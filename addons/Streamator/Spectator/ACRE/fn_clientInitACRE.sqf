#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for ACRE Radio Coms Plugin

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(ACRELoaded) = isClass (configFile >> "CfgPatches" >> "acre_main");
if !(GVAR(ACRELoaded)) exitWith {};
LOG("ACRE2 Detected");
[QGVAR(spectatorOpened), {
    [true] call acre_api_fnc_setSpectator;

    if !(isNil "acre_sys_core_languages") then {
        (acre_sys_core_languages apply {_x select 0}) call acre_api_fnc_babelSetSpokenLanguages;
    };

    [{
        private _targetRadios = GVAR(RadioFollowTarget) getVariable [QGVAR(ACRE_Radios), []];

        if (!(isNull GVAR(RadioFollowTarget))&& {!(GVAR(RadioFollowTarget) isKindOf "CAManBase")}) then {
            {
                _targetRadios pushBackUnique ([_x] call acre_api_fnc_getMountedRackRadio);
            } forEach ([GVAR(RadioFollowTarget)] call acre_api_fnc_getVehicleRacks);
        };
        if (_targetRadios isEqualTo GVAR(CurrentRadioList)) exitWith {};
        [CLIb_Player] call acre_api_fnc_removeAllSpectatorRadios;
        {
            [CLib_Player, _x] call acre_api_fnc_addSpectatorRadio;
        } forEach _targetRadios;
        [QGVAR(radioInformationChanged), _targetRadios] call CFUNC(localEvent);
        GVAR(CurrentRadioList) = _targetRadios;
    }, 1] call CFUNC(addPerFrameHandler);

    ["acre_remoteStartedSpeaking", {
        params ["_unit", "_isRadio", "_radioID"];
        if (_unit == CLib_Player) exitWith {};
        if (_isRadio == 0) exitWith {};
        if (isNull GVAR(RadioFollowTarget)) exitWith {}; // early Exit
        private _availability = [[_radioID], GVAR(CurrentRadioList), true] call acre_sys_modes_fnc_checkAvailability;
        if (((_availability select 0) select 1) isEqualTo []) exitWith {};
        private _radioIDLocal = (((_availability select 0) select 1) select 0);
        private _usedRadios = _unit getVariable [QGVAR(SpeaksOnRadios), []];
        _usedRadios pushBack _radioIDLocal;
        _unit setVariable [QGVAR(SpeaksOnRadios), _usedRadios];
        private _debug = format ["Radio used Local : %1  Radio Remote: %2 Radio CheckAvailability: %3", _radioIDLocal, _radioID, _availability];
        DUMP(_debug);
        private _radio = [_radioIDLocal] call acre_api_fnc_getBaseRadio;
        private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";
        if (_radio in ["ACRE_PRC77", "ACRE_PRC117F"]) then {
            _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\backpack_ca.paa";
        };
        [QGVAR(ShowIcon), [_unit, _icon, _radioIDLocal]] call CFUNC(localEvent);
    }] call CBA_fnc_addEventHandler;

    ["acre_remoteStoppedSpeaking", {
        params ["_unit"];
        if (isNull GVAR(RadioFollowTarget)) exitWith {}; // early Exit
        {
            [QGVAR(HideIcon), [_unit, _x]] call CFUNC(localEvent);
        } forEach (_unit getVariable [QGVAR(SpeaksOnRadios), []]);
        _unit setVariable [QGVAR(SpeaksOnRadios), []];
    }] call CBA_fnc_addEventHandler;

    [QGVAR(radioFollowTargetChanged), {
        (_this select 0) params ["_unit"];
        {
            [QGVAR(HideIcon), [_unit, _x]] call CFUNC(localEvent);
        } forEach (_unit getVariable [QGVAR(SpeaksOnRadios), []]);

    }] call CFUNC(addEventhandler);
}] call CFUNC(addEventhandler);

[{
    private _newRadios = call acre_api_fnc_getCurrentRadioList;
    private _oldRadios = CLib_Player getVariable [QGVAR(ACRE_Radios), []];
    if !(_newRadios isEqualTo _oldRadios) then {
        CLib_Player setVariable [QGVAR(ACRE_Radios), _newRadios, true];
    };
}, 1] call CFUNC(addPerFrameHandler); // see how high freqency we need to send this maybe lower it
