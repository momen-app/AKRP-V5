forward Graffiti_Load();
public Graffiti_Load()
{
	static
	    rows,
	    fields;

	SQL_GetCacheData(rows, fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_GRAFFITI_POINTS)
	{
	    SQL_GetString(i, "graffitiText", GraffitiData[i][graffitiText], 64);

    	GraffitiData[i][graffitiExists] = 1;
	    GraffitiData[i][graffitiID] = SQL_GetInt(i, "graffitiID");
	    GraffitiData[i][graffitiPos][0] = SQL_GetFloat(i, "graffitiX");
	    GraffitiData[i][graffitiPos][1] = SQL_GetFloat(i, "graffitiY");
	    GraffitiData[i][graffitiPos][2] = SQL_GetFloat(i, "graffitiZ");
	    GraffitiData[i][graffitiPos][3] = SQL_GetFloat(i, "graffitiAngle");
	    GraffitiData[i][graffitiColor] = SQL_GetInt(i, "graffitiColor");

		Graffiti_Refresh(i);
	}
	return 1;
}
public OnPlayerTeleport(playerid, Float:distance)
{
	if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked] && InsideTut[playerid] == 0)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]))
	    {
		    PlayerInfo[playerid][pACWarns]++;

		    if(PlayerInfo[playerid][pACWarns] < 3)
		    {
	    	    SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport hacking (distance: %.1f).", GetRPName(playerid), playerid, distance);
	            new szString[128];
				format(szString, sizeof(szString),"%s (uid: %i) possibly teleport hacked (distance: %.1f)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], distance);
    			SendDiscordMessage(2, szString);
				////Log_Write("log_cheat", "%s (uid: %i) possibly teleport hacked (distance: %.1f)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], distance);
			}
			else
			{
		    	SAM(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Teleport hacks", GetRPName(playerid), SERVER_BOT);
		    	KickPlayer(playerid);
			}
		}
	}

	return 1;
}
FormatNumber(number, money = 1)
{
	new length, value[32];

	format(value, sizeof(value), "%i", (number < 0) ? (-number) : (number));

	length = strlen(value);

    if(length > 3)
	{
  		for(new l = 0, i = length; --i >= 0; l ++)
		{
		    if((l % 3 == 0) && l > 0)
		    {
				strins(value, ",", i + 1);
			}
		}
	}

	if(money)
		strins(value, "$", 0);
	if(number < 0)
		strins(value, "-", 0);

	return value;
}

stock CountTaxiDrivers()
{
	new count = 0;
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pTaxiFare] > 0)
		{
			count ++;
		}
	}
	return count;
}
stock CountDownForPlayer(playerid, const StartMessage[30], const EndMessage[30],  Seconds)
{
	if(CD[playerid][CDUsed] == 1) return print("CountDown ERROR: The function is already being used for this player!");
	if(strlen(EndMessage) > 30) return print("CountDown ERROR: End Message is too long!");
	if(strlen(StartMessage) > 30) return print("CountDown ERROR: End Message is too long!");
	if(Seconds < 0 ) return print("CountDown ERROR: Negative amount of seconds.");
	CD[playerid][cdem] = StartMessage;
	CD[playerid][cdem1] = EndMessage;
	CD[playerid][cds] = Seconds;
	CDTimer[playerid] = SetTimerEx("CountDP", 1000, true, "i", playerid);
	CD[playerid][CDUsed] = 1;
	return 1;
}

public CountDP(playerid)
{
    new string[128]; // Adjust buffer size as needed
    if(CD[playerid][cds] != 0)
    {
        format(string, sizeof(string), "%s %d %s", CD[playerid][cdem], CD[playerid][cds], CD[playerid][cdem1] ); // "FIXING" in yellow, rest in white
        GameTextForPlayer(playerid, string, 1000, 3);
        CD[playerid][cds]--;
    }
    else
    {
        KillTimer(CDTimer[playerid]);
        CD[playerid][CDUsed] = 0;
    }
    return 1;
}

stock Waypoint_Set(playerid, name[], Float:x, Float:y, Float:z)
{
    format(PlayerInfo[playerid][pLocation], 32, name);

    PlayerInfo[playerid][pWaypoint] = 1;
   	PlayerInfo[playerid][pWaypointPos][0] = x;
    PlayerInfo[playerid][pWaypointPos][1] = y;
   	PlayerInfo[playerid][pWaypointPos][2] = z;

	SetPlayerCheckpoint(playerid, x, y, z, 3.0);
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pTextdraws][1]);

	return 1;
}

stock AvailableColors(TColor[])
{
    if(strcmp(TColor,"r", true) == 0) return 1;
    if(strcmp(TColor,"g", true) == 0) return 1;
    if(strcmp(TColor,"b", true) == 0) return 1;
    if(strcmp(TColor,"w", true) == 0) return 1;
    if(strcmp(TColor,"y", true) == 0) return 1;
    if(strcmp(TColor,"p", true) == 0) return 1;
    if(strcmp(TColor,"l", true) == 0) return 1;
    if(strcmp(TColor,"h", true) == 0) return 1;
    else return 0;
}

stock DisableWaypoint(playerid)
{
    if (PlayerInfo[playerid][pWaypoint])
	{
 		PlayerInfo[playerid][pWaypoint] = 0;

 		DisablePlayerCheckpoint(playerid);
  		PlayerTextDrawHide(playerid, PlayerInfo[playerid][pTextdraws][1]);
	}
	return 1;
}

public TimerWashMoney(playerid)
{
    new madumi = PlayerInfo[playerid][pDirtyCash];
	new bawas = (madumi/100)*25; // 3 discount percent
 	new total = madumi-bawas;

 	SM(playerid, COLOR_WHITE, "You washed your money and earn %i.", total);
 	SendClientMessage(playerid, -1, "You are done washing the dirty money, it's time for you to go or else cops will arrest you.");

	PlayerInfo[playerid][pDirtyCash] -= madumi;
	GivePlayerCash(playerid, total);

    TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid, SYNC_ALL);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

public TimerSelfRepair(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RepairVehicle(vehicleid);
    SendClientMessage(playerid, COLOR_WHITE, "You have repaired the vehicle you're riding...");
    TogglePlayerControllable(playerid, true);
    GivePlayerCash(playerid, -1500);
	SetVehicleHealth(vehicleid, 1000.0);
	PlayerTextDrawTextSize(playerid, PROGRESS1[playerid][1], 0.699, 16.790);
	PlayerTextDrawColour(playerid, PROGRESS1[playerid][1], 0xFF0000FF);
	PlayerTextDrawHide(playerid, PROGRESS1[playerid][0]);
	PlayerTextDrawHide(playerid, PROGRESS1[playerid][1]);
	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s successfully repaired his/her vehicle.", GetRPName(playerid));
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

public OnPlayerAirbreak(playerid)
{
	if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
	{
	    if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
	    {
	        SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using airbreak hacks.", GetRPName(playerid), playerid);
	        ////Log_Write("log_cheat", "%s (uid: %i) possibly used airbreak.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
  			new szString[128];
			format(szString, sizeof(szString),   "%s (uid: %i) possibly used airbreak.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
			SendDiscordMessage(2, szString);
		}
		else
		{
			SAM(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Air Break", GetRPName(playerid), SERVER_BOT);
		    KickPlayer(playerid);
		}
	}
	return 1;
}

IsAMotorBike(carid)
{
	switch(GetVehicleModel(carid)) {
		case 509, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

forward BotRepair(playerid); 
public BotRepair(playerid)
{
        new vehicleid = GetPlayerVehicleID(playerid);
        RepairVehicle(vehicleid);
        SendClientMessage(playerid, COLOR_WHITE, "You have repaired the health and bodywork on this vehicle..for $18000");
		GivePlayerCash(playerid, -40000);
        PlayerInfo[playerid][pRepairing] = 0;
        SetVehicleHealth(vehicleid, 1000.0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %s repairs the vehicle.", GetRPName(playerid));
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
       	PlayerTextDrawTextSize(playerid, PROGRESS1[playerid][1], 0.699, 16.790);
	    PlayerTextDrawColour(playerid, PROGRESS1[playerid][1], 0xFF0000FF);
		PlayerTextDrawHide(playerid, PROGRESS1[playerid][0]);
		PlayerTextDrawHide(playerid, PROGRESS1[playerid][1]);
        SendClientMessage(playerid, COLOR_YELLOW, "The vehicles has been repaired by an Mech Bot");
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} Mech Bot  successfully Repaired %s Vehicle.", GetRPName(playerid));

        return 1;
}
forward SetScriptSkin(playerid, skinid);
public SetScriptSkin(playerid, skinid)
{
    SetPlayerSkin(playerid, skinid);
    PlayerInfo[playerid][pSkin] = skinid;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
}

forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);
	pCBugging[playerid] = false;
	return 1;
}

ResetPlayerVariables(playerid)
{
	pCBugging[playerid] = false;
	KillTimer(ptmCBugFreezeOver[playerid]);
	ptsLastFiredWeapon[playerid] = 0;
	return 1;
}

GetDate()
{
	new date[5], datestring[24];

	getdate(date[0], date[1], date[2]);
	gettime(date[3], date[4]);

	format(datestring, sizeof(datestring), "%i-%02d-%02d %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
	return datestring;
}

GetAdminDivisionFull(playerid)
{
    new division[32];
	if(PlayerInfo[playerid][pFactionMod])
	{
	    division = "Faction Moderator";
	}
	else if(PlayerInfo[playerid][pGangMod])
	{
	    division = "Gang Moderator";
	}
	else if(PlayerInfo[playerid][pBanAppealer])
	{
	    division = "Ban Appealer";
	}
	else
	{
	    division = "";
	}
    return division;
}

GetStaffRank2(playerid)
{
	new string[24];

	if(PlayerInfo[playerid][pAdmin] > 1)
	{
		switch(PlayerInfo[playerid][pAdmin])
		{
			case 1: string = "[A1]";
		    case 2: string = "[A2]";
		    case 3: string = "[A3]";
		    case 4: string = "[A4]";
			case 5: string = "[A5]";
			case 6: string = "[A6]";
			case 7: string = "[A7]";
			case 8: string = "[A8]";
            case 9: string = "[NS]";
		}
		return string;
	}
	if(PlayerInfo[playerid][pHelper] > 0)
	{
    	switch(PlayerInfo[playerid][pHelper])
    	{
			case 1: string = "[H1]";
			case 2: string = "[H2]";
			case 3: string = "[H3]";
			case 4: string = "[H4]";
		}
	}
	else if(PlayerInfo[playerid][pFormerAdmin])
	{
	    string = "[FA]";
	}
	return string;
}

GetAdminDivision(playerid)
{
	new division[4];
	if(PlayerInfo[playerid][pFactionMod])
	{
	    division = "FM";
	}
	else if(PlayerInfo[playerid][pGangMod])
	{
	    division = "GM";
	}
	else if(PlayerInfo[playerid][pBanAppealer])
	{
	    division = "BA";
	}
	else
	{
	    division = "";
	}
	return division;
}

GetAdminRank2(playerid)
{
    new string[128]; // Increased size to accommodate multi-color strings

    switch(PlayerInfo[playerid][pAdmin])
    {
        case 1: string = "{808080}[1-{C0C0C0}HID{808080}]";  // Grey for outer, Silver for "HID" (Hidden Admin)
        case 2: string = "{00FF00}[2-{00FA9A}JUN{00FF00}]";  // Green for outer, Medium Spring Green for "JUN" (Junior Admin)
        case 3: string = "{0000FF}[3-{1E90FF}GEN{0000FF}]";  // Blue for outer, Dodger Blue for "GEN" (General Admin)
        case 4: string = "{FFD700}[4-{FFA500}SNR{FFD700}]";  // Gold for outer, Orange for "SNR" (Senior Admin)
        case 5: string = "{FFA500}[5-{FF4500}CHF{FFA500}]";  // Orange for outer, Orange Red for "CHF" (Chief Admin)
        case 6: string = "{FF69B4}[6-{FF1493}TOP{FF69B4}]";  // Pink for outer, Deep Pink for "TOP" (Top Leader)
        case 7: string = "{800080}[7-{DA70D6}ASM{800080}]";  // Purple for outer, Orchid for "ASM" (Assistant Manager)
        case 8: string = "{FFFF00}[8-{FFD700}MGR{FFFF00}]";  // Yellow for outer, Gold for "MGR" (Manager)
        case 9: string = "{8B0000}[9-{B22222}HCL{8B0000}]";  // Dark Red for outer, Fire Brick for "HCL" (High Council)
        case 10: string = "{4B0082}[10-{9400D3}SUP{4B0082}]";// Indigo for outer, Dark Violet for "SUP" (Supreme Council)
        case 11: string = "{00CED1}[11-{48D1CC}EXE{00CED1}]";// Dark Turquoise for outer, Medium Turquoise for "EXE" (Executive Director)
        case 12: string = "{DC143C}[12-{FF6347}GMS{DC143C}]";// Crimson for outer, Tomato for "GMS" (Grandmaster)
    }

    return string;
}



GetAdminRank(playerid)
{
	new string[35];

    switch(PlayerInfo[playerid][pAdmin])
    {
        case 1: string = "Hidden Admin";
        case 2: string = "Junior Admin";
        case 3: string = "General Admin";
        case 4: string = "Senior Admin";
        case 5: string = "Chief Admin";
        case 6: string = "Top Leader";
        case 7: string = "Assistant Manager";
        case 8: string = "Manager";
        case 9: string = "High Council";
        case 10: string = "Supreme Council";
        case 11: string = "Executive Director";
        case 12: string = "Grandmaster";
    }
	return string;
}

GetColorARank(playerid)
{
    new string[128];

    switch(PlayerInfo[playerid][pAdmin])
    {    // White
        case 1: string = "{808080}[1-HID] Hidden Admin";        // Grey
        case 2: string = "{00FF00}[2-JUN] Junior Admin";        // Green
        case 3: string = "{D900C8}[3-GEN] General Admin";       // Purple
        case 4: string = "{FFFF00}[4-SNR] Senior Admin";        // Yellow
        case 5: string = "{EE9A4D}[5-CHF] Chief Admin";         // Orange
        case 6: string = "{FF69B4}[6-TOP] Top Leader";          // Pink
        case 7: string = "{800080}[7-ASM] Assistant Manager";   // Purple
        case 8: string = "{FFFF00}[8-MGR] Manager";             // Yellow
        case 9: string = "{8B0000}[9-HCL] High Council";        // Dark Red
        case 10: string = "{4B0082}[10-SUP] Supreme Council";   // Indigo
        case 11: string = "{00CED1}[11-EXE] Executive Director";// Dark Turquoise
        case 12: string = "{DC143C}[12-GMS] Grandmaster";       // Crimson
    }

    return string;
}

GetHelperRank(playerid)
{
	new string[24];

	switch(PlayerInfo[playerid][pHelper])
	{
	    case 0: string = "None";
	    case 1: string = "Junior Helper";
	    case 2: string = "General Helper";
	    case 3: string = "Senior Helper";
	    case 4: string = "Head Helper";
	}

	return string;
}

GetPlayerIP(playerid)
{
	new
 	   ip[16];

	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

GetPlayerIPRange(playerid, ch = '*')
{
	new string[16], part[2];

	if(!sscanf(GetPlayerIP(playerid), "p<.>ii{ii}", part[0], part[1]))
	{
	    format(string, sizeof(string), "%i.%i.%c.%c", part[0], part[1], ch, ch);
	}

	return string;
}

GetDeathReason(reason)
{
	new
	    string[24];

	switch(reason)
	{
	    case 0: string = "Fists";
	    case 18: string = "Molotov Cocktail";
	    case 44: string = "Nightvision Goggles";
	    case 45: string = "Infrared Goggles";
	    case 49: string = "Vehicle";
	    case 50: string = "Helicopter Blades";
	    case 51: string = "Explosion";
	    case 53: string = "Drowned";
	    case 54: string = "Splat";
	    default: GetWeaponName(reason, string, sizeof(string));
	}

	return string;
}

GetWeaponNameEx(weaponid)
{
	new
	    weapon[24];

	GetWeaponName(weaponid, weapon, sizeof(weapon));

	switch(weaponid)
	{
	    case 0: weapon = "None";
	    case 18: weapon = "Molotov Cocktail";
	    case 44: weapon = "Nightvision Goggles";
	    case 45: weapon = "Infrared Goggles";
	}

	return weapon;
}

GetDonatorRank(level)
{
	new string[16];

	switch(level)
	{
	    case 0: string = "None";
	    case 1: string = "Gold";
	    case 2: string = "Diamond";
	    case 3: string = "Platinum";
	}

	return string;
}

GetJobName(jobid)
{
	new
	    name[32];

	if(jobid == JOB_NONE)
	    name = "None";
	else if(!(0 <= jobid < sizeof(jobLocations)))
	    name = "Unknown";
	else
		strcat(name, jobLocations[jobid][jobName]);

	return name;
}

IncreaseJobSkill(playerid, jobid)
{
	if((gDoubleXP) || PlayerInfo[playerid][pDoubleXP] > 0)
	{
	    GiveJobSkill(playerid, jobid);
	}

	GiveJobSkill(playerid, jobid);
}

GiveJobSkill(playerid, jobid)
{
	new level = GetJobLevel(playerid, jobid);

	switch(jobid)
	{
		case JOB_COURIER:
		{
		    PlayerInfo[playerid][pCourierSkill]++;

	    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET courierskill = courierskill + 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			if(GetJobLevel(playerid, jobid) != level)
			{
			    SM(playerid, COLOR_YELLOW, "Your trucker skill level is now %i/5. You will deliver more products and earn more money now.", level + 1);
			}
		}
	
	}
}

GetJobLevel(playerid, jobid)
{
	if(jobid == JOB_COURIER)
	{
	    if(0 <= PlayerInfo[playerid][pCourierSkill] <= 49) {
	        return 1;
		} else if(50 <= PlayerInfo[playerid][pCourierSkill] <= 99) {
			return 2;
		} else if(100 <= PlayerInfo[playerid][pCourierSkill] <= 199) {
			return 3;
		} else if(200 <= PlayerInfo[playerid][pCourierSkill] <= 349) {
			return 4;
		} else if(PlayerInfo[playerid][pCourierSkill] >= 350) {
		    return 5;
		}
	}

	return 0;
}

GetPlayerCapacity(playerid, item)
{
	switch(item)
	{
	    case CAPACITY_MATERIALS:
	    {
	        return 100000 + (PlayerInfo[playerid][pInventoryUpgrade] * 10000);
		}
		case CAPACITY_WEED:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
		    {
		        case 0: return 50;
		        case 1: return 75;
		        case 2: return 100;
		        case 3: return 125;
		        case 4: return 150;
		        case 5: return 200;
			}
		}
		case CAPACITY_COCAINE:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
     		{
		        case 0: return 25;
		        case 1: return 50;
		        case 2: return 75;
		        case 3: return 100;
		        case 4: return 125;
		        case 5: return 150;
			}
		}
		case CAPACITY_METH:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
     		{
		        case 0: return 40;
		        case 1: return 60;
		        case 2: return 70;
		        case 3: return 80;
		        case 4: return 100;
		        case 5: return 150;
			}
		}
        case CAPACITY_PAINKILLERS:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
     		{
		        case 0: return 30;
		        case 1: return 35;
		        case 2: return 40;
		        case 3: return 45;
		        case 4: return 50;
		        case 5: return 55;
			}
		}
		case CAPACITY_SEEDS:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
     		{
		        case 0: return 10;
		        case 1: return 20;
		        case 2: return 30;
		        case 3: return 40;
		        case 4: return 50;
		        case 5: return 60;
			}
		}
		case CAPACITY_EPHEDRINE:
		{
		    switch(PlayerInfo[playerid][pInventoryUpgrade])
     		{
		        case 0: return 10;
		        case 1: return 15;
		        case 2: return 20;
		        case 3: return 25;
		        case 4: return 30;
		        case 5: return 40;
			}
		}
		case CAPACITY_HPAMMO:
		{
		    return 60;
		}
        case CAPACITY_POISONAMMO:
		{
		    return 60;
		}
        case CAPACITY_FMJAMMO:
		{
      		return 60;
		}
	}
	return 0;
}

GetPlayerAssetCount(playerid, type)
{
	new count;

	switch(type)
	{
	    case LIMIT_HOUSES:
	    {
	        for(new i = 0; i < MAX_HOUSES; i ++)
	        {
	            if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
	            {
	                count++;
				}
			}
		}
		case LIMIT_BUSINESSES:
	    {
	        for(new i = 0; i < MAX_BUSINESSES; i ++)
	        {
	            if(BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
	            {
	                count++;
				}
			}
		}
		case LIMIT_GARAGES:
	    {
	        for(new i = 0; i < MAX_GARAGES; i ++)
	        {
	            if(GarageInfo[i][gExists] && IsGarageOwner(playerid, i))
	            {
	                count++;
				}
			}
		}
	}

	return count;
}

GetPlayerAssetLimit(playerid, type)
{
	switch(type)
	{
	    case LIMIT_HOUSES:
	    {
	        switch(PlayerInfo[playerid][pVIPPackage])
			{
			    case 2: return 4;
			    case 3: return 6;
			}

			switch(PlayerInfo[playerid][pAssetUpgrade])
			{
			    case 0, 1: return 1;
			    case 2, 3: return 2;
			    case 4: return 3;
			}
		}
		case LIMIT_BUSINESSES:
	    {
			switch(PlayerInfo[playerid][pAssetUpgrade])
			{
			    case 0, 1: return 1;
			    case 2, 3: return 2;
			    case 4: return 3;
			}
		}
		case LIMIT_GARAGES:
	    {
			switch(PlayerInfo[playerid][pAssetUpgrade])
			{
			    case 0, 1: return 1;
			    case 2, 3: return 2;
			    case 4: return 3;
			}
		}
        case LIMIT_VEHICLES:
	    {
            switch(PlayerInfo[playerid][pVIPPackage])
			{
			    case 1: return 10;
			    case 2: return 15;
			    case 3: return 20;
			}

	        switch(PlayerInfo[playerid][pAssetUpgrade])
	        {
	            case 0: return 3;
	            case 1: return 4;
	            case 2: return 5;
	            case 3: return 7;
	            case 4: return 10;
			}
		}
	}

	return 0;
}      

DeployObject(type, Float:x, Float:y, Float:z, Float:angle)
{
	for(new i = 0; i < MAX_DEPLOYABLES; i ++)
	{
	    if(!DeployInfo[i][dExists])
	    {
			DeployInfo[i][dExists] = 1;
            DeployInfo[i][dType] = type;
            DeployInfo[i][dPosX] = x;
            DeployInfo[i][dPosY] = y;
            DeployInfo[i][dPosZ] = z;
            DeployInfo[i][dPosA] = angle;

            if(type == DEPLOY_SPIKESTRIP) {
                DeployInfo[i][dObject] = CreateDynamicObject(2899, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 0.9, 0.0, 0.0, angle + 90.0);
            } else if(type == DEPLOY_CONE) {
                DeployInfo[i][dObject] = CreateDynamicObject(1238, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 0.7, 0.0, 0.0, angle);
	        } else if(type == DEPLOY_ROADBLOCK) {
	            DeployInfo[i][dObject] = CreateDynamicObject(981, x + 3.0 * floatsin(-angle, degrees), y + 3.0 * floatcos(-angle, degrees), z, 0.0, 0.0, angle);
			} else if(type == DEPLOY_BARREL) {
			    DeployInfo[i][dObject] = CreateDynamicObject(1237, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 1.0, 0.0, 0.0, angle);
			} else if(type == DEPLOY_FLARE) {
			    DeployInfo[i][dObject] = CreateDynamicObject(18728, x, y, z - 1.4, 0.0, 0.0, angle);
			}

			return i;
		}
	}

	return -1;
}

IsFireActive()
{
	for(new i = 0; i < MAX_FIRES; i ++)
	{
	    if(IsValidDynamicObject(gFireObjects[i]))
	    {
	        return 1;
		}
	}

	return 0;
}

IsAOilExpoCar(carid)
{
	for(new v = 0; v < sizeof(OilExpoVehicle); v++)
	{
	    if(carid == OilExpoVehicle[v]) return 1;
	}
	if(VehicleInfo[carid][vJob] == JOB_OILEXPO) return 1;
	return 0;
}
IsAFruitCar(carid)
{
	for(new v = 0; v < sizeof(Picker); v++)
	{
	    if(carid == Picker[v]) return 1;
	}
	if(VehicleInfo[carid][vJob] == 10) return 1;
	return 0;
}

IsAFarmerCar(carid)
{
	for(new v = 0; v < sizeof(FarmerVehicles); v++)
	{
	    if(carid == FarmerVehicles[v]) return 1;
	}
	if(VehicleInfo[carid][vJob] == JOB_FARMER) return 1;
	return 0;
}

IsACourierCar(carid)
{
	for(new v = 0; v < sizeof(courierVehicles); v++)
	{
	    if(carid == courierVehicles[v]) return 1;
	}
	if(VehicleInfo[carid][vJob] == JOB_COURIER) return 1;
	return 0;
}



HandleContract(playerid, killerid)
{
    if(GetFactionType(killerid) == FACTION_HITMAN && PlayerInfo[killerid][pContractTaken] == playerid)
	{
	    new price = PlayerInfo[playerid][pContracted],
	    	price2 = price / 2;

	    SM(killerid, COLOR_YELLOW, "You have completed your contract on %s and received $%i.", GetRPName(playerid), price2);
	    SM(playerid, COLOR_YELLOW, "You have been killed by a hitman and lost $%i.", price2);

	    GivePlayerCash(playerid, -price2);
	    GivePlayerCash(killerid, price2);

	    PlayerInfo[killerid][pContractTaken] = INVALID_PLAYER_ID;
	    PlayerInfo[killerid][pCompletedHits]++;
	    PlayerInfo[playerid][pContracted] = 0;
	    PlayerInfo[playerid][pContractBy] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET contracted = 0, contractby = 'Nobody' WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET completedhits = %i WHERE uid = %i", PlayerInfo[killerid][pCompletedHits], PlayerInfo[killerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pContractTaken] == playerid)
            {
                PlayerInfo[i][pContractTaken] = INVALID_PLAYER_ID;
			}
		}
	}
	else if(PlayerInfo[playerid][pContractTaken] == killerid)
	{
	    new price = PlayerInfo[killerid][pContracted];

	    SM(playerid, COLOR_YELLOW, "You have failed your contract on %s and lost $%i.", GetRPName(playerid), price);
	    SM(killerid, COLOR_YELLOW, "You have killed a hitman chasing after you and received $%i. The contract on your head has been removed.", price);

	    GivePlayerCash(playerid, -price);
	    GivePlayerCash(killerid, price);

	    PlayerInfo[playerid][pContractTaken] = INVALID_PLAYER_ID;
	    PlayerInfo[playerid][pFailedHits]++;
	    PlayerInfo[killerid][pContracted] = 0;
	    PlayerInfo[killerid][pContractBy] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET contracted = 0, contractby = 'Nobody' WHERE uid = %i", PlayerInfo[killerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET failedhits = %i WHERE uid = %i", PlayerInfo[playerid][pFailedHits], PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pContractTaken] == killerid)
            {
                PlayerInfo[i][pContractTaken] = INVALID_PLAYER_ID;
			}
		}
	}
}

GetPlayerNameEx(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}

GetPlayerZoneName(playerid)
{
	new zone[32], Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

 	if(GetInsideHouse(playerid) >= 0)
	    zone = "House";
	else if(GetInsideBusiness(playerid) >= 0)
	    zone = "Business";
	else if(GetInsideGarage(playerid) >= 0)
	    zone = "Garage";
	else if(GetPlayerInterior(playerid))
	    zone = "Interior";
	else
	    strcpy(zone, GetZoneName(x, y, z));

	return zone;
}

GetPlayerPosEx(playerid, &Float:x, &Float:y, &Float:z)
{
	new id;
	if((id = GetInsideHouse(playerid)) >= 0)
	{
	    x = HouseInfo[id][hPosX];
	    y = HouseInfo[id][hPosY];
	    z = HouseInfo[id][hPosZ];
	}
	else if((id = GetInsideBusiness(playerid)) >= 0)
	{
	    x = BusinessInfo[id][bPosX];
	    y = BusinessInfo[id][bPosY];
	    z = BusinessInfo[id][bPosZ];
	}
	else if((id = GetInsideGarage(playerid)) >= 0)
	{
	    x = GarageInfo[id][gPosX];
	    y = GarageInfo[id][gPosY];
	    z = GarageInfo[id][gPosZ];
	}
	else if((id = GetInsideEntrance(playerid)) >= 0)
	{
	    x = EntranceInfo[id][ePosX];
	    y = EntranceInfo[id][ePosY];
	    z = EntranceInfo[id][ePosZ];
	}
	else
	{
	    GetPlayerPos(playerid, x, y, z);
	    return 1;
	}
	return 0;
}

