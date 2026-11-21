<p align="center"><img src="Chronobound.png" width="180" alt="Chronobound"></p>

# Chronobound

A mage helper for **WoW: Forever**, part of the Bound family: one addon per class on the same
core (Lightbound, Chronobound, Stormbound, Packbound, Spiritbound, Felbound, Dreambound).

Full guide: https://antnsn.github.io/Chronobound/

- **Food and water**: counts your conjured food and water and shows a card when it runs low.
  Click the card to conjure more (your best rank). Says so when you can make a better rank.
- **Buffs**: a card when Arcane Intellect or your armor (Frost Armor, Ice Armor or Mage Armor)
  is missing or about to run out. Click it to cast.
- **Buff key** (Extras page): out of combat, each press casts the next thing a card asks for, then Arcane Intellect on the next group member in range who is missing it.
- **Well-Rested and Well Fed**: a countdown before they run out, like Lightbound.
- **Travel**: press Escape, and beside the game menu you get your teleports and portals (click
  to cast), the ones you will learn later with their level, your rune counts and your Hearthstone.
- **Explained**: hover over a card or button for a plain-word explanation (can be turned off).
- Every frame can be moved and resized (`/cb unlock`), three skins (Frost crystal, Blizzard, Flat).

Type `/cb` for the options, `/cb help` for the commands.

## Install

1. Open [Releases](https://github.com/antnsn/Chronobound/releases) and download
   `Chronobound-<version>.zip` (not the green "Code > Download ZIP" button: that one unpacks as
   `Chronobound-main` and the game won't load it).
2. Unzip it into `World of Warcraft/_forever_/Interface/AddOns/`, so you get the folder
   `AddOns/Chronobound`.
3. Restart the game (a `/reload` is not enough for a new addon). Chronobound only loads on mages.

## Development

Chronobound is built on [LibBound](https://github.com/antnsn/LibBound), developed in the folder
next to it. `tools/sync-libbound.sh` copies it into `Libs/LibBound` for the game and the tests;
release zips embed it (`wowbench pack`).

```bash
tools/sync-libbound.sh
for f in *.lua; do luac5.1 -p "$f"; done
~/.luarocks/bin/luacheck .
wowbench check . && wowbench test .
wowbench pack . --set-version 0.1.0     # dist/Chronobound-0.1.0.zip
python3 tools/make_media.py             # redraws Media/*.tga
```

Spell and item IDs are Classic's (`Core.lua`, `ns.DATA`); they are checked in game before each
release.

## License

GPL-3.0-or-later: GNU General Public License, version 3 or (at your option) any later
version; see [LICENSE](LICENSE). LibBound-1.0 (in `Libs/LibBound`) is MIT, see its own LICENSE.
