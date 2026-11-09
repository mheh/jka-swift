internal import CJKAMP_Ded
import JKAShared

/// The C type of the module's `vmMain` as the module defines it, the command and twelve words.
/// Source: oracle/codemp/game/g_main.c:515
typealias VmMainWords = @convention(c) (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> Int

extension Vm {
    /// This is Raven's `vm->entryPoint( callnum, args[0], ..., args[15] )` of `VM_Call`, a call into the `vmMain` of the loaded module.
    /// A NULL `entryPoint` traps with the field's name, as Raven's call through the pointer would crash.
    // AI: Raven called through the variadic pointer with 16 words. The call takes the fixed type of the export, 12 words that each widen to the word of the export.
    // Port-note: A variadic call into the fixed vmMain is undefined off x86, and the export reads 12 words, so the last 4 words go nowhere.
    // AI: Raven's pointer returned an `int`. The export returns a word, and the call keeps its low 32 bits, the `int` of Raven's 32-bit build.
    @discardableResult
    public func runEntryPoint(_ callNum: Int32, _ args: [Int32]) -> Int32 {
        precondition(self.raw.pointee.entryPoint != nil, "entryPoint is NULL")
        let vmMain = unsafeBitCast(self.raw.pointee.entryPoint, to: VmMainWords.self)
        let r = vmMain(
            Int(callNum),
            Int(args[0]),
            Int(args[1]),
            Int(args[2]),
            Int(args[3]),
            Int(args[4]),
            Int(args[5]),
            Int(args[6]),
            Int(args[7]),
            Int(args[8]),
            Int(args[9]),
            Int(args[10]),
            Int(args[11])
        )
        return Int32(truncatingIfNeeded: r)
    }
}
