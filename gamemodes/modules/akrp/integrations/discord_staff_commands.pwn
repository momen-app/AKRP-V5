DCMD:removefaction(user, channel, params[])
{
	if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	new factionid, iString[128];

	if(sscanf(params, "i", factionid))
	{
	    return DCC_SendChannelMessage(channel,"Usage: !removefaction [factionid]");
	}
	if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return DCC_SendChannelMessage(channel,"Invalid Faction.");
	}
	format(iString, sizeof(iString), "You have permanently deleted the %s Faction.", FactionInfo[factionid][fName]);
    DCC_SendChannelMessage(channel, iString);

	RemoveFaction(factionid);
	return 1;
}
DCMD:gangs(user, channel, params[]) {

    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	new string[1000],  dialog_string[1024];
    new count = 0;
    for(new gangid = 0; gangid < MAX_GANGS; gangid ++)
    {
        if(GangInfo[gangid][gSetup] == 1)
		{
        format(string, sizeof(string), "> (%i) : %s\n",  gangid, GangInfo[gangid][gName]);
		strcat(dialog_string, string);
        count++;
		}
    }
    if (count == 0) return DCC_SendChannelMessage(channel, "```There are no gangs created.```");

	new DCC_Embed:embed = DCC_CreateEmbed("List Of Gangs", dialog_string);
	DCC_SetEmbedColor(embed, 0x000000);
	DCC_SetEmbedFooter(embed, "ALL KERALA Roleplay");
	DCC_SendChannelEmbedMessage(channel, embed);
    return 1;
}
DCMD:help(user, channel, params[]) {

    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1088764086310940762>");
		return 1;
	}
	new str[500];
    format(str, sizeof(str), "Normal commands:- \n- !Toprich\n- !Factions\n- !Gangs\n- !Help\n- !Serverinfo\n- !Rules\n- !Newbie\n- !Players\n- !Credits\n- !Ip\n- !Admins\n- !Helpers\n- !Serverstats\n- !Say\n- !Meme\n-Management Cmds :\n- !removegang\n- !makeadmin\n- !makehelper\n- !setmotd\n- !Say\n- !factions\n- !removefaction\n- !Asay\n- !Chatingame\n- !Vipsay\n- !Alert\n- !Global\n- !sendto\n Admin Cmds :\n- !a\n- !kick\n- !alert\n- !pm\n- !checknewbies\n- !stats\n- !reports\n- !istjailed\n- !unjail\n- !ajail.\n- !ban\n- !unban\n- !whitelist\n- !wh\n- !unwh\n");
    new DCC_Embed:embed = DCC_CreateEmbed("All Kerala RolePlay Cmds", str);
    DCC_SetEmbedColor(embed, 0xFFFF00);
    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2024");
    DCC_SendChannelEmbedMessage(channel, embed);

	return 1;
}
DCMD:toprich(user, channel, params[]) {


    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	mysql_tquery(connectionID, "SELECT bank, username FROM users ORDER BY bank DESC LIMIT 5", "OnDiscordTopRichQuery", "i", _:channel);


	return 1;
}

forward OnDiscordTopRichQuery(DCC_Channel:channel);
public OnDiscordTopRichQuery(DCC_Channel:channel)
{
	new Name[MAX_PLAYER_NAME], Money;
	new string[128], dialog_string[1024], count = 0;

	for(new i = 0; i < cache_num_rows(); ++i)
	{
		SQL_GetString(i, "username", Name);
		Money = SQL_GetInt(i, "bank");
	    format(string, sizeof(string), "%s - $%d\n", Name, Money);
		strcat(dialog_string, string);
		count++;
	}

    if(count == 0)
    {
    	return DCC_SendChannelMessage(channel, "```\nThere is no current rich right now.\n```");
    }

	new DCC_Embed:embed = DCC_CreateEmbed("The most rich at ALL KERALA ROLEPLAY\n", dialog_string);
	DCC_SetEmbedColor(embed, 0xf30000);
	DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2022");
	DCC_SendChannelEmbedMessage(channel, embed);
	return 1;
}

CMD:rdr(playerid, params[])
{
	new reportid = PlayerInfo[playerid][pActiveReport];

    if(reportid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no active report to reply to.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rdr [reply text]");
	}

	if(ReportInfo[reportid][rReporter] == playerid)
	{
		new szString[128];
		format(szString, sizeof(szString), "** Player %s (ID %i): %s **", GetRPName(playerid), playerid, params);
		SendDiscordMessage(18, szString);
	    SM(playerid, COLOR_YELLOW, "** Reply to Discord Report Handler: %s **", params);
	}
	return 1;
}


