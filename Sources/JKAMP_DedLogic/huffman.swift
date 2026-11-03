import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/huffman.cpp:10
var bloc: Int32 {
    get { world.variables.bloc }
    set { world.variables.bloc = newValue }
}

/// Source: oracle/codemp/qcommon/huffman.cpp:12
func Huff_putBit(_ bit: Int32, _ fout: UnsafeMutableRawPointer, _ offset: inout Int32) {
    bloc = offset
    if (bloc & 7) == 0 {
        fout[byte: (bloc >> 3)] = 0
    }
    fout[byte: (bloc >> 3)] |= bit << (bloc & 7)
    bloc += 1
    offset = bloc
}

/// Source: oracle/codemp/qcommon/huffman.cpp:22
func Huff_getBit(_ fin: UnsafeMutableRawPointer, _ offset: inout Int32) -> Int32 {
    let t: Int32
    bloc = offset
    t = (fin[byte: (bloc >> 3)] >> (bloc & 7)) & 0x1
    bloc += 1
    offset = bloc
    return t
}

/**
```
Add a bit to the output file (buffered)
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:32
private func add_bit(_ bit: CChar, _ fout: UnsafeMutableRawPointer) {
    if (bloc & 7) == 0 {
        fout[byte: (bloc >> 3)] = 0
    }
    fout[byte: (bloc >> 3)] |= bit << (bloc & 7)
    bloc += 1
}

/**
```
Receive one bit from the input file (buffered)
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:41
private func get_bit(_ fin: UnsafeMutableRawPointer) -> Int32 {
    let t: Int32
    t = (fin[byte: (bloc >> 3)] >> (bloc & 7)) & 0x1
    bloc += 1
    return t
}

/// Source: oracle/codemp/qcommon/huffman.cpp:48
// TODO: Port signature
// Raven wrote: static node_t **get_ppnode(huff_t* huff)
// No table row for the return `node_t **`.
// Port-note: Raven returns the address of a `nodePtrs` slot, or the head of the free list that he links through those slots.
// The `head` and `freelist` fields are `OpaquePointer?`, and a logic body has no read or write through them. Open row R-B.
private func get_ppnode() -> Never {
    // TODO: Port get_ppnode
    portMissing("get_ppnode", source: "oracle/codemp/qcommon/huffman.cpp:48")
}

/// Source: oracle/codemp/qcommon/huffman.cpp:59
// Port-note: Raven's `ppnode` is the address of a `nodePtrs` slot, which he stores into the slot and links as the free list head.
// The `inout Node?` signature has no slot address, and the body has no form until open row R-B is ruled.
private func free_ppnode(_ huff: Huff, _ ppnode: inout Node?) {
    // TODO: Port free_ppnode
    portMissing("free_ppnode", source: "oracle/codemp/qcommon/huffman.cpp:59")
}

/**
```
Swap the location of these two nodes in the tree
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:65
private func swap(_ huff: Huff, _ node1: Node, _ node2: Node) {
    var par1: Node?
    var par2: Node?

    par1 = node1.parent
    par2 = node2.parent

    if par1 != nil {
        if par1!.left == node1 {
            par1!.left = node2
        } else {
            par1!.right = node2
        }
    } else {
        huff.tree = node2
    }

    if par2 != nil {
        if par2!.left == node2 {
            par2!.left = node1
        } else {
            par2!.right = node1
        }
    } else {
        huff.tree = node1
    }

    node1.parent = par2
    node2.parent = par1
}

/**
```
Swap these two nodes in the linked list (update ranks)
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:96
private func swaplist(_ node1: Node, _ node2: Node) {
    var par1: Node?

    par1 = node1.next
    node1.next = node2.next
    node2.next = par1

    par1 = node1.prev
    node1.prev = node2.prev
    node2.prev = par1

    if node1.next == node1 {
        node1.next = node2
    }
    if node2.next == node2 {
        node2.next = node1
    }
    if node1.next != nil {
        node1.next!.prev = node1
    }
    if node2.next != nil {
        node2.next!.prev = node2
    }
    if node1.prev != nil {
        node1.prev!.next = node1
    }
    if node2.prev != nil {
        node2.prev!.next = node2
    }
}

/**
```
Do the increments
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:128
private func increment(_ huff: Huff, _ node: Node?) {
    var lnode: Node?

    if node == nil {
        return
    }

    if node!.next != nil && node!.next!.weight == node!.weight {
        // Port-note: Raven reads the `nodePtrs` slot that `head` points at. Open row R-B.
        // Raven wrote: lnode = *node->head;
        portMissing("increment", source: "oracle/codemp/qcommon/huffman.cpp:128")
        if lnode != node!.parent {
            swap(huff, lnode!, node!)
        }
        swaplist(lnode!, node!)
    }
    if node!.prev != nil && node!.prev!.weight == node!.weight {
        // Port-note: Raven writes the `nodePtrs` slot that `head` points at. Open row R-B.
        // Raven wrote: *node->head = node->prev;
        portMissing("increment", source: "oracle/codemp/qcommon/huffman.cpp:128")
    } else {
        // Port-note: Raven clears the `nodePtrs` slot that `head` points at and frees the slot. Open row R-B.
        // Raven wrote: *node->head = NULL; free_ppnode(huff, node->head);
        portMissing("increment", source: "oracle/codemp/qcommon/huffman.cpp:128")
    }
    node!.weight += 1
    if node!.next != nil && node!.next!.weight == node!.weight {
        node!.head = node!.next!.head
    } else {
        // Port-note: Raven takes a `nodePtrs` slot and writes the node into it. Open row R-B.
        // Raven wrote: node->head = get_ppnode(huff); *node->head = node;
        portMissing("increment", source: "oracle/codemp/qcommon/huffman.cpp:128")
    }
    if node!.parent != nil {
        increment(huff, node!.parent)
        if node!.prev == node!.parent {
            swaplist(node!, node!.parent!)
            // Port-note: Raven reads and writes the `nodePtrs` slot that `head` points at. Open row R-B.
            // Raven wrote: if (*node->head == node) { *node->head = node->parent; }
            portMissing("increment", source: "oracle/codemp/qcommon/huffman.cpp:128")
        }
    }
}

/// Source: oracle/codemp/qcommon/huffman.cpp:166
func Huff_addRef(_ huff: Huff, _ ch: Int32) {
    var tnode: Node?
    var tnode2: Node?
    if huff.loc[ch] == nil { /* if this is the first transmission of this node */
        tnode = huff.nodeList[huff.blocNode]
        huff.blocNode += 1
        tnode2 = huff.nodeList[huff.blocNode]
        huff.blocNode += 1

        tnode2!.symbol = INTERNAL_NODE
        tnode2!.weight = 1
        tnode2!.next = huff.lhead!.next
        if huff.lhead!.next != nil {
            huff.lhead!.next!.prev = tnode2
            if huff.lhead!.next!.weight == 1 {
                tnode2!.head = huff.lhead!.next!.head
            } else {
                // Port-note: Raven takes a `nodePtrs` slot and writes the node into it. Open row R-B.
                // Raven wrote: tnode2->head = get_ppnode(huff); *tnode2->head = tnode2;
                portMissing("Huff_addRef", source: "oracle/codemp/qcommon/huffman.cpp:166")
            }
        } else {
            // Port-note: Raven takes a `nodePtrs` slot and writes the node into it. Open row R-B.
            // Raven wrote: tnode2->head = get_ppnode(huff); *tnode2->head = tnode2;
            portMissing("Huff_addRef", source: "oracle/codemp/qcommon/huffman.cpp:166")
        }
        huff.lhead!.next = tnode2
        tnode2!.prev = huff.lhead

        tnode!.symbol = ch
        tnode!.weight = 1
        tnode!.next = huff.lhead!.next
        if huff.lhead!.next != nil {
            huff.lhead!.next!.prev = tnode
            if huff.lhead!.next!.weight == 1 {
                tnode!.head = huff.lhead!.next!.head
            } else {
                /* this should never happen */
                // Port-note: Raven takes a `nodePtrs` slot and writes a node into it. Open row R-B.
                // Raven wrote: tnode->head = get_ppnode(huff); *tnode->head = tnode2;
                portMissing("Huff_addRef", source: "oracle/codemp/qcommon/huffman.cpp:166")
            }
        } else {
            /* this should never happen */
            // Port-note: Raven takes a `nodePtrs` slot and writes the node into it. Open row R-B.
            // Raven wrote: tnode->head = get_ppnode(huff); *tnode->head = tnode;
            portMissing("Huff_addRef", source: "oracle/codemp/qcommon/huffman.cpp:166")
        }
        huff.lhead!.next = tnode
        tnode!.prev = huff.lhead
        tnode!.right = nil
        tnode!.left = tnode!.right

        if huff.lhead!.parent != nil {
            if huff.lhead!.parent!.left == huff.lhead { /* lhead is guaranteed to by the NYT */
                huff.lhead!.parent!.left = tnode2
            } else {
                huff.lhead!.parent!.right = tnode2
            }
        } else {
            huff.tree = tnode2
        }

        tnode2!.right = tnode
        tnode2!.left = huff.lhead

        tnode2!.parent = huff.lhead!.parent
        tnode!.parent = tnode2
        huff.lhead!.parent = tnode!.parent

        huff.loc[ch] = tnode

        increment(huff, tnode2!.parent)
    } else {
        increment(huff, huff.loc[ch])
    }
}

