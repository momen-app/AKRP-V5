CMD:createfaction(playerid, params[])
{
	new type[12], name[48], type_id = -1;

    if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[12]s[48]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createfaction [type] [name]");
		SendClientMessage(playerid, COLOR_GREY2, "List of types: Police, Medic, News, Government, Hitman, Federal, Mechanic, Terrorist, Army, JailGuards, EMS, NPolice");
		return 1;
	}

	if(!strcmp(type, "police", true))
	{
	    type_id = FACTION_POLICE;
	}
	else if(!strcmp(type, "medic", true))
	{
	    type_id = FACTION_MEDIC;
	}
	else if(!strcmp(type, "news", true))
	{
	    type_id = FACTION_NEWS;
	}
	else if(!strcmp(type, "government", true))
	{
	    type_id = FACTION_GOVERNMENT;
	}
	else if(!strcmp(type, "hitman", true))
	{
	    type_id = FACTION_HITMAN;
	}
	else if(!strcmp(type, "federal", true))
	{
	    type_id = FACTION_FEDERAL;
	}
	else if(!strcmp(type, "mechanic", true))
	{
	    type_id = FACTION_MECHANIC;
	}
	else if(!strcmp(type, "terrorist", true))
	{
	    type_id = FACTION_TERRORIST;
	}
	else if(!strcmp(type, "army", true))
	{
	    type_id = FACTION_ARMY;
	}
	else if(!strcmp(type, "jailguards", true))
	{
	    type_id = FACTION_JAILGUARDS;
	}
	else if(!strcmp(type, "npolice", true))
	{
	    type_id = FACTION_NPOLICE;
	}

	if(type_id == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}

	for(new i = 1; i < MAX_FACTIONS; i ++)
	{
	    if(!FactionInfo[i][fType])
	    {
	        SetupFaction(i, name, type_id);

	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has created a {F7A763}%s{FF6347} faction named '%s'.", GetRPName(playerid), factionTypes[type_id], name);
	        SM(playerid, COLOR_WHITE, "** This faction's ID is %i. /editfaction to edit.", i);
	        return 1;
		}
	}
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "AdmCmd: %s has created a {F7A763}%s{FF6347} faction named '%s", GetRPName(playerid), factionTypes[type_id], name);
	SendDiscordMessage(9, dc_str);
	SendDiscordMessage(3, dc_str);

	return 1;
}

CMD:editfaction(playerid, params[])
{
	new factionid, option[12], param[48];

	if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[12]S()[48]", factionid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Name, Shortname, Type, Color, RankCount, RankName, Skin, Paycheck, Leader, Locker, TurfTokens");
		return 1;
	}
	if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	}

	if(!strcmp(option, "name", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [name] [text]");
		}

		strcpy(FactionInfo[factionid][fName], param, 48);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET name = '%e' WHERE id = %i", param, factionid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadLockers(factionid);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the name of faction ID %i to '%s'.", GetRPName(playerid), factionid, param);
	}
	else if(!strcmp(option, "shortname", true))
	{
	    if(isnull(param) || strlen(param) > 24)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [shortname] [text]");
		}

		strcpy(FactionInfo[factionid][fShortName], param, 24);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET shortname = '%e' WHERE id = %i", param, factionid);
		mysql_tquery(connectionID, queryBuffer);

  		ReloadLockers(factionid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the short name of faction ID %i to '%s'.", GetRPName(playerid), factionid, param);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type_id;

	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [type] [option]");
			SendClientMessage(playerid, COLOR_GREY2, "List of types: Police, Medic, News, Government, Hitman, Federal, Mechanic, Terrorist, Army, JailGuards, EMS, NPolice");
			return 1;
		}

		if(!strcmp(param, "police", true)) {
		    type_id = FACTION_POLICE;
		} else if(!strcmp(param, "medic", true)) {
		    type_id = FACTION_MEDIC;
		} else if(!strcmp(param, "news", true)) {
		    type_id = FACTION_NEWS;
		} else if(!strcmp(param, "government", true)) {
		    type_id = FACTION_GOVERNMENT;
		} else if(!strcmp(param, "hitman", true)) {
		    type_id = FACTION_HITMAN;
		} else if(!strcmp(param, "federal", true)) {
		    type_id = FACTION_FEDERAL;
		} else if(!strcmp(param, "mechanic", true)) {
		    type_id = FACTION_MECHANIC;
		} else if(!strcmp(param, "terrorist", true)) {
		    type_id = FACTION_TERRORIST;
		} else if(!strcmp(param, "army", true)) {
		    type_id = FACTION_ARMY;
		} else if(!strcmp(param, "jailguards", true)) {
		    type_id = FACTION_JAILGUARDS;
		} else if(!strcmp(param, "npolice", true)) {
		    type_id = FACTION_NPOLICE;
		}

		if(type_id == -1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		FactionInfo[factionid][fType] = type_id;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET type = %i WHERE id = %i", type_id, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the type of faction ID %i to %s.", GetRPName(playerid), factionid, factionTypes[type_id]);
	}
	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [color] [0xRRGGBBAA]");
		}

		FactionInfo[factionid][fColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET color = %i WHERE id = %i", FactionInfo[factionid][fColor], factionid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of faction ID %i.", GetRPName(playerid), color >>> 8, factionid);
	}
	else if(!strcmp(option, "rankcount", true))
	{
	    new ranks;

	    if(sscanf(param, "i", ranks))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [rankcount] [amount]");
		}
		if(!(6 <= ranks <= MAX_FACTION_RANKS))
		{
		    return SM(playerid, COLOR_SYNTAX, "The amount of ranks must range from 1 to %i.", MAX_FACTION_RANKS);
		}

		FactionInfo[factionid][fRankCount] = ranks;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET rankcount = %i WHERE id = %i", ranks, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the rank count of faction ID %i to %i.", GetRPName(playerid), factionid, ranks);
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Rank Names:");

	        for(new i = 0; i < FactionInfo[factionid][fRankCount]; i ++)
	        {
	            if(isnull(FactionRanks[factionid][i]))
	            	SM(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SM(playerid, COLOR_GREY2, "Rank %i: %s", i, FactionRanks[factionid][i]);
	        }

	        return SM(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [rankname] [slot (0-%i)] [name]", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
		}

	    strcpy(FactionRanks[factionid][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", factionid, rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's name of faction ID %i to '%s'.", GetRPName(playerid), rankid, factionid, rank);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;

	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Faction Skins:");

	        for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	        {
	            if(FactionInfo[factionid][fSkins][i] == 0)
	            	SM(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SM(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, FactionInfo[factionid][fSkins][i]);
	        }

	        return SM(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [skin] [slot (1-%i)] [skinid]", MAX_FACTION_SKINS);
	    }
	    if(!(1 <= slot <= MAX_FACTION_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
		}
		if(!(0 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin.");
		}

		slot--;

		FactionInfo[factionid][fSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", factionid, slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_WHITE, "** You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "paycheck", true))
	{
	    new rankid, amount;

        if(FactionInfo[factionid][fType] == FACTION_HITMAN)
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You can't set the paychecks for hitman factions.");
		}
	    if(sscanf(param, "ii", rankid, amount))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Rank Paychecks:");

	        for(new i = 0; i < FactionInfo[factionid][fRankCount]; i ++)
	        {
	            if(isnull(FactionRanks[factionid][i]))
	            	SM(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SM(playerid, COLOR_GREY2, "Rank %i: %s ($%i)", i, FactionRanks[factionid][i], FactionInfo[factionid][fPaycheck][i]);
	        }

	        return SM(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [paycheck] [slot (0-%i)] [amount]", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
		}
		if(!(0 <= amount <= 40000))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount must range from $0 to $40000.");
		}

	    FactionInfo[factionid][fPaycheck][rankid] = amount;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionpay VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE amount = %i", factionid, rankid, amount, amount);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's paycheck of faction ID %i to $%i.", GetRPName(playerid), rankid, factionid, amount);
	}
	else if(!strcmp(option, "leader", true))
	{
	    new leader[MAX_PLAYER_NAME];

	    if(sscanf(param, "s[24]", leader))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [leader] [name]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "This only updates the text for the leader's name in /factions. Use /setfaction to appoint someone as faction leader.");
			return 1;
		}

		strcpy(FactionInfo[factionid][fLeader], leader, MAX_PLAYER_NAME);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET leader = '%e' WHERE id = %i", leader, factionid);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the leader of faction ID %i to %s.", GetRPName(playerid), factionid, leader);
	}
    else if(!strcmp(option, "turftokens", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editfaction [factionid] [turftokens] [amount]");
		}
		if(FactionInfo[factionid][fType] != FACTION_POLICE && FactionInfo[factionid][fType] != FACTION_NPOLICE && FactionInfo[factionid][fType] != FACTION_FEDERAL && FactionInfo[factionid][fType] != FACTION_ARMY)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can only set the turf tokens for police factions.");
		}

		FactionInfo[factionid][fTurfTokens] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = %i WHERE id = %i", amount, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the turf tokens of faction ID %i to %i.", GetRPName(playerid), factionid, amount);
	}

	return 1;
}

CMD:purgefaction(playerid, params[])
{
	new factionid;

	if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /purgefaction [factionid]");
	}
	if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == factionid)
	    {
	        ResetPlayerWeaponsEx(i);
	        SM(i, COLOR_LIGHTRED, "The faction you were apart of has been purged by an administrator.");
            SetPlayerSkin(i, 230);

	        PlayerInfo[i][pFaction] = -1;
	        PlayerInfo[i][pFactionRank] = 0;
	        PlayerInfo[i][pDivision] = -1;
	        PlayerInfo[i][pDuty] = 0;
		}
	}

	strcpy(FactionInfo[factionid][fLeader], "Pending", MAX_PLAYER_NAME);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = -1, factionrank = 0, division = -1 WHERE faction = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weapon_0 = 0, weapon_1 = 0, weapon_2 = 0, weapon_3 = 0, weapon_4 = 0, weapon_5 = 0, weapon_6 = 0, weapon_7 = 0, weapon_8 = 0, weapon_9 = 0, weapon_10 = 0, weapon_11 = 0, weapon_12 = 0 where faction = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET leader = 'Pending' WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has purged faction %s.", GetRPName(playerid), FactionInfo[factionid][fName]);
	return 1;
}

CMD:removefaction(playerid, params[])
{
	new factionid;

	if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removefaction [factionid]");
	}
	if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has deleted faction %s.", GetRPName(playerid), FactionInfo[factionid][fName]);
	RemoveFaction(factionid);
	return 1;
}

CMD:factionban(playerid, params[])
{
	new targetid, status;
	if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /factionban [playerid] [status: 0 = allow, 1 = ban]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(status == 1)
	{
		SMA(COLOR_RED, "%s is now banned from joining any faction as the punishment is raised by %s.", GetRPName(targetid), GetRPName(playerid));
		SendClientMessage(targetid, COLOR_GREEN, "If you wish to get unbanned, please screenshot this and contact the one who banned you or any faction moderators.");
		PlayerInfo[targetid][pFactionBan] = 1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET factionban = 1 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(status == 0)
	{
		SMA(COLOR_GREEN, "%s is now unbanned / is now allowed to join any faction as the punishment is lifted by %s.", GetRPName(targetid), GetRPName(playerid));
		PlayerInfo[targetid][pFactionBan] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET factionban = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

CMD:setfaction(playerid, params[])
{
	new targetid, factionid, rankid;

	if(!PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uiI(-1)", targetid, factionid, rankid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setfaction [playerid] [factionid (-1 = none)] [rank (optional)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(PlayerInfo[targetid][pFactionBan] == 1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This player has been banned from joining factions.");
	}
	if(!(0 <= factionid < MAX_FACTIONS) || (factionid >= 0 && FactionInfo[factionid][fType] == FACTION_NONE))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	}
	if((factionid != -1 && !(-1 <= rankid < FactionInfo[factionid][fRankCount])))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
	}

	if(factionid == -1)
	{
     	ResetPlayerWeaponsEx(targetid);
        SetPlayerSkin(targetid, 230);

        PlayerInfo[targetid][pFaction] = -1;
        PlayerInfo[targetid][pFactionRank] = 0;
        PlayerInfo[targetid][pDivision] = -1;
        PlayerInfo[targetid][pDuty] = 0;

		SM(targetid, COLOR_AQUA, "%s has removed you from your faction.", GetRPName(playerid));
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has removed %s from their faction.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
		if(rankid == -1)
		{
	    	rankid = FactionInfo[factionid][fRankCount] - 1;
		}

		PlayerInfo[targetid][pFaction] = factionid;
		PlayerInfo[targetid][pFactionRank] = rankid;
		PlayerInfo[targetid][pDivision] = -1;

		SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"%s{CCFFFF} in %s.", GetRPName(playerid), FactionRanks[factionid][rankid], FactionInfo[factionid][fName]);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s in %s.", GetRPName(playerid), GetRPName(targetid), FactionRanks[factionid][rankid], FactionInfo[factionid][fName]);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = %i, factionrank = %i, division = %i WHERE uid = %i", factionid, rankid, PlayerInfo[playerid][pDivision], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:reporta(playerid, params[])
{
	new targetid, level;

	if(sscanf(params, "ui", targetid, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /report [playerid] [level]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!(0 <= level <= 8))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 8.");
	}
	if(level == 0 && PlayerInfo[targetid][pAdminDuty])
	{
	    SetPlayerName(targetid, PlayerInfo[targetid][pUsername]);
		PlayerInfo[targetid][pAdminDuty] = 0;
    }
    
    PlayerInfo[targetid][pAdmin] = level;
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s (%i).", GetRPName(playerid), GetRPName(targetid), GetAdminRank(targetid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminlevel = %i WHERE uid = %i", level, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(level == 0)
	{
		SM(playerid, COLOR_AQUA, "You have removed %s's administrator powers.", GetRPName(targetid));
		SM(targetid, COLOR_AQUA, "%s has removed your administrator powers.", GetRPName(playerid));
	}
	else
	{
	    SM(playerid, COLOR_AQUA, "You have set %s's admin level to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(targetid), GetAdminRank(targetid), level);
		SM(targetid, COLOR_AQUA, "%s has set your admin level to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(playerid), GetAdminRank(targetid), level);
	}
	new szString[128];
	format(szString, sizeof(szString), "```%s (uid: %i) set %s's (uid: %i) admin level to %i```", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], level);
	// ///Log_Write("log_admin", "%s (uid: %i) set %s's (uid: %i) admin level to %i", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], level);
	return 1;
}

CMD:factions(playerid, params[])
{
	new string[(1024 * 2)], color, idx;

	for(new factionid = 1; factionid < MAX_FACTIONS; factionid++)
	{
		if(FactionInfo[factionid][fType] != FACTION_NONE) {
			if(FactionInfo[factionid][fColor] == -1 || FactionInfo[factionid][fColor] == -256)
			{
				color = 0xC8C8C8FF;
			}
			else
			{
				color = FactionInfo[factionid][fColor];
			}

			if(FactionInfo[factionid][fType] == FACTION_HITMAN && !IsPlayerAdmin(playerid))
			{
				format(string, sizeof(string), "%s"WHITE"%i\t{%06x}%s"WHITE"\tConfidential\n", string, factionid, color >>> 8, FactionInfo[factionid][fName]);
			}
			else
			{
				format(string, sizeof(string), "%s"WHITE"%i\t{%06x}%s"WHITE"\t%s\n", string, factionid, color >>> 8, FactionInfo[factionid][fName], FactionInfo[factionid][fLeader]);
			}
			idx++;
		}
	}

	if(idx > 0) {
		format(string, sizeof(string), "ID\tName\tLeader\n%s", string);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "Factions", string, "Close", "");
	} else {
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "Factions", "There are no factions created.", "Close", "");
	}
	return 1;
}

CMD:channel(playerid, params[])
{
	new channel;

	if(!PlayerInfo[playerid][pWalkieTalkie])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Portable Radio.");
	}
	if(sscanf(params, "i", channel))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /channel [freq]");
	}
	if(!(0 <= channel <= 9999999))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The channel must range from 0 to 9999999.");
	}

	PlayerInfo[playerid][pChannel] = channel;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET channel = %i WHERE uid = %i", channel, PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(channel == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "** You have set the channel to 0 and disabled your Portable Radio.");
	}
	else
	{
	    SM(playerid, COLOR_WHITE, "** Channel set to %i, use /pr to broadcast over this channel.", channel);
	}

	return 1;
}

CMD:pr(playerid, params[])
{
    if(!PlayerInfo[playerid][pWalkieTalkie])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Portable Radio.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pr [Portable Radio]");
	}
	if(!PlayerInfo[playerid][pChannel])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your Portable Radio is not tuned into any channel. /channel to set one.");
	}
    if(PlayerInfo[playerid][pToggleWT])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in your Portable Radio as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pWalkieTalkie] && PlayerInfo[i][pChannel] == PlayerInfo[playerid][pChannel] && !PlayerInfo[i][pToggleWT])
		{
		    if(strlen(params) > MAX_SPLIT_LENGTH)
		    {
				SM(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: %.*s...", PlayerInfo[playerid][pChannel], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
				SM(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: ...%s", PlayerInfo[playerid][pChannel], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: %s", PlayerInfo[playerid][pChannel], GetRPName(playerid), params);
			}
		}
	}

    SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio) %s",params);
	return 1;
}

CMD:fb(playerid, params[])
{
	return callcmd::facebook(playerid, params);
}

