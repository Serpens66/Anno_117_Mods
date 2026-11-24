# Feature-specific Vanilla audit

Do this before any choice that depends on game behavior. The [baseline receipt](baseline.json) and local extraction manifest help find files and check their provenance. Neither certifies a feature.

1. **Identify context.** Record patch, DLC, province, game mode, owner/peer context, new or existing save, and loaded mods. Confirm that the local manifest matches the installation; disregard stale files absent from the manifest.
2. **Find the effective target.** Under `data/base/config/`, start with `export/assets.xml`, `export/templates.xml`, `export/properties.xml`, `export/properties-meta.xml`, `game/datasets.xml` and `gui/texts_*.xml`. There is no matching `properties-toolone.xml` or `export.xml` in the selective 3.0 snapshot. Use the actual archive paths for other resources; Lua source and stubs are under `data/script/`.
3. **Resolve values.** Find the asset by `Standard/GUID` and record its template and any `BaseAssetGUID` chain. Compare explicit values with template `Properties`, the property default data, and typed metadata. Inspect several native examples. Verify list identity and distinguish absent, empty, zero and inherited values. An explicit asset subtree alone does not tell you the effective value.
4. **Follow consumers and references.** Inspect the relevant reverse references, pool/trigger/condition/quest chains, native scripts or binding signatures and dataset values. For strings, follow `OasisId` to the corresponding `LineId` as signed 64-bit decimal text; do not round or coerce through floating-point numbers. The 117 export contains negative native IDs. Compare at least the languages affected.
5. **Close the audit.** Record evidence and remaining uncertainty using the [template](../templates/audit.md). If a missing essential source could change the decision, obtain it first. Verify intended XPath match counts before a patch and exact before/after nodes afterward. XML and generated stubs expose structure and signatures; test lifecycle, save and multiplayer effects separately.

**Vanilla evidence, 3.0:** `assets.xml` uses `AssetList`, `Template`, `BaseAssetGUID`, `Standard/GUID` and `Text/OasisId`; see examples at lines 6, 38 and 33909. `texts_english.xml` begins with `TextExport` and a negative `LineId` at line 4. `properties-meta.xml` describes `ActionExecuteScript/ScriptFileName` at 6104–6109; see the [runtime chapter](../foundations/luau-and-runtime.md) for the native Lua source map and API lookup method.

## InfoTips and other resources

