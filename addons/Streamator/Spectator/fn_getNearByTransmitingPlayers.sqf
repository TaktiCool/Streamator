#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Get Units Nearby Using ACE Map Gestures

    Parameter(s):
    None

    Returns:
    None
*/

private _players = (positionCameraToWorld [0, 0, 0]) nearEntities [["CAMAnBase"], ace_map_gestures_maxRange];
if !(isNull GVAR(CameraFollowTarget)) then {
    _players append (GVAR(CameraFollowTarget) nearEntities [["CAMAnBase"], ace_map_gestures_maxRange]);
    _players pushBackUnique GVAR(CameraFollowTarget);
    _players append (crew vehicle GVAR(CameraFollowTarget));
};
_players = _players arrayIntersect _players;
_players select { alive _x && { !((lifeState _x) in ["DEAD-RESPAWN","DEAD-SWITCHING","DEAD","INCAPACITATED","INJURED"]) } };
