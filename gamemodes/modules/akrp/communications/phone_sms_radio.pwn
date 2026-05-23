CMD:t(playerid, params[])
{
	return callcmd::sms(playerid, params);
}

CMD:sms(playerid, params[])
{
	new number, msg[128];

	if(sscanf(params, "is[128]", number, msg))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sms [number] [message]");
	}
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
	}
	if(PlayerInfo[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(number == 0 || number == PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid number.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are unable to use your cellphone at the moment.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPhone] == number)
	    {
	        if(PlayerInfo[i][pJailType] > 0)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently imprisoned and cannot use their phone.");
	        }
	        if(PlayerInfo[i][pTogglePhone])
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "That player has their mobile phone switched off.");
			}

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out a cellphone and sends a message.", GetRPName(playerid));

			if(strlen(msg) > MAX_SPLIT_LENGTH)
			{
			    SM(i, COLOR_YELLOW, "** SMS from %s (%i): %.*s... **", GetRPName(playerid), PlayerInfo[playerid][pPhone], MAX_SPLIT_LENGTH, msg);
			    SM(i, COLOR_YELLOW, "** SMS from %s (%i): ...%s **", GetRPName(playerid), PlayerInfo[playerid][pPhone], msg[MAX_SPLIT_LENGTH]);

			    SM(playerid, COLOR_YELLOW, "** SMS to %s (%i): %.*s... **", GetRPName(i), PlayerInfo[i][pPhone], MAX_SPLIT_LENGTH, msg);
			    SM(playerid, COLOR_YELLOW, "** SMS to %s (%i): ...%s **", GetRPName(i), PlayerInfo[i][pPhone], msg[MAX_SPLIT_LENGTH]);
			}
			else
			{
		        SM(i, COLOR_YELLOW, "** SMS from %s (%i): %s **", GetRPName(playerid), PlayerInfo[playerid][pPhone], msg);
		        SM(playerid, COLOR_YELLOW, "** SMS to %s (%i): %s **", GetRPName(i), PlayerInfo[i][pPhone], msg);
			}

			if(PlayerInfo[i][pTextFrom] == INVALID_PLAYER_ID)
			{
			    SendClientMessage(i, COLOR_WHITE, "** You can use '/rsms [message]' to reply to this text message.");
			}

			PlayerInfo[i][pTextFrom] = playerid;

	        GivePlayerCash(playerid, -1);
	        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$1", 5000, 1);

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO texts VALUES(null, %i, %i, '%s', NOW(), '%e')", PlayerInfo[playerid][pPhone], number, GetPlayerNameEx(playerid), msg);
	   		mysql_tquery(connectionID, queryBuffer);
	        return 1;
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, jailtype, togglephone FROM users WHERE phone = %i", number);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerSendTextMessage", "iis", playerid, number, msg);
	return 1;
}

CMD:texts(playerid)
{
    if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM texts WHERE recipient_number = %i ORDER BY date DESC", PlayerInfo[playerid][pPhone]);
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VIEW_TEXTS, playerid);
	return 1;
}

