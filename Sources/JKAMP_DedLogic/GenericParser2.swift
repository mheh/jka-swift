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
// Raven wrote: void CleanTextPool(CTextPool *pool)
// Not ported: row C3 makes the text pool a String, so the chain it frees does not exist, and CGenericParser2::Clean drops the call.

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
// The arrays hold the two orders, and a subgroup keeps a weak `mNext`, `mInOrderNext`, and `mInOrderPrevious` for the sibling walks.
final class CGPGroup {
    var mName: String
    weak var mNext: CGPGroup?
    weak var mInOrderNext: CGPGroup?
    weak var mInOrderPrevious: CGPGroup?
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

    /// Source: oracle/codemp/qcommon/GenericParser2.h:58
    func GetInOrderNext() -> CGPGroup? {
        self.mInOrderNext
    }

    /// Source: oracle/codemp/qcommon/GenericParser2.h:60
    func GetInOrderPrevious() -> CGPGroup? {
        self.mInOrderPrevious
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

        // Raven's SortObject links the new subgroup to its neighbors in name order, at GenericParser2.cpp:596 to :606.
        let index = self.mInOrderSubGroups.firstIndex { $0 === NewGroup }!
        if index + 1 < self.mInOrderSubGroups.count {
            let test = self.mInOrderSubGroups[index + 1]
            test.mInOrderPrevious = NewGroup
            NewGroup.mInOrderNext = test
        }
        if index > 0 {
            let last = self.mInOrderSubGroups[index - 1]
            last.mInOrderNext = NewGroup
            NewGroup.mInOrderPrevious = last
        }
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
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GP_Parse(_ dataPtr: inout JKAShared.TextCursor, _ cleanFirst: Bool, _ writeable: Bool) -> CGenericParser2? {
    let parse: CGenericParser2

    parse = CGenericParser2()
    if parse.Parse(&dataPtr, cleanFirst, writeable) {
        return parse
    }

    // AI: Raven deletes the parser here. The return of nil releases the class, and the release frees its tree.
    return nil
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:942
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GP_Clean(_ GP2: CGenericParser2?) {
    guard let GP2 else {
        return
    }

    GP2.Clean()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:952
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GP_Delete(_ GP2: inout CGenericParser2?) {
    if GP2 == nil {
        return
    }

    // AI: Raven deletes the parser and then clears the handle. The store of nil releases the class, and the release frees its tree.
    GP2 = nil
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:963
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GP_GetBaseParseGroup(_ GP2: CGenericParser2?) -> CGPGroup? {
    guard let GP2 else {
        return nil
    }

    return GP2.GetBaseParseGroup()
}

// CGPGroup (void *) routines
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:977
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetName(_ GPG: CGPGroup?) -> String {
    guard let GPG else {
        return ""
    }

    return GPG.GetName()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:987
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetName(_ GPG: CGPGroup?, _ Value: inout JKAShared.CharBuf) -> Bool {
    guard let GPG else {
        Value[0] = 0
        return false
    }

    strcpy(&Value, GPG.GetName())
    return true
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:999
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetNext(_ GPG: CGPGroup?) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.GetNext()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1009
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetInOrderNext(_ GPG: CGPGroup?) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.GetInOrderNext()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1019
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetInOrderPrevious(_ GPG: CGPGroup?) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.GetInOrderPrevious()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1029
// Raven wrote: TGPGroup GPG_GetPairs(TGPGroup GPG)
// Not ported: C3 makes the value list an Array, so the chain does not exist.

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1039
// Raven wrote: TGPGroup GPG_GetInOrderPairs(TGPGroup GPG)
// Not ported: C3 makes the value list an Array, so the chain does not exist.

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1049
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetSubGroups(_ GPG: CGPGroup?) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.GetSubGroups()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1059
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_GetInOrderSubGroups(_ GPG: CGPGroup?) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.GetInOrderSubGroups().first
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1069
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_FindSubGroup(_ GPG: CGPGroup?, _ name: String) -> CGPGroup? {
    guard let GPG else {
        return nil
    }

    return GPG.FindSubGroup(name)
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1079
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_FindPair(_ GPG: CGPGroup?, _ key: String) -> CGPValue? {
    guard let GPG else {
        return nil
    }

    return GPG.FindPair(key)
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1089
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_FindPairValue(_ GPG: CGPGroup?, _ key: String, _ defaultVal: String) -> String? {
    guard let GPG else {
        return defaultVal
    }

    return GPG.FindPairValue(key, defaultVal)
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1099
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPG_FindPairValue(_ GPG: CGPGroup?, _ key: String, _ defaultVal: String, _ Value: inout JKAShared.CharBuf) -> Bool {
    // Port-note: Rule 19. Raven's strcpy reads through NULL when the pair holds an empty list, so the unwrap traps there.
    strcpy(&Value, GPG_FindPairValue(GPG, key, defaultVal)!)

    return true
}

// CGPValue (void *) routines
/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1110
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPV_GetName(_ GPV: CGPValue?) -> String {
    guard let GPV else {
        return ""
    }

    return GPV.GetName()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1120
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPV_GetName(_ GPV: CGPValue?, _ Value: inout JKAShared.CharBuf) -> Bool {
    guard let GPV else {
        Value[0] = 0
        return false
    }

    strcpy(&Value, GPV.GetName())
    return true
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1132
// Raven wrote: TGPValue GPV_GetNext(TGPValue GPV)
// Not ported: C3 makes the value list an Array, so the chain does not exist.

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1142
// Raven wrote: TGPValue GPV_GetInOrderNext(TGPValue GPV)
// Not ported: C3 makes the value list an Array, so the chain does not exist.

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1152
// Raven wrote: TGPValue GPV_GetInOrderPrevious(TGPValue GPV)
// Not ported: C3 makes the value list an Array, so the chain does not exist.

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1162
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPV_IsList(_ GPV: CGPValue?) -> Bool {
    guard let GPV else {
        return false
    }

    return GPV.IsList()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1172
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPV_GetTopValue(_ GPV: CGPValue?) -> String? {
    guard let GPV else {
        return ""
    }

    return GPV.GetTopValue()
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1182
// Port-note: Rule 20. No file of oracle/codemp calls this function.
func GPV_GetTopValue(_ GPV: CGPValue?, _ Value: inout JKAShared.CharBuf) -> Bool {
    guard let GPV else {
        Value[0] = 0
        return false
    }

    // Port-note: Rule 19. Raven's strcpy reads through NULL when the value holds an empty list, so the unwrap traps there.
    strcpy(&Value, GPV.GetTopValue()!)

    return true
}

/// Source: oracle/codemp/qcommon/GenericParser2.cpp:1195
// Raven wrote: TGPValue GPV_GetList(TGPValue GPV)
// Not ported: C3 makes the value list an Array, so the chain does not exist.
