"""Draws Chronobound's textures into Media/ (TGA, power-of-two sizes).

Run from the addon folder:  python3 tools/make_media.py
Card textures are white with alpha so the game can tint them; the emblem is drawn in colour.
"""
import math
import random
from PIL import Image, ImageDraw, ImageFilter

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
    """The Chronobound emblem: a six-pointed ice crystal over a faint clock ring, in frost colours."""
    s = size * 4
    c = s / 2
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # clock ring with twelve ticks
    d.ellipse([s * 0.08, s * 0.08, s * 0.92, s * 0.92], outline=(150, 215, 255, 170), width=int(s * 0.018))
    for i in range(12):
        a = math.radians(i * 30)
        r1, r2 = s * 0.37, s * (0.42 if i % 3 == 0 else 0.40)
        d.line([(c + math.cos(a) * r1, c + math.sin(a) * r1), (c + math.cos(a) * r2, c + math.sin(a) * r2)],
               fill=(190, 235, 255, 200), width=int(s * 0.012))
    # crystal arms with side branches
    for i in range(6):
        a = math.radians(i * 60 - 90)
        tip = (c + math.cos(a) * s * 0.34, c + math.sin(a) * s * 0.34)
        side = math.radians(90)
        w = s * 0.035
        l = (c + math.cos(a - side) * w, c + math.sin(a - side) * w)
        r = (c + math.cos(a + side) * w, c + math.sin(a + side) * w)
        d.polygon([l, tip, r], fill=(215, 245, 255, 255))
        for f in (0.45, 0.68):
            bx, by = c + math.cos(a) * s * 0.34 * f, c + math.sin(a) * s * 0.34 * f
            for turn in (-1, 1):
                b = a + turn * math.radians(45)
                d.line([(bx, by), (bx + math.cos(b) * s * 0.08, by + math.sin(b) * s * 0.08)],
                       fill=(200, 240, 255, 240), width=int(s * 0.02))
    d.ellipse([c - s * 0.06, c - s * 0.06, c + s * 0.06, c + s * 0.06], fill=(240, 252, 255, 255))
    glow = img.filter(ImageFilter.GaussianBlur(s * 0.02))
    out = Image.alpha_composite(glow, img).resize((size, size), Image.LANCZOS)
    return out


def icon(size):
    """Square icon: the emblem on a dark ice-blue gradient."""
    bg = Image.new("RGBA", (size, size), (0, 0, 0, 255))
    d = ImageDraw.Draw(bg)
    for y in range(size):
        t = y / size
        d.line([(0, y), (size, y)], fill=(int(10 + 20 * (1 - t)), int(30 + 40 * (1 - t)), int(48 + 60 * (1 - t)), 255))
    e = emblem(size * 2).resize((size, size), Image.LANCZOS)
    return Image.alpha_composite(bg, e)


def save(img, name):
    img.save(OUT + name + ".tga")
    print("wrote", OUT + name + ".tga", img.size)


if __name__ == "__main__":
    save(frost(), "Frost")
    save(shard(), "Shard")
    save(rim(), "Rim")
    save(emblem(256), "Logo256")
    save(emblem(64), "Logo64")
    save(icon(64), "Icon64")
    save(icon(128), "Icon128")
