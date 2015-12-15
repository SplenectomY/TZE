/**
 * ExileClient_gui_inventory_event_onLoad
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_groundTab","_soldierTab","_groundContainer","_soldierContainer","_bypassDetected","_safes","_vehicles"];
disableSerialization;
_display = _this select 0;
_groundTab = _display displayCtrl 6321; 
_soldierTab = _display displayCtrl 6401; 
_groundContainer = _display displayCtrl 632; 
_soldierContainer = _display displayCtrl 640; 
if (ctrlShown _soldierTab) then 
{
	_bypassDetected = false;
	if ((ExileClientCurrentInventoryContainer isKindOf "GroundWeaponHolder") || (ExileClientCurrentInventoryContainer isKindOf "WeaponHolderSimulated")) then 
	{
		_safes = player nearObjects ["Exile_Container_Safe", 3];
		{
			if (_x getVariable ["ExileIsLocked", 1] isEqualTo -1) exitWith
			{
				_bypassDetected = true;
			};
		}
		forEach _safes;
		if !(_bypassDetected) then 
		{
			_vehicles = player nearObjects ["AllVehicles", 5];
			{
				if ((locked _x) isEqualTo 2) exitWith
				{
					if !(local _x) then 
					{
						_bypassDetected = true;
					};
				};
			}
			forEach _vehicles;
		};
	};
	if (_bypassDetected) then 
	{
		_soldierTab ctrlShow false;
		_soldierContainer ctrlShow false;
		ctrlDelete _soldierTab;
		ctrlDelete _soldierContainer;
		ctrlSetFocus _groundTab;
		ctrlActivate _groundTab;
	};
};
