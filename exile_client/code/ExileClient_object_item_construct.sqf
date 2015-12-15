/**
 * ExileClient_object_item_construct
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_itemClassName","_minimumDistanceToTraderZones","_minimumDistanceToSpawnZones","_maximumNumberOfTerritoriesPerPlayer","_numberOfTerritories"];
_itemClassName = _this select 0;
if( isClass(configFile >> "CfgMagazines" >> _itemClassName >> "Interactions" >> "Constructing") ) then
{
	if (findDisplay 602 != displayNull) then
	{
		(findDisplay 602) closeDisplay 2; 
	};
	try 
	{
		if !((vehicle player) isEqualTo player) then
		{
			throw "ConstructionVehicleWarning";  
		};
		_minimumDistanceToTraderZones = getNumber (missionConfigFile >> "CfgTerritories" >> "minimumDistanceToTraderZones");
		if ([getPosATL player, _minimumDistanceToTraderZones] call ExileClient_util_world_isTraderZoneInRange) then
		{
			throw "ConstructionTraderZoneWarning";
		};
		_minimumDistanceToSpawnZones = getNumber (missionConfigFile >> "CfgTerritories" >> "minimumDistanceToSpawnZones");
		if ([getPosATL player, _minimumDistanceToSpawnZones] call ExileClient_util_world_isSpawnZoneInRange) then
		{
			throw "ConstructionSpawnZoneWarning";
		};
		if(_itemClassName isEqualTo "Exile_Item_Flag") then 
		{ 
			_maximumNumberOfTerritoriesPerPlayer = getNumber (missionConfigFile >> "CfgTerritories" >> "maximumNumberOfTerritoriesPerPlayer");
			_numberOfTerritories = player call ExileClient_util_territory_getNumberOfTerritories;
			if (_numberOfTerritories >= _maximumNumberOfTerritoriesPerPlayer) then
			{
				throw "MaximumNumberOfTerritoriesReached";
			};
			call ExileClient_gui_setupTerritoryDialog_show;
		}
		else 
		{
			[_itemClassName] call ExileClient_construction_beginNewObject;
		};
	}
	catch 
	{
		[_exception] call ExileClient_gui_notification_event_addNotification;
	};
};
true