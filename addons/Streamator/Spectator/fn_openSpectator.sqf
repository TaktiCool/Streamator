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
    GVAR(SideColorsArray) = false call CFUNC(createNamespace);
    GVAR(SideColorsArray) setVariable [str west, [0, 0.4, 0.8, 1]];
    GVAR(SideColorsArray) setVariable [str east, [0.6, 0, 0, 1]];
    GVAR(SideColorsArray) setVariable [str independent, [0, 0.5, 0, 1]];
    GVAR(SideColorsArray) setVariable [str civilian, [0.4, 0, 0.5, 1]];
};

if (isNil QGVAR(SideColorsString)) then {
    GVAR(SideColorsString) = false call CFUNC(createNamespace);
    GVAR(SideColorsString) setVariable [str west, "#0099EE"];
    GVAR(SideColorsString) setVariable [str east, "#CC3333"];
    GVAR(SideColorsString) setVariable [str independent, "#33CC33"];
    GVAR(SideColorsString) setVariable [str civilian, "#CC33CC"];
};

if (isNil QGVAR(PositionMemory)) then {
    GVAR(PositionMemory) = false call CFUNC(createNamespace);
};

if (isNil QGVAR(compatibleMagazinesNamespace)) then {
    GVAR(compatibleMagazinesNamespace) = false call CFUNC(createNamespace);
};

GVAR(Camera) = objNull;

GVAR(CameraPos) = [0, 0, 0];
GVAR(CameraDir) = getDirVisual CLib_player;
GVAR(CameraDirOffset) = 0;
GVAR(CameraPitch) = -45;
GVAR(CameraPitchOffset) = 0;
GVAR(CameraHeight) = 10;
GVAR(CameraSmoothingMode) = false;
GVAR(CameraSpeedMode) = false;
GVAR(CameraZoomMode) = false;
GVAR(CameraEditMode) = false;
GVAR(CameraSpeed) = 5;
GVAR(CameraMode) = 1; // 1: FREE | 2: FOLLOW | 3: SHOULDER | 4: TOPDOWN
GVAR(CameraFOV) = 0.75;
GVAR(CameraVision) = 9;
GVAR(CameraRelPos) = [0, 0, 0];
GVAR(CameraInFirstPerson) = false;

GVAR(CameraFollowTarget) = objNull;
GVAR(RadioFollowTarget) = objNull;

GVAR(CursorTarget) = objNull;
GVAR(lastCursorTarget) = time;
GVAR(lastUnitShooting) = objNull;

GVAR(CameraPreviousState) = [];
GVAR(CameraSmoothingTime) = 0.2;

GVAR(MapState) = [];
GVAR(MapOpen) = false;

GVAR(hideUI) = false;

GVAR(OverlayUnitMarker) = true;
GVAR(OverlayGroupMarker) = true;
GVAR(OverlayCustomMarker) = true;
GVAR(OverlayPlanningMode) = true;

GVAR(InputMode) = 0;
GVAR(InputScratchpad) = "";
GVAR(InputGuess) = [];
GVAR(InputGuessIndex) = 0;

GVAR(allSpectators) = [];
GVAR(UnitInfoOpen) = false;
GVAR(UnitInfoTarget) = objNull;

GVAR(PlanningModeChannel) = 0;
// ["#FF0000","#FFFF00","#0033FF","#CC66FF","#66FF66","#FF6600","#FFFFFF","#6699FF","#00FFFF","#99FF66","#339933","#FF0066","#CC3300","#0033CC"]
GVAR(PlanningModeColorRGB) = [[1,0,0],[1,1,0],[0,0.2,1],[0.8,0.4,1],[0.4,1,0.4],[1,0.4,0],[1,1,1],[0.4,0.6,1],[0,1,1],[0.6,1,0.4],[0.2,0.6,0.2],[1,0,0.4],[0.8,0.2,0],[0,0.2,0.8]];
GVAR(PlanningModeColor) = floor (random (count GVAR(PlanningModeColorRGB)));
CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];

GVAR(PlanningModeColorHTML) = GVAR(PlanningModeColorRGB) apply {_x call BIS_fnc_colorRGBtoHTML;};

GVAR(RadioInformationPrev) = [];

