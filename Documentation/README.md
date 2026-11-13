# Anno 117 modding knowledge base

This is the maintained reference for this single Anno 117: Pax Romana PC mod repository. It is modeled on the Anno 1800 workspace, with 117 sources and version boundaries. The initial baseline is the local PC archives matching **Update 3.0 (2026-11-05)** and public sources checked through **2026-11-10**. Future work must verify the installed build and the [coverage](reference/coverage.md) and [discrepancy](reference/discrepancies.md) registers.

## Documentation scope

| Area | Contents |
| --- | --- |
| [Vanilla](vanilla/README.md) | Native game files, schema/defaults, source provenance, cross-game contracts and released game changes. |
| [Serp's mods](mods/README.md) | Serp package implementations, GUID ownership, bundled variants, mod-specific checks and user observations. |
| Foundations, setup and tools | Shared modding methods, public loader/tool contracts and machine configuration. Mod-specific tools are labeled with their package scope. |
| Reference | Shared source register, coverage summary and general discrepancies. Detailed Serp package ledgers live under mods. |

Read the Vanilla and shared chapters for native research. Read the Serp mod chapters when working on the named packages or assessing their examples. A mod test result retains its package version and test context.

| Task | Start here |
| --- | --- |
| Prepare a local or external Codex chat | [Instructions](../AGENTS.md), [setup](setup.md), [workflow](workflow.md) |
| Trace a native feature from definition to consumers | [Vanilla audit](vanilla/research.md), [audit template](templates/audit.md) |
| Package mods, avoid collisions, port a feature | [Loader and porting](foundations/loader-and-porting.md) |
| Allocate Serp GUIDs or check existing ownership and collisions | [GUID allocation register](mods/guid-allocations.md) |
| Compare a native system or mod pattern with Anno 1800 | [1800 comparison](vanilla/anno-1800-comparison.md) |
| Work on scripts, triggers or multiplayer | [Luau and runtime](foundations/luau-and-runtime.md) |
| Find native Lua owners and shortcut configuration | [Lua source map](foundations/luau-and-runtime.md#vanilla-lua-source-map) |
| Inspect Serp's Cheat Keybinds implementation and tests | [Cheat Keybinds audit](mods/cheat-keybinds-audit.md) |
| Choose a repository example and locate its history | [Workspace findings](mods/workspace.md), [file inventory](mods/workspace-inventory.json) |
| Understand update effects and current tool support | [Changelogs](vanilla/changelogs.md), [source register](reference/sources.md) |
| Refresh the extract or check the documentation | [Tools](tools/README.md), [baseline receipt](vanilla/baseline.json) |
| Record a finding or correction | [Maintenance](maintenance.md) |

## Start a chat on another PC or without filesystem access

Provide the repository checkout, or a document bundle containing the root `AGENTS.md`, this README, `reference/coverage.md`, `reference/discrepancies.md`, `setup.md`, `workflow.md` and the relevant topic chapters with their referenced evidence. Preserve relative paths when copying the bundle. The root instructions sit one directory above this README. [Project instructions](../AGENTS.md)

With filesystem access, the chat reads `Documentation/local.json` first to locate machine-specific sources. On a new PC, copy the empty template and fill only the fields needed for the task. Reading and explanation can start from the documentation while local tools require the configured inputs. [Setup and path fields](setup.md)

Without filesystem access, use the supplied documentation and reachable public references. For game-dependent decisions, supply the current Vanilla feature files and their build or extraction manifest. The local configuration describes locations accessible on its owner's machine. Check source availability in the chat's own environment and request essential missing files. [Source register](reference/sources.md) · [Feature audit](vanilla/research.md)

For a new chat, include this instruction with the documents.

> Read the project instructions, coverage and discrepancies, then the chapters relevant to my task. If you have filesystem access, consult Documentation/local.json and resolve relative paths from its directory. Use the source register for public references. Complete the current Vanilla feature audit before game-dependent decisions and record source evidence and validation limits.

## Evidence labels

**Vanilla** means structure observed in the recorded files; **loader reference/source** means published syntax or implementation scoped to its source version; **workspace** means local code or metadata; **author report** means an observation recorded by its author; **inference** means a conclusion drawn from that evidence; **pending** means unavailable or not established. No game or multiplayer tests were performed for this baseline.
