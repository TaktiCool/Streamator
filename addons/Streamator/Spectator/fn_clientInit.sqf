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
GVAR(aceLaserLoaded) = isClass (configFile >> "CfgPatches" >> "ace_laser");
GVAR(aceMedicalLoaded) = isClass (configFile >> "CfgPatches" >> "ace_medical");
GVAR(aceHearingLoaded) = isClass (configFile >> "CfgPatches" >> "ace_hearing");
GVAR(aceGogglesLoaded) = isClass (configFile >> "CfgPatches" >> "ace_goggles");
GVAR(aceSpectatorLoaded) = isClass (configFile >> "CfgPatches" >> "ace_spectator");
GVAR(aceMapGesturesLoaded) = isClass (configFile >> "CfgPatches" >> "ace_map_gestures");
GVAR(aceAdvancedThrowingLoaded) = isClass (configFile >> "CfgPatches" >> "ace_advanced_throwing");

["missionStarted", {
    if (CLib_Player call Streamator_fnc_isSpectator) then {
        "initializeSpectator" call CFUNC(localEvent);
    };
    CLib_Player setVariable [QGVAR(isPlayer), true, true];
    CLib_Player addEventhandler ["FiredMan", {
        if (GVAR(Streamators) isEqualTo []) exitWith {};
        params ["_unit", "_weapon", "", "", "_ammo", "", "_projectile"];
        if (_ammo isKindOf "BombCore") then {
            if (isNull _projectile) then {
                _projectile = (getPos _unit) nearestObject _ammo;
            };
            [QGVAR(firedEHRemoteBombFix), GVAR(Streamators), [_unit, _weapon, _projectile, _ammo]] call CFUNC(targetEvent);
        };
    }];
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(openSpectator);
}] call CFUNC(addEventhandler);

CLib_Player setVariable [QGVAR(isPlayer), true, true];

["playerChanged", {
    (_this select 0) params ["_newPlayer", "_oldPlayer"];
    if (_newPlayer == player) then {
        _newPlayer setVariable [QGVAR(isPlayer), true, true];
    };
    call FUNC(updateLocalMapMarkers);
}] call CFUNC(addEventhandler);

if (GVAR(aceAdvancedThrowingLoaded)) then {
    ["ace_throwableThrown", {
        ["ace_throwableThrown", _this] call CFUNC(globalEvent);
    }] call CBA_fnc_addEventHandler;
};
