# Strip Club Map Implementation

## Requirements
- ET Legacy game
- NetRadiant map editor
- Basic understanding of ET Legacy map scripting

## Implementation Steps

### 1. Set Up Development Environment
- Install ET Legacy game
- Download and install NetRadiant map editor
- Set up NetRadiant to work with ET Legacy

### 2. Create Map Geometry
- Use NetRadiant to create the map geometry based on the [design document](stripclub_design.md)
- Create the following areas:
  - Main Floor with stage, bar, and tables
  - VIP Lounge with private dance areas
  - Backstage area for Allied spawns
  - Office with safe (primary objective)
  - Rooftop exterior area
  - Parking Lot for Axis spawns

### 3. Add Entities
- Place entities according to the [entity placement guide](stripclub_entity_placement.md)
- Key entities include:
  - Team spawn points
  - Objective markers
  - Constructible objects
  - Trigger zones
  - Visual effect entities

### 4. Implement Scripts
- Use the provided [stripclub.script](../../etmain/maps/stripclub.script) file
- Use the provided [stripclub.objdata](../../etmain/maps/stripclub.objdata) file
- Ensure entity names in the map match those referenced in the script

### 5. Create or Acquire Assets
- Create or source textures and models as listed in the [assets list](stripclub_assets.md)
- Optimize all assets for performance
- Create custom shaders if needed

### 6. Compile the Map
- Use NetRadiant's built-in compiler (q3map2)
- Compile with the following stages:
  1. BSP stage - creates the basic geometry
  2. VIS stage - calculates visibility data
  3. LIGHT stage - adds lighting to the map
- Check for any compiler errors or warnings

### 7. Package the Map
- Create the directory structure as outlined in the [pk3 structure document](stripclub_pk3_structure.md)
- Place all files in their appropriate directories
- Create a ZIP archive containing all directories and files
- Rename the .zip extension to .pk3

## Testing

### Local Testing
1. Place the stripclub.pk3 file in your ET Legacy etmain folder
2. Launch ET Legacy
3. Create a local server with the map
4. Verify all objectives work as expected:
   - Safe can be constructed/destroyed
   - Main stage and VIP lounge can be captured
   - Side entrance can be constructed
   - Command posts function correctly
5. Test with bots to ensure gameplay flow
6. Check for any missing textures or models
7. Verify all script triggers work properly

### Multiplayer Testing
1. Host a server with the map
2. Invite players to join and test
3. Gather feedback on:
   - Balance between attackers and defenders
   - Objective difficulty and timing
   - Map flow and chokepoints
   - Performance and optimization

## Troubleshooting

### Common Issues
- **Missing textures**: Ensure all textures are properly packaged in the .pk3
- **Script errors**: Check that entity names match exactly with script references
- **Spawn issues**: Verify spawn point placement and team assignments
- **Objective not working**: Check trigger zones and script connections

### Debugging
- Use the console command `developer 1` to enable developer messages
- Check the console for any error messages
- Use `mapname_devmap` to load the map with cheats enabled for testing

## Resources
- [ET Legacy Wiki](https://github.com/etlegacy/etlegacy/wiki)
- [NetRadiant Documentation](http://icculus.org/gtkradiant/)
- [ET Mapping Community](https://www.splashdamage.com/forums/)
