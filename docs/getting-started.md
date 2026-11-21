---
title: Getting started
nav_order: 2
description: Install Chronobound and set it up in a few minutes.
---

# Getting started
{: .no_toc }

From install to a mage who conjures, buffs and travels with one click.
{: .fs-6 .fw-300 }

1. TOC
{:toc}

---

## 1. Install it

Pick one:

- **CurseForge app or WowUp:** search for **Chronobound** and click Install.
- **By hand:** download it from [CurseForge](https://www.curseforge.com/wow/addons/chronobound) or from [GitHub Releases](https://github.com/antnsn/Chronobound/releases) and unzip it into your `World of Warcraft\_forever_\Interface\AddOns` folder, so you get a folder called `Chronobound` there.

{: .warning }
On GitHub, download `Chronobound-<version>.zip` from Releases, not the green **Code > Download ZIP** button. That one unpacks as `Chronobound-main`, and the game won't load it.

Restart the game (a `/reload` is not enough for a new addon) and log in on your mage. On other classes Chronobound loads nothing and turns itself off for that character from the next login.

## 2. Open the options

Type `/cb` in chat, or click the Chronobound button on your minimap.

The options window has one page per feature on the left: **Buffs**, **Food & water**, **Travel**, **Extras** and **Skin**. Almost everything is on by default, so you mostly turn off what you don't want.

## 3. Pick your buff key

The buff key is the one thing Chronobound can't choose for you.

1. In `/cb`, open the **Extras** page.
2. Under **Buff key**, click the key button and press the key you want. Esc cancels.
3. Out of combat, press it. Each press casts the next thing a card asks for, then Arcane Intellect on the next party member in range who is missing it.

More in [Buff key](features/buff-key.html).

## 4. Put the frames where you want them

Chronobound shows cards: one each for Arcane Intellect, your armor, water, food, Well-Rested and Well Fed. They only show up when something needs doing.

1. Type `/cb unlock`, Shift-click the minimap button, or click **Unlock frames** at the bottom of the `/cb` window. Every card shows, with sample text.
2. Drag each card where you want it. Scroll the mouse wheel over a card to resize it.
3. Type `/cb lock`, or click **Lock** on the bar at the top of the screen.

`/cb reset` puts every frame back where it started.

Using EllesmereUI, ElvUI or another flat UI? Pick the **Flat** look on the **Skin** page in `/cb`. See [Skins](features/skins.html).

## 5. Press Escape

The game menu now has a **Travel** panel beside it, with your teleports, portals and Hearthstone. Click one to cast it. Teleports and portals you haven't learned yet are grayed out with the level you learn them at. See [Travel panel](features/travel-panel.html).

## That's it

Everything else works on its own. When you want to know what a card means or change how something behaves, look it up under [Features](features/).
