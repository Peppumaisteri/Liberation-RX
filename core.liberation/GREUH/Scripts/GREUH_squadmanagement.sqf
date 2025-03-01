squadaction = "";
squadname = "";

if (isNil "global_group_ids") then { global_group_ids = [] };
if (isNil "global_groups_renamed") then { global_groups_renamed = [] };
waitUntil {sleep 1; !isNil "global_locked_group"};
global_new_leader = [];

while { true } do {
	groups_list = [];
	{ 
		if (isplayer leader _x) then { groups_list pushBack _x }; 
	} foreach (groups GRLIB_side_friendly);

	if(lbCurSel 515 != -1) then {
		_grp = objNull;
		_grp = groups_list select (lbCurSel 515);
		if (!(isNull _grp) && (_grp in (global_locked_group))) then {
			ctrlSetText [516, "UnLock"];
		} else {
			ctrlSetText [516, "Lock"];
		};
	};

	if ( squadaction != "" ) then {
		_grp = grpNull;
		switch (squadaction) do {
			case "join" : {
				if(lbCurSel 515 != -1) then { _grp = groups_list select (lbCurSel 515); };
				if (!(isNull _grp) && (_grp != group player)) then {
					if (count units group player == 1) then {
						if (!(_grp in (global_locked_group))) then {
							[group player, "del"] remoteExec ["addel_group_remote_call", 2];
							[player] join _grp;
							hint "Squad joined";
						} else {hint "Sorry, the Squad is Locked."};
					} else {hint "Sorry, your Group is not Empty."};
				};
			};
			case "leave" : {
				if (leader group player != player) then {
					_group = createGroup [GRLIB_side_friendly, true];
					[_group, "add"] remoteExec ["addel_group_remote_call", 2];
					[player] joinSilent _group;
					hint "New Squad created";
				};
			};
			case "lock" : {
				if(lbCurSel 515 != -1) then { _grp = groups_list select (lbCurSel 515); };
				if (!(isNull _grp) && (_grp == group player)) then {

					if (!(_grp in (global_locked_group))) then {
						hint "Squad locked !";
						[_grp, "add"] remoteExec ["addel_group_remote_call", 2];
						ctrlSetText [516, "UnLock"];
					} else {
						hint "Squad unLocked !";
						[_grp, "del"] remoteExec ["addel_group_remote_call", 2];
						ctrlSetText [516, "Lock"];
					};
				};
			};
			case "rename" : {
				if ( leader group player == player ) then {
					renaming = true;
					ctrlSetText [527, (groupid (group player))];
					waitUntil { ((squadaction == "") || (squadname != "") || !(dialog) || !(alive player)) };
					if ( alive player && dialog && ( squadname != "" )) then {
						if ( (group player) in global_groups_renamed ) then {
							global_group_ids set [global_groups_renamed find (group player),squadname];
						} else {
							global_group_ids = global_group_ids + [squadname];
							global_groups_renamed = global_groups_renamed + [group player];
						};
						publicVariable "global_group_ids";
						publicVariable "global_groups_renamed";
					};
					squadname = "";
					renaming = false;
				} else {
					hint "Sorry, only the Squad Leader can rename their squad.";
				};
			};
			case "leader" : {
				if ( leader group player == player ) then {
					choosingleader = true;
					choose_squadleader = -10;

					_player_group_filtered = [];
					{
						if ( isPlayer _x ) then {
							_player_group_filtered = _player_group_filtered + [_x];
						};
					} foreach (units group player);

					lbClear 567;
					{
						lbAdd [567, name _x ];
					} foreach _player_group_filtered;

					_count_units_grp_player = count (units group player);
					waitUntil { ((squadaction == "") || (choose_squadleader >= 0) || !(dialog) || !(alive player) || (_count_units_grp_player != count (units group player))) };
					if ( alive player && dialog && ( choose_squadleader >= 0 )) then {
						global_new_leader = [group player, _player_group_filtered select choose_squadleader];
						publicVariable "global_new_leader";
					};
					choose_squadleader = -10;
					choosingleader = false;
				} else {
					hint "Sorry, only the squad leader can choose a new leader.";
				};
			};
		};
		squadaction = "";
	};

	{
		if (count global_groups_renamed != 0) then {
			if (_x in global_groups_renamed) then {
				if (groupid _x != global_group_ids select (global_groups_renamed find _x)) then {
					_x setgroupid [(global_group_ids select (global_groups_renamed find _x))];
				};
			};
		};
	} foreach groups_list;

	if ( count global_new_leader != 0 ) then {
		if ( group player == global_new_leader select 0 ) then {
			(global_new_leader select 0) selectLeader (global_new_leader select 1);
			hint format ["%1 is your new squad leader.",name (global_new_leader select 1)];
			global_new_leader = [];
		};
	};

	sleep 3;
};

