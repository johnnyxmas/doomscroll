# DoomScroll

Play Doom in your terminal's scrollback buffer by converting gameplay frames to ANSI art.

## How It Works

1. Runs Chocolate Doom in the background
2. Captures frames from the framebuffer
3. Converts frames to ANSI art using chafa
4. Outputs frames to terminal scrollback

## Requirements

- Chocolate Doom (`brew install chocolate-doom`)
- chafa (`brew install chafa`)
- ffmpeg (`brew install ffmpeg`)

## Installation

```bash
git clone https://github.com/yourusername/doomscroll.git
cd doomscroll
chmod +x doomscroll.sh
```

## Usage

```bash
./doomscroll.sh
```

Use your terminal's scrollback to navigate through the gameplay.

## Configuration

Edit `doomscroll.conf` to adjust:
- Frame rate
- Resolution
- ANSI art style