# General Luau, triggers and multiplayer

Anno 117 uses [Luau](https://luau.org/) according to the [117 scripting tutorial](https://github.com/anno-mods/modding-guide/blob/main/Scripting/Anno_117_Lua_Tutorial.md). The language is shared with other Luau hosts; their APIs are not the game's APIs. A stock Lua 5.3 run cannot verify this engine, and standalone Luau only checks what it can parse or execute without game bindings.

The [loader Lua reference](https://jakobharder.github.io/anno-mod-loader/lua-scripts/) documents a `Scripts` object in `modinfo.json`: `Modules` declares module paths, `Init` runs after mod loading, `Load` on new/loaded game, `Unload` on unloading, and `Tick` on the metagame tick. A trigger action is a separate execution path. For a concrete change, establish what is available in each callback, what survives a reload, and what listeners need removing.

Use `data/script/types/system.lua`, `events.lua` and `types/generated/rdgs/` as an API map, then read real calls in `core/`, `modules/`, `content/` and `version/`. Generated functions with empty bodies establish declarations, not working implementations or peer semantics. For example, `system.lua` annotates `await`, and `core/scriptsystem.lua` uses it with game futures; `events.lua` distinguishes session load/enter and metagame unload. Avoid assuming 1800 `ts` objects, event wiring, timing and synchronous reads behave the same. In particular the stub for `GetSessionGameObject` lives in `cmetagameobjectmanagerluabindings.lua`; confirm the actual global owner rather than copying a workspace comment.

## Vanilla Lua source map

The Lua source root is `<vanillaPath>/data/script/`, resolved through ignored `Documentation/local.json`. Verify the relevant files against the current extraction manifest before using their declarations or consumers.

| Location below data/script | Purpose |
| --- | --- |
| `types/generated/globals.lua` | Resolve accessible singleton names to their declared types, e.g. Selection, Area, Economy, Cheat, Conditions, Scripts and TechHandler. |
| `types/generated/rdgs/` | Read the corresponding class signatures, property types, overloads and validity checks. Colon calls pass self; global properties such as Participants.GetCurrentParticipantGUID are read without parentheses. Generated empty bodies are declarations only. |
| `types/generated/datasets/` | Inspect the enum used by a signature, then cross-check config/game/datasets.xml; do not reuse 1800 enum values. |
| `types/system.lua`, `events.lua` | Host logging, coroutine/future primitives and event declarations. `system.run(path)` starts a coroutine, `system.require(path)` mimics Lua 5.1 require, and `system.dofile(path)` executes a script file. |
| `core/scriptsystem.lua`, `core/core.lua` | Actual helpers layered on top of the host. For example, system.wait(delay) awaits system.sleep(delay); a declaration of an async call is not a synchronous result. |
| `modules/`, `content/`, `version/` | Actual native consumers and lifecycle examples; use the manifest to distinguish current files from old research-folder leftovers. |

The modloader's Init hook can assign a module returned by require to a uniquely named global. Load/Unload reset per-game module state; a cached module does not automatically reset its variables on save reload. A module definition and its shortcut call must agree on dot versus colon syntax. A mod-global call from ShortcutConfig is supported by the public script-testing example. [Script-testing example](https://github.com/03szust/script-testing/blob/main/data/base/config/export/assets.xml)

## Native shortcut configuration

Native ShortcutConfig asset 2001271 uses `Values/ShortcutConfig/InputBindings`, with separate Modern/Legacy presets. A Command is a string and the inspected native examples call singleton methods. Trace the current target, property defaults, input type and actual consumer before changing shortcut behavior.

## Validation and package examples

Test locally with a disposable save, then check distinct participants and co-op peers, their active sessions, reconnect and removal when applicable. Record the initiating peer and exactly what every other peer sees. Metadata multiplayer flags, no crash on launch, and shared code on disk are separate from synchronization evidence.

The package patterns, mock checks and user observations for Serp's GameSpeedMultiplayer and Cheat Keybinds are maintained in the mod-specific examples. Their source and runtime limits are recorded with each package version. [Serp mod runtime examples](../mods/runtime-examples.md)
