#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy, joko // Jonas

    Description:
    Add or Update Group in Tracker

    Parameter(s):
    0: group <Group>

    Returns:
    0: Return Id <STRING>
*/
params ["_vehicle", "_vehicleIconId", ["_inGroup", false], ["_isEmpty", false]];

private _color = EGVAR(Spectator,SideColorsArray) getVariable [(str (side _vehicle)), [0.5, 0.5, 0.5, 1]];
if (_isEmpty) then {
    _color =  [0.93, 0.7, 0.01, 0.6];
};
private _vehicleMapIcon = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "Icon");

private _vehIcon = ["ICON", _vehicleMapIcon, _color, _vehicle, 30, 30, _vehicle, "", 1];
private _vehIconHover = ["ICON", "\a3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa", [0.85,0.85,0,1], _vehicle, 25, 25, _vehicle, "", 1, 0.08, "RobotoCondensed", "right"];

[_vehicleIconId, [_vehIcon]] call CFUNC(addMapGraphicsGroup);
[_vehicleIconId, [_vehIcon, _vehIconHover], "hover"] call CFUNC(addMapGraphicsGroup);

[_vehicleIconId, "dblclicked", {
    (_this select 1) params ["_vehicle"];
    _vehicle call EFUNC(Spectator,setCameraTarget);
}, _vehicle] call CFUNC(addMapGraphicsEventHandler);


