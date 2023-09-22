#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Initialize Spectator

    Parameter(s):
    None

    Returns:
    None
*/

if (isNil QGVAR(SideColorsArray)) then {
    GVAR(SideColorsArray) = createHashMap;
    GVAR(SideColorsArray) set [west, [0, 0.4, 0.8, 1]];
    GVAR(SideColorsArray) set [east, [0.6, 0, 0, 1]];
    GVAR(SideColorsArray) set [independent, [0, 0.5, 0, 1]];
    GVAR(SideColorsArray) set [civilian, [0.4, 0, 0.5, 1]];
    GVAR(SideColorsArray) set [sideUnknown, [0.3, 0.3, 0.3, 1]];
};

if (isNil QGVAR(SideColorsString)) then {
    GVAR(SideColorsString) = createHashMap;
    GVAR(SideColorsString) set [west, "#0099EE"];
    GVAR(SideColorsString) set [east, "#CC3333"];
    GVAR(SideColorsString) set [independent, "#33CC33"];
    GVAR(SideColorsString) set [civilian, "#CC33CC"];
    GVAR(SideColorsString) set [sideUnknown, "#4C4C4C"];
};

if (isNil QGVAR(PositionMemory)) then {
    GVAR(PositionMemory) = false call CFUNC(createNamespace);
};

if (GVAR(aceMapGesturesLoaded)) then {
    GVAR(ace_map_gestures_color_namespace) = missionNamespace getVariable ["ace_map_gestures_GroupColorCfgMappingNew", objNull];
    GVAR(ace_map_gestures_defaultLeadColor) = missionNamespace getVariable ["ace_map_gestures_defaultLeadColor", [1,0.88,0,0.95]];
    GVAR(ace_map_gestures_defaultColor) = missionNamespace getVariable ["ace_map_gestures_defaultColor", [1,0.88,0,0.7]];
    GVAR(ace_map_gestures_nameTextColor) = missionNamespace getVariable ["ace_map_gestures_nameTextColor", [0.2,0.2,0.2,0.3]];
};
GVAR(Camera) = objNull;

GVAR(CameraPos) = [0, 0, 0];
GVAR(CameraDir) = getDirVisual CLib_Player;
GVAR(CameraDirOffset) = 0;
GVAR(CameraPitch) = -45;
GVAR(CameraPitchOffset) = 0;
GVAR(CameraHeight) = 10;
GVAR(CameraSmoothingMode) = false;
GVAR(CameraSpeedMode) = false;
GVAR(CameraZoomMode) = false;
GVAR(CameraFocusDistanceMode) = false;
GVAR(CameraSpeed) = 5;
GVAR(CameraMode) = CAMERAMODE_FREE;
GVAR(CameraFOV) = 0.75;
GVAR(CameraFocusDistance) = 64;
GVAR(CameraVision) = 9;
GVAR(ThermalVision) = 0;
GVAR(PrevCameraVision) = 8;
GVAR(CameraRelPos) = [0, 0, 0];
GVAR(CameraInFirstPerson) = false;
GVAR(CameraDisableFocus) = false;

GVAR(lastPlanningModeUpdate) = -999;

GVAR(CameraFollowTarget) = objNull;
GVAR(RadioFollowTarget) = objNull;

GVAR(CursorTarget) = objNull;
GVAR(lastCursorTarget) = time;
GVAR(lastUnitShooting) = objNull;

GVAR(CameraPreviousState) = [];
GVAR(CameraSmoothingTime) = 0.2;

GVAR(MapState) = [];
GVAR(MapOpen) = false;
GVAR(MeasureDistancePositions) = [];
GVAR(MeasureDistance) = false;
GVAR(useTerrainIntersect) = false;

GVAR(MinimapVisible) = false;
GVAR(CenterMinimapOnCameraPositon) = true;
GVAR(RenderFOVCone) = true;

GVAR(hideUI) = false;

if (isNil QGVAR(ViewDistanceLimit)) then {
    GVAR(ViewDistanceLimit) = 12000;
};

GVAR(OverlayUnitMarker) = true;
GVAR(OverlayGroupMarker) = true;
GVAR(OverlayCustomMarker) = true;
GVAR(OverlayPlanningMode) = true;
GVAR(OverlayPlayerMarkers) = true;
GVAR(OverlayLaserTargets) = true;
GVAR(RadioIconsVisible) = true;
GVAR(showLaserCode) = false;

GVAR(InputMode) = INPUTMODE_MOVE;
GVAR(InputScratchpad) = "";
GVAR(InputGuess) = [];
GVAR(InputGuessIndex) = 0;

GVAR(allSpectators) = [];
GVAR(LaserTargets) = [];
GVAR(UnitInfoOpen) = false;
GVAR(UnitInfoTarget) = objNull;

GVAR(RenderAIUnits) = profileNamespace getVariable [QGVAR(RenderAIUnits), false];

