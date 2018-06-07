#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
if (GVAR(TFARRadioPFHId) == -1) then {
    if !(alive GVAR(CameraFollowTarget)) exitWith {};
    GVAR(TFARRadioPFHId) = [{
        if !(alive GVAR(CameraFollowTarget)) exitWith {
            GVAR(TFARRadioPFHId) call CFUNC(removePerFrameHandler);
            GVAR(TFARRadioPFHId) = -1;
            tf_lastFrequencyInfoTick = diag_tickTime - 1;
        };
        private _freqSW = [];
        private _freqLR = [];

        {
            if ((_x call TFAR_fnc_getAdditionalSwChannel) == (_x call TFAR_fnc_getSwChannel)) then {
                _freqSW pushBackUnique format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, 0];
            } else {
                _freqSW pushBackUnique format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, 0];
                if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
                    _freqSW pushBackUnique format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, 0];
                };
            };
            nil;
        } count (GVAR(CameraFollowTarget) call TFAR_fnc_radiosList);

        {
            if ((_x call TFAR_fnc_getAdditionalLrChannel) == (_x call TFAR_fnc_getLrChannel)) then {
                _freqLR pushBackUnique format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, 0];
            } else {
                _freqLR pushBackUnique format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, 0];
                if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                    _freqLR pushBackUnique format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, 0];
                };
            };
            nil;
        } count (GVAR(CameraFollowTarget) call TFAR_fnc_lrRadiosList);

        if (_freqSW isEqualTo []) then {
            _freqSW pushBackUnique "No_SW_Radio";
        };
        if (_freqLR isEqualTo []) then {
            _freqLR pushBackUnique "No_LR_Radio";
        };
        TFAR_player_name = name CLib_player;
        private _request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13", str(_freqSW), str(_freqLR), "No_DD_Radio", false, 0, TF_dd_volume_level, TFAR_player_name, waves, 0, 1.0, 0, 1.0, TF_speakerDistance];
        private _result = "task_force_radio_pipe" callExtension _request;
        DUMP("Listen To Radio: " + _result + " " + _request);
        tf_lastFrequencyInfoTick = diag_tickTime + 10;
    }, 0.5] call CFUNC(addPerFrameHandler);
    tf_lastFrequencyInfoTick = diag_tickTime + 10;
} else {
    GVAR(TFARRadioPFHId) call CFUNC(removePerFrameHandler);
    GVAR(TFARRadioPFHId) = -1;
    tf_lastFrequencyInfoTick = diag_tickTime - 1;
};
