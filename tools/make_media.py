"""Draws Chronobound's textures into Media/ (TGA, power-of-two sizes).

Run from the addon folder:  python3 tools/make_media.py
Card textures are white with alpha so the game can tint them; the emblem is drawn in colour.
"""
import math
import random
from PIL import Image, ImageDraw, ImageFilter

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "LibBound", "tools"))
from paint import Canvas, bar, disc, grow, leaf, lick, mask, minus, poly, radial_disc, rays, ring, sparkle, union  # noqa: E402

S = 1024

OUT = "Media/"


def frost(size=128, seed=7):
    """Frosted glass: soft speckles and a few hairline crystal streaks, tileable, white on alpha."""
    rnd = random.Random(seed)
    img = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(img)
    for _ in range(900):
        x, y = rnd.randrange(size), rnd.randrange(size)
        v = rnd.randint(40, 140)
        for dx in (-size, 0, size):  # draw wrapped copies so the tile has no seams
            for dy in (-size, 0, size):
                d.point((x + dx, y + dy), fill=v)
    for _ in range(14):
        x, y = rnd.randrange(size), rnd.randrange(size)
        a = rnd.uniform(0, math.pi)
        length = rnd.randint(10, 26)
        for dx in (-size, 0, size):
            for dy in (-size, 0, size):
                d.line((x + dx, y + dy, x + dx + math.cos(a) * length, y + dy + math.sin(a) * length), fill=170, width=1)
    img = img.filter(ImageFilter.GaussianBlur(0.7))
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(img)
    return out


def shard(size=32):
    """An ice shard cut into the top-left corner: a sharp facet with a bright edge."""
    s = size * 4
    img = Image.new("L", (s, s), 0)
    d = ImageDraw.Draw(img)
    d.polygon([(0, 0), (s * 0.92, 0), (s * 0.30, s * 0.30), (0, s * 0.92)], fill=150)
    d.polygon([(0, 0), (s * 0.62, 0), (s * 0.18, s * 0.18), (0, s * 0.62)], fill=235)
    d.line([(s * 0.92, 0), (s * 0.30, s * 0.30), (0, s * 0.92)], fill=255, width=6)
    img = img.resize((size, size), Image.LANCZOS)
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(img)
    return out


def rim(size=64, width=5):
    """A soft glow along the edge of a square, for the breathing rim (stretched over the card)."""
    img = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(img)
    for i in range(width * 2):
        v = int(255 * (1 - i / (width * 2)) ** 2)
        d.rectangle([i, i, size - 1 - i, size - 1 - i], outline=v)
    img = img.filter(ImageFilter.GaussianBlur(1.2))
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(img)
    return out


def emblem(size=256):
    """The Chronobound emblem, painted (tools in LibBound/tools/paint.py)."""
    s = S
    cv = Canvas(s)
    radial_disc(cv, 0.40, (40, 70, 140), (6, 12, 34))
    cv.light(rays(s, 24, 0.10, 0.40, 0.05).filter(ImageFilter.GaussianBlur(8)), (60, 110, 220), 0.35)
    rg = ring(s, 0.415, 0.372)
    cv.glow(rg, (120, 170, 255), 20, 0.6)
    cv.paint(rg, top=(225, 235, 250), bottom=(70, 90, 130), bevel=8, gloss=0.6)
    ticks = mask(s)
    for k in range(12):
        a = k * math.pi / 6
        r0, r1 = (0.29, 0.355) if k % 3 == 0 else (0.315, 0.355)
        w = 0.012 if k % 3 == 0 else 0.007
        ticks = union(ticks, bar(s, 0.5 + math.sin(a) * r0, 0.5 - math.cos(a) * r0, 0.5 + math.sin(a) * r1, 0.5 - math.cos(a) * r1, w))
    cv.paint(ticks, top=(230, 240, 255), bottom=(120, 150, 200), bevel=3, gloss=0.4)
    hands = union(bar(s, 0.5, 0.5, 0.5 + math.sin(math.radians(300)) * 0.25, 0.5 - math.cos(math.radians(300)) * 0.25, 0.010),
                  bar(s, 0.5, 0.5, 0.5 + math.sin(math.radians(60)) * 0.17, 0.5 - math.cos(math.radians(60)) * 0.17, 0.013))
    cv.paint(hands, top=(255, 230, 160), bottom=(150, 110, 40), bevel=3, gloss=0.5)
    # the crystal: six facets around a ridge, breaking out of the ring top and bottom
    T, UR, LR, B, LL, UL, C = (0.5, 0.04), (0.615, 0.30), (0.60, 0.72), (0.5, 0.96), (0.40, 0.72), (0.385, 0.30), (0.505, 0.50)
    whole = poly(s, [T, UR, LR, B, LL, UL])
    cv.glow(whole, (110, 190, 255), 50, 0.9)
    cv.shadow(whole, 16, 8, 12, 0.6)
    facets = [([T, C, UL], (245, 252, 255), (170, 215, 250)), ([T, UR, C], (180, 220, 250), (90, 150, 220)),
              ([UL, C, LL], (190, 230, 255), (110, 170, 235)), ([UR, LR, C], (80, 140, 215), (30, 70, 160)),
              ([LL, C, B], (130, 190, 245), (40, 90, 180)), ([C, LR, B], (50, 100, 190), (15, 40, 110))]
    for pts, top, bot in facets:
        cv.paint(poly(s, pts), top=top, bottom=bot, bevel=0)
    edges = mask(s); d = ImageDraw.Draw(edges)
    for a, b in ((T, C), (UL, C), (UR, C), (LL, C), (LR, C), (B, C)):
        d.line([(a[0] * s, a[1] * s), (b[0] * s, b[1] * s)], fill=255, width=3)
    d.line([(p[0] * s, p[1] * s) for p in (T, UR, LR, B, LL, UL, T)], fill=255, width=5)
    cv.light(edges.filter(ImageFilter.GaussianBlur(1.5)), (200, 235, 255), 0.7)
    for x, y, r in ((0.30, 0.22, 0.06), (0.72, 0.80, 0.05), (0.73, 0.25, 0.035), (0.27, 0.74, 0.03), (0.47, 0.14, 0.03)):
        cv.light(sparkle(s, x, y, r).filter(ImageFilter.GaussianBlur(2)), (230, 245, 255), 1.0)
    return cv.image(size)


