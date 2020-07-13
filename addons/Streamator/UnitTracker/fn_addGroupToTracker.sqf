#include "macros.hpp"
/*
    Stremator

    Author: BadGuy, joko // Jonas

    Description:
    Add or Update Group in Tracker

    Parameter(s):
    0: group <Group>

    Returns:
    0: Return Id <STRING>
*/
params ["_group", "_groupIconId", ["_attachTo", [0, -20]]];

private _color = EGVAR(Spectator,SideColorsArray) getVariable [str side _group, [1, 1, 1, 1]];

private _groupMapIcon = _group getVariable QEGVAR(Spectator,GroupIcon);
if (isNil "_groupMapIcon") then {
    _groupMapIcon = [side _group] call EFUNC(Spectator,getDefaultIcon);
    _group setVariable [QEGVAR(Spectator,GroupIcon), _groupMapIcon];
};

private _iconPos = [vehicle leader _group, _attachTo];

private _groupIdElements = (groupId _group) splitString " ";
private _firstGroupIdElement = _groupIdElements deleteAt 0;
private _shortGroupId = format ["%1 %2", _firstGroupIdElement select [0, 1], _groupIdElements joinString " "];

[
    _groupIconId,
    [
        ["ICON", _groupMapIcon, _color, _iconPos, 25, 25],
        ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _iconPos, 26, 26, 0, _shortGroupId, 2]
    ]
] call CFUNC(addMapGraphicsGroup);

[
    _groupIconId,
    [
        ["ICON", _groupMapIcon, _color, _iconPos, 30, 30],
        ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _iconPos, 31, 31, 0, _shortGroupId, 2]
    ],
    "hover"
] call CFUNC(addMapGraphicsGroup);

[_groupIconId, "dblclicked", {
    (_this select 1) params ["_unit"];
    GVAR(CameraPreviousState) = [];
    [_unit, [EGVAR(Spectator,CameraMode), CAMERAMODE_FOLLOW] select (EGVAR(Spectator,CameraMode) == CAMERAMODE_FREE)] call EFUNC(Spectator,setCameraTarget);
}, leader _group] call CFUNC(addMapGraphicsEventHandler);