GetVehicleLinkedID(id)
{
    foreach(new i : Vehicle)
    {
        if(VehicleInfo[i][vID] == id)
        {
		 	return i;
    	}
    }

    return INVALID_VEHICLE_ID;
}
GetPlayerLinkedID(id)
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pID] == id)
        {
		 	return i;
    	}
    }

    return INVALID_VEHICLE_ID;
}
GetVehicleZoneName(vehicleid)
{
	new zone[32], Float:x, Float:y, Float:z;

	GetVehiclePos(vehicleid, x, y, z);

	if(GetVehicleVirtualWorld(vehicleid))
	    zone = "Garage";
	else
	    strcpy(zone, GetZoneName(x, y, z));

	return zone;
}

GetZoneName(Float:x, Float:y, Float:z)
{
	new zone[32];

	for(new i = 0; i < sizeof(zoneArray); i ++)
	{
	    if((zoneArray[i][zoneMinX] <= x <= zoneArray[i][zoneMaxX]) && (zoneArray[i][zoneMinY] <= y <= zoneArray[i][zoneMaxY]) && (zoneArray[i][zoneMinZ] <= z <= zoneArray[i][zoneMaxZ]))
	    {
	        strcpy(zone, zoneArray[i][zoneName]);
	        return zone;
	    }
	}

	return zone;
}


PreviewClothing(playerid, index)
{
	new businessid = GetInsideBusiness(playerid);
    if(PlayerInfo[playerid][pCash] < BusinessInfo[businessid][bPrices][1])
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "You can't purchase this. You don't have enough money for it.");
    }
    else
    {
        SetPlayerAttachedObject(playerid, 9, clothingArray[index][clothingModel], clothingArray[index][clothingBone]);

		PlayerInfo[playerid][pEditType] = EDIT_CLOTHING_PREVIEW;
        PlayerInfo[playerid][pSelected] = index;

		SM(playerid, COLOR_GREEN, "You are now previewing "SVRCLR"%s{CCFFFF}. This clothing item costs "SVRCLR"%s{CCFFFF} to purchase.", clothingArray[index][clothingName], FormatNumber(BusinessInfo[businessid][bPrices][1]));
		SM(playerid, COLOR_GREEN, "Use your cursor to control the editor interface. Click the floppy disk to save changes.");
        EditAttachedObject(playerid, 9);
	}
}
AFKCheck(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:cx,
	    Float:cy,
	    Float:cz;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerCameraPos(playerid, cx, cy, cz);

	if(PlayerInfo[playerid][pAFKPos][0] == x && PlayerInfo[playerid][pAFKPos][1] == y && PlayerInfo[playerid][pAFKPos][2] == z && PlayerInfo[playerid][pAFKPos][3] == cx && PlayerInfo[playerid][pAFKPos][4] == cy && PlayerInfo[playerid][pAFKPos][5] == cz)
	{
		PlayerInfo[playerid][pAFKTime]++;

	    if(!PlayerInfo[playerid][pAFK] && PlayerInfo[playerid][pAFKTime] >= 60)
	    {
		    SendClientMessage(playerid, COLOR_WHITE, "You are now marked as "SVRCLR"Away from keyboard"WHITE" as you havent moved in one minute.");
			if(PlayerInfo[playerid][pJailType] > 0)
		    {
		        SendClientMessage(playerid, COLOR_SYNTAX, 
                      "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}| ANTI-EXPLOIT] You were kicked for staying AFK while in prison.");
			    KickPlayer(playerid);
		    }
			else
			PlayerInfo[playerid][pAFK] = 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][pAFK])
		{
		    if(PlayerInfo[playerid][pAFKTime] < 120) {
		    	SM(playerid, COLOR_WHITE, "You are no longer marked as Away from Keyboard after %i seconds.", PlayerInfo[playerid][pAFKTime]);
			} else {
			    SM(playerid, COLOR_WHITE, "You are no longer marked as Away from Keyboard after %i minutes.", PlayerInfo[playerid][pAFKTime] / 60);
			}

			PlayerInfo[playerid][pAFK] = 0;
		}

		PlayerInfo[playerid][pAFKTime] = 0;
	}

	PlayerInfo[playerid][pAFKPos][0] = x;
	PlayerInfo[playerid][pAFKPos][1] = y;
	PlayerInfo[playerid][pAFKPos][2] = z;
	PlayerInfo[playerid][pAFKPos][3] = cx;
	PlayerInfo[playerid][pAFKPos][4] = cy;
	PlayerInfo[playerid][pAFKPos][5] = cz;
}
ShowClothingSelectionMenu(playerid)
{
    new
		models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
		index;

	PlayerInfo[playerid][pClothingIndex] = -1;

	for(new i = 0; i < sizeof(clothingArray); i ++)
    {
        if(!strcmp(clothingArray[i][clothingType], clothingTypes[PlayerInfo[playerid][pCategory]]))
        {
	        if(PlayerInfo[playerid][pClothingIndex] == -1)
	        {
	            PlayerInfo[playerid][pClothingIndex] = i;
			}

	        models[index++] = clothingArray[i][clothingModel];
	    }
	}

	ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHING, clothingTypes[PlayerInfo[playerid][pCategory]], models, index);
}

PurchaseLandObject(playerid, landid, index)
{
    if(PlayerInfo[playerid][pCash] < furnitureArray[index][fPrice])
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "You can't purchase this. You don't have enough money for it.");
    }
    else
    {
        new
            Float:x,
            Float:y,
	        Float:z,
    	    Float:a;

        if(PlayerInfo[playerid][pEditType] == EDIT_LAND_OBJECT_PREVIEW && IsValidDynamicObject(PlayerInfo[playerid][pEditObject])) // Bug fix where if you did '/furniture buy' again while editing your object gets stuck. (12/28/2016)
        {
            DestroyDynamicObject(PlayerInfo[playerid][pEditObject]);
            PlayerInfo[playerid][pEditObject] = INVALID_OBJECT_ID;
		}

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		PlayerInfo[playerid][pEditType] = EDIT_LAND_OBJECT_PREVIEW;
		PlayerInfo[playerid][pEditObject] = CreateDynamicObject(furnitureArray[index][fModel], x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z + 1.0, 0.0, 0.0, ((19353 <= furnitureArray[index][fModel] <= 19417) || (19426 <= furnitureArray[index][fModel] <= 19465)) ? (a + 90.0) : (a), GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		PlayerInfo[playerid][pObjectLand] = landid;
        PlayerInfo[playerid][pSelected] = index;

        UpdateLandText(landid);

		SM(playerid, COLOR_GREEN, "You are now previewing "SVRCLR"%s{CCFFFF}. This object costs "SVRCLR"%s{CCFFFF} to purchase.", furnitureArray[index][fName], FormatNumber(furnitureArray[index][fPrice]));
		SM(playerid, COLOR_GREEN, "Use your cursor to control the editor interface. Click the floppy disk to save changes.");
        EditDynamicObject(playerid, PlayerInfo[playerid][pEditObject]);
	}
}

ShowObjectSelectionMenu(playerid, type)
{
    new
		models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
		index;

	PlayerInfo[playerid][pFurnitureIndex] = -1;

	for(new i = 0; i < sizeof(furnitureArray); i ++)
	{
	    if(!strcmp(furnitureArray[i][fCategory], furnitureCategories[PlayerInfo[playerid][pCategory]]))
	    {
	        if(PlayerInfo[playerid][pFurnitureIndex] == -1)
	        {
	            PlayerInfo[playerid][pFurnitureIndex] = i;
			}

	        models[index++] = furnitureArray[i][fModel];
	    }
	}

	ShowPlayerSelectionMenu(playerid, type, furnitureCategories[PlayerInfo[playerid][pCategory]], models, index);
}

ClearChat(playerid)
{
	for(new i = 0; i < 29; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}

ClearAllChat(playerid)
{
	for(new i = 0; i < 65; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}
Float:Streamer_GetExtraFloat(objectid, type)
{
	new
	    string[24];

	getproperty(.id = objectid, .value = type, .string = string);
	strunpack(string, string);
	return floatstr(string);
}

Streamer_SetExtraFloat(objectid, type, Float:value)
{
	new
	    string[24];

	format(string, sizeof(string), "%f", value);
	setproperty(.id = objectid, .value = type, .string = string);
	return 1;
}

Streamer_GetExtraInt(objectid, type)
{
	new extra[11];

	if(Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, extra, sizeof(extra)))
	{
		return extra[type];
	}

	return 0;
}

Streamer_SetExtraInt(objectid, type, value)
{
	new extra[11];

    if(Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, extra, sizeof(extra)))
    {
	    extra[type] = value;
		return Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, extra, sizeof(extra));
	}

	return 0;
}

LandDoorCheck(playerid)
{
    new houseid = GetInsideHouse(playerid), landid = GetNearbyLand(playerid),id;

	if((id = GetNearbyLand(playerid)) >= 0 && (IsLandOwner(playerid, id) || PlayerInfo[playerid][pLandPerms] == id))
	{
		for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
		{
    		if(IsValidDynamicObject(i) && IsGateObject(i) && IsPlayerInRangeOfPoint(playerid, 10.0, Streamer_GetExtraFloat(i, E_OBJECT_X), Streamer_GetExtraFloat(i, E_OBJECT_Y), Streamer_GetExtraFloat(i, E_OBJECT_Z)) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    mysql_tquery(connectionID, queryBuffer, "OnPlayerUseLandGate", "ii", playerid, i);
			    return 1;
			}
		}
	}
	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
		{
		    if(houseid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_opened, door_locked FROM furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    mysql_tquery(connectionID, queryBuffer, "OnPlayerUseFurnitureDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
			else if(landid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_opened, door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    mysql_tquery(connectionID, queryBuffer, "OnPlayerUseLandDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    return 1;
			}
		}
	}

	return 0;
}

EnterCheck(playerid)
{
	new id, string[40];

	if((gettime() - PlayerInfo[playerid][pLastEnter]) < 3 && PlayerInfo[playerid][pAdminDuty] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to wait before using this command again.");
	}
	if(PlayerInfo[playerid][pHurt] - 30 > 0)
		return SM(playerid, COLOR_GREY, "You are too hurt to operate/enter anything. Please wait %i seconds before trying again.", (PlayerInfo[playerid][pHurt] - 30));

    if((id = GetNearbyHouse(playerid)) >= 0)
	{
	    if(HouseInfo[id][hLocked])
	    {
			Dyuze(playerid, "Notice", "This house is ~r~Locked.");
			return 0;
		}

		if(IsHouseOwner(playerid, id))
		{
		    HouseInfo[id][hTimestamp] = gettime();

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET timestamp = %i WHERE id = %i", gettime(), HouseInfo[id][hID]);
		    mysql_tquery(connectionID, queryBuffer);
			//SM(playerid, COLOR_SYNTAX, "** This house can be robbed again in %i hours. (( Type /robhouse to rob this house. ))", HouseInfo[id][hRobbed]);

		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered their house.", GetRPName(playerid));
		}
		else
		{
			SM(playerid, COLOR_SYNTAX, "** This house can be robbed again in %i hours. (( Type /robhouse to rob this house. ))", HouseInfo[id][hRobbed]);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered the house.", GetRPName(playerid));
		}

        PlayerInfo[playerid][pLastEnter] = gettime();
		SetFreezePos(playerid, HouseInfo[id][hIntX], HouseInfo[id][hIntY], HouseInfo[id][hIntZ]);
		SetPlayerFacingAngle(playerid, HouseInfo[id][hIntA]);
		SetPlayerInterior(playerid, HouseInfo[id][hInterior]);
		SetPlayerVirtualWorld(playerid, HouseInfo[id][hWorld]);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else if((id = GetNearbyGarage(playerid)) >= 0)
	{
	    if(GarageInfo[id][gLocked])
	    {
			Dyuze(playerid, "Notice", "This garage is ~r~Locked.");
			return 0;
		}

		if(IsGarageOwner(playerid, id))
		{
		    GarageInfo[id][gTimestamp] = gettime();

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET timestamp = %i WHERE id = %i", gettime(), GarageInfo[id][gID]);
		    mysql_tquery(connectionID, queryBuffer);

		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered their garage.", GetRPName(playerid));
		}
		else
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered the garage.", GetRPName(playerid));
		}

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    TeleportToGarage(playerid, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ], garageInteriors[GarageInfo[id][gType]][intVA], garageInteriors[GarageInfo[id][gType]][intID], GarageInfo[id][gWorld]);
		}
		else
		{
		    PlayerInfo[playerid][pLastEnter] = gettime();
			SetFreezePos(playerid, garageInteriors[GarageInfo[id][gType]][intPX], garageInteriors[GarageInfo[id][gType]][intPY], garageInteriors[GarageInfo[id][gType]][intPZ]);
			SetPlayerFacingAngle(playerid, garageInteriors[GarageInfo[id][gType]][intPA]);
			SetPlayerInterior(playerid, garageInteriors[GarageInfo[id][gType]][intID]);
			SetPlayerVirtualWorld(playerid, GarageInfo[id][gWorld]);
			SetCameraBehindPlayer(playerid);
		}

		return 1;
	}
	else if((id = GetNearbyBusiness(playerid)) >= 0)
	{
	    if(BusinessInfo[id][bLocked])
	    {
			Dyuze(playerid, "Notice", "This store is ~r~Closed.");
			return 0;
		}

		if(IsBusinessOwner(playerid, id))
		{
		    BusinessInfo[id][bTimestamp] = gettime();

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET timestamp = %i WHERE id = %i", gettime(), BusinessInfo[id][bID]);
		    mysql_tquery(connectionID, queryBuffer);
			SM(playerid, COLOR_GREEN, "%s", BusinessInfo[id][bMessage]);
			//SM(playerid, COLOR_SYNTAX, "** This business can be robbed again in %i hours. (( Type /robbiz to rob this business. ))", BusinessInfo[id][bRobbed]);
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered %s.", GetRPName(playerid), BusinessInfo[id][bName]);
		}
		else
		{
		    if(BusinessInfo[id][bEntryFee] > 0)
			{
				if(PlayerInfo[playerid][pCash] < BusinessInfo[id][bEntryFee])
		    	{
		    	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money to pay the entry fee. You may not enter.");
		        }

		        format(string, sizeof(string), "~r~-$%i", BusinessInfo[id][bEntryFee]);
		        Dyuze(playerid, "Notice", string);

		        BusinessInfo[id][bCash] += BusinessInfo[id][bEntryFee];
		        GivePlayerCash(playerid, -BusinessInfo[id][bEntryFee]);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[id][bCash], BusinessInfo[id][bID]);
		    	mysql_tquery(connectionID, queryBuffer);
		    }

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered %s.", GetRPName(playerid), BusinessInfo[id][bName]);
            SM(playerid, COLOR_GREEN, "%s", BusinessInfo[id][bMessage]);
			SM(playerid, COLOR_SYNTAX, "** This business can be robbed again in %i hours. (( Type /robbiz to rob this business. ))", BusinessInfo[id][bRobbed]);
		}

		PlayerInfo[playerid][pLastEnter] = gettime();
		SetFreezePos(playerid, BusinessInfo[id][bIntX], BusinessInfo[id][bIntY], BusinessInfo[id][bIntZ]);
		SetPlayerFacingAngle(playerid, BusinessInfo[id][bIntA]);
		SetPlayerInterior(playerid, BusinessInfo[id][bInterior]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[id][bWorld]);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else if((id = GetNearbyEntrance(playerid)) >= 0)
	{
	    if(EntranceInfo[id][eLocked])
	    {
			Dyuze(playerid, "Notice", "This building is ~r~Locked.");
			return 0;
		}
		if(EntranceInfo[id][eIntX] == 0.0 && EntranceInfo[id][eIntY] == 0.0 && EntranceInfo[id][eIntZ] == 0.0)
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "This entrance has no interior and therefore cannot be entered.");
		    return 0;
		}

		if(!PlayerInfo[playerid][pAdminDuty])
		{
			if(EntranceInfo[id][eAdminLevel] && PlayerInfo[playerid][pAdmin] < EntranceInfo[id][eAdminLevel])
			{
			    SendClientMessage(playerid, COLOR_SYNTAX, "Your administrator level is too low. You may not enter.");
		    	return 0;
			}
			if(EntranceInfo[id][eFactionType] > 0 && GetFactionType(playerid) != EntranceInfo[id][eFactionType])
			{
		    	SendClientMessage(playerid, COLOR_SYNTAX, "This entrance is only accesible to a specific faction type. You may not enter.");
				return 0;
			}
			if(EntranceInfo[id][eVIP] && PlayerInfo[playerid][pVIPPackage] < EntranceInfo[id][eVIP])
			{
		    	SendClientMessage(playerid, COLOR_SYNTAX, "Your VIP rank is too low. You may not enter.");
		    	return 0;
			}
		}

        PlayerInfo[playerid][pLastEnter] = gettime();
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered the building.", GetRPName(playerid));

		if(EntranceInfo[id][eVehicles] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(EntranceInfo[id][eFreeze])
		    {
		        TeleportToCoords(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ], EntranceInfo[id][eIntA], EntranceInfo[id][eInterior], EntranceInfo[id][eWorld], true);
		    }
			else
			{
				TeleportToCoords(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ], EntranceInfo[id][eIntA], EntranceInfo[id][eInterior], EntranceInfo[id][eWorld]);
			}
		}
		else
		{
			if(EntranceInfo[id][eFreeze])
			{
  				SetFreezePos(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]);
			}
			else
			{
			    SetPlayerPos(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]);
  			}

	  		SetPlayerFacingAngle(playerid, EntranceInfo[id][eIntA]);
	    	SetPlayerInterior(playerid, EntranceInfo[id][eInterior]);
			SetPlayerVirtualWorld(playerid, EntranceInfo[id][eWorld]);
			SetCameraBehindPlayer(playerid);
		}

		if(!EntranceInfo[id][eFreeze])
		{
			format(string, sizeof(string), "~w~%s", EntranceInfo[id][eName]);
		    Dyuze(playerid, "Notice", string);
		}
		return 1;
	}
	return 0;
}

ExitCheck(playerid)
{
	new id;

    if((gettime() - PlayerInfo[playerid][pLastEnter]) < 3 && PlayerInfo[playerid][pAdminDuty] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to wait before using this command again.");
	}

    if((id = GetInsideHouse(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][hIntX], HouseInfo[id][hIntY], HouseInfo[id][hIntZ]))
	{
	    PlayerInfo[playerid][pLastEnter] = gettime();
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has exited the house.", GetRPName(playerid));
		SetPlayerPos(playerid, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]);
		SetFreezePos(playerid, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]);
		SetPlayerFacingAngle(playerid, HouseInfo[id][hPosA]);
		SetPlayerInterior(playerid, HouseInfo[id][hOutsideInt]);
		SetPlayerVirtualWorld(playerid, HouseInfo[id][hOutsideVW]);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else if((id = GetInsideGarage(playerid)) >= 0)
	{
	    if(
			(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInRangeOfPoint(playerid, 6.0, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ])) ||
			((GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) && (IsPlayerInRangeOfPoint(playerid, 2.0, garageInteriors[GarageInfo[id][gType]][intPX], garageInteriors[GarageInfo[id][gType]][intPY], garageInteriors[GarageInfo[id][gType]][intPZ]) || IsPlayerInRangeOfPoint(playerid, 4.0, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ]))))
		{
	    	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has exited the garage.", GetRPName(playerid));

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
			    TeleportToCoords(playerid, GarageInfo[id][gExitX], GarageInfo[id][gExitY], GarageInfo[id][gExitZ], GarageInfo[id][gExitA], 0, 0);
			}
			else
			{
		    	SetPlayerPos(playerid, GarageInfo[id][gPosX], GarageInfo[id][gPosY], GarageInfo[id][gPosZ]);
				SetPlayerFacingAngle(playerid, GarageInfo[id][gPosA]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
			}
		}

        PlayerInfo[playerid][pLastEnter] = gettime();
		return 1;
	}
	else if((id = GetInsideBusiness(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[id][bIntX], BusinessInfo[id][bIntY], BusinessInfo[id][bIntZ]))
	{
	    PlayerInfo[playerid][pLastEnter] = gettime();
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has exited the business.", GetRPName(playerid));
		SetPlayerPos(playerid, BusinessInfo[id][bPosX], BusinessInfo[id][bPosY], BusinessInfo[id][bPosZ]);
		SetFreezePos(playerid, BusinessInfo[id][bPosX], BusinessInfo[id][bPosY], BusinessInfo[id][bPosZ]);
		SetPlayerFacingAngle(playerid, BusinessInfo[id][bPosA]);
		SetPlayerInterior(playerid, BusinessInfo[id][bOutsideInt]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[id][bOutsideVW]);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else if((id = GetInsideEntrance(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, (IsPlayerInAnyVehicle(playerid)) ? (7.0) : (3.0), EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]))
	{
	    PlayerInfo[playerid][pLastEnter] = gettime();
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has exited the building.", GetRPName(playerid));

		if(EntranceInfo[id][eVehicles] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(EntranceInfo[id][eFreeze])
		    {
		    	TeleportToCoords(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ], EntranceInfo[id][ePosA], EntranceInfo[id][eOutsideInt], EntranceInfo[id][eOutsideVW], true);
			}
			else
			{
				TeleportToCoords(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ], EntranceInfo[id][ePosA], EntranceInfo[id][eOutsideInt], EntranceInfo[id][eOutsideVW]);
			}
		}
		else
		{
		    if(EntranceInfo[id][eFreeze])
		    {
				SetFreezePos(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ]);
			}
			else
			{
			    SetPlayerPos(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ]);
			}

			SetPlayerFacingAngle(playerid, EntranceInfo[id][ePosA]);
			SetPlayerInterior(playerid, EntranceInfo[id][eOutsideInt]);
			SetPlayerVirtualWorld(playerid, EntranceInfo[id][eOutsideVW]);
			SetCameraBehindPlayer(playerid);
		}
		return 1;
	}
	return 0;
}

AddReportToQueue(playerid, text[])
{
    for(new i = 0; i < MAX_REPORTS; i ++)
	{
	    if(!ReportInfo[i][rExists])
	    {
	        strcpy(ReportInfo[i][rText], text, 128);

	        ReportInfo[i][rExists] = 1;
			ReportInfo[i][rAccepted] = 0;
			ReportInfo[i][rReporter] = playerid;
			ReportInfo[i][rHandledBy] = INVALID_PLAYER_ID;
			ReportInfo[i][rTime] = 5;

	        PlayerInfo[playerid][pLastReport] = gettime();
	        SAM(COLOR_REPORTSS, ""YELLOW"[RID: %i] "GREEN"of"YELLOW" %s[%i]:"REPORTSS" %s", i, GetRPName(playerid), playerid, text);
	        return 1;
		}
	}

	return 0;
}

AddDMReportToQueue(playerid, text[])
{
    for(new i = 0; i < MAX_REPORTS; i ++)
	{
	    if(!ReportInfo[i][rExists])
	    {
	        strcpy(ReportInfo[i][rText], text, 128);

	        ReportInfo[i][rExists] = 1;
			ReportInfo[i][rAccepted] = 0;
			ReportInfo[i][rReporter] = playerid;
			ReportInfo[i][rHandledBy] = INVALID_PLAYER_ID;
			ReportInfo[i][rTime] = 5;

	        PlayerInfo[playerid][pLastReport] = gettime();
	        SAM(COLOR_YELLOW2, "%s has reported that the following player may be "RED"deathmatching{F5DEB3}: %s (ReportID: %i)", GetRPName(playerid), text, i);
	        return 1;
		}
	}

	return 0;
}

AddBan(username[], ip[], from[], reason[], permanent = 0)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM bans WHERE username = '%s' OR ip = '%s'", username, ip);
	mysql_tquery(connectionID, queryBuffer, "OnBanAttempt", "ssssi", username, ip, from, reason, permanent);
}

UpdateLandText(landid)
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_UPDATE_LANDLABELS, landid);
}

BanPlayer(playerid, from[], reason[], permanent = 0)
{
	if(!strcmp(from, SERVER_BOT))
	{
	    gAnticheatBans++;
    	SaveServerInfo();
	}
	AddBan(GetPlayerNameEx(playerid), GetPlayerIP(playerid), from, reason, permanent);
	KickIP(GetPlayerIP(playerid));
}

Rangeban(playerid, from[], reason[])
{
	AddBan(GetPlayerNameEx(playerid), GetPlayerIPRange(playerid), from, reason);

    //mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO log_bans VALUES(null, %i, NOW(), '%s (IP: %s) was rangebanned by %s, reason: %e')", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), GetPlayerIP(playerid), from, reason);
	//mysql_tquery(connectionID, queryBuffer);

	KickIP(GetPlayerIP(playerid));
}

KickIP(const ip[])
{
	foreach(new i : Player)
	{
	    if(!strcmp(GetPlayerIP(i), ip))
	    {
	        KickPlayer(i);
		}
	}
}

GetHealth(playerid)
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	return floatround(health);
}

GetArmor(playerid)
{
	new Float:armor;
	GetPlayerArmour(playerid, armor);
	return floatround(armor);
}

GivePlayerHealth(playerid, Float:amount)
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, (health + amount > 150.0) ? (150.0) : (health + amount));
}

GivePlayerArmour(playerid, Float:amount)
{
	new Float:armor;
	GetPlayerArmour(playerid, armor);
	SetScriptArmour(playerid, (armor + amount > 150.0) ? (150.0) : (armor + amount));
}

AddToPaycheck(playerid, amount)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pPaycheck] = PlayerInfo[playerid][pPaycheck] + amount;

		if(!PlayerInfo[playerid][pAdminDuty])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET paycheck = paycheck + %i WHERE uid = %i", amount, PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}

forward OnPlayerCallContact(playerid);
public OnPlayerCallContact(playerid)
{
	new
		contact[MAX_PLAYER_NAME];
	new rows, fields;
	SQL_GetCacheData(rows, fields);

	if (!rows)
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You don't have that name in your contacts");
	}
	else
	{
		new
			number;
		number = SQL_GetInt(0, "contact_number");
		SQL_GetString(0, "contact_name", contact);

		if(number == PlayerInfo[playerid][pPhone])
		{
			return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" Invalid number.");
		}

		foreach(new i : Player)
		{
			if(PlayerInfo[i][pTogglePhone])
				return SendClientMessage(playerid, COLOR_ERROR, "The player's phone is off.");

			if(PlayerInfo[i][pPhone] == number)
			{
				if(PlayerInfo[i][pJailType] > 0)
				{
					return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That player is currently imprisoned and cannot use their phone.");
				}
				if(PlayerInfo[i][pCallLine] != INVALID_PLAYER_ID)
				{
					return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" This player is currently in a call. Wait until they hang up.");
				}
				if(PlayerInfo[i][pTogglePhone])
				{
					return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That player has their mobile phone switched off.");
				}
				if(PlayerInfo[i][pLiveBroadcast] != INVALID_PLAYER_ID)
				{
					return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That player is currently in a live interview and can't talk on the phone.");
				}

				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

				PlayerInfo[playerid][pCallLine] = i;
				PlayerInfo[playerid][pCallStage] = 0;

				PlayerInfo[i][pCallLine] = playerid;
				PlayerInfo[i][pCallStage] = 1;

				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
				SendProximityMessage(i, 20.0, SERVER_COLOR, "**{C2A2DA} %s's mobile phone begins to ring.", GetRPName(i));

				SM(playerid, COLOR_YELLOW, "** You've placed a call to number: %i. Please wait for your call to be answered.", number);
				SM(i, COLOR_YELLOW, "** Incoming call from #%i. Use /pickup to take this call.", PlayerInfo[playerid][pPhone]);
				PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
				return 1;
			}
		}

		SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That number is either not in service or the owner is offline.");
	}
	return 1;
}

forward OnPlayerTextContact(playerid);
public OnPlayerTextContact(playerid)
{
	new
		contact[MAX_PLAYER_NAME];

	new rows, fields;
	SQL_GetCacheData(rows, fields);

	if (!rows)
	{
		return 0;
	}
	else
	{
		new
			number;

		number = SQL_GetInt(0, "Number");
		SQL_GetString(0, "Contact", contact);

		PlayerInfo[playerid][pPhoneSMS] = number;

		ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "SMS Text", "Please type your message:", "Send", "Cancel");
	}
	return 1;
}
forward craftrope(playerid);
public craftrope(playerid)
{
    if (!PlayerInfo[playerid][pCrafting])
    {
        PlayerInfo[playerid][pMaterials] -= 50;
        ClearAnimations(playerid, SYNC_ALL);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        GameTextForPlayer(playerid, "~r~Failed", 5000, 3);
        return SendClientMessage(playerid, COLOR_RED, "Failed in crafting.\n you wasted all your materials");
    }
    //notification.Show(playerid, "Crafting Success", " ~n~ +2 rope.", "!",BoxColour_GREEN);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has Succesfuly crafted and received 2 ropes.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_GREEN, "Ropes crafted. Use /tie to tie people in your vehicle.");
    PlayerInfo[playerid][pRope] += 2;
    PlayerInfo[playerid][pCrafting] = 0;
    PlayerInfo[playerid][pMaterials] -= 50;
    ClearAnimations(playerid, SYNC_ALL);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = %i WHERE uid = %i", PlayerInfo[playerid][pRope], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return 1;
}

