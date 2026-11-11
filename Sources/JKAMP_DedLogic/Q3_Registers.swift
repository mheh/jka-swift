import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:9
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var varStrings: [String: String] {
    get { world.varStrings }
    set { world.varStrings = newValue }
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:10
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var varFloats: [String: Float] {
    get { world.varFloats }
    set { world.varFloats = newValue }
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:11
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var varVectors: [String: String] {
    get { world.varVectors }
    set { world.varVectors = newValue }
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:13
public var numVariables: Int32 {
    get { world.variables.numVariables }
    set { world.variables.numVariables = newValue }
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:21
public func Q3_VariableDeclared(_ name: String) -> Int32 {
    //Check the strings
    if varStrings[name] != nil {
        return VTYPE_STRING
    }

    //Check the floats
    if varFloats[name] != nil {
        return VTYPE_FLOAT
    }

    //Check the vectors
    if varVectors[name] != nil {
        return VTYPE_VECTOR
    }

    return VTYPE_NONE
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:50
public func Q3_DeclareVariable(_ type: Int32, _ name: String) {
    //Cannot declare the same variable twice
    if Q3_VariableDeclared(name) != VTYPE_NONE {
        return
    }

    if numVariables > MAX_VARIABLES {
        Q3_DebugPrint(WL_ERROR, "too many variables already declared, maximum is %d\n", MAX_VARIABLES)
        return
    }

    switch type {
    case TK_FLOAT:
        varFloats[name] = 0.0

    case TK_STRING:
        varStrings[name] = "NULL"

    case TK_VECTOR:
        varVectors[name] = "0.0 0.0 0.0"

    default:
        Q3_DebugPrint(WL_ERROR, "unknown 'type' for declare() function!\n")
        return
    }

    numVariables += 1
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:91
public func Q3_FreeVariable(_ name: String) {
    //Check the strings
    if varStrings[name] != nil {
        varStrings[name] = nil
        numVariables -= 1
        return
    }

    //Check the floats
    if varFloats[name] != nil {
        varFloats[name] = nil
        numVariables -= 1
        return
    }

    //Check the strings
    if varVectors[name] != nil {
        varVectors[name] = nil
        numVariables -= 1
        return
    }
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:130
@discardableResult
public func Q3_GetFloatVariable(_ name: String, _ value: inout Float) -> Int32 {
    //Check the floats
    if let vfi = varFloats[name] {
        value = vfi
        return 1
    }

    return 0
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:150
public func Q3_GetStringVariable(_ name: String, _ value: inout JKAShared.TextCursor) -> Int32 {
    //Check the strings
    if let vsi = varStrings[name] {
        value = JKAShared.TextCursor(JKAShared.CharBuf(vsi))
        return 1
    }

    return 0
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:170
public func Q3_GetVectorVariable(_ name: String, _ value: inout JKAShared.vec3_t) -> Int32 {
    //Check the strings
    if let vvi = varVectors[name] {
        let str = vvi

        sscanf(str, "%f %f %f", &value)
        return 1
    }

    return 0
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:192
public func Q3_InitVariables() {
    varStrings.removeAll()
    varFloats.removeAll()
    varVectors.removeAll()

    if numVariables > 0 {
        Q3_DebugPrint(WL_WARNING, "%d residual variables found!\n", numVariables)
    }

    numVariables = 0
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:210
@discardableResult
public func Q3_SetFloatVariable(_ name: String, _ value: Float) -> Int32 {
    //Check the floats
    if varFloats[name] == nil {
        return VTYPE_FLOAT
    }

    varFloats[name] = value

    return 1
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:229
@discardableResult
public func Q3_SetStringVariable(_ name: String, _ value: String) -> Int32 {
    //Check the strings
    if varStrings[name] == nil {
        return 0
    }

    varStrings[name] = value

    return 1
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:248
@discardableResult
public func Q3_SetVectorVariable(_ name: String, _ value: String) -> Int32 {
    //Check the strings
    if varVectors[name] == nil {
        return 0
    }

    varVectors[name] = value

    return 1
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:267
public func Q3_VariableSaveFloats(_ fmap: inout [String: Float]) {
    return
        /*
        int numFloats = fmap.size();
        gi.AppendToSaveGame( 'FVAR', &numFloats, sizeof( numFloats ) );

        varFloat_m::iterator    vfi;
        STL_ITERATE( vfi, fmap )
        {
            //Save out the map id
            int    idSize = strlen( ((*vfi).first).c_str() );

            //Save out the real data
            gi.AppendToSaveGame( 'FIDL', &idSize, sizeof( idSize ) );
            gi.AppendToSaveGame( 'FIDS', (void *) ((*vfi).first).c_str(), idSize );

            //Save out the float value
            gi.AppendToSaveGame( 'FVAL', &((*vfi).second), sizeof( float ) );
        }
        */
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:296
public func Q3_VariableSaveStrings(_ smap: inout [String: String]) {
    return
        /*
        int numStrings = smap.size();
        gi.AppendToSaveGame( 'SVAR', &numStrings, sizeof( numStrings ) );

        varString_m::iterator    vsi;
        STL_ITERATE( vsi, smap )
        {
            //Save out the map id
            int    idSize = strlen( ((*vsi).first).c_str() );

            //Save out the real data
            gi.AppendToSaveGame( 'SIDL', &idSize, sizeof( idSize ) );
            gi.AppendToSaveGame( 'SIDS', (void *) ((*vsi).first).c_str(), idSize );

            //Save out the string value
            idSize = strlen( ((*vsi).second).c_str() );

            gi.AppendToSaveGame( 'SVSZ', &idSize, sizeof( idSize ) );
            gi.AppendToSaveGame( 'SVAL', (void *) ((*vsi).second).c_str(), idSize );
        }
        */
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:328
public func Q3_VariableSave() -> Int32 {
    Q3_VariableSaveFloats(&varFloats)
    Q3_VariableSaveStrings(&varStrings)
    Q3_VariableSaveStrings(&varVectors)

    return 1
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:343
public func Q3_VariableLoadFloats(_ fmap: inout [String: Float]) {
    return
        /*
        int        numFloats;
        char    tempBuffer[1024];

        gi.ReadFromSaveGame( 'FVAR', &numFloats, sizeof( numFloats ) );

        for ( int i = 0; i < numFloats; i++ )
        {
            int idSize;

            gi.ReadFromSaveGame( 'FIDL', &idSize, sizeof( idSize ) );
            gi.ReadFromSaveGame( 'FIDS', &tempBuffer, idSize );
            tempBuffer[ idSize ] = 0;

            float    val;

            gi.ReadFromSaveGame( 'FVAL', &val, sizeof( float ) );

            Q3_DeclareVariable( TK_FLOAT, (const char *) &tempBuffer );
            Q3_SetFloatVariable( (const char *) &tempBuffer, val );
        }
        */
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:376
public func Q3_VariableLoadStrings(_ type: Int32, _ fmap: inout [String: String]) {
    return
        /*
        int        numFloats;
        char    tempBuffer[1024];
        char    tempBuffer2[1024];

        gi.ReadFromSaveGame( 'SVAR', &numFloats, sizeof( numFloats ) );

        for ( int i = 0; i < numFloats; i++ )
        {
            int idSize;

            gi.ReadFromSaveGame( 'SIDL', &idSize, sizeof( idSize ) );
            gi.ReadFromSaveGame( 'SIDS', &tempBuffer, idSize );
            tempBuffer[ idSize ] = 0;

            gi.ReadFromSaveGame( 'SVSZ', &idSize, sizeof( idSize ) );
            gi.ReadFromSaveGame( 'SVAL', &tempBuffer2, idSize );
            tempBuffer2[ idSize ] = 0;

            switch ( type )
            {
            case TK_STRING:
                Q3_DeclareVariable( TK_STRING, (const char *) &tempBuffer );
                Q3_SetStringVariable( (const char *) &tempBuffer, (const char *) &tempBuffer2 );
                break;

            case TK_VECTOR:
                Q3_DeclareVariable( TK_VECTOR, (const char *) &tempBuffer );
                Q3_SetVectorVariable( (const char *) &tempBuffer, (const char *) &tempBuffer2 );
                break;
            }
        }
        */
}

/// Source: oracle/codemp/icarus/Q3_Registers.cpp:420
public func Q3_VariableLoad() -> Int32 {
    Q3_InitVariables()

    Q3_VariableLoadFloats(&varFloats)
    Q3_VariableLoadStrings(TK_STRING, &varStrings)
    Q3_VariableLoadStrings(TK_VECTOR, &varVectors)

    return 0
}
