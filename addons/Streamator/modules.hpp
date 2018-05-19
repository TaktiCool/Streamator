#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class Streamator {
        path = "\tc\Streamator\addons\Streamator";

        // Crates
        MODULE(Spectator) {
            dependency[] = {"CLib"};
            FNC(buildSpectatorUI);
            APIFNC(addCustom3dIcon);
            FNC(clientInit);
            FNC(closeSpectator);
            FNC(dik2Char);
            FNC(cameraUpdateLoop);
            FNC(draw3dEH);
            FNC(getDefaultIcon);
            FNC(getUnitType);
            APIFNC(isSpectator);
            FNC(keyDownEH);
            FNC(keyUpEH);
            FNC(mouseMovingEH);
            FNC(mouseWheelEH);
            FNC(openSpectator);
            FNC(restorePosition);
            FNC(savePosition);
            FNC(setCameraTarget);
            FNC(setVisionMode);
        };

        // UnitTracker
        MODULE(UnitTracker) {
            dependency[] = {"Streamator/Spectator"};
            FNC(clientInit);
            FNC(addUnitToTracker);
            FNC(addGroupToTracker);
            FNC(addVehicleToTracker);
        };
    };
};