[
    _groupIconId,
    "hoverin",
    {
        (_this select 0) params ["_map"];
        (_this select 1) params ["_group", "_attachTo"];

        if (_group isEqualTo GVAR(currentHoverGroup)) exitWith {};
        GVAR(currentHoverGroup) = _group;
        _group setVariable [QGVAR(isHoveredOn), true];
        private _pos = _map ctrlMapWorldToScreen getPosVisual (vehicle leader _group);
        _pos set [0, (_pos select 0) + 15 / 640];
        _pos set [1, (_pos select 1) + (((_attachTo) select 1) + 5) / 480];

        private _display = ctrlParent _map;
        private _idd = ctrlIDD _display;

        private _ctrlGrp = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_Group), _idd], controlNull];
        private _ctrlSquadName = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_SquadName), _idd], controlNull];
        // private _ctrlSquadType = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_SquadType), _idd], controlNull];
        // private _ctrlSquadDescription = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_SquadDescription), _idd], controlNull];
        // private _ctrlSquadMemberCount = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_SquadMemberCount), _idd], controlNull];
        private _ctrlBgBottom = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_BgBottom), _idd], controlNull];
        private _ctrlMemberList = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_MemberList), _idd], controlNull];
        private _textSize = PY(1.8) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
        if (isNull _ctrlGrp) then {
            _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
            _ctrlGrp ctrlSetFade 0;
            _ctrlGrp ctrlCommit 0;
            uiNamespace setVariable [format [UIVAR(GroupInfo_%1_Group), _idd], _ctrlGrp];

            private _ctrlBg = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
            _ctrlBg ctrlSetText "#(argb,8,8,3)color(0,0,0,0.8)";
            _ctrlBg ctrlSetPosition [0, 0, PX(22), PY(2)];
            _ctrlBg ctrlCommit 0;

            _ctrlBgBottom = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
            _ctrlBgBottom ctrlSetText "#(argb,8,8,3)color(0,0,0,0.8)";
            _ctrlBgBottom ctrlSetPosition [0, PY(2.2), PX(22), PY(12)];
            uiNamespace setVariable [format [UIVAR(GroupInfo_%1_BgBottom), _idd], _ctrlBgBottom];

            _ctrlSquadName = _display ctrlCreate ["RscText", -1, _ctrlGrp];
            _ctrlSquadName ctrlSetFontHeight PY(1.8);
            _ctrlSquadName ctrlSetPosition [0, 0, PX(11), PY(2)];
            _ctrlSquadName ctrlSetFont "PuristaBold";
            _ctrlSquadName ctrlSetText "ALPHA";
            uiNamespace setVariable [format [UIVAR(GroupInfo_%1_SquadName), _idd], _ctrlSquadName];

            _ctrlMemberList = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
            _ctrlMemberList ctrlSetFontHeight PY(4);
            _ctrlMemberList ctrlSetPosition [0, PY(2.4), PX(22), PY(11.9)];
            _ctrlMemberList ctrlSetFont "PuristaMedium";
            _ctrlMemberList ctrlSetTextColor [1, 1, 1, 1];
            _ctrlMemberList ctrlSetText "ALPHA";
            uiNamespace setVariable [format [UIVAR(GroupInfo_%1_MemberList), _idd], _ctrlMemberList];
        };

        _ctrlGrp ctrlSetPosition [_pos select 0, _pos select 1, PX(22), PY(50)];
        _ctrlGrp ctrlShow true;

        _ctrlSquadName ctrlSetText toUpper groupId _group;

        private _units = units _group;


        private _squadUnits = "";
        private _unitCount = {
            private _kitIcon = _x call EFUNC(Spectator,getUnitType);
            _squadUnits = _squadUnits + format ["<img size='0.7' color='#ffffff' image='%1'/> %2<br />", _kitIcon select 0, [_x] call CFUNC(name)];
            true;
        } count _units;

        _ctrlMemberList ctrlSetStructuredText parseText format ["<t size=""%1"">%2</t>", _textSize, _squadUnits];

        _ctrlBgBottom ctrlSetPosition [0, PY(2.2), PX(22), _unitCount * PY(1.8) + PY(0.4)];

        _ctrlMemberList ctrlSetPosition [0, PY(2.4), PX(22), _unitCount * PY(1.8)];

        {
            _x ctrlCommit 0;
            nil;
        } count [_ctrlGrp, _ctrlSquadName, _ctrlBgBottom, _ctrlMemberList];

        ctrlSetFocus _ctrlGrp;

        if (GVAR(groupInfoPFH) != -1) then {
            GVAR(groupInfoPFH) call CFUNC(removePerFrameHandler);
        };

        GVAR(groupInfoPFH) = [{
            params ["_params", "_id"];
            _params params ["_group", "_map", "_attachTo"];

            private _pos = _map ctrlMapWorldToScreen getPosVisual (vehicle leader _group);
            _pos set [0, (_pos select 0) + 15 / 640];
            _pos set [1, (_pos select 1) + ((_attachTo select 1) + 5) / 480];

            private _grp = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_Group), ctrlIDD ctrlParent _map], controlNull];

            if (isNull _grp || (_map == ((findDisplay 12) displayCtrl 51) && !visibleMap) || isNull _map) exitWith {
                _id call CFUNC(removePerFrameHandler);
                _grp ctrlShow false;
                _grp ctrlCommit 0;
            };

            _grp ctrlSetPosition _pos;
            _grp ctrlCommit 0;

        }, 0, [_group, _map, _attachTo]] call CFUNC(addPerFrameHandler);
    },
    [_group, _attachTo]
] call CFUNC(addMapGraphicsEventHandler);

[
    _groupIconId,
    "hoverout",
    {
        (_this select 0) params ["_map"];
        (_this select 1) params ["_group"];

        if (GVAR(currentHoverGroup) isEqualTo _group) then {
            GVAR(currentHoverGroup) = grpNull;
        };
        _group setVariable [QGVAR(isHoveredOn), false];
        private _grp = uiNamespace getVariable [format [UIVAR(GroupInfo_%1_Group), ctrlIDD ctrlParent _map], controlNull];
        if (!isNull _grp) then {
            _grp ctrlShow false;
            _grp ctrlCommit 0;
        };

        if (GVAR(groupInfoPFH) != -1) then {
            GVAR(groupInfoPFH) call CFUNC(removePerFrameHandler);
        };

    },
    _group
] call CFUNC(addMapGraphicsEventHandler);
_groupIconId;
