CMD:BABYLON1(playerid, params[]) return callcmd::makeadmin(playerid, params);
CMD:makeadmin(playerid, params[])
{
	new targetid, level;

    if(PlayerInfo[playerid][pAdmin] < 8 && !IsPlayerAdmin(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /makeadmin [playerid] [level]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!(0 <= level <= 7))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 6.");
	}
	if(level == 7)
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "Only Naju Can Give this role");
	}
	if(level == 1 && PlayerInfo[targetid][pAdminDuty])
	{
	    SetPlayerName(targetid, PlayerInfo[targetid][pUsername]);
		PlayerInfo[targetid][pAdminDuty] = 1;
    }
    if(PlayerInfo[targetid][pAdmin] == 7 && level == 1)
    {
       return SendClientMessage(playerid, COLOR_SYNTAX, "Only Naju Can Take this role");
    }

    PlayerInfo[targetid][pAdmin] = level;
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s (%i).", GetRPName(playerid), GetRPName(targetid), GetAdminRank(targetid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminlevel = %i WHERE uid = %i", level, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	
	new szString[128];
	format(szString, sizeof(szString), "%s (uid: %i) set %s's (uid: %i) admin level to %i using [/makeadmin]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], level);
	SendDiscordMessage(0, szString);

	if(level == 1)
	{
		SM(playerid, COLOR_AQUA, "You have removed %s's administrator powers.", GetRPName(targetid));
		SM(targetid, COLOR_AQUA, "%s has removed your administrator powers.", GetRPName(playerid));
	}
	else
	{
	    SM(playerid, COLOR_AQUA, "You have set %s's admin level to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(targetid), GetAdminRank(targetid), level);
		SM(targetid, COLOR_AQUA, "%s has set your admin level to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(playerid), GetAdminRank(targetid), level);
	}
	return 1;
}
CMD:sendloc(playerid, params[])
{
    new targetid, Float:x, Float:y, Float:z, Float:a;
    if(sscanf(params, "ui", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sendloc [playerid]");
    }
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
    }
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);


	SM(playerid, COLOR_AQUA, "** You have sent your location to %s.", GetRPName(targetid));
	SM(targetid, COLOR_AQUA, "** %s has sent you a location .", GetRPName(playerid));
    SetPlayerRaceCheckpoint(targetid, CP_TYPE_GROUND_FINISH , x, y, z, 0.0, 0.0, 0.0, 1.0);
    return 1;
}
CMD:makehelper(playerid, params[])
{
	new targetid, level;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /makehelper [playerid] [level]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!(0 <= level <= 4))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 4.");
	}
	if((PlayerInfo[playerid][pAdmin] < 6) && PlayerInfo[targetid][pHelper] > PlayerInfo[playerid][pHelper] && level < PlayerInfo[targetid][pHelper])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher helper level than you. They cannot be demoted.");
	}
	if(level == 0)
	{
		if(PlayerInfo[targetid][pTagType] == TAG_HELPER)
		{
			SetPlayerSpecialTag(targetid, TAG_NORMAL);
		}
		if(PlayerInfo[targetid][pAcceptedHelp])
		{
		    callcmd::return(targetid);
		}
	}


	SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a level %i helper.", GetRPName(playerid), GetRPName(targetid), level);
	PlayerInfo[targetid][pHelper] = level;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helperlevel = %i WHERE uid = %i", level, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	
    new szString[128];
	format(szString, sizeof(szString), "%s (uid: %i) set %s's (uid: %i) Moderater level to %i", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], level);
	SendDiscordMessage(0, szString);

	SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"%s{CCFFFF} (%i).", GetRPName(targetid), GetHelperRank(targetid), level);
	SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"%s{CCFFFF} (%i).", GetRPName(playerid), GetHelperRank(targetid), level);
	return 1;
}

CMD:setpassword(playerid, params[])
{
	new username[MAX_PLAYER_NAME], password[128];

    if(PlayerInfo[playerid][pAdmin] < 11)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]s[128]", username, password))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setpassword [username] [new password]");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. You can't change their password.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminChangePassword", "iss", playerid, username, password);
	return 1;
}

CMD:omakeadmin(playerid, params[])
{
	new username[MAX_PLAYER_NAME], level;

    if(PlayerInfo[playerid][pAdmin] < 8 && !IsPlayerAdmin(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]i", username, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /omakeadmin [username] [level]");
	}
	if(!(0 <= level <= 9))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 7.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use /makeadmin instead.");
	}
	
	new szString[128];
	format(szString, sizeof(szString), "%s (uid: %i) set %s's admin level to %i using [/omakeadmin]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, level);
	SendDiscordMessage(0, szString);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminSetAdminLevel", "isi", playerid, username, level);
	return 1;
}

CMD:omakehelper(playerid, params[])
{
	new username[MAX_PLAYER_NAME], level;

    if(PlayerInfo[playerid][pAdmin] < 6 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]i", username, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /omakehelper [username] [level]");
	}
	if(!(0 <= level <= 4))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 4.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use /makehelper instead.");
	}
    new szString[128];
	format(szString, sizeof(szString), "%s (uid: %i) set %s's admin level to %i using [/omakMod]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username, level);
	SendDiscordMessage(0, szString);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT helperlevel FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminSetHelperLevel", "isi", playerid, username, level);
	return 1;
}

