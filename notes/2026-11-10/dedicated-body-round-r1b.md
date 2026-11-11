# The R1b body round of the dead-function wave

This record holds set R1b of section 4 of `notes/2026-11-10/docket-13.md`: `CRMGroupInstance` and `CRMRandomInstance` of Raven's RMG, in the hierarchy of set R1a. The branch is `ded-bodies-r1b` from `c7aad3e8`, in the worktree `/tmp/jka-r1b`. Ruling R11 of `notes/2026-11-10/dedicated-open-rows-ledger-13.md` and the record `notes/2026-11-10/dedicated-body-round-r1a.md` give the form. Every Raven cite is under `oracle/codemp/RMG/`, and every Swift file is under `Sources/JKAMP_DedLogic/`.

## The files

| Swift file | Raven files |
| --- | --- |
| CRMGroupInstance.swift | RM_Instance_Group.h, RM_Instance_Group.cpp |
| CRMRandomInstance.swift | RM_Instance_Random.h, RM_Instance_Random.cpp |
| CRMInstance.swift | RM_Instance.h: the `group` and `random` cases, their arms, the deinit, and `rmInstanceList_t` |
| CRMInstanceFile.swift | RM_InstanceFile.cpp:169 and :173, the two holes of CreateInstance |

## The functions

| Function | Raven | Status |
| --- | --- | --- |
| CRMGroupInstance::CRMGroupInstance | RM_Instance_Group.cpp:28 | landed |
| CRMGroupInstance::~CRMGroupInstance | RM_Instance_Group.cpp:120 | landed |
| CRMGroupInstance::SetFilter | RM_Instance_Group.cpp:137 | landed |
| CRMGroupInstance::SetTeamFilter | RM_Instance_Group.cpp:159 | landed |
| CRMGroupInstance::SetMirror | RM_Instance_Group.cpp:181 | landed |
| CRMGroupInstance::RemoveInstances | RM_Instance_Group.cpp:204 | landed |
| CRMGroupInstance::PreSpawn | RM_Instance_Group.cpp:228 | landed |
| CRMGroupInstance::Spawn | RM_Instance_Group.cpp:258 | landed |
| CRMGroupInstance::Preview | RM_Instance_Group.cpp:288 | landed |
| CRMGroupInstance::SetArea | RM_Instance_Group.cpp:315 | landed |
| CRMGroupInstance::GetPreviewColor, GetSpacingRadius, GetFlattenRadius | RM_Instance_Group.h:31 to :33 | landed |
| MAX_RANDOM_INSTANCES | RM_Instance_Random.h:9 | landed |
| CRMRandomInstance::CRMRandomInstance | RM_Instance_Random.cpp:29 | landed |
| CRMRandomInstance::~CRMRandomInstance | RM_Instance_Random.cpp:91 | landed |
| CRMRandomInstance::SetMirror | RM_Instance_Random.cpp:99 | landed |
| CRMRandomInstance::SetFilter | RM_Instance_Random.cpp:108 | landed |
| CRMRandomInstance::SetTeamFilter | RM_Instance_Random.cpp:117 | landed |
| CRMRandomInstance::PreSpawn | RM_Instance_Random.cpp:138 | landed |
| CRMRandomInstance::Spawn | RM_Instance_Random.cpp:159 | landed |
| CRMRandomInstance::SetArea | RM_Instance_Random.cpp:183 | landed |
| CRMRandomInstance::IsValid, GetPreviewColor, GetSpacingRadius, GetSpacingLine, GetFlattenRadius, GetLockOrigin | RM_Instance_Random.h:22 to :29 | landed |
| rmInstanceList_t | RM_Instance.h:120 | landed |
| CRMInstanceFile::CreateInstance, the `group` and `random` arms | RM_InstanceFile.cpp:169, :173 | landed |

Every function of the set landed, and no stub or hole stays open.

## The form

The round follows the form of R1a with no change. The payload structs `CRMGroupInstance` (`mInstances`, `mConfineRadius`, `mPaddingSize`) and `CRMRandomInstance` (`mInstance`) hold the fields that each subclass adds. Each constructor is a labeled `convenience init`, `CRMInstance(group: group, self)` and `CRMInstance(random: group, self)`, that writes a local payload and stores it in `kind` at its end. Each override is `CRMGroupInstance_<Method>` or `CRMRandomInstance_<Method>`, with the bound payload as its first parameter where it reads a payload field. Each "own, calls base" override calls `CRMInstance_<Method>` at the line where Raven calls `CRMInstance::<Method>`: first in SetFilter, SetTeamFilter, SetMirror, and Preview, after the collision change in Group SetArea, first in Random SetArea, and last in Group PreSpawn. Random PreSpawn does not call the base, as in Raven.

Three choices of this round fill details that R1a did not fix:

- `rmInstanceList_t` is `[CRMInstance]` in `CRMInstance.swift`, under an AI line. A for-in loop takes the place of each `rmInstanceIter_t` loop, and Swift has no alias for the iterator.
- `CRMInstance` now has a deinit at the cite of Raven's virtual destructor, `RM_Instance.h:62`. It switches on `kind` and runs the destructor of the subclass: `CRMGroupInstance_deinit` and `CRMRandomInstance_deinit`. The bsp and void arms do nothing, because their destructors are empty. The AI line "The class has no deinit" of R1a is gone.
- Raven's `delete` of a child is the release of the reference. RemoveInstances clears the Array in the payload and stores the payload again, and the Random destructor stores nil. Each site has an AI line.

## The sites with a note

- `CRMGroupInstance.swift`: Raven reads `minrange` and `maxrange` into locals that no line reads. The locals drop under an AI line, the form of `unzip.swift:1024`.
- `CRMRandomInstance.swift`: when no sub group is an instance, the loop has ended with `group` NULL, and Raven calls FindPairValue through NULL in the warning. The unwrap traps there, under a rule 19 Port-note.
- `CRMRandomInstance.swift`: when CreateInstance fails, Raven calls SetFilter through the NULL `mInstance` before IsValid can run. The unwrap traps there, under a rule 19 Port-note.

## The gate

- `swift build -j 2`: exit 0, with no warning in the files of the set.
- `swift test --no-parallel -j 2`: exit 0, 162 tests pass, the count of the base.
