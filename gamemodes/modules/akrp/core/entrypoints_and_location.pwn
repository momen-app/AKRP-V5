main()
{
    print(" ");
	print("-------------------------------------------");
	print("Loading...");
	print("All Kerala Roleplay (2025)");
	print("-------------------------------------------");
	print("EDITING WITHOUT NAJU CAUSE SERIOUS ISSUE ");

}

LocateMethod(playerid, const params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Null Error - failed to locate properly - contact a developer.");
	    return 1;
	}
	if(!strcmp(params, "racetrack1", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

	    SetPlayerCheckpoint(playerid, 829.3257,-2168.8684,2.6271, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Race Track Self Repair 1.");
	}
	if(!strcmp(params, "7/11", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid,1241.75732, -1371.89358, 14.2845, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Race Track Self Repair 1.");
	}
	if(!strcmp(params, "RDC", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid,-1127.190429, 1098.394287, 38.203163, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Rdc");
	}


	if(!strcmp(params, "Impound", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2049.982666, -1912.952026, 13.546875, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Impound");
	}
	if(!strcmp(params, "GunShop", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1301.185913, -1875.214599, 13.632812, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Gunshop.");
	}
	if(!strcmp(params, "racetrack2", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 817.0483,-2168.1396,2.6409, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Race Track Self Repair 2");
	}
	if(!strcmp(params, "vote", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1954.323974, -1811.005371, 13.586874, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Votting Booth");
	}
	if(!strcmp(params, "dmv", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1837.467041, -1423.806884, 13.562500, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of DMV.");
	}
    if(!strcmp(params, "publiclocker", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid,1759.596313, -1661.407592, 13.556706, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of public locker.");
	}
	if(!strcmp(params, "fruit", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -2254.877929, -2314.894775, 29.164691, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of fruitpicker.");
	}
	if(!strcmp(params, "CattleJob", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -561.011474,-1508.511596, 9.141315, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of CattleJob");
	}
	else if(!strcmp(params, "paintball", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1220.2704, -1428.4060, 13.4382, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Paintball.");
	}
	else if(!strcmp(params, "mall", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1179.5540,-1323.4713,14.1752, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Mall.");
	}
	else if(!strcmp(params, "craft", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid,  -225.547302, 1077.088378, 19.742187, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Crafting Table.");
	}
	else if(!strcmp(params, "signaljob", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1991.694824,-1991.433837,13.546875, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the signaljob");
	}
	else if(!strcmp(params, "irev", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -348.081176, -1046.802734, 59.812500, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the All Saints.");
	}
	else if(!strcmp(params, "Carrob", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2707.4177,-2497.8257,13.7500, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Car Rob.");
	}
	else if(!strcmp(params, "dealership", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1494.422973, 758.040588, 11.130325, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Dealership.");
	}
	else if(!strcmp(params, "coroner", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_CORONER][jobX], jobLocations[JOB_CORONER][jobY], jobLocations[JOB_CORONER][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Coroner job.");
	}
	else if(!strcmp(params, "boatdealer", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 154.2223, -1946.3030, 5.1920, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Boat Dealership.");
	}
	else if(!strcmp(params, "airdealer", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1892.6315, -2328.6721, 13.5469, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Aircraft Dealership.");
	}
	else if(!strcmp(params, "bank", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1727.348510, -1130.319580, 24.095937, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Bank.");
	}
	else if(!strcmp(params, "casino", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1310.0944, -1367.9332, 13.5767, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Casino.");
	}
	else if(!strcmp(params, "cityhallls", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1481.1936, -1772.3101, 18.7958, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the City Hall LS.");
	}
	else if(!strcmp(params, "cityhalllv", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2412.8901, 1123.0446, 10.8203, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the City Hall LV.");
	}
	else if(!strcmp(params, "Mechanic Autoparts", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1597.656982, -2186.448242, 13.546875, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Mechanic HQ location.");
	}
	else if(!strcmp(params, "foodshop", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 722.189758, -1773.703247, 2.742840, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Foodshop.");
	}
	else if(!strcmp(params, "jewel", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 585.5768, -1500.7315, 15.3740, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Jewelry Shop.");
	}
	else if(!strcmp(params, "dressshop", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 609.618225, -1520.496215, 15.205955, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of DressShop.");
	}
    else if(!strcmp(params, "matpickup2", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2393.4885, -2008.5726, 13.3467, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the 2nd materials pickup.");
	}
	else if(!strcmp(params, "harvester", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -1112.4697, -1636.8641, 76.3672, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Harvester Sidejob.");
	}

	else if(!strcmp(params, "lumberjack", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -1991.550659, -2389.910644, 30.625000, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Lumberjack Job.");
	}
	else if(!strcmp(params, "matfactory1", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2173.2129, -2264.1548, 13.3467, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the 1st materials factory.");
	}
    else if(!strcmp(params, "matfactory2", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2288.0918, -1105.6555, 37.9766, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the 2nd materials factory.");
	}
	else if(!strcmp(params, "heisenbergs", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, -65.0972, -1574.3820, 2.6107, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Heisenberg's meth cooking trailer.");
	}
	else if(!strcmp(params, "aiportdepot", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2112.3240, -2432.8130, 13.5469, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of LSI Materials Depot.");
	}
	else if(!strcmp(params, "marinadepot", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 714.5344, -1565.1694, 1.7680, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of Marina materials depot.");
	}
	else if(!strcmp(params, "coinsshop", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 942.895019, -1418.117553, 13.5468756, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the CoinsShop.");
	}
	else if(!strcmp(params, "fleeca", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 942.402587, -1666.997680, 14.079086, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Fleeca Bank.");
	}
	else if(!strcmp(params, "vip", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2069.628662, -1565.076171, 14.8034, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the VIP Lounge.");
	}
	else if(!strcmp(params, "phone store", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 950.398742, -1656.711181, 13.550121, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Phone Store.");
	}
	else if(!strcmp(params, "trucker", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_COURIER][jobX], jobLocations[JOB_COURIER][jobY], jobLocations[JOB_COURIER][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Trucker job.");
	}
	
    else if(!strcmp(params, "miner", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_MINER][jobX], jobLocations[JOB_MINER][jobY], jobLocations[JOB_MINER][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Miner job.");
	}
	else if(!strcmp(params, "oilexporter", true))
	{
		new str[200];
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_OILEXPO][jobX], jobLocations[JOB_OILEXPO][jobY], jobLocations[JOB_OILEXPO][jobZ], 3.0);
	    format(str, 32, "Oil Exporter Job");
		SendClientMessage(playerid, COLOR_BLUE,"=================================================================================");
		SendClientMessage(playerid, COLOR_WHITE, ""BLUE"(( "WHITE"All kerala Roleplay's Global Positioning System (GPS) "BLUE"))");
		SendMessage(playerid, COLOR_BLUE, "Searching for "WHITE"Oil Exporter Job");
		SendMessage(playerid, COLOR_BLUE, "Distance: "WHITE"%.2f meters.", GetPlayerDistanceFromPoint(playerid, PlayerInfo[playerid][pWaypointPos][0], PlayerInfo[playerid][pWaypointPos][1], PlayerInfo[playerid][pWaypointPos][2]));
		SendClientMessage(playerid, COLOR_BLUE,"=================================================================================");
	}
	else if(!strcmp(params, "sim", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_MOBILE);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest sim Shop to you.");
	}
	else if(!strcmp(params, "atmjob", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_ATM][jobX], jobLocations[JOB_ATM][jobY], jobLocations[JOB_ATM][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Atm job.");
	}
	else if(!strcmp(params, "farmer", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_FARMER][jobX], jobLocations[JOB_FARMER][jobY], jobLocations[JOB_FARMER][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Farmer job.");
	}
	else if(!strcmp(params, "sandal", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_SANDALWOOD][jobX], jobLocations[JOB_SANDALWOOD][jobY], jobLocations[JOB_SANDALWOOD][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Sandal job.");
	}
	else if(!strcmp(params, "els", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 2316.5469, -1403.3070, 21.8769, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the East Los Santos Dirty Money Laundry.");
	}
	else if(!strcmp(params, "ps", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1477.8975, -1639.1193, 14.1484, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Pershing Square Dirty Money Laundry.");
	}
	else if(!strcmp(params, "gp", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 1971.9369, -1201.2697, 17.4500, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Glen Park Dirty Money Laundry.");
	}
	else if(!strcmp(params, "vb", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, 882.8823, -1721.1710, 12.9217, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Verona Beach Dirty Money Laundry.");
	}
	else if(!strcmp(params, "cm", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		SetPlayerCheckpoint(playerid, 897.0015, -1101.4503, 23.2969, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Cemetery Dirty Money Laundry.");
	}
	else if(!strcmp(params, "supermarket", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_STORE);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest supermarket to you.");
	}
	else if(!strcmp(params, "gunshopbiz", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_GUNSHOP);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest gun shop to you.");
	}
	else if(!strcmp(params, "clothesshop", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_CLOTHES);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest clothes shop to you.");
	}
	else if(!strcmp(params, "Blackmarket", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid,-403.169830, 1232.469482, 6.631836, 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Blackmarket");
	}
	else if(!strcmp(params, "gym", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_GYM);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest gym to you.");
	}
	else if(!strcmp(params, "restaurant", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_RESTAURANT);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest restaurant to you.");
	}
	else if(!strcmp(params, "adagency", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_AGENCY);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest advertisement agency to you.");
	}
	else if(!strcmp(params, "club", true))
	{
	    new businessid = GetClosestBusiness(playerid, BUSINESS_BARCLUB);

	    if(businessid == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no businesses of this type to be found.");
	    }

	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the closest club/bar to you.");
	}
	return 1;
}

IsPlayerInMech(playerid)
{
	for(new i = 0; i < sizeof(mechPosition); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4.0, mechPosition[i][0], mechPosition[i][1], mechPosition[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}
Graffiti_Refresh(id)
{
	if (id != -1 && GraffitiData[id][graffitiExists])
	{
		if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
		    DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);

		if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			DestroyDynamicObject(GraffitiData[id][graffitiObject]);

        //GraffitiData[id][graffitiIcon] = CreateDynamicMapIcon(GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 23, 0, -1, -1, -1, 100.0, MAPICON_GLOBAL);
		GraffitiData[id][graffitiObject] = CreateDynamicObject(19482, GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 0.0, 0.0, GraffitiData[id][graffitiPos][3]);

		SetDynamicObjectMaterial(GraffitiData[id][graffitiObject], 0, 0, "none", "none", 0);
		SetDynamicObjectMaterialText(GraffitiData[id][graffitiObject], 0, GraffitiData[id][graffitiText], OBJECT_MATERIAL_SIZE_256x128, "Diploma", 24, 1, GraffitiData[id][graffitiColor], 0, 0);
	}
	return 1;
}

IsSprayingInProgress(id)
{
	foreach (new i : Player)
	{
	    if (PlayerInfo[i][pGraffiti] == id && IsPlayerInRangeOfPoint(i, 5.0, GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2]))
	        return 1;
	}
	return 0;
}

Graffiti_Nearest(playerid)
{
	for (new i = 0; i < MAX_GRAFFITI_POINTS; i ++) if (GraffitiData[i][graffitiExists] && IsPlayerInRangeOfPoint(playerid, 5.0, GraffitiData[i][graffitiPos][0], GraffitiData[i][graffitiPos][1], GraffitiData[i][graffitiPos][2]))
	    return i;

	return -1;
}

Graffiti_Delete(id)
{
    if (id != -1 && GraffitiData[id][graffitiExists])
	{
	    new
	        string[64];

		if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
		    DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);

		if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			DestroyDynamicObject(GraffitiData[id][graffitiObject]);

		format(string, sizeof(string), "DELETE FROM `graffiti` WHERE `graffitiID` = '%d'", GraffitiData[id][graffitiID]);
		mysql_tquery(connectionID, string);

		GraffitiData[id][graffitiExists] = false;
		GraffitiData[id][graffitiText][0] = 0;
		GraffitiData[id][graffitiID] = 0;
	}
	return 1;
}

Graffiti_Save(id)
{
	new
	    query[384];

	format(query, sizeof(query), "UPDATE `graffiti` SET `graffitiX` = '%.4f', `graffitiY` = '%.4f', `graffitiZ` = '%.4f', `graffitiAngle` = '%.4f', `graffitiColor` = '%d', `graffitiText` = '%s' WHERE `graffitiID` = '%d'",
        GraffitiData[id][graffitiPos][0],
        GraffitiData[id][graffitiPos][1],
        GraffitiData[id][graffitiPos][2],
        GraffitiData[id][graffitiPos][3],
		GraffitiData[id][graffitiColor],
		SQL_ReturnEscaped(GraffitiData[id][graffitiText]),
		GraffitiData[id][graffitiID]
	);
	return mysql_tquery(connectionID, query);
}

Graffiti_Create(Float:x, Float:y, Float:z, Float:angle)
{
	for (new i = 0; i < MAX_GRAFFITI_POINTS; i ++)
	{
	    if (!GraffitiData[i][graffitiExists])
	    {
			GraffitiData[i][graffitiExists] = 1;
			GraffitiData[i][graffitiPos][0] = x;
			GraffitiData[i][graffitiPos][1] = y;
			GraffitiData[i][graffitiPos][2] = z;
			GraffitiData[i][graffitiPos][3] = angle - 90.0;
			GraffitiData[i][graffitiColor] = 0xFFFFFFFF;

			format(GraffitiData[i][graffitiText], 32, "Graffiti");

			Graffiti_Refresh(i);
			mysql_tquery(connectionID, "INSERT INTO `graffiti` (`graffitiColor`) VALUES(0)", "OnGraffitiCreated", "d", i);

			return i;
		}
	}
	return -1;
}

