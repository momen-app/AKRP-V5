public OnPlayerRemoveFromPhonebook(playerid, number)
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That number is not in the phonebook.");
	}
	else
	{
	    new name[MAX_PLAYER_NAME];

	    SQL_GetStringByIndex(0, 0, name);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM phonebook WHERE number = %i", number);
		mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_YELLOW, "You have removed %s with number %i from the phonebook directory.", name, number);
	    ////Log_Write("log_faction", "%s (uid: %i) removed %s with number %i from the phonebook.", GetRPName(playerid), PlayerInfo[playerid][pID], name, number);
	}

	return 1;
}

forward OnPlayerListInjuries(playerid, targetid);
public OnPlayerListInjuries(playerid, targetid)
{
	new rows = SQL_GetRows();

    if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player doesn't have any injuries.");
	}
	else
	{
	    SM(playerid, SERVER_COLOR, "%s's Injuries", GetRPName(targetid));

	    for(new i = 0; i < rows; i ++)
	    {
			SM(playerid, COLOR_YELLOW, "[%i seconds ago] %s was shot with a %s", gettime() - SQL_GetIntByIndex(i, 1), GetRPName(targetid), GetWeaponNameEx(SQL_GetIntByIndex(i, 0)));
		}
	}
}

forward OnPlayerOfflineKickFaction(playerid, username[]);
public OnPlayerOfflineKickFaction(playerid, username[])
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else if(SQL_GetIntByIndex(0, 1) != PlayerInfo[playerid][pFaction])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your faction.");
	}
	else if(SQL_GetIntByIndex(0, 2) > PlayerInfo[playerid][pFactionRank])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
	}
	else
	{
	    new uid = SQL_GetIntByIndex(0, 0);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = -1, factionrank = 0, division = -1 WHERE uid = %i", uid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have offline kicked %s from your faction.", username);
	}
}

forward OnPlayerOfflineKickGang(playerid, username[]);
public OnPlayerOfflineKickGang(playerid, username[])
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else if(SQL_GetIntByIndex(0, 1) != PlayerInfo[playerid][pGang])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your gang.");
	}
	else if(SQL_GetIntByIndex(0, 2) > PlayerInfo[playerid][pGangRank])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
	}
	else
	{
	    new uid = SQL_GetIntByIndex(0, 0);

		////Log_Write("log_gang", "%s (uid: %i) offline kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, uid, GangInfo[gangid][gName], gangid, GangRanks[gangid][rankid], rankid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = -1, gangrank = 0 WHERE uid = %i", uid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have offline kicked %s from your gang.", username);
	}
}

forward OnPlayerListGangs(playerid, gangid);
public OnPlayerListGangs(playerid, gangid)
{
	new color, members = SQL_GetIntByIndex(0, 0), color2, allyname[32];

	if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
	{
		color = 0xC8C8C8FF;
	}
	else
	{
	    color = GangInfo[gangid][gColor];
	}

	new alliance = GangInfo[gangid][gAlliance];

	if(alliance >= 0)
	{
		strcpy(allyname, GangInfo[alliance][gName]);
		if(GangInfo[alliance][gColor] == -1 || GangInfo[alliance][gColor] == -256)
		{
	    	color2 = 0xC8C8C8FF;
		}
		else
		{
		    color2 = GangInfo[alliance][gColor];
		}
	}
	if(alliance >= 0)
	{
	    SM(playerid, COLOR_GREY2, "{%06x}%i. %s | Leader: %s | Members: %i/%i | Strikes: %i/3 | Ally: {%06x}%s", color >>> 8, gangid, GangInfo[gangid][gName], GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], color2 >>> 8, allyname);
	}
	else if(alliance >= 0)
	{
	    SM(playerid, COLOR_GREY2, "{%06x}%i. %s | Leader: %s | Members: %i/%i | Strikes: %i/3 | Ally: {%06x}%s", color >>> 8, gangid, GangInfo[gangid][gName], GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], color2 >>> 8, allyname);
	}
	else
	{
		SM(playerid, COLOR_GREY2, "{%06x}%i. %s | Leader: %s | Members: %i/%i | Strikes: %i/3", color >>> 8, gangid, GangInfo[gangid][gName], GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes]);
	}
}

forward OnPlayerListFactions(playerid, factionid);
public OnPlayerListFactions(playerid, factionid)
{
	new color, members = SQL_GetIntByIndex(0, 0), szMessage[1080];

	if(FactionInfo[factionid][fColor] == -1 || FactionInfo[factionid][fColor] == -256)
	{
		color = 0xC8C8C8FF;
	}
	else
	{
	    color = FactionInfo[factionid][fColor];
	}
	if(FactionInfo[factionid][fType] == FACTION_HITMAN || FactionInfo[factionid][fType] == FACTION_FEDERAL && PlayerInfo[playerid][pAdmin] < 6)
	{
    	format(szMessage, sizeof(szMessage), "{%06x}%i. %s | "RED"Confidential", color >>> 8, factionid, FactionInfo[factionid][fName]);
	}
   	else
   	{
		format(szMessage, sizeof(szMessage), "{%06x}%i. %s | Leader: %s | Members: %i", color >>> 8, factionid, FactionInfo[factionid][fName], FactionInfo[factionid][fLeader], members);
	}
	SendClientMessage(playerid, COLOR_GREY, szMessage);
}

forward OnPlayerBuyPhoneNumber(playerid, number);
public OnPlayerBuyPhoneNumber(playerid, number)
{
	if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The specified phone number is already taken.");
	}
	else
	{
	    PlayerInfo[playerid][pPhone] = number;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", number, PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    GivePlayerCash(playerid, -100000);
	    GameTextForPlayer(playerid, "~r~-$100000", 5000, 1);

	    SM(playerid, COLOR_WHITE, "** You paid $100000 to change your phone number to %i.", number);
	    ////Log_Write("log_vip", "%s Donator %s (uid: %i) has purchased phone number: %i for $100000.", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], number);
	}
}

forward OnPlayerSpawnVehicle(playerid, parked);
public OnPlayerSpawnVehicle(playerid, parked)
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no valid vehicle which you can spawn.");
	}
	else
	{
        foreach(new i : Vehicle)
	    {
	        if(IsValidVehicle(i) && VehicleInfo[i][vID] == SQL_GetInt(0, "id"))
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is spawned already. /v find to track it.");
	    	}
	    }
		if(SQL_GetInt(0, "impounded"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} This vehicle is impounded. You can release it from the DMV. (/gps)");
		}
 		if(SQL_GetInt(0, "broken"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} Some parts are broken after getting stoled, (( You can spawned it after 5 days ))");
		}
	    new
			modelid = SQL_GetInt(0, "modelid"),
			Float:x = SQL_GetFloat(0, "pos_x"),
			Float:y = SQL_GetFloat(0, "pos_y"),
			Float:z = SQL_GetFloat(0, "pos_z"),
			Float:a = SQL_GetFloat(0, "pos_a"),
			color1 = SQL_GetInt(0, "color1"),
			color2 = SQL_GetInt(0, "color2"),
			vehicleid;

		vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
		GetPlayerPos(playerid, x, y, z);
		SetVehiclePos(vehicleid, x + 1, y + 1, z + 2.0);
		PutPlayerInVehicle(playerid, vehicleid, 0);


		if(vehicleid != INVALID_VEHICLE_ID)
		{
		    ResetVehicle(vehicleid);

		    SQL_GetString(0, "owner", VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
		    SQL_GetString(0, "plate", VehicleInfo[vehicleid][vPlate], 32);

		    VehicleInfo[vehicleid][vID] = SQL_GetInt(0, "id");
		    VehicleInfo[vehicleid][vOwnerID] = SQL_GetInt(0, "ownerid");
			VehicleInfo[vehicleid][vOgowner] = SQL_GetInt(0, "ogowner");
		    VehicleInfo[vehicleid][vPrice] = SQL_GetInt(0, "price");
		    VehicleInfo[vehicleid][vTickets] = SQL_GetInt(0, "tickets");
		    VehicleInfo[vehicleid][vLocked] = SQL_GetInt(0, "locked");
		    VehicleInfo[vehicleid][vHealth] = SQL_GetFloat(0, "health");
		    VehicleInfo[vehicleid][vPaintjob] = SQL_GetInt(0, "paintjob");
		    VehicleInfo[vehicleid][vInterior] = SQL_GetInt(0, "interior");
	        VehicleInfo[vehicleid][vGang] = SQL_GetInt(0, "gangid");
	        VehicleInfo[vehicleid][vWorld] = SQL_GetInt(0, "world");
	        VehicleInfo[vehicleid][vNeon] = SQL_GetInt(0, "neon");
	        VehicleInfo[vehicleid][vNeonEnabled] = SQL_GetInt(0, "neonenabled");
	        VehicleInfo[vehicleid][vTrunk] = SQL_GetInt(0, "trunk");
	        VehicleInfo[vehicleid][vMods][0] = SQL_GetInt(0, "mod_1");
	        VehicleInfo[vehicleid][vMods][1] = SQL_GetInt(0, "mod_2");
	        VehicleInfo[vehicleid][vMods][2] = SQL_GetInt(0, "mod_3");
	        VehicleInfo[vehicleid][vMods][3] = SQL_GetInt(0, "mod_4");
	        VehicleInfo[vehicleid][vMods][4] = SQL_GetInt(0, "mod_5");
	        VehicleInfo[vehicleid][vMods][5] = SQL_GetInt(0, "mod_6");
	        VehicleInfo[vehicleid][vMods][6] = SQL_GetInt(0, "mod_7");
	        VehicleInfo[vehicleid][vMods][7] = SQL_GetInt(0, "mod_8");
	        VehicleInfo[vehicleid][vMods][8] = SQL_GetInt(0, "mod_9");
	        VehicleInfo[vehicleid][vMods][9] = SQL_GetInt(0, "mod_10");
	        VehicleInfo[vehicleid][vMods][10] = SQL_GetInt(0, "mod_11");
	        VehicleInfo[vehicleid][vMods][11] = SQL_GetInt(0, "mod_12");
	        VehicleInfo[vehicleid][vMods][12] = SQL_GetInt(0, "mod_13");
	        VehicleInfo[vehicleid][vMods][13] = SQL_GetInt(0, "mod_14");
	        VehicleInfo[vehicleid][vCash] = SQL_GetInt(0, "cash");
	        VehicleInfo[vehicleid][vMaterials] = SQL_GetInt(0, "materials");
	        VehicleInfo[vehicleid][vPot] = SQL_GetInt(0, "pot");
	        VehicleInfo[vehicleid][vCrack] = SQL_GetInt(0, "crack");
	        VehicleInfo[vehicleid][vMeth] = SQL_GetInt(0, "meth");
	        VehicleInfo[vehicleid][vPainkillers] = SQL_GetInt(0, "painkillers");
	        VehicleInfo[vehicleid][vWeapons][0] = SQL_GetInt(0, "weapon_1");
	        VehicleInfo[vehicleid][vWeapons][1] = SQL_GetInt(0, "weapon_2");
	        VehicleInfo[vehicleid][vWeapons][2] = SQL_GetInt(0, "weapon_3");
            VehicleInfo[vehicleid][vHPAmmo] = SQL_GetInt(0, "hpammo");
            VehicleInfo[vehicleid][vPoisonAmmo] = SQL_GetInt(0, "poisonammo");
            VehicleInfo[vehicleid][vFMJAmmo] = SQL_GetInt(0, "fmjammo");
            if(SQL_GetInt(0, "rent") == 1)
			{
				VehicleInfo[vehicleid][vRent] = SQL_GetInt(0, "rent");
                VehicleInfo[vehicleid][vRenttime] = SQL_GetInt(0, "renttime");
			}
			else{
				VehicleInfo[vehicleid][vRent] = 0;
				VehicleInfo[vehicleid][vRenttime] = 0;
			}
	        VehicleInfo[vehicleid][vFactionType] = FACTION_NONE;
	        VehicleInfo[vehicleid][vJob] = JOB_NONE;
	        VehicleInfo[vehicleid][vRespawnDelay] = -1;
	        VehicleInfo[vehicleid][vModel] = modelid;
		    VehicleInfo[vehicleid][vPosX] = x;
		    VehicleInfo[vehicleid][vPosY] = y;
		    VehicleInfo[vehicleid][vPosZ] = z;
		    VehicleInfo[vehicleid][vPosA] = a;
		    VehicleInfo[vehicleid][vColor1] = color1;
		    VehicleInfo[vehicleid][vColor2] = color2;
		    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vTimer] = -1;
            VehicleInfo[vehicleid][vVip] = 0;
			vehicleFuel[vehicleid] = SQL_GetInt(0, "fuel");
			adminVehicle{vehicleid} = false;

			ReloadVehicle(vehicleid);

		    if(!parked)
			{
			    SM(playerid, COLOR_AQUA, "You have spawned your "SVRCLR"%s{CCFFFF} which is located in {F7A763}%s{CCFFFF}. /findcar to track it.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			}
	    }
	}

	return 1;
}

