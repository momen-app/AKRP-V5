CMD:donatorhelp(playerid) return callcmd::viphelp(playerid);
CMD:viphelp(playerid)
{
	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a donator subscription.");
	}
	SendClientMessage(playerid, COLOR_VIP, "** Donator: /(v)ip, /vipinfo, /vipinvite, /vipnumber");
	SendClientMessage(playerid, COLOR_VIP, "** Donator: /sellgun, /vcode, /vipmenu(soon)");
	return 1;
}

CMD:fws(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		new targetid;
		if(sscanf(params, "ud", targetid))
		{
			SM(playerid, COLOR_SYNTAX, "Usage: /fws [playerid]");
			return 1;
		}

		GiveWeapon(targetid, 24);
		GiveWeapon(targetid, 25);
		GiveWeapon(targetid, 27);
		GiveWeapon(targetid, 31);
		GiveWeapon(targetid, 34);
		SM(playerid, COLOR_LIGHTRED, "AdmCmd: %s has given a full weapon set to %s.", GetRPName(playerid), GetRPName(targetid));
		SM(targetid, COLOR_GREEN, "You have received a full weapon set from %s.", GetRPName(playerid));
	}
	else
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	return 1;
}

forward Slide(playerid);
public Slide(playerid)
{
    if(Sliding[playerid] == 1)
    {
		new Float:X;
		new Float:Y;
		new Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z - 5.00);
		SetTimerEx("Slide", 1000, 0, "i", playerid);
    }
	return 1;
}

forward DestroyEffectObject(objectid, objectid2);
public DestroyEffectObject(objectid, objectid2)
{
	DestroyObject(objectid);
	if(objectid2 != -1) DestroyObject(objectid2);
	return 1;
}

forward IsAChopper(vehicleid);
public IsAChopper(vehicleid)
{
	if(vehicleid >= 0 && vehicleid <= 1) // < Define your Chopper ID's Here
	{
		return 1;
	}
	return 0;
}

//temoporary
CMD:slide(playerid, params[])
{
	new vehicleid;
	if(IsPlayerInAnyVehicle(playerid) && IsAChopper(vehicleid) && Sliding[playerid] == 0)
	{
		Sliding[playerid] = 1;
		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Slide", 1000, 0, "i", playerid);
		SendClientMessage(playerid, COLOR_WHITE, "You are sliding down the rope.");
	}
	return 1;
}

CMD:stopp(playerid, params[])
{
	if(Sliding[playerid] == 1)
	{
		Sliding[playerid] = 0;
		TogglePlayerControllable(playerid, true);
		SendClientMessage(playerid, COLOR_WHITE, "You have stopped sliding.");
	}
	return 1;
}

CMD:factionhelp(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not apart of any faction.");
	}

	SendClientMessage(playerid, COLOR_WHITE, "** Radio: /fc, /(r)adio, /div, /faction, /division, /locker, /showbadge, /(m)egaphone.");

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY, FACTION_JAILGUARDS, FACTION_NPOLICE:
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "** Police: /open, /cell, /cells, /tazer, /cuff, /uncuff, /drag, /detain, /charge, /arrest.");
	        SendClientMessage(playerid, COLOR_WHITE, "** Police: /wanted, /frisk, /take, /ticket, /gov, /ram, /deploy, /undeploy, /undeployall, /backup.");
	        SendClientMessage(playerid, COLOR_WHITE, "** Police: /mdc, /clearwanted, /siren, /badge, /vticket, /vfrisk, /vtake, /seizeplant.");
	        SendClientMessage(playerid, COLOR_WHITE, "** Police: /showtlaws, /showslaws, /giveweaponlic");
         	SendClientMessage(playerid, COLOR_WHITE, "** Auto: /po, /sto, /mir.");

			if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_FEDERAL)
				SendClientMessage(playerid, COLOR_LIGHTORANGE, "** Federal: /cctv, /listcallers, /trackcall, /passport, /checkcargo, /d, /callsign");
			else
			    SendClientMessage(playerid, COLOR_WHITE, "** Federal: /cctv, /listcallers, /trackcall, /checkcargo, /d, /callsign");
		}
		case FACTION_MEDIC:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** Medic: /firstaid, /stretcher(/loadpt), /surgery, /getpt, /injuries, /deploy, /undeploy.");
		    SendClientMessage(playerid, COLOR_WHITE, "** Medic: /movept, /badge, /gov, /backup, /listcallers, /trackcall, /d, /callsign, /undeployall, /heal.");
  			SendClientMessage(playerid, COLOR_WHITE, "** Auto: /po.");
		}
		case FACTION_NEWS:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** News: /news, /live, /endlive, /liveban, /phonebook");
		}
		case FACTION_MECHANIC:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** Mech: /tune, /repair, /tow, /untow, /refill, /nos, /hyd, /takecall");
			SendClientMessage(playerid, COLOR_WHITE, "** Mech: /upgradevehicle, /neon, /paintcar, /colorcar, /unmod");
		}
		case FACTION_GOVERNMENT:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** Goverment: /gov, /settax, /factionpay, /tazer, /cuff, /uncuff, /detain, /taxdeposit, /taxwithdraw.");
		    SendClientMessage(playerid, COLOR_WHITE, "** Goverment: /backup, /badge, /d, /flash");
		}
		case FACTION_HITMAN:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** Hitman: /contracts, /takehit, /profile, /passport, /plantbomb, /pickupbomb, /detonate, /hmole, /hfind");
		}
		case FACTION_TERRORIST:
		{
		    SendClientMessage(playerid, COLOR_WHITE, "** Terrorist: /locker, /gov, /r, /fc **");
		}
	}

	return 1;
}

