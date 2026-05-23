CMD:dm(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /dm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be punished.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}

	PlayerInfo[targetid][pDMWarnings]++;

	if(PlayerInfo[targetid][pDMWarnings] < 5)
	{
	    new minutes = PlayerInfo[targetid][pDMWarnings] * 15;

	    PlayerInfo[targetid][pJailType] = 2;
    	PlayerInfo[targetid][pJailTime] = PlayerInfo[targetid][pDMWarnings] * 900;
    	PlayerInfo[targetid][pWeaponRestricted] = PlayerInfo[targetid][pDMWarnings] * 2;

		SetPlayerInJail(targetid);

		if(PlayerInfo[playerid][pAdmin] == 1)
		{
		    SMA(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by an Admin (%i/5 Warnings)", GetRPName(targetid), minutes, PlayerInfo[targetid][pDMWarnings]);
		    strcpy(PlayerInfo[targetid][pPrisonedBy], "Secret Admin", MAX_PLAYER_NAME);
		}
		else
		{
			SMA(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by %s (%i/5 Warnings)", GetRPName(targetid), minutes, GetRPName(playerid), PlayerInfo[targetid][pDMWarnings]);
			GetPlayerName(playerid, PlayerInfo[targetid][pPrisonedBy], MAX_PLAYER_NAME);
		}

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonedby = '%e', prisonreason = 'DM' WHERE uid = %i", PlayerInfo[targetid][pPrisonedBy], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerInfo[targetid][pPrisonReason], "DM", 128);

		GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);
		SM(targetid, COLOR_WHITE, "** You have been admin prisoned for %i minutes, reason: DM.", minutes);
		SM(targetid, COLOR_WHITE, "** Your punishment is %i hours of weapon restriction and %i/5 DM warning.", PlayerInfo[targetid][pWeaponRestricted], PlayerInfo[targetid][pDMWarnings]);
	}
	else
	{

		if(PlayerInfo[playerid][pAdmin] == 1)
		{
			new from[] = "Secret Admin";
			new reason[] = "DM (5/5 warnings)";
		    BanPlayer(targetid, from, reason);
			SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by an admin for deathmatching (5/5 warnings)", GetRPName(targetid));
			PlayerInfo[targetid][pDMWarnings] = 0;
		}
		else
		{
			new reason[] = "DM (5/5 warnings)";
	        BanPlayer(targetid, GetPlayerNameEx(playerid), reason);
			SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by %s for deathmatching (5/5 warnings)", GetRPName(targetid), GetRPName(playerid));
            PlayerInfo[targetid][pDMWarnings] = 0;
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET jailtype = %i, jailtime = %i, dmwarnings = %i, weaponrestricted = %i WHERE uid = %i", PlayerInfo[targetid][pJailType], PlayerInfo[targetid][pJailTime], PlayerInfo[targetid][pDMWarnings], PlayerInfo[targetid][pWeaponRestricted], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:god(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 3)
	{
        SetPlayerHealth(playerid, 32767);
        SetPlayerArmour(playerid, 32767);
    }
	return 1;
}

ClearDeathList(playerid)
{
	for(new i = 0; i < 5; i ++)
	{
		SendDeathMessageToPlayer(playerid, 1001, 1001, 255);
	}
	return 1;
}

CMD:aduty(playerid)
{
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty])
	{
		SetPlayerSpecialTag(playerid, TAG_ADMIN);

	    SavePlayerVariables(playerid);
	    ResetPlayerWeapons(playerid);
	    PlayerInfo[playerid][pCash] = 0;

		SetPlayerHealth(playerid, 32767);
		SetScriptArmour(playerid, 0.0);

		

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s is now on admin duty.", GetRPName(playerid));
	    SendClientMessage(playerid, COLOR_WHITE, "You are now on admin duty. Your stats will not be saved until you're off duty.");
	

        PlayerInfo[playerid][pAdminDuty] = 1;
        PlayerInfo[playerid][pTogglePhone] = 1;
        PlayerInfo[playerid][pAdutyl] = 1;
       
        if(strcmp(PlayerInfo[playerid][pAdminName], "None", true) != 0)
        {
	        SetPlayerName(playerid, PlayerInfo[playerid][pAdminName]);
		}
    }
	else
	{
		new savecheck = 0;
		SetPlayerSpecialTag(playerid, TAG_NORMAL);
		if(PlayerInfo[playerid][pPaycheck] > 1)
		{
		    savecheck = PlayerInfo[playerid][pPaycheck];
		}
		
		ClearDeathList(playerid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE uid = %i", PlayerInfo[playerid][pID]);
    	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_PROCESS_LOGIN, playerid);
		PlayerInfo[playerid][pPaycheck] = savecheck;
	}

	return 1;
}

CMD:setadminname(playerid, params[])
{
	new name[MAX_PLAYER_NAME], targetid;

    if(PlayerInfo[playerid][pAdmin] < 8)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[24]", targetid, name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setadminname [playerid] [name ('none' to reset)]");
	}
	if(PlayerInfo[targetid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot set an admin name to a player.");
	}
	if(!IsValidName(name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The name specified is not supported by the SA-MP client.");
	}

	strcpy(PlayerInfo[targetid][pAdminName], name, MAX_PLAYER_NAME);

	if(PlayerInfo[targetid][pAdminDuty])
	{
	    SetPlayerName(targetid, name);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminname = '%e' WHERE uid = %i", name, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "ADMCMD: %s has changed %s's adminname to %s", PlayerInfo[playerid][pUsername], PlayerInfo[targetid][pUsername], name);
	return 1;
}

CMD:getip(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getip [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, COLOR_WHITE, "** %s[%i]'s IP: %s **", GetRPName(targetid), targetid, GetPlayerIP(targetid));
	return 1;
}

CMD:ogetip(playerid, params[])
{
	new name[MAX_PLAYER_NAME];

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ogetip [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_OFFLINE_IP, playerid);

	return 1;
}

CMD:iplookup(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!IsAnIP(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /iplookup [ip address]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin FROM users WHERE ip = '%e' ORDER BY lastlogin DESC", params);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_TRACE_IP, playerid);

	return 1;
}

CMD:lastactive(playerid, params[])
{
	new username[24], specifiers[] = "%D of %M, %Y @ %k:%i";

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /lastactive [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT DATE_FORMAT(lastlogin, '%s') FROM users WHERE username = '%e'", specifiers, username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckLastActive", "is", playerid, username);

	return 1;
}
CMD:prisoners(playerid, params[])
{
	return callcmd::listjailed(playerid, params);
}
CMD:listjailed(playerid, params[])
{
	new type[14];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Jailed Players:");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pJailType] > 0)
	    {
	        switch(PlayerInfo[i][pJailType])
	        {
	            case 1: type = "OOC jailed";
				case 2: type = "OOC prisoned";
				case 3: type = "IC prisoned";
			}

			SM(playerid, COLOR_GREY1, "(ID: %i) %s - Status: %s - Time: %i seconds", i, GetRPName(i), type, PlayerInfo[i][pJailTime]);
		}
	}

	return 1;
}
CMD:prisoner(playerid, params[])
{
	return callcmd::prisoninfo(playerid, params);
}
CMD:prisoninfo(playerid, params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /prisoninfo [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pJailType] != 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not in OOC prison.");
	}

	SM(playerid, COLOR_WHITE, "** %s was prisoned by %s, reason: %s (%i seconds left.) **", GetRPName(targetid), PlayerInfo[targetid][pPrisonedBy], PlayerInfo[targetid][pPrisonReason], PlayerInfo[targetid][pJailTime]);
	return 1;
}

CMD:relog(playerid, params[])
{
	new targetid;
	new string[64], playerIP[32];
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /relog [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to relog.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessage(targetid, SERVER_COLOR, "NOTE:"WHITE" You are being reconnected to the server - please wait...");
	SavePlayerVariables(targetid);
	ResetPlayer(targetid);
	PlayerInfo[targetid][pLogged] = 0;
	GetPlayerIp(targetid, playerIP, sizeof(playerIP));
	Reconnecting[targetid] = true;
 	format(ReconnectIP[targetid], MAX_IP_SIZE, "%s", playerIP);
  	format(string, sizeof(string), "banip %s", playerIP);
   	SendRconCommand(string);
	return 1;
}


CMD:setint(playerid, params[])
{
    new targetid, interiorid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, interiorid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setint [playerid] [int]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!(0 <= interiorid <= 19))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid interior. Valid interiors range from 0 to 19.");
	}

	SetPlayerInterior(targetid, interiorid);
	SM(playerid, COLOR_GREY2, "%s's interior set to ID %i.", GetRPName(targetid), interiorid);
	return 1;
}

CMD:setvw(playerid, params[])
{
    new targetid, worldid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, worldid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvw [playerid] [vw]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SetPlayerVirtualWorld(targetid, worldid);
	SM(playerid, COLOR_GREY2, "%s's virtual world set to ID %i.", GetRPName(targetid), worldid);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new targetid, skinid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, skinid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setskin [playerid] [skinid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!(0 <= skinid <= 311))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin specified.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
	}

	PlayerInfo[targetid][pSkin] = skinid;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", skinid, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SetPlayerSkin(targetid, skinid);
	SM(playerid, COLOR_GREY2, "%s's skin set to ID %i.", GetRPName(targetid), skinid);
	return 1;
}


