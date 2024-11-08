#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Server Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(StreamatorOwnerIDs) = [];
publicVariable QGVAR(StreamatorOwnerIDs);

[{
    [{
        call FUNC(CollectStreamators);
    }, 4] call CFUNC(wait);
    private _allStreamatorsIDs = allPlayers select {_x call Streamator_fnc_isSpectator} apply {owner _x};
    if (_allStreamatorsIDs isEqualTo GVAR(StreamatorOwnerIDs)) exitWith {};
    GVAR(StreamatorOwnerIDs) = _allStreamatorsIDs;
    publicVariable QGVAR(StreamatorOwnerIDs);
}, QFUNC(CollectStreamators)] call CFUNC(compileFinal);
call FUNC(CollectStreamators);
