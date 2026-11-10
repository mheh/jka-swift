import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:12
let MAX_TOKEN_SIZE = 1024 as Int32

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:13
var token: JKAShared.CharBuf {
    get { world.variables.token }
    set { world.variables.token = newValue }
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:15
private func GetToken(_ text: inout JKAShared.TextCursor, _ allowLineBreaks: Bool, _ readUntilEOL: Bool = false) -> String {
    var pointer = text
    var length: Int32 = 0
    var c: Int32 = 0
    var foundLineBreak: Bool

    token[0] = 0
    if pointer.isNull {
        return String(token)
    }

    while true {
        foundLineBreak = false
        while true {
            c = pointer.byte
            if c > Int32(ascii: " ") {
                break
            }
            if c == 0 {
                text = TextCursor()
                return String(token)
            }
            if c == Int32(ascii: "\n") {
                foundLineBreak = true
            }
            pointer.advance()
        }
        if foundLineBreak && !allowLineBreaks {
            text = pointer
            return String(token)
        }

        c = pointer.byte

        // skip single line comment
        if c == Int32(ascii: "/") && pointer[1] == Int32(ascii: "/") {
            pointer.advance(by: 2)
            while pointer.byte != 0 && pointer.byte != Int32(ascii: "\n") {
                pointer.advance()
            }
        }
        // skip multi line comments
        else if c == Int32(ascii: "/") && pointer[1] == Int32(ascii: "*") {
            pointer.advance(by: 2)
            while pointer.byte != 0 && (pointer.byte != Int32(ascii: "*") || pointer[1] != Int32(ascii: "/")) {
                pointer.advance()
            }
            if pointer.byte != 0 {
                pointer.advance(by: 2)
            }
        } else {
            // found the start of a token
            break
        }
    }

    if c == Int32(ascii: "\"") {
        // handle a string
        pointer.advance()
        while true {
            c = pointer.byte
            pointer.advance()
            if c == Int32(ascii: "\"") {
                //				token[length++] = c;
                break
            } else if c == 0 {
                break
            } else if length < MAX_TOKEN_SIZE {
                token[length] = c
                length += 1
            }
        }
    } else if readUntilEOL {
        // absorb all characters until EOL
        // Port-note: Raven's loop reads past the NUL at the end of the text when the last line has no line break.
        // The loop also stops at the NUL.
        while c != Int32(ascii: "\n") && c != Int32(ascii: "\r") && c != 0 {
            if c == Int32(ascii: "/") && (pointer[1] == Int32(ascii: "/") || pointer[1] == Int32(ascii: "*")) {
                break
            }

            if length < MAX_TOKEN_SIZE {
                token[length] = c
                length += 1
            }
            pointer.advance()
            c = pointer.byte
        }
        // remove trailing white space
        while length != 0 && token[length - 1] < Int32(ascii: " ") {
            length -= 1
        }
    } else {
        while c > Int32(ascii: " ") {
            if length < MAX_TOKEN_SIZE {
                token[length] = c
                length += 1
            }
            pointer.advance()
            c = pointer.byte
        }
    }

    if token[0] == Int32(ascii: "\"") {
        // remove start quote
        length -= 1
        memmove(&token, 1, length, at: 0)

        if length != 0 && token[length - 1] == Int32(ascii: "\"") {
            // remove end quote
            length -= 1
        }
    }

    if length >= MAX_TOKEN_SIZE {
        length = 0
    }
    token[length] = 0
    text = pointer

    return String(token)
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:212
// TODO: Port signature
// Raven wrote: void CleanTextPool(CTextPool *pool)
// No table row for `CTextPool * pool`.
func CleanTextPool() -> Never {
    // TODO: Port CleanTextPool
    portMissing("CleanTextPool", source: "oracle/codemp/qcommon/GenericParser2.cpp:212")
}

// MARK: - CGPObject

/// Raven's `CGPObject::WriteText`, which writes one name or value into the text, in quotes when it holds a space or no text.
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:238
// AI: Raven's CGPObject has no Swift type under row C3 of the C++ docket. Its one method is a function of the file.
private func WriteText(_ textPool: inout String, _ text: String) -> Bool {
    if strchr(text, Int32(ascii: " ")) != nil || text.isEmpty {
        // AI: Raven appends to a chain of CTextPool blocks. The text pool is a String, and each AllocText is an append.
        textPool += "\""
        textPool += text
        textPool += "\""
    } else {
        textPool += text
    }

    return true
}

// MARK: - CGPValue

/// Raven's `CGPValue`, one key and the list of its values.
/// Row C3 of the C++ docket makes it a struct over `[String]`, so the `CGPObject` chain of the values is the array.
/// Source: oracle/codemp/qcommon/GenericParser2.h:68
// AI: Raven links each value as a `CGPObject` whose text lives in a CTextPool. The struct holds the name and the values as Strings.
struct CGPValue {
    var mName: String
    var mList: [String]

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:267
    init(_ initName: String, _ initValue: String? = nil) {
        self.mName = initName
        self.mList = []
        if let initValue {
            self.AddValue(initValue)
        }
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:53
    func GetName() -> String {
        self.mName
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:289
    // AI: Raven copies each text into the caller's CTextPool. A String is already a copy, so the pool parameter drops.
    func Duplicate() -> CGPValue {
        var newValue = CGPValue(self.mName)
        for iterator in self.mList {
            newValue.AddValue(iterator)
        }

        return newValue
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:323
    func IsList() -> Bool {
        if self.mList.count < 2 {
            return false
        }

        return true
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:333
    func GetTopValue() -> String? {
        if !self.mList.isEmpty {
            return self.mList[0]
        }

        return nil
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:83
    func GetList() -> [String] {
        self.mList
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:343
    // AI: Raven appends a CGPObject node at the tail that the head's in-order link holds. The array append is that step.
    mutating func AddValue(_ newValue: String) {
        self.mList.append(newValue)
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:362
    mutating func Parse(_ dataPtr: inout TextCursor) -> Bool {
        var token: String

        while true {
            token = GetToken(&dataPtr, true, true)

            if token.isEmpty {
                // end of data - error!
                return false
            } else if Q_stricmp(token, "]") == 0 {
                // ending brace for this list
                break
            }

            // AI: Raven copies the token into the CTextPool before AddValue. The String is the copy.
            self.AddValue(token)
        }

        return true
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:387
    func Write(_ textPool: inout String, _ depth: Int32) -> Bool {
        var i: Int32

        if self.mList.isEmpty {
            return true
        }

        i = 0
        while i < depth {
            // AI: Raven appends to a chain of CTextPool blocks. The text pool is a String, and each AllocText is an append.
            textPool += "\t"
            i += 1
        }

        _ = WriteText(&textPool, self.mName)

        if self.mList.count == 1 {
            textPool += "\t\t"
            _ = WriteText(&textPool, self.mList[0])
            textPool += "\r\n"
        } else {
            textPool += "\r\n"

            i = 0
            while i < depth {
                textPool += "\t"
                i += 1
            }
            textPool += "[\r\n"

            for next in self.mList {
                i = 0
                while i < depth + 1 {
                    textPool += "\t"
                    i += 1
                }
                _ = WriteText(&textPool, next)
                textPool += "\r\n"
            }

            i = 0
            while i < depth {
                textPool += "\t"
                i += 1
            }
            textPool += "]\r\n"
        }

        return true
    }
}

// MARK: - CGPGroup

/// Raven's `CGPGroup`, one named group of pairs and subgroups.
/// Row C3 of the C++ docket makes it a final class, so `GetParent` and the sibling walk through `GetNext` stay as Raven wrote them.
/// The pairs and the subgroups are arrays in the add order, and the `mInOrder` arrays hold the same items in name order.
/// Source: oracle/codemp/qcommon/GenericParser2.h:93
// AI: Raven links the pairs and subgroups through `mNext` and `mInOrderNext` and keeps the tail in `mCurrentPair` and `mCurrentSubGroup`.
// The arrays hold the two orders, and a subgroup keeps a weak `mNext` for the sibling walk.
final class CGPGroup {
    var mName: String
    weak var mNext: CGPGroup?
    var mPairs: [CGPValue] = []
    var mInOrderPairs: [CGPValue] = []
    var mSubGroups: [CGPGroup] = []
    var mInOrderSubGroups: [CGPGroup] = []
    weak var mParent: CGPGroup?
    var mWriteable = false

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:458
    init(_ initName: String = "Top Level", _ initParent: CGPGroup? = nil) {
        self.mName = initName
        self.mParent = initParent
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:53
    func GetName() -> String {
        self.mName
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:109
    func GetParent() -> CGPGroup? {
        self.mParent
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:110
    func GetNext() -> CGPGroup? {
        self.mNext
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:476
    // Port-note: Raven's do-while counts one and then reads through the NULL head when the group has no subgroup.
    // The count of an empty list is 0.
    func GetNumSubGroups() -> Int32 {
        Int32(self.mSubGroups.count)
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:493
    // Port-note: Raven's do-while counts one and then reads through the NULL head when the group has no pair.
    // The count of an empty list is 0.
    func GetNumPairs() -> Int32 {
        Int32(self.mPairs.count)
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:510
    // AI: Raven deletes each pair and subgroup through the chains. Emptying the arrays frees them.
    func Clean() {
        self.mPairs = []
        self.mInOrderPairs = []
        self.mSubGroups = []
        self.mInOrderSubGroups = []
        self.mParent = nil
        self.mWriteable = false
    }

    /// Raven's `Duplicate`, which builds the copy with no parent, because his constructor call passes only the name.
    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:532
    // AI: Raven copies each text into the caller's CTextPool. A String is already a copy, so the pool parameter drops.
    func Duplicate(_ initParent: CGPGroup? = nil) -> CGPGroup {
        let newGroup = CGPGroup(self.mName)

        for subSub in self.mSubGroups {
            let newSub = subSub.Duplicate(newGroup)
            newGroup.AddGroup(newSub)
        }

        for subPair in self.mPairs {
            let newPair = subPair.Duplicate()
            newGroup.AddPair(newPair)
        }

        return newGroup
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:115
    func SetWriteable(_ writeable: Bool) {
        self.mWriteable = writeable
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:116
    func GetPairs() -> [CGPValue] {
        self.mPairs
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:117
    func GetInOrderPairs() -> [CGPValue] {
        self.mInOrderPairs
    }

    /// Raven's head of the subgroup chain, which a caller walks with `GetNext`.
    /// Source: oracle/codemp/qcommon/GenericParser2.h:118
    func GetSubGroups() -> CGPGroup? {
        self.mSubGroups.first
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:119
    func GetInOrderSubGroups() -> [CGPGroup] {
        self.mInOrderSubGroups
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:570
    // AI: Raven links the object into the add chain and the name chain through CGPObject pointers.
    // The function appends to the add array and inserts into the name array before the first greater name.
    private func SortObject<Item>(_ object: Item, _ unsortedList: inout [Item], _ sortedList: inout [Item], _ name: (Item) -> String) {
        if unsortedList.isEmpty {
            unsortedList = [object]
            sortedList = [object]
        } else {
            unsortedList.append(object)

            var test = 0
            while test < sortedList.count {
                if Q_stricmp(name(object), name(sortedList[test])) < 0 {
                    break
                }

                test += 1
            }

            sortedList.insert(object, at: test)
        }
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:615
    // AI: Raven copies the name and the value into the CTextPool. A String is already a copy, so the pool parameter drops.
    @discardableResult
    func AddPair(_ name: String, _ value: String?) -> CGPValue {
        let newPair = CGPValue(name, value)

        self.AddPair(newPair)

        return newPair
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:635
    func AddPair(_ NewPair: CGPValue) {
        self.SortObject(NewPair, &self.mPairs, &self.mInOrderPairs) { $0.GetName() }
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:641
    // AI: Raven copies the name into the CTextPool. A String is already a copy, so the pool parameter drops.
    @discardableResult
    func AddGroup(_ name: String) -> CGPGroup {
        let newGroup = CGPGroup(name, self)

        self.AddGroup(newGroup)

        return newGroup
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:657
    func AddGroup(_ NewGroup: CGPGroup) {
        // Raven's SortObject sets `mNext` of the last subgroup to the new one.
        self.mSubGroups.last?.mNext = NewGroup
        self.SortObject(NewGroup, &self.mSubGroups, &self.mInOrderSubGroups) { $0.GetName() }
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:663
    func FindSubGroup(_ name: String) -> CGPGroup? {
        var group = self.GetSubGroups()
        while let current = group {
            if Q_stricmp(name, current.GetName()) == 0 {
                return current
            }
            group = current.GetNext()
        }
        return nil
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:679
    func Parse(_ dataPtr: inout TextCursor) -> Bool {
        var token: String
        var lastToken = CharBuf(MAX_TOKEN_SIZE)
        var newSubGroup: CGPGroup
        var newPair: CGPValue

        while true {
            token = GetToken(&dataPtr, true)

            if token.isEmpty {
                // end of data - error!
                if self.mParent != nil {
                    return false
                } else {
                    break
                }
            } else if Q_stricmp(token, "}") == 0 {
                // ending brace for this group
                break
            }

            strcpy(&lastToken, token)

            // read ahead to see what we are doing
            token = GetToken(&dataPtr, true, true)
            if Q_stricmp(token, "{") == 0 {
                // new sub group
                newSubGroup = self.AddGroup(String(lastToken))
                newSubGroup.SetWriteable(self.mWriteable)
                if !newSubGroup.Parse(&dataPtr) {
                    return false
                }
            } else if Q_stricmp(token, "[") == 0 {
                // new pair list
                // AI: Raven adds the pair and then fills its list through the pointer. The struct fills first, and the add follows.
                newPair = CGPValue(String(lastToken))
                let parsed = newPair.Parse(&dataPtr)
                self.AddPair(newPair)
                if !parsed {
                    return false
                }
            } else {
                // new pair
                self.AddPair(String(lastToken), token)
            }
        }

        return true
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:736
    func Write(_ textPool: inout String, _ depth: Int32) -> Bool {
        var i: Int32

        if depth >= 0 {
            i = 0
            while i < depth {
                // AI: Raven appends to a chain of CTextPool blocks. The text pool is a String, and each AllocText is an append.
                textPool += "\t"
                i += 1
            }
            _ = WriteText(&textPool, self.mName)
            textPool += "\r\n"

            i = 0
            while i < depth {
                textPool += "\t"
                i += 1
            }
            textPool += "{\r\n"
        }

        for mPair in self.mPairs {
            _ = mPair.Write(&textPool, depth + 1)
        }

        for mSubGroup in self.mSubGroups {
            _ = mSubGroup.Write(&textPool, depth + 1)
        }

        if depth >= 0 {
            i = 0
            while i < depth {
                textPool += "\t"
                i += 1
            }
            textPool += "}\r\n"
        }

        return true
    }

    /************************************************************************************************
     * CGPGroup::FindPair
     *    This function will search for the pair with the specified key name.  Multiple keys may be
     *    searched if you specify "||" inbetween each key name in the string.  The first key to be
     *    found (from left to right) will be returned.
     *
     * Input
     *    key: the name of the key(s) to be searched for.
     *
     * Output / Return
     *    the group belonging to the first key found or 0 if no group was found.
     *
     ************************************************************************************************/
    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:795
    func FindPair(_ key: String) -> CGPValue? {
        let key = CharBuf(key)
        var length: Int32
        var pos: Int32 = 0
        var next: Int32

        while key[pos] != 0 {
            if let separator = strstr(key[pos...], "||").map({ $0 + pos }) {
                length = separator - pos
                next = separator + 2
            } else {
                length = strlen(key[pos...])
                next = pos + length
            }

            for pair in self.mPairs {
                if strlen(pair.GetName()) == length && Q_stricmpn(pair.GetName(), String(key[pos...]), length) == 0 {
                    return pair
                }
            }

            pos = next
        }

        return nil
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:834
    func FindPairValue(_ key: String, _ defaultVal: String? = nil) -> String? {
        if let pair = self.FindPair(key) {
            return pair.GetTopValue()
        }

        return defaultVal
    }
}

// MARK: - CGenericParser2

/// Raven's `CGenericParser2`, the parse of one text into a tree of groups under `mTopLevel`.
/// Row C3 of the C++ docket makes it a final class that holds the top group, as Raven holds it by value.
/// Source: oracle/codemp/qcommon/GenericParser2.h:136
// AI: Raven also holds the CTextPool chain of the parse in `mTextPool`. The text lives in the Strings of the tree, so the field drops.
final class CGenericParser2 {
    var mTopLevel = CGPGroup()
    var mWriteable = false

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:860
    init() {}

    /// Source: oracle/codemp/qcommon/GenericParser2.h:149
    func SetWriteable(_ writeable: Bool) {
        self.mWriteable = writeable
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:150
    func GetBaseParseGroup() -> CGPGroup {
        self.mTopLevel
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:871
    func Parse(_ dataPtr: inout TextCursor, _ cleanFirst: Bool = true, _ writeable: Bool = false) -> Bool {
        if cleanFirst {
            self.Clean()
        }

        // AI: Raven allocates a CTextPool here when the parser has none. The text pool has no Swift type, so the step drops.
        self.SetWriteable(writeable)
        self.mTopLevel.SetWriteable(writeable)
        let ret = self.mTopLevel.Parse(&dataPtr)

        return ret
    }

    /// Raven's inline overload that takes the text pointer by value.
    /// Source: oracle/codemp/qcommon/GenericParser2.h:153
    func Parse(_ dataPtr: TextCursor, _ cleanFirst: Bool = true, _ writeable: Bool = false) -> Bool {
        var dataPtr = dataPtr
        return self.Parse(&dataPtr, cleanFirst, writeable)
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:903
    func Clean() {
        self.mTopLevel.Clean()

        // AI: Raven frees the CTextPool chain with CleanTextPool. The text pool has no Swift type, so the call drops.
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.cpp:911
    func Write(_ textPool: inout String) -> Bool {
        self.mTopLevel.Write(&textPool, -1)
    }
}

// The following groups of routines are used for a C interface into GP2.
// C++ users should just use the objects as normally and not call these routines below
//
// CGenericParser2 (void *) routines
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:928
// TODO: Port signature
// Raven wrote: TGenericParser2 GP_Parse(char **dataPtr, bool cleanFirst, bool writeable)
// No table row for the return `TGenericParser2`.
func GP_Parse() -> Never {
    // TODO: Port GP_Parse
    portMissing("GP_Parse", source: "oracle/codemp/qcommon/GenericParser2.cpp:928")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:942
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GP_Clean(_ GP2: OpaquePointer?) {
    // TODO: Port GP_Clean
    portMissing("GP_Clean", source: "oracle/codemp/qcommon/GenericParser2.cpp:942")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:952
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GP_Delete(_ GP2: inout OpaquePointer?) {
    // TODO: Port GP_Delete
    portMissing("GP_Delete", source: "oracle/codemp/qcommon/GenericParser2.cpp:952")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:963
// TODO: Port signature
// Raven wrote: TGPGroup GP_GetBaseParseGroup(TGenericParser2 GP2)
// No table row for the return `TGPGroup`.
func GP_GetBaseParseGroup() -> Never {
    // TODO: Port GP_GetBaseParseGroup
    portMissing("GP_GetBaseParseGroup", source: "oracle/codemp/qcommon/GenericParser2.cpp:963")
}

// CGPGroup (void *) routines
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:977
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPG_GetName(_ GPG: OpaquePointer?) -> String {
    // TODO: Port GPG_GetName
    portMissing("GPG_GetName", source: "oracle/codemp/qcommon/GenericParser2.cpp:977")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:987
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPG_GetName(_ GPG: OpaquePointer?, _ Value: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port GPG_GetName
    portMissing("GPG_GetName", source: "oracle/codemp/qcommon/GenericParser2.cpp:987")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:999
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetNext(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetNext() -> Never {
    // TODO: Port GPG_GetNext
    portMissing("GPG_GetNext", source: "oracle/codemp/qcommon/GenericParser2.cpp:999")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1009
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetInOrderNext(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetInOrderNext() -> Never {
    // TODO: Port GPG_GetInOrderNext
    portMissing("GPG_GetInOrderNext", source: "oracle/codemp/qcommon/GenericParser2.cpp:1009")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1019
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetInOrderPrevious(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetInOrderPrevious() -> Never {
    // TODO: Port GPG_GetInOrderPrevious
    portMissing("GPG_GetInOrderPrevious", source: "oracle/codemp/qcommon/GenericParser2.cpp:1019")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1029
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetPairs(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetPairs() -> Never {
    // TODO: Port GPG_GetPairs
    portMissing("GPG_GetPairs", source: "oracle/codemp/qcommon/GenericParser2.cpp:1029")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1039
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetInOrderPairs(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetInOrderPairs() -> Never {
    // TODO: Port GPG_GetInOrderPairs
    portMissing("GPG_GetInOrderPairs", source: "oracle/codemp/qcommon/GenericParser2.cpp:1039")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1049
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetSubGroups(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetSubGroups() -> Never {
    // TODO: Port GPG_GetSubGroups
    portMissing("GPG_GetSubGroups", source: "oracle/codemp/qcommon/GenericParser2.cpp:1049")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1059
// TODO: Port signature
// Raven wrote: TGPGroup GPG_GetInOrderSubGroups(TGPGroup GPG)
// No table row for the return `TGPGroup`.
func GPG_GetInOrderSubGroups() -> Never {
    // TODO: Port GPG_GetInOrderSubGroups
    portMissing("GPG_GetInOrderSubGroups", source: "oracle/codemp/qcommon/GenericParser2.cpp:1059")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1069
// TODO: Port signature
// Raven wrote: TGPGroup GPG_FindSubGroup(TGPGroup GPG, const char *name)
// No table row for the return `TGPGroup`.
func GPG_FindSubGroup() -> Never {
    // TODO: Port GPG_FindSubGroup
    portMissing("GPG_FindSubGroup", source: "oracle/codemp/qcommon/GenericParser2.cpp:1069")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1079
// TODO: Port signature
// Raven wrote: TGPValue GPG_FindPair(TGPGroup GPG, const char *key)
// No table row for the return `TGPValue`.
func GPG_FindPair() -> Never {
    // TODO: Port GPG_FindPair
    portMissing("GPG_FindPair", source: "oracle/codemp/qcommon/GenericParser2.cpp:1079")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1089
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPG_FindPairValue(_ GPG: OpaquePointer?, _ key: String, _ defaultVal: String) -> String {
    // TODO: Port GPG_FindPairValue
    portMissing("GPG_FindPairValue", source: "oracle/codemp/qcommon/GenericParser2.cpp:1089")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1099
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPG_FindPairValue(_ GPG: OpaquePointer?, _ key: String, _ defaultVal: String, _ Value: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port GPG_FindPairValue
    portMissing("GPG_FindPairValue", source: "oracle/codemp/qcommon/GenericParser2.cpp:1099")
}

// CGPValue (void *) routines
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1110
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPV_GetName(_ GPV: OpaquePointer?) -> String {
    // TODO: Port GPV_GetName
    portMissing("GPV_GetName", source: "oracle/codemp/qcommon/GenericParser2.cpp:1110")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1120
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPV_GetName(_ GPV: OpaquePointer?, _ Value: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port GPV_GetName
    portMissing("GPV_GetName", source: "oracle/codemp/qcommon/GenericParser2.cpp:1120")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1132
// TODO: Port signature
// Raven wrote: TGPValue GPV_GetNext(TGPValue GPV)
// No table row for the return `TGPValue`.
func GPV_GetNext() -> Never {
    // TODO: Port GPV_GetNext
    portMissing("GPV_GetNext", source: "oracle/codemp/qcommon/GenericParser2.cpp:1132")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1142
// TODO: Port signature
// Raven wrote: TGPValue GPV_GetInOrderNext(TGPValue GPV)
// No table row for the return `TGPValue`.
func GPV_GetInOrderNext() -> Never {
    // TODO: Port GPV_GetInOrderNext
    portMissing("GPV_GetInOrderNext", source: "oracle/codemp/qcommon/GenericParser2.cpp:1142")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1152
// TODO: Port signature
// Raven wrote: TGPValue GPV_GetInOrderPrevious(TGPValue GPV)
// No table row for the return `TGPValue`.
func GPV_GetInOrderPrevious() -> Never {
    // TODO: Port GPV_GetInOrderPrevious
    portMissing("GPV_GetInOrderPrevious", source: "oracle/codemp/qcommon/GenericParser2.cpp:1152")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1162
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPV_IsList(_ GPV: OpaquePointer?) -> Bool {
    // TODO: Port GPV_IsList
    portMissing("GPV_IsList", source: "oracle/codemp/qcommon/GenericParser2.cpp:1162")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1172
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPV_GetTopValue(_ GPV: OpaquePointer?) -> String {
    // TODO: Port GPV_GetTopValue
    portMissing("GPV_GetTopValue", source: "oracle/codemp/qcommon/GenericParser2.cpp:1172")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1182
// Port-note: Rule 20. No file of oracle/codemp calls this function, so it keeps its marker.
func GPV_GetTopValue(_ GPV: OpaquePointer?, _ Value: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port GPV_GetTopValue
    portMissing("GPV_GetTopValue", source: "oracle/codemp/qcommon/GenericParser2.cpp:1182")
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1195
// TODO: Port signature
// Raven wrote: TGPValue GPV_GetList(TGPValue GPV)
// No table row for the return `TGPValue`.
func GPV_GetList() -> Never {
    // TODO: Port GPV_GetList
    portMissing("GPV_GetList", source: "oracle/codemp/qcommon/GenericParser2.cpp:1195")
}