CMD:irev(playerid) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -348.081176, -1046.802734, 59.812500) && !IsPlayerInRangeOfPoint(playerid, 5.0, -1289.585204, 490.628662, 11.455604) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2374.585204, 1958.628662, 6.455604)) return 1;
	
    if(!PlayerInfo[playerid][pInjured]) 
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not injured");
	}
    if(PlayerInfo[playerid][pCash]<15000)
	{
		return SendClientMessage(playerid, COLOR_GREY,"You don't have enough money to Ilegal revive.");
	}
    GameTextForPlayer(playerid, "~p~Illegal Reving...", 10000, 5);
	SetTimerEx("IRevive", 10000, false, "i", playerid);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Medic uses alcohol, cotton and bandage to cure %s wound.", GetRPName(playerid));
	SAM(COLOR_YELLOW, "AdmWarning:%s Using Illegal Revive", GetRPName(playerid), playerid);

	return 1;
}
CMD:rev(playerid, params[])
{
	new targetid;
	new reason[64];

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "us[64]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /revive [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not injured.");
	}
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
   
	PlayerInfo[targetid][pInjured] = 0;
	PlayerInfo[targetid][pHunger] = 100;
	PlayerInfo[targetid][pHungerTimer] = 0;
    PlayerInfo[targetid][pThirst] = 100;
    PlayerInfo[targetid][pGased] = false;
    PlayerInfo[targetid][pGased1] = false;
	PlayerInfo[targetid][pThirstTimer] = 0;
    KillTimer(killtimerz[targetid]);

    TogglePlayerControllable(targetid, 1);
	SetPlayerHealth(targetid, 100.0);
	ClearAnimations(targetid, SYNC_ALL);
	
	if(PlayerInfo[targetid][pAcceptedEMS] != INVALID_PLAYER_ID)
	{
	    SM(PlayerInfo[targetid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(targetid));
	    PlayerInfo[targetid][pAcceptedEMS] = INVALID_PLAYER_ID;
	}

	SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by an admin!");
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has revived %s. REASON: %s", GetRPName(playerid), GetRPName(targetid), reason);
	return 1;
}

CMD:freezenear(playerid, params[])
{
	new Float:radius;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    
	    if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /freezerange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, radius))
		{
		    if(!PlayerInfo[i][pAdminDuty])
		    {
			    TogglePlayerControllable(i, false);
			}

		    SendClientMessage(i, COLOR_WHITE, "An admin has frozen everyone nearby.");
		}
	}

	return 1;
}

CMD:unfreezenear(playerid, params[])
{
	new Float:radius;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unfreezerange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, radius))
		{
		    if(!PlayerInfo[i][pAdminDuty])
		    {
			    TogglePlayerControllable(i, true);
			}

		    SendClientMessage(i, COLOR_WHITE, "An admin has unfrozen everyone nearby.");
		}
	}

	return 1;
}

CMD:revivenear(playerid, params[])
{
	new Float:radius;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /reviverange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, radius) && PlayerInfo[i][pInjured])
		{
			PlayerInfo[i][pInjured] = 0;
			PlayerInfo[i][pHunger] = 100;
			PlayerInfo[i][pHungerTimer] = 0;
		    PlayerInfo[i][pThirst] = 100;
			PlayerInfo[i][pThirstTimer] = 0;
			if(PlayerInfo[i][pAcceptedEMS] != INVALID_PLAYER_ID)
			{
			    SM(PlayerInfo[i][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(i));
			    PlayerInfo[i][pAcceptedEMS] = INVALID_PLAYER_ID;
			}

            TogglePlayerControllable(i, 1);
			SetPlayerHealth(i, 100.0);
			ClearAnimations(i, SYNC_ALL);
            for(new l = 0; l < 15; l++)
            {
              TextDrawHideForPlayer(i, DEATHBUTTON[l]);
            }
			PlayerTextDrawHide(i, DEATHBUTTONP[i][0]);
            CancelSelectTextDraw(i);
		    SendClientMessage(i, COLOR_WHITE, "An admin has revived everyone nearby.");
		}
	}

	return 1;
}

CMD:heject(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /heject [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pHospital])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not in hospital.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s ejected %s from the hospital.", GetRPName(playerid), GetRPName(targetid));

	PlayerInfo[targetid][pHospitalTime] = 1;
	SendClientMessage(targetid, COLOR_YELLOW, "You have been ejected from hospital by an admin!");
	return 1;
}

CMD:myangle(playerid, params[])
{
    new myString[128], Float:a;
    GetPlayerFacingAngle(playerid, a);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    format(myString, sizeof(myString), "Your angle is: %0.2f", a);
    SendClientMessage(playerid, 0xFFFFFFFF, myString);
    format(myString, sizeof(myString), "Your position is: %f, %f, %f", x, y, z);
    SendClientMessage(playerid, 0xFFFFFFFF, myString);

	new DCC_Channel:myangle = DCC_FindChannelById("1215569500728987670"); // Discord channel ID
	new str[300];
	format(str, sizeof(str), "%f, %f, %f %0.2f", x, y, z, a);
	new DCC_Embed:embed = DCC_CreateEmbed("", str);
	format(str, sizeof(str), "Your angle is: %0.2f", a);
	DCC_SendChannelMessage(myangle, str);
	DCC_SetEmbedColor(embed, 0x000000);
	DCC_SetEmbedFooter(embed, "");
	DCC_SendChannelEmbedMessage(myangle, embed);

    return 1;
}