forward OnPlayerSpawnVehiclePGValley(playerid, parked);
public OnPlayerSpawnVehiclePGValley(playerid, parked)
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no valid vehicle which you can spawn.");
	}

	else
	{
        foreach(new i : Vehicle)
	    {
	        if(IsValidVehicle(i) && VehicleInfo[i][vID] == SQL_GetInt(0, "id"))
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is spawned already. /findcar to track it.");
	    	}
	    }
	    if(SQL_GetInt(0, "impounded"))
        {
	    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} This vehicle is impounded. You can release it from the DMV. (/Phone > Gps > Google Map > Impound)");
	    }
	    new
			modelid = SQL_GetInt(0, "modelid"),
			Float:x = SQL_GetFloat(0, "pos_x"),
			Float:y = SQL_GetFloat(0, "pos_y"),
			Float:z = SQL_GetFloat(0, "pos_z"),
			Float:a = SQL_GetFloat(0, "pos_a"),
			color1 = SQL_GetInt(0, "color1"),
			color2 = SQL_GetInt(0, "color2"),
			vehicleid;

		vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
		GetPlayerPos(playerid, x, y, z);
		SetVehiclePos(vehicleid, x + 5, y + 5, z + 2.0);
		new rand = Random(5000, 10000);
		GivePlayerCash(playerid, -rand);

		if(vehicleid != INVALID_VEHICLE_ID)
		{
		    ResetVehicle(vehicleid);

		    SQL_GetString(0, "owner", VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
		    SQL_GetString(0, "plate", VehicleInfo[vehicleid][vPlate], 32);

		    VehicleInfo[vehicleid][vID] = SQL_GetInt(0, "id");
		    VehicleInfo[vehicleid][vOwnerID] = SQL_GetInt(0, "ownerid");
			VehicleInfo[vehicleid][vOgowner] = SQL_GetInt(0, "ogowner");
		    VehicleInfo[vehicleid][vPrice] = SQL_GetInt(0, "price");
		    VehicleInfo[vehicleid][vTickets] = SQL_GetInt(0, "tickets");
		    VehicleInfo[vehicleid][vLocked] = SQL_GetInt(0, "locked");
		    VehicleInfo[vehicleid][vHealth] = SQL_GetFloat(0, "health");
		    VehicleInfo[vehicleid][vPaintjob] = SQL_GetInt(0, "paintjob");
		    VehicleInfo[vehicleid][vInterior] = SQL_GetInt(0, "interior");
	        VehicleInfo[vehicleid][vWorld] = SQL_GetInt(0, "world");
	        VehicleInfo[vehicleid][vNeon] = SQL_GetInt(0, "neon");
	        VehicleInfo[vehicleid][vNeonEnabled] = SQL_GetInt(0, "neonenabled");
	        VehicleInfo[vehicleid][vTrunk] = SQL_GetInt(0, "trunk");
	        VehicleInfo[vehicleid][vMods][0] = SQL_GetInt(0, "mod_1");
	        VehicleInfo[vehicleid][vMods][1] = SQL_GetInt(0, "mod_2");
	        VehicleInfo[vehicleid][vMods][2] = SQL_GetInt(0, "mod_3");
	        VehicleInfo[vehicleid][vMods][3] = SQL_GetInt(0, "mod_4");
	        VehicleInfo[vehicleid][vMods][4] = SQL_GetInt(0, "mod_5");
	        VehicleInfo[vehicleid][vMods][5] = SQL_GetInt(0, "mod_6");
	        VehicleInfo[vehicleid][vMods][6] = SQL_GetInt(0, "mod_7");
	        VehicleInfo[vehicleid][vMods][7] = SQL_GetInt(0, "mod_8");
	        VehicleInfo[vehicleid][vMods][8] = SQL_GetInt(0, "mod_9");
	        VehicleInfo[vehicleid][vMods][9] = SQL_GetInt(0, "mod_10");
	        VehicleInfo[vehicleid][vMods][10] = SQL_GetInt(0, "mod_11");
	        VehicleInfo[vehicleid][vMods][11] = SQL_GetInt(0, "mod_12");
	        VehicleInfo[vehicleid][vMods][12] = SQL_GetInt(0, "mod_13");
	        VehicleInfo[vehicleid][vMods][13] = SQL_GetInt(0, "mod_14");
	        VehicleInfo[vehicleid][vCash] = SQL_GetInt(0, "cash");
	        VehicleInfo[vehicleid][vMaterials] = SQL_GetInt(0, "materials");
	        VehicleInfo[vehicleid][vPot] = SQL_GetInt(0, "pot");
	        VehicleInfo[vehicleid][vCrack] = SQL_GetInt(0, "crack");
	        VehicleInfo[vehicleid][vMeth] = SQL_GetInt(0, "meth");
	        VehicleInfo[vehicleid][vPainkillers] = SQL_GetInt(0, "painkillers");
	        VehicleInfo[vehicleid][vWeapons][0] = SQL_GetInt(0, "weapon_1");
	        VehicleInfo[vehicleid][vWeapons][1] = SQL_GetInt(0, "weapon_2");
	        VehicleInfo[vehicleid][vWeapons][2] = SQL_GetInt(0, "weapon_3");
            VehicleInfo[vehicleid][vHPAmmo] = SQL_GetInt(0, "hpammo");
            VehicleInfo[vehicleid][vPoisonAmmo] = SQL_GetInt(0, "poisonammo");
            VehicleInfo[vehicleid][vFMJAmmo] = SQL_GetInt(0, "fmjammo");
			VehicleInfo[vehicleid][vRent] = SQL_GetInt(0, "rent");
            VehicleInfo[vehicleid][vRenttime] = SQL_GetInt(0, "renttime");
	        VehicleInfo[vehicleid][vGang] = -1;
	        VehicleInfo[vehicleid][vFactionType] = FACTION_NONE;
	        VehicleInfo[vehicleid][vJob] = JOB_NONE;
	        VehicleInfo[vehicleid][vRespawnDelay] = -1;
	        VehicleInfo[vehicleid][vModel] = modelid;
		    VehicleInfo[vehicleid][vPosX] = x;
		    VehicleInfo[vehicleid][vPosY] = y;
		    VehicleInfo[vehicleid][vPosZ] = z;
		    VehicleInfo[vehicleid][vPosA] = a;
			VehicleInfo[vehicleid][vVip] = 0;
		    VehicleInfo[vehicleid][vColor1] = color1;
		    VehicleInfo[vehicleid][vColor2] = color2;
		    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vTimer] = -1;
		    VehicleInfo[vehicleid][vRegistered] = SQL_GetInt(0, "registered");

			vehicleFuel[vehicleid] = SQL_GetInt(0, "fuel");
			Milliage[vehicleid] = SQL_GetFloat(0, "milliage");
			adminVehicle{vehicleid} = false;

			ReloadVehicle(vehicleid);

		    if(!parked)
			{
			    SM(playerid, COLOR_GREEN, "You have spawned your "SVRCLR"%s{CCFFFF} which is located in {F7A763}%s{CCFFFF}. /findcar to track it.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			}
	    }
	}

	return 1;
}

