waitUntil {sleep 1; !isNil "build_confirmed" };

private ["_my_dog","_onfoot","_dog_pos","_man","_dist","_reset","_mines"];
while { true } do {
	// If player have Dog
	_my_dog = player getVariable ["my_dog", nil];
	if (!isNil "_my_dog") then {
		// Hide Dog
		// go to ..\addons\PAR\PAR_EventHandler.sqf
		_onfoot = isNull objectParent player;

		// Reset Dog
		_dog_pos = getPosATL _my_dog;
		if ( _onfoot && _dog_pos distance2D player > 300 ) then {
			_my_dog setPosATL (getPos player);
			_my_dog setVariable ["do_find", nil];
			sleep 1;
		};

		// Mission for Dog
		_man = _my_dog getVariable ["do_find", nil];
		if (!isNil "_man") then {
			_reset = 0;
			// Patrol
			if (typeName _man == "ARRAY") then {
				if ((_dog_pos distance2D _man) <= 15) then {
					private _wp = _my_dog getVariable ["do_find_wp", []];
					if (count _wp > 0) then {
						private _idx = _wp find _man;
						if (_idx == (count _wp - 1)) then { _idx = 0 } else { _idx = _idx + 1};
						_my_dog setVariable ["do_find", _wp select _idx];
					} else {
						_my_dog setVariable ["do_find", nil];
						_my_dog setVariable ["do_find_wp", nil];
					};
				} else {
					_my_dog moveTo _man;
					_dog_move = "Dog_Run";
					_my_dog playMoveNow _dog_move;
				};
				// detect enemy
				_enemy_lst = (getPosATL _my_dog) nearEntities ["Man", 50];
				_enemy_lst = _enemy_lst select {alive _x && (side _x == GRLIB_side_enemy || {_x getVariable ["GRLIB_is_prisoner", false]})};	
				if (count _enemy_lst > 0) then {
					_enemy_lst = _enemy_lst apply {[_x distance2D player, _x]};
					_enemy_lst sort true;
					_dist = (_enemy_lst select 0) select 0;
					_man = (_enemy_lst select 0) select 1;
					_my_dog setVariable ["do_find", _man];
					_my_dog setVariable ["do_find_wp", nil];
					_my_dog stop false;
					_msg = format [localize "STR_DOG_FOUND", round (_dist)];
					gamelogic globalChat _msg;
				};
				_reset = 1;
			} else {
				// Find men
				if (_man isKindOf "CAManBase") then {
					private _is_captured = !(_man getVariable ["GRLIB_is_prisoner", true]);
					if (!alive _man || (_man != player && side _man == GRLIB_side_friendly) || _is_captured) then {
						_my_dog setVariable ["do_find", nil];
					} else {
						private _dist = round (_dog_pos distance2D _man);
						if (_dist <= 3) then {
							if (isPlayer _man) exitWith { _my_dog setVariable ["do_find", nil] };
							_my_dog setDir (_my_dog getDir _man);
							_tone = _my_dog getVariable "my_dog_tone";
							[_my_dog, _tone] spawn dog_bark;
							sleep selectRandom [3,4,5];
							_my_dog playMoveNow "Dog_Stop";
						} else {
							_my_dog moveTo (getPos _man);
							_dog_move = "Dog_Walk";
							switch (true) do {
								case (_dist > 5 && _dist <= 40): {_dog_move = "Dog_Run"};
								case (_dist > 40): {_dog_move = "Dog_Sprint"};
							};
							_my_dog playMoveNow _dog_move;
						};
					};
					_reset = 1;
				};

				// Find guns
				if (_man isKindOf "GroundWeaponHolder" || _man isKindOf "WeaponHolderSimulated") then {
					if (isNull _man) then {
						_my_dog setVariable ["do_find", nil];
					} else {
						_dist = round (_dog_pos distance2D _man);
						if (_dist <= 3) then {
							_my_dog setDir (_my_dog getDir _man);
							_offset = [-0.1,0.2,0.6];  // "Alsatian_Random_F"
							if (_my_dog isKindOf "Fin_random_F") then { _offset = [-0.1,0.15,0.5] };
							_man attachTo [_my_dog,_offset, "head"];
							_man setVectorDirAndUp [[1,0,0],[1,0,0]];
							_my_dog moveTo (getpos player);
							_my_dog setVariable ["do_find", player];
							_msg = localize "STR_DOG_FOUND_GUN";
							gamelogic globalChat _msg;
						} else {
							_my_dog moveTo (getPos _man);
							_dog_move = "Dog_Walk";
							switch (true) do {
								case (_dist > 5 && _dist <= 40): {_dog_move = "Dog_Run"};
								case (_dist > 40): {_dog_move = "Dog_Sprint"};
							};
							_my_dog playMoveNow _dog_move;
						};
					};
					_reset = 1;
				};
			};
			if (_reset == 0) then { _my_dog setVariable ["do_find", nil] };
		} else {
			private _dist = round (_dog_pos distance2D player);

			// Stop
			if (stopped _my_dog) then {
				_my_dog setDir (_my_dog getDir player);
				_my_dog playMove "Dog_Sit";
			};

			// Relax
			if (_onfoot && _dist <= 5 && !(stopped _my_dog)) then {
				_my_dog playMove "Dog_Idle_Stop";
				if (count (attachedObjects _my_dog) > 0) then {
					_my_dog setDir (_my_dog getDir player);
					sleep 0.5;
					{
						detach _x;
						sleep 0.1;
						_x attachTo [_my_dog];
						detach _x;
						sleep 0.1;
						_x setPos (_x getPos [0.5, (getDir _x)]);
					} forEach (attachedObjects _my_dog);
					sleep 0.5;
					_tone = _my_dog getVariable "my_dog_tone";
					[_my_dog, _tone] spawn dog_bark;
				};
			};

			// Return
			if (_onfoot && _dist > 15 && !(stopped _my_dog)) then {
				_my_dog stop false;
				_my_dog moveTo (getPos player);
				_dog_move = "Dog_Walk";
				switch (true) do {
					case (_dist > 5 && _dist <= 40): {_dog_move = "Dog_Run"};
					case (_dist > 40): {_dog_move = "Dog_Sprint"};
				};
				_my_dog playMoveNow _dog_move;
			};
		};

		// Detect mines
		_mines = allMines select {(getPosATL _x) distance2D (getPosATL _my_dog) <= 10 && mineActive _x && !(_x mineDetectedBy GRLIB_side_friendly)};
		if (count _mines > 0) then {
			_msg = localize "STR_DOG_FOUND_MINE";
			gamelogic globalChat _msg;
			{ GRLIB_side_friendly revealMine _x } forEach _mines;
		};
	};
	sleep 3;
};