new RandomMEME[][] =
{
	"https://i.pinimg.com/originals/86/7d/3b/867d3b282adc2e97354c776debd67cc0.jpg",
	"https://ci.memecdn.com/9856322.jpg",
	"https://pm1.narvii.com/6706/c924d60e7f1b7f8c2b1b2965b78feddf61891b05_hq.jpg",
	"https://static.wikia.nocookie.net/gtawiki/images/b/b0/Benny-GTASA-HD.jpg/revision/latest/top-crop/width/360/height/360?cb=20190529144237",
	"https://i.ytimg.com/vi/GD7b8MbY9dI/maxresdefault.jpg",
	"https://static1.thegamerimages.com/wordpress/wp-content/uploads/2020/12/San-Andreas-Necklace-Meme.jpg?q=50&fit=crop&w=1100&dpr=1.5",
	"https://pics.onsizzle.com/gta-sa-gta-4-gta-5-gta-6-upgrades-bay-66144390.png",
	"https://pics.me.me/gta-online-in-a-nutshell-true-lmao-how-old-would-20702747.png",
	"https://pm1.narvii.com/6803/35037d8a5eff99bf5ed3a99f7c1206e47059404ev2_hq.jpg",
	"http://ci.memecdn.com/4419533.jpg",
	"https://i.ytimg.com/vi/FtU7C5UQQKY/maxresdefault.jpg",
	"https://thumbs.gfycat.com/CavernousThirdGosling-max-1mb.gif",
	"https://www.meme-arsenal.com/memes/58ece2cf303e827df95e2c40cba4202f.jpg",
	"https://i.ytimg.com/vi/73St08q-QAI/maxresdefault.jpg"

};
DCMD:meme(user, channel, params[]) {

    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	new randMEM = random(sizeof(RandomMEME));
    new string[500];
    format(string,sizeof (string), "%s", RandomMEME[randMEM]);
    DCC_SendChannelMessage(channel, string);
    return 1;
}
DCMD:ahelp(user, channel, params[]) {

    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    DCC_SendChannelMessage(channel, "```This Command Is Disables use \n-!mhelp\n DISCORD COONECTOR BY MUHSIN```");
    return 1;
}
DCMD:serverinfo(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
    new str[9999];
    format(str, sizeof(str), "**[!] Verbal RP**\n**[!] 24/7 online**\n**[!] Quality server**\n**[!] No delay**\n**[!] 24/7 service online**\n**[!]**https://discord.gg/ZthxDqwhSm\n\n\n\n\n**[!] Starting Money: 200,000**\n**[!] Refund? Need 3 hours playing just type /iloveAKRP refund and you will get BMX & 3D VIP**");
    new DCC_Embed:embed = DCC_CreateEmbed("Official ALL KERALA ROLEPLAY Philippines", str);
    DCC_SetEmbedColor(embed, 0xFF0000);
    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2022");
    DCC_SendChannelEmbedMessage(channel, embed);
    return 1;
}
DCMD:mhelp(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
    DCC_SendChannelMessage(channel, "```This Command Is Disables use \n-!help\n DISCORD COONECTOR BY MUHSIN```");
    return 1;
}

