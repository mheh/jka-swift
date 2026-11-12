/// This type records the skin and sound registrations of the saberload dumper, and it gives out the same handles.
/// The sound table lives for the whole run, as an engine configstring table does, and the two name logs restart for each saber.
///
/// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:169
public final class SaberLoadRegistrations {
    /// This is the dumper's `CS_SOUNDS_MAX`, the size of the sound table.
    /// Slot 0 is never a sound, so a full table has 255 names.
    static let soundSlotCount = 256

    /// These are the sizes of the dumper's two name logs, `g_snd[512]` and `g_skn[64]`.
    static let soundLogCount = 512
    static let skinLogCount = 64

    private var sounds: [String] = []
    private var skins: [(handle: Int32, name: String)] = []
    private var skinCounter: Int32 = 0
    private var soundTable: [String] = []

    public init() {}
}

// MARK: - The registrations

extension SaberLoadRegistrations {
    /// This is the dumper's `reg_reset`, which clears the two name logs and the skin counter before each saber.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:172
    public func resetForSaber() {
        self.sounds = []
        self.skins = []
        self.skinCounter = 0
    }

    /// This is the dumper's `G_SoundIndex`, which logs the name and returns its slot in the sound table.
    /// A new name takes the next slot from 1, the same name gets the same slot again, and an empty name gets 0.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:182
    public func soundIndex(_ name: String) -> Int32 {
        if self.sounds.count < Self.soundLogCount {
            self.sounds.append(name)
        }
        guard !name.isEmpty else { return 0 }
        if let index = self.soundTable.firstIndex(of: name) {
            return Int32(index + 1)
        }
        guard self.soundTable.count < Self.soundSlotCount - 1 else {
            fatalError("G_FindConfigstringIndex: overflow")
        }
        self.soundTable.append(name)
        return Int32(self.soundTable.count)
    }

    /// This is the dumper's `trap_R_RegisterSkin`, which logs the name and returns the next value of the skin counter.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:199
    public func registerSkin(_ name: String) -> Int32 {
        self.skinCounter += 1
        if self.skins.count < Self.skinLogCount {
            self.skins.append((handle: self.skinCounter, name: name))
        }
        return self.skinCounter
    }
}

// MARK: - The dump

extension SaberLoadRegistrations {
    /// This prints the `regskin` lines and then the `regsound` lines of one saber, as the end of `dump_saber` does.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:296
    public var lines: String {
        var out = ""
        for skin in self.skins {
            out += "regskin \(skin.handle) \"\(skin.name)\"\n"
        }
        for sound in self.sounds {
            out += "regsound \"\(sound)\"\n"
        }
        return out
    }
}