CMD:ganghelp(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a gang member.");
	}

	SendClientMessage(playerid, COLOR_WHITE, "** Gang: /f, /gang, /gstash, /bandana, /clothes, /capture, /claim, /reclaim, /turfinfo, /points.");
    SendClientMessage(playerid, COLOR_WHITE, "** Gang: /gpark, /gbuyvehicle, /gfindcar, /grespawncars, /gsellcar, /lock, /endalliance.");
	SendClientMessage(playerid, COLOR_WHITE, "** Gang: /getmats, /sellgun, /getdrug, /planthelp, /getcrate");
	return 1;
}

CMD:landhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_WHITE, "** Land: /buyland, /lock, /lopen, /landinfo, /land, /sellmyland, /sellland, /lands.");
    return 1;
}

CMD:planthelp(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a gang member.");
	}
    SendClientMessage(playerid, COLOR_WHITE, "** Plant: /plantpot, /plantinfo, /pickplant.");
    return 1;
}

CMD:o(playerid, params[]) return callcmd::ooc(playerid, params);
CMD:ooc(playerid, params[])
{
	new string[64];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(o)oc [global OOC]");
	}
	if(!enabledOOC && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The global OOC channel is disabled at the moment.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(PlayerInfo[playerid][pToggleOOC])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the OOC chat as you have it toggled.");
	}

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
	    format(string, sizeof(string), "{%06x}%s"WHITE" %s", color >>> 8, PlayerInfo[playerid][pCustomTitle], GetRPName(playerid));

	} else if(PlayerInfo[playerid][pAdmin] > 1) {
		format(string, sizeof(string), ""SVRCLR"%s"WHITE" %s", GetAdminRank(playerid), GetRPName(playerid));
	} else if(PlayerInfo[playerid][pHelper] > 0) {
	    format(string, sizeof(string), "%s %s", GetHelperRank(playerid), GetRPName(playerid));
    } else if(PlayerInfo[playerid][pFormerAdmin]) {
	    format(string, sizeof(string), ""SVRCLR"Former Admin"WHITE" %s", GetRPName(playerid));
	} else if(PlayerInfo[playerid][pVIPPackage] > 0) {
	    format(string, sizeof(string), "{C2A2DA}%s Donator"WHITE" %s", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetRPName(playerid));
	} else {
	    format(string, sizeof(string), "%s", GetRPName(playerid));
	}

	foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pToggleOOC])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
				SM(i, COLOR_WHITE, "(( %s: %.*s... ))", string, MAX_SPLIT_LENGTH, params);
				SM(i, COLOR_WHITE, "(( %s: ...%s ))", string, params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, COLOR_WHITE, "(( %s: %s ))", string, params);
			}
		}
	}

	return 1;
}

