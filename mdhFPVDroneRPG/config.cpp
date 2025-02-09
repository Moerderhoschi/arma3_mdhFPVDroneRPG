class CfgPatches 
{
	class mdhFPVDroneRPG
	{
		author = "Moerderhoschi";
		name = "FPV Drone RPG";
		url = "http://moerderhoschi.bplaced.net";
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		version = "1.20160815";
		versionStr = "1.20160815";
		versionAr[] = {1,20160816};
		authors[] = {};
	};
};

class CfgFunctions
{
	class mdh
	{
		class mdhFunctions
		{
			class mdhFPVDroneRPG
			{
				file = "mdhFPVDroneRPG\init.sqf";
				postInit = 1;
			};
		};
	};
};

class CfgMods
{
	class mdhFPVDroneRPG
	{
		dir = "@mdhFPVDroneRPG";
		name = "FPV Drone RPG";
		picture = "mdhFPVDroneRPG\mdhFPVDroneRPG.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "http://moerderhoschi.bplaced.net";
	};
};