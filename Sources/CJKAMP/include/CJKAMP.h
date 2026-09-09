#ifndef CJKAMP_H
#define CJKAMP_H

// The defines live here and not in Package.swift, because the Swift importer parses this header without the target's cSettings.
// QAGAME, MISSIONPACK, _JK2, and NDEBUG mirror Raven's vcproj Release config for the MP game module.
// WIN32 and _WINDOWS stay off, because they gate macros and inline asm, not layouts.
// __linux__ selects the platform section of q_shared.h that jka-rust's oracle harnesses use.
// It routes SnapVector off the MSVC inline assembly and supplies ID_INLINE and MAC_STATIC.
#define QAGAME 1
#define MISSIONPACK 1
#define _JK2 1
#define NDEBUG 1
#define __linux__ 1

// Raven declares powf with an int exponent at q_shared.h:1242, which conflicts with the SDK's powf.
// We include math.h first so the real powf is declared under its true name, then rename every later powf token.
// This is the same shim jka-rust's oracle harnesses force-include.
#include <math.h>
#define powf raven_powf

// The MP public headers, in Raven's include order, through the committed symlink include/codemp.
// A headerSearchPath reaches the C compile but not the Swift importer, so the symlink is the path both see.
// This umbrella edits no Raven file. The module-private headers such as g_local.h stay out.
#include "codemp/game/q_shared.h"
#include "codemp/game/bg_public.h"
#include "codemp/game/g_public.h"
// PROTOTYPE: g_local.h is in for the GameWorld view prototype. The row B3 ruling decides whether it stays.
#include "codemp/game/g_local.h"

#endif
