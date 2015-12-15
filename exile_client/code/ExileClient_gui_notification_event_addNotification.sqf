/**
 * ExileClient_gui_notification_event_addNotification
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_notifConfig","_text","_text1","_text2","_text3","_text4","_picture","_duration","_color","_descriptionText"];
_notifConfig = _this select 0;
_text = param [1,[""]];
_text1 = _text param [0,""];
_text2 = _text param [1,""];
_text3 = _text param [2,""];
_text4 = _text param [3,""];
try
{
	if !(isClass(configFile >> "CfgNotifications" >> _notifConfig)) then 
	{
		throw format["Invalid CfgNotification: %1", _notifConfig];
	};
	_picture = getText(configFile >> "CfgNotifications" >> _notifConfig >> "iconPicture");
	_duration = getNumber(configFile >> "CfgNotifications" >> _notifConfig >> "duration");
	_color = getArray(configFile >> "CfgNotifications" >> _notifConfig >> "color");
	_descriptionText = getText(configFile >> "CfgNotifications" >> _notifConfig >> "description");
	if (_text1 isEqualTo "") then
	{
		_text = _descriptionText;
	}
	else
	{
		_text = format [_descriptionText,_text1,_text2,_text3,_text4];
	};
	ExileClientNotificationQueue pushBack [_duration,_picture,_text,_color];
}
catch
{
	ExileClientNotificationQueue pushBack [6,"\exile_assets\texture\ui\fail_ca.paa",_exception,{0.91, 0, 0, 0.6}];
};
true