CMD:goto(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /goto [playerid/location]");
 		SendClientMessage(playerid, COLOR_WHITE, "Locations: LS, SF, LV, Grove, Idlewood, Unity, Jefferson, Market, Airport, Bank");
 		SendClientMessage(playerid, COLOR_WHITE, "Locations: Grotti, DMV, Casino, Allsaints, Mall, VIP, PB");
 		SendClientMessage(playerid, COLOR_WHITE, "Locations: army, north, farm");
		return 1;
	}

	if(!strcmp(params, "ls", true))
    {
		TeleportToCoords(playerid, 1544.4407, -1675.5522, 13.5584, 90.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Los Santos.");
        SAM(COLOR_RED, "%s has teleported to Los Santos.", GetRPName(playerid));
    }
    else if(!strcmp(params, "pb", true))
    {
        TeleportToCoords(playerid, 1395.1077,-1385.9746,13.5547,174.8546, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Paintball.");
        SAM(COLOR_RED, "%s has teleported to Paintball.", GetRPName(playerid));
	}
    else if(!strcmp(params, "sf", true))
    {
		TeleportToCoords(playerid, -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to San Fierro.");
        SAM(COLOR_RED, "%s has teleported to San Fierro.", GetRPName(playerid));
    }
    else if(!strcmp(params, "lv", true))
    {
		TeleportToCoords(playerid, 1670.6908, 1423.5240, 10.7811, 270.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Las Venturas.");
        SAM(COLOR_RED, "%s has teleported to Las Venturas.", GetRPName(playerid));
    }
    else if(!strcmp(params, "grove", true))
    {
		TeleportToCoords(playerid, 2497.8274, -1668.9033, 13.3438, 90.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Grove Street.");
        SAM(COLOR_RED, "%s has teleported to Grove Street.", GetRPName(playerid));
    }
    else if(!strcmp(params, "idlewood", true))
    {
		TeleportToCoords(playerid, 2090.0664, -1816.9071, 13.3904, 90.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Idlewood.");
        SAM(COLOR_RED, "%s has teleported to Idlewood.", GetRPName(playerid));
    }
    else if(!strcmp(params, "md", true))
    {
		TeleportToCoords(playerid, 334.949951, -1794.299926, 6.918820, 0.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Muthuk");
        SAM(COLOR_RED, "%s has teleported to Muthuk.", GetRPName(playerid));
    }
    else if(!strcmp(params, "jefferson", true))
    {
		TeleportToCoords(playerid, 2222.3438, -1164.5013, 25.7331, 0.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Jefferson Motel.");
        SAM(COLOR_RED, "%s has teleported to Jefferson Motel.", GetRPName(playerid));
    }
    else if(!strcmp(params, "market", true))
    {
		TeleportToCoords(playerid, 818.1782, -1349.2217, 13.5260, 0.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Market.");
        SAM(COLOR_RED, "%s has teleported to Market.", GetRPName(playerid));
    }
    else if(!strcmp(params, "airport", true))
    {
		TeleportToCoords(playerid, 1938.7185, -2370.6375, 13.5469, 0.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to LS airport.");
        SAM(COLOR_RED, "%s has teleported to LS Airport.", GetRPName(playerid));
    }
    else if(!strcmp(params, "bank", true))
    {
        TeleportToCoords(playerid, 1463.8929, -1026.6189, 23.8281, 180.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Mulholland bank.");
        SAM(COLOR_RED, "%s has teleported to Mulholland Bank.", GetRPName(playerid));
    }
    else if(!strcmp(params, "grotti", true))
    {
		TeleportToCoords(playerid, 556.7949, -1253.8925, 17.0882, 332.4382, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Grotti dealership.");
        SAM(COLOR_RED, "%s has teleported to Grotti Dealership.", GetRPName(playerid));
    }
	else if(!strcmp(params, "dmv", true))
    {
        TeleportToCoords(playerid, 2489.2214,-1943.3082,13.5144, 180.0000, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to DMV.");
        SAM(COLOR_RED, "%s has teleported to DMV.", GetRPName(playerid));
	}
	else if(!strcmp(params, "casino", true))
    {
        TeleportToCoords(playerid, 1979.2966,-2389.7334,13.5469,337.3903, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Casino.");
        SAM(COLOR_RED, "%s has teleported to Casino.", GetRPName(playerid));
	}
	else if(!strcmp(params, "allsaints", true))
    {
        TeleportToCoords(playerid, 1214.6766,-1351.9923,13.5738,87.7388, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Allsaints.");
        SAM(COLOR_RED, "%s has teleported to All Saints.", GetRPName(playerid));
	}
	else if(!strcmp(params, "mall", true))
    {
        TeleportToCoords(playerid, 1129.0829,-1413.3024,13.6092,359.0887, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Mall.");
        SAM(COLOR_RED, "%s has teleported to Mall.", GetRPName(playerid));
	}
	else if(!strcmp(params, "army", true))
    {
        TeleportToCoords(playerid, -1523.6044,503.5841,7.1797,117.9949, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Army Base.");
        SAM(COLOR_RED, "%s has teleported to Army Base.", GetRPName(playerid));
	}
	else if(!strcmp(params, "north", true))
    {
        TeleportToCoords(playerid, -203.7191,1150.7198,19.7422,318.9240, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Northside (Fort Cartson).");
        SAM(COLOR_RED, "%s has teleported to Northside (Fort Cartson).", GetRPName(playerid));
	}
	else if(!strcmp(params, "farm", true))
    {
        TeleportToCoords(playerid, -369.3234,-1409.6986,25.7266,308.1521, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to Farm.");
        SAM(COLOR_RED, "%s has teleported to Farm.", GetRPName(playerid));
	}
	else if(!strcmp(params, "vip", true))
    {
        TeleportToCoords(playerid, 1806.383666,-1576.964477,13.457272,308.1521, 0, 0);
        SendClientMessage(playerid, COLOR_GREY2, "Teleported to VIP LOUNGE.");
        SAM(COLOR_RED, "%s has teleported to VIP Lounge.", GetRPName(playerid));
	}
	else
	{
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(!IsPlayerSpawned(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
		}
		if(PowerSpec[targetid] == 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot Teleport to alenjandro,NAJU, and barako as they're currently RP'ing");
		}

		TeleportToPlayer(playerid, targetid);
		SM(playerid, COLOR_GREY2, "Teleported to %s's position.", GetRPName(targetid));
		SAM(COLOR_RED, "%s has teleported to %s's position.", GetRPName(playerid), GetRPName(targetid));
	}
	return 1;
}

CMD:gethere(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gethere [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
	}
	if(PlayerInfo[targetid][pPaintball] > 0 && PlayerInfo[playerid][pPaintball] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the paintball arena.");
	}
	if(PowerSpec[targetid] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot [/gethere] NAJU,Barako and Alenjandro as they're currently RP'ing.");
	}

	TeleportToPlayer(targetid, playerid);
	SM(playerid, COLOR_GREY2, "Teleported %s to your position.", GetRPName(targetid));
    SAM(COLOR_RED, "%s has been teleported to %s's position by using [/gethere]", GetRPName(targetid), GetRPName(playerid));

	return 1;
}

CMD:gotocar(playerid, params[])
{
	new vehicleid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotocar [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle specified.");
	}

	TeleportToVehicle(playerid, vehicleid);
	SM(playerid, COLOR_GREY2, "Teleported to vehicle ID %i.", vehicleid);
	return 1;
}

CMD:getcar(playerid, params[])
{
	new vehicleid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getcar [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle specified.");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 1, y + 1, z + 2.0);

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	SM(playerid, COLOR_GREY2, "Teleported vehicle ID %i to your position.", vehicleid);
	return 1;
}

CMD:gotoco(playerid, params[]) { return callcmd::gotocoords(playerid, params); }
CMD:gotocoords(playerid, params[])
{
	new Float:x, Float:y, Float:z, interiorid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "fffI(0)", x, y, z, interiorid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotocoords [x] [y] [z] [int (optional)]");
	}

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interiorid);
	return 1;
}

CMD:gotoint(playerid, params[])
{
	static list[4096];

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}

	if(isnull(list))
	{
	    for(new i = 0; i < sizeof(interiorArray); i ++)
	    {
	        format(list, sizeof(list), "%s\n%s", list, interiorArray[i][intName]);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_INTERIORS, DIALOG_STYLE_LIST, "Choose an interior to teleport to.", list, "Select", "Cancel");
	return 1;
}

CMD:jetpack(playerid, params[])
{
	new targetid;
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /jetpack [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
    PlayerInfo[targetid][pJetpack] = 1;
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_USEJETPACK);
	GameTextForPlayer(targetid, "~g~Jetpack", 3000, 3);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given a jetpack to %s.", GetRPName(playerid), GetRPName(targetid));
	switch(random(4))
	{
	    case 0: SendClientMessage(targetid, COLOR_WHITE, "The jetpack is part of an experiment conducted at the Area 69 facility.");
	    case 1: SendClientMessage(targetid, COLOR_WHITE, "You stole this from Area 69 in that one single player mission. Remember?");
	    case 2: SendClientMessage(targetid, COLOR_WHITE, "You probably don't need this anyway. All you hackers seem to do is airbreak around the map.");
	}

	return 1;
}


CMD:sendto(playerid, params[])
{
	new targetid, option[12], param[32];

    if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[12]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sendto [playerid] [location]");
	    SendClientMessage(playerid, COLOR_WHITE, "Locations: Player, Vehicle, LS, SF, LV, Grove, Idlewood, Unity, Jefferson, Market, Bank");
	    SendClientMessage(playerid, COLOR_WHITE, "Locations: Grotti, DMV, Casino, Allsaints, Mall, VIP, PB");
	    SendClientMessage(playerid, COLOR_WHITE, "Locations: Farm, Army, North");
		return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
	}
	if(PlayerInfo[targetid][pPaintball] > 0 && PlayerInfo[playerid][pPaintball] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the paintball arena.");
	}
	if(PlayerInfo[targetid][pJailType])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is in jail so you can't teleport them.");
	}
	if(PlayerInfo[playerid][pAdmin] < 2 && isnull(PlayerInfo[targetid][pHelpRequest]) && PlayerInfo[playerid][pAcceptedHelp] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't submitted a help request. Therefore you can't teleport them.");
	}

    if(!strcmp(option, "ls", true))
    {
		TeleportToCoords(targetid, 1544.4407, -1675.5522, 13.5584, 90.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Los Santos.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Los Santos.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Los Santos.", GetRPName(playerid));
    }
    else if(!strcmp(option, "sf", true))
    {
		TeleportToCoords(targetid, -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to San Fierro.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to San Fierro.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to San Fierro.", GetRPName(playerid));
    }
    else if(!strcmp(option, "pb", true))
    {
        TeleportToCoords(targetid, 1395.1077,-1385.9746,13.5547,174.8546, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Paintball", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Paintball.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Paintball.", GetRPName(playerid));
    }
    else if(!strcmp(option, "lv", true))
    {
		TeleportToCoords(targetid, 1670.6908, 1423.5240, 10.7811, 270.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Las Venturas.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Las Venturas.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Las Venturas.", GetRPName(playerid));
    }
    else if(!strcmp(option, "grove", true))
    {
		TeleportToCoords(targetid, 2497.8274, -1668.9033, 13.3438, 90.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Grove Street.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Grove Street.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Grove Street.", GetRPName(playerid));
    }
    else if(!strcmp(option, "idlewood", true))
    {
		TeleportToCoords(targetid, 2090.0664, -1816.9071, 13.3904, 90.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Idlewood.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Idlewood.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Idlewood.", GetRPName(playerid));
    }
    else if(!strcmp(option, "unity", true))
    {
		TeleportToCoords(targetid, 1782.2683, -1865.5726, 13.5725, 0.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Unity Station.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Unity Station.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Unity Station.", GetRPName(playerid));
    }
    else if(!strcmp(option, "jefferson", true))
    {
		TeleportToCoords(targetid, 2222.3438, -1164.5013, 25.7331, 0.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Jefferson.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Jefferson Motel.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Jefferson Motel.", GetRPName(playerid));
    }
    else if(!strcmp(option, "market", true))
    {
		TeleportToCoords(targetid, 818.1782, -1349.2217, 13.5260, 0.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Market.", GetRPName(playerid), GetRPName(targetid));
		SM(playerid, COLOR_GREY2, "You have sent %s to Market.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Market.", GetRPName(playerid));
    }
    else if(!strcmp(option, "bank", true))
    {
        TeleportToCoords(targetid, 1463.8929, -1026.6189, 23.8281, 180.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Bank.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to the Bank.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to the Bank.", GetRPName(playerid));
    }
    else if(!strcmp(option, "grotti", true))
    {
		TeleportToCoords(targetid, 556.7949,-1253.8925,17.0882,332.4382, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Dealership.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Grotti car dealership.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Grotti car dealership.", GetRPName(playerid));
    }
    else if(!strcmp(option, "dmv", true))
    {
        TeleportToCoords(targetid, 2489.2214,-1943.3082,13.5144, 180.0000, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to DMV.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to the DMV.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to the DMV.", GetRPName(playerid));
    }
    else if(!strcmp(option, "casino", true))
    {
        TeleportToCoords(targetid, 1979.2966,-2389.7334,13.5469,337.3903, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Casino.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Casino.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Casino.", GetRPName(playerid));
    }
	else if(!strcmp(option, "allsaints", true))
    {
        TeleportToCoords(targetid, 1214.6766, -1351.9923, 13.5738, 87.7388, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to All Saints.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Allsaints.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Allsaints.", GetRPName(playerid));
    }
    else if(!strcmp(option, "farm", true))
    {
        TeleportToCoords(targetid, -369.3234,-1409.6986,25.7266,308.1521, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Farm.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Farm.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Farm.", GetRPName(playerid));
    }
    else if(!strcmp(option, "army", true))
    {
        TeleportToCoords(targetid, -1523.6044,503.5841,7.1797,117.9949, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Army Base.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Army Base.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Army Base.", GetRPName(playerid));
    }
    else if(!strcmp(option, "north", true))
    {
        TeleportToCoords(targetid, -203.7191,1150.7198,19.7422,318.9240, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Northside (Fort Cartson).", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Northside (Fort Cartson).", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Northside (Fort Cartson).", GetRPName(playerid));
    }
	else if(!strcmp(option, "mall", true))
    {
        TeleportToCoords(targetid, 1129.0829,-1413.3024,13.6092,359.0887, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to Mall.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to Mall.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to Mall.", GetRPName(playerid));
    }
    else if(!strcmp(option, "vip", true))
    {
        TeleportToCoords(targetid, 1265.3110,-1676.5968,13.5469,357.3727, 0, 0);
        SAM(COLOR_RED, "%s has sent %s to VIP Lounge.", GetRPName(playerid), GetRPName(targetid));
        SM(playerid, COLOR_GREY2, "You have sent %s to VIP LOUNGE.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to VIP LOUNGE.", GetRPName(playerid));
    }
    else if(!strcmp(option, "player", true))
    {
        new sendtargetid;

        if(PlayerInfo[playerid][pAdmin] < 1)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Only level 2+ admins can do this.");
		}
        if(sscanf(param, "u", sendtargetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sendto [playerid] [player] [targetid]");
		}
		if(!IsPlayerConnected(sendtargetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The target specified is disconnected.");
		}
		if(!IsPlayerSpawned(sendtargetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The target specified is either not spawned, or spectating.");
		}

		TeleportToPlayer(targetid, sendtargetid);
        SAM(COLOR_RED, "%s has sent %s to player ID (%i).", GetRPName(playerid), GetRPName(targetid), sendtargetid);
		SM(playerid, COLOR_GREY2, "You have sent %s to %s's location.", GetRPName(targetid), GetRPName(sendtargetid));
		SM(targetid, COLOR_GREY2, "%s has sent you to %s's location.", GetRPName(playerid), GetRPName(sendtargetid));
	}
	else if(!strcmp(option, "vehicle", true))
    {
        new vehicleid;

        if(PlayerInfo[playerid][pAdmin] < 1)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Only level 2+ admins can do this.");
		}
        if(sscanf(param, "i", vehicleid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sendto [playerid] [vehicle] [vehicleid]");
		}
		if(!IsValidVehicle(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle specified.");
		}

		TeleportToVehicle(targetid, vehicleid);
        SAM(COLOR_RED, "%s has sent %s to vehicle ID (%i).", GetRPName(playerid), GetRPName(targetid), vehicleid);
		SM(playerid, COLOR_GREY2, "You have sent %s to vehicle ID %i.", GetRPName(targetid), vehicleid);
		SM(targetid, COLOR_GREY2, "%s has sent you to vehicle ID %i.", GetRPName(playerid), vehicleid);
	}

	return 1;
}

CMD:bigears(playerid, params[])
{
	return callcmd::listen(playerid, params);
}

CMD:listen(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}

	if(!PlayerInfo[playerid][pListen])
	{
		PlayerInfo[playerid][pListen] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "You are now listening to all IC & local OOC chats.");
	}
	else
	{
		PlayerInfo[playerid][pListen] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "You are no longer listening to IC & local OOC chats.");
	}

	return 1;
}

CMD:listenpm(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}

	if(!PlayerInfo[playerid][pPMListen])
	{
		PlayerInfo[playerid][pPMListen] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "You are now listening to all PM's % Whisper's chats.");
	}
	else
	{
		PlayerInfo[playerid][pPMListen] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "You are no longer listening to PM's % Whisper's chats.");
	}

	return 1;
}

CMD:prisonic(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /prisonic [playerid] [minutes] [reason]");
 		SendClientMessage(playerid, COLOR_YELLOW, "This command OOC'ly puts the player inside an IC prison.");
 		return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be jailed.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet. You can wait until they login or use /ojail.");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of minutes cannot be below one. Use /release instead.");
	}

    PlayerInfo[targetid][pJailType] = 1;
    PlayerInfo[targetid][pJailTime] = minutes * 60;

    ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);
	SetPlayerInJail(targetid);

    SMA(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SM(targetid, COLOR_AQUA, "** You have been admin jailed for %i minutes by %s.", minutes, GetRPName(playerid));
    return 1;
}

CMD:rwarn(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rwarn [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pReportMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is muted from reports.");
	}

	PlayerInfo[targetid][pReportWarns]++;

	SM(targetid, COLOR_LIGHTRED, "** %s issued you a report warning, reason: %s (%i/3)", GetRPName(playerid), reason, PlayerInfo[targetid][pReportWarns]);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was given a report warning by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);

	if(PlayerInfo[targetid][pReportWarns] >= 3)
	{
	    PlayerInfo[targetid][pReportMuted] = 12;
	    SendClientMessage(targetid, COLOR_LIGHTRED, "** You have been muted from reports for 12 playing hours.");
	}

	return 1;
}

CMD:runmute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /runmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pReportMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not muted from reports.");
	}

	PlayerInfo[targetid][pReportWarns] = 0;
	PlayerInfo[targetid][pReportMuted] = 0;

	SAM(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from reports by %s.", GetRPName(targetid), GetRPName(playerid));
	SM(targetid, COLOR_YELLOW, "** Your report mute has been lifted by %s. Your report warnings were reset.", GetRPName(playerid));
	return 1;
}

CMD:nmute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(!PlayerInfo[targetid][pNewbieMuted])
	{
	    PlayerInfo[targetid][pNewbieMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_LIGHTRED, "** You have been muted from newbie chat by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[targetid][pNewbieMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_YELLOW, "** You have been unmuted from newbie chat by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:hmute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /hmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(!PlayerInfo[targetid][pHelpMuted])
	{
	    PlayerInfo[targetid][pHelpMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_LIGHTRED, "** You have been muted from help requests by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[targetid][pHelpMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_YELLOW, "** You have been unmuted from help requests by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:admute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /admute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(!PlayerInfo[targetid][pAdMuted])
	{
	    PlayerInfo[targetid][pAdMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_LIGHTRED, "** You have been muted from advertisements by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[targetid][pAdMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_YELLOW, "** You have been unmuted from advertisements by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:gmute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(!PlayerInfo[targetid][pGlobalMuted])
	{
	    PlayerInfo[targetid][pGlobalMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_LIGHTRED, "** You have been muted from global chat by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[targetid][pGlobalMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_YELLOW, "** You have been unmuted from global chat by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:rmute(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(!PlayerInfo[targetid][pReportMuted])
	{
	    PlayerInfo[targetid][pReportMuted] = 99999;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_LIGHTRED, "** You have been muted from submitting reports by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[targetid][pReportMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
	    SM(targetid, COLOR_YELLOW, "** You have been unmuted from submitting reports by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:freeze(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /freeze [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	TogglePlayerControllable(targetid, 0);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was frozen by %s.", GetPlayerNameEx(targetid), GetPlayerNameEx(playerid));
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unfreeze [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(PlayerInfo[targetid][pTazedTime])
	{
		ClearAnimations(targetid, SYNC_ALL);
		PlayerInfo[targetid][pTazedTime] = 0;
	}

    PlayerInfo[targetid][pTied] = 0;
	TogglePlayerControllable(targetid, 1);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was unfrozen by %s.", GetPlayerNameEx(targetid), GetPlayerNameEx(playerid));
	return 1;
}

CMD:listguns(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /listguns [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, SERVER_COLOR, "%s's Weapons:", GetRPName(targetid));

	for(new i = 0; i < 13; i ++)
	{
	    new
	        weapon,
	        ammo;

	    GetPlayerWeaponData(targetid, i, weapon, ammo);

	    if(weapon)
	    {
	        if(PlayerInfo[targetid][pAmmoType] != AMMOTYPE_NORMAL && PlayerInfo[targetid][pAmmoWeapon] == weapon) {
	            if(PlayerInfo[targetid][pAmmoType] == AMMOTYPE_HP) {
	                SM(playerid, COLOR_GREY2, "-> %s (%i ammo) (Hollow point ammo)", GetWeaponNameEx(weapon), PlayerInfo[targetid][pHPAmmo]);
	            } else if(PlayerInfo[targetid][pAmmoType] == AMMOTYPE_POISON) {
	                SM(playerid, COLOR_GREY2, "-> %s (%i ammo) (Poison tip ammo)", GetWeaponNameEx(weapon), PlayerInfo[targetid][pPoisonAmmo]);
	            } else if(PlayerInfo[targetid][pAmmoType] == AMMOTYPE_FMJ) {
	                SM(playerid, COLOR_GREY2, "-> %s (%i ammo) (FMJ ammo)", GetWeaponNameEx(weapon), PlayerInfo[targetid][pFMJAmmo]);
	            }
	        }
			else if(!PlayerHasWeapon(targetid, weapon)) {
		        SM(playerid, COLOR_GREY2, "-> %s {FFD700}(Desynced){C8C8C8}", GetWeaponNameEx(weapon));
	    	} else {
            	SM(playerid, COLOR_GREY2, "-> %s", GetWeaponNameEx(weapon));
			}
		}
	}

	return 1;
}

CMD:disarm(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /disarm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	ResetPlayerWeaponsEx(targetid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has disarmed %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:nrn(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nrn [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	ShowPlayerDialog(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to change their name for being Non-RP.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:jail(playerid, params[])
{
	return callcmd::prison(playerid, params);
}

CMD:prison(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /prison [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be prisoned.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of minutes cannot be below one. Use /release instead.");
	}

    PlayerInfo[targetid][pJailType] = 2;
    PlayerInfo[targetid][pJailTime] = minutes * 60;

	SetPlayerInJail(targetid);
	GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonedby = '%e', prisonreason = '%e' WHERE uid = %i", GetPlayerNameEx(playerid), reason, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	GetPlayerName(playerid, PlayerInfo[targetid][pPrisonedBy], MAX_PLAYER_NAME);
	strcpy(PlayerInfo[targetid][pPrisonReason], reason, 128);
	
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "%s prisoned %s for %i minutes, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), minutes, reason);
	SendDiscordMessage(6, dc_str);

    SMA(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SM(targetid, COLOR_AQUA, "** You have been admin prisoned for %i minutes by %s.", minutes, GetRPName(playerid));
    return 1;
}

CMD:oprison(playerid, params[])
{
	new username[MAX_PLAYER_NAME + 1], minutes, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]is[128]", username, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /oprison [username] [minutes] [reason]");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of minutes cannot be below one. Use /release instead.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use /prison instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, uid FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflinePrison", "isis", playerid, username, minutes, reason);
	return 1;
}

CMD:release(playerid, params[])
{
    new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /release [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pJailType])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not jailed.");
	}

	PlayerInfo[targetid][pJailTime] = 1;
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was released from jail/prison by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	return 1;
}
CMD:pfine(playerid, params[])
{
	new targetid, amount, reason[128];

	if(!IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fine [playerid] [amount] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pFactionRank] > PlayerInfo[playerid][pFactionRank])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be fined.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid amount.");
	}

	GivePlayerCash(targetid, -amount);

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was Police fined $%i by %s, reason: %s", GetRPName(targetid), amount, GetRPName(playerid), reason);
	return 1;
}
CMD:fine(playerid, params[])
{
	new targetid, amount, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fine [playerid] [amount] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be fined.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid amount.");
	}

	GivePlayerCash(targetid, -amount);

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was fined $%i by %s, reason: %s", GetRPName(targetid), amount, GetRPName(playerid), reason);
	return 1;
}

CMD:pefine(playerid, params[])
{
	new targetid, percent, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, percent, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pfine [playerid] [percent] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!(1 <= percent <= 100))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The percentage value must be between 1 and 100.");
	}

	new amount = ((PlayerInfo[targetid][pCash] + PlayerInfo[targetid][pBank]) / 100) * percent;

	GivePlayerCash(targetid, -amount);

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was fined $%i by %s, reason: %s", GetRPName(targetid), amount, GetRPName(playerid), reason);
	return 1;
}

CMD:ofine(playerid, params[])
{
	new username[MAX_PLAYER_NAME + 1], amount, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]is[128]", username, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ofine [username] [amount] [reason]");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid amount.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use /fine instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineFine", "isis", playerid, username, amount, reason);
	return 1;
}

CMD:sethp(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uf", targetid, amount))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sethp [playerid] [amount]");
	    SendClientMessage(playerid, COLOR_WHITE, "Warning: Values above 255.0 may not work properly with the server-sided damage system.");
	    return 1;
	}
	if(amount == 0.0)
	{
		DamagePlayer(targetid, 300, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SetPlayerHealth(targetid, amount);
	SM(playerid, COLOR_GREY2, "%s's health set to %.1f.", GetRPName(targetid), amount);
	SMA(COLOR_RED, "%s's health set to %.1f by %s", GetRPName(targetid), amount, GetRPName(playerid));
	return 1;
}
CMD:sethelmet(playerid, params[])
{
    new targetid, amount;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sethelmet [playerid] [amount]");
	    return 1;
	}
	if(amount == 0)
	{
		HidePlayerProgressBar(targetid, helmetbar);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	PlayerInfo[targetid][pHelmet] = amount;
	SM(playerid, COLOR_GREY2, "%s's helmet set to %i", GetRPName(targetid), amount);
	SMA(COLOR_RED, "%s's helmet set to %i by %s", GetRPName(targetid), amount, GetRPName(playerid));
	return 1;
}
CMD:ameliasethp(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uf", targetid, amount))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sethp [playerid] [amount]");
	    SendClientMessage(playerid, COLOR_WHITE, "Warning: Values above 255.0 may not work properly with the server-sided damage system.");
	    return 1;
	}
	if(amount == 0.0)
	{
		DamagePlayer(targetid, 300, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SetPlayerHealth(targetid, amount);
	SM(playerid, COLOR_GREY2, "%s's health set to %.1f.", GetRPName(targetid), amount);
	return 1;
}

CMD:setarmor(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uf", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setarmor [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SetScriptArmour(targetid, amount);
	SM(playerid, COLOR_GREY2, "%s's armor set to %.1f.", GetRPName(targetid), amount);
	SMA(COLOR_RED, "%s's armor set to %.1f by %s", GetRPName(targetid), amount, GetRPName(playerid));
	return 1;
}

CMD:ameliasetarmor(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uf", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setarmor [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SetScriptArmour(targetid, amount);
	SM(playerid, COLOR_GREY2, "%s's armor set to %.1f.", GetRPName(targetid), amount);
	return 1;
}

CMD:refillcars(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(IsValidVehicle(i))
	    {
	        vehicleFuel[i] = 100;
		}
	}

	SMA(COLOR_LIGHTRED, "AdmCmd: %s refilled all vehicles to maximum fuel.", GetRPName(playerid));
	return 1;
}
CMD:refillatm(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	for(new i = 1; i < MAX_ATMS; i ++)
	{
	    if(AtmInfo[i][aExists])
	    {
	       AtmInfo[i][amoney] = 10000000;
	    }
	    
	}

	SMA(COLOR_LIGHTRED, "AdmCmd: %s refilled all Atm to maximum Money.", GetRPName(playerid));
	return 1;
}
CMD:top(playerid)
{
	ShowDialogToPlayer(playerid, DIALOG_TOP);
	return 1;
}

CMD:togooc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledOOC)
	{
	    enabledOOC = 1;
	    SMA(SERVER_COLOR, "(( Administrator %s enabled the Out of Character channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledOOC = 0;
	    SMA(SERVER_COLOR, "(( Administrator %s disabled the Out of Character channel. ))", GetRPName(playerid));
	}
	return 1;
}

CMD:togn(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledNewbie)
	{
	    enabledNewbie = 1;
	    SMA(SERVER_COLOR, "(( Administrator %s enabled the newbie channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledNewbie = 0;
	    SMA(SERVER_COLOR, "(( Administrator %s disabled the newbie channel. ))", GetRPName(playerid));
	}
	return 1;
}
CMD:togvip(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledVip)
	{
	    enabledVip = 1;
	    SMA(SERVER_COLOR, "(( Administrator %s enabled the vip channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledVip = 0;
	    SMA(SERVER_COLOR, "(( Administrator %s disabled the vip channel. ))", GetRPName(playerid));
	}
	return 1;
}

CMD:togwar(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledGlobal1)
	{
	    enabledGlobal1 = 1;
	    SMA(SERVER_COLOR, "(( Administrator %s enabled the war channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledGlobal1 = 0;
	    SMA(SERVER_COLOR, "(( Administrator %s disabled the war channel. ))", GetRPName(playerid));
	}
	return 1;
}

CMD:togglobal(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledGlobal)
	{
	    enabledGlobal = 1;
	    SMA(SERVER_COLOR, "(( Administrator %s enabled the global channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledGlobal = 0;
	    SMA(SERVER_COLOR, "(( Administrator %s disabled the global channel. ))", GetRPName(playerid));
	}
	return 1;
}
CMD:togadmin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledAdmin)
	{
	    enabledAdmin = 1;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has enabled the admin channel.", GetRPName(playerid));
	}
	else
	{
	    enabledAdmin = 0;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has disabled the admin channel.", GetRPName(playerid));
	}
	return 1;
}

CMD:togreports(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!enabledReports)
	{
	    enabledReports = 1;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has enabled the report channel.", GetRPName(playerid));
	}
	else
	{
	    enabledReports = 0;
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has disabled the report channel.", GetRPName(playerid));
	}
	return 1;
}

CMD:listpvehs(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /listpvehs [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, SERVER_COLOR, "%s's Vehicles:", GetRPName(targetid));

    for(new i = 1; i < MAX_VEHICLES; i ++)
    {
        if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && IsVehicleOwner(targetid, i))
        {
            SM(playerid, COLOR_GREY2, "ID: %i | Model: %s | Location: %s", i, GetVehicleName(i), GetVehicleZoneName(i));
		}
	}

	return 1;
}

CMD:despawnpveh(playerid, params[])
{
	new vehicleid;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /despawnpveh [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle specified is invalid or not owned by any player.");
	}

	SM(playerid, COLOR_WHITE, "** You have despawned %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
	DespawnVehicle(vehicleid);
	return 1;
}

CMD:vcheck(playerid)
{
    new vehicleid;

    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC) && GetFactionType(playerid) != FACTION_POLICE)
    {
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]:{ffffff} You are not a part of law enforcement.");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]:{ffffff} You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]:{ffffff} This vehicle isn't owned by any particular person.");
	}
	SCMf(playerid, COLOR_GREY2, "(Cartype: %s) - (Tickets: $%i) - (Plate: %s)", GetVehicleName(vehicleid), VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vPlate]);
	return 1;
}
CMD:veh(playerid, params[])
{
	new model[20], modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, vehicleid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "s[20]I(-1)I(-1)", model, color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /veh [modelid/name] [color1 (optional)] [color2 (optional)]");
	}
	if((modelid = GetVehicleModelByName(model)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle model.");
	}
	if(!(-1 <= color1 <= 255) || !(-1 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid color. Valid colors range from -1 to 255.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

	if(vehicleid == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	}
	ResetVehicleObjects(vehicleid);
	adminVehicle{vehicleid} = true;
	vehicleFuel[vehicleid] = 100;
	vehicleColors[vehicleid][0] = color1;
	vehicleColors[vehicleid][1] = color2;

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s spawned a %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	SM(playerid, COLOR_WHITE, "** %s (ID %i) spawned. Use '/savevehicle %i' to save this vehicle to the database.", GetVehicleName(vehicleid), vehicleid, vehicleid);
	return 1;
}

CMD:yveh(playerid, params[])
{
	new model[20], modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, vehicleid;

	if(strcmp(PlayerInfo[playerid][pCustomTitle], "Youtuber", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	if(sscanf(params, "s[20]I(-1)I(-1)", model, color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /yveh [modelid/name] [color1 (optional)] [color2 (optional)]");
	}
	if((modelid = GetVehicleModelByName(model)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle model.");
	}
	if(!(-1 <= color1 <= 255) || !(-1 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid color. Valid colors range from -1 to 255.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

	if(vehicleid == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	}
	ResetVehicleObjects(vehicleid);
	adminVehicle{vehicleid} = true;
	vehicleFuel[vehicleid] = 100;
	vehicleColors[vehicleid][0] = color1;
	vehicleColors[vehicleid][1] = color2;

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SAM(COLOR_LIGHTRED, "YoutuberCMD: %s spawned a %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	return 1;
}

CMD:savevehicle(playerid, params[])
{
	new vehicleid, gangid, type,viptype, delay2, Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "iiiii", vehicleid, gangid, type, delay2, viptype))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /savevehicle [vehicleid] [gangid (-1 = none)] [faction type] [respawn delay (seconds)] [vip type 0 of none]");
	    SendClientMessage(playerid, COLOR_GREY2, "Faction types: (0) None (1) Police (2) Medic (3) News (4) Government (5) Hitman (6) Federal (7) Mechanic (8) Terrorist (9) Army (10) JailGuard");
	    SendClientMessage(playerid, COLOR_GREY2, "Faction types: (11) NPolice (12) EMS");
	    return 1;
	}
	if(!IsValidVehicle(vehicleid) || !adminVehicle{vehicleid})
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle specified is either invalid or not an admin spawned vehicle.");
	}
	if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	if(!(0 <= type <= 12))
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}

    SM(playerid, COLOR_WHITE, "** %s saved. This vehicle will now spawn here from now on.", GetVehicleName(vehicleid));

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);

	if(viptype > 0)
	{
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (modelid, pos_x, pos_y, pos_z, pos_a, color1, color2, gangid, factiontype, respawndelay, vip) VALUES(%i, '%f', '%f', '%f', '%f', %i, %i, %i, %i, %i , %i)", GetVehicleModel(vehicleid), x, y, z, a, vehicleColors[vehicleid][0], vehicleColors[vehicleid][1], gangid, type, delay2, viptype);
	    mysql_tquery(connectionID, queryBuffer);
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET vip = %i WHERE id = %i", viptype, gangid);
	    mysql_tquery(connectionID, queryBuffer);
	    mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);
	}
    else
	{
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (modelid, pos_x, pos_y, pos_z, pos_a, color1, color2, gangid, factiontype, respawndelay) VALUES(%i, '%f', '%f', '%f', '%f', %i, %i, %i, %i, %i)", GetVehicleModel(vehicleid), x, y, z, a, vehicleColors[vehicleid][0], vehicleColors[vehicleid][1], gangid, type, delay2);
	    mysql_tquery(connectionID, queryBuffer);
	    mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);
	}
	
	adminVehicle{vehicleid} = false;
	DestroyVehicleEx(vehicleid);

	return 1;
}

CMD:tab(playerid) {
    new string[MAX_PLAYER_NAME * 100], title[80], count = 0, name[MAX_PLAYER_NAME+1];
    strcat(string, "ID\tName\tLevel\tPing");
    count++;
    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string), "%s\n%d\t%s\t%d\t%d", string, playerid, name, GetPlayerScore(playerid), GetPlayerPing(playerid));
    foreach(new i : Player)

    {
        if(IsPlayerConnected(i) && i != playerid)
        {
            count++;
            GetPlayerName(i, name, sizeof(name));
            format(string, sizeof(string), "%s\n%d\t%s\t%d\t%d", string, i, name, GetPlayerScore(i), GetPlayerPing(i));
        }
    }
    format(title, sizeof(title), " AK:RP |  Players Online: %d", count);
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Closed", "");
    return 1;
}

CMD:editvehicle(playerid, params[])
{
	new vehicleid, option[14], param[32], value;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[32]", vehicleid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Spawn, Tickets, Locked, Plate, Color, Paintjob, Neon, Trunk, Health");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Gang, Faction, Job, Respawndelay, VIP, Rank");
	    return 1;
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle specified is invalid or a static vehicle.");
	}

	if(!strcmp(option, "spawn", true))
	{
	    new id = VehicleInfo[vehicleid][vID];

	    if(VehicleInfo[vehicleid][vFactionType] > 0 && GetPlayerInterior(playerid) > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't set the spawn of a faction vehicle indoors.");
	    }

	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	    	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);
	    }
	    else
	    {
		    GetPlayerPos(playerid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
		    GetPlayerFacingAngle(playerid, VehicleInfo[vehicleid][vPosA]);
	    }

	    if(VehicleInfo[vehicleid][vGang] >= 0 || VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
	        VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);
	        SaveVehicleModifications(vehicleid);
	    }

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], id);
		mysql_tquery(connectionID, queryBuffer);

	 	SM(playerid, COLOR_AQUA, "** You have moved the spawn point for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
	 	SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
	 	DespawnVehicle(vehicleid, false);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);
	}
	
	else if(!strcmp(option, "tickets", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option can only be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [tickets] [value]");
		}

		VehicleInfo[vehicleid][vTickets] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** You have set the tickets of %s's %s (ID %i) to $%i.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "locked", true))
	{
		if(sscanf(param, "i", value) || !(0 <= value <= 1))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [locked] [0/1]");
		}
		if(VehicleInfo[vehicleid][vFactionType] > 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Faction vehicles can't be locked.");
		}

		VehicleInfo[vehicleid][vLocked] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[vehicleid][vLocked], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SetVehicleParams(vehicleid, VEHICLE_DOORS, value);
		SM(playerid, COLOR_AQUA, "** You have set the locked state of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "plate", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option can only be adjusted on player owned vehicles.");
		}
		if(isnull(param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [plate] [text]");
		}

		strcpy(VehicleInfo[vehicleid][vPlate], param, 32);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET plate = '%e' WHERE id = %i", VehicleInfo[vehicleid][vPlate], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ResyncVehicle(vehicleid);
		SM(playerid, COLOR_AQUA, "** You have set the license plate of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
		SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle will need to be respawned for changes to take effect.");
	}
    else if(!strcmp(option, "color", true))
	{
	    new color1, color2;

		if(sscanf(param, "ii", color1, color2))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [color] [color 1] [color 2]");
		}
		if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The colors must range from 0 to 255.");
		}

		VehicleInfo[vehicleid][vColor1] = color1;
		VehicleInfo[vehicleid][vColor2] = color2;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ChangeVehicleColor(vehicleid, color1, color2);
		SM(playerid, COLOR_AQUA, "** You have set the colors of %s (ID %i) to %i, %i.", GetVehicleName(vehicleid), vehicleid, color1, color2);
	}
	else if(!strcmp(option, "paintjob", true))
	{
	    new paintjobid;

		if(sscanf(param, "i", paintjobid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [paintjobid] [value (-1 = none)]");
		}
		if(!(-1 <= paintjobid <= 5))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The paintjob must range from -1 to 5.");
		}
		if(VehicleInfo[vehicleid][vFactionType] > 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't change the paintjob on a faction vehicle.");
		}

		VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", VehicleInfo[vehicleid][vPaintjob], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ChangeVehiclePaintjob(vehicleid, paintjobid);
		SM(playerid, COLOR_AQUA, "** You have set the paintjob of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, paintjobid);
	}
	else if(!strcmp(option, "neon", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option can only be adjusted on player owned vehicles.");
		}
		if(isnull(param))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [neon] [color]");
		    SendClientMessage(playerid, COLOR_GREY2, "List of colors: None, Red, Blue, Green, Yellow, Pink, White");
		    return 1;
		}

		if(!strcmp(param, "neon", true)) {
		    SetVehicleNeon(vehicleid, 0);
		} else if(!strcmp(param, "red", true)) {
			SetVehicleNeon(vehicleid, 18647);
		} else if(!strcmp(param, "blue", true)) {
			SetVehicleNeon(vehicleid, 18648);
		} else if(!strcmp(param, "green", true)) {
			SetVehicleNeon(vehicleid, 18649);
		} else if(!strcmp(param, "yellow", true)) {
			SetVehicleNeon(vehicleid, 18650);
		} else if(!strcmp(param, "pink", true)) {
			SetVehicleNeon(vehicleid, 18651);
		} else if(!strcmp(param, "white", true)) {
			SetVehicleNeon(vehicleid, 18652);
		} else {
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid color.");
		}

		SM(playerid, COLOR_AQUA, "** You have set the neon type of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
	}
	else if(!strcmp(option, "trunk", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option can only be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value) || !(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [trunk] [level (0-3)]");
		}

		VehicleInfo[vehicleid][vTrunk] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "** You have set the trunk of %s's %s (ID %i) to level %i/3.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "health", true))
	{
	    new Float:amount;

		if(sscanf(param, "f", amount))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [health] [amount]");
		}
		if(!(300.0 <= amount <= 10000.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The health value must range from 300.0 to 10000.0.");
		}

		VehicleInfo[vehicleid][vHealth] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET health = '%f' WHERE id = %i", VehicleInfo[vehicleid][vHealth], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SetVehicleHealth(vehicleid, amount);
		SM(playerid, COLOR_AQUA, "** You have set the health of %s (ID %i) to %.2f.", GetVehicleName(vehicleid), vehicleid, amount);
	}
	else if(!strcmp(option, "fuel", true))
	{
	    new amount;

		if(sscanf(param, "i", amount))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [fuel] [amount]");
		}
		if(!(0 <= amount <= 100))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The health value must range from 0.0 to 100.0.");
		}

        vehicleFuel[vehicleid] = amount;

		SM(playerid, COLOR_AQUA, "** You have set the fuel of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, amount);
	}
	else if(!strcmp(option, "gang", true))
	{
	    new gangid;

        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option cannot be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", gangid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [gang] [gangid (-1 = none)]");
		}
		if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

		VehicleInfo[vehicleid][vGang] = gangid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET gangid = %i WHERE id = %i", VehicleInfo[vehicleid][vGang], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		    SM(playerid, COLOR_AQUA, "** You have reset the gang for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
			SM(playerid, COLOR_AQUA, "** You have set the gang of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GangInfo[gangid][gName], gangid);
	}
 	else if(!strcmp(option, "faction", true))
	{
	    new type;

        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", type))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [faction] [type]");
	        SendClientMessage(playerid, COLOR_GREY2, "List of types: (0) None (1) Police (2) Medic (3) News (4) Government (5) Hitman (6) Federal (7) Mechanic (8) Terrorist (9) Army (10) JailGuard");
	        SendClientMessage(playerid, COLOR_GREY2, "List of types: (11) NPolice (12) EMS");
	        return 1;
		}
		if(!(0 <= type <= 12))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		VehicleInfo[vehicleid][vFactionType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET factiontype = %i WHERE id = %i", VehicleInfo[vehicleid][vFactionType], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(type == FACTION_NONE)
		    SM(playerid, COLOR_AQUA, "** You've reset the faction type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SM(playerid, COLOR_AQUA, "** You've set the faction type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, factionTypes[type], type);
	}
	else if(!strcmp(option, "job", true))
	{
        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", value))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [job] [type]");
			SendClientMessage(playerid, COLOR_GREY2, "List of jobs: (-1) None  (1) Trucker  (3) Bodyguard (4) Arms Dealer (5) Miner");
			SendClientMessage(playerid, COLOR_GREY2, "List of jobs: (6) tow trucker (7) Drug Dealer (8) Lawyer (9) Detective (10) Farmer (11) Garbage (12) Goods Delivery");
			return 1;
		}
		if(!(-1 <= value <= 12))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid job.");
		}

		VehicleInfo[vehicleid][vJob] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET job = %i WHERE id = %i", VehicleInfo[vehicleid][vJob], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(value == JOB_NONE)
		    SM(playerid, COLOR_AQUA, "** You've reset the job type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SM(playerid, COLOR_AQUA, "** You've set the job type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GetJobName(value), value);
	}
    else if(!strcmp(option, "respawndelay", true))
	{
	    new id = VehicleInfo[vehicleid][vID];

	    if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This option cannot be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvehicle [vehicleid] [respawndelay] [seconds (-1 = none)]");
		}

	    VehicleInfo[vehicleid][vRespawnDelay] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET respawndelay = %i WHERE id = %i", VehicleInfo[vehicleid][vRespawnDelay], id);
		mysql_tquery(connectionID, queryBuffer);

	 	SM(playerid, COLOR_AQUA, "** You have set the respawn delay of %s (ID %i) to %i seconds.", GetVehicleName(vehicleid), vehicleid, value);
	 	SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
	 	DespawnVehicle(vehicleid, false);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);
	}

	return 1;
}

CMD:removevehicle(playerid, params[])
{
	new vehicleid;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevehicle [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle specified is invalid or a static vehicle.");
	}

	if(VehicleInfo[vehicleid][vOwnerID]) {
		SM(playerid, COLOR_WHITE, "** You have deleted %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
	} else {
		SM(playerid, COLOR_WHITE, "** You have deleted %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DespawnVehicle(vehicleid, false);
	return 1;
}

CMD:aclearwanted(playerid, params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /aclearwanted [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no active charges to clear.");
	}

	PlayerInfo[targetid][pWantedLevel] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(targetid, COLOR_WHITE, "** Your crimes were cleared by %s.", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has cleared %s's crimes and wanted level.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:removedm(playerid, params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removedm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pDMWarnings] && !PlayerInfo[targetid][pWeaponRestricted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't been punished for DM recently.");
	}

	PlayerInfo[targetid][pDMWarnings]--;
	PlayerInfo[targetid][pWeaponRestricted] = 0;

	if(PlayerInfo[targetid][pJailType] == 2)
	{
	    PlayerInfo[targetid][pJailType] = 0;
		PlayerInfo[targetid][pJailTime] = 0;

		SetPlayerPos(targetid, 1544.4407, -1675.5522, 13.5584);
		SetPlayerFacingAngle(targetid, 90.0000);
		SetPlayerInterior(targetid, 0);
		SetPlayerVirtualWorld(targetid, 0);
		SetCameraBehindPlayer(targetid);
		SetPlayerWeapons(targetid);
	}

	SM(targetid, COLOR_AQUA, "** Your DM punishment has been reversed by %s.", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reversed %s's DM punishment.", GetRPName(playerid), GetRPName(targetid));
	
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET jailtype = 0, jailtime = 0, dmwarnings = %i, weaponrestricted = 0 WHERE uid = %i", PlayerInfo[targetid][pDMWarnings], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:destroyveh(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}

	if(adminVehicle{vehicleid})
	{
	    DestroyVehicleEx(vehicleid);
	    adminVehicle{vehicleid} = false;
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Admin vehicle destroyed.");
	}

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(adminVehicle{i})
	    {
	        DestroyVehicle(i);
	        adminVehicle{i} = false;
		}
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s destroyed all admin spawned vehicles.", GetRPName(playerid));
	return 1;
}

CMD:respawncars(playerid, params[])
{
	new option[10], param[12];

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[10]S()[12]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /respawncars [job | faction | nearby | all]");
	}
	if(!strcmp(option, "job", true))
	{
		for(new i = 1; i < MAX_VEHICLES; i ++)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i})
		    {
		        if((courierVehicles[0] <= i <= courierVehicles[6]) || (sandalvehicle[0] <= i <= sandalvehicle[3]) || (FarmerVehicles[0] <= i <= FarmerVehicles[9]) || (VehicleInfo[i][vJob] != JOB_NONE))
		        {
	        		SetVehicleToRespawn(i);
				}
	 		}
		}

		SAM(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied job vehicles.", GetRPName(playerid));
	}
	else if(!strcmp(option, "faction", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /respawncars [faction] [type]");
	        SendClientMessage(playerid, COLOR_GREY2, "List of options: (1) Police (2) Medic (3) News (4) Government (5) Hitman (6) Federal (7) Mechanic (8) Terrorist (9) Army");
	        return 1;
		}
		if(!(1 <= type <= 9))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction type.");
		}

		for(new i = 1; i < MAX_VEHICLES; i ++)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i} && VehicleInfo[i][vFactionType] == type)
	    	{
				SetVehicleToRespawn(i);
			}
		}

		SAM(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied {F7A763}%s{FF6347} vehicles.", GetRPName(playerid), factionTypes[type]);
	}
	else if(!strcmp(option, "nearby", true))
	{
		for(new i = 1; i < MAX_VEHICLES; i ++)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i} && IsVehicleStreamedIn(i, playerid))
		    {
				SetVehicleToRespawn(i);
			}
		}

		SAM(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles in %s.", GetRPName(playerid), GetPlayerZoneName(playerid));
	}
	else if(!strcmp(option, "all", true))
	{
		for(new i = 1; i < MAX_VEHICLES; i ++)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i})
		    {
				SetVehicleToRespawn(i);
			}
		}

		SAM(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles.", GetRPName(playerid));
	}

	return 1;
}
CMD:rdcann(playerid, params[])
{
	new text[128];
    if(!IsAHitman(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[128]", text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rdcannn [text]");
	}
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pGang] || IsAHitman(i))
		{
			DynamicTextDrawSetString(ANN[2], text);
			for(new f = 0; f < 3; f ++)
			{
				TextDrawShowForPlayer(i, ANN[f]);
			}

			SetTimerEx("ANNHIDE", 10000, false, "i", i);
			PlayerPlaySound(i,1150,0.0,0.0,0.0);
		}
	}
	return 1;
}
CMD:announce(playerid, params[])
{
	new text[128];
    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[128]", text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /announce [text]");
	}
	foreach(new i : Player)
	{
		DynamicTextDrawSetString(ANN[2], text);
		for(new f = 0; f < 3; f ++)
		{
			TextDrawShowForPlayer(i, ANN[f]);
		}

		SetTimerEx("ANNHIDE", 10000, false, "i", i);
		PlayerPlaySound(i,1150,0.0,0.0,0.0);
	}
	return 1;
}

