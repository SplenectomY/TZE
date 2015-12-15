/**
 * ExileClient_gui_hud_toggle
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if (_this) then
{
	("RscExileHUDLayer" call BIS_fnc_rscLayer) cutRsc ["RscExileHUD", "PLAIN", 1, false];  
	ExileHudEventHandle = addMissionEventHandler ["Draw3D", { _this call ExileClient_gui_hud_event_onDraw3d; }];
	ExileHudIsVisible = true;
}
else 
{
	("RscExileHUDLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; 
	ExileHudIsVisible = false;
	removeMissionEventHandler ["Draw3D", ExileHudEventHandle];
};