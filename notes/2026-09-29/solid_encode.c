// solid_encode.c shows the three-byte box of entityState_t.solid, as the oracle packs and unpacks it.
// Build and run: cc -o solid_encode solid_encode.c && ./solid_encode
#include <stdio.h>

typedef float vec3_t[3];
typedef struct { int solid; } entityState_t;                   // q_shared.h, the wire field of 24 bits (msg.cpp:892)
typedef struct { vec3_t mins, maxs; } entityShared_t;           // g_public.h:69, the float box the server traces
typedef struct { entityState_t s; entityShared_t r; } gentity_t;

// codemp/server/sv_world.cpp:194-231, with the 1..255 clamps removed.
// The int locals truncate the float box, and only maxs[0] stands for x and y.
static void SV_LinkEntity_encode(gentity_t *gEnt) {
    int i, j, k;
    i = gEnt->r.maxs[0];
    j = (-gEnt->r.mins[2]);
    k = (gEnt->r.maxs[2] + 32);
    gEnt->s.solid = (k << 16) | (j << 8) | i;
}

// codemp/cgame/cg_predict.c:218-260.
// The client rebuilds an integer box that is square and centered in x and y.
static void CG_ClipMoveToEntities_decode(const entityState_t *ent, vec3_t bmins, vec3_t bmaxs) {
    int x = (ent->solid & 255), zd = ((ent->solid >> 8) & 255), zu = ((ent->solid >> 16) & 255) - 32;
    bmins[0] = bmins[1] = -x; bmaxs[0] = bmaxs[1] = x; bmins[2] = -zd; bmaxs[2] = zu;
}

// A 16-unit breakable box scaled by modelscale, as code/game/g_breakable.cpp:1210-1220 scales it.
static void run(const char *label, float modelscale) {
    gentity_t ent = { { 0 }, { { -16, -16, -16 }, { 16, 16, 16 } } };
    vec3_t bmins, bmaxs;
    for (int a = 0; a < 3; a++) { ent.r.mins[a] *= modelscale; ent.r.maxs[a] *= modelscale; }
    SV_LinkEntity_encode(&ent);
    CG_ClipMoveToEntities_decode(&ent.s, bmins, bmaxs);
    printf("%-7s scale %.2f  server maxs[0] %5.2f  client %5.2f  gap %.2f\n",
           label, modelscale, ent.r.maxs[0], bmaxs[0], ent.r.maxs[0] - bmaxs[0]);
}

int main(void) {
    run("ok", 1.5f);       // 24.0 survives, because the scaled box is integer-sized.
    run("chopped", 1.3f);  // 20.8 becomes 20, so the client walks 0.8 units into the box.
    run("chopped", 2.1f);  // 33.6 becomes 33, the cast drops the fraction and does not round.
    return 0;
}
