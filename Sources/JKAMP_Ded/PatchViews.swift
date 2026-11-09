import JKAShared

extension CGrid {
    /// Raven's `grid->points[i][j]`, the two-index `vec3_t points[MAX_GRID_SIZE][MAX_GRID_SIZE]` field, one row of `MAX_GRID_SIZE` points per first index.
    /// Source: oracle/codemp/qcommon/cm_patch.h:115
    // AI: Raven indexes the field with two indexes. The accessor gives one Slots of points per row, because the generated `points` holds only the first row.
    public var pointsRows: Slots<Slots<JKAShared.vec3_t>> {
        Slots(rows: self.points.base, count: Int(MAX_GRID_SIZE), stride: Int(MAX_GRID_SIZE) * self.points.stride) {
            Slots(vectors: $0, count: Int(MAX_GRID_SIZE))
        }
    }
}

extension PatchCollide {
    /// Raven's `pc->facets` that a body walks with `facet++`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_patch.cpp:1288
    // AI: Raven walks the `facet_t *` field as an array. The accessor gives the Slots over the records, the form of the generated `planesSlots`.
    public var facetsSlots: Slots<Facet> {
        precondition(self.facets != nil, "facets is NULL")
        return Slots(views: UnsafeMutableRawPointer(self.facets!.handle), count: Int.max, stride: Facet.stride)
    }
}