CMD:id(playerid, params[])
{
	new count, color, name[MAX_PLAYER_NAME], targetid = strval(params);

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /id [playerid/partial name]");
	}

	if(IsNumeric(params))
	{
		if(IsPlayerConnected(targetid))
		{
		    if((color = GetPlayerColor(targetid)) == 0xFFFFFF00) {
		        color = 0xAAAAAAFF;
			}

		    GetPlayerName(targetid, name, sizeof(name));
		    SM(playerid, COLOR_WHITE, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", targetid, color >>> 8, name, PlayerInfo[targetid][pLevel], GetPlayerPing(targetid));
		}
		else
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
	}
	else if(strlen(params) < 2)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Please input at least two characters to search.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        GetPlayerName(i, name, sizeof(name));

	        if(strfind(name, params, true) != -1)
	        {
	            if((color = GetPlayerColor(i)) == 0xFFFFFF00) {
		        	color = 0xAAAAAAFF;
				}

	            SM(playerid, COLOR_WHITE, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", i, color >>> 8, name, PlayerInfo[i][pLevel], GetPlayerPing(i));
	            count++;
			}
		}

		if(!count)
		{
		    SM(playerid, COLOR_SYNTAX, "No results found for \"%s\". Please narrow your search.", params);
		}
	}

	return 1;
}

CMD:pppay(playerid, params[])
{
    new targetid, amount;
    
    if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to pay a player while on-duty, bobo!", GetRPName(playerid));
	}

    if(sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pay [playerid] [amount]");
    }
    if(gettime() - PlayerInfo[playerid][pLastPay] < 3)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Please wait three seconds between each transaction.");
    }
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
    }
    if(targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't pay yourself.");
    }
    if(amount > PlayerInfo[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much.");
    }
    if(PlayerInfo[playerid][pLevel] < 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can only pay up to $1,000 at a time as a level 1.");
    }
    if(amount < 1)
    {
        return SM(playerid, COLOR_SYNTAX, "Invalid amount");
    }

    PlayerInfo[playerid][pLastPay] = gettime();

    GivePlayerCash(playerid, -amount);
    GivePlayerCash(targetid, amount);

    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out $%i and gives it to %s.", GetRPName(playerid), amount, GetRPName(targetid));
    //Log_Write("log_give", "%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));

    SM(targetid, COLOR_GREEN, "You have been given $%i by %s.", amount, GetRPName(playerid));
    SM(playerid, COLOR_GREEN, "You have given "SVRCLR"$%i{CCFFFF} to %s.", amount, GetRPName(targetid));

    if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
    {
        SAM(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has given $%i to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(targetid), GetPlayerIP(targetid));
    }

    return 1;
}

CMD:fixlands(playerid, params[])
{
	return callcmd::reloadlands(playerid, params);
}

CMD:reloadlands(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(gettime() - gLastFix < 60)
	{
	    return SM(playerid, COLOR_SYNTAX, "This command can only be used every 1 minute. Please wait %i more seconds.", 60 - (gettime() - gLastFix));
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /reloadlands [confirm]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command may cause lag to the server. Abusing this will cause in a permanent ban.");
	    return 1;
	}
	for(new i = 0; i < MAX_OBJECTS; i ++)
	{
	    if(IsValidObject(i) && gScriptObject{i})
	    {
	        DestroyObject(i);
		}
	}
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reloaded all lands and their objects.", GetRPName(playerid));
	gLastFix = gettime();
	return 1;
}

CMD:resetbackpack(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /resetbackpack [playerid]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "** This command removes the player's backpack and all items inside it.");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	ResetBackpack(targetid);
	SM(targetid, COLOR_LIGHTRED, "Administrator %s has reset your backpack and all its items.", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset %s's backpack and all its items.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:giveweaponlic(playerid, params[])
{
	new targetid;
	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY2, "You are not a part of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
	{
		 return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Usage: /giveweaponlic [playerid]");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pWeaponLicense] == 1) {
		return SendClientMessage(playerid, COLOR_GREY2, "The player has already have weapon license.");
	}

	PlayerInfo[targetid][pWeaponLicense] = 1;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunlicense = %i WHERE uid = %i", PlayerInfo[targetid][pWeaponLicense], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(targetid, COLOR_WHITE, "** %s has given you a weapon license.", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %s a weapon license.", GetRPName(playerid), GetRPName(targetid));

	//Log_Write("log_give", "%s (uid: %i) (IP: %s) gives weapon license to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));
	return 1;
}

