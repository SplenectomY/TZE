/**
 * ExileClient_gui_hud_toggleStatsBar
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_hungerLabel","_hungerValue","_thirstLabel","_thirstValue","_healthLabel","_healthValue"];
disableSerialization;
_display = uiNamespace getVariable "RscExileHUD";
ExileHudShowHealth = !ExileHudShowHealth;
_hungerLabel = _display displayCtrl 1303;
_hungerLabel ctrlShow !ExileHudShowHealth;
_hungerValue = _display displayCtrl 1302;
_hungerValue ctrlShow !ExileHudShowHealth;
_thirstLabel = _display displayCtrl 1305;
_thirstLabel ctrlShow !ExileHudShowHealth; 
_thirstValue = _display displayCtrl 1304;
_thirstValue  ctrlShow !ExileHudShowHealth;
_healthLabel = _display displayCtrl 1307;
_healthLabel ctrlShow ExileHudShowHealth;
_healthValue = _display displayCtrl 1306;
_healthValue ctrlShow ExileHudShowHealth;