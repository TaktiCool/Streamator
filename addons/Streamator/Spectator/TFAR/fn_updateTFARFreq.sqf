#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Update TFAR Frequencys

    Parameter(s):
    None

    Returns:
    None
*/
TFAR_Core_VehicleConfigCacheNamespace setVariable ["TFAR_fnc_radiosList_lastCache", 0];

private _freqSW = [];
private _freqLR = [];

{
    private _adChannel = _x call TFAR_fnc_getAdditionalSwChannel;
    private _rc = _x call TFAR_fnc_getSwRadioCode;
    _freqSW pushBackUnique [format ["%1%2", _x call TFAR_fnc_getSwFrequency, _rc], _x call TFAR_fnc_getSwStereo, _x];
    if (_adChannel > -1 && {_adChannel == (_x call TFAR_fnc_getSwChannel)}) then {
        _freqSW pushBackUnique [format ["%1%2", [_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency, _rc], _x call TFAR_fnc_getAdditionalSwStereo, _x];
    };
    nil;
} count (CLib_Player call TFAR_fnc_radiosList);

{
    private _adChannel = _x call TFAR_fnc_getAdditionalLrChannel;
    private _rc = _x call TFAR_fnc_getLrRadioCode;
    _freqLR pushBackUnique [format ["%1%2", _x call TFAR_fnc_getLrFrequency, _rc], _x call TFAR_fnc_getLrStereo, _x];
    if (_adChannel > -1 && {_adChannel != (_x call TFAR_fnc_getLrChannel)}) then {
        _freqLR pushBackUnique [format ["%1%2", [_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency, _rc], _x call TFAR_fnc_getAdditionalLrStereo, typeOf (_x select 0)];
    };
    nil;
} count (CLib_Player call TFAR_fnc_lrRadiosList);

if (_freqSW isEqualTo []) then {
    _freqSW pushBackUnique "No_SW_Radio";
};
if (_freqLR isEqualTo []) then {
    _freqLR pushBackUnique "No_LR_Radio";
};
private _data = [_freqSW, _freqLR];
private _oldData = CLib_Player getVariable [QGVAR(RadioInformation), []];
if (_oldData isNotEqualTo _data) then {
    CLib_Player setVariable [QGVAR(RadioInformation), _data, true];
};
