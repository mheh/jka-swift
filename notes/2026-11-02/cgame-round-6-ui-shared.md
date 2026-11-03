# The cgame transcription rounds, round 6, ui_shared

The record of the sixth cgame transcription round on 2026-11-02, one stem, the borrowed `ui_shared`, on the branch `cgame-round-6-ui-shared` off master. The adopted file is `Sources/JKAMP_CGameLogic/ui_shared.swift`, and the C file is `oracle/codemp/ui/ui_shared.c`.

## The first adoption

The stub was adopted at 91a9b08. The draft gate reported 629 holes, 0 defects, and 134 compile holes over 3 passes. The file took 619 Port-notes by `grep -c` and 40 `TODO: Port signature` markers. The docket holds tool rows R46 to R66, signature rows S1 to S4, and hand groups H1 to H18.

## Rows R46 to R66 and S1 to S4

Ruled as proposed. Each row is one commit, and a signature row is its own commit after the row that needed it.

- R46. A view per typeData record: ListBoxDef, MultiDef, TextScrollDef, EditFieldDef, and ModelDef. Commit 2b93455.
- R47. A FIELDS row gives `itemDef_t.typeData` the raw kind, so `ListBoxDef(item.typeData!)` reads through `init(_ raw:)`. Commit 0e50f78.
- R48. `itemDef_t.parent` is the optional view of its menu. Commit 12f1e7b.
- R50. `scrollInfo` is a zeroed record, and the five Scroll functions take its view. Commit a7ff1af.
- R51. `captureFunc` is a stored Swift function on the variables struct. Commit c681e00.
- R52. `g_bindings` and `itemFlags` are C storage tables. Commit b3d2ba1.
- R53. The keyword hash tables and `commandList` are hand tables on CGameWorld. Commit 1ef4245, with the S3 signatures at 96fdf20.
- R54. `strHandle` is a table of stringDef_t views. Commit 4ab56b4.
- R55. The G2 pointer tracker is a view list. Commit e0a6edd.
- R49. The captured menu of the cgame is a menuDef_t. Commit 62b533a, with the S4 signatures at c30d8c2.
- S1. UI_Alloc returns raw. Commit ef6c752, with the signature at 7037087.
- S2. A `char **` cursor is a TextCursor. Commit 7f18fe7, with the signatures at a0d5571.
- R56. A variadic format is a String, and its va_list drops. Commit 0eb62b9.
- R57. The parse outputs of PC_String_Parse and PC_Script_Parse are `inout String?`. Commit 1898739, with the signatures at a7f6514.
- R58. The run methods take Raven's buffers and his NULL color. Commit 394ec5c.
- R59. Four more run method shapes, with the feederItemText return. Commit ed9e570.
- R60. A const text local that Raven points at a field or a buffer. Commit a0353e4.
- R61. A byte read of a `char name[N]` field through `*`. Commit 910f623.
- R62. A truth test of a `char *` field through `*`. Commit 1029aec.
- R63. A macro that a dependency exports with the same body is exported once. Commit d7abedc.
- R64. A `Slots<vec3_t>` forward takes no `&`. Commit 0fd7981.
- R65. A post-increment inside a subscript of a store. Commit 8254ac1.
- R66. The twokeys out array of Controls_GetKeyAssignment. Commit c5557e4, with the signature at 312df3a.

Three more commits support the rows. 157ef2c makes the shared buffer views of cg_main read through the raw cast. 49f1634 makes trap_PC_SourceFileAndLine fill its filename buffer. 3d17e7a fixes the single build and the snapshot.

The gate after R47 reported 385 holes and 151 compile holes over 5 passes.

## The readoption

The generator sequence ran at 8519087, and the stub was readopted at d92a438. The draft gate reported `ui_shared: 316 of 316 hand functions replaced, 0 kept, 144 holes, 0 cascade errors, 0 defects, 38 compile holes over 3 passes`. The file took 144 Port-notes and 152 `portMissing` lines, so 144 is the count the hole round starts from.

The snapshot against the cache of master moved 14 game bodies, all toward the hand form.

## The hole round

Commit 51fca1e closed 139 of the 144 notes and removed all 152 `portMissing` lines. Three sub-agents each took a disjoint set of functions, and the coordinator reviewed every edit.

- UI_Alloc takes the G_Alloc form, one zeroed block per call with Raven's count over `allocPoint`, and the rule 24 line of the allocation.
- hashForString takes the H1 form, with `JKAShared.tolower` because Darwin also declares `tolower`.
- String_Alloc returns `String(strPool[ph...])`, `staticNULL` is `""`, and `*p == 0` is `p.isEmpty`. The pool copy now uses the `at:` form of `strcpy`, because the earlier call passed a pointer to a one-byte temporary.
- `styles`, `alignment`, and `types` are `[String?]` with Raven's NULL row. `languageString` holds Raven's text. `commandList`, `scriptCommandCount`, `g_bindCount`, and the four keyword tables are forwards over CGameWorld and the C storage.
- KeywordHash_Add and KeywordHash_Find link and walk the rows by index. Item_Parse and Menu_Parse walk `key` as an `Int32?` row index.
- UI_InsertG2Pointer walks with a `prev` local in place of `**nextFree`.
- `inHandleKey` is a CGameWorld property with a forward under Raven's name.
- `memmove` joins `memset` in `CString.swift`, and the three moves of Item_TextField_HandleKey call it.
- The stepped text locals are TextCursor walks. The other text locals are String or `String?`.
- The `vec4_t *out` locals are `Slots<Float>?` over the color fields. The color and fullScreen parse outputs take a copy and a store-back. The color reads of drawText take a `vec4_t` copy, because the engine only reads the color.

The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The notes left

Five Port-note lines stay, each a rule 19 line with no `portMissing` marker:

- UI_Alloc. Raven returns NULL when the pool is full, and his callers write through it. The function traps before that write.
- Item_SetFocus. Raven keeps the address of the chosen sound field, and nothing writes it before his one read, so the local holds the value.
- UI_InsertG2Pointer. Raven stores through `*nextFree`, the list head or the `next` of `prev`.
- ItemParse_cvarStrList and ItemParse_cvarFloatList. Raven tests the pointer as a signed int, and the port tests for the NULL of String_Alloc.

## The rows left open

- R60 arm 2. The cursor sweep of `table.py` takes no text or field store, so the stepped text locals were hand work.
- KeywordHash_Add and KeywordHash_Find have hand signatures, and every readoption must take them again.
- The Display_CaptureItem caller in cg_newDraw stores into `cgs.capturedItem`, and that caller is not ported yet.
