#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
private _freqSW = [];
private _freqLR = [];

{
    private _adChannel = _x call TFAR_fnc_getAdditionalSwChannel;
    private _rc = _x call TFAR_fnc_getSwRadioCode;
    _freqSW pushBackUnique format ["%1%2", _x call TFAR_fnc_getSwFrequency, _rc];
    if (_adChannel > -1 && {_adChannel == (_x call TFAR_fnc_getSwChannel)}) then {
        _freqSW pushBackUnique format ["%1%2", [_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency, _rc];
    };
    nil;
} count (CLib_player call TFAR_fnc_radiosList);

{
    private _adChannel = _x call TFAR_fnc_getAdditionalLrChannel;
    private _rc = _x call TFAR_fnc_getLrRadioCode;
    _freqLR pushBackUnique format ["%1%2", _x call TFAR_fnc_getLrFrequency, _rc];
    if (_adChannel > -1 && {_adChannel != (_x call TFAR_fnc_getLrChannel)}) then {
        _freqLR pushBackUnique format ["%1%2", [_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency, _rc];
    };
    nil;
} count (CLib_player call TFAR_fnc_lrRadiosList);

if (_freqSW isEqualTo []) then {
    _freqSW pushBackUnique "No_SW_Radio";
};
if (_freqLR isEqualTo []) then {
    _freqLR pushBackUnique "No_LR_Radio";
};
CLib_player setVariable [QGVAR(RadioInformation), [_freqSW, _freqLR], true];
