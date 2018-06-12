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
private _customIcon = _unit getVariable "Spectator_CustomIcon";
if !(isNil "_customIcon") exitWith {
    if (_customIcon isEqualType "") then {
        [_customIcon, 1];
    } else {
        _customIcon;
    };
};
if (leader _unit == _unit) exitWith {
    //"\a3\ui_f\data\igui\cfg\cursors\leader_ca.paa";
    ["\A3\ui_f\data\gui\cfg\ranks\corporal_gs.paa", 1];
};
if (_unit getUnitTrait "medic") exitWith {
    //"\a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
    ["\A3\ui_f\data\igui\cfg\actions\heal_ca.paa", 1];
};

if (_unit getUnitTrait "explosiveSpecialist") exitWith {
    //"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa";
    ["\A3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa", 1];
};

if (_unit getUnitTrait "engineer") exitWith {
    //"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\support_ca.paa", 1];
};
if ((secondaryWeapon _unit) find "launch" != -1) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\at_ca.paa";
    ["\A3\ui_f\data\gui\rsc\rscdisplayarsenal\secondaryweapon_ca.paa", 1.3];
};
if ((primaryWeapon _unit) find "srifle" != -1) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\recon_ca.paa", 1];
};
if ((primaryWeapon _unit) find "LMG" != -1 || (primaryWeapon _unit) find "MMG" != -1) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\assault_ca.paa", 1];
};
if ((primaryWeapon _unit) find "GL" != -1) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\gl_ca.paa";
    ["\A3\ui_f_curator\data\rsccommon\rscattributeinventory\filter_6_ca.paa", 1];
};

["\a3\ui_f\data\igui\cfg\actions\clear_empty_ca.paa", 1];
