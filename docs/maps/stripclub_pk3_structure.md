# Strip Club Map .pk3 Structure

This document outlines the directory structure for packaging the strip club themed multiplayer map as a .pk3 file for ET Legacy.

## Overview

The .pk3 format is essentially a ZIP file with a specific directory structure. This format is used by ET Legacy (and other id Tech 3 based games) to package maps, textures, models, and other game assets.

## Directory Structure

```
stripclub.pk3/
├── maps/
│   ├── stripclub.bsp       # Compiled map file
│   ├── stripclub.script    # Game script defining objectives and gameplay
│   └── stripclub.objdata   # Objectives data with descriptions
├── scripts/
│   └── stripclub.shader    # Custom shader definitions
├── textures/
│   └── stripclub/          # Custom textures for the map
│       ├── walls/          # Wall textures
│       │   ├── club_wall.jpg
│       │   ├── vip_wall.jpg
│       │   └── office_wall.jpg
│       ├── floors/         # Floor textures
│       │   ├── stage_floor.jpg
│       │   ├── vip_floor.jpg
│       │   └── bar_floor.jpg
│       └── signs/          # Neon signs and other signage
│           ├── main_sign.jpg
│           ├── vip_sign.jpg
│           └── private_sign.jpg
├── models/
│   └── mapobjects/         # Custom models for the map
│       └── stripclub/      # Map-specific models
│           ├── pole.md3    # Dancer pole model
│           ├── bar.md3     # Bar counter model
│           ├── safe.md3    # Office safe model
│           └── booth.md3   # VIP booth model
└── sound/
    └── stripclub/          # Custom sounds for the map
        ├── music.wav       # Background music
        ├── announcer/      # Announcer voice lines
        │   ├── stage_captured.wav
        │   └── safe_cracked.wav
        └── ambient/        # Ambient sounds
            ├── club_music.wav
            └── crowd_noise.wav
```

## File Descriptions

### Core Map Files

- **stripclub.bsp**: The compiled map file containing geometry, lighting, and entity placement
- **stripclub.script**: Script file defining objectives, spawn points, and gameplay mechanics
- **stripclub.objdata**: Objective descriptions for both teams

### Asset Files

- **Shader Files**: Define special rendering effects for surfaces
- **Texture Files**: Image files for all surfaces in the map
- **Model Files**: 3D models for objects in the map
- **Sound Files**: Audio files for music, announcements, and ambient sounds

## Packaging Instructions

1. Create the directory structure as outlined above
2. Place all files in their appropriate directories
3. Compile the map using NetRadiant/GtkRadiant to generate the .bsp file
4. Create a ZIP archive containing all directories and files
5. Rename the .zip extension to .pk3

## Installation

To install the map:

1. Place the stripclub.pk3 file in the ET Legacy etmain folder
2. Launch ET Legacy
3. The map will be available in the server browser or for local play

## Testing

After packaging:

1. Test the map locally to ensure all assets load correctly
2. Verify that all objectives function as intended
3. Check for any missing textures or models
4. Ensure all script triggers work properly

## Notes

- The .pk3 file must maintain this exact directory structure for ET Legacy to properly load the assets
- All file paths within the .pk3 are case-sensitive
- The total size of the .pk3 should be kept reasonable for download purposes
- Consider creating a lightweight version with reduced texture sizes for faster downloads
