/**
 * ExileClient_object_player_bambiStateEnd
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
disableSerialization;
if (alive player) then
{
	[["Exile", "BambiStateEnded"], 15, "", 35, "", true, false, true, true] call BIS_fnc_advHint;
	["endBambiStateRequest"] call ExileClient_system_network_send;	
};
[ExileClientEndBambiStateThread] call ExileClient_system_thread_removeTask;
ExileClientPlayerIsBambi = false;
false call ExileClient_gui_hud_toggleBambiIcon;
true