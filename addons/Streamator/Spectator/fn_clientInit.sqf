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

if !(side CLib_player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};

GVAR(SideColorsArray) = false call CFUNC(createNamespace);
GVAR(SideColorsArray) setVariable [str west, [0, 0.4, 0.8, 1]];
GVAR(SideColorsArray) setVariable [str east, [0.6, 0, 0, 1]];
GVAR(SideColorsArray) setVariable [str independent, [0, 0.5, 0, 1]];
GVAR(SideColorsArray) setVariable [str civilian, [0.5, 0.5, 0, 1]];

GVAR(SideColorsString) = false call CFUNC(createNamespace);
GVAR(SideColorsString) setVariable [str west, "#0099EE"];
GVAR(SideColorsString) setVariable [str east, "#CC3333"];
GVAR(SideColorsString) setVariable [str independent, "#33CC33"];
GVAR(SideColorsString) setVariable [str civilian, "#CCCC33"];

GVAR(Camera) = objNull;
GVAR(CameraPos) = [0, 0, 0];
GVAR(CameraDir) = getDirVisual CLib_player;
GVAR(CameraDirOffset) = 0;
GVAR(CameraPitch) = -45;
GVAR(CameraPitchOffset) = 0;
GVAR(CameraHeight) = 100;
GVAR(CameraSmoothingMode) = false;
GVAR(CameraSpeedMode) = false;
GVAR(CameraOffsetMode) = false;
GVAR(CameraSpeed) = 5;
GVAR(CameraMode) = 1; // 1: FREE | 2: FOLLOW
GVAR(CameraFOV) = 0.75;
GVAR(CameraRelPos) = [0, 0, 0];
GVAR(CameraFollowTarget) = objNull;
GVAR(CursorTarget) = objNull;
GVAR(CameraPreviousState) = [];
GVAR(CameraSmoothingTime) = 0.2;
GVAR(MapState) = [];

GVAR(OverlayUnitMarker) = true;
GVAR(OverlayGroupMarker) = true;
GVAR(OverlaySectorMarker) = true;

GVAR(InputMode) = 0;
GVAR(InputScratchpad) = "";
GVAR(InputGuess) = [];
GVAR(InputGuessIndex) = 0;

// small helper function
DFUNC(getDefaultIcon) = {
    params ["_side"];
    switch (_side) do {
        case (west): {
            "b_unknown"
        };
        case (east): {
            "o_unknown"
        };
        case (independent): {
            "n_unknown"
        };
        case (civilian): {
            "c_unknown"
        };
        default {
            "hd_unknown"
         };
    };
};

// Small helper functions
DFUNC(dik2Char) = {
    params ["_dik", "_shift"];

    private _char = switch (_dik) do {
        case DIK_A: {"a"};
        case DIK_B: {"b"};
        case DIK_C: {"c"};
        case DIK_D: {"d"};
        case DIK_E: {"e"};
        case DIK_F: {"f"};
        case DIK_G: {"g"};
        case DIK_H: {"h"};
        case DIK_I: {"i"};
        case DIK_J: {"j"};
        case DIK_K: {"k"};
        case DIK_L: {"l"};
        case DIK_M: {"m"};
        case DIK_N: {"n"};
        case DIK_O: {"o"};
        case DIK_P: {"p"};
        case DIK_Q: {"q"};
        case DIK_R: {"r"};
        case DIK_S: {"s"};
        case DIK_T: {"t"};
        case DIK_U: {"u"};
        case DIK_V: {"v"};
        case DIK_W: {"w"};
        case DIK_X: {"x"};
        case DIK_Y: {"y"};
        case DIK_Z: {"z"};
        case DIK_SPACE: {" "};
        case DIK_0: {"0"};
        case DIK_1: {"1"};
        case DIK_2: {"2"};
        case DIK_3: {"3"};
        case DIK_4: {"4"};
        case DIK_5: {"5"};
        case DIK_6: {"6"};
        case DIK_7: {"7"};
        case DIK_8: {"8"};
        case DIK_9: {"9"};
        default {""};
    };
    [_char, toUpper _char] select _shift
};

