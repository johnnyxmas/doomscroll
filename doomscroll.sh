#!/bin/bash

# Chocolate Doom launcher script with improved WAD detection
WAD_DIR="./wad"
IWAD=""

echo "Debug: Checking WAD directory at $(realpath "$WAD_DIR" 2>/dev/null || echo "$WAD_DIR")"

# Check if WAD directory exists and is accessible
if [ -d "$WAD_DIR" ]; then
    echo "Debug: WAD directory exists"
    if [ -r "$WAD_DIR" ]; then
        echo "Debug: WAD directory is readable"
        
        # Find all WAD files (case insensitive, including hidden)
        shopt -s nullglob dotglob nocaseglob
        WADS=("$WAD_DIR"/*.[Ww][Aa][Dd])
        shopt -u nullglob dotglob nocaseglob
        
        echo "Debug: Found ${#WADS[@]} WAD files:"
        for wad in "${WADS[@]}"; do
            echo " - $wad"
        done
        
        if [ ${#WADS[@]} -gt 0 ]; then
            echo "Available WAD files:"
            for i in "${!WADS[@]}"; do
                echo "$((i+1)). ${WADS[$i]##*/}"
            done
            
            read -rp "Enter number of WAD to use (or press Enter to specify path): " selection
            if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#WADS[@]} ]; then
                IWAD="${WADS[$((selection-1))]}"
            fi
        else
            echo "No WAD files found in $WAD_DIR directory"
        fi
    else
        echo "Error: Cannot read WAD directory $WAD_DIR (permission denied)"
    fi
else
    echo "WAD directory $WAD_DIR does not exist"
fi

# If no WAD selected from directory, prompt for path
if [ -z "$IWAD" ]; then
    echo "Please provide path to your DOOM.WAD or other IWAD file:"
    read -r IWAD
fi

# Convert to absolute path and validate
IWAD=$(realpath "$IWAD" 2>/dev/null || echo "$IWAD")
if [ ! -f "$IWAD" ]; then
    echo "Error: WAD file not found at $IWAD"
    echo "Note: You need the original DOOM.WAD or other IWAD file to play"
    exit 1
fi

# Run Chocolate Doom with the specified WAD
cd doom || exit 1
exec ./src/chocolate-doom -iwad "$IWAD"