GVAR(PlanningModeChannel) = 0;
GVAR(PlanningModeColorRGB) = [
    [1,0,0,1],       // #FF0000
    [1,1,0,1],       // #FFFF00
    [0,0.2,1,1],     // #0033FF
    [0.8,0.4,1,1],   // #CC66FF
    [0.4,1,0.4,1],   // #66FF66
    [1,0.4,0,1],     // #FF6600
    [1,1,1,1],       // #FFFFFF
    [0.4,0.6,1,1],   // #6699FF
    [0,1,1,1],       // #00FFFF
    [0.6,1,0.4,1],   // #99FF66
    [0.2,0.6,0.2,1], // #339933
    [1,0,0.4,1],     // #FF0066
    [0.8,0.2,0,1],   // #CC3300
    [0,0.2,0.8,1]    // #0033CC
];
private _colorCount = count GVAR(PlanningModeColorRGB);
GVAR(PlanningModeColor) = profileNamespace getVariable [QGVAR(PlanningModeColor), floor (random _colorCount)];
profileNamespace setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor)];
saveProfileNamespace;

CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];

GVAR(PlanningModeColorHTML) = GVAR(PlanningModeColorRGB) apply {_x call BIS_fnc_colorRGBtoHTML;};

GVAR(RadioInformationPrev) = [];

GVAR(OverlayBulletTracer) = false;
GVAR(BulletTracers) = [];
GVAR(ThrownTracked) = [];
GVAR(ShoulderOffset) = [0.4,-0.5,-0.3];
GVAR(TopDownOffset) = [0, 0, 100];

GVAR(SyncObjectViewDistance) = true;
GVAR(PlaningModeUpdateTime) = 0.05;

if (isNumber (missionConfigFile >> QUOTE(DOUBLE(PREFIX,PlaningModeUpdateTime)))) then {
    GVAR(PlaningModeUpdateTime) = getNumber (missionConfigFile >> QUOTE(DOUBLE(PREFIX,PlaningModeUpdateTime)));
};

[QGVAR(InputModeChanged), {
    GVAR(InputScratchpad) = "";
    QGVAR(updateMenu) call CFUNC(localEvent);
}] call CFUNC(addEventhandler);

[{
    GVAR(Camera) cameraEffect ["internal", "back"];
    switchCamera CLib_Player;
    cameraEffectEnableHUD true;
    DUMP("Camera Fix Executed");
}, QFUNC(fixCamera)] call CFUNC(compileFinal);

["entityCreated", {
    (_this select 0) params ["_target"];
    if (_target isKindOf "CAManBase") then {
        _target addEventHandler ["FiredMan", {
            params ["_unit", "_weapon", "", "", "_ammo", "", "_projectile"];
            [_unit, _weapon, _projectile, _ammo] call FUNC(firedEH);
        }];
    };
}] call CFUNC(addEventhandler);

[QGVAR(firedEHRemoteBombFix), {
    (_this select 0) call FUNC(firedEH);
}] call CFUNC(addEventHandler);

["ace_throwableThrown", {
    (_this select 0) params["_unit", "_projectile"];
    GVAR(lastUnitShooting) = _unit;
    _unit setVariable [QGVAR(lastShot), time];
    private _shots = _unit getVariable [QGVAR(shotCount), 0];
    _unit setVariable [QGVAR(shotCount), _shots + 1];
    if (GVAR(OverlayBulletTracer)) then {
        GVAR(ThrownTracked) pushBack [_projectile, time + 10];
    };
}] call CFUNC(addEventHandler);

GVAR(lastFrameDataUpdate) = diag_frameNo;
[QGVAR(RequestCameraState), {
    if (GVAR(lastFrameDataUpdate) == diag_frameNo) exitWith {};
    CLib_Player setVariable [QGVAR(State), [
        GVAR(CameraMode),
        GVAR(CameraFollowTarget),
        GVAR(CameraPos),
        GVAR(CameraRelPos),
        GVAR(CameraDir),
        GVAR(CameraPitch),
        GVAR(CameraFOV),
        GVAR(CameraVision),
        GVAR(CameraSmoothingTime),
        GVAR(ShoulderOffset),
        GVAR(CameraDirOffset),
        GVAR(CameraPitchOffset),
        GVAR(TopdownOffset)
    ], true];
    GVAR(lastFrameDataUpdate) = diag_frameNo;
}] call CFUNC(addEventhandler);


[{
    GVAR(allSpectators) = (allPlayers select {_x call Streamator_fnc_isSpectator && _x isNotEqualTo CLib_Player});

    // hijack this for disabling the UI.
    private _temp = shownHUD;
    _temp set [1, false];
    _temp set [6, false];
    _temp set [7, true];
    showHUD _temp;

    [{
        call FUNC(updateSpectatorArray);
    }, 3] call CFUNC(wait);
}, QFUNC(updateSpectatorArray)] call CFUNC(compileFinal);