DCMD:ajail(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}

	new targetid, minutes, reason[128];

	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return DCC_SendChannelMessage(channel, "```[USAGE] !ajail [playerid] [minutes] [reason]```");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return DCC_SendChannelMessage(channel, "```The player specified is disconnected.```");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return DCC_SendChannelMessage(channel, "```That player hasn't logged in yet. You can wait until they login or use /oprison.```");
	}
	if(minutes < 1)
	{
	    return DCC_SendChannelMessage(channel, "```The amount of minutes cannot be below one. Use /release instead.```");
	}

    PlayerInfo[targetid][pJailType] = 2;
    PlayerInfo[targetid][pJailTime] = minutes * 60;

	if(PlayerInfo[targetid][pGender] == 1)
		SetPlayerSkin(targetid, 97);
 	else
		SetPlayerSkin(targetid, 152);

	SetPlayerInJail(targetid);
	GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonreason = '%e' WHERE uid = %i", reason, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	strcpy(PlayerInfo[targetid][pPrisonReason], reason, 128);

    SMA(COLOR_RED, "[JAIL]|%s was prisoned for %i minutes By a Discord - Admin , reason: %s", GetRPName(targetid), minutes, reason);
    SM(targetid, COLOR_AQUA, "** You have been admin prisoned for %i minutes By a Discord Admin.", minutes);

	new string[128 + MAX_PLAYER_NAME];
	format(string,sizeof (string), "```You Have Successfully ajailed %s for %i minutes , reason: %s```", GetRPName(targetid), minutes, reason);
    DCC_SendChannelMessage(channel, string);
    return 1;
}
DCMD:ojail(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}
    new username[MAX_PLAYER_NAME + 1], minutes, reason[128];

	if(sscanf(params, "s[24]is[128]", username, minutes, reason))
	{
	    return DCC_SendChannelMessage(channel, "```[Usage]: /ojail [username] [minutes] [reason]```");
	}
	if(minutes < 1)
	{
	    return DCC_SendChannelMessage(channel, "```The amount of minutes cannot be below one. Use /release instead.```");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, uid FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflinePrison", "isis", INVALID_PLAYER_ID, username, minutes, reason);


	new string[128 + MAX_PLAYER_NAME];
	format(string,sizeof (string), "```You Have Successfully ajailed %s for %i minutes , reason: %s```", username, minutes, reason);
    DCC_SendChannelMessage(channel, string);
    return 1;
}
DCMD:unjail(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}

    new targetid, reason[128];
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return DCC_SendChannelMessage(channel, "```[USAGE] !unjail [playerid] [reason]```");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return DCC_SendChannelMessage(channel, "```The player specified is disconnected.```");
	}
	if(!PlayerInfo[targetid][pJailType])
	{
	    return DCC_SendChannelMessage(channel, "```That player is not jailed.```");
	}
	SetPlayerSkin(targetid, PlayerInfo[targetid][pSkin]);
	PlayerInfo[targetid][pJailTime] = 1;
	SMA(COLOR_RED, "[UNJAIL] %s was release from jail/prison by Discord - Admin, reason: %s", GetRPName(targetid), reason);

	new string[128 + MAX_PLAYER_NAME];
	format(string,sizeof (string), "```You Have Successfully unjailed %s , reason: %s```", GetRPName(targetid), reason);
    DCC_SendChannelMessage(channel, string);
	return 1;
}
DCMD:listjailed(user, channel, params[])
{

    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}

	new type[14];
	DCC_SendChannelMessage(channel, "```Jailed Players:```");

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

			new string[128 + MAX_PLAYER_NAME];
	        format(string,sizeof (string), "```(ID: %i) %s - Status: %s - Time: %i seconds```", i, GetRPName(i), type, PlayerInfo[i][pJailTime]);
            DCC_SendChannelMessage(channel, string);
		}
	}

	return 1;
}
DCMD:removegang(user, channel, params[])
{
	if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}
    new gangid;
	if(sscanf(params, "i", gangid))
	{
	    return DCC_SendChannelMessage(channel,"Usage: !removegang [gangid]");
	}
	if(!(1 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return DCC_SendChannelMessage(channel,"Invalid gang.");
	}
	new iString[128];
	format(iString, sizeof(iString), "You have permanently deleted the %s gang slot.", GangInfo[gangid][gName]);
    DCC_SendChannelMessage(channel, iString);

	RemoveGang(gangid);
	return 1;
}
DCMD:factions(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	new string[1000],  dialog_string[1024];
    new count = 0;
	for(new factionid = 1; factionid < MAX_FACTIONS; factionid++)
	{
		if(FactionInfo[factionid][fType] != FACTION_NONE) {

			if(FactionInfo[factionid][fType] == FACTION_HITMAN)
			{
				format(string, sizeof(string), "%i %s Confidential\n", factionid, FactionInfo[factionid][fName]);

			}
			else
			{
				format(string, sizeof(string), "%i %s\n", factionid, FactionInfo[factionid][fName], FactionInfo[factionid][fLeader]);
			}
			strcat(dialog_string, string);
			count++;
		}
    }
    if (count == 0) return DCC_SendChannelMessage(channel, "```There are no Factions created.```");

	new DCC_Embed:embed = DCC_CreateEmbed("List Of Factions", dialog_string);
	DCC_SetEmbedColor(embed, 0x000000);
	DCC_SetEmbedFooter(embed, "ALL KERALA Roleplay");
	DCC_SendChannelEmbedMessage(channel, embed);
    return 1;
}

