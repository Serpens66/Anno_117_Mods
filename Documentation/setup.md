# Setup

Copy [local.example.json](local.example.json) to the ignored `local.json` alongside it, then fill only the fields needed for the task. All values in the public template are empty. Keep an existing working local configuration when updating the repository.

Every configured path can be absolute or relative. Resolve relative values against the directory containing `local.json`, regardless of the shell's current directory. An empty string means the path is not configured. Values are literal paths, so expand environment variables yourself before storing them. Windows JSON paths can use `/` separators or doubled backslashes.

Chats with local file access read this configuration before locating game data, tools or external research folders. An absent configuration leads to this setup procedure for tasks that need local inputs. Reading the documentation and reachable public sources can continue independently. A chat without local filesystem access needs the relevant feature files supplied by the user. [Source register](reference/sources.md)

## Configuration fields

| Field | Points to | Needed for |
| --- | --- | --- |
| `mainDataPath` | The installed Anno 117 `maindata` directory containing RDA archives. | Refreshing or directly verifying installed Vanilla sources. |
| `vanillaPath` | The root of the user's current Anno 117 extraction, containing `data/` and its extraction manifest. | Native feature research and checks that read extracted Vanilla. |
| `rdaExplorerPath` | The tool directory containing `AnnoRDA.dll`. | The supplied PowerShell extractor. |
| `modsPath` | The actual user or installation mod directory selected for inspection. | Installation/profile checks and the console-package fallback used by the Cheat Keybinds checker. |
| `xmltestPath` | A matching 117-capable offline evaluator executable. | Offline loader evaluation when that tool is available. |
| `fileDBReaderPath` | The FileDBReader executable. | Decoding supported binary resources for inspection. |
| `infoTipInterpreterPath` | The 117 InfoTip format/interpreter XML used with FileDBReader. | InfoTip decoding. |
| `anno1800DocsPath` | An optional local copy of the broader Anno 1800 SharedMods documentation directory. | Cross-game source research. The source register also links the public repository. |
| `anno1800StarterPath` | An optional local Anno 1800 starter-kit root containing its `Documentation/` and tools. | Reproducing starter-kit examples and historical audits. |
| `anno1800VanillaPath` | An optional Anno 1800 extraction root containing `data/`. | Native comparisons against that user's 1800 files. |
| `referenceModsPath` | An optional directory of separately obtained reference mod packages. | Inspecting examples or dependencies beyond this checkout. |
| `researchNotesPath` | An optional directory of local research notes and historical source material. | Looking up supplementary notes by the filenames recorded in a finding. |
| `consoleModPath` | The root of a separately accessible `console-ubi` package containing `modinfo.json` and `data/`. | Cheat Keybinds compatibility checks. An explicit value takes precedence over `modsPath/console-ubi`. |

Missing optional paths block only the operations that need them. A tool requiring an input should identify the field and direct the user to this setup page. A configured path grants no installation, deployment or profile-edit authorization.

## Tools and workspace

Use Python 3 with `lxml` for the supplied XML/GUID and Cheat Keybinds checks. The RDA extractor requires PowerShell and a .NET runtime compatible with the configured `AnnoRDA.dll`. Standalone Luau and `luau-compile` are optional tools for the separately invoked language/mock checks. FileDBReader and its matching interpreter are needed for the documented InfoTip inspection workflow. Record tool versions with the results. [Tool commands](tools/README.md) · [InfoTip inspection](vanilla/research.md#local-infotip-xml-inspection-export-2026-11-12)

The main development folders are `Recommended/`, `WIP/`, `YouKnowWhatYouDo/` and `shared_Mods/`. Work on a specific package; never point the game at the entire checkout. See the [workspace findings](mods/workspace.md) for overlapping variants.

On PC, use the game's actual Documents directory, typically `Documents/Anno 117 - Pax Romana/mods`, or its installation `mods` directory. Documents may be redirected. Pick one location and one copy per ModID, and do not leave both its ZIP and its unpacked folder active. The [official PC instructions](https://www.anno-union.com/modding-in-anno-117-pax-romana/) and [loader install guide](https://jakobharder.github.io/anno-mod-loader/install/) show the supported locations. The latter abbreviates the game folder. Keep a disposable save and an explicit test profile for runtime validation; inspect its loader log rather than assuming activation from a folder name.

The 117-aware [Anno Modding Tools](https://github.com/anno-mods/vscode-anno) extension can browse the installed RDA data and show patch diffs. Pin or record the tool version and choose 117 in the tool's configuration. Lua 5.3 and a 1800-only xmltest binary do not establish 117 compatibility. See [tools](tools/README.md) for extraction and validation.

## Verify installation and startup activation

Store the actual user mod directory in `modsPath` in ignored `local.json`. Resolve the Windows Documents directory rather than assuming its location, and inspect the installation `mods` directory as well. Check any additional search locations reported by the loader log for another copy of the same ModID. A missing optional location is not an installation error.

For a mod folder that is a junction, inspect its `LinkType` and `Target`, then read `modinfo.json` through the installed path and compare the package files with the intended source. A junction to a development package exposes subsequent edits to the installed mod immediately. Do not copy a second package or recreate a working junction merely to update it. Installation, profile activation and successful loading are separate checks.

Inspect the profile selector and selected profile generated by the installed loader. Check that the intended ModID is enabled there, and inspect other selectors or activation files only when the actual installation uses them. Profile names and layouts can vary with the loader version. Record the observed files and version before proposing an edit. [Discrepancy D117-11](mods/discrepancies.md)

Read a fresh `mods/mod-loader.log` for the intended startup. Verify the loaded ModID and version, completed patching and any warnings or errors. Record file comparisons, activation, loader output and runtime observations separately. Repeat the check after an update.

The dated profile, junction and log observations from Serp's installation are recorded in the audit. Use the current machine's files for a new check. [Historical installation observations](mods/cheat-keybinds-audit.md#historical-installation-observations-2026-11-12) · [Ownership audit](mods/cheat-keybinds-audit.md#1155-gamespeed-label-ownership-and-installation-2026-11-12)
