/**
 * ExileClient_gui_payTerritoryProtectionMoneyDialog_event_onTerritoryDropDownSelectionChanged
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_territoryDropDown","_index","_flagObject","_radius","_level","_objectsInTerritory","_popTabAmountPerObject","_totalPopTabAmount","_respectAmountPerObject","_totalRespectAmount","_currencyDropDown","_payButton"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExilePayTerritoryProtectionMoneyDialog", displayNull];
_territoryDropDown = _this select 0;
_index = _this select 1;
_flagObject = objectFromNetId (_territoryDropDown lbData _index);
_radius = _flagObject getVariable ["ExileTerritorySize", 15];
_level = _flagObject getVariable ["ExileTerritoryLevel", 1];
_objectsInTerritory = _flagObject getVariable ["ExileTerritoryNumberOfConstructions", 0];
_popTabAmountPerObject = getNumber (missionConfigFile >> "CfgTerritories" >> "popTabAmountPerObject");
_totalPopTabAmount = _level * _popTabAmountPerObject * _objectsInTerritory;
_respectAmountPerObject = getNumber (missionConfigFile >> "CfgTerritories" >> "respectAmountPerObject");
_totalRespectAmount = _level * _respectAmountPerObject * _objectsInTerritory;
_currencyDropDown = _display displayCtrl 4000;
lbClear _currencyDropDown;
_index = _currencyDropDown lbAdd (format ["%1 Pop Tabs", _totalPopTabAmount]);
_currencyDropDown lbSetValue [_index, _totalPopTabAmount];
_index = _currencyDropDown lbAdd (format ["%1 Respect", _totalRespectAmount]);
_currencyDropDown lbSetValue [_index, _totalRespectAmount];
_currencyDropDown lbSetCurSel 0;
_currencyDropDown ctrlEnable true;
_payButton = _display displayCtrl 4002;
_payButton ctrlEnable true;