# This script assembles vmtest.qvm and vmtest.map, then runs the image in a small interpreter and prints the expected return values.
# Run it with: python3 -I assemble.py
# The layout follows oracle/codemp/qcommon/qfiles.h (vmHeader_t) and vm.cpp (VM_Create).
# The interpreter follows oracle/codemp/qcommon/vm_interpreted.cpp (VM_PrepareInterpreter, VM_CallInterpreted).
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))

VM_MAGIC = 0x12721444
STACK_SIZE = 0x20000

# The opcode numbers are the opcode_t enum of oracle/codemp/qcommon/vm_local.h, counted from OP_UNDEF = 0.
OPS = [
    "UNDEF", "IGNORE", "BREAK", "ENTER", "LEAVE", "CALL", "PUSH", "POP", "CONST", "LOCAL", "JUMP",
    "EQ", "NE", "LTI", "LEI", "GTI", "GEI", "LTU", "LEU", "GTU", "GEU", "EQF", "NEF", "LTF", "LEF", "GTF", "GEF",
    "LOAD1", "LOAD2", "LOAD4", "STORE1", "STORE2", "STORE4", "ARG", "BLOCK_COPY",
    "SEX8", "SEX16", "NEGI", "ADD", "SUB", "DIVI", "DIVU", "MODI", "MODU", "MULI", "MULU",
    "BAND", "BOR", "BXOR", "BCOM", "LSH", "RSHI", "RSHU", "NEGF", "ADDF", "SUBF", "DIVF", "MULF", "CVIF", "CVFI",
]
OP = {name: number for number, name in enumerate(OPS)}

# These are the opcodes with a four byte operand. VM_PrepareInterpreter lists the same set, and OP_ARG has a one byte operand.
WIDE = {"ENTER", "CONST", "LOCAL", "LEAVE", "EQ", "NE", "LTI", "LEI", "GTI", "GEI", "LTU", "LEU", "GTU", "GEU",
        "EQF", "NEF", "LTF", "LEF", "GTF", "GEF", "BLOCK_COPY"}
BRANCH = {"EQ", "NE", "LTI", "LEI", "GTI", "GEI", "LTU", "LEU", "GTU", "GEU", "EQF", "NEF", "LTF", "LEF", "GTF", "GEF"}

# The data segment holds one word at address 0. The lit segment holds the bytes "JKA" and a NUL at address 4.
DATA_WORDS = [7]
LIT_BYTES = b"JKA\x00"
BSS_LENGTH = STACK_SIZE - 4 * len(DATA_WORDS) - len(LIT_BYTES)

# The stack frame of vmMain: 8 reserved bytes, 12 bytes of outgoing arguments, then the two locals.
FRAME = 32
ARG_BASE = FRAME + 8
CMD, A, B, C = ARG_BASE, ARG_BASE + 4, ARG_BASE + 8, ARG_BASE + 12
SUM, I = 20, 24