forward OnPlayerBuyClothingItem(playerid, name[], price, businessid, clothingid);
public OnPlayerBuyClothingItem(playerid, name[], price, businessid, clothingid)
{
    new string[16];

	strcpy(ClothingInfo[playerid][clothingid][cName], name, 32);

    ClothingInfo[playerid][clothingid][cID] = cache_insert_id();
    ClothingInfo[playerid][clothingid][cExists] = 1;
	ClothingInfo[playerid][clothingid][cAttached] = 0;
	ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;

	BusinessInfo[businessid][bCash] += price;
	BusinessInfo[businessid][bProducts]--;

 	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
 	mysql_tquery(connectionID, queryBuffer);

	GivePlayerCash(playerid, -price);
 	SM(playerid, COLOR_GREEN, "%s purchased for $%i. /clothing to find your new item.", name, price);

    format(string, sizeof(string), "~r~-$%i", price);
	GameTextForPlayer(playerid, string, 5000, 1);
}

HideShotTD1(playerid)
{
	PlayerTextDrawHide(playerid, ShotsTD[playerid][0]);
	PlayerTextDrawHide(playerid, ShotsTD[playerid][1]);
	PlayerTextDrawHide(playerid, ShotsTD[playerid][2]);
	PlayerTextDrawHide(playerid, ShotsTD[playerid][3]);
	return 1;
}

forward HideShotTD(playerid);
public HideShotTD(playerid)
{
	HideShotTD1(playerid);
    return 1;
}

forward OnPlayerSendTextMessage(playerid, number, msg[]);
public OnPlayerSendTextMessage(playerid, number, msg[])
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The number you're trying to reach does not belong to any particular person.");
	}
	else if(SQL_GetIntByIndex(0, 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently imprisoned and cannot use their phone.");
 	}
 	else if(SQL_GetIntByIndex(0, 2))
 	{
 	    SendClientMessage(playerid, COLOR_SYNTAX, "That player has their mobile phone switched off.");
	}
 	else
	{
	    new
	        username[MAX_PLAYER_NAME];

	    SQL_GetStringByIndex(0, 0, username);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO texts VALUES(null, %i, %i, '%s', NOW(), '%e')", PlayerInfo[playerid][pPhone], number, GetPlayerNameEx(playerid), msg);
	    mysql_tquery(connectionID, queryBuffer);

        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out a cellphone and sends a message.", GetRPName(playerid));
	    SM(playerid, COLOR_YELLOW, "** SMS to %s (%i): %s **", username, number, msg);
	    SendClientMessage(playerid, COLOR_WHITE, "** The player who owns the number is offline, but will receive your text when they log in.");

        GivePlayerCash(playerid, -1);
		Dyuze(playerid, "Notice", "Text sent! We deduct you $1.");
	}
}

forward OnPlayerRentHouse(playerid, houseid);
public OnPlayerRentHouse(playerid, houseid)
{
	if(SQL_GetIntByIndex(0, 0) >= GetHouseTenantCapacity(houseid))
	{
	    SM(playerid, COLOR_SYNTAX, "This house has reached its limit of %i tenants.", GetHouseTenantCapacity(houseid));
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rentinghouse = %i WHERE uid = %i", HouseInfo[houseid][hID], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		PlayerInfo[playerid][pRentingHouse] = HouseInfo[houseid][hID];
		SM(playerid, COLOR_YELLOW, "You are now renting at %s's house. You will pay $%i every paycheck.", HouseInfo[houseid][hOwner], HouseInfo[houseid][hRentPrice]);
	}
}

forward OnPlayerEvict(playerid, username[]);
public OnPlayerEvict(playerid, username[])
{
	if(!SQL_GetRows())
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player doesn't exist, or is not renting at your home.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        if(!strcmp(GetPlayerNameEx(i), username) && PlayerInfo[i][pLogged])
	        {
	            PlayerInfo[i][pRentingHouse] = 0;
	            SendClientMessage(i, COLOR_RED, "You have been evicted from your home by the owner.");
	        }
	    }

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rentinghouse = 0 WHERE username = '%e'", username);
	    mysql_tquery(connectionID, queryBuffer);

        SM(playerid, COLOR_WHITE, "** You have evicted %s from your property.", username);
	}

	return 1;
}

forward OnListPlayerFlags(playerid, targetid);
public OnListPlayerFlags(playerid, targetid)
{
	new rows = SQL_GetRows();

	if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "This player has no flags listed under their account.");
	}
	else
	{
	    new flaggedby[24], date[24], desc[128];

	    SM(playerid, SERVER_COLOR, "%s's Flags", GetRPName(targetid));

	    for(new i = 0; i < rows; i ++)
	    {
	        SQL_GetString(i, "flaggedby", flaggedby);
	        SQL_GetString(i, "date", date);
	        SQL_GetString(i, "description", desc);

	        SM(playerid, COLOR_GREY2, "[%i][%s] %s (from: %s)", i + 1, date, desc, flaggedby);
	    }
	}
}

forward OnUpdatePartner(playerid);
public OnUpdatePartner(playerid)
{
    if(SQL_GetRows())
	{
	    SQL_GetString(0, "username", PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME);
	}
}

forward OnAdminChangePassword(playerid, username[], password[]);
public OnAdminChangePassword(playerid, username[], password[])
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
	}
	else
	{
	    new
	        hashed[129];

	    WP_Hash(hashed, sizeof(hashed), password);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET password = '%s' WHERE username = '%e'", hashed, username);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has changed %s's account password.", GetRPName(playerid), username);
	}
}

forward OnVerifyRemoveFlag(playerid, targetid, slot);
public OnVerifyRemoveFlag(playerid, targetid, slot)
{
	if(SQL_GetRows())
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM flags WHERE id = %i", SQL_GetIntByIndex(0, 0));
	    mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_YELLOW, "** %s's flag in slot %i was removed.", GetRPName(targetid), slot);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player has no outstanding flag in that slot.");
	}
}