CMD:facebook(playerid, params[])
{
 	new string[64];
 	
 	if(isnull(params))
 	{
     	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(fb) or /facebook [global IC]");
	}
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
	}
	if(PlayerInfo[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(gettime() - PlayerInfo[playerid][pLastTweet] < 10)
	{
	    return SM(playerid, COLOR_GREY, "You can only speak in this channel every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerInfo[playerid][pLastTweet]));
	}
    if((!isnull(PlayerInfo[playerid][pCustomTitle]) && strcmp(PlayerInfo[playerid][pCustomTitle], "None", true) != 0)) {
	    new color;
		if(PlayerInfo[playerid][pCustomTColor] == -1 || PlayerInfo[playerid][pCustomTColor] == -256)
		{
	    	color = 0xC8C8C8FF;
		}
		else
		{
		    color = PlayerInfo[playerid][pCustomTColor];
		}
	    format(string, sizeof(string), "", color >>> 8, PlayerInfo[playerid][pCustomTitle]);
	}
	else if(PlayerInfo[playerid][pAdmin] > 0) {
	  format(string, sizeof(string), "", GetAdminRank(playerid));
	}
	else if(PlayerInfo[playerid][pHelper] > 0) {
	   format(string, sizeof(string), "", GetHelperRank(playerid));
	}
	else if(PlayerInfo[playerid][pFormerAdmin]) {
	    string = "";
	}
	else if(PlayerInfo[playerid][pVIPPackage] > 0) {
	    format(string, sizeof(string), "", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]));
	}
	else if(PlayerInfo[playerid][pLevel] >= 3) {
	    format(string, sizeof(string), "", PlayerInfo[playerid][pLevel]);
	}
	else {
	       string = "";
	}

	foreach(new i : Player)
	{
	  	if(PlayerInfo[i][pPhone] > 0)
	  	{
	      	if(strlen(params) > MAX_SPLIT_LENGTH)
	    	{
	        	SM(i, COLOR_WHITE, "[{1FAAF0}Facebook{F0F1F0}]%s {1FAAF0}@%s{F0F1F0} : %.*s...", string, GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	        	SM(i, COLOR_WHITE, "[{1FAAF0}Facebook{F0F1F0}]%s {1FAAF0}@%s{F0F1F0} : ...%s ", string, GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
	   		}
	   		else
	   		{
	       		SM(i, COLOR_WHITE, "[{1FAAF0}Facebook{F0F1F0}]%s {1FAAF0}@%s{F0F1F0} : %s ", string, GetRPName(playerid), params);
	   		}
	  	}
 	}

	if(PlayerInfo[playerid][pAdmin] < 2)
 	{
 		PlayerInfo[playerid][pLastTweet] = gettime();
 	}
	
	new szstring[129];
	format(szstring, 129 ,"**[Facebook]%s @%s : %s**", string, GetRPName(playerid), params);
	SendDiscordMessage(20, szstring);
 	return 1;
}

CMD:g(playerid, params[])
{
	new string[64];
	
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /g [global chat]");
	}
	if(!enabledGlobal && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The global channel is disabled at the moment.");
	}
	if(PlayerInfo[playerid][pGlobalMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are muted from speaking in this channel.");
	}
    if(PlayerInfo[playerid][pToggleGlobal])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the global chat as you have it toggled.");
	}
	if(gettime() - PlayerInfo[playerid][pLastGlobal] < 30)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only speak in this channel every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerInfo[playerid][pLastGlobal]));
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
	    format(string, sizeof(string), "{%06x}%s{80d6ab}", color >>> 8, PlayerInfo[playerid][pCustomTitle]);

	} else if(PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pAdminDuty]) {
		format(string, sizeof(string), "%s", GetAdminRank(playerid));
	} else if(PlayerInfo[playerid][pHelper] > 0) {
	    format(string, sizeof(string), "%s", GetHelperRank(playerid));
	} else if(PlayerInfo[playerid][pFormerAdmin]) {
	    string = "Former Admin";
	} else if(PlayerInfo[playerid][pVIPPackage] > 0) {
	    format(string, sizeof(string), "%s Donator", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]));
	} else if(PlayerInfo[playerid][pLevel] >= 3) {
	    format(string, sizeof(string), "Level %i Player", PlayerInfo[playerid][pLevel]);
	} else {
        string = "Newbie";
	}

	foreach(new i : Player)
	{
		if(!PlayerInfo[i][pToggleGlobal])
		{
      		if(strlen(params) > MAX_SPLIT_LENGTH)
		    {
		        SM(i, COLOR_ORANGE, "(( %s %s %s: %.*s... ))", IsPlayerAndroid(playerid) ? ("{CCFFFF}CP") : ("{C2A2DA}PC"), string, GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SM(i, COLOR_ORANGE, "(( %s %s: ...%s ))", string, GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, COLOR_ORANGE, "(( %s {80d6ab}%s %s: %s ))", IsPlayerAndroid(playerid) ? ("{CCFFFF}CP") : ("{C2A2DA}PC"), string, GetRPName(playerid), params);
			}
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pFormerAdmin])
	{
		PlayerInfo[playerid][pLastGlobal] = gettime();
	}
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "((**[Global Chat]%s: %s **))",  GetRPName(playerid), params);
	SendDiscordMessage(21, dc_str);
	return 1;
}

CMD:fc(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fc [faction chat]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
    if(PlayerInfo[playerid][pToggleFaction])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the faction chat as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && !PlayerInfo[i][pToggleFaction])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SM(i, 0x00FFFFFF, "[/fc] %s %s: %.*s... **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SM(i, 0x00FFFFFF, "[/fc] %s %s: ...%s **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, 0x00FFFFFF, "[/fc] %s %s: %s **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
			}
		}
	}
	new szString[128];
	format(szString, sizeof(szString),"**(%s)[%i] %s: %s**", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
	SendDiscordMessage(22, szString);
	return 1;
}

CMD:div(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /div [division chat]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pDivision] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any divisions in your faction.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[i][pDivision] == PlayerInfo[playerid][pDivision])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SM(i, COLOR_LIGHTORANGE, "** [%s] %s %s: %.*s... **", FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SM(i, COLOR_LIGHTORANGE, "** [%s] %s %s: ...%s **", FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, COLOR_LIGHTORANGE, "** [%s] %s %s: %s **", FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}

CMD:r(playerid, params[])
{
	return callcmd::radio(playerid, params);
}
CMD:rc(playerid, params[])
{
	return callcmd::radiochat(playerid);
}

CMD:radio(playerid, params[])
{
    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(r)adio [faction radio]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pToggleRadio])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in your radio as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}

	new color = (FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_MEDIC) ? (COLOR_DOCTOR) : (COLOR_ROYALBLUE);
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && !PlayerInfo[i][pToggleRadio])
	    {

			if(strlen(params) > MAX_SPLIT_LENGTH)
			{
			    SM(i, color, "** %s %s: %.*s... **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
			    SM(i, color, "** %s %s: ...%s **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, color, "** %s %s: %s **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
			}
		}
	}
	SetPlayerBubbleText(playerid, 5.0, color, "(Radio) %s",params);
	return 1;
}

CMD:int(playerid, params[])
{
	new header[128];

    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /int [international radio]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 4)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank is too to talk in international radio.");
	}
	if(PlayerInfo[playerid][pToggleRadio])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your radio as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /int if you're dead!");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}

    if(!strcmp(FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], "None", true))
	{
	    if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}
	else
	{
		if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_NPOLICE, FACTION_POLICE, FACTION_MEDIC, FACTION_GOVERNMENT, FACTION_FEDERAL, FACTION_ARMY, FACTION_JAILGUARDS:
	    {
			foreach(new i : Player)
			{
			    if((!PlayerInfo[i][pToggleRadio]) && (GetFactionType(i) == FACTION_NPOLICE || GetFactionType(i) == FACTION_POLICE || GetFactionType(i) == FACTION_MEDIC || GetFactionType(i) == FACTION_GOVERNMENT || GetFactionType(i) == FACTION_FEDERAL || GetFactionType(i) == FACTION_ARMY || GetFactionType(i) == FACTION_JAILGUARDS))
			    {
			        if(strlen(params) > MAX_SPLIT_LENGTH)
			        {
			        	SM(i, COLOR_INT, "**[INT] [%s] %s: %.*s... **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
			        	SM(i, COLOR_INT, "** [%s] %s: ...%s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
					}
					else
					{
					    SM(i, COLOR_INT, "**[INT] [%s] %s: %s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params);
					}
				}
			}
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Your faction is not authorized to speak in department radio.");
		}
	}

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[INT.Radio]: %s", params);
	return 1;
}

CMD:d(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_SYNTAX, "/d has been changed to /sd for southern departments and /nd for northern departments.");
}

CMD:nd(playerid, params[])
{
	new header[128];

    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nd [northern department radio]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pToggleRadio])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your radio as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /nd if you're dead!");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}

    if(!strcmp(FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], "None", true))
	{
	    if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}
	else
	{
		if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_NPOLICE:
	    {
			foreach(new i : Player)
			{
			    if((!PlayerInfo[i][pToggleRadio]) && (GetFactionType(i) == FACTION_NPOLICE))
			    {
			        if(strlen(params) > MAX_SPLIT_LENGTH)
			        {
			        	SM(i, COLOR_YELLOW, "** [%s] %s: %.*s... **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
			        	SM(i, COLOR_YELLOW, "** [%s] %s: ...%s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
					}
					else
					{
					    SM(i, COLOR_YELLOW, "** [%s] %s: %s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params);
					}
				}
			}
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Your faction is not authorized to speak in department radio.");
		}
	}

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[ND.Radio]: %s", params);
	return 1;
}

CMD:sd(playerid, params[])
{
	new header[128];

    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sd [southern department radio]");
	}
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pToggleRadio])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your radio as you have it toggled.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /sd if you're dead!");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}

    if(!strcmp(FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], "None", true))
	{
	    if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}
	else
	{
		if(PlayerInfo[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pDivision]], FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
		}
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_MEDIC, FACTION_GOVERNMENT, FACTION_FEDERAL, FACTION_ARMY, FACTION_JAILGUARDS:
	    {
			foreach(new i : Player)
			{
			    if((!PlayerInfo[i][pToggleRadio]) && (GetFactionType(i) == FACTION_POLICE || GetFactionType(i) == FACTION_MEDIC || GetFactionType(i) == FACTION_GOVERNMENT || GetFactionType(i) == FACTION_FEDERAL || GetFactionType(i) == FACTION_ARMY || GetFactionType(i) == FACTION_JAILGUARDS))
			    {
			        if(strlen(params) > MAX_SPLIT_LENGTH)
			        {
			        	SM(i, COLOR_YELLOW, "** [%s] %s: %.*s... **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
			        	SM(i, COLOR_YELLOW, "** [%s] %s: ...%s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
					}
					else
					{
					    SM(i, COLOR_YELLOW, "** [%s] %s: %s **", FactionInfo[PlayerInfo[playerid][pFaction]][fShortName], GetRPName(playerid), params);
					}
				}
			}
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Your faction is not authorized to speak in department radio.");
		}
	}

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[SD.Radio]: %s", params);
	return 1;
}

CMD:faction(playerid, params[])
{
	new targetid, option[14], param[32];

	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(sscanf(params, "s[14]S()[32]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /faction [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Invite, Kick, Rank, RankName, Roster, Online, Offlinekick, Respawncars, Skin");
	    return 1;
	}
	if(!strcmp(option, "invite", true))
	{
		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /faction [invite] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pFaction] != -1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already apart of a faction.");
		}
		if(PlayerInfo[targetid][pGang] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is apart of a gang and therefore can't join a faction.");
		}

		PlayerInfo[targetid][pFactionOffer] = playerid;
		PlayerInfo[targetid][pFactionOffered] = PlayerInfo[playerid][pFaction];

		SM(targetid, COLOR_AQUA, "** %s has invited you to join "SVRCLR"%s{CCFFFF} (/accept faction).", GetRPName(playerid), FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
		SM(playerid, COLOR_AQUA, "** You have invited %s to join your faction.", GetRPName(targetid));
	}
	else if(!strcmp(option, "kick", true))
	{
		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /faction [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pFaction] != PlayerInfo[playerid][pFaction])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your faction.");
		}
		if(PlayerInfo[targetid][pFactionRank] > PlayerInfo[playerid][pFactionRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
		}

		//Log_Write("log_faction", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], FactionInfo[PlayerInfo[playerid][pFaction]][fName], PlayerInfo[playerid][pFaction], FactionRanks[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pFactionRank]], PlayerInfo[targetid][pFactionRank]);

		ResetPlayerWeaponsEx(targetid);
        SetPlayerSkin(targetid, 230);

        PlayerInfo[targetid][pFaction] = -1;
        PlayerInfo[targetid][pFactionRank] = 0;
        PlayerInfo[targetid][pDivision] = -1;
        PlayerInfo[targetid][pDuty] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = -1, factionrank = 0, division = -1 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_AQUA, "%s has kicked you from the faction.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "You have kicked %s from your faction.", GetRPName(targetid));
	}
	else if(!strcmp(option, "rank", true))
	{
	    new rankid;

		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "ui", targetid, rankid))
		{
		    return SM(playerid, COLOR_SYNTAX, "Usage: /faction [rank] [playerid] [rankid (0-%i)]", PlayerInfo[playerid][pFactionRank]);
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(rankid < 0 || rankid > PlayerInfo[playerid][pFactionRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The rank specified is either invalid or higher than your rank.");
		}
		if(PlayerInfo[targetid][pFaction] != PlayerInfo[playerid][pFaction])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your faction.");
		}
		if(PlayerInfo[targetid][pFactionRank] > PlayerInfo[playerid][pFactionRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
		}

		PlayerInfo[targetid][pFactionRank] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET factionrank = %i WHERE uid = %i", rankid, PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_AQUA, "%s has set your rank to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(playerid), FactionRanks[PlayerInfo[playerid][pFaction]][rankid], rankid);
		SM(playerid, COLOR_AQUA, "You have set %s's rank to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(targetid), FactionRanks[PlayerInfo[playerid][pFaction]][rankid], rankid);
		//Log_Write("log_faction", "%s (uid: %i) has set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], FactionInfo[PlayerInfo[playerid][pFaction]][fName], PlayerInfo[playerid][pFaction], FactionRanks[PlayerInfo[playerid][pFaction]][rankid], rankid);
	}
	else if(!strcmp(option, "roster", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin, factionrank FROM users WHERE faction = %i ORDER BY factionrank DESC", PlayerInfo[playerid][pFaction]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_FACTION_ROSTER, playerid);
	}
	else if(!strcmp(option, "online", true))
	{
	    callcmd::fmembers(playerid);
	}
	else if(!strcmp(option, "respawncars", true))
	{
	    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}

 		for(new i = 1; i < MAX_VEHICLES; i ++)
		{
		    if(!IsVehicleOccupied(i) && VehicleInfo[i][vFactionType] == FactionInfo[PlayerInfo[playerid][pFaction]][fType])
		    {
		        SetVehicleToRespawn(i);
			}
		}

     	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, "(( %s %s has respawned all unoccupied faction vehicles. ))", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
        SAM(COLOR_YELLOW, "AdmWarning: %s[%i] has respawned their faction vehicles.", GetRPName(playerid), playerid);
	}
	else if(!strcmp(option, "offlinekick", true))
	{
	    new username[MAX_PLAYER_NAME];

		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "s[24]", username))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /faction [offlinekick] [username]");
		}
		if(IsPlayerOnline(username))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use '/faction kick' instead.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, faction, factionrank FROM users WHERE username = '%e'", username);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerOfflineKickFaction", "is", playerid, username);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;
		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
		{
		    return SM(playerid, COLOR_GREY2, "You need to be rank %i to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
		}
	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Faction Skins:");

	        for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	        {
	            if(FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i] == 0)
	            	SM(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SM(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i]);
	        }

	        return SM(playerid, COLOR_GREY2, "Usage: /faction [skin] [slot (1-%i)] [skinid]", MAX_FACTION_SKINS);
	    }

	    if(!(1 <= slot <= MAX_FACTION_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_GREY2, "Invalid slot.");
		}
		if(!(0 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_GREY2, "Invalid skin.");
		}

		slot--;

		FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", PlayerInfo[playerid][pFaction], slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_WHITE, "** You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "rankname", true))
	{
		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
		{
		    return SM(playerid, COLOR_GREY2, "You need to be rank %i to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
		}
	    new rankid, rank[32];

	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Rank Names:");

	        for(new i = 0; i < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount]; i ++)
	        {
	            if(isnull(FactionRanks[PlayerInfo[playerid][pFaction]][i]))
	            	SM(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SM(playerid, COLOR_GREY2, "Rank %i: %s", i, FactionRanks[PlayerInfo[playerid][pFaction]][i]);
	        }

	        return SM(playerid, COLOR_GREY2, "Usage: /faction [rankname] [slot (0-%i)] [name]", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
	    }
	    if(!(0 <= rankid < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount]))
	    {
	        return SendClientMessage(playerid, COLOR_GREY2, "Invalid rank.");
		}
	    strcpy(FactionRanks[PlayerInfo[playerid][pFaction]][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", PlayerInfo[playerid][pFaction], rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_YELLOW, "AdmWarning: %s has set rank %i's name of faction ID %i to '%s'.", GetPlayerNameEx(playerid), rankid, PlayerInfo[playerid][pFaction], rank);
	}

	return 1;
}

CMD:division(playerid, params[])
{
	new targetid, divisionid, option[10], param[32];

	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Hitman factions do not have access to the division system.");
	}
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /division [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Create, Remove, List, Assign, Kick");
	    return 1;
	}
	if(!strcmp(option, "create", true))
	{
		if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(isnull(param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /division [create] [name]");
		}

		for(new i = 0; i < MAX_FACTION_DIVISIONS; i ++)
		{
		    if(isnull(FactionDivisions[PlayerInfo[playerid][pFaction]][i]))
		    {
		        strcpy(FactionDivisions[PlayerInfo[playerid][pFaction]][i], param, 32);
		        SM(playerid, COLOR_AQUA, "You have created division {FFA763}%s{CCFFFF}. The ID of this division is %i.", param, i);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO divisions VALUES(%i, %i, '%e')", PlayerInfo[playerid][pFaction], i, param);
		        mysql_tquery(connectionID, queryBuffer);
		        return 1;
			}
		}

		SM(playerid, COLOR_SYNTAX, "Your faction can only have up to %i divisions.", MAX_FACTION_DIVISIONS);
	}
	else if(!strcmp(option, "remove", true))
	{
	    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "i", divisionid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /division [remove] [divisionid]");
		}
		if(!(0 <= divisionid < MAX_FACTION_DIVISIONS) || isnull(FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid division ID.");
	    }

	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[i][pDivision] == divisionid)
	        {
	            PlayerInfo[i][pDivision] = -1;
	            SendClientMessage(i, COLOR_LIGHTRED, "The division you were apart of has been deleted by the faction owner.");
		    }
		}

		SM(playerid, COLOR_AQUA, "You have deleted division {F7A763}%s{CCFFFF} (%i).", FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid], divisionid);
		FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid][0] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM divisions WHERE id = %i AND divisionid = %i", PlayerInfo[playerid][pFaction], divisionid);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET division = -1 WHERE faction = %i", PlayerInfo[playerid][pFaction]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "list", true))
	{
	    SendClientMessage(playerid, SERVER_COLOR, "Divisions List:");

	    for(new i = 0; i < MAX_FACTION_DIVISIONS; i ++)
	    {
	        if(isnull(FactionDivisions[PlayerInfo[playerid][pFaction]][i]))
	        {
	            SM(playerid, COLOR_GREY1, "ID: %i | Name: Empty Slot", i);
	        }
	        else
	        {
	            SM(playerid, COLOR_GREY1, "ID: %i | Name: %s", i, FactionDivisions[PlayerInfo[playerid][pFaction]][i]);
	        }
	    }
	}
	else if(!strcmp(option, "assign", true))
	{
	    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "ui", targetid, divisionid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /division [assign] [playerid] [divisionid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pFaction] != PlayerInfo[playerid][pFaction])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your faction.");
		}
		if(!(0 <= divisionid < MAX_FACTION_DIVISIONS) || isnull(FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid division ID.");
	    }
	    if(PlayerInfo[targetid][pDivision] == divisionid)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already apart of that division.");
	    }
	    if(PlayerInfo[targetid][pDivision] >= 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already apart of another division.");
	    }

	    PlayerInfo[targetid][pDivision] = divisionid;

	    SM(targetid, COLOR_AQUA, "%s has assigned you to the {F7A763}%s{CCFFFF} division.", GetRPName(playerid), FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid]);
	    SM(playerid, COLOR_AQUA, "You have assigned %s to the {F7A763}%s{CCFFFF} division.", GetRPName(targetid), FactionDivisions[PlayerInfo[playerid][pFaction]][divisionid]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET division = %i WHERE uid = %i", divisionid, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "kick", true))
	{
	    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
		{
		    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /division [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pFaction] != PlayerInfo[playerid][pFaction])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your faction.");
		}
	    if(PlayerInfo[targetid][pDivision] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of any division.");
	    }

	    SM(targetid, COLOR_AQUA, "%s has removed you from the {F7A763}%s{CCFFFF} division.", GetRPName(playerid), FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[targetid][pDivision]]);
	    SM(playerid, COLOR_AQUA, "You have removed %s from the {F7A763}%s{CCFFFF} division.", GetRPName(targetid), FactionDivisions[PlayerInfo[playerid][pFaction]][PlayerInfo[targetid][pDivision]]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET division = -1 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[targetid][pDivision] = -1;
	}

	return 1;
}

CMD:cells(playerid, params[])
{
	new status;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

    for(new i = 0; i < sizeof(gPrisonCells); i ++)
	{
		if(!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
		{
		    MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
		    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
		    status = true;
		}
		else
		{
		    MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
		    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
		    status = false;
		}
	}

	if(status)
		SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has opened all cells in the prison.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
	else
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has closed all cells in the prison.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));

	return 1;
}


