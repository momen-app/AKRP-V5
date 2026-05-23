CMD:accept(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /accept [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: House, Death, Garage, Business, Land, Vest, Vehicle, Faction, Gang, Ticket, Live, Vehicle, RentVehicle");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Item, Frisk, Handshake, Weapon, Lawyer, Dicebet, Invite, Robbery, Allience, Location");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to use accept, bobo!", GetRPName(playerid));
	}
	if(!strcmp(params, "house", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pHouseOffer],
		    houseid = PlayerInfo[playerid][pHouseOffered],
		    price = PlayerInfo[playerid][pHousePrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a house.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsHouseOwner(offeredby, houseid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this house.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's house.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
		{
	    	return SM(playerid, COLOR_SYNTAX, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
		}

	    SetHouseOwner(houseid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's house offer and paid $%i for their house.", GetRPName(offeredby), price);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your house offer and paid $%i for your house.", GetRPName(playerid), price);
	    //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their house (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), HouseInfo[houseid][hID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));

	    PlayerInfo[playerid][pHouseOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "location", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pGpsOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a location.");
	    }
	    new
	        targetid,
		    Float:x,
		    Float:y,
		    Float:z,
		    Float:a;

        GetPlayerPos(targetid, x, y, z);
        GetPlayerFacingAngle(targetid, a);

		SetPlayerCheckpoint(playerid, x, y, z, 3.0);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's location.", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s accepted your location offer.", GetRPName(playerid));
	    SM(playerid, COLOR_GREEN, "Location: %s", GetPlayerZoneName(offeredby));

	    PlayerInfo[playerid][pGpsOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "vehicle", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pCarOffer],
		    vehicleid = PlayerInfo[playerid][pCarOffered],
		    price = PlayerInfo[playerid][pCARPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You haven't received any offers for a vehicle.");
	    }
		if(PlayerInfo[playerid][pCartype] == 1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Vehicle Is a RentVehilce Use /accept rentvehicle");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsVehicleOwner(offeredby, vehicleid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this vehicle.");
	    }
    	if(GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES)
    	{
   			return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
    	}
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's vehicle.");
	    }

	    GetPlayerName(playerid, VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
	    VehicleInfo[vehicleid][vOwnerID] = PlayerInfo[playerid][pID];

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET ownerid = %i, owner = '%s' WHERE id = %i", VehicleInfo[vehicleid][vOwnerID], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_AQUA, "** You have accepted %s's vehicle offer and paid $%i for their %s.", GetRPName(offeredby), price, GetVehicleName(vehicleid));
	    SM(offeredby, COLOR_AQUA, "** %s accepted your vehicle offer and paid $%i for your %s.", GetRPName(playerid), price, GetVehicleName(vehicleid));
        //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));
        new szString[128];
  	    format(szString, sizeof(szString),"%s (uid: %i) (IP: %s) sold their %s (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));
  	    SendDiscordMessage(12, szString);
	    PlayerInfo[playerid][pCarOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "rentvehicle", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pCarOffer],
		    vehicleid = PlayerInfo[playerid][pCarOffered],
		    price = PlayerInfo[playerid][pCARPrice],
			minutes = PlayerInfo[playerid][pCartime];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You haven't received any offers for a vehicle.");
	    }
		if(PlayerInfo[playerid][pCartype] == 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Use /accept vehicle");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsVehicleOwner(offeredby, vehicleid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this vehicle.");
	    }
    	if(GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES)
    	{
   			return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
    	}
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's vehicle for rent.");
	    }

         // Convert fractional hours to seconds


        VehicleInfo[vehicleid][vOgowner] = PlayerInfo[offeredby][pID];       
        VehicleInfo[vehicleid][vOwnerID] = PlayerInfo[playerid][pID]; 
	    VehicleInfo[vehicleid][vRent]  = 1;       
        VehicleInfo[vehicleid][vRenttime] = minutes; 

        SendClientMessage(offeredby, COLOR_BLUE, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}]Vehicle rented successfully.");
        SendClientMessage(playerid, -1, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}]You have rented a vehicle.");

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET ogowner = %i, ownerid = %i, rent = 1 , renttime = %i WHERE id = %i", VehicleInfo[vehicleid][vOgowner], VehicleInfo[vehicleid][vOwnerID],VehicleInfo[vehicleid][vRenttime], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		new szString[128];
  	    format(szString, sizeof(szString),"[ Rent ]%s (uid: %i) (IP: %s) sold their %s (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));
  	    SendDiscordMessage(12, szString);
	    PlayerInfo[playerid][pCarOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "death", true))
	{
	    if(IsPlayerConnected(PlayerInfo[playerid][pAcceptedEMS]) && !PlayerInfo[PlayerInfo[playerid][pAcceptedEMS]][pAFK])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "There is a medic online and on the way to rescue you.");
		}
 		if(PlayerInfo[playerid][pDeathCooldown] > 0)
		{
	    	return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds before you can give up.", PlayerInfo[playerid][pDeathCooldown]);
		}
	    if(!PlayerInfo[playerid][pInjured])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not injured and can't accept your death.");
	    }
	    for(new td = 0; td < 4; td ++)
	    {
		  PlayerTextDrawHide(playerid, DEATH[playerid][td]);
        }
        for(new i = 0; i < 15; i++)
        {
          TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
        }
        CancelSelectTextDraw(playerid);

       	PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
	    SendClientMessage(playerid, COLOR_SYNTAX, "You have given up and accepted your fate.");
	    DamagePlayer(playerid, 300, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
	}
	else if(!strcmp(params, "marriage", true))
	{
		new id, offeredby = PlayerInfo[playerid][pMarriageOffer];
		if((id = GetInsideBusiness(playerid)) == -1 || BusinessInfo[id][bType] != BUSINESS_RESTAURANT)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at a restaurant to commence a wedding.");
		}
		if(PlayerInfo[playerid][pCash] < 750 || PlayerInfo[offeredby][pCash] < 750)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You both need to have $750 in hand to commence a wedding.");
		}
		if(!IsPlayerConnected(offeredby) || !IsPlayerInRangeOfPlayer(playerid, offeredby, 15.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't in range of anyone who has offered to marry you.");
		}

		GivePlayerCash(playerid, -3000000);
		GivePlayerCash(offeredby, -3000000);
		BusinessInfo[id][bCash] += 1000000;

		SMA(SERVER_COLOR, "Priest: %s and %s just got married, Congratulations to them and longlive.", GetRPName(offeredby), GetRPName(playerid));

		PlayerInfo[playerid][pMarriedTo] = PlayerInfo[offeredby][pID];
		PlayerInfo[offeredby][pMarriedTo] = PlayerInfo[playerid][pID];

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = %i WHERE uid = %i", PlayerInfo[playerid][pMarriedTo], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = %i WHERE uid = %i", PlayerInfo[offeredby][pMarriedTo], PlayerInfo[offeredby][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerInfo[playerid][pMarriedName], GetPlayerNameEx(offeredby), MAX_PLAYER_NAME);
		strcpy(PlayerInfo[offeredby][pMarriedName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);

		PlayerInfo[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "divorce", true))
	{
		new offeredby = PlayerInfo[playerid][pMarriageOffer];
		if(!IsPlayerConnected(offeredby) || !IsPlayerInRangeOfPlayer(playerid, offeredby, 15.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't in range of anyone who has offered to divorce you.");
		}
		if(PlayerInfo[playerid][pMarriedTo] == -1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't even married ya naab.");
		}
		if(PlayerInfo[playerid][pMarriedTo] != PlayerInfo[offeredby][pID])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That isn't the person you're married to.");
		}

		PlayerInfo[playerid][pMarriedTo] = -1;
		PlayerInfo[offeredby][pMarriedTo] = -1;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = -1 WHERE uid = %i", PlayerInfo[offeredby][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerInfo[playerid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
		strcpy(PlayerInfo[offeredby][pMarriedName], "Nobody", MAX_PLAYER_NAME);

		PlayerInfo[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "alliance", true))
	{
	    new offeredby = PlayerInfo[playerid][pAllianceOffer], color, color2;

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent been offered an alliance.");
	    }
		if(offeredby == playerid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't accept offers from yourself.");
		}

		new gangid = PlayerInfo[playerid][pGang], allyid = PlayerInfo[offeredby][pGang];

	    SM(offeredby, COLOR_GREEN, "%s has accepted your offer to form a gang alliance.", GetRPName(playerid));
		SM(playerid, COLOR_GREEN, "You've accepted the offer from %s to form a gang alliance.", GetRPName(offeredby));

		GangInfo[gangid][gAlliance] = allyid;
		GangInfo[allyid][gAlliance] = gangid;
		PlayerInfo[playerid][pAllianceOffer] = INVALID_PLAYER_ID;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = %i WHERE id = %i", allyid, gangid);
   		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = %i WHERE id = %i", gangid, allyid);
		mysql_tquery(connectionID, queryBuffer);

		if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
		    color = GangInfo[gangid][gColor];
		}

		if(GangInfo[allyid][gColor] == -1 || GangInfo[allyid][gColor] == -256)
		{
		    color2 = 0xC8C8C8FF;
		}
		else
		{
		    color2 = GangInfo[allyid][gColor];
		}

		SMA(COLOR_GREEN, "Gang News: {%06x}%s"WHITE" has formed an alliance with {%06x}%s", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);
	}
	else if(!strcmp(params, "garage", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pGarageOffer],
		    garageid = PlayerInfo[playerid][pGarageOffered],
		    price = PlayerInfo[playerid][pGaragePrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a garage.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsGarageOwner(offeredby, garageid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this garage.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's garage.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_GARAGES) >= GetPlayerAssetLimit(playerid, LIMIT_GARAGES))
		{
		    return SM(playerid, COLOR_SYNTAX, "You currently own %i/%i garages. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
		}

	    SetGarageOwner(garageid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's garage offer and paid $%i for their garage.", GetRPName(offeredby), price);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your garage offer and paid $%i for your garage.", GetRPName(playerid), price);
        //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s garage (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));

	    PlayerInfo[playerid][pGarageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "business", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pBizOffer],
		    businessid = PlayerInfo[playerid][pBizOffered],
		    price = PlayerInfo[playerid][pBizPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a business.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsBusinessOwner(offeredby, businessid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this business.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's business.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
		{
	    	return SM(playerid, COLOR_SYNTAX, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
		}

	    SetBusinessOwner(businessid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's business offer and paid $%i for their %s.", GetRPName(offeredby), price, bizInteriors[BusinessInfo[businessid][bType]][intType]);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your business offer and paid $%i for your %s.", GetRPName(playerid), price, bizInteriors[BusinessInfo[businessid][bType]][intType]);
        //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s business (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));

	    PlayerInfo[playerid][pBizOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "land", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pLandOffer],
		    landid = PlayerInfo[playerid][pLandOffered],
		    price = PlayerInfo[playerid][pLandPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a land.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsLandOwner(offeredby, landid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this land.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's land.");
	    }

	    SetLandOwner(landid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's land offer and paid $%i for their land.", GetRPName(offeredby), price);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your land offer and paid $%i for your land.", GetRPName(playerid), price);
	    //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their land (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), LandInfo[landid][lID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));

	    PlayerInfo[playerid][pLandOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "vest", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pVestOffer],
		    price = PlayerInfo[playerid][pVestPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a vest.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy the vest.");
	    }
	    new Float:armor = 50.0;

		SetScriptArmour(playerid, armor);
		GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_AQUA, "** You have accepted %s's vest and paid $%i for %.1f armor points.", GetRPName(offeredby), price, armor);
	    SM(offeredby, COLOR_AQUA, "** %s accepted your vest offer and paid $%i for %.1f armor points.", GetRPName(playerid), price, armor);

	    TurfTaxCheck(offeredby, price);

	    PlayerInfo[playerid][pVestOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "vehicle", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pCarOffer],
		    vehicleid = PlayerInfo[playerid][pCarOffered],
		    price = PlayerInfo[playerid][pCarPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a vehicle.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(!IsVehicleOwner(offeredby, vehicleid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player no longer is the owner of this vehicle.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy this player's vehicle.");
	    }
	    if(PlayerInfo[playerid][pLevel] < 2)
	    {
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be level 2 inorder to purchase this car.");
	    }
	    
	    GetPlayerName(playerid, VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
	    VehicleInfo[vehicleid][vOwnerID] = PlayerInfo[playerid][pID];

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET ownerid = %i, owner = '%s' WHERE id = %i", VehicleInfo[vehicleid][vOwnerID], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's vehicle offer and paid $%i for their %s.", GetRPName(offeredby), price, GetVehicleName(vehicleid));
	    SM(offeredby, COLOR_GREEN, "** %s accepted your vehicle offer and paid $%i for your %s.", GetRPName(playerid), price, GetVehicleName(vehicleid));
        //Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerInfo[offeredby][pID], GetPlayerIP(offeredby), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price, GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid));

	    PlayerInfo[playerid][pCarOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "faction", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pFactionOffer],
		    factionid = PlayerInfo[playerid][pFactionOffered];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any invites to a faction.");
	    }
	    if(PlayerInfo[offeredby][pFaction] != factionid || PlayerInfo[offeredby][pFactionRank] < FactionInfo[factionid][fRankCount] - 2)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is no longer allowed to invite you.");
	    }

	    PlayerInfo[playerid][pFaction] = factionid;
	    PlayerInfo[playerid][pFactionRank] = 0;
	    PlayerInfo[playerid][pDivision] = -1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = %i, factionrank = 0, division = -1 WHERE uid = %i", factionid, PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's faction offer to join "SVRCLR"%s{CCFFFF}.", GetRPName(offeredby), FactionInfo[factionid][fName]);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your faction offer and is now apart of your faction.", GetRPName(playerid));
	    PlayerInfo[playerid][pFactionOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "gang", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pGangOffer],
		    gangid = PlayerInfo[playerid][pGangOffered];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any invites to a gang.");
	    }
	    if(PlayerInfo[offeredby][pGang] != gangid || PlayerInfo[offeredby][pGangRank] < 5)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is no longer allowed to invite you.");
	    }

	    PlayerInfo[playerid][pGang] = gangid;
	    PlayerInfo[playerid][pGangRank] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = %i, gangrank = 0 WHERE uid = %i", gangid, PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's gang offer to join "SVRCLR"%s{CCFFFF}.", GetRPName(offeredby), GangInfo[gangid][gName]);
	    SM(offeredby, COLOR_GREEN, "** %s accepted your gang offer and is now apart of your gang.", GetRPName(playerid));

	    PlayerInfo[playerid][pGangOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "frisk", true))
	{
	    new offeredby = PlayerInfo[playerid][pFriskOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers to be frisked.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }

	    FriskPlayer(offeredby, playerid);
	    PlayerInfo[playerid][pFriskOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "carry", true))
	{
	    new offeredby = PlayerInfo[playerid][pCarryOffer];
	    new targetid;

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers to be frisked.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pDraggedBy] == INVALID_PLAYER_ID)
    	{
		PlayerInfo[playerid][pDraggedBy] = targetid;
		TogglePlayerControllable(playerid, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs onto %s and begins to carry them.", GetRPName(playerid), GetRPName(targetid));
     	}
    	else
     	{
	    PlayerInfo[playerid][pDraggedBy] = INVALID_PLAYER_ID;
	    TogglePlayerControllable(playerid, true);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s stops carry %s.", GetRPName(playerid), GetRPName(targetid));
     	}
	    PlayerInfo[playerid][pCarryOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "ticket", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pTicketOffer],
		    price = PlayerInfo[playerid][pTicketPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a ticket.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to pay this ticket.");
	    }

	    //GivePlayerCash(offeredby, price);

	    AddToTaxVault(price);
	    GivePlayerCash(playerid, -price);

	    SM(playerid, COLOR_GREEN, "** You have paid the $%i ticket written by %s.", price, GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has paid the $%i ticket which was written to them.", GetRPName(playerid), price);

	    PlayerInfo[playerid][pTicketOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "live", true))
	{
	    new offeredby = PlayerInfo[playerid][pLiveOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a live interview.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID || PlayerInfo[offeredby][pCallLine] != INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You or the offerer can't be on a phone call during a live interview.");
	    }

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's live interview offer. Speak in IC chat to begin the interview!", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has accepted your live interview offer. Speak in IC chat to begin the interview!", GetRPName(playerid));

		PlayerInfo[playerid][pLiveBroadcast] = offeredby;
		PlayerInfo[offeredby][pLiveBroadcast] = playerid;
  		PlayerInfo[playerid][pLiveOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "handshake", true))
	{
	    new offeredby = PlayerInfo[playerid][pShakeOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for a handshake.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }

	    ClearAnimations(playerid, SYNC_ALL);
		ClearAnimations(offeredby, SYNC_ALL);

		SetPlayerToFacePlayer(playerid, offeredby);
		SetPlayerToFacePlayer(offeredby, playerid);

		switch(PlayerInfo[playerid][pShakeType])
		{
		    case 1:
		    {
				ApplyAnimationEx(playerid,  "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0);
				ApplyAnimationEx(offeredby, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0);
			}
			case 2:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0);
				ApplyAnimationEx(offeredby, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0);
			}
			case 3:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0);
				ApplyAnimationEx(offeredby, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0);
			}
			case 4:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0);
				ApplyAnimationEx(offeredby, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0);
			}
			case 5:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0);
				ApplyAnimationEx(offeredby, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0);
			}
			case 6:
			{
			    ApplyAnimationEx(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			    ApplyAnimationEx(offeredby, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			}
	    }

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's handshake offer.", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has accepted your handshake offer.", GetRPName(playerid));

  		PlayerInfo[playerid][pShakeOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "item", true))
	{
		new
		    offeredby = PlayerInfo[playerid][pSellOffer],
		    type = PlayerInfo[playerid][pSellType],
		    amount = PlayerInfo[playerid][pSellExtra],
		    price = PlayerInfo[playerid][pSellPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for an item.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to accept the offer.");
	    }
	    if(PlayerInfo[playerid][pLevel] < 2)
	    {
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You are not allowed to buy item if you're level 2 below");
	    }

	    switch(type)
	    {
	        case ITEM_WEAPON:
			{
			    new weaponid = PlayerInfo[playerid][pSellExtra];

	            if(!PlayerHasWeapon(offeredby, weaponid))
	            {
	                return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
	            }

	            GivePlayerCash(playerid, -price);
	            GivePlayerCash(offeredby, price);

	            GiveWeapon(playerid, weaponid);
	            

				
	            RemovePlayerWeaponEx(offeredby, weaponid);
	            

				SM(playerid, COLOR_GREEN, "** You have purchased %s's %s for $%i.", GetRPName(offeredby), GetWeaponNameEx(weaponid), price);
				SM(offeredby, COLOR_GREEN, "** %s has purchased your %s for $%i.", GetRPName(playerid), GetWeaponNameEx(weaponid), price);

				TurfTaxCheck(offeredby, price);

				PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_MATERIALS:
			{
			    if(PlayerInfo[offeredby][pMaterials] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pMaterials] += amount;
			    PlayerInfo[offeredby][pMaterials] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[offeredby][pMaterials], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i materials from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i materials for $%i.", GetRPName(playerid), amount, price);

                TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_BACKPACK:
			{
			    new size[6];
			    if(PlayerInfo[offeredby][pBackpack] != amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][bpWearing])
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot accept this offer as you are still wearing your backpack.");
				}
				if(PlayerInfo[offeredby][bpWearing])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is still wearing their backpack.");
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pBackpack] = amount;
				SavePlayerVariables(playerid);
				ResetBackpack(offeredby);
				if(amount == 1)
				{
				    format(size, sizeof(size), "small");
				}
				if(amount == 2)
				{
				    format(size, sizeof(size), "medium");
				}
				if(amount == 3)
				{
				    format(size, sizeof(size), "large");
				}
			    SM(playerid, COLOR_GREEN, "** You have purchased a %s backpack from %s for $%i.", size, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %s backpack for $%i.", GetRPName(playerid), size, price);

                TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_WEED:
			{
			    if(PlayerInfo[offeredby][pPot] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pPot] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pPot] += amount;
			    PlayerInfo[offeredby][pPot] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[offeredby][pPot], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i grams of pot from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i grams of pot for $%i.", GetRPName(playerid), amount, price);

                TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_COCAINE:
			{
			    if(PlayerInfo[offeredby][pCrack] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pCrack] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pCrack] += amount;
			    PlayerInfo[offeredby][pCrack] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[offeredby][pCrack], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i grams of Crack from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i grams of Crack for $%i.", GetRPName(playerid), amount, price);

			    TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_METH:
			{
			    if(PlayerInfo[offeredby][pMeth] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pMeth] + amount > GetPlayerCapacity(playerid, CAPACITY_METH))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pMeth] += amount;
			    PlayerInfo[offeredby][pMeth] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[offeredby][pMeth], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i grams of meth from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i grams of meth for $%i.", GetRPName(playerid), amount, price);

			    TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_PAINKILLERS:
			{
			    if(PlayerInfo[offeredby][pPainkillers] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
				if(PlayerInfo[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pPainkillers] += amount;
			    PlayerInfo[offeredby][pPainkillers] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[offeredby][pPainkillers], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i painkillers from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i painkillers for $%i.", GetRPName(playerid), amount, price);

			    TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_SEEDS:
			{
			    if(PlayerInfo[offeredby][pSeeds] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pSeeds] += amount;
			    PlayerInfo[offeredby][pSeeds] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", PlayerInfo[offeredby][pSeeds], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i seeds from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i seeds for $%i.", GetRPName(playerid), amount, price);

			    TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
            case ITEM_EPHEDRINE:
			{
			    if(PlayerInfo[offeredby][pEphedrine] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerInfo[playerid][pEphedrine] + amount > GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE))
				{
				    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i ephedrine. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pEphedrine], GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerInfo[playerid][pEphedrine] += amount;
			    PlayerInfo[offeredby][pEphedrine] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i WHERE uid = %i", PlayerInfo[playerid][pEphedrine], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i WHERE uid = %i", PlayerInfo[offeredby][pEphedrine], PlayerInfo[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_GREEN, "** You have purchased %i grams of ephedrine from %s for $%i.", amount, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_GREEN, "** %s has purchased your %i grams of ephedrine for $%i.", GetRPName(playerid), amount, price);

			    TurfTaxCheck(offeredby, price);

			    PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
		}
	}
	else if(!strcmp(params, "dicebet", true))
	{
	    new
			offeredby = PlayerInfo[playerid][pDiceOffer],
			amount = PlayerInfo[playerid][pDiceBet],
			amount2 = (amount/100) * 2,
			amount3 = amount - amount2;

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any offers for dice betting.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerInfo[playerid][pCash] < amount)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to accept this bet.");
	    }
	    if(PlayerInfo[offeredby][pCash] < amount)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player can't afford to accept this bet.");
	    }

		new
			rand[2];

		rand[0] = random(6) + 1;
		rand[1] = random(6) + 1;

		SendProximityMessage(offeredby, 20.0, COLOR_WHITE, "** %s rolls a dice which lands on the number %i.", GetRPName(offeredby), rand[0]);
		SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s rolls a dice which lands on the number %i.", GetRPName(playerid), rand[1]);

		if(rand[0] > rand[1])
		{
		    GivePlayerCash(offeredby, amount3);
		    GivePlayerCash(playerid, -amount);

		    SM(offeredby, COLOR_GREEN, "** You have won $%i from your dice bet with %s.", amount3, GetRPName(playerid));
		    SM(playerid, COLOR_RED, "** You have lost $%i from your dice bet with %s.", amount, GetRPName(offeredby));

			if(amount3 > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
			{
				SAM(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(offeredby), GetPlayerIP(offeredby), amount3, GetRPName(playerid), GetPlayerIP(playerid));
			}
		}
		else if(rand[0] == rand[1])
		{
			SM(offeredby, COLOR_GREEN, "** The bet of $%i was a tie. You kept your money as a result!", amount);
		    SM(playerid, COLOR_GREEN, "** The bet of $%i was a tie. You kept your money as a result!", amount);
		}
		else
		{
		    GivePlayerCash(offeredby, -amount);
		    GivePlayerCash(playerid, amount3);

		    SM(playerid, COLOR_GREEN, "** You have won $%i from your dice bet with %s.", amount3, GetRPName(offeredby));
		    SM(offeredby, COLOR_RED, "** You have lost $%i from your dice bet with %s.", amount, GetRPName(playerid));

			if(amount3 > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
			{
				SAM(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount3, GetRPName(offeredby), GetPlayerIP(offeredby));
			}
		}

	    PlayerInfo[playerid][pDiceOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "invite", true))
	{
	    new
			offeredby = PlayerInfo[playerid][pInviteOffer],
			houseid = PlayerInfo[playerid][pInviteHouse];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any invitations to a house.");
	    }

		PlayerInfo[playerid][pCP] = CHECKPOINT_HOUSE;
		SetPlayerCheckpoint(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 3.0);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's invitation to their house.", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has accepted your invitation to your house.", GetRPName(playerid));

	    PlayerInfo[playerid][pInviteOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "rob", true))
	{
		new	offeredby = PlayerInfo[playerid][pSendRob];
		new	robcash = 5000+random(5000);

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY2, "You havent received any offers for rob.");
	    }
		GivePlayerCash(offeredby, robcash);
		GivePlayerCash(playerid, -robcash);
		PlayerInfo[offeredby][pCrimes]++;

		SM(playerid, COLOR_GREEN, "** You have accepted %s's rob.", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has accepted your rob.", GetRPName(playerid));
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s successfully robbed %s $%i", GetRPName(offeredby),GetRPName(playerid), robcash);
	    PlayerInfo[playerid][pSendRob] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "robbery", true))
	{
	    new offeredby = PlayerInfo[playerid][pRobberyOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received any invitations to a bank heist.");
	    }
	    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
	    }
	    if(RobberyInfo[rRobbers][0] != offeredby || RobberyInfo[rStarted])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The robbery invite is no longer available.");
		}
		if(GetBankRobbers() >= MAX_BANK_ROBBERS)
		{
	    	return SM(playerid, COLOR_SYNTAX, "This bank robbery has reached its limit of %i robbers.", MAX_BANK_ROBBERS);
 		}

		AddToBankRobbery(playerid);

	    SM(playerid, COLOR_GREEN, "** You have accepted %s's bank robbery invitation.", GetRPName(offeredby));
	    SM(offeredby, COLOR_GREEN, "** %s has accepted your bank robbery invitation.", GetRPName(playerid));

	    PlayerInfo[playerid][pRobberyOffer] = INVALID_PLAYER_ID;
	}
	return 1;
}