def build_program():
    code = []

    def emit(op, operand=None):
        code.append((op, operand))

    def label(name):
        code.append(("LABEL", name))

    def load(offset):
        emit("LOCAL", offset)
        emit("LOAD4")

    def finish():
        emit("CONST", "end")
        emit("JUMP")

    # vmMain(command, a, b, c) is instruction 0.
    label("vmMain")
    emit("ENTER", FRAME)

    def case(number):
        load(CMD)
        emit("CONST", number)
        emit("NE", "next%d" % number)

    # case 0: (a + b) * c - a
    case(0)
    load(A)
    load(B)
    emit("ADD")
    load(C)
    emit("MULI")
    load(A)
    emit("SUB")
    finish()
    label("next0")

    # case 1: the absolute difference |a - b|, through the local at SUM
    case(1)
    emit("LOCAL", SUM)
    load(A)
    load(B)
    emit("SUB")
    emit("STORE4")
    load(SUM)
    emit("CONST", 0)
    emit("GEI", "case1_positive")
    load(SUM)
    emit("NEGI")
    finish()
    label("case1_positive")
    load(SUM)
    finish()
    label("next1")

    # case 2: helper(a, b) + c, a call to the second function
    case(2)
    load(A)
    emit("ARG", 8)
    load(B)
    emit("ARG", 12)
    emit("CONST", "helper")
    emit("CALL")
    load(C)
    emit("ADD")
    finish()
    label("next2")

    # case 3: syscall 1 with a, plus b. The address -2 gives the call number -1 - (-2) = 1.
    case(3)
    load(A)
    emit("ARG", 8)
    emit("CONST", -2)
    emit("CALL")
    load(B)
    emit("ADD")
    finish()
    label("next3")

    # case 4: the sum 1 + 2 + ... + a, a loop of compare, branch, and jump
    case(4)
    emit("LOCAL", SUM)
    emit("CONST", 0)
    emit("STORE4")
    emit("LOCAL", I)
    emit("CONST", 1)
    emit("STORE4")
    label("loop_top")
    load(I)
    load(A)
    emit("GTI", "loop_done")
    emit("LOCAL", SUM)
    load(SUM)
    load(I)
    emit("ADD")
    emit("STORE4")
    emit("LOCAL", I)
    load(I)
    emit("CONST", 1)
    emit("ADD")
    emit("STORE4")
    emit("CONST", "loop_top")
    emit("JUMP")
    label("loop_done")
    load(SUM)
    finish()
    label("next4")

    # case 5: data word at address 0 times a, plus the byte at address 4
    case(5)
    emit("CONST", 0)
    emit("LOAD4")
    load(A)
    emit("MULI")
    emit("CONST", 4)
    emit("LOAD1")
    emit("ADD")
    finish()
    label("next5")

    # case 6: ((a & b) / c) with syscall 2 called on (a, b) and the result discarded
    case(6)
    load(A)
    emit("ARG", 8)
    load(B)
    emit("ARG", 12)
    emit("CONST", -3)
    emit("CALL")
    emit("POP")
    load(A)
    load(B)
    emit("BAND")
    load(C)
    emit("DIVI")
    finish()
    label("next6")

    # case 7: 1 when a equals b, otherwise 0
    case(7)
    load(A)
    load(B)
    emit("EQ", "case7_equal")
    emit("CONST", 0)
    finish()
    label("case7_equal")
    emit("CONST", 1)
    finish()
    label("next7")

    # case 8: the smaller of a and b
    case(8)
    load(A)
    load(B)
    emit("LTI", "case8_a")
    load(B)
    finish()
    label("case8_a")
    load(A)
    finish()
    label("next8")

    # case 9: the low byte of a, sign extended
    case(9)
    load(A)
    emit("SEX8")
    finish()
    label("next9")

    # Any other command returns -1.
    emit("CONST", -1)
    label("end")
    emit("LEAVE", FRAME)

    # helper(a, b) = a * a + b
    label("helper")
    emit("ENTER", 8)
    emit("LOCAL", 16)
    emit("LOAD4")
    emit("LOCAL", 16)
    emit("LOAD4")
    emit("MULI")
    emit("LOCAL", 20)
    emit("LOAD4")
    emit("ADD")
    emit("LEAVE", 8)
    return code


def assemble(program):
    # The first pass numbers the instructions and finds the byte offset of each one.
    targets = {}
    count = 0
    for op, operand in program:
        if op == "LABEL":
            targets[operand] = count
        else:
            count += 1

    out = bytearray()
    offsets = []
    for op, operand in program:
        if op == "LABEL":
            continue
        offsets.append(len(out))
        out.append(OP[op])
        if operand is not None and isinstance(operand, str):
            operand = targets[operand]
        if op == "ARG":
            out.append(operand)
        elif op in WIDE:
            out += struct.pack("<i", operand)
        else:
            assert operand is None
    return bytes(out), count, targets, offsets


def build_image(code, instruction_count):
    data = b"".join(struct.pack("<i", word) for word in DATA_WORDS)
    code_offset = 32
    data_offset = code_offset + len(code)
    header = struct.pack(
        "<8i", VM_MAGIC, instruction_count, code_offset, len(code), data_offset, len(data), len(LIT_BYTES), BSS_LENGTH)
    return header + code + data + LIT_BYTES


