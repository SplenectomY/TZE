/**
 * ExileClient_gui_notification_toggle
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if(_this)then
{
	("RscExileNotificationLayer" call BIS_fnc_rscLayer) cutRsc ["RscExileNotification", "PLAIN", 1, false];
	ExileClientNotificationIsShown = true;
}
else
{
	("RscExileNotificationLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; 
	ExileClientNotificationIsShown = false;
};
true