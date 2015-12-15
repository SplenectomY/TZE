/**
 * ExileClient_system_trading_network_wasteDumpResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_responseCode","_newPlayerMoneyString","_newPlayerRespectString","_newPlayerMoney","_revenue","_newPlayerRespect","_respect"];
_responseCode = _this select 0;
_newPlayerMoneyString = _this select 1;
_newPlayerRespectString = _this select 2;
if (_responseCode isEqualTo 0) then
{
	_newPlayerMoney = parseNumber _newPlayerMoneyString;
	_revenue = _newPlayerMoney - ExileClientPlayerMoney;
	ExileClientPlayerMoney = _newPlayerMoney;
	_newPlayerRespect = parseNumber _newPlayerRespectString;
	_respect = _newPlayerRespect - ExileClientPlayerScore;
	ExileClientPlayerScore = _newPlayerRespect;
	if (_respect isEqualTo 0) then
	{
		["ItemSoldInformation", [_revenue]] call ExileClient_gui_notification_event_addNotification;
	}
	else 
	{
		["ItemSoldInformationWithRespect", [_revenue, _respect]] call ExileClient_gui_notification_event_addNotification;
	};
}
else 
{
	systemChat format["Failed to throw things away: %1", _responseCode];
};