def read_header(image):
    names = ["vmMagic", "instructionCount", "codeOffset", "codeLength", "dataOffset", "dataLength", "litLength", "bssLength"]
    return dict(zip(names, struct.unpack_from("<8i", image, 0)))


def write_map(path, targets):
    # Each line is "segment value name". The segment 0 is the code segment, and the value is an instruction number in hex.
    # VM_LoadSymbols skips the lines of any other segment.
    lines = ["0 %08x vmMain" % targets["vmMain"], "0 %08x helper" % targets["helper"], "1 00000000 g_word", "2 00000004 g_lit"]
    with open(path, "w", newline="\n") as handle:
        handle.write("\n".join(lines) + "\n")


class Machine:
    """This runs an image the way VM_PrepareInterpreter and VM_CallInterpreted do."""

    def __init__(self, image, syscall):
        header = read_header(image)
        self.syscall = syscall
        total = header["dataLength"] + header["litLength"] + header["bssLength"]
        size = 1
        while size < total:
            size <<= 1
        self.mask = size - 1
        self.memory = bytearray(size)
        initial = image[header["dataOffset"]:header["dataOffset"] + header["dataLength"] + header["litLength"]]
        self.memory[:len(initial)] = initial

        # The prepare walk records the byte offset of each instruction.
        code = image[header["codeOffset"]:header["codeOffset"] + header["codeLength"]]
        self.code = code
        self.pointers = []
        pc = 0
        for _ in range(header["instructionCount"]):
            self.pointers.append(pc)
            op = OPS[code[pc]]
            pc += 1
            if op in WIDE:
                pc += 4
            elif op == "ARG":
                pc += 1
        assert pc == header["codeLength"], "the prepare walk must consume the code exactly"
        self.program_stack_top = size

    def word(self, address):
        return struct.unpack_from("<i", self.memory, address & (self.mask & ~3))[0]

    def set_word(self, address, value):
        struct.pack_into("<i", self.memory, address & (self.mask & ~3), wrap(value))

    def call(self, args):
        args = list(args) + [0] * (10 - len(args))
        stack = [0]
        ps = self.program_stack_top - 48
        for k in range(10):
            self.set_word(ps + 8 + 4 * k, args[k])
        self.set_word(ps + 4, 0)
        self.set_word(ps, -1)
        pc = 0
        code = self.code
        used = set()

        def operand(at):
            return struct.unpack_from("<i", code, at)[0]

        while True:
            name = OPS[code[pc]]
            used.add(name)
            pc += 1
            if name == "CONST":
                stack.append(operand(pc))
                pc += 4
            elif name == "LOCAL":
                stack.append(wrap(operand(pc) + ps))
                pc += 4
            elif name == "LOAD4":
                stack[-1] = self.word(stack[-1])
            elif name == "LOAD1":
                stack[-1] = self.memory[stack[-1] & self.mask]
            elif name == "STORE4":
                self.set_word(stack[-2], stack[-1])
                del stack[-2:]
            elif name == "ARG":
                self.set_word(code[pc] + ps, stack.pop())
                pc += 1
            elif name == "CALL":
                self.set_word(ps, pc)
                target = stack.pop()
                if target < 0:
                    number = -1 - target
                    self.set_word(ps + 4, number)
                    parms = [self.word(ps + 4 + 4 * k) for k in range(5)]
                    stack.append(wrap(self.syscall(parms)))
                    pc = self.word(ps)
                else:
                    pc = self.pointers[target]
            elif name == "PUSH":
                stack.append(0)
            elif name == "POP":
                stack.pop()
            elif name == "ENTER":
                ps -= operand(pc)
                pc += 4
            elif name == "LEAVE":
                ps += operand(pc)
                pc = self.word(ps)
                if pc == -1:
                    assert len(stack) == 2, "the interpreter error: opStack must hold one value"
                    return stack[-1], used
            elif name == "JUMP":
                pc = self.pointers[stack.pop()]
            elif name in BRANCH:
                r0 = stack.pop()
                r1 = stack.pop()
                taken = {"EQ": r1 == r0, "NE": r1 != r0, "LTI": r1 < r0, "LEI": r1 <= r0, "GTI": r1 > r0, "GEI": r1 >= r0}[name]
                pc = self.pointers[operand(pc)] if taken else pc + 4
            elif name == "NEGI":
                stack[-1] = wrap(-stack[-1])
            elif name == "ADD":
                r0 = stack.pop()
                stack[-1] = wrap(stack[-1] + r0)
            elif name == "SUB":
                r0 = stack.pop()
                stack[-1] = wrap(stack[-1] - r0)
            elif name == "MULI":
                r0 = stack.pop()
                stack[-1] = wrap(stack[-1] * r0)
            elif name == "DIVI":
                r0 = stack.pop()
                stack[-1] = wrap(int(stack[-1] / r0))
            elif name == "BAND":
                r0 = stack.pop()
                stack[-1] = wrap(stack[-1] & r0)
            elif name == "SEX8":
                stack[-1] = ((stack[-1] & 0xFF) ^ 0x80) - 0x80
            else:
                raise AssertionError("the interpreter does not know " + name)


