internal import CJKAMP_Game
@_exported import JKAMP

/// This target holds the game module views: Entity, Client, Level, and the typed trap functions of g_syscalls.c.
/// It is the only Swift target that imports CJKAMP_Game, so no Raven prototype reaches the logic target.
/// The generated views of `gentity_t`, `gclient_t`, `level_locals_t`, and every struct they reach live under `Generated/Views`.
/// `GameMemory` holds the C memory of the two tables and the level record.
