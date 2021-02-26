#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Builds FPS UI

    Parameter(s):
    None

    Returns:
    None
*/
params ["_ctrlGrp"];
private _display = ctrlParent _ctrlGrp;

private _ctrlUnitName = _display ctrlCreate ["RscText", -1, _ctrlGrp];
_ctrlUnitName ctrlSetPosition [PX(BORDERWIDTH + 2.6), safeZoneH - PY(BORDERWIDTH + 7.6), PX(100), PY(5)];
_ctrlUnitName ctrlSetFontHeight PY(4);
_ctrlUnitName ctrlSetFont "RobotoCondensedBold";
_ctrlUnitName ctrlSetTextColor [1, 1, 1, 1];
_ctrlUnitName ctrlSetFade 1;
_ctrlUnitName ctrlSetText "UNIT NAME"; // Unit Name
_ctrlUnitName ctrlCommit 0;

private _ctrlGrpMinimap = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
_ctrlGrpMinimap ctrlSetPosition [safeZoneW - PX(BORDERWIDTH + 2.6 + 25), safeZoneH - PY(BORDERWIDTH + 40), PX(25), PY(25)];
_ctrlGrpMinimap ctrlSetFade 1;
_ctrlGrpMinimap ctrlCommit 0;

private _ctrlMinimapBackground = _display ctrlCreate ["RscPicture", -1, _ctrlGrpMinimap];
_ctrlMinimapBackground ctrlSetPosition [0, 0, PX(25), PY(28)];
_ctrlMinimapBackground ctrlSetText "#(argb,8,8,3)color(0.1,0.1,0.1,0.75)";
_ctrlMinimapBackground ctrlCommit 0;

private _ctrlMinimapTitle = _display ctrlCreate ["RscTitle", -1, _ctrlGrpMinimap];
_ctrlMinimapTitle ctrlSetPosition [0, 0, PX(15), PY(3)];
_ctrlMinimapTitle ctrlSetFontHeight PY(2);
_ctrlMinimapTitle ctrlSetFont "RobotoCondensedBold";
_ctrlMinimapTitle ctrlSetText "Minimap";
_ctrlMinimapTitle ctrlCommit 0;

private _ctrlBearings = _display ctrlCreate ["RscTitle", -1, _ctrlGrpMinimap];
_ctrlBearings ctrlSetPosition [PX(19), 0, PX(5.5), PY(3)];
_ctrlBearings ctrlSetFontHeight PY(2);
_ctrlBearings ctrlSetFont "RobotoCondensedBold";
_ctrlBearings ctrlSetText "NW 000°";
_ctrlBearings ctrlCommit 0;

private _ctrlTime = _display ctrlCreate ["RscTitle", -1, _ctrlGrpMinimap];
_ctrlTime ctrlSetPosition [PX(10), 0, PX(4), PY(3)];
_ctrlTime ctrlSetFontHeight PY(2);
_ctrlTime ctrlSetFont "RobotoCondensedBold";
_ctrlTime ctrlSetText "00:00";
_ctrlTime ctrlCommit 0;

private _ctrlMinimap = _display ctrlCreate ["RscMapControl", -1, _ctrlGrpMinimap];
_ctrlMinimap ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH + 2.6 + 25), safeZoneY + safeZoneH - PY(BORDERWIDTH + 37), PX(25), 0];
_ctrlMinimap ctrlCommit 0;
[_ctrlMinimap] call CFUNC(registerMapControl);

_ctrlMinimap setVariable [QGVAR(ctrlBearings), _ctrlBearings];
_ctrlMinimap setVariable [QGVAR(ctrlTime), _ctrlTime];

