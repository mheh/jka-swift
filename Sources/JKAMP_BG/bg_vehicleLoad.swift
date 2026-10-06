import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_vehicleLoad.c:72
let MAX_VEH_WEAPON_DATA_SIZE = 0x20000 as Int32

/// Source: oracle/codemp/game/bg_vehicleLoad.c:73
let MAX_VEHICLE_DATA_SIZE = 0x80000 as Int32

/// Source: oracle/codemp/game/bg_vehicleLoad.c:76
var VehWeaponParms: JKAShared.CharBuf {
    get { bg.variables.VehWeaponParms }
    set { bg.variables.VehWeaponParms = newValue }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:77
var VehicleParms: JKAShared.CharBuf {
    get { bg.variables.VehicleParms }
    set { bg.variables.VehicleParms = newValue }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:103
public var g_vehWeaponInfo: Slots<JKAMP.VehWeaponInfo> { bg.storage.g_vehWeaponInfo }

/// Source: oracle/codemp/game/bg_vehicleLoad.c:104
var numVehicleWeapons: Int32 {
    get { bg.variables.numVehicleWeapons }
    set { bg.variables.numVehicleWeapons = newValue }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:106
public var g_vehicleInfo: Slots<JKAMP.VehicleInfo> { bg.storage.g_vehicleInfo }

/// Source: oracle/codemp/game/bg_vehicleLoad.c:107
var numVehicles: Int32 {
    get { bg.variables.numVehicles }
    set { bg.variables.numVehicles = newValue }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:138
// TODO: Port global vehWeaponFields
// Raven wrote: vehField_t vehWeaponFields[NUM_VWEAP_PARMS]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_vehicleLoad.c:445
// TODO: Port global vehicleFields
// Raven wrote: vehField_t vehicleFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_vehicleLoad.c:671
// TODO: Port global VehicleTable
// Raven wrote: stringID_table_t VehicleTable[VH_NUM_VEHICLES+1]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_vehicleLoad.c:79
func BG_ClearVehicleParseParms() {
    //You can't strcat to these forever without clearing them!
    VehWeaponParms[0] = 0
    VehicleParms[0] = 0
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:167
private func BG_ParseVehWeaponParm(_ vehWeapon: JKAMP.VehWeaponInfo, _ parmName: String, _ pValue: String) -> Bool {
    var i: Int32
    var vec = vec3_t()
    // Raven walks the record's bytes through `b`, and the raw pointer over the view's slot is that walk, under rule 11.
    let b: UnsafeMutableRawPointer = UnsafeMutableRawPointer(vehWeapon.handle)
    var _iFieldsRead: Int32 = 0
    var vehType: vehicleType_t
    var value = CharBuf(1024)

    Q_strncpyz(&value, pValue, Int32((value).count))

    // Loop through possible parameters
    i = 0
    while i < NUM_VWEAP_PARMS {
        if vehWeaponFields[i].name != nil && Q_stricmp(vehWeaponFields[i].name!, parmName) == 0 {
            // found it
            switch vehWeaponFields[i].type {
            case VF_INT:
                b[int: vehWeaponFields[i].ofs] = atoi(value)

            case VF_FLOAT:
                b[float: vehWeaponFields[i].ofs] = atof(value)

            case VF_LSTRING:
                if b[pointer: vehWeaponFields[i].ofs] == nil {
                    //just use 1024 bytes in case we want to write over the string
                    b[pointer: vehWeaponFields[i].ofs] = BG_Alloc(1024) //(char *)BG_Alloc(strlen(value));
                    strcpy(b[pointer: vehWeaponFields[i].ofs]!, value)
                }

            case VF_VECTOR:
                _iFieldsRead = sscanf(value, "%f %f %f", &vec)
                if _iFieldsRead != 3 {
                    Com_Printf(S_COLOR_YELLOW + "BG_ParseVehWeaponParm: VEC3 sscanf() failed to read 3 floats ('angle' key bug?)\n")
                }
                b[float: vehWeaponFields[i].ofs, 0] = vec[0]
                b[float: vehWeaponFields[i].ofs, 1] = vec[1]
                b[float: vehWeaponFields[i].ofs, 2] = vec[2]

            case VF_BOOL:
                b[int: vehWeaponFields[i].ofs] = (Bool((atof(value) != 0)) ? 1 : 0)

            case VF_VEHTYPE:
                vehType = vehicleType_t(GetIDForString(VehicleTable, String(value)))
                b[int: vehWeaponFields[i].ofs] = vehType

            case VF_ANIM:
                do {
                    let anim: Int32 = GetIDForString(animTable, String(value))
                    b[int: vehWeaponFields[i].ofs] = anim
                }

            case VF_WEAPON:
                //*(int *)(b+vehWeaponFields[i].ofs) = VEH_VehWeaponIndexForName( value );
                break

            case VF_MODEL:
                b[int: vehWeaponFields[i].ofs] = G_ModelIndex(String(value))

            case VF_MODEL_CLIENT:
                //*(int *)(b+vehWeaponFields[i].ofs) = G_ModelIndex( value );
                break

            case VF_EFFECT:
                b[int: vehWeaponFields[i].ofs] = G_EffectIndex(String(value))

            case VF_EFFECT_CLIENT:
                //*(int *)(b+vehWeaponFields[i].ofs) = G_EffectIndex( value );
                break

            case VF_SHADER:
                break

            case VF_SHADER_NOMIP:
                break

            case VF_SOUND:
                b[int: vehWeaponFields[i].ofs] = G_SoundIndex(String(value))

            case VF_SOUND_CLIENT:
                //*(int *)(b+vehWeaponFields[i].ofs) = G_SoundIndex( value );
                break

            default:
                //Unknown type?
                return false
            }
            break
        }
        i += 1
    }
    if i == NUM_VWEAP_PARMS {
        return false
    } else {
        return true
    }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:309
func VEH_LoadVehWeapon(_ vehWeaponName: String) -> Int32 {
    //load up specified vehWeapon and save in array: g_vehWeaponInfo
    var token: String
    var parmName = CharBuf(128)
    var value: String
    var p = TextCursor()
    var vehWeapon: VehWeaponInfo? = nil

    //BG_VehWeaponSetDefaults( &g_vehWeaponInfo[0] );//set the first vehicle to default data

    //try to parse data out
    p = TextCursor(VehWeaponParms)

    COM_BeginParseSession("vehWeapons")

    vehWeapon = g_vehWeaponInfo[numVehicleWeapons]
    // look for the right vehicle weapon
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            return 0
        }

        if Q_stricmp(token, vehWeaponName) == 0 {
            break
        }

        SkipBracedSection(&p)
    }
    if p.isNull {
        return 0
    }

    token = COM_ParseExt(&p, true)
    if token.isEmpty {
        //barf
        return VEH_WEAPON_NONE
    }

    if Q_stricmp(token, "{") != 0 {
        return VEH_WEAPON_NONE
    }

    // parse the vehWeapon info block
    while 1 != 0 {
        SkipRestOfLine(&p)
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing Vehicle Weapon '%s'\n", vehWeaponName)
            return VEH_WEAPON_NONE
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }
        Q_strncpyz(&parmName, token, Int32((parmName).count))
        value = COM_ParseExt(&p, true)
        if value.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: Vehicle Weapon token '%s' has no value!\n", parmName)
        } else {
            if !BG_ParseVehWeaponParm(vehWeapon!, String(parmName), value) {
                Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle Weapon key/value pair '%s','%s'!\n", parmName, value)
            }
        }
    }
    if vehWeapon!.fHoming != 0 {
        //all lock-on weapons use these 2 sounds
        //Hmm, no need fo have server register this, is there?
        //G_SoundIndex( "sound/weapons/torpedo/tick.wav" );
        //G_SoundIndex( "sound/weapons/torpedo/lock.wav" );
    }
    defer { numVehicleWeapons += 1 }
    return numVehicleWeapons
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:413
func VEH_VehWeaponIndexForName(_ vehWeaponName: String) -> Int32 {
    var vw: Int32
    if vehWeaponName.isEmpty {
        Com_Printf(S_COLOR_RED + "ERROR: Trying to read Vehicle Weapon with no name!\n")
        return VEH_WEAPON_NONE
    }
    vw = VEH_WEAPON_BASE
    while vw < numVehicleWeapons {
        if g_vehWeaponInfo[vw].name != nil && Q_stricmp(g_vehWeaponInfo[vw].name!, vehWeaponName) == 0 {
            //already loaded this one
            return vw
        }
        vw += 1
    }
    //haven't loaded it yet
    if vw >= MAX_VEH_WEAPONS {
        //no more room!
        Com_Printf(S_COLOR_RED + "ERROR: Too many Vehicle Weapons (max 16), aborting load on %s!\n", vehWeaponName)
        return VEH_WEAPON_NONE
    }
    //we have room for another one, load it up and return the index
    //HMM... should we not even load the .vwp file until we want to?
    vw = VEH_LoadVehWeapon(vehWeaponName)
    if vw == VEH_WEAPON_NONE {
        Com_Printf(S_COLOR_RED + "ERROR: Could not find Vehicle Weapon %s!\n", vehWeaponName)
    }
    return vw
}

// Setup the shared functions (one's that all vehicles would generally use).
/// Source: oracle/codemp/game/bg_vehicleLoad.c:683
func BG_SetSharedVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    //only do the whole thing if we're on game
    G_SetSharedVehicleFunctions(pVehInfo)

    switch pVehInfo.type {
    case VH_SPEEDER:
        G_SetSpeederVehicleFunctions(pVehInfo)

    case VH_ANIMAL:
        G_SetAnimalVehicleFunctions(pVehInfo)

    case VH_FIGHTER:
        G_SetFighterVehicleFunctions(pVehInfo)

    case VH_WALKER:
        G_SetWalkerVehicleFunctions(pVehInfo)

    default:
        break
    }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:709
func BG_VehicleSetDefaults(_ vehicle: JKAMP.VehicleInfo) {
    vehicle.clear()
    /*
    #if _JK2MP
    if (!vehicle->name)
    {
    vehicle->name = (char *)BG_Alloc(1024);
    }
    strcpy(vehicle->name, "default");
    #else
    vehicle->name = G_NewString( "default" );
    #endif

    //general data
    vehicle->type = VH_SPEEDER;				//what kind of vehicle
    //FIXME: no saber or weapons if numHands = 2, should switch to speeder weapon, no attack anim on player
    vehicle->numHands = 0;					//if 2 hands, no weapons, if 1 hand, can use 1-handed weapons, if 0 hands, can use 2-handed weapons
    vehicle->lookPitch = 0;				//How far you can look up and down off the forward of the vehicle
    vehicle->lookYaw = 5;					//How far you can look left and right off the forward of the vehicle
    vehicle->length = 0;					//how long it is - used for body length traces when turning/moving?
    vehicle->width = 0;						//how wide it is - used for body length traces when turning/moving?
    vehicle->height = 0;					//how tall it is - used for body length traces when turning/moving?
    VectorClear( vehicle->centerOfGravity );//offset from origin: {forward, right, up} as a modifier on that dimension (-1.0f is all the way back, 1.0f is all the way forward)

    //speed stats - note: these are DESIRED speed, not actual current speed/velocity
    vehicle->speedMax = VEH_DEFAULT_SPEED_MAX;	//top speed
    vehicle->turboSpeed = 0;					//turboBoost
    vehicle->speedMin = 0;						//if < 0, can go in reverse
    vehicle->speedIdle = 0;						//what speed it drifts to when no accel/decel input is given
    vehicle->accelIdle = 0;						//if speedIdle > 0, how quickly it goes up to that speed
    vehicle->acceleration = VEH_DEFAULT_ACCEL;	//when pressing on accelerator (1/2 this when going in reverse)
    vehicle->decelIdle = VEH_DEFAULT_DECEL;		//when giving no input, how quickly it desired speed drops to speedIdle
    vehicle->strafePerc = VEH_DEFAULT_STRAFE_PERC;//multiplier on current speed for strafing.  If 1.0f, you can strafe at the same speed as you're going forward, 0.5 is half, 0 is no strafing

    //handling stats
    vehicle->bankingSpeed = VEH_DEFAULT_BANKING_SPEED;	//how quickly it pitches and rolls (not under player control)
    vehicle->rollLimit = VEH_DEFAULT_ROLL_LIMIT;		//how far it can roll to either side
    vehicle->pitchLimit = VEH_DEFAULT_PITCH_LIMIT;		//how far it can pitch forward or backward
    vehicle->braking = VEH_DEFAULT_BRAKING;				//when pressing on decelerator (backwards)
    vehicle->turningSpeed = VEH_DEFAULT_TURNING_SPEED;	//how quickly you can turn
    vehicle->turnWhenStopped = qfalse;					//whether or not you can turn when not moving
    vehicle->traction = VEH_DEFAULT_TRACTION;			//how much your command input affects velocity
    vehicle->friction = VEH_DEFAULT_FRICTION;			//how much velocity is cut on its own
    vehicle->maxSlope = VEH_DEFAULT_MAX_SLOPE;			//the max slope that it can go up with control

    //durability stats
    vehicle->mass = VEH_DEFAULT_MASS;			//for momentum and impact force (player mass is 10)
    vehicle->armor = VEH_DEFAULT_MAX_ARMOR;		//total points of damage it can take
    vehicle->toughness = VEH_DEFAULT_TOUGHNESS;	//modifies incoming damage, 1.0 is normal, 0.5 is half, etc.  Simulates being made of tougher materials/construction
    vehicle->malfunctionArmorLevel = 0;			//when armor drops to or below this point, start malfunctioning

    //visuals & sounds
    //vehicle->model = "models/map_objects/ships/swoop.md3";	//what model to use - if make it an NPC's primary model, don't need this?
    if (!vehicle->model)
    {
    vehicle->model = (char *)BG_Alloc(1024);
    }
    strcpy(vehicle->model, "models/map_objects/ships/swoop.md3");

    vehicle->modelIndex = 0;							//set internally, not until this vehicle is spawned into the level
    vehicle->skin = NULL;								//what skin to use - if make it an NPC's primary model, don't need this?
    vehicle->riderAnim = BOTH_GUNSIT1;					//what animation the rider uses

    vehicle->soundOn = NULL;							//sound to play when get on it
    vehicle->soundLoop = NULL;							//sound to loop while riding it
    vehicle->soundOff = NULL;							//sound to play when get off
    vehicle->exhaustFX = NULL;							//exhaust effect, played from "*exhaust" bolt(s)
    vehicle->trailFX = NULL;							//trail effect, played from "*trail" bolt(s)
    vehicle->impactFX = NULL;							//explosion effect, for when it blows up (should have the sound built into explosion effect)
    vehicle->explodeFX = NULL;							//explosion effect, for when it blows up (should have the sound built into explosion effect)
    vehicle->wakeFX = NULL;								//effect itmakes when going across water

    //other misc stats
    vehicle->gravity = VEH_DEFAULT_GRAVITY;				//normal is 800
    vehicle->hoverHeight = 0;//VEH_DEFAULT_HOVER_HEIGHT;	//if 0, it's a ground vehicle
    vehicle->hoverStrength = 0;//VEH_DEFAULT_HOVER_STRENGTH;//how hard it pushes off ground when less than hover height... causes "bounce", like shocks
    vehicle->waterProof = qtrue;						//can drive underwater if it has to
    vehicle->bouyancy = 1.0f;							//when in water, how high it floats (1 is neutral bouyancy)
    vehicle->fuelMax = 1000;							//how much fuel it can hold (capacity)
    vehicle->fuelRate = 1;								//how quickly is uses up fuel
    vehicle->visibility = VEH_DEFAULT_VISIBILITY;		//radius for sight alerts
    vehicle->loudness = VEH_DEFAULT_LOUDNESS;			//radius for sound alerts
    vehicle->explosionRadius = VEH_DEFAULT_EXP_RAD;
    vehicle->explosionDamage = VEH_DEFAULT_EXP_DMG;
    vehicle->maxPassengers = 0;

    //new stuff
    vehicle->hideRider = qfalse;						// rider (and passengers?) should not be drawn
    vehicle->killRiderOnDeath = qfalse;					//if rider is on vehicle when it dies, they should die
    vehicle->flammable = qfalse;						//whether or not the vehicle should catch on fire before it explodes
    vehicle->explosionDelay = 0;						//how long the vehicle should be on fire/dying before it explodes
    //camera stuff
    vehicle->cameraOverride = qfalse;					//whether or not to use all of the following 3rd person camera override values
    vehicle->cameraRange = 0.0f;						//how far back the camera should be - normal is 80
    vehicle->cameraVertOffset = 0.0f;					//how high over the vehicle origin the camera should be - normal is 16
    vehicle->cameraHorzOffset = 0.0f;					//how far to left/right (negative/positive) of of the vehicle origin the camera should be - normal is 0
    vehicle->cameraPitchOffset = 0.0f;					//a modifier on the camera's pitch (up/down angle) to the vehicle - normal is 0
    vehicle->cameraFOV = 0.0f;							//third person camera FOV, default is 80
    vehicle->cameraAlpha = qfalse;						//fade out the vehicle if it's in the way of the crosshair
    */
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:812
func BG_VehicleClampData(_ vehicle: JKAMP.VehicleInfo) {
    //sanity check and clamp the vehicle's data
    var i: Int32

    i = 0
    while i < 3 {
        if vehicle.centerOfGravity[i] > 1.0 {
            vehicle.centerOfGravity[i] = 1.0
        } else if vehicle.centerOfGravity[i] < -1.0 {
            vehicle.centerOfGravity[i] = -1.0
        }
        i += 1
    }

    // Validate passenger max.
    if vehicle.maxPassengers > VEH_MAX_PASSENGERS {
        vehicle.maxPassengers = VEH_MAX_PASSENGERS
    } else if vehicle.maxPassengers < 0 {
        vehicle.maxPassengers = 0
    }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:839
private func BG_ParseVehicleParm(_ vehicle: JKAMP.VehicleInfo, _ parmName: String, _ pValue: String?) -> Bool {
    var i: Int32
    var vec = vec3_t()
    // Raven walks the record's bytes through `b`, and the raw pointer over the view's slot is that walk, under rule 11.
    let b: UnsafeMutableRawPointer = UnsafeMutableRawPointer(vehicle.handle)
    var _iFieldsRead: Int32 = 0
    var vehType: vehicleType_t
    var value = CharBuf(1024)

    Q_strncpyz(&value, pValue!, Int32((value).count))

    // Loop through possible parameters
    i = 0
    while vehicleFields[i].ofs != -1 {
        if Q_stricmp(vehicleFields[i].name!, parmName) == 0 {
            // found it
            switch vehicleFields[i].type {
            case VF_IGNORE:
                break

            case VF_INT:
                b[int: vehicleFields[i].ofs] = atoi(value)

            case VF_FLOAT:
                b[float: vehicleFields[i].ofs] = atof(value)

            case VF_LSTRING:
                if b[pointer: vehicleFields[i].ofs] == nil {
                    //just use 128 bytes in case we want to write over the string
                    b[pointer: vehicleFields[i].ofs] = BG_Alloc(128) //(char *)BG_Alloc(strlen(value));
                    strcpy(b[pointer: vehicleFields[i].ofs]!, value)
                }

            case VF_VECTOR:
                _iFieldsRead = sscanf(value, "%f %f %f", &vec)
                if _iFieldsRead != 3 {
                    Com_Printf(S_COLOR_YELLOW + "BG_ParseVehicleParm: VEC3 sscanf() failed to read 3 floats ('angle' key bug?)\n")
                }
                b[float: vehWeaponFields[i].ofs, 0] = vec[0]
                b[float: vehWeaponFields[i].ofs, 1] = vec[1]
                b[float: vehWeaponFields[i].ofs, 2] = vec[2]

            case VF_BOOL:
                b[int: vehicleFields[i].ofs] = (Bool((atof(value) != 0)) ? 1 : 0)

            case VF_VEHTYPE:
                vehType = vehicleType_t(GetIDForString(VehicleTable, String(value)))
                b[int: vehicleFields[i].ofs] = vehType

            case VF_ANIM:
                do {
                    let anim: Int32 = GetIDForString(animTable, String(value))
                    b[int: vehicleFields[i].ofs] = anim
                }

            case VF_WEAPON:
                b[int: vehicleFields[i].ofs] = VEH_VehWeaponIndexForName(String(value))

            case VF_MODEL:
                b[int: vehicleFields[i].ofs] = G_ModelIndex(String(value))

            case VF_MODEL_CLIENT:
                //*(int *)(b+vehicleFields[i].ofs) = G_ModelIndex( value );
                break

            case VF_EFFECT:
                b[int: vehicleFields[i].ofs] = G_EffectIndex(String(value))

            case VF_EFFECT_CLIENT:
                //*(int *)(b+vehicleFields[i].ofs) = G_EffectIndex( value );
                break

            case VF_SHADER:
                break

            case VF_SHADER_NOMIP:
                break

            case VF_SOUND:
                b[int: vehicleFields[i].ofs] = G_SoundIndex(String(value))

            case VF_SOUND_CLIENT:
                //*(int *)(b+vehicleFields[i].ofs) = G_SoundIndex( value );
                break

            default:
                //Unknown type?
                return false
            }
            break
        }
        i += 1
    }
    if vehicleFields[i].ofs == -1 {
        return false
    } else {
        return true
    }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:983
func VEH_LoadVehicle(_ vehicleName: String) -> Int32 {
    //load up specified vehicle and save in array: g_vehicleInfo
    var token: String
    //we'll assume that no parm name is longer than 128
    var parmName = CharBuf(128)
    var weap1 = CharBuf(128)
    var weap2 = CharBuf(128)
    var weapMuzzle1 = CharBuf(128)
    var weapMuzzle2 = CharBuf(128)
    var weapMuzzle3 = CharBuf(128)
    var weapMuzzle4 = CharBuf(128)
    var weapMuzzle5 = CharBuf(128)
    var weapMuzzle6 = CharBuf(128)
    var weapMuzzle7 = CharBuf(128)
    var weapMuzzle8 = CharBuf(128)
    var weapMuzzle9 = CharBuf(128)
    var weapMuzzle10 = CharBuf(128)
    var value: String? = nil
    var p = TextCursor()
    var vehicle: VehicleInfo? = nil

    // Load the vehicle parms if no vehicles have been loaded yet.
    if numVehicles == 0 {
        BG_VehicleLoadParms()
    }

    //try to parse data out
    p = TextCursor(VehicleParms)

    COM_BeginParseSession("vehicles")

    vehicle = g_vehicleInfo[numVehicles]
    // look for the right vehicle
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            return VEHICLE_NONE
        }

        if Q_stricmp(token, vehicleName) == 0 {
            break
        }

        SkipBracedSection(&p)
    }

    if p.isNull {
        return VEHICLE_NONE
    }

    token = COM_ParseExt(&p, true)
    if token.isEmpty {
        //barf
        return VEHICLE_NONE
    }

    if Q_stricmp(token, "{") != 0 {
        return VEHICLE_NONE
    }

    let vehicleInfo = vehicle!
    BG_VehicleSetDefaults(vehicleInfo)
    // parse the vehicle info block
    while 1 != 0 {
        SkipRestOfLine(&p)
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing Vehicle '%s'\n", vehicleName)
            return VEHICLE_NONE
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }
        Q_strncpyz(&parmName, token, Int32((parmName).count))
        value = COM_ParseExt(&p, true)
        if value == nil || value!.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: Vehicle token '%s' has no value!\n", parmName)
        } else if Q_stricmp("weap1", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weap1, value!, Int32((weap1).count))
        } else if Q_stricmp("weap2", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weap2, value!, Int32((weap2).count))
        } else if Q_stricmp("weapMuzzle1", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle1, value!, Int32((weapMuzzle1).count))
        } else if Q_stricmp("weapMuzzle2", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle2, value!, Int32((weapMuzzle2).count))
        } else if Q_stricmp("weapMuzzle3", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle3, value!, Int32((weapMuzzle3).count))
        } else if Q_stricmp("weapMuzzle4", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle4, value!, Int32((weapMuzzle4).count))
        } else if Q_stricmp("weapMuzzle5", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle5, value!, Int32((weapMuzzle5).count))
        } else if Q_stricmp("weapMuzzle6", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle6, value!, Int32((weapMuzzle6).count))
        } else if Q_stricmp("weapMuzzle7", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle7, value!, Int32((weapMuzzle7).count))
        } else if Q_stricmp("weapMuzzle8", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle8, value!, Int32((weapMuzzle8).count))
        } else if Q_stricmp("weapMuzzle9", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle9, value!, Int32((weapMuzzle9).count))
        } else if Q_stricmp("weapMuzzle10", parmName) == 0 {
            //hmm, store this off because we don't want to call another one of these text parsing routines while we're in the middle of one...
            Q_strncpyz(&weapMuzzle10, value!, Int32((weapMuzzle10).count))
        } else {
            if !BG_ParseVehicleParm(vehicleInfo, String(parmName), value) {
                Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair '%s', '%s'!\n", parmName, value!)
            }
        }
    }
    //NOW: if we have any weapons, go ahead and load them
    if weap1[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weap1", String(weap1)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weap1', '%s'!\n", weap1)
        }
    }
    if weap2[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weap2", String(weap2)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weap2', '%s'!\n", weap2)
        }
    }
    if weapMuzzle1[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle1", String(weapMuzzle1)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle1', '%s'!\n", weapMuzzle1)
        }
    }
    if weapMuzzle2[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle2", String(weapMuzzle2)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle2', '%s'!\n", weapMuzzle2)
        }
    }
    if weapMuzzle3[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle3", String(weapMuzzle3)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle3', '%s'!\n", weapMuzzle3)
        }
    }
    if weapMuzzle4[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle4", String(weapMuzzle4)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle4', '%s'!\n", weapMuzzle4)
        }
    }
    if weapMuzzle5[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle5", String(weapMuzzle5)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle5', '%s'!\n", weapMuzzle5)
        }
    }
    if weapMuzzle6[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle6", String(weapMuzzle6)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle6', '%s'!\n", weapMuzzle6)
        }
    }
    if weapMuzzle7[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle7", String(weapMuzzle7)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle7', '%s'!\n", weapMuzzle7)
        }
    }
    if weapMuzzle8[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle8", String(weapMuzzle8)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle8', '%s'!\n", weapMuzzle8)
        }
    }
    if weapMuzzle9[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle9", String(weapMuzzle9)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle9', '%s'!\n", weapMuzzle9)
        }
    }
    if weapMuzzle10[0] != 0 {
        if !BG_ParseVehicleParm(vehicleInfo, "weapMuzzle10", String(weapMuzzle10)) {
            Com_Printf(S_COLOR_RED + "ERROR: Unknown Vehicle key/value pair 'weapMuzzle10', '%s'!\n", weapMuzzle10)
        }
    }

    //let's give these guys some defaults
    if vehicleInfo.health_front == 0 {
        vehicleInfo.health_front = vehicleInfo.armor / 4
    }
    if vehicleInfo.health_back == 0 {
        vehicleInfo.health_back = vehicleInfo.armor / 4
    }
    if vehicleInfo.health_right == 0 {
        vehicleInfo.health_right = vehicleInfo.armor / 4
    }
    if vehicleInfo.health_left == 0 {
        vehicleInfo.health_left = vehicleInfo.armor / 4
    }

    if vehicleInfo.model != nil {
        vehicleInfo.modelIndex = G_ModelIndex(va("models/players/%s/model.glm", vehicleInfo.model!))
    }

    //SP
    //this will just turn off surfs if there is a *off shader on a surf, the skin will actually get thrown away when cgame starts
    //this is for the server-side call, it will propgate down to cgame with configstrings and register it at the same time as all the other skins for ghoul2 models
    //this will just turn off surfs if there is a *off shader on a surf, the skin will actually get thrown away when cgame starts
    //this is for the server-side call, it will propgate down to cgame with configstrings and register it at the same time as all the other skins for ghoul2 models
    //sanity check and clamp the vehicle's data
    BG_VehicleClampData(vehicleInfo)
    // Setup the shared function pointers.
    BG_SetSharedVehicleFunctions(vehicleInfo)
    //misc effects... FIXME: not even used in MP, are they?
    if vehicleInfo.explosionDamage != 0 {
        G_EffectIndex("ships/ship_explosion_mark")
    }
    if vehicleInfo.flammable {
        G_SoundIndex("sound/vehicles/common/fire_lp.wav")
    }

    if vehicleInfo.hoverHeight > 0 {
        G_EffectIndex("ships/swoop_dust")
    }

    G_EffectIndex("volumetric/black_smoke")
    G_EffectIndex("ships/fire")
    G_SoundIndex("sound/vehicles/common/release.wav")


    defer { numVehicles += 1 }
    return numVehicles
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1364
func VEH_VehicleIndexForName(_ vehicleName: String) -> Int32 {
    var v: Int32
    if vehicleName.isEmpty {
        Com_Printf(S_COLOR_RED + "ERROR: Trying to read Vehicle with no name!\n")
        return VEHICLE_NONE
    }
    v = VEHICLE_BASE
    while v < numVehicles {
        if g_vehicleInfo[v].name != nil && Q_stricmp(g_vehicleInfo[v].name!, vehicleName) == 0 {
            //already loaded this one
            return v
        }
        v += 1
    }
    //haven't loaded it yet
    if v >= MAX_VEHICLES {
        //no more room!
        Com_Printf(S_COLOR_RED + "ERROR: Too many Vehicles (max 64), aborting load on %s!\n", vehicleName)
        return VEHICLE_NONE
    }
    //we have room for another one, load it up and return the index
    //HMM... should we not even load the .veh file until we want to?
    v = VEH_LoadVehicle(vehicleName)
    if v == VEHICLE_NONE {
        Com_Printf(S_COLOR_RED + "ERROR: Could not find Vehicle %s!\n", vehicleName)
    }
    return v
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1396
func BG_VehWeaponLoadParms() {
    var len: Int32
    var totallen: Int32
    var vehExtFNLen: Int32
    let mainBlockLen: Int32
    let fileCnt: Int32
    var i: Int32
    var holdChar = TextCursor()
    var marker: Int32 = 0
    var vehWeaponExtensionListBuf = CharBuf(2048)
    var f: fileHandle_t = 0
    var tempReadBuffer: UnsafeMutableRawPointer

    len = 0

    //remember where to store the next one
    mainBlockLen = len
    totallen = mainBlockLen
    marker = totallen
    VehWeaponParms[marker] = 0

    //now load in the extra .veh extensions
    let filled = trap_FS_GetFileList("ext_data/vehicles/weapons", ".vwp", Int32((vehWeaponExtensionListBuf).count))
    fileCnt = filled.0
    vehWeaponExtensionListBuf = filled.1

    holdChar = TextCursor(vehWeaponExtensionListBuf)

    tempReadBuffer = BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE)

    // NOTE: Not use TempAlloc anymore...
    //Make ABSOLUTELY CERTAIN that BG_Alloc/etc. is not used before
    //the subsequent BG_TempFree or the pool will be screwed.

    i = 0
    while i < fileCnt {
        vehExtFNLen = strlen(holdChar.text)

        //		Com_Printf( "Parsing %s\n", holdChar );

        len = trap_FS_FOpenFile(va("ext_data/vehicles/weapons/%s", holdChar.text), &f, FS_READ)
        //		len = gi.FS_ReadFile( va( "ext_data/vehicles/weapons/%s", holdChar), (void **) &buffer );

        if len == -1 {
            Com_Printf("error reading file\n")
        } else {
            trap_FS_Read(OpaquePointer(tempReadBuffer), len, f)
            tempReadBuffer[byte: len] = 0

            // Don't let it end on a } because that should be a stand-alone token.
            if totallen != 0 && VehWeaponParms[marker - 1] == Int32(ascii: "}") {
                strcat(&VehWeaponParms, " ", at: marker)
                totallen += 1
                marker += 1
            }

            if totallen + len >= MAX_VEH_WEAPON_DATA_SIZE {
                Com_Error(ERR_DROP, "Vehicle Weapon extensions (*.vwp) are too large")
            }
            strcat(&VehWeaponParms, tempReadBuffer, at: marker)
            trap_FS_FCloseFile(f)

            totallen += len
            marker = totallen
        }
        i += 1
        holdChar.advance(by: vehExtFNLen + 1)
    }

    BG_TempFree(MAX_VEH_WEAPON_DATA_SIZE)
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1487
public func BG_VehicleLoadParms() {
    //HMM... only do this if there's a vehicle on the level?
    var len: Int32
    var totallen: Int32
    var vehExtFNLen: Int32
    let mainBlockLen: Int32
    let fileCnt: Int32
    var i: Int32
    //	const char	*filename = "ext_data/vehicles.dat";
    var holdChar = TextCursor()
    var marker: Int32 = 0
    var vehExtensionListBuf = CharBuf(2048)
    var f: fileHandle_t = 0
    var tempReadBuffer: UnsafeMutableRawPointer

    len = 0

    //remember where to store the next one
    mainBlockLen = len
    totallen = mainBlockLen
    marker = totallen
    VehicleParms[marker] = 0

    //now load in the extra .veh extensions
    let filled = trap_FS_GetFileList("ext_data/vehicles", ".veh", Int32((vehExtensionListBuf).count))
    fileCnt = filled.0
    vehExtensionListBuf = filled.1

    holdChar = TextCursor(vehExtensionListBuf)

    tempReadBuffer = BG_TempAlloc(MAX_VEHICLE_DATA_SIZE)

    // NOTE: Not use TempAlloc anymore...
    //Make ABSOLUTELY CERTAIN that BG_Alloc/etc. is not used before
    //the subsequent BG_TempFree or the pool will be screwed.

    i = 0
    while i < fileCnt {
        vehExtFNLen = strlen(holdChar.text)

        //		Com_Printf( "Parsing %s\n", holdChar );

        len = trap_FS_FOpenFile(va("ext_data/vehicles/%s", holdChar.text), &f, FS_READ)
        //		len = gi.FS_ReadFile( va( "ext_data/vehicles/%s", holdChar), (void **) &buffer );

        if len == -1 {
            Com_Printf("error reading file\n")
        } else {
            trap_FS_Read(OpaquePointer(tempReadBuffer), len, f)
            tempReadBuffer[byte: len] = 0

            // Don't let it end on a } because that should be a stand-alone token.
            if totallen != 0 && VehicleParms[marker - 1] == Int32(ascii: "}") {
                strcat(&VehicleParms, " ", at: marker)
                totallen += 1
                marker += 1
            }

            if totallen + len >= MAX_VEHICLE_DATA_SIZE {
                Com_Error(ERR_DROP, "Vehicle extensions (*.veh) are too large")
            }
            strcat(&VehicleParms, tempReadBuffer, at: marker)
            trap_FS_FCloseFile(f)

            totallen += len
            marker = totallen
        }
        i += 1
        holdChar.advance(by: vehExtFNLen + 1)
    }

    BG_TempFree(MAX_VEHICLE_DATA_SIZE)

    numVehicles = 1 //first one is null/default
    //set the first vehicle to default data
    BG_VehicleSetDefaults(g_vehicleInfo[VEHICLE_BASE])
    //sanity check and clamp the vehicle's data
    BG_VehicleClampData(g_vehicleInfo[VEHICLE_BASE])
    // Setup the shared function pointers.
    BG_SetSharedVehicleFunctions(g_vehicleInfo[VEHICLE_BASE])

    //Load the Vehicle Weapons data, too
    BG_VehWeaponLoadParms()
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1590
public func BG_VehicleGetIndex(_ vehicleName: String) -> Int32 {
    return (VEH_VehicleIndexForName(vehicleName))
}

//We get the vehicle name passed in as modelname
//with a $ in front of it.
//we are expected to then get the model for the
//vehicle and stomp over modelname with it.
/// Source: oracle/codemp/game/bg_vehicleLoad.c:1599
public func BG_GetVehicleModelName(_ modelname: inout JKAShared.CharBuf) {
    let vehName: CharBuf = modelname[(1)...]
    let vIndex: Int32 = BG_VehicleGetIndex(String(vehName))

    if vIndex == VEHICLE_NONE {
        Com_Error(ERR_DROP, "BG_GetVehicleModelName:  couldn't find vehicle %s", vehName)
    }

    strcpy(&modelname, g_vehicleInfo[vIndex].model!)
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1613
func BG_GetVehicleSkinName(_ skinname: inout JKAShared.CharBuf) {
    let vehName: CharBuf = skinname[(1)...]
    let vIndex: Int32 = BG_VehicleGetIndex(String(vehName))

    if vIndex == VEHICLE_NONE {
        Com_Error(ERR_DROP, "BG_GetVehicleSkinName:  couldn't find vehicle %s", vehName)
    }

    if g_vehicleInfo[vIndex].skin == nil || g_vehicleInfo[vIndex].skin!.isEmpty {
        skinname[0] = 0
    } else {
        strcpy(&skinname, g_vehicleInfo[vIndex].skin!)
    }
}

/// Source: oracle/codemp/game/bg_vehicleLoad.c:1643
public func AttachRidersGeneric(_ pVeh: JKAMP.Vehicle) {
    // If we have a pilot, attach him to the driver tag.
    if pVeh.m_pPilot != nil {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var yawOnlyAngles = vec3_t()
            let parent: BgEntity? = pVeh.m_pParentEntity
            let pilot: BgEntity? = pVeh.m_pPilot
            let parentEntity = parent!
            let crotchBolt: Int32 = trap_G2API_AddBolt(parentEntity.ghoul2, 0, "*driver")


            yawOnlyAngles = vec3_t(0, parentEntity.playerState!.viewangles[YAW], 0)

            // Get the driver tag.
            trap_G2API_GetBoltMatrix(parentEntity.ghoul2, 0, crotchBolt, boltMatrix, yawOnlyAngles, parentEntity.playerState!.origin, BG_GetTime(), nil, &parentEntity.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pilot!.playerState!.origin)
        }
    }
}
