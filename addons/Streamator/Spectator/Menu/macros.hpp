#include "\tc\Streamator\addons\Streamator\Spectator\macros.hpp"

#define CREATE_BACK_ACTION(ORIGIN_PATH,TARGET_PATH) ["BACK", ORIGIN_PATH, DIK_ESCAPE, { GVAR(currentMenuPath) = TARGET_PATH; true }] call FUNC(addMenuItem)
#define CREATE_BACK_ACTION_MAIN(ORIGIN_PATH) CREATE_BACK_ACTION(ORIGIN_PATH,"MAIN")
