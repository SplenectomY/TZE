/**
 * ExileClient_object_player_hideCorpse
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_corpse"];
_corpse = _this select 0;
if !(ExileClientPlayerIsInCombat) exitWith
{
};
if !("Exile_Item_Shovel" in (magazines player)) exitWith
{
};
if !((typeOf _corpse) isEqualTo "Exile_Unit_Player") exitWith 
{
};
if (alive _corpse) exitWith
{
};
if !(alive player) exitWith
{
};
player action ["hideBody", _corpse];
// TODO: Server respect?