// Setup Ammo Box

if (!isServer) exitWith {};
params ["_type", "_pos", "_locked"];

private _spawnpos = [];
private _radius = 50;
private _max_try = 10;

while { count _spawnpos == 0 && _max_try > 0 } do {
	_spawnpos = [1, _pos, _radius, 30, true] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
	_radius = _radius + 10;
	_max_try = _max_try -1;
	sleep 0.5;
};

if ( count _spawnpos == 0 ) then {
	_spawnpos = _pos findEmptyPosition [0, _radius, _type];
};

if ( count _spawnpos == 0 ) exitWith { diag_log format ["--- LRX Error: No place to build box %1 at position %2", _type, _pos]; objNull };
_spawnpos set [2, 0.5];

private _box = createVehicle [_type, _spawnpos, [], 5, "None"];
_box allowDamage false;
_box addMPEventHandler ["MPKilled", {_this spawn kill_manager}];
_box spawn { sleep 3; _this allowDamage true };

if (isNil "_locked") then { _locked = false};

if (_locked) then {
	[_box, "lock", "server"] call F_vehicleLock;
} else {
	[_box, "abandon"] call F_vehicleLock;
};

if (["A3_", GRLIB_mod_west, true] call F_startsWith && _type == basic_weapon_typename) then {
	private _box_refill = selectRandom ["mission_Ammo","mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers","mission_Ammo"];
	[_box, _box_refill] call fn_refillbox;
};
_box;
