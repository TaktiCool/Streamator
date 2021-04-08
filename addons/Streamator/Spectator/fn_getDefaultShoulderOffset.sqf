#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Get Default Should Offset for Vehicle

    Parameter(s):
    0: Target Object <Object>

    Returns:
    Should Offset Positions <Array>
*/
params [["_target", objNull, [objNull]]];

private _vehicle = vehicle _target;


    if (_vehicle isKindOf "Plane") exitWith {
        private _bb = 0 boundingBoxReal (driver _vehicle);
        [_bb select 1 select 0, _bb select 1 select 1,_bb select 1 select 2];
    };
    if (_vehicle isKindOf "Helicopter") exitWith {
        private _bb = 0 boundingBoxReal _vehicle;
        [(_bb select 1 select 0)*0.3, -(_bb select 1 select 1)*0.1,(_bb select 1 select 2)*0.2];
    };
    if !(_vehicle isKindOf "CAManBase") exitWith {
        private _bb = 0 boundingBoxReal _target;
        [(_bb select 1 select 0), (_bb select 0 select 1), 0];
    };
    if (_target isKindOf "CAManBase") exitWith {
        private _bb = 0 boundingBoxReal _target;
        [(_bb select 1 select 0)/2.5, (_bb select 0 select 1)/2.5, (_bb select 0 select 1)/5];
    };

private _bb = 0 boundingBoxReal _target;
[(_bb select 1 select 0), (_bb select 0 select 1), 0];
