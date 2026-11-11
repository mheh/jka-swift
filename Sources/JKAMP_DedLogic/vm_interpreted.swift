import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:9
/// Raven's data table, a hand property of `EngineWorld`.
var opnames: [String?] {
    get { world.opnames }
    set { world.opnames = newValue }
}

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:291
private let MAX_STACK = 256 as Int32

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:292
private let STACK_MASK = (MAX_STACK - 1)

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:294
// Raven wrote: #define DEBUGSTR va ( "%s%i" , VM_Indent ( vm ) , opStack - stack )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:362
// Raven wrote: #define r2 codeImage [ programCounter ]
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.


/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:113
func VM_Indent(_ vm: Vm) -> String {
    // AI: Raven keeps the text in a static pointer. No statement writes the text and the returned String is a copy, so the port holds it in a local.
    let string: CharBuf = "                                        "
    if vm.callLevel > 20 {
        return String(string)
    }
    // Port-note: Raven reads past the end of the text when callLevel is below 0, and the suffix subscript traps there.
    return String(string[(2 * (20 - vm.callLevel))...])
}

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:121
func VM_StackTrace(_ vm: Vm, _ programCounter: Int32, _ programStack: Int32) {
    var count: Int32
    // Raven assigns his own `programCounter` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var programCounter = programCounter
    // Raven assigns his own `programStack` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var programStack = programStack
    // Raven reads the frame words through `vm->dataBase`, and the raw pointer over the field is that read, under rule 11.
    let dataBase: UnsafeMutableRawPointer = vm.dataBase!.base

    count = 0
    repeat {
        Com_Printf("%s\n", VM_ValueToSymbol(vm, programCounter))
        programStack = dataBase[int: programStack + 4]
        programCounter = dataBase[int: programStack]
        if programCounter == -1 {
            break
        }
        count += 1
    } while count < 32

}

/**
```
====================
VM_PrepareInterpreter
====================
```
*/
/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:139
func VM_PrepareInterpreter(_ vm: Vm, _ header: VmHeader) {
    var op: Int32
    var pc: Int32
    var code: UnsafeMutableRawPointer
    var instruction: Int32
    var codeBase: Slots<Int32>

    // Raven stores the allocation in `vm->codeBase`, and the opaque pointer over the raw allocation is that store, under rule 11.
    vm.codeBase = OpaquePointer(Hunk_Alloc(vm.codeLength * 4, h_high))			// we're now int aligned
//	memcpy( vm->codeBase, (byte *)header + header->codeOffset, vm->codeLength );
    // Raven indexes `vm->instructionPointers` in place, and the Slots over the field's table is that index, under rule 11.
    let instructionPointers = Slots<Int32>(scalars: vm.instructionPointers!.base, count: Int(vm.instructionPointersLength >> 2))

    // we don't need to translate the instructions, but we still need
    // to find each instructions starting point for jumps
    pc = 0
    instruction = 0
    // Raven walks the header's bytes through `code`, and the raw pointer over the view's slot is that walk, under rule 11.
    code = UnsafeMutableRawPointer(header.handle) + header.codeOffset
    // Raven indexes the code through `(int *)vm->codeBase`, and the Slots over the field's table is that index, under rule 11.
    codeBase = Slots<Int32>(scalars: UnsafeMutableRawPointer(vm.codeBase!), count: Int(vm.codeLength))

    while instruction < header.instructionCount {
        instructionPointers[instruction] = pc
        instruction += 1

        op = Int32(code[byte: pc] as byte)
        codeBase[pc] = op
        if pc > header.codeLength {
            Com_Error(ERR_FATAL, "VM_PrepareInterpreter: pc > header->codeLength")
        }

        pc += 1

        // these are the only opcodes that aren't a single byte
        switch op {
        case OP_ENTER, OP_CONST, OP_LOCAL, OP_LEAVE, OP_EQ, OP_NE, OP_LTI, OP_LEI, OP_GTI, OP_GEI, OP_LTU, OP_LEU, OP_GTU, OP_GEU, OP_EQF, OP_NEF, OP_LTF, OP_LEF, OP_GTF, OP_GEF, OP_BLOCK_COPY:
            // Raven's `loadWord` on x86 is `*((int *)addr)`, the int at the byte offset.
            codeBase[pc + 0] = code[int: pc]
            pc += 4

        case OP_ARG:
            codeBase[pc + 0] = Int32(code[byte: pc] as byte)
            pc += 1

        default:
            break
        }

    }
    pc = 0
    instruction = 0
    code = UnsafeMutableRawPointer(header.handle) + header.codeOffset
    codeBase = Slots<Int32>(scalars: UnsafeMutableRawPointer(vm.codeBase!), count: Int(vm.codeLength))

    while instruction < header.instructionCount {
        op = Int32(code[byte: pc] as byte)
        instruction += 1
        pc += 1
        switch op {
        case OP_ENTER, OP_CONST, OP_LOCAL, OP_LEAVE, OP_EQ, OP_NE, OP_LTI, OP_LEI, OP_GTI, OP_GEI, OP_LTU, OP_LEU, OP_GTU, OP_GEU, OP_EQF, OP_NEF, OP_LTF, OP_LEF, OP_GTF, OP_GEF, OP_BLOCK_COPY:
            switch op {
            case OP_EQ, OP_NE, OP_LTI, OP_LEI, OP_GTI, OP_GEI, OP_LTU, OP_LEU, OP_GTU, OP_GEU, OP_EQF, OP_NEF, OP_LTF, OP_LEF, OP_GTF, OP_GEF:
                codeBase[pc] = instructionPointers[codeBase[pc]]

            default:
                break
            }
            pc += 4

        case OP_ARG:
            pc += 1

        default:
            break
        }

    }
}

