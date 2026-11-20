"""Draws Chronobound's textures into Media/ (TGA, power-of-two sizes).

Run from the addon folder:  python3 tools/make_media.py
Card textures are white with alpha so the game can tint them; the emblem comes from the painted art.
"""
import math
import random
from PIL import Image, ImageChops, ImageDraw, ImageFilter


OUT = "Media/"
ART = "Chronobound.png"  # painted by Marius; the logo, icon and crest are made from it


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
    """The emblem, from the painted art in Chronobound.png (also the CurseForge project picture)."""
    return Image.open(ART).convert("RGBA").resize((size, size), Image.LANCZOS)


def crest(size=256):
    """The card crest: the same art as a white shape for the game to tint, its light parts
    brighter, so the faint motif behind the cards matches the icon."""
    art = emblem(size)
    lum = art.convert("L").point([int(70 + v * 185 / 255) for v in range(256)])
    alpha = ImageChops.multiply(art.getchannel("A"), lum)
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(alpha)
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
    save(crest(), "Crest")
    save(rim(), "Rim")
    save(emblem(256), "Logo256")
    save(emblem(64), "Logo64")
    save(icon(64), "Icon64")
    save(icon(128), "Icon128")
