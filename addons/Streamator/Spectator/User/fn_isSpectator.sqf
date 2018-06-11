#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:

    Parameter(s):
    0: Unit <Object>

    Returns:
    is Spectator <Bool>
*/
params ["_unit"];
(_unit isKindof "VirtualSpectator_F" && side _unit isEqualTo sideLogic)
 || _unit getVariable ["Streamator_isSpectator", false]
