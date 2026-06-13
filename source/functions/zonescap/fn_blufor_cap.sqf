params ["_place","_points","_markername","_markername2","_triggerPos"];

amount_zones_captured = amount_zones_captured + 1;
["us_takencontrol",[_place]] call bis_fnc_showNotification;

// MODIFY NUMBER OF CONTROLLED ZONES
zoneundercontrolblu = zoneundercontrolblu + 1;
publicVariable "zoneundercontrolblu";

// TELL THE ZONE IS UNDER BLU CONTROL
WARCOM_zones_controled_by_BLUFOR = WARCOM_zones_controled_by_BLUFOR + [_triggerPos];

// REMOVE A ZONE FROM OPFOR CONTROL
_index = 0;
{
if ((_x select 0 == _triggerPos select 0) && (_x select 1 == _triggerPos select 1) && (_x select 2 == _triggerPos select 2)) exitWith {
WARCOM_zones_controled_by_OPFOR set [_index,-1];
WARCOM_zones_controled_by_OPFOR = WARCOM_zones_controled_by_OPFOR - [-1];
}; 
_index = _index + 1;
} forEach WARCOM_zones_controled_by_OPFOR;


// MODIFY ARMY POWER
WARCOM_opfor_ap = WARCOM_opfor_ap + _points;
WARCOM_blufor_ap = WARCOM_blufor_ap + _points;
publicVariable "WARCOM_blufor_ap";

// ADD Skill to operatives
[] call operative_mission_complete; 

// MODIFY MARKER ICON
str(_markername) setMarkerColor "ColorGreen";
// hint str(_markername);
// MODIFY MARKER ELLIPSE
str(_markername2) setMarkerColor "ColorGreen";

if (hasInterface) then {
commandpointsblu1 = commandpointsblu1 + (_points/2); 
publicVariable "commandpointsblu1"; 
};

["CPadded_retaken",[(_points/2)]] call bis_fnc_showNotification;

// === ZONE CAPTURE FEEDBACK ===
// Show remaining zone count
private _remainingZones = count WARCOM_zones_controled_by_OPFOR;
private _totalZones = _remainingZones + zoneundercontrolblu;
systemChat format ["[DUWS-R] Zone captured! %1 zones remaining (%2/%3 secured)", _remainingZones, zoneundercontrolblu, _totalZones];

// Reveal enemies in captured zone for 10 seconds
private _revealRadius = 200;
{
    if (side _x == EAST && {_x distance _triggerPos < _revealRadius}) then {
        _x setMarkerAlpha 0.8;
    };
} forEach allUnits;
sleep 10;
{
    if (side _x == EAST && {_x distance _triggerPos < _revealRadius}) then {
        _x setMarkerAlpha 1;
    };
} forEach allUnits;

// Show remaining zones on map with temporary markers
private _zoneMarker = createMarker [format ["zone_remaining_%1", round time], _triggerPos];
_zoneMarker setMarkerShape "ICON";
_zoneMarker setMarkerType "mil_dot";
_zoneMarker setMarkerColor "ColorGreen";
_zoneMarker setMarkerText format ["%1 zones left", _remainingZones];
sleep 15;
deleteMarker _zoneMarker;

// RECALL VARNAME FOR ZONE TRIGGER --> use the pos of the trigger
private "_trg";
call compile format["_trg = trigger%1%2",round (_triggerPos select 0),round (_triggerPos select 1)];
//// MAKE THE TRIGGER CAPTURABLE FOR OPFOR
_trg setTriggerActivation["EAST SEIZED","PRESENT",true];
_trg setTriggerStatements["this", format["[""%1"",%2,""%3"",""%4"",%5] call duws_fnc_opfor_cap",_place,_points,_markername,_markername2,_triggerPos], ""];