CMD:call(playerid, params[])
{
	new number;

	if(sscanf(params, "i", number))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /call [number]");
	    SendClientMessage(playerid, COLOR_WHITE, "Special numbers: 911 = Emergency hotline, 6397 = News, 6324 = Mechanic");
	    return 1;
	}
	if(number == 911)
	{
	    PlayerInfo[playerid][pCallLine] = playerid;
		PlayerInfo[playerid][pCallStage] = 911;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
		SendClientMessage(playerid, COLOR_DISPATCH, "911, what is your emergency? Enter 'police' or 'medic'.");
		return 1;
	}
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
	}
	if(PlayerInfo[playerid][pSIM] == SIM_NONE)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a SIM card.");
    }
    if(PlayerInfo[playerid][pLoad] <= 0 || PlayerInfo[playerid][pLoadExpiry] < gettime())
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough load or your load has expired.");
    }
	if(PlayerInfo[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have a call in session. /(h)angup to end that call.");
	}
	if(number == 0 || number == PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid number.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are unable to use your cellphone at the moment.");
	}

	
	if(number == 6397)
	{
	    PlayerInfo[playerid][pCallLine] = playerid;
		PlayerInfo[playerid][pCallStage] = 6397;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
		SendClientMessage(playerid, COLOR_DISPATCH, "This is SANews here. Leave a message and we'll get back to you! *BEEP*");
		return 1;
	}
	else if(number == 6324)
	{
	    PlayerInfo[playerid][pCallLine] = playerid;
		PlayerInfo[playerid][pCallStage] = 6324;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
		SendClientMessage(playerid, COLOR_DISPATCH, "This is the mechanic hotline. Please explain your situation to us.");
		return 1;
	}
	else if(number == 8294)
	{
	    PlayerInfo[playerid][pCallLine] = playerid;
		PlayerInfo[playerid][pCallStage] = 8294;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
		SendClientMessage(playerid, COLOR_DISPATCH, "This is the cab company. Please state your location and destination.");
		return 1;
	}
	else if(number == 666)
	{
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
	    SendClientMessage(playerid, COLOR_WHITE, "** They hung up their phone and ended the call.");
	    return 1;
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pPhone] == number)
	    {
	    	new string[32];
	        if(PlayerInfo[i][pJailType] > 0)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently imprisoned and cannot use their phone.");
	        }
	        if(PlayerInfo[i][pCallLine] != INVALID_PLAYER_ID)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "This player is currently in a call. Wait until they hang up.");
	        }
	        if(PlayerInfo[i][pTogglePhone])
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "That player has their mobile phone switched off.");
			}
			if(PlayerInfo[i][pLiveBroadcast] != INVALID_PLAYER_ID)
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently in a live interview and can't talk on the phone.");
	        }

	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

			PlayerInfo[playerid][pCallLine] = i;
			PlayerInfo[playerid][pCallStage] = 0;

			PlayerInfo[i][pCallLine] = playerid;
			PlayerInfo[i][pCallStage] = 1;
			
   		  

			format(string, sizeof(string), "%i", PlayerInfo[playerid][pPhone]);
			DynamicPlayerTextDrawSetString(i, NumberTD[i], string);

			PlayerInfo[playerid][pLoad] -= 1;
			SM(playerid, COLOR_YELLOW, "** You now have %i Calls Left", PlayerInfo[playerid][pLoad]);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET `load` = %i WHERE uid = %i", PlayerInfo[playerid][pLoad], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
			SendProximityMessage(i, 20.0, SERVER_COLOR, "**{C2A2DA} %s's mobile phone begins to ring.", GetRPName(i));

	        SM(playerid, COLOR_YELLOW, "** You've placed a call to number: %i. Please wait for your call to be answered.", number);
	        SM(i, COLOR_YELLOW, "** Incoming call from #%i. Use /pickup to take this call.", PlayerInfo[playerid][pPhone]);
	        return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "That number is either not in service or the owner is offline.");
	return 1;
}

CMD:p(playerid, params[])
{
	return callcmd::pickup(playerid, params);
}

CMD:pickup(playerid, params[])
{
	if(PlayerInfo[playerid][pCallStage] != 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no incoming calls which you can answer right now.");
	}
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are unable to use your cellphone at the moment.");
	}

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s presses a button and answers their mobile phone.", GetRPName(playerid));
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

	PlayerInfo[PlayerInfo[playerid][pCallLine]][pCallStage] = 2;
	PlayerInfo[playerid][pCallStage] = 2;
	
	
	
    new callerHasVoiceOnClient = GetPVarInt(playerid,"hasVoiceOnClient");
   	new calledHasVoiceOnClient = GetPVarInt(PlayerInfo[playerid][pCallLine],"hasVoiceOnClient");
	if(callerHasVoiceOnClient == 1 && calledHasVoiceOnClient == 1) {
		isUsingPhoneVoip[playerid] = true;
		CallRemoteFunction("callstreams", "ii", PlayerInfo[playerid][pCallLine], playerid);
	}
	else {
		SendClientMessage(playerid, -1, "Samp-Voice Plugin Not Found");
	}



	SendClientMessage(playerid, COLOR_WHITE, "** You have answered the call. You can now speak in chat to talk to the caller.");
	SendClientMessage(PlayerInfo[playerid][pCallLine], COLOR_WHITE, "** They answered the call. You can now speak in chat to talk to them.");
	return 1;
}