/// Source: oracle/codemp/qcommon/vm_interpreted.cpp:296
func VM_CallInterpreted(_ vm: Vm, _ args: [Int32]?) -> Int32 {
    // Port-note: Raven writes past the end of `stack` when the opStack overflows, and the Swift array traps there.
    var stack = [Int32](repeating: 0, count: Int(MAX_STACK))
    var opStack: Int32
    var programCounter: Int32
    var programStack: Int32
    let stackOnEntry: Int32
    let image: UnsafeMutableRawPointer
    let codeImage: Slots<Int32>
    var v1: Int32
    let dataMask: Int32
    var profileSymbol: VmSymbol? = nil

    // interpret the code
    vm.currentlyInterpreting = true
    VM_SetSymbolMap(vm)

    // we might be called recursively, so this might not be the very top
    stackOnEntry = vm.programStack
    programStack = stackOnEntry

    if com_vmdebug!.integer != 0 {
        profileSymbol = VM_ValueToFunctionSymbol(vm, 0)
    }
    // uncomment this for debugging breakpoints
    vm.breakFunction = 0
    // set up the stack frame 

    // Raven reads the data image through `vm->dataBase` and the code through `vm->codeBase`, and the raw pointer over each field is that read, under rule 11.
    image = vm.dataBase!.base
    codeImage = Slots<Int32>(scalars: UnsafeMutableRawPointer(vm.codeBase!), count: Int(vm.codeLength))
    // Raven indexes `vm->instructionPointers` in place, and the Slots over the field's table is that index, under rule 11.
    let instructionPointers = Slots<Int32>(scalars: vm.instructionPointers!.base, count: Int(vm.instructionPointersLength >> 2))
    dataMask = vm.dataMask

    // leave a free spot at start of stack so
    // that as long as opStack is valid, opStack-1 will
    // not corrupt anything
    opStack = 0
    programCounter = 0

    programStack -= 48

    image[int: programStack + 44] = args![9]
    image[int: programStack + 40] = args![8]
    image[int: programStack + 36] = args![7]
    image[int: programStack + 32] = args![6]
    image[int: programStack + 28] = args![5]
    image[int: programStack + 24] = args![4]
    image[int: programStack + 20] = args![3]
    image[int: programStack + 16] = args![2]
    image[int: programStack + 12] = args![1]
    image[int: programStack + 8] = args![0]
    image[int: programStack + 4] = 0	// return stack
    image[int: programStack] = -1	// will terminate the loop on return

    vm.callLevel = 0

    VM_Debug(0)

//	vm_debugLevel=2;
    // main interpreter loop, will exit when a LEAVE instruction
    // grabs the -1 program counter

    // Port-note: Raven's label `nextInstruction` is the outer loop and `nextInstruction2` is the inner loop, and each goto is a labeled continue.
    // Port-note: Raven's `goto done` is the break out of the outer loop.
    nextInstruction: while true {
        var opcode: Int32
        var r0: Int32
        var r1: Int32
//		unsigned int	r2;

        // Port-note: Raven's `stack` is not initialized, so the first read of `r0` is indeterminate, and the port reads 0 from the filled array.
        // Raven reads `r1` from the word before `stack` when opStack is at the free spot, memory outside the array, and the port reads 0 there.
        r0 = stack[opStack]
        r1 = opStack > 0 ? stack[opStack - 1] : 0
        nextInstruction2: while true {
            opcode = codeImage[programCounter]
            programCounter += 1
            if com_vmdebug!.integer > 1 {
                if UInt32(bitPattern: programCounter) > vm.codeLength {
                    Com_Error(ERR_DROP, "VM pc out of range")
                }

                if opStack < 0 {
                    Com_Error(ERR_DROP, "VM opStack underflow")
                }
                if opStack >= MAX_STACK {
                    Com_Error(ERR_DROP, "VM opStack overflow")
                }

                if programStack <= vm.stackBottom {
                    Com_Error(ERR_DROP, "VM stack overflow")
                }

                if (programStack & 3) != 0 {
                    Com_Error(ERR_DROP, "VM program stack misaligned")
                }

                if vm_debugLevel > 1 {
                    // Raven's macro `DEBUGSTR`.
                    Com_Printf("%s %s\n", va("%s%i", VM_Indent(vm), opStack), opnames[opcode] ?? "(null)")
                }
                profileSymbol!.profileCount += 1
            }

            // Port-note: Raven's signed `+`, `-`, `*`, unary `-`, and `<<` are undefined in C on overflow, and the x86 build wraps.
            // The port wraps with `&+`, `&-`, `&*`, `&<<`, and `&>>`, and a shift count takes its low five bits as x86 does.
            switch opcode {
            case OP_BREAK:
                vm.breakCount += 1
                continue nextInstruction2
            case OP_CONST:
                opStack += 1
                r1 = r0
                // Raven's macro `r2`.
                stack[opStack] = codeImage[programCounter]
                r0 = stack[opStack]

                programCounter += 4
                continue nextInstruction2
            case OP_LOCAL:
                opStack += 1
                r1 = r0
                stack[opStack] = codeImage[programCounter] &+ programStack
                r0 = stack[opStack]

                programCounter += 4
                continue nextInstruction2

            case OP_LOAD4:
                if com_vmdebug!.integer > 1 {
                    if (stack[opStack] & 3) != 0 {
                        Com_Error(ERR_DROP, "OP_LOAD4 misaligned")
                    }
                }
                stack[opStack] = image[int: r0 & dataMask]
                r0 = stack[opStack]
                continue nextInstruction2
            case OP_LOAD2:
                stack[opStack] = image[ushort: r0 & dataMask]
                r0 = stack[opStack]
                continue nextInstruction2
            case OP_LOAD1:
                stack[opStack] = Int32(image[byte: r0 & dataMask] as UInt8)
                r0 = stack[opStack]
                continue nextInstruction2

            case OP_STORE4:
                image[int: r1 & (dataMask & ~3)] = r0
                opStack -= 2
                continue nextInstruction
            case OP_STORE2:
                image[short: r1 & (dataMask & ~1)] = r0
                opStack -= 2
                continue nextInstruction
            case OP_STORE1:
                image[byte: r1 & dataMask] = r0
                opStack -= 2
                continue nextInstruction

            case OP_ARG:
                // single byte offset from programStack
                image[int: codeImage[programCounter] + programStack] = r0
                opStack -= 1
                programCounter += 1
                continue nextInstruction

            case OP_BLOCK_COPY:
                do {
                    let src: Int32
                    let dest: Int32
                    var i: Int32
                    var count: Int32
                    let srci: Int32
                    let desti: Int32

                    count = codeImage[programCounter]
                    // MrE: copy range check
                    srci = r0 & dataMask
                    desti = r1 & dataMask
                    count = ((srci &+ count) & dataMask) &- srci
                    count = ((desti &+ count) & dataMask) &- desti

                    src = r0 & dataMask
                    dest = r1 & dataMask
                    // AI: Raven tests the alignment of the two pointers into the data image. The test reads their byte offsets, because the hunk aligns the image's base.
                    if ((src | dest | count) & 3) != 0 {
                        Com_Error(ERR_DROP, "OP_BLOCK_COPY not dword aligned")
                    }
                    count >>= 2
                    i = count - 1
                    while i >= 0 {
                        image[int: dest, i] = image[int: src, i]
                        i -= 1
                    }
                    programCounter += 4
                    opStack -= 2
                }
                continue nextInstruction

            case OP_CALL:
                // save current program counter
                image[int: programStack] = programCounter

                // jump to the location on the stack
                programCounter = r0
                opStack -= 1
                if programCounter < 0 {
                    // system call
                    let r: Int32
                    let temp: Int32
                    var stomped: Int32 = 0

                    if com_vmdebug!.integer > 1 {
                        if vm_debugLevel != 0 {
                            Com_Printf("%s---> systemcall(%i)\n", va("%s%i", VM_Indent(vm), opStack), -1 - programCounter)
                        }
                    }
                    // save the stack to allow recursive VM entry
                    temp = vm.callLevel
                    vm.programStack = programStack - 4
                    if com_vmdebug!.integer > 1 {
                        stomped = image[int: programStack + 4]
                    }
                    image[int: programStack + 4] = -1 - programCounter

//VM_LogSyscalls( (int *)&image[ programStack + 4 ] );
                    // Raven hands the engine the address of the argument words in the data image, and the handle over that address is the pass, under rule 11.
                    r = vm.runSystemCall(OpaquePointer(image + (programStack + 4)))

                    if com_vmdebug!.integer > 1 {
                        // this is just our stack frame pointer, only needed
                        // for debugging
                        image[int: programStack + 4] = stomped
                    }

                    // save return value
                    opStack += 1
                    stack[opStack] = r
                    programCounter = image[int: programStack]
                    vm.callLevel = temp
                    if com_vmdebug!.integer > 1 {
                        if vm_debugLevel != 0 {
                            Com_Printf("%s<--- %s\n", va("%s%i", VM_Indent(vm), opStack), VM_ValueToSymbol(vm, programCounter))
                        }
                    }
                } else {
                    programCounter = instructionPointers[programCounter]
                }
                continue nextInstruction

            // push and pop are only needed for discarded or bad function return values
            case OP_PUSH:
                opStack += 1
                continue nextInstruction
            case OP_POP:
                opStack -= 1
                continue nextInstruction

            case OP_ENTER:
                if com_vmdebug!.integer != 0 {
                    profileSymbol = VM_ValueToFunctionSymbol(vm, programCounter)
                }
                // get size of stack frame
                v1 = codeImage[programCounter]

                programCounter += 4
                programStack &-= v1
                if com_vmdebug!.integer > 1 {
                    // save old stack frame for debugging traces
                    image[int: programStack + 4] = programStack + v1
                    if vm_debugLevel != 0 {
                        Com_Printf("%s---> %s\n", va("%s%i", VM_Indent(vm), opStack), VM_ValueToSymbol(vm, programCounter - 5))
                        if vm.breakFunction != 0 && programCounter - 5 == vm.breakFunction {
                            // this is to allow setting breakpoints here in the debugger
                            vm.breakCount += 1
        //					vm_debugLevel = 2;
        //					VM_StackTrace( vm, programCounter, programStack );
                        }
                        vm.callLevel += 1
                    }
                }
                continue nextInstruction
            case OP_LEAVE:
                // remove our stack frame
                v1 = codeImage[programCounter]

                programStack &+= v1

                // grab the saved program counter
                programCounter = image[int: programStack]
                if com_vmdebug!.integer != 0 {
                    profileSymbol = VM_ValueToFunctionSymbol(vm, programCounter)
                    if vm_debugLevel != 0 {
                        vm.callLevel -= 1
                        Com_Printf("%s<--- %s\n", va("%s%i", VM_Indent(vm), opStack), VM_ValueToSymbol(vm, programCounter))
                    }
                }
                // check for leaving the VM
                if programCounter == -1 {
                    break nextInstruction
                }
                continue nextInstruction

            /*
            ===================================================================
            BRANCHES
            ===================================================================
            */

            case OP_JUMP:
                programCounter = r0
                programCounter = instructionPointers[programCounter]
                opStack -= 1
                continue nextInstruction

            case OP_EQ:
                opStack -= 2
                if r1 == r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_NE:
                opStack -= 2
                if r1 != r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_LTI:
                opStack -= 2
                if r1 < r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_LEI:
                opStack -= 2
                if r1 <= r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_GTI:
                opStack -= 2
                if r1 > r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_GEI:
                opStack -= 2
                if r1 >= r0 {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_LTU:
                opStack -= 2
                if (UInt32(bitPattern: r1)) < (UInt32(bitPattern: r0)) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_LEU:
                opStack -= 2
                if (UInt32(bitPattern: r1)) <= (UInt32(bitPattern: r0)) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_GTU:
                opStack -= 2
                if (UInt32(bitPattern: r1)) > (UInt32(bitPattern: r0)) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_GEU:
                opStack -= 2
                if (UInt32(bitPattern: r1)) >= (UInt32(bitPattern: r0)) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    continue nextInstruction
                } else {
                    programCounter += 4
                    continue nextInstruction
                }

            case OP_EQF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) == Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }

            case OP_NEF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) != Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }

            case OP_LTF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) < Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }

            case OP_LEF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) <= Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }

            case OP_GTF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) > Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }

            case OP_GEF:
                if Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) >= Float(bitPattern: UInt32(bitPattern: stack[opStack])) {
                    programCounter = codeImage[programCounter]	//vm->instructionPointers[r2];
                    opStack -= 2
                    continue nextInstruction
                } else {
                    programCounter += 4
                    opStack -= 2
                    continue nextInstruction
                }


            //===================================================================

            case OP_NEGI:
                stack[opStack] = 0 &- r0
                continue nextInstruction
            case OP_ADD:
                stack[opStack - 1] = r1 &+ r0
                opStack -= 1
                continue nextInstruction
            case OP_SUB:
                stack[opStack - 1] = r1 &- r0
                opStack -= 1
                continue nextInstruction
            case OP_DIVI:
                stack[opStack - 1] = r1 / r0
                opStack -= 1
                continue nextInstruction
            case OP_DIVU:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) / (UInt32(bitPattern: r0)))
                opStack -= 1
                continue nextInstruction
            case OP_MODI:
                stack[opStack - 1] = r1 % r0
                opStack -= 1
                continue nextInstruction
            case OP_MODU:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) % UInt32(bitPattern: r0))
                opStack -= 1
                continue nextInstruction
            case OP_MULI:
                stack[opStack - 1] = r1 &* r0
                opStack -= 1
                continue nextInstruction
            case OP_MULU:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) &* (UInt32(bitPattern: r0)))
                opStack -= 1
                continue nextInstruction

            case OP_BAND:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) & (UInt32(bitPattern: r0)))
                opStack -= 1
                continue nextInstruction
            case OP_BOR:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) | (UInt32(bitPattern: r0)))
                opStack -= 1
                continue nextInstruction
            case OP_BXOR:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) ^ (UInt32(bitPattern: r0)))
                opStack -= 1
                continue nextInstruction
            case OP_BCOM:
                stack[opStack - 1] = Int32(bitPattern: ~(UInt32(bitPattern: r0)))
                continue nextInstruction

            case OP_LSH:
                stack[opStack - 1] = r1 &<< r0
                opStack -= 1
                continue nextInstruction
            case OP_RSHI:
                stack[opStack - 1] = r1 &>> r0
                opStack -= 1
                continue nextInstruction
            case OP_RSHU:
                stack[opStack - 1] = Int32(bitPattern: (UInt32(bitPattern: r1)) &>> r0)
                opStack -= 1
                continue nextInstruction

            case OP_NEGF:
                stack[opStack] = Int32(bitPattern: (-Float(bitPattern: UInt32(bitPattern: stack[opStack]))).bitPattern)
                continue nextInstruction
            case OP_ADDF:
                stack[opStack - 1] = Int32(bitPattern: (Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) + Float(bitPattern: UInt32(bitPattern: stack[opStack]))).bitPattern)
                opStack -= 1
                continue nextInstruction
            case OP_SUBF:
                stack[opStack - 1] = Int32(bitPattern: (Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) - Float(bitPattern: UInt32(bitPattern: stack[opStack]))).bitPattern)
                opStack -= 1
                continue nextInstruction
            case OP_DIVF:
                stack[opStack - 1] = Int32(bitPattern: (Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) / Float(bitPattern: UInt32(bitPattern: stack[opStack]))).bitPattern)
                opStack -= 1
                continue nextInstruction
            case OP_MULF:
                stack[opStack - 1] = Int32(bitPattern: (Float(bitPattern: UInt32(bitPattern: stack[opStack - 1])) * Float(bitPattern: UInt32(bitPattern: stack[opStack]))).bitPattern)
                opStack -= 1
                continue nextInstruction

            case OP_CVIF:
                stack[opStack] = Int32(bitPattern: (Float(stack[opStack])).bitPattern)
                continue nextInstruction
            case OP_CVFI:
                // Port-note: Raven's cast of a float outside the int range is undefined in C, and Swift traps there.
                stack[opStack] = Int32(Float(bitPattern: UInt32(bitPattern: stack[opStack])))
                continue nextInstruction
            case OP_SEX8:
                stack[opStack] = Int32(Int8(truncatingIfNeeded: stack[opStack]))
                continue nextInstruction
            case OP_SEX16:
                stack[opStack] = Int32(Int16(truncatingIfNeeded: stack[opStack]))
                continue nextInstruction
            default:
                Com_Error(ERR_DROP, "Bad VM instruction")  // this should be scanned on load!
            }
        }
    }

    // done
    vm.currentlyInterpreting = false

    if opStack != 1 {
        Com_Error(ERR_DROP, "Interpreter error: opStack = %i", opStack)
    }

    vm.programStack = stackOnEntry

    // return the result
    return stack[opStack]
}
