#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
params ["_ctrlGrp", "_display"];
// Unit Information Screen
private _ctrlGrpUnitInfo = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
_ctrlGrpUnitInfo ctrlSetPosition [safeZoneW/2-PX(50), safeZoneH - PY(BORDERWIDTH) - PY(26), PX(100), PY(24)];
_ctrlGrpUnitInfo ctrlShow false;
_ctrlGrpUnitInfo ctrlCommit 0;

private _ctrlGrpUnitInfoBackground = _display ctrlCreate ["RscPicture", -1, _ctrlGrpUnitInfo];
_ctrlGrpUnitInfoBackground ctrlSetPosition [PX(0), 0, PX(100), PY(24)];
_ctrlGrpUnitInfoBackground ctrlSetText "#(argb,8,8,3)color(0.1,0.1,0.1,0.75)";
_ctrlGrpUnitInfoBackground ctrlCommit 0;

private _ctrlUnitNameSpacer = _display ctrlCreate ["RscPicture", -1, _ctrlGrpUnitInfo];
_ctrlUnitNameSpacer ctrlSetPosition [0, PY(6), PX(100), PY(0.2)];
_ctrlUnitNameSpacer ctrlSetText "#(argb,8,8,3)color(1,1,1,1)"; // Side Color
_ctrlUnitNameSpacer ctrlCommit 0;

private _ctrlUnitRoleIconBackground = _display ctrlCreate ["RscPicture", -1, _ctrlGrpUnitInfo];
_ctrlUnitRoleIconBackground ctrlSetPosition [0, 0, PX(6), PY(6)];
_ctrlUnitRoleIconBackground ctrlSetText "#(argb,8,8,3)color(0,0.4,0.8,1)"; // Side Color
_ctrlUnitRoleIconBackground ctrlCommit 0;

private _ctrlUnitRoleIcon = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrpUnitInfo];
_ctrlUnitRoleIcon ctrlSetPosition [PX(1.4), PY(1.4), PX(3.2), PY(3.2)];
_ctrlUnitRoleIcon ctrlSetText "\a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa"; // Unit Role Icon "getUnitType"
_ctrlUnitRoleIcon ctrlCommit 0;

private _ctrlUnitName = _display ctrlCreate ["RscTitle", -1, _ctrlGrpUnitInfo];
_ctrlUnitName ctrlSetPosition [PX(6), 0, PX(44.5), PY(3.5)];
_ctrlUnitName ctrlSetFontHeight PY(3.2);
_ctrlUnitName ctrlSetFont "RobotoCondensedLight";
_ctrlUnitName ctrlSetTextColor [1, 1, 1, 1];
_ctrlUnitName ctrlSetText "UNIT NAME"; // Unit Name
_ctrlUnitName ctrlCommit 0;

private _ctrlGrpName = _display ctrlCreate ["RscTitle", -1, _ctrlGrpUnitInfo];
_ctrlGrpName ctrlSetPosition [PX(6), PY(3), PX(44.5), PY(3)];
_ctrlGrpName ctrlSetFontHeight PY(2.4);
_ctrlGrpName ctrlSetFont "RobotoCondensedBold";
_ctrlGrpName ctrlSetTextColor [1, 1, 1, 1];
_ctrlGrpName ctrlSetText "SQUAD NAME"; // Unit Name
_ctrlGrpName ctrlCommit 0;

private _ctrlGrpUnitInfoSquad = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpUnitInfo];
_ctrlGrpUnitInfoSquad ctrlSetPosition [0, PY(6), PX(22), PY(18)];
_ctrlGrpUnitInfoSquad ctrlCommit 0;

private _ctrlSquadPicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrpUnitInfoSquad];
_ctrlSquadPicture ctrlSetPosition [PX(5), PY(2), PX(12), PY(12)];
_ctrlSquadPicture ctrlSetText "\A3\Ui_f\Data\GUI\Cfg\UnitInsignia\CTRG.paa"; // Squad XML Picture
_ctrlSquadPicture ctrlCommit 0;

private _ctrlSquadName = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrpUnitInfoSquad];
_ctrlSquadName ctrlSetPosition [PX(0), PY(14.5), PX(22), PY(3)];
_ctrlSquadName ctrlSetFontHeight PY(2.4);
_ctrlSquadName ctrlSetFont "RobotoCondensedBold";
_ctrlSquadName ctrlSetTextColor [1, 1, 1, 1];
_ctrlSquadName ctrlSetText "ARMA AT WAR"; // Squad XML Name
_ctrlSquadName ctrlCommit 0;

