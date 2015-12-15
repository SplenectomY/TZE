/**
 * ExileClient_object_player_network_loadPlayerResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_playerNetID","_moneyString","_scoreString","_kills","_deaths","_hunger","_thirst","_alcohol","_clanName","_player"];
_playerNetID = _this select 0;
_moneyString = _this select 1;
_scoreString = _this select 2;
_kills = _this select 3;
_deaths = _this select 4;
_hunger = _this select 5;
_thirst = _this select 6;
_alcohol = _this select 7;
_clanName = _this select 8;
_player = objectFromNetId _playerNetID;
[_player, _hunger, _thirst, _alcohol] call ExileClient_object_player_respawn;
ExileClientPlayerMoney = parseNumber _moneyString;
ExileClientPlayerScore = parseNumber _scoreString;
ExileClientPlayerKills = _kills;
ExileClientPlayerDeaths = _deaths;
ExileClientClanName = _clanName;
ExileClientPlayerIsBambi = false;
ExileClientPlayerBambiStateExpiresAt = 0;
if !(ExileClientPartyID isEqualTo -1) then
{
	[player] joinSilent (groupFromNetId ExileClientPartyID);
};
true