CMD:e(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /e [executive chat]");
	}
	if(PlayerInfo[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the executive chat as you have admin chats toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAdmin] > 5 && !PlayerInfo[i][pToggleAdmin])
	    {
			SM(i, 0xA077BFFF, "** [%s] %s: %s **", GetAdminRank(playerid), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:ha(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ha [head admin chat]");
	}
	if(PlayerInfo[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the head administrator chat as you have admin chats toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAdmin] > 4 && !PlayerInfo[i][pToggleAdmin])
	    {
			SM(i, 0x5C80FFFF, "** [%s] %s: %s **", GetAdminRank(playerid), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:a(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /a [admin chat]");
	}
	if(!enabledAdmin && PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The admin channel is disabled by Naju.");
	}
	if(PlayerInfo[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the admin chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAdmin] > 0 && !PlayerInfo[i][pToggleAdmin])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SM(i, 0xD1E0BAFF, "%s "RED"%s{D1E0BA} %s {F9B64A}%s"WHITE": %.*s... **", IsPlayerAndroid(playerid) ? ("{CCFFFF}Android") : ("{C2A2DA}Desktop"), GetAdminDivision(playerid),GetAdminRank2(playerid), GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SM(i, 0xD1E0BAFF, ""RED"%s{D1E0BA} %s {F9B64A}%s"WHITE": ...%s **", GetAdminDivision(playerid),GetAdminRank2(playerid), GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
				SM(i, 0xD1E0BAFF, "%s "RED"%s{D1E0BA} %s {F9B64A}%s"WHITE": %s **", IsPlayerAndroid(playerid) ? ("{CCFFFF}Android") : ("{C2A2DA}Desktop"), GetAdminDivision(playerid),GetAdminRank2(playerid), GetRPName(playerid), params);
			}
		}
	}
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "%s %s %s: %s", GetAdminDivision(playerid),GetAdminRank(playerid), GetRPName(playerid), params);
	SendDiscordMessage(9, dc_str);
	return 1;
}

CMD:verify(playerid, params[])
{
    if(PlayerInfo[playerid][pVerified] == 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently verified.");
    }
    new code = Random(100000, 999999);
    PlayerInfo[playerid][pCode] = code;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET code = %i WHERE uid = %i", code, PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
    SendClientMessage(playerid, COLOR_GREEN, "Code has been re-established. You may see it at '/settings'!!!");
    return 1;
}


//Discord Command(s)

DCMD:link(user, channel, params[])
{
    // VARIABLES //
    new DCC_Guild:guild = DCC_FindGuildById("911932751115063296");//server id
    new DCC_Role:role = DCC_FindRoleById("911933029264543804");// Verified Role
    new DCC_Role:role1 = DCC_FindRoleById("911933029910470737");// Unverified Role
    new DCC_Channel:channell = DCC_FindChannelById("911933062533742612");
    new chan[500];
    DCC_GetChannelName(channell, chan, sizeof(chan));
    new bool:hasRole;
    new name[32+1], id[20+1], user_id[20+1];
    new code;

    // Checking if the user has the Verified role. if is, we will not allow the user to verify again.
    DCC_HasGuildMemberRole(guild, user, role, hasRole);


    // CODE //
    if(channel != DCC_FindChannelById("911933062533742612"))
    {
        new str[1500];
        format(str, sizeof(str), "Wrong Channel\nYou can use this command at <#911933062533742612>.", chan);
    }
    if(!IsNumeric(params))
    {
        return DCC_SendChannelMessage(channel, "> ***Please Use Numerical Because it wont work!***");
    }

    if(sscanf(params, "i", code))
        return DCC_SendChannelMessage(channel, "***Discord: !link [code]***");
        
    if(hasRole)
    {
        new str[500];
        format(str, sizeof(str), "This system prevents users from verifying/creating multiple accounts to the server.");
        new DCC_Embed:embed = DCC_CreateEmbed("You are currently verified!", str);
        DCC_SetEmbedColor(embed, 0xFF0000);
        return DCC_SendChannelEmbedMessage(channel, embed);
    }

    if(code == 0)
    {
        return DCC_SendChannelMessage(channel, "> ***Please enter valid code.***");
    }
    for(new i = 0 ; i < MAX_PLAYERS; i ++)
    {

        if(PlayerInfo[i][pCode] == code)
        {
            new str[500], footer[500];

        	DCC_AddGuildMemberRole(guild, user, role);
        	DCC_RemoveGuildMemberRole(guild, user, role1);
            DCC_SetGuildMemberNickname(guild, user, PlayerInfo[i][pUsername]);
            PlayerInfo[i][pVerified] = 1;
            PlayerInfo[i][pCode] = 0;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET verify = 1 WHERE username = '%e'", PlayerInfo[i][pUsername]);
            mysql_tquery(connectionID, queryBuffer);
			format(str, sizeof(str), "Your account is **%s** \nSuccessfully Verified, Ingame And Discord.", PlayerInfo[i][pUsername]);
			new DCC_Embed:embed = DCC_CreateEmbed();
   			DCC_SetEmbedTitle(embed, "Player Verification.");
      		DCC_SetEmbedDescription(embed, str);
      		DCC_SetEmbedColor(embed, 0x0000FFFF);
        	format(footer, sizeof(footer), "BABYLON  Team Management");
         	DCC_SetEmbedFooter(embed, footer);
            DCC_SendChannelEmbedMessage(channell, embed);

            // Storing their Discord user Name, and Discord User Tag //
            DCC_GetUserId(user, user_id, sizeof(user_id));
            DCC_GetUserName(user, name, sizeof(name));
            DCC_GetUserDiscriminator(user, id, sizeof(id));
            PlayerInfo[i][pDiscordName] = name;
            PlayerInfo[i][pDiscordTag] = id;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET discordid = '%e', discordname = '%e', discordtag = '%e' WHERE username = '%e'", user_id, name, id, PlayerInfo[i][pUsername]);
            mysql_tquery(connectionID, queryBuffer);

            return 1;
        }
    }
    return 1;
}

