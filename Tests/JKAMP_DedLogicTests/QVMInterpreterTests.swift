import Foundation
import Testing
import JKAMP
import JKAMP_Ded
import JKATestSupport
@testable import JKAMP_DedLogic

/// This suite runs the interpreter port of `vm_interpreted.cpp` over `vmtest.qvm` and checks each command of the README beside the image.
/// The run stays disabled until `VM_SetSymbolMap`, `VM_Debug`, and `VM_PrepareInterpreter` have Swift bodies.
@Suite(.serialized)
struct QVMInterpreterSuite {
    /// The syscalls of one run, each one the call number and its parameters.
    nonisolated(unsafe) static var syscalls: [[Int32]] = []

    /// The test commands of the README: the command, the three arguments, the return value, and the syscalls.
    static let commands: [(command: Int32, args: [Int32], result: Int32, syscalls: [[Int32]])] = [
        (0, [3, 4, 5], 32, []),
        (0, [-2, 10, 3], 26, []),
        (1, [9, 4, 0], 5, []),
        (1, [4, 9, 0], 5, []),
        (1, [5, 5, 0], 0, []),
        (2, [6, 7, 8], 51, []),
        (3, [5, 2, 0], 52, [[1, 5]]),
        (4, [0, 0, 0], 0, []),
        (4, [10, 0, 0], 55, []),
        (5, [6, 0, 0], 116, []),
        (6, [12, 10, 2], 4, [[2, 12, 10]]),
        (7, [3, 3, 0], 1, []),
        (7, [3, 4, 0], 0, []),
        (8, [9, 4, 0], 4, []),
        (8, [4, 9, 0], 4, []),
        (9, [511, 0, 0], -1, []),
        (9, [127, 0, 0], 127, []),
        (10, [1, 2, 3], -1, []),
    ]

    @Test("VM_Indent gives two spaces per call level up to 20")
    func indent() {
        world = EngineWorld()
        let vm = vmTable[0]

        vm.callLevel = 0
        #expect(VM_Indent(vm) == "")
        vm.callLevel = 3
        #expect(VM_Indent(vm) == String(repeating: " ", count: 6))
        vm.callLevel = 20
        #expect(VM_Indent(vm) == String(repeating: " ", count: 40))
        vm.callLevel = 25
        #expect(VM_Indent(vm) == String(repeating: " ", count: 40))
    }

    @Test(
        "vmtest.qvm returns the README value of each command",
        .disabled("VM_CallInterpreted stops at the VM_SetSymbolMap hole and the VM_Debug stub, and VM_PrepareInterpreter has no signature")
    )
    func commandsReturnTheReadmeValues() throws {
        world = EngineWorld()
        let image = try OracleData.fixtureData("qvm/vmtest.qvm")
        let vm = vmTable[0]
        Self.load(vm, image)

        // Raven's com_vmdebug at 0, so the run takes no debug arm.
        let cvar = UnsafeMutableRawPointer.allocate(byteCount: Cvar.byteCount, alignment: 16)
        defer { cvar.deallocate() }
        cvar.initializeMemory(as: UInt8.self, repeating: 0, count: Cvar.byteCount)
        com_vmdebug = Cvar(cvar)

        vm.systemCall = { parms in
            let words = UnsafeMutablePointer<Int32>(parms!)
            switch words[0] {
            case 1:
                QVMInterpreterSuite.syscalls.append([1, words[1]])
                return words[1] * 10
            case 2:
                QVMInterpreterSuite.syscalls.append([2, words[1], words[2]])
                return words[1] * 100 + words[2]
            default:
                Issue.record("syscall \(words[0]) is not in the README")
                return 0
            }
        }

        for row in Self.commands {
            Self.syscalls = []
            let args = [row.command] + row.args + [Int32](repeating: 0, count: 7)
            let result = VM_CallInterpreted(vm, args)
            #expect(result == row.result, "command \(row.command) with \(row.args)")
            #expect(Self.syscalls == row.syscalls, "command \(row.command) with \(row.args)")
            #expect(vm.programStack == vm.dataMask + 1, "command \(row.command) with \(row.args)")
        }
    }

    // MARK: - Loading

    /// This loads the image into the slot as the QVM arm of `VM_Create` and the two passes of `VM_PrepareInterpreter` do.
    /// It stands in for `VM_PrepareInterpreter` until that function has a signature, and the call replaces it then.
    static func load(_ vm: Vm, _ image: Data) {
        let instructionCount = Self.word(image, at: 4)
        let codeOffset = Self.word(image, at: 8)
        let codeLength = Self.word(image, at: 12)
        let dataOffset = Self.word(image, at: 16)
        let dataLength = Self.word(image, at: 20)
        let litLength = Self.word(image, at: 24)
        let bssLength = Self.word(image, at: 28)

        // The data image, rounded up to a power of 2
        var size = 1
        while size < dataLength + litLength + bssLength {
            size <<= 1
        }
        let data = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: 16)
        data.initializeMemory(as: UInt8.self, repeating: 0, count: size)
        for i in 0..<(dataLength + litLength) {
            data.storeBytes(of: image[image.startIndex + dataOffset + i], toByteOffset: i, as: UInt8.self)
        }
        vm.dataBase = OpaquePointer(data)
        vm.dataMask = Int32(size - 1)

        // The jump targets and the code words
        let pointers = UnsafeMutablePointer<Int32>.allocate(capacity: instructionCount)
        let code = UnsafeMutablePointer<Int32>.allocate(capacity: codeLength)
        code.initialize(repeating: 0, count: codeLength)
        let byte = { (pc: Int) in Int32(image[image.startIndex + codeOffset + pc]) }
        let wide: Set<Int32> = [
            OP_ENTER, OP_CONST, OP_LOCAL, OP_LEAVE, OP_EQ, OP_NE, OP_LTI, OP_LEI, OP_GTI, OP_GEI, OP_LTU, OP_LEU, OP_GTU, OP_GEU,
            OP_EQF, OP_NEF, OP_LTF, OP_LEF, OP_GTF, OP_GEF, OP_BLOCK_COPY,
        ]
        var pc = 0
        for instruction in 0..<instructionCount {
            pointers[instruction] = Int32(pc)
            let op = byte(pc)
            code[pc] = op
            pc += 1
            if wide.contains(op) {
                code[pc] = Int32(Self.word(image, at: codeOffset + pc))
                pc += 4
            } else if op == OP_ARG {
                code[pc] = byte(pc)
                pc += 1
            }
        }

        // The branch operands become code offsets.
        pc = 0
        for _ in 0..<instructionCount {
            let op = byte(pc)
            pc += 1
            if wide.contains(op) {
                if op != OP_ENTER && op != OP_CONST && op != OP_LOCAL && op != OP_LEAVE && op != OP_BLOCK_COPY {
                    code[pc] = pointers[Int(code[pc])]
                }
                pc += 4
            } else if op == OP_ARG {
                pc += 1
            }
        }
        vm.instructionPointers = OpaquePointer(pointers)
        vm.instructionPointersLength = Int32(instructionCount * 4)
        vm.codeBase = OpaquePointer(code)
        vm.codeLength = Int32(codeLength)

        // the stack is implicitly at the end of the image
        vm.programStack = vm.dataMask + 1
        vm.stackBottom = vm.programStack - 0x20000
    }

    /// This reads one little-endian 32-bit word at a byte offset.
    static func word(_ image: Data, at offset: Int) -> Int {
        var value: UInt32 = 0
        for byte in 0..<4 {
            value |= UInt32(image[image.startIndex + offset + byte]) << UInt32(8 * byte)
        }
        return Int(Int32(bitPattern: value))
    }
}
