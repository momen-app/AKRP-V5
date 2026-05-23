CMD:carhelp(playerid)
{
	return callcmd::vehiclehelp(playerid);
}

CMD:armbomb(playerid, params[])
{
	return callcmd::plantbomb(playerid, params);
}

CMD:eject(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /eject [playerid]");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any vehicle.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected, or is not in your vehicle.");
	}

	RemovePlayerFromVehicle(targetid);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s ejects %s from the vehicle.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:dicebet(playerid, params[])
{
	new targetid, amount;
	
	if(!IsPlayerInRangeOfPoint(playerid, 100.0, 2192.6663,247.4592,1190.2942))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the casino.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to use dicebet while on-duty, bobo!", GetRPName(playerid));
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /dicebet [playerid] [amount]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $1.");
	}
	if(PlayerInfo[playerid][pCash] < amount)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much money to bet.");
	}
	if(gettime() - PlayerInfo[playerid][pLastBet] < 7)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 7 seconds. Please wait %i more seconds.", 7 - (gettime() - PlayerInfo[playerid][pLastBet]));
	}

	PlayerInfo[targetid][pDiceOffer] = playerid;
	PlayerInfo[targetid][pDiceBet] = amount;
	PlayerInfo[playerid][pLastBet] = gettime();

	SM(targetid, COLOR_AQUA, "** %s has initiated a bet with you for $%i (/accept dicebet).", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "** You have initiated a bet against %s for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:calculate(playerid, params[])
{
	new option, Float:value1, Float:value2;
	
	if(sscanf(params, "fcf", value1, option, value2))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /calculate [value 1] [option] [value 2]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: (+) Add (-) Subtract (*) Multiply (/) Divide");
	    return 1;
	}
	if(option == '/' && value2 == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't divide by zero.");
	}

	if(option == '+') {
	    SM(playerid, COLOR_YELLOW, "** Result: %.2f + %.2f = %.2f", value1, value2, value1 + value2);
	} else if(option == '-') {
	    SM(playerid, COLOR_YELLOW, "** Result: %.2f - %.2f = %.2f", value1, value2, value1 - value2);
	} else if(option == '*' || option == 'x') {
		SM(playerid, COLOR_YELLOW, "** Result: %.2f * %.2f = %.2f", value1, value2, value1 * value2);
	} else if(option == '/') {
		SM(playerid, COLOR_YELLOW, "** Result: %.2f / %.2f = %.2f", value1, value2, value1 / value2);
	}

	return 1;
}

CMD:serverstats(playerid, params[])
{
	new houses, businesses, garages, vehicles, lands, entrances, turfs, points, gangs, factions;

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

	SendClientMessage(playerid, SERVER_COLOR, ""SERVER_NAME" Stats:");
	SM(playerid, COLOR_GREY2, "Connections: %i - Registered: %i - Kill Counter: %i - Death Counter: %i - Hours Played: %i", gConnections, gTotalRegistered, gTotalKills, gTotalDeaths, gTotalHours);
	SM(playerid, COLOR_WHITE, "Houses: %i/%i - Businesses: %i/%i - Garages: %i/%i - Lands: %i/%i - Vehicles: %i/%i", houses, MAX_HOUSES, businesses, MAX_BUSINESSES, garages, MAX_GARAGES, lands, MAX_LANDS, vehicles, MAX_VEHICLES);
	SM(playerid, COLOR_GREY2, "Entrances: %i/%i - Turfs: %i/%i - Points: %i/%i - Gangs: %i/%i - Factions: %i/%i", entrances, MAX_ENTRANCES, turfs, MAX_TURFS, points, MAX_POINTS, gangs, MAX_GANGS, factions, MAX_FACTIONS);
	SM(playerid, COLOR_WHITE, "Players Online: %i/%i - Player Record: %i - Record Date: %s - Anticheat Bans: %i", Iter_Count(Player), MAX_PLAYERS, gPlayerRecord, gRecordDate, gAnticheatBans);
	return 1;
}

CMD:ww(playerid, params[])
{
	return callcmd::pw(playerid, params);
}

CMD:pw(playerid, params[])
{
	if(!PlayerInfo[playerid][pWatch])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a pocket watch. You can buy one at 24/7.");
	}

	if(!PlayerInfo[playerid][pWatchOn])
	{
	    if(PlayerInfo[playerid][pToggleTextdraws])
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You can't turn on your watch as you have textdraws toggled! (/toggle textdraws)");
		}

	    PlayerInfo[playerid][pWatchOn] = 1;
	    ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, TimeTD);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on their watch.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[playerid][pWatchOn] = 0;
	    ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
	    TextDrawHideForPlayer(playerid, TimeTD);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off their watch.", GetRPName(playerid));
	}

	return 1;
}