CMD:cell(playerid, params[])
{
	for(new i = 0; i < sizeof(gPrisonCells); i ++)
	{
	    if(IsPlayerInRangeOfDynamicObject(playerid, gPrisonCells[i], 2.0))
	    {
	        if(!IsLawEnforcement(playerid))
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to open this cell.");
			}
			if(PlayerInfo[playerid][pDuty] == 0)
			{
				return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
			}

			if(!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
			{
			    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their key to open the cell door.", GetRPName(playerid));
			    MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
			    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
			}
			else
			{
			    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their key to close the cell door.", GetRPName(playerid));
			    MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
			    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
			}

			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any prison cells.");
	return 1;
}

CMD:lopen(playerid, params[])
{
	if(!LandDoorCheck(playerid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any land door/gate which you can open.");
	}
	return 1;
}

CMD:fd(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsMedic(playerid) && !IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1759.596313, -1661.407592, 13.556706 ) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1602.160278, -1657.790283, 16.202812))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You Are Not In Range Of The Faction Garage");
    }

	if(!IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must spawn a vehicle to despawn car.");
	}

	if(factionVehicle{vehicleid})
	{
	    DestroyVehicleEx(vehicleid);
	    factionVehicle{vehicleid} = false;
	    return SendClientMessage(playerid, COLOR_SYNTAX, "FACTION VEHICLE HAS BEEN DESPAWNED.");
	}
	return 1;
}

CMD:showbadge(playerid, params[])
{
	new targetid, factionid, rankid;

    if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}

	if(GetFactionType(playerid) == FACTION_HITMAN)
	{
	    if(sscanf(params, "uii", targetid, factionid, rankid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /showbadge [playerid] [factionid] [rankid]");
	        SendClientMessage(playerid, COLOR_WHITE, "Use /factions for a list of factions to use with factionid parameter.");
	        return 1;
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
		}
		if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Invalid rank. Valid ranks for this faction range from 0 to %i.", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(FactionInfo[factionid][fType] == FACTION_HITMAN)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this faction for your fake badge.");
	    }

	    SM(targetid, COLOR_WHITE, "** %s is rank %s (%i) in %s. **", GetRPName(playerid), FactionRanks[factionid][rankid], rankid, FactionInfo[factionid][fName]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s shows their badge to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
		if(sscanf(params, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /showbadge [playerid]");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
		}

	    SM(targetid, COLOR_WHITE, "** %s is rank %s (%i) in %s. **", GetRPName(playerid), FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], PlayerInfo[playerid][pFactionRank], FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s shows their badge to %s.", GetRPName(playerid), GetRPName(targetid));
	}

	return 1;
}

CMD:m(playerid, params[]) return callcmd::megaphone(playerid, params);
CMD:megaphone(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(m)egaphone [text]");
	}

	SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[>] %s: %s", GetRPName(playerid), params);
	SetPlayerBubbleText(playerid, 50.0, COLOR_YELLOW, "(Megaphone) %s",params);
	return 1;
}

CMD:sto(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_NPOLICE, FACTION_FEDERAL, FACTION_TERRORIST, FACTION_ARMY, FACTION_JAILGUARDS:
	    {
	        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[>] %s: Driver! Step out of the vehicle with your hands above your head!", GetRPName(playerid));
			SetPlayerBubbleText(playerid, 50.0, COLOR_YELLOW, "(Megaphone) %s",params);
		}
	}
	return 1;
}

CMD:po(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_NPOLICE, FACTION_FEDERAL, FACTION_TERRORIST, FACTION_ARMY, FACTION_JAILGUARDS:
	    {
	        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[>] %s: Pull your vehicle over to the side of the road and turn off the ignition!", GetRPName(playerid));
			SetPlayerBubbleText(playerid, 50.0, COLOR_YELLOW, "(Megaphone) %s",params);
		}
		case FACTION_MEDIC:
		{
		    SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[>] %s: Move to the right! FMD passing on your left!", GetRPName(playerid), params);
			SetPlayerBubbleText(playerid, 50.0, COLOR_YELLOW, "(Megaphone) %s",params);
		}
	}
	return 1;
}

forward showMirandaRights(playerid, step);
public showMirandaRights(playerid, step)
{
	new string[128];
    switch(step)
    {
        case 1:
        {
            format(string, sizeof(string), "%s says: You have the right to remain silent.", GetRPName(playerid));
			SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
            SetTimerEx("showMirandaRights", 3000, false, "ii", playerid, 2);
        }
        case 2:
        {
            format(string, sizeof(string), "%s says: Anything you say can and will be used against you in a court of law.", GetRPName(playerid));
			SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
            SetTimerEx("showMirandaRights", 4000, false, "ii", playerid, 3);
        }
        case 3:
        {
            format(string, sizeof(string), "%s says: You have the right to to an attorney, If you can not afford one, one will be appointed for you.", GetRPName(playerid));
			SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
        }
	}
}

CMD:mir(playerid, params[])
{
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(IsLawEnforcement(playerid))
	{
	    SetTimerEx("showMirandaRights", 1000, false, "ii", playerid, 1);
	}
	return 1;
}

CMD:tazer(playerid, params[])
{
	if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
    if(PlayerInfo[playerid][pHurt] && PlayerInfo[playerid][pTazer] == 0)
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to pull out your tazer. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}
	if(!PlayerInfo[playerid][pTazer])
	{
	    PlayerInfo[playerid][pTazer] = 1;
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s reaches for their tazer gun.", GetRPName(playerid));

		GiveWeapon(playerid, 23, true);
  		SetPlayerArmedWeapon(playerid, WEAPON_SILENCED);
	}
	else
	{
	    PlayerInfo[playerid][pTazer] = 0;
		SetPlayerWeapons(playerid);

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s puts their tazer gun back in their duty belt.", GetRPName(playerid));

		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			SetPlayerArmedWeapon(playerid, WEAPON:PlayerInfo[playerid][pWeapons][2]);
		}
	}

	return 1;
}

CMD:cuff(playerid, params[])
{
	new targetid;
    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /cuff [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't cuff yourself.");
	}
	if(PlayerInfo[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already handcuffed.");
	}
	if(PlayerInfo[targetid][pTazedTime] == 0 && GetPlayerSpecialAction(targetid) != SPECIAL_ACTION_DUCK && GetPlayerAnimationIndex(targetid) != 1437)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player must either be tazed, crouched, or hands up.");
	}
	if(PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't handcuff an injured player.");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to cuff anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}

	if(PlayerInfo[targetid][pCallLine] != INVALID_PLAYER_ID)
	{
 		HangupCall(PlayerInfo[targetid][pCallLine], HANGUP_DROPPED);
	}

	PlayerInfo[targetid][pCuffed] = 1;
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
	TogglePlayerControllable(targetid, 0);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s tightens a pair of handcuffs around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
	GameTextForPlayer(targetid, "~r~Cuffed", 3000, 3);
	return 1;
}

CMD:uncuff(playerid, params[])
{
	new targetid;

    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_GOVERNMENT && PlayerInfo[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /uncuff [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid && PlayerInfo[playerid][pAdminDuty] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't uncuff yourself.");
	}
	if(!PlayerInfo[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not handcuffed.");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to uncuff anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}

	PlayerInfo[targetid][pCuffed] = 0;
 	PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;

	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(targetid, 1);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s loosens the pair of handcuffs from around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
	GameTextForPlayer(targetid, "~g~Uncuffed", 3000, 3);
	return 1;
}

CMD:testcarry(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /carry [playerid]");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't carry yourself.");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to carry anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}
	else
	{
	    PlayerInfo[targetid][pCarryOffer] = playerid;

	    SM(targetid, COLOR_AQUA, "** %s is attempting to carry you. (/accept carry)", GetRPName(playerid));
	    SM(playerid, COLOR_AQUA, "** You have sent a carry offer to %s.", GetRPName(targetid));
	}

	return 1;
}

CMD:carry(playerid, params[])
{
    new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /carry [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't carry yourself.");
	}
	if(PlayerInfo[targetid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The Player Is in Jail");
	}
	if(PlayerInfo[targetid][pDraggedBy] == INVALID_PLAYER_ID)
	{
		PlayerInfo[targetid][pDraggedBy] = playerid;
		TogglePlayerControllable(targetid, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs onto %s and begins to carry them.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
	    PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;
	    TogglePlayerControllable(targetid, 1);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s stops carrying %s.", GetRPName(playerid), GetRPName(targetid));
	}

	return 1;
}

CMD:drag(playerid, params[])
{
    new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drag [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't drag yourself.");
	}
	if(!PlayerInfo[targetid][pInjured] && !PlayerInfo[targetid][pCuffed] && !PlayerInfo[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not injured, handcuffed or tied.");
	}
	if(PlayerInfo[targetid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The Player Is in Jail");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to drag anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}

	if(PlayerInfo[targetid][pDraggedBy] == INVALID_PLAYER_ID)
	{
		PlayerInfo[targetid][pDraggedBy] = playerid;
		TogglePlayerControllable(targetid, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs onto %s and begins to drag them.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
	    PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;
	    TogglePlayerControllable(targetid, 1);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s stops dragging %s.", GetRPName(playerid), GetRPName(targetid));
	}

	return 1;
}

CMD:detain(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /detain [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't detain yourself.");
	}
	if(!PlayerInfo[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not handcuffed.");
	}
	if(IsPlayerInAnyVehicle(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already in a vehicle.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any vehicle.");
	}

	for(new i = (GetVehicleSeatCount(vehicleid) == 4) ? 2 : 1; i < GetVehicleSeatCount(vehicleid); i ++)
	{
	    if(!IsSeatOccupied(vehicleid, i))
	    {
			PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;
			PlayerInfo[targetid][pVehicleCount] = 0;

	        TogglePlayerControllable(targetid, 0);
	        PutPlayerInVehicle(targetid, vehicleid, i);

			SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws %s into their vehicle.", GetRPName(playerid), GetRPName(targetid));
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "There are no unoccupied back seats left. Find another vehicle.");
	return 1;
}

CMD:charge(playerid, params[])
{
	new targetid, reason[128];

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /charge [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't charge yourself.");
	}
	if(PlayerInfo[targetid][pWantedLevel] >= 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is already at the maximum wanted level (6).");
	}

	PlayerInfo[targetid][pWantedLevel]++;
	PlayerInfo[targetid][pCrimes]++;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = %i, crimes = %i WHERE uid = %i", PlayerInfo[targetid][pWantedLevel], PlayerInfo[targetid][pCrimes], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO charges VALUES(null, %i, '%s', NOW(), '%e')", PlayerInfo[targetid][pID], GetPlayerNameEx(playerid), reason);
	mysql_tquery(connectionID, queryBuffer);

    //format(string, sizeof(string), "Breaking News"WHITE": %s %s has charged %s with %s.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), reason);
	//SMA(COLOR_LIGHTGREEN, string);

	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has charged %s with "SVRCLR"%s{9999FF}. **", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), reason);
	SM(targetid, COLOR_LIGHTRED, "** Officer %s has charged you with %s.", GetRPName(playerid), reason);
	return 1;
}

CMD:arrest(playerid, params[])
{
	new string[128], targetid, minutes, fine;

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 1556.288208, -1677.866943, 22.942804))
	{
		PlayerGangZones[0] = SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, 1556.288208, -1677.866943, 22.942804, 0.0, 0.0, 0.0, 1);
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Goto Arrest Point");

	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "ui", targetid, minutes))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /arrest [playerid] [minutes (1-60)]");
	}
	
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't arrest yourself.");
	}
	if(!PlayerInfo[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not handcuffed.");
	}
	if(!PlayerInfo[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't arrest a player with no active charges. /charge to add them.");
	}

	for(new i = 0; i < sizeof(arrestPoints); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]))
	    {
	        if(minutes > 60)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot give more than 60 minutes prison time");
	        }
//	        minutes = PlayerInfo[targetid][pWantedLevel] * 10;
	        fine = PlayerInfo[targetid][pWantedLevel] * 200;

	        if(PlayerInfo[targetid][pVIPPackage] == 1)
			{
	            SM(targetid, COLOR_VIP, "** Donator perk: Your %i minutes of jail time has been reduced by 15 percent to %i minutes.", minutes, percent(minutes, 15));
	            minutes = percent(minutes, 85);
	        }
	        else if(PlayerInfo[targetid][pVIPPackage] == 2)
			{
	            SM(targetid, COLOR_VIP, "** Donator perk: Your %i minutes of jail time has been reduced by 30 percent to %i minutes.", minutes, percent(minutes, 30));
	            minutes = percent(minutes, 70);
	        }
	        else if(PlayerInfo[targetid][pVIPPackage] == 3)
			{
	            SM(targetid, COLOR_VIP, "** Donator perk: Your %i minutes of jail time has been reduced by 50 percent to %i minutes.", minutes, percent(minutes, 50));
	            minutes = percent(minutes, 50);
	        }

		    PlayerInfo[targetid][pJailType] = 3;
    		PlayerInfo[targetid][pJailTime] = minutes * 60;
			PlayerInfo[targetid][pWantedLevel] = 0;
			PlayerInfo[targetid][pArrested]++;

			SetPlayerInJail(targetid);
			GivePlayerCash(targetid, -fine);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 0, arrested = %i WHERE uid = %i", PlayerInfo[targetid][pArrested], PlayerInfo[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerInfo[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);

		    format(string, sizeof(string), "> News"WHITE": %s %s has completed their arrest. %s has been sent to jail for %i weeks.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), minutes);
			SMA(COLOR_LIGHTGREEN, string);

    		SM(targetid, COLOR_AQUA, "** You've been arrested for %i minutes, fine: $%i.", minutes, fine);
    		//Log_Write("log_faction", "%s (uid: %i) has arrested %s (uid: %i) for %i minutes, fine: $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], minutes, fine);
    		return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any arrest points.");
    return 1;
}

CMD:scfind(playerid, params[])
{
	new targetid;
 	if(GetFactionType(playerid) != FACTION_JAILGUARDS)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not part of the Supreme Court!");
 	}
 	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /scfind [playerid]");
	}
	if(PlayerInfo[playerid][pDetectiveCooldown] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds to use this command again.", PlayerInfo[playerid][pDetectiveCooldown]);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(GetPlayerInterior(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is an interior. You can't find them at the moment.");
	}
	if(PlayerInfo[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on an on-duty administrator.");
	}
 	PlayerInfo[playerid][pFindTime] = 20;
  	PlayerInfo[playerid][pDetectiveCooldown] = 28;
   	SetPlayerMarkerForPlayer(playerid, targetid, 0xFF0000FF);
	SM(playerid, COLOR_WHITE, "** %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerInfo[playerid][pFindTime]);
	PlayerInfo[playerid][pFindPlayer] = targetid;
	return 1;
}


CMD:dfind(playerid, params[])
{
	new targetid;
 	if(GetFactionType(playerid) != FACTION_GOVERNMENT && GetFactionType(playerid) != FACTION_FEDERAL && GetFactionType(playerid) != FACTION_NPOLICE)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not part of the Government or Federal Faction!");
 	}
 	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /dfind [playerid]");
	}
	if(PlayerInfo[playerid][pDetectiveCooldown] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds to use this command again.", PlayerInfo[playerid][pDetectiveCooldown]);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(GetPlayerInterior(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is an interior. You can't find them at the moment.");
	}
	if(PlayerInfo[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on an on-duty administrator.");
	}
 	PlayerInfo[playerid][pFindTime] = 20;
  	PlayerInfo[playerid][pDetectiveCooldown] = 28;
   	SetPlayerMarkerForPlayer(playerid, targetid, 0xFF0000FF);
	SM(playerid, COLOR_WHITE, "** %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerInfo[playerid][pFindTime]);
	PlayerInfo[playerid][pFindPlayer] = targetid;
	return 1;
}

CMD:hfind(playerid, params[])
{
	new targetid;
 	if(GetFactionType(playerid) != FACTION_HITMAN)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a hitman!");
 	}
 	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /hfind [playerid]");
	}
	if(PlayerInfo[playerid][pDetectiveCooldown] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds to use this command again.", PlayerInfo[playerid][pDetectiveCooldown]);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(GetPlayerInterior(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player is an interior. You can't find them at the moment.");
	}
	if(PlayerInfo[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on an on-duty administrator.");
	}
 	PlayerInfo[playerid][pFindTime] = 20;
  	PlayerInfo[playerid][pDetectiveCooldown] = 28;
   	SetPlayerMarkerForPlayer(playerid, targetid, 0xFF0000FF);
	SM(playerid, COLOR_WHITE, "** %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerInfo[playerid][pFindTime]);
	PlayerInfo[playerid][pFindPlayer] = targetid;
	return 1;
}

CMD:find(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_SYNTAX, "This command is disabled due to reports of metagaming and other shits.");
}

CMD:robplayer(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_SYNTAX, "This command has been disabled.");
}

