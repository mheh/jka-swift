# Ported types, the proposal for vet task 3

Written 2026-09-09. Four rows. Rows 2 through 4 describe mechanisms with no code yet, and each shows the file it would produce. Nothing is implemented until its row is ratified.

## Row 1, the header shape

The generated headers as they sit under `Sources/` after commit `9200e40`. One Raven declaration per file, the oracle path mirrored under the target's include directory, Raven's text and comments verbatim, a `Source:` line per tree, includes rewritten to the file that owns each dependency, and every record asserted in the target's `layout_asserts.h` with the oracle's `sizeof` and `offsetof`. A pointer to a tagged struct is satisfied by the target's forward header, so no include cycle exists. A C++ declaration, and a C declaration that holds one by value, sits under the target's `cxx/` directory for reference and is not compiled.

A seam type, `Sources/CJKAMP/include/codemp/game/q_shared/playerState_t.h`, 280 lines:

```c
#include "CJKAMP_forward.h"
#include "codemp/game/q_shared/constants.h"
#include "codemp/game/q_shared/enum_FP_FIRST.h"
#include "codemp/game/q_shared/forcedata_t.h"
#include "codemp/game/q_shared/qboolean.h"
#include "shared/game/q_shared/constants.h"
#include "shared/game/q_shared/vec3_t.h"

// Source: oracle/codemp/game/q_shared.h:2169
// playerState_t is a full superset of entityState_t as it is used by players,
// so if a playerState_t is transmitted, the entityState_t can be fully derived
// from it.
typedef struct playerState_s {
	int			commandTime;	// cmd->serverTime of last executed command
```

and its asserts in `Sources/CJKAMP/layout_asserts.h`, 169 lines for this type:

```c
_Static_assert(sizeof(playerState_t) == 1552, "playerState_t");
_Static_assert(offsetof(playerState_t, commandTime) == 0, "playerState_t.commandTime");
```

A shared type, `Sources/CJKAShared/include/shared/game/q_shared/vec3_t.h`, carries one `Source:` line per tree:

```c
// Source: oracle/codemp/game/q_shared.h:532
// Source: oracle/code/game/q_shared.h:316
typedef vec_t vec3_t[3];
```

A constants file, `Sources/CJKAMP/include/codemp/game/bg_public/constants.h`, one macro per `Source:` line, the union of what every MP module saw:

```c
// Source: oracle/codemp/game/bg_public.h:22
#define	STEPSIZE		18

// Source: oracle/codemp/game/bg_public.h:26
#define ARMOR_PROTECTION		0.50 // Shields only stop 50% of armor-piercing dmg
```

The delta. `gentity_t`, `gclient_t`, and `level_locals_t` sit in `CJKAMP`, not `CJKAMP_Game`, because Raven's `bg_*.c` include `g_local.h` under `QAGAME`, so the `mp-bg` parse sees them and the merge counts two modules agreeing. The proposed rule: `mp-bg` is not a module of its own but the game module's parse of the `bg_*.c` files, so its headers count as `mp-game` headers for placement, and a type is tree-level only when `mp-game`, `mp-cgame`, and `mp-ui` agree. The bg types every module includes stay in `CJKAMP`, and the three game-private types move to `CJKAMP_Game` with their asserts.

## Row 2, adoption

Rule 12 says a private header is adopted the day the port first changes a field, and its asserts are deleted by a manifest entry. The mechanism: a file `adopted.json` at the target root, beside the translation unit, which the merge reads before it writes.

```json
{
  "files": {
    "codemp/game/g_local/gentity_t.h": "2026-10-02, the think fields became an enum, see JKAMP_Game/Entity.swift"
  },
  "asserts": {
    "gentity_t": "same entry"
  }
}
```

The merge keeps a file listed under `files` as it is on disk and does not rewrite it, drops every assert for a type listed under `asserts`, and prints both counts in its report. A seam type, one the engine dereferences, is never adoptable: the merge holds the list from `g_public.h` and `cg_public.h`, `sharedEntity_t`, `playerState_t`, `entityState_t`, `usercmd_t`, `trace_t`, `gameState_t`, and their members, and exits with a message if `adopted.json` names one. The generated header keeps its `Do not edit until adopted` note, and an adopted header's note changes to the `adopted.json` entry's text.

## Row 3, the six-triple asserts

Packet row 6 fixed the triples: `i686-pc-windows-msvc`, `i686-pc-linux-gnu`, `x86_64-pc-windows-msvc`, `x86_64-pc-linux-gnu`, `x86_64-apple-macosx`, `arm64-apple-macosx`. The mechanism: `extract.py` parses each module once per triple with `-target`, and writes the asserts of each triple under a guard on Clang's predefined macros, so one `layout_asserts.h` holds six blocks and the host's block is the one the package build compiles.

```c
#if defined(_WIN32) && defined(__i386__)
_Static_assert(sizeof(gentity_t) == 1312, "gentity_t");
#elif defined(__linux__) && defined(__i386__)
_Static_assert(sizeof(gentity_t) == 1312, "gentity_t");
#elif defined(_WIN32) && defined(__x86_64__)
_Static_assert(sizeof(gentity_t) == 1832, "gentity_t");
```

`check.sh` runs Clang with `-target` for each triple against every target's translation unit, and the assert headers include no system header, so no SDK is needed for a foreign triple. A seam type must have one size on all six triples, and the merge exits with a message when one does not. The numbers above are illustrative and the run supplies them.

## Row 4, the re-export shape

Rule 8 says a logic target never imports a C module and the view target re-exports each constant and enum as a generated public Swift declaration. The generator reads the merged constants files and enum headers and writes one Swift file per Raven header under the view target, `Sources/JKAMP/Generated/bg_public.swift` for `bg_public.h`. The C declaration stays the single source of truth, so each Swift value reads the imported C value.

```swift
internal import CJKAMP

/// Source: oracle/codemp/game/bg_public.h:22
public let STEPSIZE = CJKAMP.STEPSIZE

/// Source: oracle/codemp/game/bg_weapons.h:8
public let WP_NONE = CJKAMP.WP_NONE

/// Source: oracle/codemp/game/bg_weapons.h:40
public typealias weapon_t = Int32

/// Source: oracle/codemp/game/bg_public.h:1330
public struct team_t: RawRepresentable, Hashable, Sendable {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }
    public static let TEAM_FREE = team_t(rawValue: CJKAMP.TEAM_FREE.rawValue)
}
```

A macro Clang cannot import, such as one that names another macro in an expression, becomes a literal with a two-line comment. An anonymous enum's enumerators become plain constants, because that is what Clang imports. A named enum becomes a struct with static members, because Raven stores out-of-range values in these fields and a Swift enum would trap. A typedef of a scalar becomes a typealias of the Swift scalar.

## Ledger

- Row 1, the header shape: ratified as proposed, with the `mp-bg` placement rule, 2026-09-09.
- Row 2, adoption: replaced. No adoption. Every copied header is regenerated on every merge and never edited. A port that changes a private type's shape does so in Swift, and the C field goes unused. The seam list stays as the input to row 3's one-size check. 2026-09-09.
- Row 3, the six-triple asserts: ratified as proposed, 2026-09-09.
- Row 4, the re-export shape: ratified as proposed, the C value as the single source of truth, a literal only where Clang cannot import, 2026-09-09.
