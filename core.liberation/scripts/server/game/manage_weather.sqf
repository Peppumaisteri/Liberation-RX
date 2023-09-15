// Dynamic Weather enabled (thx to:  sturmalex)
if (GRLIB_weather_param == 4) exitWith {
	[] execVM "scripts\server\game\manage_weather_dynamic.sqf";
};

//Classic Weather
private _weathers = [0];
private _chosen_weather = 0;
private _weathertime = (30 * 60); // Delay between weather change

if (GRLIB_weather_param == 1) then {
	_weathers = [0, 0.05, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45];
};

if (GRLIB_weather_param == 2) then {
	_weathers = [0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.6, 0.63, 0.66, 0.7, 0.73, 0.76];
};

if (GRLIB_weather_param == 3) then {
	// _weathers = [0, 0.01, 0.02, 0.03, 0.05, 0.07, 0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.45, 0.5, 0.55, 0.6, 0.7, 0.8, 0.9, 1.0];
	_weathers = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1];
};

while { GRLIB_endgame == 0 } do {
	if (GRLIB_global_stop == 0) then {
		_chosen_weather = selectRandom _weathers;
		0 setOvercast _chosen_weather;
		if ( _chosen_weather <= 0.5 ) then { 0 setRain 0; 0 setFog 0 };
		if ( _chosen_weather > 0.5 && _chosen_weather <= 0.8 ) then { 0 setRain 0.2; 0 setFog 0.2 };
		if ( _chosen_weather > 0.8 ) then { 0 setRain 0.4; 0 setFog 0.4 }; // Removed heavy rain due to severe fps issues
		setWind [2, 2, true];
		//forceWeatherChange;
	};
	sleep _weathertime;
};