CMD:gggivebackpack(playerid, params[])
{
	new targetid, size[10];
	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[14]S()[32]", targetid, size))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givebackpack [playerid] [size]");
	    SendClientMessage(playerid, COLOR_WHITE, "Sizes:   Small, Medium, Large");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!strcmp(size, "small", true))
	{
		PlayerInfo[targetid][pBackpack] = 1;
	    SM(targetid, COLOR_WHITE, "** %s has given you a small backpack.", GetRPName(playerid));
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %s a small backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "medium", true))
	{
		PlayerInfo[targetid][pBackpack] = 2;
	    SM(targetid, COLOR_WHITE, "** %s has given you a medium backpack.", GetRPName(playerid));
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %s a medium backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "large", true))
	{
		PlayerInfo[targetid][pBackpack] = 3;
	    SM(targetid, COLOR_WHITE, "** %s has given you a large backpack.", GetRPName(playerid));
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %s a large backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	return 1;
}


CMD:give(playerid, params[])
{
	new targetid, option[14], param[32], amount;

	if(sscanf(params, "us[14]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapon, Materials, Pot, Crack, Meth, Painkillers, Cigars, Spraycans");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: GasCan, Seeds, Ephedrine, DirtyCash, Diamonds, Food, Drink");
	    return 1;
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
    if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}

	if(!strcmp(option, "weapon", true))
	{
	    new weaponid = GetScriptWeapon(playerid);

	    if(!weaponid)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the weapon you're willing to give away.");
	    }
	    if(PlayerInfo[targetid][pWeapons][weaponSlotIDs[weaponid]] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player already has a weapon in that slot.");
	    }
	    if(PlayerInfo[targetid][pWeaponRestricted] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is either weapon restricted or played less than two playing hours.");
	    }
	    if(PlayerInfo[playerid][pFaction] >= 0 && PlayerInfo[targetid][pFaction] != PlayerInfo[playerid][pFaction])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can only give away weapons to your own faction members.");
	    }

	    GiveWeapon(targetid, weaponid);
	    
		RemovePlayerWeaponEx(playerid, weaponid);
		

	    SM(targetid, COLOR_GREEN, "%s has given you their %s.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SM(playerid, COLOR_GREEN, "You have given %s your %s.", GetRPName(targetid), GetWeaponNameEx(weaponid));

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s passes over their %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
	}
	else if(!strcmp(option, "food", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [food] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pFood])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pFood] -= amount;
		PlayerInfo[targetid][pFood] += amount;
		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[playerid][pFood], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[targetid][pFood], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i food.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i food to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s gives some food to %s.", GetRPName(playerid), GetRPName(targetid));
	    //Log_Write("log_give", "%s (uid: %i) gives %i food to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	}
	else if(!strcmp(option, "drink", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [drink] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pDrink])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pDrink] -= amount;
		PlayerInfo[targetid][pDrink] += amount;
		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = %i WHERE uid = %i", PlayerInfo[playerid][pDrink], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = %i WHERE uid = %i", PlayerInfo[targetid][pDrink], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i drink.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i drink to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s gives some drink to %s.", GetRPName(playerid), GetRPName(targetid));
	    //Log_Write("log_give", "%s (uid: %i) gives %i drink to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [materials] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pMaterials])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more materials.");
		}

		PlayerInfo[playerid][pMaterials] -= amount;
		PlayerInfo[targetid][pMaterials] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[targetid][pMaterials], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i materials.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i materials to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some materials to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "pot", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [pot] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pPot])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pPot] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more pot.");
		}

		PlayerInfo[playerid][pPot] -= amount;
		PlayerInfo[targetid][pPot] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[targetid][pPot], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i grams of pot.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i grams of pot to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some pot to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [Crack] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pCrack])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pCrack] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more Crack.");
		}

		PlayerInfo[playerid][pCrack] -= amount;
		PlayerInfo[targetid][pCrack] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[targetid][pCrack], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i grams of crack.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i grams of crack to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some Crack to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "meth", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [meth] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pMeth])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pMeth] + amount > GetPlayerCapacity(playerid, CAPACITY_METH))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more meth.");
		}

		PlayerInfo[playerid][pMeth] -= amount;
		PlayerInfo[targetid][pMeth] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[targetid][pMeth], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i grams of meth.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i grams of meth to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some meth to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [painkillers] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pPainkillers])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more painkillers.");
		}

		PlayerInfo[playerid][pPainkillers] -= amount;
		PlayerInfo[targetid][pPainkillers] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[targetid][pPainkillers], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i painkillers.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i painkillers to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some painkillers to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "bandage", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [bandage] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pBandage])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[playerid][pBandage] >= 5)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 5 Bandage.");
	    }

		PlayerInfo[playerid][pBandage] -= amount;
		PlayerInfo[targetid][pBandage] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bandage = %i WHERE uid = %i", PlayerInfo[playerid][pBandage], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		
		SM(targetid, COLOR_AQUA, "%s has given you %i Bandage.", GetRPName(playerid), amount);
		SM(playerid, COLOR_AQUA, "You have given %i Bandagd to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some Bandage to %s.", GetRPName(playerid), GetRPName(targetid));
	    //Log_Write("log_give", "%s (uid: %i) gives %i Bandage to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	}
	else if(!strcmp(option, "vest", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [vest] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pVest])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pVest] -= amount;
		PlayerInfo[targetid][pVest] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[playerid][pVest], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[targetid][pVest], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_AQUA, "%s has given you %i Vest.", GetRPName(playerid), amount);
		SM(playerid, COLOR_AQUA, "You have given %i Vest to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some Vest to %s.", GetRPName(playerid), GetRPName(targetid));
	    //Log_Write("log_give", "%s (uid: %i) gives %i Vest to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	}
	else if(!strcmp(option, "cigars", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [cigars] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pCigars])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pCigars] -= amount;
		PlayerInfo[targetid][pCigars] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", PlayerInfo[playerid][pCigars], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", PlayerInfo[targetid][pCigars], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i cigars.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i cigars to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some cigars to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [spraycans] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pSpraycans])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pSpraycans] -= amount;
		PlayerInfo[targetid][pSpraycans] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = %i WHERE uid = %i", PlayerInfo[playerid][pSpraycans], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = %i WHERE uid = %i", PlayerInfo[targetid][pSpraycans], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i spraycans.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i spraycans to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some spraycans to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "gascan", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [gascan] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pGasCan])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pGasCan] -= amount;
		PlayerInfo[targetid][pGasCan] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[targetid][pGasCan], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i liters of gasoline.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i liters of gasoline to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some gasoline to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [seeds] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pSeeds])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more seeds.");
		}

		PlayerInfo[playerid][pSeeds] -= amount;
		PlayerInfo[targetid][pSeeds] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", PlayerInfo[targetid][pSeeds], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i seeds.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i seeds to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some seeds to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "ephedrine", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [ephedrine] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pEphedrine])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}
		if(PlayerInfo[targetid][pEphedrine] + amount > GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE))
		{
		    return SM(playerid, COLOR_SYNTAX, "That player can't carry that much more ephedrine.");
		}

		PlayerInfo[playerid][pEphedrine] -= amount;
		PlayerInfo[targetid][pEphedrine] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i WHERE uid = %i", PlayerInfo[playerid][pEphedrine], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i WHERE uid = %i", PlayerInfo[targetid][pEphedrine], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i grams of ephedrine.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i grams of ephedrine to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some ephedrine to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else if(!strcmp(option, "dirtycash", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /give [playerid] [dirtycash] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pDirtyCash])
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "Insufficient amount.");
		}

		PlayerInfo[playerid][pDirtyCash] -= amount;
		PlayerInfo[targetid][pDirtyCash] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[targetid][pDirtyCash], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i grams of dirty cash.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i grams of dirty cash to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives some dirty cash to %s.", GetRPName(playerid), GetRPName(targetid));	 
	}
	else if(!strcmp(option, "diamonds", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [diamonds] [amount]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pDiamonds])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}

		PlayerInfo[playerid][pDiamonds] -= amount;
		PlayerInfo[targetid][pDiamonds] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[targetid][pDiamonds], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_GREEN, "%s has given you %i diamonds.", GetRPName(playerid), amount);
		SM(playerid, COLOR_GREEN, "You have given %i diamonds to %s.", amount, GetRPName(targetid));

		SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s gives some diamonds to %s.", GetRPName(playerid), GetRPName(targetid));
	}

	return 1;
}
CMD:washmoney(playerid, params[])
{
	if(PlayerInfo[playerid][pDirtyCash] < 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You don't have dirty money.");
	}
    for(new i = 0; i < sizeof(washmoneyPoints); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, washmoneyPoints[i][0], washmoneyPoints[i][1], washmoneyPoints[i][2]))
	    {
			Dyuze(playerid, "Notice", "~g~Washing Money...");
			ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
			TogglePlayerControllable(playerid, 0);
			RemovePlayerAttachedObject(playerid, 9);
			SetTimerEx("TimerWashMoney", 10000, false, "i", playerid);
			return 1;
		}
	}
	return 1;
}
CMD:takejoint(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, -981.992919, 1057.608237, 1344.968017))	return 1;
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
    if(PlayerInfo[playerid][pJoint] == 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 Joint package.");
    }

	PlayerInfo[playerid][pLastSell] = gettime();
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
	SM(playerid, COLOR_YELLOW, "You Are taking Joint package.");
    SetPlayerAttachedObject(playerid, 1, 2249, 5, 0.068999, 0.007000, -0.046000, 65.699996, -81.899963, 0.000000, 1.000000, 1.000000, 1.000000);
    SetTimerEx("Joint", 15000, false, "i", playerid);
	return 1;
}

