# The build of the 13 helpers of the frame-path walk

This record lists the helpers that the section "Helpers" of `frame-path-walk.md` orders. No build and no test ran, because the generator builder gates the phase.

## The helpers

1. `Sources/JKAMP_BG/bg_lib.swift`: `public func qsort<T>(_ a: inout [T], _ cmp: (T, T) -> Int32)` is now public, with the new `public func qsort<T>(_ a: inout [T], _ n: Int32, _ cmp: (T, T) -> Int32)` and `public func qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)` (A1, D6).
2. `Sources/JKAShared/CharBuf.swift`: `public mutating func zero<I: BinaryInteger>(count n: I)` (B5).
3. `Sources/JKAShared/Format.swift`: `extension Bool: FormatArg`, with `formatValue` `.integer(self ? 1 : 0)` (D1).
4. `Sources/JKAShared/Scan.swift`: `public func sscanf(_ s: CharBuf, _ fmt: String, _ ints: inout [Int32], _ texts: inout [String]) -> Int32` (D2).
5. `Sources/JKAShared/Bool+Int32.swift`: `extension Bool { public init(_ value: Int32) }`, `value != 0` (D3, I1).
6. `Sources/JKAMP_GameLogic/g_utils.swift`: `func G_RadiusList(_ origin: JKAShared.vec3_t, _ radius: Float, _ ignore: Entity, _ takeDamage: Bool, _ ent_list: Slots<Entity?>) -> Int32`, beside the function (D7).
7. `Sources/JKAMP/EntityState+Bones.swift`: `public var boneIndexSlots: Slots<Int32>` and `public var boneAnglesSlots: Slots<JKAShared.vec3_t>` on `EntityState`, as the conflict 4 verdict gives them (F2, J5, Q2).
8. `Sources/JKAMP/Vehicle+Orientation.swift`: `public func pointOrientation(at ps: PlayerState)` on `Vehicle` (J3).
9. `Sources/JKAShared/NativeBytes.swift`: `extension UInt32 { public init(nativeBytes bytes: [UInt8]) }` and `public func nativeBytes(of value: UInt32) -> [UInt8]` (L1).
10. `Sources/JKAShared/q_shared.c.swift`: `public func Com_sprintf(_ dest: inout CharBuf, _ size: Int32, _ fmt: String, _ args: any FormatArg..., at offset: some BinaryInteger)` (L2).
11. `Sources/JKAShared/Promotion.swift`: `@_disfavoredOverload public func += (lhs: inout Int32, rhs: Bool)`, under a new `MARK: - Truth values` (L3).
12. `Sources/JKAMP_GameLogic/ai_main.swift`: `func RemoveColorEscapeSequences(_ text: inout JKAShared.CharBuf, at offset: some BinaryInteger)`, beside the function (O5).
13. `Sources/JKAShared/q_shared.c.swift`: `public func Q_stricmp(_ s1: String?, _ s2: String?) -> Int32`, -1 for a nil argument (R9).

## Unruled

- O5: `RemoveColorEscapeSequences` is internal to `JKAMP_GameLogic` in `ai_main.swift`, so its `at:` overload can live only in that target. The brief allowed only the D7 file there. We put the overload beside the function in `ai_main.swift`, as the D7 proof puts its forward beside `G_RadiusList`.
- L2: Swift cannot pass a variadic list on. The `at:` overload of `Com_sprintf` formats the text once with `format(fmt, args)` and passes it to the base form under `"%s"`, which gives the same bytes and the same overflow checks. One comment line in the body names this.
- A1: the `Slots<Int32>` overload of `qsort` takes the table by value, because `Slots` has a `nonmutating` setter. The call reads `qsort(level.sortedClients, level.numConnectedClients, SortRanks)`, with no `&`. It sorts a copy and writes back the first `n` slots.
- D2: the list `sscanf` returns the count it read, as the proof says. C returns -1 (`EOF`) when the input ends before the first conversion, and this overload returns 0 there. Raven's one caller does not read the result.
- D2: the overload checks with `precondition` that every format token is `%i` or `%s`, and that the target counts match the conversion counts. A `%s` reads the run of bytes up to the next whitespace, as UTF-8 text.
- D3 and I1: the initializer is in a new file `Bool+Int32.swift`, on the model of `Int32+Ascii.swift`, because no existing `JKAShared` file holds a `Bool` cast.
- L1: the pack and unpack helpers are in a new file `NativeBytes.swift`. The unpack helper traps on an array that does not hold four bytes.
- J3: the method is in a new file `Vehicle+Orientation.swift`, an extension on `Vehicle`, and it takes the `PlayerState` view.
- B5: `zero(count:)` takes any `BinaryInteger`, so the call passes `MAX_STRING_CHARS` with no cast, and a count past the end traps.
- R9: the `Source:` line of the `Q_stricmp` overload names `q_shared.c:900`, the line of Raven's function, as the existing overloads do. The proof cites the body line 901.