CMD:addtoevent(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /addtoevent [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
	}
	if(!EventInfo[eReady])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There are no active events which you can add this player to.");
	}
	if(PlayerInfo[targetid][pJoinedEvent])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is already in the event.");
	}
	if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently playing paintball.");
	}

	SetPlayerInEvent(targetid);

	SM(targetid, COLOR_WHITE, "** %s has added you to the event.", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has added %s to the event.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:olisthelpers(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 6 && PlayerInfo[playerid][pHelper] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	mysql_tquery(connectionID, "SELECT username, lastlogin, helperlevel FROM users WHERE helperlevel > 0 ORDER BY lastlogin DESC", "OnQueryFinished", "ii", THREAD_LIST_HELPERS, playerid);
	return 1;
}
CMD:newb(playerid, params[]) return callcmd::newbie(playerid, params);
CMD:n(playerid, params[]) return callcmd::newbie(playerid, params);
CMD:newbie(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(n)ewbie [newbie chat]");
	}
	if(!enabledNewbie && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The newbie channel is disabled at the moment.");
	}
	if(PlayerInfo[playerid][pNewbieMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are muted from speaking in this channel. /report for an unmute.");
	}
	if(gettime() - PlayerInfo[playerid][pLastNewbie] < 60)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only speak in this channel every 60 seconds. Please wait %i more seconds.", 60 - (gettime() - PlayerInfo[playerid][pLastNewbie]));
	}
	if(PlayerInfo[playerid][pToggleNewbie])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the newbie chat as you have it toggled.");
	}

	SendNewbieChatMessage(playerid, params);

	PlayerInfo[playerid][pNewbies] ++;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET newbies = %i WHERE uid = %i", PlayerInfo[playerid][pNewbies], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:advertise(playerid, params[])
{
	return callcmd::ad(playerid, params);
}

CMD:ad(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid), price = strlen(params) * 5;

	if((businessid == -1 || BusinessInfo[businessid][bType] != 5))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any advertisement business.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(ad)vertise [advertisement] ($5/char)");
	}
	if(PlayerInfo[playerid][pAdMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are muted from submitting advertisements. /report for an unmute.");
	}
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a mobile phone. You need a phone so people can contact you.");
	}
	if(gettime() - gLastAd < 30)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Advertisements can only be posted every 30 seconds.");
	}
	if(PlayerInfo[playerid][pVIPPackage] < 1 && PlayerInfo[playerid][pCash] < price)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need $%i in order to place the advertisement. You can't afford that.", price);
	}

	new
		string[20];

	gLastAd = gettime();

	format(string, sizeof(string), "~n~  you paid %i$.", price);

	GivePlayerCash(playerid, -price);

	if(businessid >= 0)
	{
		BusinessInfo[businessid][bCash] += price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
		mysql_tquery(connectionID, queryBuffer);
	}

	SMA(COLOR_GREEN, "Advert: %s, just contact %s(%i)", params, GetRPName(playerid), PlayerInfo[playerid][pPhone]);
	return 1;
}


CMD:oadmins(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	mysql_tquery(connectionID, "SELECT username, lastlogin, adminlevel FROM users WHERE adminlevel > 0 ORDER BY lastlogin DESC", "OnQueryFinished", "ii", THREAD_LIST_ADMINS, playerid);
	return 1;
}

CMD:selldynamics(playerid, params[])
{
	new houses, garages, businesses;

	if(!IsPlayerAdmin(playerid))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to use this command.");
	}

	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(HouseInfo[i][hExists])
	    {
	        SetHouseOwner(i, INVALID_PLAYER_ID);
	        houses++;
	    }
	}

	for(new i = 0; i < MAX_GARAGES; i ++)
	{
	    if(GarageInfo[i][gExists])
	    {
	        SetGarageOwner(i, INVALID_PLAYER_ID);
	        garages++;
	    }
	}

	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(BusinessInfo[i][bExists])
	    {
	        SetBusinessOwner(i, INVALID_PLAYER_ID);
	        businesses++;
	    }
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has sold all properties.", GetRPName(playerid));
	SM(playerid, COLOR_WHITE, "** You have sell %i houses, %i garages and %i businesses.", houses, garages, businesses);
	return 1;
}

CMD:sellinactive(playerid, params[])
{
	new houses, garages, businesses;

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(HouseInfo[i][hExists] && HouseInfo[i][hOwnerID] > 0 && (gettime() - HouseInfo[i][hTimestamp]) > 1209600)
	    {
	        SetHouseOwner(i, INVALID_PLAYER_ID);
	        houses++;
	    }
	}

	for(new i = 0; i < MAX_GARAGES; i ++)
	{
	    if(GarageInfo[i][gExists] && GarageInfo[i][gOwnerID] > 0 && (gettime() - GarageInfo[i][gTimestamp]) > 1209600)
	    {
	        SetGarageOwner(i, INVALID_PLAYER_ID);
	        garages++;
	    }
	}

	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(BusinessInfo[i][bExists] && BusinessInfo[i][bOwnerID] > 0 && (gettime() - BusinessInfo[i][bTimestamp]) > 1209600)
	    {
	        SetBusinessOwner(i, INVALID_PLAYER_ID);
	        businesses++;
	    }
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has sold all inactive properties.", GetRPName(playerid));
	SM(playerid, COLOR_WHITE, "** You have sold %i inactive houses, %i inactive garages and %i inactive businesses.", houses, garages, businesses);
	return 1;
}