CMD:frisk(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SM(playerid, COLOR_SYNTAX, "Usage: /frisk [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(IsLawEnforcement(playerid) || PlayerInfo[playerid][pDuty] == 0)
	{
	    FriskPlayer(playerid, targetid);
	}
	else
	{
	    PlayerInfo[targetid][pFriskOffer] = playerid;

	    SM(targetid, COLOR_AQUA, "** %s is attempting to frisk you for illegal items. (/accept frisk)", GetRPName(playerid));
	    SM(playerid, COLOR_AQUA, "** You have sent a frisk offer to %s.", GetRPName(targetid));
	}

	return 1;
}

CMD:take(playerid, params[])
{
	new targetid, option[14];

    if(!IsLawEnforcement(playerid) && !IsGovernment(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "us[14]", targetid, option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /take [playerid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapons, Pot, Crack, Meth, Painkillers, CarLicense");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: DirtyCash, GunLicense, Materials");
		return 1;
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
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
	else if(!strcmp(option, "crack", true))
	{
	    if(!PlayerInfo[targetid][pCrack])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no Crack on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's Crack.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i grams of Crack.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of Crack.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pCrack]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
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
	else if(!strcmp(option, "meth", true))
	{
	    if(!PlayerInfo[targetid][pMeth])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no meth on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's meth.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i grams of meth.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of meth.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pMeth]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[targetid][pMeth] = 0;
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(!PlayerInfo[targetid][pPainkillers])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has no painkillers on them.");
		}

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes away %s's painkillers.", GetRPName(playerid), GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has taken your %i painkillers.", GetRPName(playerid), PlayerInfo[targetid][pPot]);
        //Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i painkillers.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pPainkillers]);

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

CMD:ticket(playerid, params[])
{
	new targetid, amount, reason[128];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "uis[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ticket [playerid] [amount] [reason]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't ticket yourself.");
	}
	if(!(10 <= amount <= 500))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The ticket amount must range between $10 and $500.");
	}

	PlayerInfo[targetid][pTicketOffer] = playerid;
	PlayerInfo[targetid][pTicketPrice] = amount;

	SM(targetid, COLOR_AQUA, "** %s writes you a $%i ticket for %s. (/accept ticket)", GetRPName(playerid), amount, reason);
	SM(playerid, COLOR_AQUA, "** You have offered a $%i ticket to %s for %s.", amount, GetRPName(targetid), reason);
	return 1;
}

CMD:gov(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any faction at the moment.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gov [text]");
	}

	switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
	{
	    case FACTION_MEDIC:
	    {
	        SMA(COLOR_WHITE, "---------- * Public Service Announcement * ----------");
	        SMA(COLOR_DOCTOR, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_POLICE:
		{
	        SMA(COLOR_WHITE, "---------- * Public Service Announcement * ----------");
	        SMA(COLOR_BLUE, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
        case FACTION_GOVERNMENT:
		{
	        SMA(COLOR_WHITE, "---------- * Government News Announcement * ----------");
	        SMA(COLOR_YELLOW2, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_FEDERAL:
		{
	        SMA(COLOR_WHITE, "---------- * Public Service Announcement * ----------");
	        SMA(COLOR_ROYALBLUE, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_MECHANIC:
		{
	        SMA(COLOR_WHITE, "---------- * Mechanic Service Announcement * ----------");
	        SMA(COLOR_GREEN, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_TERRORIST:
		{
	        SMA(COLOR_WHITE, "---------- * Terrorist Announcement * ----------");
	        SMA(COLOR_RED, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_ARMY:
		{
	        SMA(COLOR_WHITE, "---------- * Army Announcement * ----------");
	        SMA(COLOR_DARKGREEN, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_JAILGUARDS:
		{
	        SMA(COLOR_WHITE, "---------- * DOC Announcement * ----------");
	        SMA(COLOR_JAILGUARD, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		case FACTION_NPOLICE:
		{
	        SMA(COLOR_WHITE, "---------- * Public Service Announcement * ----------");
	        SMA(COLOR_BLUE, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Your faction is not authorized to use this command.");
		}
	}

	return 1;
}

CMD:ram(playerid, params[])
{
	new id;

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
		{
		    if((id = GetInsideHouse(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[id][hID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_opened FROM furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		 		mysql_tquery(connectionID, queryBuffer, "OnPlayerRamFurnitureDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
		}
	}

	if((id = GetNearbyHouse(playerid)) >= 0)
	{
	    if(!HouseInfo[id][hLocked])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This house is unlocked. You don't need to ram the door.");
		}

		HouseInfo[id][hLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = 0 WHERE id = %i", HouseInfo[id][hID]);
		mysql_tquery(connectionID, queryBuffer);

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s rams down %s's house door.", GetRPName(playerid), HouseInfo[id][hOwner]);
	}
	else if((id = GetNearbyBusiness(playerid)) >= 0)
	{
	    if(!BusinessInfo[id][bLocked])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This business is unlocked. You don't need to ram the door.");
		}

		BusinessInfo[id][bLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = 0 WHERE id = %i", BusinessInfo[id][bID]);
		mysql_tquery(connectionID, queryBuffer);

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s rams down %s's business door.", GetRPName(playerid), BusinessInfo[id][bOwner]);
	}
	else if((id = GetNearbyGarage(playerid)) >= 0)
	{
	    if(!GarageInfo[id][gLocked])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This garage is unlocked. You don't need to ram the door.");
		}

		GarageInfo[id][gLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = 0 WHERE id = %i", GarageInfo[id][gID]);
		mysql_tquery(connectionID, queryBuffer);

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s rams down %s's garage door.", GetRPName(playerid), GarageInfo[id][gOwner]);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any door which can be rammed.");
	}

	return 1;
}

CMD:deploy(playerid, params[])
{
	new type[12], type_id = -1, Float:x, Float:y, Float:z, Float:a;

    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "s[12]", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /deploy [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Spikestrip, Cone, Roadblock, Barrel, Flare");
	    return 1;
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't deploy objects inside.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	if(!strcmp(type, "spikestrip", true)) {
	    type_id = DEPLOY_SPIKESTRIP;
	} else if(!strcmp(type, "cone", true)) {
		type_id = DEPLOY_CONE;
	} else if(!strcmp(type, "roadblock", true)) {
	    type_id = DEPLOY_ROADBLOCK;
	} else if(!strcmp(type, "barrel", true)) {
	    type_id = DEPLOY_BARREL;
	} else if(!strcmp(type, "flare", true)) {
	    type_id = DEPLOY_FLARE;
	}

	if(type_id == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}
	if(DeployObject(type_id, x, y, z, a) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The deployable objects pool is full. Try deleting some first.");
	}

	if(IsLawEnforcement(playerid))
		SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));
	else
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_DOCTOR, "HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));

	return 1;
}

CMD:undeployall(playerid, params[])
{
	if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

	for(new i = 0; i < MAX_DEPLOYABLES; i ++)
	{
		if(DeployInfo[i][dExists])
	 	{
			DestroyDynamicObject(DeployInfo[i][dObject]);
			DeployInfo[i][dExists] = 0;
   			DeployInfo[i][dType] = -1;
		}
	}
	SendFactionMessage(PlayerInfo[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_ROYALBLUE) : (COLOR_DOCTOR), "HQ: %s %s has removed all deployed objects.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
	return 1;
}

CMD:undeploy(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

    for(new i = 0; i < MAX_DEPLOYABLES; i ++)
    {
        if(DeployInfo[i][dExists])
        {
            new Float:range;

            if(DeployInfo[i][dType] == DEPLOY_SPIKESTRIP || DeployInfo[i][dType] == DEPLOY_BARREL || DeployInfo[i][dType] == DEPLOY_FLARE || DeployInfo[i][dType] == DEPLOY_CONE) {
                range = 2.0;
            } else if(DeployInfo[i][dType] == DEPLOY_ROADBLOCK) {
                range = 5.0;
            }

        	if(IsPlayerInRangeOfPoint(playerid, range, DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]))
        	{
      	  		SendFactionMessage(PlayerInfo[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_ROYALBLUE) : (COLOR_DOCTOR), "HQ: %s %s has removed a %s in %s.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), deployableItems[DeployInfo[i][dType]], GetZoneName(DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]));
				DestroyDynamicObject(DeployInfo[i][dObject]);

        	    DeployInfo[i][dExists] = 0;
        	    DeployInfo[i][dType] = -1;
        	    return 1;
			}
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any deployed objects.");
	return 1;
}
CMD:gbk(playerid, params[])
{
	return callcmd::gbackup(playerid, params);
}
CMD:gbackup(playerid, params[])
{
    if(PlayerInfo[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot call for backup when you are dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
 		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed.");
	}
	if(PlayerInfo[playerid][pTied])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}
	if(!PlayerInfo[playerid][pBackup])
	{
        PlayerInfo[playerid][pBackup] = 1;
	}
	else
	{
	    PlayerInfo[playerid][pBackup] = 0;
	}

	foreach(new i : Player)
	{
        if(PlayerInfo[i][pGang] == PlayerInfo[playerid][pGang])
        {
    	    if(PlayerInfo[playerid][pBackup])
    	    {
    	        SM(i, COLOR_AQUA, "** %s %s is requesting backup in %s (marked on map). **", GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
    	        SetPlayerMarkerForPlayer(i, playerid, (GangInfo[PlayerInfo[playerid][pGang]][gColor] & ~0xff) + 0xFF);
			}
			else
			{
    	        SM(i, COLOR_AQUA, "** %s %s has cancelled their backup request. **", GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid));
                SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));

				
			}
		}
	}

	return 1;
}

CMD:bk(playerid, params[])
{
	return callcmd::backup(playerid, params);
}

CMD:backup(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}

	if(!PlayerInfo[playerid][pBackup])
	{
        PlayerInfo[playerid][pBackup] = 1;

        if(GetFactionType(playerid) != FACTION_MEDIC)
	        SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s is requesting backup in %s (marked on map).", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
		else
		    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_DOCTOR, "HQ: %s %s is requesting backup in %s (marked on map).", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
	}
	else
	{
	    PlayerInfo[playerid][pBackup] = 0;

	    if(GetFactionType(playerid) != FACTION_MEDIC)
	        SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has cancelled their backup request.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
	    else
			SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_DOCTOR, "HQ: %s %s has cancelled their backup request.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid));
	}

    foreach(new i : Player)
	{
        if(PlayerInfo[playerid][pLogged])
		{
  			if(PlayerInfo[playerid][pBackup])
    			SetPlayerMarkerForPlayer(i, playerid, (FactionInfo[PlayerInfo[playerid][pFaction]][fColor] & ~0xff) + 0xFF);
			else
   				SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
		}
    }

	return 1;
}

CMD:mdc(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && !IsGovernment(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a government or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if((!IsPlayerInRangeOfPoint(playerid, 50.0, 1229.3544, -1311.8627, 796.7859)) && !(596 <= GetVehicleModel(GetPlayerVehicleID(playerid)) <= 599) && GetVehicleModel(GetPlayerVehicleID(playerid)) != 415 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 490)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside a police car or the police station.");
	}

	ShowPlayerDialog(playerid, DIALOG_MDC, DIALOG_STYLE_LIST, "Mobile data computer", "Wanted suspects\nPlayer lookup\nVehicle lookup", "Select", "Cancel");
	return 1;
}

CMD:clearwanted(playerid, params[])
{
    new targetid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /clearwanted [playerid]");
	}
	if((!IsPlayerInRangeOfPoint(playerid, 50.0, 1229.3544, -1311.8627, 796.7859)) && !(596 <= GetVehicleModel(GetPlayerVehicleID(playerid)) <= 599))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside a police car or the police station.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't clear yourself.");
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
	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has cleared %s's charges and wanted level.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:vticket(playerid, params[])
{
 	new amount, vehicleid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vticket [amount]");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!(100 <= amount <= 1500))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount must range from $100 to $1500.");
	}
	if(VehicleInfo[vehicleid][vTickets] >= 100000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has over $100000 in tickets. You can't add anymore.");
	}

	VehicleInfo[vehicleid][vTickets] += amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s writes up a $%i ticket and attaches it to the %s.", GetRPName(playerid), amount, GetVehicleName(vehicleid));
	return 1;
}

CMD:siren(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:x, Float:y, Float:z, Float:tmp;

    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleHasWindows(vehicleid))
	{
 		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle cannot have a siren attached to it.");
	}

	if(!IsValidDynamicObject(vehicleSiren[vehicleid]))
	{
	    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, z, z, z);
		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, tmp);

		vehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(vehicleSiren[vehicleid], vehicleid, -x, y, z / 1.9, 0.0, 0.0, 0.0);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s places a detachable siren on the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    DestroyDynamicObject(vehicleSiren[vehicleid]);
	    vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s detaches the siren from the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:vfrisk(playerid, params[])
{
    new vehicleid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}

    new count;

    for(new i = 0; i < 3; i ++)
    {
        if(VehicleInfo[vehicleid][vWeapons][i])
        {
            count++;
        }
    }

    SendClientMessage(playerid, SERVER_COLOR, "Trunk Balance:");
    SM(playerid, COLOR_GREY2, "Cash: $%i/$%i | Tickets: %i ", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH), VehicleInfo[vehicleid][vTickets]);
	SM(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
    SM(playerid, COLOR_GREY2, "Pot: %i/%i grams | Crack: %i/%i grams", VehicleInfo[vehicleid][vPot], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCrack], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
    SM(playerid, COLOR_GREY2, "Meth: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vMeth], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_METH), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));
    //SendClientMessage(playerid, SERVER_COLOR, "Trunk Ammunition:");
	SM(playerid, COLOR_GREY2, "HP Ammo: %i/%i | Poison Ammo: %i/%i", VehicleInfo[vehicleid][vHPAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HPAMMO), VehicleInfo[vehicleid][vPoisonAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_POISONAMMO));
    SM(playerid, COLOR_GREY2, "FMJ Ammo: %i/%i", VehicleInfo[vehicleid][vFMJAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_FMJAMMO));
	SM(playerid, SERVER_COLOR, "Vehicle Info:");
	SM(playerid, COLOR_GREY2, "Vehicle Plate: %s | Vehicle Owner: %s | Vehicle Gang: %s | Vehicle Faction: %s", VehicleInfo[vehicleid][vPlate], VehicleInfo[vehicleid][vOwner], GangInfo[VehicleInfo[vehicleid][vGang]][gName], FactionInfo[VehicleInfo[vehicleid][vFactionType]][fType]);
	if(count > 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "Trunk Weapons:");

    	for(new i = 0; i < 3; i ++)
        {
            if(VehicleInfo[vehicleid][vWeapons][i])
	        {
    	        SM(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
			}
		}
    }

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s prys open the trunk of the %s and takes a look inside.", GetRPName(playerid), GetVehicleName(vehicleid));
	return 1;
}

CMD:vtake(playerid, params[])
{
    new vehicleid, option[14];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "s[14]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vtake [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapons, Ammo, Pot, Crack, Meth, Painkillers");
	    return 1;
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}

	if(!strcmp(option, "weapons", true))
	{
        VehicleInfo[vehicleid][vWeapons][0] = 0;
        VehicleInfo[vehicleid][vWeapons][1] = 0;
        VehicleInfo[vehicleid][vWeapons][2] = 0;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_1 = 0, weapon_2 = 0, weapon_3 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the weapons from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessage(playerid, COLOR_AQUA, "You have taken the weapons from the trunk.");
	}
	else if(!strcmp(option, "ammo", true))
	{
        VehicleInfo[vehicleid][vHPAmmo] = 0;
		VehicleInfo[vehicleid][vPoisonAmmo] = 0;
		VehicleInfo[vehicleid][vFMJAmmo] = 0;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET hpammo = 0, poisonammo = 0, fmjammo = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the ammunition from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessage(playerid, COLOR_AQUA, "You have taken the ammunition from the trunk.");
	}
	else if(!strcmp(option, "pot", true))
	{
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the pot from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SM(playerid, COLOR_AQUA, "You have taken the %i grams of pot from the trunk.", VehicleInfo[vehicleid][vPot]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pot = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vPot] = 0;
	}
	else if(!strcmp(option, "crack", true))
	{
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the Crack from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SM(playerid, COLOR_AQUA, "You have taken the %i grams of Crack from the trunk.", VehicleInfo[vehicleid][vCrack]);
		
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET crack = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vCrack] = 0;
	}
	else if(!strcmp(option, "meth", true))
	{
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the meth from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SM(playerid, COLOR_AQUA, "You have taken the %i grams of meth from the trunk.", VehicleInfo[vehicleid][vMeth]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET meth = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vMeth] = 0;
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes the painkillers from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SM(playerid, COLOR_AQUA, "You have taken the %i painkillers from the trunk.", VehicleInfo[vehicleid][vPainkillers]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vPainkillers] = 0;
	}

	return 1;
}

CMD:firstaid(playerid, params[])
{
	new targetid;

    if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1597.648559, 1528.162475, 3001.765869))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of ambulance interior.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /firstaid [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't heal yourself.");
	}
	if(PlayerInfo[targetid][pFirstAid])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player already has first aid effects.");
	}

	PlayerInfo[targetid][pFirstAid] = 1;
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s administers first aid to %s.", GetRPName(playerid), GetRPName(targetid));

	SM(targetid, COLOR_AQUA, "You have received first aid from %s. Your health will now regenerate until full.", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "You have administered first aid to %s.", GetRPName(targetid));
	return 1;
}

CMD:stretcher(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stretcher [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(!PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not injured.");
	}
	if(IsPlayerInAnyVehicle(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already in a vehicle.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) != 416 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 490)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be driving an ambulance.");
	}

	for(new i = 2; i < GetVehicleSeatCount(vehicleid); i ++)
	{
	    if(!IsSeatOccupied(vehicleid, i))
	    {
	        PlayerInfo[targetid][pVehicleCount] = 0;
	        PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;

	        ClearAnimations(targetid, SYNC_ALL);
	        ApplyAnimationEx(targetid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0);

	        TogglePlayerControllable(targetid, 0);
	        PutPlayerInVehicle(targetid, vehicleid, i);

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s places %s on a stretcher in the Ambulance.", GetRPName(playerid), GetRPName(targetid));
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "There are no unoccupied seats left. Find another vehicle.");
	return 1;
}

CMD:listpt(playerid, params[])
{
	if(GetFactionType(playerid) != FACTION_MEDIC)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	SendClientMessage(playerid, COLOR_GREEN, "Injured - (/injuries):");
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pInjured])
		{
		    new accepted[24];
		    if(IsPlayerConnected(PlayerInfo[i][pAcceptedEMS]))
		    {
				accepted = GetRPName(PlayerInfo[i][pAcceptedEMS]);
		    }
		    else
		    {
		        accepted = "None";
		    }
		    SM(playerid, COLOR_SYNTAX, "Name: %s - Location: %s - Medic: %s", GetRPName(i), GetPlayerZoneName(i), accepted);
		}
	}
	SendClientMessage(playerid, COLOR_AQUA, "Use /getpt [playerid] to track them!");
	return 1;
}

CMD:heal(playerid, params[])
{
	new targetid;

    if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /heal [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't heal yourself.");
	}
	if(PlayerInfo[targetid][pFirstAid])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This player already has first aid effects.");
	}

	PlayerInfo[targetid][pFirstAid] = 1;
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s administers first aid to %s.", GetRPName(playerid), GetRPName(targetid));

	SM(targetid, COLOR_AQUA, "You have received first aid from %s. Your health will now regenerate until full.", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "You have administered first aid to %s.", GetRPName(targetid));
	return 1;
}

CMD:getpt(playerid, params[])
{
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetFactionType(playerid) == FACTION_MEDIC)
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getpt [playerid]");
		}
		if(IsPlayerConnected(targetid))
		{
		    if(targetid == playerid)
		    {
		        SendClientMessage(playerid, COLOR_AQUA, "You can't accept your own Emergency Dispatch call!");
				return 1;
		    }
		    if(!PlayerInfo[targetid][pInjured])
		    {
		        SendClientMessage(playerid, COLOR_SYNTAX, "That person is not injured!");
		        return 1;
		    }
			if(!IsPlayerConnected(PlayerInfo[targetid][pAcceptedEMS]))
			{
				if(PlayerInfo[targetid][pJailTime] > 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on jailed players.");
				SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_DOCTOR, "EMS Driver %s has accepted the Emergency Dispatch call for %s.", GetRPName(playerid), GetRPName(targetid));
				SM(playerid, COLOR_AQUA, "* You have accepted EMS Call from %s, you will see the marker until you have reached it.", GetRPName(targetid));
				SM(targetid, COLOR_AQUA, "* EMS Driver %s has accepted your EMS Call; please be patient as they are on the way!", GetPlayerNameEx(playerid));
				PlayerInfo[targetid][pAcceptedEMS] = playerid;
				GameTextForPlayer(playerid, "~w~EMS Caller~n~~r~Go to the red marker.", 5000, 1);
                PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
                new Float:ppos[3];
				GetPlayerPosEx(targetid, ppos[0], ppos[1], ppos[2]);
	    		SetPlayerCheckpoint(playerid, ppos[0],ppos[1],ppos[2], 3.0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "Someone has already accepted that call!");
			}
		}
	}
	return 1;
}

CMD:loadpt(playerid, params[]) { return callcmd::stretcher(playerid, params); }
CMD:movept(playerid, params[]) { return callcmd::drag(playerid, params); }

CMD:injuries(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
    if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /injuries [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT weaponid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerListInjuries", "ii", playerid, targetid);
	return 1;
}

CMD:news(playerid, params[])
{
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a news reporter.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /news [text]");
	}
	foreach(new i : Player)
	{
		if(!PlayerInfo[playerid][pToggleNews])
		{
 			SM(i, 0x489348FF, "** %s %s: %s", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:cctv(playerid, params[])
{
	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /cctv [on/off]");
	}
	else if(!strcmp(params, "on", true))
	{
		PlayerMenu[playerid] = 0;
		TogglePlayerControllable(playerid, 0);
		ShowMenuForPlayer(CCTVMenu[0], playerid);
	}
	else if(!strcmp(params, "off", true))
	{
		if(CurrentCCTV[playerid] > -1)
		{
			SetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
			SetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
			SetPlayerInterior(playerid, LastPos[playerid][LInterior]);
			TogglePlayerControllable(playerid, true);
			KillTimer(KeyTimer[playerid]);
			SetCameraBehindPlayer(playerid);
			TextDrawHideForPlayer(playerid, TD);
			CurrentCCTV[playerid] = -1;
		}
	}
	return 1;
}

CMD:live(playerid, params[])
{
	new targetid;

    if(GetFactionType(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a news reporter.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /live [playerid]");
	}
	if(PlayerInfo[playerid][pLiveMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are banned from live interviews. Ask a higher rank to lift your ban.");
	}
	if(PlayerInfo[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already doing a live interview. /endlive to finish it.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't interview yourself.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(PlayerInfo[targetid][pLiveMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is banned from live interviews.");
	}
	if(PlayerInfo[targetid][pCallLine] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is on a phone call at the moment.");
	}

	PlayerInfo[targetid][pLiveOffer] = playerid;

	SM(targetid, COLOR_AQUA, "** %s offered you a live interview. (/accept live)", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have offered %s a live interview.", GetRPName(targetid));
	return 1;
}

CMD:endlive(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a news reporter.");
	}
    if(PlayerInfo[playerid][pLiveBroadcast] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently not doing a live interview.");
	}

	SendClientMessage(playerid, COLOR_AQUA, "You have ended the live interview.");
	SM(PlayerInfo[playerid][pLiveBroadcast], COLOR_AQUA, "%s has ended the live interview.", GetRPName(playerid));

	PlayerInfo[PlayerInfo[playerid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
	return 1;
}

CMD:liveban(playerid, params[])
{
	new targetid;

    if(GetFactionType(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a news reporter.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /liveban [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}

	if(!PlayerInfo[targetid][pLiveMuted])
	{
		if(PlayerInfo[targetid][pLiveBroadcast] != INVALID_PLAYER_ID)
		{
	    	PlayerInfo[PlayerInfo[targetid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
	    	PlayerInfo[targetid][pLiveBroadcast] = INVALID_PLAYER_ID;
		}

		PlayerInfo[targetid][pLiveMuted] = 1;
		SM(targetid, COLOR_LIGHTRED, "%s has banned you from live interviews.", GetPlayerNameEx(playerid));
		SM(playerid, COLOR_AQUA, "You have banned %s from live interviews.", GetPlayerNameEx(targetid));
	}
	else
	{
	    PlayerInfo[targetid][pLiveMuted] = 0;
		SM(targetid, COLOR_YELLOW, "%s has unbanned you from live interviews.", GetPlayerNameEx(playerid));
		SM(playerid, COLOR_AQUA, "You have unbanned %s from live interviews.", GetPlayerNameEx(targetid));
	}

	return 1;
}

CMD:settax(playerid, params[])
{
	new string[128], amount;

	if(GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of government.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /settax [rate]");
	}
	if(!(10 <= amount <= 90))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The tax percentage must range from 10 to 90.");
	}

	gTax = amount;
	SaveServerInfo();

	format(string, sizeof(string), "Breaking News"WHITE": Mayor changed the income tax rate to %i percent.", amount);
	SMA(COLOR_LIGHTGREEN, string);

	SAM(COLOR_YELLOW, "AdmWarning: %s has adjusted the income tax rate to %i percent.", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "You have set the income tax rate to %i percent.", amount);
	return 1;
}

CMD:factionpay(playerid, params[])
{
	new factionid;

	if(GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of government.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /factionpay [factionid] (Use /factions for list.)");
	}
	if(!(1 <= factionid < MAX_FACTIONS) || !FactionInfo[factionid][fType])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");
	}
	if(FactionInfo[factionid][fType] == FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't set the paychecks for hitman factions.");
	}

	PlayerInfo[playerid][pFactionEdit] = factionid;
	ShowDialogToPlayer(playerid, DIALOG_FACTIONPAY1);
	return 1;
}

CMD:taxwithdraw(playerid, params[])
{
	new amount, reason[64];

    if(GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of government.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(sscanf(params, "is[64]", amount, reason))
	{
	    return SM(playerid, COLOR_WHITE, "USAGE /taxwithdraw [amount] [reason] ($%i available)", gVault);
	}
	if(amount < 1 || amount > gVault)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	AddToTaxVault(-amount);
	GivePlayerCash(playerid, amount);

	SM(playerid, COLOR_AQUA, "** You have withdrawn $%i from the tax vault. The new balance is $%i.", amount, gVault);
	SAM(COLOR_YELLOW, "AdmWarning: %s has withdrawn $%i from the tax vault, reason: %s", GetRPName(playerid), amount, reason);
	return 1;
}

CMD:taxdeposit(playerid, params[])
{
	new amount;

    if(GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of government.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SM(playerid, COLOR_WHITE, "USAGE /taxdeposit [amount] ($%i available)", gVault);
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	AddToTaxVault(amount);
	GivePlayerCash(playerid, -amount);

	SM(playerid, COLOR_AQUA, "** You have deposited $%i in the tax vault. The new balance is $%i.", amount, gVault);
	SAM(COLOR_YELLOW, "AdmWarning: %s has deposited $%i in the tax vault.", GetRPName(playerid), amount);
	//Log_Write("log_faction", "%s (uid: %i) has deposited $%i in the tax vault.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount);
	return 1;
}

CMD:contract(playerid, params[])
{
	new targetid, amount, reason[64];

	if(sscanf(params, "iis[64]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /contract [playerid] [amount] [reason]");
	}
	if(PlayerInfo[playerid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least level 3+ to contract players.");
	}
	if(GetFactionType(playerid) == FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are a hitman and therefore can't contract other players.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't contract yourself.");
	}
	if(PlayerInfo[targetid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can only contract level 3+ players.");
	}
	if(!(100000 <= amount <= 500000))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount must range from $100000 to $500000.");
	}
	if(PlayerInfo[playerid][pCash] < amount)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much money.");
	}
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}

	foreach(new i : Player)
	{
	    if(GetFactionType(i) == FACTION_HITMAN)
	    {
	        SM(i, COLOR_YELLOW, "** %s has contracted %s for $%i, reason: %s [/contracts]", GetRPName(playerid), GetRPName(targetid), amount, reason);
		}
	}

	GivePlayerCash(playerid, -amount);

	PlayerInfo[targetid][pContracted] += amount;
	GetPlayerName(playerid, PlayerInfo[targetid][pContractBy], MAX_PLAYER_NAME);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET contracted = %i, contractby = '%e' WHERE uid = %i", PlayerInfo[targetid][pContracted], PlayerInfo[targetid][pContractBy], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "You have placed a contract on %s for $%i, reason: %s", GetRPName(targetid), amount, reason);
	SAM(COLOR_YELLOW, "AdmWarning: %s placed a contract on %s for $%i, reason: %s", GetRPName(playerid), GetRPName(targetid), amount, reason);
 	//Log_Write("log_contracts", "%s (uid: %i) placed a contract on %s (uid: %i) for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], amount, reason);
 	return 1;
}

CMD:contracts(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_HITMAN && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Pending Contracts:");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pContracted] > 0)
	    {
	        SM(playerid, COLOR_GREY2, "ID: %i | Target: %s | Bounty price: $%i | Last contracter: %s", i, GetRPName(i), PlayerInfo[i][pContracted], PlayerInfo[i][pContractBy]);
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "** Use /takehit [id] or /denyhit [id] to handle contracts.");
	return 1;
}

CMD:denyhit(playerid, params[])
{
	new targetid;

	if(GetFactionType(playerid) != FACTION_HITMAN && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /denyhit [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pContracted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't been contracted.");
	}

    SAM(COLOR_LIGHTRED, "AdmCmd: %s has cancelled the contract on %s for $%i.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pContracted]);

	if(GetFactionType(playerid) == FACTION_HITMAN)
	{
		SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_YELLOW, "** Hitman %s has cancelled the contract on %s for $%i. **", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pContracted]);
	}

	PlayerInfo[targetid][pContracted] = 0;
    strcpy(PlayerInfo[targetid][pContractBy], "Pending", MAX_PLAYER_NAME);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET contracted = 0, contractby = 'Pending' WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:knife(playerid, params)
{
    if(GetFactionType(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
    else
    {
        GivePlayerWeaponEx(playerid, 4);
        SendClientMessage(playerid, COLOR_YELLOW, "Hitman: You have received knife");
    }
    return 1;
}
CMD:takehit(playerid, params[])
{
	new targetid;

	if(GetFactionType(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /takehit [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(!PlayerInfo[targetid][pContracted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't been contracted.");
	}

	PlayerInfo[playerid][pContractTaken] = targetid;
	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_YELLOW, "** Hitman %s has accepted the contract to kill %s for $%i. **", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pContracted]);
	SM(playerid, COLOR_AQUA, "You have taken the hit. You will receive $%i once you have assassinated "SVRCLR"%s{CCFFFF}.", PlayerInfo[targetid][pContracted], GetRPName(targetid));
	return 1;
}

CMD:mask(playerid)
{
	if(!PlayerInfo[playerid][pMask])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Mask.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pTied] > 0 ||  PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pAdminDuty]) return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this while on admin duty.");

	if(Maskara[playerid] == 0)
	{

		if(PlayerInfo[playerid][pTagType] == TAG_NORMAL)
		{
		 	SetPlayerSpecialTag(playerid, TAG_MASK);
		}
		Maskara[playerid] = 1;
		MaskaraID[playerid] = playerid;
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s puts on his/her mask.", GetRPName(playerid));
		ApplyAnimationEx(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
		SetPlayerAttachedObject(playerid, 3, 19801, 2, 0.091000, 0.012000, -0.000000, 0.099999, 87.799957, 179.500015, 1.345999, 1.523000, 1.270001, 0, 0);
	}
	else
	{
		if(PlayerInfo[playerid][pTagType] == TAG_MASK)
		{
		 	SetPlayerSpecialTag(playerid, TAG_NORMAL);
		}
	   	Maskara[playerid] = 0;
	   	MaskaraID[playerid] = 0;
     	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Stranger takes off his/her mask.");
     	ApplyAnimationEx(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
	}
	return 1;
}

CMD:masked(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) {
		new string[128], name[MAX_PLAYER_NAME+1];
		foreach(new i : Player)
		{
			if(IsPlayerConnected(i))
			{
				if(Maskara[i] == 1)
				{
					GetPlayerName(i, name, sizeof(name));
					format(string, sizeof(string),"%s %s (%d)\n", string, name, MaskaraID[i]);
				}
			}
		}
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

CMD:propose(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /propose [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 3.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(PlayerInfo[playerid][pCash] < 3000000 || PlayerInfo[targetid][pCash] < 3000000)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You both need to have atleast $3,000,000 to have a wedding.");
	}
	if(PlayerInfo[playerid][pMarriedTo] != -1)
	{
	    return SM(playerid, COLOR_SYNTAX, "You're already married to %s.", PlayerInfo[playerid][pMarriedName]);
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't marry yourself faggot.");
	}
	PlayerInfo[targetid][pMarriageOffer] = playerid;

	SM(targetid, COLOR_AQUA, "** %s has asked you to marry them, Please be careful when chosing a partner, It will cost both parties $750. (/accept marriage)", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have sent %s a proposal for marriage.", GetRPName(targetid));
	return 1;
}

CMD:divorce(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /divorce [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 3.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(PlayerInfo[playerid][pMarriedTo] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't even married.");
	}
	if(PlayerInfo[playerid][pMarriedTo] != PlayerInfo[targetid][pID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't married to that person.");
	}
	PlayerInfo[targetid][pMarriageOffer] = playerid;

	SM(targetid, COLOR_AQUA, "** %s has asked you to divorce them (/accept divorce)", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have sent %s a request for divorce.", GetRPName(targetid));
	return 1;
}

CMD:profile(playerid, params[])
{
    new targetid;

	if(GetFactionType(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /profile [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, SERVER_COLOR, "%s:", GetRPName(targetid));
	SM(playerid, COLOR_GREY2, "Gender: %s", (PlayerInfo[targetid][pGender] == 2) ? ("Female") : ("Male"));
	SM(playerid, COLOR_GREY2, "Age: %i years old", PlayerInfo[targetid][pAge]);

	if(PlayerInfo[targetid][pFaction] != -1)
	{
	    SM(playerid, COLOR_GREY2, "Faction: %s", FactionInfo[PlayerInfo[targetid][pFaction]][fName]);
	    SM(playerid, COLOR_GREY2, "Rank: %s (%i)", FactionRanks[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pFactionRank]], PlayerInfo[targetid][pFactionRank]);
	}
	else
	{
	    SM(playerid, COLOR_GREY2, "Faction: None");
	}

	if(PlayerInfo[targetid][pContracted] > 0)
	{
		SM(playerid, COLOR_GREY2, "Contract: $%i", PlayerInfo[targetid][pContracted]);
		SM(playerid, COLOR_GREY2, "Last Contracter: %s", PlayerInfo[targetid][pContractBy]);
	}

	SM(playerid, COLOR_GREY2, "Completed Hits: %i", PlayerInfo[targetid][pCompletedHits]);
	SM(playerid, COLOR_GREY2, "Failed Hits: %i", PlayerInfo[targetid][pFailedHits]);
	return 1;
}

CMD:createlocker(playerid, params[])
{
	new factionid, Float:x, Float:y, Float:z;

    if(PlayerInfo[playerid][pAdmin] < 6 && !PlayerInfo[playerid][pFactionMod])
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createlocker [factionid]");
	}
    if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

    GetPlayerPos(playerid, x, y, z);

	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
		if(!LockerInfo[i][lExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionlockers (factionid, pos_x, pos_y, pos_z, interior, world) VALUES(%i, '%f', '%f', '%f', %i, %i)", factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateLocker", "iiifffii", playerid, i, factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Locker slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editlocker(playerid, params[])
{
	new lockerid, option[32], param[32];

	if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pFactionMod])
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[32]S()[32]", lockerid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [option]");
		SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Position, FactionID, Icon, Label, Uniform");
		return 1;
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}
    if(!strcmp(option, "position", true))
    {
		GetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
		LockerInfo[lockerid][lInterior] = GetPlayerInterior(playerid);
		LockerInfo[lockerid][lWorld] = GetPlayerVirtualWorld(playerid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET pos_x = '%f', pos_y = '%f', pos_z = '%f', interior = %i, world = %i WHERE id = %i", LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], LockerInfo[lockerid][lInterior], LockerInfo[lockerid][lWorld], LockerInfo[lockerid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SCMf(playerid, COLOR_AQUA, "* You have moved locker %i to your position.", lockerid);
		ReloadLocker(lockerid);
	}
	else if(!strcmp(option, "factionid", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SCMf(playerid, COLOR_SYNTAX, "USAGE: /editlocker [%i] [%s] [value]", lockerid, option);
		}
	    LockerInfo[lockerid][lFaction] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET factionid = %i WHERE id = %i", LockerInfo[lockerid][lFaction], LockerInfo[lockerid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SCMf(playerid, COLOR_AQUA, "* You set locker %i's faction to %i.", lockerid, value);
		ReloadLocker(lockerid);
	}
	else if(!strcmp(option, "icon", true))
	{
	    new iconid;

	    if(sscanf(param, "i", iconid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [icon] [iconid (19300 = hide)]");
		}
		if(!IsValidModel(iconid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
		}

		LockerInfo[lockerid][lIcon] = iconid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET iconid = %i WHERE id = %i", LockerInfo[lockerid][lIcon], LockerInfo[lockerid][lID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadLocker(lockerid);
	    SCMf(playerid, COLOR_AQUA, "* You've changed the pickup icon model of locker %i to %i.", lockerid, iconid);
	}
	else if(!strcmp(option, "label", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [label] [0/1]");
		}

		LockerInfo[lockerid][lLabel] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET label = %i WHERE id = %i", LockerInfo[lockerid][lLabel], LockerInfo[lockerid][lID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadLocker(lockerid);

		if(status)
		    SCMf(playerid, COLOR_AQUA, "* You've enabled the 3D text label for locker %i.", lockerid);
		else
		    SCMf(playerid, COLOR_AQUA, "* You've disabled the 3D text label for locker %i.", lockerid);
	}
	else if(!strcmp(option, "uniform", true))
	{
	    if(FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FACTION_HITMAN)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Weapons for hitman agency lockers cannot be edited in-game.");
	    }

		SendClientMessage(playerid, COLOR_SYNTAX, "use the command /editfaction skin for the uniforms!");
	}
	return 1;
}
CMD:removelocker(playerid, params[])
{
	new lockerid;

	if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pFactionMod])
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", lockerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelocker [lockerid]");
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}

	DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
	DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionlockers WHERE id = %i", LockerInfo[lockerid][lID]);
	mysql_tquery(connectionID, queryBuffer);

	LockerInfo[lockerid][lExists] = 0;
	LockerInfo[lockerid][lID] = 0;

	SCMf(playerid, COLOR_AQUA, "* You have removed locker %i.", lockerid);
	return 1;
}

CMD:gotolocker(playerid, params[])
{
	new lockerid;

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}

	if(sscanf(params, "i", lockerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotolocker [lockerid]");
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}
	GameTextForPlayer(playerid,"~w~Teleported", 5000, 1);


	SetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
	SetPlayerInterior(playerid, LockerInfo[lockerid][lInterior]);
	SetPlayerVirtualWorld(playerid, LockerInfo[lockerid][lWorld]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:passport(playerid, params[])
{
	new name[24], level, skinid;

    if(PlayerInfo[playerid][pPassport])
	{
  		Namechange(playerid, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPassportName]);
  		SetScriptSkin(playerid, PlayerInfo[playerid][pPassportSkin]);
		SendClientMessage(playerid, COLOR_AQUA, "You have burned your passport and received your old name, clothes, level and number back.");

		PlayerInfo[playerid][pLevel] = PlayerInfo[playerid][pPassportLevel];
		PlayerInfo[playerid][pPhone] = PlayerInfo[playerid][pPassportPhone];
		PlayerInfo[playerid][pPassport] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET passport = 0, passportname = 'None', passportlevel = 0, passportskin = 0, passportphone = 0, level = %i, phone = %i WHERE uid = %i", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}

	if(GetFactionType(playerid) != FACTION_HITMAN && GetFactionType(playerid) != FACTION_FEDERAL && GetFactionType(playerid) != FACTION_GOVERNMENT && GetFactionType(playerid) != FACTION_NPOLICE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman or federal agent or Government Agent.");
	}
	if(sscanf(params, "s[24]ii", name, level, skinid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /passport [name] [level] [skinid]");
	}
	if(!(3 <= strlen(name) <= 20))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your name must range from 3 to 20 characters.");
	}
	if(strfind(name, "_") == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your name needs to contain at least one underscore.");
	}
	if(!IsValidName(name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid characters. Your name may only contain letters and underscores.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't allowed to change your name while on admin duty,");
	}
	if(!(1 <= level <= 10))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your level must range from 1 to 10.");
	}
	if(!(1 <= skinid <= 311))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The skin ID must range from 1 to 311.");
	}
	if(!isnull(PlayerInfo[playerid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have already requested a namechange. Please wait for a response.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnHitmanPassport", "isii", playerid, name, level, skinid);
	return 1;
}
CMD:vfind(playerid, params[])
{
      FindNearestLowHealthVehicle(playerid);
      return 1;
}
forward FindNearestLowHealthVehicle(playerid);
public FindNearestLowHealthVehicle(playerid)
{
    new Float:playerPos[3];
    GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

    new nearestVehicle = INVALID_VEHICLE_ID;

    new vehicleid;
    for(vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        // Check if the vehicle is streamed in
        if(!IsVehicleStreamedIn(vehicleid, playerid)) continue;

        // Initialize vehiclePos with zeroes
        new Float:vehiclePos[3] = {0.0, 0.0, 0.0};

        // Retrieve the vehicle position
        if(!GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]))
        {
            continue; // Skip to the next vehicle if position retrieval fails
        }
        new
				Float:health;
        GetVehicleHealth(vehicleid,health);
        // Check if the vehicle's health is below 600 and the player is in range
        if(health < 600.0 && IsPlayerInRangeOfPoint(playerid, 50.0, vehiclePos[0], vehiclePos[1], vehiclePos[2]))
        {
            nearestVehicle = vehicleid;
        }
    }

    if(nearestVehicle != INVALID_VEHICLE_ID)
    {
        SetVehicleCheckpoint(playerid, nearestVehicle);
        SendClientMessage(playerid, -1, "Nearest Damaged vehicle marked.");
    }
    else
    {
        SendClientMessage(playerid, -1, "No Damaged Vehicle Nearby.");
    }
}

forward SetVehicleCheckpoint(playerid, vehicleid);
public SetVehicleCheckpoint(playerid, vehicleid)
{
    new Float:pos[3];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 3);
}
CMD:plantbomb(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
	if(!PlayerInfo[playerid][pBombs])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any bombs.");
	}
	if(PlayerInfo[playerid][pPlantedBomb])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have planted a bomb already.");
	}
    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't plant a bomb inside.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't plant a bomb while inside of a vehicle");
	}

	GetPlayerPos(playerid, PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ]);
    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);

	PlayerInfo[playerid][pPlantedBomb] = 1;
	PlayerInfo[playerid][pBombObject] = CreateDynamicObject(19602, PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ] - 1.0, 0.0, 0.0, 0.0);
	PlayerInfo[playerid][pBombs]--;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bombs = %i WHERE uid = %i", PlayerInfo[playerid][pBombs], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessage(playerid, COLOR_WHITE, "** Bomb has been planted, use /detonate to make it go BOOM!");
	return 1;
}

CMD:pickupbomb(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
	if(!PlayerInfo[playerid][pPlantedBomb])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent planted a bomb which you can pickup.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of your planted bomb.");
	}

    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
	DestroyDynamicObject(PlayerInfo[playerid][pBombObject]);

    PlayerInfo[playerid][pBombObject] = INVALID_OBJECT_ID;
	PlayerInfo[playerid][pPlantedBomb] = 0;
	PlayerInfo[playerid][pBombs]++;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bombs = %i WHERE uid = %i", PlayerInfo[playerid][pBombs], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessage(playerid, COLOR_WHITE, "** You have picked up your bomb.");
	return 1;
}

CMD:detonate(playerid, params[])
{
	if(!PlayerInfo[playerid][pPlantedBomb])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent planted a bomb which you can detonate.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are too far away from your planted bomb.");
	}

	CreateExplosion(PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ], 11, 10.0);
    DestroyDynamicObject(PlayerInfo[playerid][pBombObject]);

	if(PlayerInfo[playerid][pContractTaken] != INVALID_PLAYER_ID && IsPlayerInRangeOfPoint(PlayerInfo[playerid][pContractTaken], 10.0, PlayerInfo[playerid][pBombX], PlayerInfo[playerid][pBombY], PlayerInfo[playerid][pBombZ]))
	{
	    SetPlayerHealth(PlayerInfo[playerid][pContractTaken], 0.0);
	    HandleContract(PlayerInfo[playerid][pContractTaken], playerid);
	}

    PlayerInfo[playerid][pBombObject] = INVALID_OBJECT_ID;
	PlayerInfo[playerid][pPlantedBomb] = 0;

	SendClientMessage(playerid, COLOR_WHITE, "** You have detonated your bomb!");
	return 1;
}
CMD:dump(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SM(playerid, COLOR_SYNTAX, "This command can only be used every 6 minutes. Please wait %i more seconds.", 359 - (gettime() - gLastSave));
	}
	Profiler_Dump();
	return 1;
}
CMD:saveall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SM(playerid, COLOR_SYNTAX, "This command can only be used every 6 minutes. Please wait %i more seconds.", 359 - (gettime() - gLastSave));
	}
	foreach(new i : Player)
	{
	    SavePlayerVariables(i);
	    SM(i, COLOR_LIGHTRED, "AdmCmd: %s has saved all player accounts.", GetRPName(playerid));
	}
	gLastSave = gettime();
	return 1;
}
CMD:forcesave(playerid, params[]) return callcmd::saveall(playerid, params);
CMD:adestroyboombox(playerid, params[])
{
	new boomboxid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if((boomboxid = GetNearbyBoombox(playerid)) == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no boombox in range.");
	}

	SM(playerid, COLOR_AQUA, "You have destroyed "SVRCLR"%s{CCFFFF}'s boombox.", GetRPName(boomboxid));
	DestroyBoombox(boomboxid);

	return 1;
}

CMD:setbanktimer(playerid, params[])
{
	new hours;

    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", hours))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setbanktimer [hours]");
	}
	if(hours < 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Hours can't be below 0.");
	}

	RobberyInfo[rTime] = hours;
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the bank robbery timer to %i hours.", GetRPName(playerid), hours);
	return 1;
}
CMD:resetactiverobbery(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	ResetRobbery();
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the active bank robbery.", GetRPName(playerid));
	return 1;
}
CMD:resetrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	RobberyInfo[rTime] = 0;
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the bank robbery timer.", GetRPName(playerid));
	return 1;
}

CMD:resetrobbiz(playerid, params[])
{
	new businessid;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", businessid))
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Usage: /resetrobbiz [businessid]");
	    return 1;
	}
	BusinessInfo[businessid][bRobbed] = 0;
	BusinessInfo[businessid][bRobbing] = 0;
	ReloadBusiness(businessid);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET robbed = %i, robbing = %i WHERE id = %i", BusinessInfo[businessid][bRobbed], BusinessInfo[businessid][bRobbing], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset business (ID: %d) the business robbery timer.", GetRPName(playerid), businessid);
	return 1;
}
CMD:givepayday(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givepayday [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SendPaycheck(targetid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has forced a payday for %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:givepveh(playerid, params[])
{
	new model[20], modelid, targetid, color1, color2, Float:x, Float:y, Float:z, Float:a;

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[20]ii", targetid, model, color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givepveh [playerid] [modelid/name] [color1] [color2]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if((modelid = GetVehicleModelByName(model)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid vehicle model.");
	}
	if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid color. Valid colors range from 0 to 255.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, color1, color2) VALUES(%i, '%s', %i, '%f', '%f', '%f', '%f', %i, %i)", PlayerInfo[targetid][pID], GetPlayerNameEx(targetid), modelid, x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a, color1, color2);
	mysql_tquery(connectionID, queryBuffer);

	SM(targetid, COLOR_AQUA, "%s has given you your own "SVRCLR"%s{CCFFFF}. /vstorage to spawn it.", GetRPName(playerid), vehicleNames[modelid - 400]);
	SM(playerid, COLOR_AQUA, "You have given %s their own "SVRCLR"%s{CCFFFF}.", GetRPName(targetid), vehicleNames[modelid - 400]);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %s their own %s.", GetRPName(playerid), GetRPName(targetid), vehicleNames[modelid - 400]);
	return 1;
}

CMD:givedoublexp(playerid, params[])
{
	new targetid, hours;

    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, hours))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givedoublexp [playerid] [hours]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(hours < 1 && PlayerInfo[targetid][pDoubleXP] - hours < 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player can't have under 0 hours of double XP.");
	}

	PlayerInfo[targetid][pDoubleXP] += hours;

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given %i hours of double XP to %s.", GetRPName(playerid), hours, GetRPName(targetid));
	SM(targetid, COLOR_YELLOW, "%s has given you %i hours of double XP.", GetRPName(playerid), hours);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET doublexp = %i WHERE uid = %i", PlayerInfo[targetid][pDoubleXP], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:randomfire(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(IsFireActive())
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a fire active already. /killfire to kill it!");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	RandomFire(0);

	GetDynamicObjectPos(gFireObjects[0], x, y, z);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has started a random fire in %s.", GetRPName(playerid), GetZoneName(x, y, z));
	return 1;
}

CMD:killfire(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!IsFireActive())
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is currently no fire active.");
	}

	for(new i = 0; i < MAX_FIRES; i ++)
	{
	    DestroyDynamicObject(gFireObjects[i]);
	    gFireObjects[i] = INVALID_OBJECT_ID;
	    gFireHealth[i] = 0.0;
	}

	gFires = 0;
	SendClientMessage(playerid, COLOR_SYNTAX, "Active fire killed.");
	return 1;
}

CMD:spawnfire(playerid, params[])
{
	new Float:px, Float:py, Float:pz;

    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't create fires indoors.");
	}

	for(new x = 0; x < MAX_FIRES; x ++)
	{
	    if(gFireObjects[x] == INVALID_OBJECT_ID)
	    {
	        GetPlayerPos(playerid, px, py, pz);

	        if(!IsFireActive())
	        {
	            foreach(new i : Player)
	            {
	                if(GetFactionType(i) == FACTION_MEDIC)
	                {
	            		PlayerInfo[i][pCP] = CHECKPOINT_MISC;
               			SetPlayerCheckpoint(i, px, py, pz, 3.0);
		   				SM(i, COLOR_DOCTOR, "** All units, a fire has been reported in %s. Please head to the beacon on your map. **", GetZoneName(px, py, pz));
					}
	            }
	        }

	        gFireObjects[x] = CreateDynamicObject(18691, px, py, pz - 2.4, 0.0, 0.0, 0.0, .streamdistance = 50.0);
	        gFireHealth[x] = 50.0;
			gFires++;

			return SendClientMessage(playerid, COLOR_SYNTAX, "Fire created!");
		}
	}

	SM(playerid, COLOR_SYNTAX, "You can't create anymore fires. The limit is %i fires.", MAX_FIRES);
	return 1;
}
CMD:radiochat(playerid)
{
    new string[2048], status[128], statuss[128];
    strcat(string, "Channel\tToggle\tDescription");
    if(PlayerInfo[playerid][pFactionRadio] == 0)
    {
    	status = "{ff0000}OFF{FFFFFF}";
    }
    else
    {
    	status = "{009900}ON{FFFFFF}";
    }
    if(PlayerInfo[playerid][pGangRadio] == 0)
    {
    	statuss = "{ff0000}OFF{FFFFFF}";
    }
    else
    {
    	statuss = "{009900}ON{FFFFFF}";
    }
    format(string, sizeof(string), "%s\nFaction Radio\t%s\tRadio Channel for your faction\
		\nGang Radio\t%s\tRadio Channel for your Gang.", string, status, statuss);
    ShowPlayerDialog(playerid, DIALOG_RADIOCHAT, DIALOG_STYLE_TABLIST_HEADERS, "Voice Chat Setup", string, "Toggle", "Close");
    return 1;
}
CMD:radiosv(playerid)
{
    new string[2048], status[128];
    strcat(string, "Channel\tToggle\tDescription");
    if(PlayerInfo[playerid][pRadioUse] == 0)
    {
    	status = "{ff0000}OFF{FFFFFF}";
    }
    else
    {
    	status = "{009900}ON{FFFFFF}";
    }
    format(string, sizeof(string), "%s\nPublic Radio\t%s\t Channel 1 - 30", string, status);
    ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_TABLIST_HEADERS, "Voice Chat Setup", string, "Toggle", "Close");
    return 1;
}
CMD:number(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /number [playerid]");
	}
	if(!PlayerInfo[playerid][pPhonebook])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a phonebook.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, COLOR_GREY2, "(Name): %s, (Ph): %i", GetRPName(targetid), PlayerInfo[targetid][pPhone]);
	return 1;
}

