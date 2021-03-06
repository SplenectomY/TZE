/**
 * ExileClient_gui_hud_initialize
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_hasChanges"];
ExileHudIsVisible = false;
ExileHudEventHandle = -1;
ExileHudLastSpeedRenderedAt = diag_tickTime;
ExileHudLastGroupRenderedAt = diag_tickTime;
ExileHudStatsRenderedAt = diag_tickTime;
ExileHudLastVehicleRenderedAt = diag_tickTime;
ExileHudLastRenderedMuzzle = "";
ExileHudLastRenderedGrenadeClassName = "";
ExileHudLastRenderedVehicleClassName = "";
ExileHudLastRenderedVehicleFuelTankSize = 0;
ExileHudShowHealth = false;
_hasChanges = false;
{
	if ((profileNamespace getVariable [_x select 0, -1]) isEqualTo -1) then 
	{
		profileNamespace setVariable [_x select 0, profileNamespace getVariable [_x select 1, 1]];
		_hasChanges = true;
	};
}
forEach 
[
	["ExilePartyESPRed", "IGUI_TEXT_RGB_R"],
	["ExilePartyESPGreen", "IGUI_TEXT_RGB_G"],
	["ExilePartyESPBlue", "IGUI_TEXT_RGB_B"]
];
if ((profileNamespace getVariable ["ExilePartyESPAlpha", -1]) isEqualTo -1) then 
{
	profileNamespace setVariable ["ExilePartyESPAlpha", 0.75];
	_hasChanges = true;
};
if ((profileNamespace getVariable ["ExilePartyMarkerAlpha", -1]) isEqualTo -1) then 
{
	profileNamespace setVariable ["ExilePartyMarkerAlpha", 0.75];
	_hasChanges = true;
};
if (_hasChanges) then 
{
	saveProfileNamespace;
};