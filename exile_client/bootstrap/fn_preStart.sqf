/**
 * Pre-Start
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

uiNamespace setVariable ["ExileClient_gui_multiplayerSetup_event_onLoad", 
{
	private ["_display", "_news", "_cookie", "_alphabet"];

	_display = _this select 0;
	_news = _display displayCtrl 24000;

	if !(ctrlHTMLLoaded _news) then 
	{
		_cookie = profileNamespace getVariable ["ExileCookie", ""];

		if (_cookie isEqualTo "") then 
		{
			_alphabet = "zyxwvutsrqponmlkjihgfedcbaABCDEFGHIJKLMNOPQRSTUVWXYZ";

			for "_i" from 1 to 32 do 
			{
				_cookie = _cookie + (_alphabet select [floor (random 51), 1]);
			};

			profileNamespace setVariable ["ExileCookie", _cookie];
			saveProfileNamespace;
		};

		_news htmlLoad format["http://lobby.exilemod.com/index.html?cookie=%1", _cookie];
	};
}];

true