CMD:caplimit(playerid, params[])
{
	new option[8], amount;
    if(PlayerInfo[playerid][pAdmin] < 8 && PlayerInfo[playerid][pGangMod] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[8]i", option, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /caplimit [turfs/points] [amount]");
	}
    if(!strcmp(option, "turfs", true))
	{
	    if(0 > amount > MAX_TURFS)
		{
		    return SM(playerid, COLOR_SYNTAX, "Amount must be above 0 and less then %i.", MAX_TURFS);
		}
		MaxCapCount[0] = amount;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the max active turf claim limit for gangs to %i.", GetRPName(playerid), amount);
	}
	if(!strcmp(option, "points", true))
	{
	    if(0 > amount > MAX_POINTS)
		{
		    return SM(playerid, COLOR_SYNTAX, "Amount must be above 0 and less then %i.", MAX_POINTS);
		}
	    MaxCapCount[1] = amount;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the max active point cap limit for gangs to %i.", GetRPName(playerid), amount);
	}
	SaveServerInfo();
	return 1;
}

CMD:setmotd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 6 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	new option[8], newval[128];
	if(sscanf(params, "s[8]s[128]", option, newval))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setmotd [admin/helper/global] [text ('none' to reset)]");
	}
	if(strfind(newval, "|") != -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You may not include the '|' character in the MOTD.");
	}
	if(!strcmp(option, "global", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 8) return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
 		if(!strcmp(newval, "none", true))
		{
	    	gServerMOTD[0] = 0;
	    	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the global MOTD.", GetRPName(playerid));
		}
		else
		{
	    	strcpy(gServerMOTD, newval, 128);
	    	SAM(COLOR_YELLOW, "AdmCmd: %s has set the global MOTD to '%s'", GetRPName(playerid), gServerMOTD);
		}
	}
	if(!strcmp(option, "admin", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 8) return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
 		if(!strcmp(newval, "none", true))
		{
	    	adminMOTD[0] = 0;
      		SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the admin MOTD.", GetRPName(playerid));
		}
		else
		{
	    	strcpy(adminMOTD, newval, 128);
	    	SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the admin MOTD to '%s'", GetRPName(playerid), adminMOTD);
		}
	}
	if(!strcmp(option, "helper", true))
	{
 		if(!strcmp(newval, "none", true))
		{
	    	helperMOTD[0] = 0;
	    	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the helper MOTD.", GetRPName(playerid));
		}
		else
		{
	    	strcpy(helperMOTD, newval, 128);
	    	SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the helper MOTD to '%s'", GetRPName(playerid), helperMOTD);
		}
	}

	SaveServerInfo();
	return 1;
}

CMD:editland(playerid, params[])
{
	new landid, option[32], param[32];
	if(PlayerInfo[playerid][pAdmin] < 8)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[32]S()[32]", landid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editland [landid] [option]");
		SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Price, Level, Height, Owner");
		return 1;
	}
    if(!strcmp(option, "price", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SM(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
		if(!(1<= value <= 100000000))
		{
		    return SM(playerid, COLOR_SYNTAX, "Value cannot be less than 1 or more than 100M");
		}
	    LandInfo[landid][lPrice] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET price = %i WHERE id = %i", value, LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** You set land %i's price to %i.", landid, value);
		ReloadLand(landid);
	}
	else if(!strcmp(option, "level", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SM(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
		if(!(1 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Land levels cannot be below 0 or more than 3");
		}
	    LandInfo[landid][lLevel] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET level = %i WHERE id = %i", value, LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** You set land %i's price to %i.", landid, value);
		ReloadLand(landid);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;
		if(sscanf(param, "u", targetid))
	    {
			return SM(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
	   	SetLandOwner(landid, targetid);

		SM(playerid, COLOR_AQUA, "** You set land %i's owner to %s.", landid, GetRPName(targetid));
		ReloadLand(landid);
	}
	return 1;
}

CMD:motd(playerid, params[])
{
	if(!isnull(gServerMOTD))
	{
		SM(playerid, COLOR_YELLOW, "News: %s", gServerMOTD);
	}
	if(!isnull(adminMOTD) && PlayerInfo[playerid][pAdmin] > 0)
	{
		SM(playerid, COLOR_LIGHTRED, "Admin News: %s", adminMOTD);
	}
	if(!isnull(helperMOTD) && (PlayerInfo[playerid][pHelper] > 0 || PlayerInfo[playerid][pAdmin] > 0))
	{
		SM(playerid, COLOR_AQUA, "Helper News: %s", helperMOTD);
	}
	if(PlayerInfo[playerid][pGang] >= 0 && strcmp(GangInfo[PlayerInfo[playerid][pGang]][gMOTD], "None", true) != 0)
	{
		SM(playerid, COLOR_GREEN, "Gang News: %s", GangInfo[PlayerInfo[playerid][pGang]][gMOTD]);
	}
	return 1;
}

CMD:setstaff(playerid, params[])
{
	new targetid, option[16], status;

    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[16]i", targetid, option, status) || !(0 <= status <= 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstaff [playerid] [option] [status (0/1)]");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: FM, GM, BA");
		return 1;
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}

	if(!strcmp(option, "fm", true))
	{
	    PlayerInfo[targetid][pFactionMod] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET factionmod = %i WHERE uid = %i", PlayerInfo[targetid][pFactionMod], PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));

	        SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"faction moderator{CCFFFF}.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"faction moderator{CCFFFF}.", GetRPName(playerid));
		    new szString[129];
            format(szString, sizeof(szString), "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));
		    SendDiscordMessage(0, szString);
		}
		else
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));
	        SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"faction moderator{CCFFFF}.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"faction moderator{CCFFFF}.", GetRPName(playerid));
		    new szString[129];
            format(szString, sizeof(szString), "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));
		    SendDiscordMessage(0, szString);
		}
	}
	else if(!strcmp(option, "gm", true))
	{
	    PlayerInfo[targetid][pGangMod] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gangmod = %i WHERE uid = %i", PlayerInfo[targetid][pGangMod], PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a gang moderator.", GetRPName(playerid), GetRPName(targetid));

	        SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"gang moderator{CCFFFF}.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"gang moderator{CCFFFF}.", GetRPName(playerid));
		}
		else
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's gang moderator status.", GetRPName(playerid), GetRPName(targetid));

	        SM(playerid, COLOR_AQUA, "You have removed %s's "SVRCLR"gang moderator{CCFFFF} status.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has removed your "SVRCLR"gang moderator{CCFFFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "ba", true))
	{
	    PlayerInfo[targetid][pBanAppealer] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET banappealer = %i WHERE uid = %i", PlayerInfo[targetid][pBanAppealer], PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a ban appealer.", GetRPName(playerid), GetRPName(targetid));

	        SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"ban appealer{CCFFFF}.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"ban appealer{CCFFFF}.", GetRPName(playerid));
		}
		else
	    {
	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's ban appealer status.", GetRPName(playerid), GetRPName(targetid));

	        SM(playerid, COLOR_AQUA, "You have removed %s's "SVRCLR"ban appealer{CCFFFF} status.", GetRPName(targetid));
		    SM(targetid, COLOR_AQUA, "%s has removed your "SVRCLR"ban appealer{CCFFFF} status.", GetRPName(playerid));
		}
	}

	return 1;
}

