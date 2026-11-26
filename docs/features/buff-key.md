---
title: Buff key
parent: Features
nav_order: 3
description: One key that casts what the cards ask for, then Arcane Intellect on the next party member who is missing it.
---

# Buff key

Press one key, out of combat, and Chronobound casts the next thing that is needed: your own buffs and conjured water or food first, then Arcane Intellect on your group.

## What it does

- Each press casts **one** spell.
- First, it casts what the first card on screen asks for, the same spell a click on that card would cast. The cards are checked in this order:
  1. **Arcane Intellect** on yourself.
  2. **Your armor.**
  3. **Conjure water.**
  4. **Conjure food.**
- When no card asks for anything, it casts **Arcane Intellect** on the next party or raid member who is missing it, or whose Arcane Intellect has less than a minute left. Arcane Brilliance counts as having it.
- It skips players who are offline, dead, not friendly, too far away or out of range.
- **Lower-level players get the rank they can take.** A buff only goes on someone at most 10 levels below the rank's spell level, so a level 30 gets Arcane Intellect rank 3 at most, not rank 5.
- When there is nothing left to do, a press says `nothing to buff right now.` in chat.
- In combat, the key does nothing.

See [Buffs](buffs.html) and [Food and water](food-and-water.html) for when those cards show up.

## How to use it

1. Type `/cb` and open the **Extras** page.
2. Under **Buff key**, click the button next to **Key**, then press the key you want (for example Shift-Q). Esc cancels.
3. Out of combat, press your key until chat says there is nothing to buff. Each press casts one spell.

## Settings

In `/cb`, page **Extras**, section **Buff key**:

| Setting | Default | What it does |
| --- | --- | --- |
| Key | Not set | The key itself. **Clear** removes it. |

Arcane Intellect for the group follows the **Show** switch in the Arcane Intellect section of the **Buffs** page. Turn that off and the key stops buffing the group too. See [Buffs](buffs.html#settings).

## Good to know

**Does it work in combat?**
No. The game does not let addons pick targets for you in combat. Buff before the pull.

**It conjured water when I wanted to buff the group.**
The cards come first. When the water card is up, the key conjures until the card goes away, then moves on to the group. Lower **Water: warn at** on the **Food & water** page if it conjures too early for you.

**Someone is missing Arcane Intellect but the key skips them.**
They are probably out of range or too far away. When the game hides a player's buffs from addons, the key also skips that player, so it doesn't buff someone who may already have it.

**Do I get Arcane Intellect myself from the group part?**
No. Your own Arcane Intellect comes from the Arcane Intellect card, which comes first.

**The key button says "leave combat first."**
You can't set the key in combat. Try again after the fight.

**The key overrides what the key did before** while Chronobound is loaded. Clear it on the **Extras** page to get your old binding back.
