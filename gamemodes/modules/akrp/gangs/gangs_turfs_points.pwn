CMD:creategangtag(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z,
		Float:angle;

    if(PlayerInfo[playerid][pAdmin] < 6)
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
 		return SendClientMessage(playerid, COLOR_SYNTAX, "You can only create graffiti points outside interiors.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Graffiti_Create(x, y, z, angle);

	if(id == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for graffiti points.");
	}

	EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);

	PlayerInfo[playerid][pEditGraffiti] = id;
	SM(playerid, COLOR_SYNTAX, "You have successfully created graffiti ID: %d.", id);
	return 1;
}

CMD:editgangtag(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 6)
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	}
	if(sscanf(params, "d", id))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgangtag [graffiti id]");
	}

	EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);
	PlayerInfo[playerid][pEditGraffiti] = id;
	SM(playerid, COLOR_SYNTAX, "You have successfully editing graffiti ID: %d.", id);
	return 1;
}

CMD:destroygangtag(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 6)
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	}
	if(sscanf(params, "d", id))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /destroygraffiti [graffiti id]");
	}

	if((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid graffiti ID.");
	}
	Graffiti_Delete(id);
	SM(playerid, COLOR_SYNTAX, "You have successfully destroyed graffiti ID: %d.", id);
	return 1;
}

CMD:gspray(playerid, params[])
{
	new id = Graffiti_Nearest(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not near any graffiti point.");

	if(PlayerInfo[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
	}
	if(PlayerInfo[playerid][pGangRank] < 5)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 5 to tag a wall");
	}
	if(PlayerInfo[playerid][pSpraycans] <= 0)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough spraycans for this.");
	}
	ShowPlayerDialog(playerid, DIALOG_GRAFFITICOLOR, DIALOG_STYLE_LIST, "Select Color", ""WHITE"White\n{FF0000}Red\n{FFFF00}Yellow\n{33CC33}Green\n{33CCFF}Light Blue\n"SVRCLR"Orange\n{1394BF}Dark Blue\n{000000}Black", "Select", "Cancel");
	return 1;
}

CMD:creategang(playerid, params[])
{
	new name[32];

    if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[32]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /creategang [name]");
	}

	for(new i = 1; i < MAX_GANGS; i ++)
	{
	    if(!GangInfo[i][gSetup])
	    {
	        SetupGang(i, name);

	        SAM(COLOR_LIGHTRED, "AdmCmd: %s has setup gang {F7A763}%s{FF6347} in slot ID %i.", GetRPName(playerid), name, i);
	        SM(playerid, COLOR_WHITE, "** This gang's ID is %i. /editgang to edit.", i);
	        return 1;
		}
	}

	return 1;
}

CMD:editgang(playerid, params[])
{
	new gangid, option[14], param[128];

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[128]", gangid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Name, MOTD, Theme, Level, Color, Points, TurfTokens, RankName, Skin, Strikes, Alliance");
		return 1;
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}

	if(!strcmp(option, "name", true))
	{
	    if(isnull(param) || strlen(params) > 32)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [name] [text]");
		}

		strcpy(GangInfo[gangid][gName], param, 32);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET name = '%e' WHERE id = %i", param, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the name of gang ID %i to '%s'.", GetRPName(playerid), gangid, param);
	}
	else if(!strcmp(option, "motd", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [motd] [text]");
		}

		strcpy(GangInfo[gangid][gMOTD], param, 128);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET motd = '%e' WHERE id = %i", param, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has adjusted the MOTD of gang ID %i.", GetRPName(playerid), gangid);
	}
	else if(!strcmp(option, "theme", true))
	{
	    new theme[32];

	    if(sscanf(param, "s[24]", theme))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [theme] [name]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "This updates the Gang Theme in [/gangs]");
			return 1;
		}

		strcpy(GangInfo[gangid][gTheme], theme, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET theme = '%e' WHERE id = %i", theme, gangid);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the theme of gang ID %i to %s.", GetRPName(playerid), gangid, theme);
	}
	else if(!strcmp(option, "level", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [level] [value (1-3)]");
		}
		if(!(1 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level.");
		}

		GangInfo[gangid][gLevel] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET level = %i WHERE id = %i", GangInfo[gangid][gLevel], gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the level of gang ID %i to %i/3.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [color] [0xRRGGBBAA]");
		}

		GangInfo[gangid][gColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET color = %i WHERE id = %i", GangInfo[gangid][gColor], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of gang ID %i.", GetRPName(playerid), color >>> 8, gangid);
	}
	else if(!strcmp(option, "points", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [points] [value]");
		}

		GangInfo[gangid][gPoints] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET points = %i WHERE id = %i", GangInfo[gangid][gPoints], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the gang points of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "turftokens", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [turftokens] [value]");
		}

		GangInfo[gangid][gTurfTokens] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET turftokens = %i WHERE id = %i", GangInfo[gangid][gTurfTokens], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the turf tokens of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Rank Names:");

	        for(new i = 0; i < 7; i ++)
	        {
	            if(isnull(GangRanks[gangid][i]))
	            	SM(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SM(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[gangid][i]);
	        }

	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [rankname] [slot (0-6)] [name]");
	    }
	    if(!(0 <= rankid <= 6))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
		}

	    strcpy(GangRanks[gangid][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", gangid, rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's name of gang ID %i to '%s'.", GetRPName(playerid), rankid, gangid, rank);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;

	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Gang Skins:");

	        for(new i = 0; i < MAX_GANG_SKINS; i ++)
	        {
	            if(GangInfo[gangid][gSkins][i] == 0)
	            	SM(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SM(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[gangid][gSkins][i]);
	        }

	        return SM(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
	    }
	    if(!(1 <= slot <= MAX_GANG_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
		}
		if(!(0 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin.");
		}

		slot--;

		GangInfo[gangid][gSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", gangid, slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_WHITE, "** You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "strikes", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [strikes] [amount]");
		}
		if(!(0 <= amount <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount must range from 0 to 3.");
		}

		GangInfo[gangid][gStrikes] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET strikes = %i WHERE id = %i", amount, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the strikes of gang ID %i to %i.", GetRPName(playerid), gangid, amount);
	}
	else if(!strcmp(option, "alliance", true))
	{
		new allyid;

	    if(sscanf(param, "i", allyid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgang [gangid] [alliance] [gangid]");
		}

		if(allyid == -1)
		{
		    if(GangInfo[gangid][gAlliance] >= 0)
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = -1 WHERE id = %i", GangInfo[gangid][gAlliance]);
				mysql_tquery(connectionID, queryBuffer);
		        GangInfo[GangInfo[gangid][gAlliance]][gAlliance] = -1;
			}

			GangInfo[gangid][gAlliance] = -1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = -1 WHERE id = %i", gangid);
			mysql_tquery(connectionID, queryBuffer);

			ReloadGang(gangid);
			SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the alliance of gang ID %i.", GetRPName(playerid), gangid);
		}
		else
		{
		    if(!(1 <= allyid < MAX_GANGS) || GangInfo[allyid][gSetup] == 0)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
		    }

			GangInfo[gangid][gAlliance] = allyid;
			GangInfo[allyid][gAlliance] = gangid;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = %i WHERE id = %i", allyid, gangid);
			mysql_tquery(connectionID, queryBuffer);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = %i WHERE id = %i", gangid, allyid);
			mysql_tquery(connectionID, queryBuffer);

			ReloadGang(gangid);
			SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the alliance of gang ID %i to gang %i.", GetRPName(playerid), gangid, allyid);
		}
	}
	return 1;
}

CMD:removegang(playerid, params[])
{
	new gangid;

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removegang [gangid]");
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has deleted gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
	SM(playerid, COLOR_LIGHTRED, "You have permanently deleted the {F7A763}%s{FF6347} gang slot.", GangInfo[gangid][gName]);
	RemoveGang(gangid);
	return 1;
}

CMD:gangban(playerid, params[])
{
	new targetid, status;
	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gangban [playerid] [status: 0 = allow, 1 = ban]");
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
		SMA(COLOR_RED, "%s is now banned from joining any gang as the punishment is raised by %s.", GetRPName(targetid), GetRPName(playerid));
		SendClientMessage(targetid, COLOR_GREEN, "If you wish to get unbanned, please screenshot this and contact the one who banned you or any gang moderators.");
		PlayerInfo[targetid][pGangBan] = 1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gangban = 1 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(status == 0)
	{
		SMA(COLOR_GREEN, "%s is now unbanned / is now allowed to join any gang as the punishment is lifted by %s.", GetRPName(targetid), GetRPName(playerid));
		PlayerInfo[targetid][pGangBan] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gangban = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

CMD:gangstrike(playerid, params[])
{
	new gangid, reason[128];

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[128]", gangid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gangstrike [gangid] [reason]");
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}
	if(GangInfo[gangid][gStrikes] >= 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This gang already has 3 strikes.");
	}

	GangInfo[gangid][gStrikes]++;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET strikes = %i WHERE id = %i", GangInfo[gangid][gStrikes], gangid);
	mysql_tquery(connectionID, queryBuffer);

	switch(GangInfo[gangid][gStrikes])
	{
		case 1: SMA(COLOR_GREEN, "Gang News: %s has received their 1st strike, reason: %s", GangInfo[gangid][gName], reason);
		case 2: SMA(COLOR_GREEN, "Gang News: %s has received their 2nd strike, reason: %s", GangInfo[gangid][gName], reason);
		case 3: SMA(COLOR_GREEN, "Gang News: %s has received their 3rd strike, reason: %s", GangInfo[gangid][gName], reason);
	}

	return 1;
}

CMD:setgang(playerid, params[])
{
	new targetid, gangid, rankid;

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uiI(-1)", targetid, gangid, rankid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setgang [playerid] [gangid (-1 = none)] [rank (optional)]");
	}
	if(PlayerInfo[targetid][pGangBan] == 1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This player has been banned from joining any gang.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!(0 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}
	if((gangid != -1 && !(-1 <= rankid <= 6)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
	}

	if(gangid == -1)
	{
	    PlayerInfo[targetid][pGang] = -1;
		PlayerInfo[targetid][pGangRank] = 0;

		SM(targetid, COLOR_AQUA, "%s has removed you from your gang.", GetRPName(playerid));
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has removed %s from their gang.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
		if(rankid == -1)
		{
	    	rankid = 6;
		}

		PlayerInfo[targetid][pGang] = gangid;
		PlayerInfo[targetid][pGangRank] = rankid;

		SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"%s{CCFFFF} in %s.", GetRPName(playerid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s in %s.", GetRPName(playerid), GetRPName(targetid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = %i, gangrank = %i WHERE uid = %i", gangid, rankid, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:families(playerid, params[]) { return callcmd::gangs(playerid, params); }
CMD:gangs(playerid, params[])
{
	new gangid;

	if(sscanf(params, "i", gangid))
	{
	    SendClientMessage(playerid, SERVER_COLOR, "Gangs:");

		for(new i = 0; i < MAX_GANGS; i ++)
		{
		    if(GangInfo[i][gSetup])
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE gang = %i", i);
		        mysql_tquery(connectionID, queryBuffer, "OnPlayerListGangs", "ii", playerid, i);
		    }
		}
		return 1;
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
	}
	if(GangInfo[gangid][gAlliance] != -1)
	{
	    SM(playerid, COLOR_GREY, "Name: %s - Leader: %s - Strikes: %i/3 - Alliance: %s", GangInfo[gangid][gName], GangInfo[gangid][gLeader], GangInfo[gangid][gStrikes], GangInfo[GangInfo[gangid][gAlliance]][gName]);
	}

	SendClientMessage(playerid, SERVER_COLOR, "Members Online:");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pLogged] && PlayerInfo[i][pGang] == gangid)
	    {
	        SM(playerid, COLOR_GREY2, "(%i) %s %s", PlayerInfo[i][pGangRank], GangRanks[gangid][PlayerInfo[i][pGangRank]], GetRPName(i));
		}
	}

	return 1;
}