The selective extraction includes the raw `data/infotips/export.bin`. Confirm its manifest entry before tracing a layout. The 117 patch path is `data/infotips/export.bin.xml`. Keep layout GUIDs, consumer fields and localized text IDs distinct. The loader XML uses attributes on `InfoElement` and `VisibilityElement`, hides count fields and uses Oasis `TextId`. FileDBReader output can differ from loader XML. Check the selector against a representation that matches the tool used for patch evaluation. [Loader InfoTip reference](https://jakobharder.github.io/anno-mod-loader/infotips/)

The **2026-11-10 InfoTip supplement** to the original 3.0 snapshot refreshed the local binary and added its manifest entry. The installed `infotips.rda` supplies 2,394,704 bytes with SHA-256 `e84254fe137deb3c73de90c68737afd06ca2cab70cca9c7e296e56fc84c3200e`. The archive stream, fresh extraction and refreshed local file matched. The XML inspection export was subsequently produced on 2026-11-12 as described below; loader evaluation remains open. [Original baseline receipt](baseline.json) · [Extraction tools](../tools/README.md)

Generated Phoenix UI files, other FileDB containers, model configuration, media and province data need targeted extraction or conversion. Confirm their format and target path on the installed build. [Phoenix inspection](../tools/README.md#inspect-phoenix-ui-resources)

## Native XML dialect

The five main asset/template/property/dataset inputs and text exports passed a strict XML parse. Other native `.xml` files can use game-specific syntax: 104 files were rejected by the strict parser, including ambient settings with shorthand closing tags, `engine/globals.xml`, `engine/prop_sets.xml` and `game/camera.xml`. They match the archive bytes. Preserve the originals and use a loader-aware tool for affected targets. See the receipt for paths and parser messages.

## Local InfoTip XML inspection export (2026-11-12)

At the user's request, FileDBReader 3.0.3 decoded the current `data/infotips/export.bin` with compression version 2 and the available `infotip_117.xml` interpreter. Its default output is `data/infotips/export.xml` alongside the binary, NOT `export.bin.xml`. The resulting 5,424,089-byte XML parses with root Content and 1,076 InfoTipData entries, including exactly one Guid500664 and one Guid25345. The binary remains unchanged at 2,394,704 bytes / SHA-256 e84254fe137deb3c73de90c68737afd06ca2cab70cca9c7e296e56fc84c3200e. This derived inspection file stays outside Git and the original RDA extraction manifest.

Resolve the tool and interpreter via optional `fileDBReaderPath` / `infoTipInterpreterPath` in ignored local.json, then call `decompress -f <vanillaPath>/data/infotips/export.bin -c 2 -i <interpreter>`. Do not overwrite an existing export without checking it. The interpreter reported duplicate selections, empty fields and wrong byte sizes (for example FirstValue/SecondValue); a successful exit and well-formed XML do not validate every interpreted type or a compress/edit round trip. Use this output for inspection, preserve the binary and verify any field before modifying it. FileDBReader XML is also distinct from the mod loader's export.bin.xml patch representation.

InfoTip500664 (SideNotificationInfoTip) contains ElementType25 and TextId -6902128858514781674. That ID was not found in any of the 12 inspected language text exports; no dynamic-text semantics are inferred. The static AutosaveLimit_InfoTip25345 remains distinguishable. In installed config.rda, 154 explicit SideNotification instances (standalone NotificationType and inline ActionNotification/Notification, excluding other notification templates) comprise 140 inherited Infotip values and 14 explicit zeros; there is no explicit nonzero override. The inherited default is 500664. This counts declarations, not runtime deliveries or every derived asset.

### SideNotification hover status (2026-11-12)

The hover experiments, user runtime observations and resulting inference were recorded while developing Serp's Cheat Keybinds. Their tested scope and current package status are maintained with the mod documentation. [Serp's notification observations](../mods/notification-observations.md)

## HUD scene resources and writable bindings (2026-11-24)

A targeted check across all 41 installed PC archive indexes, including `zz_patchfiles_301.rda`, verified the following native resources under `data/ui/studio/generated/`. These three files were byte-identical to the matching files in the local extract. The generated UI resources are binary and sit outside the selective 3.0 manifest.

| Native resource | Archive | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| `hudarchivesscene` (`PHXSC`) | `ui.rda` | 1,923 | `16051a905f50cc20948430ad60ec5644bd02327e06f0ee84639b56c966905d15` |
| `hudgovernorsbarscene` (`PHXSC`) | `ui.rda`, `zz_patchfiles_150.rda` (identical) | 1,332 | `2edf44c9e469794e6d93b572e96bdbaed9ec12589c4c0fc822257ff567a2a8d6` |
| `df80c10b-e116-4fc7-a0e7-5495ac9a731d` (`PHXWI`, `Good_Atom`) | `ui.rda` | 1,828 | `c7e96596632d6b2c57ed3b4a02a455d61af836eb9be3de125ab09d24ea473fba` |

The installed `script.rda` stubs under `data/script/types/generated/rdui/gameobjects/` expose string getters and setters for `NotificationArchiveTabsData.CurrentTabName` and `HUDGovernorsBar_LocationData.Second_Third_PartyName`. The corresponding scene data paths are `HUDArchives.SceneData.NotificationArchive.NotificationArchiveTabs` and `HUDGovernorsBar.HUDGovernorsBarData.IslandData.SecondAndThirdPartyData`. `DragSceneObject.LoadingData` exposes the active drag data. The `rdgs/careaeconomyluabindings.lua` stub exposes `GetStorageAmount(productGUID)`.

The working Lua fields have native consumers. These additional effective resources were checked against the installed archives before inspecting their decoded graphs.

| Native resource under `data/ui/studio/generated/` | Effective archive | Observed consumer |
| --- | --- | --- |
| `ebe57eed-b91b-49bf-868b-2df9ed8bbe1d` | `ui.rda` | The notification archive reads the `CurrentTabName` binding path to display the tab name. |
| `105abc85-7a2a-4d9c-a692-12116b4d9184` | `zz_patchfiles_300.rda` | The island HUD binds `Second_Third_PartyName` to the second/third-party label `H02.Text`. |
| `d3b4a81c-cbd4-464f-9939-b621eb94a8c8` | `zz_patchfiles_300.rda` | The native DropZone template binds `DropZone.DropSuccessful` to its success sound. |
| `90cab494-fd20-409d-a168-93b64492c76c` | `zz_patchfiles_300.rda` | The native Pin widget uses the same DropZone template and event in its own bindings, including a `DropZone_DS_Entry` instance. |

The patch300 entries differ from the legacy loose copies. Compare the effective archive members even when the path and byte length match the loose copy. Installed `script.rda` also supplies `types/ui.lua` and `types/phoenix.lua`. A name search across all 2,554 effective installed Lua/Luau files for widget creation, mounting and scene registration found the `CCheatBindings.ReloadUI` declaration, whose signature establishes a reload call. A widget or scene registration entry point remains unverified. The 41 archive indexes contained no XML or JSON under `data/ui/studio/generated/`. Some patch archives ship Studio JSON separately under `data/ui/studio/scenes/` for other scenes. Neither HUD scene had a matching Studio JSON file in those indexes.

The local Anno Toolbox 0.2.0 Phoenix reader decoded the three native files listed with hashes and all five package files to the end with no unknown types reported. [Phoenix inspection](../tools/README.md#inspect-phoenix-ui-resources)

In the external reference package `inselbar-tooltip-pin` 0.4.25, the two same-path scene replacements split the display and drop handling. The mod archive scene places a new `PHXWI` widget, `2e71e482-c681-5497-82e6-89da1b1c7c71`, with an HTML-enabled label and a new `PHXIM` image resource for its five empty slots. The archive scene passes its data binding into a custom widget property, which feeds the label. The mod governor scene contains five instances of the native `DropZone` widget. Their `DropSuccessful` events run `EventAssign` bindings that write the zero-width marker strings expected by the mod's Tick script. The script reads drag data and uses the governor string for drop signalling. It uses the archive tab-name string to pass a rich-text row to the UI, yielding the field while the notification archive is open. The widget renders goods and quantities as one formatted row. The two new UUID-named resources were absent across the 41 native archive indexes. The package also replaces the native `Good_Atom` widget `df80c10b-e116-4fc7-a0e7-5495ac9a731d`, changing only its fixed and proportional pivot and child position. Include this shared resource in conflict checks. [HUD compatibility](../foundations/loader-and-porting.md#phoenix-hud-compatibility)

The installed `infotips.rda` payload differs from the 3.0 snapshot. FileDBReader 3.0.3 with compression version 2 and the `infotip_117.xml` interpreter decoded one entry each for `500038`, `25000020`, `24252` and `501001`. The reference package's four InfoTip operations target these existing entries separately from the HUD scene changes. Selector counts are from the inspection representation.
