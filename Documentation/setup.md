# Setup

Copy [local.example.json](local.example.json) to the ignored `local.json` alongside it. Relative paths resolve from this directory. Set the actual paths accessible to your chat or shell: installation `maindata`, the selective Vanilla extract, the directory with RDAExplorer's `AnnoRDA.dll`, and optionally a test mod directory and 117-capable offline evaluator. A local path is configuration, not an instruction to install or deploy. In a remote chat, supply the required native files explicitly.

The main development folders are `Recommended/`, `WIP/`, `YouKnowWhatYouDo/` and `shared_Mods/`. Work on a specific package; never point the game at the entire checkout. See the [workspace findings](reference/workspace.md) for overlapping variants.

On PC, use the game's actual Documents directory, typically `Documents/Anno 117 - Pax Romana/mods`, or its installation `mods` directory. Documents may be redirected. Pick one location and one copy per ModID, and do not leave both its ZIP and its unpacked folder active. The [official PC instructions](https://www.anno-union.com/modding-in-anno-117-pax-romana/) and [loader install guide](https://jakobharder.github.io/anno-mod-loader/install/) show the supported locations. The latter abbreviates the game folder. Keep a disposable save and an explicit test profile for runtime validation; inspect its loader log rather than assuming activation from a folder name.

The 117-aware [Anno Modding Tools](https://github.com/anno-mods/vscode-anno) extension can browse the installed RDA data and show patch diffs. Pin or record the tool version and choose 117 in the tool's configuration. Lua 5.3 and a 1800-only xmltest binary do not establish 117 compatibility. See [tools](tools/README.md) for extraction and validation.