CMD:deliverjoint(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, -1124.992919, 1060.608237, 1345.968017))	return 1;
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
	if(PlayerInfo[playerid][pJoint] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any Joint package.");
	}

	PlayerInfo[playerid][pJoint] -= 1;
	PlayerInfo[playerid][pPainkillers] += 1;
	PlayerInfo[playerid][pLastSell] = gettime();
   	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	SM(playerid, COLOR_YELLOW, "You Got +1 Joint.");
	return 1;
}

CMD:sell(playerid, params[])
{
	new targetid, option[14], param[32], amount, price;

    if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell an item to a player while on-duty, bobo!", GetRPName(playerid));
	}

	if(sscanf(params, "us[14]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapon, Materials, Backpack, Pot, Crack, Meth, Painkillers, Seeds, Ephedrine");
	    return 1;
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pTied] > 0 ||  PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
    if(gettime() - PlayerInfo[playerid][pLastSell] < 10)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
	if(!strcmp(option, "weapon", true))
	{
	    new weaponid;

		if(sscanf(param, "ii", weaponid, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [weapon] [weaponid] [price] (/guninv for weapon IDs)");
		}
	    if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
		}
	    if(PlayerInfo[targetid][pWeapons][weaponSlotIDs[weaponid]] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player already has a weapon in that slot.");
	    }
	    if(PlayerInfo[targetid][pWeaponRestricted] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is either weapon restricted or played less than two playing hours.");
	    }
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}
		//if(GetFactionType(playerid) == FACTION_NONE || (GetFactionType(playerid) == FACTION_TERRORIST && PlayerInfo[playerid][pFactionRank] >= FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 3))
		if(GetFactionType(playerid) == FACTION_NONE)
		{
		    PlayerInfo[playerid][pLastSell] = gettime();
			PlayerInfo[targetid][pSellOffer] = playerid;
			PlayerInfo[targetid][pSellType] = ITEM_WEAPON;
			PlayerInfo[targetid][pSellExtra] = weaponid;
			PlayerInfo[targetid][pSellPrice] = price;

			SM(targetid, COLOR_GREEN, "** %s offered to sell you their %s for $%i. (/accept item)", GetRPName(playerid), GetWeaponNameEx(weaponid), price);
			SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %s for $%i.", GetRPName(targetid), GetWeaponNameEx(weaponid), price);
		}
		else
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell a gun as you're part of a faction");
		}
	}
	else if(!strcmp(option, "materials", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [materials] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pMaterials])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_MATERIALS;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i materials for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i materials for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "backpack", true))
	{
	    new size[6];
		if(sscanf(param, "ii", amount, price))
		{
  			SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [backpack] [size] [price]");
  			SendClientMessage(playerid, SERVER_COLOR, "** {FF0000}[NOTE}: "WHITE"Please note that the items inside the backpack will be deleted.");
  			return 1;
		}
		if(!PlayerInfo[playerid][pBackpack])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a backpack.");
		}
		if(PlayerInfo[playerid][bpWearing])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell your backpack while wearing it.");
		}
		if(amount != PlayerInfo[playerid][pBackpack])
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Invalid backpack size.");
		    SendClientMessage(playerid, COLOR_SYNTAX, "Sizes: 1 - Small  |  2 - Medium  |  3 - large");
		    return 1;
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_BACKPACK;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;
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
		SM(targetid, COLOR_GREEN, "** %s offered to sell you a %s backpack for $%i. (/accept item)", GetRPName(playerid), size, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %s backpack for $%i.", GetRPName(targetid), size, price);
	}
	else if(!strcmp(option, "pot", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [pot] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pPot])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_WEED;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i grams of pot for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i grams of pot for $%i.", GetRPName(targetid), amount, price);
	}
    else if(!strcmp(option, "crack", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [Crack] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pCrack])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_COCAINE;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i grams of Crack for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i grams of Crack for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "meth", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [meth] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pMeth])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_METH;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i grams of meth for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i grams of meth for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "painkillers", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [painkillers] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pPainkillers])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_PAINKILLERS;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i painkillers for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i painkillers for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "seeds", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [seeds] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pSeeds])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_SEEDS;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i seeds for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i seeds for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "ephedrine", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [ephedrine] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerInfo[playerid][pEphedrine])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerInfo[playerid][pLastSell] = gettime();
		PlayerInfo[targetid][pSellOffer] = playerid;
		PlayerInfo[targetid][pSellType] = ITEM_EPHEDRINE;
		PlayerInfo[targetid][pSellExtra] = amount;
		PlayerInfo[targetid][pSellPrice] = price;

		SM(targetid, COLOR_GREEN, "** %s offered to sell you %i grams of ephedrine for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SM(playerid, COLOR_GREEN, "** You have offered to sell %s your %i grams of ephedrine for $%i.", GetRPName(targetid), amount, price);
	}

	return 1;
}