CMD:gps(playerid, params[])
{
	if(!PlayerInfo[playerid][pGPS])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a GPS. You can buy one at 24/7.");
	}

	if(!PlayerInfo[playerid][pGPSOn])
	{
	    if(PlayerInfo[playerid][pToggleTextdraws])
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You can't turn on your GPS as you have textdraws toggled! (/toggle textdraws)");
		}

	    PlayerInfo[playerid][pGPSOn] = 1;

	    DynamicPlayerTextDrawSetString(playerid, PlayerInfo[playerid][pText][0], "Loading...");
	    ShowGPSTextdraw(playerid);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on their GPS.", GetRPName(playerid));
	}
	else
	{
	    PlayerInfo[playerid][pGPSOn] = 0;
	    HideGPSTextdraw(playerid);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off their GPS.", GetRPName(playerid));
	}

	return 1;
}

CMD:fixvw(playerid, params[])
{
	if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pJoinedEvent])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently in a in the event. Use /quitevent instead.");
	}
	if(GetPlayerVirtualWorld(playerid) > 0 && GetPlayerInterior(playerid) == 0)
	{
	    SetPlayerVirtualWorld(playerid, 0);
	    SendClientMessage(playerid, COLOR_SYNTAX, "Your virtual world has been fixed.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Your virtual world is not bugged at the moment. /report or relog if the problem persists.");
	}

	return 1;
}

CMD:stuck(playerid, params[])
{
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pAcceptedHelp] || PlayerInfo[playerid][pFishTime] > 0 || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
    if(gettime() - PlayerInfo[playerid][pLastStuck] < 5)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastStuck]));
	}

	new
	    Float:x,
    	Float:y,
    	Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 0.5);

	ClearAnimations(playerid, SYNC_ALL);
	TogglePlayerControllable(playerid, true);

	ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0);
	SendClientMessage(playerid, SERVER_COLOR, "**"WHITE" You are no longer stuck.");

	PlayerInfo[playerid][pLastStuck] = gettime();
	return 1;
}

CMD:badge(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOVERNMENT && GetFactionType(playerid) != FACTION_MECHANIC && GetFactionType(playerid) != FACTION_TERRORIST && GetFactionType(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
    if(PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(!PlayerInfo[playerid][pDuty])
	{
	    if(PlayerInfo[playerid][pJoinedEvent] || PlayerInfo[playerid][pPaintballTeam] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can not put on your badge on while in an event or paintball match.");
		}
		new string[128], color, faction = PlayerInfo[playerid][pFaction];
		if(FactionInfo[faction][fColor] == -1 || FactionInfo[faction][fColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
			color = FactionInfo[faction][fColor];
		}
		format(string, sizeof(string), "{%06x}%s\n"WHITE"%s", color >>> 8, FactionInfo[faction][fName],FactionRanks[faction][PlayerInfo[playerid][pFactionRank]]);
		UpdateDynamic3DTextLabelText(PlayerLabel[playerid], COLOR_WHITE, string);

	    PlayerInfo[playerid][pDuty] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "You have enabled your badge. You now appear on-duty for all players.");
	}
	else
	{
		UpdateDynamic3DTextLabelText(PlayerLabel[playerid], COLOR_WHITE, "");
	    PlayerInfo[playerid][pDuty] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "You have disabled your badge. You no longer appear on-duty for any players.");
	}
	return 1;
}

CMD:forcelottery(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	LotteryUpdate();
	return 1;
}

CMD:duel(playerid, params[])
{
	new target1, target2, Float:health, Float:armor, weapon1, weapon2;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uuffii", target1, target2, health, armor, weapon1, weapon2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /duel [player1] [player2] [health] [armor] [weapon1] [weapon2]");
	}
	if(target1 == INVALID_PLAYER_ID || target2 == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid player specified.");
	}
	if(health < 1.0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Health can't be under 1.0.");
	}
	if(!(0 <= weapon1 <= 46) || !(0 <= weapon2 <= 46))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid weapon. Valid weapon IDs range from 0 to 46.");
	}

	new rand = random(99999);

	SavePlayerVariables(target1);
	SavePlayerVariables(target2);

	ResetPlayerWeapons(target1);
	ResetPlayerWeapons(target2);

	SetPlayerPos(target1, 1413.1495, -15.9198, 1000.9246);
	SetPlayerPos(target2, 1367.6084, -17.7317, 1000.9219);
	SetPlayerInterior(target1, 1);
	SetPlayerInterior(target2, 1);
	SetPlayerVirtualWorld(target1, rand);
	SetPlayerVirtualWorld(target2, rand);

	SetPlayerHealth(target1, health);
	SetPlayerArmour(target1, armor);
	SetPlayerHealth(target2, health);
	SetPlayerArmour(target2, armor);

	GiveWeapon(target1, weapon1, true);
	GiveWeapon(target1, weapon2, true);
	GiveWeapon(target2, weapon1, true);
	GiveWeapon(target2, weapon2, true);

	GameTextForPlayer(target1, "~r~Duel time!", 3000, 3);
	GameTextForPlayer(target2, "~r~Duel time!", 3000, 3);

	PlayerInfo[target1][pDueling] = target2;
	PlayerInfo[target2][pDueling] = target1;

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has forced %s and %s into a duel.", GetRPName(playerid), GetRPName(target1), GetRPName(target2));
	return 1;
}