forward OnAdminListVehiclesForRemoval(playerid, targetid);
public OnAdminListVehiclesForRemoval(playerid, targetid)
{
    new rows = SQL_GetRows();

    if(!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player owns no vehicles.");
	}
	else
	{
		static string[1024];

		string = "#\tModel\tLocation";

		for(new i = 0; i < rows; i ++)
    	{
			new
				vehicleid = GetVehicleLinkedID(SQL_GetInt(i, "id"));

			if(vehicleid == INVALID_VEHICLE_ID)
			{
				format(string, sizeof(string), "%s\nn/a\t%s\t%s", string, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "interior")) ? ("Garage") : GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z")));
			}
			else
			{
				format(string, sizeof(string), "%s\nID %i\t%s\t%s", string, vehicleid, GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			}
		}

		PlayerInfo[playerid][pRemoveFrom] = targetid;
		ShowPlayerDialog(playerid, DIALOG_REMOVEPVEH, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to remove.", string, "Select", "Cancel");
	}
}

forward OnVerifyRemoveVehicle(playerid, targetid);
public OnVerifyRemoveVehicle(playerid, targetid)
{
	if(SQL_GetRows())
	{
	    new vehicleid = GetVehicleLinkedID(SQL_GetInt(0, "id")), modelid = SQL_GetInt(0, "modelid");

	 
	    if(vehicleid != INVALID_VEHICLE_ID)
	    {
	        DespawnVehicle(vehicleid, false);
		}
        else
        {
	      SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's %s.", GetRPName(playerid), GetRPName(targetid), vehicleNames[modelid - 400]);
	      SM(targetid, COLOR_GREEN, "%s has removed your {FF6347}%s{33CCFF} from your vehicle list.", GetRPName(playerid), vehicleNames[modelid - 400]);
		}
	}
}

forward OnAdminOfflineCheck(playerid, username[]);
public OnAdminOfflineCheck(playerid, username[])
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else
	{
	    // At first I didn't know how I was going to do this. But then I came up with a plan.
	    // Load everything into an unused player slot, use DisplayStats as normal, then destroy the data.
	    // This ensures that whenever I add a new thing to /stats for instance, I don't have to maintain
	    // two stats functions, I can just call DisplayStats and let the work do itself.

	    PlayerInfo[MAX_PLAYERS][pID] = SQL_GetInt(0, "uid");
		PlayerInfo[MAX_PLAYERS][pSetup] = SQL_GetInt(0, "setup");
		PlayerInfo[MAX_PLAYERS][pDonateWeapon] = SQL_GetInt(0, "donateweapon");
        PlayerInfo[MAX_PLAYERS][pGender] = SQL_GetInt(0, "gender");
        PlayerInfo[MAX_PLAYERS][pAge] = SQL_GetInt(0, "age");
        PlayerInfo[MAX_PLAYERS][pSkin] = SQL_GetInt(0, "skin");
        PlayerInfo[MAX_PLAYERS][pCameraX] = SQL_GetFloat(0, "camera_x");
        PlayerInfo[MAX_PLAYERS][pCameraY] = SQL_GetFloat(0, "camera_y");
        PlayerInfo[MAX_PLAYERS][pCameraZ] = SQL_GetFloat(0, "camera_z");
        PlayerInfo[MAX_PLAYERS][pPosX] = SQL_GetFloat(0, "pos_x");
        PlayerInfo[MAX_PLAYERS][pPosY] = SQL_GetFloat(0, "pos_y");
        PlayerInfo[MAX_PLAYERS][pPosZ] = SQL_GetFloat(0, "pos_z");
        PlayerInfo[MAX_PLAYERS][pPosA] = SQL_GetFloat(0, "pos_a");
        PlayerInfo[MAX_PLAYERS][pInterior] = SQL_GetInt(0, "interior");
        PlayerInfo[MAX_PLAYERS][pWorld] = SQL_GetInt(0, "world");
        PlayerInfo[MAX_PLAYERS][pCash] = SQL_GetInt(0, "cash");
        PlayerInfo[MAX_PLAYERS][pBank] = SQL_GetInt(0, "bank");
        PlayerInfo[MAX_PLAYERS][pPaycheck] = SQL_GetInt(0, "paycheck");
        PlayerInfo[MAX_PLAYERS][pLevel] = SQL_GetInt(0, "level");
        PlayerInfo[MAX_PLAYERS][pEXP] = SQL_GetInt(0, "exp");
        PlayerInfo[MAX_PLAYERS][pMinutes] = SQL_GetInt(0, "minutes");
        PlayerInfo[MAX_PLAYERS][pHours] = SQL_GetInt(0, "hours");
        PlayerInfo[MAX_PLAYERS][pAdmin] = SQL_GetInt(0, "adminlevel");
        PlayerInfo[MAX_PLAYERS][pHelper] = SQL_GetInt(0, "helperlevel");
        PlayerInfo[MAX_PLAYERS][pHealth] = SQL_GetFloat(0, "health");
        PlayerInfo[MAX_PLAYERS][pArmor] = SQL_GetFloat(0, "armor");
        PlayerInfo[MAX_PLAYERS][pUpgradePoints] = SQL_GetInt(0, "upgradepoints");
		PlayerInfo[MAX_PLAYERS][pWarnings] = SQL_GetInt(0, "warnings");
		PlayerInfo[MAX_PLAYERS][pComserv] = SQL_GetInt(0, "comserv");
		PlayerInfo[MAX_PLAYERS][pInjured] = SQL_GetInt(0, "injured");
		PlayerInfo[MAX_PLAYERS][pHospital] = SQL_GetInt(0, "hospital");
		PlayerInfo[MAX_PLAYERS][pSpawnHealth] = SQL_GetFloat(0, "spawnhealth");
        PlayerInfo[MAX_PLAYERS][pSpawnArmor] = SQL_GetFloat(0, "spawnarmor");
        PlayerInfo[MAX_PLAYERS][pJailType] = SQL_GetInt(0, "jailtype");
        PlayerInfo[MAX_PLAYERS][pJailTime] = SQL_GetInt(0, "jailtime");
        PlayerInfo[MAX_PLAYERS][pNewbieMuted] = SQL_GetInt(0, "newbiemuted");
        PlayerInfo[MAX_PLAYERS][pHelpMuted] = SQL_GetInt(0, "helpmuted");
        PlayerInfo[MAX_PLAYERS][pAdMuted] = SQL_GetInt(0, "admuted");
        PlayerInfo[MAX_PLAYERS][pLiveMuted] = SQL_GetInt(0, "livemuted");
        PlayerInfo[MAX_PLAYERS][pGlobalMuted] = SQL_GetInt(0, "globalmuted");
        PlayerInfo[MAX_PLAYERS][pReportMuted] = SQL_GetInt(0, "reportmuted");
        PlayerInfo[MAX_PLAYERS][pReportWarns] = SQL_GetInt(0, "reportwarns");
        PlayerInfo[MAX_PLAYERS][pFightStyle] = SQL_GetInt(0, "fightstyle");
        PlayerInfo[MAX_PLAYERS][pDirtyCash] = SQL_GetInt(0, "dirtycash");

		#if defined Christmas
			PlayerInfo[MAX_PLAYERS][pCandy] = SQL_GetInt(0, "candy");
		#endif

        PlayerInfo[MAX_PLAYERS][pFood] = SQL_GetInt(0, "food");
		PlayerInfo[MAX_PLAYERS][pDrink] = SQL_GetInt(0, "drink");
        
        PlayerInfo[MAX_PLAYERS][pRepairKit] = SQL_GetInt(0, "repairkit");
        PlayerInfo[MAX_PLAYERS][pToolkit] = SQL_GetInt(0, "toolkit");
		PlayerInfo[MAX_PLAYERS][pPhone] = SQL_GetInt(0, "phone");
		PlayerInfo[MAX_PLAYERS][pJob] = SQL_GetInt(0, "job");
		PlayerInfo[MAX_PLAYERS][pSecondJob] = SQL_GetInt(0, "secondjob");
		PlayerInfo[MAX_PLAYERS][pCrimes] = SQL_GetInt(0, "crimes");
		PlayerInfo[MAX_PLAYERS][pArrested] = SQL_GetInt(0, "arrested");
		PlayerInfo[MAX_PLAYERS][pWantedLevel] = SQL_GetInt(0, "wantedlevel");
		PlayerInfo[MAX_PLAYERS][pMaterials] = SQL_GetInt(0, "materials");
		PlayerInfo[MAX_PLAYERS][pPot] = SQL_GetInt(0, "pot");
		PlayerInfo[MAX_PLAYERS][pCrack] = SQL_GetInt(0, "crack");
		PlayerInfo[MAX_PLAYERS][pMeth] = SQL_GetInt(0, "meth");
		PlayerInfo[MAX_PLAYERS][pPainkillers] = SQL_GetInt(0, "painkillers");
		PlayerInfo[MAX_PLAYERS][pBandage] = SQL_GetInt(0, "bandage");
		PlayerInfo[MAX_PLAYERS][pVest] = SQL_GetInt(0, "vest");
		PlayerInfo[MAX_PLAYERS][pSeeds] = SQL_GetInt(0, "seeds");
		PlayerInfo[MAX_PLAYERS][pEphedrine] = SQL_GetInt(0, "ephedrine");
		PlayerInfo[MAX_PLAYERS][pMuriaticAcid] = SQL_GetInt(0, "muriaticacid");
		PlayerInfo[MAX_PLAYERS][pBakingSoda] = SQL_GetInt(0, "bakingsoda");
		PlayerInfo[MAX_PLAYERS][pCigars] = SQL_GetInt(0, "cigars");
		PlayerInfo[MAX_PLAYERS][pWalkieTalkie] = SQL_GetInt(0, "walkietalkie");
		PlayerInfo[MAX_PLAYERS][pChannel] = SQL_GetInt(0, "channel");
		PlayerInfo[MAX_PLAYERS][pGiveAmount] = SQL_GetInt(0, "Amount");
		PlayerInfo[MAX_PLAYERS][pSelectItem] = SQL_GetInt(0, "Select");
		PlayerInfo[MAX_PLAYERS][pRentingHouse] = SQL_GetInt(0, "rentinghouse");
		PlayerInfo[MAX_PLAYERS][pSpraycans] = SQL_GetInt(0, "spraycans");
		PlayerInfo[MAX_PLAYERS][pBoombox] = SQL_GetInt(0, "boombox");
		PlayerInfo[MAX_PLAYERS][pMP3Player] = SQL_GetInt(0, "mp3player");
		PlayerInfo[MAX_PLAYERS][pPhonebook] = SQL_GetInt(0, "phonebook");
		PlayerInfo[MAX_PLAYERS][pFishingRod] = SQL_GetInt(0, "fishingrod");
		PlayerInfo[MAX_PLAYERS][pFishingBait] = SQL_GetInt(0, "fishingbait");
		PlayerInfo[MAX_PLAYERS][pFishWeight] = SQL_GetInt(0, "fishweight");
		PlayerInfo[MAX_PLAYERS][pFishingSkill] = SQL_GetInt(0, "fishingskill");
		PlayerInfo[MAX_PLAYERS][pCourierSkill] = SQL_GetInt(0, "courierskill");
		PlayerInfo[MAX_PLAYERS][pGuardSkill] = SQL_GetInt(0, "guardskill");
		PlayerInfo[MAX_PLAYERS][pWeaponSkill] = SQL_GetInt(0, "weaponskill");
		PlayerInfo[MAX_PLAYERS][pLawyerSkill] = SQL_GetInt(0, "lawyerskill");
		PlayerInfo[MAX_PLAYERS][pSmugglerSkill] = SQL_GetInt(0, "smugglerskill");
		PlayerInfo[MAX_PLAYERS][pToggleTextdraws] = SQL_GetInt(0, "toggletextdraws");
		PlayerInfo[MAX_PLAYERS][pToggleOOC] = SQL_GetInt(0, "toggleooc");
		PlayerInfo[MAX_PLAYERS][pTogglePhone] = SQL_GetInt(0, "togglephone");
		PlayerInfo[MAX_PLAYERS][pToggleAdmin] = SQL_GetInt(0, "toggleadmin");
		PlayerInfo[MAX_PLAYERS][pToggleHelper] = SQL_GetInt(0, "togglehelper");
		PlayerInfo[MAX_PLAYERS][pToggleNewbie] = SQL_GetInt(0, "togglenewbie");
		PlayerInfo[MAX_PLAYERS][pToggleWT] = SQL_GetInt(0, "togglewt");
		PlayerInfo[MAX_PLAYERS][pToggleRadio] = SQL_GetInt(0, "toggleradio");
		PlayerInfo[MAX_PLAYERS][pToggleVIP] = SQL_GetInt(0, "togglevip");
		PlayerInfo[MAX_PLAYERS][pToggleMusic] = SQL_GetInt(0, "togglemusic");
		PlayerInfo[MAX_PLAYERS][pToggleFaction] = SQL_GetInt(0, "togglefaction");
		PlayerInfo[MAX_PLAYERS][pToggleNews] = SQL_GetInt(0, "togglenews");
		PlayerInfo[MAX_PLAYERS][pToggleGlobal] = SQL_GetInt(0, "toggleglobal");
		PlayerInfo[MAX_PLAYERS][pToggleCam] = SQL_GetInt(0, "togglecam");
		PlayerInfo[MAX_PLAYERS][pCarLicense] = SQL_GetInt(0, "carlicense");
		PlayerInfo[MAX_PLAYERS][pWeaponLicense] = SQL_GetInt(0, "gunlicense");
		PlayerInfo[MAX_PLAYERS][pBuygun] = SQL_GetInt(0, "buygun");
		PlayerInfo[MAX_PLAYERS][pBGTime] = SQL_GetInt(0, "bgtime");
		PlayerInfo[MAX_PLAYERS][pVIPPackage] = SQL_GetInt(0, "vippackage");
		PlayerInfo[MAX_PLAYERS][pVIPTime] = SQL_GetInt(0, "viptime");
		PlayerInfo[MAX_PLAYERS][pVIPCooldown] = SQL_GetInt(0, "vipcooldown");
		PlayerInfo[MAX_PLAYERS][pWeapons][0] = SQL_GetInt(0, "weapon_0");
		PlayerInfo[MAX_PLAYERS][pWeapons][1] = SQL_GetInt(0, "weapon_1");
		PlayerInfo[MAX_PLAYERS][pWeapons][2] = SQL_GetInt(0, "weapon_2");
		PlayerInfo[MAX_PLAYERS][pWeapons][3] = SQL_GetInt(0, "weapon_3");
		PlayerInfo[MAX_PLAYERS][pWeapons][4] = SQL_GetInt(0, "weapon_4");
		PlayerInfo[MAX_PLAYERS][pWeapons][5] = SQL_GetInt(0, "weapon_5");
		PlayerInfo[MAX_PLAYERS][pWeapons][6] = SQL_GetInt(0, "weapon_6");
		PlayerInfo[MAX_PLAYERS][pWeapons][7] = SQL_GetInt(0, "weapon_7");
		PlayerInfo[MAX_PLAYERS][pWeapons][8] = SQL_GetInt(0, "weapon_8");
		PlayerInfo[MAX_PLAYERS][pWeapons][9] = SQL_GetInt(0, "weapon_9");
		PlayerInfo[MAX_PLAYERS][pWeapons][10] = SQL_GetInt(0, "weapon_10");
		PlayerInfo[MAX_PLAYERS][pWeapons][11] = SQL_GetInt(0, "weapon_11");
		PlayerInfo[MAX_PLAYERS][pWeapons][12] = SQL_GetInt(0, "weapon_12");
		PlayerInfo[MAX_PLAYERS][pFaction] = SQL_GetInt(0, "faction");
		PlayerInfo[MAX_PLAYERS][pFactionRank] = SQL_GetInt(0, "factionrank");
		PlayerInfo[MAX_PLAYERS][pGang] = SQL_GetInt(0, "gang");
		PlayerInfo[MAX_PLAYERS][pGangRank] = SQL_GetInt(0, "gangrank");
		PlayerInfo[MAX_PLAYERS][pDivision] = SQL_GetInt(0, "division");
		PlayerInfo[MAX_PLAYERS][pContracted] = SQL_GetInt(0, "contracted");
		PlayerInfo[MAX_PLAYERS][pBombs] = SQL_GetInt(0, "bombs");
		PlayerInfo[MAX_PLAYERS][pCompletedHits] = SQL_GetInt(0, "completedhits");
		PlayerInfo[MAX_PLAYERS][pFailedHits] = SQL_GetInt(0, "failedhits");
		PlayerInfo[MAX_PLAYERS][pReports] = SQL_GetInt(0, "reports");
		PlayerInfo[MAX_PLAYERS][pNewbies] = SQL_GetInt(0, "newbies");
		PlayerInfo[MAX_PLAYERS][pHelpRequests] = SQL_GetInt(0, "helprequests");
		PlayerInfo[MAX_PLAYERS][pSpeedometer] = SQL_GetInt(0, "speedometer");
		PlayerInfo[MAX_PLAYERS][pFactionMod] = SQL_GetInt(0, "factionmod");
		PlayerInfo[MAX_PLAYERS][pGangMod] = SQL_GetInt(0, "gangmod");
		PlayerInfo[MAX_PLAYERS][pBanAppealer] = SQL_GetInt(0, "banappealer");
		PlayerInfo[MAX_PLAYERS][pFactionBan] = SQL_GetInt(0, "factionban");
		PlayerInfo[MAX_PLAYERS][pGangBan] = SQL_GetInt(0, "gangban");
		PlayerInfo[MAX_PLAYERS][pPotPlanted] = SQL_GetInt(0, "potplanted");
		PlayerInfo[MAX_PLAYERS][pPotTime] = SQL_GetInt(0, "pottime");
		PlayerInfo[MAX_PLAYERS][pPotGrams] = SQL_GetInt(0, "potgrams");
		PlayerInfo[MAX_PLAYERS][pPotX] = SQL_GetFloat(0, "pot_x");
		PlayerInfo[MAX_PLAYERS][pPotY] = SQL_GetFloat(0, "pot_y");
		PlayerInfo[MAX_PLAYERS][pPotZ] = SQL_GetFloat(0, "pot_z");
		PlayerInfo[MAX_PLAYERS][pPotA] = SQL_GetFloat(0, "pot_a");
		PlayerInfo[MAX_PLAYERS][pInventoryUpgrade] = SQL_GetInt(0, "inventoryupgrade");
		PlayerInfo[MAX_PLAYERS][pAddictUpgrade] = SQL_GetInt(0, "addictupgrade");
        PlayerInfo[MAX_PLAYERS][pTraderUpgrade] = SQL_GetInt(0, "traderupgrade");
        PlayerInfo[MAX_PLAYERS][pAssetUpgrade] = SQL_GetInt(0, "assetupgrade");
        PlayerInfo[MAX_PLAYERS][pLaborUpgrade] = SQL_GetInt(0, "laborupgrade");
		PlayerInfo[MAX_PLAYERS][pHPAmmo] = SQL_GetInt(0, "hpammo");
		PlayerInfo[MAX_PLAYERS][pPoisonAmmo] = SQL_GetInt(0, "poisonammo");
		PlayerInfo[MAX_PLAYERS][pFMJAmmo] = SQL_GetInt(0, "fmjammo");
		PlayerInfo[MAX_PLAYERS][pAmmoType] = SQL_GetInt(0, "ammotype");
		PlayerInfo[MAX_PLAYERS][pAmmoWeapon] = SQL_GetInt(0, "ammoweapon");
		PlayerInfo[MAX_PLAYERS][pDMWarnings] = SQL_GetInt(0, "dmwarnings");
		PlayerInfo[MAX_PLAYERS][pWeaponRestricted] = SQL_GetInt(0, "weaponrestricted");
		PlayerInfo[MAX_PLAYERS][pReferralUID] = SQL_GetInt(0, "referral_uid");
		PlayerInfo[MAX_PLAYERS][pWatch] = SQL_GetInt(0, "watch");
		PlayerInfo[MAX_PLAYERS][pGPS] = SQL_GetInt(0, "gps");
		PlayerInfo[MAX_PLAYERS][pRefunded] = SQL_GetInt(0, "refunded");
		PlayerInfo[MAX_PLAYERS][pMask] = SQL_GetInt(0, "mask");
		PlayerInfo[MAX_PLAYERS][pBlindfold] = SQL_GetInt(0, "blindfold");
		PlayerInfo[MAX_PLAYERS][pHunger] = SQL_GetInt(0, "hunger");
		PlayerInfo[MAX_PLAYERS][pHungerTimer] = SQL_GetInt(0, "hungertimer");
		PlayerInfo[MAX_PLAYERS][pThirst] = SQL_GetInt(0, "thirst");
		PlayerInfo[MAX_PLAYERS][pThirstTimer] = SQL_GetInt(0, "thirsttimer");
		PlayerInfo[MAX_PLAYERS][pLottery] = SQL_GetInt(0, "lottery");
		PlayerInfo[MAX_PLAYERS][pLotteryB] = SQL_GetInt(0, "LotteryB");


		strcpy(PlayerInfo[MAX_PLAYERS][pUsername], username, MAX_PLAYER_NAME);
		DisplayStats(MAX_PLAYERS, playerid);
	}
}

