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
            FNC(dik2Char);
            FNC(cameraUpdateLoop);
            FNC(draw3dEH);
            FNC(getDefaultIcon);
            FNC(getUnitType);
            FNC(initializeSpectator);
            APIFNC(isSpectator);
            FNC(keyDownEH);
            FNC(keyUpEH);
            FNC(mouseMovingEH);
            FNC(mouseWheelEH);
            FNC(restorePosition);
            FNC(savePosition);
            FNC(setCameraTarget);
            FNC(setVisionMode);
            FNC(terminateSpectator);
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
