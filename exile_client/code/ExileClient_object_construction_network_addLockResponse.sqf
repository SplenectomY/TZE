/**
 * ExileClient_object_construction_network_addLockResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_pincode"];
_pincode = _this select 0;
[player, "Exile_Item_Codelock"] call ExileClient_util_playerCargo_remove;
if (isStreamFriendlyUIEnabled) then 
{
	["Success",[format ["Lock added, Pincode: ****"]]] call ExileClient_gui_notification_event_addNotification;
}
else 
{
	["Success",[format ["Lock added, Pincode: %1","1234"]]] call ExileClient_gui_notification_event_addNotification;
};
true