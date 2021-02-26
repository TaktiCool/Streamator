#include "macros.hpp"
/*
    Streamator
    Author: Raven

    Description:
    Extracts the TFAR frequency out of the given input string

    Parameter(s):
    0: The input string that when split at the '|' character contains the frequency string at element 0 <STRING>

    Returns:
    The frequency string <String>
*/

params ["_input"];

if (_input isEqualTo "") exitWith {
    ERROR_LOG("Empty radio data element encountered");
};
private _elements = _input splitString "|";
_elements select 0;