DCMD:credits(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    DCC_SendChannelMessage(channel, "```This Bot is made of NAJU```");
    return 1;
}

DCMD:kick(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    new
        targetid, plrName[MAX_PLAYER_NAME + 1];

    if (sscanf(params, "u", targetid))
        return DCC_SendChannelMessage(channel, "```SYNTAX: !kick [playerid]```");

    if (targetid == INVALID_PLAYER_ID)
        return DCC_SendChannelMessage(channel, "```Username/id you entered is not found on server```");

    //get player name
    GetPlayerName(targetid, plrName, sizeof plrName);

    Kick(targetid);
    return DCC_SendChannelMessage(channel, "[OD]%s Has Being Kicked From Server", plrName);
}


DCMD:admins(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    new count = 0;
    DCC_SendChannelMessage(channel, "```__Online Admins:__```");
    new iString[356] = '\0';

    foreach(new i : Player) {
        if(PlayerInfo[i][pAdmin] > 0) {
        format(iString, sizeof(iString), "```Admin : (Id: %i) Name : %s Level : %d\n```", i, PlayerInfo[i][pUsername], PlayerInfo[i][pAdmin]);
        DCC_SendChannelMessage(channel, iString);
        count++; }
    }
    if (count == 0) return DCC_SendChannelMessage(channel, "```There are no admins online.```");
    return 1;
}

DCMD:helpers(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    new count = 0;
    DCC_SendChannelMessage(channel, "```__Online Helpers:__```");
    new iString[356] = '\0';


    foreach(new i : Player) {
        if(PlayerInfo[i][pHelper] > 0) {
        format(iString, sizeof(iString), "```Helper : (Id: %i) Name : %s Level : %d\n```", i, PlayerInfo[i][pUsername], PlayerInfo[i][pHelper]);
        DCC_SendChannelMessage(channel, iString);
        count++; }
    }
    if (count == 0) return DCC_SendChannelMessage(channel, "```There are no Helpers online.```");
    return 1;
}

DCMD:serverstats(user, channel, params[])
{
    new houses, businesses, garages, vehicles, lands, entrances, turfs, points, gangs, factions;
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}
	for(new i = 0; i < MAX_HOUSES; i ++) 	 if(HouseInfo[i][hExists]) 		houses++;
	for(new i = 0; i < MAX_BUSINESSES; i ++) if(BusinessInfo[i][bExists]) 	businesses++;
	for(new i = 0; i < MAX_GARAGES; i ++) 	 if(GarageInfo[i][gExists]) 	garages++;
	for(new i = 0; i < MAX_VEHICLES; i ++) 	 if(IsValidVehicle(i)) 			vehicles++;
	for(new i = 0; i < MAX_LANDS; i ++) 	 if(LandInfo[i][lExists]) 		lands++;
	for(new i = 0; i < MAX_ENTRANCES; i ++)  if(EntranceInfo[i][eExists]) 	entrances++;
	for(new i = 0; i < MAX_TURFS; i ++) 	 if(TurfInfo[i][tExists]) 		turfs++;
	for(new i = 0; i < MAX_POINTS; i ++) 	 if(PointInfo[i][pExists]) 		points++;
	for(new i = 0; i < MAX_GANGS; i ++) 	 if(GangInfo[i][gSetup]) 		gangs++;
	for(new i = 0; i < MAX_FACTIONS; i ++) 	 if(FactionInfo[i][fType]) 		factions++;

	new string[300];
	format(string, sizeof(string), "```"SERVER_NAME" Stats:\n- Registered: %i - Kill Counter: %i - Death Counter: %i - Players Online: %i/%i - Player Record: %i - Record Date: %s - Anticheat Bans: %i```", gTotalRegistered, gTotalKills, gTotalDeaths, Iter_Count(Player), MAX_PLAYERS, gPlayerRecord, gRecordDate, gAnticheatBans);
    DCC_SendChannelMessage(channel, string);
	return 1;
}

