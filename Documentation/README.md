# Anno 117 modding knowledge base

This is the maintained reference for this single Anno 117: Pax Romana PC mod repository. It is modeled on the Anno 1800 workspace, with 117 sources and version boundaries. The initial baseline is the local PC archives matching **Update 3.0 (2026-11-05)** and public sources checked through **2026-11-10**. Future work must verify the installed build and the [coverage](reference/coverage.md) and [discrepancy](reference/discrepancies.md) registers.

| Task | Start here |
| --- | --- |
| Prepare a local or external Codex chat | [Instructions](../AGENTS.md), [setup](setup.md), [workflow](workflow.md) |
| Trace a native feature from definition to consumers | [Vanilla audit](foundations/vanilla-research.md), [audit template](templates/audit.md) |
| Package mods, avoid collisions, port a feature | [Loader and porting](foundations/loader-and-porting.md) |
| Allocate Serp GUIDs or check existing ownership and collisions | [GUID allocation register](reference/guid-allocations.md) |
| Compare a native system or mod pattern with Anno 1800 | [1800 comparison](reference/anno-1800-comparison.md) |
| Work on scripts, triggers or multiplayer | [Luau and runtime](foundations/luau-and-runtime.md) |
| Find Vanilla Lua owners, port shortcut commands or check Cheat Keybinds | [Lua source map](foundations/luau-and-runtime.md#vanilla-lua-source-map), [Cheat Keybinds audit](reference/cheat-keybinds-audit.md) |
| Choose a repository example and locate its history | [Workspace findings](reference/workspace.md), [file inventory](reference/workspace-inventory.json) |
| Understand update effects and current tool support | [Changelogs](reference/changelogs.md), [source register](reference/sources.md) |
| Refresh the extract or check the documentation | [Tools](tools/README.md), [baseline receipt](reference/vanilla-baseline.json) |
| Record a finding or correction | [Maintenance](maintenance.md) |

For an external chat: give it this repository or these documents and the feature's current Vanilla files from your own installation. Ask it to read AGENTS, coverage and discrepancies before making any game-dependent decision. No private paths or extracted Vanilla files are required to read this documentation.

Evidence labels: **Vanilla** means structure observed in the recorded files; **loader reference/source** means published syntax or implementation scoped to its source version; **workspace** means local code or metadata; **author report** means an observation recorded by its author; **inference** means a conclusion drawn from that evidence; **pending** means unavailable or not established. No game or multiplayer tests were performed for this baseline.