private _ctrlGrpUnitInfoHealth= _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpUnitInfo];
_ctrlGrpUnitInfoHealth ctrlSetPosition [PX(24), PY(8), PX(14), PY(6)];
_ctrlGrpUnitInfoHealth ctrlCommit 0;

private _ctrlHealthRing = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrpUnitInfoHealth];
_ctrlHealthRing ctrlSetPosition [PX(0), PY(0), PX(6), PY(6)];
_ctrlHealthRing ctrlSetText "\A3\Ui_f\Data\igui\cfg\holdactions\progress\progress_24_ca.paa";
_ctrlHealthRing ctrlCommit 0;

private _ctrlHealthIcon = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrpUnitInfoHealth];
_ctrlHealthIcon ctrlSetPosition [PX(0), PY(0), PX(6), PY(6)];
_ctrlHealthIcon ctrlSetText "\A3\Ui_f\Data\igui\cfg\holdactions\holdaction_revive_ca.paa";
_ctrlHealthIcon ctrlCommit 0;

private _ctrlHealthValue = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrpUnitInfoHealth];
_ctrlHealthValue ctrlSetPosition [PX(6), PY(0), PX(8), PY(6)];
_ctrlHealthValue ctrlSetFontHeight PY(3.2);
_ctrlHealthValue ctrlSetFont "RobotoCondensed";
_ctrlHealthValue ctrlSetTextColor [1, 1, 1, 1];
_ctrlHealthValue ctrlSetText "100"; // Squad XML Name
_ctrlHealthValue ctrlCommit 0;

private _ctrlGrpUnitInfoShots= _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpUnitInfo];
_ctrlGrpUnitInfoShots ctrlSetPosition [PX(24), PY(17), PX(14), PY(6)];
_ctrlGrpUnitInfoShots ctrlCommit 0;

private _ctrlShotsIcon = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrpUnitInfoShots];
_ctrlShotsIcon ctrlSetPosition [PX(1), PY(1), PX(4), PY(4)];
_ctrlShotsIcon ctrlSetText "\A3\Ui_f\Data\gui\cfg\respawnroles\assault_ca.paa"; // Squad XML Picture
_ctrlShotsIcon ctrlCommit 0;

private _ctrlShotsValue = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrpUnitInfoShots];
_ctrlShotsValue ctrlSetPosition [PX(6), PY(0), PX(8), PY(6)];
_ctrlShotsValue ctrlSetFontHeight PY(3.2);
_ctrlShotsValue ctrlSetFont "RobotoCondensed";
_ctrlShotsValue ctrlSetTextColor [1, 1, 1, 1];
_ctrlShotsValue ctrlSetText "999"; // Squad XML Name
_ctrlShotsValue ctrlCommit 0;

