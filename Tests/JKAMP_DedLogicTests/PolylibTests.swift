import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the port of `cm_polylib.cpp` on the base winding of the plane z = 0.
/// `AllocWinding` and `FreeWinding` go through `Z_Malloc` and `Z_Free`, so each test builds a fresh world for a fresh zone.
@Suite(.serialized)
struct PolylibSuite {
    @Test("the base winding of a plane has four points, a positive area, and the plane of the input")
    func baseWindingKeepsThePlane() {
        world = EngineWorld()
        let normal = vec3_t(0, 0, 1)

        // given the base winding of the plane z = 0
        let w = BaseWindingForPlane(normal, 0)!

        // then it has four points and a positive area
        #expect(w.numpoints == 4)
        #expect(WindingArea(w) > 0)

        // then its plane is the input plane
        var planeNormal = vec3_t()
        var planeDist: Float = 0
        WindingPlane(w, &planeNormal, &planeDist)
        #expect(abs(planeNormal.x - normal.x) < 1e-3)
        #expect(abs(planeNormal.y - normal.y) < 1e-3)
        #expect(abs(planeNormal.z - normal.z) < 1e-3)
        #expect(abs(planeDist) < 1e-3)
    }

    @Test("a chop through the origin halves the area of the base winding")
    func chopHalvesTheArea() {
        world = EngineWorld()

        // given the base winding of the plane z = 0
        var w = BaseWindingForPlane(vec3_t(0, 0, 1), 0)
        let area = WindingArea(w!)

        // when the plane x = 0 chops it
        ChopWindingInPlace(&w, vec3_t(1, 0, 0), 0, 0.1)

        // then the half that stays has half the area, as a ratio within 1e-3
        #expect(abs(WindingArea(w!) / area - 0.5) < 1e-3)
    }
}
