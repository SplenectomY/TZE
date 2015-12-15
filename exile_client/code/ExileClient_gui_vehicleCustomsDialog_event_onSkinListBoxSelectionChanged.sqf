/**
 * ExileClient_gui_vehicleCustomsDialog_event_onSkinListBoxSelectionChanged
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_listBox","_index","_skinClass","_dialog","_purchaseButton"];
disableSerialization;
_listBox = _this select 0;
_index = _this select 1;
_skinClass = _listBox lbData _index;
_skinClass call ExileClient_gui_modelBox_update;
ExileClientVehicleCustomsSelectedSkin = _skinClass;
_dialog = uiNameSpace getVariable ["RscExileVehicleCustomsDialog", displayNull];
_purchaseButton = _dialog displayCtrl 4002;
_purchaseButton ctrlEnable !(ExileClientVehicleCustomsOriginalSkin isEqualTo _skinClass);
true