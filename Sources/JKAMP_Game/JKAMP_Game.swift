internal import CJKAMP_Game
@_exported import JKAMP

/// This target holds the game module views: Entity, Client, Level, and the typed trap functions of g_syscalls.c.
/// It is the only Swift target that imports CJKAMP_Game, so no Raven prototype reaches the logic target.
/// The generated views of `gentity_t`, `gclient_t`, `level_locals_t`, and every struct they reach live under `Generated/Views`.
/// `GameStorage` holds the C memory of every struct table and record Raven kept at file scope, the entity table and the level record among them.
