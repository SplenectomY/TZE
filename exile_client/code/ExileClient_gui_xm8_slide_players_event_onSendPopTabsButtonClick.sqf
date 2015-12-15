/**
 * ExileClient_gui_xm8_slide_players_event_onSendPopTabsButtonClick
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_playersListBox","_playerNetID","_amountInputBox","_amount","_otherPlayer"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
_playersListBox = _display displayCtrl 4111;
_playerNetID = _playersListBox lbData (lbCurSel _playersListBox);
_amountInputBox = _display displayCtrl 4116;
_amount = abs (parseNumber (ctrlText _amountInputBox));
if (_playerNetID isEqualTo (netId player)) then
{
	["You cannot send pop tabs to yourself!", "Okay"] call ExileClient_gui_xm8_showWarning;
}
else 
{
	if (_amount > ExileClientPlayerMoney) then
	{
		["You do not have enough pop tabs to transfer!", "Okay"] call ExileClient_gui_xm8_showWarning;	
	}
	else 
	{
		_otherPlayer = objectFromNetId _playerNetID;
		[format ["Send %1 to %2?", _amount, name _otherPlayer], "Send", "Don't send"] call ExileClient_gui_xm8_showConfirm;
		waitUntil { !(isNil "ExileClientXM8ConfirmResult") };
		if (ExileClientXM8ConfirmResult) then
		{
			[format ["You have sent %1 pop tabs to %2!", _amount, name _otherPlayer], "Okay"] call ExileClient_gui_xm8_showMessage;
			["sendMoneyRequest", [str _amount, _playerNetID]] call ExileClient_system_network_send;
		};
	};
};