CMD:turfinfo(playerid, params[])
{
	new
		iCount,
		szMessage[280];

	SendClientMessage(playerid, SERVER_COLOR, "Turf Info:");
	for(new i; i < MAX_TURFS; i++)
	{
		if(TurfInfo[i][tExists])
		{
		    if(TurfInfo[i][tCapturer] != INVALID_PLAYER_ID)
			{
				if(TurfInfo[i][tCaptureTime] == 1)
				{
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Time left: Less than 1 minute", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]));
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				}
				else
				{
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Time left: %d minutes", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]), TurfInfo[i][tCaptureTime]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				}
			}
		}
	}
	if(iCount == 0)
		return SendClientMessage(playerid, COLOR_SYNTAX, "No gang has attempted to capture a turf at this time.");
	return 1;
}

CMD:pointinfo(playerid, params[])
{
	new
		iCount,
		szMessage[128];

	SendClientMessage(playerid, COLOR_ORANGE, "Point Info:");
	for(new i; i < MAX_POINTS; i++) {
		if(PointInfo[i][pExists]) {
		    if(PointInfo[i][pCapturer] != INVALID_PLAYER_ID)  {
				if(PointInfo[i][pCaptureTime] == 1) {
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Gang: %s | Time left: Less than 1 minute", PointInfo[i][pName], GetRPName(PointInfo[i][pCapturer]), GangInfo[PlayerInfo[PointInfo[i][pCapturer]][pGang]][gName]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				} else {
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Gang: %s | Time left: %d minutes", PointInfo[i][pName], GetRPName(PointInfo[i][pCapturer]), GangInfo[PlayerInfo[PointInfo[i][pCapturer]][pGang]][gName], PointInfo[i][pCaptureTime]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				}
			}
		}
	}
	if(iCount == 0)
		return SendClientMessage(playerid, COLOR_GREY, "No gang has attempted to capture a point at this time.");
	return 1;
}

CMD:points(playerid, params[])
{
	new name[280], color, string[2048];
	psstring = "";
	for(new i = 0; i < MAX_POINTS; i ++)
	{
		if(PointInfo[i][pExists])
		{
			if(PointInfo[i][pCapturedGang] == -1)
			{
				name = "None";
				color = 0xFFFFFF00;
			}
			else
			{
				strcpy(name, GangInfo[PointInfo[i][pCapturedGang]][gName]);
				color = GangInfo[PointInfo[i][pCapturedGang]][gColor];
			}
			if(strlen(string) < 1950)
			{
			    format(string, sizeof(string), "%s{%06x}%i. %s | %s | Claimer: %s | Profits: $%i | Time: %ih\n", string, color >>> 8, i, PointInfo[i][pName], name, PointInfo[i][pCapturedBy], PointInfo[i][pProfits], PointInfo[i][pTime]);
			}
			else
			{
			    format(psstring, sizeof(psstring), "%s{%06x}%i. %s | %s | Claimer: %s | Profits: $%i | Time: %ih\n", psstring, color >>> 8, i, PointInfo[i][pName], name, PointInfo[i][pCapturedBy], PointInfo[i][pProfits], PointInfo[i][pTime]);
			}

		}
	}
	ShowPlayerDialog(playerid, DIALOG_POINTLIST, DIALOG_STYLE_MSGBOX, ""SVRCLR"Point List"WHITE" ("REVISION")", string, "Next", "Cancel");
	return 1;
}

CMD:lands(playerid)
{
	if(!PlayerInfo[playerid][pShowLands])
	{
        ShowLandsOnMap(playerid, true);
        ShowTurfsOnMap(playerid, false);
        SendClientMessage(playerid, COLOR_AQUA, "You will now see lands on your mini-map.");
	}
	else
	{
        ShowLandsOnMap(playerid, false);
        SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any lands on your mini-map.");
	}

	return 1;
}

CMD:f(playerid, params[])
{
    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /f [gang chat]");
	}
	if(PlayerInfo[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
	}
    if(PlayerInfo[playerid][pToggleGang])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the gang chat as you have it toggled.");
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
	    if(PlayerInfo[i][pGang] == PlayerInfo[playerid][pGang] && !PlayerInfo[i][pToggleGang])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SM(i, 0x00FFFFFF, "[/f] (%i) %s %s: %.*s... **", PlayerInfo[playerid][pGangRank], GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SM(i, 0x00FFFFFF, "[/f] (%i) %s %s: ...%s **", PlayerInfo[playerid][pGangRank], GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, 0x00FFFFFF, "[/f] (%i) %s %s: %s **", PlayerInfo[playerid][pGangRank], GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}

CMD:ally(playerid, params[])
{
	new gangid = PlayerInfo[playerid][pGang];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ally [Alliance chat]");
	}
	if(PlayerInfo[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
	}
	if(GangInfo[gangid][gAlliance] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang isn't a part of an alliance.");
	}
    if(PlayerInfo[playerid][pToggleGang])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the alliance chat as you have gang chat toggled.");
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
	    if((PlayerInfo[i][pGang] == PlayerInfo[playerid][pGang] || PlayerInfo[i][pGang] == GangInfo[gangid][gAlliance])  && !PlayerInfo[i][pToggleGang])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SM(i, 0x6DFB6DFF, "** (A-Radio] %s %s: %.*s... **", GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SM(i, 0x6DFB6DFF, "** (A-Radio] %s %s: ...%s **", GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, 0x6DFB6DFF, "** (A-Radio) %s %s: %s **", GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}

CMD:members(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] != -1)
	{
		callcmd::gmembers(playerid);
	}
	if(PlayerInfo[playerid][pFaction] != -1)
	{
 		callcmd::fmembers(playerid);
	}
	return 1;
}

CMD:fmembers(playerid)
{
	if(PlayerInfo[playerid][pFaction] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not apart of any faction.");
	}

    SendClientMessage(playerid, SERVER_COLOR, "Factions Online:");
    new string[128], color = FactionInfo[PlayerInfo[playerid][pFaction]][fColor];

    foreach(new i : Player)
    {
        if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction])
        {
            format(string, sizeof(string), "(ID: %i) %s {%06x}%s"WHITE"", i, FactionRanks[PlayerInfo[i][pFaction]][PlayerInfo[i][pFactionRank]], color >>> 8, GetRPName(i));
			if(PlayerInfo[i][pDivision] >= 0)
			{
			    format(string, sizeof(string), "%s | Division: %s", string, FactionDivisions[PlayerInfo[i][pFaction]][PlayerInfo[i][pDivision]]);
			}
			if(FactionInfo[PlayerInfo[i][pFaction]][fType] == FACTION_MEDIC)
			{
			    SendClientMessage(playerid, COLOR_WHITE, string);
			    format(string, sizeof(string), "%s | Total Patients: %i | Total Fires: %i", string, PlayerInfo[i][pTotalPatients], PlayerInfo[i][pTotalFires]);
			}
			format(string, sizeof(string), "%s | Location: %s", string, GetPlayerZoneName(i));
			if(PlayerInfo[i][pAFK])
            {
				format(string, sizeof(string), "%s | "SVRCLR"AFK"WHITE" (%d secs)", string, PlayerInfo[i][pAFKTime]);
			}
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
    }

	return 1;
}
CMD:gmembers(playerid)
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a gang at the moment.");
	}

    SendClientMessage(playerid, SERVER_COLOR, "Gangs Online:");
	new string[128], color = GangInfo[PlayerInfo[playerid][pGang]][gColor];
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pGang] == PlayerInfo[playerid][pGang])
        {
            format(string, sizeof(string), "(%i) %s {%06x}%s"WHITE"", PlayerInfo[i][pGangRank], GangRanks[PlayerInfo[i][pGang]][PlayerInfo[i][pGangRank]], color >>> 8, GetRPName(i));
   			format(string, sizeof(string), "%s | Location: %s", string, GetPlayerZoneName(i));
			if(PlayerInfo[i][pAFK])
            {
				format(string, sizeof(string), "%s | "SVRCLR"AFK"WHITE" (%d secs)", string, PlayerInfo[i][pAFKTime]);
			}
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
    }

    return 1;
}

