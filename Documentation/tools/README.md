# Local tools

## GUID allocation inventory

Run `python Documentation/tools/inventory_guid_allocations.py --check` before allocating new IDs. The maintained [register](../reference/guid-allocations.md) records Serp's inclusive 1500000000-1500010000 range, package owners, variants, reference-only holds and known historical collisions. After reviewing allocations, regenerate with `--write` and recheck. Default invocation is read-only. The Cheat Keybinds block 1500001200-1500001299 is reserved to that ModID; new foreign use or unexpected same-namespace ownership conflicts fail the check.

## Refresh the selective Vanilla snapshot

Use PowerShell on Windows with the user-supplied RDAExplorer installation. The [extractor](Extract-Anno117.ps1) loads that installation's `AnnoRDA.dll`, indexes installed `*.rda` in its natural container order and takes the last selected entry for a duplicate virtual path. This is the extraction overlay, not a claim about every runtime file-resolution rule. If an archive fails to index or an entry has a size mismatch, discard the incomplete snapshot; it has no completed manifest.

From `Documentation`, set up [local configuration](../setup.md), then choose a **new** output directory outside the repository:

    $cfg117 = Get-Content -LiteralPath .\local.json -Raw | ConvertFrom-Json
    .\tools\Extract-Anno117.ps1 -RdaExplorerPath $cfg117.rdaExplorerPath -MainDataPath $cfg117.mainDataPath -OutputPath ..\..\RDAs\next-snapshot

The filter accepts `.xml`, `.lua`, `.luau` and `.srt`, excluding graphics paths and generated soundbank catalogs. The only added binary path is `data/infotips/export.bin`. The extractor copies its raw bytes alongside the text and script sources and records its winning archive, size and SHA-256 in `anno117-rda-manifest.json`. Text exports from `config.rda` include all shipped language XMLs in that archive. Other media, binaries and UI JSON require a targeted extract. [InfoTip supplement](../foundations/vanilla-research.md#infotips-and-other-resources)

Verify representative files and the manifest before replacing the selective files in a live research folder. `current` was pre-existing in this workspace and was updated at paths listed by its manifest; it retains old, unlisted files and shortcuts. For clean research use a fresh extraction or consult the manifest. Do not delete or merge archived materials without checking the destination.

## Checks

- The [inventory tool](inventory_workspace.py) records sizes/hashes, source kinds, text encodings, XML structure, references and package metadata. Run it with a Python 3 interpreter from any directory: `python inventory_workspace.py <repo> <output.json> --revision <commit>`. Put refresh outputs under ignored `Documentation/out` until reviewed.
- Run JSON/XML parsing and Markdown link checks first. For patches, use a 117-compatible xmltest or the editor's patch diff, then inspect diagnostics and the actual patched subtree. See the [loader debug reference](https://jakobharder.github.io/anno-mod-loader/debug/). Lua/Luau and Git invocations follow the workspace permission route.
- Check the game-generated `mods/mod-loader.log` on an authorized game run. A structural pass or evaluator pass does not prove game runtime, save removal or multiplayer compatibility.

## Cheat Keybinds offline checks

From the repository root run `python Documentation/tools/check_cheat_keybinds.py` using Python with lxml. The script reads `Documentation/local.json`, checks XML/metadata/text IDs and basic structural patch expectations, then generates `Documentation/out/cheat-keybinds-mock.luau`. Run that file with a standalone Luau CLI and compile `Recommended/Cheat Keybinds (Serp)/data/cheatkeybinds_serp.lua` with `luau-compile --null`, both outside the Windows sandbox through the supported permission route. The 2026-11-12 run used official Luau 0.746. These are structural and mocked language checks, not 117 loader/game/save/multiplayer tests. [Audit](../reference/cheat-keybinds-audit.md)

The 1.14.1 label checks use `modsPath` to read the installed `console-ubi` and `[Gameplay] GameSpeedMultiplayer` definitions and project all four optional-mod combinations without changing either package or activation. Both source definitions must be accessible to run this offline compatibility check even though neither mod is a runtime requirement. Selection notifications are asserted to have IsSilent=0; actual visibility still requires a game test.


For 1.15.0, additionally check the explicit menu-to-notification mapping, 16 notice priorities=-1, the two native reputation action trigger payloads, the extra configurable alternative shortcut in both presets and directed mocked calls. Compile the changed module with Luau, then run the generated mock harness through the approved outside-sandbox route. Report actual check output/counts after execution; declarations and mocks do not establish notification replacement, negative amounts, workforce quantity, research refunds or multi-AI cooldown behavior.