forward craftMp5(playerid);
public craftMp5(playerid)
{
    if (!PlayerInfo[playerid][pCrafting])
    {
        PlayerInfo[playerid][pCrafting] = 0;
        PlayerInfo[playerid][pMaterials] -= 350;
        PlayerInfo[playerid][pGunFrame] --;
        PlayerInfo[playerid][pIorn] -= 5;
        ClearAnimations(playerid, SYNC_ALL);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET iorn = %i WHERE uid = %i", PlayerInfo[playerid][pIorn], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunframe = %i WHERE uid = %i", PlayerInfo[playerid][pGunFrame], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pDiamonds];
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        GameTextForPlayer(playerid, "~r~Failed", 5000, 3);
        return SendClientMessage(playerid, COLOR_RED, "Failed in crafting.\n you wasted all your materials");
    }
   // notification.Show(playerid, "Crafting Success", " ~n~ +1 Mp5.", "!",BoxColour_GREEN);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has Succesfuly crafted and received a Mp5.", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_GREEN, "successfully crafted a Mp5.");
    GiveWeapon(playerid, 29);
    PlayerInfo[playerid][pCrafting] = 0;
    PlayerInfo[playerid][pMaterials] -= 350;
    PlayerInfo[playerid][pGunFrame] --;
    PlayerInfo[playerid][pIorn] -= 5;
    ClearAnimations(playerid, SYNC_ALL);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET iorn = %i WHERE uid = %i", PlayerInfo[playerid][pIorn], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunframe = %i WHERE uid = %i", PlayerInfo[playerid][pGunFrame], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pDiamonds];
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    return 1;
}

forward craftAK(playerid);
public craftAK(playerid)
{
    if (!PlayerInfo[playerid][pCrafting])
    {
        PlayerInfo[playerid][pMaterials] -= 500;
        PlayerInfo[playerid][pGunFrame] -= 2;
        PlayerInfo[playerid][pIorn] -= 5;
        PlayerInfo[playerid][pCopper] -= 2;
        ClearAnimations(playerid, SYNC_ALL);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET iorn = %i WHERE uid = %i", PlayerInfo[playerid][pIorn], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunframe = %i WHERE uid = %i", PlayerInfo[playerid][pGunFrame], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET copper = %i WHERE uid = %i", PlayerInfo[playerid][pCopper], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pDiamonds];
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        GameTextForPlayer(playerid, "~r~Failed", 5000, 3);
        return SendClientMessage(playerid, COLOR_RED, "Failed in crafting.\n you wasted all your materials");
    }
    //notification.Show(playerid, "Crafting Success", " ~n~ +1 M4-A1.", "!",BoxColour_GREEN);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has Succesfuly crafted and received a AK-47.", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_GREEN, "successfully crafted a M4.");
	GiveWeapon(playerid, 31);
    PlayerInfo[playerid][pCrafting] = 0;
    PlayerInfo[playerid][pMaterials] -= 500;
    PlayerInfo[playerid][pGunFrame] -= 2;
    PlayerInfo[playerid][pIorn] -= 5;
    PlayerInfo[playerid][pCopper] -= 2;
    ClearAnimations(playerid, SYNC_ALL);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET iorn = %i WHERE uid = %i", PlayerInfo[playerid][pIorn], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunframe = %i WHERE uid = %i", PlayerInfo[playerid][pGunFrame], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET copper = %i WHERE uid = %i", PlayerInfo[playerid][pCopper], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
    PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pDiamonds];
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    return 1;
}

forward OnPlayerListContacts(playerid);
public OnPlayerListContacts(playerid)
{
	new
		contact[MAX_PLAYER_NAME],
		string[1024],
		number;

	new rows, fields;
	SQL_GetCacheData(rows, fields);
	strcat(string, "Add Contact");

	for (new i = 0; i < rows; i ++)
	{
		SQL_GetString(i, "contact_name", contact);
		number = SQL_GetInt(i, "contact_number");
		format(string, sizeof(string), "%s\n%s (%i)", string, contact, number);

		gListedItems[playerid][i] = SQL_GetInt(i, "contact_id");
	}
	ShowPlayerDialog(playerid, DIALOG_CONTACTS, DIALOG_STYLE_LIST, "{FFFFFF}My contacts", string, "Select", "Cancel");
}

ListContacts(playerid)
{
	if (PlayerInfo[playerid][pPhone] > 0)
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM phone_contacts WHERE phone_number = %i", PlayerInfo[playerid][pPhone]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerListContacts", "i", playerid);
	}
}

forward OnGraffitiCreated(id);
public OnGraffitiCreated(id)
{
	GraffitiData[id][graffitiID] = cache_insert_id();
	Graffiti_Save(id);

	return 1;
}

GivePlayerCash(playerid, amount)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pCash] = PlayerInfo[playerid][pCash] + amount;

		if(!PlayerInfo[playerid][pAdminDuty])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = cash + %i WHERE uid = %i", amount, PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}

RefundPlayer(playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pRefunded] = 1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET refunded = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, color1, color2) VALUES(%i, '%s', 481, '%f', '%f', '%f', '%f', 6, 243)", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a);
        mysql_tquery(connectionID, queryBuffer);
  		GivePlayerCash(playerid, 200000);
		VIPRefund(playerid);
	}
}

VIPRefund(playerid)
{
	if (PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pVIPPackage] = 3;
		PlayerInfo[playerid][pVIPTime] = gettime() + (1296000);
		PlayerInfo[playerid][pVIPCooldown] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

GivePlayerDirtyCash(playerid, amount)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pDirtyCash] = PlayerInfo[playerid][pDirtyCash] + amount;

		if(!PlayerInfo[playerid][pAdminDuty])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Dirtycash = Dirtycash + %i WHERE uid = %i", amount, PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}
BPFriskPlayer(playerid, targetid)
{
	new str[1024], weapon_count, count;

	format(str, sizeof(str), "{7DAEFF}%s's Backpack Contents:"WHITE"\n\n", GetRPName(targetid));

	if(PlayerInfo[targetid][bpCash] > 0) {
		format(str, sizeof(str), "%sCash: $%i\n\n", str, PlayerInfo[targetid][bpCash]);
		count++;
	}
	if(PlayerInfo[targetid][bpMaterials] > 0)
	{
	    format(str, sizeof(str), "%sMaterials (%i)\n", str, PlayerInfo[targetid][bpMaterials]);
		count++;
	}
    if(PlayerInfo[targetid][bpPot])
	{
	    format(str, sizeof(str), "%sPot (%ig)\n", str, PlayerInfo[targetid][bpPot]);
		count++;
	}
	if(PlayerInfo[targetid][bpCrack])
	{
	    format(str, sizeof(str), "%sCrack: (%ig)\n", str, PlayerInfo[targetid][bpCrack]);
		count++;
	}
	if(PlayerInfo[targetid][bpMeth])
	{
	    format(str, sizeof(str), "%sMeth (%ig)\n", str, PlayerInfo[targetid][bpMeth]);
		count++;
	}
	if(PlayerInfo[targetid][bpPainkillers])
	{
	    format(str, sizeof(str), "%sPainkillers (%i)\n", str, PlayerInfo[targetid][bpPainkillers]);
		count++;
	}

	format(str, sizeof(str), "%s\nWeapons:\n", str);
	for(new i = 0; i < 15; i ++)
	{
	    if(PlayerInfo[targetid][bpWeapons][i] > 0)
	    {
			weapon_count++;
			format(str, sizeof(str), "%s{FF0000}* %s (ammo: %d)\n", str, GetWeaponNameEx(PlayerInfo[targetid][bpWeapons][i]), PlayerInfo[targetid][bpAmmo][i]);
		}
	}
	if(weapon_count < 1) format(str, sizeof(str), "%s{FF0000}* This bacpack has no weapon stored in it.", str);
	if(count < 1) format(str, sizeof(str), "%s{FF0000}* This backpack has no items stored in it.", str);

	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Backpack Search Result", str, "Close", "");
    SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s searches %s's backpack.", GetRPName(playerid), GetRPName(targetid));
}
InfluencingGangInTurf(turfid)
{
    new gangMemberCount[MAX_GANGS] = {0};
    new IG, IGID = -1;

    // Count the number of members for each gang in the turf area
    foreach (new j : Player)
    {
        if (PlayerInfo[j][pGang] != -1 && !PlayerInfo[j][pInjured] && !PlayerInfo[j][pAdmin])
        {
            if (IsPlayerInDynamicArea(j, TurfInfo[turfid][tArea]))
            {
                gangMemberCount[PlayerInfo[j][pGang]]++;
            }
        }
    }

    // Determine the gang with the most members
    for (new i = 0; i < MAX_GANGS; i++)
    {
        if (GangInfo[i][gSetup] && gangMemberCount[i] > IG)
        {
            IG = gangMemberCount[i];
            IGID = i;
        }
    }

    return IGID;
}

FriskPlayer(playerid, targetid)
{
	SM(playerid, SERVER_COLOR, "%s's Items:", GetRPName(targetid));

	SM(playerid, COLOR_GREEN, "Cash ($%i)", PlayerInfo[targetid][pCash]);
	SM(playerid, COLOR_GREEN, "Backpack: Cash ($%i)", PlayerInfo[targetid][bpCash]);
	SM(playerid, COLOR_REALRED, "Dirty Money ($%i)", PlayerInfo[targetid][pDirtyCash]);

	if(PlayerInfo[targetid][pBackpack])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Backpack");
	}
	if(PlayerInfo[targetid][pPhone])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Mobile Phone");
	}
	if(PlayerInfo[targetid][pWalkieTalkie])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Portable Radio");
	}
    if(PlayerInfo[targetid][pSpraycans])
	{
	    SM(playerid, COLOR_GREY2, "Spraycans (%i)", PlayerInfo[targetid][pSpraycans]);
	}
	if(PlayerInfo[targetid][pBoombox])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Boombox");
	}
	if(PlayerInfo[targetid][pMP3Player])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "MP3 player");
	}
	if(PlayerInfo[targetid][pPhonebook])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Phonebook");
	}
	if(PlayerInfo[targetid][pMaterials] > 0)
	{
	    SM(playerid, COLOR_REALRED, "Materials (%i)", PlayerInfo[targetid][pMaterials]);
	}
    if(PlayerInfo[targetid][pPot])
	{
	    SM(playerid, COLOR_REALRED, "Pot (%ig)", PlayerInfo[targetid][pPot]);
	}
	if(PlayerInfo[targetid][pCrack])
	{
	    SM(playerid, COLOR_REALRED, "Crack (%ig)", PlayerInfo[targetid][pCrack]);
	}
	if(PlayerInfo[targetid][pMeth])
	{
	    SM(playerid, COLOR_REALRED, "Meth (%ig)", PlayerInfo[targetid][pMeth]);
	}
	if(PlayerInfo[targetid][pPainkillers])
	{
	    SM(playerid, COLOR_REALRED, "Painkillers (%i)", PlayerInfo[targetid][pPainkillers]);
	}
	if(PlayerInfo[targetid][pBandage])
	{
	    SM(playerid, COLOR_REALRED, "Bandage (%i)", PlayerInfo[targetid][pBandage]);
	}
	if(PlayerInfo[targetid][pSeeds])
	{
	    SM(playerid, COLOR_REALRED, "Marijuana Seeds (%i)", PlayerInfo[targetid][pSeeds]);
	}
	if(PlayerInfo[targetid][pEphedrine])
	{
	    SM(playerid, COLOR_REALRED, "Raw Ephedrine (%i)", PlayerInfo[targetid][pEphedrine]);
	}
	if(PlayerInfo[targetid][bpMaterials] > 0)
	{
	    SM(playerid, COLOR_REALRED, "Backpack: Materials (%i)", PlayerInfo[targetid][bpMaterials]);
	}
    if(PlayerInfo[targetid][bpPot])
	{
	    SM(playerid, COLOR_REALRED, "Backpack: Pot (%ig)", PlayerInfo[targetid][bpPot]);
	}
	if(PlayerInfo[targetid][bpCrack])
	{
	    SM(playerid, COLOR_REALRED, "Backpack: Crack: (%ig)", PlayerInfo[targetid][bpCrack]);
	}
	if(PlayerInfo[targetid][bpMeth])
	{
	    SM(playerid, COLOR_REALRED, "Backpack: Meth (%ig)", PlayerInfo[targetid][bpMeth]);
	}
	if(PlayerInfo[targetid][bpPainkillers])
	{
	    SM(playerid, COLOR_REALRED, "Backpack: Painkillers (%i)", PlayerInfo[targetid][bpPainkillers]);
	}

	switch(PlayerInfo[targetid][pSmuggleDrugs])
	{
	    case 1: SM(playerid, COLOR_REALRED, "Seeds package");
	    case 2: SM(playerid, COLOR_REALRED, "Crack package");
	    case 3: SM(playerid, COLOR_REALRED, "Raw ephedrine package");
	}

	for(new i = 0; i < 13; i ++)
	{
	    if(PlayerInfo[targetid][pWeapons][i] > 0)
	    {
	        SM(playerid, COLOR_REALRED, "%s", GetWeaponNameEx(PlayerInfo[targetid][pWeapons][i]));
		}
 	    else if(PlayerInfo[targetid][bpWeapons][i] > 0)
	    {
	        SM(playerid, COLOR_REALRED, "Backpack: %s", GetWeaponNameEx(PlayerInfo[targetid][bpWeapons][i]));
		}
	}

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s searches for items on %s.", GetRPName(playerid), GetRPName(targetid));
}


DisplayStats(playerid, targetid = INVALID_PLAYER_ID)
{
	if(targetid == INVALID_PLAYER_ID) targetid = playerid;

    new name[24], gender[8], faction[48], facrank[48], gang[32], gangrank[32], insurance[24], division[48], Float:health, Float:armor, Float:maxarmor;

	if(playerid == MAX_PLAYERS)
	{
		strcpy(name, PlayerInfo[playerid][pUsername]);
	}
	else
	{
		strcat(name, GetRPName(playerid));
	}

	if(PlayerInfo[playerid][pGender] == 1) gender = "Male";
	else if(PlayerInfo[playerid][pGender] == 2) gender = "Female";
	else if(PlayerInfo[playerid][pGender] == 3) gender = "Shemale";

	switch(PlayerInfo[playerid][pInsurance])
	{
	    case HOSPITAL_COUNTY: insurance = "Northern Hospital";
	    case HOSPITAL_ALLSAINTS: insurance = "All Saints";
	    case HOSPITAL_VIP: insurance = "County General";
	    default: insurance = "None";
	}

	if(PlayerInfo[playerid][pFaction] >= 0)
	{
	    if(!strcmp(FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], "None", true))
	    {
		    strcpy(faction, FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
		}
		else
		{
		    strcpy(faction, FactionInfo[PlayerInfo[playerid][pFaction]][fShortName]);
		}

	    format(facrank, sizeof(facrank), "%s (%i)", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], PlayerInfo[playerid][pFactionRank]);

	    if(PlayerInfo[playerid][pDivision] >= 0)
	    {
	        strcpy(division, FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]]);
		}
		else
		{
		    division = "None";
		}
	}
	else
	{
	    faction = "None";
	    facrank = "N/A";
	    division = "None";
	}

	if(PlayerInfo[playerid][pGang] >= 0)
	{
	    strcpy(gang, GangInfo[PlayerInfo[playerid][pGang]][gName]);
	    strcpy(gangrank, GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]]);
	}
	else
	{
	    gang = "None";
	    gangrank = "N/A";
	}

	switch(PlayerInfo[playerid][pVIPPackage])
	{
		case 0:
			maxarmor = 150.0;
		case 1, 2:
			maxarmor = 150.0;
		case 3:
		    maxarmor = 150.0;
	}

	if(playerid == MAX_PLAYERS)
	{
	    health = PlayerInfo[playerid][pHealth];
	    armor = PlayerInfo[playerid][pArmor];
	}
	else
	{
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armor);
	}

	SM(targetid, 0x7514F6FF,  	"_______________________________________________________________________________");
 	SM(targetid, COLOR_WHITE, 		"%s - (Level: %i) - (Gender: %s) - (Age: %i) - (Cash: $%s) - (Bank: $%s) - (Hours: %i) - (Ph: %i)\n", name, PlayerInfo[playerid][pLevel], gender, PlayerInfo[playerid][pAge], AddCommas(PlayerInfo[playerid][pCash]), AddCommas(PlayerInfo[playerid][pBank]), PlayerInfo[playerid][pHours], PlayerInfo[playerid][pPhone]);
	SM(targetid, COLOR_NAVYBLUE,  	 	"(Total Wealth: $%s) - (Addict: %i/3) - (Asset: %i/4) - (Channel: %i) - (Report Warnings: %i/3)\n", AddCommas(PlayerInfo[playerid][pCash] + PlayerInfo[playerid][pBank]), PlayerInfo[playerid][pAddictUpgrade], PlayerInfo[playerid][pAssetUpgrade], PlayerInfo[playerid][pChannel], PlayerInfo[playerid][pReportWarns]);
	SM(targetid, COLOR_WHITE, 		"(Job: %s / %s) - (Job Skill: %i) - (Crimes: %i) - (Arrested: %i) - (Jail Time: %i seconds)\n", GetJobName(PlayerInfo[playerid][pJob]), GetJobName(PlayerInfo[playerid][pSecondJob]), GetJobLevel(playerid, PlayerInfo[playerid][pJob]), PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pArrested], PlayerInfo[playerid][pJailTime]);
	SM(targetid, COLOR_NAVYBLUE,  	 	"(Spawn Health: %.1f/100.0) - (Spawn Armor: %.1f/%.1f) - (Insurance: %s) - (Paycheck: $%i)\n", PlayerInfo[playerid][pSpawnHealth], PlayerInfo[playerid][pSpawnArmor], maxarmor, insurance, PlayerInfo[playerid][pPaycheck]);
    SM(targetid, COLOR_WHITE, 		"(Faction: %s [%s %i - %s]) - (Gang: %s [%s %i]) - (Helper: %s) - (DM Warnings: %i/5)\n", faction, facrank, PlayerInfo[playerid][pFactionRank], division, gang, gangrank, PlayerInfo[playerid][pGangRank], GetHelperRank(playerid), PlayerInfo[playerid][pDMWarnings]);
	SM(targetid, COLOR_NAVYBLUE, 		"(VIP Package: %s) - (Married to: %s) - (Warnings: %i) - (Wanted Level: %i)\n", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), PlayerInfo[playerid][pMarriedName], PlayerInfo[playerid][pWarnings], PlayerInfo[playerid][pWantedLevel]);
	SM(targetid, COLOR_WHITE,       "(Experience: %s/%s) - (Next Level: %s) - (Weapon Restriction: %i Hrs)\n",  FormatNumber(PlayerInfo[playerid][pEXP], 0), FormatNumber((PlayerInfo[playerid][pLevel] * 10), 0), FormatNumber((PlayerInfo[playerid][pLevel] + 1) * 5000), PlayerInfo[playerid][pWeaponRestricted]);

	if(PlayerInfo[targetid][pAdmin] > 0)
	{
	    SM(targetid, COLOR_WHITE, 	"(Interior: %i) - (Virtual: %i) - (AFK: %s) - (Reports: %i) - (Help Requests: %i)", (playerid == MAX_PLAYERS) ? (PlayerInfo[playerid][pInterior]) : (GetPlayerInterior(playerid)), (playerid == MAX_PLAYERS) ? (PlayerInfo[playerid][pWorld]) : (GetPlayerVirtualWorld(playerid)), (playerid == MAX_PLAYERS) ? ("No") : ((PlayerInfo[playerid][pAFK]) ? ("Yes") : ("No")),
			PlayerInfo[playerid][pReports], PlayerInfo[playerid][pHelpRequests]);
	}
	SM(targetid, 0x7514F6FF,  	"_______________________________________________________________________________");
	return 1;
}
RemovePlayerWeaponEx(playerid, weaponid)
{
	// Reset the player's weapons.
	ResetPlayerWeapons(playerid);
	// Set the armed slot to zero.
	SetPlayerArmedWeapon(playerid, 0);
	// Set the weapon in the slot to zero.
	PlayerInfo[playerid][pACTime] = gettime() + 2;
	PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] = 0;
	PlayerInfo[playerid][pTempWeapons][weaponSlotIDs[weaponid]] = 0;
	// Set the player's weapons.
	SetPlayerWeapons(playerid);
	// Save them to prevent rollbacks.
	SavePlayerWeapons(playerid);
}

