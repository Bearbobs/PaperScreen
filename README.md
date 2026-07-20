# PaperScreen
 
A lightweight macOS utility that overlays a soft, procedurally generated paper texture across your screen — softening contrast and glare without tinting your colors like a blue-light filter.
 
Runs invisibly above every app, click-through, on every display, and stays out of your way.

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=CS7H4YVYFX2HA)

## Requirements
 
- macOS 11.0+
- Xcode 15+

## How It Works
 
1. **Overlay window** — a borderless, transparent `NSWindow` is created per screen at the highest window level, with `ignoresMouseEvents = true` and `.canJoinAllSpaces`, so it floats above everything without stealing focus or input.
2. **Texture generation** — Core Image's random noise generator is blurred and level-adjusted to produce an organic grain (the direct equivalent of SVG's `feTurbulence`), rendered once per texture preset.
3. **Compositing** — the noise layer is applied with a `.multiply` blend mode at low opacity, which darkens highlights and reduces perceived contrast without shifting hue — the effect of a physical matte screen protector, in software.

