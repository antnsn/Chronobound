# Chronobound v1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Mage addon for WoW: Forever that watches conjured food/water, self-buffs and Well Rested/Fed, and adds a travel panel to the Escape menu, explained for new players, in a frost-crystal look. The sheep timer comes in a later plan.

**Architecture:** (Changed 2026-11-20 on Marius' word "har ikke vi en core addon for dette? er ikke det hele greia?": LibBound first, not copies.) A shared library `LibBound-1.0` (own folder and repo, `../LibBound`) built from Lightbound's Core, Skin, card, Options, Minimap and WellRested code, made per-addon through `lib:NewAddon(addonName, ns, cfg)` and `lib.Install*(ns, ...)`. Chronobound holds only the mage parts (data, frost skin, self-buffs, conjure, travel, its option pages) on top. Lightbound switches to LibBound later in its own PR. Option keys stay Lightbound's names. Every behaviour is pinned by a wowbench scenario.

**Tech Stack:** Lua 5.1 (WoW: Forever client 1.60.1, Interface 16001), wowbench (`check`, `test`, `pack`), luacheck (`~/.luarocks/bin/luacheck`), Python 3 + Pillow for textures, GitHub (public repo `antnsn/Chronobound`, Pages for docs).

**Spec:** `/mnt/e/obsidian/Personal/Private/projects/Bound Addons/Chronobound Design.md` (read it first; the "Calls", "Release" and "Sheep" sections at the end are part of it).

## Global Constraints

- Interface `16001`; folder and addon name `Chronobound`; SavedVariables `ChronoboundDB`; slash `/cb` and `/chronobound`, plus space-free aliases for every sub-command.
- Loads only on mages; on any other class it prints one line and unticks itself for that character (copy Lightbound's Core.lua lines 1-27).
- All in-game text in English. Tooltips explain things in plain words; option `explain = true` by default.
- Use only API in wowbench's `api/client.txt`; never call a name in `api/missing.txt` (GetSpellInfo, GetItemCount, IsAddOnLoaded, GetAddOnMetadata, GetItemInfo...) unguarded. `wowbench check .` must report 0 errors.
- Forever: aura reads may error and combat state may be secret in combat; read buffs out of combat (copy `ns.ReadPlayerBuffs`, `ns.InCombat`, `ns.IsSecret`).
- Secure click-to-cast buttons are created and changed out of combat only; in combat they freeze as they were.
- Restraint: no sound unless the player's sound option is on, nothing flashes, glow only when something needs doing, never a reminder in combat.
- Look: "Frost crystal" (dark ice-blue panels, frosted glass, cut crystal corners, a cold white rim breathing slowly, pale cyan titles), own textures in `Media/`; Blizzard and Flat skins too.
- Option keys shared with Lightbound keep Lightbound's names: `wellRested*`, `wellFed*`, `snap`, `gridSize`, `skin`, `minimap`, `minimapAngle`, `scales`, `*Point`.
- Spell and item IDs (Classic; verified in game before the first release, Task 10): Conjure Water 5504, 5505, 5506, 6127, 10138, 10139, 10140; Conjure Food 587, 597, 990, 6129, 10144, 10145, 28612; Arcane Intellect 1459, 1460, 1461, 10156, 10157; Frost Armor 168, 7300, 7301; Ice Armor 7302, 7320, 10219, 10220; Mage Armor 6117, 22782, 22783; conjured water items 5350, 2288, 2136, 3772, 8077, 8078, 8079; conjured food items 5349, 1113, 1114, 1487, 8075, 8076, 22895 (index i of a spell list makes index i of its item list).
- Travel: Teleport Orgrimmar 3567 (lvl 20), Undercity 3563 (20), Thunder Bluff 3566 (30), Stormwind 3561 (20), Ironforge 3562 (20), Darnassus 3565 (30); Portal Orgrimmar 11417 (40), Undercity 11418 (40), Thunder Bluff 11420 (50), Stormwind 10059 (40), Ironforge 11416 (40), Darnassus 11419 (50); Rune of Teleportation item 17031, Rune of Portals item 17032; Hearthstone item 6948.
- Every commit: `for f in *.lua; do luac5.1 -p "$f"; done`, `~/.luarocks/bin/luacheck .`, `wowbench check .`, `wowbench test .` all clean; Codex review before commit (global rule).

## Review Focus

- A mage with no conjure spells yet (level 1-3): no card nags, the travel panel shows everything greyed with the level, nothing errors. (Task 5 and 7 scenarios `fresh`.)
- Combat starting while a card is shown: the card stays put, its overlay is hidden by the state driver, nothing errors, it comes back after combat. (Task 4 scenario `combat`.)
- Bags full of an old rank after learning a higher one: the card says "a better rank is known" once, out of combat, and the button conjures the new rank. (Task 5 scenario `newrank`.)
- A non-mage logging in with the addon on: one chat line, the addon unticks itself, no frames. (Task 1 scenario `warrior`.)
- The Escape menu opened in combat: the panel shows (it follows GameMenuFrame) but its buttons don't change; out of combat it refreshes. (Task 7 scenario `combat`.)

---

### Task 1: Repository and core

**Files:**
- Create: `Chronobound.toc`, `Core.lua`, `.luacheckrc`, `.pkgmeta`, `.gitignore`, `wowbench.toml`, `LICENSE` (MIT), `CLAUDE.md`, `README.md`, `tests/core.scenario.lua`, `.github/workflows/lint.yml`
- Reference (copy from): `../Lightbound/Core.lua`, `../Lightbound/.luacheckrc`, `../Lightbound/CLAUDE.md`

**Interfaces:**
- Produces: `ns.db` (ChronoboundDB merged over `ns.defaults`), `ns.modules` (list; each module may define `M:Init()`, `M:OnEvent(event, ...)`, `M.events`), `ns.Print(msg)`, `ns.IsSecret(v)`, `ns.InCombat()`, `ns.ReadPlayerBuffs() -> buffs, hidden`, `ns.SpellName(id)`, `ns.MakeMovable(frame, key)`, `ns.ApplyPoint(frame, key)`, `ns.ShowGrid(show)`, `ns.unlocked`, `ns.MakeCard(name, opts) -> card` (card:SetIcon, SetTitle, SetStatus(text, urgent), SetFaded, Glow), `ns.MakeCastOverlay(card, getSpellFn)` (Lightbound's click-to-cast overlay), `ns.isMage`, slash `/cb` dispatching `ns.commands[name](rest)`.

- [ ] **Step 1:** `git init`, create the public repo `gh repo create antnsn/Chronobound --public`, copy Lightbound's ruleset (protected main, signed commits, PRs, 0 approvals) with `gh api`, `bd init`. `CLAUDE.md` = Lightbound's with Chronobound names, the wowbench commands and the PR flow.
- [ ] **Step 2: Write `tests/core.scenario.lua`** with moods `mage warrior`: mage → `wb.login()` gives no errors, `wb.slash("/cb")` opens the options frame (`wb.shown("ChronoboundOptions")`), `/cb unlock` sets `wb.ns.unlocked == true`; warrior (`wb.state.player.classFile = "WARRIOR"`) → `wb.printed("only does something on a mage")`, `wb.frames()` has no Chronobound frame.
- [ ] **Step 3:** run `wowbench test .` → FAIL (no files).
- [ ] **Step 4:** `Core.lua` from Lightbound's: class gate for `MAGE` ("Chronobound: only does something on a mage."), defaults trimmed to the shared keys plus `explain = true`, module loader with error isolation, movers/grid/cards/overlays unchanged except colours via the skin, slash `/cb`, `/chronobound`, sub-commands `unlock`, `lock`, `reset` (positions), `help`, each with a space-free alias (`/cbunlock` ...).
- [ ] **Step 5:** `wowbench test .` and `wowbench check .` pass; `luacheck .` clean.
- [ ] **Step 6:** commit "Chronobound skeleton: core from Lightbound, mage-only".

### Task 2: Frost crystal skin and textures

**Files:**
- Create: `Skin.lua`, `tools/make_media.py`, `Media/*.tga`, `tests/skin.scenario.lua`

**Interfaces:**
- Consumes: Task 1's `ns.MakeCard`.
- Produces: `ns.UI` (font, color, texture tables of the active skin, same field names as Lightbound's `Skin.lua`), skins `frost` (default), `blizzard`, `flat`; `ns.db.skin`.

- [ ] **Step 1: Write `tests/skin.scenario.lua`** with moods `frost blizzard flat`: login with `saved = { ChronoboundDB = { skin = <mood> } }`, `wb.ns.UI.name` equals the skin's display name ("Frost crystal", "Blizzard", "Flat"), a card built with `wb.ns.MakeCard("ChronoboundTestCard")` exists and no errors.
- [ ] **Step 2:** run, FAIL.
- [ ] **Step 3:** `tools/make_media.py` (Pillow) draws white-on-alpha textures for tinting: `Crystal` (card frame with cut corners, 256x64), `Frost` (frosted noise panel, 128x128), `Rim` (soft rim glow, 64x64), `Shard` (corner shard, 32x32), `Icon64`/`Icon128`/`Logo64`/`Logo256` (a frost-crystal emblem). `Skin.lua` from Lightbound's with `SKINS.frost` (dark ice blue `{0.06,0.13,0.19}` panels, rim `{0.75,0.94,1.0}`, titles `{0.75,0.94,1.0}`, text `{0.90,0.96,1.0}`, accent `{0.44,0.83,1.0}`), `blizzard` and `flat` copied. Card breathing tempo as Lightbound (slow); no rotating sunburst: the frost skin breathes the rim only.
- [ ] **Step 4:** tests pass; screenshot check comes in Task 10.
- [ ] **Step 5:** commit "Frost crystal skin and textures".

### Task 3: BuffTimer engine with Well Rested and Well Fed

**Files:**
- Create: `BuffTimer.lua`, `tests/buff_timer.scenario.lua`
- Reference: `../Lightbound/WellRested.lua`, `../wowbench/examples/lightbound/session.scenario.lua`

**Interfaces:**
- Consumes: `ns.MakeCard`, `ns.ReadPlayerBuffs`, `ns.InCombat`.
- Produces: `ns.MakeBuffTimer(cfg) -> timer` where `cfg = { key, label, name, spellID, icon, cast = optional spell to cast on click, explain = tooltip text }`; timer has `:Update()`, `.Test()`; `ns.UpdateBuffTimers()`. Settings per `key`: `<key>`, `<key>Minutes`, `<key>Sound`, `<key>Icon`, `<key>Keep`, point `<key>Point` (Well Rested keeps `wrPoint`, Well Fed `wfPoint`).

- [ ] **Step 1: Write `tests/buff_timer.scenario.lua`** with moods `missing off buffed secret`, the same expectations as Lightbound's session for the cards: buffed → both cards shown with time left after `wb.advance(7)`; off (`wellRested=false, wellFed=false`) → none; with `wellRestedKeep = true` and the buff removed → "has run out" card and one reminder (`wb.printed("Well%-Rested has run out")` once, also after 60 s more); secret → no errors while in combat.
- [ ] **Step 2:** FAIL.
- [ ] **Step 3:** `BuffTimer.lua`: Lightbound's `MakeTimer` made public as `ns.MakeBuffTimer`, unchanged behaviour, plus `cfg.cast` (adds `ns.MakeCastOverlay`) and `cfg.explain` (tooltip when `ns.db.explain`). Well Rested (spell 429959) and Well Fed configured at the bottom exactly as Lightbound.
- [ ] **Step 4:** pass. **Step 5:** commit "Buff timers: Well Rested and Well Fed".

### Task 4: Self-buffs (Arcane Intellect, armor)

**Files:**
- Create: `SelfBuffs.lua`, `tests/self_buffs.scenario.lua`

**Interfaces:**
- Consumes: `ns.MakeBuffTimer`, `ns.SpellName`.
- Produces: `ns.BestRank(list) -> spellID or nil` (highest ID in the list the player knows, via `IsPlayerSpell`), used by Task 5 too; settings `intellect` (on), `intellectMinutes` (2), `armor` (on), `armorChoice` ("Frost"/"Mage"), `armorMinutes` (1).

- [ ] **Step 1: Write `tests/self_buffs.scenario.lua`** with moods `fresh lowlevel combat`: lowlevel knows 1459 and 168 → after login without the buffs, cards titled "Arcane Intellect missing" and "Frost Armor missing" are shown, and their overlays cast 1459 / 168 (`overlay:GetAttribute("spell")`); with Ice Armor 7302 known the armor card names Ice Armor; `armorChoice = "Mage"` with 6117 known names Mage Armor; fresh (knows neither) → no cards; combat → entering combat with cards up raises no error and `wb.ns.InCombat()` cards don't change until `wb.combat(false)`.
- [ ] **Step 2:** FAIL. **Step 3:** `SelfBuffs.lua`: two buff timers whose `name`/`spellID`/`cast` come from `ns.BestRank` (armor: Ice over Frost unless `armorChoice == "Mage"`), refreshed on `SPELLS_CHANGED` out of combat; explain texts: "Arcane Intellect raises your Intellect, so you have more mana. Lasts 30 minutes." / "Frost Armor adds armor and slows enemies that hit you. Keep it on all the time."
- [ ] **Step 4:** pass. **Step 5:** commit "Self-buff cards: Arcane Intellect and armor".

### Task 5: Conjured food and water

**Files:**
- Create: `Conjure.lua`, `tests/conjure.scenario.lua`

**Interfaces:**
- Consumes: `ns.BestRank`, `ns.MakeCard`, `ns.MakeCastOverlay`.
- Produces: `ns.ConjuredCount(kind) -> total, bestRankHeld` (`kind` = "water"/"food"; counts all ranks with `C_Item.GetItemCount`); settings `conjure` (on), `waterLow` (5), `foodLow` (3), points `cwPoint`, `cfPoint`.

- [ ] **Step 1: Write `tests/conjure.scenario.lua`** with moods `fresh low newrank enough`: low (knows 5504, holds 3 of item 5350) → card "Conjure water" with status "3 Conjured Water left", overlay spell 5504; enough (holds 20) → no card; newrank (knows 5505, holds 20 of 5350) → card status "A better rank is known" once; fresh (knows no conjure spell) → no card; the counts update on `BAG_UPDATE_DELAYED`.
- [ ] **Step 2:** FAIL. **Step 3:** `Conjure.lua`: one card per kind, updated on `BAG_UPDATE_DELAYED`, `SPELLS_CHANGED`, `PLAYER_REGEN_ENABLED`, hidden in combat; explain: "Mages make their own water. Drinking it brings your mana back after a fight, so you never have to buy any." (food: "... your health back ...").
- [ ] **Step 4:** pass. **Step 5:** commit "Conjured food and water cards".

### Task 6: wowbench stub additions (in the wowbench repo)

**Files:**
- Modify: `~/code/wowbench/stub/wb.lua`, `~/code/wowbench/fixtures/Hello/tests/hello.scenario.lua` or a new fixture test, `~/code/wowbench/docs/scenarios.md`

**Interfaces:**
- Produces: `GameMenuFrame` as a real stub frame (hidden; `ShowUIPanel(f)`/`HideUIPanel(f)`/`ToggleGameMenu()` show/hide it, firing OnShow/OnHide), `GetBindLocation()` from `wb.state.bind` (default "Orgrimmar"), `SecureActionButtonTemplate` buttons keep attributes (already), `RegisterStateDriver` records the driver (`f.__driver`), `wb.openGameMenu()` / `wb.closeGameMenu()`.

- [ ] **Step 1:** fixture test: `ToggleGameMenu()` shows `GameMenuFrame`, a child frame parented to it is `IsVisible()` then, hidden after; `GetBindLocation()` returns the state's value.
- [ ] **Step 2:** FAIL. **Step 3:** implement in `stub/wb.lua`; names must be on the API lists (the stub consistency test).
- [ ] **Step 4:** `cargo test` passes. **Step 5:** PR in wowbench, merge, `cargo install --path .`.

### Task 7: Travel panel on the Escape menu

**Files:**
- Create: `Travel.lua`, `tests/travel.scenario.lua`

**Interfaces:**
- Consumes: Task 6's `GameMenuFrame`, `ns.UI`, `ns.InCombat`.
- Produces: frame `ChronoboundTravel` parented to `GameMenuFrame`, anchored to its right (`TOPLEFT` to `GameMenuFrame` `TOPRIGHT`, x 12); setting `travel` (on); `ns.TravelRows() -> list of { spell, name, kind = "teleport"/"portal", known, level }` for the player's faction.

- [ ] **Step 1: Write `tests/travel.scenario.lua`** with moods `fresh horde alliance combat`: horde knowing 3567 and 11417 → `wb.openGameMenu()` shows `ChronoboundTravel`; its Orgrimmar teleport button has attribute spell 3567; Thunder Bluff rows exist with `known = false` and level 30/50; alliance lists Stormwind/Ironforge/Darnassus instead; rune counts read from items 17031/17032 ("Runes: Teleportation 7 · Portals 2"); hearthstone row shows `GetBindLocation()`; fresh → all greyed with levels, no error; combat → opening the menu in combat shows the panel without rebuilding buttons (no error), it refreshes after `wb.combat(false)`; clicking a button (`button:Click()`) calls `HideUIPanel(GameMenuFrame)` as PostClick.
- [ ] **Step 2:** FAIL. **Step 3:** `Travel.lua`: secure buttons (`SecureActionButtonTemplate`, type `spell` / `item` for the hearthstone) built out of combat on `PLAYER_LOGIN`, refreshed on `SPELLS_CHANGED`/`BAG_UPDATE_DELAYED` out of combat; greyed rows are plain frames with a tooltip ("Teleport: Thunder Bluff. Learn it at level 30 from a mage trainer."); runes in red when < 3; frost skin.
- [ ] **Step 4:** pass. **Step 5:** commit "Travel panel on the Escape menu".

### Task 8: Help texts, options and minimap

**Files:**
- Create: `Help.lua`, `Options.lua`, `Minimap.lua`, `tests/options.scenario.lua`

**Interfaces:**
- Consumes: every module's settings keys above.
- Produces: `ns.Help[key] -> string` (all explain texts in one table; modules read from it), options frame `ChronoboundOptions` with pages General (explain, skin, sound, grid), Buffs (Arcane Intellect, armor choice), Well Rested / Well Fed (as Lightbound's page), Conjure (thresholds), Travel; minimap button (LDB-free like Lightbound's `Minimap.lua`).

- [ ] **Step 1: Write `tests/options.scenario.lua`**: `/cb` shows `ChronoboundOptions`; toggling `explain` off hides explain lines in card tooltips (`GameTooltip.__lines` has no explain text); every page builds without errors; settings survive `wb.reload()`.
- [ ] **Step 2:** FAIL. **Step 3:** copy Lightbound's Options.lua widgets (Toggle, Slider, Cycle, Section, NewPage) and Minimap.lua; move the explain texts from Tasks 3-5 and 7 into `Help.lua`.
- [ ] **Step 4:** pass. **Step 5:** commit "Options, minimap button, help texts".

### Task 9: Docs and packaging

**Files:**
- Create: `docs/` (Jekyll + just-the-docs like Lightbound: index, getting-started with the install-from-Releases steps, one page per feature), `CHANGELOG.md`, `.github/workflows/pages.yml`

- [ ] **Step 1:** `wowbench pack . --set-version 0.1.0` builds `dist/Chronobound-0.1.0.zip` with only the addon files (no docs/tests/tools).
- [ ] **Step 2:** README says in plain words: download `Chronobound-<version>.zip` from Releases, unzip into `World of Warcraft/_forever_/Interface/AddOns/` so the folder is `AddOns/Chronobound`, restart the game.
- [ ] **Step 3:** commit "Docs, changelog, packaging".

### Task 10: In-game check and first release

- [ ] **Step 1:** Marius installs from the branch build on a mage (Rheocron-Ashborne): cards, conjure button, travel panel, skin; verify every spell/item ID in Global Constraints in game (the options page Travel/Buffs show which ranks were detected). Fix what differs on Forever.
- [ ] **Step 2:** screenshots for the docs.
- [ ] **Step 3:** tag `v0.1.0` on main, `gh release create v0.1.0 dist/Chronobound-0.1.0.zip` with install notes.
