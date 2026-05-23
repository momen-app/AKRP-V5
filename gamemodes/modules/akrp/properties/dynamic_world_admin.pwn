CMD:createatm(playerid, params[]) ///main
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, SERVER_COLOR, "Error:"WHITE" You are not authorized to use this command.");
	}
    if(sscanf(params, "s[32]", "confirm"))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createatm [confirm]");
		SendClientMessage(playerid, COLOR_WHITE, "** NOTE: The ATM will be created at the coordinates you are standing on.");
		return 1;
	}
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your virtual world & interior must be 0!");
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_ATMS; i ++)
	{
		if(!AtmInfo[i][aExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO atms VALUES(null, '%f', '%f', '%f', '%f','%f')", x, y, z, a, 50000);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateAtm", "iifffff", playerid, i, x, y, z, a, 50000);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "ATM slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}
CMD:resettoys(playerid, params[])
{
	for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			RemovePlayerAttachedObject(playerid, i);
		}
	}
}
CMD:removeatm(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, SERVER_COLOR, "Error:"WHITE" You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeatm [atmid] (/nearest)");
	}
	if(!(0 <= loc < MAX_ATMS) || !AtmInfo[loc][aExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid ATM or Static.");
	}
    DestroyDynamic3DTextLabel(AtmInfo[loc][aText]);
    DestroyDynamicObject(AtmInfo[loc][aObject]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM atms WHERE id = %i", AtmInfo[loc][aID]);
	mysql_tquery(connectionID, queryBuffer);
	AtmInfo[loc][aExists] = false;
	AtmInfo[loc][aID] = 0;

	SCMf(playerid, COLOR_WHITE, "** You have removed ATM %i.", loc);
	return 1;
}

CMD:gotoatm(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, SERVER_COLOR, "Error:"WHITE" You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoatm [atmid]");
	}
	if(!(0 <= loc < MAX_ATMS) || !AtmInfo[loc][aExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid ATM or Static.");
	}
	SetPlayerPos(playerid,AtmInfo[loc][aPosX], AtmInfo[loc][aPosY],AtmInfo[loc][aPosZ]);
	SetCameraBehindPlayer(playerid);
	SCMf(playerid, COLOR_WHITE, "** You have been teleported to ATM %i.", loc);
	return 1;
}
CMD:creategg(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You are not authorized to use this command.");
	}
    if(sscanf(params, "s[32]", "confirm"))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /creategg [confirm]");
		SendClientMessage(playerid, COLOR_WHITE, "** NOTE: The gang garage will be created at the coordinates you are standing on.");
		return 1;
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_GGARAGE; i ++)
	{
		if(!GGInfo[i][aExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO ganggarage VALUES(null, '%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateGG", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Gang Garage slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:removegg(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removegg [ggid] (/nearest)");
	}
	if(!(0 <= loc < MAX_PGARAGE) || !GGInfo[loc][aExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid Gang Garage or Static.");
	}
    DestroyDynamic3DTextLabel(GGInfo[loc][aText]);
    DestroyDynamicObject(GGInfo[loc][aObject]);
    DestroyDynamicMapIcon(GGInfo[loc][aMapIcon]);
    DestroyDynamicPickup(GGInfo[loc][aObject]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM ganggarage WHERE id = %i", GGInfo[loc][aID]);
	mysql_tquery(connectionID, queryBuffer);
	GGInfo[loc][aExists] = false;
	GGInfo[loc][aID] = 0;

	SM(playerid, COLOR_WHITE, "** You have removed gang garage %i.", loc);
	return 1;
}
CMD:createpg(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_RED, "Error:"WHITE" You are not authorized to use this command.");
	}
    if(sscanf(params, "s[32]", "confirm"))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createpg [confirm]");
		SendClientMessage(playerid, COLOR_WHITE, "** NOTE: The public garage will be created at the coordinates you are standing on.");
		return 1;
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_PGARAGE; i ++)
	{
		if(!PGInfo[i][aExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO publicgarage VALUES(null, '%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreatePG", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Public Garage slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}
CMD:removepg(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_RED, "Error:"WHITE" You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removepg [pgid] (/nearest)");
	}
	if(!(0 <= loc < MAX_PGARAGE) || !PGInfo[loc][aExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid Public Garage or Static.");
	}
    DestroyDynamic3DTextLabel(PGInfo[loc][aText]);
    DestroyDynamicObject(PGInfo[loc][aObject]);
    DestroyDynamicMapIcon(PGInfo[loc][aMapIcon]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM publicgarage WHERE id = %i", PGInfo[loc][aID]);
	mysql_tquery(connectionID, queryBuffer);
	PGInfo[loc][aExists] = false;
	PGInfo[loc][aID] = 0;

	SCMf(playerid, COLOR_WHITE, "** You have removed public garage %i.", loc);
	return 1;
}

CMD:createhouse(playerid, params[])
{
	new type, Float:x, Float:y, Float:z, Float:a;
    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", type))
	{
	    SM(playerid, COLOR_SYNTAX, "Usage: /createhouse [type (1-%i)]", sizeof(houseInteriors));
		SendClientMessage(playerid, COLOR_SYNTAX, "Types: 1-6 Apartment | 7-9 Low Class | 10-12 Med Class | 13-16 Upper | 17-19 Mansion | 20 Custom House");
		return 1;
	}
	if(!(1 <= type <= sizeof(houseInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}
	if(GetNearbyHouse(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a house in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	type--;

	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(!HouseInfo[i][hExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO houses (type, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", type, houseInteriors[type][intPrice], x, y, z, a - 180.0,
				houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ], houseInteriors[type][intA], houseInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateHouse", "iiiffff", playerid, i, type, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "House slots are currently full. Ask the developer to increase the internal limit.");
	return 1;
}

new PlayerGangZones[1];
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{

    new Float:radius = 8.0; // Adjust the radius as needed

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPlayer(i, playerid, radius))
        {
            DisablePlayerRaceCheckpoint(playerid);

            PlayerGangZones[0] = SetPlayerRaceCheckpoint(i, CP_TYPE_GROUND_FINISH, fX, fY, fZ, 0.0, 0.0, 0.0, 10);
            SendClientMessage(i, COLOR_BLUE, "Marked location.");
        }
    }
    StartTracing(playerid, fX, fY, fZ);
	SetTracingColor(playerid, 0x4B0082FF);
    DisablePlayerRaceCheckpoint(playerid);
    PlayerGangZones[0] = SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, fX, fY, fZ, 0.0, 0.0, 0.0, 10);
    SendClientMessage(playerid,COLOR_SYNTAX,"Vehicle Gps Only Work in vehicles");
    SendClientMessage(playerid, COLOR_BLUE, "Marked location. /cancelgps to cancel");
    return 0;
}

CMD:cancelgps(playerid, params[])
{
    CancelTracing(playerid);
    DisablePlayerRaceCheckpoint(playerid);
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{

    new turfid = InfluenceInfo[iTurf];

   
    if (InfluenceInfo[iTurf] != -1 && areaid == TurfInfo[turfid][tArea] && InfluenceInfo[iStart] == 1) {
        HandleTurfEntry(playerid, turfid, areaid);
    }

    
    HandleNearbyTurfInfluence(playerid, areaid);

   
    new pid = GetNearbyPoints2(playerid);
    if (pid != -1 && PointInfo[pid][pTime] == 0 && PointInfo[pid][pCapturer] != INVALID_PLAYER_ID && areaid == PointInfo[pid][pArea]) {
        HandlePointEntry(playerid, pid);
    }

    return 1;
}


forward HandleTurfEntry(playerid, turfid, areaid);
public HandleTurfEntry(playerid, turfid, areaid)
{
    if (PlayerInfo[playerid][pInjured] == 0 && PlayerInfo[playerid][pAdminDuty] == 0) {
        if (PlayerInfo[playerid][pGang] > 0) {
            SendGangEntryMessage(playerid, turfid, "Turf Boundaries");
            EnableBandana(playerid, "turf in an active war");
        } else if (IsLawEnforcement(playerid)) {
            SendLEOEntryMessage(playerid, turfid, "Turf Boundaries", "Police");
        }
    }
}


forward HandleNearbyTurfInfluence(playerid, areaid);
public HandleNearbyTurfInfluence(playerid, areaid)
{
    new turfid1 = GetNearbyTurf(playerid);
    if (turfid1 != -1 && areaid == TurfInfo[turfid1][tArea]) {
        if (TurfInfo[turfid1][tType] == 11 && TurfInfo[turfid1][tTime] == 0) {
            if (TurfInfo[turfid1][tInfluenceTime] == 0) {
                TurfInfo[turfid1][tInfluence] = 100;
                TurfInfo[turfid1][tInfluenceTime] = 1800;
                TurfInfo[turfid1][tInfluenceGang] = TurfInfo[turfid1][tCapturedGang];
                ReloadTurf(turfid1);
            }
            ShowTurfTD(playerid);

            if (TurfInfo[turfid1][tInfluenceTime] > 0 && PlayerInfo[playerid][pInjured] == 0 && PlayerInfo[playerid][pAdminDuty] == 0) {
                if (PlayerInfo[playerid][pGang] > 0) {
                    SendGangEntryMessage(playerid, turfid1, "Turf Boundaries");
                    EnableBandana(playerid, "turf in an active war");
                } else if (IsLawEnforcement(playerid)) {
                    SendLEOEntryMessage(playerid, turfid1, "Turf Boundaries", "Police");
                }
                SetPVarInt(playerid, "turfid", turfid1);
            }
        }
    }
}


forward HandlePointEntry(playerid, pid);
public HandlePointEntry(playerid, pid)
{
    if (PlayerInfo[playerid][pGang] > 0) {
        SendGangEntryMessage(playerid, pid, "Point Boundaries");
        EnableBandana(playerid, "active Point War");
    } else if (IsLawEnforcement(playerid)) {
        SendLEOEntryMessage(playerid, pid, "Point Boundaries", "Police");
    }
    SetPVarInt(playerid, "pointid", pid);
}


forward SendGangEntryMessage(playerid, areaid, const areaType[]);
public SendGangEntryMessage(playerid, areaid, const areaType[])
{
    new string[250];
    format(string, sizeof(string), "{05ff93}[Enter] {%06x}%s {44ff00}Entered "WHITE"The %s. Gang Name: %s (Entered %i Times)",
           GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8,
           GetRPName(playerid),
           areaType,
           GangInfo[PlayerInfo[playerid][pGang]][gName],
           PlayerInfo[playerid][pTEnteredTime]);
    SendTurfAdminMessage(areaid, COLOR_LIGHTRED, string);
    PlayerInfo[playerid][pTEnteredTime]++;
    format(string, sizeof(string), "{%06x}%s\n"WHITE"%s",
           GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8,
           GangInfo[PlayerInfo[playerid][pGang]][gName],
           GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]]);
    UpdateDynamic3DTextLabelText(PlayerLabel[playerid], COLOR_WHITE, string);
}


forward SendLEOEntryMessage(playerid, areaid, const areaType[], const factionName[]);
public SendLEOEntryMessage(playerid, areaid, const areaType[], const factionName[])
{
    new string[250];
    format(string, sizeof(string), "{05ff93}[Enter] {1900ff}%s {44ff00}Entered "WHITE"The %s. Faction Name: %s (Entered %i Times)",
           GetRPName(playerid),
           areaType,
           factionName,
           PlayerInfo[playerid][pTEnteredTime]);
    SendTurfAdminMessage(areaid, COLOR_LIGHTRED, string);
    PlayerInfo[playerid][pTEnteredTime]++;
}


forward EnableBandana(playerid, const reason[]);
public EnableBandana(playerid, const reason[])
{
    PlayerInfo[playerid][pBandana] = 1;
    new string[128];
    format(string, sizeof(string), "Your bandana was enabled automatically as you entered a %s.", reason);
    SendClientMessage(playerid, COLOR_WHITE, string);
}

CMD:edithouse(playerid, params[])
{
	new houseid, option[10], param[32];

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[10]S()[32]", houseid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Outside, Inside, World, Type, Owner, Price, RentPrice, Level, Locked");
	    return 1;
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid house.");
	}

	if(!strcmp(option, "outside", true))
	{
	    GetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
	    GetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);

	    HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
	    HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], HouseInfo[houseid][hPosA], HouseInfo[houseid][hOutsideInt], HouseInfo[houseid][hOutsideVW], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the exterior of house %i.", houseid);
	}
	else if(!strcmp(option, "inside", true))
	{
	    new type = -1;

	    for(new i = 0; i < sizeof(houseInteriors); i ++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 100.0, houseInteriors[i][intX], houseInteriors[i][intY], houseInteriors[i][intZ]))
	        {
	            type = i;
			}
	    }

	    GetPlayerPos(playerid, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]);
	    GetPlayerFacingAngle(playerid, HouseInfo[houseid][hIntA]);

	    HouseInfo[houseid][hInterior] = GetPlayerInterior(playerid);
		HouseInfo[houseid][hType] = type;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the interior of house %i.", houseid);
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [world] [vw]");
		}

		HouseInfo[houseid][hWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the virtual world of house %i to %i.", houseid, worldid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [type] [value (1-%i)]", sizeof(houseInteriors));
		}
		if(!(1 <= type <= sizeof(houseInteriors)))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		type--;

		HouseInfo[houseid][hType] = type;
		HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
		HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
		HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
		HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
		HouseInfo[houseid][hIntA] = houseInteriors[type][intA];

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the type of house %i to %i.", houseid, type + 1);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(!PlayerInfo[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
		}

        SetHouseOwner(houseid, targetid);
	    SM(playerid, COLOR_AQUA, "** You've changed the owner of house %i to %s.", houseid, GetRPName(targetid));
	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $0.");
		}

		HouseInfo[houseid][hPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET price = %i WHERE id = %i", HouseInfo[houseid][hPrice], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the price of house %i to $%i.", houseid, price);
	}
	else if(!strcmp(option, "rentprice", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [rentprice] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $0.");
		}

		HouseInfo[houseid][hRentPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET rentprice = %i WHERE id = %i", HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the rent price of house %i to $%i.", houseid, price);
	}
	else if(!strcmp(option, "level", true))
	{
	    new level;

	    if(sscanf(param, "i", level))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [level] [value (0-5)]");
		}
		if(!(0 <= level <= 5))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 5.");
		}

		HouseInfo[houseid][hLevel] = level;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET level = %i WHERE id = %i", HouseInfo[houseid][hLevel], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the level of house %i to %i.", houseid, level);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edithouse [houseid] [locked] [0/1]");
		}

		HouseInfo[houseid][hLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[houseid][hLocked], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SM(playerid, COLOR_AQUA, "** You've changed the lock state of house %i to %i.", houseid, locked);
	}

	return 1;
}
CMD:sa(playerid, params[])
{
	return callcmd::stopanim(playerid, params);
}
CMD:sl(playerid, params[])
{
	return callcmd::sendloc(playerid, params);
}
CMD:removefurniture(playerid, params[])
{
	new houseid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removefurniture [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid house.");
	}

	RemoveAllFurniture(houseid);
	SM(playerid, COLOR_AQUA, "** You have removed all furniture for house %i.", houseid);
	return 1;
}
CMD:sellcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), targetid, amount;
	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellcar [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(VehicleInfo[vehicleid][vRent])
	{
		return SendClientMessage(playerid, COLOR_RED, "Kalla Polayadi Mone Jabarinte Vandi Vit Jeevikan Nokuno Pelaydi");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
        return SendClientMessage(playerid, COLOR_RED, "You Admin Lol!");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must specify an amount above zero.");
	}
	for(new i = 0 ; i < 3 ; i++)
	{
		if(VehicleInfo[vehicleid][vWeapons][i] > 0 && PlayerInfo[playerid][pFaction])
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "You Are Breaking Rules Reported to Admins You Will be Jailed");
			new sz[258];
			format(sz, sizeof(sz), "{FF0000} ALERT! {FFFFFF}%s{FF0000}Tried To sell Vehicle to %s With Guns While On Pd", GetRPName(playerid), GetRPName(targetid));
			SAM(COLOR_RED, sz);
			SendDiscordMessage(26, sz);
			return 1;
		}
	}

	PlayerInfo[targetid][pCarOffer] = playerid;
	PlayerInfo[targetid][pCarOffered] = vehicleid;
	PlayerInfo[targetid][pCARPrice] = amount;
	PlayerInfo[targetid][pCartype] = 0;
	SM(targetid, COLOR_AQUA, "** %s offered you their %s for $%i (/accept vehicle).", GetRPName(playerid), GetVehicleName(vehicleid), amount);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your %s for $%i.", GetRPName(targetid), GetVehicleName(vehicleid), amount);
	return 1;
}
CMD:checkrent(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	SM(playerid, COLOR_AQUA, "Renttime = %i", VehicleInfo[vehicleid][vRenttime]);

	return 1;
}
CMD:removehouse(playerid, params[])
{
	new houseid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removehouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid house.");
	}

	RemoveAllFurniture(houseid);

	DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
	DestroyDynamicPickup(HouseInfo[houseid][hPickup]);
	DestroyDynamicMapIcon(HouseInfo[houseid][hMapIcon]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM houses WHERE id = %i", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	HouseInfo[houseid][hExists] = 0;
	HouseInfo[houseid][hID] = 0;
	HouseInfo[houseid][hOwnerID] = 0;

	Iter_Remove(House, houseid);
	
	SAM(COLOR_RED, "ADMWarning: %s has removed a house(HID: %i)", GetRPName(playerid), houseid);
	SM(playerid, COLOR_AQUA, "** You have removed house %i.", houseid);
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	new houseid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotohouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid house.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
	SetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);
	SetPlayerInterior(playerid, HouseInfo[houseid][hOutsideInt]);
	SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hOutsideVW]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:previewint(playerid, params[])
{
	new type, string[32];

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", type))
	{
	    return SM(playerid, COLOR_SYNTAX, "Usage: /previewint [1-%i]", sizeof(houseInteriors));
	}
	if(!(1 <= type <= sizeof(houseInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}

	type--;

	format(string, sizeof(string), "~w~%s", houseInteriors[type][intClass]);
	GameTextForPlayer(playerid, string, 5000, 1);

	SetPlayerPos(playerid, houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ]);
	SetPlayerFacingAngle(playerid, houseInteriors[type][intA]);
	SetPlayerInterior(playerid, houseInteriors[type][intID]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:nearest(playerid, params[])
{
	new id;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Nearest Items:");

	if((id = GetNearbyHouse(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of house ID %i.", id);
	}
	if((id = GetNearbyVehicle(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of vehicle ID %i.", id);
	}
	if((id = GetNearbyGarage(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of garage ID %i.", id);
	}
	if((id = GetNearbyPoint(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of point ID %i.", id);
	}
	if((id = GetNearbyBusiness(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of business ID %i.", id);
	}
	if((id = GetNearbyEntrance(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of entrance ID %i.", id);
	}
	if((id = GetNearbyLand(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of land ID %i.", id);
	}
	if((id = GetNearbyTurf(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of turf ID %i.", id);
	}
	if((id = GetNearbyAtm(playerid)) >= 0)
	{
		SCMf(playerid, COLOR_GREY2, "You are in range of atm ID %i", id);
	}
	if((id = Gate_Nearest(playerid)) >= 0)
	{
	    SM(playerid, COLOR_GREY2, "You are in range of gate ID %i.", id);
	}
    if((id = GetNearbyPG(playerid)) >= 0)
	{
		SCMf(playerid, COLOR_GREY2, "You are in range of public garage ID %i", id);
	}
	if((id = GetNearbyGG(playerid)) >= 0)
	{
		SM(playerid, COLOR_GREY2, "You are in range of Gang garage ID %i", id);
	}
	return 1;
}

CMD:dynamichelp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Houses:"WHITE" /createhouse, /edithouse, /removehouse, /gotohouse, /asellhouse, /removefurniture.");
	SendClientMessage(playerid, SERVER_COLOR, "ATM"WHITE" /createatm, /gotoatm, /removeatm");
	SendClientMessage(playerid, SERVER_COLOR, "Garages:"WHITE" /creategarage, /editgarage, /removegarage, /gotogarage, /asellgarage.");
    SendClientMessage(playerid, SERVER_COLOR, "Business:"WHITE" /createbiz, /editbiz, /removebiz, /gotobiz, /asellbiz.");
	SendClientMessage(playerid, SERVER_COLOR, "Entrances:"WHITE" /createentrance, /editentrance, /removeentrance, /gotoentrance.");
	SendClientMessage(playerid, SERVER_COLOR, "Points:"WHITE" /createpoint, /editpoint, /removepoint, /gotopoint.");
    SendClientMessage(playerid, SERVER_COLOR, "Turfs:"WHITE" /createturf, /turfcancel, /editturf, /removeturf, /gototurf.");
	SendClientMessage(playerid, SERVER_COLOR, "Fires:"WHITE" /randomfire, /killfire, /spawnfire.");

	return 1;
}

CMD:atm(playerid, params[])
{
	for(new i = 0; i < sizeof(atmMachines); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ]))
		{
			ShowDialogToPlayer(playerid, DIALOG_ATM);
		}
		if(GetNearbyAtm(playerid) >= 0)
		{
			ShowDialogToPlayer(playerid, DIALOG_ATM);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any ATM machines.");
	return 1;
}

CMD:asellhouse(playerid, params[])
{
	new houseid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /asellhouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid house.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell a house to a player, bobo!", GetRPName(playerid));
	}

	SetHouseOwner(houseid, INVALID_PLAYER_ID);
	SM(playerid, COLOR_AQUA, "** You have admin sold house %i.", houseid);
	return 1;
}

CMD:asellgarage(playerid, params[])
{
	new garageid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /asellgarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid garage.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell a garage to a player, bobo!", GetRPName(playerid));
	}

	SetGarageOwner(garageid, INVALID_PLAYER_ID);
	SM(playerid, COLOR_AQUA, "** You have admin sold garage %i.", garageid);
	return 1;
}

CMD:asellbiz(playerid, params[])
{
	new businessid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /asellbiz [businessid]");
	}
	if(!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid business.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell a biz to a player, bobo!", GetRPName(playerid));
	}

	SetBusinessOwner(businessid, INVALID_PLAYER_ID);
	SM(playerid, COLOR_AQUA, "** You have admin sold business %i.", businessid);
	return 1;
}

#define MAX_GAS_CANS 100 // Adjust this value as needed

new Float:GasCans[MAX_GAS_CANS][4];
          
new gasCount = 0; 

CMD:gascanplace132(playerid)
{
    new
        Float:x, Float:y, Float:z, Float:angle,
        inte, w, gasCanObject;

	if(PlayerInfo[playerid][pGasCan] == 0)
	{
        return SendClientMessage(playerid, COLOR_SYNTAX, "You Dont have A gas Can!");
	}
	if(PlayerInfo[playerid][pGasplace] > 3)
	{
        return SendClientMessage(playerid, COLOR_SYNTAX, "You Already Placed 3 Gascan");
	}
	if(IsPlayerInDynamicArea(playerid,GZArea[0]))
	{
	     return SendClientMessage(playerid, COLOR_SYNTAX, "You are In safezone");
	}
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
   
    inte = GetPlayerInterior(playerid);
    w = GetPlayerVirtualWorld(playerid);

  

    gasCanObject = CreateDynamicObject(1650, x + 0.6, y + 0.6, z - 0.6, 0.0, 0.0, angle, w, inte);

    if(gasCanObject != INVALID_OBJECT_ID)
    {
        
        GasCans[gasCount][0] = x;
        GasCans[gasCount][1] = y;
        GasCans[gasCount][2] = z;
        GasCans[gasCount][3] = gasCanObject;
        gasCount++;

        SendClientMessage(playerid, COLOR_LIGHTGREEN, "Gas can Placed!");
    }
    PlayerInfo[playerid][pGasplace] ++;
    PlayerInfo[playerid][pGasCan] -= 1;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
    return 1;
}
CMD:join(playerid, params[])
{
	for(new i = 0; i < sizeof(jobLocations); i ++)
	{
		if(!Job_IsEnabled(i))
		{
			continue;
		}

	    if(IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
	    {
			if(!Job_CanJoin(playerid, i))
			{
				return 1;
			}

	        if(PlayerInfo[playerid][pJob] != JOB_NONE)
	        {
	            if(PlayerInfo[playerid][pVIPPackage] >= 1)
	        	{
	        	    if(PlayerInfo[playerid][pSecondJob] != JOB_NONE)
	        	    {
	        	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have two jobs already. Please quit one of them before getting another one.");
	        	    }
	        	    if(PlayerInfo[playerid][pJob] == i)
	        	    {
	        	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this job already.");
	        	    }

	        	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = %i WHERE uid = %i", i, PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					PlayerInfo[playerid][pSecondJob] = i;
					SM(playerid, COLOR_AQUA, "You are now a "SVRCLR"%s{CCFFFF}. Use /jobhelp for a list of commands related to your new job.", jobLocations[i][jobName]);
	            }
	            else
	            {
	            	SendClientMessage(playerid, COLOR_SYNTAX, "You have a job already. Please quit your current job before getting another one.");
				}

				return 1;
			}

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET job = %i WHERE uid = %i", i, PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			PlayerInfo[playerid][pJob] = i;
			SM(playerid, COLOR_AQUA, "You are now a "SVRCLR"%s{CCFFFF}. Use /jobhelp for a list of commands related to your new job.", jobLocations[i][jobName]);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any job icon.");
	return 1;
}

CMD:usegascan(playerid, params[])
{
    new nearestInjuredPlayer = INVALID_PLAYER_ID;
    new Float:minDistance = 5.0; // Set the minimum distance
    new foundInjuredPlayer = false;

    foreach(new i :Player)
    {
        if (PlayerInfo[i][pInjured] && playerid != i)
        {
           
            if (IsPlayerInRangeOfPlayer(playerid, i, minDistance))
            {
                nearestInjuredPlayer = i;
                foundInjuredPlayer = true;
                break; 
            }
        }
    }


    if (!foundInjuredPlayer)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no injured players in range.");
    }


    if (PlayerInfo[playerid][pGasCan] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least 5 liters of petrol.");
    }

    PlayerInfo[nearestInjuredPlayer][pGased] = true;
    PlayerInfo[nearestInjuredPlayer][pGased1] = true;
    PlayerInfo[playerid][pGasCan] -= 5;

    // Send a proximity message
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s starts to gasoil %s.", GetRPName(playerid), GetRPName(nearestInjuredPlayer));

    // Set timers for additional effects
    SetTimerEx("ani", 10000, false, "i", nearestInjuredPlayer);

    // Update the database with the new gascan value
  // Adjusted buffer size to prevent overflow
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    return 1;
}


forward ani(playerid);
public ani(playerid)
{
    ApplyAnimationEx(playerid, "SHOP", "SHP_Prt1", 4.0, 0, 0, 0, 0, 0);
    SetPlayerAttachedObject(playerid, 1, 18712, 2, 0.198999, 0.011000, -1.566999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);

    return 1;
}
forward Burn(targetid);
public Burn(targetid)
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Crack = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET flower = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dryflower = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET walkietalkie = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weaponclip = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingRod = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingbait = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET muriaticAcid = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bakingSoda = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hpammo = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET candy = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fmjammo = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET poisonammo = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bandage = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    PlayerInfo[targetid][pDirtyCash] = 0;
    PlayerInfo[targetid][pPainkillers] = 0;
    PlayerInfo[targetid][pMeth] = 0;
    PlayerInfo[targetid][pCrack] = 0;
    PlayerInfo[targetid][pPot] = 0;
    PlayerInfo[targetid][pWalkieTalkie] = 0;
	PlayerInfo[targetid][pRope] = 0;
	PlayerInfo[targetid][pWatch] = 0;
	PlayerInfo[targetid][pGPS] = 0;
	PlayerInfo[targetid][pWeaponClip] = 0;
	PlayerInfo[targetid][pFishingRod] = 0;
	PlayerInfo[targetid][pFishingBait] = 0;
	PlayerInfo[targetid][pMaterials] = 0;
	PlayerInfo[targetid][pEphedrine] = 0;
	PlayerInfo[targetid][pCigars] = 0;
	PlayerInfo[targetid][pSpraycans] = 0;
	PlayerInfo[targetid][pSeeds] = 0;
	PlayerInfo[targetid][pMuriaticAcid] = 0;
	PlayerInfo[targetid][pBakingSoda] = 0;
	PlayerInfo[targetid][pHPAmmo] = 0;
	PlayerInfo[targetid][pFMJAmmo] = 0;
	PlayerInfo[targetid][pPoisonAmmo] = 0;
	PlayerInfo[targetid][pDrink] = 0;
	PlayerInfo[targetid][pDiamonds] = 0;
    PlayerInfo[targetid][pGasCan] = 0;
	PlayerInfo[targetid][pDrink] = 0;


    RemovePlayerAttachedObject(targetid, 0);
    RemovePlayerAttachedObject(targetid, 1);
    RemovePlayerAttachedObject(targetid, 3);
    RemovePlayerAttachedObject(targetid, 4);
    RemovePlayerAttachedObject(targetid, 5);
    RemovePlayerAttachedObject(targetid, 6);
    RemovePlayerAttachedObject(targetid, 7);
    RemovePlayerAttachedObject(targetid, 8);
    RemovePlayerAttachedObject(targetid, 9);
    RemovePlayerAttachedObject(targetid, 10);
    PlayerInfo[targetid][pGased1] = false;
    TogglePlayerControllable(targetid, 1);
    SetPlayerHealth(targetid, 100.0);
    SetPlayerVirtualWorld(targetid, 0);
    ClearAnimations(targetid, SYNC_ALL);
    SetPlayerPos(targetid, 2026.148193, -1422.461303, 17.992187);
    ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);
	
	
	for(new td = 0; td < 4; td ++)
	{
		PlayerTextDrawHide(targetid, DEATH[targetid][td]);
	}
    for(new i = 0; i < 15; i++)
    {
       TextDrawHideForPlayer(targetid, DEATHBUTTON[i]);
    }
   	PlayerTextDrawHide(targetid, DEATHBUTTONP[targetid][0]);
    CancelSelectTextDraw(targetid);

	SendClientMessage(targetid, COLOR_YELLOW, "You have been Respawned");
	SendClientMessage(targetid, COLOR_YELLOW, "You have lost 30 minutes of your memory.");
    return 1;
}



forward Burn3(playerid);
public Burn3(playerid)
{
	RemovePlayerAttachedObject(playerid, 0);
	RemovePlayerAttachedObject(playerid, 1);
	RemovePlayerAttachedObject(playerid, 2);
	RemovePlayerAttachedObject(playerid, 3);
	RemovePlayerAttachedObject(playerid, 4);
	RemovePlayerAttachedObject(playerid, 5);
	RemovePlayerAttachedObject(playerid, 6);
	RemovePlayerAttachedObject(playerid, 7);
	RemovePlayerAttachedObject(playerid, 8);
	RemovePlayerAttachedObject(playerid, 9);
	RemovePlayerAttachedObject(playerid, 10);
	ClearAnimations(playerid, SYNC_ALL);
    SetPlayerAttachedObject(playerid, 0, 18688, 2, 0.198999, 0.011000, -1.566999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
    return 1;
}
