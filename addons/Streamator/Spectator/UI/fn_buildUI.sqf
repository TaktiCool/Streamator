#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/

// Create Camera
GVAR(Camera) = "Camera" camCreate (eyePos CLib_Player);
GVAR(Camera) cameraEffect ["internal", "back"];
switchCamera CLib_Player;
CLib_Player attachTo [GVAR(Camera), [0, 0, 0]];
GVAR(CameraPos) = (eyePos CLib_Player) vectorAdd [0, 0, GVAR(CameraHeight)];
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

private _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_ctrlGrp ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
_ctrlGrp ctrlCommit 0;

// Create Black Border
{
    private _tempCtrl = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
    _tempCtrl ctrlSetPosition _x;
    _tempCtrl ctrlSetText "#(argb,8,8,3)color(0,0,0,1)";
    _tempCtrl ctrlCommit 0;
} count [
    [0,  PY(BORDERWIDTH), PX(BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)],
    [safeZoneW - PX(BORDERWIDTH), PY(BORDERWIDTH), PX(BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)],
    [0, 0, safeZoneW, PY(BORDERWIDTH)],
    [0, safeZoneH - PY(BORDERWIDTH), safeZoneW, PY(BORDERWIDTH)]
];

// Create Mode
private _ctrlInfo = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlInfo ctrlSetPosition [PX(0.3 + BORDERWIDTH), PY(0.3), safeZoneW - PX(2 * (0.3 + BORDERWIDTH)), PY(1.8)];
_ctrlInfo ctrlSetFontHeight PY(1.5);
_ctrlInfo ctrlSetFont "RobotoCondensed";
_ctrlInfo ctrlSetText (GVAR(currentMenuPath) call FUNC(renderMenu));
_ctrlInfo ctrlCommit 0;

private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);

private _ctrlCameraMode = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlCameraMode ctrlSetPosition [safeZoneW - PX(21),  PY(0.3), PX(20), PY(1.8)];
_ctrlCameraMode ctrlSetFont "RobotoCondensedBold";
_ctrlCameraMode ctrlSetStructuredText parseText format ["<t align='right' size='%1'>FREE</t>", _smallTextSize];
_ctrlCameraMode ctrlCommit 0;

private _ctrlTargetInfo = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrp];
_ctrlTargetInfo ctrlSetPosition [0, safeZoneH + PY(0.3 - BORDERWIDTH), safeZoneW, PY(1.8)];
_ctrlTargetInfo ctrlSetFontHeight PY(1.5);
_ctrlTargetInfo ctrlSetFont "RobotoCondensedBold";
_ctrlTargetInfo ctrlSetText "Target Info";
_ctrlTargetInfo ctrlCommit 0;

private _ctrlTargetSpeedInfo = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlTargetSpeedInfo ctrlSetPosition [safeZoneW - PX(25),  PY(0.3), PX(20), PY(1.8)];
_ctrlTargetSpeedInfo ctrlSetFont "RobotoCondensedBold";
_ctrlTargetSpeedInfo ctrlSetText "";
_ctrlTargetSpeedInfo ctrlCommit 0;

private _ctrlMouseSpeedBarBg = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlMouseSpeedBarBg ctrlSetPosition [safeZoneW - PX(BORDERWIDTH * 3 / 4), PY(2 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
_ctrlMouseSpeedBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
_ctrlMouseSpeedBarBg ctrlCommit 0;

private _relLength = sqrt GVAR(CameraSpeed) / sqrt CAMERAMAXSPEED;
private _ctrlMouseSpeedBar = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlMouseSpeedBar ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH * 3 / 4),
    PY(2 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
    PX(BORDERWIDTH / 2),
    _relLength * PY(BORDERWIDTH * 4)
];
_ctrlMouseSpeedBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
_ctrlMouseSpeedBar ctrlCommit 0;

private _ctrlMouseSpeedLabel = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrp];
_ctrlMouseSpeedLabel ctrlSetPosition [safeZoneW - PX(BORDERWIDTH), PY(6 * BORDERWIDTH), PX(BORDERWIDTH), PY(BORDERWIDTH)];
_ctrlMouseSpeedLabel ctrlSetFontHeight PY(1.5);
_ctrlMouseSpeedLabel ctrlSetFont "RobotoCondensedBold";
_ctrlMouseSpeedLabel ctrlSetText "SPD";
_ctrlMouseSpeedLabel ctrlCommit 0;

