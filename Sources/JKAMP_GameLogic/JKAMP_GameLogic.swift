import JKAMP_Game
import JKAMP_BG

/// This target holds the ported bodies of Raven's g_*.c files and the one GameWorld instance.
/// It imports the view targets and no C module, so every Raven global reads as a property over that instance.
/// It fills file by file during body porting, under rule 13.
