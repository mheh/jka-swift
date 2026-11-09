import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the port of `GenericParser2.cpp` on a small terrain text of the shape that `cm_terrain.cpp` reads.
/// `GetToken` writes the file-scope `token` buffer of the world, so each test builds a fresh world.
@Suite(.serialized)
struct GenericParser2Suite {
    @Test("a parse gives the groups in file order, the pairs by key, and a value list")
    func parseGivesGroupsPairsAndLists() {
        world = EngineWorld()
        let text = """
            terrain
            {
            \t// a comment
            \taltitudetexture
            \t{
            \t\theight\t\t64
            \t\tshader\t\t"textures/rock one"
            \t}
            \twater
            \t{
            \t\theight\t\t8
            \t}
            \tmodels
            \t[
            \t\tbirch
            \t\toak
            \t]
            }
            """
        let parser = CGenericParser2()

        // when the parser reads the text
        let parsed = parser.Parse(TextCursor(CharBuf(text)))

        // then the top group holds one class with two subgroups in file order
        #expect(parsed)
        let classes = parser.GetBaseParseGroup().GetSubGroups()!
        #expect(classes.GetName() == "terrain")
        let items = classes.GetSubGroups()!
        #expect(items.GetName() == "altitudetexture")
        #expect(items.GetNext()!.GetName() == "water")
        #expect(items.GetNext()!.GetNext() == nil)
        #expect(classes.GetNumSubGroups() == 2)

        // then the pairs read by key, with the quotes gone and the default for a missing key
        #expect(items.FindPairValue("height", "0") == "64")
        #expect(items.FindPairValue("shader", "") == "textures/rock one")
        #expect(items.FindPairValue("missing||height", "0") == "64")
        #expect(items.FindPairValue("missing", "0") == "0")

        // then the bracket list is one pair with two values
        let models = classes.FindPair("models")!
        #expect(models.IsList())
        #expect(models.GetList() == ["birch", "oak"])
    }

    @Test("a group with no closing brace fails the parse")
    func unclosedGroupFails() {
        world = EngineWorld()
        let parser = CGenericParser2()

        // when the text ends inside a subgroup
        let parsed = parser.Parse(TextCursor(CharBuf("outer\n{\n\tkey value\n")))

        // then the parse fails, as Raven's does for a subgroup at the end of the data
        #expect(!parsed)
    }
}