CMD:mole(playerid, params[])
{
 	if(PlayerInfo[playerid][pAdmin] < 3)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
 	}
 	if(isnull(params))
 	{
     	SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /mole [text]");
     	SendClientMessage(playerid, COLOR_YELLOW, "This command sends a SMS to the entire server. Abusing this command will result in heavy punishment.");
     	return 1;
 	}
	SMA(COLOR_YELLOW, "** SMS from Satan: %s, Ph: 666 **", params);
 	return 1;
}

CMD:hmole(playerid, params[])
{
 	if(GetFactionType(playerid) != FACTION_HITMAN)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a hitman!");
 	}
 	if(isnull(params))
 	{
     	SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /hmole [text]");
     	SendClientMessage(playerid, COLOR_YELLOW, "This command automatically places ((/contract)) text.");
     	return 1;
 	}
	SMA(COLOR_YELLOW, "** SMS from MOLE(#null): %s((/contract)) **", params);
 	return 1;
}

CMD:info(playerid) callcmd::information(playerid);
CMD:information(playerid)
{
	SendClientMessage(playerid, COLOR_WHITE, ""SERVER_NAME": "SERVER_URL"");
}

CMD:credits(playerid, params[])
{

	SendClientMessage(playerid, COLOR_YELLOW, "Current Dev: {FF0000}ABDULLAH/ROCKY");
	SendClientMessage(playerid, COLOR_YELLOW, "Current Mapper(s): {FF0000}NASHI");
	SendClientMessage(playerid, COLOR_YELLOW, "Helpful Individuals: {FF0000}DONATORS, N/A");
	SendClientMessage(playerid, COLOR_YELLOW, "Youtubers: {FF0000}CARLO, and more!");
	SendClientMessage(playerid, COLOR_YELLOW, "Special Thanks: {FF0000}AK:RP MANAGEMENTS");

	return 1;
}

CMD:takecall(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;
    if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /takecall [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_MECHANIC) && PlayerInfo[targetid][pMechanicCall] > 0)
	{
		if(GetPlayerInterior(targetid))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently unreachable.");
		}

		PlayerInfo[targetid][pMechanicCall] = 0;
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

		GetPlayerPos(targetid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 5.0);

		SM(playerid, COLOR_AQUA, "** You have accepted %s's mechanic call. Their location was marked on your map.", GetRPName(targetid));
		SM(targetid, COLOR_AQUA, "** %s has accepted your mechanic call. Please wait patiently until they arrive.", GetRPName(playerid));
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "That player has no calls which can be taken.");
	}
	return 1;
}

CMD:listcallers(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Emergency Calls:");

	foreach(new i : Player)
	{
	    if((PlayerInfo[i][pEmergencyCall] > 0) && ((PlayerInfo[i][pEmergencyType] == FACTION_MEDIC && GetFactionType(playerid) == FACTION_MEDIC) || (PlayerInfo[i][pEmergencyType] == FACTION_POLICE && IsLawEnforcement(playerid))))
	    {
	        SM(playerid, COLOR_GREY2, "** %s[%i] - Expiry: %i seconds - Emergency: %s", GetRPName(i), i, PlayerInfo[i][pEmergencyCall], PlayerInfo[i][pEmergency]);
		}
	}

	return 1;
}

CMD:trackcall(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;

	if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_MECHANIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic, law enforcer, or mechanic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
    if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /trackcall [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pEmergencyCall])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't called 911 recently or their call expired.");
	}

	GetPlayerPos(targetid, x, y, z);
	PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	SetPlayerCheckpoint(playerid, x, y, z, 5.0);
	SM(playerid, COLOR_AQUA, "** You have accepted %s's emergency call. Their location was marked on your map.", GetRPName(targetid));

	if(PlayerInfo[targetid][pEmergencyCall] == FACTION_MEDIC)
	{
		SM(targetid, COLOR_AQUA, "** %s has accepted your emergency call. Please wait patiently until they arrive.", GetRPName(playerid));
	}

	return 1;
}