CMD:updates(playerid,params[])
{
	mysql_tquery(connectionID, "SELECT * FROM changes ORDER BY slot", "OnQueryFinished", "ii", THREAD_LIST_CHANGES, playerid);
	return 1;
}

CMD:changelist(playerid, params[])
{
	new slot, option[10], param[64];

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[10]S()[64]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /changelist [view | edit | clear]");
	}
	if(!strcmp(option, "view", true))
	{
	    mysql_tquery(connectionID, "SELECT * FROM changes ORDER BY slot", "OnQueryFinished", "ii", THREAD_LIST_CHANGES, playerid);
	}
	else if(!strcmp(option, "edit", true))
	{
	    if(sscanf(param, "is[64]", slot, param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /changelist [edit] [slot (1-10)] [text]");
		}
		if(!(1 <= slot <= 10))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO changes VALUES(%i, '%e') ON DUPLICATE KEY UPDATE text = '%e'", slot, param, param);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** Change text for slot %i changed to '%s'.", slot, param);
	}
	else if(!strcmp(option, "clear", true))
	{
	    if(sscanf(param, "i", slot))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /changelist [clear] [slot (1-10)]");
		}
		if(!(1 <= slot <= 10))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM changes WHERE slot = %i", slot);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** Change text for slot %i cleared.", slot);
	}

	return 1;
}
CMD:toghelmet(playerid, params[])
{
    if(PlayerInfo[playerid][pHelmet] > 0)
	{
		if(PlayerInfo[playerid][pHidehelmet] == 0)
		{
		
			RemovePlayerAttachedObject(playerid , 9);
			PlayerInfo[playerid][pHidehelmet] = 1;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmet = %i WHERE uid = %i", PlayerInfo[playerid][pHelmet], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid,COLOR_BLUE,"Togged");
		}
		else // Use else here
		{
			PlayerInfo[playerid][pHidehelmet] = 0;
			SendClientMessage(playerid,COLOR_BLUE,"Togged");
		}
   	}

	return 1;
}


CMD:forceaduty(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /forceaduty [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player needs to be at least a level 2 administrator.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be forced into admin duty.");
	}

	if(!PlayerInfo[targetid][pAdminDuty])
	{
		SM(targetid, COLOR_WHITE, "** %s has forced you to be on admin duty.", GetRPName(playerid));
	}
	else
	{
	    SM(targetid, COLOR_WHITE, "** %s has forced you to be off admin duty.", GetRPName(playerid));
	}

	callcmd::aduty(targetid);
	return 1;
}

CMD:listhelp(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Help Requests:");

	foreach(new i : Player)
	{
	    if(!isnull(PlayerInfo[i][pHelpRequest]))
	    {
	        SM(playerid, COLOR_GREY2, "** %s[%i] asks: %s", GetRPName(i), i, PlayerInfo[i][pHelpRequest]);
		}
	}

	SendClientMessage(playerid, COLOR_AQUA, "** Use /accepthelp [id] or /denyhelp [id] to handle help requests.");
	SendClientMessage(playerid, COLOR_AQUA, "** Use /answerhelp [id] [msg] to PM an answer without the need to teleport.");
	return 1;
}

