@preconcurrency internal import CJKAMP
import JKAShared

/// Raven's item table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_misc.c:795
public nonisolated(unsafe) let bg_itemlist: Slots<Gitem> = makeItemList()

/// The item count Raven computes, which is one less than the table, because the last slot is the end marker.
/// Source: oracle/codemp/game/bg_misc.c:1771
public let bg_numItems: Int32 = CJKAMP.bg_numItems

/// Raven's muzzle offset table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// The three components of a row are forward, right, and up.
/// Source: oracle/codemp/game/bg_weapons.c:10
public nonisolated(unsafe) let WP_MuzzlePoint: Slots<JKAShared.vec3_t> = makeWPMuzzlePoint()

/// Raven's per-weapon table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_weapons.c:31
public nonisolated(unsafe) let weaponData: Slots<WeaponData> = makeWeaponData()

/// Raven's per-ammo table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_weapons.c:358
public nonisolated(unsafe) let ammoData: Slots<AmmoData> = makeAmmoData()

/// Raven's saber move table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saber.c:120
public nonisolated(unsafe) let saberMoveData: Slots<SaberMoveData> = makeSaberMoveData()

/// Raven's animation name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/cgame/animtable.h:9
public nonisolated(unsafe) let animTable: Slots<StringIDTable> = makeAnimTable()

/// Raven's saber type name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saberLoad.c:46
public nonisolated(unsafe) let SaberTable: Slots<StringIDTable> = makeSaberTable()

/// Raven's saber move name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saberLoad.c:63
public nonisolated(unsafe) let SaberMoveTable: Slots<StringIDTable> = makeSaberMoveTable()

/// Raven's siege class flag name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:45
public nonisolated(unsafe) let bgSiegeClassFlagNames: Slots<StringIDTable> = makeBgSiegeClassFlagNames()

/// Raven's saber stance name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:59
public nonisolated(unsafe) let StanceTable: Slots<StringIDTable> = makeStanceTable()

/// Raven's weapon name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:73
public nonisolated(unsafe) let WPTable: Slots<StringIDTable> = makeWPTable()

/// Raven's force power name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:100
public nonisolated(unsafe) let FPTable: Slots<StringIDTable> = makeFPTable()

/// Raven's holdable item name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:123
public nonisolated(unsafe) let HoldableTable: Slots<StringIDTable> = makeHoldableTable()

/// Raven's powerup name table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_saga.c:142
public nonisolated(unsafe) let PowerupTable: Slots<StringIDTable> = makePowerupTable()

/// Raven's vehicle weapon field table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_vehicleLoad.c:138
public nonisolated(unsafe) let vehWeaponFields: Slots<VehField> = makeVehWeaponFields()

/// Raven's vehicle field table, over the C storage of `Sources/CJKAMP/bg_tables.c`.
/// Source: oracle/codemp/game/bg_vehicleLoad.c:445
public nonisolated(unsafe) let vehicleFields: Slots<VehField> = makeVehicleFields()

// MARK: - The bind over each C array

/// The compiler crashes if a global initializer takes the address inline, so each table binds in a function.
private func makeItemList() -> Slots<Gitem> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.bg_itemlist) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.bg_itemlist) / Gitem.stride
    return Slots(views: base, count: count, stride: Gitem.stride)
}

private func makeWPMuzzlePoint() -> Slots<JKAShared.vec3_t> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.WP_MuzzlePoint) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.WP_MuzzlePoint) / MemoryLayout<(Float, Float, Float)>.stride
    return Slots(vectors: base, count: count)
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

private func makeSaberMoveData() -> Slots<SaberMoveData> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.saberMoveData) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.saberMoveData) / SaberMoveData.stride
    return Slots(views: base, count: count, stride: SaberMoveData.stride)
}

private func makeAnimTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.animTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.animTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeSaberTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.SaberTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.SaberTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeSaberMoveTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.SaberMoveTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.SaberMoveTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeBgSiegeClassFlagNames() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.bgSiegeClassFlagNames) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.bgSiegeClassFlagNames) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeStanceTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.StanceTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.StanceTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeWPTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.WPTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.WPTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeFPTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.FPTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.FPTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeHoldableTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.HoldableTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.HoldableTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makePowerupTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.PowerupTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.PowerupTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeVehWeaponFields() -> Slots<VehField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.vehWeaponFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.vehWeaponFields) / VehField.stride
    return Slots(views: base, count: count, stride: VehField.stride)
}

private func makeVehicleFields() -> Slots<VehField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP.vehicleFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP.vehicleFields) / VehField.stride
    return Slots(views: base, count: count, stride: VehField.stride)
}
