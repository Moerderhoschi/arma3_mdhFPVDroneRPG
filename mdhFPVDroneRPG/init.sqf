/////////////////////////////////////////////////////////////////////////////////////////////
// MDH FPV DRONE RPG(by Moerderhoschi) - v2025-04-05
// github: https://github.com/Moerderhoschi/arma3_mdhFPVDroneRPG
// steam mod version: https://steamcommunity.com/sharedfiles/filedetails/?id=3361183268
/////////////////////////////////////////////////////////////////////////////////////////////
if (missionNameSpace getVariable ["pMdhFPVDroneRPG",99] == 99) then
{
	0 spawn
	{
		_valueCheck = 99;
		_defaultValue = 99;
		_path = 'mdhFPVDroneRPG';
		_env  = hasInterface;

		_diary  = 0;
		_mdhFnc = 0;

		if (hasInterface) then
		{
			_diary =
			{
				waitUntil {!(isNull player)};
				_c = true;
				_t = "FPV Drone RPG";
				if (player diarySubjectExists "MDH Mods") then
				{
					{
						if (_x#1 == _t) exitWith {_c = false}
					} forEach (player allDiaryRecords "MDH Mods");
				}
				else
				{
					player createDiarySubject ["MDH Mods","MDH Mods"];
				};
		
				if(_c) then
				{
					player createDiaryRecord
					[
						"MDH Mods",
						[
							_t,
							(
							  '<br/>FPV Drone RPG is a mod, created by Moerderhoschi for Arma 3.<br/>'
							+ '<br/>'
							+ 'You can assemble a Drone by having an <br/>'
							+ 'Drone Terminal equipped and also a Backpack with RPGs.<br/>'
							+ 'You can also use RPGs of other Units Backpacks to assemble Drones.<br/>'
							+ '<br/>'
							+ 'If you have any question you can contact me at the steam workshop page.<br/>'
							+ '<br/>'
							+ '<img image="'+_path+'\mdhFPVDroneRPG.paa"/>'					  
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
		};

		if (_env) then
		{
			_mdhFnc =
			{
				player setUnitTrait ['UAVHacker', true];
				_text = "Assemble FPV Drone RPG";
				{
					if ((((_x actionParams(_x getVariable["mdhFpvDroneRPGBackpackActionID",-1]))select 0)find _text) == -1)then
					{
						_code =
						{
							_u = _this select 0;
							_p = _this select 3 select 0;
							_g = "";
							{if (_g == "" && {_x in (compatibleMagazines "launch_RPG7_F" + compatibleMagazines "launch_RPG32_F")}) then {_g = _x}} forEach backpackItems _u;
							_u removeItemFromBackpack _g;
							if (vehicle player == player) then
							{
								if (stance player == "PRONE") then
								{
									player playActionNow "MedicOther";
									sleep 8;
								}
								else
								{
									player playActionNow "Medic";
									sleep 6;
								};
							};

							_ct = "B_UAV_01_F" createVehicle (player getRelPos [1,0]);
							_ct setDir getDir player;
							(side group player) createVehicleCrew _ct;
							//_w = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", getPos _ct];
							_w = createSimpleObject [(getText(configfile >> "CfgMagazines" >> _g >> "model")), getPos _ct];
							_w attachTo [_ct, [0, 0.15, 0.1]];
							_w setdir 90;
							if (_g == "CUP_OG7_M") then
							{
								_w attachTo [_ct, [0, 0.30, 0.1]];
								_w setdir 180;
							};
							_g = getText(configfile >> "CfgMagazines" >> _g >> "ammo");
							player connectTerminalToUAV _ct;
							_w lockInventory true;
							0 = [_ct, _w, _g] spawn
							{
								params["_ct","_w","_g"];
								_a = [];
								waitUntil {sleep 0.2;_a pushBack (speed _ct);if(count _a > 5)then{_a deleteAt 0}; !alive _ct};
								if (alive _w) then
								{
									deleteVehicle _w;
									if ((selectMax _a) > 20) then
									{
										//_t = "R_PG32V_F";
										_t = _g;
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
							,(_path+"\mdhFPVDroneRPG.paa")
							,(_path+"\mdhFPVDroneRPG.paa")
							,"
								player distance _target < 5
								&& {vehicle player == player}
								&& {backPack _target != """"}
								&& {_e=false;{if(toLower""UavTerminal"" in toLower _x)exitWith{_e=true}}foreach assignedItems player;_e} 
								&& {_g="""";{if(_g==""""&&{_x in (compatibleMagazines ""launch_RPG7_F"" + compatibleMagazines ""launch_RPG32_F"")})exitWith{_g = _x}} forEach backpackItems _target;_g != """"} 
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
						] call mdhHoldActionAdd;
	
						_x setVariable ["mdhFpvDroneRPGBackpackActionID",_mdhTmpActionID];
					};
				} forEach allUnits;
			};
		};

		if (hasInterface) then
		{
			uiSleep 1.2;;
			call _diary;
		};

		sleep (1 + random 2);
		while {missionNameSpace getVariable ["pMdhFPVDroneRPG",_defaultValue] == _valueCheck} do
		{
			if (_env) then {call _mdhFnc};
			sleep (7 + random 3);
			if (hasInterface) then {call _diary};
		};
	};
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// MDH HOLD ACTION ADD FUNCTION(by Moerderhoschi with massive help of GenCoder8) - v2025-03-27
// fixed version of BIS_fnc_holdActionAdd
///////////////////////////////////////////////////////////////////////////////////////////////////////////
if (hasInterface) then
{
	GenCoder8_fixHoldActTimer =
	{
		params["_title","_iconIdle","_hint"];
		private _frameProgress = "frameprog";
		if(time > (missionNamespace getVariable [_frameProgress,-1])) then
		{
			missionNamespace setVariable [_frameProgress,time + 0.065];
			bis_fnc_holdAction_animationIdleFrame = (bis_fnc_holdAction_animationIdleFrame + 1) % 12;
		};
		private _var = "bis_fnc_holdAction_animationIdleTime_" + (str _target) + "_" + (str _actionID);
		if (time > (missionNamespace getVariable [_var,-1]) && {_eval}) then
		{
			missionNamespace setVariable [_var, time + 0.065];
			if (!bis_fnc_holdAction_running) then
			{
				[_originalTarget,_actionID,_title,_iconIdle,bis_fnc_holdAction_texturesIdle,bis_fnc_holdAction_animationIdleFrame,_hint] call bis_fnc_holdAction_showIcon;
			};
		};
	};

	_origFNC = preprocessFileLineNumbers "a3\functions_f\HoldActions\fn_holdActionAdd.sqf";
	_newFNC = ([_origFNC, "bis_fnc_holdAction_animationTimerCode", true] call BIS_fnc_splitString)#0;
	_newFNC = _newFNC + "GenCoder8_fixHoldActTimer";
	_newFNC = _newFNC + ([_origFNC, "bis_fnc_holdAction_animationTimerCode", true] call BIS_fnc_splitString)#1;
	_newFNC = _newFNC + "GenCoder8_fixHoldActTimer";
	_newFNC = _newFNC + ([_origFNC, "bis_fnc_holdAction_animationTimerCode", true] call BIS_fnc_splitString)#2;
	mdhHoldActionAdd = compile _newFNC;
};