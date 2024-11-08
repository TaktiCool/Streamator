#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/
["Show Minimap", "MAIN/MINIMAP", DIK_F1, {
    QGVAR(ToggleMinimap) call CFUNC(localEvent);
    true
}, {
    _name = "Show Minimap";
    if (GVAR(MinimapVisible)) then {
        _color = "#3CB371";
        _name = "Hide Minimap";
    };
    true
}] call FUNC(addMenuItem);
["Center On Camera", "MAIN/MINIMAP", DIK_F2, {
    GVAR(CenterMinimapOnCameraPositon) = !GVAR(CenterMinimapOnCameraPositon);
    true
}, {
    if (GVAR(CenterMinimapOnCameraPositon)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

["Render FOV Cone", "MAIN/MINIMAP", DIK_F3, {
    GVAR(RenderFOVCone) = !GVAR(RenderFOVCone);
    true
}, {
    if (GVAR(RenderFOVCone)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
