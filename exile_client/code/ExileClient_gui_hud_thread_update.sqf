/**
 * ExileClient_gui_hud_thread_update
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
call ExileClient_gui_interactionMenu_update;
if( ExileClientPlayerAttributes select 0 != ExileClientPlayerAttributesASecondAgo select 0) then
{
	if (alive player) then
	{
		if !(ExileClientPlayerIsInSecurityCamera) then 
		{
			ExileClientPostProcessingColorCorrections ppEffectAdjust [1, 1.1, -0.05, [0.4, 0.2, 0.3, -0.1], [0.79, 0.72, 0.62, 1 - (damage player)], [0.5,0.5,0.5,0], [0,0,0,0,0,0,4]];
			ExileClientPostProcessingColorCorrections ppEffectCommit 1;
			if (ExileClientPlayerIsBleeding) then
			{
				[ (100 - (ExileClientPlayerAttributes select 0)) * 10 ] call BIS_fnc_bloodEffect;
			};
		};
	};
	ExileClientPlayerAttributesASecondAgo set [0, ExileClientPlayerAttributes select 0];
	ExileClientPlayerAttributesASecondAgo set [1, ExileClientPlayerAttributes select 1];
	ExileClientPlayerAttributesASecondAgo set [2, ExileClientPlayerAttributes select 2];
	ExileClientPlayerAttributesASecondAgo set [3, ExileClientPlayerAttributes select 3];
	ExileClientPlayerAttributesASecondAgo set [4, ExileClientPlayerAttributes select 4];
};
true