DCMD:vipsay(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "```SYNTAX: !vipsay [msg]```");
    } else {

        new str[144], username[33];
        DCC_GetUserName(user, username, sizeof(username));
        format(str, sizeof(str), "{ff00d4}[LIFETIME DONATOR]"WHITE"%s : %s", username, params);
        SendClientMessageToAll(-1, str); //Broadcast message to server.
        return DCC_SendChannelMessage(channel, "```You Send a message to the server```");
    }
    return 1;
}
DCMD:alert(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "```SYNTAX: !alert [msg]```");
    } else {

        new str[144], username[33];
        DCC_GetUserName(user, username, sizeof(username));
        format(str, sizeof(str), "{ff0000}[DISCORD ADMIN]"WHITE"%s : %s", username, params);
        SendClientMessageToAll(-1, str); //Broadcast message to server.
        return DCC_SendChannelMessage(channel, "```You Send a message to the server```");
    }
    return 1;
}

DCMD:pm(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

	new recieverid, message[144];

	if(sscanf(params,"is",recieverid, message)) return DCC_SendChannelMessage(channel,"```SYNTAX : !pm [Player ID] [Message]```");
	if(!IsPlayerConnected(recieverid)) return DCC_SendChannelMessage(channel,"```Player not connected```.");

	new str[144];
	format(str, sizeof(str), "PM from Discord-Admin : %s", message);
	SendClientMessage(recieverid, 0xFFF000FF, str);
	PlayerPlaySound(recieverid, 1054, 0, 0, 0);
	return DCC_SendChannelMessage(channel,"```PM Successfully Sent```");
}
new aimWarnings[MAX_PLAYERS];
public OnPlayerSuspectedForAimbot(playerid,hitid,weaponid,warnings)
{
	aimWarnings[playerid]++;
	new str[144], Float:Wstats[BUSTAIM_WSTATS_SHOTS];
	if(warnings & WARNING_OUT_OF_RANGE_SHOT)
	{
	    format(str, sizeof(str),"<BustAim> [#%i] %s(%i) fired shots from a distance greater than the %s's fire range (normal:%i)",aimWarnings[playerid],GetRPName(playerid),playerid,GetWeaponNameEx(weaponid),BustAim::GetNormalWeaponRange(weaponid));
		SendAdminMessage(COLOR_YELLOW, str);
		BustAim::GetRangeStats(playerid,Wstats);
		format(str, sizeof(str),"<BustAim> Shooter -> Victim Distance (SA Units): 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		SendAdminMessage(COLOR_YELLOW, str);
	}
	if(warnings & WARNING_PROAIM_TELEPORT)
	{
	    format(str, sizeof(str),"<BustAim> [#%i] %s(%i) is using proaim (teleport detected)",aimWarnings[playerid],GetRPName(playerid),playerid);
		SendAdminMessage(COLOR_YELLOW, str);
		SendDiscordMessage(25, str);
		BustAim::GetTeleportStats(playerid,Wstats);
		format(str, sizeof(str),"<BustAim> Bullet -> Victim Distance(SA Units): 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		SendAdminMessage(COLOR_YELLOW, str);
		SendDiscordMessage(25, str);
	}
	if(warnings & WARNING_RANDOM_AIM)
	{
	    format(str, sizeof(str),"<BustAim> [#%i] %s(%i) is suspected to be using aimbot (hits with random aim with %s)",aimWarnings[playerid],GetRPName(playerid),playerid,GetWeaponNameEx(weaponid));
		SendAdminMessage(COLOR_YELLOW, str);
		SendDiscordMessage(25, str);
		BustAim::GetRandomAimStats(playerid,Wstats);
		format(str, sizeof(str),"<BustAim> Random Aim Offsets: 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		SendAdminMessage(COLOR_YELLOW, str);
		SendDiscordMessage(25, str);

	}
	if(warnings & WARNING_CONTINOUS_SHOTS)
	{
	    format(str, sizeof(str),"<BustAim>[#%i] %s(%i) has fired 10 shots continously with %s(%d)",aimWarnings[playerid],GetRPName(playerid),playerid,GetWeaponNameEx(weaponid),weaponid);
		SendAdminMessage(COLOR_YELLOW, str);
		SendDiscordMessage(25, str);
	}
	if(aimWarnings[playerid] >= 6 && PlayerInfo[playerid][pAdmin] < 1)
	{
		SCMf(playerid, COLOR_YELLOW, "[SYSTEM]: "WHITE"  %s %s was autokicked by %s, reason: Aimbot", GetRPName(playerid), SERVER_BOT);
		SAM(COLOR_YELLOW, "[SYSTEM]: "WHITE"  %s was autokicked by %s, reason: Aimbot", GetRPName(playerid), SERVER_BOT);
 		//BanPlayer(playerid, SERVER_BOT, "Aimbot");
 		KickPlayer(playerid);
	}
	return 0;
}
DCMD:makeadmin(user, channel, params[]) {
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

	new targetid, level;

	if(sscanf(params, "ui", targetid, level))
	{
		return DCC_SendChannelMessage(channel, "```SYNTAX: !makeadmin [playerid] [level]```");
	}
	if(!IsPlayerConnected(targetid))
	{
		return DCC_SendChannelMessage(channel, "```The player specified is disconnected.```");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
		return DCC_SendChannelMessage(channel, "```That player hasn't logged in yet.```");
	}
	if(!(0 <= level <= 7))
	{
		return DCC_SendChannelMessage(channel, "```Invalid level. Valid levels range from 0 to 7 ```");
	}

	if(level <= 1 && PlayerInfo[targetid][pAdminDuty])
	{
		SetPlayerName(targetid, PlayerInfo[targetid][pUsername]);
		PlayerInfo[targetid][pAdminDuty] = 0;
	}

    PlayerInfo[targetid][pAdmin] = level;
	SendAdminMessage(0xff2f00ff, "AdmCmd: Discord-Admin has made %s a %s (%i).", GetRPName(targetid), GetAdminRank(targetid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET adminlevel = %i WHERE uid = %i", level, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);


	DCC_SendChannelMessage(channel, "You have set %s's admin level to %s (%i).", GetRPName(targetid), GetAdminRank(targetid), level);
	SM(targetid, COLOR_AQUA, "Discord-Admin has set your admin level to {ff2f00}%s{33CCFF} (%i).", GetAdminRank(targetid), level);
	DCC_SendChannelMessage(channel, "```You Have Successfully Changed Player Admin Level```");
	return 1;
	}
}



DCMD:sendto(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

	new targetid, option[12], param[32];

	if(sscanf(params, "us[12]S()[32]", targetid, option, param))
	{
	    return DCC_SendChannelMessage(channel, "```SYNTAX: !sendto [playerid] [location]```");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return DCC_SendChannelMessage(channel, "```The player specified is disconnected.```");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return DCC_SendChannelMessage(channel, "```That player hasn't logged in .```");
	}
	if(!strcmp(option, "ls", true))
    {
		TeleportToCoords(targetid, 1544.4407, -1675.5522, 13.5584, 90.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to Los Santos.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to Los Santos.");
    }
    else if(!strcmp(option, "sf", true))
    {
		TeleportToCoords(targetid, -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to San Fierro.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to San Fierro.");
    }
    else if(!strcmp(option, "md", true))
    {
		TeleportToCoords(targetid, 331.935913, -1795.026123, 4.777225, 135.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to Mudhuk.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to Mudhuk.");
    }
    else if(!strcmp(option, "mg", true))
    {
		TeleportToCoords(targetid, -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to main garage.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to main garage .");
    }
    else if(!strcmp(option, "lv", true))
    {
		TeleportToCoords(targetid, 1670.6908, 1423.5240, 10.7811, 270.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to Las Venturas.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to Las Venturas.");
    }
    else if(!strcmp(option, "bank", true))
    {
        TeleportToCoords(targetid, 1463.8929, -1026.6189, 23.8281, 180.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to Bank.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to the Bank.");
    }
	else if(!strcmp(option, "mall", true))
    {
        TeleportToCoords(targetid, 1129.6364,-1425.1180,15.7969,357.0000, 0, 0);
        DCC_SendChannelMessage(channel, "You has sent %s to Mall.", GetRPName(targetid));
		SM(targetid, COLOR_GREY2, "Dc Admin has sent you to Mall.");
    }
	DCC_SendChannelMessage(channel, "```You Have Successfully Sended Player```");
	return 1;
}

DCMD:makehelper(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

	new targetid, level;

	if(sscanf(params, "ui", targetid, level))
	{
	    return DCC_SendChannelMessage(channel, "```SYNTAX: !makehelper [playerid] [level]```");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return DCC_SendChannelMessage(channel, "```The player specified is disconnected.```");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return DCC_SendChannelMessage(channel, "```That player hasn't logged in .```");
	}
	if(!(0 <= level <= 4))
	{
	    return DCC_SendChannelMessage(channel, "```Invalid level. Valid levels range from 0 to 4.```");
	}

    PlayerInfo[targetid][pHelper] = level;
	SendStaffMessage(0xff2f00ff, "AdmCmd: Discord-Admin has made %s a level %i helper.", GetRPName(targetid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helperlevel = %i WHERE uid = %i", level, PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	DCC_SendChannelMessage(channel, "You have made %s a {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), GetHelperRank(targetid), level);
	SM(targetid, COLOR_AQUA, "Discord-Admin has made you a {00AA00}%s{33CCFF} (%i).", GetHelperRank(targetid), level);
	DCC_SendChannelMessage(channel, "```You Have Successfully Changed Player Helper Level```");

	//Log_Write("log_makehelper", "who the fuck you to check discord admin logs");
	return 1;
}
forward DiscordCheckingStats(username[]);
public DiscordCheckingStats(username[])
{
        new skin, hours, number;
        new online[20], string[1028], skinurl[1028];

        skin = SQL_GetInt(0, "skin");
        hours = SQL_GetInt(0, "hours");
        number = SQL_GetInt(0, "phone");

        if(!IsPlayerOnline(username)) {
            online = "Offline";
        } else {
            online = "Online";
        }

        new DCC_Embed:embed = DCC_CreateEmbed("<:wgrp_logo:1082593178001092618> "SERVER_NAME" Profile");
        format(string, sizeof(string), "**Name:** %s\n**Status:** %s\n**Skin:** %i\n**Playing Hours:** %i\n**Phone Number:** %i", username, online, skin, hours, number);
        format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/%i.png", SQL_GetInt(0, "skin"));
        DCC_SetEmbedDescription(embed, string);
        DCC_SetEmbedImage(embed, skinurl);
        DCC_SetEmbedColor(embed, 0xFF9900);
        DCC_SendChannelEmbedMessage(admin_log, embed);
}

DCMD:profile(user, channel, params[])
{

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE username = '%e'", params);
    mysql_tquery(connectionID, queryBuffer, "DiscordCheckingStats", "s", params);
    return 1;
}

DCMD:reports(user, channel, params[])
{
    if(channel != DCC_FindChannelById(cmds))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1145201040115908780>");
		return 1;
	}

	DCC_SendChannelMessage(channel, "```Pending Reports:```");

	for(new i = 0; i < MAX_REPORTS; i ++)

 	if(ReportInfo[i][rExists] && !ReportInfo[i][rAccepted])
    {
        new iString[356] = '\0';
    	format(iString, sizeof(iString), "```(RID: %i) %s[%i] reports: %s```", i, GetRPName(ReportInfo[i][rReporter]), ReportInfo[i][rReporter], ReportInfo[i][rText]);
        DCC_SendChannelMessage(channel, iString);
  	}
  	return 1;
}

//Discord By Naju
DCMD:whitelist(user, channel, params[])
{
    if(channel != DCC_FindChannelById(white))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1080663943149801602>");
		return 1;
	}
    new username[MAX_PLAYER_NAME];
	new str[128];
    if (sscanf(params, "s[24]", username)) {
	    format(str, sizeof(str), "```!Whitelist Firstname_Lastname```");
	    new DCC_Embed:embed = DCC_CreateEmbed("ALL KERALA ROLEPLAY", str);
	    DCC_SetEmbedColor(embed, 0xff9d00);
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2022");
	    return DCC_SendChannelEmbedMessage(whitelist_log, embed);
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked FROM users WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminLockAccounts", "s", username);
    return 1;
}

DCMD:ann(user, channel, params[])
{
    if(channel != DCC_FindChannelById(announcement))
	{
	    DCC_SendChannelMessage(channel, "`This command only work in specific channel` <#1042087213132939294>");
		return 1;
	}
	new str[128];
    if(isnull(params)) {
	    format(str, sizeof(str), "```!ann [content]```");
	    new DCC_Embed:embed = DCC_CreateEmbed("AKRP ANNOUNCEMENT ERROR", str);
	    DCC_SetEmbedColor(embed, 0xff9d00);
	    DCC_SetEmbedThumbnail(embed, "https://cdn.discordapp.com/attachments/1042097385817513984/1093768710914838538/ezgif.com-video-to-gif_2.gif");
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP SINCE - 2022");
	    return DCC_SendChannelEmbedMessage(announce_log, embed);
    }

    new iString[128];
	format(iString, sizeof(iString),  "%s.\n||@here||", params);
	new DCC_Embed:embed = DCC_CreateEmbed("<a:AKRP_ANNOUNCE:1055772670756651008>AKRP ANNOUNCEMENT", iString);
	DCC_SetEmbedColor(embed, 0xff9d00);
	DCC_SetEmbedFooter(embed, "AKRP SINCE - 2022");
	DCC_SetEmbedImage(embed, "https://media.discordapp.net/attachments/877859563016159252/879664980218249216/colour_line2.gif");
	DCC_SetEmbedThumbnail(embed, "https://cdn.discordapp.com/attachments/1042097385817513984/1093768710914838538/ezgif.com-video-to-gif_2.gif");
	return DCC_SendChannelEmbedMessage(announce_log, embed);
}


DCMD:unwh(user, channel, params[])
{
    if(channel != whitelist_log)
	{
		new strb[1500];   
        format(strb, sizeof(strb), "This command only work in specific channel <#1258465808724787327>");
        new DCC_Embed:test = DCC_CreateEmbed("All Kerala  RolePlay", strb);
        DCC_SetEmbedColor(test, 0xFFFFFF);
        DCC_SendChannelEmbedMessage(whitelist_log, test);
		return 1;
	}
    new username[MAX_PLAYER_NAME];
	new str[128];
    if (sscanf(params, "s[24]", username)) {
	    format(str, sizeof(str), "```!Unwh Firstname_Lastname```");
	    new DCC_Embed:embed = DCC_CreateEmbed("All Kerala  RolePlay", str);
	    DCC_SetEmbedColor(embed, 0x00FFFF);
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2024");
	    return DCC_SendChannelEmbedMessage(whitelist_log, embed); 
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked FROM users WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminUnLockAccounts", "s", username);
    return 1;
}
forward OnAdminUnLockAccounts(const username[]);
public OnAdminUnLockAccounts(const username[])
{
    if(!SQL_GetRows())
    {
    	DCC_SendChannelMessage(whitelist_log, "The player specified doesn't exist.");
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 0 WHERE username = '%e'", username);
        mysql_tquery(connectionID, queryBuffer);
		new iString[128];
		format(iString, sizeof(iString),  "The Account With Username of %s's Have Been UnWhitelisted By. <@1074329603927191602>", username);
	    new DCC_Embed:embed = DCC_CreateEmbed("All Kerala  RolePlay", iString);
	    DCC_SetEmbedColor(embed, 0xfff000);
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2024");
	    return DCC_SendChannelEmbedMessage(whitelist_log, embed);
    }
	return 1;
}

DCMD:wh(user, channel, params[])
{
    if(channel != whitelist_log)
	{
		new strb[1500];   
        format(strb, sizeof(strb), "This command only work in specific channel <#1203596343113818164>");
        new DCC_Embed:test = DCC_CreateEmbed("All Kerala RolePlay", strb);
        DCC_SetEmbedColor(test, 0x00ffff);
        DCC_SendChannelEmbedMessage(whitelist_log, test);
		return 1;
	}
    new username[MAX_PLAYER_NAME];
	new str[128];
    if (sscanf(params, "s[24]", username)) {
	    format(str, sizeof(str), "```!Whitelist Firstname_Lastname```");
	    new DCC_Embed:embed = DCC_CreateEmbed("All Kerala RolePlay", str);
	    DCC_SetEmbedColor(embed, 0xFF0000);
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2024");
	    return DCC_SendChannelEmbedMessage(whitelist_log, embed); 
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked FROM users WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminLockAccounts", "s", username);
    return 1;
}

forward OnAdminLockAccounts(const username[]);
public OnAdminLockAccounts(const username[])
{
    if(!SQL_GetRows())
    {
    	DCC_SendChannelMessage(whitelist_log, "The player specified doesn't exist.");
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 1 WHERE username = '%e'", username);
        mysql_tquery(connectionID, queryBuffer);
		new iString[128];
		format(iString, sizeof(iString),  "The account with username of %s's have benn whitelisted By. <@1074329603927191602>", username);
	    new DCC_Embed:embed = DCC_CreateEmbed("All Kerala  RolePlay", iString);
	    DCC_SetEmbedColor(embed, 0xff0000);
	    DCC_SetEmbedFooter(embed, "Type !help for more info - AKRP 2024");
	    DCC_SendChannelEmbedMessage(whitelist_log, embed);
    }
	return 1;
}
