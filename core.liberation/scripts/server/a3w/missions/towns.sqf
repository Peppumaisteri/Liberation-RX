// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: towns.sqf
//	LRX Integration: pSiKO

private _towns = ((allMapMarkers select {_x select [0,7] == "bigtown" && !(_x in blufor_sectors)}) apply {[_x, -1, markerText _x]});
_towns;
