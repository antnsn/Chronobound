---
title: Quality of life
parent: Features
nav_order: 7
description: The minimap button, and moving and resizing every frame.
---

# Quality of life

Open Chronobound from the minimap, and put every card exactly where you want it.

## What it does

### Minimap button and addon menu

| Click | Does |
| --- | --- |
| Left-click | Opens the options (`/cb`). |
| Shift-click or middle-click | Unlocks the frames (and locks them again). |
| Drag | Moves the button around the minimap. |

The button works with minimap addons such as EllesmereUI, SexyMap, ElvUI, MinimapButtonBag and broker bars: they collect it like any other button.

Where the game has an addon menu (the puzzle-piece button), Chronobound is listed there too, with the same clicks. The game's **Settings > AddOns** list also has a Chronobound entry with an **Open options** button.

### Moving and resizing frames

- Unlocking shows **every** Chronobound card, with sample text, so you can place cards that are normally hidden.
- Drag a card to move it. Cards snap to a grid around the center of your screen. Hold **Shift** while dragging to place a card freely.
- Scroll the **mouse wheel** over a card to make it bigger or smaller (50% to 250%). Chat says the new size.
- While unlocked, a small bar at the top of the screen sets the grid size (**-** and **+**, or the mouse wheel; hold Shift for 1 pixel steps), turns **Snap** on or off, and has a **Lock** button.
- **Reset positions** puts every card back in its default place and size.

## How to use it

**Moving frames**

1. Type `/cb unlock`, Shift-click the minimap button, or click **Unlock frames** at the bottom of the `/cb` window.
2. Drag cards into place. Scroll on a card to resize it.
3. Click **Lock** on the bar at the top, or type `/cb lock`.
4. Made a mess? `/cb reset` (or **Reset positions** in `/cb`) puts everything back.

## Settings

In `/cb`, page **Skin**, section **General**:

| Setting | Default | What it does |
| --- | --- | --- |
| Minimap button (left-click options, shift-click unlock) | On | Shows or hides the minimap button. Also `/cb minimap`. |

The grid has no options page. Change it on the bar shown while frames are unlocked, or with `/cb grid`:

| Command | Does |
| --- | --- |
| `/cb grid` | Turns snapping on or off (on by default). |
| `/cb grid 30` | Sets the grid size (4 to 100, default 20) and turns snapping on. |

## Good to know

**Not in combat.**
Unlocking, locking, moving, resizing and resetting frames all wait until you leave combat. If a fight starts while you drag a card, the drag stops.

**Unlocked cards can't be clicked to cast.** Lock the frames again to use them.

**Closing the options window** locks the frames again, but only if you unlocked them with the options' own button. Frames unlocked with `/cb unlock` stay unlocked until you lock them.

**The options window and the travel panel** are not moved with unlock. Drag the options window by its title bar. The travel panel always sits beside the game menu.
