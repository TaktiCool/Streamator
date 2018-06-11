#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class Streamator {
        path = "\tc\Streamator\addons\Streamator";

        // Crates
        MODULE(Spectator) {
            dependency[] = {"CLib"};
            MODULE(UI) {
                FNC(buildRadioInfoUI);
                FNC(buildUI);
                FNC(buildUnitInfoUI);
                FNC(findInputEvents);
            };
            APIFNC(addCustom3dIcon);
            APIFNC(addSearchTarget);
            FNC(buildSpectatorUI);
            FNC(cameraUpdateLoop);
            FNC(clientInit);
            FNC(closeSpectator);
            FNC(compatibleMagazines);
            FNC(dik2Char);
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
            FNC(serverInit);
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