private _ctrlWeaponSlots = [];
private _xPosition = 41;
{
    private _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpUnitInfo];
    _ctrlGrp ctrlSetPosition [PX(_xPosition), PY(8), PX(16), PY(14)];
    _ctrlGrp ctrlCommit 0;

    private _ctrlWeaponPicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrp];
    _ctrlWeaponPicture ctrlSetPosition [PX(0), PY(3), PX(16), PY(8)];
    _ctrlWeaponPicture ctrlSetText (_x select 1); // Weapon Icon
    _ctrlWeaponPicture ctrlCommit 0;

    private _ctrlWeaponName = _display ctrlCreate ["RscTitle", -1, _ctrlGrp];
    _ctrlWeaponName ctrlSetPosition [0, 0, PX(16), PY(3)];
    _ctrlWeaponName ctrlSetFontHeight PY(2.4);
    _ctrlWeaponName ctrlSetFont "RobotoCondensedBold";
    _ctrlWeaponName ctrlSetTextColor [1, 1, 1, 1];
    _ctrlWeaponName ctrlSetText (_x select 0); //Weapon Name
    _ctrlWeaponName ctrlCommit 0;

    private _ctrlMagInfo = _display ctrlCreate ["RscTitle", -1, _ctrlGrp];
    _ctrlMagInfo ctrlSetPosition [0, PY(11), PX(10), PY(3)];
    _ctrlMagInfo ctrlSetFontHeight PY(2.4);
    _ctrlMagInfo ctrlSetFont "RobotoCondensed";
    _ctrlMagInfo ctrlSetTextColor [1, 1, 1, 1];
    _ctrlMagInfo ctrlSetText "300 / 300"; //Magazine load
    _ctrlMagInfo ctrlCommit 0;

    private _ctrlMagIcon = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlGrp];
    _ctrlMagIcon ctrlSetPosition [PX(10), PY(11), PX(3), PY(3)];
    _ctrlMagIcon ctrlSetText "\A3\ui_f\data\gui\rsc\rscdisplayarsenal\cargomagall_ca.paa";
    _ctrlMagIcon ctrlCommit 0;

    private _ctrlMagInfo2 = _display ctrlCreate ["RscTextNoShadow", -1, _ctrlGrp];
    _ctrlMagInfo2 ctrlSetPosition [PX(13), PY(11), PX(3), PY(3)];
    _ctrlMagInfo2 ctrlSetFontHeight PY(2.4);
    _ctrlMagInfo2 ctrlSetFont "RobotoCondensed";
    _ctrlMagInfo2 ctrlSetTextColor [1, 1, 1, 1];
    _ctrlMagInfo2 ctrlSetText "99"; //Magazine load
    _ctrlMagInfo2 ctrlCommit 0;
    _xPosition = _xPosition + 19.5;
    _ctrlWeaponSlots pushback [_ctrlGrp, _ctrlWeaponPicture, _ctrlWeaponName, _ctrlMagInfo, _ctrlMagInfo2, _ctrlMagIcon];
} forEach [
    ["MX 6.5MM", "\A3\weapons_F\Rifles\MX\data\UI\gear_mx_rifle_X_CA.paa"],
    ["NLAW","\A3\weapons_f\launchers\nlaw\data\UI\gear_nlaw_ca.paa"],
    ["P07 9MM","\A3\weapons_F\Pistols\P07\data\UI\gear_p07_x_ca.paa"]
];

private _xPosition = 38;
private _ctrlStats = [];
{
    private _grp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpUnitInfo];
    _grp ctrlSetPosition [PX(_xPosition), PY(1.4), PX(8), PY(3)];
    _grp ctrlCommit 0;

    private _picture = _display ctrlCreate ["RscPictureKeepAspect", -1, _grp];
    _picture ctrlSetPosition [PX(0), PY(0), PX(3.2), PY(3.2)];
    _picture ctrlSetText _x; // Squad XML Picture
    _picture ctrlSetTextColor [1,1,1,1];
    _picture ctrlCommit 0;

    private _text = _display ctrlCreate ["RscTextNoShadow", -1, _grp];
    _text ctrlSetPosition [PX(3.4), PY(0), PX(5), PY(3.2)];
    _text ctrlSetFontHeight PY(3.2);
    _text ctrlSetFont "RobotoCondensed";
    _text ctrlSetTextColor [1, 1, 1, 1];
    _text ctrlSetText "88"; //Magazine load
    _text ctrlCommit 0;

    _ctrlStats pushBack [_grp, _picture, _text];
    _xPosition = _xPosition + 10;
} forEach [
    "\A3\ui_f\data\igui\cfg\mptable\infantry_ca.paa",
    "\A3\ui_f\data\map\vehicleicons\icontruck_ca.paa",
    "\A3\ui_f\data\map\vehicleicons\icontank_ca.paa",
    "\A3\ui_f\data\map\vehicleicons\iconhelicopter_ca.paa",
    "\A3\ui_f_curator\data\cfgmarkers\kia_ca.paa",
    "\A3\ui_f\data\igui\cfg\mptable\total_ca.paa"
];

private _ctrlStatsTotalValue = (_ctrlStats select 5) select 2;
_ctrlStatsTotalValue ctrlSetPosition [PX(3), PY(0), PX(8), PY(3)];
_ctrlStatsTotalValue ctrlCommit 0;

