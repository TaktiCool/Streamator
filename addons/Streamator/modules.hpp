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
            MODULE(DrawCalls) {
                FNC(draw3dBullets);
                FNC(draw3dGroups);
                FNC(draw3dLaserTargets);
                FNC(draw3dMeasureDistance);
                FNC(draw3dPlanning);
                FNC(draw3dUnits);
                FNC(drawAceMapGestures);
                FNC(drawBullets);
                FNC(drawLaserTargets);
                FNC(drawMarkers);
                FNC(drawMeasureDistance);
                FNC(drawPlanning);
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
            MODULE(Menu) {
                FNC(addMenuItem);
                FNC(executeEntry);
                FNC(registerMenus);
                FNC(renderMenu);
            };
            MODULE(User) {
                APIFNC(addCustom3dIcon);
                APIFNC(addSearchTarget);
                APIFNC(isSpectator);
            };
            FNC(cameraUpdateLoop);
            FNC(clientInit);
            FNC(getDefaultIcon);
            FNC(getMousePositionInWorld);
            FNC(getUnitType);
            FNC(isValidUnit);
            FNC(openSpectator);
            FNC(restorePosition);
            FNC(savePosition);
            FNC(serverInit);
            FNC(setCameraTarget);
            FNC(setVisionMode);
            FNC(updateAndDrawBulletTracer);
            FNC(updatePlanningMarkers);
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
