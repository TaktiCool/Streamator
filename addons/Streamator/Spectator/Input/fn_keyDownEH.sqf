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
        if (GVAR(InputMode) == 1) exitWith {false};
        private _mapDisplay = uiNamespace getVariable [QGVAR(MapDisplay), displayNull];
        if (isNull _mapDisplay) then {
            GVAR(PlanningModeDrawing) = false;
            _mapDisplay = (findDisplay 46) createDisplay "RscDisplayEmpty";
            uiNamespace setVariable [QGVAR(MapDisplay), _mapDisplay];
            (_mapDisplay displayCtrl 1202) ctrlSetFade 1;
            (_mapDisplay displayCtrl 1202) ctrlCommit 0;

            private _map = _mapDisplay ctrlCreate ["RscMapControl", -1];
            _map ctrlSetPosition [safeZoneX + PX(BORDERWIDTH), safeZoneY + PY(BORDERWIDTH), safeZoneW - PX(2 * BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)];
            _map ctrlCommit 0;

            GVAR(MapOpen) = true;
            (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
            QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
            GVAR(MapState) params [["_zoom", 1], ["_position", getPos CLib_player]];

            _map ctrlMapAnimAdd [0, _zoom, _position];
            ctrlMapAnimCommit _map;

            [_map] call CFUNC(registerMapControl);
            _mapDisplay displayAddEventHandler ["KeyDown", {
                params ["_display", "_keyCode"];
                switch (_keyCode) do {
                    case DIK_ESCAPE;
                    case DIK_M: { // M
                        _display closeDisplay 1;
                        true;
                    };
                    case DIK_E: { // E
                        if !(_alt) exitWith {false};
                        with missionNamespace do {
                            if (GVAR(InputMode) == 0) then {
                                GVAR(InputMode) = 2;
                                [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                            } else {
                                GVAR(InputMode) = 0;
                                [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
                            };
                        };
                        true;
                    };
                    case DIK_F6: { // F6
                        with missionNamespace do {
                            GVAR(OverlayPlanningMode) = !GVAR(OverlayPlanningMode);
                        };
                        true
                    };
                    case DIK_F7: { // F7
                        with missionNamespace do {
                            GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
                        };
                        true;
                    };
                    case DIK_PGDN: { // Page Down
                        with missionNamespace do {
                            if (_ctrl) then {
                                GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) - 1) max 0;
                                CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                            } else {
                                GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) - 1) max 0;
                                CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                            };
                            QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
                        };
                        true;

                    };
                    case DIK_PGUP: { // Page Up
                        with missionNamespace do {
                            if (_ctrl) then {
                                GVAR(PlanningModeColor) = (GVAR(PlanningModeColor) + 1) min ((count GVAR(PlanningModeColorRGB) - 1));
                                CLib_Player setVariable [QGVAR(PlanningModeColor), GVAR(PlanningModeColor), true];
                            } else {
                                GVAR(PlanningModeChannel) = (GVAR(PlanningModeChannel) + 1) min 10;
                                CLib_Player setVariable [QGVAR(PlanningModeChannel), GVAR(PlanningModeChannel), true];
                            };
                            QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
                        };
                        true;
                    };
                    default {
                        true;
                    };
                };
            }];

            _map ctrlAddEventHandler ["MouseButtonClick", {
                params ["_map", "", "_xpos", "_ypos", "", "", "_alt"];
                if (_alt) exitWith {
                    with missionNamespace do {
                        GVAR(CameraPreviousState) = [];
                        private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
                        _pos pushBack (((getPos GVAR(Camera)) select 2) + getTerrainHeightASL _pos);
                        [objNull, 1] call FUNC(setCameraTarget);
                        GVAR(CameraPos) = _pos;
                    };
                    true;
                };
                false;
            }];

            _map ctrlAddEventHandler ["MouseMoving", {
                params ["_map", "_xPos", "_yPos"];
                with missionNamespace do {
                    if (GVAR(InputMode) == 2 && GVAR(PlanningModeDrawing)) then {
                        private _pos = _map ctrlMapScreenToWorld [_xPos, _yPos];
                        _pos set [2, 0];
                        [CLib_Player, QGVAR(cursorPosition), [[time, serverTime] select isMultiplayer, _pos], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
                    };
                };
            }];

            _map ctrlAddEventHandler  ["MouseButtonDown", {
                params ["", ["_button", -1, [0]]];
                with missionNamespace do {
                    if (_button == 0) then {
                        GVAR(PlanningModeDrawing) = true;
                    };
                };
            }];
            _map ctrlAddEventHandler  ["MouseButtonUp", {
                params ["", ["_button", -1, [0]]];
                with missionNamespace do {
                    if (_button == 0) then {
                        GVAR(PlanningModeDrawing) = false;
                    };
                };
            }];
            _map ctrlAddEventHandler ["Draw", {
                params [
                    ["_map", controlNull, [controlNull]]
                ];
                with missionNamespace do {
                    if (!GVAR(OverlayPlanningMode)) exitWith {};
                    {
                        private _unit = _x;
                        private _cursorPos = _unit getVariable QGVAR(cursorPosition);
                        private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
                        {
                            _x params ["_time", "_pos"];
                            private _alpha = 1 - (([time, serverTime] select isMultiplayer) - _time) max 0;
                            private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
                            _color set [3, _alpha];
                            private _text = "";
                            private _mapScale = ctrlMapScale _map;
                            private _textSize = PY(4);
                            if (_mapScale < 0.1) then {
                                _textSize = (_textSize * ((_mapScale / 0.1) max 0.5));
                            };
                            if (_alpha != 0) then {
                                if (_cursorPos isEqualTo _x) then {
                                    _color set [3, 1];
                                    _text = format ["%1", (_unit call CFUNC(name))];
                                    _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, 18, 18, 0, _text, 2, _textSize,  "RobotoCondensedBold", "right"];
                                    _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 2, _textSize,  "RobotoCondensedBold", "right"]
                                } else {
                                    _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 0, _textSize,  "RobotoCondensedBold", "right"];
                                };
                            };
                        } count _cursorHistory;
                        nil
                    } count ((GVAR(allSpectators) + [CLib_Player]) select {
                        (GVAR(PlanningModeChannel) == 0)
                         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
                         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
                    });
                };
            }];
            _map ctrlAddEventHandler ["Destroy", {
                params ["_map"];
                with missionNamespace do {
                    [_map] call CFUNC(unregisterMapControl);
                    private _pos = _map ctrlMapScreenToWorld [0.5, 0.5];
                    private _zoom = ctrlMapScale _map;
                    GVAR(MapState) = [_zoom, _pos];
                    GVAR(MapOpen) = false;
                    QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
                    GVAR(PlanningModeDrawing) = false;
                    [{
                        call FUNC(createPlanningDisplay);
                    }] call CFUNC(execNextFrame);
                };
            }];
        } else {
            _mapDisplay closeDisplay 1;
        };
        true
    };
    case DIK_F: { // F
        if (GVAR(InputMode) != 0) exitWith {false;};
        if (_ctrl) exitWith {
            GVAR(InputMode) = 1;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true;
        };
        if (_alt && !isNull GVAR(lastUnitShooting)) exitWith {
            [GVAR(lastUnitShooting)] call FUNC(setCameraTarget);
            true;
        };
        if (!isNull GVAR(CursorTarget) && {GVAR(CursorTarget) isKindOf "AllVehicles" && {!(GVAR(CursorTarget) isEqualTo GVAR(CameraFollowTarget))}}) then {
            GVAR(CameraRelPos) = getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CursorTarget);
            [GVAR(CursorTarget), 2] call FUNC(setCameraTarget);
        } else {
            [objNull, 1] call FUNC(setCameraTarget);
            true;
        };
    };
    case DIK_LSHIFT: { // LShift
        if (GVAR(InputMode) == 1) exitWith {false;};
        GVAR(CameraSpeedMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_LCONTROL: { // LCTRL
        if (GVAR(InputMode) == 1) exitWith {false;};
        GVAR(CameraSmoothingMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_LALT: { // LALT
        if (GVAR(InputMode) == 1) exitWith {false;};
        GVAR(CameraZoomMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false;
    };
    case DIK_ESCAPE: { // ESC
        if (GVAR(InputMode) == 1) exitWith {
            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true;
        };
        false;
    };
    case DIK_TAB: { // TAB
        if (GVAR(InputMode) == 1) exitWith {
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
        if (GVAR(InputMode) == 1) exitWith {false;};
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
        true;
    };
    case DIK_F8: { // F8
        if (GVAR(InputMode) != 0) exitWith {false;};
        QGVAR(toggleRadioUI) call CFUNC(localEvent);
        true;
    };
    case DIK_F9: { // F9
        if (GVAR(InputMode) != 0) exitWith {false;};
        call FUNC(setRadioFollowTarget);
        true;
    };
    case DIK_F10: {
        GVAR(Camera) cameraEffect ["internal", "back"];
        true;
    };
    case DIK_E: { // E
        if !(_ctrl) exitWith {false};
        if (GVAR(InputMode) == 0) then {
            GVAR(InputMode) = 2;
            GVAR(OverlayPlanningMode) = true;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            call FUNC(createPlanningDisplay);
        } else {
            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            (uiNamespace getVariable [QGVAR(PlanningModeDisplay), displayNull]) closeDisplay 1;
        };
        true;
    };
    case DIK_N: { // N
        if (GVAR(InputMode) == 1) exitWith {false};
        GVAR(CameraVision) = (GVAR(CameraVision) + 1) mod 10;
        call FUNC(setVisionMode);
        true;
    };
    case DIK_B: { // B
        if (GVAR(InputMode) == 1) exitWith {false};
        GVAR(CameraVision) = (GVAR(CameraVision) - 1);
        if (GVAR(CameraVision) == -1) then {
            GVAR(CameraVision) = 10;
        };
        call FUNC(setVisionMode);
        true;
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
        if (GVAR(InputMode) == 1) exitWith {false};
        if (_ctrl) then {
            [_keyCode] call FUNC(savePosition);
        } else {
            [_keyCode] call FUNC(restorePosition);
        };
        true;
    };

    case DIK_R: { // R
        if (GVAR(InputMode) != 0) exitWith {false;};
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
    case DIK_NUMPAD5;
    case DIK_NUMPAD4: {
        private _newCameraTarget = GVAR(CameraFollowTarget);
        if (GVAR(InputMode) == 0 && _keyCode == DIK_RETURN) exitWith {false};
        if (GVAR(InputMode) == 1) then {
            if !(GVAR(InputGuess) isEqualTo []) then {
                _newCameraTarget = ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1);
            };
            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
        };


        if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

        private _cameraMode = switch (_keyCode) do {
            case DIK_NUMPAD0: {
                _newCameraTarget = objNull;
                1;
            };
            case DIK_RETURN;
            case DIK_NUMPAD1: {2};
            case DIK_NUMPAD2: {3};
            case DIK_NUMPAD3: {5};
            case DIK_NUMPAD4: {4};
            case DIK_NUMPAD5: {6};
        };
        [_newCameraTarget, _cameraMode] call FUNC(setCameraTarget);
        true;
    };
    default {
        false
    };
};

if (!_return && GVAR(InputMode) == 1) then {
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
