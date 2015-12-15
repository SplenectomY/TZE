/**
 * ExileClient_gui_xm8_slide_players_event_onPlayerListBoxSelectionChanged
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_listBox","_index","_playerNetID","_display","_partyButton","_sendPopTabsButton","_grantTerritoryBuildRightsButton"];
disableSerialization;
_listBox = _this select 0;
_index = _this select 1;
_playerNetID = _listBox lbData _index;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
_partyButton = _display displayCtrl 4112;
_sendPopTabsButton = _display displayCtrl 4117;
_grantTerritoryBuildRightsButton = _display displayCtrl 4115;
_partyButton ctrlEnable !(ExileClientPartyID isEqualTo -1);
_sendPopTabsButton ctrlEnable !(_playerNetID isEqualTo (netId player)); 
_grantTerritoryBuildRightsButton ctrlEnable !(_playerNetID isEqualTo (netId player)); 
