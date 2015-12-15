_objects = 
[
    ["B_Boat_Armed_01_minigun_F",[2665.3274,22078.639,0.753543],0],
	["Land_PaperBox_open_empty_F",[2668.83,22088.2,3.10634],342.052],
	["Land_PaperBox_closed_F",[2667.63,22090.4,3.32083],320.85],
	["B_Boat_Armed_01_minigun_F",[2672.72,22076.6,0.685521],24.119],
	["Land_TentDome_F",[2685.43,22106.7,1.36753],116.023],
	["Land_TentDome_F",[2689.31,22102.7,1.65421],138.844],
	["Land_TentDome_F",[2680.6,22109.7,1.44558],113.664],
	["Land_TentDome_F",[2690.91,22097.5,2.00247],175.164],
	["Land_ToiletBox_F",[2682.61,22100.8,1.94478],18.2243],
	["Land_ToiletBox_F",[2685.09,22098.9,1.99074],45.2698],
	["Campfire_burning_F",[2680.66,22105.5,1.75212],0],
	["Land_Pallet_MilBoxes_F",[2671.25,22088,3.20412],0],
	["Land_PaperBox_open_full_F",[2670.22,22090.5,3.55122],0],
	["Item_Medikit",[2671.17,22089.9,3.48446],273.24],
	["Land_WoodPile_F",[2677.41,22106,1.85116],119.042],
	["Land_CampingTable_F",[2674.77,3.62944,22090.8],300.226],
	["Weapon_hgun_Rook40_F",[2674.52,22090.7,4.45849],0],
	["Land_CampingChair_V1_F",[2673.02,22090.6,3.63621],275.497],
	["Intel_File2_F",[2674.94,22091.3,4.45198],62.4856],
	["Land_Camping_Light_off_F",[2674.3,22090.3,4.45759],300.779],
	["Intel_File1_F",[2674.8,22091.1,4.4568],89.7922],
	["Land_Can_V1_F",[2674.91,22091.5,4.46289],0],
	["Land_TentDome_F",[2675.46,22111.2,1.71401],83.3397]
];

{
    private ["_object"];

    _object = (_x select 0) createVehicle [0,0,0];
    _object setDir (_x select 2);
    _object setPos (_x select 1);
    _object allowDamage false;
    _object enableSimulationGlobal false;
}
forEach _objects;

_guards = 
[
    ["B_G_engineer_F",[2678.16,22083.5,2.39605],81.446],
	["O_ghillie_ard_F",[2667.36,22093.2,3.69411],113.255],
	["B_G_engineer_F",[2662.04,22087.3,2.37746],305.003],
	["O_ghillie_ard_F",[2677.4,22077.5,0.955983],107.928],
	["B_G_engineer_F",[2675.22,22106.2,2.00568],260.065],
	["B_G_engineer_F",[2731,22084.2,5.85595],260.065],
	["O_ghillie_ard_F",[2700.18,22069.2,2.07421],124.822],
	["O_ghillie_ard_F",[2708.36,22096.3,2.25525],107.928],
	["O_ghillie_ard_F",[2641.25,22124.2,3.25387],107.928]
];

{
    private ["_guard"];

    _guard = (_x select 0) createVehicle [0,0,0];
    _guard setDir (_x select 2);
    _guard setPosATL (_x select 1);
	
}
forEach _guards;