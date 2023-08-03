// Configuration for ammo boxes transport
// First entry: classname
// Second entry: how far behind the vehicle the boxes should be unloaded
// Following entries: attachTo position for each box, the number of boxes that can be loaded is derived from the number of entries

box_transport_config = box_transport_config + [
	// the 'opfor_transport_truck' MUST be declared here
	[ "uns_m37b1", -5.5, [0,-1.8,0.2] ],  
	[ "uns_m37b1_m1919", -5.5, [0,-1.8,0.2] ],
	[ "uns_M35A2", -5.5, [0,-0.6,0.3], [0,-2.4,0.3] ],
	[ "uns_M35A2_Open", -5.5, [0,-0.6,0.3], [0,-2.4,0.3] ],
	[ "uns_ch47_m60_army", -9, [0,2.5,-1.9], [0,0.7,-1.9], [0,-1.1,-1.9], [0,-2.9,-1.9] ]
];

// Additional offset per object
// objects in this list can be loaded on vehicle position defined above

box_transport_offset = box_transport_offset + [
	["uns_AmmoBox_ANZAC", [0, 0, 0.6] ],
	["uns_HiddenAmmoBox", [0, 0, 0.2] ],
	 ["Land_WaterBottle_01_stack_F", [0, 0, -0.2] ],
 	["Land_FoodSacks_01_large_brown_idap_F", [0, 0, -0.3] ] 
];
