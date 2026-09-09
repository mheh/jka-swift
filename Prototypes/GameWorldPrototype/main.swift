// PROTOTYPE, throwaway. The terminal shell over the views and the logic.
// Run: swift run GameWorldPrototype

import Foundation
import GameWorldPrototypeViews

let bold = "\u{1B}[1m"
let dim = "\u{1B}[2m"
let reset = "\u{1B}[0m"

var lastSpawned: Entity?
var message = "ready"

func thinkName(_ ent: Entity) -> String {
    guard let think = ent.think else { return "-" }
    let key = unsafeBitCast(think, to: UnsafeRawPointer.self)
    return world.thinkNames[key] ?? "?"
}

func register(_ name: String, _ function: ThinkFunction) {
    world.thinkNames[unsafeBitCast(function, to: UnsafeRawPointer.self)] = name
}

@MainActor func render() {
    print("\u{1B}[2J\u{1B}[H", terminator: "")
    print("\(bold)GameWorld prototype\(reset)  \(dim)gentity_t stride \(GameWorld.entityStride)  level_locals_t \(GameWorld.levelSize)\(reset)")
    print("\(bold)level\(reset)  time \(level.time)  framenum \(level.framenum)  num_entities \(level.num_entities)")
    print("\(bold)pool\(reset)   \(world.stringPool.count) strings")
    print()
    print("\(bold) num  classname     health  nextthink  enemy  think            origin\(reset)")
    for ent in g_entities where ent.inuse {
        let enemy = ent.enemy.map { String($0.number) } ?? "-"
        let line = String(
            format: "%4d  %-12@  %6d  %9d  %5@  %-16@ %@",
            ent.number,
            ent.classname ?? "-",
            ent.health,
            ent.nextthink,
            enemy,
            thinkName(ent),
            "\(ent.origin)"
        )
        print(line)
    }
    print()
    print("\(dim)\(message)\(reset)")
    print()
    print("\(bold)[s]\(reset)\(dim) spawn  \(reset)\(bold)[e]\(reset)\(dim) last.enemy = first  \(reset)\(bold)[h]\(reset)\(dim) last.think = HitEnemy  \(reset)\(bold)[d]\(reset)\(dim) last.think = Free  \(reset)\(bold)[f]\(reset)\(dim) frame +100ms  \(reset)\(bold)[k]\(reset)\(dim) free last  \(reset)\(bold)[q]\(reset)\(dim) quit\(reset)")
}

func firstInUse() -> Entity? { g_entities.first { $0.inuse } }

register("Think_Free", Think_Free)
register("Think_HitEnemy", Think_HitEnemy)

render()
while let line = readLine() {
    switch line.trimmingCharacters(in: .whitespaces) {
    case "s":
        let ent = G_Spawn()
        ent.classname = "info_proto_\(ent.number)"
        ent.origin = SIMD3(Float(ent.number), 0, 0)
        lastSpawned = ent
        message = "spawned \(ent.number)"

    case "e":
        if let last = lastSpawned, let first = firstInUse(), first != last {
            last.enemy = first
            message = "\(last.number).enemy = \(first.number)"
        } else {
            message = "need two entities"
        }

    case "h":
        if let last = lastSpawned {
            last.think = Think_HitEnemy
            last.nextthink = level.time + 100
            message = "\(last.number).think = Think_HitEnemy at \(last.nextthink)"
        }

    case "d":
        if let last = lastSpawned {
            last.think = Think_Free
            last.nextthink = level.time + 100
            message = "\(last.number).think = Think_Free at \(last.nextthink)"
        }

    case "f":
        G_RunFrame(level.time + 100)
        message = "frame \(level.framenum) at \(level.time)"

    case "k":
        if let last = lastSpawned {
            G_FreeEntity(last)
            message = "freed \(last.number)"
            lastSpawned = firstInUse()
        }

    case "q":
        exit(0)

    default:
        message = "unknown key"
    }
    render()
}
