/**
 * ExileClient_gui_actionProgress_show
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_duration","_callBackParameters","_callBackFunction","_callBackUnschedueled","_progress","_keydownHandle","_display","_label","_progressBarBackground","_progressBarMaxSize","_progressBar","_startTime","_sleepDuration","_resault"];
disableSerialization;
if(ExileClientActionDelayShown)exitWith{false};
ExileClientActionDelayShown = true;
_duration = _this select 0;
_callBackParameters = param [1,[]];
_callBackFunction = param [2,""];
_callBackUnschedueled = param [3,false];
_progress = 0;
("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutRsc ["RscExileActionProgress", "PLAIN", 1, false];
_keydownHandle = (findDisplay 46) displayAddEventHandler ["KeyDown","_this call ExileClient_gui_actionProgress_event_keydown"];
_display = uiNamespace getVariable "RscExileActionProgress";   
_label = _display displayCtrl 4002;
_label ctrlSetText "0%";
_progressBarBackground = _display displayCtrl 4001;  
_progressBarMaxSize = ctrlPosition _progressBarBackground;
_progressBar = _display displayCtrl 4000;  
_progressBar ctrlSetPosition [_progressBarMaxSize select 0, _progressBarMaxSize select 1, 0, _progressBarMaxSize select 3];
_progressBar ctrlCommit 0;
_progressBar ctrlSetPosition _progressBarMaxSize; 
_progressBar ctrlCommit _duration;
_startTime = diag_tickTime;
_sleepDuration = _duration / 100;
try
{
	while {_progress < 1} do 
	{
		if (ExileClientActionDelayAbort) then 
		{
			throw "";
		};
		uiSleep _sleepDuration; 
		_progress = ((diag_tickTime - _startTime) / _duration) min 1;
		_label ctrlSetText format["%1%2", round (_progress * 100), "%"];
	};
	if !(_callBackFunction isEqualTo "") then 
	{
		if (_callBackUnschedueled) then
		{
			[_callBackParameters,_callBackFunction] execFSM "exile_client\fsm\call.fsm";
		}
		else
		{
			_callBackParameters call _callBackFunction;
		};
	};
	_resault = true;
}
catch
{
	_progressBar ctrlSetPosition _progressBarMaxSize;
	_progressBar ctrlCommit 0;
	_label ctrlSetText "Aborted!";
	_resault = false;
};
("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutFadeOut 1; 
(findDisplay 46) displayRemoveEventHandler ["KeyDown",_keydownHandle];
ExileClientActionDelayShown = false;
ExileClientActionDelayAbort = false;
_resault