CMD:gang(playerid, params[])
{
	new targetid, option[16], param[128];

	if(PlayerInfo[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
	}
	if(sscanf(params, "s[16]S()[128]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Invite, Kick, Rank, Roster, Online, Quit, Offlinekick");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: MOTD, Stash, Stats, Rankname, Skin, Upgrade, Allience");
	    return 1;
	}
	if(!strcmp(option, "invite", true))
	{
		if(PlayerInfo[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [invite] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pGangBan] == 1)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "This player has been banned from joining any gang.");
		}
		if(PlayerInfo[targetid][pGang] != -1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already apart of a gang.");
		}
		if(PlayerInfo[targetid][pLevel] < 1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The one you're going to invite needs to be level 1 inorder to join the gang.");
		}
		if(PlayerInfo[targetid][pFaction] >= 0 && FactionInfo[PlayerInfo[targetid][pFaction]][fType] != FACTION_HITMAN)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is a part of a faction and therefore can't join your gang.");
		}
 		if(GangClaimingTurfs(PlayerInfo[playerid][pGang]) || GangCapturingPoints(PlayerInfo[playerid][pGang]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can not use invite if your gang is attending a turf or point.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE gang = %i", PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptInviteGang", "ii", playerid, targetid);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;
		if(PlayerInfo[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY2, "You need to be at least rank 5+ to use this command.");
		}
	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Gang Skins:");

	        for(new i = 0; i < MAX_GANG_SKINS; i ++)
	        {
	            if(GangInfo[PlayerInfo[playerid][pGang]][gSkins][i] == 0)
	            	SM(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SM(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[PlayerInfo[playerid][pGang]][gSkins][i]);
	        }

	        return SM(playerid, COLOR_GREY2, "Usage: /gang [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
	    }
	    if(!(1 <= slot <= MAX_GANG_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_GREY2, "Invalid slot.");
		}
		if(!(0 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_GREY2, "Invalid skin.");
		}

		slot--;

		GangInfo[PlayerInfo[playerid][pGang]][gSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", PlayerInfo[playerid][pGang], slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_WHITE, "** You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "kick", true))
	{
		if(PlayerInfo[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(PlayerInfo[targetid][pGang] != PlayerInfo[playerid][pGang])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your gang.");
		}
		if(PlayerInfo[targetid][pGangRank] > PlayerInfo[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
		}

		//Log_Write("log_gang", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang], GangRanks[PlayerInfo[targetid][pGang]][PlayerInfo[targetid][pGangRank]], PlayerInfo[targetid][pGangRank]);

		PlayerInfo[targetid][pGang] = -1;
		PlayerInfo[targetid][pGangRank] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_AQUA, "%s has kicked you from the gang.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "You have kicked %s from your gang.", GetRPName(targetid));
	}
	else if(!strcmp(option, "rank", true))
	{
	    new rankid;

		if(PlayerInfo[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "ui", targetid, rankid))
		{
		    return SM(playerid, COLOR_SYNTAX, "Usage: /gang [rank] [playerid] [rankid (0-6)]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(rankid < 0 || rankid > PlayerInfo[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The rank specified is either invalid or higher than your rank.");
		}
		if(PlayerInfo[targetid][pGang] != PlayerInfo[playerid][pGang])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not apart of your gang.");
		}
		if(PlayerInfo[targetid][pGangRank] > PlayerInfo[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
		}

		PlayerInfo[targetid][pGangRank] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gangrank = %i WHERE uid = %i", rankid, PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(targetid, COLOR_AQUA, "%s has set your rank to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(playerid), GangRanks[PlayerInfo[playerid][pGang]][rankid], rankid);
		SM(playerid, COLOR_AQUA, "You have set %s's rank to "SVRCLR"%s{CCFFFF} (%i).", GetRPName(targetid), GangRanks[PlayerInfo[playerid][pGang]][rankid], rankid);
		//Log_Write("log_gang", "%s (uid: %i) has set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang], GangRanks[PlayerInfo[playerid][pGang]][rankid], rankid);
	}
	else if(!strcmp(option, "stash", true))
	{
		if(PlayerInfo[playerid][pAdmin] < 2)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be an admin to place the stash ((TO AVOID ABUSE)).");
		}
		if(PlayerInfo[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
		}
		if(isnull(param) || strcmp(param, "confirm", true) != 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [stash] [confirm] (Moves the gang stash.)");
		}

		GetPlayerPos(playerid, GangInfo[PlayerInfo[playerid][pGang]][gStashX], GangInfo[PlayerInfo[playerid][pGang]][gStashY], GangInfo[PlayerInfo[playerid][pGang]][gStashZ]);
		GangInfo[PlayerInfo[playerid][pGang]][gStashInterior] = GetPlayerInterior(playerid);
		GangInfo[PlayerInfo[playerid][pGang]][gStashWorld] = GetPlayerVirtualWorld(playerid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET stash_x = '%f', stash_y = '%f', stash_z = '%f', stashinterior = %i, stashworld = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gStashX], GangInfo[PlayerInfo[playerid][pGang]][gStashY], GangInfo[PlayerInfo[playerid][pGang]][gStashZ], GangInfo[PlayerInfo[playerid][pGang]][gStashInterior], GangInfo[PlayerInfo[playerid][pGang]][gStashWorld], PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(PlayerInfo[playerid][pGang]);
		SM(playerid, COLOR_AQUA, "You have moved the gang stash to your location. /gstash to access your stash.");
	}
	else if(!strcmp(option, "stats", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE gang = %i", PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_GANG_INFORMATION, playerid);
	}
	else if(!strcmp(option, "roster", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin, gangrank FROM users WHERE gang = %i ORDER BY gangrank DESC", PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_GANG_ROSTER, playerid);
	}
	else if(!strcmp(option, "online", true))
	{
	    callcmd::gmembers(playerid);
	}
	else if(!strcmp(option, "quit", true))
	{
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [quit] [confirm]");
	    }


	    SM(playerid, COLOR_AQUA, "You have quit %s as a "SVRCLR"%s{CCFFFF} (%i).", GangInfo[PlayerInfo[playerid][pGang]][gName], GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], PlayerInfo[playerid][pGangRank]);
		//Log_Write("log_gang", "%s (uid: %i) has quit %s (id: %i) has rank %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang], GangRanks[PlayerInfo[playerid][pGang]][PlayerInfo[playerid][pGangRank]], PlayerInfo[playerid][pGangRank]);

	    PlayerInfo[playerid][pGang] = -1;
		PlayerInfo[playerid][pGangRank] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "offlinekick", true))
	{
	    new username[MAX_PLAYER_NAME];

		if(PlayerInfo[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "s[24]", username))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [offlinekick] [username]");
		}
		if(IsPlayerOnline(username))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use '/gang kick' instead.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, gang, gangrank FROM users WHERE username = '%e'", username);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerOfflineKickGang", "is", playerid, username);
	}
	else if(!strcmp(option, "motd", true))
	{
	    if(PlayerInfo[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
		}
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [motd] [text]");
		}

		strcpy(GangInfo[PlayerInfo[playerid][pGang]][gMOTD], param, 128);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET motd = '%e' WHERE id = %i", param, PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(PlayerInfo[playerid][pGang]);
		SendClientMessage(playerid, COLOR_AQUA, "You have changed the MOTD for your gang.");
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

        if(PlayerInfo[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
		}
	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, SERVER_COLOR, "Rank Names:");

	        for(new i = 0; i < 7; i ++)
	        {
	            if(isnull(GangRanks[PlayerInfo[playerid][pGang]][i]))
	            	SM(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SM(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[PlayerInfo[playerid][pGang]][i]);
	        }

	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [rankname] [slot (0-6)] [name]");
	    }
	    if(!(0 <= rankid <= 6))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
		}

	    strcpy(GangRanks[PlayerInfo[playerid][pGang]][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", PlayerInfo[playerid][pGang], rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_AQUA, "You have set the name of rank %i to "SVRCLR"%s{CCFFFF}.", rankid, rank);
	}
	else if(!strcmp(option, "npc", true))
	{
	    new type, confirm[10];

	    if(PlayerInfo[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
		}
		if(sscanf(param, "is[10]", type, confirm))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [npc] [slot] [confirm]");
		    SendClientMessage(playerid, COLOR_GREY2, "List of slots: (1) Arms Dealer (2) Drug Dealer");
		    return 1;
		}
		if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command from within the vehicle.");
		}

		if(!isnull(confirm) && !strcmp(confirm, "confirm", true))
		{
			if(type == 1)
			{
			    if(!GangInfo[PlayerInfo[playerid][pGang]][gArmsDealer])
				{
		    		return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have the arms dealer upgrade. (/gang upgrade)");
				}

				GetPlayerPos(playerid, GangInfo[PlayerInfo[playerid][pGang]][gArmsX], GangInfo[PlayerInfo[playerid][pGang]][gArmsY], GangInfo[PlayerInfo[playerid][pGang]][gArmsZ]);
				SetPlayerPos(playerid, GangInfo[PlayerInfo[playerid][pGang]][gArmsX] + 1.0, GangInfo[PlayerInfo[playerid][pGang]][gArmsY], GangInfo[PlayerInfo[playerid][pGang]][gArmsZ] + 1.0);
		        GetPlayerFacingAngle(playerid, GangInfo[PlayerInfo[playerid][pGang]][gArmsA]);
		        GangInfo[PlayerInfo[playerid][pGang]][gArmsWorld] = GetPlayerVirtualWorld(playerid);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET arms_x = '%f', arms_y = '%f', arms_z = '%f', arms_a = '%f', armsworld = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsX], GangInfo[PlayerInfo[playerid][pGang]][gArmsY], GangInfo[PlayerInfo[playerid][pGang]][gArmsZ], GangInfo[PlayerInfo[playerid][pGang]][gArmsA], GangInfo[PlayerInfo[playerid][pGang]][gArmsWorld], PlayerInfo[playerid][pGang]);
		        mysql_tquery(connectionID, queryBuffer);

		        ReloadGang(PlayerInfo[playerid][pGang]);
		        SendClientMessage(playerid, COLOR_AQUA, "You have moved the position of the arms dealer for your gang.");
			}
			else if(type == 2)
			{
			    if(!GangInfo[PlayerInfo[playerid][pGang]][gDrugDealer])
				{
		    		return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have the drug dealer upgrade. (/gang upgrade)");
				}

				GetPlayerPos(playerid, GangInfo[PlayerInfo[playerid][pGang]][gDrugX], GangInfo[PlayerInfo[playerid][pGang]][gDrugY], GangInfo[PlayerInfo[playerid][pGang]][gDrugZ]);
				SetPlayerPos(playerid, GangInfo[PlayerInfo[playerid][pGang]][gDrugX] + 1.0, GangInfo[PlayerInfo[playerid][pGang]][gDrugY], GangInfo[PlayerInfo[playerid][pGang]][gDrugZ] + 1.0);
		        GetPlayerFacingAngle(playerid, GangInfo[PlayerInfo[playerid][pGang]][gDrugA]);
		        GangInfo[PlayerInfo[playerid][pGang]][gDrugWorld] = GetPlayerVirtualWorld(playerid);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drug_x = '%f', drug_y = '%f', drug_z = '%f', drug_a = '%f', drugworld = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugX], GangInfo[PlayerInfo[playerid][pGang]][gDrugY], GangInfo[PlayerInfo[playerid][pGang]][gDrugZ], GangInfo[PlayerInfo[playerid][pGang]][gDrugA], GangInfo[PlayerInfo[playerid][pGang]][gDrugWorld], PlayerInfo[playerid][pGang]);
		        mysql_tquery(connectionID, queryBuffer);

		        ReloadGang(PlayerInfo[playerid][pGang]);
		        SendClientMessage(playerid, COLOR_AQUA, "You have moved the position of the drug dealer for your gang.");
			}
		}
	}
	else if(!strcmp(option, "upgrade", true))
	{
	    if(PlayerInfo[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
		}

		new
		    title[48],
			string[1024] = "Perk\tDescription\tCost";

		strcat(string, "\nDrug dealer\tAn NPC which sells individually stocked drugs\t{F7A763}500 GP "WHITE"+"SVRCLR" $50,000");
		strcat(string, "\nArms dealer\tAn NPC which sells individually stocked weapons\t{F7A763}500 GP "WHITE"+"SVRCLR" $50,000");

		if(GangInfo[PlayerInfo[playerid][pGang]][gLevel] == 1)
		{
		    strcat(string, "\nLevel Up\tAdvance your gang's level to 2/3.\t{F7A763}6000 GP "WHITE"+"SVRCLR" $75,000");
		}
		else if(GangInfo[PlayerInfo[playerid][pGang]][gLevel] == 2)
		{
		    strcat(string, "\nLevel Up\tAdvance your gang's level to 3/3.\t{F7A763}12000 GP "WHITE"+"SVRCLR" $100,000");
		}

		format(title, sizeof(title), "Gang upgrades (Your gang has %i GP.)", GangInfo[PlayerInfo[playerid][pGang]][gPoints]);
		ShowPlayerDialog(playerid, DIALOG_GANGPOINTSHOP, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Select", "Cancel");
	}
	else if(!strcmp(option, "alliance", true))
	{
	    new gangid = PlayerInfo[playerid][pGang];

		if(PlayerInfo[playerid][pGangRank] < 6)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 6+ to use this command.");
	  	}
		if(sscanf(param, "u", targetid))
	  	{
	   		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gang [alliance] [playerid]");
	  	}
  	 	if(GangInfo[gangid][gAlliance] >= 0)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You're already in an alliance, end it first! (/endalliance)");
	  	}
	  	if(PlayerInfo[targetid][pGangRank] < 6)
	  	{
			return SendClientMessage(playerid, COLOR_SYNTAX, "The player you're offering to ally with must be R6 in their gang!");
	  	}
        if(PlayerInfo[targetid][pGang] == gangid)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot form an alliance with your own gang!");
		}

		if(GangInfo[gangid][gAlliance] == -1)
		{
			SM(playerid, COLOR_AQUA, "You've offered to form a gang alliance with %s.", GetRPName(targetid));
			SM(targetid, COLOR_AQUA, "%s has offered to form an alliance with your gang. (/accept alliance)", GetRPName(playerid));
			PlayerInfo[targetid][pAllianceOffer] = playerid;
		}
	}

	return 1;
}