CMD:clearall(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use that command!");
    }
    foreach(new i : Player)
	{
    	PlayerInfo[i][pWantedLevel] = 0;

  		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerInfo[i][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 0 WHERE uid = %i", PlayerInfo[i][pID]);
		mysql_tquery(connectionID, queryBuffer);
    }
    SAM(COLOR_LIGHTRED, "AdmCmd: %s has cleared everyone's Wanted Level.", GetRPName(playerid));
    return 1;
}
CMD:rd(playerid, params[]){ 
	callcmd::rdcchat(playerid, params);
}
CMD:rdcchat(playerid, params[])
{
	
	new gangid, text[128];

	if(!IsAHitman(playerid))
	{
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are Not A Rdc");
	}
	if(sscanf(params, "is[128]", gangid, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rdcchat [gangid] [text]");
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}

    foreach(new i : Player)
    {   
		if(PlayerInfo[i][pGang] == gangid)
		{
            new charext[328];
			format(charext, 328, "{ffffff}[{fc2306}RDC{FFFFFF}-{fcd106}MSG{ffffff}] {ffffff}: %s ", text);
            SendClientMessage(i, COLOR_YELLOW, charext);
		}		  
	}
	
	SM(playerid, COLOR_YELLOW, "{FFFFFF}[{fc2306}MSG{FFFFFF}-{fcd106}SEND{FFFFFF}] {06fc9b}Gang {FFFFFF}:[%s]: %s ", GangInfo[gangid][gName], text);

	return 1;

}
CMD:rds(playerid, params[])
{
	
	new  text[228];
	if(!PlayerInfo[playerid][pGang])
	{
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are Not A Gang Member");
	}
	if(sscanf(params, "s[128]", text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rdcchat [text]");
	}
    foreach(new i : Player)
    {   
		if(IsAHitman(i)){
			new charext[512];
			format(charext, 512 , "{ffffff}[{fc2306}GANG{FFFFFF}-{fcd106}MSG{ffffff}] {06fc9b}Gang : {fc2306}%s {ffffff}[{fcd106}Player :{ffffff} %s]",GangInfo[PlayerInfo[playerid][pGang]][gName], GetRPName(playerid));
            SendClientMessage(i, COLOR_YELLOW, charext);
			SM(i, COLOR_YELLOW, "[MSG-%s] : %s ", GangInfo[PlayerInfo[playerid][pGang]][gName], text); 
			
		}  
	}
	
	SM(playerid, COLOR_YELLOW, "{FFFFFF}[{fc2306}MSG{FFFFFF}-{fcd106}SEND{FFFFFF}] : %s ", text); 

	//new dc_str[454];
//	format(dc_str, sizeof(dc_str), "%s is whispering %s: %s", GetRPName(playerid), GetRPName(targetid), text);
	//SendDiscordMessage(11, dc_str);

	return 1;

}
CMD:accepthelp(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to leave the paintball arena first.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /accepthelp [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(isnull(PlayerInfo[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested any help since they connected.");
	}

	if(PlayerInfo[playerid][pTagType] == TAG_NORMAL)
	{
 		SetPlayerSpecialTag(playerid, TAG_HELPER);
	}

	if(!PlayerInfo[playerid][pAcceptedHelp])
	{
		SavePlayerVariables(playerid);
	}

	TeleportToPlayer(playerid, targetid, false);

	TogglePlayerControllable(targetid, 0);
	SetTimerEx("UnfreezeNewbie", 5000, false, "i", targetid);

	SetPlayerHealth(playerid, 32767);

	PlayerInfo[playerid][pHelpRequests]++;
	PlayerInfo[playerid][pAcceptedHelp] = 1;
	PlayerInfo[targetid][pHelpRequest][0] = 0;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helprequests = %i WHERE uid = %i", PlayerInfo[playerid][pHelpRequests], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_WHITE, "** You accepted %s's help request and were sent to their position. /return to go back.", GetRPName(targetid));
	SM(targetid, COLOR_YELLOW, "%s has accepted your help request. They are now assisting you.", GetRPName(playerid));

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has accepted help request %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:denyhelp(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /denyhelp [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(isnull(PlayerInfo[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested any help since they connected.");
	}

	PlayerInfo[targetid][pHelpRequest][0] = 0;

	SM(playerid, COLOR_WHITE, "** You denied %s's help request.", GetRPName(targetid));
	SM(targetid, COLOR_LIGHTRED, "** %s has denied your help request.", GetRPName(playerid));

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has denied help request %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:sta(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sta [playerid] (Sends /gethelp to admins)");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(isnull(PlayerInfo[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested any help since they connected.");
	}

    AddReportToQueue(targetid, PlayerInfo[targetid][pHelpRequest]);
    PlayerInfo[targetid][pHelpRequest][0] = 0;

	SM(playerid, COLOR_WHITE, "** You sent %s's help request to all online admins.", GetRPName(targetid));
	SM(targetid, COLOR_AQUA, "** %s has sent your help request to all online admins.", GetRPName(playerid));
	return 1;
}

CMD:return(playerid)
{
    if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAcceptedHelp])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent accepted any help requests.");
	}

    if(PlayerInfo[playerid][pTagType] == TAG_HELPER)
	{
	    SetPlayerSpecialTag(playerid, TAG_NORMAL);
	}

	SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	SetScriptArmour(playerid, PlayerInfo[playerid][pArmor]);

	SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
	SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pWorld]);
	SetCameraBehindPlayer(playerid);

	SendClientMessage(playerid, COLOR_WHITE, "** You were returned to your previous position.");
    PlayerInfo[playerid][pAcceptedHelp] = 0;
	return 1;
}

CMD:answerhelp(playerid, params[])
{
	new targetid, msg[128];

	if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, msg))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /answerhelp [playerid] [message]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(isnull(PlayerInfo[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested any help since they connected.");
	}

	PlayerInfo[playerid][pHelpRequests]++;
	PlayerInfo[targetid][pHelpRequest][0] = 0;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helprequests = %i WHERE uid = %i", PlayerInfo[playerid][pHelpRequests], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    SendClientMessage(playerid, COLOR_WHITE, "You");

	if(strlen(msg) > MAX_SPLIT_LENGTH)
	{
		SM(targetid, COLOR_YELLOW, "** Answer from Helper %s: %.*s... **", GetRPName(playerid), MAX_SPLIT_LENGTH, msg);
		SM(targetid, COLOR_YELLOW, "** Answer from Helper %s: ...%s **", GetRPName(playerid), msg[MAX_SPLIT_LENGTH]);
	}
	else
	{
	    SM(targetid, COLOR_YELLOW, "** Answer from Helper %s: %s **", GetRPName(playerid), msg);
	}

	SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has answered %s's help request.", GetRPName(playerid), GetRPName(targetid));

	return 1;
}

CMD:c(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] < 1 && PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /c [staff chat]");
	}
	if(PlayerInfo[playerid][pToggleHelper])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the staff chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
		if((!PlayerInfo[i][pToggleHelper]) && (PlayerInfo[i][pHelper] > 0 || PlayerInfo[i][pAdmin] > 0))
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SM(i, 0x42f4EEFF, "*%s {42f4EE}%s %s: %.*s... **", IsPlayerAndroid(playerid) ? ("{CCFFFF}Android") : ("{C2A2DA}Desktop"), GetStaffRank2(playerid), GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SM(i, 0x42f4EEFF, "*%s %s: ...%s **", GetStaffRank2(playerid), GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
				SM(i, 0x42f4EEFF, "*%s {42f4EE}%s %s: %s **", IsPlayerAndroid(playerid) ? ("{CCFFFF}Android") : ("{C2A2DA}Desktop"), GetStaffRank2(playerid), GetRPName(playerid), params);
			}
		}
	}
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "Helper Chat[/c] %s %s: %s **", GetStaffRank2(playerid), GetRPName(playerid), params);
	SendDiscordMessage(10, dc_str);
	return 1;
}
CMD:atake(playerid, params[])
{
	new targetid, option[14];

    if(PlayerInfo[playerid][pAdmin] < 4)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[14]", targetid, option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /take [playerid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapons, Pot, Cocaine, Cocaine, Joint, CarLicense");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: DirtyCash, GunLicense, Materials");
		return 1;
	}

	if(!strcmp(option, "weapons", true))
	{
	    ResetPlayerWeaponsEx(targetid);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's weapons.", GetRPName(playerid), GetRPName(targetid));

	    SM(targetid, COLOR_AQUA, "%s has taken your weapons.", GetRPName(playerid));
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) weapons.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	}
	else if(!strcmp(option, "pot", true))
	{
	    if(!PlayerInfo[targetid][pPot])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no pot on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's pot.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i grams of pot.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
	    //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of pot.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pPot]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pPot] = 0;
	}
	else if(!strcmp(option, "Cocaine", true))
	{
	    if(!PlayerInfo[targetid][pCrack])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no Cocaine on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's Cocaine.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i grams of Cocaine.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of Cocaine.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pCrack]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Crack = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pCrack] = 0;
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(!PlayerInfo[targetid][pMaterials])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no materials on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's materials.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i materials.", GetRPName(playerid), PlayerInfo[targetid][pMaterials]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i materials.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pMaterials]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pMaterials] = 0;
	}
	else if(!strcmp(option, "Cocaine", true))
	{
	    if(!PlayerInfo[targetid][pMeth])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no Cocaine on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's Cocaine.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i grams of Cocaine.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of meth.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pMeth]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pMeth] = 0;
	}
	else if(!strcmp(option, "Joint", true))
	{
	    if(!PlayerInfo[targetid][pPainkillers])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no Joint on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's Joint.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i Joint.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i Joint.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pPainkillers]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pPainkillers] = 0;
	}
	else if(!strcmp(option, "carlicense", true))
	{
	    if(!PlayerInfo[targetid][pCarLicense])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no driving license on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's drivers license.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your drivers license.", GetRPName(playerid));
	    //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) drivers license.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carlicense = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pCarLicense] = 0;
	}
	else if(!strcmp(option, "gunlicense", true))
	{
	    if(!PlayerInfo[targetid][pWeaponLicense])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no gun license on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's gun license.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your gun license.", GetRPName(playerid));
	    //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) gun license.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	    new szString[128];
		format(szString, sizeof(szString), "%s (uid: %i) has taken %s's (uid: %i) gun license.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
		SendDiscordMessage(4, szString);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunlicense = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pWeaponLicense] = 0;
	}
	else if(!strcmp(option, "dirtycash", true))
	{
	    if(!PlayerInfo[targetid][pDirtyCash])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no dirty cash on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's dirty cash.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your dirty cash.", GetRPName(playerid));
	    //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) dirty cash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pDirtyCash] = 0;
	}

	return 1;
}
CMD:hh(playerid, params[])
{
	return callcmd::helperhelp(playerid, params);
}

