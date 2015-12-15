/**
 * ExileClient_system_trading_network_moneySentRequest
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_newPlayerMoney","_recipientName","_transferAmount"];
_newPlayerMoney = parseNumber (_this select 0);
_recipientName = _this select 1;
_transferAmount = ExileClientPlayerMoney - _newPlayerMoney;
ExileClientPlayerMoney = _newPlayerMoney;
true