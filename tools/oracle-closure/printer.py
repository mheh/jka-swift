#!/usr/bin/env python3
"""printer.py: the text of the drafts from the line rows of the lowering, and nothing else.

The printer reads line rows alone and never reorders one.
It indents a body row by its depth, four spaces a depth, and joins a trailing row onto the line before it with one space.
It drops the module qualifiers of a body row, so `JKAMP.BgEntity` prints as `BgEntity`, and a header row keeps the stub's own bytes.
The functions of a stem print with one blank line after each, and the footer counts the holes, one for each line row with the role note.
"""

from __future__ import annotations

import re

from draft_classification import INDENT

# A module qualifier appears only to break a genuine ambiguity, the short-name rule of porting-rules.md, and no body line has one.
QUALIFIER = re.compile(r"\b(JKAMP|JKAShared)\.(?=[A-Za-z_])")


def short_named(line: str) -> str:
    """A body line with every module qualifier dropped, so `var ent: BgEntity? = nil` reads as Raven wrote it."""
    return QUALIFIER.sub("", line)


def function_lines(rows: list[tuple]) -> list[str]:
    """The printed lines of one function from its line rows, each row as its seq, its statement seq, its role, its depth, and its text."""
    out: list[str] = []
    for _, _, role, depth, text in rows:
        if role == "header":
            out.append(text)
        elif role == "trailing":
            out[-1] += f" {short_named(text)}"
        else:
            out.append(INDENT * depth + short_named(text))
    return out


def stem_text(functions: list[list[tuple]]) -> str:
    """The text of the functions from their line rows: each function and a blank line after it, then the footer of the hole count."""
    holes = sum(1 for rows in functions for row in rows if row[2] == "note")
    return "".join("\n".join(function_lines(rows)) + "\n\n" for rows in functions) + f"// {holes} holes\n"
