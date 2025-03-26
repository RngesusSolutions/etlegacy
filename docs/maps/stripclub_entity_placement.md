# Strip Club Map Entity Placement Guide

This document outlines the placement of key entities for the strip club themed multiplayer map in ET Legacy.

## Map Layout Reference

Refer to the [Strip Club Map Design Document](stripclub_design.md) for the complete map layout details.

## Key Entity Types

### Spawn Points

#### Allied Spawn Points
- **Entity Type**: `team_CTF_bluespawn`
- **Primary Location**: Backstage area
  - Place 4-6 spawn points spread throughout the backstage area
  - Ensure they are not visible from any entrance points
  - Coordinates should be set within the protected backstage zone

#### Axis Spawn Points
- **Entity Type**: `team_CTF_redspawn`
- **Primary Location**: Parking lot
  - Place 4-6 spawn points spread throughout the parking lot area
  - Provide some cover objects near spawn points
  - Coordinates should be set with clear paths to entry points

#### Capturable Spawn Points
- **Main Stage**:
  - Place 3-4 `team_CTF_bluespawn` and `team_CTF_redspawn` entities
  - Only active when the respective team controls the area
  - Controlled by script triggers in `mainstage_flag`

- **VIP Lounge**:
  - Place 3-4 `team_CTF_bluespawn` and `team_CTF_redspawn` entities
  - Only active when the respective team controls the area
  - Controlled by script triggers in `viplounge_flag`

### Objective Entities

#### Primary Objective: Office Safe
- **Entity Type**: `func_constructible`
- **Location**: Office room
  - Place in the back of the office against a wall
  - Set `constructible_class` to 3 (highest priority)
  - Link to `office_safe` script entity
  - Add `target_explosion` entity for visual effects when destroyed

#### Secondary Objective: Main Stage
- **Entity Type**: `team_WOLF_objective`
- **Location**: Center of the main stage area
  - Place a capture flag in the middle of the stage
  - Link to `mainstage_flag` script entity
  - Add `trigger_multiple` around the stage area for capture zone

#### Secondary Objective: VIP Lounge
- **Entity Type**: `team_WOLF_objective`
- **Location**: Center of the VIP lounge
  - Place a capture flag in the middle of the VIP area
  - Link to `viplounge_flag` script entity
  - Add `trigger_multiple` around the VIP area for capture zone

#### Secondary Objective: Side Entrance
- **Entity Type**: `func_constructible`
- **Location**: Side wall of the club
  - Place on an exterior wall for Axis to breach
  - Set `constructible_class` to 2 (medium priority)
  - Link to `side_entrance` script entity
  - Add `func_door` entity that becomes visible when constructed

### Command Posts

#### Allied Command Post
- **Entity Type**: `team_WOLF_objective` with `func_constructible`
- **Location**: Near backstage area
  - Place in a defensible position
  - Set appropriate targets and keys for Allied construction

#### Axis Command Post
- **Entity Type**: `team_WOLF_objective` with `func_constructible`
- **Location**: Near parking lot entrance
  - Place in a position that becomes accessible after breaching
  - Set appropriate targets and keys for Axis construction

## Trigger Entities

### Capture Zone Triggers
- **Entity Type**: `trigger_multiple`
- **Locations**:
  - Main stage area - linked to `mainstage_flag` script entity
  - VIP lounge area - linked to `viplounge_flag` script entity
  - Set appropriate dimensions to cover the entire capture area
  - Set `target` to the corresponding flag entity

### Door Triggers
- **Entity Type**: `trigger_multiple`
- **Location**: Side entrance
  - Place near the constructible side entrance
  - Set `target` to the door entity
  - Activated when side entrance is constructed

## Visual Effect Entities

### Safe Explosion
- **Entity Type**: `target_explosion`
- **Location**: Office safe
  - Place at the safe location
  - Triggered when safe is cracked
  - Set appropriate visual parameters

### Safe Smoke
- **Entity Type**: `target_smoke`
- **Location**: Office safe
  - Place at the safe location
  - Triggered when safe is cracked
  - Set to continuous emission

## Entity Relationships

```
office_safe (script) -> func_constructible (entity) -> target_explosion (visual)
mainstage_flag (script) -> team_WOLF_objective (entity) -> trigger_multiple (capture zone)
viplounge_flag (script) -> team_WOLF_objective (entity) -> trigger_multiple (capture zone)
side_entrance (script) -> func_constructible (entity) -> func_door (entity)
```

## Implementation Notes

1. All entity names must match exactly with the script file references
2. Ensure proper team flags are set for team-specific entities
3. Test all trigger zones for proper activation
4. Verify spawn point visibility and protection
5. Ensure all constructible entities have appropriate models and states
