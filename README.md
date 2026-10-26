# PaperScreen
 
A lightweight macOS utility that softens your screen with paper-like overlay textures and optional paper-tone or warm-light effects.
 
Runs invisibly above every app, click-through, on every display, and stays out of your way.

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=CS7H4YVYFX2HA)

## Requirements
 
- macOS 15.0+

## Display Modes

Choose any of the nine original paper types in **Settings → Overlay Texture**, then adjust opacity, grain size, and sharpness. These controls and the selected texture remain active in every mode.

Select an optional effect from the menu bar or **Settings → Color Effects**:

- **Default** uses the original selected texture, tint, and blend mode with no additional effect. New installations start here; an existing saved mode is kept.
- **Color E-paper** adds dimming, paper tone, and a fine procedural surface over the selected overlay texture. It retains the saved paper profile (Cotton Art Paper by default), without a separate Paper Style selector or profile name in the menu. The original overlay's paper type remains independently adjustable.
- **Soft Light** adds a warm tint over the selected overlay texture. Choose **Natural**, **Warm**, or **Deep Amber**, then adjust **Intensity** from 0% (original texture only) to 100% (strongest additional tint).

The selected texture, mode, Color E-paper style, Soft Light scene, and adjustments are saved between launches. Switching modes does not replace the original texture or reset its controls. Enable/disable and per-app exclusions apply to the complete overlay on every connected display. Choose **Disable PaperScreen** to remove it entirely.


## Download & Installation

- Download the latest PaperScreen.dmg from the Releases page:
    https://github.com/Bearbobs/PaperScreen/releases
- Open the downloaded DMG file,Drag PaperScreen.app into your Applications folder.
- Launch PaperScreen from Applications.
- The app will appear in your macOS menu bar.

### Opening the App (Unsigned Build)

PaperScreen isn't notarized or signed with an Apple Developer certificate, so macOS Gatekeeper will block it on first launch with a message like *"PaperScreen.app" is damaged and can't be opened* or *can't be opened because Apple cannot check it for malicious software*. This is expected for an open-source, self-distributed app — here's how to open it anyway:

**Option 1: System Settings**
1. Try to open PaperScreen normally (double-click) — it will be blocked.
2. Go to **System Settings → Privacy & Security**.
3. Scroll down to the Security section, where you'll see a message about PaperScreen being blocked.
4. Click **Open Anyway**.
5. Confirm by clicking **Open Anyway** again if prompted.

**Option 2: Terminal (if the above shows "damaged" instead of a security prompt)**
This happens because macOS strips the quarantine flag differently depending on how the DMG was downloaded. Run:
```bash
xattr -cr /Applications/PaperScreen.app
```
Then launch PaperScreen normally.

> **Why this happens:** Apple requires a paid Developer ID ($99/year) to notarize apps for smooth Gatekeeper approval. As a free, open-source project, PaperScreen doesn't currently use one. You can always verify what you're running by checking the source in this repo or building it yourself with Xcode.

## Screenshots
- Note: Try PaperScreen locally to replicate the real feel of the app.
  
<img width="1141" height="769" alt="Screenshot 2026-07-21 at 12 18 29 PM" src="https://github.com/user-attachments/assets/ee8db84d-2971-4198-991d-d6108d2ba2fe" />
<img width="1680" height="1050" alt="Screenshot 2026-07-21 at 3 15 48 PM" src="https://github.com/user-attachments/assets/5594388a-8a90-4a7c-8227-4ab49731483f" />


## How It Works
 
1. **Overlay window** — a borderless, transparent window is created per screen at the highest window level.
2. **Original texture overlay** — Core Image's random noise generator is blurred and level-adjusted for the selected paper type. Its original tint and blend mode remain active in every mode. The texture repeats at a fixed size in macOS points and renders at each display's backing scale, keeping grain size consistent across screen resolutions and Retina/non-Retina displays.
3. **Color E-paper** — a separate painter applies black dimming, a calibrated paper-color fill, then deterministic transparent fibers or grain using source-over compositing. Its four profiles and texture recipes follow the installed reference app's native defaults (PaperScreen 1.0.1, build 2; native intensity 0.35), including its dark-appearance adjustment. Fibrous papers repeat every 240 macOS points; finer grain papers repeat every 160 points. The [official style guide](https://paperscreen.app/en/help/color-e-paper-styles/) describes their relative character. Device-level pixel identity is not claimed: display color conversion and backing-scale rasterization can differ, and this app intentionally retains the original texture underneath.
4. **Soft Light** — a separate scene-based warm tint over the original texture. Default hides the add-on painter. Switching effects does not regenerate or replace the original texture.

## Contributing

Feel free to:

- Open an issue for bug reports, feature requests, improvements, or suggestions.
- Share ideas for new textures, customization options, or usability improvements.
- Submit a pull request with fixes or new features.

Every suggestion and contribution helps make PaperScreen better.