forward OnAdminOfflineFlag(playerid, username[], desc[]);
public OnAdminOfflineFlag(playerid, username[], desc[])
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, '%s', NOW(), '%e')", SQL_GetInt(0, "uid"), GetPlayerNameEx(playerid), desc);
		mysql_tquery(connectionID, queryBuffer);
		new dc_str[454];
		format(dc_str, sizeof(dc_str), "%s offline prisoned %s for  minutes, reason: %s", GetPlayerNameEx(playerid), username, desc);
		SendDiscordMessage(6, dc_str);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s offline flagged %s's account for '%s'.", GetRPName(playerid), username, desc);
	}
}

forward OnAdminCheckBanHistory(playerid, username[]);
public OnAdminCheckBanHistory(playerid, username[])
{
	new rows = SQL_GetRows();

	if(!rows)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "This player has no ban history recorded.");
	}
	else
	{
	    new date[24], description[255];

	    for(new i = 0; i < rows; i ++)
	    {
	        SQL_GetStringByIndex(i, 0, date);
	        SQL_GetStringByIndex(i, 1, description);

	        SM(playerid, COLOR_LIGHTRED, "[%s] %s", date, description);
	    }
	}
}

forward OnAdminCheckLastActive(playerid, username[]);
public OnAdminCheckLastActive(playerid, username[])
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else
	{
	    new
	        date[40];

     	SQL_GetStringByIndex(0, 0, date);
		SM(playerid, COLOR_YELLOW, "%s last logged in on the %s (server time).", username, date);
	}
}

forward OnAdminSetHelperLevel(playerid, username[], level);
public OnAdminSetHelperLevel(playerid, username[], level)
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else if((PlayerInfo[playerid][pAdmin] < 6) && SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pHelper] && level < SQL_GetIntByIndex(0, 0))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher helper level than you. They cannot be demoted.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helperlevel = %i WHERE username = '%e'", level, username);
	    mysql_tquery(connectionID, queryBuffer);

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s has offline set %s's helper level to %i.", GetRPName(playerid), username, level);
	    ////Log_Write("log_admin", "%s (uid: %i) has offline set %s's helper level to %i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, level);
	}
}
SendClientMessageFormatted(playerid, color, const text[], {Float,_}:...)
{
    static
          args,
        str[192];

    if((args = numargs()) <= 3)
    {
        SendClientMessage(playerid, color, text);
    }
    else
    {
        while(--args >= 3)
        {
            #emit LCTRL     5
            #emit LOAD.alt     args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S     text
        #emit PUSH.C     192
        #emit PUSH.C     str
        #emit PUSH.S    8
        #emit SYSREQ.C     format
        #emit LCTRL     5
        #emit SCTRL     4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}
forward OnAdminSetAdminLevel(playerid, username[], level);
public OnAdminSetAdminLevel(playerid, username[], level)
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else if(SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pAdmin] && level < SQL_GetIntByIndex(0, 0))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be demoted.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminlevel = %i WHERE username = '%e'", level, username);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has offline set %s's admin level to %i.", GetRPName(playerid), username, level);
	    ////Log_Write("log_admin", "%s (uid: %i) has offline set %s's admin level to %i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, level);
	}
}