CMD:h(playerid, params[])
{
	return callcmd::hangup(playerid, params);
}

CMD:hangup(playerid, params[])
{
	if(PlayerInfo[playerid][pCallLine] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no calls in session which you can hangup.");
	}
    HangupCall(playerid, HANGUP_USER);
	return 1;
}

CMD:stats(playerid, params[])
{
	if(!PlayerInfo[playerid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	ShowStatsDialog(playerid, playerid);
	return 1;
}

stock IsAHitman(playerid)
{
	return GetFactionType(playerid) == FACTION_HITMAN;
}

stock ShowStatsDialog(playerid, targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1300], header[1300], faction[48], facrank[32], division[32], gang[32], gangrank[32];
		if(PlayerInfo[targetid][pFaction] >= 0)
		{
			if(!strcmp(FactionInfo[PlayerInfo[targetid][pFaction]][fShortName], "", true))
			{
				strcpy(faction, FactionInfo[PlayerInfo[targetid][pFaction]][fName]);
			}
			else
			{
				strcpy(faction, FactionInfo[PlayerInfo[targetid][pFaction]][fShortName]);
			}

			format(facrank, sizeof(facrank), "(%i) %s ", PlayerInfo[targetid][pFactionRank], FactionRanks[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pFactionRank]]);

			if(PlayerInfo[targetid][pDivision] >= 0)
			{
				strcpy(division, FactionDivisions[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pDivision]]);
			}
			else
			{
				division = "";
			}
		}
		else
		{
			faction = "None";
			facrank = "None";
			division = "None";
		}
		if(PlayerInfo[targetid][pGang] >= 0)
		{
		    strcpy(gang, GangInfo[PlayerInfo[targetid][pGang]][gName]);
		    strcpy(gangrank, GangRanks[PlayerInfo[targetid][pGang]][PlayerInfo[targetid][pGangRank]]);
		}
		else
		{
		    gang = "None";
		    gangrank = "None";
		}
		new drank[64];
		if(PlayerInfo[targetid][pVIPPackage] > 0)
		{
			switch(PlayerInfo[targetid][pVIPPackage])
			{
				case 1: drank = "Bronze VIP";
				case 2: drank = "Silver VIP";
				case 3: drank = "Gold VIP";
			}
		}
		new exp = (PlayerInfo[targetid][pLevel] * 4);
		new Float:health, Float:armor;
		GetPlayerHealth(targetid, health);
		GetPlayerArmour(targetid, armor);

		format(header, sizeof(header), "Account");
		format(resultline, sizeof(resultline), "\n\
			"SVRCLR"[Faction Stats]:\n\n\
			"WHITE"Faction: [%s]\n\
			"WHITE"Faction Rank: [%s]\n\
			"WHITE"Faction Division: [%s]\n\
			"WHITE"Job: [%s]\n\n\
			"SVRCLR"[Gang Stats]:\n\n\
			"WHITE"Gang alliance: [%s]\n\
			"WHITE"Gang Rank: [%s]\n\n\
			"SVRCLR"[Other Stats]:\n\n\
			"WHITE"Level: [%s]\n\
			"WHITE"Playing Hours: [%s]\n\
			"WHITE"Experience: [%i]\n\
			"WHITE"Donator Level: [%s]\n\
			"WHITE"Health: [%.1f/150.0]\n\
			"WHITE"Cash: [%s]\n\
			"WHITE"Bank: [%s]\n\
			"WHITE"Paycheck: [%s]\n\n\
			"SVRCLR"[Note]:\n\n\
			"WHITE"Don't give your account to other player, to prevent hacking of your account\n\
			"WHITE"and we will not be able to refund your account.",
			faction, facrank, division, GetJobName(PlayerInfo[targetid][pJob]),
			gang, gangrank,
			number_format(PlayerInfo[targetid][pLevel]), number_format(PlayerInfo[targetid][pHours]),
			exp - PlayerInfo[targetid][pEXP], drank, GetPlayerHealth(targetid, health),
			number_format(PlayerInfo[targetid][pCash]), number_format(PlayerInfo[targetid][pBank]), number_format(PlayerInfo[targetid][pPaycheck]));
		ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Ok", "");
	}
	return 1;
}