private _ctrlMouseSmoothingBarBg = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlMouseSmoothingBarBg ctrlSetPosition [safeZoneW - PX(BORDERWIDTH * 3 / 4), PY(8 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
_ctrlMouseSmoothingBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
_ctrlMouseSmoothingBarBg ctrlCommit 0;

private _relLength = sqrt GVAR(CameraSmoothingTime) / sqrt 1.6;
private _ctrlMouseSmoothingBar = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlMouseSmoothingBar ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH * 3 / 4),
    PY(8 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
    PX(BORDERWIDTH / 2),
    PY(BORDERWIDTH * 4) * _relLength
];
_ctrlMouseSmoothingBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
_ctrlMouseSmoothingBar ctrlCommit 0;

private _ctrlMouseSmoothingLabel = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrp];
_ctrlMouseSmoothingLabel ctrlSetPosition [safeZoneW - PX(BORDERWIDTH), PY(12 * BORDERWIDTH), PX(BORDERWIDTH), PY(BORDERWIDTH)];
_ctrlMouseSmoothingLabel ctrlSetFontHeight PY(1.2);
_ctrlMouseSmoothingLabel ctrlSetFont "RobotoCondensedBold";
_ctrlMouseSmoothingLabel ctrlSetText "SMTH";
_ctrlMouseSmoothingLabel ctrlCommit 0;

private _ctrlFOVBarBg = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlFOVBarBg ctrlSetPosition [safeZoneW - PX(BORDERWIDTH * 3 / 4), PY(14 * BORDERWIDTH), PX(BORDERWIDTH / 2), PY(BORDERWIDTH * 4)];
_ctrlFOVBarBg ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,1)";
_ctrlFOVBarBg ctrlCommit 0;

private _logScale = (ln GVAR(CameraFOV)) / ln sqrt 2;
private _logScaleMin = (ln (sqrt(2)^-14)) / ln sqrt 2;
private _logScaleMax = (ln 2) / ln sqrt 2;
private _relLength = linearConversion [_logScaleMin, _logScaleMax, _logScale, 0, 1];
private _ctrlFOVBar = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlFOVBar ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH * 3 / 4),
    PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
    PX(BORDERWIDTH / 2),
    PY(BORDERWIDTH * 4) * _relLength
];
_ctrlFOVBar ctrlSetText "#(argb,8,8,3)color(1,1,1,1)";
_ctrlFOVBar ctrlCommit 0;

private _ctrlFOVBarCurrent = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlFOVBarCurrent ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH * 3 / 4),
    PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
    PX(BORDERWIDTH / 8),
    PY(BORDERWIDTH * 4) * _relLength
];
_ctrlFOVBarCurrent ctrlSetText "#(argb,8,8,3)color(0,0,1,1)";
_ctrlFOVBarCurrent ctrlCommit 0;

private _ctrlFOVLabel = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrp];
_ctrlFOVLabel ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH),
    PY(18 * BORDERWIDTH),
    PX(BORDERWIDTH),
    PY(BORDERWIDTH)
];
_ctrlFOVLabel ctrlSetFontHeight PY(1.2);
_ctrlFOVLabel ctrlSetFont "RobotoCondensedBold";
_ctrlFOVLabel ctrlSetText "FOV";
_ctrlFOVLabel ctrlCommit 0;

private _ctrlFOVDefaultLine = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
_ctrlFOVDefaultLine ctrlSetPosition [
    safeZoneW - PX(BORDERWIDTH * 3 / 4),
     PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
    PX(BORDERWIDTH / 2),
    PY(0.2)
];
_ctrlFOVDefaultLine ctrlSetText "#(argb,8,8,3)color(0,1,0,1)";
_ctrlFOVDefaultLine ctrlCommit 0;

private _ctrlPlanningChannel = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlPlanningChannel ctrlSetPosition [0, safeZoneH - PY(BORDERWIDTH), safeZoneW , PY(1.8)];
_ctrlPlanningChannel ctrlSetFont "RobotoCondensedBold";
_ctrlPlanningChannel ctrlSetStructuredText parseText format ["<t size='%5' color='%2'>Channel: %1 | </t><t size='%5' color='%3'>Color: %4</t>", "All", ["#ffffff", "#ffffff", "#3CB371"] select GVAR(InputMode), GVAR(PlanningModeColorHTML) select GVAR(PlanningModeColor), GVAR(PlanningModeColor), _smallTextSize];
_ctrlPlanningChannel ctrlCommit 0;

