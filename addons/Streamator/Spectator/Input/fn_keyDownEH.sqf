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
    case DIK_LSHIFT: { // LShift
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        private _oldValue = GVAR(CameraSpeedMode);
        GVAR(CameraSpeedMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        if !(_oldValue) then {
            QGVAR(updateMenu) call CFUNC(localEvent);
        };
        false;
    };
    case DIK_LCONTROL: { // LCTRL
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        private _oldValue = GVAR(CameraSmoothingMode);
        GVAR(CameraSmoothingMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        if !(_oldValue) then {
            QGVAR(updateMenu) call CFUNC(localEvent);
        };
        false;
    };
    case DIK_LALT: { // LALT
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        private _oldValue = GVAR(CameraZoomMode);
        GVAR(CameraZoomMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        if !(_oldValue) then {
            QGVAR(updateMenu) call CFUNC(localEvent);
        };
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
            [QGVAR(updateMenu)] call CFUNC(localEvent);
            true
        };
        GVAR(CameraFOV) = 0.75;
        QGVAR(CameraFOVChanged) call CFUNC(localEvent);
        true
    };
    case DIK_BACKSPACE: { // BACKSPACE
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false;};
        QGVAR(toggleUI) call CFUNC(localEvent);
        call FUNC(updateValidUnits);
        true;
    };
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
        if (!isNull GVAR(CursorTarget) && {GVAR(CursorTarget) isKindOf "AllVehicles" && {(GVAR(CursorTarget) isNotEqualTo GVAR(CameraFollowTarget))}}) then {
            GVAR(CameraRelPos) = getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CursorTarget);
            [GVAR(CursorTarget), CAMERAMODE_FOLLOW] call FUNC(setCameraTarget);
        } else {
            [objNull, CAMERAMODE_FREE] call FUNC(setCameraTarget);
            true;
        };
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
        if (GVAR(CameraVision) == 9) then {
            GVAR(CameraVision) = GVAR(PrevCameraVision);
        } else {
            GVAR(PrevCameraVision) = GVAR(CameraVision);
            GVAR(CameraVision) = 9;
        };
        call FUNC(setVisionMode);
        true;
    };
    case DIK_V: { // V
        if (GVAR(InputMode) == INPUTMODE_SEARCH) exitWith {false};
        if (_shift) exitWith {
            GVAR(CenterMinimapOnCameraPositon) = !GVAR(CenterMinimapOnCameraPositon);
            QGVAR(updateMenu) call CFUNC(localEvent);
            if (!GVAR(MinimapVisible)) then {
                QGVAR(ToggleMinimap) call CFUNC(localEvent);
            };
        };
        QGVAR(ToggleMinimap) call CFUNC(localEvent);
        true;
    };
    case DIK_R: { // R
        if (GVAR(InputMode) != INPUTMODE_MOVE) exitWith {false};
        if (GVAR(CameraMode) == CAMERAMODE_FREE) exitWith {
            call FUNC(fixCamera);
            true;
        };
        if (isNull GVAR(CameraFollowTarget)) exitWith {false};
        [GVAR(CameraFollowTarget), GVAR(CameraMode)] call FUNC(setCameraTarget);
        true;
    };
    case DIK_MULTIPLY: { // NUM *
        if (!isNull GVAR(CameraFollowTarget)) then {
            if (GVAR(UnitInfoOpen)) then {
                QGVAR(CloseUnitInfo) call CFUNC(localEvent);
            } else {
                [QGVAR(OpenUnitInfo), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
            };
        } else {
            QGVAR(CloseUnitInfo) call CFUNC(localEvent);
        };
        QGVAR(updateMenu) call CFUNC(localEvent);
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
            [_keyCode, _alt] call FUNC(restorePosition);
        };
        true;
    };

    case DIK_RETURN;
    case DIK_NUMPAD0;
    case DIK_NUMPAD1;
    case DIK_NUMPAD2;
    case DIK_NUMPAD3;
    case DIK_NUMPAD4;
    case DIK_NUMPAD5: {
        if (GVAR(InputMode) == INPUTMODE_MOVE && _keyCode == DIK_RETURN) exitWith {false};
        private _newCameraTarget = GVAR(CameraFollowTarget);
        if (GVAR(InputMode) == INPUTMODE_SEARCH) then {
            if (GVAR(InputGuess) isNotEqualTo []) then {
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
        };
        [_newCameraTarget, _cameraMode, _alt] call FUNC(setCameraTarget);
        true;
    };
    default {
        false
    };
};

if (!_return && GVAR(InputMode) != INPUTMODE_SEARCH) then {
    _return = [GVAR(currentMenuPath), _keyCode] call FUNC(executeEntry);
};

if (!_return && GVAR(InputMode) == INPUTMODE_SEARCH) then {
    if (_keyCode == DIK_F5) exitWith {
        private _newRadioTarget = ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1);
        if (_newRadioTarget isEqualType objNull) then {
            _newRadioTarget call FUNC(setRadioFollowTarget);
            _return = true;
        };
    };
    private _char = [_keyCode, _shift] call FUNC(dik2char);
    if (_char != "") then {
        GVAR(InputScratchpad) = GVAR(InputScratchpad) + _char;
        QGVAR(updateGuess) call CFUNC(localEvent);
        QGVAR(updateMenu) call CFUNC(localEvent);
        _return = true;
    } else {
        if (_keyCode == DIK_BACKSPACE) then { // BACKSPACE
            GVAR(InputScratchpad) = GVAR(InputScratchpad) select [0, count GVAR(InputScratchpad) - 1];
            QGVAR(updateGuess) call CFUNC(localEvent);
            QGVAR(updateMenu) call CFUNC(localEvent);
            _return = true;
        };
    };
};
if (_keyCode >= DIK_F1 && _keyCode <= DIK_F12) then {
    _return = true;
};
_return