ShowDialogToPlayer(playerid, dialogid)
{
	new string[2048], vehicleid = GetPlayerVehicleID(playerid), neon[12], Float:health;

	GetVehicleHealth(vehicleid, health);
	
	switch(VehicleInfo[vehicleid][vNeon])
	{
	    case 18647: neon = "Red";
		case 18648: neon = "Blue";
		case 18649: neon = "Green";
		case 18650: neon = "Yellow";
		case 18651: neon = "Pink";
		case 18652: neon = "White";
		default: neon = "None";
	}
    //new vehiclestring[4096];
	switch(dialogid)
	{
		case DIALOG_REGISTER:
		{
			format(string, sizeof(string), ""WHITE"{ffffff}This account is not yet {7fff00}registered!\n{ffffff}Name : {ff0000}%s\n{ffffff}You can register by entering the password:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,""SVRCLR"Registration ALL KERALA ROLEPLAY",string,"Register","Abort");
		}
		case DIALOG_LOGIN:
		{
			format(string, sizeof(string), "{ffffff}This account has {7fff00}registered!\n{ffffff}Character Account :{7fffd4} %s\n{ffffff}Please login with your password:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login to AKRP City",string,"Login","Abort");
		}
        case DIALOG_INSTA:
		{
		    ShowPlayerDialog(playerid, DIALOG_INSTA, DIALOG_STYLE_INPUT, "Instagram", "What's on your mind?", "Post", "Back");
		}
		case DIALOG_BUYCLOTHESCP:
        {
            new businessid = GetInsideBusiness(playerid);

            if(businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
            {
                format(string, sizeof(string), "%s %s [%i products]", BusinessInfo[businessid][bName], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

                if(PlayerInfo[playerid][pVIPPackage] > 0) {
                    ShowPlayerDialog(playerid, DIALOG_BUYCLOTHESCP, DIALOG_STYLE_INPUT, string, "NOTE: New clothes are free for VIP members.\n\nPlease input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.net/wiki/Skins:All ))", "Submit", "Cancel");
                } else {
                    ShowPlayerDialog(playerid, DIALOG_BUYCLOTHESCP, DIALOG_STYLE_INPUT, string, "NOTE: New clothes costs $2,000.\n\nPlease input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.net/wiki/Skins:All ))", "Submit", "Cancel");
                }
            }
        }
		case DIALOG_GENDER:
		{
		    ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, ""SVRCLR"Gender", "Male\nFemale", "Select", "");
		}
		case DIALOG_TWEET:
		{
	    	ShowPlayerDialog(playerid, DIALOG_TWEET, DIALOG_STYLE_INPUT, "Tweet", "What's on your mind?", "Post", "Back");
		}
		case DIALOG_AGE:
		{
	   		ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""SVRCLR"Age", ""WHITE"What age would you like your character to be (Between 13-99 yeas old):", "Submit", "Back");
		}
		case DIALOG_REFERRAL:
		{
		    ShowPlayerDialog(playerid, DIALOG_REFERRAL, DIALOG_STYLE_INPUT, ""SVRCLR"Referral", ""WHITE"Have you been invited here by one of our players? Put their name:\n(Click on 'Skip' if you havent been referred by anyone.)", "Submit", "Skip");
		}
		#if defined Christmas
			case DIALOG_CAROL:
			{
				new carolString[250];
				format(carolString, sizeof(carolString), ""RED"Merry"GREY"Christmas\n"WHITE"To start caroling on this house, type in the following into the text field.\n"GREEN"%s", ReturnLyrics(CarolLyrics[playerid]));
				ShowPlayerDialog(playerid, DIALOG_CAROL, DIALOG_STYLE_INPUT, ""SVRCLR"Christmas Caroling", carolString, "Submit", "Skip");
			}
		#endif
		case DIALOG_BUYFURNITURE1:
		{
		    for(new i = 0; i < sizeof(furnitureCategories); i ++)
		    {
		        format(string, sizeof(string), "%s\n%s", string, furnitureCategories[i]);
		    }
		    ShowPlayerDialog(playerid, DIALOG_BUYFURNITURE1, DIALOG_STYLE_LIST, "Choose a category to browse.", string, "Select", "Cancel");
			//ShowModelSelectionMenuEx(playerid, furnitureArray, "Select an item to buy", DIALOG_BUYFURNITURE1, 16.0, 0.0, 130.0);
		}
		case DIALOG_BUYFURNITURE2:
		{
		    new index = -1;

            for(new i = 0; i < sizeof(furnitureArray); i ++)
            {
                if(!strcmp(furnitureArray[i][fCategory], furnitureCategories[PlayerInfo[playerid][pCategory]]))
                {
                    if(index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s ($%i)", string, furnitureArray[i][fName], furnitureArray[i][fPrice]);
                }
            }

            PlayerInfo[playerid][pFurnitureIndex] = index;
            ShowPlayerDialog(playerid, DIALOG_BUYFURNITURE2, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
		}
		case DIALOG_TWITTER:
        {
		    ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_INPUT, "Twitter", "Please enter the Message to Post in Twitter:", "Post", "Cancel");
        }
        case DIALOG_CALL:
		{
		    ShowPlayerDialog(playerid, DIALOG_CALL, DIALOG_STYLE_INPUT, "CALL", "Special numbers: 911 = Emergency hotline, 6397 = News, 6324 = Mechanic", "Call", "Cancel");
        }
        case DIALOG_SENDGPS:
		{
	        ShowPlayerDialog(playerid, DIALOG_SENDGPS, DIALOG_STYLE_INPUT, ""SVRCLR"SEND GPS", "Please put the PlayerID you want to SEND YOURE GPS:", "Send", "Cancel");
		}
		case DIALOG_ROUTEMENU:
		{
		    ShowPlayerDialog(playerid, DIALOG_ROUTEMENU, DIALOG_STYLE_TABLIST, "U:RP Bus Menu", "Commerce-Market\nCommerce-LS Airport", "Select", "Leave");
		}
        case DIALOG_GPS1:
		{
		    ShowPlayerDialog(playerid, DIALOG_GPS1, DIALOG_STYLE_LIST, "GPS", "Google Map\nSend location", "Select", "Back");
		}
		case DIALOG_ATMDEPOSIT:
		{
		    format(string, sizeof(string), "How much would you like to deposit? (Your account balance is %s.)", FormatNumber(PlayerInfo[playerid][pBank]));
	        ShowPlayerDialog(playerid, DIALOG_ATMDEPOSIT, DIALOG_STYLE_INPUT, ""SVRCLR"Deposit", string, "Select", "Cancel");
		}
		case DIALOG_ATMWITHDRAW:
		{
		    format(string, sizeof(string), "How much would you like to withdraw? (Your account balance is %s.)", FormatNumber(PlayerInfo[playerid][pBank]));
	        ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, ""SVRCLR"Withdraw", string, "Select", "Cancel");
		}
        case DIALOG_PHONE_SMS:
		{
		    ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Send", "Cancel");
		}
        case DIALOG_ATM_TRANSFER:
		{
	        ShowPlayerDialog(playerid, DIALOG_ATM_TRANSFER, DIALOG_STYLE_INPUT, ""SVRCLR"Paypal ID", "Please put the PaypalID you want to wiretransfer the money to:", "Select", "Cancel");
		}
		case DIALOG_ATM_TRANSFER2:
		{
		    format(string, sizeof(string), "How much would you like to wiretransfer? (Your account balance is %s.)", FormatNumber(PlayerInfo[playerid][pBank]));
	        ShowPlayerDialog(playerid, DIALOG_ATM_TRANSFER2, DIALOG_STYLE_INPUT, ""SVRCLR"ATM Withdraw", string, "Select", "Cancel");
		}
		case DIALOG_ATM:
		{
	        ShowPlayerDialog(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, ""SVRCLR"Select your option", "Withdraw\nDeposit", "Submit", "Cancel");
		}
		case DIALOG_BUYCLOTHINGTYPE:
		{
		    ShowPlayerDialog(playerid, DIALOG_BUYCLOTHINGTYPE, DIALOG_STYLE_LIST, "Choose a browsing method.", "Browse by Model\nBrowse by List", "Select", "Back");
		}
		case DIALOG_BUYCLOTHING:
		{
		    new index = -1;

            for(new i = 0; i < sizeof(clothingArray); i ++)
            {
                if(!strcmp(clothingArray[i][clothingType], clothingTypes[PlayerInfo[playerid][pCategory]]))
                {
                    if(index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s", string, clothingArray[i][clothingName]);
                }
            }

            PlayerInfo[playerid][pClothingIndex] = index;
            ShowPlayerDialog(playerid, DIALOG_BUYCLOTHING, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Cancel");
		}
		case DIALOG_FACTIONPAY1:
		{
		    string = "#\tRank\tPaycheck";

		    for(new i = 0; i < FactionInfo[PlayerInfo[playerid][pFactionEdit]][fRankCount]; i ++)
		    {
		        format(string, sizeof(string), "%s\n%i\t%s\t"SVRCLR"$%i"WHITE"", string, i, FactionRanks[PlayerInfo[playerid][pFactionEdit]][i], FactionInfo[PlayerInfo[playerid][pFactionEdit]][fPaycheck][i]);
			}

			ShowPlayerDialog(playerid, DIALOG_FACTIONPAY1, DIALOG_STYLE_TABLIST_HEADERS, FactionInfo[PlayerInfo[playerid][pFactionEdit]][fName], string, "Change", "Cancel");
		}
		case DIALOG_PHONEBOOK:
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM phonebook ORDER BY name ASC LIMIT %i, %i", (PlayerInfo[playerid][pPage] - 1) * MAX_LISTED_NUMBERS, MAX_LISTED_NUMBERS);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VIEW_PHONEBOOK, playerid);
		}
		case DIALOG_NEWBIE:
		{
			ShowPlayerDialog(playerid, DIALOG_NEWBIE, DIALOG_STYLE_INPUT, "Ask Newbie Question", "Please input your question\nPlease bare in mind only script/server related questions will be answered.", "Send", "Cancel");
		}
		case DIALOG_LANDBUILDTYPE:
		{
		    ShowPlayerDialog(playerid, DIALOG_LANDBUILDTYPE, DIALOG_STYLE_LIST, "Choose your browsing method.", "Browse by Model\nBrowse by List", "Select", "Back");
		}
  		case DIALOG_LANDBUILD1:
		{
		    for(new i = 0; i < sizeof(furnitureCategories); i ++)
		    {
		        format(string, sizeof(string), "%s\n%s", string, furnitureCategories[i]);
		    }

		    ShowPlayerDialog(playerid, DIALOG_LANDBUILD1, DIALOG_STYLE_LIST, "Choose a category to browse.", string, "Select", "Back");
		}
		case DIALOG_LANDBUILD2:
		{
		    new index = -1;

            for(new i = 0; i < sizeof(furnitureArray); i ++)
            {
                if(!strcmp(furnitureArray[i][fCategory], furnitureCategories[PlayerInfo[playerid][pCategory]]))
                {
                    if(index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s (%s)", string, furnitureArray[i][fName], FormatNumber(furnitureArray[i][fPrice]));
                }
            }

            PlayerInfo[playerid][pFurnitureIndex] = index;
            ShowPlayerDialog(playerid, DIALOG_LANDBUILD2, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
		}
		case DIALOG_LANDMENU:
		{
		    new
		        landid = GetNearbyLand(playerid);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LAND_MAINMENU, playerid);
		}
		case DIALOG_LANDOBJECTMENU:
		{
	        if(IsGateObject(PlayerInfo[playerid][pSelected]))
	        {
		        ShowPlayerDialog(playerid, DIALOG_LANDOBJECTMENU, DIALOG_STYLE_LIST, "Object menu", "Edit object\nEdit gate destination\nDuplicate object\nSell object", "Select", "Cancel");
	        }
			else
			{
                ShowPlayerDialog(playerid, DIALOG_LANDOBJECTMENU, DIALOG_STYLE_LIST, "Object menu", "Edit object\nDuplicate object\nSell object", "Select", "Cancel");
	        }
		}
		case DIALOG_LANDOBJECTS:
		{
		    new landid = GetNearbyLand(playerid);

		    if(landid >= 0 && HasLandPerms(playerid, landid))
		    {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM landobjects WHERE landid = %i ORDER BY id DESC LIMIT %i, %i", LandInfo[landid][lID], (PlayerInfo[playerid][pPage] - 1) * MAX_LISTED_OBJECTS, MAX_LISTED_OBJECTS);
   				mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LIST_LANDOBJECTS, playerid);
			}
		}
		case DIALOG_MP3PLAYER:
		{
		    ShowPlayerDialog(playerid, DIALOG_MP3PLAYER, DIALOG_STYLE_LIST, "MP3 player", "Custom URL\nUploaded Music\nRadio Stations\nStop Music", "Select", "Cancel");
		}
		case DIALOG_MP3RADIO:
		{
		    ShowPlayerDialog(playerid, DIALOG_MP3RADIO, DIALOG_STYLE_LIST, "Radio Stations", "Browse Genres\nSearch by Name", "Select", "Back");
		}
		case DIALOG_MP3RADIOGENRES:
		{
		    new genre[32] = "n/a";

		    for(new i = 0; i < sizeof(radioGenreList); i ++)
		    {
		        if(strcmp(radioGenreList[i][rGenre], genre) != 0)
		        {
		            strcpy(genre, radioGenreList[i][rGenre]);
		            strcat(string, genre);
		            strcat(string, "\n");
		        }
		    }

		    ShowPlayerDialog(playerid, DIALOG_MP3RADIOGENRES, DIALOG_STYLE_LIST, "Choose a genre to browse stations in.", string, "Select", "Back");
		}
		case DIALOG_MP3RADIOSUBGENRES:
		{
		    for(new i = 0; i < sizeof(radioGenreList); i ++)
		    {
		        if(!strcmp(radioGenreList[i][rGenre], PlayerInfo[playerid][pGenre]))
		        {
		            format(string, sizeof(string), "%s\n%s", string, radioGenreList[i][rSubgenre]);
		        }
			}

			ShowPlayerDialog(playerid, DIALOG_MP3RADIOSUBGENRES, DIALOG_STYLE_LIST, "Choose a subgenre to browse stations in.", string, "Select", "Back");
		}
		case DIALOG_MP3RADIORESULTS:
		{
		    if(PlayerInfo[playerid][pSearch])
		    {
		        mysql_format(radioConnectionID, queryBuffer, sizeof(queryBuffer), "SELECT name FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, %i", PlayerInfo[playerid][pGenre], PlayerInfo[playerid][pGenre], (PlayerInfo[playerid][pPage] - 1) * MAX_LISTED_STATIONS, MAX_LISTED_STATIONS);
				mysql_tquery(radioConnectionID, queryBuffer, "Radio_ListStations", "i", playerid);
			}
			else
			{
			    mysql_format(radioConnectionID, queryBuffer, sizeof(queryBuffer), "SELECT name FROM radiostations WHERE genre = '%e' AND subgenre = '%e' ORDER BY name LIMIT %i, %i", PlayerInfo[playerid][pGenre], PlayerInfo[playerid][pSubgenre], (PlayerInfo[playerid][pPage] - 1) * MAX_LISTED_STATIONS, MAX_LISTED_STATIONS);
				mysql_tquery(radioConnectionID, queryBuffer, "Radio_ListStations", "i", playerid);
			}
		}
		case DIALOG_MP3RADIOSEARCH:
		{
		    ShowPlayerDialog(playerid, DIALOG_MP3RADIOSEARCH, DIALOG_STYLE_INPUT, "Search by Name | "SERVER_NAME"", "Enter the full or partial name of the radio station:", "Submit", "Back");
		}

		case DIALOG_GCLOTHES:
		{
		    if(!GetGangSkinCount(PlayerInfo[playerid][pGang]))
    		{
        		return SendClientMessage(playerid, COLOR_SYNTAX, "There are no skins setup for your gang.");
			}
			PlayerInfo[playerid][pSkinSelected] = -1;
    		ShowPlayerDialog(playerid, DIALOG_GANGSKINS, DIALOG_STYLE_MSGBOX, "Skin selection", "Press "SVRCLR"Next{A9C4E4} to browse through available gang skins.", "Next", "Confirm");
		}

		case DIALOG_GANGSTASH:
		{
		    format(string, sizeof(string), "Gang Locker ($%i/$%i) (Materials: %i/%i)", GangInfo[PlayerInfo[playerid][pGang]][gCash], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH), GangInfo[PlayerInfo[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS));
		    ShowPlayerDialog(playerid, DIALOG_GANGSTASH, DIALOG_STYLE_LIST, string, "Weapons\nDrugs\nMaterials\nCash\nClothes", "Select", "Cancel");
		}
		case DIALOG_GANGSTASHWEAPONS1:
		{
		    format(string, sizeof(string), "[%i] 9mm (R1+)\n[%i] Sdpistol (R1+)\n[%i] Deagle (R4+)\n[%i] Shotgun (R1+)\n[%i] SPAS-12 (R4+)\n[%i] Sawn-off (R4+)\n[%i] Tec-9 (R3+)\n[%i] Micro Uzi (R3+)\n[%i] MP5 (R3+)\n[%i] AK-47 (R4+)\n[%i] M4 (R4+)\n[%i] Rifle (R2+)\n[%i] Sniper (R5+)\n[%i] Molotov (R5+)",
		        GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_9MM], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_TEC9],
				GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_UZI], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MP5], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_AK47], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_M4], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER], GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV]);
		    ShowPlayerDialog(playerid, DIALOG_GANGSTASHWEAPONS1, DIALOG_STYLE_LIST, "Gang Locker | Weapons", string, "Select", "Back");
		}
		case DIALOG_GANGSTASHDRUGS1:
		{
		    format(string, sizeof(string), "Pot (%i/%ig)\nCrack (%i/%ig)\nMeth (%i/%ig)\nPainkillers (%i/%i)",
				GangInfo[PlayerInfo[playerid][pGang]][gPot], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_WEED), GangInfo[PlayerInfo[playerid][pGang]][gCrack], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_COCAINE), GangInfo[PlayerInfo[playerid][pGang]][gMeth], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_METH), GangInfo[PlayerInfo[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
		    ShowPlayerDialog(playerid, DIALOG_GANGSTASHDRUGS1, DIALOG_STYLE_LIST, "Gang Locker | Drugs", string, "Select", "Back");
		}
		case DIALOG_GANGSTASHDRUGS2:
		{
		    if(PlayerInfo[playerid][pSelected] == ITEM_WEED) {
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang Locker | Pot", "Withdraw\nDeposit", "Select", "Back");
			} else if(PlayerInfo[playerid][pSelected] == ITEM_COCAINE) {
			    ShowPlayerDialog(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang Locker | Crack", "Withdraw\nDeposit", "Select", "Back");
			} else if(PlayerInfo[playerid][pSelected] == ITEM_METH) {
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang Locker | Meth", "Withdraw\nDeposit", "Select", "Back");
			} else if(PlayerInfo[playerid][pSelected] == ITEM_PAINKILLERS) {
			    ShowPlayerDialog(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang Locker | Painkillers", "Withdraw\nDeposit", "Select", "Back");
			}
		}
		case DIALOG_GANGSTASHAMMO1:
		{
		    format(string, sizeof(string), "HP ammo (%i/%i)\nPoison ammo (%i/%i)\nFMJ ammo (%i/%i)", GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_HPAMMO), GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_POISONAMMO), GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_FMJAMMO));
		    ShowPlayerDialog(playerid, DIALOG_GANGSTASHAMMO1, DIALOG_STYLE_LIST, "Gang Locker | Ammo", string, "Select", "Back");
		}
		case DIALOG_GANGSTASHAMMO2:
		{
		    if(PlayerInfo[playerid][pSelected] == ITEM_HPAMMO) {
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHAMMO2, DIALOG_STYLE_LIST, "Gang Locker | HP ammo", "Withdraw\nDeposit", "Select", "Back");
			} else if(PlayerInfo[playerid][pSelected] == ITEM_POISONAMMO) {
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHAMMO2, DIALOG_STYLE_LIST, "Gang Locker | Poison ammo", "Withdraw\nDeposit", "Select", "Back");
			} else if(PlayerInfo[playerid][pSelected] == ITEM_FMJAMMO) {
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHAMMO2, DIALOG_STYLE_LIST, "Gang Locker | FMJ ammo", "Withdraw\nDeposit", "Select", "Back");
			}
		}
		case DIALOG_GANGSTASHMATS:
		{
		    format(string, sizeof(string), "Withdraw (%i/%i)\nDeposit", GangInfo[PlayerInfo[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS));
			ShowPlayerDialog(playerid, DIALOG_GANGSTASHMATS, DIALOG_STYLE_LIST, "Gang Locker | Materials", string, "Select", "Back");
		}
		case DIALOG_GANGSTASHCASH:
		{
		    format(string, sizeof(string), "Withdraw ($%i/$%i)\nDeposit", GangInfo[PlayerInfo[playerid][pGang]][gCash], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH));
  			ShowPlayerDialog(playerid, DIALOG_GANGSTASHCASH, DIALOG_STYLE_LIST, "Gang Locker | Cash", string, "Select", "Back");
		}
		case DIALOG_GANGWITHDRAW:
		{
		    if(PlayerInfo[playerid][pSelected] == ITEM_WEED) {
		        format(string, sizeof(string), "How much pot would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gPot], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_WEED));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_COCAINE) {
			    format(string, sizeof(string), "How much Crack would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gCrack], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_COCAINE));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_METH) {
		        format(string, sizeof(string), "How much meth would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gMeth], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_METH));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_PAINKILLERS) {
			    format(string, sizeof(string), "How much painkillers would you like to withdraw? (The safe contains %i/%i.)", GangInfo[PlayerInfo[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_MATERIALS) {
		        format(string, sizeof(string), "How much materials would you like to withdraw? (The safe contains %i/%i.)", GangInfo[PlayerInfo[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_CASH) {
			    format(string, sizeof(string), "How much cash would you like to withdraw? (The safe contains $%i/$%i.)", GangInfo[PlayerInfo[playerid][pGang]][gCash], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_HPAMMO) {
		        format(string, sizeof(string), "How much HP ammo would you like to withdraw? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_HPAMMO));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_POISONAMMO) {
		        format(string, sizeof(string), "How much poison ammo would you like to withdraw? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_POISONAMMO));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_FMJAMMO) {
		        format(string, sizeof(string), "How much FMJ ammo would you like to withdraw? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_FMJAMMO));
			}

			ShowPlayerDialog(playerid, DIALOG_GANGWITHDRAW, DIALOG_STYLE_INPUT, "Gang Stash Withdraw | "SERVER_NAME"", string, "Submit", "Back");
		}
		case DIALOG_GANGDEPOSIT:
		{
		    if(PlayerInfo[playerid][pSelected] == ITEM_WEED) {
		        format(string, sizeof(string), "How much pot would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gPot], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_WEED));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_COCAINE) {
			    format(string, sizeof(string), "How much Crack would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gCrack], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_COCAINE));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_METH) {
		        format(string, sizeof(string), "How much meth would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gMeth], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_METH));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_PAINKILLERS) {
			    format(string, sizeof(string), "How much painkillers would you like to deposit? (The safe contains %i/%i.)", GangInfo[PlayerInfo[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_MATERIALS) {
		        format(string, sizeof(string), "How much materials would you like to deposit? (The safe contains %i/%i.)", GangInfo[PlayerInfo[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_CASH) {
			    format(string, sizeof(string), "How much cash would you like to deposit? (The safe contains $%i/$%i.)", GangInfo[PlayerInfo[playerid][pGang]][gCash], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_HPAMMO) {
		        format(string, sizeof(string), "How much HP ammo would you like to deposit? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_HPAMMO));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_POISONAMMO) {
		        format(string, sizeof(string), "How much poison ammo would you like to deposit? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_POISONAMMO));
			} else if(PlayerInfo[playerid][pSelected] == ITEM_FMJAMMO) {
		        format(string, sizeof(string), "How much FMJ ammo would you like to deposit? (The safe contains %i/%i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo], GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_FMJAMMO));
			}

			ShowPlayerDialog(playerid, DIALOG_GANGDEPOSIT, DIALOG_STYLE_INPUT, "Gang Stash Deposit | "SERVER_NAME"", string, "Submit", "Back");
		}
		case DIALOG_GANGARMSPRICES:
		{
		    format(string, sizeof(string), "#\tWeapon\tPrice\tCost\n1\tMicro Uzi\t$%i\t5000 materials\n2\tTec-9\t$%i\t5000 materials\n3\tMP5\t$%i\t10000 materials\n4\tDesert Eagle\t$%i\t20000 materials\n5\tMolotov\t$%i\t999999 materials\n6\tAK-47\t$%i\t30000 materials\n7\tM4\t$%i\t40000 materials\n8\tSniper\t$%i\t999999 materials\n9\tSawnoff Shotgun\t$%i\t999999 materials\n10\tHollow Point Ammo\t$%i\t%i rounds\n11\tPoison Tip Ammo\t$%i\t%i rounds\n12\tFMJ Ammo\t$%i\t%i rounds",
		        GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][0], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][1], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][2], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][3], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][4], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][5], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][6], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][7], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][8],
				GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][9], GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][10], GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][11], GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSPRICES, DIALOG_STYLE_TABLIST_HEADERS, "Choose a weapon price to edit.", string, "Change", "Back");
		}
		case DIALOG_GANGARMSDEALER:
		{
		    ShowPlayerDialog(playerid, DIALOG_GANGARMSDEALER, DIALOG_STYLE_LIST, "Arms dealer", "Buy Guns\nEdit", "Select", "Cancel");
		}
		case DIALOG_GANGARMSWEAPONS:
		{
		    new
		        title[48];

		    format(title, sizeof(title), "Gang arms dealer (Materials available: %i.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials]);

		    format(string, sizeof(string), "#\tWeapon\tPrice\tCost\n1\tMicro Uzi\t$%i\t5000 materials\n2\tTec-9\t$%i\t5000 materials\n3\tMP5\t$%i\t10000 materials\n4\tDesert Eagle\t$%i\t20000 materials\n5\tMolotov\t$%i\t999999 materials\n6\tAK-47\t$%i\t30000 materials\n7\tM4\t$%i\t40000 materials\n8\tSniper\t$%i\t999999 materials\n9\tSawnoff Shotgun\t$%i\t999999 materials",
		        GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][0], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][1], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][2], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][3], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][4], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][5], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][6], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][7],
				GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][8]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSWEAPONS, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Buy", "Back");
		}
		case DIALOG_GANGARMSAMMO:
		{
		    format(string, sizeof(string), "#\tType\tCost\tStock\n1\tHollow Point Ammo\t$%i\t%i rounds\n2\tPoison Tip Ammo\t$%i\t%i rounds\n3\tFMJ Ammo\t$%i\t%i rounds",
				GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][9], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsHPAmmo], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][10], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPoisonAmmo], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][11], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsFMJAmmo]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSAMMO, DIALOG_STYLE_TABLIST_HEADERS, "Arms dealer | Ammo", string, "Buy", "Back");
		}
		case DIALOG_GANGAMMOBUY:
		{
		    if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much hollow point ammo would you like to buy? ($%i per round. %i rounds available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][9], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsHPAmmo]);
			} else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much poison tip ammo would you like to buy? ($%i per round. %i rounds available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][10], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPoisonAmmo]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much FMJ ammo would you like to buy? ($%i per round. %i rounds available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][11], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsFMJAmmo]);
			}

		    ShowPlayerDialog(playerid, DIALOG_GANGAMMOBUY, DIALOG_STYLE_INPUT, "Arms Dealer | Buy Ammo", string, "Submit", "Back");
		}
		case DIALOG_GANGARMSEDIT:
		{
			format(string, sizeof(string), "Arms dealer (Materials available: %i.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSEDIT, DIALOG_STYLE_LIST, string, "Edit prices\nDeposit mats\nWithdraw mats\nDeposit ammo\nWithdraw ammo", "Select", "Back");
		}
		case DIALOG_GANGARMSDEPOSITMATS:
		{
			format(string, sizeof(string), "How much materials would you like to deposit? (This arms dealer contains %i materials.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSDEPOSITMATS, DIALOG_STYLE_INPUT, "Arms dealer | Deposit", string, "Submit", "Back");
		}
		case DIALOG_GANGARMSWITHDRAWMATS:
		{
			format(string, sizeof(string), "How much materials would you like to withdraw? (This arms dealer contains %i materials.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials]);
			ShowPlayerDialog(playerid, DIALOG_GANGARMSWITHDRAWMATS, DIALOG_STYLE_INPUT, "Arms dealer | Withdraw", string, "Submit", "Back");
		}
		case DIALOG_GANGAMMODEPOSITS:
		{
		    format(string, sizeof(string), "Hollow point (%i)\nPoison tip (%i)\nFMJ ammo (%i)", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo]);
		    ShowPlayerDialog(playerid, DIALOG_GANGAMMODEPOSITS, DIALOG_STYLE_LIST, "Arms dealer | Deposit ammo", string, "Select", "Back");
		}
		case DIALOG_GANGAMMODEPOSIT:
		{
		    if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much hollow point ammo would you like to deposit? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo]);
		    } else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much poison tip ammo would you like to deposit? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much FMJ ammo would you like to deposit? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo]);
			}

			ShowPlayerDialog(playerid, DIALOG_GANGAMMODEPOSIT, DIALOG_STYLE_INPUT, "Arms dealer | Deposit ammo", string, "Submit", "Back");
		}
		case DIALOG_GANGAMMOWITHDRAWS:
		{
		    format(string, sizeof(string), "Hollow point (%i)\nPoison tip (%i)\nFMJ ammo (%i)", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo], GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo]);
		    ShowPlayerDialog(playerid, DIALOG_GANGAMMOWITHDRAWS, DIALOG_STYLE_LIST, "Arms dealer | Withdraw ammo", string, "Select", "Back");
		}
        case DIALOG_GANGAMMOWITHDRAW:
		{
			if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much hollow point ammo would you like to withdraw? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo]);
   			} else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much poison tip ammo would you like to withdraw? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much FMJ ammo would you like to withdraw? (This arms dealer contains %i rounds.)", GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo]);
			}

			ShowPlayerDialog(playerid, DIALOG_GANGAMMOWITHDRAW, DIALOG_STYLE_INPUT, "Arms dealer | Withdraw", string, "Submit", "Back");
		}
		case DIALOG_GANGDRUGDEALER:
		{
		    ShowPlayerDialog(playerid, DIALOG_GANGDRUGDEALER, DIALOG_STYLE_LIST, "Drug dealer", "Buy Drugs\nEdit", "Select", "Cancel");
		}
		case DIALOG_GANGDRUGSHOP:
		{
		    format(string, sizeof(string), "Drug\tPrice\tStock\nPot\t$%i\t%i grams\nCrack\t$%i\t%i grams\nMeth\t$%i\t%i grams", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][0], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][1], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][2], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugMeth]);
			ShowPlayerDialog(playerid, DIALOG_GANGDRUGSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Drug dealer", string, "Buy", "Back");
		}
		case DIALOG_GANGDRUGBUY:
		{
		    if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much pot would you like to buy? ($%i per gram. %i grams available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][0], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPot]);
			} else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much Crack would you like to buy? ($%i per gram. %i grams available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][1], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugCrack]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much meth would you like to buy? ($%i per gram. %i grams available.)", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][2], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugMeth]);
			}

		    ShowPlayerDialog(playerid, DIALOG_GANGDRUGBUY, DIALOG_STYLE_INPUT, "Drug dealer | Buy", string, "Submit", "Back");
		}
		case DIALOG_GANGDRUGEDIT:
		{
			format(string, sizeof(string), "Drug dealer (Pot: %i) (Crack: %i) (Meth: %i)", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
			ShowPlayerDialog(playerid, DIALOG_GANGDRUGEDIT, DIALOG_STYLE_LIST, string, "Edit prices\nDeposit drugs\nWithdraw drugs", "Select", "Back");
		}
		case DIALOG_GANGDRUGPRICES:
		{
		    format(string, sizeof(string), "Drug\tPrice\tStock\nPot\t$%i\t%i grams\nCrack\t$%i\t%i grams\nMeth\t$%i\t%i grams", GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][0], GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][1], GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][2], GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
			ShowPlayerDialog(playerid, DIALOG_GANGDRUGPRICES, DIALOG_STYLE_TABLIST_HEADERS, "Choose a drug price to edit.", string, "Change", "Back");
		}
		case DIALOG_GANGDRUGDEPOSITS:
		{
		    format(string, sizeof(string), "Pot (%ig)\nCrack (%ig)\nMeth (%ig)", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
		    ShowPlayerDialog(playerid, DIALOG_GANGDRUGDEPOSITS, DIALOG_STYLE_LIST, "Drug dealer | Deposit", string, "Select", "Back");
		}
		case DIALOG_GANGDRUGDEPOSIT:
		{
		    if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much pot would you like to deposit? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot]);
		    } else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much Crack would you like to deposit? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much meth would you like to deposit? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
			}

			ShowPlayerDialog(playerid, DIALOG_GANGDRUGDEPOSIT, DIALOG_STYLE_INPUT, "Drug dealer | Deposit", string, "Submit", "Back");
		}
		case DIALOG_GANGDRUGWITHDRAWS:
		{
		    format(string, sizeof(string), "Pot (%ig)\nCrack (%ig)\nMeth (%ig)", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
		    ShowPlayerDialog(playerid, DIALOG_GANGDRUGWITHDRAWS, DIALOG_STYLE_LIST, "Drug dealer | Withdraw", string, "Select", "Back");
		}
        case DIALOG_GANGDRUGWITHDRAW:
		{
		    if(PlayerInfo[playerid][pSelected] == 0) {
		        format(string, sizeof(string), "How much pot would you like to withdraw? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot]);
		    } else if(PlayerInfo[playerid][pSelected] == 1) {
		        format(string, sizeof(string), "How much Crack would you like to withdraw? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack]);
			} else if(PlayerInfo[playerid][pSelected] == 2) {
		        format(string, sizeof(string), "How much meth would you like to withdraw? (This drug dealer contains %i grams.)", GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth]);
			}

			ShowPlayerDialog(playerid, DIALOG_GANGDRUGWITHDRAW, DIALOG_STYLE_INPUT, "Drug dealer | Withdraw", string, "Submit", "Back");
		}
		case DIALOG_SETTINGS1:
	    {
			format(string, sizeof(string), "Info\tStatus\n" \
				"Engine\t%s\n" \
		        "Lights\t%s\n" \
		        "Trunk\t%s\n" \
		        "Hood\t%s\n" \
		        "Windows\t%s\n" \
		        "Seatbelt\t%s\n" \
		        "Vehicle Information",
		        (GetVehicleParams(vehicleid, VEHICLE_ENGINE) ? ("{3dcc3f}On") : ("{FF0000}Off")),
		        (GetVehicleParams(vehicleid, VEHICLE_LIGHTS) ? ("{3dcc3f}On") : ("{FF0000}Off")),
		        (GetVehicleParams(vehicleid, VEHICLE_BOOT) ? ("{3dcc3f}Open") : ("{FF0000}Closed")),
		        (GetVehicleParams(vehicleid, VEHICLE_BONNET) ? ("{3dcc3f}Open") : ("{FF0000}Closed")),
		        (CarWindows[vehicleid] == 1) ? ("{3dcc3f}On") : ("{FF0000}Off"),
		        (ExBJck[playerid] == 1) ? ("{3dcc3f}On") : ("{FF0000}Off"));
			ShowPlayerDialog(playerid, DIALOG_SETTINGS1, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Settings", string, "Tog", "Close");
	    }
	    case DIALOG_SETTINGS2:
		{
			format(string, sizeof(string), "Info\tStatus\n" \
				"Owner\t%s\n" \
		        "Value\t$%i\n" \
		        "Tickets\t$%i\n" \
		        "Plate\t%s\n" \
		        "Neon\t%s\n" \
		        "Trunk\t%i/3\n" \
		        "Health\t%.1f\n" \
		        "Fuel\t%i\n" \
		        "Mileage\t%.1f Km\n" \
		        "<< Back",
		        VehicleInfo[vehicleid][vOwner],
		        VehicleInfo[vehicleid][vPrice],
		        VehicleInfo[vehicleid][vTickets],
		        VehicleInfo[vehicleid][vPlate],
		        neon,
		        VehicleInfo[vehicleid][vTrunk],
		        health,
		        vehicleFuel[vehicleid],
		        Milliage[vehicleid]);
			ShowPlayerDialog(playerid, DIALOG_SETTINGS2, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Information", string, "Select", "Close");
		}
		case DIALOG_LOCATE:
		{
		    ShowPlayerDialog(playerid, DIALOG_LOCATE, DIALOG_STYLE_LIST, "List of Destination", "Job Locations\n{FFFF00}SHOPS\n{FF0000}GOOGLE {0000FF}MAPS\nPoints\nTurfs\nIllegal Location", "Select", "Close");
		}
		case DIALOG_PAINTBALL:
		{
		    string =  "Name\tType\tCurrent Players\n";
		    format(string, sizeof(string), "%sDeathmatch Arena\tFFA\t%i\n", string, GetArenaPlayers(1));
		    format(string, sizeof(string), "%sTeam Deathmatch Arena\tTDM\t%i\n", string, GetArenaPlayers(2));
		    format(string, sizeof(string), "%sDeagle Arena\t1Shot\t%i\n", string, GetArenaPlayers(3));
		    format(string, sizeof(string), "%sSniper Arena\t1Shot\t%i\n", string, GetArenaPlayers(4));
		    ShowPlayerDialog(playerid, DIALOG_PAINTBALL, DIALOG_STYLE_TABLIST_HEADERS, "Paintball", string, "Select", "Cancel");
		}
		case DIALOG_TOP: {
			ShowPlayerDialog(playerid, DIALOG_TOP, DIALOG_STYLE_TABLIST, SERVER_DIALOG, ""RED"Top 20 Criminal in the City.\n"YELLOW"Top 20 Richest in the City.\n"GREEN"Top 20 Addict in the City.", "Select", "Close");
		}
		case DIALOG_CREATEQUIZ:
		{
		    if(CreateQuiz == -1)
		    {
		        CreateQuiz = 0;
		    	ShowPlayerDialog(playerid, DIALOG_CREATEQUIZ, DIALOG_STYLE_INPUT, "Create A Quiz - Enter Question", "What should the question be? (displayed globally)", "Submit", "Back");
			}
			if(CreateQuiz == 1)
			{
			    ShowPlayerDialog(playerid, DIALOG_CREATEQUIZ, DIALOG_STYLE_INPUT, "Create A Quiz - Enter Answer", "What should the answer be? (displayed once answered)", "Submit", "Back");
			}
		}
	}
	return 1;
}

GetArenaPlayers(arena)
{
	new players;
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPaintball] == arena)
	    {
	        players++;
	    }
	}
	return players;
}

