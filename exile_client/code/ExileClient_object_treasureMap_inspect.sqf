/**
 * ExileClient_object_treasureMap_inspect
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_playerPosition","_minimumDistance","_maximumDistance","_spawnedTreasure","_testDistance","_testDirection","_testPosition","_playersNearby","_objectsNearby"];
_playerPosition = getPos player;
_minimumDistance = 1000;
_maximumDistance = 5000;
_spawnedTreasure = false;
while {!_spawnedTreasure} do 
{
	_testDistance = _minimumDistance + (random _maximumDistance);
	_testDirection = random 360;
	_testPosition = [_playerPosition, _testDistance, _testDirection] call ExileClient_util_math_getPositionInDirection;
	if !(surfaceIsWater _testPosition) then
	{
		_playersNearby = _testPosition nearEntities ["Exile_Unit_Player", 500];
		if( _playersNearby isEqualTo [] ) then
		{
			_objectsNearby = _testPosition nearObjects 2;
			if( _objectsNearby isEqualTo [] ) then
			{
				_spawnedTreasure = true;
			};
		};
	};
};
true