GVAR(ShoulderOffSet) = [0.4,-0.5,-0.3];
GVAR(TopDownOffset) = [0, 0, 100];
[QGVAR(InputModeChanged), {
    GVAR(InputScratchpad) = "";
    [QGVAR(updateInput)] call CFUNC(localEvent);
}] call CFUNC(addEventhandler);

["entityCreated", {
    (_this select 0) params ["_target"];
    if (_target isKindOf "CAManBase") then {
        _target addEventHandler ["FiredMan", {
            params ["_unit"];
            GVAR(lastUnitShooting) = _unit;
            _unit setVariable [QGVAR(lastShot), time];
            private _shots = _unit getVariable [QGVAR(shotCount), 0];
            _unit setVariable [QGVAR(shotCount), _shots + 1];
        }];
    };
}] call CFUNC(addEventhandler);

GVAR(lastFrameDataUpdate) = diag_frameNo;
[QGVAR(RequestCameraState), {
    if (GVAR(lastFrameDataUpdate) == diag_frameNo) exitWith {};
    CLib_player setVariable [QGVAR(State), [
        GVAR(CameraMode),
        GVAR(CameraFollowTarget),
        GVAR(CameraPos),
        GVAR(CameraRelPos),
        GVAR(CameraDir),
        GVAR(CameraPitch),
        GVAR(CameraFOV),
        GVAR(CameraVision),
        GVAR(CameraSmoothingTime),
        GVAR(ShoulderOffSet),
        GVAR(CameraDirOffset),
        GVAR(CameraPitchOffset),
        GVAR(TopdownOffset)
    ], true];
    GVAR(lastFrameDataUpdate) = diag_frameNo;
}] call CFUNC(addEventhandler);

DFUNC(updateSpectatorArray) = {
    GVAR(allSpectators) = ((entities "") select {_x call Streamator_fnc_isSpectator && _x != CLib_player});

    // hijack this for disabling the UI.
    private _temp = shownHUD;
    _temp set [1, false];
    _temp set [6, false];
    _temp set [7, true];
    showHUD _temp;

    [{
        call FUNC(updateSpectatorArray);
    }, 3] call CFUNC(wait);
};