CMD:inv(playerid, params[])
{
    
    Inventory_Show(playerid);
	Inventory_Update(playerid);
	return 1;
}
CMD:invlist(playerid, params[])
{
    DisplayInventory(playerid);
	return 1;
}
DisplayInventory(playerid, targetid = INVALID_PLAYER_ID)
{
	if(targetid == INVALID_PLAYER_ID) targetid = playerid;

	new package[12], resultline[2048], header[2048];
	switch(PlayerInfo[playerid][pSmuggleDrugs])
	{
	    case 0: package = "None";
	    case 1: package = "Seeds";
	    case 2: package = "Crack";
	    case 3: package = "Ephedrine";
	}

	format(header, sizeof(header), "Account Inventory");
	format(resultline, sizeof(resultline), "\n\
		"SVRCLR"[Package Stats]:\n\n\
		"WHITE"Materials: [%s/%i]\n\
		"WHITE"Pot: [%i/%ig]\n\
		"WHITE"Crack: [%i/%ig]\n\
		"WHITE"Meth: [%i/%ig]\n\
		"WHITE"Seeds: [%i/%ig]\n\
		"WHITE"Pain Killers: [%i/%ig]\n\
		"WHITE"Ephedrine: [%i/%ig]\n\
		"WHITE"Muriatic acid: [%i/20]\n\
		"WHITE"Baking soda: [%i/20]\n\n\
		"SVRCLR"[Other Stats]:\n\n\
		"WHITE"Mobile Phone: [%s]\n\
		"WHITE"Phonebook: %s: [%s]\n\
		"WHITE"Portable Radio: []\n\
		"WHITE"GPS: [%s]\n\
		"WHITE"Pot: []\n\
		"WHITE"Pot: []\n\
		"WHITE"Pot: []\n\
		"WHITE"Pot: []\n\
		"SVRCLR"[Note]:\n\n\
		"WHITE"Don't give your account to other player, to prevent hacking of your account\n\
		"WHITE"and we will not be able to refund your account.", AddCommas(PlayerInfo[playerid][pMaterials]), GetPlayerCapacity(playerid, CAPACITY_MATERIALS), PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED),
		PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE), PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH), 
		PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS), PlayerInfo[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS),
		PlayerInfo[playerid][pEphedrine], GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE), PlayerInfo[playerid][pMuriaticAcid], PlayerInfo[playerid][pBakingSoda],
		(PlayerInfo[playerid][pPhone]) ? ("Yes") : ("No"), (PlayerInfo[playerid][pPhonebook]) ? ("Yes") : ("No"), (PlayerInfo[playerid][pWalkieTalkie]) ? ("Yes") : ("No"),
		(PlayerInfo[playerid][pGPS]) ? ("Yes") : ("No"));
	ShowPlayerDialog(playerid, DIALOG_INVSTATS, DIALOG_STYLE_MSGBOX, header, resultline, "Ok", "");
	return 1;
}
CMD:ddedit(playerid, params[]) return callcmd::editentrance(playerid, params);
CMD:gotoid(playerid, params[]) return callcmd::goto(playerid, params);
new turftog[] = "turfs";
new pointtog[] = "points";
new pmtog[] = "pm";
new gangtog[] = "gang";
new crewtog[] = "crew";
new whispertog[] = "whisper";
new newstog[] = "news";
new newbiestog[] = "newbie";
new hudtog[] = "hud";
new chatanimtog[] = "chatanim";
CMD:togturfs(playerid) return callcmd::toggle(playerid, turftog);
CMD:togpoints(playerid) return callcmd::toggle(playerid, pointtog);
CMD:togpm(playerid) return callcmd::toggle(playerid, pmtog);
CMD:togfam(playerid) return callcmd::toggle(playerid, gangtog);
CMD:togcrew(playerid) return callcmd::toggle(playerid, crewtog);
CMD:togwhisper(playerid) return callcmd::toggle(playerid, whispertog);
CMD:tognews(playerid) return callcmd::toggle(playerid, newstog);
CMD:tognewbie(playerid) return callcmd::toggle(playerid, newbiestog);
CMD:valo(playerid) return callcmd::toggle(playerid, hudtog);
CMD:togchatanim(playerid) return callcmd::toggle(playerid, chatanimtog);
CMD:tog(playerid, params[]) return callcmd::toggle(playerid, params);
