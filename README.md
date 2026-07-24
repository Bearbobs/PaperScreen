PaperScreen
 
A lightweight macOS utility that adds a subtle grain overlay across your screen to take the edge off harsh, glossy displays. It works on contrast and texture rather than color temperature, so your whites stay white.
 
Runs invisibly above every app, click-through, on every display, and stays out of your way.

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=CS7H4YVYFX2HA)

## Requirements
 
- macOS 11.0+

## Download & Installation

- Download the latest PaperScreen.dmg from the Releases page:
    https://github.com/Bearbobs/PaperScreen/releases
- Open the downloaded DMG file,Drag PaperScreen.app into your Applications folder.
- Launch PaperScreen from Applications.
- The app will appear in your macOS menu bar.

+## Opening the App (Unsigned Build)
+
+PaperScreen isn't notarized or signed with an Apple Developer certificate, so macOS Gatekeeper will block it on first launch with a message like *"PaperScreen.app" is damaged and can't be opened* or *can't be opened because Apple cannot check it for malicious software*. This is expected for an open-source, self-distributed app — here's how to open it anyway:
+
+**Option 1: System Settings**
+1. Try to open PaperScreen normally (double-click) — it will be blocked.
+2. Go to **System Settings → Privacy & Security**.
+3. Scroll down to the Security section, where you'll see a message about PaperScreen being blocked.
+4. Click **Open Anyway**.
+5. Confirm by clicking **Open Anyway** again if prompted.
+
+**Option 2: Terminal (if the above shows "damaged" instead of a security prompt)**
+This happens because macOS strips the quarantine flag differently depending on how the DMG was downloaded. Run:
+```bash
+xattr -cr /Applications/PaperScreen.app
+```
+Then launch PaperScreen normally.
+
+> **Why this happens:** Apple requires a paid Developer ID ($99/year) to notarize apps for smooth Gatekeeper approval. As a free, open-source project, PaperScreen doesn't currently use one. You can always verify what you're running by checking the source in this repo or building it yourself with Xcode.

## Screenshots

<img width="1141" height="769" alt="Screenshot 2026-07-21 at 12 18 29 PM" src="https://github.com/user-attachments/assets/ee8db84d-2971-4198-991d-d6108d2ba2fe" />
<img width="1680" height="1050" alt="Screenshot 2026-07-21 at 3 15 48 PM" src="https://github.com/user-attachments/assets/5594388a-8a90-4a7c-8227-4ab49731483f" />


## How It Works
 
1. **Overlay window** — a borderless, transparent  is created per screen at the highest window level.
2. **Texture generation** — Core Image's random noise generator is blurred and level-adjusted to produce an organic grain.
3. **Compositing** — the noise layer is applied, which darkens highlights and reduces perceived contrast without shifting hue — the effect of a physical matte screen protector, in software.

## Contributing

Feel free to:

- Open an issue for bug reports, feature requests, improvements, or suggestions.
- Share ideas for new textures, customization options, or usability improvements.
- Submit a pull request with fixes or new features.

Every suggestion and contribution helps make PaperScreen better.


