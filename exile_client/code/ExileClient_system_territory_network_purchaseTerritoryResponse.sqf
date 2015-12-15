/**
 * ExileClient_system_territory_network_purchaseTerritoryResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_responseCode","_added"];
_responseCode = _this select 0;
if(_responseCode isEqualTo 0)then
{
	ExileClientPlayerMoney = ExileClientPlayerMoney - (((getArray(missionConfigFile >> "CfgTerritories" >> "prices")) select 0) select 0);
	_added = [player,"Exile_Item_Flag",1] call ExileClient_util_playerCargo_add;
	["TerritoryPurchased"] call ExileClient_gui_notification_event_addNotification;
}
else
{
		switch (_responseCode) do
		{
			case (1) : {systemChat "PurchaseFlagResponse - PlayerNULL!";};
			case (2) : {systemChat "PurchaseFlagResponse - PlayerDEAD!";};
			case (3) : {systemChat "PurchaseFlagResponse - PlayerBROKE!";};
		};	
};
true