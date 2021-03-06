/**
 * ExileClient_object_construction_move
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_object","_result"];
disableSerialization;
_object = _this select 0;
setMousePosition [0.5,0.5];
_result = ["Do you really want to move this object?", "Move?", "Yes", "Nah"] call BIS_fnc_guiMessage;
waitUntil {uiSleep 0.05; !isNil "_result" };
if (_result) then
{
	if (ExileClientPlayerIsInCombat) then
	{
		["ConstructionAbortedCombat"] call BIS_fnc_showNotification;
	}
	else
	{
		["moveConstructionRequest", [netId _object]] call ExileClient_system_network_send;
	};
};
true