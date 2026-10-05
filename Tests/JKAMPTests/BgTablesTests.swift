import JKATestSupport
import Testing
import JKAMP

/// The three tables of `BgTables.swift` read Raven's data out of the C storage of `Sources/CJKAMP/bg_tables.c`.
@Suite("Raven's tables read through the views")
struct BgTablesTests {
    @Test("bg_numItems counts the table without the end marker")
    func itemCount() {
        #expect(Int(bg_numItems) == bg_itemlist.count - 1)
        #expect(bg_numItems == 51)
    }

    @Test("The first item is the small instant shield Raven wrote")
    func firstItem() {
        // Source: oracle/codemp/game/bg_misc.c:822
        #expect(bg_itemlist[1].classname == "item_shield_sm_instant")
        // Source: oracle/codemp/game/bg_misc.c:829
        #expect(bg_itemlist[1].quantity == 25)
    }

    @Test("The Bryar pistol carries Raven's ammo index and fire time")
    func bryarPistol() {
        let bryar = weaponData[Int(WP_BRYAR_PISTOL)]
        // Source: oracle/codemp/game/bg_weapons.c:103
        #expect(bryar.ammoIndex == AMMO_BLASTER)
        // Source: oracle/codemp/game/bg_weapons.c:106
        #expect(bryar.fireTime == 800)
    }

    @Test("The ammo table has one slot per ammo kind")
    func ammoCount() {
        #expect(ammoData.count == Int(AMMO_MAX))
    }
}
