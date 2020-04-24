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

["missionStarted", {
    if (CLib_player call Streamator_fnc_isSpectator) then {
        "initializeSpectator" call CFUNC(localEvent);
    };
    CLib_Player setVariable [QGVAR(isPlayer), true, true];
    private _directPlayID = [GVAR(playerIDs), getPlayerUID CLib_Player, -1] call CFUNC(getHash);
    CLib_Player setVariable [QGVAR(playerID),  _directPlayID];
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

GVAR(allMapMarkers) = [];

#define Channel_Global "0"
#define Channel_Command "2"

DFUNC(collectMarkerData) = {
    params ["_marker"];
    [
        markerText _marker,
        markerPos _marker,
        markerDir _marker,
        markerType _marker,
        (configfile >> "CfgMarkerColors" >> markerColor _marker >> "color") call BIS_fnc_colorConfigToRGBA
    ]
};

DFUNC(bindMarkerEH) = {
    [{
        if (_this == 53 && getClientState == "BRIEFING READ") exitWith { false };
        !(isNull (findDisplay _this))
    }, {
        if (_this == 53 && getClientState == "BRIEFING READ") exitWith {};
        private _display = findDisplay _this;

        _display displayAddEventHandler ["KeyDown", {
            if (_this select 1 == 211) then {
                [{
                    params ["_markers"];
                    {
                        private _i = _markers find _x;
                        if (_i > -1) then {
                            if (((_x splitString "#/") param [2, "-1"]) in [Channel_Global, Channel_Command]) then {
                                [QGVAR(PlayerSideMarkerDeleted), _x] call CFUNC(serverEvent);
                            };
                        };
                    } forEach (_markers - allMapMarkers);
                }, allMapMarkers] call CFUNC(execNextFrame);
                false
            };
        }];

        _display displayAddEventHandler ["ChildDestroyed", {
            if (ctrlIdd (_this select 1) == 54 && _this select 2 == 1) then {
                [{
                    {
                        if (((_x splitString "#/") select 2) in [Channel_Global, Channel_Command]) then {
                            [QGVAR(PlayerSideMarkerPlaced), [_x, _x call FUNC(collectMarkerData)]] call CFUNC(serverEvent);
                        };
                    } forEach (allMapMarkers - _this);
                }, GVAR(allMapMarkers)] call CFUNC(execNextFrame);
            };
        }];

        _display displayCtrl 51 ctrlAddEventHandler ["MouseButtonDblClick", {
            {
                if (!isNull findDisplay 54) then {
                    (findDisplay 54 displayCtrl 1) buttonSetAction QUOTE(GVAR(allMapMarkers) = allMapMarkers);
                };
            } call CFUNC(execNextFrame);
        }];
    }, _this] call CFUNC(waitUntil);
};

DFUNC(updateLocalMapMarkers) = {
    private _markers = allMapMarkers select {
        (_x splitString "#/") params ["_userDef", "", "", "_channel"];
        _userDef == "_USER_DEFINED #"
        && !(_channel in [Channel_Global, Channel_Command])
    };
    CLib_Player setVariable [QGVAR(mapMarkers), _markers];
};

["allMapMarkersChanged", {
    call FUNC(updateLocalMapMarkers);
}] call CFUNC(addEventHandler);

12 call FUNC(bindMarkerEH);
53 call FUNC(bindMarkerEH);