SetPlayerToSpawn(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		if(PlayerInfo[playerid][pPosX] == 0.0 && PlayerInfo[playerid][pPosY] == 0.0 && PlayerInfo[playerid][pPosZ] == 0.0)
		{
            SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 1529.6, -1691.2, 13.3, 1.0, -1, -1, -1, -1, -1, -1);
		}
		else
		{
            SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ], 1.0, 0, 0, 0, 0, 0, 0);
		}
        for(new i = 0; i < 23; i++)
	    {
	       PlayerTextDrawHide(playerid,SPAWN[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
		TogglePlayerSpectating(playerid, false);
	}
	else
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        new
	            Float:x,
	            Float:y,
	            Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x, y, z + 5.0);
	    }
        for(new i = 0; i < 23; i++)
	    {
	       PlayerTextDrawHide(playerid,SPAWN[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
	    SpawnPlayer(playerid);
	}
    PlayerInfo[playerid][pLastlog] = 0;
	PlayerInfo[playerid][pACTime] = gettime() + 2;
}
SetPlayerToSpawnEx(playerid, id)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
        switch(id)
        {
		   case 0:
		   {
               SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 351.781677, -1800.793457, 7.918819, 1.0, 0, 0, 0, 0, 0, 0);
		   }
		   case 1:
		   {
		       SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 1014.756408, -2004.691406, 14.171871, 1.0, 0, 0, 0, 0, 0, 0);
		   }
		   case 2:
		   {
		       SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][pSkin], 266.055969, -2010.695434, 1.981278, 1.0, 0, 0, 0, 0, 0, 0);
		   }
		}
	    for(new i = 0; i < 23; i++)
        {
	       PlayerTextDrawHide(playerid,SPAWN[playerid][i]);
        }
		CancelSelectTextDraw(playerid);
		TogglePlayerSpectating(playerid, 0);
	}
	else
	{
	  CancelSelectTextDraw(playerid);
	  SpawnPlayer(playerid);
	}
	PlayerInfo[playerid][pACTime] = gettime() + 2;
}
SetPlayerToFacePlayer(playerid, targetid)
{
	new
	    Float:px,
	    Float:py,
	    Float:pz,
	    Float:tx,
	    Float:ty,
	    Float:tz;

	GetPlayerPos(targetid, tx, ty, tz);
	GetPlayerPos(playerid, px, py, pz);
	SetPlayerFacingAngle(playerid, 180.0 - atan2(px - tx, py - ty));
}

SavePlayerWeapons(playerid)
{
	if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pPaintball] == 0 && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID)
	{
		// Saving weapons.
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weapon_0 = %i, weapon_1 = %i, weapon_2 = %i, weapon_3 = %i, weapon_4 = %i, weapon_5 = %i, weapon_6 = %i, weapon_7 = %i, weapon_8 = %i, weapon_9 = %i, weapon_10 = %i, weapon_11 = %i, weapon_12 = %i WHERE uid = %i",
	        PlayerInfo[playerid][pWeapons][0], PlayerInfo[playerid][pWeapons][1], PlayerInfo[playerid][pWeapons][2], PlayerInfo[playerid][pWeapons][3], PlayerInfo[playerid][pWeapons][4], PlayerInfo[playerid][pWeapons][5], PlayerInfo[playerid][pWeapons][6], PlayerInfo[playerid][pWeapons][7], PlayerInfo[playerid][pWeapons][8], PlayerInfo[playerid][pWeapons][9], PlayerInfo[playerid][pWeapons][10], PlayerInfo[playerid][pWeapons][11], PlayerInfo[playerid][pWeapons][12], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		// And finally the ammo.
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hpammo = %i, poisonammo = %i, fmjammo = %i, ammotype = %i, pepperammo = %i,  ammoweapon = %i WHERE uid = %i",
		   PlayerInfo[playerid][pHPAmmo], PlayerInfo[playerid][pPoisonAmmo], PlayerInfo[playerid][pFMJAmmo], PlayerInfo[playerid][pAmmoType],PlayerInfo[playerid][pPepperAmmo], PlayerInfo[playerid][pAmmoWeapon], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

ResetBackpack(playerid)
{
	if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pAdminDuty])
	{
		PlayerInfo[playerid][pBackpack] = 0;
		PlayerInfo[playerid][bpCash] = 0;
		PlayerInfo[playerid][bpMaterials] = 0;
		PlayerInfo[playerid][bpPot] = 0;
		PlayerInfo[playerid][bpCrack] = 0;
		PlayerInfo[playerid][bpMeth] = 0;
		PlayerInfo[playerid][bpPainkillers] = 0;
		PlayerInfo[playerid][bpWeapons][0] = 0;
		PlayerInfo[playerid][bpWeapons][1] = 0;
		PlayerInfo[playerid][bpWeapons][2] = 0;
		PlayerInfo[playerid][bpWeapons][3] = 0;
		PlayerInfo[playerid][bpWeapons][4] = 0;
		PlayerInfo[playerid][bpWeapons][5] = 0;
		PlayerInfo[playerid][bpWeapons][6] = 0;
		PlayerInfo[playerid][bpWeapons][7] = 0;
		PlayerInfo[playerid][bpWeapons][8] = 0;
		PlayerInfo[playerid][bpWeapons][9] = 0;
		PlayerInfo[playerid][bpWeapons][10] = 0;
		PlayerInfo[playerid][bpWeapons][11] = 0;
		PlayerInfo[playerid][bpWeapons][13] = 0;
		PlayerInfo[playerid][bpWeapons][14] = 0;
		PlayerInfo[playerid][bpHPAmmo] = 0;
		PlayerInfo[playerid][bpPoisonAmmo] = 0;
		PlayerInfo[playerid][bpFMJAmmo] = 0;
	}
	SavePlayerVariables(playerid);
}

forward SavePlayerVariables(playerid);
public SavePlayerVariables(playerid)
{
	if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pAdminDuty])
	{
	    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && !IsPlayerInRangeOfPoint(playerid, 2.0, 0.0, 0.0, 0.0) && !PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pPaintball] == 0 && !PlayerInfo[playerid][pAcceptedHelp] && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID)
		{
		    SavePlayerWeapons(playerid);

            GetPlayerCameraPos(playerid, PlayerInfo[playerid][pCameraX], PlayerInfo[playerid][pCameraY], PlayerInfo[playerid][pCameraZ]);
			GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
	        GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);

	        GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	        GetPlayerArmour(playerid, PlayerInfo[playerid][pArmor]);

	        PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
	        PlayerInfo[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET camera_x = '%f', camera_y = '%f', camera_z = '%f', pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i, health = '%f', armor = '%f', minutes = %i, warnings = %i, injured = %i, hospital = %i, spawnhealth = '%f', spawnarmor = '%f', jailtype = %i, jailtime = %i, refunded = %i, helmet = %i WHERE uid = %i", PlayerInfo[playerid][pCameraX], PlayerInfo[playerid][pCameraY],
		PlayerInfo[playerid][pCameraZ], PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ], PlayerInfo[playerid][pPosA], PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pWorld], PlayerInfo[playerid][pHealth], PlayerInfo[playerid][pArmor], PlayerInfo[playerid][pMinutes], PlayerInfo[playerid][pWarnings], PlayerInfo[playerid][pInjured], PlayerInfo[playerid][pHospital], PlayerInfo[playerid][pSpawnHealth],
		PlayerInfo[playerid][pSpawnArmor], PlayerInfo[playerid][pJailType], PlayerInfo[playerid][pJailTime], PlayerInfo[playerid][pRefunded],PlayerInfo[playerid][pHelmet], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET newbiemuted = %i, helpmuted = %i, admuted = %i, livemuted = %i, globalmuted = %i, reportmuted = %i, reportwarns = %i, fightstyle = %i, dirtycash = %i, cash = %i, toggletextdraws = %i, toggleooc = %i, togglephone = %i, toggleadmin = %i, togglehelper = %i, togglenewbie = %i, togglewt = %i, togglevip = %i, backpack = %i, flashlight = %i, chatanim = %i WHERE uid = %i", PlayerInfo[playerid][pNewbieMuted], PlayerInfo[playerid][pHelpMuted], PlayerInfo[playerid][pAdMuted],
		PlayerInfo[playerid][pLiveMuted], PlayerInfo[playerid][pGlobalMuted], PlayerInfo[playerid][pReportMuted], PlayerInfo[playerid][pReportWarns], PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pDirtyCash],PlayerInfo[playerid][pCash], PlayerInfo[playerid][pToggleTextdraws], PlayerInfo[playerid][pToggleOOC], PlayerInfo[playerid][pTogglePhone], PlayerInfo[playerid][pToggleAdmin], PlayerInfo[playerid][pToggleHelper], PlayerInfo[playerid][pToggleNewbie], PlayerInfo[playerid][pToggleWT],
		PlayerInfo[playerid][pToggleVIP], PlayerInfo[playerid][pBackpack], PlayerInfo[playerid][pFlashlight], PlayerInfo[playerid][pChatAnim], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET toggleradio = %i, togglemusic = %i, togglefaction = %i, togglenews = %i, toggleglobal = %i, togglecam = %i, togglehud = %i, pottime = %i, potgrams = %i, showturfs = %i, showlands = %i, watchon = %i, gpson = %i, deathcooldown = %i, detectivecooldown = %i, duty = %i, bandana = %i WHERE uid = %i", PlayerInfo[playerid][pToggleRadio], PlayerInfo[playerid][pToggleMusic],
		PlayerInfo[playerid][pToggleFaction], PlayerInfo[playerid][pToggleNews], PlayerInfo[playerid][pToggleGlobal], PlayerInfo[playerid][pToggleCam], PlayerInfo[playerid][pToggleHUD], PlayerInfo[playerid][pPotTime], PlayerInfo[playerid][pPotGrams], PlayerInfo[playerid][pShowTurfs], PlayerInfo[playerid][pShowLands], PlayerInfo[playerid][pWatchOn], PlayerInfo[playerid][pGPSOn], PlayerInfo[playerid][pDeathCooldown],
		PlayerInfo[playerid][pDetectiveCooldown], PlayerInfo[playerid][pDuty], PlayerInfo[playerid][pBandana], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	// Backpack Info
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpcash = %i, bpmaterials = %i, bppot = %i, bpcrack = %i, bpmeth = %i, bppainkillers = %i, bphpammo = %i, bppoisonammo = %i, bpfmjammo = %i, totalpatients = %i, totalfires = %i, rarecooldown = %i WHERE uid = %i", PlayerInfo[playerid][bpCash], PlayerInfo[playerid][bpMaterials], PlayerInfo[playerid][bpPot], PlayerInfo[playerid][bpCrack], PlayerInfo[playerid][bpMeth],
		PlayerInfo[playerid][bpPainkillers], PlayerInfo[playerid][bpHPAmmo], PlayerInfo[playerid][bpPoisonAmmo], PlayerInfo[playerid][bpFMJAmmo], PlayerInfo[playerid][pTotalPatients], PlayerInfo[playerid][pTotalFires], PlayerInfo[playerid][pRareTime], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	// Backpack Weapons
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_0 = %i, bpweapon_1 = %i, bpweapon_2 = %i, bpweapon_3 = %i, bpweapon_4 = %i, bpweapon_5 = %i, bpweapon_6 = %i, bpweapon_7 = %i, bpweapon_8 = %i, bpweapon_9 = %i, bpweapon_10 = %i, bpweapon_11 = %i, bpweapon_12 = %i, bpweapon_13 = %i, bpweapon_14 = %i WHERE uid = %i", PlayerInfo[playerid][bpWeapons][0], PlayerInfo[playerid][bpWeapons][1], PlayerInfo[playerid][bpWeapons][2], PlayerInfo[playerid][bpWeapons][3],
		PlayerInfo[playerid][bpWeapons][4], PlayerInfo[playerid][bpWeapons][5], PlayerInfo[playerid][bpWeapons][6], PlayerInfo[playerid][bpWeapons][7], PlayerInfo[playerid][bpWeapons][8], PlayerInfo[playerid][bpWeapons][9], PlayerInfo[playerid][bpWeapons][10], PlayerInfo[playerid][bpWeapons][11], PlayerInfo[playerid][bpWeapons][12], PlayerInfo[playerid][bpWeapons][13], PlayerInfo[playerid][bpWeapons][14], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hunger = %i, hungertimer = %i, thirst = %i, thirsttimer = %i, lottery = %i, LotteryB = %i, comserv = %i where uid = %d", PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pHungerTimer], PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pThirstTimer],  PlayerInfo[playerid][pLottery],PlayerInfo[playerid][pLotteryB],PlayerInfo[playerid][pComserv],PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
        
       

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i, gps = %i, poisonammo = %i, energydrink = %i, fmjammo = %i, energyroll = %i, gascan = %i, cigars = %i, pot = %i, crack = %i, painkillers = %i, meth = %i, vest = %i, helmetp = %i, mask = %i, apple = %i, materials = %i, repairkit = %i, acetone = %i, batteries = %i, mobilemethlab = %i, boombox = %i WHERE uid = %i",
			PlayerInfo[playerid][pPhone],         // Phone
			PlayerInfo[playerid][pGPS],            // GPS
			PlayerInfo[playerid][pMilkshake],      // Milkshake
			PlayerInfo[playerid][pRedbull],        // Redbull
			PlayerInfo[playerid][pFMJAmmo],        // Burger
			PlayerInfo[playerid][pRedroll],        // Chickenroll
			PlayerInfo[playerid][pGasCan],         // Gascan
			PlayerInfo[playerid][pCigars],         // Cigar
			PlayerInfo[playerid][pPot],            // Pot
			PlayerInfo[playerid][pCrack],          // Cocaine
			PlayerInfo[playerid][pPainkillers],    // Joint
			PlayerInfo[playerid][pMeth],           // Meth
			PlayerInfo[playerid][pVest],           // Vest
			PlayerInfo[playerid][pHelmet1],        // Helmet
			PlayerInfo[playerid][pMask],           // Mask
			PlayerInfo[playerid][pApple],          // Apple
			PlayerInfo[playerid][pMaterials],      // Mats (Materials)
			PlayerInfo[playerid][pRepairKit],      // RepairKit
			PlayerInfo[playerid][pAcetone],        // Acetone
			PlayerInfo[playerid][pBatteries],      // Battery
			PlayerInfo[playerid][pMobileMethLab],  // MobileMeth
			PlayerInfo[playerid][pBoombox],        // Boombox
			PlayerInfo[playerid][pID]              // Player UID
		);
		mysql_tquery(connectionID, queryBuffer);


	#if defined Christmas
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET candy = %i WHERE uid = %i", PlayerInfo[playerid][pCandy], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	#endif
	}
}

SendPaycheck(playerid)
{
    new paycheck = PlayerInfo[playerid][pPaycheck];
    new interest, rate;
    new tax = (paycheck / 200) * gTax; // 8% tax
    new rent = 0, renting = -1; // temp
    new total = paycheck - tax;

	switch(PlayerInfo[playerid][pVIPPackage])
	{
	    case 0: rate = 1;
	    case 1: rate = 2;
	    case 2: rate = 3;
	    case 3: rate = 4;
	}

	interest = (PlayerInfo[playerid][pBank] / 500) * rate;

	switch(PlayerInfo[playerid][pVIPPackage])
	{
		case 0:
		{
			if(interest > 50000)
			{
				interest = 50000;
			}
		}
		case 1:
		{
			if(interest > 100000)
			{
				interest = 100000;
			}
		}
		case 2:
		{
			if(interest > 150000)
			{
				interest = 150000;
			}
		}
		case 3:
		{
			if(interest > 200000)
			{
				interest = 200000;
			}
		}
	}

	total += interest;

 	if(PlayerInfo[playerid][pRentingHouse])
	{
		for(new i = 0; i < MAX_HOUSES; i ++)
		{
		    if(HouseInfo[i][hExists] && HouseInfo[i][hID] == PlayerInfo[playerid][pRentingHouse] && HouseInfo[i][hRentPrice] > 0)
		    {
		        rent = HouseInfo[i][hRentPrice];
		        renting = i;
			}
		}
	}
	SendClientMessage(playerid, SERVER_COLOR, "_______________________________");
	SM(playerid, COLOR_GREY2, "Job Pay: {33CC33}+$%i", paycheck);

	if(PlayerInfo[playerid][pFaction] >= 0 && FactionInfo[PlayerInfo[playerid][pFaction]][fPaycheck][PlayerInfo[playerid][pFactionRank]] > 0)
	{
	    SM(playerid, COLOR_GREY2, "Faction Pay: {33CC33}+$%i", FactionInfo[PlayerInfo[playerid][pFaction]][fPaycheck][PlayerInfo[playerid][pFactionRank]]);
	    total += FactionInfo[PlayerInfo[playerid][pFaction]][fPaycheck][PlayerInfo[playerid][pFactionRank]];
	}

	SM(playerid, COLOR_GREY2, "Interest: {33CC33}+$%i {C8C8C8}(Rate: %.1f) [MAX: 50K]", interest, floatdiv(float(rate), 10));
	SM(playerid, COLOR_GREY2, "Income Tax: "SVRCLR"-$%i {C8C8C8}(%i Percent)", tax, gTax);

	if(renting != -1)
	{
		if(total >= rent || PlayerInfo[playerid][pBank] >= rent)
		{
		    if(total >= rent)
	    	{
	        	total -= rent;
			}
			else
			{
		    	PlayerInfo[playerid][pBank] -= rent;
			}

			SM(playerid, COLOR_GREY2, "Rent Paid: "SVRCLR"-$%i", rent);
			HouseInfo[renting][hCash] += rent;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[renting][hCash], HouseInfo[renting][hID]);
			mysql_tquery(connectionID, queryBuffer);
		}
		else
		{
		    rent = -1;
		}
	}

	SM(playerid, COLOR_GREY2, "Old Balance: $%i", PlayerInfo[playerid][pBank]);
	SendClientMessage(playerid, SERVER_COLOR, "_______________________________");
	if((gDoubleXP) || PlayerInfo[playerid][pDoubleXP] > 0) {
		SM(playerid, COLOR_GREY2, "New Balance: $%i", PlayerInfo[playerid][pBank] + total);
	} else {
		SM(playerid, COLOR_GREY2, "New Balance: $%i", PlayerInfo[playerid][pBank] + total);
	}
//	SM(playerid, COLOR_GREEN, "You have played %i/25 minutes this hour and earned your paycheck.", PlayerInfo[playerid][pMinutes]);
	Dyuze(playerid, "Payday", "Added to bank account.");
	if(rent == -1)
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rentinghouse = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		PlayerInfo[playerid][pRentingHouse] = 0;
	    SendClientMessage(playerid, COLOR_RED, "You couldn't afford to pay rent and were evicted as a result.");
	}

	AddToTaxVault(tax);

	if((gDoubleXP) || PlayerInfo[playerid][pDoubleXP] > 0) {
		PlayerInfo[playerid][pEXP] += 2;
		PlayerInfo[playerid][pBank] += total * 2;
	} else {
	    PlayerInfo[playerid][pEXP]++;
	    PlayerInfo[playerid][pBank] += total;
	}
	if(PlayerInfo[playerid][pGang] >= 0)
	{
	    GiveGangPoints(PlayerInfo[playerid][pGang], 1);
	}

    PlayerInfo[playerid][pHours]++;
    PlayerInfo[playerid][pMinutes] = 0;
    PlayerInfo[playerid][pPaycheck] = 0;

	if(PlayerInfo[playerid][pWeaponRestricted] > 0)
	{
		PlayerInfo[playerid][pWeaponRestricted]--;
	}
	if((!gDoubleXP) && PlayerInfo[playerid][pDoubleXP] > 0)
	{
	    PlayerInfo[playerid][pDoubleXP]--;

	    if(PlayerInfo[playerid][pDoubleXP] > 0)
	        SM(playerid, COLOR_YELLOW, "Your double XP token expires in %i more hours.", PlayerInfo[playerid][pDoubleXP]);
		else
		    SendClientMessage(playerid, COLOR_YELLOW, "Your double XP token has expired.");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET minutes = 0, hours = hours + 1, exp = %i, bank = %i, paycheck = 0, weaponrestricted = %i, doublexp = %i WHERE uid = %i", PlayerInfo[playerid][pEXP], PlayerInfo[playerid][pBank], PlayerInfo[playerid][pWeaponRestricted], PlayerInfo[playerid][pDoubleXP], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    gTotalHours++;
    SaveServerInfo();
}

HangupCall(playerid, reason)
{
    new callerid = PlayerInfo[playerid][pCallLine];

    if(reason == HANGUP_DROPPED)
    {
        SendClientMessage(playerid, COLOR_WHITE, " The call has been dropped...");
    }
    else
    {
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %s presses a button and hangs up their mobile phone.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, " You hung up your phone and ended the call.");

        CallRemoteFunction("deletecallstream", "i", playerid);

        if(callerid != playerid)
        {
            SendClientMessage(callerid, COLOR_WHITE, " They hung up their phone and ended the call.");
        }
    }

    if(callerid != playerid)
    {
        if(GetPlayerSpecialAction(callerid) == SPECIAL_ACTION_USECELLPHONE)
        {
            SetPlayerSpecialAction(callerid, SPECIAL_ACTION_STOPUSECELLPHONE);
        }

        PlayerInfo[callerid][pCallStage] = 0;
        PlayerInfo[callerid][pCallLine] = INVALID_PLAYER_ID;
    }

    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
    {
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
    }
    CallRemoteFunction("deletecallstream", "i", playerid);
    PlayerInfo[playerid][pCallStage] = 0;
    PlayerInfo[playerid][pCallLine] = INVALID_PLAYER_ID;
}

AddToTaxVault(amount)
{
	gVault += amount;
	SaveServerInfo();
}

SaveServerInfo()
{
    new File:file = fopen("server_info.ini", io_write);

    if(file)
    {
        new
			string[255];
        format(string, sizeof(string), "%i|%i|%i|%s|%s|%i|%i|%i|%i|%i|%i|%s|%s|%i|%i", gTax, gVault, gPlayerRecord, gRecordDate, gServerMOTD, gConnections, gTotalRegistered, gTotalKills, gTotalDeaths, gTotalHours, gAnticheatBans, adminMOTD, helperMOTD, MaxCapCount[0], MaxCapCount[1]);
        fwrite(file, string);
        fclose(file);
	}
}

LoadServerInfo()
{
	new File:file = fopen("server_info.ini", io_read);

	if(file)
	{
	    new string[255];

	    fread(file, string);
	    sscanf(string, "p<|>iiis[24]s[128]iiiiiis[128]s[128]ii", gTax, gVault, gPlayerRecord, gRecordDate, gServerMOTD, gConnections, gTotalRegistered, gTotalKills, gTotalDeaths, gTotalHours, gAnticheatBans, adminMOTD, helperMOTD, MaxCapCount[0], MaxCapCount[1]);
	    fclose(file);
	}

	if(gTax == 0)
	{
	    gTax = 10;
	}
}

RefreshTime()
{
	new hour, minute, string[12];

	gettime(hour, minute);

    format(string, sizeof(string), "%02d:%02d", hour, minute);
	DynamicTextDrawSetString(TimeTD, string);
}

GetBankRobbers()
{
	new count;

    for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
	{
    	if(RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
	    {
	        count++;
		}
	}

	return count;
}

AddToBankRobbery(playerid)
{
    for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
	{
    	if(RobberyInfo[rRobbers][i] == INVALID_PLAYER_ID)
	    {
	        RobberyInfo[rRobbers][i] = playerid;
	        PlayerInfo[playerid][pRobCash] = 0;
	        break;
		}
	}
}

RemoveFromBankRobbery(playerid)
{
    for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
	{
    	if(RobberyInfo[rRobbers][i] == playerid)
	    {
	        RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
		}
	}

	if(!GetBankRobbers())
	{
	  	ResetRobbery();
	}
	else if(RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == INVALID_PLAYER_ID)
	{
	    for(new i = 1; i < MAX_BANK_ROBBERS; i ++)
	    {
	        if(RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
	        {
	            RobberyInfo[rRobbers][0] = RobberyInfo[rRobbers][i];
	            RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
	            SM(RobberyInfo[rRobbers][0], COLOR_GREEN, "You are now the leader of this bank heist!");
	            break;
			}
		}
	}

	PlayerInfo[playerid][pRobCash] = 0;
	PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

	RemovePlayerAttachedObject(playerid, 8);
	RemovePlayerAttachedObject(playerid, 9);
	PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
	DisablePlayerCheckpoint(playerid);

	return 0;
}

IsPlayerInBankRobbery(playerid)
{
	if(RobberyInfo[rPlanning] || RobberyInfo[rStarted])
	{
		for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
		{
	    	if(RobberyInfo[rRobbers][i] == playerid)
		    {
		        return 1;
			}
		}
	}

	return 0;
}

ResetRobbery()
{
    if(RobberyInfo[rStarted])
	{
		SMA(COLOR_LIGHTGREEN, "Breaking News"WHITE": The bank robbery is now finished. $%i was stolen from the bank.", RobberyInfo[rStolen]);
	}
	if(IsValidDynamicObject(RobberyInfo[rObjects][0]))
	{
		DestroyDynamicObject(RobberyInfo[rObjects][0]);
	}
	if(IsValidDynamicObject(RobberyInfo[rObjects][1]))
	{
		DestroyDynamicObject(RobberyInfo[rObjects][1]);
	}

	for(new i = 0; i < 5; i ++)
	{
	    DestroyDynamic3DTextLabel(RobberyInfo[rText][i]);
	    RobberyInfo[rText][i] = Text3D:INVALID_3DTEXT_ID;
	}

	for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
	{
	    RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
	}

    RobberyInfo[rTime] = 12;
    RobberyInfo[rPlanning] = 0;
    RobberyInfo[rStarted] = 0;
    RobberyInfo[rStolen] = 0;
    RobberyInfo[rObjects][0] = CreateDynamicObject(19799, 1678.248901, -988.194702, 671.695007, 0.000000, 0.000000, 0.000000);
    RobberyInfo[rObjects][1] = INVALID_OBJECT_ID;
}

ResetEvent()
{
	if(EventInfo[eStarted])
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pJoinedEvent])
	        {
	            PlayerInfo[i][pJoinedEvent] = 0;
	            SetPlayerToSpawn(i);
			}
		}
	}

	for(new i = 0; i < 5; i ++)
	{
	    EventInfo[eWeapons][i] = 0;
	}

    EventInfo[eReady] = 0;
    EventInfo[eStarted] = 0;
    EventInfo[eLocked] = 0;
    EventInfo[eType] = 0;
    EventInfo[eJoinText] = 0;
    EventInfo[eHealth] = 100.0;
    EventInfo[eArmor] = 0.0;
    EventInfo[eInterior] = 0;
    EventInfo[eWorld] = 0;
    EventInfo[eNext] = 0;
    EventInfo[eCS] = 0;
    EventInfo[eQS] = 0;
    EventInfo[eHeal] = 0;

	for(new i = 0; i < 2; i ++)
	{
	    EventInfo[ePosX][i] = 0.0;
	    EventInfo[ePosY][i] = 0.0;
	    EventInfo[ePosZ][i] = 0.0;
	    EventInfo[ePosA][i] = 0.0;
	    EventInfo[eSkin][i] = 0;
	}
}
CheckServerAd(const szInput[])
{
    if (strfind(szInput, ":", true) == -1) return 0;

    new
        iCount = 0,
        iPeriod = 0,
        iColon = 0,
        iPos = 0,
        iChar;

    while ((iChar = szInput[iPos++]))
    {
        if (iChar >= '0' && iChar <= '9') 
            iCount++;
        else if (iChar == '.') 
            iPeriod++;
        else if (iChar == ':') 
            iColon++;
    }

    if ((iCount >= 7 && iPeriod >= 3 && iColon >= 1) ||
        strfind(szInput, "samp.") != -1 ||
        strfind(szInput, "play.") != -1 ||
        strfind(szInput, ":7777") != -1)
    {
        return 1;
    }

    return 0;
}


