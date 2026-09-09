// PROTOTYPE, throwaway. Bare Raven functions over the views. This target never sees a Raven prototype or a C type.

import GameWorldPrototypeViews

// MARK: - Bare Raven functions

/// A slice of `G_Spawn`: the first free slot after the client slots.
/// Source: oracle/codemp/game/g_utils.c, G_Spawn
func G_Spawn() -> Entity {
    for index in GameWorld.maxClients..<GameWorld.maxEntities {
        let ent = g_entities[index]
        if ent.inuse { continue }
        ent.inuse = true
        ent.health = 100
        ent.classname = "noclass"
        if Int32(index) >= level.num_entities { level.num_entities = Int32(index) + 1 }
        return ent
    }
    fatalError("G_Spawn: no free entities")
}

/// Source: oracle/codemp/game/g_utils.c, G_FreeEntity
func G_FreeEntity(_ ent: Entity) {
    ent.inuse = false
    ent.classname = "freed"
    ent.enemy = nil
    ent.think = nil
    ent.nextthink = 0
    // Any entity that pointed at this one now points at nothing.
    for other in g_entities where other.enemy == ent {
        other.enemy = nil
    }
}

/// Source: oracle/codemp/game/g_main.c, G_RunThink
func G_RunThink(_ ent: Entity) {
    guard ent.nextthink > 0, ent.nextthink <= level.time else { return }
    ent.nextthink = 0
    guard let think = ent.think else { return }
    think(ent.handle)
}

/// A slice of `G_RunFrame`: the clock and the think pass.
/// Source: oracle/codemp/game/g_main.c, G_RunFrame
func G_RunFrame(_ levelTime: Int32) {
    level.framenum += 1
    level.time = levelTime
    for ent in g_entities where ent.inuse {
        G_RunThink(ent)
    }
}

// MARK: - Think functions

// A think function stored in the C field has the C shape. The first line makes the view.

/// Frees the entity, the shape Raven uses for timed removal.
func Think_Free(_ handle: OpaquePointer?) {
    let ent = Entity(handle: handle!)
    G_FreeEntity(ent)
}

/// Damages the enemy and rearms. Two views of two different entities are live in one call.
func Think_HitEnemy(_ handle: OpaquePointer?) {
    let ent = Entity(handle: handle!)
    guard let enemy = ent.enemy else { return }
    enemy.health -= 10
    ent.origin += SIMD3(1, 0, 0)
    ent.nextthink = level.time + 100
    if enemy.health <= 0 { G_FreeEntity(enemy) }
}