CMD:gstash(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a gang at the moment.");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, GangInfo[PlayerInfo[playerid][pGang]][gStashX], GangInfo[PlayerInfo[playerid][pGang]][gStashY], GangInfo[PlayerInfo[playerid][pGang]][gStashZ]))
    {
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of your gang stash.");
	}
    if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to open the stash. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to the gstash, bobo!", GetRPName(playerid));
	}

	ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
	return 1;
}

CMD:bandana(playerid, params[])
{
    if(PlayerInfo[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a gang at the moment.");
	}
	new gang = PlayerInfo[playerid][pGang], color, string[128];
	if(PlayerInfo[playerid][pBandana])
	{
		UpdateDynamic3DTextLabelText(PlayerLabel[playerid], COLOR_WHITE, "");
 		PlayerInfo[playerid][pBandana] = 0;
     	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes off their bandana and puts it back to their pocket.", GetRPName(playerid));
		ApplyAnimationEx(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
	}
	else
	{
		if(PlayerInfo[playerid][pJoinedEvent] || PlayerInfo[playerid][pPaintballTeam] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can not put on your bandana on while in a event or paintball match.");
		}
		if(GangInfo[gang][gColor] == -1 || GangInfo[gang][gColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
		    color = GangInfo[gang][gColor];
		}

		format(string, sizeof(string), "{%06x}%s\n"WHITE"%s", color >>> 8, GangInfo[gang][gName],GangRanks[gang][PlayerInfo[playerid][pGangRank]]);
		UpdateDynamic3DTextLabelText(PlayerLabel[playerid], COLOR_WHITE, string);
 		PlayerInfo[playerid][pBandana] = 1;
       	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out their bandana and wraps it around their forehead.", GetRPName(playerid));
		ApplyAnimationEx(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
	}
	return 1;
}

CMD:gbuyvehicle(playerid, params[])
{
	static string[4096];
    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
	}
	if(GetGangVehicles(PlayerInfo[playerid][pGang]) >= GetGangVehicleLimit(PlayerInfo[playerid][pGang]))
    {
        return SM(playerid, COLOR_SYNTAX, "Your gang can't have more than %i vehicles at its level.", GetGangVehicleLimit(PlayerInfo[playerid][pGang]));
    }

	PlayerInfo[playerid][pGangCar] = 1;

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 542.0433, -1293.5909, 17.2422))
	{
  		string = "Category\tVehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(strcmp(vehicleArray[i][carCategory], "Boats") != 0 && strcmp(vehicleArray[i][carCategory], "Aircraft") != 0)
	  		{
		    	format(string, sizeof(string), "%s\n%s\t%s\t"SVRCLR"%s"WHITE"", string, vehicleArray[i][carCategory], vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Grotti Dealership", string, "Buy", "Cancel");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 154.2223, -1946.3030, 5.1920))
	{
    	string = "Vehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(!strcmp(vehicleArray[i][carCategory], "Boats"))
	  		{
		    	format(string, sizeof(string), "%s\n%s\t"SVRCLR"%s"WHITE"", string, vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BUYBOAT, DIALOG_STYLE_TABLIST_HEADERS, "Boat Dealership", string, "Buy", "Cancel");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1892.6315, -2328.6721, 13.5469))
	{
     	string = "Vehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(!strcmp(vehicleArray[i][carCategory], "Aircraft"))
	  		{
		    	format(string, sizeof(string), "%s\n%s\t"SVRCLR"%s"WHITE"", string, vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BUYAIRCRAFT, DIALOG_STYLE_TABLIST_HEADERS, "Aircraft Dealership", string, "Buy", "Cancel");
	}

	return 1;
}

CMD:gfindcar(playerid, params[])
{
	new string[512], count;

    if(PlayerInfo[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a gang at the moment.");
	}

	string = "#\tModel\tLocation";

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerInfo[playerid][pGang])
	    {
	        format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
	        count++;
		}
	}

	if(!count)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang has no vehicles which you can track.");
	}

	ShowPlayerDialog(playerid, DIALOG_GANGFINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Gang vehicles", string, "Track", "Cancel");
	return 1;
}

CMD:gotopoint(playerid, params[])
{
	new pointid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", pointid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotopoint [pointid]");
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid point.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:editpoint(playerid, params[])
{
	new pointid, option[14], param[32];

	if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[32]", pointid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [option]");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Name, Location, CapturedBy, Gang, Type, Profits, Time");
	    return 1;
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid point.");
	}

 	if(!strcmp(option, "name", true))
    {
        if(isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [name] [text]");
		}

		strcpy(PointInfo[pointid][pName], param, 32);
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET name = '%e' WHERE id = %i", PointInfo[pointid][pName], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the name of point %i to %s.", GetRPName(playerid), pointid, param);
		SM(playerid, COLOR_AQUA, "You have set the name of point %i to {F7A763}%s{CCFFFF}.", pointid, param);
	}
	else if(!strcmp(option, "location", true))
    {
		GetPlayerPos(playerid, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ]);
		PointInfo[pointid][pPointInterior] = GetPlayerInterior(playerid);
		PointInfo[pointid][pPointWorld] = GetPlayerVirtualWorld(playerid);
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET point_x = '%f', point_y = '%f', point_z = '%f', pointinterior = %i, pointworld = %i WHERE id = %i", PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], PointInfo[pointid][pPointInterior], PointInfo[pointid][pPointWorld], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has moved the location of point %i.", GetRPName(playerid), pointid);
		SM(playerid, COLOR_AQUA, "You have moved the location of point %i.", pointid);
	}
	else if(!strcmp(option, "capturedby", true))
    {
        if(isnull(param) || strlen(params) > 24)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [capturedby] [name]");
		}

		strcpy(PointInfo[pointid][pCapturedBy], param, MAX_PLAYER_NAME);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedby = '%e' WHERE id = %i", PointInfo[pointid][pCapturedBy], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the capturer of point %i to %s.", GetRPName(playerid), pointid, param);
		SM(playerid, COLOR_AQUA, "You have set the capturer of point %i to {F7A763}%s{CCFFFF}.", pointid, param);
	}
	else if(!strcmp(option, "gang", true))
    {
        new gangid;

        if(sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [gang] [gangid (-1 = none)]");
		}
		if(!(0 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
		}

		PointInfo[pointid][pCapturedGang] = gangid;
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedgang = %i WHERE id = %i", PointInfo[pointid][pCapturedBy], pointid);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		{
            SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset the capturing gang of point %i.", GetRPName(playerid), pointid);
			SM(playerid, COLOR_AQUA, "You have reset the capturing gang of point %i.", pointid);
		}
		else
		{
			SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the capturing gang of point %i to %s.", GetRPName(playerid), pointid, GangInfo[gangid][gName]);
			SM(playerid, COLOR_AQUA, "You have set the capturing gang of point %i to "SVRCLR"%s{CCFFFF}.", pointid, GangInfo[gangid][gName]);
		}
	}
	else if(!strcmp(option, "type", true))
    {
        new type;

        if(sscanf(param, "i", type))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [type] [value]");
           	SendClientMessage(playerid, COLOR_GREY2, "List of types: (1) Drug factory (2) Drug den (3) Crack house (4) Auto export (5) Fuel");
			SendClientMessage(playerid, COLOR_GREY2, "List of types: (6) Mat pickup 1 (7) Mat pickup 2 (8) Mat factory 1 (9) Mat factory 2");
            return 1;
		}
		if(!(0 <= type <= 9))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		PointInfo[pointid][pType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET type = %i WHERE id = %i", PointInfo[pointid][pType], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the type of point %i to %i.", GetRPName(playerid), pointid, type);
		SM(playerid, COLOR_AQUA, "You have set the type of point %i to %i.", pointid, type);
	}
    else if(!strcmp(option, "profits", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [profits] [value]");
		}

		PointInfo[pointid][pProfits] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET profits = %i WHERE id = %i", PointInfo[pointid][pProfits], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the profits of point %i to $%i.", GetRPName(playerid), pointid, value);
		SM(playerid, COLOR_AQUA, "You have set the profits of point %i to $%i.", pointid, value);
	}
	else if(!strcmp(option, "time", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editpoint [pointid] [time] [hours (0-24)]");
		}
		if(!(0 <= value <= 24))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of hours must range from 0 to 24.");
		}

		PointInfo[pointid][pTime] = value;

		if(PointInfo[pointid][pTime] == 0)
		{
		    SMA(COLOR_GREEN, "%s is now available to capture.", PointInfo[pointid][pName]);
		}
		else
		{
		    PointInfo[pointid][pCapturer] = INVALID_PLAYER_ID;
		    PointInfo[pointid][pCaptureTime] = 0;
		}

		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET time = %i WHERE id = %i", PointInfo[pointid][pTime], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the time of point %i to %i hours.", GetRPName(playerid), pointid, value);
		SM(playerid, COLOR_AQUA, "You have set the time of point %i to %i hours.", pointid, value);
	}

	return 1;
}
CMD:sellrentcar(playerid, params[]) {
    new targetid, amount;
    new minute;
    new vehicleid = GetPlayerVehicleID(playerid);
    
	if (PlayerInfo[playerid][pAdmin] <= 10 && strcmp(PlayerInfo[playerid][pUsername], "Beast_Vasu", true) != 0 && strcmp(PlayerInfo[playerid][pUsername], "Beast_Rammanan", true) != 0) {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You do not have permission to use this command.");
    }

    if (sscanf(params, "ufi", targetid, minute , amount)) {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellrentcar [playerid] [minute] [price]");
    }

	if(minute <= 0){
		return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of minutes must be greater");
	}

    if (!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_RED, "Error: Player not connected.");
    }

    if (!vehicleid) {
        return SendClientMessage(playerid, COLOR_RED, "Error: You are not in a vehicle.");
    }

	if(!IsVehicleOwner(playerid, vehicleid)){
		return SendClientMessage(playerid, COLOR_SYNTAX, "You do not own this vehicle");
	}
	if(VehicleInfo[vehicleid][vRent])
	{
		return SendClientMessage(playerid, COLOR_RED, "Dont Cheat Buddy Sura Anti System Here");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must specify an amount above zero.");
	}

	PlayerInfo[targetid][pCarOffer] = playerid;
	PlayerInfo[targetid][pCarOffered] = vehicleid;
	PlayerInfo[targetid][pCARPrice] = amount;
	PlayerInfo[targetid][pCartime] = minute;
	PlayerInfo[targetid][pCartype] = 1;



	SM(targetid, COLOR_AQUA, "** %s offered you their %s for $%i for %d minutes Rent (/accept rentvehicle).", GetRPName(playerid), GetVehicleName(vehicleid), amount, minute);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your %s for $%i for %d minutes rent.", GetRPName(targetid), GetVehicleName(vehicleid), amount, minute);
	return 1;
}

