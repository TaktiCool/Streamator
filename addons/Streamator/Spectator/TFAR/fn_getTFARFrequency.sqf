#include "macros.hpp"
/*
    Streamator
    Author: Raven
    Description:
	Extracts the TFAR frequency out of the given input string
    Parameter(s):
    0: The input string that when split at the '|' character contains the frequency string at element 0 <STRING>
    Returns:
    The frequency string
*/

params ["_input"];

if (_input isEqualTo "") exitWith {
    ERROR_LOG("Empty radio data element encountered");
};
private _elements = _input splitString "|";
if (count _elements == 1) then {
    // This doesn't contain the class name to begin with -> return element as is
    _input;
} else {
    // The important information is in the first element which by definition contains the needed frequency string
    _elements select 0;
};
