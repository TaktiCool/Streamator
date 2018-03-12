#define MODULE(name) class name
#define FNC(name) class name

class CfgCLibModules {
    class Streamator {
        path = "\tc\Streamator\addons\Streamator";

        // Crates
        MODULE(Spectator) {
            dependency[] = {"CLib"};
            FNC(clientInit);
            FNC(cameraUpdateLoop);
            FNC(draw3dEH);
            FNC(keyDownEH);
            FNC(keyUpEH);
            FNC(mouseMovingEH);
            FNC(mouseWheelEH);
        };

        // UnitTracker
        MODULE(UnitTracker) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(addUnitToTracker);
            FNC(addGroupToTracker);
            FNC(addVehicleToTracker);
        };
    };
};
