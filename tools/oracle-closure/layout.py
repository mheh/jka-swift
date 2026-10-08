"""layout.py: the layout names that the lowering writes and the printer prints, the indentation step, the Port-note line, and the compile note.
The lowering modules and printer.py read them from here, so the printer imports no drafter module."""

from __future__ import annotations

import re

INDENT = "    "

# The reason of a hole at a statement whose draft the compile gate rejected, with the compiler's message of the first error on it.
COMPILE_NOTE = "The draft of this statement did not compile, and the compiler wrote \"{}\"."


def port_note(reason: str) -> str:
    """The Port-note line of a hole, with each newline of the reason and the indentation after it as one space.
    A reason can quote Raven's text across a line, for example an operator span over `#ifdef _JK2MP`, and a second line would fall outside the comment."""
    return "// Port-note: " + re.sub(r"\s*\n\s*", " ", reason.strip())
