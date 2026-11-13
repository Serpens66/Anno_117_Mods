# Serp's mods: notification observations

Scope is Serp's Cheat Keybinds development on Anno 117 PC Update 3.0, with user runtime observations recorded on 2026-11-12. This page preserves the tested behavior and inference from that mod investigation. Native file structure, extraction hashes, InfoTip XML counts and SideNotification defaults remain in the Vanilla research chapter. [Native InfoTip evidence](../vanilla/research.md#local-infotip-xml-inspection-export-2026-11-12) · [Cheat Keybinds audit](cheat-keybinds-audit.md)

## SideNotification hover status (2026-11-12)

The investigation started from the inherited InfoTip 500664 and a valid static replacement, autosave-help InfoTip 25345. The native default's TextId -6902128858514781674 was absent from the 12 inspected Vanilla language exports. The native declarations and their source limits are recorded separately. [Native source findings](../vanilla/research.md#local-infotip-xml-inspection-export-2026-11-12)

The user reported no hover tooltip after assigning InfoTip 25345 to the Cheat Keybinds side notices. A manually triggered native island-discovery notice and a genuine island discovery also produced no hover tooltip. The spoken text at the top of the screen belonged to the separate NotificationSubtitle. These observations cover the tested installation, UI paths and context.

The resulting inference is that `SideNotification/Infotip` appears unused or vestigial in that tested UI. Other UI paths, game versions and contexts remain unverified. Showing full cheat descriptions through this property was unsuccessful in the recorded experiments.

## Current package status

The consolidated Cheat Keybinds 1.15.0 removes the experimental autosave-help InfoTip assignment and the manual native-notification diagnostic menu entry and triggers. Its 30 retained custom notices explicitly set Infotip to 0. Earlier development versions and their experiments remain historical audit evidence. [Consolidated package cleanup](cheat-keybinds-audit.md#consolidated-1150-release-cleanup-2026-11-12)