CMD:boombox(playerid, params[])
{
	new option[10], param[128];

	if(!PlayerInfo[playerid][pBoombox])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no boombox and therefore can't use this command.");
	}
	if(sscanf(params, "s[10]S()[128]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /boombox [place | pickup | play]");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command from within the vehicle.");
	}

	if(!strcmp(option, "place", true))
	{
	    if(PlayerInfo[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have placed down a boombox already.");
	    }
	    if(GetNearbyBoombox(playerid) != INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is already a boombox nearby. Place this one somewhere else.");
        }

		new
		    Float:x,
	    	Float:y,
	    	Float:z,
	    	Float:a,
			string[128];

		format(string, sizeof(string), "Boombox placed by:\n"SVRCLR"%s{F7A763}\n/boombox for more options.", GetPlayerNameEx(playerid));

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

	    PlayerInfo[playerid][pBoomboxPlaced] = 1;
    	PlayerInfo[playerid][pBoomboxObject] = CreateDynamicObject(2102, x, y, z - 1.0, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    	PlayerInfo[playerid][pBoomboxText] = CreateDynamic3DTextLabel(string, COLOR_LIGHTORANGE, x, y, z - 0.8, 10.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid));
        PlayerInfo[playerid][pBoomboxURL] = 0;

    	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s places a boombox on the ground.", GetRPName(playerid));
	}
	else if(!strcmp(option, "pickup", true))
	{
	    if(!PlayerInfo[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have not placed down a boombox.");
	    }
	    if(!IsPlayerInRangeOfDynamicObject(playerid, PlayerInfo[playerid][pBoomboxObject], 3.0))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of your boombox.");
		}

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s picks up their boombox and switches it off.", GetRPName(playerid));
		DestroyBoombox(playerid);
	}
    else if(!strcmp(option, "play", true))
	{
        if(!PlayerInfo[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have not placed down a boombox.");
	    }
	    if(!IsPlayerInRangeOfDynamicObject(playerid, PlayerInfo[playerid][pBoomboxObject], 3.0))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of your boombox.");
		}

    	PlayerInfo[playerid][pMusicType] = MUSIC_BOOMBOX;
    	ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
	}

	return 1;
}

