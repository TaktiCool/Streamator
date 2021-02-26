#define MODULE Spectator
#include "\tc\Streamator\addons\Streamator\macros.hpp"

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

#define BORDERWIDTH 2.4
#define CAMERAMINSPEED 0.625
#define CAMERAMAXSPEED 1280

#define CAMERAMINSMOOTHING 0.05
#define CAMERAMAXSMOOTHING 1.6

#define CAMERAMINFOV 0.01
#define CAMERAMAXFOV 2

#define NAMETAGDIST 200
#define UNITDOTDIST 1000
#define TRACER_SEGMENT_COUNT diag_fps
#define PLANNINGMODEUPDATETIME GVAR(PlaningModeUpdateTime)

#define LEFTBORDER (((((getResolution select 4)-16/9)/2) max 0)*safeZoneH)
