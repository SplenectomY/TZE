/**
 * ExileClient_gui_payTerritoryProtectionMoneyDialog_event_onPayButtonClick
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_territoryDropDown","_currencyDropDown","_flagNetID","_mode"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExilePayTerritoryProtectionMoneyDialog", displayNull];
_territoryDropDown = _display displayCtrl 4001;
_currencyDropDown = _display displayCtrl 4000;
_flagNetID = _territoryDropDown lbData (lbCurSel _territoryDropDown);
if ((lbCurSel _currencyDropDown) isEqualTo 0) then
{
	_mode = 0;
}
else 
{
	_mode = 1;
};
["payTerritoryProtectionMoneyRequest", [_flagNetID, _mode]] call ExileClient_system_network_send;
closeDialog 0;