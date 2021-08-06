#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/
private _fnc_onActionCrew = {
    params ["_type"];
    private _newCameraTarget = vehicle GVAR(CameraFollowTarget);

    if (isNull vehicle GVAR(CameraFollowTarget)) exitWith { _ret; };
    switch (_type) do {
        case ("COMMANDER"): {
            _newCameraTarget = commander _newCameraTarget;
        };
        case ("GUNNER"): {
            _newCameraTarget = gunner _newCameraTarget;
        };
        case ("DRIVER"): {
            _newCameraTarget = driver _newCameraTarget;
        };
        case ("CREW"): {
            private _crew = crew _newCameraTarget;
            private _index = ((_crew find GVAR(CameraFollowTarget)) + 1) % (count _crew);
            _newCameraTarget = _crew select _index;
            [_newCameraTarget, GVAR(CameraMode)] call FUNC(setCameraTarget);
        };
    };
    [_newCameraTarget, GVAR(CameraMode)] call FUNC(setCameraTarget);
    true
};
private _fnc_onRenderCrew = {
    params ["_type"];
    private _newCameraTarget = vehicle GVAR(CameraFollowTarget);
    private _ret = false;

    if (isNull vehicle GVAR(CameraFollowTarget)) exitWith { _ret; };
    switch (_type) do {
        case ("COMMANDER"): {
            _newCameraTarget = commander _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                _name = format ["Commander (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("DRIVER"): {
            _newCameraTarget = driver _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                if (vehicle _newCameraTarget isKindOf "Air") then {
                    _name = format ["Pilot (%1)", _newCameraTarget call CFUNC(name)];
                } else {
                    _name = format ["Driver (%1)", _newCameraTarget call CFUNC(name)];
                };
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("GUNNER"): {
            _newCameraTarget = gunner _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                _name = format ["Gunner (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("VEHICLE"): {
            if (!isNull _newCameraTarget) then {
                _name = format ["Vehicle (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("CREW"): {
            private _crew = crew _newCameraTarget;
            private _index = ((_crew find GVAR(CameraFollowTarget)) + 1) % (count _crew);
            _newCameraTarget = _crew select _index;
            if (!isNull _newCameraTarget) then {
                _name = format ["Next Crew (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull _newCameraTarget && !((crew (vehicle GVAR(CameraFollowTarget))) in [[], [GVAR(CameraFollowTarget)]]);
        };
    };
    if (GVAR(CameraFollowTarget) isEqualTo _newCameraTarget) then {
        _color = "#3CB371";
    };
    _ret;
};

["Commander", "MAIN/CREW", DIK_F1, _fnc_onActionCrew, _fnc_onRenderCrew, false, "COMMANDER"] call FUNC(addMenuItem);
["Gunner", "MAIN/CREW", DIK_F2, _fnc_onActionCrew, _fnc_onRenderCrew, false, "GUNNER"] call FUNC(addMenuItem);
["Driver", "MAIN/CREW", DIK_F3, _fnc_onActionCrew, _fnc_onRenderCrew, false, "DRIVER"] call FUNC(addMenuItem);
["Vehicle", "MAIN/CREW", DIK_F4, _fnc_onActionCrew, _fnc_onRenderCrew, false, "VEHICLE"] call FUNC(addMenuItem);
["Next Crew", "MAIN/CREW", DIK_F5, _fnc_onActionCrew, _fnc_onRenderCrew, false, "CREW"] call FUNC(addMenuItem);