CMD:startchat(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /startchat [playerid]");
	}
	if(IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already in an active chat. /invitechat to invite them.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
    if(IsPlayerChatActive(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is in an active chat with another admin.");
	}

	chattingWith[playerid]{targetid} = true;
	chattingWith[targetid]{playerid} = true;

	SM(targetid, COLOR_YELLOW, "Administrator %s has started a chat with you. /(ac)hat to speak with this admin.", GetRPName(playerid));
	SM(playerid, COLOR_YELLOW, "You have started a chat with %s (ID %i). /(ac)hat to speak to the player.", GetRPName(targetid), targetid);
	return 1;
}

CMD:invitechat(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /invitechat [playerid]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have not started a chat yet. /startchat to start one.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
    if(IsPlayerChatActive(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is in an active chat with another admin.");
	}

	chattingWith[playerid]{targetid} = true;
	chattingWith[targetid]{playerid} = true;

	SM(targetid, COLOR_YELLOW, "Administrator %s has invited you to a chat. /(ac)hat to speak with them.", GetRPName(playerid));
	SM(playerid, COLOR_YELLOW, "You have invited %s (ID %i) to your chat.", GetRPName(targetid), targetid);
	return 1;
}

CMD:kickchat(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /kickchat [playerid]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have not started a chat yet. /startchat to start one.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
    if(!chattingWith[playerid]{targetid})
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently not in a chat with you.");
	}

	chattingWith[playerid]{targetid} = false;
	chattingWith[targetid]{playerid} = false;

	SM(targetid, COLOR_YELLOW, "Administrator %s has removed you from the chat.", GetRPName(playerid));
	SM(playerid, COLOR_YELLOW, "You have removed %s (ID %i) from your chat.", GetRPName(targetid), targetid);
	return 1;
}

CMD:endchat(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have not started a chat yet. /startchat to start one.");
	}

	foreach(new i : Player)
	{
	    if(i == playerid || chattingWith[playerid]{i})
	    {
	        chattingWith[playerid]{i} = false;
	        SM(i, COLOR_YELLOW, "Administrator %s has ended the chat.", GetRPName(playerid));
		}
	}

	return 1;
}

CMD:ac(playerid, params[])
{
	return callcmd::achat(playerid, params);
}

CMD:achat(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "USAGE /(ac)hat [text]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent been invited to any chats by an admin.");
	}

	foreach(new i : Player)
	{
	    if(i == playerid || chattingWith[i]{playerid})
	    {
	        if(PlayerInfo[playerid][pAdmin] > 1)
				SM(i, COLOR_YELLOW, "** %s %s (ID %i): %s **", GetAdminRank(playerid), GetRPName(playerid), playerid, params);
			else
			    SM(i, COLOR_YELLOW, "** Player %s (ID %i): %s **", GetRPName(playerid), playerid, params);
	    }
	}

	return 1;
}

CMD:gascan(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), amount;

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which runs off gas.");
	}
    if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gascan [amount (1 = 20 liters)]");
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pGasCan])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}
	if(vehicleFuel[vehicleid] + amount * 20 > 100)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't add that much gasoline to the vehicle.");
	}

	PlayerInfo[playerid][pGasCan] -= amount;
	vehicleFuel[vehicleid] += amount * 20;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s refills the %s's gas tank with %i liters of gasoline.", GetRPName(playerid), GetVehicleName(vehicleid), amount * 20);
	return 1;
}



CMD:selfrepair(playerid, params[])
{
	new count, Float:health;
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 829.3257, -2168.8684, 2.6271) && !IsPlayerInRangeOfPoint(playerid, 5.0, 817.0483, -2168.1396, 2.6409))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You are not at the repair point.");
	}
    foreach(new i : Player)
	{
	    if(IsMechanic(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}
	if(count > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There's a mechanic member on-duty. (/call to contact him/her).");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_GREY2, "The engine must be off during the repair session.");
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You are not inside of any vehicle.");
	}
	if(PlayerInfo[playerid][pCash] < 1500)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot afford the self repair.");
 	}
	
	GetVehicleHealth(vehicleid, health);

	if(health >= 1000.0)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't need to be repaired.");
	}
	else
	{
		TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid,"~w~Fixing the vehicle..",10000,6);
		SetTimerEx("TimerSelfRepair", 10000, false, "i", playerid);
		SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s is repairing his/her vehicle.", GetRPName(playerid));
	}
	return 1;
}