CMD:removepoint(playerid, params[])
{
	new pointid;

	if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", pointid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removepoint [pointid]");
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid point.");
	}

	DestroyDynamic3DTextLabel(PointInfo[pointid][pText]);
	DestroyDynamicPickup(PointInfo[pointid][pPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM points WHERE id = %i", pointid);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has deleted point %s.", GetRPName(playerid), PointInfo[pointid][pName]);
	SM(playerid, COLOR_AQUA, "You have deleted point {F7A763}%s{CCFFFF}.", PointInfo[pointid][pName]);

	PointInfo[pointid][pExists] = 0;
	PointInfo[pointid][pCapturedGang] = -1;
	PointInfo[pointid][pTime] = 0;
	return 1;
}

GangCapturingPoints(gang)
{
	new capCount = 0;
	for(new x = 0; x < MAX_POINTS; x++)
	{
		if(PointInfo[x][pExists] && PointInfo[x][pCapturer] != INVALID_PLAYER_ID && PointInfo[x][pTime] == 0)
		{
  			if(PlayerInfo[PointInfo[x][pCapturer]][pGang] == gang)
  			{
          		capCount++;
  			}
		}
	}
	return capCount;
}

GangClaimingTurfs(gang)
{
	new capCount = 0;
	for(new x = 0; x < MAX_TURFS; x++)
	{
		if(TurfInfo[x][tExists] && TurfInfo[x][tCapturer] != INVALID_PLAYER_ID && TurfInfo[x][tTime] == 0)
		{
			if(PlayerInfo[TurfInfo[x][tCapturer]][pGang] == gang)
			{
    			capCount++;
			}
		}
	}
	return capCount;
}


