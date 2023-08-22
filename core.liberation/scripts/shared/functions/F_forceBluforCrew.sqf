params [ "_veh"];

createVehicleCrew _veh;
sleep 0.1;

_grp = createGroup [GRLIB_side_friendly, true];
(crew _veh) joinSilent _grp;
{
	_x addMPEventHandler ["MPKilled", { _this spawn kill_manager }];
	_x addEventHandler ["HandleDamage", { _this call damage_manager_friendly }];
	_x setSkill 0.65;
	_x allowFleeing 0;	
} foreach (crew _veh);

_veh allowCrewInImmobile [true, false];
_veh setUnloadInCombat [true, false];

_grp setCombatMode "WHITE";
_grp setBehaviour "AWARE";