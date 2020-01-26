#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Server Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");

if !(GVAR(TFARLoaded)) exitWith {};
GVAR(radioNamespace) = true call CFUNC(createNamespace);
publicVariable QGVAR(radioNamespace);
[QGVAR(spectatorRadioInformationChanged), {
    (_this select 0) params ["_unit", "_data", "_oldData"];
    private _notChanged = _data arrayIntersect _oldData;
    _notChanged append ["No_SW_Radio", "No_LR_Radio"];
    {
        private _units = GVAR(radioNamespace) getVariable [_x, []];
        private _index = _units find _unit;
        if (_index != -1) then {
            _units deleteAt _index;
            GVAR(radioNamespace) setVariable [_x, _units, true];
        };
        nil;
    } count (_oldData - _notChanged);

    {
        private _units = GVAR(radioNamespace) getVariable [_x, []];
        _units pushBackUnique _unit;
        GVAR(radioNamespace) setVariable [_x, _units, true];
        nil
    } count (_data - _notChanged);
}] call CFUNC(addEventhandler);