CMD:broadcast(playerid, params[])
{
	new style, text[128];

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[128]", style, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /broadcast [style (0-6)] [text]");
	}
	if(!(0 <= style <= 6))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid style.");
	}
	if(style == 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Style 2 only disappears after death and is therefore disabled.");
	}

	GameTextForAll(text, 6000, style);
	return 1;
}

CMD:fixveh(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't fix a vehicle if you're not sitting in one.");
	}

	RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, COLOR_SYNTAX, "Vehicle fixed.");
	return 1;
}



CMD:clearchat(playerid)
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	foreach(new i : Player)
	{
	    ClearAllChat(i);
	}
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has cleared the chat box.", GetRPName(playerid));
	return 1;
}

CMD:healnear(playerid, params[]) { return callcmd::healrange(playerid, params); }
CMD:healrange(playerid, params[])
{
	new Float:radius;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /healrange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, radius))
		{
		    if(!PlayerInfo[i][pAdminDuty])
		    {
			    SetPlayerHealth(i, 100.0);

			    if(GetArmor(i) < 100.0)
			    {
				    SetScriptArmour(i, 100.0);
				}
			}

		    SendClientMessage(i, COLOR_WHITE, "** An admin has healed everyone nearby.");
		}
	}

	return 1;
}

CMD:shots(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /shots [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM shots WHERE playerid = %i ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListShots", "ii", playerid, targetid);
	return 1;
}

CMD:adamages(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /damages [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT weaponid, playerid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListDamages", "ii", playerid, targetid);
	return 1;
}
CMD:loginmusic(playerid, params[])
{
   ShowPlayerDialog(playerid, DIALOG_LOGINMUSIC, DIALOG_STYLE_LIST, "MUSIC SYSTEM", "ILLUMINATI "RED"[AAVESHAM]\nCOMMING SOON\nCUSTOM URL", "Select", "Close");
   return 1;
}
CMD:damages(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /damages [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT weaponid, playerid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListDamages", "ii", playerid, targetid);
	return 1;
}


CMD:kills(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /kills [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM kills WHERE killer_uid = %i OR target_uid = %i ORDER BY date DESC LIMIT 20", PlayerInfo[targetid][pID], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListKills", "ii", playerid, targetid);
	return 1;
}

CMD:resetadtimer(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	gLastAd = 0;
	SendClientMessage(playerid, COLOR_SYNTAX, "Advertisement timer reset.");
	return 1;
}

CMD:craftgun(playerid, params[])
{
	new option[14], param[32];
    new gangid = 3;
	new turfid = GetNearbyTurf(playerid);

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -225.547302, 1077.088378, 19.742187))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Craft Table.");
	}
	if(sscanf(params, "s[14]S()[32]", option, param))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [weapon]");
		SendClientMessage(playerid, COLOR_YELLOW, "Gun: Mp5 [1500], ShotGun [2500], Deagle [3500]");
		SendClientMessage(playerid, COLOR_YELLOW, "Gun: Ak47 [5000], M4a1 [6000]");
		return 1;
	}
	if(PlayerInfo[playerid][pGang] != TurfInfo[turfid][tCapturedGang])
	{
		 return SendClientMessage(playerid, COLOR_SYNTAX, "This Turf Is Captured By other Gang You Cant Grind");
	}
	if(!strcmp(option, "Mp5", true))
	{
		if(sscanf(param, "i"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [Mp5]");
		}
		if(PlayerInfo[playerid][pMaterials] < 1500)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this weapon.");
		}
		if(PlayerHasWeapon(playerid, 29))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this weapon.");
		}
		else
		{
   			GivePlayerWeaponEx(playerid, 29);
   			PlayerInfo[playerid][pMaterials] -= 2500;

            GangInfo[gangid][gMaterials] +=1250;
	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
		    mysql_tquery(connectionID, queryBuffer);
   			SM(playerid, COLOR_YELLOW, "You have crafted your self a Mp5.");

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
	}
	if(!strcmp(option, "shotgun", true))
	{
		if(sscanf(param, "i"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [shotgun]");
		}
		if(PlayerInfo[playerid][pMaterials] < 2500)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this weapon.");
		}
		if(PlayerHasWeapon(playerid, 25))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this weapon.");
		}
		else
		{
   			GivePlayerWeaponEx(playerid, 25);
   			PlayerInfo[playerid][pMaterials] -= 3500;

			GangInfo[gangid][gMaterials] +=1750;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
			mysql_tquery(connectionID, queryBuffer);

   			SM(playerid, COLOR_YELLOW, "You have crafted your self a Shotgun.");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	if(!strcmp(option, "deagle", true))
	{
		if(sscanf(param, "i"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [deagle]");
		}
		if(PlayerInfo[playerid][pMaterials] < 3500)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this weapon.");
		}
		if(PlayerHasWeapon(playerid, 24))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this weapon.");
		}
		else
		{
   			GivePlayerWeaponEx(playerid, 24);
   			PlayerInfo[playerid][pMaterials] -= 3500;

			GangInfo[gangid][gMaterials] +=1750;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
			mysql_tquery(connectionID, queryBuffer);

   			SM(playerid, COLOR_YELLOW, "You have crafted your self a Deagle.");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	if(!strcmp(option, "ak47", true))
	{
		if(sscanf(param, "i"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [Ak47]");
		}
		if(PlayerInfo[playerid][pMaterials] < 5000)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this weapon.");
		}
		if(PlayerHasWeapon(playerid, 25))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this weapon.");
		}
		else
		{
   			GivePlayerWeaponEx(playerid, 30);
   			PlayerInfo[playerid][pMaterials] -= 5000;

			GangInfo[gangid][gMaterials] +=2500;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
			mysql_tquery(connectionID, queryBuffer);

   			SM(playerid, COLOR_YELLOW, "You have crafted your self a AK47.");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	if(!strcmp(option, "m4a1", true))
	{
		if(sscanf(param, "i"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /craftgun [m4a1]");
		}
		if(PlayerInfo[playerid][pMaterials] < 6000)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this weapon.");
		}
		if(PlayerHasWeapon(playerid, 31))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this weapon.");
		}
		else
		{
   			GivePlayerWeaponEx(playerid, 31);
   			PlayerInfo[playerid][pMaterials] -= 6000;

			GangInfo[gangid][gMaterials] +=3000;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
			mysql_tquery(connectionID, queryBuffer);

   			SM(playerid, COLOR_YELLOW, "You have crafted your self a M4.");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	return 1;
}


CMD:setname(playerid, params[])
{
	new targetid, name[24];

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[24]", targetid, name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setname [playerid] [name]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
 	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(PlayerInfo[targetid][pAdminDuty] && strcmp(PlayerInfo[targetid][pAdminName], "None", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't change the name of a player on admin duty. They're using their admin name.");
	}
	if(!IsValidName(name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The name specified is not supported by the SA-MP client.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminChangeName", "iis", playerid, targetid, name);
	return 1;
}

CMD:execute(playerid, params[])
{
	new killerid, bodypart, weaponid;
  	if(IsAHitman(playerid))
	{
 		if(killerid!= INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9)
    	{
        	SetPlayerHealth(playerid, 0.0);
    	}
    }
    return 1;
}

CMD:blowup(playerid, params[]) return callcmd::explode(playerid, params);
CMD:explode(playerid, params[])
{
	new targetid, damage;

    if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "ui", targetid, damage))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /explode [playerid] [damage(amount)]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	CreateExplosionForPlayer(targetid, x, y, z, 6, 20.0);
    DamagePlayer(targetid, damage, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
	SM(playerid, COLOR_WHITE, "You exploded %s for their client only.", GetRPName(targetid));
	return 1;
}
CMD:countdown(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	SetTimerEx("CountdownAll", 1000, false, "ii", playerid, 3);
 	SAM(COLOR_LIGHTRED, "AdmCmd: %s has initiated a countdown for all players.", GetRPName(playerid));
 	return 1;
}

