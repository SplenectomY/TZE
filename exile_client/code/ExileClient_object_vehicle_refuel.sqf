/**
 * ExileClient_object_vehicle_refuel
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicle","_magazines","_removed","_override","_fuelDetails","_amount"];
_vehicle = _this select 0;
_magazines = magazinesAmmo player;
_removed = false;
_override = false;
{
	_fuelDetails = _vehicle call ExileClient_util_fuel_getRealFuel;
	if((_fuelDetails select 0) isEqualTo (_fuelDetails select 1))exitWith
	{
		["VehicleRefulingFailedFull"] call ExileClient_gui_notification_event_addNotification;
		_override = true;
	};
	if((_x select 0) isEqualTo "Exile_Item_FuelCanisterFull")then
	{
		_amount = (_x select 1);
		if(_amount > 0)then
		{
			if(((_fuelDetails select 1) - (_fuelDetails select 0)) < _amount)then
			{
				_amount = (_fuelDetails select 1) - (_fuelDetails select 0);
				[
					player,
					["Exile_Item_FuelCanisterFull",_x select 1],
					["Exile_Item_FuelCanisterFull",(_x select 1) - _amount]
				] call ExileClient_util_inventory_replaceMagazine;
			}
			else
			{
				[
					player,
					["Exile_Item_FuelCanisterFull",_x select 1],
					["Exile_Item_FuelCanisterEmpty",1]
				] call ExileClient_util_inventory_replaceMagazine;
			};
			_removed = true;
		};
	};
	if(_removed)exitWith{};
}
forEach _magazines;
call ExileClient_object_player_save;
if(_removed)then
{
	if(local _vehicle)then
	{
		[_vehicle,_amount] call ExileClient_util_fuel_setFuel;
	}
	else
	{
		["setFuelRequest",[netId _vehicle,_amount]] call ExileClient_system_network_send;
	};
	["VehicleRefuled", [format ["Vehicle refuled for: %1L",_amount]]] call ExileClient_gui_notification_event_addNotification;
}
else
{
	if!(_override)then
	{
		["VehicleRefulingFailed"] call ExileClient_gui_notification_event_addNotification;
	};
};
true