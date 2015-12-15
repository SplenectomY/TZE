/**
 * ExileClient_gui_xm8_slide_territory_onOpen
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_territoryDropDown","_playerUID","_flag","_buildRights","_size","_level","_index","_kickButton","_leaveButton"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
_territoryDropDown = _display displayCtrl 4132;
lbClear _territoryDropDown;
_playerUID = getPlayerUID player;
{
	_flag = _x;
	_buildRights = _flag getVariable ["ExileTerritoryBuildRights", []];
	if (_playerUID in _buildRights) then
	{
		_name = _flag getVariable ["ExileTerritoryName", ""];
		_size = _flag getVariable ["ExileTerritorySize", 0];
		_level = _flag getVariable ["ExileTerritoryLevel", 0];
		_index = _territoryDropDown lbAdd (format ["%1 (Level: %2, Radius: %3m)",_name, _level, _size]);
		_territoryDropDown lbSetData [_index, netId _flag]; 
	};
}
forEach (allMissionObjects "Exile_Construction_Flag_Static");
_kickButton = _display displayCtrl 4134;
_kickButton ctrlEnable false;
_leaveButton = _display displayCtrl 4135;
_leaveButton ctrlEnable false;
true
