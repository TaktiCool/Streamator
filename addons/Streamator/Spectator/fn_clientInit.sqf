#include "macros.hpp"
/*
    Streamator

    Author: BadGuy, Raven

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
		DUMP("Updating TFAR frequencies...");
		// disable the caching for TFAR_fnc_radiosList by hacking into TFAR internals 
		TFAR_Core_VehicleConfigCacheNamespace setVariable ["TFAR_fnc_radiosList_lastCache", 0];
		
		// diag_log "Updating TFAR Frequencies...";
		// diag_log str (CLib_player call TFAR_fnc_radiosList);
		// diag_log str (CLib_player call TFAR_fnc_lrRadiosList apply {typeof (_x select 0)});
		
        private _freqSW = [];
        private _freqLR = [];

		// The goal is to fill the frequency information partly so that the PFH added in
		// openSpectator can fill in the remaining bits (volume and stereo settings)
		// Therefore the information that needs to be extracted here is the set frequency,
		// the radio code and the class name of the used radio for the set channels
		
		// Process SW radios
        {					
            private _adChannel = _x call TFAR_fnc_getAdditionalSwChannel;
            private _rc = _x call TFAR_fnc_getSwRadioCode;
			
            _freqSW pushBackUnique format ["%1%2|%3",
				_x call TFAR_fnc_getSwFrequency,
				_rc,
				_x
			];
			
			// Check if there is an additional channel and if so add it as well
            if ( _adChannel > -1 && {_adChannel == (_x call TFAR_fnc_getSwChannel)}) then {
                _freqSW pushBackUnique format ["%1%2|%3",
					[_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency,
					_rc,
					_x
				];
            };
            nil;
        } count (CLib_player call TFAR_fnc_radiosList);
		
		// Process LR radios
        {
            private _adChannel = _x call TFAR_fnc_getAdditionalLrChannel;
            private _rc = _x call TFAR_fnc_getLrRadioCode;
			
            _freqLR pushBackUnique format ["%1%2|%3",
				_x call TFAR_fnc_getLrFrequency,
				_rc,
				typeOf (_x select 0) // LR radio is an array whose first entry is the radio object
			];
			
			// Check if there is an additional channel and if so add it as well
            if (_adChannel > -1 && {_adChannel != (_x call TFAR_fnc_getLrChannel)}) then {
                _freqLR pushBackUnique format ["%1%2|%3",
					[_x, _adChannel + 1] call TFAR_fnc_GetChannelFrequency,
					_rc,
					typeOf (_x select 0)  // LR radio is an array whose first entry is the radio object
				];
            };
            nil;
        } count (CLib_player call TFAR_fnc_lrRadiosList);

		// If there are no radios available use "No_SW_Radio" and "No_LR_Radio" respectively to 
		// indicate that. These entries will be left alone in the PFH added in openSpectator
        if (_freqSW isEqualTo []) then {
            _freqSW pushBackUnique "No_SW_Radio";
        };
        if (_freqLR isEqualTo []) then {
            _freqLR pushBackUnique "No_LR_Radio";
        };
		
		// Set the variable to the player object in order to be able to access it later on
        CLib_player setVariable [QGVAR(RadioInformation), [_freqSW, _freqLR], true];
		
		DUMP("TFAR freuencies set to" + str _freqSW + " (SW) " + str _freqLR + " (LR)");
    };
	
	
	// Set up EventHandler for updating the stored TFAR frequencies on the following TFAR-events
    [QGVAR(OnRadiosReceived), "OnRadiosReceived", {
		// diag_log "RadiosReceived";
		// diag_log _this;
		
		// TODO: is waiting that extra frame necessary?
        [{call FUNC(updateTFARFreq);}] call CFUNC(execNextFrame);
    }] call TFAR_fnc_addEventHandler;
    [QGVAR(OnRadioOwnerSet), "OnRadioOwnerSet", {
        call FUNC(updateTFARFreq);
    }] call TFAR_fnc_addEventHandler;
    [QGVAR(OnLRChange), "OnLRChange", {
        call FUNC(updateTFARFreq);
    }] call TFAR_fnc_addEventHandler;
    [QGVAR(OnSWChange), "OnSWChange", {
        call FUNC(updateTFARFreq);
    }] call TFAR_fnc_addEventHandler;
    [QGVAR(OnLRchannelSet), "OnLRchannelSet", {
        call FUNC(updateTFARFreq);
    }] call TFAR_fnc_addEventHandler;
    [QGVAR(OnSWchannelSet), "OnSWchannelSet", {
        call FUNC(updateTFARFreq);
    }, CLib_Player] call TFAR_fnc_addEventHandler;
	[QGVAR(OnFrequencyChangedFromUI), "OnFrequencyChangedFromUI", {
		call FUNC(updateTFARFreq);
	}] call TFAR_fnc_addEventHandler;
	
	
	// Set up EventHandler for updating the stored TFAR frequencies on the following CLib-events
    ["vehicleChanged", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
    ["playerChanged", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
    ["Respawn", {
        call FUNC(updateTFARFreq);
    }] call CFUNC(addEventhandler);
	
	
	// aklso set infor right away
    call FUNC(updateTFARFreq);


	// add EH for whenever the player presses/releases the radio button (capslock for SW by default)
    [QGVAR(OnTangent), "OnTangent", {
        params ["_unit", "_radio", "_radioType", "_additional", "_tangentPressed"];

		// The _freq variable misses the information about the radio class name on purpose
		// It is being used to determine the targets of a radio transmission which only depends
		// on frequency and radio code. Therefore the radio class name is irrelevant and thus not
		// used in the variable name holding the needed targets (which is set in an EH added in the serverInit)
        private _freq = switch (_radioType) do {
            case (0): {
				// SW
                if !(_additional) then {
                    format ["%1%2", _radio call TFAR_fnc_getSwFrequency, _radio call TFAR_fnc_getSwRadioCode];
                } else {
                    format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getSwRadioCode];
                };
            };
            case (1): {
				// LR
                if !(_additional) then {
                    format ["%1%2", _radio call TFAR_fnc_getLrFrequency, _radio call TFAR_fnc_getLrRadioCode];
                } else {
                    format ["%1%2", [_radio, (_radio call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _radio call TFAR_fnc_getLrRadioCode];
                };
            };
            default {
                ERROR_LOG(format ["Encountered invalid radioType %1", _radioType]);
                "";
            };
        };
		
		// Failsafe - Exit on unexpected _radioType
        if (_freq == "") exitWith {};
		
        private _targets = GVAR(radioNamespace) getVariable [_freq, []];
		
        if (_targets isEqualTo []) exitWith {DUMP("Cancelling tangent send on frequency " + str _freq + " as there are no targets for it");};
		
		DUMP("Sending tangent event from " + str _unit + " to " + str _targets + " on frequency " + str _freq);
        [[QGVAR(tangentReleased), QGVAR(tangentPressed)] select _tangentPressed, _targets, [_unit, _freq]] call CFUNC(targetEvent);
    }] call TFAR_fnc_addEventHandler;

};