CMD:robbank(playerid, params[])
{
	new count;
    if(!IsPlayerInRangeOfPoint(playerid, 20.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(RobberyInfo[rTime] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "The bank can be robbed again in %i hours. You can't rob it now.", RobberyInfo[rTime]);
	}
	if(RobberyInfo[rPlanning])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a bank robbery being planned already. Ask the leader to join.");
	}
	if(RobberyInfo[rStarted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't rob the bank as a robbery has already started.");
	}
	if(PlayerInfo[playerid][pDuty] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You can't rob the bank while on-duty.");
	}

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}

	if(count < 5)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There needs to be at least 5+ LEO on-duty in order to rob the bank.");
	}

    RobberyInfo[rRobbers][0] = playerid;
    RobberyInfo[rPlanning] = 1;

    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
    SetPlayerCheckpoint(playerid, 1677.2610, -987.6659, 671.1152, 2.0);

    new string[128];
	format(string, sizeof(string), "~r~Bank Robbery on Progress");
    DynamicTextDrawSetString(Textdraw2, string);

    SendClientMessage(playerid, COLOR_AQUA, "You have setup a "SVRCLR"bank robbery{CCFFFF}. You need to /invite at least 2 more people in order to begin the heist.");
	SendClientMessage(playerid, COLOR_AQUA, "After you've found two additional heisters, you can use /setupvault at the checkpoint to blow the vault.");
	return 1;
}
CMD:myhelmet(playerid, params[])
{
  new string[129];
  format(string, sizeof(string), " Your Helmet health %i" , PlayerInfo[playerid][pHelmet]);
  SendClientMessage(playerid, COLOR_TEAL, string);

}
CMD:invite(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /invite [playerid]");
	}
	if(!(RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently not planning a bank robbery.");
	}
 	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(IsPlayerInBankRobbery(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already in the robbery with you.");
	}
	if(GetBankRobbers() >= MAX_BANK_ROBBERS)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can't have more than %i bank robbers in this robbery.", MAX_BANK_ROBBERS);
 	}
	if(PlayerInfo[targetid][pDuty] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "That player can't rob the bank while on-duty.");
	}

	PlayerInfo[targetid][pRobberyOffer] = playerid;

	SM(targetid, COLOR_AQUA, "** %s has invited you to a bank robbery. (/accept robbery)", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have invited %s to join your bank robbery.", GetRPName(targetid));
	return 1;
}

CMD:setupvault(playerid, params[])
{
    if(RobberyInfo[rPlanning] == 0 && RobberyInfo[rRobbers][0] != playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently not planning a bank robbery.");
	}
	if(GetBankRobbers() < 5)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least 4 other heisters in your robbery.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1677.2610, -987.6659, 671.1152))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the vault.");
	}
	if(IsValidDynamicObject(RobberyInfo[rObjects][1]))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The vault is already being bombed at the moment.");
	}

	RobberyInfo[rObjects][1] = CreateDynamicObject(1654, 1677.787475, -988.009765, 671.625366, 0.000000, 0.000000, 180.680709);

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s firmly plants an explosive on the vault door.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_WHITE, "** Bomb planted. Shoot at the bomb to blow that sumbitch' up!");
	return 1;
}

CMD:lootbox(playerid, params[])
{
	if(!RobberyInfo[rStarted] && !IsPlayerInBankRobbery(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in an active bank robbery.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -994.6146, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2335, -998.6115, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -1002.5356, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -998.4954, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -994.5173, 671.0032))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the deposit boxes.");
	}
	if(PlayerInfo[playerid][pLootTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already looting a deposit box.");
	}
	if(!IsPlayerInBankRobbery(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of this bank robbery.");
	}

	PlayerInfo[playerid][pLootTime] = 5;

	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0);
	GameTextForPlayer(playerid, "~w~Looting deposit box...", 5000, 3);
	return 1;
}

CMD:setscore(playerid, params[])
{
	new targetid, score;
    if(PlayerInfo[playerid][pAdmin] < 5)
	{
	  	return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, score))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setscore [playerid] [score]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	SetPlayerScore(targetid, score);
	SM(playerid, COLOR_SAMP, "You have set %s's score to %i.", GetPlayerNameEx(targetid), score);
	return 1;
}

CMD:turfs(playerid, params[])
{
	new turfid, name[32], color, timeleft[32], string[2048];
	tsstring = "";
	for(turfid = 0; turfid < MAX_TURFS; turfid++)
	{
	    if((TurfInfo[turfid][tType] < 11) && TurfInfo[turfid][tExists])
	    {
			if(TurfInfo[turfid][tCapturedGang] >= 0)
			{
    			strcpy(name, GangInfo[TurfInfo[turfid][tCapturedGang]][gName]);
				color = GangInfo[TurfInfo[turfid][tCapturedGang]][gColor];
			}
			else if(TurfInfo[turfid][tCapturedGang] == -5)
			{
				name = "Shutdown by The Police";
				color = 0x8D8DFF00;
			}
			else
			{
				color = COLOR_FACTIONCHAT;
				name = "None";
			}
			if(TurfInfo[turfid][tTime] > 0) format(timeleft, sizeof(timeleft), "%d Hours left", TurfInfo[turfid][tTime]);
			else format(timeleft, sizeof(timeleft), "Vulnerable");
			if(strlen(string) < 1950)
			{
			    format(string, sizeof(string), "%s{%06x}%i. %s | %s | Claimer: %s | Perk: %s | %s\n", string, color >>> 8, turfid, TurfInfo[turfid][tName], name, TurfInfo[turfid][tCapturedBy], getTurftype(turfid), timeleft);
			}
			else
			{
			    format(tsstring, sizeof(tsstring), "%s{%06x}%i. %s | %s | Claimer: %s | Perk: %s | %s\n", tsstring, color >>> 8, turfid, TurfInfo[turfid][tName], name, TurfInfo[turfid][tCapturedBy], getTurftype(turfid), timeleft);
			}
		}
	}
    ShowPlayerDialog(playerid, DIALOG_TURFLIST, DIALOG_STYLE_MSGBOX, ""SVRCLR"Point List"WHITE" ("REVISION")", string, "Next", "Cancel");
	return 1;
}