CMD:capture(playerid, params[])
{
    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
	}
	if(PlayerInfo[playerid][pCapturingPoint] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already attempting to capture the point.");
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't capture a point while injured.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(GangCapturingPoints(PlayerInfo[playerid][pGang]) >= MaxCapCount[1])
	{
	    return SM(playerid, COLOR_SYNTAX, "You're gang is already capturing %i points.", MaxCapCount[1]);
	}
	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && IsPlayerInRangeOfPoint(playerid, 1.0, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]) && GetPlayerInterior(playerid) == PointInfo[i][pPointInterior] && GetPlayerVirtualWorld(playerid) == PointInfo[i][pPointWorld])
		{
			if(PointInfo[i][pTime] > 0)
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "This point is not available to capture yet.");
		    }
		    if(PointInfo[i][pCapturer] == playerid)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "This point is already being captured by you.");
		    }
		    if(PointInfo[i][pCapturer] != INVALID_PLAYER_ID && PlayerInfo[PointInfo[i][pCapturer]][pGang] == PlayerInfo[playerid][pGang])
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "This point is already being captured by your gang.");
			}

		    foreach(new x : Player)
		    {
		        if(PlayerInfo[x][pCapturingPoint] == i && PlayerInfo[x][pCaptureTime] > 0)
		        {
		            return SendClientMessage(playerid, COLOR_SYNTAX, "Someone else is already attempting to capture. Please wait until they're done.");
				}
			}

		    PlayerInfo[playerid][pCapturingPoint] = i;
		    PlayerInfo[playerid][pCaptureTime] = 10;

			GetPlayerPos(playerid, PlayerInfo[playerid][pPointX], PlayerInfo[playerid][pPointY], PlayerInfo[playerid][pPointZ]);
		    SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "(( %s is attempting to capture %s. ))", GetRPName(playerid), PointInfo[i][pName]);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any points.");
	return 1;
}

CMD:it(playerid, params[])
{
   new time;
   if(PlayerInfo[playerid][pAdmin] < 3)
   {
	   return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorised to use this command.");
   }
   if(sscanf(params, "i", time))
   {
       return SendClientMessage(playerid, COLOR_WHITE, "Usage: /it [time]");
   }

   InfluenceInfo[iTime] = time * 60;
   SM(playerid, COLOR_YELLOW, "You have set the turf time to %i Minutes", time);
   return 1;
}

CMD:i(playerid, params[]) return callcmd::influence(playerid, params);
CMD:influence(playerid, params[])
{
   new gangid;
   if(PlayerInfo[playerid][pAdmin] < 3)
   {
	   return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorised to use this command.");
   }
   if(sscanf(params, "i", gangid))
   {
       SendClientMessage(playerid, COLOR_WHITE, "Usage: /infbar [gangid]");
       SendClientMessage(playerid, COLOR_WHITE, "(-1) Police.");
       return 1;
   }
   if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
   {
	  return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
   }


   InfluenceInfo[iEnabled] = 1;
   InfluenceInfo[iGangid] = gangid;
   return 1;
}

