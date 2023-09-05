params [ "_position", "_distance", "_side" ];
private [ "_infantrycount1", "_infantrycount2", "_countedvehicles", "_vehiclecrewcount" ];

_infantrycount1 = {
    (alive _x) && !(captive _x) &&
    (isNull objectparent _x) &&
    ((getPosATL _x) select 2 < 200) &&
    (_x distance2D lhd > GRLIB_fob_range) &&
    (_x distance2D _position <= _distance) &&
    !(_x getVariable ["GRLIB_mission_AI", false])
} count units _side;

_infantrycount2 = {
    (alive _x) &&
    (_x distance2D lhd > GRLIB_fob_range) &&
    (_x distance2D _position <= _distance) &&
    (_x getVariable ["PAR_Grp_ID", ""] != "")
} count units GRLIB_side_civilian;

_countedvehicles =  [
    (_position nearEntities [["Car", "Tank", "Air", "Ship", "StaticWeapon"], _distance]), 
    {
        (alive _x) &&
        (_x distance2D lhd > GRLIB_fob_range) &&
        !(typeOf _x in uavs) &&
        ((getPosATL _x) select 2 < 200) &&
        (speed vehicle _x <= 100) &&
        (count (crew _x) > 0) &&
        !(_x getVariable ["GRLIB_mission_AI", false])
    }
] call BIS_fnc_conditionalSelect;

_vehiclecrewcount = 0;
{ _vehiclecrewcount = _vehiclecrewcount + (_side countSide (crew _x)) } foreach _countedvehicles;

(_infantrycount1 + _infantrycount2 + _vehiclecrewcount)
