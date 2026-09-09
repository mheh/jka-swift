#!/usr/bin/env python3
"""table.py: the C-to-Swift table of abi-stubs.md row 2, shared by traps.py and skeleton.py.

A parameter or a return maps by its C shape to the Swift type in the signature and the way it crosses the seam.
The table composes the view generator for the scalar, enum, and view names, so one spelling serves every generator.
"""

from __future__ import annotations

import re
from pathlib import Path

import clang.cindex as ci
from clang.cindex import TypeKind

from reexport import SCALARS
from views import Generator

TARGET = "CJKAMP_Game"
BUILTINS = set(SCALARS.values()) | {"Bool", "Float", "Int32"}
INT_KINDS = {TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG, TypeKind.SHORT, TypeKind.USHORT}
# An int beside a char * is its size only when Raven named it so. trap_BotSetChatName's `client` is not a size.
SIZE_NAME = re.compile(r"size|len|max", re.I)
# A Raven parameter name that is a Swift keyword is written in backticks.
KEYWORDS = {"extension", "in", "func", "class", "struct", "enum", "protocol", "default", "operator", "repeat", "where",
            "import", "self", "init", "var", "let", "return", "case", "switch", "if", "else", "for", "while", "do", "is", "as",
            "true", "false", "nil", "super", "throws", "try", "catch", "inout", "static", "public", "private", "internal"}


def swift_name(name: str) -> str:
    return f"`{name}`" if name in KEYWORDS else name


class Param:
    """One parameter as the table maps it. `kind` picks the emission, `swift` is the type in the signature."""

    def __init__(self, name: str, swift: str | None, kind: str, size: str | None = None) -> None:
        self.name = swift_name(name)
        self.swift = swift
        self.kind = kind
        self.size = size

    def word(self) -> str:
        if self.kind == "enum":
            return f"{self.name}.rawValue"
        if self.kind == "out_string":
            return f"{self.name.strip('`')}Pointer.baseAddress!"
        return self.name


class SourceFile:
    """One oracle .c file, read once, for the text a cursor's extent names and Raven's comment above a function."""

    def __init__(self, path) -> None:
        self.lines = path.read_text().splitlines()


    def slice(self, extent: ci.SourceRange) -> str:
        start, end = extent.start, extent.end
        if start.line == end.line:
            return self.lines[start.line - 1][start.column - 1:end.column - 1]
        parts = [self.lines[start.line - 1][start.column - 1:]]
        parts += self.lines[start.line:end.line - 1]
        parts.append(self.lines[end.line - 1][:end.column - 1])
        return "\n".join(parts)

    def comment_above(self, cur: ci.Cursor) -> list[str]:
        """Raven's comment lines directly above the function, verbatim, a block as /** */ and line comments as they are."""
        i = cur.extent.start.line - 2
        out: list[str] = []
        while i >= 0:
            line = self.lines[i].rstrip()
            stripped = line.strip()
            if not stripped:
                break
            if stripped.startswith("//"):
                out.insert(0, line)
                i -= 1
                continue
            if stripped.endswith("*/"):
                block = [line]
                while "/*" not in self.lines[i]:
                    i -= 1
                    block.insert(0, self.lines[i].rstrip())
                block[0] = block[0].replace("/*", "/**", 1)
                out = block + out
                i -= 1
                continue
            break
        return out

    def c_signature(self, cur: ci.Cursor) -> str:
        text = self.slice(cur.extent)
        return " ".join(text[:text.index("{")].split())


class Table:
    def __init__(self) -> None:
        self.views = Generator(None)


    def param(self, cur: ci.Cursor, following: ci.Cursor | None, traps: bool = True) -> Param | None:
        """The table row of one parameter. A `char *` out-buffer is a returned String only in a trap, where the engine fills it."""
        name = cur.spelling
        t = cur.type
        canonical = t.get_canonical()
        # A vec3_t parameter is the array type itself, and Clang keeps the typedef name on the parameter.
        if t.spelling.split()[-1] == "vec3_t":
            return Param(name, "JKAShared.vec3_t", "vec3_const" if "const" in t.spelling else "vec3_mut")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            inner = pointee.get_canonical()
            if inner.kind == TypeKind.FUNCTIONPROTO or "vec3_t" in t.spelling:
                return None
            if inner.kind == TypeKind.CHAR_S:
                if pointee.is_const_qualified():
                    return Param(name, "String", "cstring")
                if traps and following is not None and following.type.get_canonical().kind in INT_KINDS and SIZE_NAME.search(following.spelling):
                    return Param(name, None, "out_string", size=following.spelling)
                return None
            record = self.views.record_name(pointee)
            if record and record in self.views.views:
                return Param(name, self.views.qualified_view(record, TARGET), "view")
            if inner.kind == TypeKind.VOID:
                return Param(name, "OpaquePointer?", "bare")
            return None
        if canonical.kind in (TypeKind.RECORD, TypeKind.CONSTANTARRAY):
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if canonical.kind == TypeKind.ENUM and swift != "Bool":
            return Param(name, swift, "enum")
        return Param(name, swift, "bare")

    def known(self, swift: str) -> bool:
        """A Swift spelling the logic target can see: a builtin, or a name a view target re-exports. An enum a .c file defines is neither."""
        return swift in BUILTINS or swift.split(".")[-1] in self.views.declared

    def result(self, cur: ci.Cursor) -> tuple[str | None, str] | None:
        """The Swift return type and the expression that maps the word into it, or None for an unmappable return."""
        t = cur.result_type
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.VOID:
            return (None, "")
        if canonical.kind == TypeKind.FLOAT:
            return ("Float", "Float(bitPattern: UInt32(truncatingIfNeeded: word))")
        if canonical.kind == TypeKind.POINTER:
            # Raven returns NULL for no entity, so a returned view is optional.
            record = self.views.record_name(canonical.get_pointee())
            if record and record in self.views.views:
                view = self.views.qualified_view(record, TARGET)
                return (f"{view}?", f"OpaquePointer(bitPattern: word).map {{ {view}(handle: $0) }}")
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if swift == "Bool":
            return ("Bool", "word != 0")
        if canonical.kind == TypeKind.ENUM:
            return (swift, f"{swift}(rawValue: Int32(truncatingIfNeeded: word))")
        return (swift, f"{swift}(truncatingIfNeeded: word)")
