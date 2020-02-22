#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Add a Target to Search for

    Parameter(s):
    0: Name of Target <String>
    1: Target <Object, String, Location, Array<Number>>
    2: Distance Offset <Number> (Default: 5)
    3: Hight Offset <Number> (Default: 1)

    Returns:
    None
*/
params [
    ["_name", "NAME NOT DEFINED", [""]],
    ["_target", objNull, [objNull, "", locationNull, []]],
    ["_distance", 5, [0]],
    ["_hight", 1, [0]]
];

if (isNil QGVAR(CustomSearchItems)) then {
    GVAR(CustomSearchItems) = [];
};
GVAR(CustomSearchItems) pushback [_name, [_target, _distance, _hight]];
