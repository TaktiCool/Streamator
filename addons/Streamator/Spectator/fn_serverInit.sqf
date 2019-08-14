#include "macros.hpp"
/*
    Streamator

    Author: BadGuy, Raven

    Description:
    Server Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(radioNamespace) = true call CFUNC(createNamespace);
publicVariable QGVAR(radioNamespace);

// Add EH to catch Events about changed Radio information of a player
// This EH is needed in order to update the reference list of which players
// can be reached on which frequency
[QGVAR(spectatorRadioInformationChanged), {
    (_this select 0) params ["_unit", "_data", "_oldData"];
	
	// As the goal is to create a list of units that are reachable on a certain
	// frequency given a certain radio code, the class name of the used radio is
	// irrelevant -> remove it from the data
	_filterCode = {
		if (_x isEqualTo "") exitWith {
			ERROR_LOG("Empty radio data element encountered");
		};
		
		private _elements = _x splitString "|";
		
		if (count _elements == 1) then {
			// This doesn't contain the class name in the first place -> return element as is
			_x
		} else {
			// The important information is in the first element -> return just this one
			// If nothing goes wrong there should only be 2 elements here anyways where the
			// second one is the unneeded class name
			_elements select 0
		};
	};
	
	_data = _data apply _filterCode;
	_oldData = _oldData apply _filterCode;
	
	
	// The elements that are the same in both data sets are the elements that did not change
    private _notChanged = _data arrayIntersect _oldData;
	
	// Always assume the lack of any radio to not be part of the changed data
    _notChanged append ["No_SW_Radio", "No_LR_Radio"];
	
    {
		// remove units from the list that are no longer reachable under the given
		// frequency
        private _units = GVAR(radioNamespace) getVariable [_x, []];
        private _index = _units find _unit;
        if (_index != -1) then {
            _units deleteAt _index;
            GVAR(radioNamespace) setVariable [_x, _units, true];
        };
        nil;
    } count (_oldData - _notChanged); // only consider diff

    {
		// add units to the list that are now reachable under the given frequency
        private _units = GVAR(radioNamespace) getVariable [_x, []];
        _units pushBackUnique _unit;
        GVAR(radioNamespace) setVariable [_x, _units, true];
        nil
    } count (_data - _notChanged); // only consider diff
}] call CFUNC(addEventhandler);