def icon(size):
    """Square icon: the emblem on a dark ice-blue gradient."""
    bg = Image.new("RGBA", (size, size), (0, 0, 0, 255))
    d = ImageDraw.Draw(bg)
    for y in range(size):
        t = y / size
        d.line([(0, y), (size, y)], fill=(int(10 + 20 * (1 - t)), int(30 + 40 * (1 - t)), int(48 + 60 * (1 - t)), 255))
    e = emblem(size * 2).resize((size, size), Image.LANCZOS)
    return Image.alpha_composite(bg, e)


def _finish(img, size):
    """White line art at 4x: a soft glow under it, down to size, as alpha."""
    glow = img.filter(ImageFilter.GaussianBlur(img.size[0] * 0.012))
    img = Image.composite(img, glow, img).resize((size, size), Image.LANCZOS)
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(img)
    return out

def crest(size=256):
    """The card crest: an arcane clock face with a frost star at its heart."""
    s = size * 4
    c = s / 2
    img = Image.new("L", (s, s), 0)
    d = ImageDraw.Draw(img)
    w = int(s * 0.018)
    d.ellipse([s * 0.06, s * 0.06, s * 0.94, s * 0.94], outline=255, width=w)
    d.ellipse([s * 0.17, s * 0.17, s * 0.83, s * 0.83], outline=200, width=int(w * 0.7))
    for k in range(12):
        a = k * math.pi / 6
        r0 = 0.30 if k % 3 == 0 else 0.34
        d.line([(c + math.sin(a) * s * r0, c - math.cos(a) * s * r0),
                (c + math.sin(a) * s * 0.40, c - math.cos(a) * s * 0.40)], fill=255, width=w)
    for k in range(24):
        a = (k + 0.5) * math.pi / 12
        x, y = c + math.sin(a) * s * 0.385, c - math.cos(a) * s * 0.385
        d.ellipse([x - w * 0.6, y - w * 0.6, x + w * 0.6, y + w * 0.6], fill=180)
    for a, r in ((math.radians(300), 0.24), (math.radians(40), 0.16)):
        d.line([(c, c), (c + math.sin(a) * s * r, c - math.cos(a) * s * r)], fill=255, width=int(w * 1.2))
    for k in range(6):
        a = k * math.pi / 3
        d.line([(c, c), (c + math.sin(a) * s * 0.08, c - math.cos(a) * s * 0.08)], fill=230, width=int(w * 0.8))
    return _finish(img, size)


def save(img, name):
    img.save(OUT + name + ".tga")
    print("wrote", OUT + name + ".tga", img.size)


if __name__ == "__main__":
    save(frost(), "Frost")
    save(shard(), "Shard")
    save(crest(), "Crest")
    save(rim(), "Rim")
    save(emblem(256), "Logo256")
    save(emblem(64), "Logo64")
    save(icon(64), "Icon64")
    save(icon(128), "Icon128")