CMD:ioff(playerid, params[]) return callcmd::influenceoff(playerid, params);
CMD:influenceoff(playerid, params[])
{
   if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_WHITE, "You are not a admin.");
   if(InfluenceInfo[iEnabled] == 0) return SendClientMessage(playerid, COLOR_SYNTAX, "Influence bar is off");

   InfluenceInfo[iEnabled] = 0;
   InfluenceInfo[iGangid] = -1;

   SM(playerid, COLOR_YELLOW, "Influence Bar Turned Off.");
   return 1;
}

CMD:tstart(playerid, params[])
{
   new turfid;
   new time;
   if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_WHITE, "You are not a admin.");
   if(InfluenceInfo[iStart] == 1) return SendClientMessage(playerid, COLOR_SYNTAX, "Turf war is already started.");
   if(sscanf(params, "i", turfid)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /tstart [turfid]");
   if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists]) return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid turf.");
   if(InfluenceInfo[iTurf] == turfid) return SendClientMessage(playerid, COLOR_SYNTAX, "This turf is already started.");

   InfluenceInfo[iStart] = 1;
   InfluenceInfo[iTurf] = turfid;
   InfluenceInfo[iTime] = 30 * 60;
   InfluenceInfo[iEnabled] = 1;
   SM(playerid, COLOR_YELLOW, "You have set the turf time to %i Minutes", time);

   SMA(COLOR_YELLOW, "[Turfwar Announce]"RED" Turf War Has Started. %s is now redzone.  is now redzone", TurfInfo[turfid][tName]);
   SMA(COLOR_YELLOW, "[Turfwar Announce]"RED" Turf War Has Started. %s is now redzone.  is now redzone", TurfInfo[turfid][tName]);
   SMA(COLOR_YELLOW, "[Turfwar Announce]"RED" Turf War Has Started. %s is now redzone.  is now redzone", TurfInfo[turfid][tName]);
   SAM(COLOR_LIGHTRED, "AdmCmd: %s has started the turf war.", GetRPName(playerid));

   new string[128];
   format(string, sizeof(string), "~r~Turf_On_Progress");
   DynamicTextDrawSetString(Textdraw2, string);


   foreach(new i: Player)
   {
		GangZoneFlashForPlayer(i, TurfInfo[turfid][tGangZone], (0xFFf74d4dFF & ~0xff) + 0xAA);
	//	ShowTurfsOnMap(i);
   }
   return 1;
}

CMD:tstop(playerid, params[])
{
   new turfid;
   if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_WHITE, "You are not a admin.");
   if(InfluenceInfo[iStart] == 0) return SendClientMessage(playerid, COLOR_SYNTAX, "Turf war is not started.");
   if(sscanf(params, "i", turfid)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /tstop [turfid]");
   if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists]) return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid turf.");
   if(!turfid) return SendClientMessage(playerid, COLOR_SYNTAX, "This turf is not started.");

   if(InfluenceInfo[iTurf] == turfid)
   {
      InfluenceInfo[iStart] = 0;
      InfluenceInfo[iTurf] = -1;
      InfluenceInfo[iEnabled] = 0;
      InfluenceInfo[iGangid] = -1;
      InfluenceInfo[iTime] = 0 * 60;
      SMA(COLOR_YELLOW, "[Turfwar Announce]"WHITE" Turf War Ended.");
      SMA(COLOR_BLUE, "[Turfwar Announce]"YELLOW" GGWP  BOTH GANGS.");
      SAM(COLOR_LIGHTRED, "AdmCmd: %s has stopped the turf war.", GetRPName(playerid));

      InfluenceInfo[iEnabled] = 0;

      new string[2500];
      format(string, sizeof(string), "~y~Priority_On_Hold");
      DynamicTextDrawSetString(Textdraw2, string);

      foreach(new i: Player)
       {
	   	   GangZoneStopFlashForPlayer(i, TurfInfo[turfid][tGangZone]);
	     //ShowTurfsOnMap(i);
       }
   }
   else
   {
		 SendClientMessage(playerid, COLOR_SYNTAX, "This turf is not started yet.");
   }
   return 1;
}
CMD:istop(playerid, params[])
{
   new i;
   if(PlayerInfo[playerid][pAdmin] < 7) return SendClientMessage(playerid, COLOR_WHITE, "You are not a admin.");
   if(sscanf(params, "i", i)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /tstop [turfid]");
   EndInfluenceWar(i);

   return 1;
}
CMD:tann(playerid, params[])
{
   if(PlayerInfo[playerid][pAdmin] < 3)
   {
      return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorised");
   }
   if(isnull(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Usage: /tann [announce text]");
   
   SMA(COLOR_YELLOW, "[Turf News] "WHITE"%s", params);
   return 1;
}

CMD:endalliance(playerid, params[])
{
	new gangid = PlayerInfo[playerid][pGang];
	new allyid = GangInfo[gangid][gAlliance];
	new color, color2;

	if(isnull(params) || strcmp(params, "confirm", true) != 0)
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /endalliance [confirm]");
	}
	if(PlayerInfo[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be in a gang to use this command");
	}
	if(PlayerInfo[playerid][pGangRank] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be rank 6 to use this command.");
	}
	if(GangInfo[gangid][gAlliance] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang isn't currently in an alliance.");
	}

	SM(playerid, COLOR_YELLOW, "You just ended your alliance with %s.", GangInfo[gangid][gName]);

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

	SMA(COLOR_GREEN, "Gang News: {%06x}%s"WHITE" has ended their alliance with {%06x}%s", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = -1 WHERE id = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET alliance = -1 WHERE id = %i", allyid);
	mysql_tquery(connectionID, queryBuffer);

	GangInfo[allyid][gAlliance] = -1;
	GangInfo[gangid][gAlliance] = -1;

	return 1;
}

CMD:guninv(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "My Weapons:");

	for(new i = 0; i < 13; i ++)
	{
     	if(PlayerInfo[playerid][pWeapons][i] > 0)
	    {
	        SM(playerid, COLOR_GREY2, "(ID: %i) %s", PlayerInfo[playerid][pWeapons][i], GetWeaponNameEx(PlayerInfo[playerid][pWeapons][i]));
		}
	}

	return 1;
}

CMD:loadammo(playerid, params[])
{
	new weaponid, type[14];

	if(sscanf(params, "is[14]", weaponid, type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /loadammo [weaponid] [type] (/guninv for weapon IDs)");
	    SendClientMessage(playerid, COLOR_GREY2, "List of types: Normal, HollowPoint, PoisonTip, FMJ");
	    return 1;
	}
    if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
	}
	if(!(22 <= weaponid <= 34))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That weapon can't be loaded with ammunition.");
	}
	if(PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}

	if(!strcmp(type, "normal", true))
	{
	    PlayerInfo[playerid][pAmmoType] = AMMOTYPE_NORMAL;
	    PlayerInfo[playerid][pAmmoWeapon] = 0;

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s loads their %s with normal ammunition.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessage(playerid, COLOR_AQUA, "You have loaded this weapon with "SVRCLR"Normal{CCFFFF} ammunition.");
	    ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
	}
	else if(!strcmp(type, "hollowpoint", true))
	{
	    if(!PlayerInfo[playerid][pHPAmmo])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no hollow point ammunition to load this weapon with.");
	    }

	    PlayerInfo[playerid][pAmmoType] = AMMOTYPE_HP;
	    PlayerInfo[playerid][pAmmoWeapon] = weaponid;

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s loads their %s with hollow point ammunition.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessage(playerid, COLOR_AQUA, "You have loaded this weapon with "SVRCLR"Hollow point{CCFFFF} ammunition.");
		ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
	}
	else if(!strcmp(type, "poisontip", true))
	{
	    if(!PlayerInfo[playerid][pPoisonAmmo])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no poison tip ammunition to load this weapon with.");
	    }

	    PlayerInfo[playerid][pAmmoType] = AMMOTYPE_POISON;
	    PlayerInfo[playerid][pAmmoWeapon] = weaponid;

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s loads their %s with poison tip ammunition.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessage(playerid, COLOR_AQUA, "You have loaded this weapon with "SVRCLR"Poison tip{CCFFFF} ammunition.");
		ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
	}
	else if(!strcmp(type, "fmj", true))
	{
	    if(!PlayerInfo[playerid][pFMJAmmo])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have no full metal jacket ammunition to load this weapon with.");
	    }

	    PlayerInfo[playerid][pAmmoType] = AMMOTYPE_FMJ;
	    PlayerInfo[playerid][pAmmoWeapon] = weaponid;

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s loads their %s with full metal jacket ammunition.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessage(playerid, COLOR_AQUA, "You have loaded this weapon with "SVRCLR"Full metal jacket{CCFFFF} ammunition.");
		ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
	}

	SetPlayerWeapons(playerid);
	return 1;
}

