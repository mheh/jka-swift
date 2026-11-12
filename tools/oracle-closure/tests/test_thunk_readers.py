"""The readers of a thunk: each unit whose view target holds a ThunkReaders.swift gets the readers that file declares."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path
from types import SimpleNamespace

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from skeleton import Skeleton  # noqa: E402


def generator(readers: set[str]) -> Skeleton:
    """A skeleton with the reader names of its view target alone, and no parse."""
    gen = Skeleton.__new__(Skeleton)
    gen.__dict__["readers"] = set(readers)
    return gen


def param(swift: str) -> SimpleNamespace:
    return SimpleNamespace(swift=swift)


class ThunkReaders(unittest.TestCase):
    def test_a_unit_with_the_readers_reads_a_text_and_a_vec4_word(self) -> None:
        # given the readers of the ui, text(at:) and vector4(at:)
        gen = generator({"text", "vector4"})

        # then a text, a vec4_t, and an optional vec4_t each take their reader
        self.assertEqual(gen.thunk_reader(param("String")), "text(at: {}!)")
        self.assertEqual(gen.thunk_reader(param("JKAShared.vec4_t")), "vector4(at: {}!)")
        self.assertEqual(gen.thunk_reader(param("JKAShared.vec4_t?")), "{}.map(vector4(at:))")

        # and a vec3_t keeps the marker, because the file declares no vector(at:)
        self.assertIsNone(gen.thunk_reader(param("JKAShared.vec3_t")))

    def test_a_unit_with_no_reader_file_maps_no_word(self) -> None:
        # given the game, whose view target holds no ThunkReaders.swift
        gen = generator(set())

        # then no parameter takes a reader
        self.assertIsNone(gen.thunk_reader(param("String")))
        self.assertIsNone(gen.thunk_reader(None))


if __name__ == "__main__":
    unittest.main()
