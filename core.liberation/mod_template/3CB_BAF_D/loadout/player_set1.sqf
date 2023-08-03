_unit = _this select 0;

//  "Remove existing items";
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

// "Add weapons";
_unit addWeapon "UK3CB_BAF_L131A1";
_unit addHandgunItem "UK3CB_BAF_9_17Rnd";


// "Add containers";
_unit forceAddUniform "UK3CB_BAF_U_CombatUniform_DDPM_RM";
_unit addVest "UK3CB_BAF_V_Osprey_DDPM2";
_unit addBackpack "UK3CB_BAF_B_Bergen_DDPM_Rifleman_A";

// "Add binoculars";
_unit addWeapon "Binocular";

// "Add items to containers";
for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
for "_i" from 1 to 2 do {_unit addItemToUniform "rhs_mag_m18_red";};
for "_i" from 1 to 2 do {_unit addItemToVest "FirstAidKit";};
for "_i" from 1 to 2 do {_unit addItemToVest "30Rnd_9x21_Mag";};
for "_i" from 1 to 2 do {_unit addItemToVest "rhs_mag_m67";};
_unit addHeadgear "UK3CB_BAF_H_Mk6_DDPM_A";
_unit addGoggles "rhs_googles_yellow";

// "Add items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";
_unit linkItem "ItemGPS";

// "Set identity";
//[_unit,"GreekHead_A3_02","male01eng"] call BIS_fnc_setIdentity;
