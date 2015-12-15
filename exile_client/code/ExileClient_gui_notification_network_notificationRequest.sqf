/**
 * ExileClient_gui_notification_network_notificationRequest
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_notifName","_notifText"];
_notifName = _this select 0;
_notifText = _this select 1;
[_notifName,_notifText] call ExileClient_gui_notification_event_addNotification;
true