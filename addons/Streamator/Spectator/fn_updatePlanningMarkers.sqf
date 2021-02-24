#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Update Planning Markers

    Parameter(s):
    None

    Returns:
    None
*/
params ["_serverTime"];

if (GVAR(PlanningModeDrawing) && { GVAR(InputMode) == INPUTMODE_PLANINGMODE }) then {
    (CLib_Player getVariable [QGVAR(cursorPosition), []]) params ["_lastUpdate"];
    if (_serverTime - _lastUpdate >= 0.2) then {
        if (GVAR(MapOpen)) then {
            [CLib_Player, QGVAR(cursorPosition), [_serverTime, (CLib_Player getVariable [QGVAR(cursorPosition), [0, [0, 0, 0]]]) select 1], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
        } else {
            private _endPosition = screenToWorld getMousePosition;
            private _intersectArray = lineIntersectsSurfaces [AGLToASL _cameraPosition, AGLToASL _endPosition, objNull, objNull, true, 1, "GEOM", "NONE", false];
            if (_intersectArray isNotEqualTo []) then {
                (_intersectArray select 0) params ["_intersectPosition"];
                _endPosition = ASLtoAGL _intersectPosition;
            };
            [CLib_Player, QGVAR(cursorPosition), [_serverTime, _endPosition], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
        };
    };
};

{
    private _deleted = false;
    private _cursorPos = _x getVariable QGVAR(cursorPosition);
    private _cursorHistory = _x getVariable [QGVAR(cursorPositionHistory), []];
    if !(isNil "_cursorPos") then {
        _cursorPos params ["_newtime", "_newpos"];
        if (_cursorHistory isEqualTo []) then {
            _cursorHistory pushBackUnique _cursorPos;
        } else {
            private _lastPosition = _cursorHistory select ((count _cursorHistory) - 1);
            if (_lastPosition isNotEqualTo _cursorPos) then {
                _lastPosition params ["_lasttime", "_lastpos"];
                if ((_newtime - _lasttime) < 0.2) then {
                    _lastpos = AGLtoASL _lastpos;
                    _newpos = AGLtoASL _newpos;
                    private _diffpos = _newpos vectorDiff _lastpos;
                    private _dist = vectorMagnitude _diffpos;
                    _diffpos = vectorNormalized _diffPos;
                    private _nSteps = (round (_dist/5) min 20) max 2;
                    private _tSteps = (_newtime - _lasttime)/_nSteps;
                    private _sSteps = _dist/_nSteps;
                    for "_cnt" from 1 to _nSteps do {
                        _cursorHistory pushBackUnique [_lasttime + _tSteps*_cnt, ASLtoAGL (_lastpos vectorAdd (_diffPos vectorMultiply (_cnt*_sSteps)))];
                    };
                };
                _cursorHistory pushBackUnique _cursorPos;
            };
        };
    };
    {
        _x params ["_time", "_pos"];

        private _alpha = 1 - (_serverTime - _time) max 0;
        if (_alpha == 0) then {
            _deleted = true;
            _cursorHistory set [_forEachIndex, objNull];
        };
    } forEach _cursorHistory;
    if (_deleted) then {
        _cursorHistory = _cursorHistory - [objNull];
    };
    _x setVariable [QGVAR(cursorPositionHistory), _cursorHistory];
} forEach ((GVAR(allSpectators) + [CLib_Player]) select {
    (GVAR(PlanningModeChannel) == 0)
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
});