CMD:switchspeedo(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /switchspeedo [kmh/mph]");
	}
	else if(!strcmp(params, "kmh", true))
	{
		PlayerInfo[playerid][pSpeedometer] = 1;
		SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as "SVRCLR"Kilometers per hour{CCFFFF}.");

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET speedometer = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "mph", true))
	{
		PlayerInfo[playerid][pSpeedometer] = 2;
		SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as "SVRCLR"Miles per hour{CCFFFF}.");

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET speedometer = 2 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

CMD:shakehand(playerid, params[])
{
	new targetid, type;

	if(sscanf(params, "ui", targetid, type))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /shakehand [playerid] [type (1-6)]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't shake your own hand.");
	}
	if(!(1 <= type <= 6))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type. Valid types range from 1 to 6.");
	}

	PlayerInfo[targetid][pShakeOffer] = playerid;
	PlayerInfo[targetid][pShakeType] = type;

	SM(targetid, COLOR_AQUA, "** %s has offered to shake your hand. (/accept handshake)", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have sent %s a handshake offer.", GetRPName(targetid));
	return 1;
}
// Function to get the weapon UID based on the weapon the player is holding
GetWeaponUID(playerid)
{
    // Get the current weapon the player is holding
    new weaponid = GetScriptWeapon(playerid);

    // Loop through all weapons stored in WeaponInfo
    for (new i = 0; i < MAX_WEAPONS; i++)
    {     // Check if the weaponid matches
        if (WeaponInfo[i][wWeaponId] == weaponid && WeaponInfo[i][wOwnerID] == PlayerInfo[playerid][pID])
        {
			printf("%i",i);
            return i; 
			// Return the UID (index) if a match is found
        }
    }

    return -1; // Return -1 if no matching weapon is found
}

CMD:dropgun(playerid, params[])
{
	new weaponid = GetScriptWeapon(playerid);
	new objectid, Float:x, Float:y, Float:z;

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be onfoot in order to drop weapons.");
	}
	if(!weaponid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the weapon you're willing to drop.");
	}
    if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(GetHealth(playerid) < 60)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't drop weapons as your health is below 60.");
	}

	GetPlayerPos(playerid, x, y, z);

	objectid = CreateDynamicObject(weaponModelIDs[weaponid], x, y, z - 1.0, 93.7, 93.7, 120.0);

	Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_WEAPON);
	Streamer_SetExtraInt(objectid, E_OBJECT_WEAPONID, weaponid);
	Streamer_SetExtraInt(objectid, E_OBJECT_FACTION, PlayerInfo[playerid][pFaction]);
	Streamer_SetExtraInt(objectid, 	E_OBJECT_WEAPONINDEX, GetWeaponUID(playerid));
	
	RemovePlayerWeaponEx(playerid, weaponid);


	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s drops their %s on the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	SM(playerid, COLOR_AQUA, "You have dropped your "SVRCLR"%s{CCFFFF}.", GetWeaponNameEx(weaponid));
	return 1;
}

CMD:pickupgun(playerid, params[]) return callcmd::grabgun(playerid, params);
CMD:grabgun(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be onfoot in order to pickup weapons.");
	}
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
    if(PlayerInfo[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are either weapon restricted or you played less than two playing hours.");
    }

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
	    if(!IsValidDynamicObject(i) || !IsPlayerInRangeOfDynamicObject(playerid, i, 2.0) || Streamer_GetExtraInt(i, E_OBJECT_TYPE) != E_OBJECT_WEAPON)
			continue;

	    if(Streamer_GetExtraInt(i, E_OBJECT_FACTION) >= 0 && PlayerInfo[playerid][pFaction] != Streamer_GetExtraInt(i, E_OBJECT_FACTION))
	    {
			new index = Streamer_GetExtraInt(i, E_OBJECT_WEAPONINDEX);
	        SCMf(playerid, COLOR_SYNTAX, "This weapon belongs to %s. You may not pick it up.",WeaponInfo[index][wOwner]);
	    }

	    new weaponid = Streamer_GetExtraInt(i, E_OBJECT_WEAPONID);

	    GiveWeapon(playerid, weaponid);
	    DestroyDynamicObject(i);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s picks up a %s from the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SM(playerid, COLOR_AQUA, "You have picked up a %s.", GetWeaponNameEx(weaponid));
	    return 1;
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any dropped weapons.");
	return 1;
}
CMD:buygun(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1301.185913, -1875.214599, 13.632812))	return 1;
	ShowPlayerDialog(playerid, DIALOG_GUNSHOP, DIALOG_STYLE_LIST, "Gunshop", "Shotgun ($50,000)\nSilentPistol ($35,000)\n9mm ($25, 000)\nMp5 ($95,000)\nVest ($5000)\nHelmet ($5000)\nParachute ($20000)", "Buy", "Cancel");
	return 1;
}
CMD:createland(playerid, params[])
{
	new price;

    if(PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "i", price))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createland [price]");
	}
	if(price < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $500,000.");
	}
	if(GetNearbyLand(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a land in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create lands indoors.");
	}

	PlayerInfo[playerid][pLandCost] = price;
	PlayerInfo[playerid][pZoneType] = ZONETYPE_LAND;
	ShowPlayerDialog(playerid, DIALOG_CREATEZONE, DIALOG_STYLE_MSGBOX, "Land System", "You have entered land creation mode. In order to create a land you need\nto mark four points around the area you want your land to be in, forming\na square. You must make a square or your outcome won't be as expected.\n\nPress "SVRCLR"Confirm{A9C4E4} to set the land spawn.", "Confirm", "Cancel");
	return 1;
}

CMD:confirm(playerid, params[])
{
	new Float:x, Float:y, Float:z;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pZoneCreation])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not creating any land or turf at the moment.");
	}

    if(PlayerInfo[playerid][pMinX] == 0.0)
	{
        GetPlayerPos(playerid, PlayerInfo[playerid][pMinX], y, z);
        PlayerInfo[playerid][pZonePickups][0] = CreateDynamicPickup(1239, 1, PlayerInfo[playerid][pMinX], y, z, .playerid = playerid);
		SendClientMessage(playerid, COLOR_WHITE, "** Boundary 1/4 set (min X).");
	}
	else if(PlayerInfo[playerid][pMinY] == 0.0)
	{
        GetPlayerPos(playerid, x, PlayerInfo[playerid][pMinY], z);
        PlayerInfo[playerid][pZonePickups][1] = CreateDynamicPickup(1239, 1, x, PlayerInfo[playerid][pMinY], z, .playerid = playerid);
        SendClientMessage(playerid, COLOR_WHITE, "** Boundary 2/4 set (min Y).");
	}
	else if(PlayerInfo[playerid][pMaxX] == 0.0)
	{
        GetPlayerPos(playerid, PlayerInfo[playerid][pMaxX], y, z);
        PlayerInfo[playerid][pZonePickups][2] = CreateDynamicPickup(1239, 1, PlayerInfo[playerid][pMaxX], y, z, .playerid = playerid);
        SendClientMessage(playerid, COLOR_WHITE, "** Boundary 3/4 set (max X).");
	}
	else if(PlayerInfo[playerid][pMaxY] == 0.0)
	{
        GetPlayerPos(playerid, x, PlayerInfo[playerid][pMaxY], z);
        SendClientMessage(playerid, COLOR_WHITE, "** Boundary 4/4 set (max Y).");

        PlayerInfo[playerid][pZonePickups][3] = CreateDynamicPickup(1239, 1, x, PlayerInfo[playerid][pMaxY], z, .playerid = playerid);
        PlayerInfo[playerid][pZoneID] = GangZoneCreate(PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY]);

        GangZoneShowForPlayer(playerid, PlayerInfo[playerid][pZoneID], 0x33CC33FF);

        if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_LAND) {
	        ShowPlayerDialog(playerid, DIALOG_CONFIRMZONE, DIALOG_STYLE_MSGBOX, "Land System", "You have set the four boundary points. The green zone on your mini-map\nrepresents the area of your land. You can choose to start over or complete\nthe creation of your land.\n\nWhat would you like to do now?", "Create", "Restart");
		} else if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_TURF) {
	        ShowPlayerDialog(playerid, DIALOG_CONFIRMZONE, DIALOG_STYLE_MSGBOX, "Turf System", "You have set the four boundary points. The green zone on your mini-map\nrepresents the area of your turf. You can choose to start over or complete\nthe creation of your turf.\n\nWhat would you like to do now?", "Create", "Restart");
		}
		else if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_POINT) {
	        ShowPlayerDialog(playerid, DIALOG_CONFIRMZONE, DIALOG_STYLE_MSGBOX, "Point System", "You have set the four boundary points. The green zone on your mini-map\nrepresents the area of your Point. You can choose to start over or complete\nthe creation of your point.\n\nWhat would you like to do now?", "Create", "Restart");
		}
	}

	return 1;
}

