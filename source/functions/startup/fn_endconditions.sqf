waitUntil {!isNil "hq_blu1"};

// End mission if HQ unit is killed
hq_blu1 spawn {
    waitUntil {time > 1};
    _this addMPEventHandler ["MPKilled",
    {
        [] spawn
        {
            ["TaskFailed",["","Your commanding officer has been killed"]] call bis_fnc_showNotification;
            sleep 6;
            ["officerkilled",false,true] call BIS_fnc_endMission;
        };
    }];
};

waitUntil {!isNil "amount_zones_created" && {amount_zones_created > 0}};

// Wait until ALL enemy zones are captured (OPFOR has no more zones)
// Uses WARCOM_zones_controled_by_OPFOR instead of zoneundercontrolblu
// to handle cases where OPFOR recaptures zones mid-game
waitUntil {sleep 3; (!isNil "WARCOM_zones_controled_by_OPFOR" && {count WARCOM_zones_controled_by_OPFOR == 0})}; 
{
    persistent_stat_script_win = [] call duws_fnc_persistent_stats_win;
    ["TaskSucceeded",["","Island captured!"]] call bis_fnc_showNotification;
    capture_island_obj setTaskState "Succeeded";
    sleep 3;
    ["island_captured_win",true,true] call BIS_fnc_endMission;
} remoteExecCall ["BIS_fnc_spawn", 0, true];
