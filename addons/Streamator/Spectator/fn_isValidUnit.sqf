#include "macros.hpp"
/*
    Streamator
    Author: BadGuy

    Description:
    Checks if a Unit should get Rendert

    Parameter(s):
    0: Unit <Object>

    Returns:
    isValid <Bool>
*/

params [["_unit", objNull]];

if !(isPlayer _unit || GVAR(RenderAIUnits)) exitWith { false };

!(side _unit in [sideLogic, sideUnknown])
&& alive _unit
&& simulationEnabled _unit
&& !isObjectHidden _unit
