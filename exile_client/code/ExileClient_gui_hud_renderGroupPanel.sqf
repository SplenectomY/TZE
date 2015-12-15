/**
 * ExileClient_gui_hud_renderGroupPanel
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_groupControl","_members","_lines","_color"];
disableSerialization;
if (diag_tickTime - ExileHudLastGroupRenderedAt >= 1) then
{
	ExileHudLastGroupRenderedAt = diag_tickTime;
	_display = uiNamespace getVariable "RscExileHUD";
	_groupControl = _display displayCtrl 1000;
	_group = group player;
	_members = units _group;
	if (ExileClientPartyID isEqualTo -1) then
	{
		if (ctrlShown _groupControl) then
		{
			_groupControl ctrlShow false;
		};
	}
	else 
	{
		if !(ctrlShown _groupControl) then
		{
			_groupControl ctrlShow true;
		};
		_lines = "";
		{
			switch (true) do
			{
				case ((damage _x) < 0.1): { _color = "#c0b9ff4b"; };
				case ((damage _x) < 0.5): { _color = "#c0ffac4b"; };
				default 				  { _color = "#c0d20707"; };
			};
			if ((vehicle _x) isEqualTo _x) then 
			{
				_lines = _lines + format ["<t color='%1'>%2</t><br/>", _color, name _x];
			}
			else 
			{
				switch (toLower ((assignedVehicleRole _x) select 0)) do
				{
					case "driver":
					{
						_lines = _lines + format ["<t color='%1'>%2 <img image='\exile_assets\texture\hud\hud_group_driver.paa'/></t><br/>", _color, name _x];
					};
					case "turret":
					{
						_lines = _lines + format ["<t color='%1'>%2 <img image='\exile_assets\texture\hud\hud_group_gunner.paa'/></t><br/>", _color, name _x];
					};
					case "cargo":
					{
						_lines = _lines + format ["<t color='%1'>%2 <img image='\exile_assets\texture\hud\hud_group_passenger.paa'/></t><br/>", _color, name _x];
					};
					default
					{
						_lines = _lines + format ["<t color='%1'>%2</t><br/>", _color, name _x];
					};
				};
			};
		}
		forEach (units (group player));
		_lines = "<t shadow='0' size='0.8'>" + _lines + "</t>";
		_groupControl ctrlSetStructuredText (parseText _lines);
	};
};