/**
```
Get a symbol
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:236
func Huff_Receive(_ node: Node, _ ch: inout Int32, _ fin: UnsafeMutableRawPointer) -> Int32 {
    // Raven assigns his own `node` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var node: Node? = node
    while node != nil && node!.symbol == INTERNAL_NODE {
        if get_bit(fin) != 0 {
            node = node!.right
        } else {
            node = node!.left
        }
    }
    if node == nil {
        return 0
//		Com_Error(ERR_DROP, "Illegal tree!\n");
    }
    ch = node!.symbol
    return (ch)
}

/**
```
Get a symbol
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:252
func Huff_offsetReceive(_ node: Node, _ ch: inout Int32, _ fin: UnsafeMutableRawPointer, _ offset: inout Int32) {
    // Raven assigns his own `node` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var node: Node? = node
    bloc = offset
    while node != nil && node!.symbol == INTERNAL_NODE {
        if get_bit(fin) != 0 {
            node = node!.right
        } else {
            node = node!.left
        }
    }
    if node == nil {
        ch = 0
        return
//		Com_Error(ERR_DROP, "Illegal tree!\n");
    }
    ch = node!.symbol
    offset = bloc
}

/**
```
Send the prefix code for this node
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:271
private func send(_ node: Node, _ child: Node?, _ fout: UnsafeMutableRawPointer) {
    if node.parent != nil {
        send(node.parent!, node, fout)
    }
    if child != nil {
        if node.right == child {
            add_bit(1, fout)
        } else {
            add_bit(0, fout)
        }
    }
}

/**
```
Send a symbol
```
*/
/// Source: oracle/codemp/qcommon/huffman.cpp:285
func Huff_transmit(_ huff: Huff, _ ch: Int32, _ fout: UnsafeMutableRawPointer) {
    var i: Int32
    if huff.loc[ch] == nil {
        /* node_t hasn't been transmitted, send a NYT, then the symbol */
        Huff_transmit(huff, NYT, fout)
        i = 7
        while i >= 0 {
            add_bit(CChar(((ch >> i) & 0x1)), fout)
            i -= 1
        }
    } else {
        send(huff.loc[ch]!, nil, fout)
    }
}

