// AI Unstuck System - runs every 30s, frees AI stuck on stairs/buildings
while {true} do {
    sleep 30;
    if (!isNil "player" && {alive player}) then {
        private _group = group player;
        if (!isNil "_group") then {
            private _playerPos = getPosATL player;
            {
                if (alive _x && {_x != player}) then {
                    private _lastPos = _x getVariable ["duws_lastPos", getPosATL _x];
                    private _currentPos = getPosATL _x;
                    private _distMoved = _lastPos distance _currentPos;
                    _x setVariable ["duws_lastPos", _currentPos];
                    if (_distMoved < 5) then {
                        private _stuckStart = _x getVariable ["duws_stuckStart", diag_tickTime];
                        if (isNil {_x getVariable "duws_stuckStart"}) then {
                            _x setVariable ["duws_stuckStart", diag_tickTime];
                        };
                        private _stuckDuration = diag_tickTime - _stuckStart;
                        if (_stuckDuration >= 60) then {
                            private _nearBld = nearestBuilding _currentPos;
                            if (!isNull _nearBld && {_nearBld distance _currentPos < 20}) then {
                                private _newPos = _playerPos findEmptyPosition [0, 20, typeOf _x];
                                if (_newPos isEqualTo []) then { _newPos = _playerPos vectorAdd [random 5 - 2.5, random 5 - 2.5, 0]; };
                                _x setPos _newPos;
                                _x setVariable ["duws_stuckStart", nil];
                                systemChat format ["AI Unstuck: %1 moved from stairs.", name _x];
                            };
                        };
                    } else {
                        _x setVariable ["duws_stuckStart", nil];
                    };
                };
            } forEach (units _group);
        };
    };
};