CMD:hhelp(playerid, params[])
{
	return callcmd::helperhelp(playerid, params);
}


CMD:helperhelp(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(PlayerInfo[playerid][pHelper] >= 1)
	{
		SendClientMessage(playerid, COLOR_AQUA, "Junior Helper:"WHITE" /c, /listhelp, /accepthelp, /answerhelp, /denyhelp, /sta, /return.");
	}
    if(PlayerInfo[playerid][pHelper] >= 2)
	{
		SendClientMessage(playerid, COLOR_AQUA, "General Helper:"WHITE" /nmute, /hmute, /gmute, /admute");
	}
    if(PlayerInfo[playerid][pHelper] >= 3)
	{
		SendClientMessage(playerid, COLOR_AQUA, "Senior Helper:"WHITE" /olisthelpers, /prisonic /checknewbies.");
	}
	if(PlayerInfo[playerid][pHelper] >= 4)
	{
		SendClientMessage(playerid, COLOR_AQUA, "Head Helpe:"WHITE" /makehelper, /omakehelper, /kick.");
	}
	return 1;
}

CMD:properties(playerid, params[])
{
	new type[16];

	SendClientMessage(playerid, SERVER_COLOR, "My Properties:");

    for(new i = 0; i < MAX_HOUSES; i ++)
    {
        if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
        {
            if(HouseInfo[i][hType] == -1)
			{
			    type = "Other";
			}
			else
			{
			    strcpy(type, houseInteriors[HouseInfo[i][hType]][intClass]);
			}

	        if((gettime() - HouseInfo[i][hTimestamp]) > 1209600)
    	    {
        	    SM(playerid, COLOR_GREY2, "(HID: %i) Your %s house in %s is currently marked as "SVRCLR"Inactive{C8C8C8}.", HouseInfo[i][hID], type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]));
			}
			else
			{
		    	SM(playerid, COLOR_GREY2, "(HID: %i) Your %s house in %s is currently marked as "SVRCLR"Active{C8C8C8}.", HouseInfo[i][hID], type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]));
			}
		}
	}

	for(new i = 0; i < MAX_GARAGES; i ++)
    {
        if(GarageInfo[i][gExists] && IsGarageOwner(playerid, i))
        {
	        if((gettime() - GarageInfo[i][gTimestamp]) > 1209600)
    	    {
        	    SM(playerid, COLOR_GREY2, "(GID: %i) Your %s garage in %s is currently marked as "SVRCLR"Inactive{C8C8C8}.", GarageInfo[i][gID], garageInteriors[GarageInfo[i][gType]][intName], GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]));
			}
			else
			{
		    	SM(playerid, COLOR_GREY2, "(GID: %i) Your %s garage in %s is currently marked as "SVRCLR"Active{C8C8C8}.", GarageInfo[i][gID], garageInteriors[GarageInfo[i][gType]][intName], GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]));
			}
		}
	}

	for(new i = 0; i < MAX_BUSINESSES; i ++)
    {
        if(BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
        {
	        if((gettime() - BusinessInfo[i][bTimestamp]) > 1209600)
    	    {
        	    SM(playerid, COLOR_GREY2, "(BID: %i) Your %s business in %s is currently marked as "SVRCLR"Inactive{C8C8C8}.", BusinessInfo[i][bID], bizInteriors[BusinessInfo[i][bType]][intType], GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]));
			}
			else
			{
		    	SM(playerid, COLOR_GREY2, "(BID: %i) Your %s business in %s is currently marked as "SVRCLR"Active{C8C8C8}.", BusinessInfo[i][bID], bizInteriors[BusinessInfo[i][bType]][intType], GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]));
			}
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "** Your properties become inactive if you don't enter them for 14+ days.");
	return 1;
}

