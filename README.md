# jka-swift

A Swift port of Star Wars Jedi Knight: Jedi Academy, modeled on [jka-rust](../jka-rust). [`oracle/`](oracle) holds Raven's released source as a read-only submodule, and every port is verified against it. Files mirror Raven's `.c` files, functions keep Raven's names, and Raven's comments stay in place. The rules a port follows are in [`docs/porting-rules.md`](docs/porting-rules.md), and the generators that read the oracle are described in [`tools/oracle-closure/README.md`](tools/oracle-closure/README.md).
