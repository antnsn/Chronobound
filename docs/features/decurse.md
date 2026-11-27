---
title: Decurse
parent: Features
nav_order: 10
description: A grid of your group that shows who has a Curse you can remove, one click to remove it.
---

# Decurse

See at a glance who has a Curse you can remove, and remove it with one click or one key, in combat too.

{: .note }
New and not in a CurseForge release yet. It is listed under **Unreleased** in the changelog. The same frame as Lightbound's Cleanse, shared through LibBound.

## What it does

- **Click** a cell or row: **Remove Lesser Curse** on that player.
- **Grid** (the default): one small cell per group member, like Decursive. A cell lights up in the debuff's colour (purple Curse) with its icon and stack count.
- **List**: one row per player who has something you can remove.
- **A key** that casts on whoever is under your mouse: a grid cell, a list row, or any raid or party frame. With nothing under the mouse, it casts on your target.
- Players out of range are dimmed. A sound plays when someone new needs it.
- An **ignore list** hides debuffs you don't want to see.
- The frame shows up once you know the spell.

## How to use it

1. Type `/cb` and open the **Decurse** page.
2. Under **Key**, click the button and press a key. Esc cancels.
3. Pick **Grid** or **List**.
4. In a fight, click a coloured cell, or hover over a player and press your key.
5. To hide a debuff you never want to remove, type `/cb ignore` followed by its full name. The same command again removes it. `/cb ignore` on its own lists what you ignore.

## Settings

In `/cb`, page **Decurse**:

| Setting | Default | What it does |
| --- | --- | --- |
| Show the decurse frame | On | The grid or list. |
| Include pets | Off | Adds group pets. |
| Dim players out of range | On | |
| Sound when someone new needs it | On | |
| Show when solo | On | Just you. Off: only in a group. |
| Names in cells (26 px and up) | Off | Three letters of each name, from 26 px cells up. |
| Grid or list | Grid | Grid: a cell per group member that follows the roster in combat. List: a row per afflicted player. |
| Grid: cells per row | 5 | 1 to 10. |
| Grid: cell size | 22 px | 14 to 40 px. |
| List: rows | 5 | 1 to 10. |
| Decurse key | Not set | Remove Lesser Curse on the player under your mouse, else your target. Works in combat. |

The bottom of the page lists your ignored debuffs.

## Good to know

**Does it work in combat?**
Yes. Clicking cells and the key work in combat. The grid also follows players joining, leaving and moving between raid groups during a fight.

**Layout changes wait for the end of combat.**
Switching between grid and list, cell size, cells per row and pets change after combat.

**Combat hides debuff details on Forever.**
In the grid, the game itself draws the debuff colour and icon in each cell, so the grid keeps working in combat. The tooltip may say "Debuff details hidden right now". The **list** relies on what the addon can read, so in combat it can miss debuffs.

**Clicking a cell that isn't lit** still casts on that player. That is on purpose: in combat the addon may not see a debuff the game hides.
