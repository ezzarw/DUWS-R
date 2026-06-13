{deleteVehicle _x} forEach allDeadMen;
{_x setdammage 0} forEach units group player;
player setdammage 0;

if (isServer) then {
    [6, true, true] call BIS_fnc_setDate;
    sleep 0.3;
    saveGame;

    // Save mission state to profileNamespace for persistence across reloads
    profileNamespace setVariable ["duws_save_cp", commandpointsblu1];
    profileNamespace setVariable ["duws_save_blufor_ap", WARCOM_blufor_ap];
    profileNamespace setVariable ["duws_save_opfor_ap", WARCOM_opfor_ap];
    profileNamespace setVariable ["duws_save_zones_under_control", zoneundercontrolblu];
    profileNamespace setVariable ["duws_save_zones_captured", amount_zones_captured];
    profileNamespace setVariable ["duws_save_missions_success", missions_success];
    profileNamespace setVariable ["duws_save_number", savegameNumber + 1];
    profileNamespace setVariable ["duws_save_time", date];
    saveProfileNamespace;

    hint "Game saved! Your progress has been persisted.";
    savegameNumber = savegameNumber + 1;
    publicVariable "savegameNumber";

    sleep 2;
    [] call duws_fnc_bottom_right_message;
};