_ctrlMinimap ctrlAddEventHandler ["Draw", {
    params [["_map", controlNull, [controlNull]]];

    private _ctrlBearings = _map getVariable [QGVAR(ctrlBearings), controlNull];
    _ctrlBearings ctrlSetText ((getDir GVAR(Camera)) call FUNC(formatDirection));
    _ctrlBearings ctrlCommit 0;

    private _ctrlTime = _map getVariable [QGVAR(ctrlTime), controlNull];
    _ctrlTime ctrlSetText ([dayTime, "HH:MM"] call BIS_fnc_timeToString);
    _ctrlTime ctrlCommit 0;

    private _mapPosition = ctrlPosition _map;
    private _position = positionCameraToWorld [0, 0, 0];
    private _velocity = GVAR(CameraSpeed) / 16;
    switch (true) do {
        case (!GVAR(CenterMinimapOnCameraPositon)): {
            private _tis = terrainIntersectAtASL [AGLToASL positionCameraToWorld [0, 0, 0], AGLToASL positionCameraToWorld [0, 0, 10000]];
            if (_tis isEqualTo [0, 0, 0]) then {
                _tis = positionCameraToWorld [0, 0, 1000];
            };
            _velocity = (_tis distance2D (AGLToASL _position)) / 16;
            _position = positionCameraToWorld [0, 0, (_tis distance2D (AGLToASL _position)) / 2];
        };
        case !(isNull GVAR(CameraFollowTarget)): {
            private _target = vehicle GVAR(CameraFollowTarget);
            _position = getPos _target;
            _velocity = (speed _target) min 80;
        };
    };

    private _mapCenterWorldPos = _map ctrlMapScreenToWorld [(_mapPosition select 0) + ((_mapPosition select 2)/2),  (_mapPosition select 1) + ((_mapPosition select 3)/2)];

    private _screenCenterWorldPos = _map ctrlMapScreenToWorld [(_mapPosition select 0) + safeZoneWAbs/2, (_mapPosition select 1) + (SafeZoneH - 1.5 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))/2];
    _screenCenterWorldPos set [2, 0];
    _mapCenterWorldPos set [2, 0];
    _position = _position vectorAdd (_screenCenterWorldPos vectorDiff _mapCenterWorldPos);

    // Calculate Zoom Level
    ctrlMapScale _map;
    private _zoom = (ctrlMapScale _map) * (1 - 0.1) + linearConversion [0, 80, abs _velocity, 0.025, 0.5, false] * 0.1;

    // Animate Map
    _map ctrlMapAnimAdd [0, _zoom min 1, _position];
    ctrlMapAnimCommit _map;

    if (GVAR(RenderFOVCone)) then {

        private _vertices = [];

        private _cPos = positionCameraToWorld [0, 0, 0];
        _cPos set [2, 0];
        _vertices pushBack _cPos;
        {
            private _newPos = _cPos vectorFromTo (screenToWorld _x);
            _newPos = _newPos vectorMultiply 100000;
            _newPos = _newPos vectorAdd _cPos;
            _vertices pushBack _newPos;
        } forEach [
            [1 - safeZoneX, 0.5],
            [safeZoneX, 0.5]
        ];
        _map drawTriangle [_vertices, [1,1,1,1], "#(rgb,1,1,1)color(0.2,0.25,0.25,0.25)"];
    };
}];

[QGVAR(CameraTargetChanged), {
    (_this select 0) params ["_cameraTarget"];
    (_this select 1) params ["_ctrl"];
    if (isNull _cameraTarget) exitWith {};
    if !(_cameraTarget isKindOf "CAManBase") then {
        _cameraTarget = (crew _cameraTarget) select 0;
    };
    _ctrl ctrlSetText (_cameraTarget call CFUNC(name));
}, [_ctrlUnitName]] call CFUNC(addEventhandler);

[QGVAR(CameraModeChanged), {
    (_this select 0) params ["_cameraMode"];
    (_this select 1) params ["_ctrl"];

    if (_cameraMode == CAMERAMODE_FPS) then {
        _ctrl ctrlSetFade 0;
    } else {
        _ctrl ctrlSetFade 1;
    };
    _ctrl ctrlCommit 0.3;
}, [_ctrlUnitName]] call CFUNC(addEventhandler);

[QGVAR(ToggleMinimap), {
    (_this select 1) params ["_ctrlGrpMinimap", "_ctrlMinimap"];
    private _ctrlMinimapPos = ctrlPosition _ctrlMinimap;
    if (ctrlFade _ctrlGrpMinimap == 1) then {
        _ctrlMinimapPos set [3, PY(25)];
        _ctrlGrpMinimap ctrlSetFade 0;
        GVAR(MinimapVisible) = true;
    } else {
        _ctrlMinimapPos set [3, 0];
        _ctrlGrpMinimap ctrlSetFade 1;
        GVAR(MinimapVisible) = false;
    };
    QEGVAR(UnitTracker,updateIcons) call CFUNC(localEvent);
    _ctrlMinimap ctrlSetPosition _ctrlMinimapPos;
    _ctrlGrpMinimap ctrlCommit 0.5;
    _ctrlMinimap ctrlCommit 0.3;
    QGVAR(updateMenu) call CFUNC(localEvent);
}, [_ctrlGrpMinimap, _ctrlMinimap]] call CFUNC(addEventhandler);
