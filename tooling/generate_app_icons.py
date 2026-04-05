from __future__ import annotations

import argparse
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"
DESIGN_ASSETS = ROOT / "design-assets" / "app_icons"

GRAPHITE = "#131922"
AMBER = "#D9A441"
AMBER_LIGHT = "#F0B944"
SLATE = "#4B5968"
SLATE_DARK = "#31404D"
FAR_SLATE = "#394553"
FAR_SLATE_DARK = "#26313D"
SHELF = "#6F7D8C"
MONO = "#F4F7FA"

BASE = 1024.0
ADAPTIVE_FOREGROUND_SCALE = 0.88
CONTENT_OFFSET_Y = 24.0


def scale(value: float, size: int) -> float:
    return value * size / BASE


def adaptive_scale(value: float, size: int, content_scale: float) -> float:
    base_value = scale(value, size)
    center = size / 2
    return center + (base_value - center) * content_scale


def adaptive_x(value: float, size: int, content_scale: float) -> float:
    return adaptive_scale(value, size, content_scale)


def adaptive_y(value: float, size: int, content_scale: float, offset_y: float) -> float:
    return adaptive_scale(value, size, content_scale) + scale(offset_y, size)


def rgba(hex_color: str, alpha: int = 255) -> tuple[int, int, int, int]:
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4)) + (alpha,)


def ensure_dirs(paths: Iterable[Path]) -> None:
    for path in paths:
        path.mkdir(parents=True, exist_ok=True)


def draw_rounded_rect(
    canvas: Image.Image,
    box: tuple[float, float, float, float],
    radius: float,
    fill: tuple[int, int, int, int],
    *,
    angle: float = 0,
    center: tuple[float, float] | None = None,
) -> None:
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    draw.rounded_rectangle(box, radius=radius, fill=fill)
    if angle:
        rotate_center = center if center is not None else ((box[0] + box[2]) / 2, (box[1] + box[3]) / 2)
        layer = layer.rotate(angle, resample=Image.Resampling.BICUBIC, center=rotate_center)
    canvas.alpha_composite(layer)