ApplyAnimationEx(playerid, const animlib[], const animname[], Float:fDelta, loop, lockx, locky, freeze, time)
{
	ApplyAnimation(playerid, animlib, animname, fDelta, bool:loop, bool:lockx, bool:locky, bool:freeze, bool:time, true);

	if(loop > 0 || freeze  > 0)
	{
		PlayerInfo[playerid][pLoopAnim] = 1;

		if(!PlayerInfo[playerid][pToggleTextdraws] && !PlayerInfo[playerid][pHospital])
		{
			TextDrawShowForPlayer(playerid, AnimationTD);
		}
	}
}
forward ShowPlayerAnimTextdraw(playerid);
public ShowPlayerAnimTextdraw(playerid)
{
		PlayerInfo[playerid][pLoopAnim] = 1;

		if(!PlayerInfo[playerid][pToggleTextdraws])
		{
			TextDrawShowForPlayer(playerid, AnimationTD);
		}
}
PlayerUseAnims(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pOilExTime] > 0 || PlayerInfo[playerid][pHarvestTime] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
	{
	    return 0;
	}

	return 1;
}
GetAvailableAttachedSlot(playerid)
{
	for(new i = 0; i < 10; i ++)
	{
	    if(!IsPlayerAttachedObjectSlotUsed(playerid, i))
	    {
	        return i;
		}
	}

	return -1;
}

SetFreezePos(playerid, Float:x, Float:y, Float:z)
{
    if(PlayerInfo[playerid][pFreezeTimer] >= 0)
	{
		KillTimer(PlayerInfo[playerid][pFreezeTimer]);
	}
	SetPlayerPos(playerid, x, y, z);
    PlayerInfo[playerid][pFreezeTimer] = SetTimerEx("UnfreezePlayer", 3000, false, "ifff", playerid, x, y, z);

    TogglePlayerControllable(playerid, 0);
	//ShowFreezeTextdraw(playerid);
}

IsPlayerChatActive(playerid)
{
	foreach(new i : Player)
	{
	    if(chattingWith[playerid]{i})
	    {
	        return 1;
		}
	}

	return 0;
}

PlayerHasJob(playerid, job)
{
	if(!Job_IsEnabled(job))
	{
		return 0;
	}

    return (PlayerInfo[playerid][pJob] == job || PlayerInfo[playerid][pSecondJob] == job);
}

SetScriptArmour(playerid, Float:amount)
{
    PlayerInfo[playerid][pACTime] = gettime() + 5;
	PlayerInfo[playerid][pArmorTime] = gettime() + 5;
	PlayerInfo[playerid][pArmor] = amount;
	return SetPlayerArmour(playerid, amount);
}

forward HideItemBox(playerid);
public HideItemBox(playerid)
{
	if(!IndexItemBox[playerid]) return 1;
	--IndexItemBox[playerid];
	MaxPlayerItemBox[playerid]--;
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawItemBox[playerid][(IndexItemBox[playerid]*10)+i]);
	return 1;
}

stock showitembox(playerid, const string[], const total[], model, time)
{
	if(MaxPlayerItemBox[playerid] == 5) return 1;
	MaxPlayerItemBox[playerid]++;
	new validtime = time*1000;
	for(new x=-1; ++x <IndexItemBox[playerid];)
	{
		for(new i=-1;++i<9;) PlayerTextDrawDestroy(playerid, TextDrawItemBox[playerid][(x*10) + i]);
		InfoItemBox[playerid][IndexItemBox[playerid]-x] = InfoItemBox[playerid][(IndexItemBox[playerid]-x)-1];
	}
    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
	format(InfoItemBox[playerid][0][ItemBoxMessage], 320, "%s", string);
	format(InfoItemBox[playerid][0][ItemBoxJumlahMessage], 200, "%s", total);
	InfoItemBox[playerid][0][ItemBoxIcon] = model;

	++IndexItemBox[playerid];
	new Float:new_x=0.0;
	for(new x=-1;++x<IndexItemBox[playerid];)
	{
		CreateItemBox(playerid, x, x * 10, new_x);
		new_x += (InfoItemBox[playerid][x][ItemBoxSize]*7.25)+55.0;
	}
	SetTimerEx("HideItemBox", validtime, false, "d", playerid);
	return 1;
}

stock CreateItemBox(const playerid, index, i, const Float:new_x)
{
	new lines = InfoItemBox[playerid][index][ItemBoxSize];
	new Float:x = (lines * 10) + new_x;
	new Float:posisibaru = x-14.0;
	
	TextDrawItemBox[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000+posisibaru, 108.500000, "");
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawLetterSize(playerid, TextDrawItemBox[playerid][i], 0.425000, 1.400000);
	PlayerTextDrawTextSize(playerid, TextDrawItemBox[playerid][i], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], -1);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 255);
	PlayerTextDrawBoxColour(playerid, TextDrawItemBox[playerid][i], 50);
	PlayerTextDrawUseBox(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);

	TextDrawItemBox[playerid][++i] = CreatePlayerTextDraw(playerid, 339.000+posisibaru, 322.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, TextDrawItemBox[playerid][i], 52.000, 68.000);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], 859394047);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 255);
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);

	TextDrawItemBox[playerid][++i] = CreatePlayerTextDraw(playerid, 343.000+posisibaru, 331.000, "_");
	PlayerTextDrawTextSize(playerid, TextDrawItemBox[playerid][i], 44.000, 49.000);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 5);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetPreviewModel(playerid, TextDrawItemBox[playerid][i], InfoItemBox[playerid][index][ItemBoxIcon]);
	PlayerTextDrawSetPreviewRot(playerid, TextDrawItemBox[playerid][i], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, TextDrawItemBox[playerid][i], 0, 0);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);

	TextDrawItemBox[playerid][++i] = CreatePlayerTextDraw(playerid, 340.000+posisibaru, 322.000, InfoItemBox[playerid][index][ItemBoxJumlahMessage]);
	PlayerTextDrawLetterSize(playerid, TextDrawItemBox[playerid][i], 0.129, 0.999);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 150);
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);

	TextDrawItemBox[playerid][++i] = CreatePlayerTextDraw(playerid, 366.000+posisibaru, 374.000, InfoItemBox[playerid][index][ItemBoxMessage]);
	PlayerTextDrawLetterSize(playerid, TextDrawItemBox[playerid][i], 0.129, 0.999);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 2);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 150);
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);

	TextDrawItemBox[playerid][++i] = CreatePlayerTextDraw(playerid, 339.000+posisibaru, 388.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, TextDrawItemBox[playerid][i], 52.000, 3.000);
	PlayerTextDrawAlignment(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawColour(playerid, TextDrawItemBox[playerid][i], 1756666111);
	PlayerTextDrawSetShadow(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawItemBox[playerid][i], 0);
	PlayerTextDrawBackgroundColour(playerid, TextDrawItemBox[playerid][i], 255);
	PlayerTextDrawFont(playerid, TextDrawItemBox[playerid][i], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawItemBox[playerid][i], 1);
	PlayerTextDrawShow(playerid, TextDrawItemBox[playerid][i]);
	return true;
}

GetWeaponClipSize(weaponid)
{
    switch(weaponid)
    {
        case 22, 23:
			return 17;
        case 26:
            return 2;
        case 24, 27:
			return 7;
        case 28, 31, 32:
			return 50;
        case 29, 30:
			return 30;
    }

    return 0;
}

ResetPlayerWeaponsEx(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPlayerArmedWeapon(playerid, WEAPON_FIST);

	for(new i = 0; i < 13; i ++)
	{
	    PlayerInfo[playerid][pWeapons][i] = 0;
	    PlayerInfo[playerid][pTempWeapons][i] = 0;
	}

	PlayerInfo[playerid][pACTime] = gettime() + 2;
}



SetWeaponAmmo(playerid, type, amount)
{
	if(type == AMMO_HP) {
		PlayerInfo[playerid][pHPAmmo] = amount;
	} else if(type == AMMO_POISON) {
	    PlayerInfo[playerid][pPoisonAmmo] = amount;
	} else if(type == AMMO_FMJ) {
	    PlayerInfo[playerid][pFMJAmmo] = amount;
	}

	SetPlayerWeapons(playerid);
}

GiveWeapon(playerid, weaponid, bool:temp = false)
{
    if(PlayerInfo[playerid][pWeaponRestricted]) return 1;
	if(1 <= weaponid <= 46)
	{
	    if(temp)
		{
			PlayerInfo[playerid][pTempWeapons][weaponSlotIDs[weaponid]] = weaponid;
			GivePlayerWeapon(playerid, weaponid, 9999999);
	    }
		else
		{
			PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] = weaponid;
			SetPlayerWeapons(playerid);
		}

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SetPlayerArmedWeapon(playerid, 0);
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			switch(weaponid)
			{
		    	case 22, 28, 29, 32:
		    	{
		    	    SetPlayerArmedWeapon(playerid, weaponid);
			    }
			    default:
			    {
		    	    SetPlayerArmedWeapon(playerid, 0);
				}
			}
		}
		else
		{
		    SetPlayerArmedWeapon(playerid, weaponid);
		}

		SavePlayerWeapons(playerid);

		PlayerInfo[playerid][pACTime] = gettime() + 2;
	}
	return 1;
}

IsAFlashingEXB(carid)
{
	switch(GetVehicleModel(carid)) {
		case 596, 597, 598, 599, 541, 426, 427, 416, 407, 560, 490: return 1;
	}
	return 0;
}
SQL_ReturnEscaped(const string[])
{
	new
	    entry[256];

	mysql_escape_string(string, entry, sizeof(entry), connectionID);
	return entry;
}

GivePlayerWeaponEx(playerid, WEAPON:weaponid, bool:temp = false)
{
	if(1 <= weaponid <= 46)
	{
	    if(temp)
		{
			PlayerInfo[playerid][pTempWeapons][weaponSlotIDs[weaponid]] = weaponid;
			GivePlayerWeapon(playerid, weaponid, 29999);
	    }
		else
		{
			PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] = weaponid;
			SetPlayerWeapons(playerid);
		}

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SetPlayerArmedWeapon(playerid, 0);
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			switch(weaponid)
			{
		    	case 22, 23, 25, 28..34:
		    	{
		    	    SetPlayerArmedWeapon(playerid, weaponid);
			    }
			    default:
			    {
		    	    SetPlayerArmedWeapon(playerid, 0);
				}
			}
		}
		else
		{
		    SetPlayerArmedWeapon(playerid, weaponid);
		}

		SavePlayerWeapons(playerid);

		PlayerInfo[playerid][pACTime] = gettime() + 2;
	}
}

GetScriptWeapon(playerid)
{
	new WEAPON:weaponid = GetPlayerWeapon(playerid);

	if(PlayerHasWeapon(playerid, weaponid))
	{
	    return weaponid;
	}

	return 0;
}



AddCommas(number, const separator[] = ",")
{
	new output[15]; // longest possible output given 32 bit integers: -2,147,483,648
	format(output, sizeof(output), "%d", number);

	for(new i = strlen(output) - 3; i > 0 && output[i-1] != '-'; i -= 3)
	{
		strins(output, separator, i);
	}

	return output;
}
PlayerHasWeapon(playerid, weaponid, bool:temp = false)
{
	switch(weaponid)
	{
	    case 0, 2, 40, 46:
	    {
	        return 1;
		}
	}

	if(weaponid == 23 && (PlayerInfo[playerid][pTazer] || (IsLawEnforcement(playerid) || GetFactionType(playerid) == FACTION_GOVERNMENT)))
	{
	    return 1;
	}

	if((temp) && PlayerInfo[playerid][pTempWeapons][weaponSlotIDs[weaponid]] == weaponid)
	{
	    return 1;
	}

	return PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] == weaponid;
}

SetPlayerWeapons(playerid)
{
	if(!PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pPaintball] == 0 && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID && !PlayerInfo[playerid][pJailType] && !PlayerInfo[playerid][pWeaponRestricted])
	{
		new weaponid = GetPlayerWeapon(playerid);

		ResetPlayerWeapons(playerid);

		for(new i = 0; i < 13; i ++)
		{
		    if(PlayerInfo[playerid][pWeapons][i] > 0)
		    {
				if(PlayerInfo[playerid][pAmmoType] != AMMOTYPE_NORMAL && PlayerInfo[playerid][pAmmoWeapon] == PlayerInfo[playerid][pWeapons][i])
				{
				    if(PlayerInfo[playerid][pAmmoType] == AMMOTYPE_HP && PlayerInfo[playerid][pHPAmmo] > 0) {
				        GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], PlayerInfo[playerid][pHPAmmo]);
				    } else if(PlayerInfo[playerid][pAmmoType] == AMMOTYPE_POISON && PlayerInfo[playerid][pPoisonAmmo] > 0) {
				        GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], PlayerInfo[playerid][pPoisonAmmo]);
					} else if(PlayerInfo[playerid][pAmmoType] == AMMOTYPE_FMJ && PlayerInfo[playerid][pFMJAmmo] > 0) {
					    GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], PlayerInfo[playerid][pFMJAmmo]);
				    } else {
						GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], 19999);
						SM(playerid, COLOR_WHITE, "** Your %s is now using normal ammunition again as you ran out of special ammo.", GetWeaponNameEx(PlayerInfo[playerid][pWeapons][i]));
						PlayerInfo[playerid][pAmmoType] = AMMOTYPE_NORMAL;
						PlayerInfo[playerid][pAmmoWeapon] = 0;
					}
				}
				else
				{
				    if(16 <= PlayerInfo[playerid][pWeapons][i] <= 18)
				        GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], 1);
				    else if (PlayerInfo[playerid][pWeapons][i] == 41)
                        GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i],PlayerInfo[playerid][pPepperAmmo]);
				    else
						GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], 19999);
				}
			}
		}

		switch(GetPlayerState(playerid))
		{
		    case PLAYER_STATE_DRIVER:
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
			case PLAYER_STATE_PASSENGER:
			{
			    switch(weaponid) // Driveby
			    {
			        case 22, 28, 29, 32:
			        {
			            SetPlayerArmedWeapon(playerid, weaponid);
					}
					default:
					{
					    SetPlayerArmedWeapon(playerid, 0);
					}
				}
			}
			default:
			{
			    SetPlayerArmedWeapon(playerid, weaponid);
		    }
		}
	}
}
DestroyVehicleEx(vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		ResetVehicleObjects(vehicleid);
	}

	return DestroyVehicle(vehicleid);
}

ResetVehicleObjects(vehicleid)
{
    if(IsValidDynamicObject(vehicleSiren[vehicleid]))
	{
	    DestroyDynamicObject(vehicleSiren[vehicleid]);
	    vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
	}
	if(IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
		vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
		DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
	}
 	if(VehicleInfo[vehicleid][vNeonEnabled])
	{
		if(IsValidDynamicObject(VehicleInfo[vehicleid][vObjects][0]))
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
		    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		}
		if(IsValidDynamicObject(VehicleInfo[vehicleid][vObjects][1]))
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
		    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
		}
 	}

 	adminVehicle{vehicleid} = false;
}
SetPlayerClothing(playerid)
{
	// Reset any clothing that the player has on them.
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
	    {
	        RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex]);
		}
	}

	// Now, we reapply the clothing to the player.
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
		{
		    if(ClothingInfo[playerid][i][cAttachedIndex] == -1)
		    {
			    ClothingInfo[playerid][i][cAttachedIndex] = GetAvailableAttachedSlot(playerid);
			}

		    if(ClothingInfo[playerid][i][cAttachedIndex] >= 0)
		    {
		        SetPlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex], ClothingInfo[playerid][i][cModel], ClothingInfo[playerid][i][cBone], ClothingInfo[playerid][i][cPosX], ClothingInfo[playerid][i][cPosY], ClothingInfo[playerid][i][cPosZ], ClothingInfo[playerid][i][cRotX], ClothingInfo[playerid][i][cRotY], ClothingInfo[playerid][i][cRotZ], ClothingInfo[playerid][i][cScaleX], ClothingInfo[playerid][i][cScaleY], ClothingInfo[playerid][i][cScaleZ]);
			}
			else
			{
			    // Clothing wasn't attached... slots are probably all full.
			    ClothingInfo[playerid][i][cAttached] = 0;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET attached = 0 WHERE id = %i", ClothingInfo[playerid][i][cID]);
			    mysql_tquery(connectionID, queryBuffer);
			}
		}
	}

	PlayerInfo[playerid][pAwaitingClothing] = 0;
}

SetPlayerInPaintball(playerid, type)
{
    if(PlayerInfo[playerid][pPaintball] == 0)
	{
		SavePlayerVariables(playerid);
		ResetPlayerWeapons(playerid);
	}
	if(type == 1)
	{
		new rand = random(sizeof(paintballFSpawns));
		SetPlayerPos(playerid, paintballFSpawns[rand][0], paintballFSpawns[rand][1], paintballFSpawns[rand][2]);
		SetPlayerFacingAngle(playerid, paintballFSpawns[rand][3]);
		SetPlayerInterior(playerid, 18);
		SetPlayerVirtualWorld(playerid, 1000);
		SetCameraBehindPlayer(playerid);

		SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 100.0);

		GivePlayerWeaponEx(playerid, 24, true);
		//GivePlayerWeaponEx(playerid, 27, true);
		GivePlayerWeaponEx(playerid, 29, true);
		GivePlayerWeaponEx(playerid, 31, true);
		GivePlayerWeaponEx(playerid, 34, true);

		PlayerInfo[playerid][pPaintball] = 1;
	}
	else if(type == 2)
	{
		SetPlayerPos(playerid, paintballTSpawns[pbNext][0], paintballTSpawns[pbNext][1], paintballTSpawns[pbNext][2]);
		SetPlayerFacingAngle(playerid, paintballTSpawns[pbNext][3]);
		SetPlayerInterior(playerid, 18);
		SetPlayerVirtualWorld(playerid, 1001);
		SetCameraBehindPlayer(playerid);

	    SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 100.0);

		GivePlayerWeaponEx(playerid, 24, true);
		//GivePlayerWeaponEx(playerid, 27, true);
		GivePlayerWeaponEx(playerid, 29, true);
		GivePlayerWeaponEx(playerid, 31, true);
		GivePlayerWeaponEx(playerid, 34, true);

		PlayerInfo[playerid][pPaintball] = 2;
		PlayerInfo[playerid][pPaintballTeam] = pbNext;
		if(!pbNext)
		{
		    pbNext = 1;
		}
		else
		{
		    pbNext = 0;
		}
	}
	else if(type == 3)
	{
	    new rand = random(sizeof(paintballDSpawns));
		SetPlayerPos(playerid, paintballDSpawns[rand][0], paintballDSpawns[rand][1], paintballDSpawns[rand][2]);
		SetPlayerFacingAngle(playerid, paintballDSpawns[rand][3]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 1000);
		SetCameraBehindPlayer(playerid);

		GangZoneShowForPlayer(playerid, zone_paintball[0], 0xFFFF0096);

	    SetPlayerHealth(playerid, 25.0);
		SetPlayerArmour(playerid, 0.0);

		GivePlayerWeaponEx(playerid, 24, true);

		PlayerInfo[playerid][pPaintball] = 3;
	}
	else if(type == 4)
	{
		new rand = random(sizeof(paintballSSpawns));
		SetPlayerPos(playerid, paintballSSpawns[rand][0], paintballSSpawns[rand][1], paintballSSpawns[rand][2]);
		SetPlayerFacingAngle(playerid, paintballSSpawns[rand][3]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 1001);
		SetCameraBehindPlayer(playerid);

		GangZoneShowForPlayer(playerid, zone_paintball[1], 0xFFFF0096);

	    SetPlayerHealth(playerid, 25.0);
		SetPlayerArmour(playerid, 0.0);

		GivePlayerWeaponEx(playerid, 34, true);

		PlayerInfo[playerid][pPaintball] = 4;
	}
}

SetPlayerInEvent(playerid)
{
    SavePlayerVariables(playerid);
	ResetPlayerWeapons(playerid);

	PlayerInfo[playerid][pJoinedEvent] = 1;
	PlayerInfo[playerid][bpWearing] = 0;
	PlayerInfo[playerid][pBandana] = 0;

	if(EventInfo[eType] == 2)
	{
		PlayerInfo[playerid][pEventTeam] = EventInfo[eNext];

		if(EventInfo[eNext] == RED_TEAM) {
			EventInfo[eNext] = BLUE_TEAM;
		} else {
	    	EventInfo[eNext] = RED_TEAM;
		}

		if(PlayerInfo[playerid][pEventTeam] == RED_TEAM) {
			Dyuze(playerid, "Notice", "You are on ~r~Red Team.");
		} else if(PlayerInfo[playerid][pEventTeam] == BLUE_TEAM) {
			Dyuze(playerid, "Notice", "You are on ~b~Red Team.");
		}
	}
	else
	{
	    PlayerInfo[playerid][pEventTeam] = 0;
	}

	SetPlayerPos(playerid, EventInfo[ePosX][PlayerInfo[playerid][pEventTeam]], EventInfo[ePosY][PlayerInfo[playerid][pEventTeam]], EventInfo[ePosZ][PlayerInfo[playerid][pEventTeam]]);
	SetPlayerFacingAngle(playerid, EventInfo[ePosA][PlayerInfo[playerid][pEventTeam]]);
	SetPlayerInterior(playerid, EventInfo[eInterior]);
	SetPlayerVirtualWorld(playerid, EventInfo[eWorld]);
	SetPlayerHealth(playerid, EventInfo[eHealth]);
	SetPlayerArmour(playerid, EventInfo[eArmor]);
	SetCameraBehindPlayer(playerid);

    if(EventInfo[eSkin][PlayerInfo[playerid][pEventTeam]])
	{
		SetPlayerSkin(playerid, EventInfo[eSkin][PlayerInfo[playerid][pEventTeam]]);
	}

	if(!isnull(EventInfo[eJoinText]))
	{
		Dyuze(playerid, "Event", EventInfo[eJoinText]);
	}

	if(EventInfo[eType] == 1 || EventInfo[eType] == 2)
	{
		SM(playerid, COLOR_YELLOW, "Event: Crackshooting is %s, Quickswapping is %s, Healing is %s.", (EventInfo[eCS]) ? ("{FFD700}Allowed"WHITE"") : ("{FFA500}Not allowed"WHITE""), (EventInfo[eQS]) ? ("{FFD700}Allowed"WHITE"") : ("{FFA500}Not allowed"WHITE""), (EventInfo[eHeal]) ? ("{FFD700}Allowed"WHITE"") : ("{FFA500}Not allowed"WHITE""));
	}

	return 1;
}

SetPlayerInHospital(playerid, time = 15, type = -1)
{
    PlayerInfo[playerid][pHospitalType] = (type == -1) ? (random(2) + 1) : (type);
    PlayerInfo[playerid][pHospitalTime] = time;
    PlayerInfo[playerid][pHospital] = 1;
    PlayerInfo[playerid][pInjured] = 0;
    
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
    SetPlayerPos(playerid, 1800.020874, -1713.662841, 14.112992);
	SetPlayerFacingAngle(playerid, 90);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("UnfreezePlayerEx", 14000, false, "i", playerid);
    InterpolateCameraLookAt(playerid, 1797.454956, -1710.072387, 13.346872, 1798.348632, -1711.462158, 13.346872, 14000);
}

SetPlayerInJail(playerid)
{
	if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
 		HangupCall(PlayerInfo[playerid][pCallLine], HANGUP_DROPPED);
	}

	if(PlayerInfo[playerid][pJailType] == 1) // /prisonic
	{
		switch(random(4))
        {
            case 0:
			{
				SetPlayerPos(playerid, 935.059204, -1635.278442, 15.042007);
			}
			case 1:
			{
				SetPlayerPos(playerid, 947.114135, -1636.006225, 15.042007 );
			}
			case 2:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
			case 3:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
			default:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
		}
		ResetPlayerWeaponsEx(playerid);
		ResetPlayer(playerid);
		SetPlayerFacingAngle(playerid, 139.4496);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnfreezePlayerEx", 8000, false, "i", playerid);
	}
	else if(PlayerInfo[playerid][pJailType] == 2) // /jail /prison
	{
		switch(random(3))
        {
            case 0:
			{
				SetPlayerPos(playerid, 935.059204, -1635.278442, 15.042007);
			}
			case 1:
			{
				SetPlayerPos(playerid, 947.114135, -1636.006225, 15.042007 );
			}
			case 2:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
			case 3:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}

		}
		ResetPlayerWeaponsEx(playerid);
		ResetPlayer(playerid);
		SetPlayerFacingAngle(playerid, 139.4496);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnfreezePlayerEx", 8000, false, "i", playerid);
	}
	else if(PlayerInfo[playerid][pJailType] == 3) // IC prison
	{
		switch(random(3))
        {
            case 0:
			{
				SetPlayerPos(playerid, 935.059204, -1635.278442, 15.042007);
			}
			case 1:
			{
				SetPlayerPos(playerid, 947.114135, -1636.006225, 15.042007 );
			}
			case 2:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
			case 3:
			{
				SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
			}
		}
		ResetPlayerWeaponsEx(playerid);
		ResetPlayer(playerid);
		SetPlayerFacingAngle(playerid, 139.4496);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnfreezePlayerEx", 8000, false, "i", playerid);
	}
	ResetPlayerWeaponsEx(playerid);
	ResetPlayer(playerid);
	SetCameraBehindPlayer(playerid);
	SetPlayerArmedWeapon(playerid, 0);
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("UnfreezePlayerEx", 8000, false, "i", playerid);
}

TeleportToVehicle(playerid, vehicleid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
		Float:a,
		interior,
		garageid;

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);

	if((garageid = GetVehicleGarage(vehicleid)) >= 0)
	{
 		interior = garageInteriors[GarageInfo[garageid][gType]][intID];
	}

	TeleportToCoords(playerid, x + 1, y + 1, z + 1, a, interior, GetVehicleVirtualWorld(vehicleid));
}

TeleportToPlayer(playerid, targetid, bool:vehicle = true)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
		Float:a;

	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);

	TeleportToCoords(playerid, x + 1, y + 1, z, a, GetPlayerInterior(targetid), GetPlayerVirtualWorld(targetid), .vehicle = vehicle);
}

TeleportToCoords(playerid, Float:x, Float:y, Float:z, Float:angle, interiorid, worldid, bool:freeze = false, bool:vehicle = true)
{

	if((vehicle) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
	    foreach(new i : Player)
	    {
	        if(IsPlayerInVehicle(i, vehicleid))
	        {
	            SetPlayerInterior(i, interiorid);
	            SetPlayerVirtualWorld(i, worldid);
			}
	    }

        SetVehiclePos(vehicleid, x, y, z);
     	SetVehicleZAngle(vehicleid, angle);
	    SetVehicleVirtualWorld(vehicleid, worldid);
	    LinkVehicleToInterior(vehicleid, interiorid);
	}
	else
	{
	    SetPlayerPos(playerid, x, y, z);
	    SetPlayerFacingAngle(playerid, angle);
		SetPlayerInterior(playerid, interiorid);
		SetPlayerVirtualWorld(playerid, worldid);
		SetCameraBehindPlayer(playerid);
	}

	if((freeze) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
        SetTimerEx("VehicleUnfreeze", 3000, false, "iifffii", playerid, GetPlayerVehicleID(playerid), x, y, z, interiorid, worldid);
        //ShowFreezeTextdraw(playerid);
        TogglePlayerControllable(playerid, false);
	}
}
TeleportToGarage(playerid, Float:x, Float:y, Float:z, Float:angle, interiorid, worldid, bool:freeze = true, bool:vehicle = true)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if((vehicle) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    foreach(new i : Player)
	    {
	        if(IsPlayerInVehicle(i, vehicleid))
	        {
	            SetPlayerInterior(i, interiorid);
	            SetPlayerVirtualWorld(i, worldid);
			}
	    }

        SetVehiclePos(vehicleid, x, y, z);
     	SetVehicleZAngle(vehicleid, angle);
	    SetVehicleVirtualWorld(vehicleid, worldid);
	    LinkVehicleToInterior(vehicleid, interiorid);
	}
	else
	{
	    SetPlayerPos(playerid, x, y, z);
	    SetPlayerFacingAngle(playerid, angle);
		SetPlayerInterior(playerid, interiorid);
		SetPlayerVirtualWorld(playerid, worldid);
		SetCameraBehindPlayer(playerid);
	}

	if((freeze) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
        SetTimerEx("VehicleUnfreeze", 3000, false, "iifffii", playerid, GetPlayerVehicleID(playerid), x, y, z, interiorid, worldid);
		Dyuze(playerid, "Notice", "Loading objects...");
        TogglePlayerControllable(playerid, 0);
	}
}
ShowLandsOnMap(playerid, enable)
{
	for(new i = 0; i < MAX_LANDS; i ++)
	{
	    if(LandInfo[i][lExists])
	    {
		    if(enable) {
 				GangZoneShowForPlayer(playerid, LandInfo[i][lGangZone], (LandInfo[i][lOwnerID] > 0) ? (0x0080FFAA) : (0x33CC33AA));
			} else {
		    	GangZoneHideForPlayer(playerid, LandInfo[i][lGangZone]);
			}
		}
	}

	PlayerInfo[playerid][pShowLands] = enable;
}

