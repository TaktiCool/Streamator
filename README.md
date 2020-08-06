# STREAMATOR
A spectator mod for Arma 3.

# Users Manual
## CAMERA MODE
The camera mode is shown on the top right.

Mode | Description
---|---
**FREE** | Free movement of the camera.
**FOLLOW [&lt;Object&gt;]** | The camera is moving relatively to a focused object.<br>***Special Remarks:***<br>If the &lt;Object&gt; is a spectator, the current camera state (position, view angle etc.) of the focused spectator is transferred to your camera. To limit network traffic, this is done only at the moment of focusing. It can be refreshed by pressing the R key.
**FIRST PERSON [&lt;Object&gt;]** | First Person View Mode to see what the player sees
**SHOULDER [&lt;Object&gt;]** | Over the Shoulder View with Camera Offset and Direction offset
**TOPDOWN [&lt;Object&gt;]** | Topdown View Mode to Overview a Unit Movements
**ORBIT [&lt;Object&gt;]** | Topdown View Mode to Overview a Unit Movements
**UAV [&lt;Object&gt;]** | View of the Followed Units UAV if one is connected

## 3D VIEW
Key Binding | Short Description | Remarks
---|---|---
**`W` `S` `A` `D`** | Horiz. movement |
**`Q` `Y`** | Vert. movement |
**`F`** | (De-)focus object | Changes the camera mode to FOLLOW. The current camera target (shown on the bottom) will be the focused object. If no object is selected (camera target = Null Object), the camera mode will change to FREE.
**`CTRL`** + **`F`** | Find object | Opens a search field with completion. See more [Serach Mode](#search-mode)
**`ALT`** + **`F`** | last Shooting Unit | Changes the FOLLOW Target to the last Shooting Unit
**`R`** | Refocus object | Only in FOLLOW Mode! Refocus (center) the camera to the current focused object. If a spectator is selected, the current camera state (position, view angle etc.) is transferred to your camera. if in SHOULDER, TOPDOWN or ORBIT Mode it resets Camera to Default Values
**`SHIFT`** + **`Scrollwheel`** | Change Speed | Changes the Speed of the Camera.
**`CTRL`** + **`Scrollwheel`** | Change Smoothing | Changes the camera smoothing coefficient.
**`ALT`** + **`Scrollwheel`** | Change FOV | Changes the field of view (zoom).
**`TAB`** | Resets FOV | Resets the field of View
**`N`** | Vision mode | Switches Between Normal Vision Mode and Last used Vision Mode
**`F1-F12 + Escape`** | Menu Navigation | Keybindings used for Menu Navigation
**`CTRL`** + **`0`**...**`9`** | Save camera state | Saves the current camera state (position, view angle, mode, camera target etc.) to a slot (0...9)
**`0`**...**`9`** | Restore camera state | Restores camera state. See Save camera state
**`M`** | Open Map | Opens the map. (see Map View)
**`V`** | Toggle MiniMap | Toggles MiniMap
**`Shift + V`** | Toggles Center Minimap on Camera | Toggles Center Minimap on Camera or View Vector
**`CTRL`** + **`E`** | Toggle Planning Mode | Toggles Planing Mode and shows Cursor
**`PAGE UP`** | Increase Planning Mode Channel | Increase Planning Mode Channel
**`PAGE DOWN`** | Decrease Planning Mode Channel | Decrease Planning Mode Channel
**`CTRL`** + **`PAGE UP`** | Change Planning Mode Color | Change Planning Mode Color
**`CTRL`** + **`PAGE DOWN`** | Change Planning Mode Color | Change Planning Mode Color
**`LMB`** | Drawing in Planning Mode | Drawing in Planning Mode
**`NUMPAD 0`** | Free View | Toggles back to Free View
**`NUMPAD 1`** | Follow View | Toggles to Follow Mode
**`NUMPAD 2`** | Shoulder View | Toggles to Shoulder View
**`NUMPAD 3`** | Topdown View | Toggles to TopDown View
**`NUMPAD 4`** | First Person View | Toggles to First Person View
**`NUMPAD 5`** | Orbit View | Toggles to Orbit View
**`NUMPAD 6`** | UAV View | Toggles to A UAVs view if the current Vehicle is a UAV or the current Unit is connected to a UAV
**`Scrollwheel`** | Camera Height in TopDown View | Adjusts the Camera Height in TopDown Camera Mode
**`ALT`** | Smooth Transition Modifier | When Pressed While Changing Camera Targets a Smooth Transition is done

## MAP VIEW
Key Binding | Short Description | Remarks
---|---|---
**`M`** | Close map | Closes the map view.
**`ALT`** + **`LMB`** | Move camera | Moves the camera to the clicked position
**`LMB`** (Dbl. Click) on Marker | Focus Unit/Vehicle | Focuses a unit or vehicle.
Hover Marker | Shows unit/group/vehicle information | units: unit name<br>groups: ID and group members<br>Vehicles: type and units<br>
**`CTRL`** + **`E`** | Toggle Planning Mode | Toggles Planning Mode and shows Cursor
**`PAGE UP`** | Increase Planning Mode Channel | Increase Planning Mode Channel
**`PAGE DOWN`** | Decrease Planning Mode Channel | Decrease Planning Mode Channel
**`LMB`** | Drawing in Planning Mode | Drawing in Planning Mode

## Search Mode
Key Binding | Short Description | Remarks
---|---|---
**`ENTER`** | Switch to Search Entry | Switch to Search Entry
**`NUMPAD 0`** | Free View | Toggles back to Free View
**`NUMPAD 1`** | Follow View | Toggles to Follow Mode
**`NUMPAD 2`** | Shoulder View | Toggles to Shoulder View
**`NUMPAD 3`** | Topdown View | Toggles to Topdown View
**`NUMPAD 4`** | First Person View | Toggles to First Person View
**`NUMPAD 5`** | Orbit View | Toggles to Orbit View
**`NUMPAD 6`** | UAV View | Toggles to A UAVs view if the current Vehicle is a UAV or the current Unit is connected to a UAV
**`TAB`** | Cycle to Search Entry Right | Switches to the Next Searched Result
**`SHIFT`** + **`TAB`** | Cycle to Search Entry Left | Switches to the Next Searched Result

# MENU SYSTEM
**[F1]** <Overlays>
    **[Esc]** Back
    **[F1]** Group Markers
    **[F2]** Unit Markers
    **[F3]** Player Markers
    **[F4]** Planning Mode
    **[F5]** Bullet Tracers
    **[F6]** Laser Targets
    **[F7]** Custom Markers
**[F2]** <Camera Modes>
    **[Esc]** Back
    **[F1]** Free
    **[F2]** Follow
    **[F3]** Shoulder
    **[F4]** Topdown
    **[F5]** FPS
    **[F6]** Orbit
    **[F7]** UAV
**[F3]** <Vision Modes>
    **[Esc]** Back
    **[F1]** Normal
    **[F2]** NVG
    **[F3]** Thermal
    **[F4]** <Thermal Modes>
        **[Esc]** Back
        **[F1]** Thermal (W)
        **[F2]** Thermal (B)
        **[F3]** Thermal (G)
        **[F4]** Thermal (BG)
        **[F5]** Thermal (R)
        **[F6]** Thermal (BR)
        **[F7]** Thermal (WR)
        **[F8]** Thermal (RGW)
**[F4]** <Minimap>
    **[Esc]** Back
    **[F1]** Toggle
    **[F2]** Toggle View Mode
**[F5]** <Radio>
    **[Esc]** Back
    **[F1]** Toggle Radio Overlay
    **[F2]** Target current Camera target
**[F6]** Toggle AI
**[F7]** Unit Chyron
**[F8]** Fix Camera

# Creators Manual
TBD