def draw_horizontal_gradient_pill(
    canvas: Image.Image,
    box: tuple[float, float, float, float],
    radius: float,
    left: tuple[int, int, int, int],
    middle: tuple[int, int, int, int],
    right: tuple[int, int, int, int],
) -> None:
    x0, y0, x1, y1 = [int(v) for v in box]
    width = max(1, x1 - x0)
    height = max(1, y1 - y0)
    gradient = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    pixels = gradient.load()
    for x in range(width):
        t = x / max(1, width - 1)
        if t <= 0.5:
            inner_t = t / 0.5
            color = tuple(int(left[i] + (middle[i] - left[i]) * inner_t) for i in range(4))
        else:
            inner_t = (t - 0.5) / 0.5
            color = tuple(int(middle[i] + (right[i] - middle[i]) * inner_t) for i in range(4))
        for y in range(height):
            pixels[x, y] = color
    mask = Image.new("L", (width, height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle((0, 0, width, height), radius=int(radius), fill=255)
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    layer.paste(gradient, (x0, y0), mask)
    canvas.alpha_composite(layer)


def draw_center_glow(canvas: Image.Image, size: int, *, content_scale: float, offset_y: float) -> None:
    glow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(glow)
    box = (
        adaptive_x(382 - 18, size, content_scale),
        adaptive_y(236 - 18, size, content_scale, offset_y),
        adaptive_x(642 + 18, size, content_scale),
        adaptive_y(626 + 18, size, content_scale, offset_y),
    )
    draw.rounded_rectangle(box, radius=scale(38, size), fill=rgba(AMBER, 88))
    glow = glow.filter(ImageFilter.GaussianBlur(radius=scale(18, size)))
    canvas.alpha_composite(glow)


def draw_full_icon(
    size: int,
    *,
    include_background: bool,
    monochrome: bool,
    include_glow: bool,
    content_scale: float = 1.0,
    offset_y: float = CONTENT_OFFSET_Y,
) -> Image.Image:
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    if include_background:
        bg = ImageDraw.Draw(image)
        bg.rounded_rectangle((0, 0, size, size), radius=scale(256, size), fill=rgba(GRAPHITE))

    if include_glow and not monochrome:
        draw_center_glow(image, size, content_scale=content_scale, offset_y=offset_y)

    shelf_left = rgba(SHELF if not monochrome else MONO)
    shelf_mid = rgba("#798696" if not monochrome else MONO)
    draw_horizontal_gradient_pill(
        image,
        (
            adaptive_x(240, size, content_scale),
            adaptive_y(682, size, content_scale, offset_y),
            adaptive_x(784, size, content_scale),
            adaptive_y(720, size, content_scale, offset_y),
        ),
        scale(19, size),
        shelf_left,
        shelf_mid,
        shelf_left,
    )

    far_fill = rgba(FAR_SLATE if not monochrome else MONO, 128 if not monochrome else 255)
    side_fill = rgba(SLATE if not monochrome else MONO, 230 if not monochrome else 255)
    center_fill = rgba(AMBER_LIGHT if not monochrome else MONO)

    draw_rounded_rect(
        image,
        (
            adaptive_x(232, size, content_scale),
            adaptive_y(366, size, content_scale, offset_y),
            adaptive_x(342, size, content_scale),
            adaptive_y(658, size, content_scale, offset_y),
        ),
        scale(25, size),
        far_fill,
        angle=-10,
        center=(adaptive_x(287, size, content_scale), adaptive_y(512, size, content_scale, offset_y)),
    )
    draw_rounded_rect(
        image,
        (
            adaptive_x(682, size, content_scale),
            adaptive_y(366, size, content_scale, offset_y),
            adaptive_x(792, size, content_scale),
            adaptive_y(658, size, content_scale, offset_y),
        ),
        scale(25, size),
        far_fill,
        angle=10,
        center=(adaptive_x(737, size, content_scale), adaptive_y(512, size, content_scale, offset_y)),
    )
    draw_rounded_rect(
        image,
        (
            adaptive_x(286, size, content_scale),
            adaptive_y(338, size, content_scale, offset_y),
            adaptive_x(434, size, content_scale),
            adaptive_y(666, size, content_scale, offset_y),
        ),
        scale(28, size),
        side_fill,
        angle=-6,
        center=(adaptive_x(360, size, content_scale), adaptive_y(502, size, content_scale, offset_y)),
    )
    draw_rounded_rect(
        image,
        (
            adaptive_x(590, size, content_scale),
            adaptive_y(338, size, content_scale, offset_y),
            adaptive_x(738, size, content_scale),
            adaptive_y(666, size, content_scale, offset_y),
        ),
        scale(28, size),
        side_fill,
        angle=6,
        center=(adaptive_x(664, size, content_scale), adaptive_y(502, size, content_scale, offset_y)),
    )
    draw_rounded_rect(
        image,
        (
            adaptive_x(382, size, content_scale),
            adaptive_y(236, size, content_scale, offset_y),
            adaptive_x(642, size, content_scale),
            adaptive_y(626, size, content_scale, offset_y),
        ),
        scale(38, size),
        center_fill,
    )

    if not monochrome:
        top_sheen = Image.new("RGBA", image.size, (0, 0, 0, 0))
        sheen_draw = ImageDraw.Draw(top_sheen)
        sheen_draw.rounded_rectangle(
            (
                adaptive_x(382, size, content_scale),
                adaptive_y(236, size, content_scale, offset_y),
                adaptive_x(642, size, content_scale),
                adaptive_y(626, size, content_scale, offset_y),
            ),
            radius=scale(38, size),
            fill=rgba("#FFFFFF", 0),
        )
        sheen = Image.new("RGBA", image.size, (0, 0, 0, 0))
        sheen_draw = ImageDraw.Draw(sheen)
        sheen_draw.rounded_rectangle(
            (
                adaptive_x(382, size, content_scale),
                adaptive_y(236, size, content_scale, offset_y),
                adaptive_x(642, size, content_scale),
                adaptive_y(430, size, content_scale, offset_y),
            ),
            radius=scale(38, size),
            fill=rgba("#FFF2C5", 18),
        )
        image.alpha_composite(sheen)

    return image


def save_png(path: Path, image: Image.Image) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, format="PNG")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate OneShelf app icon assets.")
    parser.add_argument(
        "--write-android",
        action="store_true",
        help="Also write launcher assets into android/app/src/main/res.",
    )
    args = parser.parse_args()

    ensure_dirs(
        [
            DESIGN_ASSETS / "android",
            DESIGN_ASSETS / "ios",
        ]
    )

    full_1024 = draw_full_icon(1024, include_background=True, monochrome=False, include_glow=True)
    full_512 = draw_full_icon(512, include_background=True, monochrome=False, include_glow=True)
    adaptive_preview = draw_full_icon(1024, include_background=True, monochrome=False, include_glow=False)
    tinted_template = draw_full_icon(1024, include_background=False, monochrome=True, include_glow=False)
    android_foreground = draw_full_icon(
        432, include_background=False, monochrome=False, include_glow=False, content_scale=ADAPTIVE_FOREGROUND_SCALE
    )
    android_monochrome = draw_full_icon(
        432, include_background=False, monochrome=True, include_glow=False, content_scale=ADAPTIVE_FOREGROUND_SCALE
    )

    save_png(DESIGN_ASSETS / "ios" / "oneshelf-ios-appicon-1024.png", full_1024)
    save_png(DESIGN_ASSETS / "ios" / "oneshelf-ios-tinted-template-1024.png", tinted_template)
    save_png(DESIGN_ASSETS / "android" / "oneshelf-play-store-512.png", full_512)
    save_png(DESIGN_ASSETS / "android" / "oneshelf-android-adaptive-preview-1024.png", adaptive_preview)
    save_png(DESIGN_ASSETS / "android" / "oneshelf-android-foreground-432.png", android_foreground)
    save_png(DESIGN_ASSETS / "android" / "oneshelf-android-monochrome-432.png", android_monochrome)

    if args.write_android:
        ensure_dirs(
            [
                ANDROID_RES / "mipmap-anydpi-v26",
                ANDROID_RES / "drawable-mdpi",
                ANDROID_RES / "drawable-hdpi",
                ANDROID_RES / "drawable-xhdpi",
                ANDROID_RES / "drawable-xxhdpi",
                ANDROID_RES / "drawable-xxxhdpi",
            ]
        )

        legacy_sizes = {
            "mipmap-mdpi": 48,
            "mipmap-hdpi": 72,
            "mipmap-xhdpi": 96,
            "mipmap-xxhdpi": 144,
            "mipmap-xxxhdpi": 192,
        }
        for folder, px in legacy_sizes.items():
            legacy_icon = draw_full_icon(px, include_background=True, monochrome=False, include_glow=True)
            save_png(ANDROID_RES / folder / "ic_launcher.png", legacy_icon)
            save_png(ANDROID_RES / folder / "ic_launcher_round.png", legacy_icon)

        adaptive_sizes = {
            "drawable-mdpi": 108,
            "drawable-hdpi": 162,
            "drawable-xhdpi": 216,
            "drawable-xxhdpi": 324,
            "drawable-xxxhdpi": 432,
        }
        for folder, px in adaptive_sizes.items():
            foreground = draw_full_icon(
                px, include_background=False, monochrome=False, include_glow=False, content_scale=ADAPTIVE_FOREGROUND_SCALE
            )
            monochrome = draw_full_icon(
                px, include_background=False, monochrome=True, include_glow=False, content_scale=ADAPTIVE_FOREGROUND_SCALE
            )
            save_png(ANDROID_RES / folder / "ic_launcher_foreground.png", foreground)
            save_png(ANDROID_RES / folder / "ic_launcher_monochrome.png", monochrome)


if __name__ == "__main__":
    main()
