# Serp's mods: notification observations

Scope is Serp's Cheat Keybinds development on Anno 117 PC Update 3.0, with user runtime observations recorded on 2026-11-12. This page preserves the tested behavior and inference from that mod investigation. Native file structure, extraction hashes, InfoTip XML counts and SideNotification defaults remain in the Vanilla research chapter. [Native InfoTip evidence](../vanilla/research.md#local-infotip-xml-inspection-export-2026-11-12) · [Cheat Keybinds audit](cheat-keybinds-audit.md)

## SideNotification hover status (2026-11-12)

The investigation started from the inherited InfoTip 500664 and a valid static replacement, autosave-help InfoTip 25345. The native default's TextId -6902128858514781674 was absent from the 12 inspected Vanilla language exports. The native declarations and their source limits are recorded separately. [Native source findings](../vanilla/research.md#local-infotip-xml-inspection-export-2026-11-12)

The user reported no hover tooltip after assigning InfoTip 25345 to the Cheat Keybinds side notices. A manually triggered native island-discovery notice and a genuine island discovery also produced no hover tooltip. The spoken text at the top of the screen belonged to the separate NotificationSubtitle. These observations cover the tested installation, UI paths and context.

The resulting inference is that `SideNotification/Infotip` appears unused or vestigial in that tested UI. Other UI paths, game versions and contexts remain unverified. Showing full cheat descriptions through this property was unsuccessful in the recorded experiments.

## Historical consolidation (2026-11-12)

The consolidated Cheat Keybinds 1.15.0 removes the experimental autosave-help InfoTip assignment and the manual native-notification diagnostic menu entry and triggers. Its 30 retained custom notices explicitly set Infotip to 0. Earlier development versions and their experiments remain historical audit evidence. [Consolidated package cleanup](cheat-keybinds-audit.md#consolidated-1150-release-cleanup-2026-11-12)

## Third-party Serp Cheat Keybinds Port 1.15.0 review (2026-11-24)

The reviewed package credits vadim for its notification layer and retains Serp's ModID, creator metadata and mod.io resource ID. The comparison uses the tracked Recommended package, whose manifest reports 1.14.0 and whose readme reports 1.15.0. WIP and the demo bundle are separate variants. The original active shortcut definitions and 14 cheat function bodies match. The inherited global Side/Delay override remains in both packages.

The port replaces only the icon and body of each of the 14 selection toasts. It adds 15 portraits, 15 narrative participant profiles and 63 notification-only triggers, including 28 execution or no-alternate messages and 35 failures. The port exits before dispatch for eight Alt+G cases where the Recommended package calls the primary action. The new alternate-action warnings hardcode the default Alt+V. The English file rewrites 36 original strings, and each of the 12 language files supplies 77 new text IDs. The added IDs are outside the mod's exclusive block and are not recorded as workspace allocations.

Current installed PC archives were read in archive order, including patch archive 301. The installed config.rda assets.xml SHA-256 is f78f2241f819f2e120347492e3a6feb2c2c5cae9e8b5857897191cc25c90c9e4. The three unconditional native target GUIDs resolve uniquely. A static XML projection matched each of the 28 selection replacements once. Packaged picture files and text references resolve, with no added asset GUID collision in the effective Vanilla assets or new text ID collision in the checked English and German Vanilla exports. The CharacterNotification profile field requires the Participant property. The port provides it through the native narrative-participant template, whose default is AutoCreate_Always. This warrants separate save and multiplayer checks.

The author's 3.0 screenshots include a readable character popup. The distributed package has no notification scene override and the screenshots do not establish that its longest current messages fit. The live installed template declares NotificationConfiguration/DefaultFlyoutHeightOffset=5, contrary to the port study. That declaration alone does not establish its UI effect. The author's tested sample does not establish a fixed character budget, nor do the negative binary searches establish that the line cap resides in compiled defaults. Our earlier hover result remains scoped to the tested 3.0 context.

The shipped builder deletes existing generated output before validation and its install option deletes the destination before copying. It invokes local external tools, ignores the XML evaluator's exit code and accepts a reused result path. The exact English override is absent from the delivery. The foreign builder and scripts were inspected without running them. No matching loader evaluator, game, save or multiplayer test was run for the port.
