/**
 * ExileClient_gui_notification_event_slideUpDown
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_slide","_state","_display","_background","_message","_icon","_deployTime","_backgroundPosition","_messagePosition","_iconPosition"];
disableSerialization;
_slide = (_this select 0) * 10;
_state = _this select 1;
_display = uiNamespace getVariable ["RscExileExileNotification",displayNull];
_background = _display displayCtrl (4000 + _slide);
_message = _display displayCtrl (4001 + _slide);
_icon = _display displayCtrl (4002 + _slide);
_deployTime = 0.6;
if(_state)then
{
	_backgroundPosition = ((ctrlPosition _background) select 1) - (0.08 * safezoneH);
	_messagePosition = ((ctrlPosition _message) select 1) - (0.08 * safezoneH);
	_iconPosition = ((ctrlPosition _icon) select 1) - (0.08 * safezoneH);
	_background ctrlSetPosition 
	[
		0.838021 * safezoneW + safezoneX,
		_backgroundPosition
	];
	_icon ctrlSetPosition
	[
		0.84375 * safezoneW + safezoneX,
		_iconPosition
	];
	_message ctrlSetPosition
	[
		0.883854 * safezoneW + safezoneX,
		_messagePosition
	];
}
else
{
	_backgroundPosition = ((ctrlPosition _background) select 1) + (0.08 * safezoneH);
	_messagePosition = ((ctrlPosition _message) select 1) + (0.08 * safezoneH);
	_iconPosition = ((ctrlPosition _icon) select 1) + (0.08 * safezoneH);
	_background ctrlSetPosition 
	[
		0.838021 * safezoneW + safezoneX,
		_backgroundPosition
	];
	_icon ctrlSetPosition
	[
		0.84375 * safezoneW + safezoneX,
		_iconPosition
	];
	_message ctrlSetPosition
	[
		0.883854 * safezoneW + safezoneX,
		_messagePosition
	];
};
_background ctrlCommit _deployTime;
_message ctrlCommit _deployTime;
_icon ctrlCommit _deployTime;
true