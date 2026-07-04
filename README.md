# Cat-Windots

A Catppuccin Mocha rice for Windows 11. Tiling window management, a custom status bar, blurred Explorer, a styled taskbar and start menu, and a local AI assistant — all applied with a single installer.

---

## Components

| Tool | Role |
|---|---|
| GlazeWM | Tiling window manager |
| YASB | Status bar |
| Starship | Shell prompt |
| Windows Terminal | Terminal emulator |
| Windhawk | Taskbar and start menu styler |
| ExplorerBlurMica | Blur and mica effect for File Explorer |
| Catppuccin Mocha | Full Windows visual theme |
| Neura AI | Local AI assistant via Ollama |
| JetBrainsMono Nerd Font | Font used across the setup |
| Zen Browser | Default browser |

---

## Requirements

- Windows 11
- Administrator rights
- Internet connection for the initial install
- 8 GB RAM minimum, 16 GB recommended if using Neura AI
- Python 3.10 or later (Neura AI only)

---

## Installation

Download or clone this repo, then place `Cat-Windots-Installer.bat` either next to the `Cat-Windots` folder or inside it. Right-click it and run as Administrator.

The installer handles:

- winget detection and setup
- GlazeWM, YASB, Starship, Windows Terminal, Windhawk, Zen Browser, Git
- JetBrainsMono Nerd Font
- Optional apps: Discord, Spotify, YouTube Music, VS Code
- All config files copied to their correct locations
- ExplorerBlurMica registration
- Catppuccin theme files copied to the Windows themes directory

Two steps require manual action after the installer finishes.

### 1. Windhawk mods

Open Windhawk and install these two mods:

- Windows 11 Taskbar Styler
- Windows 11 Start Menu Styler

For each one, go to the Settings tab, then Advanced, and paste the contents of the corresponding JSON file from `Dots-Apply/Windhawk/`.

### 2. Catppuccin Mocha theme

Windows does not allow third-party `.msstyles` files without a patch. Install [SecureUxTheme](https://github.com/namazso/SecureUxTheme) first, then go to Settings > Personalisation > Themes and select Catppuccin - Mocha.

Four variants are included:

| Variant | Description |
|---|---|
| Catppuccin - Mocha | Standard |
| Catppuccin - Mocha NA | No accent colour |
| Catppuccin - Mocha Night | Darker |
| Catppuccin - Mocha Night NA | Darker, no accent colour |

---

## Wallpapers

17 wallpapers are bundled under `Themes/Catppuccin/Wallpapers/`, one per Mocha accent colour. The YASB wallpaper widget lets you cycle through them directly from the bar.

Blue, Dark, Flamingo, Green, Grey, Lavender, Light, Maroon, Mauve, Peach, Pink, Red, Rosewater, Sapphire, Sky, Teal, Yellow.

---

## GlazeWM keybindings

| Key | Action |
|---|---|
| Alt + H / L / K / J | Focus left / right / up / down |
| Alt + Shift + H / L / K / J | Move window left / right / up / down |
| Alt + 1-9 | Switch to workspace |
| Alt + Shift + 1-9 | Move window to workspace |
| Alt + Q | Close focused window |
| Alt + F | Toggle fullscreen |
| Alt + M | Toggle minimised |
| Alt + Space | Toggle floating |
| Alt + T | Set to tiling |
| Alt + Shift + V | Toggle tiling direction |
| Alt + Shift + Space | Cycle tiling / floating / fullscreen |
| Alt + W | Focus previous workspace |
| Alt + , / . | Resize width |
| Alt + Up / Down | Resize height |
| Alt + R | Resize mode |
| Alt + Shift + E | Exit GlazeWM |
| Alt + Shift + P | Pause all keybindings |

---

## YASB bar widgets

Active window, workspaces, clock, weather, media controls, volume, Wi-Fi, Bluetooth, battery, memory, disk, CPU/GPU via LibreHardwareMonitor, Cava visualiser, notifications, system tray, VS Code, wallpaper switcher, launchpad, power menu.

---

## Neura AI

A local AI assistant that runs entirely on your machine using Ollama. No cloud, no accounts.

```
neura
```

| Command | Action |
|---|---|
| /help | Show all commands |
| /models | Browse available models |
| /model neura | Switch to the Neura model |
| /import file.pdf | Load a PDF into the chat |
| /export | Save the chat as a PDF |
| /persona coder | Use a preset personality |
| /quit | Exit |

To change the AI personality edit `Neura.Modelfile` and re-run `install.bat`.

---

## File structure

```
Cat-Windots/
  Dots-Apply/
    Explorer/         ExplorerBlurMica DLL and config.ini
    Glazewm/          config.yaml
    neura ai/         Installer and source files
    Starship/         starship.toml
    Terminal/         settings.json
    Windhawk/
      Taskbar/        taskbar.json
      Start menu/     startmenu.json
    YASB/             config.yaml and styles.css
  Themes/
    Catppuccin/       .msstyles files, icons, wallpapers
    *.theme           Theme descriptor files
Cat-Windots-Installer.bat
README.md
```

---

## Credits

- [Catppuccin](https://github.com/catppuccin/catppuccin) — colour palette
- [GlazeWM](https://github.com/glzr-io/glazewm) — tiling window manager
- [YASB](https://github.com/amnweb/yasb) — status bar
- [Starship](https://starship.rs) — shell prompt
- [Windhawk](https://windhawk.net) — UI mod engine
- [ExplorerBlurMica](https://github.com/Maplespe/ExplorerBlurMica) — Explorer blur
- [SecureUxTheme](https://github.com/namazso/SecureUxTheme) — theme patcher
- [Ollama](https://ollama.com) — local LLM runtime
- [Neura AI](https://github.com/PiyushManwani/neura-ai) — by Piyush Manwani
