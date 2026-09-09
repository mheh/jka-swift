import JKAMP

/// This target holds the ported bodies of Raven's bg_*.c files, the code the game and cgame modules share.
/// It imports the MP views and no C module, so it carries no pointer code.
/// It fills file by file during body porting, under rule 13.
