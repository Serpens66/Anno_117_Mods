# Local tools

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
