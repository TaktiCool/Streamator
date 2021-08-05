#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for TFAR Radio Coms Plugin

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "tfar_core");

if (!GVAR(TFARLoaded)) exitWith {};
LOG("TFAR Stable Detected");

[QGVAR(spectatorOpened), {

    GVAR(TFARRadioVolume) = 7;
    0 call TFAR_fnc_setVoiceVolume;
    CLib_Player setVariable ["tf_unable_to_use_radio", true];
    CLib_Player setVariable ["tf_forcedCurator", true];
    CLib_Player setVariable ["TFAR_forceSpectator", true];

    [{
        if !(alive GVAR(RadioFollowTarget)) exitWith {
            if (GVAR(RadioInformationPrev) isNotEqualTo []) then {
                private _radioInformationPrev = (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1);
                _radioInformationPrev = _radioInformationPrev apply { if (_x isEqualType "") then { _x } else { _x select 0 }; };
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, [], _radioInformations]] call CFUNC(serverEvent);
                [QGVAR(radioInformationChanged), []] call CFUNC(localEvent);
                GVAR(RadioInformationPrev) = [];
            };
        };
        private _data = GVAR(RadioFollowTarget) getVariable [QGVAR(RadioInformation), [["No_SW_Radio"], ["No_LR_Radio"]]];
        if (_data isNotEqualTo GVAR(RadioInformationPrev)) then {
            private _radioInformation = (_data select 0) + (_data select 1);
            _radioInformation = _radioInformation apply { if (_x isEqualType "") then { _x } else { _x select 0 }; };

            if (GVAR(RadioInformationPrev) isEqualTo []) then {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, _radioInformation, []]] call CFUNC(serverEvent);
            } else {
                private _radioInformationPrev = (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1);
                _radioInformationPrev = _radioInformationPrev apply { if (_x isEqualType "") then { _x } else { _x select 0 }; };
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, _radioInformation, _radioInformationPrev]] call CFUNC(serverEvent);
            };
            [QGVAR(radioInformationChanged), _radioInformation] call CFUNC(localEvent);
            GVAR(RadioInformationPrev) = +_data;
        };
        _data params ["_freqSW", "_freqLR"];
        if !("No_SW_Radio" in _freqSW) then {
            _freqSW = _freqSW apply {format ["%1|%2|%3|%4", _x select 0, GVAR(TFARRadioVolume), _x select 1, _x select 2]};
        };
        if !("No_LR_Radio" in _freqLR) then {
            _freqLR = _freqLR apply {format ["%1|%2|%3|%4", _x select 0, GVAR(TFARRadioVolume), _x select 1, _x select 2]};
        };

        TFAR_player_name = name CLib_Player;
        private _globalVolume = CLib_Player getVariable ["tf_globalVolume", 1.0];
        private _receivingDistanceMultiplicator = (CLib_Player getVariable ["tf_receivingDistanceMultiplicator",1.0]) * (1/TFAR_globalRadioRangeCoef);

        private _request = format ["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10~",
            _freqSW, // list of short wave frequencies to set (including volume and stero info)
            _freqLR, // list of long range frequencies to set (including volume and stero info)
            true, // Set player's state to "alive"
            0, // set player's voice volume
            profileName, // The player's nickname
            waves, // The waves level
            TF_terrain_interception_coefficient, // The terrainIntersectionCoefficient
            _globalVolume, // The global volume
            _receivingDistanceMultiplicator, // receivingDistanceMultiplicator
            0 // speakerDistance
        ];
        private _result = "task_force_radio_pipe" callExtension _request;
        DUMP("Listen To Radio: " + _result + " " + _request);
        TFAR_core_VehicleConfigCacheNamespace setVariable ["TFAR_fnc_sendFrequencyInfo_lastExec", diag_tickTime + 5];

    }, 0.3] call CFUNC(addPerFrameHandler);

    [QGVAR(radioFollowTargetChanged), {
        (_this select 0) params ["_unit"];
        if !(alive _unit) then {
            TFAR_core_VehicleConfigCacheNamespace setVariable ["TFAR_fnc_sendFrequencyInfo_lastExec", diag_tickTime - 3];
        };
    }] call CFUNC(addEventhandler);

    [QGVAR(TangentChanged), {
        (_this select 0) params ["_freq", "_tangentPressed", "_unit"];
        GVAR(RadioInformationPrev) params [["_swFreqs", []], ["_lrFreqs", []]];

        _swFreqs = _swFreqs apply {
             if (_x isEqualType "") then { _x } else { _x select 0 call FUNC(getTFARFrequency) };
        };
        _lrFreqs = _lrFreqs apply {
            if (_x isEqualType "") then { _x } else { _x select 0 call FUNC(getTFARFrequency) };
        };

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
}] call CFUNC(addEventhandler);

private _events = ["OnRadiosReceived","OnRadioOwnerSet","OnLRChange","OnSWChange","OnLRchannelSet","OnSWchannelSet", "OnFrequencyChangedFromUI", "OnFrequencyChanged", "OnSpeakVolumeModifierReleased", "newLRSettingsAssigned"];

{
    [format [QGVAR(%1), _x], _x, {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
} forEach _events;

{
    [_x, {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
} forEach ["vehicleChanged", "playerChanged", "Respawn", "playerInventoryChanged"];

[QGVAR(OnTangent), "OnTangent", {
    params ["", "_radio", "_radioType", "_additional", "_tangentPressed"];

    private _freq = switch (_radioType) do {
        case (0): {
            if (_additional) then {
                format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getSwRadioCode];
            } else {
                format ["%1%2", _radio call TFAR_fnc_getSwFrequency, _radio call TFAR_fnc_getSwRadioCode];
            };
        };
        case (1): {
            if (_additional) then {
                format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getLrRadioCode];
            } else {
                format ["%1%2", _radio call TFAR_fnc_getLrFrequency, _radio call TFAR_fnc_getLrRadioCode];
            };
        };
        default {
            DUMP("Magic you dont exist");
            ""
        };
    };
    if (_freq == "") exitWith {};
    private _targets = GVAR(radioNamespace) getVariable [_freq, []];
    if (_targets isEqualTo []) exitWith {};
    [QGVAR(TangentChanged), _targets, [_freq, _tangentPressed, CLib_Player]] call CFUNC(targetEvent);
}, CLib_Player] call TFAR_fnc_addEventHandler;
