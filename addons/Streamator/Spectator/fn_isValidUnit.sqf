#include "macros.hpp"
/*
    Streamator
    Author: BadGuy

    Description:
    Checks if a Unit should get Rendered

    Parameter(s):
    0: Unit <Object>

    Returns:
    isValid <Bool>
*/

params [["_unit", objNull]];

if !(_unit getVariable [QGVAR(isPlayer), false] || GVAR(RenderAIUnits)) exitWith { false };

!(side _unit in [sideLogic, sideUnknown])
&& alive _unit
&& simulationEnabled _unit
&& !isObjectHidden _unit
