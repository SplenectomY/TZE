/**
 * ExileClient_gui_vehicleTraderDialog_updateVehicleListBox
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_dialog","_traderObject","_categoryClasses","_itemListControl","_categoryClass","_categoryVehicleClassNames","_className","_salesPrice","_indexEntryIndex"];
disableSerialization;
_dialog = uiNameSpace getVariable ["RscExileVehicleTraderDialog", displayNull];
_traderObject = uiNameSpace getVariable ["ExileCurrentTrader", objNull];
_categoryClasses = _this;
if (_categoryClasses select 0 == "") then
{
	_categoryClasses = getArray(missionConfigFile >> "CfgTraders" >> typeOf _traderObject >> "categories");
};
_itemListControl = _dialog displayCtrl 4001;
lbClear _itemListControl;
{
	_categoryClass = _x;
	_categoryVehicleClassNames = getArray(missionConfigFile >> "CfgTraderCategories" >> _categoryClass >> "items");
	{
		_className = _x;
		_salesPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _className >> "price");
		_indexEntryIndex = _itemListControl lbAdd getText(configFile >> "CfgVehicles" >> _className >> "displayName");
		_itemListControl lbSetData [_indexEntryIndex, _className];
    	_itemListControl lbSetTextRight [_indexEntryIndex, format["%1", _salesPrice]];
    	_itemListControl lbSetPictureRight [_indexEntryIndex, "exile_assets\texture\ui\poptab_trader_ca.paa"];
    	if (_salesPrice > ExileClientPlayerMoney) then
		{
			_itemListControl lbSetColorRight [_indexEntryIndex, [0.91, 0, 0, 0.6]];
		};
	}
	forEach _categoryVehicleClassNames;
}
forEach _categoryClasses;
true