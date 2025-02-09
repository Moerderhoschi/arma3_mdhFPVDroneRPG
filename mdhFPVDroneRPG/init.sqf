///////////////////////////////////////////////////////////////////////////////////////////////////
// FPV DRONE RPG MOD
// MADE BY MOERDERHOSCHI
// ARMED-ASSAULT.DE
// 10.2024
///////////////////////////////////////////////////////////////////////////////////////////////////
0 = [] spawn
{
	if (isDedicated) exitWith {};
	waitUntil {sleep 1; !(isNull player)};
	waitUntil {sleep 1; player == player};

	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DIARYRECORD
	///////////////////////////////////////////////////////////////////////////////////////////////////
	_diary =
	{
		if (isNull player) exitWith {false};
		if(!(player diarySubjectExists "mdhFPVDroneRPG")) then
		{
			player createDiarySubject ["mdhFPVDroneRPG","FPV Drone RPG"];
			player createDiaryRecord
			[
				"mdhFPVDroneRPG",
				[
					"FPV Drone RPG by Moerderhoschi",
					(
						'<br/>FPV Drone RPG is a mod, created by Moerderhoschi for Arma 3.<br/>'
					  + '<br/>'
					  + 'You can assemble a Drone by having an <br/>'
					  + 'Drone Terminal equipped and also a Backpack with RPGs.<br/>'
					  + 'You can also use RPGs of other Units Backpacks to assemble Drones.<br/>'
					  + '<br/>'
					  + 'If you have any question you can contact me at the official Bohemia Interactive Forum: forums.bistudio.com<br/>'
					  + '<br/>'
					  + '<img image="mdhFPVDroneRPG\mdhFPVDroneRPG.paa"/>'					  
					  + '<br/>'
					  + 'Credits and Thanks:<br/>'
					  + 'Armed-Assault.de Crew - For many great ArmA moments in many years<br/>'
					  + 'BIS - For ArmA3<br/>'
					)
				]
			]
		};
		true
	};
	
	///////////////////////////////////////////////////////
	// set drone function
	///////////////////////////////////////////////////////
	_addaction =
	{
		if (!isDedicated) then
		{
			player setUnitTrait ['UAVHacker', true];
			_text = "Assemble FPV Drone RPG";
			{
				if ((((_x actionParams(_x getVariable["mdhFpvDroneRPGBackpackActionID",-1]))select 0)find _text)<0)then
				{
					_code =
					{
						_u = _this select 0;
						_p = _this select 3 select 0;
						_g = "";
						{if (_g == "" && {_x in (compatibleMagazines "launch_RPG7_F" + compatibleMagazines "launch_RPG32_F")}) then {_g = _x}} forEach backpackItems _u;
						_u removeItemFromBackpack _g;
						player playActionNow "Medic";
						sleep 6;

						_ct = "B_UAV_01_F" createVehicle (player getRelPos [1,0]);
						_ct setDir getDir player;
						(side group player) createVehicleCrew _ct;
						_w = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", getPos _ct];
						_w attachTo [_ct, [0, 0.15, 0.1]];
						_w setdir 90;
						player connectTerminalToUAV _ct;
						_w lockInventory true;
						0 = [_ct, _w] spawn
						{
							params["_ct","_w"];
							_a = [];
							waitUntil {sleep 0.2;_a pushBack (speed _ct);if(count _a > 5)then{_a deleteAt 0}; !alive _ct};
							if (alive _w) then
							{
								deleteVehicle _w;
								if ((selectMax _a) > 20) then
								{
									_t = "R_PG32V_F";
									_b = _t createVehicle getPos _ct;
									_b attachTo [_ct, [0, 0, 0.5]];
									_b setdir 270;
									detach _b;
									_b setVelocityModelSpace [0,100,0];
								};
							};
						};
					};

					_mdhTmpActionID =
					[
						_x
						,_text
						,"mdhFPVDroneRPG\mdhFPVDroneRPG.paa"
						,"mdhFPVDroneRPG\mdhFPVDroneRPG.paa"
						,"
							player distance _target < 5
							&& {vehicle player == player}
							&& {backPack _target != """"}
							&& {_e=false;{if(toLower""UavTerminal"" in toLower _x)then{_e=true}}foreach assignedItems player;_e} 
							&& {_g="""";{if(_g==""""&&{_x in (compatibleMagazines ""launch_RPG7_F"" + compatibleMagazines ""launch_RPG32_F"")}) then {_g = _x}} forEach backpackItems _target;_g != """"} 
						"
						,"true"
						,{}
						,{}
						,_code
						,{}
						,[1]
						,1
						,-1
						,false
						,false
						,false
					] call BIS_fnc_holdActionAdd;

					_x setVariable ["mdhFpvDroneRPGBackpackActionID",_mdhTmpActionID];
				};
			} forEach allUnits;
		};
	};
	
	///////////////////////////////////////////////////////
	// loop
	///////////////////////////////////////////////////////
	sleep 1;

	while {sleep 1; true} do
	{
		sleep random 1;
		0 = [_diary, _addaction] spawn
		{
			waitUntil {!(isNull player)};
			waitUntil {player==player};
			0 = [] call (_this select 0);
			0 = [] call (_this select 1);
		};
		sleep 5;
	};
};