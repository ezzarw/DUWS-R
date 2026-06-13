// Rearm all squad members at cost of 2 CP
if (commandpointsblu1 < 2) exitWith {
    hint "Not enough CP (2 required)";
};
if (isNull player) exitWith {};
private _group = group player;
if (isNil "_group") exitWith {};
{  
    if (alive _x) then {
        // Rearm primary weapon
        private _weapon = primaryWeapon _x;
        if (_weapon != "") then {
            private _mag = (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0;
            if (!isNil "_mag") then {
                _x addMagazines [_mag, 4];
            };
        };
        // Add basic supplies
        _x addMagazine "HandGrenade";
        _x addMagazine "SmokeShell";
        // Repair
        _x setDamage 0;
    };
} forEach (units _group);
commandpointsblu1 = commandpointsblu1 - 2;
publicVariable "commandpointsblu1";
hint "Squad rearmed and healed (-2 CP)";