ShowTurfsOnMap(playerid, enable)
{
	for(new i = 0; i < MAX_TURFS; i ++)
	{
	    if(TurfInfo[i][tExists])
	    {
		    if(enable)
			{
			    GangZoneShowForPlayer(playerid, TurfInfo[i][tGangZone], GetTurfColor(i));
                if(TurfInfo[i][tType] == 11)
			    {
			        if(TurfInfo[i][tTime])
			        {
			            GangZoneStopFlashForPlayer(playerid, TurfInfo[i][tGangZone]);
			        }
			        else if(TurfInfo[i][tInfluenceTime])
			        {
			            if(TurfInfo[i][tInfluenceGang] == -1)
			            {
				        	GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], 0x000000AA);
						}
						else
						{
							GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], 0x000000AA);
						}
			        }
			    }
			    else
			    {
				    if(TurfInfo[i][tCapturer] == INVALID_PLAYER_ID)
				    {
	                    GangZoneStopFlashForPlayer(playerid, TurfInfo[i][tGangZone]);
				    }
				    else
				    {
					    if(PlayerInfo[TurfInfo[i][tCapturer]][pGang] == -1 && GetFactionType(TurfInfo[i][tCapturer]) == FACTION_POLICE)
					        GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], 0x000000AA);
						else if(PlayerInfo[TurfInfo[i][tCapturer]][pGang] >= 0)
							GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], (GangInfo[PlayerInfo[TurfInfo[i][tCapturer]][pGang]][gColor] & ~0xff) + 0xAA);
					}
				}
			}
			else
			{
		    	GangZoneHideForPlayer(playerid, TurfInfo[i][tGangZone]);
			}
		}
	}

	PlayerInfo[playerid][pShowTurfs] = enable;
}
ShowPointsOnMap(playerid, enable)
{
	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists])
	    {
		    if(enable)
			{
			    GangZoneShowForPlayer(playerid, PointInfo[i][pGangZone],  0xFF00008C);
                if(PointInfo[i][pTime] == 0 && PointInfo[i][pCapturer] != INVALID_PLAYER_ID)
			    {
			        if(PointInfo[i][pTime])
			        {
			            GangZoneStopFlashForPlayer(playerid, PointInfo[i][pGangZone]);
			        }
			        else if(PointInfo[i][pTime] == 0 && PointInfo[i][pCapturer] != INVALID_PLAYER_ID)
			        {
			            if(PointInfo[i][pTime] == 0 && PointInfo[i][pCapturer] != INVALID_PLAYER_ID)
			            {
				        	GangZoneFlashForPlayer(playerid, PointInfo[i][pGangZone], 0x000000AA);
						}
			        }
			    }

			}
			else
			{
		    	GangZoneHideForPlayer(playerid,PointInfo[i][pGangZone]);
			}
		}
	}

	PlayerInfo[playerid][pShowPoints] = enable;
}
CancelZoneCreation(playerid)
{
    for(new i = 0; i < 4; i ++)
    {
        DestroyDynamicPickup(PlayerInfo[playerid][pZonePickups][i]);
        PlayerInfo[playerid][pZonePickups][i] = -1;
	}

	GangZoneDestroy(PlayerInfo[playerid][pZoneID]);

	PlayerInfo[playerid][pZoneID] = -1;
	PlayerInfo[playerid][pZoneCreation] = 0;
    PlayerInfo[playerid][pMinX] = 0.0;
    PlayerInfo[playerid][pMinY] = 0.0;
    PlayerInfo[playerid][pMaxX] = 0.0;
    PlayerInfo[playerid][pMaxY] = 0.0;
}

ResetPlayer(playerid)
{
    if(PlayerInfo[playerid][pJoinedEvent])
	{
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		ResetPlayerWeapons(playerid);
		PlayerInfo[playerid][pJoinedEvent] = 0;
	}
	if(PlayerInfo[playerid][pHospital])
	{
	    GameTextForPlayer(playerid, " ", 100, 3);
	    PlayerInfo[playerid][pHospital] = 0;
	    PlayerInfo[playerid][pHospitalTime] = 0;
	}
	if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    ResetPlayerWeapons(playerid);
		PlayerInfo[playerid][pPaintball] = 0;
		PlayerInfo[playerid][pPaintballTeam] = -1;
	}
	if(PlayerInfo[playerid][pOilExTime] > 0)
	{
	    ClearAnimations(playerid, SYNC_ALL);
	}
	if(PlayerInfo[playerid][pFruitExTime] > 0)
	{
	    ClearAnimations(playerid, SYNC_ALL);
	}
	if(PlayerInfo[playerid][pHarvestTime] > 0)
	{
	    ClearAnimations(playerid, SYNC_ALL);
	}
	if(PlayerInfo[playerid][pTazedTime] > 0)
	{
	    ClearAnimations(playerid, SYNC_ALL);
	    TogglePlayerControllable(playerid, true);
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    TogglePlayerControllable(playerid, true);
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if(PlayerInfo[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
	{
	    PlayerInfo[PlayerInfo[playerid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
	    PlayerInfo[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
	}
	if(PlayerInfo[playerid][pPlantedBomb])
	{
	    DestroyDynamicObject(PlayerInfo[playerid][pBombObject]);
	    PlayerInfo[playerid][pBombObject] = INVALID_OBJECT_ID;
	    PlayerInfo[playerid][pPlantedBomb] = 0;
	}
	if(PlayerInfo[playerid][pFreezeTimer] >= 0)
	{
	    KillTimer(PlayerInfo[playerid][pFreezeTimer]);
	    TogglePlayerControllable(playerid, true);
		PlayerInfo[playerid][pFreezeTimer] = -1;
	}
	if(PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
		PlayerInfo[PlayerInfo[playerid][pDueling]][pDueling] = INVALID_PLAYER_ID;
		PlayerInfo[playerid][pDueling] = INVALID_PLAYER_ID;
	}
	if(RobberyInfo[rPlanning] || RobberyInfo[rStarted])
	{
		RemoveFromBankRobbery(playerid);
	}

	PlayerInfo[playerid][pInjured] = 0;
	PlayerInfo[playerid][pAcceptedHelp] = 0;
	PlayerInfo[playerid][pHarvestTime] = 0;
	PlayerInfo[playerid][pWheat] = 0;
	PlayerInfo[playerid][pSpeedTime] = 0;
	PlayerInfo[playerid][pCoronerBody] = 0;
	PlayerInfo[playerid][pGraffiti] = -1;
	PlayerInfo[playerid][pGraffitiTime] = 0;
	PlayerInfo[playerid][pTazer] = 0;
	PlayerInfo[playerid][pTazedTime] = 0;
	PlayerInfo[playerid][pOilExTime] = 0;
	PlayerInfo[playerid][pFruitExTime] = 0;
	PlayerInfo[playerid][pOilEx] = 0;
	PlayerInfo[playerid][pCuffed] = 0;
	PlayerInfo[playerid][pTied] = 0;
	PlayerInfo[playerid][pDraggedBy] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pDelivered] = 0;
	PlayerInfo[playerid][pContractTaken] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pPoisonTime] = 0;
    PlayerInfo[playerid][pCapturingPoint] = -1;
    PlayerInfo[playerid][pCaptureTime] = 0;
    CancelBreakIn(playerid);
 	CancelActiveCheckpoint(playerid);
 	RemovePlayerAttachedObject(playerid, 9);
}

CancelBreakIn(playerid)
{
	if(PlayerInfo[playerid][pLockBreak] != INVALID_VEHICLE_ID)
	{
	    new
	        damage[4];

		SetVehicleParams(PlayerInfo[playerid][pLockBreak], VEHICLE_ALARM, false);
		GetVehicleDamageStatus(PlayerInfo[playerid][pLockBreak], damage[0], damage[1], damage[2], damage[3]);
		UpdateVehicleDamageStatus(PlayerInfo[playerid][pLockBreak], damage[0], 0, damage[2], damage[3]);

    	DestroyDynamic3DTextLabel(PlayerInfo[playerid][pLockText]);
		KillTimer(PlayerInfo[playerid][pLockTimer]);

		PlayerInfo[playerid][pLockText] = Text3D:INVALID_3DTEXT_ID;
		PlayerInfo[playerid][pLockBreak] = INVALID_VEHICLE_ID;
	}
}

forward loginwait(playerid);
public loginwait(playerid)
{
    TogglePlayerControllable(playerid, true);
}



CancelActiveCheckpoint(playerid)
{
    if(PlayerInfo[playerid][pDrivingTest])
	{
	    SetVehicleToRespawn(PlayerInfo[playerid][pTestVehicle]);
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	    RemovePlayerAttachedObject(playerid, 9);
    }

    DisablePlayerCheckpoint(playerid);

	PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
	PlayerInfo[playerid][pSmuggleMats] = 0;
	PlayerInfo[playerid][pSmuggleDrugs] = 0;
	PlayerInfo[playerid][pDrivingTest] = 0;
	PlayerInfo[playerid][pTestVehicle] = INVALID_VEHICLE_ID;
	PlayerInfo[playerid][pTestCP] = 0;
    PlayerInfo[playerid][pWheat] = 0;
    PlayerInfo[playerid][pOilEx] = 0;
    PlayerInfo[playerid][pShipment] = -1;
    PlayerInfo[playerid][pIllegalCargo] = -1;
}

ReferralCheck(playerid)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip FROM users WHERE uid = %i", PlayerInfo[playerid][pReferralUID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_REWARD_REFERRER, playerid);
}

	
SetPlayerSpecialTag(playerid, type)
{
	new
	    string[280];

    if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pSpecialTag]))
	{
		DestroyDynamic3DTextLabel(PlayerInfo[playerid][pSpecialTag]);
        PlayerInfo[playerid][pSpecialTag] = Text3D:INVALID_3DTEXT_ID;
	}

    foreach(new i : Player)
	{
	    if(type == TAG_NORMAL)
		    ShowPlayerNameTagForPlayer(i, playerid, true);
		else
		    ShowPlayerNameTagForPlayer(i, playerid, false);
	}

	switch(type)
    {
		case TAG_ADMIN:
        {
            if(!strcmp(PlayerInfo[playerid][pAdminName], "None", true))
	            format(string, sizeof(string), "%s\n{089DCE}AK:RP Administrator\n{FF6347}%s", GetPlayerNameEx(playerid), GetAdminRank(playerid));
			else
			    format(string, sizeof(string), "%s\n{089DCE}AK:RP Administrator\n{FF6347}%s", PlayerInfo[playerid][pAdminName], GetAdminRank(playerid));

			if(strlen(GetAdminDivisionFull(playerid)) > 0)
			{
				format(string, sizeof(string), "%s\n{00C2E0}%s", string, GetAdminDivisionFull(playerid));
			}
			PlayerInfo[playerid][pSpecialTag] = CreateDynamic3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.2, 20.0, .attachedplayer = playerid, .testlos = 1);
		}
		case TAG_HELPER:
		{
		    format(string, sizeof(string), "%s\n{089DCE}Helper Assisting\n{00FF00}%s", GetRPName(playerid), GetHelperRank(playerid));
    		PlayerInfo[playerid][pSpecialTag] = CreateDynamic3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.2, 20.0, .attachedplayer = playerid, .testlos = 1);
		}
		case TAG_MASK:
		{
			MaskaraID[playerid] = playerid + 120;
		    format(string, sizeof(string), "Stranger(B%d)", MaskaraID[playerid]);
		}
	}

	PlayerInfo[playerid][pTagType] = type;
}

SendNewbieChatMessage(playerid, text[])
{
	new string[64];
	if((!isnull(PlayerInfo[playerid][pCustomTitle]) && strcmp(PlayerInfo[playerid][pCustomTitle], "None", true) != 0 && strcmp(PlayerInfo[playerid][pCustomTitle], "0", true) != 0) && strcmp(PlayerInfo[playerid][pCustomTitle], "NULL", true) != 0) {
	    new color;
		if(PlayerInfo[playerid][pCustomTColor] == -1 || PlayerInfo[playerid][pCustomTColor] == -256)
		{
	    	color = 0xC8C8C8FF;
		}
		else
		{
		    color = PlayerInfo[playerid][pCustomTColor];
		}
	    format(string, sizeof(string), "{%06x}%s{7DAEFF} %s", color >>> 8, PlayerInfo[playerid][pCustomTitle], GetRPName(playerid));

    }
	else if(PlayerInfo[playerid][pAdmin] > 1)
	{
	    format(string, sizeof(string), ""SVRCLR"%s{7DAEFF} %s", GetColorARank(playerid), GetRPName(playerid));
	} else if(PlayerInfo[playerid][pHelper] > 0) {
	    format(string, sizeof(string), "{33CCFF}%s{7DAEFF} %s", GetHelperRank(playerid), GetRPName(playerid));
    } else if(PlayerInfo[playerid][pFormerAdmin]) {
	    format(string, sizeof(string), "Former Admin %s", GetRPName(playerid));
	} else if(PlayerInfo[playerid][pVIPPackage] > 0) {
		format(string, sizeof(string), "%s Donator %s", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetRPName(playerid));
	} else if(PlayerInfo[playerid][pLevel] > 1) {
	    format(string, sizeof(string), "Level %i Player %s", PlayerInfo[playerid][pLevel], GetRPName(playerid));
	} else {
	    format(string, sizeof(string), "Newbie %s", GetRPName(playerid));
	}

    foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pToggleNewbie])
	    {
	        if(strlen(text) > MAX_SPLIT_LENGTH)
	        {
				SM(i, COLOR_NEWBIE, "[N] %s: %.*s...", string, MAX_SPLIT_LENGTH, text);
				SM(i, COLOR_NEWBIE, "[N] %s: ...%s", string, text[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, COLOR_NEWBIE, "[N] %s: %s", string, text);
			}
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] == 0)
	{
 		PlayerInfo[playerid][pLastNewbie] = gettime();
	}
}

Namechange(playerid, oldname[], newname[])
{
    for(new i = 0; i < MAX_HOUSES; i ++)
    {
        if(HouseInfo[i][hExists] && !strcmp(HouseInfo[i][hOwner], oldname, false))
        {
            strcpy(HouseInfo[i][hOwner], newname, MAX_PLAYER_NAME);
            ReloadHouse(i);
        }
    }

    for(new i = 0; i < MAX_GARAGES; i ++)
    {
        if(GarageInfo[i][gExists] && !strcmp(GarageInfo[i][gOwner], oldname, false))
        {
            strcpy(GarageInfo[i][gOwner], newname, MAX_PLAYER_NAME);
            ReloadGarage(i);
        }
    }

    for(new i = 0; i < MAX_BUSINESSES; i ++)
    {
        if(BusinessInfo[i][bExists] && !strcmp(BusinessInfo[i][bOwner], oldname, false))
        {
            strcpy(BusinessInfo[i][bOwner], newname, MAX_PLAYER_NAME);
            ReloadBusiness(i);
        }
    }

    foreach(new i : Land)
	{
	    if(LandInfo[i][lExists] && !strcmp(LandInfo[i][lOwner], oldname, false))
	    {
	        strcpy(LandInfo[i][lOwner], newname, MAX_PLAYER_NAME);
	        ReloadLand(i);
	    }
	}


    for(new i = 0; i < MAX_VEHICLES; i ++)
    {
        if(IsValidVehicle(i) && VehicleInfo[i][vID] && !strcmp(VehicleInfo[i][vOwner], oldname, false))
        {
            strcpy(VehicleInfo[i][vOwner], newname, MAX_PLAYER_NAME);
        }
    }

	// Updating queries.
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET owner = '%e' WHERE owner = '%e'", newname, oldname);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET owner = '%e' WHERE owner = '%e'", newname, oldname);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET owner = '%e' WHERE owner = '%e'", newname, oldname);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET owner = '%e' WHERE owner = '%e'", newname, oldname);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET owner = '%e' WHERE owner = '%e'", newname, oldname);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET username = '%e' WHERE uid = %i", newname, PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

	strcpy(PlayerInfo[playerid][pUsername], newname, MAX_PLAYER_NAME);

    SetPlayerName(playerid, newname);
    SavePlayerVariables(playerid);
}

IsABoat(vehicleid)
{
    switch(GetVehicleModel(vehicleid))
    {
        case 430, 446, 452..454, 472, 473, 484, 493, 595: return 1;
    }

    return 0;
}

IsLawEnforcement(playerid)
{
	return GetFactionType(playerid) == FACTION_POLICE || GetFactionType(playerid) == FACTION_NPOLICE || GetFactionType(playerid) == FACTION_FEDERAL || GetFactionType(playerid) == FACTION_ARMY || GetFactionType(playerid) == FACTION_JAILGUARDS;
}

IsGovernment(playerid)
{
	return GetFactionType(playerid) == FACTION_GOVERNMENT;
}

IsMechanic(playerid)
{
	return GetFactionType(playerid) == FACTION_MECHANIC;
}

IsTerrorist(playerid)
{
	return GetFactionType(playerid) == FACTION_TERRORIST;
}

IsPlayerBeingFound(playerid)
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFindPlayer] == playerid && PlayerInfo[i][pFindTime] > 0)
	    {
	        return 1;
		}
	}

	return 0;
}

IsGateModel(modelid)
{
    switch(modelid)
    {
        case 8957, 7891, 3037, 19861, 19864, 19912, 971, 975, 980, 985, 19870, 988:
        {
            return 1;
        }
    }

	return 0;
}

IsGateObject(objectid)
{
    new
		modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

	if((modelid) && IsGateModel(modelid))
	{
	    return 1;
	}

	return 0;
}

IsDoorObject(objectid)
{
	new
		modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

	if((modelid) && !IsGateObject(objectid))
	{
		for(new i = 0; i < sizeof(furnitureArray); i ++)
		{
	    	if(!strcmp(furnitureArray[i][fCategory], "Doors & Gates") && furnitureArray[i][fModel] == modelid)
	    	{
		        return 1;
			}
		}
	}

	return 0;
}

RemoveFaction(factionid)
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == factionid)
	    {
			ResetPlayerWeaponsEx(i);
	        SM(i, COLOR_LIGHTRED, "The faction you were apart of has been deleted by an administrator.");
            SetPlayerSkin(i, 230);

	        PlayerInfo[i][pFaction] = -1;
	        PlayerInfo[i][pFactionRank] = 0;
	        PlayerInfo[i][pDivision] = -1;
	        PlayerInfo[i][pDuty] = 0;
	    }
	}

	DestroyDynamic3DTextLabel(FactionInfo[factionid][fText]);
	DestroyDynamicPickup(FactionInfo[factionid][fPickup]);

    FactionInfo[factionid][fName] = 0;
    FactionInfo[factionid][fLeader] = 0;
	FactionInfo[factionid][fType] = FACTION_NONE;
	FactionInfo[factionid][fColor] = 0;
	FactionInfo[factionid][fRankCount] = 0;
    FactionInfo[factionid][fLockerX] = 0.0;
    FactionInfo[factionid][fLockerY] = 0.0;
    FactionInfo[factionid][fLockerZ] = 0.0;
    FactionInfo[factionid][fLockerInterior] = 0;
    FactionInfo[factionid][fLockerWorld] = 0;
    FactionInfo[factionid][fTurfTokens] = 0;
    FactionInfo[factionid][fText] = Text3D:INVALID_3DTEXT_ID;
    FactionInfo[factionid][fPickup] = -1;

    for(new i = 0; i < MAX_FACTION_RANKS; i ++)
    {
        strcpy(FactionRanks[factionid][i], "Unspecified", 32);
        FactionInfo[factionid][fPaycheck][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factions WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionranks WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionskins WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionpay WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM divisions WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = -1, factionrank = 0, division = -1 WHERE faction = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);
}

GetFactionSkinCount(factionid)
{
	new count;

	for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	{
	    if(FactionInfo[factionid][fSkins][i] != 0)
	    {
	        count++;
		}
	}

	return count;
}

GetFactionType(playerid)
{
	if(PlayerInfo[playerid][pFaction] >= 0)
	{
	    return FactionInfo[PlayerInfo[playerid][pFaction]][fType];
	}

	return FACTION_NONE;
}

SetupFaction(factionid, name[], type)
{
    strcpy(FactionInfo[factionid][fName], name, 48);
   	strcpy(FactionInfo[factionid][fShortName], "None", 24);
	strcpy(FactionInfo[factionid][fLeader], "Pending", MAX_PLAYER_NAME);

    FactionInfo[factionid][fType] = type;
    FactionInfo[factionid][fColor] = 0xFFFFFF00;
    FactionInfo[factionid][fRankCount] = 6;
    FactionInfo[factionid][fLockerX] = 0.0;
    FactionInfo[factionid][fLockerY] = 0.0;
    FactionInfo[factionid][fLockerZ] = 0.0;
    FactionInfo[factionid][fLockerInterior] = 0;
    FactionInfo[factionid][fLockerWorld] = 0;
    FactionInfo[factionid][fTurfTokens] = 0;
    FactionInfo[factionid][fText] = Text3D:INVALID_3DTEXT_ID;
    FactionInfo[factionid][fPickup] = -1;

    for(new i = 0; i < MAX_FACTION_RANKS; i ++)
    {
        strcpy(FactionRanks[factionid][i], "Unspecified", 32);
        FactionInfo[factionid][fPaycheck][i] = 0;
	}
	for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	{
	    FactionInfo[factionid][fSkins][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factions (id, name, type) VALUES(%i, '%e', %i)", factionid, name, type);
	mysql_tquery(connectionID, queryBuffer);
}

SetupGang(gangid, name[])
{
	strcpy(GangInfo[gangid][gName], name, 32);
	strcpy(GangInfo[gangid][gMOTD], "None", 128);
	strcpy(GangInfo[gangid][gTheme], "None", 32);
	strcpy(GangInfo[gangid][gLeader], "Pending", MAX_PLAYER_NAME);

	GangInfo[gangid][gSetup] = 1;
	GangInfo[gangid][gColor] = 0xFFFFFF00;
	GangInfo[gangid][gStrikes] = 0;
	GangInfo[gangid][gLevel] = 1;
	GangInfo[gangid][gPoints] = 0;
	GangInfo[gangid][gTurfTokens] = 0;
	GangInfo[gangid][gStashX] = 0.0;
	GangInfo[gangid][gStashY] = 0.0;
	GangInfo[gangid][gStashZ] = 0.0;
	GangInfo[gangid][gStashInterior] = 0;
	GangInfo[gangid][gStashWorld] = 0;
	GangInfo[gangid][gCash] = 0;
	GangInfo[gangid][gMaterials] = 0;
	GangInfo[gangid][gPot] = 0;
	GangInfo[gangid][gCrack] = 0;
	GangInfo[gangid][gMeth] = 0;
	GangInfo[gangid][gPainkillers] = 0;
	GangInfo[gangid][gHPAmmo] = 0;
	GangInfo[gangid][gPoisonAmmo] = 0;
	GangInfo[gangid][gFMJAmmo] = 0;
    GangInfo[gangid][gArmsDealer] = 0;
    GangInfo[gangid][gDrugDealer] = 0;
    GangInfo[gangid][gArmsX] = 0.0;
    GangInfo[gangid][gArmsY] = 0.0;
    GangInfo[gangid][gArmsZ] = 0.0;
    GangInfo[gangid][gDrugX] = 0.0;
    GangInfo[gangid][gDrugY] = 0.0;
    GangInfo[gangid][gDrugZ] = 0.0;
    GangInfo[gangid][gArmsWorld] = 0;
    GangInfo[gangid][gDrugWorld] = 0;
    GangInfo[gangid][gDrugPot] = 0;
    GangInfo[gangid][gDrugCrack] = 0;
    GangInfo[gangid][gDrugMeth] = 0;
    GangInfo[gangid][gArmsMaterials] = 0;
    GangInfo[gangid][gAlliance] = -1;
    GangInfo[gangid][gArmsHPAmmo] = 0;
    GangInfo[gangid][gArmsPoisonAmmo] = 0;
    GangInfo[gangid][gArmsFMJAmmo] = 0;
    GangInfo[gangid][gPickup] = -1;
    GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
    GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
    GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;

	for(new i = 0; i < 7; i ++)
    {
        strcpy(GangRanks[gangid][i], "Unspecified", 32);
	}

	for(new i = 0; i < 12; i ++)
	{
	    if(i < 3)
	    {
	        GangInfo[gangid][gDrugPrices][i] = 0;
		}

		GangInfo[gangid][gArmsPrices][i] = 0;
	}

	for(new i = 0; i < MAX_GANG_SKINS; i ++)
	{
        GangInfo[gangid][gSkins][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangs (id, name) VALUES(%i, '%e')", gangid, name);
	mysql_tquery(connectionID, queryBuffer);
}
ResetClotheSetup(playerid)
{
	PlayerInfo[playerid][pSkin] = g_MaleSkins[0];
	PlayerInfo[playerid][pOutfit] = 0;

	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	UpdateClotheSetup(playerid);
}
UpdateClotheSetup(playerid)
{
	new string[64];
	format(string, sizeof(string), "%i/%i", PlayerInfo[playerid][pOutfit] + 1, (PlayerInfo[playerid][pGender] == GENDER_MALE ? sizeof(g_MaleSkins) : sizeof(g_FemaleSkins)));
	DynamicPlayerTextDrawSetString(playerid, ClotheTD[playerid][3], string);
}
UpdateClotheSelection(playerid, index)
{
	new size;

	if (PlayerInfo[playerid][pGender] == GENDER_MALE) {
		size = sizeof(g_MaleSkins);
	} else if (PlayerInfo[playerid][pGender] == GENDER_FEMALE) {
		size = sizeof(g_FemaleSkins);
	}

	if (index < 0) {
		index = --size;
	} else if (index >= size) {
		index = 0;
	}

	PlayerInfo[playerid][pOutfit] = index;

	if (PlayerInfo[playerid][pGender] == GENDER_MALE) {
		PlayerInfo[playerid][pSkin] = g_MaleSkins[index];
	} else if (PlayerInfo[playerid][pGender] == GENDER_FEMALE) {
		PlayerInfo[playerid][pSkin] = g_FemaleSkins[index];
	}

	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
}
AddPointMoney(type, amount)
{
	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && PointInfo[i][pType] == type)
	    {
	        if(PointInfo[i][pCapturedGang] >= 0)
	        {
	            amount /= 2;
	            GangInfo[PointInfo[i][pCapturedGang]][gCash] += amount;

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PointInfo[i][pCapturedGang]][gCash], PointInfo[i][pCapturedGang]);
	        	mysql_tquery(connectionID, queryBuffer);
	        }

			PointInfo[i][pProfits] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET profits = %i WHERE id = %i", PointInfo[i][pProfits], i);
	 		mysql_tquery(connectionID, queryBuffer);
	    }
    }
}

// PUBLIC GARAGE