private _fnc_init = {
    if (GVAR(aceLoaded)) then {
        if (GVAR(aceHearingLoaded)) then {
            [CLib_Player] call ace_hearing_fnc_putInEarplugs;
            ACE_Hearing_deafnessDV = 0;
            ACE_Hearing_volume = 1;
        };
        if (GVAR(aceMedicalLoaded)) then {
            CLib_Player setVariable ["ace_medical_allowdamage", false];
        };
        if (GVAR(aceGogglesLoaded)) then {
            call ace_goggles_fnc_removeGlassesEffect;
            CLib_Player setVariable ["ace_goggles_Condition", [false,[false,0,0,0],false]];
            ace_goggles_PostProcess ppEffectEnable false;
            ace_goggles_PostProcessEyes ppEffectEnable false;
        };
    };

    if (goggles CLib_Player != "") then {
        removeGoggles CLib_Player;
    };

    [{
        if (goggles CLib_Player != "") then {
            removeGoggles CLib_Player;
        };

        if (GVAR(aceMedicalLoaded)) then {
            CLib_Player setVariable ["ace_medical_allowdamage", false];
        };
        if (GVAR(aceHearingLoaded)) then {
            ACE_Hearing_deafnessDV = 0;
            ACE_Hearing_volume = 1;
        };
        if (GVAR(aceGogglesLoaded)) then {
            call ace_goggles_fnc_removeGlassesEffect;
            CLib_Player setVariable ["ace_goggles_Condition", [false,[false,0,0,0],false]];
            ace_goggles_PostProcess ppEffectEnable false;
            ace_goggles_PostProcessEyes ppEffectEnable false;
        };

        CLib_Player allowDamage false;
        CLib_Player setDamage 0;
        #ifndef ISDEV
            clearRadio;
        #endif

    }, 0] call CFUNC(addPerFrameHandler);

    ["enableSimulation", [CLib_Player, false]] call CFUNC(serverEvent);
    ["hideObject", [CLib_Player, true]] call CFUNC(serverEvent);
    CLib_Player allowDamage false;
    CLib_Player addEventHandler ["HandleDamage", {0}];

    // Disable BI
    "Terminate" call BIS_fnc_EGSpectator;

    (findDisplay 46) displayAddEventHandler ["MouseMoving", {_this call FUNC(mouseMovingEH)}];
    (findDisplay 46) displayAddEventHandler ["KeyDown", {_this call FUNC(keyDownEH)}];
    (findDisplay 46) displayAddEventHandler ["KeyUp", {_this call FUNC(keyUpEH)}];
    (findDisplay 46) displayAddEventHandler ["MouseZChanged", {_this call FUNC(mouseWheelEH)}];
    (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
        params ["", ["_button", -1, [0]]];
        if (_button == 0) then {
            GVAR(PlanningModeDrawing) = true;
        };
    }];
    (findDisplay 46) displayAddEventHandler ["MouseButtonUp", {
        params ["", ["_button", -1, [0]]];
        if (_button == 0) then {
            GVAR(PlanningModeDrawing) = false;
        };
    }];

    ["enableSimulation", [CLib_Player, false]] call CFUNC(serverEvent);
    ["hideObject", [CLib_Player, true]] call CFUNC(serverEvent);

    call FUNC(registerMenus);
    call FUNC(buildUI);
    [FUNC(cameraUpdateLoop), 0] call CFUNC(addPerFrameHandler);

    [{
        [{
            call FUNC(fixCamera);
        }, {
            (getPos GVAR(Camera)) distance (positionCameraToWorld [0,0,0]) > 2;
        }] call CFUNC(waitUntil);
    }, 0.5] call CFUNC(wait);

    QGVAR(updateMenu) call CFUNC(localEvent);
    QGVAR(spectatorOpened) call CFUNC(localEvent);
    [QGVAR(RegisterStreamator), CLib_Player] call CFUNC(serverEvent);
    [findDisplay 46, [PX(-1.5) ,0]] call CFUNC(registerDisplayNotification);
};

if (GVAR(aceSpectatorLoaded)) then {
    ["ace_spectatorSet", {
        params ["", "_player"];
        if (_player isEqualTo player && !isNull GVAR(Camera)) then {
            GVAR(Camera) cameraEffect ["internal", "back"];
            switchCamera CLib_Player;
            cameraEffectEnableHUD true;
        };
    }] call CBA_fnc_addEventHandler;
};

if (CLib_Player isKindof "VirtualSpectator_F" && side CLib_Player isEqualTo sideLogic) then {
    [_fnc_init, {
        (missionNamespace getVariable ["BIS_EGSpectator_initialized", false]) && !isNull findDisplay 60492;
    }] call CFUNC(waitUntil);
} else {
    call _fnc_init;
};

// Camera Update PFH
addMissionEventHandler ["Draw3D", {call FUNC(draw3dEH)}];

call FUNC(updateSpectatorArray);
[
    "SpectatorCamera", [["ICON", "\a3\ui_f\data\gui\rsc\rscdisplayegspectator\cameratexture_ca.paa", [0.5,0.5,1,1], GVAR(Camera), 20, 20, GVAR(Camera), "", 1, 0.08, "RobotoCondensed", "right", {
        _position = positionCameraToWorld [0, 0, 0];
        _angle = (positionCameraToWorld [0, 0, 0]) getDir (positionCameraToWorld [0, 0, 1]);
    }]]
] call CFUNC(addMapGraphicsGroup);

[{
    call FUNC(updateValidUnits);
}, 1] call CFUNC(addPerframeHandler);
call FUNC(updateValidUnits);
