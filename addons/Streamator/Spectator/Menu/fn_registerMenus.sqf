#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Menus

    Parameter(s):


    Returns:

*/
GVAR(currentMenuPath) = "MAIN";

// Overlays
["Overlays", "MAIN", DIK_F1, "MAIN/OVERLAYS", {true}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/OVERLAYS");
call FUNC(overlaySubMenus);

// Camera
["Camera Modes", "MAIN", DIK_F2, "MAIN/CAMERA", {!isNull GVAR(CameraFollowTarget) && !GVAR(MapOpen)}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/CAMERA");
call FUNC(cameraSubMenus);

// Vision Modes
["Vision Modes", "MAIN", DIK_F3, "MAIN/VISION", {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/VISION");
call FUNC(visionSubMenus);

// Minimap
["Minimap", "MAIN", DIK_F4, "MAIN/MINIMAP", {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/MINIMAP");
call FUNC(mapSubMenus);

// Radio
if (GVAR(TFARLoaded) || GVAR(ACRELoaded)) then {
    ["Radio", "MAIN", DIK_F5, "MAIN/RADIO", {true}, true] call FUNC(addMenuItem);
    CREATE_BACK_ACTION_MAIN("MAIN/RADIO");
    call FUNC(radioSubMenus);
};

// Crew
["Crew", "MAIN", DIK_F6, "MAIN/CREW", {
    !GVAR(MapOpen) && !isNull GVAR(CameraFollowTarget) && !((vehicle GVAR(CameraFollowTarget)) isKindOf "CAManBase");
}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/CREW");
call FUNC(crewSubMenus);

// Misc
["Misc", "MAIN", DIK_F7, "MAIN/MISC", {true}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION_MAIN("MAIN/MISC");
call FUNC(miscSubMenus);
