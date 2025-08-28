/////////////////////////////////////////////////////////////////////////////////////////////
// MDH FPV DRONE RPG(by Moerderhoschi) - v2025-08-28
// github: https://github.com/Moerderhoschi/arma3_mdhFPVDroneRPG
// steam mod version: https://steamcommunity.com/sharedfiles/filedetails/?id=3361183268
/////////////////////////////////////////////////////////////////////////////////////////////
pMdhFPVDroneRPG = 99; // FORCE USE OF ADDON NOT mdhMissionEnhancements Script!
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
					mdhFPVDroneRPGModBriefingFnc =
					{
						if ((_this#0) == "mdhFPVDroneRPGModAssembleTime") then
						{
							profileNameSpace setVariable[_this#0,_this#1];
						}
						else
						{
							_terminal = "B_UavTerminal";
							if (side group player == civilian) then {_terminal = "C_UavTerminal"};
							if (side group player == east) then {_terminal = "O_UavTerminal"};
							if (side group player == independent) then {_terminal = "I_UavTerminal"};
							player linkItem _terminal;
						};
						systemChat (_this#2);
					};

					player createDiaryRecord
					[
						"MDH Mods",
						[
							_t,
							(
							  '<br/>FPV Drone RPG is a mod, created by Moerderhoschi for Arma 3. (v2025-08-28)<br/>'
							+ '<br/>'
							+ 'You can assemble a Drone by having an <br/>'
							+ 'Drone Terminal equipped and also a Backpack with RPGs or Mines.<br/>'
							+ 'You can also use RPGs of other Units Backpacks to assemble Drones.<br/>'
							+ '<br/>'
							+ 'FPV Drone RPG Modoptions: '
							+ '<br/>Add Terminal to inventory: <font color="#33CC33"><execute expression = "[''mdhFPVDroneRPGModTerminal'',true,''FPV Drone RPG Terminal added to inventory''] call mdhFPVDroneRPGModBriefingFnc">gimme</execute></font color>'
							+ '<br/>Assembletime: '
							+    '<font color="#33CC33"><execute expression = "[''mdhFPVDroneRPGModAssembleTime'',1,''MDH FPV Drone assemble time activated''] call mdhFPVDroneRPGModBriefingFnc">activate</execute></font color>'
							+ ' / <font color="#CC0000"><execute expression = "[''mdhFPVDroneRPGModAssembleTime'',0,''MDH FPV Drone assemble time deactivated''] call mdhFPVDroneRPGModBriefingFnc">deactivate</execute></font color>'							
							+ '<br/><br/>'
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
				_text = "Assemble FPV Drone ";
				_satchels = ["SatchelCharge_Remote_Mag","DemoCharge_Remote_Mag"];
				_satchels = _satchels + ["APERSBoundingMine_Range_Mag","APERSTripMine_Wire_Mag","APERSMine_Range_Mag","ATMine_Range_Mag","ClaymoreDirectionalMine_Remote_Mag","SLAMDirectionalMine_Wire_Mag"];
				_satchels = _satchels + ["CUP_PipeBomb_M","CUP_MineE_M","CUP_Mine_M"];

				_code =
				{
					_u = _this #0;
					_p = _this #3#0;
					_satchels = _this #3#1;
					showCommandingMenu "RscMainMenu";showCommandingMenu ""; // hideActionMenuAfterUse
					_g = _p;
					_u removeItem _g;
					if (vehicle player == player) then
					{
						if (profileNameSpace getVariable ["mdhFPVDroneRPGModAssembleTime",1] == 1) then
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
					};

					_ct = "B_UAV_01_F" createVehicle (player getRelPos [1,0]);
					_ct setDir getDir player;
					(side group player) createVehicleCrew _ct;
					_w = createSimpleObject [(getText(configfile >> "CfgMagazines" >> _g >> "model")), getPos _ct];
					_w attachTo [_ct, [0, 0.15, 0.1]];
					_w setdir 90;
					if (_g == "CUP_OG7_M") then
					{
						_w attachTo [_ct, [0, 0.3, 0.1]];
						_w setdir 180;
					};
					if (_g in _satchels) then
					{
						_w attachTo [_ct, [0, 0.02, 0.14]];
						if (_g in ["SatchelCharge_Remote_Mag"]) then {_w attachTo [_ct, [0, 0.05, 0.14]]};
						_w setDir 90;
						if (_g in ["CUP_PipeBomb_M","APERSTripMine_Wire_Mag"]) then {_w setdir 0};
						if (_g in ["APERSBoundingMine_Range_Mag"]) then
						{
							_w attachTo [_ct, [0, 0, 0.14]];
							_w setdir 0;
							_w setVectorUp[0,999,1]
						};
					};
					_ammo = getText(configfile >> "CfgMagazines" >> _g >> "ammo");
					player connectTerminalToUAV _ct;
					_w lockInventory true;
					0 = [_ct, _w, _ammo, _g, _satchels] spawn
					{
						params["_ct","_w","_ammo","_g","_satchels"];
						0 = [_ct] spawn
						{
							params["_ct"];
							_a = [];
							{_a pushBack configName _x} forEach (configProperties[configFile >> "CfgVehicles" >> (typeOf _ct) >> "HitPoints"]);
							waitUntil
							{
								sleep 0.2;
								if (alive _ct) then {{if (_ct getHitPointDamage _x > 0) then {_ct setHitPointDamage [_x, 0]}} forEach _a};
								!alive _ct OR speed _ct > 5 OR speed _ct < -5 OR ((getPos _ct)#2) > 2;
							};
						};

						_a = [];
						waitUntil {sleep 0.2;_a pushBack (speed _ct);if(count _a > 5)then{_a deleteAt 0}; !alive _ct};
						if (alive _w) then
						{
							deleteVehicle _w;
							if ((selectMax _a) > 20) then
							{
								_t = _ammo;
								_b = _t createVehicle getPos _ct;
								_b attachTo [_ct, [0, 0, 0.5]];
								_b setdir 270;
								detach _b;
								if (_g in _satchels) then
								{
									_b setDamage 1;
								}
								else
								{
									_b setVelocityModelSpace [0,100,0];
								};
							};
						};
					};
				};

				
				{
					_u = _x;
					if ((actionIDs _u findIf {_text in (_u actionParams _x select 0)}) == -1) then
					{
						{
							_m = _x;
							_g = getText(configfile >> "CfgMagazines" >> _x >> "displayName");
							_mdhTmpActionID =
							[
								_u
								,_text +  _g
								,(_path+"\mdhFPVDroneRPG.paa")
								,(_path+"\mdhFPVDroneRPG.paa")
								,"
									player distance _target < 5
									&& {vehicle player == player}
									&& {assignedItems player findIf {toLower""UavTerminal"" in toLower _x} != -1}
									&& {itemsWithMagazines _target findIf {_x == """+_m+"""} != -1 }
								"
								,"true"
								,{}
								,{}
								,_code
								,{}
								,[_m,_satchels]
								,1
								,-1
								,false
								,false
								,false
							] call mdhHoldActionAdd;							
						} forEach (compatibleMagazines "launch_RPG7_F" + compatibleMagazines "launch_RPG32_F" + _satchels);
					};
				} forEach allUnits;
			};
		};

		if (hasInterface) then
		{
			uiSleep 1.2;;
			call _diary;
		};

		pMdhFPVDroneRPG = 99; // FORCE USE OF ADDON NOT mdhMissionEnhancements Script!
		sleep (1 + random 2);
		pMdhFPVDroneRPG = 99; // FORCE USE OF ADDON NOT mdhMissionEnhancements Script!
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