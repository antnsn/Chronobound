---
title: Portal service
parent: Features
nav_order: 9
description: Post your portal offer in Trade with one key press, and hear it when someone asks. Click Invite or Whisper in chat.
---

# Portal service

Sell portal to other players. Post your offer in Trade with one key press, and when someone asks for it in chat you hear a sound and get a line with **[Invite]** and **[Whisper]** to click.

## Posting your offer

- Set a key under **Portal service** in the `/cb` window (**Announce key**), click **Announce now** there, or type `/cb announce`.
- The game only lets addons post in Trade when you press a key or click, so there is no automatic posting on a timer.
- Your message, with the placeholders filled in, goes to the Trade channel. Outside a city there is no Trade channel, and you get a note instead.
- To keep you out of trouble for spamming, it waits at least 60 seconds between posts (you can set 30 to 300).

The example message:

```
Portals to {portals}! Whisper "port {short}", tips welcome :)
```

Write your own in the box on the page. Placeholders: `{portals}` (the portals you know), `{short}` (the same as players type them: org/uc/tb), `{runes}` (your Runes of Portals), `{zone}` (where you are) and `{level}` (your level). **Reset to example** brings the example back, and the line under the box shows what will be posted.

You need at least one portal (Portal: Orgrimmar and Undercity at level 40, Thunder Bluff at 50); before that the addon says so instead of posting, and gives no alerts.

## Alerts

When someone asks in Trade, General, LookingForGroup, say, yell or a whisper, you get a sound and one chat line:

```
[Chronobound] Thrall: wtb port org  [Invite] [Whisper]
```

Click **[Invite]** to invite them to your group, or **[Whisper]** to start a whisper.

- In public chat it needs a request, not just the word: "wtb port org", "any portal to tb?", "lf mage port uc", "need a port pls". A city or "portal" alone in Trade does nothing, but in a whisper a city name alone ("uc") is enough.
- Other players' offers ("WTS ...", "/w me", "tips welcome") don't count.
- The same person again within a minute gives no second line.
- Your own posts never alert you.
- Add your own words under **Extra words** (comma between them).

## Auto-whisper

Off by default. Turned on, the addon whispers your reply (on the page, with `{name}` for their name) to each person who asks, once per person per 10 minutes, never while you are in combat.

## Settings

| Setting | Default | What it does |
| --- | --- | --- |
| Alerts | on | the sound and chat line when someone asks |
| Sound | on | a sound with each alert |
| Auto-whisper | off | whisper your reply to each person who asks |
| Announce key | none | the key that posts your message |
| Wait between posts | 60 s | 30 to 300 seconds |
| Channel | Trade | the channel to post in |
| Extra words | none | more words that count as a request |
