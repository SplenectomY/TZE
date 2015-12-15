/**
 * ExileClient_gui_upgradeTerritoryDialog_network_territoryUpgradeDialogResponse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_level","_territoryConfig","_territoryLevels","_territoryPrice","_territoryRange"];
_level = _this select 0;
_territoryConfig = getArray(missionConfigFile >> "CfgTerritories" >> "Prices");
_territoryLevels = count _territoryConfig;
if((_level + 1) > _territoryLevels)then
{
	_territoryPrice = (_territoryConfig select (_territoryLevels - 1)) select 0;
	_territoryRange = (_territoryConfig select (_territoryLevels - 1)) select 1;
}
else
{
	_territoryPrice = (_territoryConfig select _level) select 0;
	_territoryRange = (_territoryConfig select _level) select 1;	
};
[_level,_territoryPrice,_territoryRange,_territoryLevels] call ExileClient_gui_upgradeTerritoryDialog_show;
true