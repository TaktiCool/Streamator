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
	_data = _data apply {[_x] call FUNC(getTFARFrequency)};
	_oldData = _oldData apply {[_x] call FUNC(getTFARFrequency)};
	
	
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
