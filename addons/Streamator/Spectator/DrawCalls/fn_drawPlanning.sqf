#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Planning Mode Markers on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map", "_textSize"];
private _serverTime = [time, serverTime] select isMultiplayer;
_serverTime call FUNC(updatePlanningMarkers);

{
    private _unit = _x;
    private _cursorPos = _unit getVariable QGVAR(cursorPosition);
    private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
    {
        _x params ["_time", "_pos"];
        private _alpha = 1 - (_serverTime - _time) max 0;
        private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
        if (_cursorPos isEqualTo _x) then {
            private _text = format ["%1", (_unit call CFUNC(name))];
            _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, 18, 18, 0, _text, 2, _textSize, TEXT_FONT];
            _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 2]
        } else {
            _color set [3, _alpha];
            _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 0];
        };
    } forEach _cursorHistory;
} forEach ((GVAR(allSpectators) + [CLib_Player]) select {
    (GVAR(PlanningModeChannel) == 0)
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
});
