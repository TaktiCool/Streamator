#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Add or Update Group in Tracker

    Parameter(s):


    Returns:

*/
params ["_unit"];

if (leader _unit == _unit) exitWith {
    "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
};
if (_unit getUnitTrait "medic") exitWith {
    "\a3\ui_f\data\igui\cfg\actions\heal_ca.paa";
};
if (_unit getUnitTrait "engineer" || _unit getUnitTrait "explosiveSpecialist") exitWith {
    "\a3\ui_f\data\gui\cfg\respawnroles\support_ca.paa";
};
if ("launch" find (secondaryWeapon _unit) != -1) exitWith {
    "\a3\ui_f\data\igui\cfg\weaponicons\at_ca.paa";
};
if ("srifle" find (primaryWeapon _unit) != -1) exitWith {
    "\a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa";
};
if ("LMG" find (primaryWeapon _unit) != -1 || "MMG" find (primaryWeapon _unit) != -1) exitWith {
    "\a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa";
};
if ("GL" find (primaryWeapon _unit) != -1) exitWith {
    "\a3\ui_f\data\igui\cfg\weaponicons\gl_ca.paa";
};

"\a3\ui_f\data\igui\cfg\actions\clear_empty_ca.paa";
