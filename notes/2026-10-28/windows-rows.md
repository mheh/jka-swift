# The two Windows rows

This record holds the two rows the Windows lane of the first CI runs raised, landed on the branch `windows-rows` off master at 40db1d6 on 2026-10-28. The rulings are the coordinator's, in the pattern of the ratified rows of `notes/2026-10-27/client-connect.md`, and the user reads them after the fact. The lane is allowed to fail, and it fails on these two alone.

## W1. `unsigned long` crosses as `CUnsignedLong`

The Windows build refused `Vehicle.swift:209`, "cannot convert return expression of type 'UInt32' to return type 'UInt'", at the view of `m_ulFlags`, Raven's `unsigned long` of `bg_vehicles.h:543`. The scalar table of `reexport.py` spelled `long` as `Int` and `unsigned long` as `UInt`, which match C's width on Darwin and Linux and miss it on Windows, where `unsigned long` is 32 bits. Swift's `CLong` and `CUnsignedLong` are C's own widths on every platform, so the two rows read those now, and `CUnsignedLong` joins the unsigned spellings. The drafter writes the bits of a `long` into an `unsigned long` as `CUnsignedLong(bitPattern: CLong(x))`, and the 44 hand sites of the vehicle files, `bg_pmove.swift`, `bg_slidemove.swift`, and `g_weapon.swift` take that form in place of `UInt(bitPattern: Int(x))`. The views, the traps, and the manifests regenerate: `m_ulFlags` is `CUnsignedLong`, and the two bot traps that take a `context` of `unsigned long` spell it so. The hand `Rng` keeps its `UInt32`, because Raven's `holdrand` is a 32-bit draw by design.

## W2. A platform conditional stays in the extracted header

The Windows build refused `q_shared.swift:25`, "module 'CJKAMP' has no member named 'MAX_OSPATH'". Raven defines the macro under `#ifdef PATH_MAX` at `q_shared.h:394`, `PATH_MAX` on one side and `256` on the other, and `extract.py` keeps the arm the parse on macOS took, so the extracted header named `PATH_MAX`, which Windows has no definition for. The form: `PLATFORM_MACROS` in `rulings.py` names `PATH_MAX`, the extract keeps Raven's whole conditional around a macro that sits under a platform macro, the `IfResolver` leaves such a conditional as text, and the merge reads a block's macro name from its first `#define` line instead of its first line. The extracted `constants.h` of `q_shared.h` carries both arms as Raven wrote them, and each platform build takes its own.

The SP umbrella headers moved under the regenerated extract and went back to their committed text, because the SP targets are outside this row and their extract state is a question of its own.

## The gate

The build has 0 errors, the 112 Swift tests pass in four runs, the 82 tool tests pass with 16 skipped, and `tools/load-test.sh` exits 0. The compile gate over every stem reports 1280 holes, 0 cascade errors, 0 defects, and 2 compile holes, the same as after X21, with the 75 game stems at 1019 holes. The snapshot check reported the drafts of the vehicle files, `ai_util`, and `q_math` with the new wrap and local spelling, the `bg_lib` manifest, the two bot traps, and the `Vehicle` view, and the standing snapshot is refreshed after that read. The Windows lane of the next master run tells whether the two rows hold on Windows.
