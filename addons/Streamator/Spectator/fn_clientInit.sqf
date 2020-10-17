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
GVAR(aceMapGesturesLoaded) = isClass (configFile >> "CfgPatches" >> "ace_map_gestures");
GVAR(aceSpectatorLoaded) = isClass (configFile >> "CfgPatches" >> "ace_spectator");
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

["terminateSpectator", {
    call FUNC(closeSpectator);
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(openSpectator);
}] call CFUNC(addEventhandler);

CLib_Player setVariable [QGVAR(isPlayer), true, true];

["playerChanged", {
    (_this select 0) params ["_newPlayer"];
    _newPlayer setVariable [QGVAR(isPlayer), true, true];
    call FUNC(updateLocalMapMarkers);
}] call CFUNC(addEventhandler);

if (GVAR(ace_Loaded)) then {
    ["ace_throwableThrown", {
        ["ace_throwableThrown", _this] call CFUNC(globalEvent);
    }] call CBA_fnc_addEventHandler;
};
GVAR(allMapMarkers) = [];

#define Channel_Side "1"
#define Channel_Command "2"

DFUNC(collectMarkerData) = {
    params ["_marker", ["_forceSideColor", false]];
    [
        markerText _marker,
        markerPos _marker,
        markerDir _marker,
        getText ([(configFile >> "CfgMarkers" >> markerType _marker >> "icon"), (configFile >> "CfgMarkers" >> markerType _marker >> "texture")] select (isText (configFile >> "CfgMarkers" >> markerType _marker >> "texture"))),
        [(configfile >> "CfgMarkerColors" >> markerColor _marker >> "color") call BIS_fnc_colorConfigToRGBA, side CLib_Player] select _forceSideColor
    ]
};

DFUNC(bindMarkerEH) = {
    [{
        if (_this == 53 && getClientState == "BRIEFING READ") exitWith {};
        private _display = findDisplay _this;

        _display displayAddEventHandler ["KeyDown", {
            if (_this select 1 == DIK_DELETE) then {
                [{
                    {
                        private _i = _this find _x;
                        if (_i > -1) then {
                            if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                                [QGVAR(PlayerSideMarkerDeleted), _x] call CFUNC(serverEvent);
                            };
                        };
                    } forEach (_this - allMapMarkers);
                }, allMapMarkers] call CFUNC(execNextFrame);
            };
            false;
        }];

        _display displayAddEventHandler ["ChildDestroyed", {
            if (ctrlIdd (_this select 1) == 54 && _this select 2 == 1) then {
                [{
                    {
                        if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                            [QGVAR(PlayerSideMarkerPlaced), [_x, [_x, true] call FUNC(collectMarkerData)]] call CFUNC(serverEvent);
                        };
                    } forEach (allMapMarkers - _this);
                    {
                        private _i = _this find _x;
                        if (_i > -1) then {
                            if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                                [QGVAR(PlayerSideMarkerDeleted), _x] call CFUNC(serverEvent);
                            };
                        };
                    } forEach (_this - allMapMarkers);
                }, GVAR(allMapMarkers)] call CFUNC(execNextFrame);
            };
            false;
        }];

        _display displayCtrl 51 ctrlAddEventHandler ["MouseButtonDblClick", {
            {
                if (!isNull findDisplay 54) then {
                    (findDisplay 54 displayCtrl 1) buttonSetAction QUOTE(GVAR(allMapMarkers) = allMapMarkers);
                };
            } call CFUNC(execNextFrame);
            false;
        }];
    }, {
        if (_this == 53 && getClientState == "BRIEFING READ") exitWith { false };
        !(isNull (findDisplay _this))
    }, _this] call CFUNC(waitUntil);
};

DFUNC(updateLocalMapMarkers) = {
    private _markers = allMapMarkers select {
        (_x splitString "#/") params ["_userDef", "", "", "_channel"];
        _userDef == "_USER_DEFINED "
        && !(_channel in [Channel_Side, Channel_Command])
    };
    _markers = _markers apply { _x call FUNC(collectMarkerData); };
    if (_markers isEqualTo (CLib_Player getVariable [QGVAR(mapMarkers), []])) exitWith {};
    CLib_Player setVariable [QGVAR(mapMarkers), _markers, true];
};

["allMapMarkersChanged", {
    call FUNC(updateLocalMapMarkers);
}] call CFUNC(addEventHandler);

12 call FUNC(bindMarkerEH);
53 call FUNC(bindMarkerEH);