CMD:setformeradmin(playerid, params[])
{
	new targetid, status;
	if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, status) || !(0 <= status <= 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setformeradmin [playerid] [status (0/1)]");
		return 1;
	}

    if(status)
    {
	   	if(PlayerInfo[targetid][pAdmin])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The specified player is an admin and therefore cannot be set as a former admin.");
		}
        SAM(COLOR_LIGHTRED, "AdmCmd: %s has made %s a Former Admin.", GetRPName(playerid), GetRPName(targetid));

        SM(playerid, COLOR_AQUA, "You have made %s a "SVRCLR"Former Admin{CCFFFF}.", GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has made you a "SVRCLR"Former Admin{CCFFFF}.", GetRPName(playerid));
	}
	else
    {
        SAM(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's Former Admin status.", GetRPName(playerid), GetRPName(targetid));

        SM(playerid, COLOR_AQUA, "You have removed %s's "SVRCLR"Former Admin{CCFFFF} status.", GetRPName(targetid));
	    SM(targetid, COLOR_AQUA, "%s has removed your "SVRCLR"Former Admin{CCFFFF} status.", GetRPName(playerid));
	}
    PlayerInfo[targetid][pFormerAdmin] = status;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET formeradmin = %i WHERE uid = %i", PlayerInfo[targetid][pFormerAdmin], PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:callsign(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_MEDIC)
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
	if(isnull(params) || strlen(params) > 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /callsign [text ('none' to reset)]");
	}

	if(IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
		vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

		if(!strcmp(params, "none", true))
		{
			SendClientMessage(playerid, COLOR_WHITE, "** Callsign removed from the vehicle.");
		}
	}

	if(strcmp(params, "none", true) != 0)
	{
		vehicleCallsign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_GREY2, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
 		SendClientMessage(playerid, COLOR_WHITE, "** Callsign attached. '/callsign none' to detach the callsign.");
	}

	return 1;
}
CMD:kill(playerid, params[])
{
	new Float:health;
	GetPlayerHealth(playerid, health);

	if(PlayerInfo[playerid][pCuffed] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot kill yourself while cuffed!");
	}
	if(PlayerInfo[playerid][pJailTime] > 1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot do this while in jail.");
	}
	if(PlayerInfo[playerid][pInjured] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are too injured to attempt suicide!");
	}

	if(health < 15.0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your health is currently too low to kill yourself.");
	}

    switch(GetPlayerWeapon(playerid))
	{
		case 0 .. 21:
		{
            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s reaches into their pocket, pulling out a large quantity of pills, swallowing them.", GetRPName(playerid));
		}
		case 22 .. 24:
		{
		   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s raises their handgun to their head, pulling the trigger.", GetRPName(playerid));
		}
		case 25 .. 27:
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s places the barrel of their shotgun into their mouth, pulling the trigger.", GetRPName(playerid));
		}
		case 28 .. 39:
  		{
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s places the barrel of their weapon into their mouth, pulling the trigger.", GetRPName(playerid));
		}
	}
	DamagePlayer(playerid, 300, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
	return 1;
}



CMD:clearreports(playerid, params[])
{	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	for(new i = 0; i < MAX_REPORTS; i ++)
	{
 		if(ReportInfo[i][rExists])
		{
			ReportInfo[i][rExists] = 0;
		}
	}
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has cleared all active reports.", GetRPName(playerid));
	return 1;
}
// Anti Cheat  Drizzy

stock loadAntiCheatSettings()
{
	printf("[LoadAntiCheat] Loading data from database...");
    mysql_tquery(connectionID, "SELECT * FROM `anticheat_settings`", "UploadAntiCheat");
}

forward UploadAntiCheat();
public UploadAntiCheat()
{
    new rows = cache_num_rows(), tick = GetTickCount();

	if (!rows)
	{
        print("[MySQL]: Anti-cheat settings were not found in the database. Loading of the mod stopped - configure anti-cheat. ");
        return GameModeExit();
    }

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        AC_CODE_TRIGGER_TYPE[i] = SQL_GetInt(i, "ac_code_trigger_type");

        if (AC_CODE_TRIGGER_TYPE[i] == AC_CODE_TRIGGER_TYPE_DISABLED) {
            EnableAntiCheat(i, 0);
        }
    }

    new mes[128];
    format(mes, sizeof(mes), "[ANTICHEAT]: Anti-cheat settings loaded successfully (loaded: %i). Time: %i мс.", rows, GetTickCount() - tick);
    print(mes);

    return 1;
}

