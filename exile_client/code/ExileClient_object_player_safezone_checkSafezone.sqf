/**
 * ExileClient_object_player_safezone_checkSafezone
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if !(ExilePlayerInSafezone) then 
{
	if ((getPosATL (vehicle player)) call ExileClient_util_world_isInTraderZone) then 
	{
		[] call ExileClient_object_player_event_onEnterSafezone; 
	};
	ExileClientPlayerLastSafeZoneCheckAt = diag_tickTime;
}
else 
{
	if (diag_tickTime - ExileClientPlayerLastSafeZoneCheckAt >= 30) then
	{
		if !((getPosATL (vehicle player)) call ExileClient_util_world_isInTraderZone) then 
		{
			[] call ExileClient_object_player_event_onLeaveSafezone; 
		};
		ExileClientPlayerLastSafeZoneCheckAt = diag_tickTime;
	};
};