[QGVAR(PlanningModeChannelChanged), {
    (_this select 1) params ["_ctrl"];
    private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
    if (GVAR(PlanningModeChannel) == 0) then {
        _ctrl ctrlSetStructuredText parseText format ["<t size='%5' color='%2'>Channel: %1 | </t><t size='%5' color='%3'>Color: %4</t>", "All", ["#ffffff", "#ffffff", "#3CB371"] select GVAR(InputMode), GVAR(PlanningModeColorHTML) select GVAR(PlanningModeColor), GVAR(PlanningModeColor), _smallTextSize];
    } else {
        _ctrl ctrlSetStructuredText parseText format ["<t size='%5' color='%2'>Channel: %1 | </t><t size='%5' color='%3'>Color: %4</t>", GVAR(PlanningModeChannel), ["#ffffff", "#ffffff", "#3CB371"]select GVAR(InputMode), GVAR(PlanningModeColorHTML) select GVAR(PlanningModeColor), GVAR(PlanningModeColor), _smallTextSize];
    };
    _ctrl ctrlCommit 0;
}, _ctrlPlanningChannel] call CFUNC(addEventhandler);

[QGVAR(CameraTargetChanged), {
    if (GVAR(UnitInfoOpen)) then {
        if (isNull GVAR(CameraFollowTarget)) then {
            QGVAR(CloseUnitInfo) call CFUNC(localEvent);
        } else {
            [QGVAR(OpenUnitInfo), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
        };
    };

}] call CFUNC(addEventhandler);

[QGVAR(CameraSpeedChanged), {
    (_this select 1) params ["_ctrl"];
    private _logScale = (ln GVAR(CameraSpeed)) / ln sqrt 2;
    private _logScaleMin = (ln CAMERAMINSPEED) / ln sqrt 2;
    private _logScaleMax = (ln CAMERAMAXSPEED) / ln sqrt 2;
    private _relLength = linearConversion [_logScaleMin, _logScaleMax, _logScale, 0, 1];
    //private _relLength = sqrt GVAR(CameraSpeed) / sqrt CAMERAMAXSPEED;
    _ctrl ctrlSetPosition [
        safeZoneW - PX(BORDERWIDTH * 3 / 4),
        PY(2 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        _relLength * PY(BORDERWIDTH * 4)
    ];
    _ctrl ctrlCommit 0;
}, _ctrlMouseSpeedBar] call CFUNC(addEventhandler);

[QGVAR(CameraSpeedChanged)] call CFUNC(localEvent);

[QGVAR(CameraSmoothingChanged), {
    (_this select 1) params ["_ctrl"];
    private _relLength = 0;
    if (GVAR(CameraSmoothingTime) > 0) then {
        private _logScale = (ln GVAR(CameraSmoothingTime)) / ln sqrt 2;
        private _logScaleMin = (ln 0.05) / ln sqrt 2;
        private _logScaleMax = (ln 1.6) / ln sqrt 2;
        _relLength = linearConversion [_logScaleMin, _logScaleMax, _logScale, 0.1, 1];
    };

    //private _relLength = sqrt GVAR(CameraSmoothingTime) / sqrt 1.6;
    _ctrl ctrlSetPosition [
        safeZoneW - PX(BORDERWIDTH * 3 / 4),
        PY(8 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        PY(BORDERWIDTH * 4) * _relLength
    ];
    _ctrl ctrlCommit 0;
}, _ctrlMouseSmoothingBar] call CFUNC(addEventhandler);

[QGVAR(CameraSmoothingChanged)] call CFUNC(localEvent);

[QGVAR(CameraFOVChanged), {
    (_this select 1) params ["_ctrl"];
    private _logScale = (ln GVAR(CameraFOV)) / ln sqrt 2;
    private _logScaleMin = (ln (sqrt(2)^-14)) / ln sqrt 2;
    private _logScaleMax = (ln 2) / ln sqrt 2;
    private _relLength = linearConversion [_logScaleMin, _logScaleMax, _logScale, 0, 1];
    //private _relLength = (2 - GVAR(CameraFOV)) / 2;
    _ctrl ctrlSetPosition [
        safeZoneW - PX(BORDERWIDTH * 3 / 4),
        PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 2),
        PY(BORDERWIDTH * 4) * _relLength
    ];
    _ctrl ctrlCommit 0;
}, _ctrlFOVBar] call CFUNC(addEventhandler);

QGVAR(CameraFOVChanged) call CFUNC(localEvent);

[QGVAR(CursorTargetChanged), {
    (_this select 0) params ["_target"];
    (_this select 1) params ["_ctrl"];
    _ctrl ctrlSetText format ["%1 [%2]", str _target, _target call CFUNC(name)];
    _ctrl ctrlCommit 0;
}, _ctrlTargetInfo] call CFUNC(addEventhandler);

[QGVAR(CameraModeChanged), {
    (_this select 0) params ["_mode"];
    (_this select 1) params ["_ctrl"];

    private _textMode = ["FREE", "FOLLOW [%1]", "SHOULDER [%1]", "TOPDOWN [%1]", "FIRST PERSON [%1]", "ORBIT [%1]", "UAV %2 [%1]"]  select (_mode - 1);
    _textMode = format [_textMode, GVAR(CameraFollowTarget) call CFUNC(name), GVAR(UAVCameraTarget) call CFUNC(name)];
    private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
    _ctrl ctrlSetStructuredText parseText format ["<t size='%2' align='right'>%1</t>", _textMode, _smallTextSize];
    _ctrl ctrlCommit 0;
}, _ctrlCameraMode] call CFUNC(addEventhandler);

[QGVAR(hightlightModeChanged), {
    (_this select 1) params ["_ctrlFOVLabel", "_ctrlMouseSmoothingLabel", "_ctrlMouseSpeedLabel"];

    if (GVAR(CameraSpeedMode)) then {
        _ctrlMouseSpeedLabel ctrlSetTextColor [0, 1, 0, 1];
    } else {
        _ctrlMouseSpeedLabel ctrlSetTextColor [1, 1, 1, 1];
    };
    if (GVAR(CameraSmoothingMode)) then {
        _ctrlMouseSmoothingLabel ctrlSetTextColor [0, 1, 0, 1];
    } else {
         _ctrlMouseSmoothingLabel ctrlSetTextColor [1, 1, 1, 1];
    };
    if (GVAR(CameraZoomMode)) then {
        _ctrlFOVLabel ctrlSetTextColor [0, 1, 0, 1];
    } else {
        _ctrlFOVLabel ctrlSetTextColor [1, 1, 1, 1];
    };
}, [_ctrlFOVLabel, _ctrlMouseSmoothingLabel, _ctrlMouseSpeedLabel]] call CFUNC(addEventhandler);

[QGVAR(toggleUI), {
    (_this select 1) params ["_ctrlGrp"];
    GVAR(hideUI) = !GVAR(hideUI);
    _ctrlGrp ctrlShow !GVAR(hideUI);
    GVAR(UnitInfoOpen) = true;
    QGVAR(CloseUnitInfo) call CFUNC(localEvent);

}, _ctrlGrp] call CFUNC(addEventhandler);

[_ctrlGrp] call FUNC(buildRadioInfoUI);
[_ctrlGrp] call FUNC(buildUnitInfoUI);
[_ctrlGrp] call FUNC(buildFPSUI);
_ctrlInfo call FUNC(findInputEvents);

[{
    (_this select 0) params ["_ctrlFOVBarCurrent", "_ctrlTargetSpeedInfo"];
    private _logScale = (ln (GVAR(CameraPreviousState) param [4, GVAR(CameraFOV)])) / ln sqrt 2;
    private _logScaleMin = (ln 0.01) / ln sqrt 2;
    private _logScaleMax = (ln 2) / ln sqrt 2;
    private _relLength = linearConversion [_logScaleMin, _logScaleMax, _logScale, 0, 1];

    _ctrlFOVBarCurrent ctrlSetPosition [
        safeZoneW - PX(BORDERWIDTH * 3 / 4),
        PY(14 * BORDERWIDTH) + PY(4 * BORDERWIDTH) * (1 - _relLength),
        PX(BORDERWIDTH / 8),
        PY(BORDERWIDTH * 4) * _relLength
    ];
    _ctrlFOVBarCurrent ctrlCommit 0;
    if (isNull GVAR(CameraFollowTarget)) then {
        _ctrlTargetSpeedInfo ctrlSetText "";
    } else {
        _ctrlTargetSpeedInfo ctrlSetText format ["%1 km/h", abs (floor (speed (vehicle GVAR(CameraFollowTarget))))];
    };
    _ctrlTargetSpeedInfo ctrlCommit 0;
}, 0, [_ctrlFOVBarCurrent, _ctrlTargetSpeedInfo]] call CFUNC(addPerFrameHandler);