forward OnAdminCreateLocker(playerid, lockerid, factionid, Float:x, Float:y, Float:z, interior, world);
public OnAdminCreateLocker(playerid, lockerid, factionid, Float:x, Float:y, Float:z, interior, world)
{
	LockerInfo[lockerid][lID] = cache_insert_id();
	LockerInfo[lockerid][lExists] = 1;
	LockerInfo[lockerid][lFaction] = factionid;
    LockerInfo[lockerid][lPosX] = x;
    LockerInfo[lockerid][lPosY] = y;
    LockerInfo[lockerid][lPosZ] = z;
    LockerInfo[lockerid][lInterior] = interior;
    LockerInfo[lockerid][lWorld] = world;
	LockerInfo[lockerid][lIcon] = 1239;
	LockerInfo[lockerid][lLabel] = 1;

    // CHANGE SQL TOO PLS
    LockerInfo[lockerid][locKevlar] = { 1, 100 };
    LockerInfo[lockerid][locMedKit] = { 1, 50 };
    LockerInfo[lockerid][locNitestick] = { 0, 0 };
    LockerInfo[lockerid][locMace] = { 0, 0 };
    LockerInfo[lockerid][locDeagle] = { 1, 850 };
    LockerInfo[lockerid][locShotgun] = { 1, 1000 };
    LockerInfo[lockerid][locMP5] = { 1, 1500 };
    LockerInfo[lockerid][locM4] = { 1, 2500 };
    LockerInfo[lockerid][locSniper] = { 1, 5000 };
    LockerInfo[lockerid][locCamera] = { 0, 0 };
    LockerInfo[lockerid][locFireExt] = { 0, 0 };
    LockerInfo[lockerid][locPainKillers] = { 0, 0 };

    LockerInfo[lockerid][lText] = Text3D:INVALID_3DTEXT_ID;
    LockerInfo[lockerid][lPickup] = -1;

    ReloadLocker(lockerid);
    SCMf(playerid, COLOR_GREEN, "* Locker %i created for %s.", lockerid, FactionInfo[factionid][fName]);
}
forward OnAdminCreateGG(playerid, atm, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreateGG(playerid, atm, Float:x, Float:y, Float:z, Float:a)
{
    GGInfo[atm][aID] = cache_insert_id();
	GGInfo[atm][aExists] = true;
    GGInfo[atm][aPosX] = x;
    GGInfo[atm][aPosY] = y;
    GGInfo[atm][aPosZ] = z;
    GGInfo[atm][aPosA] = a;

	ReloadGG(atm);
	SM(playerid, COLOR_TEAL, "** Gang Garage "WHITE"[%i]"TEAL" created at %.1f, %.1f, %.1f.", atm, x, y, z);
}
forward OnAdminCreatePG(playerid, atm, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreatePG(playerid, atm, Float:x, Float:y, Float:z, Float:a)
{
    PGInfo[atm][aID] = cache_insert_id();
	PGInfo[atm][aExists] = true;
    PGInfo[atm][aPosX] = x;
    PGInfo[atm][aPosY] = y;
    PGInfo[atm][aPosZ] = z;
    PGInfo[atm][aPosA] = a;

	ReloadPG(atm);
	SCMf(playerid, COLOR_TEAL, "** Public Garage "WHITE"[%i]"TEAL" created at %.1f, %.1f, %.1f.", atm, x, y, z);
}

forward OnAdminCreateAtm(playerid, atm, Float:x, Float:y, Float:z, Float:a); //main
public OnAdminCreateAtm(playerid, atm, Float:x, Float:y, Float:z, Float:a)
{
    AtmInfo[atm][aID] = cache_insert_id();
	AtmInfo[atm][aExists] = true;
    AtmInfo[atm][aPosX] = x;
    AtmInfo[atm][aPosY] = y;
    AtmInfo[atm][aPosZ] = z;
    AtmInfo[atm][aPosA] = a;
    AtmInfo[atm][amoney] = 1000000000;

	ReloadAtm(atm);
	SCMf(playerid, COLOR_GREEN, "** ATM [%i] created at %.1f, %.1f, %.1f with money : 10000000", atm, x, y, z);
}

forward OnAdminCreateTurf(playerid, turfid, name[], type, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height);
public OnAdminCreateTurf(playerid, turfid, name[], type, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height)
{
	strcpy(TurfInfo[turfid][tName], name, 32);
	strcpy(TurfInfo[turfid][tCapturedBy], "Pending", MAX_PLAYER_NAME);

	TurfInfo[turfid][tExists] = 1;
	TurfInfo[turfid][tCapturedGang] = -1;
	TurfInfo[turfid][tTime] = 6;
	TurfInfo[turfid][tType] = type;
	TurfInfo[turfid][tMinX] = minx;
	TurfInfo[turfid][tMinY] = miny;
	TurfInfo[turfid][tMaxX] = maxx;
	TurfInfo[turfid][tMaxY] = maxy;
	TurfInfo[turfid][tHeight] = height;
	TurfInfo[turfid][tGangZone] = -1;
	TurfInfo[turfid][tArea] = -1;
	TurfInfo[turfid][tCaptureTime] = 0;
	TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
	TurfInfo[turfid][tInfluenceTime]  = 0;
	TurfInfo[turfid][tInfluenceGang]  = -1;
	TurfInfo[turfid][tInfluence]  = 0;

	ReloadTurf(turfid);
	SM(playerid, COLOR_YELLOW, "** Turf %i created successfully.", turfid);
}
stock CalculateGangZoneCenter(Float:minX, Float:minY, Float:maxX, Float:maxY, &Float:centerX, &Float:centerY)
{
    centerX = (minX + maxX) / 2;
    centerY = (minY + maxY) / 2;
}
forward OnAdminCreatePoint(playerid, pointid, name[], type, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height);
public OnAdminCreatePoint(playerid, pointid, name[], type, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height)
{
	new Float:X, Float:Y;
	
	CalculateGangZoneCenter(minx, miny , maxx, maxy, X, Y);

	strcpy(PointInfo[pointid][pName], name, 32);
	strcpy(PointInfo[pointid][pCapturedBy], "Pending", MAX_PLAYER_NAME);

	PointInfo[pointid][pExists] = 1;
	PointInfo[pointid][pType] = type;
	PointInfo[pointid][pProfits] = 0;
	PointInfo[pointid][pMinX] = minx;
	PointInfo[pointid][pMinY] = miny;
    PointInfo[pointid][pPointX] = X,
	PointInfo[pointid][pPointY] = Y,
	PointInfo[pointid][pPointZ] = height;
	PointInfo[pointid][pMaxX] = maxx;
	PointInfo[pointid][pMaxY] = maxy;
	PointInfo[pointid][pHeight] = height;
	PointInfo[pointid][pCapturedGang] = -1;
	PointInfo[pointid][pTime] = 10;
	PointInfo[pointid][pPointInterior] = GetPlayerInterior(playerid);
	PointInfo[pointid][pPointWorld] = GetPlayerVirtualWorld(playerid);
	PointInfo[pointid][pCaptureTime] = 0;
	PointInfo[pointid][pArea] = -1;
	PointInfo[pointid][pCapturer] = INVALID_PLAYER_ID;
	PointInfo[pointid][pText] = Text3D:INVALID_3DTEXT_ID;
	PointInfo[pointid][pPickup] = -1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET name = '%e', type = %i, point_x = '%f', point_y = '%f', point_z = '%f', pointinterior = %i, pointworld = %i WHERE id = %i", name, type, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], PointInfo[pointid][pPointInterior], PointInfo[pointid][pPointWorld], pointid);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has created point {F7A763}%s{FF6347}.", GetRPName(playerid), name);
	SM(playerid, COLOR_AQUA, "You have created point {F7A763}%s{CCFFFF}. /editpoint %i to edit this point.", name, pointid);
	ReloadPoint(pointid);
	SM(playerid, COLOR_YELLOW, "** Point %i created successfully.", pointid);
}

forward OnAdminCreateLand(playerid, landid, price, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height, Float:x, Float:y, Float:z);
public OnAdminCreateLand(playerid, landid, price, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height, Float:x, Float:y, Float:z)
{
	strcpy(LandInfo[landid][lOwner], "Nobody", MAX_PLAYER_NAME);

	LandInfo[landid][lExists] = 1;
	LandInfo[landid][lID] = cache_insert_id();
	LandInfo[landid][lOwnerID] = 0;
	LandInfo[landid][lLevel] = 1;
	LandInfo[landid][lPrice] = price;
	LandInfo[landid][lMinX] = minx;
	LandInfo[landid][lMinY] = miny;
	LandInfo[landid][lMaxX] = maxx;
	LandInfo[landid][lMaxY] = maxy;
	LandInfo[landid][lX] = x;
	LandInfo[landid][lY] = y;
	LandInfo[landid][lZ] = z;
	LandInfo[landid][lHeight] = height;
	LandInfo[landid][lGangZone] = -1;
    LandInfo[landid][lArea] = -1;
    LandInfo[landid][lText] = Text3D:INVALID_3DTEXT_ID;
	LandInfo[landid][lPickup] = -1;
	Iter_Add(Land, landid);

    ReloadLand(landid);
    SM(playerid, SERVER_COLOR, "** Land %i created successfully.", landid);
}

forward OnAdminCreateEntrance(playerid, entranceid, name[], Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateEntrance(playerid, entranceid, name[], Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(EntranceInfo[entranceid][eOwner], "Nobody", MAX_PLAYER_NAME);
	strcpy(EntranceInfo[entranceid][eName], name, 40);
	strcpy(EntranceInfo[entranceid][ePassword], "None", 64);

	EntranceInfo[entranceid][eExists] = 1;
	EntranceInfo[entranceid][eID] = cache_insert_id();
	EntranceInfo[entranceid][eOwnerID] = 0;
	EntranceInfo[entranceid][eIcon] = 1239;
	EntranceInfo[entranceid][eLocked] = 0;
	EntranceInfo[entranceid][eRadius] = 3.0;
	EntranceInfo[entranceid][ePosX] = x;
	EntranceInfo[entranceid][ePosY] = y;
	EntranceInfo[entranceid][ePosZ] = z;
	EntranceInfo[entranceid][ePosA] = angle;
	EntranceInfo[entranceid][eIntX] = 0.0;
	EntranceInfo[entranceid][eIntY] = 0.0;
	EntranceInfo[entranceid][eIntZ] = 0.0;
	EntranceInfo[entranceid][eIntA] = 0.0;
	EntranceInfo[entranceid][eInterior] = 0;
	EntranceInfo[entranceid][eWorld] = EntranceInfo[entranceid][eID] + 4000000;
	EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
	EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);
	EntranceInfo[entranceid][eAdminLevel] = 0;
	EntranceInfo[entranceid][eFactionType] = FACTION_NONE;
	EntranceInfo[entranceid][eVIP] = 0;
	EntranceInfo[entranceid][eVehicles] = 0;
	EntranceInfo[entranceid][eFreeze] = 0;
	EntranceInfo[entranceid][eLabel] = 1;
	EntranceInfo[entranceid][eText] = Text3D:INVALID_3DTEXT_ID;
	EntranceInfo[entranceid][ePickup] = -1;
	EntranceInfo[entranceid][eMapIcon] = 0;
	EntranceInfo[entranceid][eMapIconID] = -1;
	EntranceInfo[entranceid][eColor] = -256;
	Iter_Add(Entrance, entranceid);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET world = %i WHERE id = %i", EntranceInfo[entranceid][eWorld], EntranceInfo[entranceid][eID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadEntrance(entranceid);
	SM(playerid, SERVER_COLOR, "** Entrance %i created successfully.", entranceid);
}

forward OnAdminCreateBusiness(playerid, businessid, type, Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateBusiness(playerid, businessid, type, Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);
    format(BusinessInfo[businessid][bName], 64, "Unamed Business");

	BusinessInfo[businessid][bExists] = 1;
	BusinessInfo[businessid][bID] = cache_insert_id();
	BusinessInfo[businessid][bOwnerID] = 0;
	BusinessInfo[businessid][bType] = type;
	BusinessInfo[businessid][bPrice] = bizInteriors[type][intPrice];
	BusinessInfo[businessid][bEntryFee] = 0;
	BusinessInfo[businessid][bLocked] = 1;
	BusinessInfo[businessid][bPosX] = x;
	BusinessInfo[businessid][bPosY] = y;
	BusinessInfo[businessid][bPosZ] = z;
	BusinessInfo[businessid][bPosA] = angle;
	BusinessInfo[businessid][bIntX] = bizInteriors[type][intX];
	BusinessInfo[businessid][bIntY] = bizInteriors[type][intY];
	BusinessInfo[businessid][bIntZ] = bizInteriors[type][intZ];
	BusinessInfo[businessid][bIntA] = bizInteriors[type][intA];
	BusinessInfo[businessid][bInterior] = bizInteriors[type][intID];
	BusinessInfo[businessid][bWorld] = BusinessInfo[businessid][bID] + 3000000;
	BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
	BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);
	BusinessInfo[businessid][bCash] = 0;
	BusinessInfo[businessid][bProducts] = 500;
	BusinessInfo[businessid][bText] = Text3D:INVALID_3DTEXT_ID;
	BusinessInfo[businessid][bPickup] = -1;
	BusinessInfo[businessid][bMapIcon] = -1;
	BusinessInfo[businessid][bRobbed] = 3;
	BusinessInfo[businessid][bRobbing] = 0;

	for (new j = 0; j < 25; j ++)
	{
		BusinessInfo[businessid][bPrices][j] = 0;
	}

	switch(BusinessInfo[businessid][bType])
	{
		case BUSINESS_STORE, BUSINESS_GUNSHOP, BUSINESS_CLOTHES, BUSINESS_RESTAURANT, BUSINESS_BARCLUB:
			format(BusinessInfo[businessid][bMessage], 128, "Welcome to "WHITE"%s's{32CD32} %s. Type /buy to purchase from this business.", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType]);
		case BUSINESS_GYM:
		    format(BusinessInfo[businessid][bMessage], 128, "Welcome to "WHITE"%s's{32CD32} %s. /buy to purchase a fighting style.", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType]);
		case BUSINESS_AGENCY:
			format(BusinessInfo[businessid][bMessage], 128, "Welcome to "WHITE"%s's{32CD32} %s. /(ad)vertise to make an advertisement.", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType]);
	    case BUSINESS_MOBILE:
			format(BusinessInfo[businessid][bMessage], 128, "Welcome to "WHITE"%s's{32CD32} %s. /buyload && /buy To buy", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType]);

	}


	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET world = %i, name = '%e', message = '%e' WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bName], BusinessInfo[businessid][bMessage], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
	SM(playerid, SERVER_COLOR, "** Business %i created successfully.", businessid);
}

