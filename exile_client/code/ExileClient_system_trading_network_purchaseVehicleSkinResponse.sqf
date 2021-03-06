/**
 * ExileClient_system_trading_network_purchaseVehicleSkinResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_responseCode","_newPlayerMoneyString","_newPlayerMoney","_salesPrice"];
_responseCode = _this select 0;
_newPlayerMoneyString = _this select 1;
if (_responseCode isEqualTo 0) then
{
	_newPlayerMoney = parseNumber _newPlayerMoneyString;
	_salesPrice = ExileClientPlayerMoney - _newPlayerMoney;
	ExileClientPlayerMoney = _newPlayerMoney;
	["VehicleSkinPurchasedInformation", [_salesPrice * -1]] call ExileClient_gui_notification_event_addNotification;
}
else 
{
	systemChat format["Failed to purchase vehicle skin: %1", _responseCode];
};