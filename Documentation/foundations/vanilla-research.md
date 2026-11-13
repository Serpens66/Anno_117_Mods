# Feature-specific Vanilla audit

Do this before any choice that depends on game behavior. The [baseline receipt](../reference/vanilla-baseline.json) and local extraction manifest help find files and check their provenance. Neither certifies a feature.

1. **Identify context.** Record patch, DLC, province, game mode, owner/peer context, new or existing save, and loaded mods. Confirm that the local manifest matches the installation; disregard stale files absent from the manifest.
2. **Find the effective target.** Under `data/base/config/`, start with `export/assets.xml`, `export/templates.xml`, `export/properties.xml`, `export/properties-meta.xml`, `game/datasets.xml` and `gui/texts_*.xml`. There is no matching `properties-toolone.xml` or `export.xml` in the selective 3.0 snapshot. Use the actual archive paths for other resources; Lua source and stubs are under `data/script/`.
3. **Resolve values.** Find the asset by `Standard/GUID` and record its template and any `BaseAssetGUID` chain. Compare explicit values with template `Properties`, the property default data, and typed metadata. Inspect several native examples. Verify list identity and distinguish absent, empty, zero and inherited values. An explicit asset subtree alone does not tell you the effective value.
4. **Follow consumers and references.** Inspect the relevant reverse references, pool/trigger/condition/quest chains, native scripts or binding signatures and dataset values. For strings, follow `OasisId` to the corresponding `LineId` as signed 64-bit decimal text; do not round or coerce through floating-point numbers. The 117 export contains negative native IDs. Compare at least the languages affected.
5. **Close the audit.** Record evidence and remaining uncertainty using the [template](../templates/audit.md). If a missing essential source could change the decision, obtain it first. Verify intended XPath match counts before a patch and exact before/after nodes afterward. XML and generated stubs expose structure and signatures; test lifecycle, save and multiplayer effects separately.

**Vanilla evidence, 3.0:** `assets.xml` uses `AssetList`, `Template`, `BaseAssetGUID`, `Standard/GUID` and `Text/OasisId`; see examples at lines 6, 38 and 33909. `texts_english.xml` begins with `TextExport` and a negative `LineId` at line 4. `properties-meta.xml` describes `ActionExecuteScript/ScriptFileName` at 6104–6109; see the [runtime chapter](luau-and-runtime.md) for the bounded comparison to workspace code.

## InfoTips and other resources

The selective extraction includes the raw `data/infotips/export.bin`. Confirm its manifest entry before tracing a layout. The 117 patch path is `data/infotips/export.bin.xml`. Keep layout GUIDs, consumer fields and localized text IDs distinct. The loader XML uses attributes on `InfoElement` and `VisibilityElement`, hides count fields and uses Oasis `TextId`. FileDBReader output can differ from loader XML. Check the selector against a representation that matches the tool used for patch evaluation. [Loader InfoTip reference](https://jakobharder.github.io/anno-mod-loader/infotips/)

The **2026-11-10 InfoTip supplement** to the original 3.0 snapshot refreshed the local binary and added its manifest entry. The installed `infotips.rda` supplies 2,394,704 bytes with SHA-256 `e84254fe137deb3c73de90c68737afd06ca2cab70cca9c7e296e56fc84c3200e`. The archive stream, fresh extraction and refreshed local file matched. The XML inspection export was subsequently produced on 2026-11-12 as described below; loader evaluation remains open. [Original baseline receipt](../reference/vanilla-baseline.json) · [Extraction tools](../tools/README.md)

UI Studio JSON, other FileDB containers, model configuration, media and province data need targeted extraction or conversion. Confirm their format and target path on the installed build.

## Native XML dialect

The five main asset/template/property/dataset inputs and text exports passed a strict XML parse. Other native `.xml` files can use game-specific syntax: 104 files were rejected by the strict parser, including ambient settings with shorthand closing tags, `engine/globals.xml`, `engine/prop_sets.xml` and `game/camera.xml`. They match the archive bytes. Preserve the originals and use a loader-aware tool for affected targets. See the receipt for paths and parser messages.

## Local InfoTip XML inspection export (2026-11-12)

At the user's request, FileDBReader 3.0.3 decoded the current `data/infotips/export.bin` with compression version 2 and the available `infotip_117.xml` interpreter. Its default output is `data/infotips/export.xml` alongside the binary, NOT `export.bin.xml`. The resulting 5,424,089-byte XML parses with root Content and 1,076 InfoTipData entries, including exactly one Guid500664 and one Guid25345. The binary remains unchanged at 2,394,704 bytes / SHA-256 e84254fe137deb3c73de90c68737afd06ca2cab70cca9c7e296e56fc84c3200e. This derived inspection file stays outside Git and the original RDA extraction manifest.

Resolve the tool and interpreter via optional `fileDBReaderPath` / `infoTipInterpreterPath` in ignored local.json, then call `decompress -f <vanillaPath>/data/infotips/export.bin -c 2 -i <interpreter>`. Do not overwrite an existing export without checking it. The interpreter reported duplicate selections, empty fields and wrong byte sizes (for example FirstValue/SecondValue); a successful exit and well-formed XML do not validate every interpreted type or a compress/edit round trip. Use this output for inspection, preserve the binary and verify any field before modifying it. FileDBReader XML is also distinct from the mod loader's export.bin.xml patch representation.

InfoTip500664 (SideNotificationInfoTip) contains ElementType25 and TextId -6902128858514781674. That ID was not found in any of the 12 inspected language text exports; no dynamic-text semantics are inferred. The static AutosaveLimit_InfoTip25345 remains distinguishable. In installed config.rda, 154 explicit SideNotification instances (standalone NotificationType and inline ActionNotification/Notification, excluding other notification templates) comprise 140 inherited Infotip values and 14 explicit zeros; there is no explicit nonzero override. The inherited default is 500664. This counts declarations, not runtime deliveries or every derived asset. User tests now show no hover tooltip for both forced and genuine island discovery; only the separate spoken subtitle appears at the top of the screen.

### SideNotification hover status (2026-11-12)

**Inference:** `SideNotification/Infotip` appears unused or vestigial in the tested game UI; this remains an inference, not a confirmed engine limitation.

Source evidence: the inherited default 500664 points to TextId -6902128858514781674, absent from all 12 inspected Vanilla language exports. Most explicit SideNotification definitions inherit that default, while all explicit overrides disable it with 0. These declarations establish configuration, not active UI consumption.

User runtime observations: assigning the valid native autosave-help Infotip25345 to the cheat notices produced no hover tooltip. Both the manually triggered Vanilla island-discovery notice and a genuine island discovery also produced no hover tooltip; the top-center spoken text is the separate NotificationSubtitle. Together these findings support the inference above, but do not rule out different behavior in another UI path, game version or context. Do not currently recommend this property as a solution for showing full cheat descriptions.
