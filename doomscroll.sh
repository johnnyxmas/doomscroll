#!/bin/bash

# Configuration
FPS=10
WIDTH=80
HEIGHT=25
DOOM_CONFIG="$HOME/.chocolate-doom/chocolate-doom.cfg"
TMP_DIR="/tmp/doomscroll"

# Check dependencies
check_deps() {
    local missing=()
    for dep in autoconf automake make chafa ffmpeg; do
        if ! command -v $dep &> /dev/null; then
            missing+=("$dep")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        echo "Install with: brew install ${missing[*]}"
        exit 1
    fi
}

# Build Chocolate Doom from submodule
build_doom() {
    if [ ! -d "doom" ]; then
        echo "Error: doom submodule not found"
        exit 1
    fi

    cd doom || exit 1
    if [ ! -f "configure" ]; then
        ./autogen.sh
    fi
    ./configure
    make
    cd ..
}

# Setup temporary directory
setup_tempdir() {
    mkdir -p "$TMP_DIR/frames"
    trap 'rm -rf "$TMP_DIR"' EXIT
}

# Configure Chocolate Doom for headless capture
configure_doom() {
    mkdir -p "$(dirname "$DOOM_CONFIG")"
    cat > "$DOOM_CONFIG" <<-EOL
        [video]
        fullscreen = false
        width = 320
        height = 200
        display = 0
        grabmouse = true
        [sound]
        samplerate = 0
        [default]
        skill = 3
EOL
}

# Main function
main() {
    check_deps
    build_doom
    setup_tempdir
    configure_doom

    echo "Starting DoomScroll - Press Ctrl+C to stop"
    echo "Use terminal scrollback to view gameplay"

    # Run Doom and capture frames
    ./doom/src/chocolate-doom -iwad "$TMP_DIR/doom.wad" -record "$TMP_DIR/demo.lmp" &
    DOOM_PID=$!

    # Wait for demo to finish or be interrupted
    wait $DOOM_PID

    # Convert demo to video
    ffmpeg -i "$TMP_DIR/demo.lmp" -vf fps=$FPS "$TMP_DIR/frames/frame%04d.png"

    # Convert frames to ANSI and output
    for frame in "$TMP_DIR/frames"/*.png; do
        clear
        chafa -c 256 --symbols all -w $WIDTH -h $HEIGHT "$frame"
        sleep 0.1
    done
}

main "$@"