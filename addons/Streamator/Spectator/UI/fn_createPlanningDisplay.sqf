#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Create Planning Mode Display

    Parameter(s):
    None

    Returns:
    None
*/
if (GVAR(InputMode) == INPUTMODE_PLANINGMODE) then {
    if (isNull (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull])) then {
        private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
        uiNamespace setVariable [QGVAR(PlanningModeDisplay), _display];
        _display displayAddEventHandler ["MouseMoving", {_this call FUNC(mouseMovingEH)}];
        _display displayAddEventHandler ["KeyDown", {_this call FUNC(keyDownEH)}];
        _display displayAddEventHandler ["KeyUp", {_this call FUNC(keyUpEH)}];
        _display displayAddEventHandler ["MouseZChanged", {_this call FUNC(mouseWheelEH)}];
        _display displayAddEventHandler ["MouseButtonDown", {
            params ["", ["_button", -1, [0]], "", "", "", "_ctrl"];
            if (_button == 0 && _ctrl) exitWith {
                GVAR(MeasureDistance) = true;
                GVAR(PlanningModeDrawing) = false;
                private _endPosition = call FUNC(getMousePositionInWorld);
                GVAR(MeasureDistancePositions) = [_endPosition, _endPosition];
                true;
            };
            if (_button == 0) exitWith {
                GVAR(MeasureDistance) = false;
                GVAR(MeasureDistancePositions) = [];
                GVAR(PlanningModeDrawing) = true;
                true;
            };
            true;
        }];
        _display displayAddEventHandler ["MouseButtonUp", {
            params ["", ["_button", -1, [0]], "", "", "", "_ctrl"];
            if (_button == 0 && _ctrl) exitWith {
                GVAR(MeasureDistance) = false;
                GVAR(MeasureDistancePositions) = [];
                true;
            };
            if (_button == 0) exitWith {
                GVAR(PlanningModeDrawing) = false;
                GVAR(MeasureDistance) = false;
                GVAR(MeasureDistancePositions) = [];
                true;
            };
            true;
        }];
        _display displayAddEventHandler ["Unload", {
            GVAR(MeasureDistance) = false;
            GVAR(MeasureDistancePositions) = [];
            if (!GVAR(MapOpen)) then {
                GVAR(InputMode) = INPUTMODE_MOVE;
                [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                [{
                    (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
                }] call CFUNC(execNextFrame);
            };
        }];
    };
} else {
    (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
};
