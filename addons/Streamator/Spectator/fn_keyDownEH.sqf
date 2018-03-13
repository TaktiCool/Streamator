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
    ["_display", displayNull, [displayNull]],
    ["_keyCode", 0, [0]],
    ["_shift", false, [true]],
    ["_ctrl", false, [true]],
    ["_alt", false, [true]]
];

private _return = switch (_keyCode) do {
    case DIK_M: { // M: Map
        if (GVAR(InputMode) > 0) exitWith {false};

        private _mapDisplay = uiNamespace getVariable [QGVAR(MapDisplay), displayNull];
        if (isNull _mapDisplay) then {
            _mapDisplay = (findDisplay 46) createDisplay "RscDisplayEmpty";
            uiNamespace setVariable [QGVAR(MapDisplay), _mapDisplay];
            (_mapDisplay displayCtrl 1202) ctrlSetFade 1;
            (_mapDisplay displayCtrl 1202) ctrlCommit 0;

            private _map = _mapDisplay ctrlCreate ["RscMapControl", -1];
            _map ctrlSetPosition [safeZoneX + PX(BORDERWIDTH), safeZoneY + PY(BORDERWIDTH), safeZoneW - PX(2 * BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)];
            _map ctrlCommit 0;

            GVAR(MapOpen) = true;
            QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
            GVAR(MapState) params [["_zoom", 1], ["_position", getPos CLib_player]];

            _map ctrlMapAnimAdd [0, _zoom, _position];
            ctrlMapAnimCommit _map;

            [_map] call CFUNC(registerMapControl);
            GVAR(teleportMode) = false;
            _mapDisplay displayAddEventHandler ["KeyDown", {
                params ["_display", "_keyCode"];
                switch (_keyCode) do {
                    case DIK_M: { // M
                        _display closeDisplay 1;
                        true
                    };
                    case DIK_LCONTROL: {
                        GVAR(teleportMode) = true;
                        true;
                    };
                    default {
                        false
                    };
                };
            }];

            _mapDisplay displayAddEventHandler ["KeyUp", {
                params ["", "_keyCode"];
                switch (_keyCode) do {
                    case DIK_LCONTROL: {
                        GVAR(teleportMode) = false;
                        true;
                    };
                    default {
                        false
                    };
                };
            }];

            _map ctrlAddEventHandler ["MouseButtonClick", {
                params ["_map", "_button", "_xPos", "_yPos"];
                if (GVAR(teleportMode)) then {

                    private _pos = _map ctrlMapScreenToWorld [_xPos, _yPos];
                    _pos set [2, ((getPos GVAR(Camera)) select 2) + getTerrainHeightASL _pos];
                    GVAR(CameraPos) = _pos;
                };

            }];

            _map ctrlAddEventHandler ["Destroy", {
                params ["_map"];
                [_map] call CFUNC(unregisterMapControl);
                private _pos = _map ctrlMapScreenToWorld [0.5, 0.5];
                private _zoom = ctrlMapScale _map;
                GVAR(MapState) = [_zoom, _pos];
                GVAR(MapOpen) = false;
                QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open

            }];
        } else {
            _mapDisplay closeDisplay 1;
        };

        true
    };
    case DIK_F: { // F
        if (GVAR(InputMode) > 0) exitWith {false};
        if (_ctrl) exitWith {
            GVAR(InputMode) = 1;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
        if (_alt && !isNull GVAR(lastUnitShooting)) exitWith {
            GVAR(lastUnitShooting) call FUNC(setCameraTarget);
            true
        };
        if (!isNull GVAR(CursorTarget) && {GVAR(CursorTarget) isKindOf "AllVehicles" && {!(GVAR(CursorTarget) isEqualTo GVAR(CameraFollowTarget))}}) then {
            GVAR(CameraFollowTarget) = GVAR(CursorTarget);
            GVAR(CameraRelPos) = getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget);
            GVAR(CameraMode) = 2;
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
        } else {
            GVAR(CameraMode) = 1;
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
            true
        };
    };
    case DIK_LSHIFT: { // LShift
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraSpeedMode) = true;
        false
    };
    case DIK_LCONTROL: { // LCTRL
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraSmoothingMode) = true;
        false
    };
    case DIK_LALT: { // LCTRL
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraZoomMode) = true;
        false
    };
    case DIK_ESCAPE: { // ESC
        if (GVAR(InputMode) > 0) exitWith {
            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
        false
    };
    case DIK_TAB: { // TAB
        if (GVAR(InputMode) > 0) exitWith {
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
    case DIK_RETURN: { // RETURN
        if (GVAR(InputMode) == 1) exitWith {
            if !(GVAR(InputGuess) isEqualTo []) then {
                 ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1) call FUNC(setCameraTarget);
            };

            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
    };
    case DIK_BACKSPACE: { // BACKSPACE
        GVAR(InputMode) == 0
    };
    case DIK_F1: { // F1
        GVAR(OverlayGroupMarker) = !GVAR(OverlayGroupMarker);
        true
    };
    case DIK_F2: { // F2
        GVAR(OverlayUnitMarker) = !GVAR(OverlayUnitMarker);
        true
    };
    case DIK_F3: { // F3
        GVAR(OverlayCustomMarker) = !GVAR(OverlayCustomMarker);
        true
    };
    case DIK_N: { // N
        GVAR(CameraVision) = (GVAR(CameraVision) + 1) mod 10;
        switch (GVAR(CameraVision)) do {
            case (9): {
                camUseNVG false;
                false setCamUseTi 0;
            };
            case (8): {
                camUseNVG true;
                false setCamUseTi 0;
            };
            default {
                camUseNVG false;
                true setCamUseTi GVAR(CameraVision);
            };
        };
    };

    default {
        false
    };
};

if (!_return && GVAR(InputMode) > 0) then {
    private _char = [_keyCode, _shift] call FUNC(dik2char);
    if (_char != "") then {
        GVAR(InputScratchpad) = GVAR(InputScratchpad) + _char;
        [QGVAR(updateGuess)] call CFUNC(localEvent);
        [QGVAR(updateInput)] call CFUNC(localEvent);
        _return = true;
    } else {
        if (_keyCode == DIK_BACKSPACE) then { // BACKSPACE
            GVAR(InputScratchpad) = GVAR(InputScratchpad) select [0, count GVAR(InputScratchpad) - 1];
            [QGVAR(updateGuess)] call CFUNC(localEvent);
            [QGVAR(updateInput)] call CFUNC(localEvent);
            _return = true;
        };
    };
};

_return
