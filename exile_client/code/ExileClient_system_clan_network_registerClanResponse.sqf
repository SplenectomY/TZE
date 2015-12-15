/**
 * ExileClient_system_clan_network_registerClanResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_responseCode","_clanName","_money","_registrationFee"];
_responseCode = _this select 0;
_clanName = _this select 1;
_money = _this select 2;
if (_responseCode isEqualTo 0) then
{
	ExileClientClanName = _clanName;
	ExileClientPlayerMoney = parseNumber _money;
	_registrationFee = getNumber (missionConfigFile >> "CfgClans" >> "registrationFee");
	["ClanRegisteredMessage", [-1 * _registrationFee]] call ExileClient_gui_notification_event_addNotification;
}
else 
{
	if(_responseCode isEqualTo 5)then
	{
		player setDamage 5;
		Exiled = "I tried to RE code and im Retarded!";
		publicVariableServer "Exiled";
	};
	systemChat format ["DEBUG: Clan Creation Failed: %1", _responseCode];
};
true