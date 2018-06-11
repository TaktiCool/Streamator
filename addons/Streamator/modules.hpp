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
            MODULE(Input) {
                FNC(dik2Char);
                FNC(keyDownEH);
                FNC(keyUpEH);
                FNC(mouseMovingEH);
                FNC(mouseWheelEH);
            };
            MODULE(User) {
                APIFNC(addCustom3dIcon);
                APIFNC(addSearchTarget);
            };
            FNC(cameraUpdateLoop);
            FNC(clientInit);
            FNC(closeSpectator);
            FNC(compatibleMagazines);
            FNC(draw3dEH);
            FNC(getDefaultIcon);
            FNC(getUnitType);
            APIFNC(isSpectator);
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