forward OnAdminCreateGarage(playerid, garageid, type, Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateGarage(playerid, garageid, type, Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(GarageInfo[garageid][gOwner], "Nobody", MAX_PLAYER_NAME);

	GarageInfo[garageid][gExists] = 1;
	GarageInfo[garageid][gID] = cache_insert_id();
	GarageInfo[garageid][gOwnerID] = 0;
	GarageInfo[garageid][gType] = type;
	GarageInfo[garageid][gPrice] = garageInteriors[type][intPrice];
	GarageInfo[garageid][gLocked] = 0;
	GarageInfo[garageid][gPosX] = x;
	GarageInfo[garageid][gPosY] = y;
	GarageInfo[garageid][gPosZ] = z;
	GarageInfo[garageid][gPosA] = angle;
	GarageInfo[garageid][gExitX] = x - 3.0 * floatsin(-angle, degrees);
	GarageInfo[garageid][gExitY] = y - 3.0 * floatsin(-angle, degrees);
	GarageInfo[garageid][gExitZ] = z;
	GarageInfo[garageid][gExitA] = angle - 180.0;
	GarageInfo[garageid][gWorld] = GarageInfo[garageid][gID] + 2000000;
    GarageInfo[garageid][gText] = Text3D:INVALID_3DTEXT_ID;
    GarageInfo[garageid][gPickup] = -1;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET world = %i WHERE id = %i", GarageInfo[garageid][gWorld], GarageInfo[garageid][gID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadGarage(garageid);
	SM(playerid, SERVER_COLOR, "** Garage %i created successfully.", garageid);
}

forward OnAdminCreateHouse(playerid, houseid, type, Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateHouse(playerid, houseid, type, Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);

	HouseInfo[houseid][hExists] = 1;
	HouseInfo[houseid][hID] = cache_insert_id();
	HouseInfo[houseid][hOwnerID] = 0;
	HouseInfo[houseid][hType] = type;
	HouseInfo[houseid][hPrice] = houseInteriors[type][intPrice];
	HouseInfo[houseid][hRentPrice] = 0;
	HouseInfo[houseid][hLevel] = 1;
	HouseInfo[houseid][hLocked] = 0;
	HouseInfo[houseid][hPosX] = x;
	HouseInfo[houseid][hPosY] = y;
	HouseInfo[houseid][hPosZ] = z;
	HouseInfo[houseid][hPosA] = angle;
	HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
	HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
	HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
	HouseInfo[houseid][hIntA] = houseInteriors[type][intA];
	HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
	HouseInfo[houseid][hWorld] = HouseInfo[houseid][hID] + 1000000;
	HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
	HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);
	HouseInfo[houseid][hCash] = 0;
	HouseInfo[houseid][hMaterials] = 0;
	HouseInfo[houseid][hPot] = 0;
	HouseInfo[houseid][hCrack] = 0;
	HouseInfo[houseid][hMeth] = 0;
	HouseInfo[houseid][hPainkillers] = 0;
	HouseInfo[houseid][hHPAmmo] = 0;
	HouseInfo[houseid][hPoisonAmmo] = 0;
	HouseInfo[houseid][hFMJAmmo] = 0;
	HouseInfo[houseid][hLabels] = 0;
	HouseInfo[houseid][hText] = Text3D:INVALID_3DTEXT_ID;
	HouseInfo[houseid][hPickup] = -1;
	HouseInfo[houseid][hRobbed] = 3;
	HouseInfo[houseid][hRobbing] = 0;


	for(new i = 0; i < 10; i ++)
	{
	    HouseInfo[houseid][hWeapons][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
	SM(playerid, SERVER_COLOR, "** House %i created successfully.", houseid);
}

forward OnAdminDeleteAccount(playerid, username[]);
public OnAdminDeleteAccount(playerid, username[])
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else if(SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pAdmin])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. You cannot delete them.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM users WHERE username = '%e'", username);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has deleted %s's account.", GetPlayerNameEx(playerid), username);
	}
}

forward OnAdminListKills(playerid, targetid);
public OnAdminListKills(playerid, targetid)
{
    new rows = SQL_GetRows();

    if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't killed, or has been killed, by anyone since they registered.");
	}
	else
	{
	    new date[24], killer[24], target[24], reason[24];

	    SendClientMessage(playerid, SERVER_COLOR, "Kills & Deaths");

	    for(new i = 0; i < rows; i ++)
	    {
	        SQL_GetString(i, "date", date);
	        SQL_GetString(i, "killer", killer);
	        SQL_GetString(i, "target", target);
	        SQL_GetString(i, "reason", reason);

	        if(SQL_GetInt(i, "killer_uid") == PlayerInfo[targetid][pID])
	        {
		        SM(playerid, COLOR_YELLOW, "[%s] %s killed %s (%s)", date, killer, target, reason);
	        }
	        else if(SQL_GetInt(i, "target_uid") == PlayerInfo[targetid][pID])
	        {
	            SM(playerid, COLOR_YELLOW, "[%s] %s was killed by %s (%s)", date, target, killer, reason);
	        }
	    }
	}
}

