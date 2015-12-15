/**
 * ExileClient_construction_handleAbort
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_simulatePhysics"];
_simulatePhysics = _this;
switch (ExileClientConstructionResult) do
{
	case 1: 
	{
		if( ExileClientConstructionProcess isEqualTo 1) then
		{
			[player, ExileClientConstructionKitClassName] call ExileClient_util_playerCargo_remove;
		};
		[ExileClientConstructionObject, getText (ExileClientConstructionConfig >> "staticObject"), _simulatePhysics] spawn ExileClient_construction_simulationCountDown;
		if (getText (ExileClientConstructionConfig >> "staticObject") isEqualTo "Exile_Container_Safe") then 
		{
			["SafePlacedInformation"] call ExileClient_gui_notification_event_addNotification;
		}
		else
		{
			["ConstructionPlacedInformation", [ExileClientConstructionObjectDisplayName]] call ExileClient_gui_notification_event_addNotification;
		};
	};
	case 3:
	{
		if (ExileClientConstructionProcess isEqualTo 2) then
		{
			[ExileClientConstructionObject, getText (ExileClientConstructionConfig >> "staticObject"), true] spawn ExileClient_construction_simulationCountDown;
		}
		else 
		{
			deleteVehicle ExileClientConstructionObject;
		};
		["ConstructionMovedTooFarWarning", [ExileClientConstructionObjectDisplayName]] call ExileClient_gui_notification_event_addNotification;
	};
	case 2:
	{
		if (ExileClientConstructionProcess isEqualTo 2) then
		{
			[ExileClientConstructionObject, getText(ExileClientConstructionConfig >> "staticObject"), _simulatePhysics] spawn ExileClient_construction_simulationCountDown;
		}
		else 
		{
			deleteVehicle ExileClientConstructionObject;
		};
		if (ExileClientPlayerIsInCombat) then
		{
			["ConstructionAbortedCombat"] call ExileClient_gui_notification_event_addNotification;
		}
		else
		{
			["ConstructionAbortedInformation", [ExileClientConstructionObjectDisplayName]] call ExileClient_gui_notification_event_addNotification;
		};		
	};
};
ExileClientConstructionObject = objNull;
ExileClientIsInConstructionMode = false;
ExileClientConstructionResult = 0;
ExileClientConstructionProcess = 0;
ExileClientConstructionLock = false;
hintSilent "";
true