#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for TFAR Radio Plugin

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");

if (!GVAR(TFARLoaded)) exitWith {};

[QGVAR(spectatorOpened), {
    0 call TFAR_fnc_setVoiceVolume;
    CLib_Player setVariable ["tf_unable_to_use_radio", true];
    CLib_Player setVariable ["tf_forcedCurator", true];

    [{
        if !(alive GVAR(RadioFollowTarget)) exitWith {
            if !(GVAR(RadioInformationPrev) isEqualTo []) then {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, [], (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1)]] call CFUNC(serverEvent);
                [QGVAR(radioInformationChanged), []] call CFUNC(localEvent);
                GVAR(RadioInformationPrev) = [];
            };
        };
        private _data = GVAR(RadioFollowTarget) getVariable [QGVAR(RadioInformation), [["No_SW_Radio"], ["No_LR_Radio"]]];
        if !(_data isEqualTo GVAR(RadioInformationPrev)) then {
            if (GVAR(RadioInformationPrev) isEqualTo []) then {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, (_data select 0) + (_data select 1), []]] call CFUNC(serverEvent);
            } else {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, (_data select 0) + (_data select 1), (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1)]] call CFUNC(serverEvent);
            };
            [QGVAR(radioInformationChanged), _data] call CFUNC(localEvent);
            GVAR(RadioInformationPrev) = +_data;
        };
        _data params ["_freqSW", "_freqLR"];
        if !("No_SW_Radio" in _freqSW) then {
            _freqSW = _freqSW apply {_x + "|7|0"};
        };
        if !("No_LR_Radio" in _freqLR) then {
            _freqLR = _freqLR apply {_x + "|7|0"};
        };
        TFAR_player_name = name CLib_player;
        private _request = format ["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13", str(_freqSW), str(_freqLR), "No_DD_Radio", true, TF_speak_volume_meters min TF_max_voice_volume, TF_dd_volume_level, TFAR_player_name, waves, 0, 1.0, CLib_player getVariable ["tf_voiceVolume", 1.0], 1.0, TF_speakerDistance];
        private _result = "task_force_radio_pipe" callExtension _request;
        DUMP("Listen To Radio: " + _result + " " + _request);
        tf_lastFrequencyInfoTick = diag_tickTime + 10;
    }, 0.5] call CFUNC(addPerFrameHandler);

    [QGVAR(radioFollowTargetChanged), {
        (_this select 0) params ["_unit"];
        if !(alive _unit) then {
            tf_lastFrequencyInfoTick = diag_tickTime - 1;
        };
    }] call CFUNC(addEventhandler);

}] call CFUNC(addEventhandler);

{
    [format [QGVAR(%1), _x], _x, {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
} forEach ["OnRadiosReceived","OnRadioOwnerSet","OnLRChange","OnSWChange","OnLRchannelSet","OnSWchannelSet"];

{
    [_x, {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
} forEach ["vehicleChanged", "playerChanged", "Respawn"];

[QGVAR(OnTangent), "OnTangent", {
    params ["_unit", "_radio", "_radioType", "_additional", "_tangentPressed"];

    private _freq = switch (_radioType) do {
        case (0): {
            if !(_additional) then {
                format ["%1%2", _radio call TFAR_fnc_getSwFrequency, _radio call TFAR_fnc_getSwRadioCode];
            } else {
                format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getSwRadioCode];
            };
        };
        case (1): {
            if !(_additional) then {
                format ["%1%2", _radio call TFAR_fnc_getLrFrequency, _radio call TFAR_fnc_getLrRadioCode];
            } else {
                format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getLrRadioCode];
            };
        };
        case (2): {
            DUMP("Magic you dont exist");
            "";
        };
    };
    if (_freq == "") exitWith {};
    private _targets = GVAR(radioNamespace) getVariable [_freq, []];
    if (_targets isEqualTo []) exitWith {};
    [QGVAR(TangentChanged), [_freq, _tangentPressed, CLib_Player]] call CFUNC(targetEvent);
}, CLib_Player] call TFAR_fnc_addEventHandler;

[QGVAR(TangentChanged), {
    (_this select 0) params ["_freq", "_tangentPressed", "_unit"];
    GVAR(RadioInformationPrev) params [["_swFreqs", []], ["_lrFreqs", []]];

    private _icon = "";
    if (_freq in _swFreqs) then {
        _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";
    };
    if (_freq in _lrFreqs) then {
        _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\backpack_ca.paa";
    };

    if (_tangentPressed) then {
        [QGVAR(ShowIcon), [_unit, _icon, _freq]] call CFUNC(localEvent);
    } else {
        [QGVAR(HideIcon), [_unit, _freq]] call CFUNC(localEvent);
    };
}] call CFUNC(addEventHandler);
