#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draw3d event handler for the spectator

    Parameter(s):
    None

    Returns:
    None
*/
if (isGamePaused || CGVAR(PauseMenuOpen)) exitWith {};
// Cursor Target
private _nextTarget = objNull;
private _intersectCam = AGLToASL positionCameraToWorld [0, 0, 0];
private _intersectTarget = AGLToASL positionCameraToWorld [0, 0, 10000];
private _object = lineIntersectsSurfaces [
    _intersectCam,
    _intersectTarget,
    objNull,
    objNull,
    true,
    1,
    "GEOM",
    "NONE",
    false
];

if (_object isNotEqualTo []) then {
    _nextTarget = (_object select 0) select 2;
};

if (_nextTarget isNotEqualTo GVAR(CursorTarget)) then {
    if (!(isNull _nextTarget) || (time - GVAR(lastCursorTarget)) >= 1) then {
        GVAR(CursorTarget) = _nextTarget;
        [QGVAR(CursorTargetChanged), _nextTarget] call CFUNC(localEvent);
        GVAR(lastCursorTarget) = time;
    };
};
if (GVAR(hideUI) || GVAR(MapOpen)) exitWith {};

private _fov = (call CFUNC(getFOV)) * 3;
private _cameraPosition = positionCameraToWorld [0, 0, 0];
//HUD
//PlanningMode
if (GVAR(OverlayPlanningMode)) then {
    [_cameraPosition, _fov] call FUNC(draw3dPlanning);
};

//Units
if (GVAR(OverlayUnitMarker)) then {
    [_cameraPosition, _fov] call FUNC(draw3dUnits);
};

// GROUPS
if (GVAR(OverlayGroupMarker)) then {
    [_cameraPosition, _fov] call FUNC(draw3dGroups);
};

if (GVAR(OverlayLaserTargets)) then {
    call FUNC(draw3dLaserTargets);
};

if (GVAR(OverlayBulletTracer)) then {
    call FUNC(draw3dBullets);
};

if (GVAR(MeasureDistance) && {(GVAR(MeasureDistancePositions) isNotEqualTo [])}) then {
    call FUNC(draw3dMeasureDistance);
};
