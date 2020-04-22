#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    KeyDown-EH for the Spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: KeyCode <Number> (Default: 0)
    2: ShiftPressed <Bool> (Default: false)
    3: CtrlPressed <Bool> (Default: false)
    4: AltPressed <Bool> (Default: false)

    Returns:
    Event handled <Bool>
*/

params [
    "",
    ["_keyCode", 0, [0]],
    ["_shift", false, [true]],
    ["_ctrl", false, [true]],
    ["_alt", false, [true]]
];

private _return = switch (_keyCode) do {
    case DIK_M: { // M: Map
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        call FUNC(buildMapUI);
        true;
    };
    case DIK_F: { // F
        if (GVAR(InputMode) != INPUTMODE_MOVE) exitWith {false;};
        if (_ctrl) exitWith {
            GVAR(InputMode) = INPUTMODE_SEARCH;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true;
        };
        if (_alt && !isNull GVAR(lastUnitShooting)) exitWith {
            [GVAR(lastUnitShooting), [GVAR(CameraMode), CAMERAMODE_FOLLOW] select (GVAR(CameraMode) == CAMERAMODE_FREE)] call FUNC(setCameraTarget);
            true;
        };
        if (!isNull GVAR(CursorTarget) && {GVAR(CursorTarget) isKindOf "AllVehicles" && {!(GVAR(CursorTarget) isEqualTo GVAR(CameraFollowTarget))}}) then {
            GVAR(CameraRelPos) = getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CursorTarget);
            [GVAR(CursorTarget), CAMERAMODE_FOLLOW] call FUNC(setCameraTarget);
        } else {
            [objNull, CAMERAMODE_FREE] call FUNC(setCameraTarget);
            true;
        };
    };
    case DIK_LSHIFT: { // LShift
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        GVAR(CameraSpeedMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_LCONTROL: { // LCTRL
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        GVAR(CameraSmoothingMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_LALT: { // LALT
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        GVAR(CameraZoomMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_ESCAPE: { // ESC
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {
            GVAR(InputMode) = INPUTMODE_MOVE;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true;
        };
        false;
    };
    case DIK_TAB: { // TAB
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {
            GVAR(InputGuessIndex) = GVAR(InputGuessIndex) + ([1, -1] select _shift);
            if (GVAR(InputGuessIndex) < 0) then {
                GVAR(InputGuessIndex) = count GVAR(InputGuess) - 1;
            };
            if (GVAR(InputGuessIndex) >= count GVAR(InputGuess)) then {
                GVAR(InputGuessIndex) = 0;
            };
            [QGVAR(updateInput)] call CFUNC(localEvent);
            true
        };
        GVAR(CameraFOV) = 0.75;
        QGVAR(CameraFOVChanged) call CFUNC(localEvent);
        true
    };
    case DIK_BACKSPACE: { // BACKSPACE
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        QGVAR(toggleUI) call CFUNC(localEvent);
        true;
    };
    case DIK_F1: { // F1
        GVAR(OverlayGroupMarker) = !GVAR(OverlayGroupMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true;
    };
    case DIK_F2: { // F2
        GVAR(OverlayUnitMarker) = !GVAR(OverlayUnitMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true;
    };
    case DIK_F3: { // F3
        GVAR(OverlayCustomMarker) = !GVAR(OverlayCustomMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true;
    };
    case DIK_F5: { // F5
        if (!isNull GVAR(CameraFollowTarget)) then {
            if (GVAR(UnitInfoOpen)) then {
                QGVAR(CloseUnitInfo) call CFUNC(localEvent);
            } else {
                [QGVAR(OpenUnitInfo), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
            };
        } else {
            QGVAR(CloseUnitInfo) call CFUNC(localEvent);
        };
        true;
    };

    case DIK_F6: { // F6
        GVAR(OverlayPlanningMode) = !GVAR(OverlayPlanningMode);
        true
    };
    case DIK_F7: { // F7
        GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
        profileNamespace setVariable [QGVAR(RenderAIUnits), GVAR(RenderAIUnits)];
        saveProfileNamespace;
        true;
    };
    case DIK_F8: { // F8
        if (GVAR(InputMode) != INPUTMODE_MOVE) exitWith {false;};
        QGVAR(toggleRadioUI) call CFUNC(localEvent);
        true;
    };
    case DIK_F9: { // F9
        if (GVAR(InputMode) != INPUTMODE_MOVE) exitWith {false;};
        call FUNC(setRadioFollowTarget);
        true;
    };
    case DIK_F10: {
        GVAR(Camera) cameraEffect ["internal", "back"];
        switchCamera CLib_Player;
        cameraEffectEnableHUD true;
        true; // F10
    };
    case DIK_F11: { // F11
        GVAR(OverlayBulletTracer) = !GVAR(OverlayBulletTracer);
        GVAR(BulletTracers) = [];
    };
    case DIK_E: { // E
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        if !(_ctrl) exitWith {false};
        if (GVAR(InputMode) == INPUTMODE_MOVE) then {
            GVAR(InputMode) = INPUTMODE_PLANINGMODE;
            GVAR(OverlayPlanningMode) = true;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            call FUNC(createPlanningDisplay);
        } else {
            GVAR(InputMode) = INPUTMODE_MOVE;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
        };
        true;
    };
    case DIK_N: { // N
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        GVAR(CameraVision) = (GVAR(CameraVision) - 1);
        if (GVAR(CameraVision) == -1) then {
            GVAR(CameraVision) = 10;
        };
        call FUNC(setVisionMode);
        true;
    };
    case DIK_B: { // B
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        GVAR(CameraVision) = (GVAR(CameraVision) + 1) mod 10;
        call FUNC(setVisionMode);
        true;
    };
    case DIK_C: {
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        GVAR(CameraVision) = 9;
        call FUNC(setVisionMode);
    };
    case DIK_PGDN: { // Page Down
        if (_ctrl) then {
            GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) - 1) max 0;
            CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
        } else {
            GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) - 1) max 0;
            CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
        };
        QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
        true;
    };
    case DIK_PGUP: { // Page Up
        if (_ctrl) then {
            GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) + 1) min ((count GVAR(PlanningModeColorRGB) - 1));
            CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
        } else {
            GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) + 1) min 10;
            CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
        };
        QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
        true;
    };

    case DIK_1;
    case DIK_2;
    case DIK_3;
    case DIK_4;
    case DIK_5;
    case DIK_6;
    case DIK_7;
    case DIK_8;
    case DIK_9;
    case DIK_0: {
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        if (_ctrl) then {
            [_keyCode] call FUNC(savePosition);
        } else {
            [_keyCode] call FUNC(restorePosition);
        };
        true;
    };

    case DIK_R: { // R
        if (GVAR(InputMode) != INPUTMODE_MOVE) exitWith {false;};
        if (isNull GVAR(CameraFollowTarget)) exitWith {false;};
        switch (GVAR(CameraMode)) do {
            case 2: {
                [GVAR(CameraFollowTarget)] call FUNC(setCameraTarget);
                true;
            };
            case 3: {
                GVAR(ShoulderOffSet) = [0.4,-0.5,-0.3];
                true;
            };
            case 4: {
                GVAR(TopDownOffset) = [0, 0, 100];
                true;
            };
            case 6: {
                GVAR(CameraRelPos) = [0, 10, 10];
                true;
            };
            default {
                false;
            };
        };

    };

    case DIK_RETURN;
    case DIK_NUMPAD0;
    case DIK_NUMPAD1;
    case DIK_NUMPAD2;
    case DIK_NUMPAD3;
    case DIK_NUMPAD4;
    case DIK_NUMPAD5;
    case DIK_NUMPAD6: {
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        private _newCameraTarget = GVAR(CameraFollowTarget);
        if (GVAR(InputMode) == INPUTMODE_MOVE && _keyCode == DIK_RETURN) exitWith {false};
        if (GVAR(InputMode) == INPUTMODE_SEARCH) then {
            if !(GVAR(InputGuess) isEqualTo []) then {
                _newCameraTarget = ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1);
            };
            GVAR(InputMode) = INPUTMODE_MOVE;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
        };


        if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

        private _cameraMode = switch (_keyCode) do {
            case DIK_NUMPAD0: {
                _newCameraTarget = objNull;
                CAMERAMODE_FREE;
            };
            case DIK_RETURN: {
                if (GVAR(CameraMode) == CAMERAMODE_FREE) then {
                    CAMERAMODE_FOLLOW
                } else {
                    GVAR(CameraMode);
                };
            };
            case DIK_NUMPAD1: {CAMERAMODE_FOLLOW};
            case DIK_NUMPAD2: {CAMERAMODE_SHOULDER};
            case DIK_NUMPAD3: {CAMERAMODE_TOPDOWN};
            case DIK_NUMPAD4: {CAMERAMODE_FPS};
            case DIK_NUMPAD5: {CAMERAMODE_ORBIT};
            case DIK_NUMPAD6: {CAMERAMODE_UAV};
        };
        [_newCameraTarget, _cameraMode] call FUNC(setCameraTarget);
        true;
    };
    case DIK_V: {
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        QGVAR(ToggleMinimap) call CFUNC(localEvent);
        true;
    };
    default {
        false
    };
};

if (!_return && GVAR(InputMode) == INPUTMODE_SEARCH) then {
    private _char = [_keyCode, _shift] call FUNC(dik2char);
    if (_char != "") then {
        GVAR(InputScratchpad) = GVAR(InputScratchpad) + _char;
        QGVAR(updateGuess) call CFUNC(localEvent);
        QGVAR(updateInput) call CFUNC(localEvent);
        _return = true;
    } else {
        if (_keyCode == DIK_BACKSPACE) then { // BACKSPACE
            GVAR(InputScratchpad) = GVAR(InputScratchpad) select [0, count GVAR(InputScratchpad) - 1];
            QGVAR(updateGuess) call CFUNC(localEvent);
            QGVAR(updateInput) call CFUNC(localEvent);
            _return = true;
        };
    };
};

_return
