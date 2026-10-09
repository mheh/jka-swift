# The gate-cost change

## The change

`draftcheck.py` splices the drafts of every stem of a run into the mirror and builds the game product once per pass. A `Stem` object holds the state of one stem. `attribute()` gives each error of a build to the stem whose mirror file the compiler names. An error in a file of no stem goes to an "other files" line and counts in the total. `run()` drafts again only the stems that got a new compile hole in the last build, and the other stems keep their drafts. The cap of 8 passes holds for the run. After the last pass, each stem prints its line, saves its compile holes to the `rejected` table, and writes its draft to `.build-draft/drafts/`, and the mirror gets the hand text again. A new line `run: N passes, N builds` closes the stem lines. The kept hand functions of an adopted stem stay as before. Item 10 of `docs/oracle-closure.md` and the `draftcheck.py` line of the README state the new shape.

## The test

`OneBuild` in `tests/test_draftcheck.py` runs two stems with a fake draft and a fake build. The first build rejects one statement of each stem, and the second build is clean. The test checks two passes, two builds, each compile hole under its own stem, and no defect left.

## The gates

1. The tool tests: 68 tests, 10 skipped, all pass.
2. `draftcheck.py --all`: 89 holes, 0 defects, 0 compile holes, 1 pass, 98 seconds.
3. `draftcheck.py --game`: 1157 holes, 0 cascade errors, 29 defects, 81 compile holes over 75 stems, 8 passes, 888 seconds. The cap of 8 passes stopped six stems.
4. `draftcheck.py --stem q_shared,g_main`: q_shared 159 holes, 0 defects, 22 compile holes over 2 passes. g_main 90 holes, 0 defects, 18 compile holes over 4 passes. The run took 5 passes and 208 seconds.

## The findings

1. The bg gate shows 89 holes against the reference of 107. G1 and R5 landed before this change, so the lower count can come from them. A bg run on 0004618 without this change would confirm it.
2. The game gate does not reach the reference. It shows 29 defects, 81 compile holes against 224, and 1157 holes against 1357. Six stems show their first defects only in pass 8 and hit the cap. The compiler stops the report of a file when other files of the same module fail, so in a shared build the defects of a stem show only after the defects of other stems go. Each pass clears one wave of stems, and the waves need more than 8 passes. The first defect line of each stem:
   - NPC_senses: `NPC_senses.swift:680: cannot convert value of type 'AlertEvent' to expected argument type 'UnsafeMutableRawPointer'`
   - NPC_spawn: `NPC_spawn.swift:1034: value of optional type 'GNPC?' must be unwrapped to refer to member 'clear' of wrapped base type 'GNPC'`
   - SpeederNPC: `SpeederNPC.swift:406: unary operators must not be juxtaposed; parenthesize inner expression`
   - ai_main: `ai_main.swift:801: extra argument in call`
   - ai_util: `ai_util.swift:347: binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'`
   - ai_wpnav: `ai_wpnav.swift:242: cannot convert return expression of type 'CharBuf' to return type 'String'`
3. The game gate took 888 seconds and passed the 600-second limit of one call, so it went on in the background. Eight builds of the full set cost more than the one-stem builds did, because each build compiles every drafted file.
4. The q_shared gate shows 159 holes and 22 compile holes against the reference of 167 and 35, with 0 defects. G1 and R5 are the expected cause.

## The cap run

`PASSES` is 24 for every run. The code does not tell a single-stem run from a shared run, so one cap applies to both. The tool tests pass, with 10 skipped.

`draftcheck.py --game` took 13 passes and 13 builds in 1144 seconds. It shows 1211 holes, 0 cascade errors, 0 defects, and 136 compile holes. The references are 1357 holes, 0 defects, and 224 compile holes. No stem hit the cap, and no defect remains.

1. The holes are 146 under the reference, and the compile holes are 88 under the reference. G1 and R5 landed before this run and lower both counts, but this run does not show how much of the difference comes from them.
2. The run passed the 600-second limit of one call, so it went on in the background. The run of one build per stem took 3,255 seconds, so this run takes about one third of that time.
3. The output prints no line for each pass and no wall time for each pass. It does not show how many stems still had a defect at pass 8, 12, 16, or 20.
