import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/vm.cpp:20
// AI: Raven's `g_vmMap` is a `std::map` from the VM to its symbol map. The map is a Dictionary on the world, under rule 17.
var g_vmMap: [Vm: [Int32: VmSymbol]] {
    get { world.g_vmMap }
    set { world.g_vmMap = newValue }
}

/// Source: oracle/codemp/qcommon/vm.cpp:21
// AI: Raven points `g_symbolMap` at the symbol map of one VM in `g_vmMap`. The port holds that VM, the key of the map.
var g_symbolMap: Vm? {
    get { world.g_symbolMap }
    set { world.g_symbolMap = newValue }
}

/// Source: oracle/codemp/qcommon/vm.cpp:24
var currentVM: Vm? {
    get { world.variables.currentVM }
    set { world.variables.currentVM = newValue }
}

/// Source: oracle/codemp/qcommon/vm.cpp:25
var lastVM: Vm? {
    get { world.variables.lastVM }
    set { world.variables.lastVM = newValue }
}

/// Source: oracle/codemp/qcommon/vm.cpp:26
var vm_debugLevel: Int32 {
    get { world.variables.vm_debugLevel }
    set { world.variables.vm_debugLevel = newValue }
}

/// Source: oracle/codemp/qcommon/vm.cpp:28
let MAX_VM = 3 as Int32

/// Source: oracle/codemp/qcommon/vm.cpp:29
var vmTable: Slots<Vm> { world.storage.vmTable }

/// Source: oracle/codemp/qcommon/vm.cpp:115
// AI: Raven declares `nullSym` static in VM_ValueToFunctionSymbol. The function uses one zeroed allocation on the storage class.
var nullSym_VM_ValueToFunctionSymbol: VmSymbol { world.storage.nullSym_VM_ValueToFunctionSymbol }

/// Source: oracle/codemp/qcommon/vm.cpp:469
let STACK_SIZE = 0x20000 as Int32

/// Source: oracle/codemp/qcommon/vm.cpp:784
private let MAX_STACK = 256 as Int32

/// Source: oracle/codemp/qcommon/vm.cpp:785
private let STACK_MASK = (MAX_STACK - 1)

/**
Set the symbol map based on the VM currently
being in interpreted. This is done so that we
do not have to do a map lookup for the VM with
each symbol request.
-rww
*/
/// Source: oracle/codemp/qcommon/vm_local.h:162
// AI: Raven stores the address of the map of `vm` in `g_vmMap`. The port stores the VM, the key of that map.
func VM_SetSymbolMap(_ vm: Vm) {
    g_symbolMap = vm
}

// converts a VM pointer to a C pointer and
// checks to make sure that the range is acceptable
/// Source: oracle/codemp/qcommon/vm.cpp:37
// TODO: Port signature
// Raven wrote: void *VM_VM2C( vmptr_t p, int length )
// No table row for the return `void *`.
func VM_VM2C() -> Never {
    // TODO: Port VM_VM2C
    portMissing("VM_VM2C", source: "oracle/codemp/qcommon/vm.cpp:37")
}

/// Source: oracle/codemp/qcommon/vm.cpp:41
func VM_Debug(_ level: Int32) {
    vm_debugLevel = level
}

