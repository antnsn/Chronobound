---
title: Buffs
parent: Features
nav_order: 2
description: A card when Arcane Intellect or your armor is missing or about to run out. Click it to cast.
---

# Buffs

Arcane Intellect and your armor spell should be on you all the time. Chronobound warns you before one runs out and shows a card when it is gone. Click the card to cast it.

## What it does

There are two cards, **Arcane Intellect** and your armor. Each one does the same three things:

- **A warning before it runs out.** When the buff has less time left than you set (2 minutes for Arcane Intellect, 1 minute for armor by default), a message shows in the middle of the screen and in chat, for example `Arcane Intellect: 2 min left`.
- **A countdown card.** After the warning, the card counts down the time left. Click it to cast the buff again.
- **A card when it is missing.** When the buff is gone, the card shows a gray icon and `Missing: click to cast`. Once, out of combat and while you are alive, you also get a message: `Arcane Intellect is gone, rebuff`.

The armor card:

- Is titled with the armor it will cast: **Frost Armor**, then **Ice Armor** once you learn it, or **Mage Armor** if you pick it on the **Buffs** page and know it.
- Counts any of the three as armor. If you pick Mage Armor while Frost Armor is up, the card waits until no armor is up before it asks for Mage Armor. The messages call it `Armor`, for example `Armor: 1 min left`.

Arcane Intellect also counts when it is **Arcane Brilliance**, or when another mage cast it on you.

A spell you haven't learned yet shows no card at all.

## How to use it

1. When a card shows up, click it out of combat. It casts your best rank on yourself.
2. On the **Buffs** page, pick **Armor to keep up**: Frost (Frost or Ice Armor) or Mage.
3. Want a sound with the warning? Tick **Sound** for that buff.

{: .tip }
The [buff key](buff-key.html) casts these cards for you, one press each.

## Settings

In `/cb`, page **Buffs**. The **Arcane Intellect** and **Armor** sections have the same settings:

| Setting | Default | What it does |
| --- | --- | --- |
| Show | On | The warning and the cards for this buff. Off: nothing at all for it. |
| Sound | Off | Plays the raid warning sound with the warning and the "is gone" message. |
| When missing | On | Shows the "Missing: click to cast" card and the one "is gone, rebuff" message once the buff is gone. Off: no card and no message after it runs out. |
| Warn with time left | 2 min (Arcane Intellect), 1 min (Armor) | When the warning comes and the countdown card starts. 1 to 10 minutes. |

Below the Armor section:

| Setting | Default | What it does |
| --- | --- | --- |
| Armor to keep up | Frost | **Frost**: Frost Armor, or Ice Armor once you learn it. More armor, and slows enemies that hit you. **Mage**: Mage Armor, more mana back while casting (from level 34). Until you learn Mage Armor, the card uses Frost or Ice Armor. |

Left-click the button for the next choice, right-click for the previous one.

## Good to know

**Does it work in combat?**
The cards stay on screen in combat, but clicks only cast out of combat. The game does not let addons cast for you in combat.

**Turning off Arcane Intellect also stops the buff key from buffing the group.**
The **Show** switch in the Arcane Intellect section also decides whether the [buff key](buff-key.html) puts Arcane Intellect on your party.

**Right after you log in or change zones**, the cards wait about 5 seconds before they say a buff is missing. The game fills in your buffs a moment after loading.

**When combat hides buffs from addons**, the cards keep what they knew before the fight and catch up after it.

**Hover over a card** to read what the buff does, when [explanations](explanations.html) are on.
