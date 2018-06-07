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
        private _freqDD = "No_DD_Radio";

        if (call TFAR_fnc_haveSWRadio) then {
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
            } count (TFAR_currentUnit call TFAR_fnc_radiosList);
        };

        if (call TFAR_fnc_haveLRRadio) then {
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
            } count (TFAR_currentUnit call TFAR_fnc_lrRadiosList);
        };

        if (call TFAR_fnc_haveDDRadio) then {
            _freqDD = TF_dd_frequency;
        };
        if (_freqSW isEqualTo []) then {
            _freqSW pushBackUnique "No_SW_Radio";
        };
        if (_freqLR isEqualTo []) then {
            _freqLR pushBackUnique "No_LR_Radio";
        };
        CLib_Player setVariable [QGVAR(RadioInformations), [_freqSW, _freqLR, _freqDD], true];
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
};
