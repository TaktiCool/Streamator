#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Fired EH for Untis

    Parameter(s):
    Fired EH Parameter

    Returns:
    None
*/
params [["_direction", 0]];
private _bearings = ["N ","NE","E ","SE","S ","SW","W ","NW","N "] select round (_direction / 45);
private _text = switch (true) do {
    case (_direction < 10): {
        format ["%2 00%1°", floor _direction, _bearings];
    };
    case (_direction < 100): {
        format ["%2 0%1°", floor _direction, _bearings];
    };
    default {
        format ["%2 %1°", floor _direction, _bearings];
    };
};
_text
