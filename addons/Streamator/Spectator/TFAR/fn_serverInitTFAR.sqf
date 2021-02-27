#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Server Init for TFAR Radio Coms Plugin

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "tfar_core");

if !(GVAR(TFARLoaded)) exitWith {};
LOG("TFAR Stable Detected");
GVAR(radioNamespace) = true call CFUNC(createNamespace);
publicVariable QGVAR(radioNamespace);
[QGVAR(spectatorRadioInformationChanged), {
    (_this select 0) params ["_unit", "_data", "_oldData"];

    _data = _data apply {[_x] call FUNC(getTFARFrequency)};
    _oldData = _oldData apply {[_x] call FUNC(getTFARFrequency)};

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
