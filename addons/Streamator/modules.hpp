#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class Streamator {
        path = "\tc\Streamator\addons\Streamator";

        // Crates
        MODULE(Spectator) {
            dependency[] = {"CLib"};
            APIFNC(addCustom3dIcon);
            FNC(clientInit);
            FNC(cameraUpdateLoop);
            FNC(draw3dEH);
            FNC(getUnitType);
            FNC(setCameraTarget);
            FNC(keyDownEH);
            FNC(keyUpEH);
            FNC(mouseMovingEH);
            FNC(mouseWheelEH);
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
