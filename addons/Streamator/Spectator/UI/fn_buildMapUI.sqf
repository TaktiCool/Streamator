#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Build UI elements for Map

    Parameter(s):
    None

    Returns:
    None
*/
call FUNC(updateValidUnits);
private _mapDisplay = uiNamespace getVariable [QGVAR(MapDisplay), displayNull];
if (!isNull _mapDisplay) exitWith {
    _mapDisplay closeDisplay 1;
};
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
QGVAR(updateMenu) call CFUNC(localEvent); // hijack To Update Text on Map Open
GVAR(MapState) params [["_zoom", 1], ["_position", getPos CLib_Player]];

QEGVAR(UnitTracker,updateIcons) call CFUNC(localEvent);

_map ctrlMapAnimAdd [0, _zoom, _position];
ctrlMapAnimCommit _map;

[_map] call CFUNC(registerMapControl);

_mapDisplay displayAddEventHandler ["KeyDown", {
    params [
        "_display",
        ["_keyCode", 0, [0]],
        ["_shift", false, [true]],
        ["_ctrl", false, [true]],
        ["_alt", false, [true]]
    ];

    if !([GVAR(currentMenuPath), _keyCode] call FUNC(executeEntry)) then {
        switch (_keyCode) do {
            case DIK_ESCAPE;
            case DIK_M: { // M
                _display closeDisplay 1;
            };
            case DIK_E: { // E
                if !(_ctrl) exitWith {false};
                if (GVAR(InputMode) == INPUTMODE_MOVE) then {
                    GVAR(InputMode) = INPUTMODE_PLANINGMODE;
                    [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                } else {
                    GVAR(InputMode) = INPUTMODE_MOVE;
                    [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                };
            };
            case DIK_PGDN: { // Page Down
                if (_ctrl) then {
                    GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) - 1) max 0;
                    CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                } else {
                    GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) - 1) max 0;
                    CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                };
                QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
            };
            case DIK_PGUP: { // Page Up
                if (_ctrl) then {
                    GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) + 1) min ((count GVAR(PlanningModeColorRGB) - 1));
                    CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                } else {
                    GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) + 1) min 10;
                    CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                };
                QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
            };
        };
    };
    true;
}];

_map ctrlAddEventHandler ["MouseMoving", {
    params ["_map", "_xPos", "_yPos"];
    if (GVAR(MeasureDistance)) exitWith {
        GVAR(MeasureDistancePositions) set [1, _map ctrlMapScreenToWorld [_xpos, _ypos]];
    };
    if (GVAR(InputMode) == INPUTMODE_PLANINGMODE && GVAR(PlanningModeDrawing)) exitWith {
        private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
        _pos set [2, 0];
        [CLib_Player, QGVAR(cursorPosition), [[time, serverTime] select isMultiplayer, _pos], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
    };

}];

_map ctrlAddEventHandler  ["MouseButtonDown", {
    params ["_map", ["_button", -1, [0]], "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    if (_button == 0 && _ctrl) exitWith {
        GVAR(MeasureDistance) = true;
        private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
        GVAR(MeasureDistancePositions) = [_pos, _pos];
        true;
    };
    if (_button == 0 && GVAR(InputMode) == INPUTMODE_PLANINGMODE) exitWith {
        GVAR(PlanningModeDrawing) = true;
        private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
        _pos set [2, 0];
        [CLib_Player, QGVAR(cursorPosition), [[time, serverTime] select isMultiplayer, _pos], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
        true;
    };
    true;
}];
_map ctrlAddEventHandler  ["MouseButtonUp", {
    params ["_map", ["_button", -1, [0]], "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    if (_button == 0 && GVAR(MeasureDistance)) exitWith {
        GVAR(MeasureDistance) = false;
        GVAR(MeasureDistancePositions) = [];
        true;
    };
    if (_button == 0 && GVAR(InputMode) == INPUTMODE_PLANINGMODE) exitWith {
        GVAR(PlanningModeDrawing) = false;
        true;
    };
    if (_alt) exitWith {
        GVAR(CameraPreviousState) = [];
        private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
        _pos pushBack (50 + getTerrainHeightASL _pos);
        [objNull, CAMERAMODE_FREE] call FUNC(setCameraTarget);
        GVAR(CameraPos) = _pos;
        true;
    };
    true;
}];
_map ctrlAddEventHandler ["Draw", { _this call FUNC(drawEH); }];

_map ctrlAddEventHandler ["Destroy", {
    params ["_map"];
    [_map] call CFUNC(unregisterMapControl);
    private _pos = _map ctrlMapScreenToWorld [0.5, 0.5];
    private _zoom = ctrlMapScale _map;
    GVAR(MapState) = [_zoom, _pos];
    GVAR(MapOpen) = false;
    QGVAR(updateMenu) call CFUNC(localEvent); // hijack To Update Text on Map Open
    GVAR(PlanningModeDrawing) = false;
    [{
        call FUNC(createPlanningDisplay);
    }] call CFUNC(execNextFrame);
}];