CMD:accent(playerid, params[])
{
	new type;

	if(sscanf(params, "i", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /accent [type]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of accents: (0) None - (1) Tagalog - (2) Cebuano - (3) Bikol - (4) English - (5) Japanese - (6) Chinese");
		SendClientMessage(playerid, SERVER_COLOR, "More accent contact developers.");
		return 1;
	}

	switch(type)
	{
		case 0: strcpy(PlayerInfo[playerid][pAccent], "None", 16);
		case 1: strcpy(PlayerInfo[playerid][pAccent], "Tagalog", 16);
		case 2: strcpy(PlayerInfo[playerid][pAccent], "Cebuano", 16);
		case 3: strcpy(PlayerInfo[playerid][pAccent], "Bikol", 16);
		case 4: strcpy(PlayerInfo[playerid][pAccent], "English", 16);
		case 5: strcpy(PlayerInfo[playerid][pAccent], "Japanese", 16);
		case 6: strcpy(PlayerInfo[playerid][pAccent], "Chinese", 16);

		default: SendClientMessage(playerid, COLOR_SYNTAX, "Invalid accent. Valid types range from 0 to 53.");
	}

	SM(playerid, COLOR_WHITE, "** You set your accent to '%s'.", PlayerInfo[playerid][pAccent]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET accent = '%e' WHERE uid = %i", PlayerInfo[playerid][pAccent], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:dice(playerid, params[])
{
	SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s rolls a dice which lands on the number %i.", GetRPName(playerid), random(6) + 1);
	return 1;
}

CMD:flipcoin(playerid, params[])
{
	SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s flips a coin which lands on %s.", GetRPName(playerid), (random(2)) ? ("Heads") : ("Tails"));
	return 1;
}

CMD:time(playerid, params[])
{
	new
	    string[128],
		date[6];

	getdate(date[0], date[1], date[2]);
	gettime(date[3], date[4], date[5]);

	switch(date[1])
	{
	    case 1: string = "January";
	    case 2: string = "February";
	    case 3: string = "March";
	    case 4: string = "April";
	    case 5: string = "May";
	    case 6: string = "June";
	    case 7: string = "July";
	    case 8: string = "August";
	    case 9: string = "September";
	    case 10: string = "October";
	    case 11: string = "November";
	    case 12: string = "December";
	}

	format(string, sizeof(string), "%s %02d, %i %02d:%02d:%02d", string, date[2], date[0], date[3], date[4], date[5]);

	if(PlayerInfo[playerid][pJailTime] > 0)
	{
	    format(string, sizeof(string), "%s Jail Time: %i seconds", string, PlayerInfo[playerid][pJailTime]);
	}

    ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
	Dyuze(playerid, "Time", string, 5000);
	SM(playerid, COLOR_WHITE, "** Paychecks occur at every hour. The next paycheck is at %02d:00 which is in %i minutes.", date[3]+1, (60 - date[4]));
	return 1;
}

CMD:reportdm(playerid, params[]) return callcmd::rdm(playerid, params);
CMD:rdm(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rdm [playerid]");
	}
	if(!enabledReports)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report channel is disabled at the moment.");
	}
	if(PlayerInfo[playerid][pReportMuted])
	{
	    if(PlayerInfo[playerid][pReportMuted] > 1000) {
     		return SM(playerid, COLOR_SYNTAX, "You are indefinitely muted from submitting reports.");
		} else {
			return SM(playerid, COLOR_SYNTAX, "You are muted from submitting reports. Your mute is lifted in %i hours.", PlayerInfo[playerid][pReportMuted]);
		}
	}
	if(gettime() - PlayerInfo[playerid][pLastReport] < 50)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only submit one report every 50 seconds. Please wait %i more seconds.", 50 - (gettime() - PlayerInfo[playerid][pLastReport]));
	}
	if(PlayerInfo[playerid][pActiveReport] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have an active report which needs to be closed first. Use /cr to close it.");
	}
	if(!AddDMReportToQueue(playerid, params))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The report queue is currently full. Please try again later.");
	}

	SendClientMessage(playerid, COLOR_YELLOW, "Your DM report was sent to all online admins. Please wait for a response.");
	return 1;
}

