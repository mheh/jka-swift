# The be_ai_char body round

This record holds the body round of `Sources/JKAMP_DedLogic/be_ai_char.swift`, on the branch `ded-bodies-be-ai-char` in the worktree `/tmp/jka-char`, from the branch `dedicated-integration-11`. The file had 16 inline holes of row P2, each a `Port-note`, a `Raven wrote:` line, and a `portMissing` call. Row X22 (`rulings.py:464`) gives the view `Cvalue` the accessors `integer`, `_float`, and `string: String?` with an interning setter (`Sources/JKAMP_Ded/Generated/Views/Cvalue.swift:66` to `:80`), so each hole has its form. The file had no skeleton header.

## The counts

| File | Holes | Filled | Left |
| --- | --- | --- | --- |
| be_ai_char | 16 | 16 | 0 |

`portMissing(` no longer stands in the file.

## The bodies

| Function | Raven | Arm | Status | Form |
| --- | --- | --- | --- | --- |
| BotDumpCharacter | `be_ai_char.cpp:88` | the switch | landed | a `switch` on `ch.c[i].type` with the three `Log_Write` calls and a `default: break` |
| BotFreeCharacterStrings | `:112` | the free | landed | the free drops under an AI line, row CM5 of the seventh ledger |
| BotDefaultCharacteristics | `:163` | float | landed | a `._float` copy |
| BotDefaultCharacteristics | `:163` | integer | landed | an `.integer` copy |
| BotDefaultCharacteristics | `:163` | string | landed | `_ = GetMemory(...)` and a `.string` store under an AI line |
| BotLoadCharacterFromFile | `:195` | float | landed | `Float(token.floatvalue)`, the form of `be_ai_chat.swift:581` |
| BotLoadCharacterFromFile | `:195` | integer | landed | `Int32(bitPattern: token.intvalue)`, the form of `be_ai_char.swift:211` |
| BotLoadCharacterFromFile | `:195` | string | landed | `_ = GetMemory(...)` and a `.string` store under an AI line |
| BotInterpolateCharacters | `:499` | float | landed | the interpolation on `._float` |
| BotInterpolateCharacters | `:499` | integer | landed | an `.integer` copy |
| BotInterpolateCharacters | `:499` | string | landed | `_ = GetMemory(...)` and a `.string` store under an AI line |
| Characteristic_Float | `:624` | integer | landed | `Float(.value.integer)`, Raven's `(float)` cast |
| Characteristic_Float | `:624` | float | landed | `.value._float` |
| Characteristic_Integer | `:679` | integer | landed | `.value.integer` |
| Characteristic_Integer | `:679` | float | landed | `Int32(.value._float)`, Raven's `(int)` cast |
| Characteristic_String | `:733` | the copy | landed | `strncpy(&buf, …, size - 1)` of `JKAShared/CString.swift:340` |

## The AI lines

The string stores take the form of `be_ai_chat.swift:1743`: the `GetMemory` call stays for the zone count, and the field takes the pooled text. The free of BotFreeCharacterStrings takes the form of `be_ai_chat.swift:1531`. Four AI lines stand in the file.

## The rows

None.

## The gate

`swift build -j 2` completes. `swift test --no-parallel -j 2` passes 156 tests in 9 runs.