[QGVAR(InputModeChanged), {
    GVAR(InputScratchpad) = "";
    [QGVAR(updateInput)] call CFUNC(localEvent);
}] call CFUNC(addEventhandler);

[{
    // Disable BI
    ["Terminate"] call BIS_fnc_EGSpectator;

    // Create Camera
    ["enableSimulation", [CLib_Player, false]] call CFUNC(serverEvent);
    ["hideObject", [CLib_Player, true]] call CFUNC(serverEvent);

    GVAR(Camera) = "Camera" camCreate (eyePos CLib_player);
    GVAR(Camera) cameraEffect ["internal", "back"];
    CLib_player attachTo [GVAR(Camera), [0, 0, 0]];
    GVAR(CameraPos) = (eyePos CLib_player) vectorAdd [0, 0, GVAR(CameraHeight)];
    showCinemaBorder false;
    cameraEffectEnableHUD true;

    // Create On Screen Display
    UIVAR(SpectatorScreen) cutRsc ["RscTitleDisplayEmpty", "PLAIN"];
    private _display = uiNamespace getVariable ["RscTitleDisplayEmpty", displayNull];
    if (isNull _display) exitWith {};

    uiNamespace setVariable [QGVAR(SpectatorControlDisplay), _display];

    (_display displayCtrl 1202) ctrlSetFade 1;
    (_display displayCtrl 1202) ctrlShow false;
    (_display displayCtrl 1202) ctrlCommit 0;

    // Create Black Border
    {
        private _tempCtrl = _display ctrlCreate ["RscPicture", -1];
        _tempCtrl ctrlSetPosition _x;
        _tempCtrl ctrlSetText "#(argb,8,8,3)color(0,0,0,1)";
        _tempCtrl ctrlCommit 0;
    } count [
        [safeZoneX, safeZoneY + PY(BORDERWIDTH), PX(BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)],
        [safeZoneX + safeZoneW - PX(BORDERWIDTH), safeZoneY + PY(BORDERWIDTH), PX(BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)],
        [safeZoneX, safeZoneY, safeZoneW, PY(BORDERWIDTH)],
        [safeZoneX, safeZoneY + safeZoneH - PY(BORDERWIDTH), safeZoneW, PY(BORDERWIDTH)]
    ];

    // Create Mode
    private _ctrlInfo = _display ctrlCreate ["RscStructuredText", -1];
    _ctrlInfo ctrlSetPosition [safeZoneX + PX(0.3 + BORDERWIDTH), safeZoneY + PY(0.3), safeZoneW - PX(2 * (0.3 + BORDERWIDTH)), PY(1.8)];
    _ctrlInfo ctrlSetFontHeight PY(1.5);
    _ctrlInfo ctrlSetFont "RobotoCondensed";
    _ctrlInfo ctrlSetText "[F] Follow Target    [CTRL + F] Follow Unit/Squad/Objective    [M] Map    [TAB] Reset FOV";
    _ctrlInfo ctrlCommit 0;

    private _ctrlCameraMode = _display ctrlCreate ["RscStructuredText", -1];
    _ctrlCameraMode ctrlSetPosition [safeZoneX + safeZoneW - PY(22), safeZoneY + PY(0.3), PX(20), PY(1.8)];
    _ctrlCameraMode ctrlSetFontHeight PY(1.5);
    _ctrlCameraMode ctrlSetFont "RobotoCondensedBold";
    _ctrlCameraMode ctrlSetStructuredText parseText "<t align='right'>FREE</t>";
    _ctrlCameraMode ctrlCommit 0;

    private _ctrlTargetInfo = _display ctrlCreate ["RscTextNoShadow", -1];
    _ctrlTargetInfo ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH + PY(0.3 - BORDERWIDTH), safeZoneW, PY(1.8)];
    _ctrlTargetInfo ctrlSetFontHeight PY(1.5);
    _ctrlTargetInfo ctrlSetFont "RobotoCondensedBold";
    _ctrlTargetInfo ctrlSetText "Target Info";
    _ctrlTargetInfo ctrlCommit 0;

    private _ctrlMouseSpeedBarBg = _display ctrlCreate ["RscPicture", -1];
    _ctrlMouseSpeedBarBg ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4), safeZoneY + PY(2 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
    _ctrlMouseSpeedBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
    _ctrlMouseSpeedBarBg ctrlCommit 0;

    private _relLength = sqrt GVAR(CameraSpeed) / sqrt CAMERAMAXSPEED;
    private _ctrlMouseSpeedBar = _display ctrlCreate ["RscPicture", -1];
    _ctrlMouseSpeedBar ctrlSetPosition [
        safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
        safeZoneY + PY(2 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        _relLength * PY(BORDERWIDTH * 4)
    ];
    _ctrlMouseSpeedBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
    _ctrlMouseSpeedBar ctrlCommit 0;

    private _ctrlMouseSpeedLabel = _display ctrlCreate ["RscTextNoShadow", -1];
    _ctrlMouseSpeedLabel ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH), safeZoneY + PY(6 * BORDERWIDTH), PX(BORDERWIDTH), PY(BORDERWIDTH)];
    _ctrlMouseSpeedLabel ctrlSetFontHeight PY(1.5);
    _ctrlMouseSpeedLabel ctrlSetFont "RobotoCondensedBold";
    _ctrlMouseSpeedLabel ctrlSetText "SPD";
    _ctrlMouseSpeedLabel ctrlCommit 0;

    private _ctrlMouseSmoothingBarBg = _display ctrlCreate ["RscPicture", -1];
    _ctrlMouseSmoothingBarBg ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4), safeZoneY + PY(8 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
    _ctrlMouseSmoothingBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
    _ctrlMouseSmoothingBarBg ctrlCommit 0;

    private _relLength = sqrt GVAR(CameraSmoothingTime) / sqrt 1.6;
    private _ctrlMouseSmoothingBar = _display ctrlCreate ["RscPicture", -1];
    _ctrlMouseSmoothingBar ctrlSetPosition [
        safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
        safeZoneY + PY(8 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        PY(BORDERWIDTH * 4) * _relLength
    ];
    _ctrlMouseSmoothingBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
    _ctrlMouseSmoothingBar ctrlCommit 0;

    private _ctrlMouseSmoothingLabel = _display ctrlCreate ["RscTextNoShadow", -1];
    _ctrlMouseSmoothingLabel ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH), safeZoneY + PY(12 * BORDERWIDTH), PX(BORDERWIDTH), PY(BORDERWIDTH)];
    _ctrlMouseSmoothingLabel ctrlSetFontHeight PY(1.2);
    _ctrlMouseSmoothingLabel ctrlSetFont "RobotoCondensedBold";
    _ctrlMouseSmoothingLabel ctrlSetText "SMTH";
    _ctrlMouseSmoothingLabel ctrlCommit 0;


    private _ctrlFOVBarBg = _display ctrlCreate ["RscPicture", -1];
    _ctrlFOVBarBg ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4), safeZoneY + PY(14 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
    _ctrlFOVBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
    _ctrlFOVBarBg ctrlCommit 0;

    private _relLength = (2 - GVAR(CameraFOV)) / 2;
    private _ctrlFOVBar = _display ctrlCreate ["RscPicture", -1];
    _ctrlFOVBar ctrlSetPosition [
        safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
        safeZoneY + PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        PY(BORDERWIDTH * 4) * _relLength
    ];
    _ctrlFOVBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
    _ctrlFOVBar ctrlCommit 0;

    private _ctrlFOVLabel = _display ctrlCreate ["RscTextNoShadow", -1];
    _ctrlFOVLabel ctrlSetPosition [safeZoneX + safeZoneW - PX(BORDERWIDTH), safeZoneY + PY(18 * BORDERWIDTH), PX(BORDERWIDTH), PY(BORDERWIDTH)];
    _ctrlFOVLabel ctrlSetFontHeight PY(1.2);
    _ctrlFOVLabel ctrlSetFont "RobotoCondensedBold";
    _ctrlFOVLabel ctrlSetText "FOV";
    _ctrlFOVLabel ctrlCommit 0;

    private _ctrlFOVDefaultLine = _display ctrlCreate ["RscPicture", -1];
    _ctrlFOVDefaultLine ctrlSetPosition [
        safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
        safeZoneY + PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        PY(1)
    ];
    _ctrlFOVDefaultLine ctrlSetText "#(argb,8,8,3)color(1,1,0,0)";
    _ctrlFOVDefaultLine ctrlCommit 0;

    [QGVAR(CameraSpeedChanged), {
        (_this select 1) params ["_ctrl"];
        private _relLength = sqrt GVAR(CameraSpeed) / sqrt CAMERAMAXSPEED;
        _ctrl ctrlSetPosition [
            safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
            safeZoneY + PY(2 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
            PX(BORDERWIDTH / 2),
            _relLength * PY(BORDERWIDTH * 4)
        ];
        _ctrl ctrlCommit 0;
    }, _ctrlMouseSpeedBar] call CFUNC(addEventhandler);

    [QGVAR(CameraSmoothingChanged), {
        (_this select 1) params ["_ctrl"];
        private _relLength = sqrt GVAR(CameraSmoothingTime) / sqrt 1.6;
        _ctrl ctrlSetPosition [
            safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
            safeZoneY + PY(8 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
            PX(BORDERWIDTH / 2),
            PY(BORDERWIDTH * 4) * _relLength
        ];
        _ctrl ctrlCommit 0;
    }, _ctrlMouseSmoothingBar] call CFUNC(addEventhandler);

    [QGVAR(CameraFOVChanged), {
        (_this select 1) params ["_ctrl"];
        private _relLength = (2 - GVAR(CameraFOV)) / 2;
        _ctrl ctrlSetPosition [
            safeZoneX + safeZoneW - PX(BORDERWIDTH * 3 / 4),
            safeZoneY + PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
            PX(BORDERWIDTH / 2),
            PY(BORDERWIDTH * 4) * _relLength
        ];
        _ctrl ctrlCommit 0;
    }, _ctrlFOVBar] call CFUNC(addEventhandler);


    [QGVAR(CursorTargetChanged), {
        (_this select 0) params ["_target"];
        (_this select 1) params ["_ctrl"];
        _ctrl ctrlSetText format ["%1 [%2]", str _target, _target call CFUNC(name)];
        _ctrl ctrlCommit 0;
    }, _ctrlTargetInfo] call CFUNC(addEventhandler);

    [QGVAR(CameraModeChanged), {
        (_this select 0) params ["_mode"];
        (_this select 1) params ["_ctrl"];

        private _textMode = ["FREE", format ["FOLLOW [%1]", GVAR(CameraFollowTarget) call CFUNC(name)]] select (_mode - 1);

        _ctrl ctrlSetStructuredText parseText format ["<t align='right'>%1</t>", _textMode];
        _ctrl ctrlCommit 0;
    }, _ctrlCameraMode] call CFUNC(addEventhandler);

    [QGVAR(updateGuess), {
        (_this select 1) params ["_ctrl"];

        private _str = switch (GVAR(InputMode)) do {
            case 1: { // Search FOLLOW Target
                private _searchStr = GVAR(InputScratchpad);
                GVAR(InputGuessIndex) = 0;
                if (_searchStr != "") then {
                    _searchStr = toLower _searchStr;
                    private _guess = [];
                    {
                        private _name = (_x call CFUNC(name));
                        private _index = toLower _name find _searchStr;
                        if (_index >= 0) then {
                            _guess pushBack [_index, _x, _name];
                        };
                        if (leader group _x == _x) then {
                            private _name = groupId group _x;
                            private _index = toLower _name find _searchStr;
                            if (_index >= 0) then {
                                _guess pushBack [_index, _x, _name];
                            };
                        };
                        false;
                    } count allUnits;

                    if !(_guess isEqualTo []) then {
                        _guess sort true;
                    };

                    GVAR(InputGuess) = _guess;
                };
            };
            default {};
        };

        _ctrl ctrlSetStructuredText parseText _str;
        _ctrl ctrlCommit 0;
    }] call CFUNC(addEventhandler);

    [QGVAR(updateInput), {
        (_this select 1) params ["_ctrl"];

        private _str = switch (GVAR(InputMode)) do {
            case 1: { // Search FOLLOW Target
                private _searchStr = GVAR(InputScratchpad);
                private _temp = "<t color='#cccccc'>Search for Target: </t>";
                systemChat GVAR(InputScratchpad);
                if (_searchStr != "") then {
                    private _guess = +GVAR(InputGuess);
                    if !(_guess isEqualTo []) then {
                        if (GVAR(InputGuessIndex) >= count _guess) then {
                            GVAR(InputGuessIndex) = 0;
                        };
                        private _friendlySide = (EGVAR(Common,competingSides)) select 0;

                        _guess = _guess select [GVAR(InputGuessIndex), count _guess];
                        private _bestGuess = _guess select 0;
                        private _guessStr = _guess apply {
                            format [
                                "<t color='%1'>%2</t>",
                                ["#CC3333", "#0099EE"] select ((side group (_x select 1)) isEqualTo _friendlySide),
                                (_x select 2)
                            ]
                        };
                        _guessStr deleteAt 0;

                        if (GVAR(InputGuessIndex) > 0) then {
                            _temp = _temp + "<img size='0.5' image='\A3\ui_f\data\gui\rsccommon\rschtml\arrow_left_ca.paa'/>";
                        };
                        private _color = ["#CC3333", "#0099EE"] select ((side group (_bestGuess select 1)) isEqualTo _friendlySide);

                        _temp = _temp + format ["<t color='%1'>%2</t>", _color, ((_bestGuess select 2) select [0, _bestGuess select 0])];
                        _temp = _temp + format ["<t color='#ffffff' shadowColor='%1' shadow='1'>%2</t>", _color, ((_bestGuess select 2) select [_bestGuess select 0, count _searchStr])];
                        _temp = _temp + format ["<t color='%1'>%2</t>", _color, ((_bestGuess select 2) select [(_bestGuess select 0) + count _searchStr])];
                        if (!(_guessStr isEqualTo [])) then {
                            _temp = _temp + "<t color='#cccccc'> | " + (_guessStr joinString " | ") + "</t>";
                        };
                    } else {
                        _temp = _temp + _searchStr + "| <t color='#cccccc'>NO RESULT</t>";
                    };
                } else {
                    _temp = _temp + _searchStr + "| ";
                };

                _temp
            };
            default {
                "[F] Follow Cursor Target    [CTRL + F] Follow Unit/Squad/Objective    [M] Map    [F1] Toggle Group Overlay    [F2] Toggle Unit Overlay    [F3] Toggle Sector Overlay    [TAB] Reset FOV"
            };
        };

        _ctrl ctrlSetStructuredText parseText _str;
        _ctrl ctrlCommit 0;
    }, _ctrlInfo] call CFUNC(addEventhandler);

    [QGVAR(updateInput)] call CFUNC(localEvent);

    (findDisplay 46) displayAddEventHandler ["MouseMoving", {_this call FUNC(mouseMovingEH)}];
    (findDisplay 46) displayAddEventHandler ["KeyDown", {_this call FUNC(keyDownEH)}];
    (findDisplay 46) displayAddEventHandler ["KeyUp", {_this call FUNC(keyUpEH)}];
    (findDisplay 46) displayAddEventHandler ["MouseZChanged", {_this call FUNC(mouseWheelEH)}];
}, {
    (missionNamespace getVariable ["BIS_EGSpectator_initialized", false]) && !isNull findDisplay 60492;
}] call CFUNC(waitUntil);

// Camera Update PFH
addMissionEventHandler ["Draw3D", {call DFUNC(draw3dEH)}];

[DFUNC(cameraUpdateLoop), 0] call CFUNC(addPerFrameHandler);