DFUNC(createPlanningDisplay) = {
    if (GVAR(InputMode) == 2) then {
        if (isNull (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull])) then {
            private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
            uiNamespace setVariable [QGVAR(PlanningModeDisplay), _display];
            _display displayAddEventHandler ["MouseMoving", {_this call FUNC(mouseMovingEH)}];
            _display displayAddEventHandler ["KeyDown", {_this call FUNC(keyDownEH)}];
            _display displayAddEventHandler ["KeyUp", {_this call FUNC(keyUpEH)}];
            _display displayAddEventHandler ["MouseZChanged", {_this call FUNC(mouseWheelEH)}];
            _display displayAddEventHandler ["MouseButtonDown", {
                params ["", ["_button", -1, [0]]];
                if (_button == 0) then {
                    GVAR(PlanningModeDrawing) = true;
                };
            }];
            _display displayAddEventHandler ["MouseButtonUp", {
                params ["", ["_button", -1, [0]]];
                if (_button == 0) then {
                    GVAR(PlanningModeDrawing) = false;
                };
            }];
            _display displayAddEventHandler ["Unload", {
                if (!GVAR(MapOpen)) then {
                    GVAR(InputMode) = 0;
                    [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                    [{
                        (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
                    }] call CFUNC(execNextFrame);
                };
            }];
        };
    } else {
        (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
    };
};

private _fnc_init = {

    if (GVAR(TFARLoaded)) then {
        0 call TFAR_fnc_setVoiceVolume;
        CLib_Player setVariable ["tf_unable_to_use_radio", true];
        CLib_Player setVariable ["tf_forcedCurator", true];
    };

    if (GVAR(aceLoaded)) then {
        [CLib_Player] call ace_hearing_fnc_putInEarplugs;
    };

    [{
        if (GVAR(aceLoaded)) then {
            CLib_Player getVariable ["ACE_Medical_allowDamage", false];
            ACE_Hearing_deafnessDV = 0;
            ACE_Hearing_volume = 1;
        };
        CLib_Player setDamage 0;
    }, 0.5] call CFUNC(addPerFrameHandler);

    ["enableSimulation", [CLib_Player, false]] call CFUNC(serverEvent);
    ["hideObject", [CLib_Player, true]] call CFUNC(serverEvent);
    CLib_Player allowDamage false;

    // Disable BI
    ["Terminate"] call BIS_fnc_EGSpectator;
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

    call FUNC(buildUI);

    QGVAR(updateInput) call CFUNC(localEvent);

    [DFUNC(cameraUpdateLoop), 0] call CFUNC(addPerFrameHandler);
};

if (CLib_player isKindof "VirtualSpectator_F" && side CLib_player isEqualTo sideLogic) then {
    [_fnc_init, {
        (missionNamespace getVariable ["BIS_EGSpectator_initialized", false]) && !isNull findDisplay 60492;
    }] call CFUNC(waitUntil);
} else {
    call _fnc_init;
};

if (GVAR(TFARLoaded)) then {
    DFUNC(TFARRadio) = {
        if (GVAR(RadioFollowTarget) == GVAR(CameraFollowTarget)) then {
            GVAR(RadioFollowTarget) = objNull;
        } else {
            GVAR(RadioFollowTarget) = GVAR(CameraFollowTarget);
        };
        [QGVAR(radioFollowTargetChanged), [GVAR(RadioFollowTarget)]] call CFUNC(localEvent);
        if !(alive GVAR(RadioFollowTarget)) then {
            tf_lastFrequencyInfoTick = diag_tickTime - 1;
        };
    };

    [{
        if !(alive GVAR(RadioFollowTarget)) exitWith {
            if !(GVAR(RadioInformationPrev) isEqualTo []) then {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, [], (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1)]] call CFUNC(serverEvent);
                [QGVAR(radioInformationChanged), []] call CFUNC(localEvent);
                GVAR(RadioInformationPrev) = [];
            };
        };
        private _data = GVAR(RadioFollowTarget) getVariable [QGVAR(RadioInformation), [["No_SW_Radio"], ["No_LR_Radio"]]];
        if !(_data isEqualTo GVAR(RadioInformationPrev)) then {
            if (GVAR(RadioInformationPrev) isEqualTo []) then {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, (_data select 0) + (_data select 1), []]] call CFUNC(serverEvent);
            } else {
                [QGVAR(spectatorRadioInformationChanged), [CLib_Player, (_data select 0) + (_data select 1), (GVAR(RadioInformationPrev) select 0) + (GVAR(RadioInformationPrev) select 1)]] call CFUNC(serverEvent);
            };
            [QGVAR(radioInformationChanged), _data] call CFUNC(localEvent);
            GVAR(RadioInformationPrev) = +_data;
        };
        _data params ["_freqSW", "_freqLR"];
        if !("No_SW_Radio" in _freqSW) then {
            _freqSW = _freqSW apply {_x + "|7|0"};
        };
        if !("No_LR_Radio" in _freqLR) then {
            _freqLR = _freqLR apply {_x + "|7|0"};
        };
        TFAR_player_name = name CLib_player;
        private _request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13", str(_freqSW), str(_freqLR), "No_DD_Radio", false, 0, TF_dd_volume_level, TFAR_player_name, waves, 0, 1.0, 0, 1.0, TF_speakerDistance];
        private _result = "task_force_radio_pipe" callExtension _request;
        //DUMP("Listen To Radio: " + _result + " " + _request);
        tf_lastFrequencyInfoTick = diag_tickTime + 10;
    }, 0.5] call CFUNC(addPerFrameHandler);
};

// Camera Update PFH
addMissionEventHandler ["Draw3D", {call DFUNC(draw3dEH)}];

call FUNC(updateSpectatorArray);
[
    "SpectatorCamera", [["ICON", "\a3\ui_f\data\gui\rsc\rscdisplayegspectator\cameratexture_ca.paa", [0.5,0.5,1,1], GVAR(Camera), 20, 20, GVAR(Camera), "", 1, 0.08, "RobotoCondensed", "right", {
        _position = getPos GVAR(Camera);
        _angle = getDirVisual GVAR(Camera);
    }]]
] call CFUNC(addMapGraphicsGroup);
