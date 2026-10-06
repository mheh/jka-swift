"""Seam C: a Table that loads from the store holds the same facts as the Table whose cold sweep wrote them.

This test parses the real tree and runs one cold sweep, so it runs only with SLOW=1 in the environment.
"""

from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(Path(__file__).resolve().parent))

from test_store import plain  # noqa: E402

# Every fact store a sweep fills, by its attribute name on the Table.
FACT_STORES = (
    "nullable", "hopped", "called", "stores_through", "store_swept", "readonly_text", "null_returns", "indexed_params",
    "indexed_fields", "handoffs", "cursors", "alias_writes", "buffer_traps", "text_traps", "reads", "file_walks", "array_handoffs",
    "null_arms",
)


@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one cold sweep of the real parse, run with SLOW=1")
class Loader(unittest.TestCase):
    def test_a_warm_table_holds_the_facts_of_the_cold_sweep(self) -> None:
        import closure as C
        from table import Table

        parse = C.Parse()
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "table.sqlite"

            # given one cold sweep into an empty store, and the local facts of a sample of functions
            cold = Table(parse, store=path)
            cold.sweep()
            self.assertEqual(cold.swept, {"base", "adoption"})
            sample = list(cold.functions)[::40] + sorted({(stem, function) for stem, function, _ in cold.cursors})[:20]
            cold_locals = {key: plain(cold.locals_of(*key)) for key in sample}

            # when a second Table sweeps the same parse
            warm = Table(parse, store=path)
            warm.sweep()

            # then it sweeps nothing and holds every fact store of the cold Table
            self.assertEqual(warm.swept, set())
            for name in FACT_STORES:
                self.assertEqual(plain(getattr(warm, name)), plain(getattr(cold, name)), name)
            self.assertEqual(list(warm.functions), list(cold.functions))
            self.assertTrue(all(warm.functions[key].spelling == key[1] for key in warm.functions))

            # and it reads the local facts of the sample from the store
            self.assertEqual({key: plain(warm.locals_of(*key)) for key in sample}, cold_locals)
            self.assertTrue(cold_locals)


if __name__ == "__main__":
    unittest.main()
