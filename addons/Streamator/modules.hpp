#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class Streamator {
        path = "\tc\Streamator\addons\Streamator";

        // Crates
        MODULE(Spectator) {
            dependency[] = {"CLib"};
            MODULE(ACRE) {
                FNC(clientInitACRE);
            };
            MODULE(Draw) {
                FNC(draw3dEH);
                FNC(drawEH);
            };
            MODULE(TFAR) {
                FNC(clientInitTFAR);
                FNC(getTFARFrequency);
                FNC(serverInitTFAR);
                FNC(updateTFARFreq);
            };
            MODULE(Radio) {
                FNC(setRadioFollowTarget);
            };

            MODULE(UI) {
                FNC(buildFPSUI);
                FNC(buildMapUI);
                FNC(buildRadioInfoUI);
                FNC(buildUI);
                FNC(buildUnitInfoUI);
                FNC(createPlanningDisplay);
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
                APIFNC(isSpectator);
            };
            FNC(cameraUpdateLoop);
            FNC(clientInit);
            FNC(closeSpectator);
            FNC(getDefaultIcon);
            FNC(getUnitType);
            FNC(isValidUnit);
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
            FNC(addUnitToTracker);
            FNC(addGroupToTracker);
            FNC(addVehicleToTracker);
            FNC(clientInit);
            FNC(updateIcons);
        };
    };
};
