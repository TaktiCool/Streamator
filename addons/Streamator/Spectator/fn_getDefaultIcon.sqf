#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Gets Group Icon for Side

    Parameter(s):
    None

    Returns:
    None
*/
params ["_side"];
switch (_side) do {
    case (west): {
        "\A3\ui_f\data\map\markers\nato\b_inf.paa"
    };
    case (east): {
        "\A3\ui_f\data\map\markers\nato\o_inf.paa"
    };
    case (independent): {
        "\A3\ui_f\data\map\markers\nato\n_inf.paa"
    };
    case (civilian): {
        "\A3\ui_f\data\map\markers\nato\n_unknown.paa"
    };
    default {
        "\A3\ui_f\data\map\markers\nato\n_unknown.paa"
     };
};
