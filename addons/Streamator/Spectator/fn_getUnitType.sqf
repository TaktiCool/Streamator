#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Gets Icon for Unit

    Parameter(s):
    0: Unit to get Icon for <Object>

    Returns:
    <String> Icon path for Unit
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


if !(isNull objectParent _unit) then {
    private _vehicle = vehicle _unit;
    private _crewInfo = ((fullCrew _vehicle) select {(_x select 0) isEqualTo _unit}) select 0;
    _crewInfo params ["", "_role", "", "", "_isTurret"];

    if (_role == "driver") then {
        if (_vehicle isKindOf "Air") then {
            ["\A3\ui_f\data\IGUI\Cfg\Actions\getinpilot_ca.paa", 1] breakOut SCRIPTSCOPENAME;
        } else {
            ["\A3\ui_f\data\IGUI\Cfg\CommandBar\imageDriver_ca.paa", 1.5] breakOut SCRIPTSCOPENAME;
        };
        ["\A3\ui_f\data\IGUI\Cfg\CommandBar\imageDriver_ca.paa", 1.5] breakOut SCRIPTSCOPENAME;
    };
    if (_role == "commander") then {
        ["\A3\ui_f\data\IGUI\Cfg\CommandBar\imageCommander_ca.paa", 1.2] breakOut SCRIPTSCOPENAME;
    };
    if (_role == "turret" && _isTurret) then {
        ["\a3\ui_f\data\igui\cfg\simpletasks\types\rifle_ca.paa", 1] breakOut SCRIPTSCOPENAME;
    };
    if (_role == "gunner" || (_role == "turret" && !_isTurret)) then {
        ["\A3\ui_f\data\IGUI\Cfg\CommandBar\imageGunner_ca.paa", 1.5] breakOut SCRIPTSCOPENAME;
    };
};

if (leader _unit == _unit) exitWith {
    private _icon = ["\A3\ui_f\data\gui\cfg\ranks\corporal_gs.paa", 1];
    if (rankId _unit >= 2) then {
        _icon set [0, format ["\A3\ui_f\data\gui\cfg\ranks\%1_gs.paa", rank _unit]];
    };
    _icon;
};

if ((_unit getVariable ["ace_medical_medicClass", [0, 1] select (_unit getUnitTrait "medic")] > 0) || _unit getUnitTrait "medic") exitWith {
    //"\a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
    ["\A3\ui_f\data\igui\cfg\actions\heal_ca.paa", 1];
};

if ((_unit getVariable ["ACE_isEOD", _unit getUnitTrait "explosiveSpecialist"]) in [1, true]) exitWith {
    //"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa";
    ["\A3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa", 1];
};

private _isEngineer = _unit getVariable ["ACE_isEngineer", _unit getUnitTrait "engineer"];
if (_isEngineer isEqualType 0) then {_isEngineer = _isEngineer > 0};
if (_isEngineer) exitWith {
    //"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\support_ca.paa", 1];
};
if ((toLowerANSI (getText(configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "UIPicture")) == "\a3\weapons_f\data\ui\icon_at_ca.paa")) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\at_ca.paa";
    ["\A3\ui_f\data\gui\rsc\rscdisplayarsenal\secondaryweapon_ca.paa", 1.3];
};

private _primaryWeapon = toLowerANSI primaryWeapon _unit;
if ("srifle" in _primaryWeapon) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\recon_ca.paa", 1];
};

if ("gl" in _primaryWeapon) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\gl_ca.paa";
    ["\A3\ui_f_curator\data\rsccommon\rscattributeinventory\filter_6_ca.paa", 1];
};

if ((toLowerANSI (getText (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "UIPicture")) == "\a3\weapons_f\data\ui\icon_mg_ca.paa")) exitWith {
    //"\a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa";
    ["\A3\ui_f\data\gui\cfg\respawnroles\assault_ca.paa", 1];
};
["\a3\ui_f\data\igui\cfg\actions\clear_empty_ca.paa", 1];