CMD:landcancel(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(PlayerInfo[playerid][pZoneCreation] != ZONETYPE_LAND)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not creating a land at the moment.");
	}

	CancelZoneCreation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTRED, "** Land creation cancelled.");
	return 1;
}

CMD:gotoland(playerid, params[])
{
	new landid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotoland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid land.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, LandInfo[landid][lX], LandInfo[landid][lY], LandInfo[landid][lZ]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:removelandobjects(playerid, params[])
{
	new landid;

    if (PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removelandobjects [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid land.");
	}

	RemoveAllLandObjects(landid);
    SM(playerid, COLOR_AQUA, "** You have removed all land objects for land %i.", landid);
	return 1;
}

CMD:removeland(playerid, params[])
{
	new landid;

    if (PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removeland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid land.");
	}
	RemoveAllLandObjects(landid);

	GangZoneDestroy(LandInfo[landid][lGangZone]);
	DestroyDynamicArea(LandInfo[landid][lArea]);
	DestroyDynamic3DTextLabel(LandInfo[landid][lText]);
	DestroyDynamicPickup(LandInfo[landid][lPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM lands WHERE id = %i", LandInfo[landid][lID]);
	mysql_tquery(connectionID, queryBuffer);

	LandInfo[landid][lID] = 0;
	LandInfo[landid][lExists] = 0;
	LandInfo[landid][lOwnerID] = 0;

    SM(playerid, COLOR_AQUA, "** You have removed land %i.", landid);
	return 1;
}

CMD:buyland(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any lands.");
    }
    if(LandInfo[landid][lOwnerID] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "This land is already owned.");
	}
    if(strcmp(params, "confirm", true))
    {
        return SM(playerid, COLOR_SYNTAX, "Usage: /buyland [confirm] (This land costs $%i.)", LandInfo[landid][lPrice]);
	}
	if(PlayerInfo[playerid][pCash] < LandInfo[landid][lPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this land.");
	}

    SetLandOwner(landid, playerid);
	GivePlayerCash(playerid, -LandInfo[landid][lPrice]);

	SM(playerid, COLOR_YELLOW, "You paid $%i for this land! /landhelp to see the available commands for your land.", LandInfo[landid][lPrice]);
	//Log_Write("log_property", "%s (uid: %i) purchased a land (id: %i) in %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], LandInfo[landid][lID], GetPlayerZoneName(playerid), LandInfo[landid][lPrice]);
	return 1;
}

CMD:sellland(playerid, params[])
{
	new landid = GetNearbyLand(playerid), targetid, amount;

    if(landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any lands of yours.");
    }
    if(sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellland [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must specify an amount above zero.");
	}

	PlayerInfo[targetid][pLandOffer] = playerid;
	PlayerInfo[targetid][pLandOffered] = landid;
	PlayerInfo[targetid][pLandPrice] = amount;

	SM(targetid, COLOR_AQUA, "** %s offered you to buy their land for $%i. (/accept land)", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "** You offered %s to buy your land for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:sellmyland(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any lands of yours.");
    }
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellmyland [confirm]");
	    SM(playerid, COLOR_WHITE, "This command sells your land back to the state. You will receive $%i back.", percent(LandInfo[landid][lPrice], 75));
	    return 1;
	}

	SetLandOwner(landid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(LandInfo[landid][lPrice], 75));

	SM(playerid, COLOR_YELLOW, "You have sold your land to the state and received $%i back.", percent(LandInfo[landid][lPrice], 75));
    //Log_Write("log_property", "%s (uid: %i) sold their land (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], LandInfo[landid][lID], percent(LandInfo[landid][lPrice], 75));
	return 1;
}

CMD:landinfo(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any lands.");
    }

    if(!LandInfo[landid][lOwnerID])
	{
        SM(playerid, COLOR_WHITE, "** This land is currently not owned and is for sale, price: "SVRCLR"$%i"WHITE".", LandInfo[landid][lPrice]);
	}
	else if(!IsLandOwner(playerid, landid))
	{
	    SM(playerid, COLOR_WHITE, "** This land is owned by %s.", LandInfo[landid][lOwner]);
	}
	else
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
    	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LAND_INFORMATION, playerid);
	}

	return 1;
}

CMD:land(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of a land.");
    }
    if(!HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to build in this land.");
	}

	ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
	return 1;
}

CMD:mp3(playerid, params[])
{
	if(!PlayerInfo[playerid][pMP3Player])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have an MP3 player.");
	}

	PlayerInfo[playerid][pMusicType] = MUSIC_MP3PLAYER;
	ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
	return 1;
}

CMD:setradio(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in any vehicle.");
	}

	PlayerInfo[playerid][pMusicType] = MUSIC_VEHICLE;
	ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
	return 1;
}

CMD:acceptname(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /acceptname [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(isnull(PlayerInfo[targetid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested a namechange.");
	}
	if(PlayerInfo[targetid][pFreeNamechange] == 0 && PlayerInfo[targetid][pCash] < PlayerInfo[targetid][pLevel] * 7500)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player can't afford the namechange.");
	}

	new cost = PlayerInfo[targetid][pLevel] * 5000;

	if(PlayerInfo[targetid][pFreeNamechange])
	{
	    if(PlayerInfo[targetid][pFreeNamechange] == 2 && (GetFactionType(targetid) == FACTION_HITMAN || GetFactionType(targetid) == FACTION_FEDERAL || GetFactionType(targetid) == FACTION_GOVERNMENT || GetFactionType(targetid) == FACTION_NPOLICE))
	    {
	        GetPlayerName(targetid, PlayerInfo[targetid][pPassportName], MAX_PLAYER_NAME);

	        PlayerInfo[targetid][pPassport] = 1;
	        PlayerInfo[targetid][pPassportLevel] = PlayerInfo[targetid][pLevel];
	        PlayerInfo[targetid][pPassportSkin] = PlayerInfo[targetid][pSkin];
	        PlayerInfo[targetid][pPassportPhone] = PlayerInfo[targetid][pPhone];
			PlayerInfo[targetid][pLevel] = PlayerInfo[targetid][pChosenLevel];
			PlayerInfo[targetid][pSkin] = PlayerInfo[targetid][pChosenSkin];
			PlayerInfo[targetid][pPhone] = random(100000) + 899999;

			SetPlayerSkin(targetid, PlayerInfo[targetid][pSkin]);
			//Log_Write("log_faction", "%s (uid: %i) used the /passport command to change their name to %s, level to %i and skin to %i.", GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange], PlayerInfo[targetid][pLevel], PlayerInfo[targetid][pSkin]);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET level = %i, skin = %i, phone = %i, passport = 1, passportname = '%s', passportlevel = %i, passportskin = %i, passportphone = %i WHERE uid = %i", PlayerInfo[targetid][pLevel], PlayerInfo[targetid][pSkin], PlayerInfo[targetid][pPhone], PlayerInfo[targetid][pPassportName], PlayerInfo[targetid][pPassportLevel], PlayerInfo[targetid][pPassportSkin], PlayerInfo[targetid][pPassportPhone], PlayerInfo[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
	    }

		//Log_Write("log_admin", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange]);
		//Log_Write("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange]);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's free namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pNameChange]);
		SM(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for free.", PlayerInfo[targetid][pNameChange]);
		if(!PlayerInfo[playerid][pLogged])
		{
  			ShowDialogToPlayer(targetid, DIALOG_REGISTER);
		}
		if(PlayerInfo[targetid][pFreeNamechange] == 2)
		{
		    SendClientMessage(targetid, COLOR_WHITE, "** You can use /passport again to return to your old name and stats.");
		}
	}
	else
	{
	    //Log_Write("log_admin", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange], cost);
		//Log_Write("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange], cost);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's namechange to %s for %s.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pNameChange], FormatNumber(cost));
		SM(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for %s.", PlayerInfo[targetid][pNameChange], FormatNumber(cost));

        GivePlayerCash(targetid, -cost);
	}
	Namechange(targetid, GetPlayerNameEx(targetid), PlayerInfo[targetid][pNameChange]);
	PlayerInfo[targetid][pNameChange] = 0;
	PlayerInfo[targetid][pFreeNamechange] = 0;
	
    new szstring[129];
	format(szstring, 129 ,"[SYSTEM]: "WHITE"  %s has accepted %s's namechange to %s for %s.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pNameChange], FormatNumber(cost));
	SendDiscordMessage(2, szstring);
	return 1;
}

CMD:denyname(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /denyname [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(isnull(PlayerInfo[targetid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't requested a namechange.");
	}

	if(PlayerInfo[targetid][pFreeNamechange])
	{
	    ShowPlayerDialog(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
	}

    //Log_Write("log_admin", "%s (uid: %i) denied %s's (uid: %i) namechange to %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], PlayerInfo[targetid][pNameChange]);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has denied %s's namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pNameChange]);
	SM(targetid, COLOR_LIGHTRED, "Your namechange request to %s was denied.", PlayerInfo[targetid][pNameChange]);

	PlayerInfo[targetid][pNameChange] = 0;
	PlayerInfo[targetid][pFreeNamechange] = 0;
	
	new szstring[129];
	format(szstring, 129 , "AdmCmd: %s has denied %s's namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerInfo[targetid][pNameChange]);
	SendDiscordMessage(2, szstring);
	return 1;
}

CMD:namechanges(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Pending Namechanges:");

	foreach(new i : Player)
	{
	    if(!isnull(PlayerInfo[i][pNameChange]))
	    {
	        SM(playerid, COLOR_GREY1, "(ID: %i) %s - Requested name: %s", i, GetRPName(i), PlayerInfo[i][pNameChange]);
		}
	}

	return 1;
}

CMD:paytickets(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), amount;

	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SM(playerid, COLOR_SYNTAX, "Usage: /paytickets [amount] (There is $%i in unpaid tickets.)", VehicleInfo[vehicleid][vTickets]);
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pCash])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}
	if(amount > VehicleInfo[vehicleid][vTickets])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There isn't that much in unpaid tickets to pay.");
	}

    VehicleInfo[vehicleid][vTickets] -= amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "You have paid $%i in unpaid tickets. This vehicle now has $%i left in unpaid tickets.", amount, VehicleInfo[vehicleid][vTickets]);
	return 1;
}

CMD:carinfo(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any vehicle of yours.");
	}

	new neon[12], Float:health;

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

	SM(playerid, SERVER_COLOR, "%s Stats:", GetVehicleName(vehicleid));
	SM(playerid, COLOR_GREY2, "(Owner: %s) - (Value: $%i) - (Tickets: $%i) - (Plate: %s)", VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vPrice], VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vPlate]);
	SM(playerid, COLOR_GREY2, "(Neon: %s) - (Trunk: %i/3) - (Health: %.1f) - (Fuel: %i)", neon, VehicleInfo[vehicleid][vTrunk], health, vehicleFuel[vehicleid]);
	return 1;
}

CMD:getdrug(playerid, params[])
{
	new option[10], amount, cost;

    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -1009.370605, -972.158630, 133.949142))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not near Seeds house.");
	}
	if(sscanf(params, "s[10]i", option, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getdrug [seeds] [amount]");
	}

	if(!strcmp(option, "seeds", true))
	{
		if(amount < 1 || amount > 10)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't buy less than 1 or more than 10 seeds at a time.");
		}
		if(amount > gSeedsStock)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "There aren't that many seeds left in stock.");
		}
		if(PlayerInfo[playerid][pCash] < (cost = amount * 250))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many seeds.");
		}
		if(PlayerInfo[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
		{
		    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
		}

		gSeedsStock -= amount;
		PlayerInfo[playerid][pSeeds] += amount;
	
		SetTimerEx("HideGiveitems", 4000, false, "i", playerid);

		GivePlayerCash(playerid, -cost);
		AddPointMoney(POINT_DRUGDEN, cost);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have purchased %i marijuana seeds for $%i. /planthelp for more help.", amount, cost);
	}
	return 1;
}
CMD:cms(playerid, params[])
{
	return callcmd::cleanmyscreen(playerid, params);
}


CMD:cleanmyscreen(playerid, params[])
{
	ClearChat(playerid);
	return 1;
}
CMD:plantpot(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a gang member.");
	}
	if(PlayerInfo[playerid][pPotPlanted])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You have an active pot plant already.");
	}
	if(PlayerInfo[playerid][pSeeds] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough seeds. You need at least 10 seeds in order to plant them.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't plant indoors.");
	}

	GetPlayerPos(playerid, PlayerInfo[playerid][pPotX], PlayerInfo[playerid][pPotY], PlayerInfo[playerid][pPotZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPotA]);

	PlayerInfo[playerid][pSeeds] -= 10;
	PlayerInfo[playerid][pPotPlanted] = 1;
	PlayerInfo[playerid][pPotTime] = 60;
	PlayerInfo[playerid][pPotGrams] = 0;
	PlayerInfo[playerid][pPotObject] = CreateDynamicObject(3409, PlayerInfo[playerid][pPotX], PlayerInfo[playerid][pPotY], PlayerInfo[playerid][pPotZ] - 1.8, 0.0, 0.0, PlayerInfo[playerid][pPotA]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i, potplanted = 1, pottime = %i, potgrams = %i, pot_x = '%f', pot_y = '%f', pot_z = '%f', pot_a = '%f' WHERE uid = %i", PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pPotTime], PlayerInfo[playerid][pPotGrams], PlayerInfo[playerid][pPotX], PlayerInfo[playerid][pPotY], PlayerInfo[playerid][pPotZ], PlayerInfo[playerid][pPotA], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s plants some seeds into the ground.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_YELLOW, "You have planted a pot plant. Every two minutes your plant will grow one gram of pot.");
	SendClientMessage(playerid, COLOR_YELLOW, "Your plant will be ready in 60 minutes. Be careful, as anyone who sees your plant can pick it!");
	return 1;
}

CMD:plantinfo(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a gang member.");
	}
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPotPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[i][pPotX], PlayerInfo[i][pPotY], PlayerInfo[i][pPotZ]))
	    {
	        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s inspects the plant.", GetRPName(playerid));
	        SM(playerid, COLOR_WHITE, "** This plant has so far grown %i grams of pot. It will be ready in %i/60 minutes.", PlayerInfo[i][pPotGrams], PlayerInfo[i][pPotTime]);
	        return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any plants.");
	return 1;
}

CMD:pickplant(playerid, params[])
{
    foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPotPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[i][pPotX], PlayerInfo[i][pPotY], PlayerInfo[i][pPotZ]))
	    {
	        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be crouched in order to pick a plant.");
			}
			if(PlayerInfo[i][pPotGrams] < 2)
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "This plant hasn't grown that much yet. Wait a little while first.");
			}
			if(PlayerInfo[playerid][pPot] + PlayerInfo[i][pPotGrams] > GetPlayerCapacity(playerid, CAPACITY_WEED))
			{
			    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
			}

			PlayerInfo[playerid][pPickPlant] = i;
			PlayerInfo[playerid][pPickTime] = 5;

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s crouches down and starts picking at the pot plant.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "** Allow up to five seconds for you to pick the plant.");
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any plants.");
	return 1;
}

CMD:seizeplant(playerid, params[])
{
    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

    foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPotPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[i][pPotX], PlayerInfo[i][pPotY], PlayerInfo[i][pPotZ]))
	    {
	        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s seizes a pot plant weighing %i grams.", GetRPName(playerid), PlayerInfo[i][pPotGrams]);
	        DestroyPotPlant(i);
	        return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any plants.");
	return 1;
}

CMD:usecigar(playerid)
{
	if(!PlayerInfo[playerid][pCigars])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any cigars left.");
	}

	PlayerInfo[playerid][pCigars]--;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s lights up a cigar and starts to smoke it.", GetRPName(playerid));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", PlayerInfo[playerid][pCigars], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

//                                        [New Meth,Weed,System]
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CMD:cookmeth(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!(GetVehicleModel(GetPlayerVehicleID(playerid)) == 508 && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER))
		return SendClientMessage(playerid, COLOR_GREY, "You not in passenger sit or not in journey vehicle .");
	
	if(VehicleInfo[vehicleid][vRenttime] < 1 && VehicleInfo[vehicleid][vRent] == 1)
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "This Vehicle Will Expire In 1 Minute.");
	}
	if(PlayerInfo[playerid][pBatteries] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need Batteries.");
	}
	if(PlayerInfo[playerid][pAcetone] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need Acetone.");
	}
	if(PlayerInfo[playerid][pMobileMethLab] < 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need MobileMethLab.");
	}
	if(PlayerInfo[playerid][pCooking] == 1)
	{
	     return SendClientMessage(playerid, COLOR_SYNTAX, "Already Cooking");
	}

	PlayerInfo[playerid][pAcetone] -= 5;
	PlayerInfo[playerid][pBatteries] -= 5;
	PlayerInfo[playerid][pMethScore] = 0;
	PlayerInfo[playerid][pMobileMethLab] -= 1;
	PlayerInfo[playerid][pCooking] = 1;
	
	methveh = CreateDynamicObject(18728,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
	AttachDynamicObjectToVehicle(methveh, vehicleid, 0.540, -4.000, -2.000, 0.000, 0.000, 0.000);
	
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Acetone = %i WHERE uid = %i", PlayerInfo[playerid][pAcetone], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Batteries = %i WHERE uid = %i", PlayerInfo[playerid][pBatteries], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pMobileMethLab = %i WHERE uid = %i", PlayerInfo[playerid][pMobileMethLab], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SetTimerEx("Showmethbox", 15000, false, "i", playerid);
	return 1;
}

forward Showmethbox(playerid);
public Showmethbox(playerid)
{
    SetTimerEx("Showmethbox1", 15000, false, "i", playerid);
    ShowPlayerDialog(playerid, DIALOG_METH_QUESTION_1, DIALOG_STYLE_LIST, "{FF0000}GAS TANK IS LEAKING.......NOW WHAT? ", "Use Tap\nIgnore\nReplace The Tube\n", "Select", "Close");
    return 1;
}

forward Showmethbox1(playerid);
public Showmethbox1(playerid)
{
    SetTimerEx("Showmethbox2", 15000, false, "i", playerid);
    ShowPlayerDialog(playerid, DIALOG_METH_QUESTION_2, DIALOG_STYLE_LIST, "{FF0000}YOU SPILLED SOME ACTONE ON THE FLOOR....NOW WHAT? ", "Open A Window\nBreath In It\nPut A Mask\n", "Select", "Close");
    return 1;
}