GetNearbyPG(playerid)
{
	for(new i = 0; i < MAX_PGARAGE; i ++)
	{
	    if(PGInfo[i][aExists] && IsPlayerInRangeOfPoint(playerid, 3.0, PGInfo[i][aPosX], PGInfo[i][aPosY], PGInfo[i][aPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

ReloadPG(atmid)
{
	if(PGInfo[atmid][aExists])
	{
	    DestroyDynamic3DTextLabel(PGInfo[atmid][aText]);
	    DestroyDynamicObject(PGInfo[atmid][aObject]);
		DestroyDynamicMapIcon(PGInfo[atmid][aMapIcon]);
		
	    PGInfo[atmid][aText] = CreateDynamic3DTextLabel(""TEAL"["WHITE"Public Garage"TEAL"]"WHITE"\nPress "WHITE"'Y'"TEAL" to spawn/despawn a vehicle.", COLOR_TEAL, PGInfo[atmid][aPosX], PGInfo[atmid][aPosY], PGInfo[atmid][aPosZ] + 0.4, 20.0);
        PGInfo[atmid][aObject] = CreateDynamicPickup(19134, 1, PGInfo[atmid][aPosX], PGInfo[atmid][aPosY], PGInfo[atmid][aPosZ]);


		PGInfo[atmid][aMapIcon] = CreateDynamicMapIcon(PGInfo[atmid][aPosX], PGInfo[atmid][aPosY], PGInfo[atmid][aPosZ], 55, 1, -1, -1, -1, 5000000.0);
	}
}
GetNearbyGG(playerid)
{
	for(new i = 0; i < MAX_GGARAGE; i ++)
	{
	    if(GGInfo[i][aExists] && IsPlayerInRangeOfPoint(playerid, 3.0, GGInfo[i][aPosX], GGInfo[i][aPosY], GGInfo[i][aPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}
ReloadGG(atmid)
{
	if(GGInfo[atmid][aExists])
	{
	    DestroyDynamic3DTextLabel(GGInfo[atmid][aText]);
	    DestroyDynamicObject(GGInfo[atmid][aObject]);
		DestroyDynamicMapIcon(GGInfo[atmid][aMapIcon]);

		GGInfo[atmid][aText] = CreateDynamic3DTextLabel(""TEAL"["WHITE"Gang Garage"TEAL"]"WHITE"\nPress "WHITE"'Y'"TEAL" to spawn/despawn a vehicle.", COLOR_TEAL, GGInfo[atmid][aPosX], GGInfo[atmid][aPosY], GGInfo[atmid][aPosZ] + 0.4, 20.0);
		GGInfo[atmid][aMapIcon] = CreateDynamicMapIcon(GGInfo[atmid][aPosX], GGInfo[atmid][aPosY], GGInfo[atmid][aPosZ], 55, 1, -1, -1, -1, 500.0);

	    GGInfo[atmid][aObject] = CreateDynamicPickup(19134, 1 , GGInfo[atmid][aPosX], GGInfo[atmid][aPosY], GGInfo[atmid][aPosZ]);
	}
}
// Locker System

IsPlayerInRangeOfLocker(playerid, factionid)
{
	new lockerid;

	if((lockerid = GetNearbyLocker(playerid)) >= 0 && LockerInfo[lockerid][lFaction] == factionid)
	{
	    return 1;
	}

	return 0;
}

GetNearbyLocker(playerid)
{
	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
	    if(LockerInfo[i][lExists] && IsPlayerInRangeOfPoint(playerid, 3.0, LockerInfo[i][lPosX], LockerInfo[i][lPosY], LockerInfo[i][lPosZ]))
	    {
	        return i;
		}
	}

	return -1;
}

ReloadLockers(factionid)
{
	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
	    if(LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
	    {
	        ReloadLocker(i);
		}
	}
}

ReloadLocker(lockerid)
{
	if(LockerInfo[lockerid][lExists])
	{
	    DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
	    DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);
	    if(LockerInfo[lockerid][lLabel])
	    {
	        new string[128];
	    	format(string, sizeof(string), "%s "WHITE"(ID: %d)"LIGHTRED"\nPress"WHITE"'Y'"LIGHTRED" to access locker.", FactionInfo[LockerInfo[lockerid][lFaction]][fName], lockerid);
     		LockerInfo[lockerid][lText] = CreateDynamic3DTextLabel(string, COLOR_LIGHTRED, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], 10.0, .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
		}
		LockerInfo[lockerid][lPickup] = CreateDynamicPickup(LockerInfo[lockerid][lIcon], 1, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
	}
}

ReloadPoint(pointid)
{
    if(PointInfo[pointid][pExists])
    {
        new string[128], name[32] = "None";

        DestroyDynamic3DTextLabel(PointInfo[pointid][pText]);
        DestroyDynamicPickup(PointInfo[pointid][pPickup]);

        if(PointInfo[pointid][pCapturedGang] >= 0)
        {
            strcpy(name, GangInfo[PointInfo[pointid][pCapturedGang]][gName]);
        }

        if(PointInfo[pointid][pTime] > 0)
        	format(string, sizeof(string), "["WHITE"%s{FFFF00}]\n"WHITE"Owned by: %s\nAvailable in %i hours.", PointInfo[pointid][pName], name, PointInfo[pointid][pTime]);
		else
		    format(string, sizeof(string), "["WHITE"%s{FFFF00}]\n"WHITE"Owned by: %s\nAvailable to capture!", PointInfo[pointid][pName], name);

        DestroyDynamicArea(PointInfo[pointid][pArea]);
	    GangZoneDestroy(PointInfo[pointid][pGangZone]);

	    PointInfo[pointid][pArea] = CreateDynamicRectangle(PointInfo[pointid][pMinX], PointInfo[pointid][pMinY], PointInfo[pointid][pMaxX], PointInfo[pointid][pMaxY]);
	    PointInfo[pointid][pGangZone] = GangZoneCreateEx(PointInfo[pointid][pMinX], PointInfo[pointid][pMinY], PointInfo[pointid][pMaxX], PointInfo[pointid][pMaxY]);

		PointInfo[pointid][pText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], 10.0, .worldid = PointInfo[pointid][pPointWorld], .interiorid = PointInfo[pointid][pPointInterior]);
        PointInfo[pointid][pPickup] = CreateDynamicPickup(1254, 1, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], .worldid = PointInfo[pointid][pPointWorld], .interiorid = PointInfo[pointid][pPointInterior]);
	}
}

ReloadGang(gangid)
{
	if(GangInfo[gangid][gSetup])
	{
	    new string[128], color;

	    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
	    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][1]);
	    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][2]);
	    DestroyDynamicPickup(GangInfo[gangid][gPickup]);
	    DestroyActor(GangInfo[gangid][gActors][0]);
	    DestroyActor(GangInfo[gangid][gActors][1]);

        if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
		    color = GangInfo[gangid][gColor];
		}

	    if(GangInfo[gangid][gStashX] != 0.0 && GangInfo[gangid][gStashY] != 0.0 && GangInfo[gangid][gStashZ] != 0.0)
	    {
	        format(string, sizeof(string), "Gang Stash\n{%06x}%s{C8C8C8}\nLevel %i\n/gstash", color >>> 8, GangInfo[gangid][gName], GangInfo[gangid][gLevel]);

            GangInfo[gangid][gText][0] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], 10.0, .worldid = GangInfo[gangid][gStashWorld], .interiorid = GangInfo[gangid][gStashInterior]);
            GangInfo[gangid][gPickup] = CreateDynamicPickup(1239, 1, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], .worldid = GangInfo[gangid][gStashWorld], .interiorid = GangInfo[gangid][gStashInterior]);
	    }
	    if(GangInfo[gangid][gArmsDealer] && GangInfo[gangid][gArmsX] != 0.0 && GangInfo[gangid][gArmsY] != 0.0 && GangInfo[gangid][gArmsZ] != 0.0)
	    {
	        format(string, sizeof(string), "[Arms Dealer]\n"WHITE"Owned by: %s\nType /armsdealer for more info.", GangInfo[gangid][gName]);

	        GangInfo[gangid][gActors][0] = CreateActor(179, GangInfo[gangid][gArmsX], GangInfo[gangid][gArmsY], GangInfo[gangid][gArmsZ], GangInfo[gangid][gArmsA]);
			GangInfo[gangid][gText][1] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, GangInfo[gangid][gArmsX], GangInfo[gangid][gArmsY], GangInfo[gangid][gArmsZ] + 0.3, 10.0, .worldid = GangInfo[gangid][gArmsWorld]);

		    SetActorVirtualWorld(GangInfo[gangid][gActors][0], GangInfo[gangid][gArmsWorld]);
		}
		if(GangInfo[gangid][gDrugDealer] && GangInfo[gangid][gDrugX] != 0.0 && GangInfo[gangid][gDrugY] != 0.0 && GangInfo[gangid][gDrugZ] != 0.0)
	    {
	        format(string, sizeof(string), "[Drug Dealer]\n"WHITE"Owned by: %s\nType /drugdealer for more info.", GangInfo[gangid][gName]);

	        GangInfo[gangid][gActors][1] = CreateActor(28, GangInfo[gangid][gDrugX], GangInfo[gangid][gDrugY], GangInfo[gangid][gDrugZ], GangInfo[gangid][gDrugA]);
            GangInfo[gangid][gText][2] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, GangInfo[gangid][gDrugX], GangInfo[gangid][gDrugY], GangInfo[gangid][gDrugZ] + 0.3, 10.0, .worldid = GangInfo[gangid][gDrugWorld]);

	        SetActorVirtualWorld(GangInfo[gangid][gActors][1], GangInfo[gangid][gDrugWorld]);
		}
	}
}

GiveGangPoints(gangid, amount)
{
	if(GangInfo[gangid][gSetup])
	{
        GangInfo[gangid][gPoints] = GangInfo[gangid][gPoints] + amount;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET points = %i WHERE id = %i", GangInfo[gangid][gPoints], gangid);
        mysql_tquery(connectionID, queryBuffer);
	}
}

RemoveGang(gangid)
{
	if(GangInfo[gangid][gAlliance] >= 0)
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = -1 WHERE id = %i", gangid);
	    mysql_tquery(connectionID, queryBuffer);

	    GangInfo[GangInfo[gangid][gAlliance]][gAlliance] = -1;
	}
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pGang] == gangid)
	    {
	        SM(i, COLOR_LIGHTRED, "The gang you were apart of has been deleted by an administrator.");
	        PlayerInfo[i][pGang] = -1;
	        PlayerInfo[i][pGangRank] = 0;
	    }
	}

	DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][1]);
    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][2]);
    DestroyDynamicPickup(GangInfo[gangid][gPickup]);
    DestroyActor(GangInfo[gangid][gActors][0]);
    DestroyActor(GangInfo[gangid][gActors][1]);

    GangInfo[gangid][gSetup] = 0;
    GangInfo[gangid][gName] = 0;
    GangInfo[gangid][gMOTD] = 0;
    GangInfo[gangid][gLeader] = 0;
    GangInfo[gangid][gTheme] = 0;
	GangInfo[gangid][gColor] = 0;
	GangInfo[gangid][gStrikes] = 0;
	GangInfo[gangid][gLevel] = 0;
	GangInfo[gangid][gPoints] = 0;
	GangInfo[gangid][gTurfTokens] = 0;
	GangInfo[gangid][gStashX] = 0.0;
	GangInfo[gangid][gStashY] = 0.0;
	GangInfo[gangid][gStashZ] = 0.0;
	GangInfo[gangid][gStashInterior] = 0;
	GangInfo[gangid][gStashWorld] = 0;
	GangInfo[gangid][gCash] = 0;
	GangInfo[gangid][gMaterials] = 0;
	GangInfo[gangid][gPot] = 0;
	GangInfo[gangid][gCrack] = 0;
	GangInfo[gangid][gMeth] = 0;
	GangInfo[gangid][gPainkillers] = 0;
	GangInfo[gangid][gArmsDealer] = 0;
    GangInfo[gangid][gDrugDealer] = 0;
    GangInfo[gangid][gArmsX] = 0.0;
    GangInfo[gangid][gArmsY] = 0.0;
    GangInfo[gangid][gArmsZ] = 0.0;
    GangInfo[gangid][gDrugX] = 0.0;
    GangInfo[gangid][gDrugY] = 0.0;
    GangInfo[gangid][gDrugZ] = 0.0;
    GangInfo[gangid][gArmsWorld] = 0;
    GangInfo[gangid][gDrugWorld] = 0;
    GangInfo[gangid][gDrugPot] = 0;
    GangInfo[gangid][gDrugCrack] = 0;
    GangInfo[gangid][gDrugMeth] = 0;
    GangInfo[gangid][gArmsMaterials] = 0;
    GangInfo[gangid][gAlliance] = -1;
    GangInfo[gangid][gArmsHPAmmo] = 0;
    GangInfo[gangid][gArmsPoisonAmmo] = 0;
    GangInfo[gangid][gArmsFMJAmmo] = 0;
    GangInfo[gangid][gPickup] = -1;
    GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
    GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
    GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;

    for(new i = 0; i < 7; i ++)
    {
        strcpy(GangRanks[gangid][i], "Unspecified", 32);
	}

	for(new i = 0; i < 14; i ++)
	{
		GangInfo[gangid][gWeapons][i] = 0;
	}

	for(new i = 0; i < MAX_GANG_SKINS; i ++)
	{
	    GangInfo[gangid][gSkins][i] = 0;
	}

	for(new i = 0; i < MAX_POINTS; i ++)
	{
		if(PointInfo[i][pExists] && PointInfo[i][pCapturedGang] == gangid)
		{
		    PointInfo[i][pCapturedGang] = -1;
		}
	}

	for(new i = 0; i < MAX_TURFS; i ++)
	{
		if(TurfInfo[i][tExists] && TurfInfo[i][tCapturedGang] == gangid)
		{
		    TurfInfo[i][tCapturedGang] = -1;
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM gangs WHERE id = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM gangranks WHERE id = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM gangskins WHERE id = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedgang = -1 WHERE capturedgang = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedgang = -1 WHERE capturedgang = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = -1, gangrank = 0 WHERE gang = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);
}

GetGangVehicles(gangid)
{
	new count;

    for(new i = 0; i < MAX_VEHICLES; i ++)
	{
	    if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == gangid)
	    {
	        count++;
		}
	}

	return count;
}

GetGangVehicleLimit(gangid)
{
	switch(GangInfo[gangid][gLevel])
	{
	    case 1: return 5;
	    case 2: return 7;
	    case 3: return 9;
	}

	return 0;
}

GetGangMemberLimit(gangid)
{
	switch(GangInfo[gangid][gLevel])
	{
	    case 1: return 15;
	    case 2: return 20;
	    case 3: return 30;
	}

	return 0;
}

GetGangSkinCount(gangid)
{
	new count;

	for(new i = 0; i < MAX_GANG_SKINS; i ++)
	{
	    if(GangInfo[gangid][gSkins][i] != 0)
	    {
	        count++;
		}
	}

	return count;
}

GetVehicleGarage(vehicleid)
{
	for(new i = 0; i < MAX_GARAGES; i ++)
	{
	    if(GarageInfo[i][gExists] && GarageInfo[i][gWorld] == GetVehicleVirtualWorld(vehicleid))
	    {
	        return i;
		}
	}

	return -1;
}

GetNearbyVehicle(playerid)
{
	new Float:x, Float:y, Float:z;

	foreach(new i : Vehicle)
	{
	    if(IsVehicleStreamedIn(i, playerid))
	    {
	        GetVehiclePos(i, x, y, z);

	        if(IsPlayerInRangeOfPoint(playerid, 3.5, x, y, z))
	        {
	            return i;
			}
		}
	}

	return INVALID_VEHICLE_ID;
}

GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff= 0.0, Float:yoff= 0.0, Float:zoff= 0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot, degrees) * yoff + floatcos(rot, degrees) * xoff + x;
    y = floatcos(rot, degrees) * yoff - floatsin(rot, degrees) * xoff + y;
    z = zoff + z;
}

IsPlayerAtVehicleDoor(playerid, vehicleid, type)
{
 	new
	    Float:vx,
	    Float:vy,
	    Float:vz,
	    Float:va,
	    Float:x,
	    Float:y,
	    Float:z,
		Float:a;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, z);

	if(type == DOOR_DRIVER) {
		GetVehicleRelativePos(vehicleid, vx, vy, vz, -x * 2, y, z);
	} else {
	    GetVehicleRelativePos(vehicleid, vx, vy, vz, x * 2, y, z);
	}

    GetPlayerFacingAngle(playerid, a);
    GetVehicleZAngle(vehicleid, va);

    if(IsPlayerInRangeOfPoint(playerid, 1.0, vx, vy, vz))
    {
        return 1;
	}

	return 0;
}


GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if(IsValidVehicle(vehicleid))
	{
		new
			Float:pos[7];

		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
		GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
		GetVehicleZAngle(vehicleid, pos[6]);

		x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
		y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 		z = pos[5];
		return 1;
	}

	x = 0.0;
	y = 0.0;
	z = 0.0;

	return 0;
}

IsVehicleBeingPicked(vehicleid)
{
    foreach(new i : Player)
	{
	    if(PlayerInfo[i][pLockBreak] == vehicleid)
	    {
	        return 1;
		}
	}

	return 0;
}

IsVehicleOwner(playerid, vehicleid)
{
	return (VehicleInfo[vehicleid][vOwnerID] == PlayerInfo[playerid][pID]) || (VehicleInfo[vehicleid][vOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

SetVehicleNeon(vehicleid, modelid)
{
	if(18647 <= modelid <= 18652)
	{
	    if(VehicleInfo[vehicleid][vNeonEnabled])
	    {
	        DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
			DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
	    }

	    VehicleInfo[vehicleid][vNeon] = modelid;
	    VehicleInfo[vehicleid][vNeonEnabled] = (modelid > 0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neon = %i, neonenabled = 1 WHERE id = %i", VehicleInfo[vehicleid][vNeon], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadVehicleNeon(vehicleid);
	}
}

ReloadVehicleNeon(vehicleid)
{
	if(VehicleInfo[vehicleid][vID] > 0)
	{
	    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
	    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);

	    if(VehicleInfo[vehicleid][vNeon] && VehicleInfo[vehicleid][vNeonEnabled])
	    {
	        new
				Float:x,
				Float:y,
				Float:z;

			GetVehicleModelInfo(VehicleInfo[vehicleid][vModel], VEHICLE_MODEL_INFO_SIZE, x, y, z);

			VehicleInfo[vehicleid][vObjects][0] = CreateDynamicObject(VehicleInfo[vehicleid][vNeon], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			VehicleInfo[vehicleid][vObjects][1] = CreateDynamicObject(VehicleInfo[vehicleid][vNeon], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

			AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vObjects][0], vehicleid, -x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vObjects][1], vehicleid, x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
		}
	}
}

GetNearbyAtm(playerid) //main
{
	for(new i = 0; i < MAX_ATMS; i ++)
	{
	    if(AtmInfo[i][aExists] && IsPlayerInRangeOfPoint(playerid, 3.0, AtmInfo[i][aPosX], AtmInfo[i][aPosY], AtmInfo[i][aPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}
ReloadAtm(atmid) //main
{
	if(AtmInfo[atmid][aExists])
	{

		new string[500];
	    DestroyDynamic3DTextLabel(AtmInfo[atmid][aText]);
	    DestroyDynamicObject(AtmInfo[atmid][aObject]);
        format(string, sizeof(string), ""WHITE"ATM Machine\n"RED"[Type]: /atm To Access\n "WHITE"[ATM BALANCE:%i]", AtmInfo[atmid][amoney]);
        AtmInfo[atmid][aText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, AtmInfo[atmid][aPosX], AtmInfo[atmid][aPosY], AtmInfo[atmid][aPosZ] + 0.4, 10.0);
        AtmInfo[atmid][aObject] = CreateDynamicObject(19324, AtmInfo[atmid][aPosX], AtmInfo[atmid][aPosY], AtmInfo[atmid][aPosZ], 0.0, 0.0, AtmInfo[atmid][aPosA]);

	}
}
ReloadAtmText(atmid) //main
{
	if(AtmInfo[atmid][aExists])
	{
		new string[500];
	    DestroyDynamic3DTextLabel(AtmInfo[atmid][aText]);
        format(string, sizeof(string), ""WHITE"ATM Machine\n"RED"[Type]: /atm To Access\n "WHITE"[ATM BALANCE:%i]", AtmInfo[atmid][amoney]);
        AtmInfo[atmid][aText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, AtmInfo[atmid][aPosX], AtmInfo[atmid][aPosY], AtmInfo[atmid][aPosZ] + 0.4, 10.0);
	}
}



ResyncVehicle(vehicleid)
{
	new
		worldid = GetVehicleVirtualWorld(vehicleid);
	SetVehicleVirtualWorld(vehicleid, cellmax);
	SetVehicleVirtualWorld(vehicleid, worldid);
}

SaveVehicleModifications(vehicleid)
{
	for(new i = 0; i < 14; i ++)
	{
	    VehicleInfo[vehicleid][vMods][i] = GetVehicleComponentInSlot(vehicleid, i);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_%i = %i WHERE id = %i", i + 1, VehicleInfo[vehicleid][vMods][i], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
}

ReloadVehicle(vehicleid)
{
    if(VehicleInfo[vehicleid][vPaintjob] >= 0)
    {
        ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
    }
    if(VehicleInfo[vehicleid][vNeon] && VehicleInfo[vehicleid][vNeonEnabled])
	{
		ReloadVehicleNeon(vehicleid);
    }
    
	for(new i = 0; i < 14; i ++)
	{
	    if(VehicleInfo[vehicleid][vMods][i] >= 1000)
	    {
	        AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
		}
	}
 
	if(!VehicleInfo[vehicleid][vRegistered])
	{
	    SetVehicleNumberPlate(vehicleid, "UNREG");
	    ResyncVehicle(vehicleid);
	} else {
	    new plate[15];
	    format(plate, sizeof(plate), "LSV-0%d", VehicleInfo[vehicleid][vID]);
	    strcpy(VehicleInfo[vehicleid][vPlate], plate, 32);
	    SetVehicleNumberPlate(vehicleid, plate);
	    ResyncVehicle(vehicleid);
	}
    LinkVehicleToInterior(vehicleid, VehicleInfo[vehicleid][vInterior]);
    SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][vWorld]);
    SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
    SetVehicleParams(vehicleid, VEHICLE_DOORS, VehicleInfo[vehicleid][vLocked]);
}

DespawnVehicle(vehicleid, bool:save = true)
{
	if(VehicleInfo[vehicleid][vID] > 0)
	{
	    if(VehicleInfo[vehicleid][vNeonEnabled])
	    {
	        DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
	        DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
	    }

		if(save) {
		    new
				Float:health;

		    GetVehicleHealth(vehicleid, health);
		    SaveVehicleModifications(vehicleid);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET fuel = %i, health = '%f', renttime = %i WHERE id = %i", vehicleFuel[vehicleid], health,  VehicleInfo[vehicleid][vRenttime], VehicleInfo[vehicleid][vID]);
	    	mysql_tquery(connectionID, queryBuffer);
	    }

		DestroyVehicleEx(vehicleid);
		ResetVehicle(vehicleid);
	}
}

ResetVehicle(vehicleid)
{
	strcpy(VehicleInfo[vehicleid][vPlate], "UNREG", 32);

	if(VehicleInfo[vehicleid][vTimer] >= 0)
	{
	    KillTimer(VehicleInfo[vehicleid][vTimer]);
	}

    VehicleInfo[vehicleid][vID] = 0;
	VehicleInfo[vehicleid][vOwnerID] = 0;
	VehicleInfo[vehicleid][vOgowner] = 0;
	VehicleInfo[vehicleid][vOwner] = 0;
	VehicleInfo[vehicleid][vModel] = 0;
	VehicleInfo[vehicleid][vPrice] = 0;
	VehicleInfo[vehicleid][vTickets] = 0;
	VehicleInfo[vehicleid][vLocked] = 0;
	VehicleInfo[vehicleid][vHealth] = 1000.0;
	VehicleInfo[vehicleid][vPosX] = 0.0;
	VehicleInfo[vehicleid][vPosY] = 0.0;
	VehicleInfo[vehicleid][vPosZ] = 0.0;
	VehicleInfo[vehicleid][vPosA] = 0.0;
	VehicleInfo[vehicleid][vColor1] = 0;
	VehicleInfo[vehicleid][vColor2] = 0;
	VehicleInfo[vehicleid][vPaintjob] = -1;
	VehicleInfo[vehicleid][vInterior] = 0;
	VehicleInfo[vehicleid][vWorld] = 0;
	VehicleInfo[vehicleid][vCash] = 0;
    VehicleInfo[vehicleid][vRent] = 0;
    VehicleInfo[vehicleid][vRenttime] = 0;
	VehicleInfo[vehicleid][vMaterials] = 0;
	VehicleInfo[vehicleid][vPot] = 0;
	VehicleInfo[vehicleid][vCrack] = 0;
	VehicleInfo[vehicleid][vMeth] = 0;
	VehicleInfo[vehicleid][vPainkillers] = 0;
	VehicleInfo[vehicleid][vWeapons][0] = 0;
	VehicleInfo[vehicleid][vWeapons][1] = 0;
	VehicleInfo[vehicleid][vWeapons][2] = 0;
	VehicleInfo[vehicleid][vHPAmmo] = 0;
	VehicleInfo[vehicleid][vPoisonAmmo] = 0;
	VehicleInfo[vehicleid][vFMJAmmo] = 0;
    VehicleInfo[vehicleid][vGang] = -1;
	VehicleInfo[vehicleid][vFactionType] = FACTION_NONE;
	VehicleInfo[vehicleid][vJob] = JOB_NONE;
	VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
	VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
	VehicleInfo[vehicleid][vTimer] = -1;
	VehicleInfo[vehicleid][vVip] = 0;
	VehicleInfo[vehicleid][vRegistered] = 0;
	Milliage[vehicleid] = 0;

	for(new i = 0; i < 14; i ++)
	{
	    VehicleInfo[vehicleid][vMods][i] = 0;
	}
	ResetVehicleObjects(vehicleid);
}

IsPointInLand(landid, Float:x, Float:y)
{
	if((LandInfo[landid][lMinX] <= x <= LandInfo[landid][lMaxX]) && (LandInfo[landid][lMinY] <= y <= LandInfo[landid][lMaxY]))
	{
	    return 1;
	}

	return 0;
}

GangZoneCreateEx(Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	return GangZoneCreate((minx > maxx) ? (maxx) : (minx), (miny > maxy) ? (maxy) : (miny), (minx > maxx) ? (minx) : (maxx), (miny > maxy) ? (miny) : (maxy));
}

HasLandPerms(playerid, landid)
{
	return IsLandOwner(playerid, landid) || PlayerInfo[playerid][pLandPerms] == landid;
}

IsLandOwner(playerid, landid)
{
	return (LandInfo[landid][lOwnerID] == PlayerInfo[playerid][pID]) || (LandInfo[landid][lOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

SetLandOwner(landid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(LandInfo[landid][lOwner], "Nobody", MAX_PLAYER_NAME);
	    LandInfo[landid][lOwnerID] = 0;
	}
	else
	{
	    GetPlayerName(playerid, LandInfo[landid][lOwner], MAX_PLAYER_NAME);
	    LandInfo[landid][lOwnerID] = PlayerInfo[playerid][pID];
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET ownerid = %i, owner = '%s' WHERE id = %i", LandInfo[landid][lOwnerID], LandInfo[landid][lOwner], LandInfo[landid][lID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadLand(landid);
}

GetLandObjectID(sql_id)
{
    for(new i = 0; i <= Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i ++)
    {
        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID) == sql_id)
        {
            return i;
		}
	}

	return INVALID_OBJECT_ID;
}

GetLandObjectCapacity(level)
{
	switch(level)
	{
	    case 1: return 150;
	    case 2: return 200;
	    case 3: return 300;
	    case 4: return 500;
	    case 5: return 1000;
	}

	return 0;
}

RemoveLandObject(objectid)
{
    if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
	{
 		new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteLandObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM landobjects WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer);
	}
}

DeleteLandObject(objectid)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
	{
    	new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);

        if(IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }

        DestroyDynamicObject(objectid);
	}
}

RemoveAllLandObjects(landid)
{
    if(LandInfo[landid][lExists])
	{
	    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
	        {
             	DeleteLandObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

ReloadLandObject(objectid, labels)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
	{
	    new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteLandObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM landobjects WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, labels);
	}
}

ReloadAllLandObjects(landid)
{
    if(LandInfo[landid][lExists])
	{
	    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
	        {
             	DeleteLandObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, LandInfo[landid][lLabels]);
	}
}

ReloadLand(landid)
{
	if(LandInfo[landid][lExists])
	{
		DestroyDynamic3DTextLabel(LandInfo[landid][lText]);
		DestroyDynamicPickup(LandInfo[landid][lPickup]);
	    DestroyDynamicArea(LandInfo[landid][lArea]);
	    GangZoneDestroy(LandInfo[landid][lGangZone]);

	    LandInfo[landid][lArea] = CreateDynamicRectangle(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lMaxX], LandInfo[landid][lMaxY]);
	    LandInfo[landid][lGangZone] = GangZoneCreateEx(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lMaxX], LandInfo[landid][lMaxY]);
	   	LandInfo[landid][lText] = CreateDynamic3DTextLabel("Land", COLOR_GREY, LandInfo[landid][lX], LandInfo[landid][lY], LandInfo[landid][lZ], 15.0, .worldid = 0, .interiorid = 0);
	    UpdateLandText(landid);
      	
		LandInfo[landid][lPickup] = CreateDynamicPickup(19523, 1, LandInfo[landid][lX], LandInfo[landid][lY], LandInfo[landid][lZ]);

	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pShowLands])
	        {
	            GangZoneShowForPlayer(i, LandInfo[landid][lGangZone], (LandInfo[landid][lOwnerID] > 0) ? (0x99ffbeAA) : (0x33CC33AA));
			}
		}
	}
}

Gate_Nearest(playerid)
{
    for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && IsPlayerInRangeOfPoint(playerid, GateData[i][gateRadius], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2]))
	{
		if (GetPlayerInterior(playerid) == GateData[i][gateInterior] && GetPlayerVirtualWorld(playerid) == GateData[i][gateWorld])
			return i;
	}
	return -1;
}
Object_Nearest(playerid)
{
    for (new i = 0; i != MAX_MAPOBJECTS; i ++) if (ObjectData[i][mobjExists] && IsPlayerInRangeOfPoint(playerid, 3.0, ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2]))
	{
		if (GetPlayerInterior(playerid) == ObjectData[i][mobjInterior] && GetPlayerVirtualWorld(playerid) == ObjectData[i][mobjWorld])
			return i;
	}
	return -1;
}


forward Dcstart(playerid);

public Dcstart(playerid)
{
    new string[128];
    new minutes, seconds_left;
    
    if(PlayerInfo[playerid][pDeathCooldown] <= 0)
    {
	   KillTimer(killtimerz[playerid]);
    }

    minutes = PlayerInfo[playerid][pDeathCooldown] / 60;
    seconds_left = PlayerInfo[playerid][pDeathCooldown] % 60;

    format(string, sizeof(string), "%d:%d", minutes, seconds_left);

    DynamicPlayerTextDrawSetString(playerid, DEATH[playerid][1], string);
    return 1;
}

// Jeck
stock ShowGPSTextdraw(playerid) {
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pText][0]);
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pText][1]);
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pText][6]);
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pText][7]);
}

stock HideGPSTextdraw(playerid) {
	PlayerTextDrawHide(playerid, PlayerInfo[playerid][pText][0]);
	PlayerTextDrawHide(playerid, PlayerInfo[playerid][pText][1]);
	PlayerTextDrawHide(playerid, PlayerInfo[playerid][pText][6]);
	PlayerTextDrawHide(playerid, PlayerInfo[playerid][pText][7]);
}

stock IsPlayerNearDynamicObject(playerid, objectid, Float:range = 5.0) {

	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	GetDynamicObjectPos(objectid, fX, fY, fZ);

	return (IsPlayerInRangeOfPoint(playerid, range, fX, fY, fZ));
}

