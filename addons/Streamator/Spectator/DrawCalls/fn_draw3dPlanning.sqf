#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Planning Mode Markers in 3d

    Parameter(s):
    None

    Returns:
    None
*/
params ["_cameraPosition", "_fov"];
private _serverTime = [time, serverTime] select isMultiplayer;
_serverTime call FUNC(updatePlanningMarkers);

private _sqrtFOV = sqrt(_fov);

{
    private _unit = _x;
    private _cursorPos = _unit getVariable QGVAR(cursorPosition);
    private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
    {
        _x params ["_time", "_pos"];
        private _size = (0.8 min (1 / (((_cameraPosition distance _pos) / 100)^0.7)) max 0.15) * _sqrtFOV;
        private _alpha = 1 - (_serverTime - _time) max 0;
        private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
        if (_cursorPos isEqualTo _x) then {
            private _text = format ["%1", (_unit call CFUNC(name))];
            drawIcon3D ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, _size, _size, 0, _text, 2, PY(2), TEXT_FONT, "center"];
            drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, _size, _size, 0, "", 2, PY(2), TEXT_FONT, "center"];
        } else {
            _color set [3, _alpha];
            drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, _size, _size, 0, "", 0, PY(2), TEXT_FONT, "center"];
        };
    } forEach _cursorHistory;
} forEach ((GVAR(allSpectators) + [CLib_Player]) select {
    (GVAR(PlanningModeChannel) == 0)
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
    || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
});