forward OnCheatDetected(playerid, const ip_address[], type, code);
public OnCheatDetected(playerid, const ip_address[], type, code)
{
    if (type == AC_GLOBAL_TRIGGER_TYPE_PLAYER)
    {
        switch(code)
        {
            case 5, 6, 11, 22:
            {
                return 1;
            }
            case 32: // CarJack
            {
                new
                    Float:x,
                    Float:y,
                    Float:z;

                AntiCheatGetPos(playerid, x, y, z);
                return SetPlayerPos(playerid, x, y, z);
            }
            default:
            {
                if (gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME)
                    return 1;

                pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
                AC_CODE_TRIGGERED_COUNT[code]++;

                new trigger_type = AC_CODE_TRIGGER_TYPE[code];

                switch(trigger_type)
                {
                    case AC_CODE_TRIGGER_TYPE_DISABLED: return 1;
                    case AC_CODE_TRIGGER_TYPE_WARNING:
                    {
                    	new str[128];
						if(AC_CODE_TRIGGERED_PLAYER_COUNT[playerid] >= 2)
						{
							 if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][pAdmin] < 8) {
                             	SendAdminMessage(COLOR_RED, str);
								AC_CODE_TRIGGERED_PLAYER_COUNT[playerid] = 0;
                             	SM(playerid, -1, "You were kicked on suspicion of using cheat programs: %s [code: %03d].", AC_CODE_NAME[code], code);
                             	AntiCheatKickWithDesync(playerid, code);
								
                        	 } else {
                               SendAdminMessage(COLOR_YELLOW, "Admin %s[%d] attempted to use cheats, but was not kicked.", GetRPName(playerid), playerid);
                         	}
						}
						if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][pAdmin] < 8) {
							format(str, sizeof(str),"%s[%d] suspected of using cheat programs: %s [code: %03d].", GetRPName(playerid), playerid, AC_CODE_NAME[code], code);
                    		SendAdminMessage(COLOR_RED, str);
							AC_CODE_TRIGGERED_PLAYER_COUNT[playerid]++;
					
                    		SM(playerid, -1, "You were suspected of using cheat programs: %s [code: %03d].", AC_CODE_NAME[code], code);
						}
						else {
                              SendAdminMessage(COLOR_YELLOW, "Admin %s[%d] attempted to use cheats, but was not kicked.", GetRPName(playerid), playerid);
                        }
					}
                    case AC_CODE_TRIGGER_TYPE_KICK:
                    {
                         new str[128];
                         format(str, sizeof(str), "%s[%d] was kicked on suspicion of using cheat programs: %s [code: %03d].", GetRPName(playerid), playerid, AC_CODE_NAME[code], code);

                         // Check if the player is an admin before kicking
                         if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][pAdmin] < 8) {
                             SendAdminMessage(COLOR_RED, str);
                             SM(playerid, -1, "You were kicked on suspicion of using cheat programs: %s [code: %03d].", AC_CODE_NAME[code], code);
                             AntiCheatKickWithDesync(playerid, code);
                         } else {
                              SendAdminMessage(COLOR_YELLOW, "Admin %s[%d] attempted to use cheats, but was not kicked.", GetRPName(playerid), playerid);
                         }
                     }

                }
            }
        }
    }
    else //AC_GLOBAL_TRIGGER_TYPE_IP
    {
        AC_CODE_TRIGGERED_COUNT[code]++;
        new str[128];
        format(str, sizeof(str),"<AC-BAN-IP> IP address %s was blocked: %s [code: %03d].", ip_address, AC_CODE_NAME[code], code);
        SendAdminMessage(COLOR_RED, str);
		BlockIpAddress(ip_address, 60 * 1000);
    }
    return 1;
}



