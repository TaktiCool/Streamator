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

private _ctrlGrpDroneView = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
_ctrlGrpDroneView ctrlSetPosition [PX(BORDERWIDTH + 2.6), safeZoneH - PY(BORDERWIDTH + 40), PX(25), PY(28)];
_ctrlGrpDroneView ctrlCommit 0;

private _ctrlDroneViewBackground = _display ctrlCreate ["RscPicture", -1, _ctrlGrpDroneView];
_ctrlDroneViewBackground ctrlSetPosition [0, 0, PX(25), PY(28)];
_ctrlDroneViewBackground ctrlSetText "#(argb,8,8,3)color(0.1,0.1,0.1,0.75)";
_ctrlDroneViewBackground ctrlCommit 0;

private _ctrlDroneViewFeed = _display ctrlCreate ["RscPicture", -1, _ctrlGrpDroneView];
_ctrlDroneViewFeed ctrlSetPosition [0, PY(3), PX(25), PY(25)];
_ctrlDroneViewFeed ctrlSetText "#(argb,8,8,3)color(0.5,0.5,0.5,1)";
_ctrlDroneViewFeed ctrlCommit 0;

private _ctrlDroneViewTitle = _display ctrlCreate ["RscTitle", -1, _ctrlGrpDroneView];
_ctrlDroneViewTitle ctrlSetPosition [0, 0, PX(15), PY(3)];
_ctrlDroneViewTitle ctrlSetFontHeight PY(2);
_ctrlDroneViewTitle ctrlSetFont "RobotoCondensedBold";
_ctrlDroneViewTitle ctrlSetText "DRONE CAM";
_ctrlDroneViewTitle ctrlCommit 0;

[QGVAR(CameraTargetChanged), {
    (_this select 0) params ["_cameraTarget"];
    (_this select 1) params ["_ctrl"];

    _ctrl ctrlSetText (_cameraTarget call CFUNC(name));
}, [_ctrlUnitName]] call CFUNC(addEventhandler);

[QGVAR(CameraModeChanged), {
    (_this select 0) params ["_cameraMode"];
    (_this select 1) params ["_ctrl"];

    if (_cameraMode == 5) then {
        _ctrl ctrlSetFade 0;
    } else {
        _ctrl ctrlSetFade 1;
    };
    _ctrl ctrlCommit 0.3;
}, [_ctrlUnitName]] call CFUNC(addEventhandler);
