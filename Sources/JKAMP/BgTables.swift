@preconcurrency internal import CJKAMP
import JKAShared

/// Raven's item table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_misc.c:795
public nonisolated(unsafe) let bg_itemlist: Slots<Gitem> = makeItemList()

/// The item count Raven computes, which is one less than the table, because the last slot is the end marker.
/// Source: oracle/codemp/game/bg_misc.c:1771
public let bg_numItems: Int32 = CJKAMP.bg_numItems

/// Raven's per-weapon table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_weapons.c:31
public nonisolated(unsafe) let weaponData: Slots<WeaponData> = makeWeaponData()

/// Raven's per-ammo table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_weapons.c:358
public nonisolated(unsafe) let ammoData: Slots<AmmoData> = makeAmmoData()

// MARK: - The bind over each C array

/// The compiler crashes if a global initializer takes the address inline, so each table binds in a function.
private func makeItemList() -> Slots<Gitem> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.bg_itemlist) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.bg_itemlist) / Gitem.stride
    return Slots(views: base, count: count, stride: Gitem.stride)
}

private func makeWeaponData() -> Slots<WeaponData> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.weaponData) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.weaponData) / WeaponData.stride
    return Slots(views: base, count: count, stride: WeaponData.stride)
}

private func makeAmmoData() -> Slots<AmmoData> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.ammoData) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.ammoData) / AmmoData.stride
    return Slots(views: base, count: count, stride: AmmoData.stride)
}
