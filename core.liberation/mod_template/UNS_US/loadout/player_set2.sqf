_unit = _this select 0;

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

// "Add weapons";
_unit addWeapon "uns_m14";
_unit addPrimaryWeaponItem "uns_m14mag";
_unit addWeapon "uns_m1911";
_unit addHandgunItem "uns_m1911mag";

// "Add containers";
_unit forceAddUniform "UNS_ARMY_BDU_1stIDpv1";
_unit addVest "uns_simc_56";
_unit addBackpack "uns_simc_US_Bandoleer_556_3";

// "Add binoculars";
_unit addWeapon "uns_binocular_navy";

// "Add items to containers";
for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
for "_i" from 1 to 3 do {_unit addItemToUniform "uns_m1911mag";};
for "_i" from 1 to 2 do {_unit addItemToUniform "uns_m61gren";};
for "_i" from 1 to 2 do {_unit addItemToVest "uns_m61gren";};
_unit addItemToVest "uns_kabar";
_unit addItemToVest "uns_m1911mag";
for "_i" from 1 to 4 do {_unit addItemToVest "uns_m14mag";};
_unit addItemToVest "uns_m308gren";
_unit addItemToVest "uns_m14gren";
_unit addItemToBackpack "FirstAidKit";
for "_i" from 1 to 4 do {_unit addItemToBackpack "uns_m14mag";};
_unit addHeadgear "uns_simc_m1_bitch_op";

// "Add items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";

// "Set identity";
//[_unit,"GreekHead_A3_02","male01eng"] call BIS_fnc_setIdentity;