CMD:setrent(playerid, params[])
{
	new price, houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "i", price))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setrent [price ('0' to disable)]");
	}
	if(!(0 <= price <= 10000))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid price. The price must range between $0 and $10,000.");
	}

	HouseInfo[houseid][hRentPrice] = price;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET rentprice = %i WHERE id = %i", price, HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
	SM(playerid, COLOR_AQUA, "** You've set the rental price to $%i.", price);
	return 1;
}

CMD:renthouse(playerid, params[])
{
	new houseid;

	if((houseid = GetNearbyHouse(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no house in range. You must be near a house.");
	}
	if(!HouseInfo[houseid][hOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This house is not owned and therefore cannot be rented.");
	}
	if(!HouseInfo[houseid][hRentPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This house's owner has chosen to disable renting for this house.");
	}
	if(PlayerInfo[playerid][pCash] < HouseInfo[houseid][hRentPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to rent here.");
	}
	if(IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are the owner of this house. You can't rent here.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerRentHouse", "ii", playerid, houseid);
	return 1;
}

CMD:unrent(playerid, params[])
{
	if(!PlayerInfo[playerid][pRentingHouse])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not renting at any property. You can't use this command.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rentinghouse = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	PlayerInfo[playerid][pRentingHouse] = 0;
	SendClientMessage(playerid, COLOR_WHITE, "** You have ripped up your rental contract.");
	return 1;
}

CMD:tenants(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin FROM users WHERE rentinghouse = %i ORDER BY lastlogin DESC", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LIST_TENANTS, playerid);
	return 1;
}
forward TimerLockpick(playerid);
public TimerLockpick(playerid)
{
    TogglePlayerControllable(playerid, true);
    PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	SendProximityMessage(playerid, 20.0, COLOR_BLUE, "** %s successfully lockpicked the vehicle.", GetRPName(playerid));
	return 1;
}
CMD:lockpick(playerid, params[])
{	
	new vehicleid = GetNearbyVehicle(playerid);

	if(PlayerInfo[playerid][pLockpick] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any lockpicks left.");
	}
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You may only break into a player owned vehicle.");
	}
	if(VehicleInfo[vehicleid][vLocked] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is unlocked. Therefore you can't break into it.");
	}

	PlayerInfo[playerid][pLockpick]--;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET lockpick = %i WHERE uid = %i", PlayerInfo[playerid][pLockpick], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	if(GetNearbyVehicle(playerid))
	{	
		TogglePlayerControllable(playerid, 0);
		VehicleInfo[vehicleid][vLocked] = 0;
		SetVehicleParams(vehicleid, VEHICLE_DOORS, false);
		//notification.Show(playerid, "ROB INFO", "  Lockpicking the vehicle...","!",BoxColour_BLUE);
		SetTimerEx("TimerLockpick", 10000, false, "i", playerid);
		SendProximityMessage(playerid, 20.0, COLOR_BLUE, "** %s is unlocking the vehicle.", GetRPName(playerid));
	}
	return 1;
}
CMD:evict(playerid, params[])
{
    new username[MAX_PLAYER_NAME], houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /evict [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e' AND rentinghouse = %i", username, HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerEvict", "is", playerid, username);
	return 1;
}

CMD:evictall(playerid, params[])
{
    new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}

	foreach(new i : Player)
    {
        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pRentingHouse] == HouseInfo[houseid][hID])
        {
            PlayerInfo[i][pRentingHouse] = 0;
            SendClientMessage(i, COLOR_RED, "You have been evicted from your home by the owner.");
        }
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rentinghouse = 0 WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
    mysql_tquery(connectionID, queryBuffer);

    SendClientMessage(playerid, COLOR_WHITE, "** You have evicted all tenants from your home.");
    return 1;
}
CMD:cursor(playerid, params) {
	SelectTextDraw(playerid, -1);
	return 1;
}
CMD:houseinvite(playerid, params[])
{
	new targetid, houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "i", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /houseinvite [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    //return SendClientMessage(playerid, COLOR_SYNTAX, "You can't invite yourself to your own home.");
	}

	PlayerInfo[targetid][pInviteOffer] = playerid;
	PlayerInfo[targetid][pInviteHouse] = houseid;

	SM(targetid, COLOR_AQUA, "** %s has offered you an invitation to their house in %s. (/accept invite)", GetRPName(playerid), GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]));
	SM(playerid, COLOR_AQUA, "** You have offered %s an invitation to your house.", GetRPName(targetid));
	return 1;
}

CMD:furniture(playerid, params[])
{
	new houseid = GetInsideHouse(playerid), option[10], param[32];

	if(houseid == -1 || !HasFurniturePerms(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any house of yours.");
	}
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Buy, Edit, Sell, Clear, Allow, Disallow, Labels");
	    return 1;
	}
	if(!strcmp(option, "buy", true))
	{
		if(PlayerInfo[playerid][pAdminDuty])
		{
		    return SAM(COLOR_RED, "%s has attempted to buy a furniture while on-duty, bobo!", GetRPName(playerid));
		}
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_FURNITURE, playerid);
	}
	else if(!strcmp(option, "edit", true))
	{
	    new objectid;

	    if(sscanf(param, "i", objectid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [edit] [objectid]");
		}
		if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_FURNITURE)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. You can find the object IDs for your furniture by enabling labels. [/furniture labels]");
        }
        if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != HouseInfo[houseid][hID])
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. This furniture object is not inside of your house.");
        }

        PlayerInfo[playerid][pEditType] = EDIT_FURNITURE;
        PlayerInfo[playerid][pEditObject] = objectid;
        PlayerInfo[playerid][pFurnitureHouse] = houseid;

		EditDynamicObject(playerid, objectid);
        GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
	}
	else if(!strcmp(option, "sell", true))
	{
	    new objectid;

	    if(PlayerInfo[playerid][pAdminDuty])
		{
		    return SAM(COLOR_RED, "%s has attempted to sell furniture in the house while on-duty, bobo!", GetRPName(playerid));
		}

	    if(sscanf(param, "i", objectid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [sell] [objectid] (75%% refund)");
		}
		if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_FURNITURE)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. You can find the object IDs for your furniture by enabling labels. [/furniture labels]");
        }
        if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != HouseInfo[houseid][hID])
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. This furniture object is not inside of your house.");
        }

        PlayerInfo[playerid][pSelected] = objectid;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, price FROM furniture WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
        mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_SELL_FURNITURE, playerid);
	}
	else if(!strcmp(option, "clear", true))
	{
		if(PlayerInfo[playerid][pAdminDuty])
		{
		    return SAM(COLOR_RED, "%s has attempted to clear a house furniture while on-duty, bobo!", GetRPName(playerid));
		}
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [clear] [confirm]");
			SendClientMessage(playerid, COLOR_WHITE, "This sells all of your furniture in your house. This action is irreversible.");
			return 1;
		}

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT price FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
        mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CLEAR_FURNITURE, playerid);
	}
	else if(!strcmp(option, "allow", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [allow] [playerid]");
		}
		if(!IsHouseOwner(playerid, houseid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This can only be done by the house owner.");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
		}
		if(targetid == playerid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
		}
		if(PlayerInfo[targetid][pFurniturePerms] == houseid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already allowed that player to access your furniture.");
		}

		PlayerInfo[targetid][pFurniturePerms] = houseid;

		SM(targetid, COLOR_AQUA, "%s has allowed you to access their home's furniture.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "You have allowed %s to access your home's furniture.", GetRPName(targetid));
	}
	else if(!strcmp(option, "disallow", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /furniture [disallow] [playerid]");
		}
		if(!IsHouseOwner(playerid, houseid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This can only be done by the house owner.");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
		}
		if(targetid == playerid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
		}
		if(PlayerInfo[targetid][pFurniturePerms] != houseid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent allowed that player to access your furniture.");
		}

		PlayerInfo[targetid][pFurniturePerms] = -1;

		SM(targetid, COLOR_AQUA, "%s has removed your access to their home's furniture.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "You have removed %s's access to your home's furniture.", GetRPName(targetid));
	}
	else if(!strcmp(option, "labels", true))
	{
	    if(!HouseInfo[houseid][hLabels])
	    {
	        HouseInfo[houseid][hLabels] = 1;
         	SendClientMessage(playerid, COLOR_AQUA, "You will now see labels appear above all of your furniture.");
	    }
	    else
	    {
	        HouseInfo[houseid][hLabels] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any labels appear above your furniture.");
	    }

	    ReloadAllFurniture(houseid);
	}


	return 1;
}