forward Showmethbox2(playerid);
public Showmethbox2(playerid)
{

    SetTimerEx("Showmethbox3", 15000, false, "i", playerid);
    ShowPlayerDialog(playerid, DIALOG_METH_QUESTION_3, DIALOG_STYLE_LIST, "{FF0000}YOU ADDED TO MUCH ACETONE.... NOW WHAT?", "Do Nothing\nAdd Lithium\nUse A straw\n", "Select", "Close");
    return 1;
}

forward Showmethbox3(playerid);
public Showmethbox3(playerid)
{
    SetTimerEx("Showmethbox4", 15000, false, "i", playerid);
    ShowPlayerDialog(playerid, DIALOG_METH_QUESTION_4, DIALOG_STYLE_LIST, "{FF0000}YOU FOUNDED SOME BLUE DYE  ", "Pour In It\nThrow It Away\nYou Found Another Color\n", "Select", "Close");
    return 1;
}


forward Showmethbox4(playerid);
public Showmethbox4(playerid)
{
   ShowPlayerDialog(playerid, DIALOG_METH_QUESTION_5, DIALOG_STYLE_LIST, "{FFFFFF}JOB DONE", "COLLECT METH", "Select", "Close");
   return 1;
}

CMD:use(playerid, params[])
{
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pJoinedEvent] > 0 && !EventInfo[eHeal])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The administrator has chosen to disable healing in this event.");
	}
	if(gettime() - PlayerInfo[playerid][pLastSell] < 60)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 60 sec. Please wait %i more seconds.", 60 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /use [bandage | Vest | Helmet]");
	}
	if(!strcmp(params, "bandage", true))
	{
		if(PlayerInfo[playerid][pBandage] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You have no bandage left.");
		}
		
		PlayerInfo[playerid][pLastSell] = gettime();
		GivePlayerHealth(playerid, 50.0);
		PlayerInfo[playerid][pBandage] -= 1;
		SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s begins bandaging their self", GetRPName(playerid));
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bandage = %i WHERE uid = %i", PlayerInfo[playerid][pBandage], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(params, "vest", true))
	{
		if(PlayerInfo[playerid][pVest] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You have no vest left.");
		}
		if(PlayerInfo[playerid][pEquipVest] == true)
			return SendClientMessageEx(playerid, COLOR_GREY, "You are already equipping a vest.");
			
		new string[128];
		PlayerInfo[playerid][pVest]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[playerid][pVest], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		format(string, sizeof(string), "* %s has takes off their vest, dropping it on the ground.", GetPlayerNameEx(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_ORANGE, string);
		format(string, sizeof(string), "* %s picks up the vest equipping it to themselves.", GetPlayerNameEx(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_ORANGE, string);

		SendClientMessageEx(playerid, COLOR_ORANGE, " Equipping your kevalar vest, This will take 20 seconds. Keep cover! ");
       
		PlayerInfo[playerid][pEquipVest] = true;
		//PlayerTextDrawShow(playerid, PROGRESS1[playerid][0]);
        //PlayerText_MoveTextSize(playerid, PROGRESS1[playerid][1] ,116.69, 20000, EASE_IN_SINE);
        //PlayerText_InterpolateColor(playerid, PROGRESS1[playerid][1], 16744447, 20000, EASE_IN_SINE);
		PlayerInfo[playerid][pEquipTimer] = SetTimerEx("OnPlayerEquipVest", 20000, false, "d", playerid);

		ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.0, 1, 1, 1, 0, 0);
		TogglePlayerControllable(playerid, 0);
	}
	else if(!strcmp(params, "helmet", true))
	{
		if(PlayerInfo[playerid][pHelmet1] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You have no helmet left.");
		}
		if(PlayerInfo[playerid][pHelmet] >= 100)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You already have Full helmet");
		}
		if(PlayerInfo[playerid][pEquipHelmet] == true)
			return SendClientMessageEx(playerid, COLOR_GREY, "You are already equipping a vest.");

		new string[128];
		PlayerInfo[playerid][pHelmet1]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmetp = %i WHERE uid = %i", PlayerInfo[playerid][pHelmet1], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);


		format(string, sizeof(string), "* %s has takes off their helmet.", GetPlayerNameEx(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_ORANGE, string);
		format(string, sizeof(string), "* %s picks up the helmet equipping it to themselves.", GetPlayerNameEx(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_ORANGE, string);

		SendClientMessageEx(playerid, COLOR_ORANGE, " Equipping your helmet, This will take 4 seconds. Keep cover! ");

		PlayerInfo[playerid][pEquipHelmet] = true;
		//PlayerTextDrawShow(playerid, PROGRESS1[playerid][0]);
        //PlayerText_MoveTextSize(playerid, PROGRESS1[playerid][1] ,116.69, 4000, EASE_IN_SINE);
        //PlayerText_InterpolateColor(playerid, PROGRESS1[playerid][1], 16744447, 4000, EASE_IN_SINE);
		PlayerInfo[playerid][pEquipTimer] = SetTimerEx("OnPlayerEquipHelmet", 4000, false, "d", playerid);

		ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.0, 1, 1, 1, 0, 0);
		TogglePlayerControllable(playerid, 0);
	}
	return 1;
}

CMD:usedrug(playerid, params[])
{
    if(gettime() - PlayerInfo[playerid][pLastDrug] < 5)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only consume drugs every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastDrug]));
	}
	if(PlayerInfo[playerid][pDrugsUsed] >= 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are stoned and therefore can't consume anymore drugs right now.");
	}
	if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pJoinedEvent] > 0 && !EventInfo[eHeal])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The administrator has chosen to disable healing in this event.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /usedrug [meth | Joint | pot | Cocaine]");
	}

	if(!strcmp(params, "meth", true))
	{
	    if(PlayerInfo[playerid][pMeth] < 2)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least two grams of meth.");
		}

		if(PlayerInfo[playerid][pAddictUpgrade] > 0)
	    {
			SM(playerid, COLOR_YELLOW, "Addict Perk: Your level %i/3 addict perk gave you %.1f/%.1f extra health & armor.", PlayerInfo[playerid][pAddictUpgrade], (PlayerInfo[playerid][pAddictUpgrade] * 5.0), (PlayerInfo[playerid][pAddictUpgrade] * 5.0));
	    }


		GivePlayerArmour(playerid, 25.0 + (PlayerInfo[playerid][pAddictUpgrade] * 5.0));

		PlayerInfo[playerid][pMeth] -= 2;
		PlayerInfo[playerid][pDrugsUsed] ++;
		PlayerInfo[playerid][pLastDrug] = gettime();

		if(PlayerInfo[playerid][pDrugsUsed] >= 2)
	    {
	    	Dyuze(playerid, "Notice", "~p~shit... you stoned as hell duuuude...");
			PlayerInfo[playerid][pDrugsTime] = 10;
		}

        ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s smokes two grams of meth.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(params, "Joint", true))
	{
	    if(PlayerInfo[playerid][pPainkillers] <= 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any Joint left.");
		}

		if(PlayerInfo[playerid][pAddictUpgrade] > 0)
	    {
			SM(playerid, COLOR_YELLOW, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra health.", PlayerInfo[playerid][pAddictUpgrade], (PlayerInfo[playerid][pAddictUpgrade] * 5.0));
	    }

		GivePlayerHealth(playerid, 50.0 + (PlayerInfo[playerid][pAddictUpgrade] * 5.0));

		PlayerInfo[playerid][pPainkillers] -= 2;
		PlayerInfo[playerid][pDrugsUsed] += 2;
		PlayerInfo[playerid][pLastDrug] = gettime();

		if(PlayerInfo[playerid][pDrugsUsed] >= 2)
	    {
	        Dyuze(playerid, "Notice", "~p~shit... you stoned as hell duuuude...");
	        PlayerInfo[playerid][pDrugsTime] = 10;
		}

        ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s pops a Joint in their mouth.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(params, "pot", true))
	{
	    if(PlayerInfo[playerid][pPot] < 2) return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least one gram of pot.");
		GivePlayerHealth(playerid, 25.0 + (PlayerInfo[playerid][pAddictUpgrade] * 5.0));

		PlayerInfo[playerid][pPot] -= 2;
		PlayerInfo[playerid][pDrugsUsed]++;
		PlayerInfo[playerid][pLastDrug] = gettime();

		if(PlayerInfo[playerid][pDrugsUsed] >= 2)
	    {
	        Dyuze(playerid, "Notice", "~p~shit... you stoned as hell duuuude...");
			PlayerInfo[playerid][pDrugsTime] = 10;
		}

	    ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s smokes one gram of pot.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(params, "Cocaine", true))
	{
		if(PlayerInfo[playerid][pCrack] < 2)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least one gram of Cocaine.");
		}
        GivePlayerHealth(playerid, 10.0 + (PlayerInfo[playerid][pAddictUpgrade] * 5.0));
		GivePlayerArmour(playerid, 50.0 + (PlayerInfo[playerid][pAddictUpgrade] * 5.0));

		PlayerInfo[playerid][pCrack] -= 2;
		PlayerInfo[playerid][pDrugsUsed] += 2;
		PlayerInfo[playerid][pLastDrug] = gettime();

		if(PlayerInfo[playerid][pDrugsUsed] >= 2)
	    {
	        Dyuze(playerid, "Notice", "~p~shit... you stoned as hell duuuude...");
			PlayerInfo[playerid][pDrugsTime] = 10;
		}

	    ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s snorts one gram of Cocaine.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}
new potuse[] = "pot";
new crackuse[] = "crack";
CMD:usepot(playerid) return callcmd::usedrug(playerid, potuse);
CMD:usecrack(playerid) return callcmd::usedrug(playerid, crackuse);

CMD:rules(playerid, params[])
{
	return ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_LIST, "List of Rules", "Server\nTraffic Laws\nSpeed Laws", "Select", "Close");
}

CMD:showslaws(playerid, params[])
{
	new targetid, str[1024];

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /showslaws [playerid]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}

	strcat(str, ""WHITE"- This server has limitations. -\n");
	strcat(str, "1. 50 MPH if you are in the City.\n");
	strcat(str, "2. 70 MPH on the County roads.\n");
	strcat(str, "3. 90 MPH on the Highways and Interstates.\n");
	strcat(str, "4. Box trucks cannot exceed 50 MPH.\n");
	strcat(str, "5. Any vehicles with 3 or more axles aren't allowed to go more than 55 mph. Regardless of roadway limits.\n");
	strcat(str, "Note: This is a short version of our speed laws. Please visit  to see a full list of "SERVER_URL"");
	ShowPlayerDialog(targetid, 0, DIALOG_STYLE_MSGBOX, ""WHITE"List of Speed Enforcement Laws", str, "Okay", "");

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s shows the speed rules to %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:showtlaws(playerid, params[])
{
	new targetid, str[1024];

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /showtlaws [playerid]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}

	strcat(str, ""WHITE"1. Drive on the right side of the road at all times or else you will get punishment.\n");
	strcat(str, "2. Yield to emergency vehicles.\n");
	strcat(str, "3. Move over and slow down for stopped emergency vehicles.\n");
	strcat(str, "4. Turn your headlights on at night. Type (/lights) to turn it.\n");
	strcat(str, "5. Wear your seatbelt or helmet always. Type (/seatbelt) to wear it.\n");
	strcat(str, "6. Traffic lights are synced Red is for Stop, Yellow is for Slow down and Green is for Go\n");
	strcat(str, "7. Only follow traffic lights above a junction. (Marked with a solid white line)\n");
	strcat(str, "8. Remain at a safe distance from other vehicles when driving, atleast 3 car lengths\n");
	strcat(str, "9. Only follow traffic lights above a junction. (Marked with a solid white line)\n");
	strcat(str, "10. Pedistrians always have the right of way, regardless of the situation.\n");
	strcat(str, "11. Drive how you would in real life, dont be a moron.\n");
	strcat(str, "- If you fail at driving you will be jailed or banned. -\n");
	strcat(str, "Note: This is a short version of our traffic laws. Please visit  to see a full list at "SERVER_URL"");
	ShowPlayerDialog(targetid, 0, DIALOG_STYLE_MSGBOX, ""WHITE"List of Traffic Laws", str, "Okay", "");

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s shows the traffic rules to %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:showlicenses(playerid, params[]) return callcmd::showid(playerid, params);
CMD:showid(playerid, params[])
{
	new targetid, status[64];

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /showid [playerid]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}

	SendClientMessage(targetid, SERVER_COLOR, "ID Card:");
	SM(targetid, COLOR_GREY1, "Name: %s", GetRPName(playerid));
	SM(targetid, COLOR_GREY1, "Gender: %s", (PlayerInfo[playerid][pGender] == 2) ? ("Female") : ("Male"));
	SM(targetid, COLOR_GREY1, "Age: %i Years Old", PlayerInfo[playerid][pAge]);
	SM(targetid, COLOR_GREY1, "Drivers License: %s", (PlayerInfo[playerid][pCarLicense]) ? (""SVRCLR"Yes") : (""SVRCLR"No"));
	SM(targetid, COLOR_GREY1, "Weapon License: %s", (PlayerInfo[playerid][pWeaponLicense]) ? (""SVRCLR"Yes") : (""SVRCLR"No"));
	SM(targetid, COLOR_GREY1, "Citizenship: %s", status);
	if(targetid != playerid) SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s shows their ID card to %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:cc(playerid) return callcmd::clearchat(playerid);

CMD:drop(playerid, params[])
{
	new option[12], confirm[10];

	if(sscanf(params, "s[12]S()[10]", option, confirm))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drop [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Weapons, Backpack, Materials, Pot, Crack, Meth, Painkillers, Cigars, Spraycans");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Seeds, Ephedrine, HPAmmo");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Ore, Copper, Gold, Iorn, Diamond");
	    return 1;
	}
	if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}

	if(!strcmp(option, "weapons", true))
	{
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drop [weapons] [confirm]");
	    }

	    ResetPlayerWeaponsEx(playerid);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their weapons.", GetRPName(playerid));
	}
	else if(!strcmp(option, "backpack", true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You need to be onfoot in order to drop weapons.");

		if(PlayerInfo[playerid][pBackpack] < 1)
			return SendClientMessage(playerid, COLOR_ERROR, "You don't have backpack with you.");

		if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You can't use this command at the moment.");

		if(GetHealth(playerid) < 60)
			return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You can't drop weapons as your health is below 60.");

	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	        return SendClientMessage(playerid, COLOR_GREY, "USAGE:"WHITE" /drop [backpack] [confirm]");

		if(IsPlayerInRangeOfBackpack(playerid, 2.0) != -1)
			return SendClientMessage(playerid, COLOR_GREY, "You are in range of another backpack, find another position.");

		DropBackpack(playerid);
		ResetBackpack(playerid);
		ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, COLOR_YELLOW, "You drop your backpack.");
	    SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s drops their backpack.", GetRPName(playerid));
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(!PlayerInfo[playerid][pMaterials])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no materials which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [materials] [confirm] (You have %i materials.)", PlayerInfo[playerid][pMaterials]);
	    }

	    PlayerInfo[playerid][pMaterials] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their materials.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Ore", true))
	{
	    if(!PlayerInfo[playerid][pOre])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Ore which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [ore] [confirm] (You have %i ore.)", PlayerInfo[playerid][pOre]);
	    }

	    PlayerInfo[playerid][pOre] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Ores.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ore = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "copper", true))
	{
	    if(!PlayerInfo[playerid][pCopper])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Copper which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [copper] [confirm] (You have %i Copper.)", PlayerInfo[playerid][pCopper]);
	    }
	    PlayerInfo[playerid][pCopper] = 0;

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Coppers.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET copper = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
		PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pDiamonds];
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "iorn", true))
	{
		if(!PlayerInfo[playerid][pIorn])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Copper which you can throw away.");
		}
		if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
		{
			return SM(playerid, COLOR_SYNTAX, "Usage: /drop [iorn] [confirm] (You have %i Iorns.)", PlayerInfo[playerid][pIorn]);
		}
		PlayerInfo[playerid][pIorn] = 0;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Iorns.", GetRPName(playerid));
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET iorn = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pDiamonds];
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gold", true))
	{
		if(!PlayerInfo[playerid][pGold])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Copper which you can throw away.");
		}
		if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
		{
			return SM(playerid, COLOR_SYNTAX, "Usage: /drop [gold] [confirm] (You have %i golds.)", PlayerInfo[playerid][pGold]);
		}
		PlayerInfo[playerid][pGold] = 0;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Golds.", GetRPName(playerid));
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gold = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pDiamonds];
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "diamonds", true))
	{
		if(!PlayerInfo[playerid][pDiamonds])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Copper which you can throw away.");
		}
		if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
		{
			return SM(playerid, COLOR_SYNTAX, "Usage: /drop [diamonds] [confirm] (You have %i Diamonds.)", PlayerInfo[playerid][pDiamonds]);
		}
		PlayerInfo[playerid][pDiamonds] = 0;
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Diamonds.", GetRPName(playerid));
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		PlayerInfo[playerid][pMetalCapacity] = PlayerInfo[playerid][pCopper] + PlayerInfo[playerid][pIorn] + PlayerInfo[playerid][pGold] + PlayerInfo[playerid][pDiamonds];
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET metals = %i WHERE uid = %i", PlayerInfo[playerid][pMetalCapacity], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "pot", true))
	{
	    if(!PlayerInfo[playerid][pPot])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no pot which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [pot] [confirm] (You have %i grams of pot.)", PlayerInfo[playerid][pPot]);
	    }

	    PlayerInfo[playerid][pPot] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their pot.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(!PlayerInfo[playerid][pCrack])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no Crack which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [Crack] [confirm] (You have %i grams of Crack.)", PlayerInfo[playerid][pCrack]);
	    }

	    PlayerInfo[playerid][pCrack] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their Crack.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "meth", true))
	{
	    if(!PlayerInfo[playerid][pMeth])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no meth which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [meth] [confirm] (You have %i grams of meth.)", PlayerInfo[playerid][pMeth]);
	    }

	    PlayerInfo[playerid][pMeth] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their meth.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(!PlayerInfo[playerid][pPainkillers])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no painkillers which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [painkillers] [confirm] (You have %i painkillers.)", PlayerInfo[playerid][pPainkillers]);
	    }

	    PlayerInfo[playerid][pPainkillers] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their painkillers.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "cigars", true))
	{
	    if(!PlayerInfo[playerid][pCigars])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no cigars which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [cigars] [confirm] (You have %i cigars.)", PlayerInfo[playerid][pCigars]);
	    }

	    PlayerInfo[playerid][pCigars] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their cigars.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(!PlayerInfo[playerid][pSpraycans])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no spraycans which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [spraycans] [confirm] (You have %i spraycans.)", PlayerInfo[playerid][pSpraycans]);
	    }

	    PlayerInfo[playerid][pSpraycans] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their spraycanss.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(!PlayerInfo[playerid][pSeeds])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no seeds which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [seeds] [confirm] (You have %i seeds.)", PlayerInfo[playerid][pSeeds]);
	    }

	    PlayerInfo[playerid][pSeeds] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their seeds.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "ephedrine", true))
	{
	    if(!PlayerInfo[playerid][pEphedrine])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no ephedrine which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [ephedrine] [confirm] (You have %i grams of ephedrine.)", PlayerInfo[playerid][pEphedrine]);
	    }

	    PlayerInfo[playerid][pEphedrine] = 0;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their ephedrine.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "hpammo", true))
	{
	    if(!PlayerInfo[playerid][pHPAmmo])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no hollow point ammo which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /drop [hpammo] [confirm] (You have %i rounds of HP ammo.)", PlayerInfo[playerid][pHPAmmo]);
	    }

	    SetWeaponAmmo(playerid, AMMO_HP, 0);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s throws away their hollow point ammo.", GetRPName(playerid));
	}

	return 1;
}

