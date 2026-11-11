# The R1a body round of the dead-function wave

This record holds set R1a of section 4 of `notes/2026-11-10/docket-13.md`: the base `CRMInstance`, `CRMBSPInstance`, `CRMVoidInstance`, and `CRMInstanceFile` of Raven's RMG. The classes had no stubs, so the round writes four new files. The branch is `ded-bodies-r1a` from `f60a012e`, in the worktree `/tmp/jka-r1a`. Ruling R11 of `notes/2026-11-10/dedicated-open-rows-ledger-13.md` gives the form. Every Raven cite is under `oracle/codemp/RMG/`, and every Swift file is under `Sources/JKAMP_DedLogic/`.

## The files

| Swift file | Raven files |
| --- | --- |
| CRMInstance.swift | RM_Instance.h, RM_Instance.cpp |
| CRMBSPInstance.swift | RM_Instance_BSP.h, RM_Instance_BSP.cpp |
| CRMVoidInstance.swift | RM_Instance_Void.h, RM_Instance_Void.cpp |
| CRMInstanceFile.swift | RM_InstanceFile.h, RM_InstanceFile.cpp |

## The functions

| Function | Raven | Status |
| --- | --- | --- |
| AUTOMAP_NONE to AUTOMAP_WALL | RM_Instance.h:15 to :22 | landed |
| CRMInstance::CRMInstance | RM_Instance.cpp:18 | landed |
| CRMInstance::IsValid | RM_Instance.h:64 | landed |
| CRMInstance::PreSpawn | RM_Instance.cpp:47 | landed |
| CRMInstance::Spawn | RM_Instance.h:67 | landed |
| CRMInstance::PostSpawn | RM_Instance.cpp:95 | landed |
| CRMInstance::DrawAutomapSymbol | RM_Instance.cpp:105 | landed |
| CRMInstance::Preview | RM_Instance.cpp:161 | landed |
| The 33 inline methods of RM_Instance.h:72 to :116 | RM_Instance.h | landed |
| CRMBSPInstance::CRMBSPInstance | RM_Instance_BSP.cpp:31 | landed |
| CRMBSPInstance::Spawn | RM_Instance_BSP.cpp:80 | landed |
| CRMBSPInstance::GetPreviewColor, GetHoleRadius, GetModelName, GetAngleDiff, GetAngularType | RM_Instance_BSP.h:24 to :32 | landed |
| CRMVoidInstance::CRMVoidInstance | RM_Instance_Void.cpp:29 | landed |
| CRMVoidInstance::SetArea | RM_Instance_Void.cpp:47 | landed |
| CRMInstanceFile::CRMInstanceFile | RM_InstanceFile.cpp:33 | landed |
| CRMInstanceFile::~CRMInstanceFile | RM_InstanceFile.cpp:49 | landed |
| CRMInstanceFile::Open | RM_InstanceFile.cpp:67 | landed |
| CRMInstanceFile::Close | RM_InstanceFile.cpp:114 | landed |
| CRMInstanceFile::CreateInstance | RM_InstanceFile.cpp:138 | landed, two holes |

Every function of the set landed. CreateInstance holds two inline holes, the `group` and `random` arms at `RM_InstanceFile.cpp:169` and `:173`, each with a Port-note that names set R1b and a `portMissing` call. CRMGroupInstance and CRMRandomInstance are set R1b.

## The form of the hierarchy

No class hierarchy existed in the port before this round, and R11 calls this one the example for later ones. The choices below fill the details that R11 does not fix.

