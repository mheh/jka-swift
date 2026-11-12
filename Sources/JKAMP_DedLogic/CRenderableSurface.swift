import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's renderable Ghoul2 surface, the surface data and the bone cache that `RB_SurfaceGhoul` draws, with the gore values.
/// `RenderSurfaces` of tr_ghoul2.cpp makes one per drawn surface.
/// Source: oracle/codemp/renderer/tr_local.h:2047
public final class CRenderableSurface {
    var ident: Int32 = 0
    var boneCache: CBoneCache? = nil
    var surfaceData: MdxmSurface? = nil	// pointer to surface data loaded into file - only used by client renderer DO NOT USE IN GAME SIDE - if there is a vid restart this will be out of wack on the game
    var alternateTex: Slots<Float>? = nil		// alternate texture coordinates.
    var goreChain: OpaquePointer? = nil

    var scale: Float = 0
    var fade: Float = 0
    var impactTime: Float = 0 // this is a number between 0 and 1 that dictates the progression of the bullet impact

    /// Source: oracle/codemp/renderer/tr_local.h:2067
    // AI: Raven defines `operator=`. The method is `copy`.
    @discardableResult
    func copy(_ src: CRenderableSurface) -> CRenderableSurface {
        // Raven's one use is in RenderSurfaces at tr_ghoul2.cpp:2661, under `#ifndef DEDICATED`, so the method is dead in the dedicated build.
        self.ident = src.ident
        self.boneCache = src.boneCache
        self.surfaceData = src.surfaceData
        self.alternateTex = src.alternateTex
        self.goreChain = src.goreChain

        return self
    }

    /// Source: oracle/codemp/renderer/tr_local.h:2079
    init() {
        self.ident = SF_MDX
        self.boneCache = nil
        self.surfaceData = nil
        self.alternateTex = nil
        self.goreChain = nil
    }

    /// Source: oracle/codemp/renderer/tr_local.h:2092
    func Init() {
        // Raven's one call is in AllocRS at tr_ghoul2.cpp:872, which is dead in the dedicated build, so the method is dead too.
        self.ident = SF_MDX
        self.boneCache = nil
        self.surfaceData = nil
        self.alternateTex = nil
        self.goreChain = nil
    }
}
