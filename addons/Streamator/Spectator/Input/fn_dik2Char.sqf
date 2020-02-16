#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Converts Dik To Character

    Parameter(s):
    0: Character <Number>
    1: Shift Pressed <Bool>

    Returns:
    None
*/
params ["_dik", "_shift"];

private _char = toLower call compile keyName _dik;
DUMP("Pressed Char: " + _char + " " + str toArray _char + " " + str (count (toArray _char)));
if ((count (toArray _char)) != 1) then {
    _char = switch (_char) do {
        case ("space"): {
            " "
        };
        default {
            ""
        };
    };
};

[_char, toUpper _char] select _shift;