forward OnAdminListDamages(playerid, targetid);
public OnAdminListDamages(playerid, targetid)
{
	new rows = SQL_GetRows();

    if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't been damaged by anyone since they connected.");
	}
	else
	{
	    SendClientMessage(playerid, SERVER_COLOR, "Damage Received");

	    for(new i = 0; i < rows; i ++)
	    {
	        SM(playerid, COLOR_YELLOW, "[%i seconds ago] %s was shot by %s with a %s", gettime() - SQL_GetIntByIndex(i, 2), GetRPName(targetid), GetRPName(SQL_GetIntByIndex(1, 1)), GetWeaponNameEx(SQL_GetIntByIndex(i, 0)));
            new szString[128];
	    	format(szString, sizeof(szString), "[%i seconds ago] %s was shot by %s with a %s", gettime() - SQL_GetIntByIndex(i, 2), GetRPName(targetid), GetRPName(SQL_GetIntByIndex(1, 1)), GetWeaponNameEx(SQL_GetIntByIndex(i, 0)));
			SendDiscordMessage(15, szString);
			//SM(playerid, COLOR_GREY2, "(Weapon: %s) - (From: %s) - (Time: %i seconds ago)", GetWeaponNameEx(SQL_GetIntByIndex(i, 0)), GetRPName(SQL_GetIntByIndex(i, 1)), gettime() - SQL_GetIntByIndex(i, 2));
		}
	}
}

forward OnAdminListShots(playerid, targetid);
public OnAdminListShots(playerid, targetid)
{
	new rows = SQL_GetRows();

    if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't registered any shots since they connected.");
	}
	else
	{
	    new weaponid, hittype, timestamp, where[48];

	    SM(playerid, SERVER_COLOR, "%i Last Shots", rows);

	    for(new i = 0; i < rows; i ++)
	    {
	        weaponid 	= SQL_GetInt(i, "weaponid");
	        hittype 	= SQL_GetInt(i, "hittype");
	        timestamp 	= SQL_GetInt(i, "timestamp");

			switch(hittype)
			{
       			case BULLET_HIT_TYPE_PLAYER:
					SQL_GetString(i, "hitplayer", where);
          		case BULLET_HIT_TYPE_VEHICLE:
          		    format(where, sizeof(where), "Vehicle (ID %i)", SQL_GetInt(i, "hitid"));
    			default:
    			    where = "Missed";
			}
			new szString[128];
			format(szString, sizeof(szString), "[%i seconds ago] %s shot a %s and hit: %s", gettime() - timestamp, GetRPName(targetid), GetWeaponNameEx(weaponid), where);
			SendDiscordMessage(15, szString);

			SM(playerid, COLOR_YELLOW, "[%i seconds ago] %s shot a %s and hit: %s", gettime() - timestamp, GetRPName(targetid), GetWeaponNameEx(weaponid), where);
		}
	}
}

forward OnAdminBanIP(playerid, ip[], reason[]);
public OnAdminBanIP(playerid, ip[], reason[])
{
	if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "This IP address is already banned.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        if(!strcmp(GetPlayerIP(i), ip))
			{
				SM(i, COLOR_YELLOW, "** Your IP address has been banned by %s, reason: %s", GetRPName(playerid), reason);
				KickPlayer(i);
			}
		}

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO bans VALUES(null, 'n/a', '%s', '%s', NOW(), '%s', 0)", ip, GetPlayerNameEx(playerid), reason);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has banned IP '%s', reason: %s", GetRPName(playerid), ip, reason);
	    ////Log_Write("log_punishments", "%s (uid: %i) has banned IP: %s, reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], ip, reason);
	}
}

forward OnAdminCheckBan(playerid, string[]);
public OnAdminCheckBan(playerid, string[])
{
	new bannedby[MAX_PLAYER_NAME], username[MAX_PLAYER_NAME], ip[16], date[24], reason[128];

	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "There are no bans that match your criteria.");
	}
	else
	{
	    SQL_GetString(0, "bannedby", bannedby);
	    SQL_GetString(0, "username", username);
	    SQL_GetString(0, "ip", ip);
	    SQL_GetString(0, "date", date);
	    SQL_GetString(0, "reason", reason);

		if(!strcmp(username, "n/a", true)) {
		    if(strfind(ip, "*", true) != -1) {
		    	SM(playerid, COLOR_LIGHTRED, "[%s] IP address '%s' was rangebanned by %s, reason: %s", date, ip, bannedby, reason);
	        } else {
	            SM(playerid, COLOR_LIGHTRED, "[%s] IP address '%s' was banned by %s, reason: %s", date, ip, bannedby, reason);
	        }
		}
		else {
		    if(strfind(ip, "*", true) != -1) {
		    	SM(playerid, COLOR_LIGHTRED, "[%s] %s (IP: %s) was rangebanned by %s, reason: %s", date, username, ip, bannedby, reason);
	        } else if(SQL_GetInt(0, "permanent")) {
	            SM(playerid, COLOR_LIGHTRED, "[%s] %s (IP: %s) was permanently banned by %s, reason: %s", date, username, ip, bannedby, reason);
	        } else {
	            SM(playerid, COLOR_LIGHTRED, "[%s] %s (IP: %s) was banned by %s, reason: %s", date, username, ip, bannedby, reason);
	        }
		}
	}
}

forward OnAdminUnbanUser(playerid, username[]);
public OnAdminUnbanUser(playerid, username[])
{
	if(SQL_GetRows())
	{
	    if(SQL_GetIntByIndex(0, 1) && PlayerInfo[playerid][pAdmin] < 6)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This player is permanently banned. Permabans may only be lifted by Executive Admin.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM bans WHERE id = %i", SQL_GetIntByIndex(0, 0));
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has unbanned %s.", GetRPName(playerid), username);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "There is no banned player known by that name.");
	}

	return 1;
}
forward OnAdminLockAccount(playerid, username[]);
public OnAdminLockAccount(playerid, username[])
{
    if(!SQL_GetRows())
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 1 WHERE username = '%e'", username);
        mysql_tquery(connectionID, queryBuffer);

        SAM(COLOR_LIGHTRED, "AdmCmd: %s has whitelist %s's account.", GetRPName(playerid), username);
        ////Log_Write("log_admin", "%s (uid: %i) whitelist %s's account.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username);
    }
}

forward OnAdminUnlockAccount(playerid, username[]);
public OnAdminUnlockAccount(playerid, username[])
{
    if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist, or their account is not locked.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 0 WHERE username = '%e'", username);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has unwhitelist %s's account.", GetRPName(playerid), username);
	    //Log_Write("log_admin", "%s (uid: %i) unwhitelist %s's account.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username);
	}
}

forward OnAdminChangeName(playerid, targetid, name[]);
public OnAdminChangeName(playerid, targetid, name[])
{
	if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The name specified is taken already.");
	}
	else
	{
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has changed %s's name to %s.", GetRPName(playerid), GetRPName(targetid), name);
		SM(targetid, COLOR_WHITE, "** %s changed your name from %s to %s.", GetRPName(playerid), GetRPName(targetid), name);
		new dc_str[454];
		format(dc_str, sizeof(dc_str), "AdmCmd: %s has changed %s's name to %s.", GetRPName(playerid), GetRPName(targetid), name);
		SendDiscordMessage(2, dc_str);

		Namechange(targetid, GetPlayerNameEx(targetid), name);
	}
}

forward OnAdminOfflineBan(playerid, username[], reason[]);
public OnAdminOfflineBan(playerid, username[], reason[])
{
    if(SQL_GetRows())
	{
	    if(SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pAdmin])
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be banned.");
		}

		new
		    ip[16];

		SQL_GetStringByIndex(0, 1, ip);

        AddBan(username, ip, GetPlayerNameEx(playerid), reason);

    	//mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO log_bans VALUES(null, %i, NOW(), '%s (IP: %s) was banned by %s, reason: %e')", SQL_GetInt(0, "uid"), username, ip, GetPlayerNameEx(playerid), reason);
		//mysql_tquery(connectionID, queryBuffer);

        SAM(COLOR_LIGHTRED, "AdmCmd: %s was offline banned by %s, reason: %s", username, GetPlayerNameEx(playerid), reason);
        ////Log_Write("log_punishments", "%s (uid: %i) offline banned %s, reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, reason);
	}

	return 1;
}

forward OnAdminOfflinePrison(playerid, username[], minutes, reason[]);
public OnAdminOfflinePrison(playerid, username[], minutes, reason[])
{
	if(SQL_GetRows())
	{
	    if(playerid != INVALID_PLAYER_ID && SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pAdmin])
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be prisoned.");
		}

		new prisonedBy[MAX_PLAYER_NAME + 16];
		if(playerid != INVALID_PLAYER_ID)
		{
			format(prisonedBy, sizeof(prisonedBy), "%s", GetPlayerNameEx(playerid));
		}
		else
		{
			format(prisonedBy, sizeof(prisonedBy), "Discord Admin");
		}

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET jailtype = 2, jailtime = %i, prisonedby = '%e', prisonreason = '%e' WHERE username = '%e'", minutes * 60, prisonedBy, reason, username);
	    mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s was offline prisoned for %i minutes by %s, reason: %s", username, minutes, prisonedBy, reason);
		////Log_Write("log_punishments", "%s (uid: %i) offline prisoned %s for %i minutes, reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, minutes, reason);
	}
	else
	{
	    if(playerid != INVALID_PLAYER_ID)
	    {
		    SendClientMessage(playerid, COLOR_SYNTAX, "That player is not registered.");
		}
	}

	return 1;
}

forward OnAdminOfflineFine(playerid, username[], amount, reason[]);
public OnAdminOfflineFine(playerid, username[], amount, reason[])
{
	if(SQL_GetRows())
	{
	    if(SQL_GetIntByIndex(0, 0) > PlayerInfo[playerid][pAdmin])
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be fined.");
		}

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = cash - %i WHERE username = '%e'", amount, username);
	    mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s was offline fined for $%i by %s, reason: %s", username, amount, GetRPName(playerid), reason);
        ////Log_Write("log_admin", "%s (uid: %i) offline fined %s for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, amount, reason);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player is not registered.");
	}

	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	new
	    File:file = fopen("mysql_error.txt", io_append);

	if(file)
	{
	    new
	        string[2048];

		format(string, sizeof(string), "[%s]\r\nError ID: %i\r\nCallback: %s\r\nQuery: %s\r\n[!] %s\r\n\r\n", GetDate(), errorid, callback, query, error);
		fwrite(file, string);
		fclose(file);
	}

	//SAM(COLOR_LIGHTRED, "AdmCmd: A MySQL error occurred (error %i). Details written to mysql_error.txt.", errorid);
	return 1;
}

