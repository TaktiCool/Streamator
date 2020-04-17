#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Builds Map UI

    Parameter(s):
    None

    Returns:
    None
*/
private _mapDisplay = uiNamespace getVariable [QGVAR(MapDisplay), displayNull];
if (isNull _mapDisplay) then {
    GVAR(PlanningModeDrawing) = false;
    _mapDisplay = (findDisplay 46) createDisplay "RscDisplayEmpty";
    uiNamespace setVariable [QGVAR(MapDisplay), _mapDisplay];
    (_mapDisplay displayCtrl 1202) ctrlSetFade 1;
    (_mapDisplay displayCtrl 1202) ctrlCommit 0;

    private _map = _mapDisplay ctrlCreate ["RscMapControl", -1];
    _map ctrlSetPosition [safeZoneX + PX(BORDERWIDTH), safeZoneY + PY(BORDERWIDTH), safeZoneW - PX(2 * BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)];
    _map ctrlCommit 0;

    GVAR(MapOpen) = true;
    (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
    QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
    GVAR(MapState) params [["_zoom", 1], ["_position", getPos CLib_player]];

    _map ctrlMapAnimAdd [0, _zoom, _position];
    ctrlMapAnimCommit _map;

    [_map] call CFUNC(registerMapControl);
    _mapDisplay displayAddEventHandler ["KeyDown", {
        params ["_display", "_keyCode"];
        switch (_keyCode) do {
            case DIK_ESCAPE;
            case DIK_M: { // M
                _display closeDisplay 1;
                true;
            };
            case DIK_E: { // E
                if !(_alt) exitWith {false};
                with missionNamespace do {
                    if (GVAR(InputMode) == INPUTMODE_MOVE) then {
                        GVAR(InputMode) = INPUTMODE_PLANINGMODE;
                        [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                    } else {
                        GVAR(InputMode) = INPUTMODE_MOVE;
                        [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                    };
                };
                true;
            };
            case DIK_F6: { // F6
                with missionNamespace do {
                    GVAR(OverlayPlanningMode) = !GVAR(OverlayPlanningMode);
                };
                true
            };
            case DIK_F7: { // F7
                with missionNamespace do {
                    GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
                };
                true;
            };
            case DIK_PGDN: { // Page Down
                with missionNamespace do {
                    if (_ctrl) then {
                        GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) - 1) max 0;
                        CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                    } else {
                        GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) - 1) max 0;
                        CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                    };
                    QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
                };
                true;

            };
            case DIK_PGUP: { // Page Up
                with missionNamespace do {
                    if (_ctrl) then {
                        GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) + 1) min ((count GVAR(PlanningModeColorRGB) - 1));
                        CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                    } else {
                        GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) + 1) min 10;
                        CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                    };
                    QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
                };
                true;
            };
            default {
                true;
            };
        };
    }];

    _map ctrlAddEventHandler ["MouseButtonClick", {
        params ["_map", "", "_xpos", "_ypos", "", "", "_alt"];
        if (_alt) exitWith {
            with missionNamespace do {
                GVAR(CameraPreviousState) = [];
                private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
                _pos pushBack (((getPos GVAR(Camera)) select 2) + getTerrainHeightASL _pos);
                [objNull, 1] call FUNC(setCameraTarget);
                GVAR(CameraPos) = _pos;
            };
            true;
        };
        false;
    }];

    _map ctrlAddEventHandler ["MouseMoving", {
        params ["_map", "_xPos", "_yPos"];
        with missionNamespace do {
            if (GVAR(InputMode) == INPUTMODE_PLANINGMODE && GVAR(PlanningModeDrawing)) then {
                private _pos = _map ctrlMapScreenToWorld [_xPos, _yPos];
                _pos set [2, 0];
                [CLib_Player, QGVAR(cursorPosition), [[time, serverTime] select isMultiplayer, _pos], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
            };
        };
    }];

    _map ctrlAddEventHandler  ["MouseButtonDown", {
        params ["", ["_button", -1, [0]]];
        with missionNamespace do {
            if (_button == 0) then {
                GVAR(PlanningModeDrawing) = true;
            };
        };
    }];
    _map ctrlAddEventHandler  ["MouseButtonUp", {
        params ["", ["_button", -1, [0]]];
        with missionNamespace do {
            if (_button == 0) then {
                GVAR(PlanningModeDrawing) = false;
            };
        };
    }];
    _map ctrlAddEventHandler ["Draw", {
        params [
            ["_map", controlNull, [controlNull]]
        ];
        with missionNamespace do {
            if (!GVAR(OverlayPlanningMode)) exitWith {};
            {
                private _unit = _x;
                private _cursorPos = _unit getVariable QGVAR(cursorPosition);
                private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
                {
                    _x params ["_time", "_pos"];
                    private _alpha = 1 - (([time, serverTime] select isMultiplayer) - _time) max 0;
                    private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
                    _color set [3, _alpha];
                    private _text = "";
                    private _mapScale = ctrlMapScale _map;
                    private _textSize = PY(4);
                    if (_mapScale < 0.1) then {
                        _textSize = (_textSize * ((_mapScale / 0.1) max 0.5));
                    };
                    if (_alpha != 0) then {
                        if (_cursorPos isEqualTo _x) then {
                            _color set [3, 1];
                            _text = format ["%1", (_unit call CFUNC(name))];
                            _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, 18, 18, 0, _text, 2, _textSize,  "RobotoCondensedBold", "right"];
                            _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 2, _textSize,  "RobotoCondensedBold", "right"]
                        } else {
                            _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 0, _textSize,  "RobotoCondensedBold", "right"];
                        };
                    };
                } count _cursorHistory;
                nil
            } count ((GVAR(allSpectators) + [CLib_Player]) select {
                (GVAR(PlanningModeChannel) == 0)
                 || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
                 || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
            });


            // Render ACE3 Map Gestures
            // Credits: Dslyecxi, MikeMatrix
            // https://github.com/acemod/ACE3/blob/master/addons/map_gestures/functions/fnc_drawMapGestures.sqf
            if (GVAR(aceMapGesturesLoaded)) then {
                #define TEXT_FONT "RobotoCondensedBold"

                // Iterate over all nearby players and render their pointer if player is transmitting.
                {
                    // Only render if the unit is alive and transmitting
                    if (alive _x && {_x getVariable ["ace_map_gestures_Transmit", false]}) then {

                        private _pos = _x getVariable ["ace_map_gestures_pointPosition", [0,0,0]];

                        private _group = group _x;
                        private _grpName = groupID _group;

                        // If color settings for the group exist, then use those, otherwise fall back to the default colors
                        private _colorMap = ace_map_gestures_GroupColorCfgMappingNew getVariable _grpName;
                        private _color = if (isNil "_colorMap") then {
                            [ace_map_gestures_defaultLeadColor, ace_map_gestures_defaultColor] select (_x != leader _group);
                        } else {
                            _colorMap select (_x != leader _group);
                        };

                        // Render icon and player name
                        _map drawIcon ["\a3\ui_f\data\gui\cfg\Hints\icon_text\group_1_ca.paa", _color, _pos, 55, 55, 0, "", 1, 0.030, TEXT_FONT, "left"];
                        _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", ace_map_gestures_nameTextColor, _pos, 20, 20, 0, name _x, 0, 0.030, TEXT_FONT, "left"];
                    };
                    nil
                } count ([CLib_Player, ace_map_gestures_maxRange] call ace_map_gestures_fnc_getProximityPlayers);

            };
        };
    }];
    _map ctrlAddEventHandler ["Destroy", {
        params ["_map"];
        with missionNamespace do {
            [_map] call CFUNC(unregisterMapControl);
            private _pos = _map ctrlMapScreenToWorld [0.5, 0.5];
            private _zoom = ctrlMapScale _map;
            GVAR(MapState) = [_zoom, _pos];
            GVAR(MapOpen) = false;
            QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
            GVAR(PlanningModeDrawing) = false;
            [{
                call FUNC(createPlanningDisplay);
            }] call CFUNC(execNextFrame);
        };
    }];
} else {
    _mapDisplay closeDisplay 1;
};
true
