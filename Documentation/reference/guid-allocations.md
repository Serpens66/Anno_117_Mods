# Serp GUID and text-ID allocations

Current workspace register, reviewed 2026-11-12. The user confirms the reserved **inclusive range 1500000000-1500010000**. The [117 public registry](https://github.com/anno-mods/GuidRanges/blob/main/117/guids.md) records the same Serp range. This register covers local packages, not every published or externally installed mod.

## Allocation rules

- Check this register and rerun the scanner before allocating an ID. Reserve and document the intended owner before implementing. Do not choose IDs merely because a single package does not contain them.
- **1500001200-1500001299 is reserved exclusively for Cheat Keybinds (`cheat-keybinds-serp`).** Gaps inside that block remain reserved to this mod; they are not available to other mods.
- **1500000060-1500000062 are reserved for GameSpeed Multiplayer (`change-multiplayer-gamespeed-serp`) shortcut labels.** Retired Cheat Keybinds compatibility IDs 1500001249-1500001251 remain reserved within its exclusive block.
- Existing allocations outside this block remain with their recorded owners. References do not transfer ownership. Same-ModID copies are alternative/bundled packages, not independent allocation owners; reconcile their actual contents and never activate incompatible variants together.
- Assets and text LineIDs are separate runtime namespaces. The historical cross-kind reuse below is recorded accurately, but use a distinct numeric ID for new unrelated owners rather than introducing more cross-kind reuse.
- Preserve published IDs. Resolve old collisions by explicit compatibility/isolation or an authorized migration, not silent renumbering. No IDs were changed by this inventory.
- Lua literals and XML targets/references can identify occupied legacy IDs even when their definition is absent here. Reference-only IDs below are held pending provenance research, not offered as free.

## Declared allocations by ModID

Translation copies are collapsed to one allocation. Numeric ranges below are exact consecutive sets, not a claim that the holes between them are free.

| ModID | Asset definitions | Text definitions (LineID / legacy text GUID) |
| --- | --- | --- |
| `change-multiplayer-gamespeed-complicated-serp` | 1500000050-1500000051, 1500000054 | none |
| `change-multiplayer-gamespeed-serp` | 1500000050-1500000055 | 1500000060-1500000062 |
| `cheat-demo-start-serp` | 1500000000 | none |
| `cheat-keybinds-serp` | 1500000015-1500000017, 1500001201-1500001214, 1500001252-1500001253, 1500001256-1500001257, 1500001260-1500001273 | 1500000000, 1500000015-1500000017, 1500001221-1500001232, 1500001240-1500001248, 1500001254-1500001255, 1500001258, 1500001280-1500001293 |
| `copy-pools-ap-buildable-buildings-serp` | 1500000002-1500000005 | none |
| `testmod-serp` | 1500000021, 1500000030, 1500001166-1500001167 | none |
| `unhide-all-ships-and-buildings-serp` | 1500000001, 1500000006 | none |
| `unlock-all-ships-and-buildings-serp` | 1500000010 | none |

## Package boundaries

Each path is relative to the repository. A nested package belongs to its nearest modinfo file, not to the outer bundle.

| ModID | Package roots |
| --- | --- |
| `AIEnterSessionsAfterHuman_Serp` | `WIP/AI EnterSessionsAfterHumanAndAsksPermission (Serp)` |
| `better-passive-trading-serp` | `WIP/BT Better PassiveTrading (Serp)` |
| `blueblueprints-serp` | `Recommended/Blue Blueprints (Serp)` |
| `bluemapwater-serp` | `Recommended/Blue Map Water (Serp)` |
| `change-multiplayer-gamespeed-complicated-serp` | `WIP/Change Multiplayer GameSpeed COMPLICATED (Serp)` |
| `change-multiplayer-gamespeed-serp` | `Recommended/[Gameplay] GameSpeedMultiplayer` |
| `cheat-demo-start-serp` | `YouKnowWhatYouDo/Cheat Demo Start (Serp)` |
| `cheat-keybinds-serp` | `Recommended/Cheat Keybinds (Serp)`; `WIP/Cheat Keybinds (Serp)`; `YouKnowWhatYouDo/Cheat Demo Start (Serp)/Cheat Keybinds (Serp)` |
| `copy-pools-ap-buildable-buildings-serp` | `Recommended/Unhide All (Serp)/shared_CopyPools_AP_ConstrBuild`; `YouKnowWhatYouDo/Cheat Demo Start (Serp)/Unhide All (Serp)/shared_CopyPools_AP_ConstrBuild`; `YouKnowWhatYouDo/Unlock ShipsUnitsBuildingsl (Serp)/shared_CopyPools_AP_ConstrBuild`; `shared_Mods/shared_CopyPools_AP_ConstrBuild` |
| `display-buffs-from-others-serp` | `YouKnowWhatYouDo/DisplayBuffsFromOthers (Serp)` |
| `display-passive-tradegoods-serp` | `YouKnowWhatYouDo/BT Display All Goods at Merchants` |
| `testmod-serp` | `WIP/ztestmod` |
| `unhide-all-ships-and-buildings-serp` | `Recommended/Unhide All (Serp)`; `YouKnowWhatYouDo/Cheat Demo Start (Serp)/Unhide All (Serp)` |
| `unlock-all-ships-and-buildings-serp` | `YouKnowWhatYouDo/Unlock ShipsUnitsBuildingsl (Serp)` |
| `zoom-out-further-serp` | `Recommended/Zoom Out-In Further (Serp)` |

## Collisions and repeated copies

- **asset 1500000050:** `change-multiplayer-gamespeed-complicated-serp`, `change-multiplayer-gamespeed-serp`. Do not load the conflicting package set together.
- **asset 1500000051:** `change-multiplayer-gamespeed-complicated-serp`, `change-multiplayer-gamespeed-serp`. Do not load the conflicting package set together.
- **asset 1500000054:** `change-multiplayer-gamespeed-complicated-serp`, `change-multiplayer-gamespeed-serp`. Do not load the conflicting package set together.
- **Cross-kind numeric reuse 1500000000:** asset owner(s) `cheat-demo-start-serp`; text owner(s) `cheat-keybinds-serp`. This is not a same-namespace collision. In particular, the historical demo asset does not redeclare the Cheat Keybinds text as an asset.
- **Cross-kind numeric reuse 1500000015:** asset owner(s) `cheat-keybinds-serp`; text owner(s) `cheat-keybinds-serp`. This is not a same-namespace collision.
- **Cross-kind numeric reuse 1500000016:** asset owner(s) `cheat-keybinds-serp`; text owner(s) `cheat-keybinds-serp`. This is not a same-namespace collision.
- **Cross-kind numeric reuse 1500000017:** asset owner(s) `cheat-keybinds-serp`; text owner(s) `cheat-keybinds-serp`. This is not a same-namespace collision.
- Cheat Keybinds Recommended, WIP and historical demo copies share the same ModID. The current Recommended asset IDs and newly added reason-text IDs have no different-ModID declaration owner. Keep those alternative copies mutually exclusive.
- Shared construction-pool helpers are repeated inside bundles under the same ModID. Their different versions/contents must still be reconciled; duplicate ID ownership does not prove byte equivalence.

## Reference-only IDs held for investigation

These literal values occur in package XML/Lua but have no asset or text definition in the scanned workspace. They may be external dependencies, old 1800 material or arithmetic bases; they are not proven runtime allocations. Comments alone are excluded.

| Referencing ModID | IDs without a local declaration |
| --- | --- |
| `testmod-serp` | 1500000031 |

## Refresh and validation

Run `python Documentation/tools/inventory_guid_allocations.py --write` to regenerate this maintained register, then `python Documentation/tools/inventory_guid_allocations.py --check` to verify it. Review changed allocations and collisions before accepting the output. Default invocation prints a compact audit summary without changing files.

The scanner reads XML declarations (`Standard/GUID`, `Asset @GUID`, text `LineId` and legacy text GUID), XML references/targets, non-comment Lua numeric literals and the nearest package ModID. It does not execute Lua or the mod loader and cannot prove dynamically computed IDs or an unlisted external package set. All in-range numbers in documentation/tests are excluded because they are not game packages.

Scan totals: 21 package roots, 94 distinct declared numbers, 3 same-namespace different-ModID collisions and 4 cross-kind numeric overlaps. Known existing speed-prototype collisions are documented above; any new same-namespace conflict or foreign use of the Cheat Keybinds reserved block fails `--check`.