stock ShowPlayer_AntiCheatSettings(playerid)
{
    static
        dialog_string[42 + 19 - 8 + (AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH + AC_MAX_TRIGGER_TYPE_NAME_LENGTH + 10)*AC_MAX_CODES_ON_PAGE] = EOS;

    new
        triggeredCount = 0,
        page = pAntiCheatSettingsPage{playerid},
        next = 0,
        index = 0;

    dialog_string = "Name\tPunishment\tNumber of positives\n";

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        if (i >= (page * AC_MAX_CODES_ON_PAGE) && i < (page * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
            next++;

        if (i >= (page - 1) * AC_MAX_CODES_ON_PAGE && i < ((page - 1) * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
        {
            triggeredCount = AC_CODE_TRIGGERED_COUNT[i];

            format(dialog_string, sizeof(dialog_string), "%s[%s] %s\t%s\t%d\n",
                dialog_string,
                AC_CODE[i],
                AC_CODE_NAME[i],
                AC_TRIGGER_TYPE_NAME[AC_CODE_TRIGGER_TYPE[i]],
                triggeredCount);

            pAntiCheatSettingsMenuListData[playerid][index++] = i;
        }
    }

    if (next)
        strcat(dialog_string, ""AC_DIALOG_NEXT_PAGE_TEXT"\n");

    if (page > 1)
        strcat(dialog_string, AC_DIALOG_PREVIOUS_PAGE_TEXT);

    return ShowPlayerDialog(playerid, ANTICHEAT_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Anti-cheat settings", dialog_string, "Select", "Cancel");
}

//The function of showing the menu for editing the type of triggering of a certain code in anti-cheat
stock ShowPlayer_AntiCheatEditCode(playerid, code)
{
    new
        dialog_header[22 - 4 + AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH],
        dialog_string[AC_MAX_TRIGGER_TYPE_NAME_LENGTH*AC_MAX_TRIGGER_TYPES];

    format(dialog_header, sizeof(dialog_header), "Code: %s | Name: %s", AC_CODE[code], AC_CODE_NAME[code]); //Название

    for(new i = 0; i < AC_MAX_TRIGGER_TYPES; i++)
    {
        strcat(dialog_string, AC_TRIGGER_TYPE_NAME[i]);

        if (i + 1 != AC_MAX_TRIGGER_TYPES)
            strcat(dialog_string, "\n");
    }

    return ShowPlayerDialog(playerid, ANTICHEAT_EDIT_CODE, DIALOG_STYLE_LIST, dialog_header, dialog_string, "Select", "Return");
}

CMD:anticheats(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 11 && !IsPlayerAdmin(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

    pAntiCheatSettingsPage{playerid} = 1; // Set the variable that stores the page number the player is on to the value 1 (that is, now the player is on page 1)
    return ShowPlayer_AntiCheatSettings(playerid); // Show the player the main anti-cheat settings dialog
}
CMD:windows(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be inside a vehicle to use this command.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}
    if(!VehicleHasWindows(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle does not have any windows.");
	}
	if(CarWindows[vehicleid])
	{
	    CarWindows[vehicleid] = 0;
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s rolls down the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    CarWindows[vehicleid] = 1;
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s rolls up the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}

// - COMMANDS BY Rocky
CMD:taclight(playerid, params[])
{
	if (!PlayerInfo[playerid][pFlashlight]) {
		return SM(playerid, SERVER_COLOR, "[!] "WHITE"You must have a flashlight to use this command.");
	}
	if(PlayerInfo[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 6, 0.25, -0.0175, 0.16, 86.5, -185, 86.5, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 6, 0.2, 0.01, 0.16, 90, -95, 90, 1, 1, 1);
		SendProximityMessage(playerid, 30.0, COLOR_LE, "** %s attaches their flashlight to the top of their weapon.", GetRPName(playerid));

		PlayerInfo[playerid][pUsedFlashlight] = 1;
	}
	else
	{
		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
		PlayerInfo[playerid][pUsedFlashlight] =0;
		SendProximityMessage(playerid, 30.0, COLOR_LE, "** %s detaches their flashlight from their weapon.", GetRPName(playerid));
	}
	return 1;
}
CMD:flashlight(playerid, params[])
{
	if (!PlayerInfo[playerid][pFlashlight]) {
		return SM(playerid, SERVER_COLOR, "[!] "WHITE"You must have a flashlight to use this command.");
	}
	if(PlayerInfo[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 5, 0.1, 0.038, -0.01, -90, 180, 0, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
		SendProximityMessage(playerid, 30.0, COLOR_LE, "** %s takes out a flashlight and turns it on.", GetRPName(playerid));

		PlayerInfo[playerid][pUsedFlashlight] =1;
	}
	else
	{
 		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
  		PlayerInfo[playerid][pUsedFlashlight] =0;
  		SendProximityMessage(playerid, 30.0, COLOR_LE, "** %s puts their flashlight back in their pocket.", GetRPName(playerid));
	}
	return 1;
}



CMD:registercar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:vpos[3];

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1824.496704, -1426.201660, 13.655930))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any DMV.");
	}
	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	}
	if(vehicleFuel[vehicleid] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no fuel left in this vehicle.");
	}

	if(VehicleInfo[vehicleid][vFactionType] != FACTION_NONE && GetFactionType(playerid) != VehicleInfo[vehicleid][vFactionType])
 	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't belong to your faction, therefore you can't register it.");
 		return 1;
	}
 	if(VehicleInfo[vehicleid][vGang] >= 0 && PlayerInfo[playerid][pGang] != VehicleInfo[vehicleid][vGang])
 	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't belong to your gang, therefore you can't register it.");
 		return 1;
 	}
	if(VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid))
	{
 		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't belong to you, therefore you can't register it.");
	}
	if(VehicleInfo[vehicleid][vRegistered])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is already registered.");
	}
	if(PlayerInfo[playerid][pCash] < 50000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must have $50,000 to register a vehicle.");
	}
	GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

	VehicleInfo[vehicleid][vRegistered] = 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET registered = 1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
    mysql_tquery(connectionID, queryBuffer);

	SM(playerid, SERVER_COLOR, "You have successfully registered this vehicle.");
	GivePlayerCash(playerid, -50000);
	ReloadVehicle(vehicleid);
	SetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2] + 1);
	return 1;
}


