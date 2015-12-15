/**
 * ExileClient_system_territory_network_payTerritoryProtectionMoneyResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
ExileClientPlayerMoney = parseNumber (_this select 0);
ExileClientPlayerScore = parseNumber (_this select 1);
["ProtectionMoneyPaidInformation"] call ExileClient_gui_notification_event_addNotification;