[
    _vehicleIconId,
    "hoverin",
    {
        (_this select 0) params ["_map", "_xPos", "_yPos"];
        (_this select 1) params ["_vehicle"];

        if (_vehicle isEqualTo GVAR(currentHoverVehicle)) exitWith {};
        GVAR(currentHoverVehicle) = _vehicle;

        private _pos = _map ctrlMapWorldToScreen getPosVisual _vehicle;
        _pos set [0, (_pos select 0) + 15 / 640];
        _pos set [1, (_pos select 1)];

        private _display = ctrlParent _map;
        private _idd = ctrlIDD _display;

        private _ctrlGrp = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_Group), _idd], controlNull];
        private _ctrlVehicleName = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_VehicleName), _idd], controlNull];
        private _ctrlTotalSeats = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_TotalSeats), _idd], controlNull];
        private _ctrlBgBottom = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_BgBottom), _idd], controlNull];
        private _ctrlMemberList = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_MemberList), _idd], controlNull];
        private _textSize = PY(1.8) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
        if (isNull _ctrlGrp) then {
            _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
            _ctrlGrp ctrlSetFade 0;
            _ctrlGrp ctrlCommit 0;
            uiNamespace setVariable [format [UIVAR(VehicleInfo_%1_Group), _idd], _ctrlGrp];

            private _ctrlBg = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
            _ctrlBg ctrlSetText "#(argb,8,8,3)color(0,0,0,0.8)";
            _ctrlBg ctrlSetPosition [0, 0, PX(22), PY(2)];
            _ctrlBg ctrlCommit 0;

            _ctrlBgBottom = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
            _ctrlBgBottom ctrlSetText "#(argb,8,8,3)color(0,0,0,0.8)";
            _ctrlBgBottom ctrlSetPosition [0, PY(2.2), PX(22), PY(12)];
            uiNamespace setVariable [format [UIVAR(VehicleInfo_%1_BgBottom), _idd], _ctrlBgBottom];

            _ctrlVehicleName = _display ctrlCreate ["RscText", -1, _ctrlGrp];
            _ctrlVehicleName ctrlSetFontHeight PY(1.8);
            _ctrlVehicleName ctrlSetPosition [0, 0, PX(18), PY(2)];
            _ctrlVehicleName ctrlSetFont "PuristaBold";
            _ctrlVehicleName ctrlSetText "HUNTER";
            uiNamespace setVariable [format [UIVAR(VehicleInfo_%1_VehicleName), _idd], _ctrlVehicleName];

            _ctrlTotalSeats = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
            _ctrlTotalSeats ctrlSetFontHeight PY(1.8);
            _ctrlTotalSeats ctrlSetPosition [PX(16.5), PY(0), PX(5), PY(2)];
            _ctrlTotalSeats ctrlSetFont "PuristaMedium";
            _ctrlTotalSeats ctrlSetTextColor [0.5, 0.5, 0.5, 1];
            _ctrlTotalSeats ctrlSetStructuredText parseText "ALPHA";
            uiNamespace setVariable [format [UIVAR(VehicleInfo_%1_TotalSeats), _idd], _ctrlTotalSeats];

            _ctrlMemberList = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
            _ctrlMemberList ctrlSetFontHeight PY(4);
            _ctrlMemberList ctrlSetPosition [0, PY(2.4), PX(21.5), PY(11.9)];
            _ctrlMemberList ctrlSetFont "PuristaMedium";
            _ctrlMemberList ctrlSetTextColor [1, 1, 1, 1];
            _ctrlMemberList ctrlSetText "ALPHA";
            uiNamespace setVariable [format [UIVAR(VehicleInfo_%1_MemberList), _idd], _ctrlMemberList];
        };

        _ctrlGrp ctrlSetPosition [_pos select 0, _pos select 1, PX(22), PY(50)];
        _ctrlGrp ctrlShow true;

        _ctrlVehicleName ctrlSetText toUpper getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");

        private _maxCrewSize = [typeOf _vehicle, true] call BIS_fnc_crewCount;
        private _units = crew _vehicle;

        private _crewUnits = "";
        private _unitCount = {
            if (alive _x) then {
                private _kitIcon = _x call EFUNC(Spectator,getUnitType);
                _crewUnits = _crewUnits + format ["<img size='0.7' color='#ffffff' image='%1'/> %2<br />", _kitIcon, [_x] call CFUNC(name)];
                true;
            } else {
                false;
            }
        } count _units;

        _ctrlTotalSeats ctrlSetStructuredText parseText format ["<t size=""%1"" align=""right"">%2 / %3</t>", _textSize, _unitCount, _maxCrewSize];

        _ctrlMemberList ctrlSetStructuredText parseText format ["<t size=""%1"">%2</t>", _textSize, _crewUnits];

        _ctrlBgBottom ctrlSetPosition [0, PY(2.2), PX(22), _unitCount * PY(1.8) + PY(0.4)];
        _ctrlBgBottom ctrlShow (_unitCount > 0);

        _ctrlMemberList ctrlSetPosition [0, PY(2.4), PX(22), _unitCount * PY(1.8)];

        {
            _x ctrlCommit 0;
            nil;
        } count [_ctrlGrp, _ctrlVehicleName, _ctrlTotalSeats, _ctrlBgBottom, _ctrlMemberList];

        ctrlSetFocus _ctrlGrp;

        if (GVAR(VehicleInfoPFH) != -1) then {
            GVAR(VehicleInfoPFH) call CFUNC(removePerFrameHandler);
        };

        GVAR(VehicleInfoPFH) = [{
            params ["_params", "_id"];
            _params params ["_vehicle", "_map"];

            private _pos = _map ctrlMapWorldToScreen getPosVisual _vehicle;
            _pos set [0, (_pos select 0) + 15 / 640];
            _pos set [1, (_pos select 1)];

            private _grp = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_Group), ctrlIDD ctrlParent _map], controlNull];

            if (isNull _grp || (_map == ((findDisplay 12) displayCtrl 51) && !visibleMap) || isNull _map) exitWith {
                _id call CFUNC(removePerFrameHandler);
                _grp ctrlShow false;
                //ctrlDelete _grp;
                _grp ctrlCommit 0;
            };

            _grp ctrlSetPosition _pos;
            _grp ctrlCommit 0;

        }, 0, [_vehicle, _map]] call CFUNC(addPerFrameHandler);
    },
    _vehicle
] call CFUNC(addMapGraphicsEventHandler);

[
    _vehicleIconId,
    "hoverout",
    {
        (_this select 0) params ["_map", "_xPos", "_yPos"];
        (_this select 1) params ["_vehicle"];

        if (GVAR(currentHoverVehicle) isEqualTo _vehicle) then {
            GVAR(currentHoverVehicle) = objNull;
        };

        private _grp = uiNamespace getVariable [format [UIVAR(VehicleInfo_%1_Group), ctrlIDD ctrlParent _map], controlNull];
        if (!isNull _grp) then {
            _grp ctrlShow false;
            _grp ctrlCommit 0;
        };

        if (GVAR(VehicleInfoPFH) != -1) then {
            GVAR(VehicleInfoPFH) call CFUNC(removePerFrameHandler);
        };

    },
    _vehicle
] call CFUNC(addMapGraphicsEventHandler);
_vehicleIconId;
