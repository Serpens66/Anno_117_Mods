# Local tools

The extractor and workspace inventory support native research and general repository inspection. The GUID ownership scanner and Cheat Keybinds checker below apply to Serp's packages. [Vanilla sources](../vanilla/README.md) · [Serp mod evidence](../mods/README.md)

## Serp mod GUID allocation inventory

Run `python Documentation/tools/inventory_guid_allocations.py --check` before allocating new IDs. The maintained [register](../mods/guid-allocations.md) records Serp's inclusive 1500000000-1500010000 range, package owners, variants, reference-only holds and known historical collisions. After reviewing allocations, regenerate with `--write` and recheck. Default invocation is read-only. The Cheat Keybinds block 1500001200-1500001299 is reserved to that ModID; new foreign use or unexpected same-namespace ownership conflicts fail the check.

## Refresh the selective Vanilla snapshot

Use PowerShell on Windows with the user-supplied RDAExplorer installation. The [extractor](Extract-Anno117.ps1) loads that installation's `AnnoRDA.dll`, indexes installed `*.rda` in its natural container order and takes the last selected entry for a duplicate virtual path. This is the extraction overlay, not a claim about every runtime file-resolution rule. If an archive fails to index or an entry has a size mismatch, discard the incomplete snapshot; it has no completed manifest.

From the repository root, load the local configuration and choose a new absolute output directory outside the checkout. The following command resolves the two configured inputs from the configuration directory and prompts for the output. An existing output is rejected by the extractor.

```powershell
$documentation = (Resolve-Path -LiteralPath './Documentation').Path
$configPath = Join-Path $documentation 'local.json'
if (!(Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw 'Missing Documentation/local.json. See Documentation/setup.md.'
}
$cfg117 = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
foreach ($field in @('mainDataPath', 'rdaExplorerPath')) {
    $value = $cfg117.$field
    if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value)) {
        throw "Configure $field in Documentation/local.json. See Documentation/setup.md."
    }
    $resolved = [IO.Path]::GetFullPath([IO.Path]::Combine($documentation, $value))
    if (!(Test-Path -LiteralPath $resolved -PathType Container)) {
        throw "Configured $field directory is missing. See Documentation/setup.md."
    }
    $cfg117.$field = $resolved
}
$outputPath = Read-Host 'New absolute snapshot directory outside the checkout'
if ([string]::IsNullOrWhiteSpace($outputPath) -or ![IO.Path]::IsPathFullyQualified($outputPath)) {
    throw 'Choose an absolute output directory.'
}
& (Join-Path $documentation 'tools/Extract-Anno117.ps1') -RdaExplorerPath $cfg117.rdaExplorerPath -MainDataPath $cfg117.mainDataPath -OutputPath $outputPath
```

The filter accepts `.xml`, `.lua`, `.luau` and `.srt`, excluding graphics paths and generated soundbank catalogs. The only added binary path is `data/infotips/export.bin`. The extractor copies its raw bytes alongside the text and script sources and records its winning archive, size and SHA-256 in `anno117-rda-manifest.json`. Text exports from `config.rda` include all shipped language XMLs in that archive. Other media, binaries and Phoenix UI resources require a targeted extract. [InfoTip supplement](../vanilla/research.md#infotips-and-other-resources)

Verify representative files and the manifest before replacing the selective files in a live research folder. `current` was pre-existing in this workspace and was updated at paths listed by its manifest; it retains old, unlisted files and shortcuts. For clean research use a fresh extraction or consult the manifest. Do not delete or merge archived materials without checking the destination.

## Inspect Phoenix UI resources

1. Resolve the research inputs from ignored `Documentation/local.json`. List the exact virtual paths under `data/ui/studio/generated/` in the installed archives, including patch archives. Read the effective members in the extractor's container order, recording archive, size and SHA-256. Compare hashes before reusing loose files from an older or selective snapshot. Use a disposable output location for targeted extraction.
2. Open the installation or a folder of loose files in the Anno Toolbox UI editor. The inspected resources use `PHXSC` for scenes, `PHXWI` for widgets and `PHXIM` for images. For scripted inspection with local Anno Toolbox 0.2.0, use `annotoolbox.formats.phoenix.load_schema`, `phoenixread.load` and inspect the decoded root and bindings. A hex or string scan can locate a name or UUID, while the decoded structure shows its role and references. [Anno Toolbox UI editor](https://github.com/SunnyM00n/anno-toolbox/blob/main/docs/ui-editor.md)
3. Compare native and mod instance trees and record which UUID-named files are new or same-path replacements. Follow container references to widget and image assets. Resolve event and property IDs against game-object metadata, generated `rdui` stubs and native bindings with the same path. Cross-check the Lua callbacks that read or write those properties.
4. Before editing, check decode and byte-identical save with `phoenixwrite.save` for the exact inputs. After editing, decode the new output, check intended instance/binding counts and verify endpoints, shared resources and references. A codec round trip or editor preview establishes offline structure. Check runtime behavior separately in an authorized isolated game test.

The [HUD audit](../vanilla/research.md#hud-scene-resources-and-writable-bindings-2026-11-24) applies this method to Inselbar and records the effective native consumers.

## Checks

- The [inventory tool](inventory_workspace.py) records sizes/hashes, source kinds, text encodings, XML structure, references and package metadata. From the repository root, run `python Documentation/tools/inventory_workspace.py <repo> <output.json> --revision <commit>`. From another working directory, supply the script's absolute path. Put refresh outputs under ignored `Documentation/out` until reviewed.
- Run JSON/XML parsing and Markdown link checks first. For patches, use a 117-compatible xmltest or the editor's patch diff, then inspect diagnostics and the actual patched subtree. See the [loader debug reference](https://jakobharder.github.io/anno-mod-loader/debug/). Lua/Luau and Git invocations follow the workspace permission route.
- Check the game-generated `mods/mod-loader.log` on an authorized game run. A structural pass or evaluator pass does not prove game runtime, save removal or multiplayer compatibility.

## Serp mod Cheat Keybinds offline checks

From the repository root run `python Documentation/tools/check_cheat_keybinds.py` using Python 3 with lxml. From another directory, supply the script's absolute path. Its configuration and output locations are anchored to the repository. The script reads `Documentation/local.json`, checks XML/metadata/text IDs and basic structural patch expectations, then generates `Documentation/out/cheat-keybinds-mock.luau`. Run that file with a standalone Luau CLI and compile `Recommended/Cheat Keybinds (Serp)/data/cheatkeybinds_serp.lua` with `luau-compile --null`, both outside the Windows sandbox through the supported permission route. The 2026-11-12 run used official Luau 0.746. These are structural and mocked language checks, not 117 loader/game/save/multiplayer tests. [Audit](../mods/cheat-keybinds-audit.md)

The compatibility checks use `consoleModPath` for the `console-ubi` package, falling back to `modsPath/console-ubi` when that field is unset. Both paths resolve relative to `Documentation/local.json`. The Gamespeed input is the maintained package inside this checkout. The checker projects all four presence combinations and needs both package sources for this check. Set the console path to a separately obtained package if it is absent from the installation. Selection notifications are asserted to have IsSilent=0; actual visibility still requires a game test.


For the 2026-11-24 popup release, the checker covers the selection icon and text mapping, portrait and profile references, primary and alternative result mapping, and prerequisite error routing. Pass `--vanilla-path` with a fresh effective extract when the configured baseline predates the installed game. The override must contain the current assets, templates, property metadata and all language exports. Compile the module and run the generated Luau harness through the approved outside-sandbox route. Report the actual outputs separately from in-game observations.