/**
```
==============
VM_Init
==============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:50
func VM_Init() {
    Cvar_Get("vm_cgame", "0", CVAR_SYSTEMINFO | CVAR_ARCHIVE) // default to DLLs now instead. Our VMs are getting too HUGE.
    Cvar_Get("vm_game", "0", CVAR_SYSTEMINFO | CVAR_ARCHIVE) //
    Cvar_Get("vm_ui", "0", CVAR_SYSTEMINFO | CVAR_ARCHIVE) //
    //client wants to know if the server is using vm's for certain modules,
    //so if pure we can force the same method (be it vm or dll) -rww

    Cmd_AddCommand("vmprofile", VM_VmProfile_f)
    Cmd_AddCommand("vminfo", VM_VmInfo_f)

    vmTable.zero()
}

/**
```
===============
VM_ValueToSymbol

Assumes a program counter value
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:70
func VM_ValueToSymbol(_ vm: Vm, _ value: Int32) -> String {
    var sym: VmSymbol?
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var text = CharBuf(1024)

    sym = g_vmMap[g_symbolMap!]?[value]

    if sym == nil {
        sym = vm.symbols
        if sym == nil {
            return "NO SYMBOLS"
        }

        // find the symbol
        while sym!.next != nil && sym!.next!.symValue <= value {
            sym = sym!.next
        }
        if sym != nil {
            //for instant recollection next time
            g_vmMap[g_symbolMap!, default: [:]][value] = sym
        }
    }

    if value == sym!.symValue {
        return sym!.symName
    }

    Com_sprintf(&text, Int32((text).count), "%s+%i", sym!.symName, value - sym!.symValue)

    return String(text)
}

/**
```
===============
VM_ValueToFunctionSymbol

For profiling, find the symbol behind this value
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:113
func VM_ValueToFunctionSymbol(_ vm: Vm, _ value: Int32) -> VmSymbol? {
    var sym: VmSymbol?

    sym = g_vmMap[g_symbolMap!]?[value]

    if sym == nil {
        sym = vm.symbols
        if sym == nil {
            return nullSym_VM_ValueToFunctionSymbol
        }

        while sym!.next != nil && sym!.next!.symValue <= value {
            sym = sym!.next
        }
        if sym != nil {
            //for instant recollection next time
            g_vmMap[g_symbolMap!, default: [:]][value] = sym
        }
    }

    return sym
}

/**
```
===============
VM_SymbolToValue
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:148
// Port-note: Raven calls this function from no file of either tree, so it is dead.
func VM_SymbolToValue(_ vm: Vm, _ symbol: String) -> Int32 {
    // TODO: Port VM_SymbolToValue
    portMissing("VM_SymbolToValue", source: "oracle/codemp/qcommon/vm.cpp:148")
}

/**
```
=====================
VM_SymbolForCompiledPointer
=====================
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:165
// Port-note: Raven calls this function from no file of either tree, so it is dead.
func VM_SymbolForCompiledPointer(_ vm: Vm, _ code: OpaquePointer?) -> String {
    // TODO: Port VM_SymbolForCompiledPointer
    portMissing("VM_SymbolForCompiledPointer", source: "oracle/codemp/qcommon/vm.cpp:165")
}

/**
```
===============
ParseHex
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:197
func ParseHex(_ text: String) -> Int32 {
    var value: Int32
    var c: Int32
    // Raven steps his own `text` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var text = TextCursor(CharBuf(text))

    value = 0
    while true {
        c = text.byte
        text.advance()
        if !((c) != 0) { break }
        if c >= Int32(ascii: "0") && c <= Int32(ascii: "9") {
            value = value * 16 + c - Int32(ascii: "0")
            continue
        }
        if c >= Int32(ascii: "a") && c <= Int32(ascii: "f") {
            value = value * 16 + 10 + c - Int32(ascii: "a")
            continue
        }
        if c >= Int32(ascii: "A") && c <= Int32(ascii: "F") {
            value = value * 16 + 10 + c - Int32(ascii: "A")
            continue
        }
    }

    return value
}

/**
```
===============
VM_Alloc

Convenience function for changing the way VMs are allocated.
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:227
func VM_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    return Hunk_Alloc(size, h_high)
    //return Z_Malloc(size, TAG_ALL, qtrue);
}

/**
```
===============
VM_LoadSymbols
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:238
func VM_LoadSymbols(_ vm: Vm) {
    let len: Int32
    var mapfile = CharBuf(0)
    var token: String
    var text_p: TextCursor
    var name = CharBuf(64)
    var symbols = CharBuf(64)
    var count: Int32
    var value: Int32
    var segment: Int32
    let numInstructions: Int32
    var prev: Slots<VmSymbol?>
    var sym: VmSymbol
    var chars: Int32

    // don't load symbols if not developer
    if com_developer!.integer == 0 {
        return
    }

    COM_StripExtension(vm.name, &name)
    Com_sprintf(&symbols, Int32((symbols).count), "vm/%s.map", name)
    len = FS_ReadFile(String(symbols), &mapfile)
    // AI: Raven tested the buffer for NULL. The CharBuf form gives an empty buffer for a missing file, so the test reads the length.
    if len < 0 {
        Com_Printf("Couldn't load symbol file: %s\n", symbols)
        return
    }

    numInstructions = vm.instructionPointersLength >> 2

    // parse the symbols
    text_p = TextCursor(mapfile)
    prev = vm.symbolsSlot
    count = 0

    VM_SetSymbolMap(vm)

    while true {
        token = COM_Parse(&text_p)
        if token.isEmpty {
            break
        }
        segment = ParseHex(token)
        if segment != 0 {
            COM_Parse(&text_p)
            COM_Parse(&text_p)
            continue // only load code segment values
        }

        token = COM_Parse(&text_p)
        if token.isEmpty {
            Com_Printf("WARNING: incomplete line at end of file\n")
            break
        }
        value = ParseHex(token)

        token = COM_Parse(&text_p)
        if token.isEmpty {
            Com_Printf("WARNING: incomplete line at end of file\n")
            break
        }
        chars = strlen(token)
        sym = VmSymbol(VM_Alloc(Int32(VmSymbol.byteCount) + chars))
        prev[0] = sym
        prev = sym.nextSlot
        sym.next = nil

        // convert value from an instruction number to a code offset
        if value >= 0 && value < numInstructions {
            value = vm.instructionPointers![value]
        }

        sym.symValue = value
        // The setter of `symName` holds Raven's Q_strncpyz, bounded by the token's MAX_TOKEN_CHARS.
        sym.symName = token

        g_vmMap[g_symbolMap!, default: [:]][value] = sym

        count += 1
    }

    vm.numSymbols = count
    Com_Printf("%i symbols parsed from %s\n", count, symbols)
    FS_FreeFile(mapfile)
}

/**
```
============
VM_DllSyscall

Dlls will call this directly

 rcg010206 The horror; the horror.

  The syscall mechanism relies on stack manipulation to get it's args.
   This is likely due to C's inability to pass "..." parameters to
   a function in one clean chunk. On PowerPC Linux, these parameters
   are not necessarily passed on the stack, so while (&arg[0] == arg)
   is true, (&arg[1] == 2nd function parameter) is not necessarily
   accurate, as arg's value might have been stored to the stack or
   other piece of scratch memory to give it a valid address, but the
   next parameter might still be sitting in a register.

  Quake's syscall system also assumes that the stack grows downward,
   and that any needed types can be squeezed, safely, into a signed int.

  This hack below copies all needed values for an argument to a
   array in memory, so that Quake can get the correct values. This can
   also be used on systems where the stack grows upwards, as the
   presumably standard and safe stdargs.h macros are used.

  As for having enough space in a signed int for your datatypes, well,
   it might be better to wait for DOOM 3 before you start porting.  :)

  The original code, while probably still inherently dangerous, seems
   to work well enough for the platforms it already works on. Rather
   than add the performance hit for those platforms, the original code
   is still in use there.

  For speed, we just grab 15 arguments, and don't worry about exactly
   how many the syscall actually needs; the extra is thrown away.

============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:363
// Raven wrote: int QDECL VM_DllSyscall( int arg, ... )
// Not ported: the C function of Sources/CJKAHost/jka_host.c, because Swift cannot write a C variadic callee, and the module reaches it through dllEntry.

/**
```
=================
VM_Restart

Reload the data, but leave everything else in place
This allows a server to do a map_restart without changing memory allocation
=================
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:391
func VM_Restart(_ vm: Vm) -> Vm? {
    var header: VmHeader?
    var length: Int32
    var dataLength: Int32
    var i: Int32
    var filename = CharBuf(64)

    // DLL's can't be restarted in place
    if vm.dllHandle != nil {
        var name = CharBuf(64)
        let systemCall: VmSystemCall?

        systemCall = vm.systemCall
        Q_strncpyz(&name, vm.name, Int32((name).count))

        VM_Free(vm)

        // Raven assigns the new VM to his own `vm` parameter and returns it, so the body returns it.
        return VM_Create(String(name), systemCall, VMI_NATIVE)
    }

    // load the image
    Com_Printf("VM_Restart()\n", filename)
    Com_sprintf(&filename, Int32((filename).count), "vm/%s.qvm", vm.name)
    Com_Printf("Loading vm file %s.\n", filename)
    length = FS_ReadFile(String(filename), &header)
    if header == nil {
        Com_Error(ERR_DROP, "VM_Restart failed.\n")
    }

    // byte swap the header
    i = 0
    while i < Int32(VmHeader.byteCount) / 4 {
        // LittleLong of the WinDed arm is its argument, so the store writes the word back.
        header!.bytes(count: length)[int: i * 4] = header!.bytes(count: length)[int: i * 4]
        i += 1
    }

    // validate
    if header!.vmMagic != VM_MAGIC || header!.bssLength < 0 || header!.dataLength < 0 || header!.litLength < 0 || header!.codeLength <= 0 {
        VM_Free(vm)
        Com_Error(ERR_FATAL, "%s has bad header", filename)
    }

    // round up to next power of 2 so all data operations can
    // be mask protected
    dataLength = header!.dataLength + header!.litLength + header!.bssLength
    i = 0
    while dataLength > (1 << i) {
        i += 1
    }
    dataLength = 1 << i

    // clear the data
    Com_Memset(vm.dataBase!, 0, dataLength)

    // copy the intialized data
    Com_Memcpy(vm.dataBase!, header!.bytes(count: length).suffix(from: header!.dataOffset), header!.dataLength + header!.litLength)

    // byte swap the longs
    i = 0
    while i < header!.dataLength {
        // LittleLong of the WinDed arm is its argument, so the store writes the word back.
        vm.dataBase![int: i] = vm.dataBase![int: i]
        i += 4
    }

    // free the original file
    FS_FreeFile(header)

    return vm
}

/**
```
================
VM_Create

If image ends in .qvm it will be interpreted, otherwise
it will attempt to load as a system dll
================
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:471
func VM_Create(_ module: String, _ systemCalls: VmSystemCall?, _ interpret: vmInterpret_t) -> Vm? {
    var vm: Vm?
    var header: VmHeader?
    var length: Int32
    var dataLength: Int32
    var i: Int32
    var filename = CharBuf(64)
    // Raven assigns his own `interpret` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var interpret = interpret

    if module.isEmpty || systemCalls == nil {
        Com_Error(ERR_FATAL, "VM_Create: bad parms")
    }

    // see if we already have the VM
    i = 0
    while i < MAX_VM {
        if Q_stricmp(vmTable[i].name, module) == 0 {
            vm = vmTable[i]
            return vm
        }
        i += 1
    }

    // find a free vm
    i = 0
    while i < MAX_VM {
        if vmTable[i].name.isEmpty {
            break
        }
        i += 1
    }

    if i == MAX_VM {
        Com_Error(ERR_FATAL, "VM_Create: no free vm_t")
    }

    vm = vmTable[i]

    Q_strncpyz(&vm!.nameBuffer, module, 64)
    vm!.systemCall = systemCalls

    // never allow dll loading with a demo
    if interpret == VMI_NATIVE {
        if Cvar_VariableValue("fs_restrict") != 0 {
            interpret = VMI_COMPILED
        }
    }

    if interpret == VMI_NATIVE {
        // try to load as a system dll
        Com_Printf("Loading dll file %s.\n", vm!.name)
        // AI: Raven hands VM_DllSyscall to the module. The C VM_DllSyscall of CJKAHost reaches the module through the load of the shell, so the call hands nil.
        vm!.dllHandle = Sys_LoadDll(module, vm!.entryPointAddress, nil)
        if vm!.dllHandle != nil {
            return vm
        }

        Com_Printf("Failed to load dll, looking for qvm.\n")
        interpret = VMI_COMPILED
    }

    // load the image
    Com_sprintf(&filename, Int32((filename).count), "vm/%s.qvm", vm!.name)
    Com_Printf("Loading vm file %s.\n", filename)
    length = FS_ReadFile(String(filename), &header)
    if header == nil {
        Com_Printf("Failed.\n")
        VM_Free(vm!)
        return nil
    }

    // byte swap the header
    i = 0
    while i < Int32(VmHeader.byteCount) / 4 {
        // LittleLong of the WinDed arm is its argument, so the store writes the word back.
        header!.bytes(count: length)[int: i * 4] = header!.bytes(count: length)[int: i * 4]
        i += 1
    }

    // validate
    if header!.vmMagic != VM_MAGIC || header!.bssLength < 0 || header!.dataLength < 0 || header!.litLength < 0 || header!.codeLength <= 0 {
        VM_Free(vm!)
        Com_Error(ERR_FATAL, "%s has bad header", filename)
    }

    // round up to next power of 2 so all data operations can
    // be mask protected
    dataLength = header!.dataLength + header!.litLength + header!.bssLength
    i = 0
    while dataLength > (1 << i) {
        i += 1
    }
    dataLength = 1 << i

    // allocate zero filled space for initialized and uninitialized data
    // AI: Raven stores the block of VM_Alloc into the `byte *` field. The store is the Slots over the `dataLength` bytes of the block.
    vm!.dataBase = Slots(scalars: VM_Alloc(dataLength), count: Int(dataLength))
    vm!.dataMask = dataLength - 1

    // copy the intialized data
    Com_Memcpy(vm!.dataBase!, header!.bytes(count: length).suffix(from: header!.dataOffset), header!.dataLength + header!.litLength)

    // byte swap the longs
    i = 0
    while i < header!.dataLength {
        // LittleLong of the WinDed arm is its argument, so the store writes the word back.
        vm!.dataBase![int: i] = vm!.dataBase![int: i]
        i += 4
    }

    // allocate space for the jump targets, which will be filled in by the compile/prep functions
    vm!.instructionPointersLength = header!.instructionCount * 4
    // AI: Raven stores the block of VM_Alloc into the `int *` field. The store is the Slots over the words of the block.
    vm!.instructionPointers = Slots(scalars: VM_Alloc(vm!.instructionPointersLength), count: Int(vm!.instructionPointersLength >> 2))

    // copy or compile the instructions
    vm!.codeLength = header!.codeLength

    if interpret >= VMI_COMPILED {
        vm!.compiled = true
        VM_Compile(vm!, header!)
    } else {
        vm!.compiled = false
        VM_PrepareInterpreter(vm!, header!)
    }

    // free the original file
    FS_FreeFile(header)

    // load the map file
    VM_LoadSymbols(vm!)

    // the stack is implicitly at the end of the image
    vm!.programStack = vm!.dataMask + 1
    vm!.stackBottom = vm!.programStack - STACK_SIZE

    return vm
}

/**
```
==============
VM_Free
==============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:605
func VM_Free(_ vm: Vm) {

    if vm.dllHandle != nil {
        Sys_UnloadDll(vm.dllHandle)
        vm.clear()
    }
    vm.clear()
    // Port-note: Raven keeps the symbol map of a freed VM, and a later VM in the same slot reads the stale symbols.
    // The port removes the map of the slot here.
    g_vmMap[vm] = nil

    currentVM = nil
    lastVM = nil
}

/// Source: oracle/codemp/qcommon/vm.cpp:628
func VM_Clear() {
    var i: Int32
    i = 0
    while i < MAX_VM {
        if vmTable[i].dllHandle != nil {
            Sys_UnloadDll(vmTable[i].dllHandle)
        }
        vmTable[i].clear()
        // Port-note: Raven keeps the symbol map of a cleared VM, and a later VM in the same slot reads the stale symbols.
        // The port removes the map of the slot here.
        g_vmMap[vmTable[i]] = nil
        i += 1
    }
    currentVM = nil
    lastVM = nil
}

/// Source: oracle/codemp/qcommon/vm.cpp:640
func VM_ArgPtr(_ intValue: Int32) -> UnsafeMutableRawPointer? {
    if intValue == 0 {
        return nil
    }
    // bk001220 - currentVM is missing on reconnect
    if currentVM == nil {
        return nil
    }

    if currentVM!.entryPoint != nil {
        return currentVM!.address(at: intValue)
    } else {
        return currentVM!.address(at: intValue & currentVM!.dataMask)
    }
}

/// Source: oracle/codemp/qcommon/vm.cpp:657
func BotVMShift(_ ptr: Int32) -> UnsafeMutableRawPointer? {
    if ptr == 0 {
        return nil
    }

    if gvm == nil {
        //always using the game vm here.
        return nil
    }

    if gvm!.entryPoint != nil {
        return gvm!.address(at: ptr)
    } else {
        return gvm!.address(at: ptr & gvm!.dataMask)
    }
}

/// Source: oracle/codemp/qcommon/vm.cpp:679
func VM_Shifted_Alloc(_ ptr: inout OpaquePointer?, _ size: Int32) {
    var mem: OpaquePointer?

    if currentVM == nil {
        ptr = nil
        return
    }

    //first allocate our desired memory, up front
    let block = Z_Malloc(size + 1, TAG_VM_ALLOCATED, false)
    // Raven stores the allocation in `mem`, and the opaque pointer over the raw allocation is that store, under rule 11.
    mem = OpaquePointer(block)

    if mem == nil {
        ptr = nil
        return
    }

    // AI: Raven clears the block with `memset`. The fill clears the `size+1` bytes of the Slots over the block.
    Slots<JKAShared.byte>(scalars: block, count: Int(size + 1)).fill(0)

    //This can happen.. if a free chunk of memory is found before the vm alloc pointer, commonly happens
    //when allocating like 4 bytes or whatever. However it seems to actually be handled which I didn't
    //think it would be.. so hey.

    //Alright, subtract the database from the memory pointer to get a memory address relative to the VM.
    //When the VM modifies it it should be modifying the same chunk of memory we have allocated in the engine.
    ptr = currentVM!.shifted(mem)
}

/// Source: oracle/codemp/qcommon/vm.cpp:719
func VM_Shifted_Free(_ ptr: inout OpaquePointer?) {
    let mem: OpaquePointer?

    if currentVM == nil {
        return
    }

    //Shift the VM memory pointer back to get the same pointer we initially allocated in real memory space.
    mem = currentVM!.unshifted(ptr)

    if mem == nil {
        return
    }

    Z_Free(mem)
    ptr = nil //go ahead and clear the pointer for the game.
}

/// Source: oracle/codemp/qcommon/vm.cpp:742
func VM_ExplicitArgPtr(_ vm: Vm, _ intValue: Int) -> String? {
    if intValue == 0 {
        return nil
    }

    // bk010124 - currentVM is missing on reconnect here as well?
    if currentVM == nil {
        return nil
    }

    //
    if vm.entryPoint != nil {
        return vm.address(at: intValue)
    } else {
        // AI: Raven masks an `int` word. The word of VM_Call is pointer-wide, so the mask widens to it.
        return vm.address(at: intValue & Int(vm.dataMask))
    }
}

/**
```
==============
VM_Call


Upon a system call, the stack will look like:

sp+32	parm1
sp+28	parm0
sp+24	return value
sp+20	return address
sp+16	local1
sp+14	local0
sp+12	arg1
sp+8	arg0
sp+4	return stack
sp		return address

An interpreted function will immediately execute
an OP_ENTER instruction, which will subtract space for
locals from sp
==============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:787
func VM_Call(_ vm: Vm, _ callnum: Int32, _ args: any JKAShared.FormatArg...) -> Int {
    var oldVM: Vm?
    var r: Int
    // Raven's local `int args[16]` is `words`, because the variadic parameter holds the name `args`.
    // AI: Raven's words are `int`. The words are pointer-wide, so the address of a vector reaches a dll module whole.
    var words = [Int](repeating: 0, count: 16)

    oldVM = currentVM
    currentVM = vm
    lastVM = vm

    if vm_debugLevel != 0 {
        Com_Printf("VM_Call( %i )\n", callnum)
    }

    // Port-note: Raven reads 16 words with `va_arg` in the dll arm, and the other arms read the words after `&callnum` on the stack.
    // A read past the last argument is undefined, so the port reads the caller's words once for every arm, and the rest stay 0.
    for (n, arg) in args.enumerated() where n < 16 {
        guard case .integer(let word) = arg.formatValue else {
            preconditionFailure("VM_Call: argument \(n) is not an int")
        }
        words[n] = Int(truncatingIfNeeded: word)
    }

    // if we have a dll loaded, call it directly
    if vm.entryPoint != nil {
        //rcg010207 -  see dissertation at top of VM_DllSyscall() in this file.
        r = vm.runEntryPoint(callnum, words)
    } else if vm.compiled {
        // AI: Raven's VM_Call returns the `int` of each arm. It returns the word of the module's vmMain, so the `int` of a QVM arm widens to it.
        // AI: Raven's QVM arms read `int` words. The arm narrows each pointer-wide word to the `int` of the QVM.
        r = Int(VM_CallCompiled(vm, [callnum] + words.map { Int32(truncatingIfNeeded: $0) }))
    } else {
        // AI: Raven's QVM arms read `int` words. The arm narrows each pointer-wide word to the `int` of the QVM.
        r = Int(VM_CallInterpreted(vm, [callnum] + words.map { Int32(truncatingIfNeeded: $0) }))
    }

    if oldVM != nil { // bk001220 - assert(currentVM!=NULL) for oldVM==NULL
        currentVM = oldVM
    }
    return r
}

//=================================================================

/// Source: oracle/codemp/qcommon/vm.cpp:833
private func VM_ProfileSort(_ a: VmSymbol?, _ b: VmSymbol?) -> Int32 {
    let sa: VmSymbol?
    let sb: VmSymbol?

    sa = a
    sb = b

    if sa!.profileCount < sb!.profileCount {
        return -1
    }
    if sa!.profileCount > sb!.profileCount {
        return 1
    }
    return 0
}

/**
```
==============
VM_VmProfile_f

==============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:854
func VM_VmProfile_f() {
    var vm: Vm?
    var sorted: [VmSymbol?]
    var sym: VmSymbol?
    var i: Int32
    var total: Double

    if lastVM == nil {
        return
    }

    vm = lastVM

    if vm!.numSymbols == 0 {
        return
    }

    // AI: Raven sorts a Z_Malloc table of `vmSymbol_t *` and frees it with Z_Free. The table is a Swift array of the views, which frees itself.
    sorted = [VmSymbol?](repeating: nil, count: Int(vm!.numSymbols))
    sorted[0] = vm!.symbols
    total = Double(sorted[0]!.profileCount)
    i = 1
    while i < vm!.numSymbols {
        sorted[i] = sorted[i - 1]!.next
        total += Double(sorted[i]!.profileCount)
        i += 1
    }

    qsort(&sorted, vm!.numSymbols, VM_ProfileSort)

    i = 0
    while i < vm!.numSymbols {
        var perc: Int32

        sym = sorted[i]

        perc = Int32(Double(100 * Float(sym!.profileCount)) / total)
        Com_Printf("%2i%% %9i %s\n", perc, sym!.profileCount, sym!.symName)
        sym!.profileCount = 0
        i += 1
    }

    Com_Printf("    %9.0f total\n", total)
}

/**
```
==============
VM_VmInfo_f

==============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:901
func VM_VmInfo_f() {
    var vm: Vm?
    var i: Int32

    Com_Printf("Registered virtual machines:\n")
    i = 0
    while i < MAX_VM {
        vm = vmTable[i]
        if vm!.name.isEmpty {
            break
        }
        Com_Printf("%s : ", vm!.name)
        if vm!.dllHandle != nil {
            Com_Printf("native\n")
            i += 1
            continue
        }
        if vm!.compiled {
            Com_Printf("compiled on load\n")
        } else {
            Com_Printf("interpreted\n")
        }
        Com_Printf("    code length : %7i\n", vm!.codeLength)
        Com_Printf("    table length: %7i\n", vm!.instructionPointersLength)
        Com_Printf("    data length : %7i\n", vm!.dataMask + 1)
        i += 1
    }
}

/**
```
===============
VM_LogSyscalls

Insert calls to this while debugging the vm compiler
===============
```
*/
/// Source: oracle/codemp/qcommon/vm.cpp:934
// Port-note: Raven calls this function only from comments of vm_interpreted.cpp and vm_x86.cpp, so it is dead.
func VM_LogSyscalls(_ args: Slots<Int32>) {
    // TODO: Port VM_LogSyscalls
    portMissing("VM_LogSyscalls", source: "oracle/codemp/qcommon/vm.cpp:934")
}

/// Source: oracle/codemp/qcommon/vm.cpp:949
// AI: Raven gives this body under `oDLL_ONLY`, which no build defines, and WinDed links vm_x86.cpp. The port takes this body, because vm_x86.cpp does not port.
func VM_CallCompiled(_ vm: Vm, _ args: [Int32]?) -> Int32 {
    return(0)
}

/// Source: oracle/codemp/qcommon/vm.cpp:953
// AI: Raven gives this body under `oDLL_ONLY`, which no build defines, and WinDed links vm_x86.cpp. The port takes this body, because vm_x86.cpp does not port.
func VM_Compile(_ vm: Vm, _ header: VmHeader) {}
