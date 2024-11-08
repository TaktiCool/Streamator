#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Overlay SubMenus

    Parameter(s):


    Returns:

*/

["Group Markers", "MAIN/OVERLAYS", DIK_F1, {
    GVAR(OverlayGroupMarker) = !GVAR(OverlayGroupMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(updateValidUnits);
    true
}, {
    if (GVAR(OverlayGroupMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Unit Markers", "MAIN/OVERLAYS", DIK_F2, {
    GVAR(OverlayUnitMarker) = !GVAR(OverlayUnitMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(updateValidUnits);
    true
}, {
    if (GVAR(OverlayUnitMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Player Markers", "MAIN/OVERLAYS", DIK_F3, {
    GVAR(OverlayPlayerMarkers) = !GVAR(OverlayPlayerMarkers);
    true
}, {
    if (GVAR(OverlayPlayerMarkers)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Planning Markers", "MAIN/OVERLAYS", DIK_F4, {
    GVAR(OverlayPlanningMode) = !GVAR(OverlayPlanningMode);
    true
}, {
    if (GVAR(OverlayPlanningMode)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Bullet Markers", "MAIN/OVERLAYS", DIK_F5, {
    GVAR(OverlayBulletTracer) = !GVAR(OverlayBulletTracer);
    GVAR(BulletTracers) = [];
    true
}, {
    if (GVAR(OverlayBulletTracer)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Laser Markers", "MAIN/OVERLAYS", DIK_F6, {
    GVAR(OverlayLaserTargets) = !GVAR(OverlayLaserTargets);
    true
}, {
    if (GVAR(OverlayLaserTargets)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Custom Markers", "MAIN/OVERLAYS", DIK_F7, {
    GVAR(OverlayCustomMarker) = !GVAR(OverlayCustomMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(updateValidUnits);
    true
}, {
    if (GVAR(OverlayCustomMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
