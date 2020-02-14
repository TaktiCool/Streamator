#include "macros.hpp"
/*
    Streamator

    Author: Badguy

    Description:
    Sets Camera Vision Mode

    Parameter(s):
    None

    Returns:
    None
*/
switch (GVAR(CameraVision)) do {
    case (9): {
        camUseNVG false;
        false setCamUseTi 0;
    };
    case (8): {
        camUseNVG true;
        false setCamUseTi 0;
    };
    default {
        camUseNVG false;
        true setCamUseTi GVAR(CameraVision);
    };
};
