params ["_fob"];

// Prevent duplicate actions on JIP/re-init
if (_fob getVariable ["duws_fob_actions_init", false]) exitWith {};
_fob setVariable ["duws_fob_actions_init", true];

_fob addaction ["<t color='#ff00ff'>Player stats</t>",duws_fnc_info, "", 0, true, true, "", "_this == player"];
_fob addaction ["<t color='#15ff00'>Request ammobox drop(2CP)</t>",duws_fnc_fob_ammobox, "", 0, true, true, "", "_this == player"];

if (support_armory_available) then {
    _fob addaction ["<t color='#ff0066'>Armory (VA)</t>",{[] call duws_fnc_bisArsenal}, "", 0, true, true, "", "_this == player"];
};

_fob addaction ["<t color='#ffb700'>Squad manager</t>",duws_fnc_squadmng, "", 0, true, true, "", "_this == player"];
_fob addaction ["<t color='#ffb700'>FOB manager</t>",duws_fnc_fobmanageropen, "", 0, true, true, "", "_this == player"];

if (isServer) then {
    _fob addaction ["<t color='#00b7ff'>Rest (wait/save)</t>",duws_fnc_savegame, "", 0, true, true, "", "_this == player"];
} else {
    _fob addaction ["<t color='#00b7ff'>Rest</t>", duws_fnc_savegameClient, "", 0, true, true, "", "_this == player"];
};
