_loop = true;

WARCOM_blu_attack_wave_type = "";
WARCOM_blu_attack_wave_avalaible = false;

// Type of attack wave
[] spawn {
          //WARCOM_blu_attack_wave_type = [Blufor_Teamleader,Blufor_Rifleman];
        diag_log format ["WARCOM_blufor_ap_assault: %1", WARCOM_blufor_ap];
          waitUntil {sleep 1; WARCOM_blufor_ap>=10};
          [West,"HQ"] sidechat "This is HQ, BLUFOR troops just arrived on the island, we'll soon be able to push through the enemy lines";
          WARCOM_blu_attack_wave_avalaible = true;
          WARCOM_blu_attack_wave_type = (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam");

          waitUntil {sleep 1; WARCOM_blufor_ap>40};          
          WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"); 
          
          waitUntil {sleep 1; WARCOM_blufor_ap>65};          
          WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad_Weapons"); 
          
          waitUntil {sleep 1; WARCOM_blufor_ap>100};          
          WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad");
          
          waitUntil {sleep 1; WARCOM_blufor_ap>135};          
          WARCOM_blu_attack_wave_type = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInf_AT");
          
                               
};











// Attack waves main
[] spawn {
    waitUntil {sleep 1; WARCOM_blu_attack_wave_avalaible};

    while {true} do {
        sleep 30;

        // Clean up dead groups
        {
            if (!isNull _x && {{alive _x} count units _x == 0}) then {
                deleteVehicle _x;
            };
        } forEach allGroups;

        _group = [WARCOM_blu_hq_pos, WEST, WARCOM_blu_attack_wave_type,[],[],blufor_ai_skill] call BIS_fnc_spawnGroup;

        // Failsafe: skip wave if group leader is dead
        if (alive (leader _group)) then {
            _TFname = [1] call duws_fnc_random_name;
            [West,"HQ"] sidechat format["This is HQ, We are sending Task Force %1, we will try to push as far as possible in enemy territory",_TFname];

            // Pick a random OPFOR-controlled zone as the assault target
            private _targetZone = [];
            if (count WARCOM_zones_controled_by_OPFOR > 0) then {
                _targetZone = selectRandom WARCOM_zones_controled_by_OPFOR;
            } else {
                _targetZone = WARCOM_hq_pos;
            };

            // Send assault to target zone
            _group setCombatMode "RED";
            _wp = _group addWaypoint [_targetZone, 0];
            _wp setWaypointType "SAD";
            _wp setWaypointCompletionRadius 40;
            _wp setWaypointTimeout [300, 450, 600];

            _blu_assault = [_group,_TFname] spawn duws_fnc_WARCOM_gps_marker;
        };

        sleep (WARCOM_blu_attack_delay + random 1200);
    };
};
