# Anno 1800 to Anno 117 porting comparison

Reviewed 2026-11-10 against the installed Anno 117 PC Update 3.0 archives and the local Anno 1800 main export. This comparison covers selected native contracts and package examples. Repeat the feature audit for the target build and mod before choosing an implementation. [Feature audit](../foundations/vanilla-research.md) · [Loader and porting](../foundations/loader-and-porting.md)

## Which local sources to use

| Source | Use in a 117 investigation |
| --- | --- |
| 1800 `mods bei github/SharedMods/Documentation` | The broader 1800 reference covers triggers and saves, shared Lua, multiplayer, InfoTips, graphics and offline loader checks. Start with its coverage and discrepancies. Use its source tracing and validation methods for 117 and recheck the contracts in 117 Vanilla. [Public documentation](https://github.com/Serpens66/Anno-1800-SharedMods-for-Modders-/tree/main/Documentation) |
| 1800 `ModdingWithCodex` | The smaller starter kit has an audit template, a worked harbor field edit and a reward-pool guide. Its documented 1800 offline results belong to the recorded inputs and evaluator. |
| 1800 `Anno1800 RDA unpacked/dataAlle` | The local comparison input. It supplies the main assets, templates, property definitions and defaults, datasets and language exports. The exact originating game update is unverified. Other snapshots in the parent directory are separate sources. |
| 117 configured Vanilla extract and installed archives | The current 117 inputs. The checked asset, template, property, dataset and language files match the local manifest. The installed archive inventory matched all 40 manifest entries by name, size and modification time. |
| 117 parent directory | `modloader-changes.md` is a historical loader note. `info.txt` records Serp's range and an old allocation marker. `fremde mods` contains reference packages for quests, Lua/UI and ambient settings. Treat their metadata, files and author-reported behavior as distinct evidence. Keep machine-specific paths in the ignored local configuration. [Setup](../setup.md) · [Sources](sources.md) |

The local Red Sea Albion and AmbientClearView packages use a plain-text `.xml.lnk` with a virtual path to a sibling `.noxml` file. This shows the intended replacement layout. Support for the example on 3.0 and its interaction with other mods remain untested. The nearby Windows shortcuts in the research folders serve a different purpose. [Loader file structure](https://jakobharder.github.io/anno-mod-loader/file-structure/#link-files)

## Reused structures and changed contracts

**Harbor radius.** Both main exports have one full asset `2001241`, template `BuildingBaseTiles`, with no base asset and explicit `Values/BuildingBaseTiles/HarbourConstructionAreaRadius=28` and `HarbourConstructionAreaDistanceToEdge=2`. The 117 metadata declares the radius an integer. The 1800 asset also has `HarbourConstructionAreaRadiusCreativeMode=56` and its metadata declares that field. The field is absent from the checked 117 schema and main asset. In 117 the harbor colors are grouped by accessibility mode, and the icon path differs. Scope any port to the audited field. Placement restrictions and engine use require game checks. See the two main asset files at 1800 line 734703 and 117 line 186105, and 117 metadata at line 25725.

**Construction category helper.** The 1800 and 117 copies of `shared_CopyPools_AP_ConstrBuild` both copy explicit `ConstructionCategory/BuildingList/Item/Building` values to an `AssetPool`. The 1800 version uses ModID `CopyPoolsAPConstructionCategoryBuildings_Serp`, anchor `700000`, pool `1500003819` and the 1800 asset path. The 117 version uses `copy-pools-ap-buildable-buildings-serp`, anchor `31973`, pool `1500000002` and the 117 asset path. In unpatched 117 3.0 the anchor is a single native `AssetPool`, the output GUID is absent and the serialized content XPath finds 779 text nodes. This is the raw match count, which can include repeated building IDs. The legacy late-load metadata in the package is evidence of intent. Actual order and output still require the 117 loader and the complete dependency set. [117 package](../../shared_Mods/shared_CopyPools_AP_ConstrBuild/modinfo.json) · [Loader and porting](../foundations/loader-and-porting.md)

**Reward pools.** In both games `RewardPool` and `RewardItemPool` templates provide the `RewardPool` property and the `ItemsPool/Item` vector. 117 defaults give `MinAmount`, `MaxAmount` and `Weight` a value of 1 and `GenerateUniqueRewards` a value of 1. The metadata declares `ItemGroup` as an asset-group reference. Check whether the entry has an actual group value because native entries can contain an empty `ItemGroup`.

| Field | 1800 main schema | 117 3.0 main schema |
| --- | --- | --- |
| `RewardPool/ItemsPool/Item/ItemLink` | `Product`, `Item`, `RewardPool`, `RegionRewardPool`, `BuildPermit` | `Product`, `Item`, `RewardPool`, `RegionRewardPool` |
| `Reward/RewardAssets/Item/Reward` | The 1800 ItemLink types plus `ResourceRewardPool` and `Session` | The 117 ItemLink types plus `Session` |
| `RegionRewardPool/RewardPools` | `Region`-keyed array. Keys include `Moderate`, `Colony01`, `Arctic`, `Africa` and `Mod1` through `Mod3`. | `Region`-keyed array with `Meta` (0), `Roman` (7), `Celtic` (8) and `Egyptian` (12). |

The 1800 money-pool asset `150038` uses template `ResourcePool` and property `ResourceRewardPool`. The asset, template and property are absent from the inspected 117 main export. For a 117 contract example, Dorian `31099` explicitly references `64766` at `ContractProvider/ItemRewards/Item/ItemRewardPool`. Pool `64766` links through `ItemsPool/Item/ItemLink` to pool `83452`, which links to specialist `44191`. The parent includes zero-weight entries and a weighted entry with no link and both amounts set to zero. Those serialized values do not establish how the engine normalizes nested weights, handles empty entries, or applies unlock and uniqueness checks. See 117 assets at lines 438172, 1292537, 1283662 and 1336287, metadata at 48100–48197, defaults at 6163–6169 and 6202–6204, and the `Region` dataset.

## Old names and new systems

**Expeditions.** The 1800 main export contains 200 exact `Expedition` template instances. Asset `800103` points to an event pool and a reward, and 1800 defines `ExpeditionEvent`, `ExpeditionFeature` and the `ExpeditionAttributes` dataset. The corresponding templates, dataset and example GUID are absent from the checked 117 main export. 117 still has names such as `expedition_return_a7.cfg` in assets, an `OpenExpeditionShipMenu` setting in console XML and the `Expedition` enum in `data/script/types/generated/halo/enums/shipstatesa7.lua`. Those hits establish retained references or declarations. Treat an old expedition recipe as unsupported by this data and assess a new 117 quest or contract on its own native chain.

**Aqueducts and production.** The 1800 oil power plant `100780` uses `Powerplant/IndustrializationDistance` and the 1800 consumer schema includes `Electrifiable/ElectricityBoost`. The 117 main schema lacks those property contracts even though legacy electricity and power-plant labels appear in datasets. The 117 water network has separate producer, segment and consumer properties. Basins `19691` (Roman), `29524` (Roman Celtic) and `149791` (Egyptian) explicitly supply `AqueductProducer/WaterVolumeSupply=100`. Connector `149792` references the Egyptian basin through `AqueductSourceBuilding`. Sandarac field `8579` declares an optional consumer with demand `5`, unlock reference `38551` and productivity buff `28480`. That buff declares source category `Aqueduct`. The consumer default is `None`, and `AqueductConsumptionType` lists `None`, `Optional` and `Mandatory`. Audit source availability, the regional network and the intended consumer separately. The English and German exports both resolve the unlock and buff Oasis IDs. Connection rules and production effects still need runtime checks. [Patch 3.0 notes](https://www.anno-union.com/updates/anno-117-pax-romana-patch-3-0/)

**City Status.** Economy feature `1010000` supplies `EconomyFeature7/CityStatusFeature/Region`, keyed by the 117 `Region` dataset. Its `Roman/CityStatusList` links status `1929` to a `RequiredPopulation` entry for tier `1494`. The next Roman entry links status `3559` to the same tier with an explicit count of 200. Status assets hold their own settings, including incident intervals, and `ConditionCityStatus/TargetCityStatus` accepts a `CityStatus` asset. The generated area population and need attribute bindings expose additional lookup declarations. Keep the status asset, its population thresholds and the condition consumer separate when researching an edit. [Patch 3.0 notes](https://www.anno-union.com/updates/anno-117-pax-romana-patch-3-0/)

## Source identities and limits

For 117, paths below are relative to the configured Vanilla extract. The five XML files were supplied by `config.rda` and matched the 3.0 manifest. For 1800, use the five corresponding files under `data/config/export/main/asset/` in `dataAlle`. 1800 has `properties-toolone.xml` where 117 has `properties-meta.xml`.

| Input | 1800 SHA-256 | 117 SHA-256 |
| --- | --- | --- |
| Assets (`data/base/config/export/assets.xml` in 117) | `08b6cc7023aa1d834f2e6c2042848a3b3e2f13fcc44735a6248f6b6622d42c6a` | `11350fe1da08885635b262f8d0f3cf7c67aec159f6196754ba13cfba4758ea05` |
| Templates (same 117 directory) | `099e887c72f97e3a443944e90d45ea544a3d83dd3dd440bf1e420ed709a187f8` | `42d1cf6520e304c306ea991c8c8d0fdc6e780a810b15f342f3df4722aaaf4e71` |
| Property definitions (same 117 directory) | `bf8b81d19a54ab1e7086bc7d47e0239857335422cec6e299b527ef77d462593b` | `eba34b07c95127aff732b9df8f8461dcf0681b10bea79cf17572f764c53414fc` |
| Property defaults (same 117 directory) | `a9d10e0c450908ab8f7fb15d29852996a912eea536ccda7855f175cfd972c200` | `5eb9f94f8de7268588ca7a605d89e393dc518cff25b113c0dae2409576455b43` |
| Datasets (`data/base/config/game/datasets.xml` in 117) | `814e866f3bd38b271e0aa4fa91a1080e9e64121d54431d98c74d916739c30a48` | `dcb9a864c19823def5d8e3907cc4a7acd5dcd7a17f1cc7f912260dd49793cd75` |

Evidence is limited to source inspection, structural XML queries and package comparison. The original 1800 offline checks retain their own scope. 117 loader output, game and save behavior, and multiplayer are untested.