private _unitInfoAllCtrls = [
    _ctrlGrpUnitInfo,
    _ctrlGrpUnitInfoBackground,
    _ctrlUnitName,
    _ctrlUnitRoleIconBackground,
    _ctrlUnitRoleIcon,
    _ctrlGrpName,
    _ctrlGrpUnitInfoSquad,
    _ctrlSquadPicture,
    _ctrlSquadName,
    _ctrlGrpUnitInfoHealth,
    _ctrlHealthIcon,
    _ctrlHealthRing,
    _ctrlHealthValue,
    _ctrlGrpUnitInfoShots,
    _ctrlShotsIcon,
    _ctrlShotsValue,
    _ctrlWeaponSlots,
    _ctrlStats
];

[QGVAR(UpdateUnitInfo), {
    (_this select 0) params ["_unit"];
    (_this select 1) params ["_ctrlGrp", "", "_ctrlUnitName",
    "_ctrlRoleIconBackground", "_ctrlUnitRoleIcon", "_ctrlGroupId",
    "","_ctrlSquadPicture", "_ctrlSquadName",
    "", "", "_ctrlHealthRing", "_ctrlHealthValue",
    "", "_ctrlShotsIcon", "_ctrlShotsValue",
    "_ctrlWeaponSlots", "_ctrlStats"];

    if (isNull _unit) then {
        QGVAR(CloseUnitInfo) call CFUNC(localEvent);
    };

    // set unit name
    _ctrlUnitName ctrlSetText (_unit call CFUNC(name));
    _ctrlUnitName ctrlCommit 0;

    // set side color
    private _color = GVAR(SideColorsArray) getVariable [str side _unit, [0,0,0,1]];
    _ctrlRoleIconBackground ctrlSetText format ["#(argb,8,8,3)color(%1,%2,%3,1)", _color select 0, _color select 1, _color select 2];
    _ctrlRoleIconBackground ctrlCommit 0;

    _ctrlUnitRoleIcon ctrlSetText ((_unit call FUNC(getUnitType)) select 0);
    _ctrlUnitRoleIcon ctrlCommit 0;

    // set group id
    _ctrlGroupId ctrlSetText toUpper (groupId group _unit);
    _ctrlGroupId ctrlCommit 0;

    // set squad xml info /
    private _squadParams = squadParams _unit;
    LOG("Squad Params: " + str _squadParams);
    if (_squadParams isEqualTo []) then {
        _ctrlSquadName ctrlSetText "";
        _ctrlSquadName ctrlCommit 0;

        private _squadImage = [_unit] call BIS_fnc_getUnitInsignia;
        if (_squadImage == "") then {
            _squadImage = "\A3\Ui_f\Data\GUI\Cfg\LoadingScreens\A3_LoadingLogo_ca.paa";
        };
        _ctrlSquadPicture ctrlSetText _squadImage;
        _ctrlSquadPicture ctrlCommit 0;
    } else {
        _squadParams = _squadParams select 0;
        _ctrlSquadName ctrlSetText toUpper (_squadParams select 1);
        _ctrlSquadName ctrlCommit 0;

        _ctrlSquadPicture ctrlSetText (_squadParams select 4);
        _ctrlSquadPicture ctrlCommit 0;
    };

    // set health
    private _health = 1 - damage _unit;
    _ctrlHealthRing ctrlSetText format ["\A3\Ui_f\Data\igui\cfg\holdactions\progress\progress_%1_ca.paa", round (_health*24)];
    _ctrlHealthRing ctrlCommit 0;
    _ctrlHealthValue ctrlSetText format ["%1", round (_health*100)];
    _ctrlHealthValue ctrlCommit 0;

    // set number of shots
    _ctrlShotsValue ctrlSetText format ["%1", _unit getVariable [QGVAR(shotCount), 0]];
    _ctrlShotsValue ctrlCommit 0;
    if ((time - (_unit getVariable [QGVAR(lastShot), 0])) <= 0.5) then {
        _ctrlShotsIcon ctrlSetPosition [PX(0.5), PY(0.5), PX(5), PY(5)];
        _ctrlShotsIcon ctrlCommit 0;
        _ctrlShotsIcon ctrlSetPosition [PX(1), PY(1), PX(4), PY(4)];
        _ctrlShotsIcon ctrlCommit 0.5;
    };


    // setup weapons
    private _cfgWeapons = configFile >> "CfgWeapons";
    private _cfgMagazines = configFile >> "CfgMagazines";
    private _primaryMagLoaded = "";
    private _nbrPrimaryMags = 0;
    private _secondaryMagLoaded = "";
    private _nbrSecondaryMags = 0;
    private _handgunMagLoaded = "";
    private _nbrHandgunMags = 0;

    {
        _x params ["_class", "_ammo", "_loaded"];

        switch (true) do {
            case (_class in ((primaryWeapon _unit) call FUNC(compatibleMagazines))): {
                if (_loaded) then {
                    _primaryMagLoaded = format[ "%1 / %2", _ammo, getNumber (_cfgMagazines >> _class >> "count")];
                } else {
                    _nbrPrimaryMags = _nbrPrimaryMags + 1;
                };
            };
            case (_class in ((handgunWeapon _unit) call FUNC(compatibleMagazines))): {
                if (_loaded) then {
                    _handgunMagLoaded = format[ "%1 / %2", _ammo, getNumber (_cfgMagazines >> _class >> "count")];
                } else {
                    _nbrHandgunMags = _nbrHandgunMags + 1;
                };
            };
            case (_class in ((secondaryWeapon _unit) call FUNC(compatibleMagazines))): {
                if (_loaded) then {
                    _secondaryMagLoaded = format[ "%1 / %2", _ammo, getNumber (_cfgMagazines >> _class >> "count")];
                } else {
                    _nbrSecondaryMags = _nbrSecondaryMags + 1;
                };
            };
        };
    } forEach magazinesAmmoFull _unit;

    private _magInfo = [_primaryMagLoaded, _secondaryMagLoaded, _handgunMagLoaded];
    private _magInfo2 = [format ["%1", _nbrPrimaryMags], format ["%1", _nbrSecondaryMags], format ["%1", _nbrHandgunMags]];
    private _weaponclass = [primaryWeapon _unit, secondaryWeapon _unit, handgunWeapon _unit];
    private _emptyPicture = [
        "A3\ui_f\data\gui\rsc\rscdisplaygear\ui_gear_primary_gs.paa",
        "A3\ui_f\data\gui\rsc\rscdisplaygear\ui_gear_secondary_gs.paa",
        "A3\ui_f\data\gui\rsc\rscdisplaygear\ui_gear_hgun_gs.paa"
    ];

    private _currentWeapon = currentWeapon _unit;
    {
        _x params ["", "_ctrlPicture", "_ctrlName", "_ctrlMagInfo",
        "_ctrlMagInfo2", "_ctrlMagIcon"];

        private _thisWeaponClass = (_weaponclass select _forEachIndex);

        private _weaponName = "";
        private _picture = _emptyPicture select _forEachIndex;
        if (_thisWeaponClass != "") then {
            _weaponName = toUpper getText (_cfgWeapons >> _thisWeaponClass >> "displayname");
            _picture = getText (_cfgWeapons >> _thisWeaponClass >> "picture");
        };

        private _textColor = [1,1,1,0.5];

        if (_currentWeapon == _thisWeaponClass && _thisWeaponClass != "") then {
            _textColor = [1,1,1,1];
        };
        _ctrlPicture ctrlSetText _picture;
        _ctrlPicture ctrlCommit 0;

        _ctrlName ctrlSetText _weaponName;
        _ctrlName ctrlSetTextColor _textColor;
        _ctrlName ctrlCommit 0;

        _ctrlMagInfo ctrlSetText (_magInfo select _forEachIndex);
        _ctrlMagInfo ctrlSetTextColor _textColor;
        _ctrlMagInfo ctrlCommit 0;

        if (_thisWeaponClass == "" || (_magInfo2 select _forEachIndex) == "0") then {
            _ctrlMagIcon ctrlSetText "";
            _ctrlMagIcon ctrlCommit 0;

            _ctrlMagInfo2 ctrlSetText "";
            _ctrlMagInfo2 ctrlCommit 0;
        } else {
            _ctrlMagIcon ctrlSetText "\A3\ui_f\data\gui\rsc\rscdisplayarsenal\cargomagall_ca.paa";
            _ctrlMagIcon ctrlSetTextColor _textColor;
            _ctrlMagIcon ctrlCommit 0;

            _ctrlMagInfo2 ctrlSetText (_magInfo2 select _forEachIndex);
            _ctrlMagInfo2 ctrlSetTextColor _textColor;
            _ctrlMagInfo2 ctrlCommit 0;
        };
    } forEach _ctrlWeaponSlots;

    // set score
    private _scores = getPlayerScores _unit;
    if (_scores isEqualTo []) then {
        _scores = [0, 0, 0, 0, 0, 0];
    };

    {
        _x params ["", "", "_ctrlValue"];
        private _value = _scores select _forEachIndex;
        if (_value == 0) then {
            _ctrlValue ctrlSetTextColor [1,1,1,0.5];
        } else {
            _ctrlValue ctrlSetTextColor [1,1,1,1];
        };

        _ctrlValue ctrlSetText format ["%1", _value];
        _ctrlValue ctrlCommit 0;
    } forEach _ctrlStats;
}, _unitInfoAllCtrls] call CFUNC(addEventhandler);

