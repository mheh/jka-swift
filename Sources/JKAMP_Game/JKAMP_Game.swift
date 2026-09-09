internal import CJKAMP_Game
import JKAMP

/// This target holds the game module views: Entity, Client, Level, and the typed trap functions of g_syscalls.c.
/// It is the only Swift target that imports CJKAMP_Game, so no Raven prototype reaches the logic target.
/// Vet row 5 fills it with the generated views.