CMD:report(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /report [playerid (optional)] [text]");
	}
	if(!enabledReports)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report channel is disabled at the moment.");
	}
	if(PlayerInfo[playerid][pReportMuted])
	{
	    if(PlayerInfo[playerid][pReportMuted] > 1000) {
     		return SM(playerid, COLOR_SYNTAX, "You are indefinitely muted from submitting reports.");
		} else {
			return SM(playerid, COLOR_SYNTAX, "You are muted from submitting reports. Your mute is lifted in %i hours.", PlayerInfo[playerid][pReportMuted]);
		}
	}
	if(gettime() - PlayerInfo[playerid][pLastReport] < 50)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only submit one report every 50 seconds. Please wait %i more seconds.", 50 - (gettime() - PlayerInfo[playerid][pLastReport]));
	}
	if(PlayerInfo[playerid][pActiveReport] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have an active report which needs to be closed first. Use /cr to close it.");
	}
	if(!AddReportToQueue(playerid, params))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The report queue is currently full. Please try again later.");
	}

	SendClientMessage(playerid, COLOR_YELLOW, "Your report was sent to all online admins. Please wait for a response.");
	return 1;
}

CMD:gethelp(playerid, params[]) return callcmd::helpme(playerid, params);
CMD:requesthelp(playerid, params[]) return callcmd::helpme(playerid, params);
CMD:helpme(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gethelp [help request]");
	}
	if(PlayerInfo[playerid][pHelper] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are a helper and therefore can't use this command.");
	}
	if(PlayerInfo[playerid][pHelpMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are muted from submitting help requests.");
	}
	if(gettime() - PlayerInfo[playerid][pLastRequest] < 30)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only submit one help request every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerInfo[playerid][pLastRequest]));
	}

	strcpy(PlayerInfo[playerid][pHelpRequest], params, 128);
	SendHelperMessage(COLOR_GREEN, "** Help Request from %s[%i]: %s **", GetRPName(playerid), playerid, params);
	
    new szString[128];
	format(szString, sizeof(szString),"** Help Request from %s[%i]: %s **", GetRPName(playerid), playerid, params);
	SendDiscordMessage(10, szString);
	PlayerInfo[playerid][pLastRequest] = gettime();
	
	SendClientMessage(playerid, COLOR_YELLOW, "Your help request was sent to all helpers. Please wait for a response.");
	return 1;
}
GetSpawnedVehicles(playerid)
{
    new count;

    for(new i = 1; i < MAX_VEHICLES; i ++)
    {
        if(IsVehicleOwner(playerid, i))
        {
            count++;
        }
    }

    return count;
}