def wrap(value):
    return ((value + 0x80000000) & 0xFFFFFFFF) - 0x80000000


def main():
    program = build_program()
    code, count, targets, offsets = assemble(program)
    image = build_image(code, count)

    with open(os.path.join(HERE, "vmtest.qvm"), "wb") as handle:
        handle.write(image)
    write_map(os.path.join(HERE, "vmtest.map"), targets)

    # Read the header back from the written file and check it against vmHeader_t.
    with open(os.path.join(HERE, "vmtest.qvm"), "rb") as handle:
        written = handle.read()
    header = read_header(written)
    assert header["vmMagic"] == VM_MAGIC
    assert header["instructionCount"] == count == len(offsets)
    assert header["codeOffset"] == 32
    assert header["codeLength"] == len(code) > 0
    assert header["dataOffset"] == header["codeOffset"] + header["codeLength"]
    assert header["dataLength"] == 4 * len(DATA_WORDS)
    assert header["litLength"] == len(LIT_BYTES)
    assert header["bssLength"] == BSS_LENGTH >= 0
    assert len(written) == header["dataOffset"] + header["dataLength"] + header["litLength"]
    assert struct.unpack_from("<i", written, header["dataOffset"])[0] == DATA_WORDS[0]
    assert written[header["dataOffset"] + 4:] == LIT_BYTES
    assert targets["vmMain"] == 0

    print("header")
    for name, value in header.items():
        print("  %-16s %d (0x%x)" % (name, value, value & 0xFFFFFFFF))
    print("file size        %d" % len(written))
    print("symbols          " + ", ".join("%s=%d" % (name, targets[name]) for name in ("vmMain", "helper")))

    tests = [
        (0, 3, 4, 5), (0, -2, 10, 3),
        (1, 9, 4, 0), (1, 4, 9, 0), (1, 5, 5, 0),
        (2, 6, 7, 8),
        (3, 5, 2, 0),
        (4, 0, 0, 0), (4, 10, 0, 0),
        (5, 6, 0, 0),
        (6, 12, 10, 2),
        (7, 3, 3, 0), (7, 3, 4, 0),
        (8, 9, 4, 0), (8, 4, 9, 0),
        (9, 0x1FF, 0, 0), (9, 0x7F, 0, 0),
        (10, 1, 2, 3),
    ]

    def syscall(log):
        def run(parms):
            log.append(tuple(parms[:3]) if parms[0] == 2 else tuple(parms[:2]))
            if parms[0] == 1:
                return parms[1] * 10
            return parms[1] * 100 + parms[2]
        return run

    covered = set()
    print("command a b c -> return, syscalls (number, parameters)")
    for command, a, b, c in tests:
        log = []
        machine = Machine(written, syscall(log))
        value, used = machine.call([command, a, b, c])
        covered |= used
        print("  %d %d %d %d -> %d  %s" % (command, a, b, c, value, log))
    print("opcodes used (%d): %s" % (len(covered), " ".join(sorted(covered))))
    assert len(covered) >= 10


main()
