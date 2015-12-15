/**
 * ExileServer_world_initialize
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
 private["_objects","_position","_direction","_animations","_traderFace","_trader","_canCreate","_traderClass"];
 
"Initializing game world..." call ExileServer_util_log;
ExileServerKillFeed = if((getNumber (configFile >> "CfgSettings" >> "KillFeed" >> "showKillFeed")) isEqualTo 1)then{true}else{false};
call ExileServer_World_loadAllTerritories;
call ExileServer_world_loadAllDatabaseConstructions;
call ExileServer_world_loadAllDatabaseVehicles;
call ExileServer_world_loadAllDatabaseContainers;
call ExileServer_world_spawnSpawnZoneVehicles;
call ExileServer_world_spawnVehicles;

ZEtraderGrids = ["26-220","229-188"];

ZEtrdrGdsCnt = count ZEtraderGrids;

ZEtraderTypesAvail = [
	["Exile_Trader_Hardware","Hardware Dealer"],
	["Exile_Trader_Food","Food Dealer"],
	["Exile_Trader_Armory","Arms Dealer"],
	["Exile_Trader_Equipment","Outfitter"],
	["Exile_Trader_SpecialOperations","Tech Dealer"],
	["Exile_Trader_Office","Real Estate Agent"],
	["Exile_Trader_WasteDump","Scrapper"],
	["Exile_Trader_Aircraft","Aircraft Dealer"],
	["Exile_Trader_Vehicle","Vehicle Dealer"],
	["Exile_Trader_Boat","Boat Dealer"]
	//["Exile_Trader_VehicleCustoms","Vehicle Customs"],
	//["Exile_Trader_AircraftCustoms","Aircraft Customs"]
];

ZEtrdrTpsAvlCnt = count ZEtraderTypesAvail;

ZEActiveTraders = [];

////////////////////
//ROLL FOR A TRADER!
////////////////////

_SelectedGrid = ZEtraderGrids select floor(random ZEtrdrGdsCnt);

_traderClass = ZEtraderTypesAvail select floor(random ZEtrdrTpsAvlCnt);

_traderClassName = _traderClass select 0;

_traderClassNameFriendly = _traderClass select 1;

////////////////////
////////////////////
////////////////////

ZECheckArea = {
	private["_position","_return", "_nearbyUnits","_maxRange","_flags","_distance","_radius"];
	_position = _this select 0;
	_return = true;
	_maxRange = getNumber (missionConfigFile >> "CfgTerritories" >> "maximumRadius");
	_flags = _position nearObjects ["Exile_Construction_Flag_Static", _maxRange];
		{
			_distance = (getPos _x) distance _position;
			_radius = _x getVariable ["ExileTerritorySize", 0];
			if (_distance <= _radius) exitWith {_return = false;};
		}	
		forEach _flags;
	_return;
};

ZETargetPlayer = {
	private["_group","_units","_unit","_player"];
	_unit = _this select 0;
	_player = _this select 1;
	
	_group = group _unit; 
	_units = units _group;
	_group allowfleeing 0;
	_group reveal _player;
	_group setBehaviour "COMBAT";
	_group setCombatMode "RED";
	//_units commandWatch objNull;
	_units doTarget _player;
	_units doWatch _player;
	_units doFire _player;
};

ZETraderAnimChange = {
	private["_trader","_animations"];
	_trader = _this select 0;
	_animations = _trader getVariable ["ExileAnimations", []];
	_trader switchMove (_animations select floor(random (count _animations)));
	true;
};

ZEGuardHandleDamage = {
	private["_guard","_damage","_source","_sourceSide","_oldDamage","_currentDamage"];
	_guard = _this select 0;
	_damage = _this select 2;
	_currentDamage = damage _guard;
	_oldDamage = _damage;
	_source = _this select 3;
	//diag_log format ["Guard was dammaged. Source = %1", _source];
	_sourceSide = side _source;
	if (_sourceSide == resistance) then {_damage = 0};
	if (isPlayer _source) then {_damage = _oldDamage};
	_guard setDamage (_currentDamage + _damage);
};

ZEGuardInfAmmo = {
	private ["_guard","_magazine","_weapons","_currentMagCount"];
	_guard = _this select 0;
	_magazine = currentMagazine _guard;
	{_guard removeMagazine _x} forEach magazines _guard;
	while {alive _guard} do {
		_currentMagCount = count (magazines _guard);
		if (_currentMagCount < 3) then {_guard addMagazine _magazine;};
		sleep 60;
	};
};

ZEGuardParams = {
	private ["_guard","_group","_guardAbilityRoll"];
	_guard = _this select 0;
	_group = _this select 1;
	_guard setUnitRank "COLONEL";
	_guardAbilityRoll = ((random 4) + 5) * 0.1; //Guards get a skill rating between 0.5 and 0.9
    _guard setUnitAbility _guardAbilityRoll;
    _guard addMPEventHandler ["MPKilled", {_this spawn ZEOnGuardDeath;}];
    _guard addMPEventHandler ["MPHit", {_this spawn ZEOnGuardHit;}];
	_guard addEventHandler ["HandleDamage", {_this spawn ZEGuardHandleDamage;}];
	_guard removeMagazines "HandGrenade";
	_guard removeMagazines "MiniGrenade";
	[_guard] spawn ZEGuardInfAmmo;
	if (false) then {_group selectLeader _guard;};
};

ZETraderParams = {
	private ["_trader","_traderClassName","_traderClassNameFriendly","_SelectedGrid","_markerName"];
	
	_trader = _this select 0;
	_traderClassName = _this select 1;
	_traderClassNameFriendly = _this select 2;
	_SelectedGrid = _this select 3;
	
	_trader setUnitRank "COLONEL";
	_trader setUnitAbility 0.5;
	_trader setVariable ["BIS_fnc_animalBehaviour_disable", true];
	_trader disableAI "ANIM";
	_trader disableAI "MOVE";
	_trader disableAI "FSM";
	_trader disableAI "AUTOTARGET";
	_trader disableAI "TARGET";
	_trader disableAI "CHECKVISIBLE";
	_animations = ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"];
	_trader switchMove (_animations select 0);
	_animationCount = count _animations;
	if (_animationCount > 1) then {
		_trader setVariable ["ExileAnimations", _animations];
		_trader addEventHandler ["AnimDone", {_this call ZETraderAnimChange;}];
	};
	_trader setVariable ["TraderType", _traderClassName];
	_trader setVariable ["TraderTypeFriendly", _traderClassNameFriendly];
	_trader setVariable ["TraderGrid", _SelectedGrid];
	_trader addMPEventHandler ["MPKilled", {_this spawn ZEOnTraderDeath;}];
	_trader addMPEventHandler ["MPHit", {_this spawn ZEOnGuardHit;}];
	_trader addEventHandler ["HandleDamage", {_this spawn ZEGuardHandleDamage;}];
	
	_markerName = format ["TraderMarker_%1",_SelectedGrid];
	createMarker [_markerName, position _trader];
	_markerName setMarkerShape "ICON";
	_markerName setMarkerText _traderClassNameFriendly;
	_markerName setMarkerType "hd_dot";
	
};
	
ZEOnTraderDeath = {
	private["_trader","_traderClassName","_traderClassNameFriendly","_SelectedGrid","_killer","_respect","_markerName","_money"];
	_trader = _this select 0;
	_killer = _this select 1;
	diag_log format ["Trader was killed by %1!", _killer];
	
	if ((isPlayer _killer) && (!isNull _killer) && ((getPlayerUID _killer) != "") && (_killer isKindOf "Exile_Unit_Player")) then {
		_killer addRating -2000;
		_respect = (_killer getVariable ["ExileScore", 0]) - 2000;
		_money = _killer getVariable ["ExileMoney", 0];
		_killer setVariable ["ExileScore", _respect];
		ExileClientPlayerScore = _respect;
		(owner _killer) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;
		// Update client database entry
		format["setAccountMoneyAndRespect:%1:%2:%3", _money, _respect, (getPlayerUID _killer)] call ExileServer_system_database_query_fireAndForget;
	};
	_traderClassName = _trader getVariable ["TraderType", []];
	_traderClassNameFriendly = _trader getVariable ["TraderTypeFriendly", []];
	_SelectedGrid = _trader getVariable ["TraderGrid", []];
	ZEtraderTypesAvail = ZEtraderTypesAvail + [[_traderClassName,_traderClassNameFriendly]];
	ZEActiveTraders = ZEActiveTraders - [[_SelectedGrid,_traderClassNameFriendly]];
	
	sleep 4;
	deleteVehicle _trader;
	
	_markerName = format ["TraderMarker_%1",_SelectedGrid];
	deleteMarker _markerName;
};

ZEOnTrader2Death = {
	private["_trader","_killer","_respect","_attributes","_group","_units","_money"];
	_trader = _this select 0;
	_killer = _this select 1;
	diag_log format ["Trader was killed by %1!", _killer];
	
	if ((isPlayer _killer) && (!isNull _killer) && ((getPlayerUID _killer) != "") && (_killer isKindOf "Exile_Unit_Player")) then {
		_killer addRating -2000;
		_respect = (_killer getVariable ["ExileScore", 0]) - 2000;
		_money = _killer getVariable ["ExileMoney", 0];
		_killer setVariable ["ExileScore", _respect];
		ExileClientPlayerScore = _respect;
		(owner _killer) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;
		// Update client database entry
		format["setAccountMoneyAndRespect:%1:%2:%3", _money, _respect, (getPlayerUID _killer)] call ExileServer_system_database_query_fireAndForget;
	};
	
	sleep 4;
	deleteVehicle _trader;
};

ZEOnGuardDeath = {
	private["_guard","_killer","_respect","_group","_units","_money"];
	_guard = _this select 0;
	_killer = _this select 1;
	diag_log format ["Guard was killed by %1!", _killer];
	
	if ((isPlayer _killer) && (!isNull _killer) && ((getPlayerUID _killer) != "") && (_killer isKindOf "Exile_Unit_Player")) then {
		_killer addRating -1000;
		_respect = (_killer getVariable ["ExileScore", 0]) - 1000;
		_money = _killer getVariable ["ExileMoney", 0];
		_killer setVariable ["ExileScore", _respect];
		ExileClientPlayerScore = _respect;
		(owner _killer) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;
		// Update client database entry
		format["setAccountMoneyAndRespect:%1:%2:%3", _money, _respect, (getPlayerUID _killer)] call ExileServer_system_database_query_fireAndForget;
	};
	sleep 300;
	deleteVehicle _guard;
};

ZEOnGuardHit = {
	private["_guard","_shooter"];
	_guard = _this select 0;
	_shooter = _this select 1;
	diag_log format ["Guard was hit by %1!", _shooter];
	
	if (isPlayer _shooter) then {
		_shooter addrating -10000; 
		diag_log format ["Shooter is player %1! Removing 10,000 rating.", _shooter]; 
		[_guard,_shooter] call ZETargetPlayer;
	};
};

ZETraderLoop = {
	
	private["_SelectedGrid","_traderClassName","_traderClassNameFriendly","_position","_direction","_animations","_canCreate","_group_0"];
	
	_SelectedGrid = _this select 0;
	
	_traderClassName = _this select 1;
	
	_traderClassNameFriendly = _this select 2;

	while {true} do {
	
		if (ZEtrdrTpsAvlCnt == 0) then {sleep 600} else {
		
			//SHORELINE AND DOCK DEALERS
			if (_traderClassName != "Exile_Trader_Aircraft" && _traderClassName != "Exile_Trader_Vehicle" && _traderClassName != "Exile_Trader_WasteDump") then {
			
				//26_220 - TOP LEFT OF MAP, BOATS and BOXES
				if (_SelectedGrid == "26-220") then {
				
					//_canCreate = [_position] call ZECheckArea;
					_canCreate = true;
					if (_canCreate) then {
						ZEtraderGrids = ZEtraderGrids - [_SelectedGrid];
						ZEtraderTypesAvail = ZEtraderTypesAvail - [[_traderClassName,_traderClassNameFriendly]];
						ZEActiveTraders = ZEActiveTraders + [[_SelectedGrid,_traderClassNameFriendly]];

						_this = createCenter resistance;
						_this setFriend [west, 1];
						_this setFriend [resistance, 1];
						_this setFriend [civilian, 1];
						_center_0 = _this;
						_group_0 = createGroup _center_0;

						_trader = objNull;
						if (true) then
						{
							_this = _group_0 createUnit [_traderClassName, [2674.13,22091.2,0], [], 0, "CAN_COLLIDE"];
							_trader = _this;
							_this setDir 116.348;
							[_this,_traderClassName,_traderClassNameFriendly,_SelectedGrid] call ZETraderParams;
						};

						_unit_0 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["B_G_engineer_F", [2678.16,22083.5,0], [], 0, "CAN_COLLIDE"];
						  _unit_0 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};
						
						_unit_2 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["O_ghillie_ard_F", [2667.36,22093.2,0], [], 0, "CAN_COLLIDE"];
						  _unit_2 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};

						_unit_5 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["B_G_engineer_F", [2662.04,22087.3,0], [], 0, "CAN_COLLIDE"];
						  _unit_5 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};

						_unit_7 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["O_ghillie_ard_F", [2677.4,22077.5,0], [], 0, "CAN_COLLIDE"];
						  _unit_7 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};

						_unit_9 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["B_G_engineer_F", [2675.22,22106.2,0], [], 0, "CAN_COLLIDE"];
						  _unit_9 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};

						_unit_11 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["B_G_engineer_F", [2731,22084.2,0], [], 0, "CAN_COLLIDE"];
						  _unit_11 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};
						
						_unit_13 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["O_ghillie_ard_F", [2700.18,22069.2,0], [], 0, "CAN_COLLIDE"];
 						 _unit_13 = _this;
 						 [_this,_group_0] call ZEGuardParams;
						};

						_unit_15 = objNull;
						if (true) then
						{
 						 _this = _group_0 createUnit ["O_ghillie_ard_F", [2708.36,22096.3,0], [], 0, "CAN_COLLIDE"];
						 _unit_15 = _this;
 						 [_this,_group_0] call ZEGuardParams;
						};

						_unit_17 = objNull;
						if (true) then
						{
						  _this = _group_0 createUnit ["O_ghillie_ard_F", [2641.25,22124.2,0], [], 0, "CAN_COLLIDE"];
						  _unit_17 = _this;
						  [_this,_group_0] call ZEGuardParams;
						};
						
						_objects = 
[
    ["B_Boat_Armed_01_minigun_F",[2665.3274,22078.639,0],0],
	["Land_PaperBox_open_empty_F",[2668.83,22088.2,0],342.052],
	["Land_PaperBox_closed_F",[2667.63,22090.4,0],320.85],
	["B_Boat_Armed_01_minigun_F",[2672.72,22076.6,0],24.119],
	["Land_TentDome_F",[2685.43,22106.7,0],116.023],
	["Land_TentDome_F",[2689.31,22102.7,0],138.844],
	["Land_TentDome_F",[2680.6,22109.7,0],113.664],
	["Land_TentDome_F",[2690.91,22097.5,0],175.164],
	["Land_ToiletBox_F",[2682.61,22100.8,0],18.2243],
	["Land_ToiletBox_F",[2685.09,22098.9,0],45.2698],
	["Campfire_burning_F",[2680.66,22105.5,0],0],
	["Land_Pallet_MilBoxes_F",[2671.25,22088,0],0],
	["Land_PaperBox_open_full_F",[2670.22,22090.5,0],0],
	["Item_Medikit",[2671.17,22089.9,0],273.24],
	["Land_WoodPile_F",[2677.41,22106,0],119.042],
	["Land_CampingTable_F",[2674.77,22090.8,0],300.226],
	["Weapon_hgun_Rook40_F",[2674.52,22090.7,0],0],
	["Land_CampingChair_V1_F",[2673.02,22090.6,0],275.497],
	["Land_Camping_Light_off_F",[2674.3,22090.3,1],300.779],
	["Land_Can_V1_F",[2674.91,22091.5,0],1],
	["Land_TentDome_F",[2675.46,22111.2,0],83.3397]
];

{
    private ["_object"];

    _object = (_x select 0) createVehicle [0,0,0];
    _object setDir (_x select 2);
    _object setPos (_x select 1);
    _object allowDamage false;
    _object enableSimulationGlobal false;
	_object setVehicleLock "LOCKED";
	clearMagazineCargoGlobal _object;
	clearItemCargoGlobal _object;
	clearWeaponCargoGlobal _object;
	clearBackpackCargoGlobal _object;
	
}
forEach _objects;
					
					};
				};
			
			};
			//AIRCRAFT DEALERS
			if (_traderClassName == "Exile_Trader_Aircraft") then {
				
				//Salt flats airstrip, made by david
				if (_SelectedGrid == "229-188") then {
					
					ZEtraderGrids = ZEtraderGrids - [_SelectedGrid];
					ZEtraderTypesAvail = ZEtraderTypesAvail - [[_traderClassName,_traderClassNameFriendly]];
					ZEActiveTraders = ZEActiveTraders + [[_SelectedGrid,_traderClassNameFriendly]];
					
					_this = createCenter resistance;
					_this setFriend [west, 1];
					_this setFriend [resistance, 1];
					_this setFriend [civilian, 1];
					_center_1 = _this;
					_group_1 = createGroup _center_1;

					_trader = objNull;
					if (true) then 
					{
						_this = _group_1 createUnit ["Exile_Trader_Aircraft", [22993.1,18880.1,0], [], 0, "CAN_COLLIDE"];
						_trader = _this;
						_this setDir 165.308;
						[_this,_traderClassName,_traderClassNameFriendly,_SelectedGrid] call ZETraderParams;
					};
					
					_trader = objNull;
					if (true) then
					{
						_this = _group_1 createUnit ["Exile_Trader_AircraftCustoms", [22993.9,18895.7,0], [], 0, "CAN_COLLIDE"];
						_trader = _this;
						_this setDir 115.757;
						_trader setUnitRank "COLONEL";
						_trader setUnitAbility 0.5;
						_trader setVariable ["BIS_fnc_animalBehaviour_disable", true];
						_trader disableAI "ANIM";
						_trader disableAI "MOVE";
						_trader disableAI "FSM";
						_trader disableAI "AUTOTARGET";
						_trader disableAI "TARGET";
						_trader disableAI "CHECKVISIBLE";
						_animations = ["HubStanding_idle1", "HubStanding_idle2", "HubStanding_idle3"];
						_trader switchMove (_animations select 0);
						_animationCount = count _animations;
						if (_animationCount > 1) then {
							_trader setVariable ["ExileAnimations", _animations];
							_trader addEventHandler ["AnimDone", {_this call ZETraderAnimChange;}];
						};
						_trader addMPEventHandler ["MPKilled", {_this spawn ZEOnTrader2Death;}];
						_trader addMPEventHandler ["MPHit", {_this spawn ZEOnGuardHit;}];
					};

					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["B_HeavyGunner_F", [22975.1,18891.6,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["B_HeavyGunner_F", [22973.6,18891,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["I_soldier_F", [22990.2,18879.5,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["I_Soldier_AR_F", [22991.8,18892.3,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};	
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["B_ghillie_sard_F", [22985.2,18881.5,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["B_ghillie_ard_F", [22927.1,18797,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["B_ghillie_ard_F", [22964.3,18837.6,0], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull; if (true) then {_this = _group_1 createUnit ["O_Soldier_LAT_F", [22960.7,18877.1,14.5826], [], 0, "CAN_COLLIDE"]; _unit_0 = _this; _this limitSpeed 0; [_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_Sniper_F", [22961.5,18838.4,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_Spotter_F", [22966.4,18835.3,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_soldier_F", [22991.5,18883.6,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_soldier_F", [22966.6,18870.2,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_soldier_F", [22969.4,18874.8,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22939.9,18856.4,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_soldier_F", [22943.6,18886.2,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22889.1,18880.6,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22913.6,18914.6,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22955.5,18938.1,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22962.7,18978.7,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22919.2,18936.6,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22891.9,18909.3,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22874.2,18881.5,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["B_ghillie_ard_F", [22982.5,18998.6,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_Spotter_F", [22953.6,18818.3,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
					_unit_0 = objNull;if (true) then{_this = _group_1 createUnit ["I_Spotter_F", [22993.2,18901.4,0], [], 0, "CAN_COLLIDE"];_unit_0 = _this;[_this,_group_1] call ZEGuardParams;};
						
					_objects = [
						["Exile_Sign_Aircraft",[22822.4,19164.8,0],118.168],
						["Exile_Sign_AircraftCustoms",[22848.3,18946.3,0],149.661],
						["Exile_Sign_Aircraft",[22839.4,18935.3,0],119.76],
						["Exile_Sign_AircraftCustoms",[22831.13,19175.5,0],158.647],
						["I_Heli_light_03_unarmed_F",[22917.6,18825.3,0],192.058],
						["I_Heli_light_03_unarmed_F",[22918.5,18796,0],134.65],
						["B_Heli_Light_01_F",[22940,18809.4,0],131.47],
						["I_Heli_light_03_unarmed_F",[22929.3,18804,0],141.057],
						["Land_Cargo40_military_green_F",[22946.7,18830.1,0],142.279],
						["B_Heli_Light_01_F",[22946.1,18815.9,0],136.158],
						["B_Heli_Light_01_F",[22931.6,18817,0],131.379],
						["B_Heli_Light_01_F",[22938.9,18822.7,0],144.404],
						["Land_Cargo40_military_green_F",[22938.4,18840.4,0],146.065],
						["Land_Cargo40_military_green_F",[22935.9,18842.5,0],145.182],
						["I_Truck_02_covered_F",[22939,18872.4,0],124.6],
						["I_MBT_03_cannon_F",[22956.2,18825.3,0],53.0747],
						["Land_Cargo40_military_green_F",[22950.8,18827.8,0],141.998],
						["I_Heli_Transport_02_F",[22958.9,18855.3,0],89.8794],
						["I_Truck_02_covered_F",[22963.2,18889,0],126.277],
						["Land_Campfire_F",[22971.6,18896.6,0],0],
						["Land_Pallet_MilBoxes_F",[22977.1,18895.4,0],0],
						["Land_CargoBox_V1_F",[22966.6,18872.4,0],113.377],
						["Land_CargoBox_V1_F",[22968,18873.9,0],139.534],
						["Land_WoodenTable_large_F",[22993.3,18879.1,0],75.8839],
						["Land_HumanSkeleton_F",[22992.9,18879,0.8],255.483],
						["Land_CampingChair_V1_F",[22978.8,18892.6,0],339.849],
						["Land_CampingChair_V2_F",[22970.4,18897.3,0],297.68],
						["Land_CampingChair_V2_F",[22971.5,18895,0],205.906],
						["Land_CampingChair_V2_F",[22972.9,18897.8,0],27.4104],
						["I_MRAP_03_gmg_F",[22976.2,18902,0],179.823],
						["Land_WoodPile_F",[22968.2,18903.3,0],60.6244],
						["Land_Sleeping_bag_F",[22971,18901.9,0],346.996],
						["Land_Sleeping_bag_F",[22972.5,18902.1,0],0],
						["Exile_Sign_Aircraft",[22994.9,18811.5,0],1.0856],
						["Exile_Sign_AircraftCustoms",[22993.3,18896.8,0],281.587],
						["Land_Pallet_F",[22982.4,18895.8,0],0],
						["Land_Pallet_F",[22980.1,18895.9,0],0],
						["Land_CinderBlocks_F",[22980.1,18895.8,0],0],
						["Land_CinderBlocks_F",[22982.3,18895.8,0],0],
						["Land_ChairPlastic_F",[22994.3,18897.1,0],59.5372],
						["Land_Cargo40_military_green_F",[22988.7,18905.5,0],239.288],
						["Land_Cargo40_military_green_F",[22991.6,18906.9,0],235.641],
						["Land_Cargo40_military_green_F",[22988.5,18914.8,0],147.722],
						["Land_Cargo40_military_green_F",[22986.5,18917.4,0],147.172],
						["B_Heli_Transport_03_F",[22996.5,18909.9,0],145.747],
						["B_Heli_Transport_03_F",[22994.6,18932.9,0],62.5648]
						
						//[22992.9,18879,0.00147772]
						
					];

					{
						private ["_object"];
						_object = (_x select 0) createVehicle [0,0,0];
						_object setDir (_x select 2);
						_object setPos (_x select 1);
						_object allowDamage false;
						_object enableSimulationGlobal false;
						_object setVehicleLock "LOCKED";
						clearMagazineCargoGlobal _object;
						clearItemCargoGlobal _object;
						clearWeaponCargoGlobal _object;
						clearBackpackCargoGlobal _object;
					} forEach _objects;
				};
			};
			
			ZEtrdrTpsAvlCnt = count ZEtraderTypesAvail;
			
			_traderClass = ZEtraderTypesAvail select floor(random ZEtrdrTpsAvlCnt);

			_traderClassName = _traderClass select 0;
		
			_traderClassNameFriendly = _traderClass select 1;
			
		};
		
		ZEtrdrGdsCnt = count ZEtraderGrids;
	
		if (ZEtrdrGdsCnt == 0) exitWith {};
	
		sleep 60;
	
		_SelectedGrid = ZEtraderGrids select floor(random ZEtrdrGdsCnt);
	
	};

};

[_SelectedGrid,_traderClassName,_traderClassNameFriendly] spawn ZETraderLoop;

"Game world initialized! Let the fun begin!" call ExileServer_util_log;
true