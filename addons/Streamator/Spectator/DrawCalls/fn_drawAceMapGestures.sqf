#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Ace Map Gestures on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map", "_textSize"];
// Iterate over all nearby players and render their pointer if player is transmitting.
{
    private _pos = _x getVariable "ace_map_gestures_pointPosition";
    if (!isNil "_pos" && {_pos isNotEqualTo []}) then {
        private _grpName = groupID (group _x);

        // If color settings for the group exist, then use those, otherwise fall back to the default colors
        private _color = (GVAR(ace_map_gestures_color_namespace) getVariable [_grpName, [GVAR(ace_map_gestures_defaultLeadColor), GVAR(ace_map_gestures_defaultLeadColor)]]) select (_x != leader _x);

        // Render icon and player name
        _map drawIcon ["a3\ui_f\data\gui\cfg\Hints\icon_text\group_1_ca.paa", _color, _pos, 55, 55, 0, "", 1];
        _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", GVAR(ace_map_gestures_nameTextColor), _pos, 20, 20, 0, name _x, 0, _textSize, TEXT_FONT, "left"];
    };
} forEach call FUNC(getNearByTransmitingPlayers);
