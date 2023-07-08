waitUntil {sleep 1; GRLIB_player_spawned};

private ["_manpower_used", "_player_vehicles", "_player_respawn", "_unit"];
private _uid = getPlayerUID player;
private _search_list = light_vehicles + heavy_vehicles + opfor_recyclable + air_vehicles + static_vehicles + support_vehicles;

private _get_mp = {
	params ["_vehicle"];
	private _ret = 0;
	private _veh_class = typeOf _vehicle;
	{
		if ((_x select 0) == _veh_class) exitWith { _ret = (_x select 1) };
	} forEach _search_list;
	_ret;
};

while { true } do {
		_new_manpower_used = count ((units player) select { !(isPlayer _x) && alive _x });

		_player_vehicles = vehicles select {
			(alive _x) &&
			(_x getVariable ["GRLIB_vehicle_owner", ""] == _uid) &&
			!(_x getVariable ['R3F_LOG_disabled', false]) &&
			isNull (_x getVariable ["R3F_LOG_est_transporte_par", objNull])
		};

		_player_respawn = ([_uid] call F_getMobileRespawnsPlayer) select 0;

		{
			_new_manpower_used = _new_manpower_used + ([_x] call _get_mp);
		} foreach (_player_vehicles + _player_respawn);

		resources_infantry = _new_manpower_used;
	sleep 3;
};