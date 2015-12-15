/**
 * ExileClient_gui_inventory_event_onPartyButtonClick
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
closeDialog 0;
if (ExileClientPartyID isEqualTo -1) then
{
	call ExileClient_gui_createPartyDialog_show;
}
else 
{
	call ExileClient_gui_partyDialog_show;
};
true