CMD:createturf(playerid, params[])
{
	new type, name[32];

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[32]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createturf [special type] [name]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of types: (0)None (1)Hollowpoint Ammo (2)Poison Ammo (3)FMJ ammo (4)Materials (5)Traphouse");
	    SendClientMessage(playerid, COLOR_GREY2, "List of types: (6)Crackhouse (7)Sales taxing (8)Low weps (9)Medium weps (10)High weps");
	    return 1;
	}
	if(!(0 <= type <= 10))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}
	if(GetNearbyTurf(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a turf in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create turfs indoors.");
	}

	PlayerInfo[playerid][pTurfType] = type;
	PlayerInfo[playerid][pZoneType] = ZONETYPE_TURF;

	strcpy(PlayerInfo[playerid][pTurfName], name, 32);
	ShowPlayerDialog(playerid, DIALOG_CREATEZONE, DIALOG_STYLE_MSGBOX, "Turf creation system", "You have entered turf creation mode. In order to create a turf you need\nto mark four points around the area you want your turf to be in, forming\na square. You must make a square or your outcome won't be as expected.\n\nPress "SVRCLR"Confirm{A9C4E4} to begin turf creation.", "Confirm", "Cancel");
	return 1;
}

CMD:turfcancel(playerid, params[])
{
	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(PlayerInfo[playerid][pZoneCreation] != ZONETYPE_TURF)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not creating a turf at the moment.");
	}

	CancelZoneCreation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTRED, "** Land creation cancelled.");
	return 1;
}
CMD:createpoint1(playerid, params[])
{
	new type, name[32];

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    if(sscanf(params, "is[32]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createpoint [type] [name]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of types: (1) Drug factory (2) Drug den (3) Crack house (4) Auto export (5) Fuel");
		SendClientMessage(playerid, COLOR_GREY2, "List of types: (6) Mat pickup 1 (7) Mat pickup 2 (8) Mat factory 1 (9) Mat factory 2");
	    return 1;
	}
	if(!(0 <= type <= 9))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}
	if(GetNearbyPoints2(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a Point in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create Points indoors.");
	}

	PlayerInfo[playerid][pPointType] = type;
	PlayerInfo[playerid][pZoneType] = ZONETYPE_POINT;

	strcpy(PlayerInfo[playerid][pPointName], name, 32);
	ShowPlayerDialog(playerid, DIALOG_CREATEZONE, DIALOG_STYLE_MSGBOX, "Point creation system", "You have entered Point creation mode. In order to create a Point you need\nto mark four points around the area you want your Point to be in, forming\na square. You must make a square or your outcome won't be as expected.\n\nPress "SVRCLR"Confirm{A9C4E4} to begin point creation.", "Confirm", "Cancel");
	return 1;
}

CMD:pointcancel(playerid, params[])
{
	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(PlayerInfo[playerid][pZoneCreation] != ZONETYPE_POINT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not creating a point at the moment.");
	}

	CancelZoneCreation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTRED, "** Land creation cancelled.");
	return 1;
}
CMD:gototurf(playerid, params[])
{
	new turfid;

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", turfid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gototurf [turfid]");
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid turf.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, TurfInfo[turfid][tMinX], TurfInfo[turfid][tMinY], TurfInfo[turfid][tHeight]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:removeturf(playerid, params[])
{
	new turfid;

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", turfid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removeturf [turfid]");
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid turf.");
	}

	GangZoneDestroy(TurfInfo[turfid][tGangZone]);
	DestroyDynamicArea(TurfInfo[turfid][tArea]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM turfs WHERE id = %i", turfid);
	mysql_tquery(connectionID, queryBuffer);

	TurfInfo[turfid][tExists] = 0;
	TurfInfo[turfid][tCapturedGang] = 0;
    TurfInfo[turfid][tType] = 0;

    SM(playerid, COLOR_AQUA, "** You have removed turf %i.", turfid);
	return 1;
}

CMD:editturf(playerid, params[])
{
	new turfid, option[14], param[32];

	if(!PlayerInfo[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[32]", turfid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [option]");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Name, ClaimBy, Gang, Type, Time");
	    return 1;
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid turf.");
	}

 	if(!strcmp(option, "name", true))
    {
        if(isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [name] [text]");
		}

		strcpy(TurfInfo[turfid][tName], param, 32);
		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET name = '%e' WHERE id = %i", TurfInfo[turfid][tName], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has set the name of turf %i to %s.", GetRPName(playerid), turfid, param);
		SM(playerid, COLOR_AQUA, "You have set the name of turf %i to {F7A763}%s{CCFFFF}.", turfid, param);
	}
	else if(!strcmp(option, "claimby", true))
    {
        if(isnull(param) || strlen(params) > 32)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [capturedby] [name]");
		}

		strcpy(TurfInfo[turfid][tCapturedBy], param, MAX_PLAYER_NAME);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedby = '%e' WHERE id = %i", TurfInfo[turfid][tCapturedBy], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has set the capturer of turf %i to %s.", GetRPName(playerid), turfid, param);
		SM(playerid, COLOR_AQUA, "You have set the capturer of turf %i to {F7A763}%s{CCFFFF}.", turfid, param);
	}
 	else if(!strcmp(option, "gang", true))
    {
        new gangid;

        if(sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [gang] [gangid (-1 = none)]");
		}
		if(!(0 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
		}

		TurfInfo[turfid][tCapturedGang] = gangid;
		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedgang = %i WHERE id = %i", TurfInfo[turfid][tCapturedGang], turfid);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		{
            SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has reset the capturing gang of turf %i.", GetRPName(playerid), turfid);
			SM(playerid, COLOR_AQUA, "You have reset the capturing gang of turf %i.", turfid);
		}
		else
		{
			SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has set the capturing gang of turf %i to %s.", GetRPName(playerid), turfid, GangInfo[gangid][gName]);
			SM(playerid, COLOR_AQUA, "You have set the capturing gang of turf %i to "SVRCLR"%s{CCFFFF}.", turfid, GangInfo[gangid][gName]);
		}
	}
	else if(!strcmp(option, "type", true))
    {
        new type;

        if(sscanf(param, "i", type))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [type] [value]");
	    	SendClientMessage(playerid, COLOR_GREY2, "List of types: (0)None (1)Hollowpoint Ammo (2)Poison Ammo (3)FMJ ammo (4)Materials (5)Traphouse");
	    	SendClientMessage(playerid, COLOR_GREY2, "List of types: (6)Crackhouse (7)Sales taxing (8)Low weps (9)Medium weps (10)High weps (11)Influence Truf");
            return 1;
		}
		if(!(0 <= type <= 11))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		TurfInfo[turfid][tType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET type = %i WHERE id = %i", TurfInfo[turfid][tType], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has set the type of turf %i to %i.", GetRPName(playerid), turfid, type);
		SM(playerid, COLOR_AQUA, "You have set the type of turf %i to %i.", turfid, type);
	}
	else if(!strcmp(option, "time", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editturf [turfid] [time] [hours (0-24)]");
		}
		if(!(0 <= value <= 24))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of hours must range from 0 to 24.");
		}

		TurfInfo[turfid][tTime] = value;

		if(TurfInfo[turfid][tTime] == 0 && TurfInfo[turfid][tType] != 8)
		{
		    SMA(COLOR_TEAL	, ""WHITE"%s"TEAL" is now available to capture.", TurfInfo[turfid][tName]);
		}
		else
		{
		    TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
		    TurfInfo[turfid][tCaptureTime] = 0;
		}

		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET time = %i WHERE id = %i", TurfInfo[turfid][tTime], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_TEAL, "AdmCmd:"WHITE" %s has set the time of turf %i to %i hours.", GetRPName(playerid), turfid, value);
		SM(playerid, COLOR_AQUA, "You have set the time of turf %i to %i hours.", turfid, value);
	}

	return 1;
}


