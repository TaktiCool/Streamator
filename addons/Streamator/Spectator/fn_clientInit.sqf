#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(ACRELoaded) = isClass (configFile >> "CfgPatches" >> "acre_main");

if (CLib_player call Streamator_fnc_isSpectator) then {
    ["missionStarted", {
        "initializeSpectator" call CFUNC(localEvent);
    }] call CFUNC(addEventhandler);
};

["terminateSpectator", {
    call FUNC(closeSpectator);
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(openSpectator);
}] call CFUNC(addEventhandler);

if (GVAR(TFARLoaded)) then {
    DFUNC(updateTFARFreq) = {
        private _freqSW = [];
        private _freqLR = [];

        {
            private _adChannel = _x call TFAR_fnc_getAdditionalSwChannel;
            private _rc = _x call TFAR_fnc_getSwRadioCode;
            _freqSW pushBackUnique format ["%1%2", _x call TFAR_fnc_getSwFrequency, _rc];
            if ( _adChannel > -1 && {_adChannel == (_x call TFAR_fnc_getSwChannel)}) then {
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
    };
    [QGVAR(OnRadiosReceived), "OnRadiosReceived", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    [QGVAR(OnRadioOwnerSet), "OnRadioOwnerSet", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    [QGVAR(OnLRChange), "OnLRChange", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    [QGVAR(OnSWChange), "OnSWChange", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    [QGVAR(OnLRchannelSet), "OnLRchannelSet", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    [QGVAR(OnSWchannelSet), "OnSWchannelSet", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
    ["vehicleChanged", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
    ["playerChanged", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
    ["Respawn", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
    call FUNC(updateTFARFreq);

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
        [[QGVAR(tangentReleased), QGVAR(tangentPressed)] select _tangentPressed, _targets, [_unit, _freq]] call CFUNC(targetEvent);
    }, CLib_Player] call TFAR_fnc_addEventHandler;

};
if (GVAR(ACRELoaded)) then {
    [{
        private _newRadios = call acre_api_fnc_getCurrentRadioList;
        private _oldRadios = CLib_Player getVariable [QGVAR(ACRE_Radios), []];
        if !(_newRadios isEqualTo _oldRadios) then {
            CLib_Player setVariable [QGVAR(ACRE_Radios), _newRadios, true];
        };
    }, 1] call CFUNC(addPerFrameHandler); // see how high freqency we need to send this maybe lower it

}
