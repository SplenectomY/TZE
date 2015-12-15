/**
 * ExileClient_system_process_postInit
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if (missionName isEqualTo "ExileIntro") then
{
	"Intro PostInit..." call ExileClient_util_log;
}
else 
{
	if (hasInterface) then
	{
		[] call ExileClient_system_moon_initialize;
		[] call ExileClient_gui_hud_initialize;
		[15, ExileClient_gui_hud_thread_survivalInfo, [], true] call ExileClient_system_thread_addtask;
		[1, ExileClient_gui_hud_thread_update, [], true] call ExileClient_system_thread_addtask;
		if( isServer ) then
		{
			if( hasInterface && !isMultiplayer ) then
			{
				"Editor PostInit..." call ExileClient_util_log;
				[] call ExileClient_util_debug_editor;
				true call ExileClient_gui_hud_toggle;
			};		
		};
		if (!isServer) then 
		{
			"Client PostInit..." call ExileClient_util_log;
			[] call ExileClient_system_music_initialize;
			[0.5, ExileClient_object_player_von_checkVon, [], true] call ExileClient_system_thread_addtask;
			[0.25, ExileClient_object_player_stats_update, [], true] call ExileClient_system_thread_addtask;
			[5, ExileClient_object_player_safezone_checkSafezone, [], true] call ExileClient_system_thread_addtask;
			[300, ExileClient_object_player_save, [], true] call ExileClient_system_thread_addtask;
		};
	};
};
true