[QGVAR(OpenUnitInfo), {
    (_this select 0) params ["_unit"];
    (_this select 1) params ["_ctrlGrp","","","","","","","_ctrlSquadPicture"];
    if (isNull _unit) exitWith {
        QGVAR(CloseUnitInfo) call CFUNC(localEvent);
    };
    if !(_unit isKindOf "CAManBase") then {
        private _crew = crew _unit;
        if !(_crew isEqualTo []) then {
            _unit = _crew select 0;
        };
    };
    if !(_unit isKindOf "CAManBase") exitWith {
        QGVAR(CloseUnitInfo) call CFUNC(localEvent);
    };
    if (isNull _unit) exitWith {
        QGVAR(CloseUnitInfo) call CFUNC(localEvent);
    };
    GVAR(UnitInfoTarget) = _unit;
    if (GVAR(UnitInfoOpen)) exitWith {
        [QGVAR(UpdateUnitInfo), _unit] call CFUNC(localEvent);
    };
    _ctrlGrp ctrlSetPosition [safeZoneW/2-PX(50), safeZoneH - PY(BORDERWIDTH) - PY(26), 0, PY(6)];
    _ctrlGrp ctrlShow true;
    _ctrlGrp ctrlSetFade 1;
    _ctrlGrp ctrlCommit 0;

    [QGVAR(UpdateUnitInfo), _unit] call CFUNC(localEvent);

    _ctrlGrp ctrlSetPosition [safeZoneW/2-PX(50), safeZoneH - PY(BORDERWIDTH) - PY(26), PX(100), PY(6)];
    _ctrlGrp ctrlSetFade 0;
    _ctrlGrp ctrlCommit 0.3;

    _ctrlSquadPicture ctrlSetPosition [PX(11), PY(2), 0, PY(12)];
    _ctrlSquadPicture ctrlCommit 0;

    [{
        _this params ["_ctrlGrp","_ctrlSquadPicture"];
        _ctrlGrp ctrlSetPosition [safeZoneW/2-PX(50), safeZoneH - PY(BORDERWIDTH) - PY(26), PX(100), PY(24)];
        _ctrlGrp ctrlCommit 0.5;
        _ctrlSquadPicture ctrlSetPosition [PX(5), PY(2), PX(12), PY(12)];
        _ctrlSquadPicture ctrlCommit 0.5;
    }, 0.5, [_ctrlGrp, _ctrlSquadPicture]] call CFUNC(wait);

    [{
        private _unit = GVAR(UnitInfoTarget);
        if (GVAR(UnitInfoOpen)) then {
            [QGVAR(UpdateUnitInfo), _unit] call CFUNC(localEvent);
        } else {
            (_this select 1) call CFUNC(removePerFrameHandler);
        };
    }, 0.5] call CFUNC(addPerFrameHandler);

    GVAR(UnitInfoOpen) = true;
}, _unitInfoAllCtrls] call CFUNC(addEventhandler);

[QGVAR(CloseUnitInfo), {
    (_this select 1) params ["_ctrlGrp"];

    if (!GVAR(UnitInfoOpen)) exitWith {};
    _ctrlGrp ctrlSetPosition [safeZoneW/2-PX(50), safeZoneH - PY(BORDERWIDTH) - PY(2), PX(100), 0];
    _ctrlGrp ctrlSetFade 1;
    _ctrlGrp ctrlCommit 0.3;

    [{
        _this ctrlShow false;
    }, 0.3, _ctrlGrp] call CFUNC(wait);

    GVAR(UnitInfoOpen) = false;
}, _unitInfoAllCtrls] call CFUNC(addEventhandler);
