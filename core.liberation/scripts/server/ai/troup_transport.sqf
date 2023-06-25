params ["_troup_transport", "_objective_pos"];
private [ "_unit" ];

diag_log format [ "Spawn Troop in vehicle %1 objective %2 at %3", typeOf _troup_transport, _objective_pos, time ];
private _transport_group = (group (driver _troup_transport));
private _start_pos = getpos _troup_transport;
private _unload_distance = 300;

private _troupgrp = [_start_pos, ([] call F_getAdaptiveSquadComp), GRLIB_side_enemy, "infantry"] call F_libSpawnUnits;
{
	_x assignAsCargoIndex [_troup_transport, _forEachIndex];
	_x moveInCargo _troup_transport;
	_x setSkill ["courage", 1];
	_x allowFleeing 0;
	_x setVariable ["GRLIB_counter_TTL", round(time + 1800)];
} foreach (units _troupgrp);

waitUntil { sleep 1; ((damage _troup_transport > 0.2) || !(alive (driver _troup_transport)) || ((_troup_transport distance2D _objective_pos) < _unload_distance)) };
doStop (driver _troup_transport);
sleep 2;

// transport troops
{ [_troup_transport, _x] spawn F_ejectUnit } forEach (units _troupgrp);
sleep 2;
[_troupgrp, _objective_pos] spawn battlegroup_ai;

sleep 10;
// transport vehicle
if ((alive _troup_transport) && (alive (driver _troup_transport))) then {
	[_transport_group] call F_deleteWaypoints;
	private _waypoint = _transport_group addWaypoint [_objective_pos, 100];
	_waypoint setWaypointType "SAD";
	_waypoint setWaypointSpeed "NORMAL";
	_waypoint setWaypointBehaviour "COMBAT";
	_waypoint setWaypointCombatMode "RED";
	_waypoint setWaypointCompletionRadius 30;
	_waypoint = _transport_group addWaypoint [_objective_pos, 100];
	_waypoint setWaypointType "SAD";
	_waypoint = _transport_group addWaypoint [_objective_pos, 100];
	_waypoint setWaypointType "CYCLE";
	(driver _troup_transport) doFollow (leader _troup_transport);
};