- `final class CRMInstance` holds Raven's base fields. Raven's protected fields are internal, because the extension of each subclass file reads them. The class has no deinit, because Raven's destructor at `RM_Instance.h:62` is empty.
- The field `kind` is the nested `enum Kind`. This round declares the two cases of its set, `bsp(CRMBSPInstance)` and `void`. R1b adds `group(CRMGroupInstance)` and `random(CRMRandomInstance)`, and the compiler then names each switch that needs a new arm.
- The payload of a case is a `struct` with the name of Raven's subclass, and it holds only the fields that the subclass adds. `CRMBSPInstance` holds `mBsp`, `mAngleVariance`, `mBaseAngle`, `mAngleDiff`, and `mHoleRadius`, plus the BSP methods that read only those fields: GetHoleRadius, GetModelName, GetAngleDiff, and GetAngularType. CRMVoidInstance adds no field, so `void` has no payload and no struct.
- Each subclass constructor is a `convenience init` in its file, labeled with the case: `CRMInstance(bsp: group, self)` and `CRMInstance(void: group, self)`. It calls the base `init(_ instGroup:, _ instFile:, _ kind:)` first, as Raven's initializer list does. A constructor that writes payload fields writes them into a local payload and stores it in `kind` at its end, under an AI line.
- Each virtual method of the base is one method with Raven's name and a `switch self.kind`.
- An override is an extension method in the file of its subclass, named `<RavenClass>_<Method>`, for example `CRMBSPInstance_Spawn` and `CRMVoidInstance_SetArea`. Its doc line names Raven's qualified name. Where the override reads payload fields, the switch binds the payload and passes it as the first parameter, `CRMBSPInstance_Spawn(bsp, terrain, IsServer)`. A Raven read of `mBsp` is then `bsp.mBsp`.
- A base body that a subclass calls by its qualified name, Raven's `CRMInstance::SetArea(amanager, area)`, is a method named `CRMInstance_<Method>`, and the switch arm of each case with no override calls it. The base bodies of PreSpawn, Preview, SetArea, SetFilter, SetTeamFilter, and SetMirror take this form, because Group or Random call each one by name. Every other base body stands inline in the switch arm.
- A non-virtual method is a plain method with Raven's name and no switch.
- GetOrigin returns a copy of the area origin, the form of `CRMArea.GetOrigin`, under an AI line. A write through Raven's pointer, such as `GetOrigin()[2] -= 16`, writes `self.mArea!.mOrigin`.
- `CRMInstanceFile` is a `final class`, because Raven passes it by reference to each constructor. CRMMission holds it by value at `RM_Mission.h:22`. R1c adds that field.

## The virtual methods and their arms

R1b continues from this table. "base" is the base body, inline or as `CRMInstance_<Method>`. Raven's Group and Random columns come from `RM_Instance_Group.h` and `RM_Instance_Random.h`.

| Virtual | Swift base body | bsp | void | Raven group | Raven random |
| --- | --- | --- | --- | --- | --- |
| IsValid | inline `true` | base | base | base | own (`mInstance != NULL`) |
| PreSpawn | `CRMInstance_PreSpawn` | base | base | own, calls base | own |
| Spawn | inline `false` | `CRMBSPInstance_Spawn` | base | own | own |
| PostSpawn | inline | base | base | base | base |
| Preview | `CRMInstance_Preview` | base | base | own, calls base | base |
| SetArea | `CRMInstance_SetArea` | base | `CRMVoidInstance_SetArea` | own, calls base | own, calls base |
| SetFilter | `CRMInstance_SetFilter` | base | base | own, calls base | own, calls base |
| SetTeamFilter | `CRMInstance_SetTeamFilter` | base | base | own, calls base | own, calls base |
| SetMirror | `CRMInstance_SetMirror` | base | base | own, calls base | own, calls base |
| GetSurfaceSprites | inline | base | base | base | base |
| GetLockOrigin | inline | base | base | base | own |
| GetSpacingLine | inline | base | base | base | own |
| GetPreviewColor | inline `0` | `CRMBSPInstance_GetPreviewColor` | base | own | own |
| GetSpacingRadius | inline | base | base | own (`0`) | own |
| GetFlattenRadius | inline | base | base | own (`0`) | own |

The destructor is empty in the base, BSP, and Void. Group and Random delete their child instances in their destructors.

## The sites with a note

- `CRMBSPInstance.swift`: Raven's `DEG2RAD(atof(...))` computes in double, because atof returns a double. The macro expands at the three sites with one comment line, the form of the VectorInverseScaleVector site of `CCMLandScape.swift`.
- `CRMBSPInstance.swift`: the `float` mAngleVariance passes to the `int` parameter of irand with a C conversion line.
- `CRMBSPInstance.swift`: Raven's `sprintf` into `char temp[10000]` is Com_sprintf with the size, under the AI line of `CRMManager.swift:187`.
- `CRMBSPInstance.swift`: Raven saves and restores `sv.entityParsePoint`. The view setter interns the saved text, so the parse goes on over a copy of the same text, under an AI line.
- `CRMBSPInstance.swift`: the `trace_t tr` of Raven's block is `Trace.scratch`, and Raven's `return false` inside the block is the closure's `true`.
- `CRMInstanceFile.swift`: the second GetSubGroups of Open reads through NULL when the file holds no root group. The unwrap traps there, under a rule 19 Port-note.
- `CRMInstanceFile.swift`: Raven's static local `instanceID` has no read and no write, so the body drops it under an AI line.

## The gate

- `swift build -j 2`: exit 0. The one new warning is the unused result of `VM_Call` in CRMBSPInstance_Spawn, the same warning as the 59 other bare `VM_Call` lines of the build.
- `swift test --no-parallel -j 2`: exit 0, 162 tests pass, the count of the base.
