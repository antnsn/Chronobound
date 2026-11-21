---
title: Food and water
parent: Features
nav_order: 1
description: A card when your conjured food or water runs low, or when you can make a better rank. Click it to conjure more.
---

# Food and water

Mages make their own food and water. Chronobound counts what you carry and shows a card when it runs low, so you never sit down after a fight with nothing to drink.

## What it does

- Two cards: **Conjure water** and **Conjure food**. Each one works on its own.
- Chronobound counts every rank of conjured water (or food) in your bags, old and new together.
- When the count drops to the warning level or below, the card shows with a glow and the count, for example `4 Conjured Spring Water left`. At 0 it says `No water left` (or `No food left`), highlighted.
- **Click the card to conjure more.** It always conjures your best rank.
- **A better rank is known.** When you carry enough, but all of it is an older rank than you can make, the card shows without a glow and says `A better rank is known`. It goes away as soon as you carry one of the new rank. Click it to conjure the new rank.
- The cards hide in combat and come back after the fight.
- A card only shows once you know the conjure spell. Before you learn Conjure Food, there is no food card.

## How to use it

1. Play as usual. When a card shows up, click it. You conjure one batch of your best rank.
2. Click again until you have as much as you want. The card goes away once you carry more than the warning level.
3. Want to carry more before it warns? Raise the warning level on the **Food & water** page.

{: .tip }
The [buff key](buff-key.html) conjures too: when the water or food card is up and no buff card comes before it, the key conjures for you.

## Settings

In `/cb`, page **Food & water**:

| Setting | Default | What it does |
| --- | --- | --- |
| Watch conjured food and water | On | Turns both cards on or off. |
| Water: warn at | 5 | The card shows when you carry this many conjured water or fewer. 0 to 40. |
| Food: warn at | 3 | The card shows when you carry this many conjured food or fewer. 0 to 40. |

At 0, a card only shows when you have none left.

## Good to know

**Why does it say "A better rank is known" when my bags are full of water?**
You trained a new rank, and none of your water is that rank yet. New water brings back more mana. Conjure fresh and throw the old away when you need the space. The card has no glow, since nothing is urgent.

**Does it count bought food and water?**
No. It only counts mage-conjured food and water.

**The card doesn't respond to my click.**
Clicks only cast out of combat, and in combat the card is hidden anyway. If it still doesn't cast, the frames may be unlocked: unlocked cards can be dragged, not clicked. Type `/cb lock`.

**Hover over the card** to read what it is for, when [explanations](explanations.html) are on.