/// Source: oracle/codemp/qcommon/huffman.cpp:298
func Huff_offsetTransmit(_ huff: Huff, _ ch: Int32, _ fout: UnsafeMutableRawPointer, _ offset: inout Int32) {
    bloc = offset
    send(huff.loc[ch]!, nil, fout)
    offset = bloc
}

/// Source: oracle/codemp/qcommon/huffman.cpp:304
func Huff_Decompress(_ mbuf: Msg, _ offset: Int32) {
    var ch: Int32 = 0
    var cch: Int32 = 0
    var i: Int32 = 0
    var j: Int32 = 0
    var size: Int32 = 0
    var seq: [UInt8] = [UInt8](repeating: 0, count: 65536)
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Huff.scratch { huff -> Bool in

        size = mbuf.cursize - offset
        // Raven walks the message's bytes through `buffer`, and the raw pointer over the `data` field is that walk, under rule 11.
        let buffer: UnsafeMutableRawPointer = UnsafeMutableRawPointer(mbuf.data!) + offset

        if size <= 0 {
            return true
        }

        // Initialize the tree & list with the NYT node
        huff.loc[NYT] = huff.nodeList[huff.blocNode]
        huff.blocNode += 1
        huff.ltail = huff.loc[NYT]
        huff.lhead = huff.ltail
        huff.tree = huff.lhead
        huff.tree!.symbol = NYT
        huff.tree!.weight = 0
        huff.lhead!.prev = nil
        huff.lhead!.next = huff.lhead!.prev
        huff.tree!.right = nil
        huff.tree!.left = huff.tree!.right
        huff.tree!.parent = huff.tree!.left

        cch = Int32(buffer[byte: 0] as UInt8) * 256 + Int32(buffer[byte: 1] as UInt8)
        // don't overflow with bad messages
        if cch > mbuf.maxsize - offset {
            cch = mbuf.maxsize - offset
        }
        bloc = 16

        j = 0
        while j < cch {
            ch = 0
            // don't overflow reading from the messages
            // FIXME: would it be better to have a overflow check in get_bit ?
            if (bloc >> 3) > size {
                seq[j] = 0
                break
            }
            _ = Huff_Receive(huff.tree!, &ch, buffer) /* Get a character */
            if ch == NYT { /* We got a NYT, get the symbol associated with it */
                ch = 0
                i = 0
                while i < 8 {
                    ch = (ch << 1) + get_bit(buffer)
                    i += 1
                }
            }

            seq[j] = UInt8(truncatingIfNeeded: ch) /* Write symbol */

            Huff_addRef(huff, Int32(ch)) /* Increment node */
            j += 1
        }
        mbuf.cursize = cch + offset
        // Port-note: Raven copies his `byte seq[65536]` local into the message's bytes, and a `[UInt8]` has no raw copy. Open row R-A.
        // Raven wrote: Com_Memcpy(mbuf->data + offset, seq, cch);
        portMissing("Huff_Decompress", source: "oracle/codemp/qcommon/huffman.cpp:304")
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/qcommon/huffman.cpp:358
func Huff_Compress(_ mbuf: Msg, _ offset: Int32) {
    var i: Int32 = 0
    var ch: Int32 = 0
    var size: Int32 = 0
    var seq: [UInt8] = [UInt8](repeating: 0, count: 65536)
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Huff.scratch { huff -> Bool in

        size = mbuf.cursize - offset
        // Raven walks the message's bytes through `buffer`, and the raw pointer over the `data` field is that walk, under rule 11.
        let buffer: UnsafeMutableRawPointer = UnsafeMutableRawPointer(mbuf.data!) + offset

        if size <= 0 {
            return true
        }

        // Add the NYT (not yet transmitted) node into the tree/list */
        huff.loc[NYT] = huff.nodeList[huff.blocNode]
        huff.blocNode += 1
        huff.lhead = huff.loc[NYT]
        huff.tree = huff.lhead
        huff.tree!.symbol = NYT
        huff.tree!.weight = 0
        huff.lhead!.prev = nil
        huff.lhead!.next = huff.lhead!.prev
        huff.tree!.right = nil
        huff.tree!.left = huff.tree!.right
        huff.tree!.parent = huff.tree!.left
        huff.loc[NYT] = huff.tree

        seq[0] = UInt8(truncatingIfNeeded: (size >> 8))
        seq[1] = UInt8(truncatingIfNeeded: size & 0xff)

        bloc = 16

        i = 0
        while i < size {
            ch = Int32(buffer[byte: i] as UInt8)
            // Port-note: Raven hands his `byte seq[65536]` local to the `byte *` of Huff_transmit, and a `[UInt8]` has no raw pointer. Open row R-A.
            // Raven wrote: Huff_transmit(&huff, ch, seq);
            portMissing("Huff_Compress", source: "oracle/codemp/qcommon/huffman.cpp:358")
            Huff_addRef(huff, Int32(ch)) /* Do update */
            i += 1
        }

        bloc += 8 // next byte

        mbuf.cursize = (bloc >> 3) + offset
        // Port-note: Raven copies his `byte seq[65536]` local into the message's bytes, and a `[UInt8]` has no raw copy. Open row R-A.
        // Raven wrote: Com_Memcpy(mbuf->data+offset, seq, (bloc>>3));
        portMissing("Huff_Compress", source: "oracle/codemp/qcommon/huffman.cpp:358")
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/qcommon/huffman.cpp:397
func Huff_Init(_ huff: Huffman) {
    huff.compressor.clear()
    huff.decompressor.clear()

    // Initialize the tree & list with the NYT node
    huff.decompressor.loc[NYT] = huff.decompressor.nodeList[huff.decompressor.blocNode]
    huff.decompressor.blocNode += 1
    huff.decompressor.ltail = huff.decompressor.loc[NYT]
    huff.decompressor.lhead = huff.decompressor.ltail
    huff.decompressor.tree = huff.decompressor.lhead
    huff.decompressor.tree!.symbol = NYT
    huff.decompressor.tree!.weight = 0
    huff.decompressor.lhead!.prev = nil
    huff.decompressor.lhead!.next = huff.decompressor.lhead!.prev
    huff.decompressor.tree!.right = nil
    huff.decompressor.tree!.left = huff.decompressor.tree!.right
    huff.decompressor.tree!.parent = huff.decompressor.tree!.left

    // Add the NYT (not yet transmitted) node into the tree/list */
    huff.compressor.loc[NYT] = huff.compressor.nodeList[huff.compressor.blocNode]
    huff.compressor.blocNode += 1
    huff.compressor.lhead = huff.compressor.loc[NYT]
    huff.compressor.tree = huff.compressor.lhead
    huff.compressor.tree!.symbol = NYT
    huff.compressor.tree!.weight = 0
    huff.compressor.lhead!.prev = nil
    huff.compressor.lhead!.next = huff.compressor.lhead!.prev
    huff.compressor.tree!.right = nil
    huff.compressor.tree!.left = huff.compressor.tree!.right
    huff.compressor.tree!.parent = huff.compressor.tree!.left
    huff.compressor.loc[NYT] = huff.compressor.tree
}
