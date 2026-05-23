CMD:taxhelp(playerid, params[])
{
	SM(playerid, COLOR_SYNTAX, "The tax is currently set to {CCFFFF}%i percent", gTax);
	return 1;
}
CMD:timers(playerid, params[])
{
	printf("Running timers: %d", CountRunningTimers());
	return 1;
}
CMD:tn(playerid, params[]) return callcmd::trashnewb(playerid, params);
CMD:trashnewb(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] >= 1 || PlayerInfo[playerid][pAdmin] >= 2)
	{
	    new giveplayerid, string[128], reason[128];
		if(sscanf(params, "us[128]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /trashnewb (playerid) (text)");
		if(GetPVarInt(giveplayerid, "SendQuestion") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player isn't asking");
		format(string, sizeof(string), "* Staff %s has trashed your question. Reason: %s", GetPlayerNameEx(playerid), reason);
		SendClientMessageEx(giveplayerid, COLOR_GREEN, string);
		format(string, sizeof(string), "* %s has trashed %s question. Reason: %s", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), reason);
		SendQuestionToStaff(COLOR_GREEN, string);
		DeletePVar(giveplayerid, "SendQuestion");
		DeletePVar(giveplayerid, "Question");
		return 1;
	}
	else SendClientMessageEx(playerid, COLOR_GREEN, "You're not a Helper or an Admin!");
	return 1;
}

CMD:na(playerid, params[]) return callcmd::nanswer(playerid, params);
CMD:nanswer(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] >= 1 || PlayerInfo[playerid][pAdmin] >= 2)
	{
	    new giveplayerid, string[300], answer[128], question[128];
		if(sscanf(params, "us[128]", giveplayerid, answer)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /nanswer (playerid) (answer)");
		if(GetPVarInt(giveplayerid, "SendQuestion") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player isn't asking");
		format(string, sizeof(string), "* Staff %s has answered your Question", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_GREEN, string);
		GetPVarString(giveplayerid, "Question", question, sizeof(question));
		foreach(new n: Player)
		{
		    if(!PlayerInfo[n][pToggleNewbie])
		    {
			    format(string, sizeof(string), "Question: %s: %s", GetPlayerNameEx(giveplayerid), question);
			    SendClientMessageEx(n, COLOR_NEWBIE, string);
			    if(PlayerInfo[playerid][pHelper] == 1 && PlayerInfo[playerid][pAdmin] < 2)
			    {
					format(string, sizeof(string), "Answer: %s: %s", GetPlayerNameEx(playerid), answer);
					PlayerInfo[playerid][pNewbies] ++;
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET newbies = %i WHERE uid = %i", PlayerInfo[playerid][pNewbies], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}
				if(PlayerInfo[playerid][pHelper] >= 2 && PlayerInfo[playerid][pAdmin] < 1) format(string, sizeof(string), "Answer: %s: %s", GetPlayerNameEx(playerid), answer);
				if(PlayerInfo[playerid][pAdmin] >= 2) format(string, sizeof(string), "Answer: %s: %s", GetPlayerNameEx(playerid), answer);
				SendClientMessageEx(n, COLOR_NEWBIE, string);
			}
		}
		DeletePVar(giveplayerid, "SendQuestion");
		DeletePVar(giveplayerid, "Question");
		return 1;
	}
	else SendClientMessageEx(playerid, COLOR_GREEN, "You're not a Helper or an Admin!");
	return 1;

}

CMD:buyinsurance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 204.8622,1883.6208,369.3091))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in any of the hospitals.");
	}
	if(PlayerInfo[playerid][pCash] < 5000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford insurance.");
	}

	switch(GetPlayerVirtualWorld(playerid))
	{
	    case HOSPITAL_COUNTY:
	    {
	        if(PlayerInfo[playerid][pInsurance] == HOSPITAL_COUNTY)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -5000);
	        GameTextForPlayer(playerid, "~r~-$5000", 5000, 1);
	        SendClientMessage(playerid, COLOR_GREEN, "You paid $5000 for insurance at {FF8282}Northern Hospital{CCFFFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET insurance = %i WHERE uid = %i", HOSPITAL_COUNTY, PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerInfo[playerid][pInsurance] = HOSPITAL_COUNTY;
	    }
	    case HOSPITAL_ALLSAINTS:
	    {
	        if(PlayerInfo[playerid][pInsurance] == HOSPITAL_ALLSAINTS)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -5000);
	        GameTextForPlayer(playerid, "~r~-$5000", 5000, 1);
	        SendClientMessage(playerid, COLOR_GREEN, "You paid $5000 for insurance at {FF8282}All Saints Hospital{CCFFFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET insurance = %i WHERE uid = %i", HOSPITAL_ALLSAINTS, PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerInfo[playerid][pInsurance] = HOSPITAL_ALLSAINTS;
	    }
	    case HOSPITAL_VIP:
	    {
	        if(PlayerInfo[playerid][pInsurance] == HOSPITAL_VIP)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -5000);
	        GameTextForPlayer(playerid, "~r~-$5000", 5000, 1);
	        SendClientMessage(playerid, COLOR_GREEN, "You paid $5000 for insurance at {FF8282}County General{CCFFFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET insurance = %i WHERE uid = %i", HOSPITAL_VIP, PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerInfo[playerid][pInsurance] = HOSPITAL_VIP;
	    }
	}

	return 1;
}
new gelection = 0;
CMD:vote(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 1940.153442, -1823.597045, 13.586874) || !IsPlayerInRangeOfPoint(playerid, 2.0, 1940.144287, -1825.208007, 13.586874)){
	    return 1;
	}
	if(PlayerInfo[playerid][pVoted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You Already Voted.");
	}
	if(gelection == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Wait For Officers");
	}
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM factions WHERE type = 4");
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VOTE_LOAD, playerid);
    
    return 1;
	
}
CMD:votelist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
		
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM factions WHERE type = 4");
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VOTE_LOAD1, playerid);

	return 1;

}
CMD:voters(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE voted = 1");
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_VOTERS, playerid);

	return 1;

}
CMD:togvote(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(gelection == 0)
	{
       gelection = 1;
       SendClientMessage(playerid, COLOR_SYNTAX, "Election Started");
	}
	else
	{
	   gelection = 0;
	   SendClientMessage(playerid, COLOR_SYNTAX, "Election Stoped");
	   

       mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM users WHERE voted = 1");
       mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_VOTERS, playerid);

	}

	return 1;

}
CMD:poll(playerid, params[])
{
	new string[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(sscanf(params, "s[128]", params))
		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /poll [question]");

	if(strlen(params) > 128)
		return SendClientMessage(playerid, COLOR_SYNTAX, "Maximum characters limit is 128.");

	if(PollOn)
		return SendClientMessage(playerid, COLOR_SYNTAX, "There is already an poll started.");

	format(string, sizeof(string), "** Question:"WHITE" %s {FF6347}**", params);
	SMA(COLOR_LIGHTRED, string);

	SMA(COLOR_LIGHTRED, "** Press "WHITE"Y{FF6347} to vote "WHITE"Yes{FF6347}, Press "WHITE"N{FF6347} to vote "WHITE"No{FF6347}. **");
	SMA(COLOR_LIGHTRED, "** Poll ending in "WHITE"30{FF6347} Seconds. **");

	PollOn = 1;
	PollN = 0;
	foreach(new i: Player)
	{
		PollVoted[i] = 0;
	}
	PollY = 0;
	SetTimer("pollend", 30000, false);
	return 1;
}

CMD:blindfold(playerid,params[])
{
    new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /blindfold [playerid]");
	}
	if(PlayerInfo[playerid][pBlindfold] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any blindfolds left.");
	}
	if(!IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected, That player must either be in your vehicle..");
	}
	if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't blindfold the driver.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't blindfold yourself.");
	}
	if(pBlind[targetid])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already blindfolded. /unblindfold to free them.");
	}
	if(PlayerInfo[targetid][pAcceptedHelp])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't blindfold a helper who is assisting someone.");
	}
	if(PlayerInfo[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't blindfold an on duty administrator.");
	}


	PlayerInfo[playerid][pBlindfold]--;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET blindfold = %i WHERE uid = %i", PlayerInfo[playerid][pBlindfold], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	GameTextForPlayer(targetid, "~r~Blindfold", 3000, 3);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s blindfold %s with a bandana.", GetRPName(playerid), GetRPName(targetid));

	TogglePlayerControllable(targetid, 0);
	TextDrawShowForPlayer(targetid, Blind);
	pBlind[targetid] = 1;
    return 1;
}

CMD:unblindfold(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unblindfold [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't unblindfold yourself.");
	}
	if(!pBlind[targetid])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not blindfold.");
	}
	if(IsPlayerInAnyVehicle(targetid) && !IsPlayerInVehicle(playerid, GetPlayerVehicleID(targetid)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in that player's vehicle in order to unblindfold them.");
	}

	GameTextForPlayer(targetid, "~g~Unblindfold", 3000, 3);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unblindfoild the bandana from %s.", GetRPName(playerid), GetRPName(targetid));

    TextDrawHideForPlayer(targetid, Blind);
	pBlind[targetid] = 0;
	return 1;
}

CMD:tie(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /tie [playerid]");
	}
	if(PlayerInfo[playerid][pRope] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any ropes left.");
	}
	if(!IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected, That player must either be in your vehicle..");
	}
	if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't tie up the driver.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't tie yourself.");
	}
	if(PlayerInfo[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already tied. /untie to free them.");
	}
	if(PlayerInfo[targetid][pAcceptedHelp])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't tie a helper who is assisting someone.");
	}
	if(PlayerInfo[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't tie an on duty administrator.");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to tie anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}

	PlayerInfo[playerid][pRope]--;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = %i WHERE uid = %i", PlayerInfo[playerid][pRope], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	GameTextForPlayer(targetid, "~r~Tied", 3000, 3);
	TogglePlayerControllable(targetid, 0);
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s ties %s with a rope.", GetRPName(playerid), GetRPName(targetid));

	TogglePlayerControllable(targetid, 0);
	PlayerInfo[targetid][pTied] = 1;
	return 1;
}

CMD:untie(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /untie [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't untie yourself.");
	}
	if(!PlayerInfo[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not tied.");
	}
	if(IsPlayerInAnyVehicle(targetid) && !IsPlayerInVehicle(playerid, GetPlayerVehicleID(targetid)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in that player's vehicle in order to untie them.");
	}
	if(PlayerInfo[playerid][pHurt])
	{
	    return SM(playerid, COLOR_GREY, "You're too hurt to untie anyone. Please wait %i seconds before trying again.", PlayerInfo[playerid][pHurt]);
	}

	GameTextForPlayer(targetid, "~g~Untied", 3000, 3);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unties the rope from %s.", GetRPName(playerid), GetRPName(targetid));

 	PlayerInfo[targetid][pDraggedBy] = INVALID_PLAYER_ID;

	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(targetid, 1);

	PlayerInfo[targetid][pTied] = 0;
	return 1;
}

CMD:signcheck(playerid, params[])
{
	SendClientMessage(playerid, COLOR_SYNTAX, "Auto Signcheck is on, No need for this.");
	return 1;
}

CMD:skate(playerid,params[])
{
	if(!PlayerInfo[playerid][pSkates])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You do not own any skates.");
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimationEx(playerid, "CARRY","null",0,0,0,0,0,0);
	    ApplyAnimationEx(playerid, "SKATE","null",0,0,0,0,0,0);
	    ApplyAnimationEx(playerid, "CARRY","crry_prtial",4.0,0,0,0,0,0);
	    SetPlayerArmedWeapon(playerid,0);
        if(!PlayerInfo[playerid][pSkating])
		{
            PlayerInfo[playerid][pSkating] = true;
            DestroyDynamicObject(PlayerInfo[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            SetPlayerAttachedObject(playerid, 5,19878,6,-0.055999,0.013000,0.000000,-84.099983,0.000000,-106.099998,1.000000,1.000000,1.000000);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_GREEN,"You have equiped your skating gear. Press RMB or Aim Key to skate.");
        }
		else
		{
			PlayerInfo[playerid][pSkating] = false;
            DestroyDynamicObject(PlayerInfo[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_GREEN, "You are no longer skating.");
        }
	}
	else SendClientMessage(playerid, COLOR_GREY, "You must not be inside a vehicle.");
 	return 1;
}

CMD:b(playerid, params[])
{
	new
	    string[144];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /b [local OOC]");
	}
	if(Maskara[playerid] == 1) {
		format(string, sizeof(string), "(( Stranger(B%d): %s ))", MaskaraID[playerid], params);
		SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	} else {
		format(string, sizeof(string), "(( [%d] %s: %s ))", playerid, GetRPName(playerid), params);
		SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	}
	return 1;
}

CMD:robbiz(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), count;
	if(gRobbery)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There is still an active robbery or the admin disabled the robbery of house/biz.");
	}
	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You aren't inside a business that you can rob.");
	}
	if(IsBusinessOwner(playerid, businessid)) {
		return SendClientMessage(playerid, COLOR_GREY2, "You can't rob your business.");
	}
	if(PlayerInfo[playerid][pLevel] < 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You need to be level 2 in order to rob the business.");
	}
	if(PlayerInfo[playerid][pRobbingBiz] >= 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You're already robbing a business.");
	}
	if(BusinessInfo[businessid][bRobbing] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You can't rob the business. Robbery has already started.");
	}
	if(BusinessInfo[businessid][bRobbed] > 0)
	{
	    return SM(playerid, COLOR_GREY2, "This business can be robbed again in %i hours. You can't rob it now.", BusinessInfo[businessid][bRobbed]);
	}
	if(PlayerInfo[playerid][pDuty] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You can't rob the business while on-duty.");
	}

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}

	if(count < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There needs to be at least 3+ LEO on-duty in order to rob the business.");
	}

	foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SM(i, COLOR_ROYALBLUE, "** HQ: A robbery is occurring at the %s. All units respond immediately.", GetZoneName(BusinessInfo[businessid][bPosX],BusinessInfo[businessid][bPosY],BusinessInfo[businessid][bPosZ]));
			SetPlayerCheckpoint(i, BusinessInfo[businessid][bPosX],BusinessInfo[businessid][bPosY],BusinessInfo[businessid][bPosZ], 3.0);
		}
	}

	PlayerInfo[playerid][pLootTime] = 5;
	GameTextForPlayer(playerid, "~w~Looting house vault...", 5000, 3);
	
	gRobbery = true;
	SMA(COLOR_YELLOW, "Breaking News"WHITE":"RED"%s"YELLOW" has attempted to rob a "GREEN"BUSINESS"YELLOW", COPS MUST RESPOND!!", GetRPName(playerid));

	new string[128];
	format(string, sizeof(string), "~r~Store Robbery on Progress");
    DynamicTextDrawSetString(Textdraw2, string);

 	SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s points his gun at the clerk and attempts to rob the business shop.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_GREY2,"** Wait until cops arrive for roleplay oses. (( You can door shout by inputting '/ds'. ))");
	PlayerInfo[playerid][pRobbingBiz] = businessid;
	BusinessInfo[businessid][bRobbing] = 1;
	return 1;
}


CMD:ds(playerid, params[])
{
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY2, "Usage: /ds [door shout text]");

	new string[128], idx;

	if((idx = GetNearbyHouse(playerid)) != -1 || (idx = GetInsideHouse(playerid)) != -1)
	{
		foreach(new i : Player)
		{
			if(i != playerid) {
				if((GetNearbyHouse(i) == idx) || (GetInsideHouse(i) == idx))
				{
					if(strlen(params) > 90)
					{
						format(string, sizeof(string), "(door) %s: %.90s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);
						format(string, sizeof(string), "(door) %s: ... %s", GetRPName(playerid), params[90]);
						SendClientMessage(i, COLOR_GREY1, string);
					} else {
						format(string, sizeof(string), "(door) %s: %s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);
					}
				}
			}
		}
		if(strlen(params) > 90)
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %.90s", GetRPName(playerid), params);
			SM(playerid, COLOR_GREY1, "(door) %s: ... %s", GetRPName(playerid), params[90]);
		}
		else
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %s", GetRPName(playerid), params);
		}
	}
	else if((idx = GetNearbyBusiness(playerid)) != -1 || (idx = GetInsideBusiness(playerid)) != -1) {
		foreach(new i : Player)
		{
			if(i != playerid) {
				if((GetNearbyBusiness(i) == idx) || (GetInsideBusiness(i) == idx))
				{
					if(strlen(params) > 90)
					{
						format(string, sizeof(string), "(door) %s: %.90s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);

						format(string, sizeof(string), "(door) %s: ... %s", GetRPName(playerid), params[90]);
						SendClientMessage(i, COLOR_GREY1, string);
					}
					else
					{
						format(string, sizeof(string), "(door) %s: %s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);
					}
				}
			}
		}
		if(strlen(params) > 90)
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %.90s", GetRPName(playerid), params);
			SM(playerid, COLOR_GREY1, "(door) %s: ... %s", GetRPName(playerid), params[90]);
		}
		else
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %s", GetRPName(playerid), params);
		}
	} else if((idx = GetNearbyEntranceEx(playerid)) != -1 || (idx = GetInsideEntrance(playerid)) != -1) {
		foreach(new i : Player)
		{
			if(i != playerid) {
				if((GetNearbyEntranceEx(i) == idx) || (GetInsideEntrance(i) == idx))
				{
					if(strlen(params) > 90)
					{
						format(string, sizeof(string), "(door) %s: %.90s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);

						format(string, sizeof(string), "(door) %s: ... %s", GetRPName(playerid), params[90]);
						SendClientMessage(i, COLOR_GREY1, string);
					}
					else
					{
						format(string, sizeof(string), "(door) %s: %s", GetRPName(playerid), params);
						SendClientMessage(i, COLOR_GREY1, string);
					}
				}
			}
		}
		if(strlen(params) > 90)
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %.90s", GetRPName(playerid), params);
			SM(playerid, COLOR_GREY1, "(door) %s: ... %s", GetRPName(playerid), params[90]);
		}
		else
		{
			SM(playerid, COLOR_GREY1, "(door) %s: %s", GetRPName(playerid), params);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You are not near any door.");
	}
	return 1;
}

CMD:mic(playerid, params[])
{
	new
	    string[144];

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1082.1001, -1740.0272, 14.1402))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any microphone.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /mic [text]");
	}

	SetPlayerBubbleText(playerid, 50.0, COLOR_YELLOW, "(Microphone) %s",params);
	format(string, sizeof(string), "[M] %s: %s!", GetRPName(playerid), params);
	SendProximityFadeMessage(playerid, 50.0, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);

	return 1;
}

CMD:s(playerid, params[]) return callcmd::shout(playerid, params);
CMD:shout(playerid, params[])
{
	new
	    string[144];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(s)hout [text]");
	}
	if(Maskara[playerid] == 1) {
		SetPlayerBubbleText(playerid, 20.0, COLOR_GREY1, "(Shouts) %s",params);
		format(string, sizeof(string), "Stranger(B%d): %s!", MaskaraID[playerid], params);
		SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	} else {
		SetPlayerBubbleText(playerid, 20.0, COLOR_GREY1, "(Shouts) %s",params);
		format(string, sizeof(string), "%s: %s!", GetRPName(playerid), params);
		SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	}
	return 1;
}

cmd:vc(playerid)
{
	return 1;
}
CMD:vcode(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(isnull(params) || strlen(params) > 64)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vcode [text ('none' to reset)]");
	}

	if(IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
		DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

		if(!strcmp(params, "none", true))
		{
			SendClientMessage(playerid, COLOR_WHITE, "** Car text removed from the vehicle.");
		}
	}

	if(strcmp(params, "none", true) != 0)
	{
		DonatorCallSign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_VIP, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
 		SendClientMessage(playerid, COLOR_WHITE, "** Car text attached. '/vcode none' to detach the Car text.");
	}

	return 1;
}

CMD:me(playerid, params[])
{ 
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /me [action]");
	}

	if(Maskara[playerid] == 1) {
		if(strlen(params) > MAX_SPLIT_LENGTH)
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Stranger(B%d) %.*s...", MaskaraID[playerid], MAX_SPLIT_LENGTH, params);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} ...%s", params[MAX_SPLIT_LENGTH]);
		}
		else
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Stranger(B%d) %s", MaskaraID[playerid], params);
		}
	} else {
		if(strlen(params) > MAX_SPLIT_LENGTH)
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, params);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} ...%s", params[MAX_SPLIT_LENGTH]);
		}
		else
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s %s", GetRPName(playerid), params);
		}
	}
	return 1;
}

CMD:surgery(playerid, params[])
{
	new targetid, cpr;

	if(!IsPlayerInSurgeryArea(playerid))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} You are not in range of Surgery Room.");
	}
	if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /surgery [playerid]");
	}
	if((gettime() - PlayerInfo[playerid][pLastAM]) < 30)
	{
		return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE"Someone's doing an operation.");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} The player specified is disconnected or out of range.");
    }
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} You can't use this command on yourself.");
	}
	if(!PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not injured.");
	}
	cpr = 50000 + random(1000);
	AddToPaycheck(playerid, cpr);
	SendClientMessage(targetid, COLOR_DOCTOR, "You have been paid $50k+ from the government added to your paycheck");
	PlayerInfo[playerid][pLastAM] = gettime();
	PlayerInfo[playerid][pTotalPatients]++;
	ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0);
	SetTimerEx("Surgery", 15000, false, "i", targetid);
	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s begins the surgery.", GetRPName(playerid));
	return 1;
}

CMD:mydiscord(playerid, params[])
{
	SM(playerid, COLOR_GREY, "Discord:  %s#%s", PlayerInfo[playerid][pDiscordName], PlayerInfo[playerid][pDiscordTag]);
}

CMD:ame(playerid, params[])
{
	new message[100], string[128];
	if(sscanf(params, "s[100]", message))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ame [action/off]");
 		SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
		SendClientMessage(playerid, COLOR_REALRED, "NOTE: Don't abuse it or get a punishment.");
		return 1;
	}
	if(strcmp(message, "off", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");

	    DestroyDynamic3DTextLabel(PlayerInfo[playerid][aMeID]);
	    PlayerInfo[playerid][aMeStatus] =0;
	    return 1;
	}
	if(strlen(message) > 64) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
	if(strlen(message) < 3) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");
	if(Maskara[playerid] == 1)
	{
		if(PlayerInfo[playerid][aMeStatus] == 0)
		{
		    PlayerInfo[playerid][aMeStatus] =1;

			format(string, sizeof(string), "**{C2A2DA} Stranger(B%d) %s", MaskaraID[playerid], message);
			PlayerInfo[playerid][aMeID] = CreateDynamic3DTextLabel(string, SERVER_COLOR, 0.0, 0.0, 0.0, 20.0, playerid);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);
			return 1;
		}
		else
		{
			format(string, sizeof(string), "**{C2A2DA} Stranger(B%d) %s", MaskaraID[playerid], message);
			UpdateDynamic3DTextLabelText(PlayerInfo[playerid][aMeID], SERVER_COLOR, string);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);
			return 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][aMeStatus] == 0)
		{
		    PlayerInfo[playerid][aMeStatus] = 1;

			format(string, sizeof(string), "**{C2A2DA} %s %s", GetRPName(playerid), message);
			PlayerInfo[playerid][aMeID] = CreateDynamic3DTextLabel(string, SERVER_COLOR, 0.0, 0.0, 0.0, 20.0, playerid);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);
			return 1;
		}
		else
		{
			format(string, sizeof(string), "**{C2A2DA} %s %s", GetRPName(playerid), message);
			UpdateDynamic3DTextLabelText(PlayerInfo[playerid][aMeID], SERVER_COLOR, string);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);
			return 1;
		}
	}
}

CMD:settings(playerid, params[])
{
	new string[9000];
	format(string, sizeof(string), "Name:\t%s\n\
	Discord: %s#%s\n\
 	Verification:\t%s\n\
    "WHITE"\n", GetRPName(playerid), PlayerInfo[playerid][pDiscordName], PlayerInfo[playerid][pDiscordTag], (PlayerInfo[playerid][pVerified] ? (""GREEN"Verified"WHITE"") : (""RED"Not Verified")));

	ShowPlayerDialog(playerid, DIALOG_VERIFICATION, DIALOG_STYLE_LIST, "Account Verification", string, "Select", "Cancel");
	return 1;
}

stock GetPlayerDiscord(playerid)
{
	new string128], DCC_User:user, playerName[MAX_PLAYER_NAME], playerID[64];
	if(PlayerInfo[playerid][pVerified])
	{
		DCC_GetUserName(user, playerName, sizeof(playerName));
		DCC_GetUserId(user, playerID, sizeof(playerID));
		format(string, sizeof(string), "%s#%i", playerName, playerID);
	}
	return string;
}

CMD:verified(playerid, params[])
{
	#pragma unused params

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	mysql_tquery(connectionID, "SELECT verified, username FROM users WHERE verified > 0 ORDER BY verified DESC LIMIT 20", "OnVerifiedListQuery", "i", playerid);
	return 1;
}

forward OnVerifiedListQuery(playerid);
public OnVerifiedListQuery(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		return 1;
	}

	new str[2048], cstring[96], Name[MAX_PLAYER_NAME];
	for(new i = 0; i < cache_num_rows(); ++i)
	{
		SQL_GetString(i, "username", Name);
		format(cstring, sizeof(cstring), "%s\t"GREEN"Verified"WHITE"\n", Name);
		strcat(str, cstring);
	}

	if(!str[0])
	{
		format(str, sizeof(str), "No verified accounts found.");
	}

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST, "Verified", str, "Confirm", "");
	return 1;
}

CMD:ado(playerid, params[])
{
	new message[100], string[180];
	if(sscanf(params, "s[100]", message))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ado [action/off]");
  		SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
		SendClientMessage(playerid, COLOR_REALRED, "NOTE: Don't abuse it or get a punishment.");
		return 1;
	}
	if(strcmp(message, "off", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");

	    DestroyDynamic3DTextLabel(PlayerInfo[playerid][aMeID]);
	    PlayerInfo[playerid][aMeStatus] =0;
	    return 1;
	}
	if(strlen(message) > 64) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
	if(strlen(message) < 3) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");

	if(Maskara[playerid] == 1)
	{
		if(PlayerInfo[playerid][aMeStatus] == 0)
		{
			PlayerInfo[playerid][aMeStatus] = 1;

			format(string, sizeof(string), "**{C2A2DA} %s (( Stranger(B%d) ))", message, MaskaraID[playerid]);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);

			PlayerInfo[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_LE, 0.0, 0.0, 0.0, 20.0, playerid);
			return 1;
		}
		else
		{
			format(string, sizeof(string), "**{C2A2DA} %s (( Stranger(B%d) ))", message, MaskaraID[playerid]);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);

			UpdateDynamic3DTextLabelText(PlayerInfo[playerid][aMeID], COLOR_LE, string);
			return 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][aMeStatus] == 0)
		{
			PlayerInfo[playerid][aMeStatus] = 1;

			format(string, sizeof(string), "**{C2A2DA} %s (( %s ))", message, GetRPName(playerid));
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);

			PlayerInfo[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_LE, 0.0, 0.0, 0.0, 20.0, playerid);
			return 1;
		}
		else
		{
			format(string, sizeof(string), "**{C2A2DA} %s (( %s ))", message, GetRPName(playerid));
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, string);

			UpdateDynamic3DTextLabelText(PlayerInfo[playerid][aMeID], COLOR_LE, string);
			return 1;
		}
	}
}

CMD:do(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /do [describe]");
	}
	if(Maskara[playerid] == 1) {
		if(strlen(params) > MAX_SPLIT_LENGTH)
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %.*s...", MAX_SPLIT_LENGTH, params);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} ...%s (( Stranger(B%d) ))", params[MAX_SPLIT_LENGTH], MaskaraID[playerid]);
		}
		else
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s (( Stranger(B%d) ))", params, MaskaraID[playerid]);
		}
	} else {
		if(strlen(params) > MAX_SPLIT_LENGTH)
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %.*s...", MAX_SPLIT_LENGTH, params);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} ...%s (( %s ))", params[MAX_SPLIT_LENGTH], GetRPName(playerid));
		}
		else
		{
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s (( %s ))", params, GetRPName(playerid));
		}
	}
	return 1;
}


forward Joint(playerid);
public Joint(playerid)
{
	PlayerInfo[playerid][pJoint] += 1;

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

	SetTimerEx("HideGiveitems", 4000, false, "i", playerid);

	ClearAnimations(playerid, SYNC_ALL);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA}  +1 joint package.");
    return 1;
}

forward Flower(playerid);
public Flower(playerid)
{
	PlayerInfo[playerid][pFlower] += 1;

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

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET flower = %i WHERE uid = %i", PlayerInfo[playerid][pFlower], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA}  +1 Flower.");
    return 1;
}
forward Cocaine(playerid);
public Cocaine(playerid)
{
	PlayerInfo[playerid][pDryFlower] -= 2;
	PlayerInfo[playerid][pCrack] += 1;

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

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dryflower = %i WHERE uid = %i", PlayerInfo[playerid][pDryFlower], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA}  +1 Cocaine.");
    return 1;
}
CMD:getflower(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1561.992919, 1667.608237, 700.968017))	return 1;
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
    if(PlayerInfo[playerid][pFlower] + 1 > 10)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 10 flowers.");
    }

    PlayerInfo[playerid][pLastSell] = gettime();
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
    SM(playerid, COLOR_YELLOW, "You Are now Grinding Flowers.");
    SetPlayerAttachedObject(playerid, 1, 2249, 5, 0.068999, 0.007000, -0.046000, 65.699996, -81.899963, 0.000000, 1.000000, 1.000000, 1.000000);
    SetTimerEx("Flower", 15000, false, "i", playerid);

	return 1;
}

forward DryFlower(playerid);
public DryFlower(playerid)
{
	PlayerInfo[playerid][pDryFlower] += 1;
	PlayerInfo[playerid][pFlower] -= 1;

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

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dryflower = %i WHERE uid = %i", PlayerInfo[playerid][pDryFlower], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET flower = %i WHERE uid = %i", PlayerInfo[playerid][pFlower], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA}  +1 Dry Flower.");
    return 1;
}
CMD:dryflower(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1555.256591, 1709.114624, 700.968017))	return 1;
	if(PlayerInfo[playerid][pFlower] < 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need  Flower.");
	}
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
    if(PlayerInfo[playerid][pDryFlower] + 1 > 10)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 10 flowers.");
    }

	PlayerInfo[playerid][pLastSell] = gettime();
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
	SM(playerid, COLOR_YELLOW, "You Are now Grinding Dry Flowers.");
    SetPlayerAttachedObject(playerid, 1, 2249, 5, 0.068999, 0.007000, -0.046000, 65.699996, -81.899963, 0.000000, 1.000000, 1.000000, 1.000000);
    SetTimerEx("DryFlower", 15000, false, "i", playerid);

	return 1;
}

CMD:getcocaine(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1542.924194, 1667.241088, 700.968017))	return 1;
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
    if(PlayerInfo[playerid][pDryFlower] < 2)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least two grams of Dry Flower.");
	}

	PlayerInfo[playerid][pLastSell] = gettime();
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);

	SM(playerid, COLOR_YELLOW, "You Are now Grinding Cocaine.");
    SetPlayerAttachedObject(playerid, 1, 1575, 5, 0.068999, 0.007000, -0.046000, 65.699996, -81.899963, 0.000000, 1.000000, 1.000000, 1.000000);
    SetTimerEx("Cocaine", 15000, false, "i", playerid);

	return 1;
}

CMD:checkrob(playerid, params[])
{
	if(!gRobbery)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "ENGLISH:"RED" THERE IS NO ACTIVE ROBBERY.");
	    SendClientMessage(playerid, COLOR_YELLOW, "TAGALOG:"RED" WALA PANG NAG RO-ROB NG BIZ/HOUSE.");
	    SendClientMessage(playerid, COLOR_YELLOW, "BISAYA:"RED" WALA PAY NANGAWAT KARON.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "ENGLISH:"GREEN" THERE IS AN ACTIVE CURRENT");
	    SendClientMessage(playerid, COLOR_YELLOW, "TAGALOG:"GREEN" MERONG NAG ROROBBERY NG BIZ/HOUSE NGAYON.");
	    SendClientMessage(playerid, COLOR_YELLOW, "BISAYA:"GREEN" NAA NAY NANGWAT KARON.");
	}
	return 1;
}

CMD:check(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /check [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	ShowStatsDialog(playerid, targetid);
	return 1;
}

CMD:l(playerid, params[])
{
	return callcmd::low(playerid, params);
}
CMD:sendemail(playerid, params[])
{
	//new name1[] = "John Doe";
    //new to[] = "kcnajwan7@gmail.com";
    //new subject[] = "Test Email";
    //new text[] = "<html><head><style>#code {width: 58px; border: 4px solid black; padding: 2px; font-size: 24px; font-weight: bold; margin-top: 15px; margin-bottom: 15px; margin-left: 10px; align-items: center; color: #000;}</style></head><body><img src='https://i.gyazo.com/cf4f68f94b939c99ccfd0d9f8f51976c.png' height='100' width='300'><br><br> Welcome to our server <b>%s</b>! Please confirm your email by entering the code below in the server. If you don't confirm the email, you will not be able to play in the server.<br><br><b>Confirmation code:</b><div id='code'>12312 <!-- Placeholder for the verification code --></div>Thank you, <i>the SAMPMailJS STAFF</i>.</body></html>";
    //new text2[2024];
    //format(text2, sizeof(text2), text , GetRPName(playerid));
    //SendEmail(name1, to, subject, text2);
	return 1;
}
CMD:low(playerid, params[])
{
	new
	    string[144];


	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(l)ow [text]");
	}
	if(Maskara[playerid] == 1) {
		format(string, sizeof(string), "Stranger(B%d): %s", MaskaraID[playerid], params);
		SendProximityFadeMessage(playerid, 5.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	} else {
		format(string, sizeof(string), "%s: %s", GetRPName(playerid), params);
		SendProximityFadeMessage(playerid, 5.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
	}
	SetPlayerBubbleText(playerid, 5.0, COLOR_GREY1, "(Quietly) %s", params);
	return 1;
}
CMD:revive(playerid, params[]) return callcmd::rev(playerid, params);
CMD:dv(playerid, params[]) return callcmd::destroyveh(playerid, params);
CMD:w(playerid, params[]) return callcmd::whisper(playerid, params);
CMD:whisper(playerid, params[])
{
	new targetid, text[128];


	if(sscanf(params, "us[128]", targetid, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(w)hisper [playerid] [text]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pToggleWhisper] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has blocked all incoming whispers.");
	}
	if(PlayerInfo[playerid][pToggleWhisper] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Whisper chat is currently disabled. /tog whisper to re-enable.");
	}
	if(!IsPlayerInRangeOfPlayer(playerid, targetid, 5.0) && (!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be near that player to whisper them.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't whisper to yourself.");
	}

    foreach(new i : Player)
    {
	    if(PlayerInfo[i][pPMListen])
		{
  			SM(i, COLOR_YELLOW, "[L] %s whisper to %s: %s", GetRPName(playerid), GetRPName(targetid), text);
        }
	}
	SM(targetid, COLOR_YELLOW, "** Whisper from %s: %s **", GetRPName(playerid), text);
	SM(playerid, COLOR_YELLOW, "** Whisper to %s: %s **", GetRPName(targetid), text);

	SetPlayerBubbleText(playerid, 5.0, COLOR_YELLOW, "(Whispering)");

	if(PlayerInfo[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
	{
	    SendClientMessage(targetid, COLOR_WHITE, "** You can use '/rw [message]' to reply to this whisper.");
	}

	new dc_str[454];
	format(dc_str, sizeof(dc_str), "%s is whispering %s: %s", GetRPName(playerid), GetRPName(targetid), text);
	SendDiscordMessage(11, dc_str);

	PlayerInfo[targetid][pWhisperFrom] = playerid;
	return 1;
}

CMD:apm(playerid, params[])
{
	new targetid, text[128];

	if(sscanf(params, "us[128]", targetid, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pm [playerid] [message]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pTogglePM] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has blocked all incoming private messages.");
	}
	if(PlayerInfo[playerid][pTogglePM] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "PM chat is currently disabled. /tog pm to re-enable.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't PM yourself.");
	}

    foreach(new i : Player)
    {
	    if(PlayerInfo[i][pPMListen])
		{
  			SM(i, COLOR_YELLOW, "(L) %s PM to %s: %s", GetRPName(playerid), GetRPName(targetid), text);
        }
	}

	SM(targetid, COLOR_YELLOW, "(( PM from %s: %s ))", GetRPName(playerid), text);
	SM(playerid, COLOR_YELLOW, "(( PM to %s: %s ))", GetRPName(targetid), text);

	if(PlayerInfo[targetid][pPMFrom] == INVALID_PLAYER_ID)
	{
	    SendClientMessage(targetid, COLOR_WHITE, "** You can use '/re [message]' to reply to this PM.");
	}

	PlayerInfo[targetid][pPMFrom] = playerid;
	return 1;
}

CMD:re(playerid, params[])
{

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /re [text]");
	}
	if(PlayerInfo[playerid][pPMFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent been messaged by anyone since you joined the server.");
	}
	if(PlayerInfo[PlayerInfo[playerid][pPMFrom]][pTogglePM] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player has blocked all incoming private messages.");
	}
	if(PlayerInfo[playerid][pTogglePM] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "PM chat is currently disabled. /tog pm to re-enable.");
	}

	PlayerInfo[PlayerInfo[playerid][pPMFrom]][pPMFrom] = playerid;
	SM(PlayerInfo[playerid][pPMFrom], COLOR_YELLOW, "(( PM from %s: %s ))", GetRPName(playerid), params);
	SM(playerid, COLOR_YELLOW, "(( PM to %s: %s ))", GetRPName(PlayerInfo[playerid][pPMFrom]), params);
    new akrplog[124];
	format(akrplog, sizeof(akrplog), "(L) %s PM to %s: %s", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pPMFrom]), params);
    SendDiscordMessage(19, akrplog);


    foreach(new i : Player)
    {
	    if(PlayerInfo[i][pPMListen])
		{
  			SM(i, COLOR_YELLOW, "(L) %s PM to %s: %s", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pPMFrom]), params);
        }
	}
	return 1;
}

CMD:rw(playerid, params[])
{

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rw [text]");
	}
	if(PlayerInfo[playerid][pWhisperFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent been whispered by anyone since you joined the server.");
	}
	if(!IsPlayerInRangeOfPlayer(playerid, PlayerInfo[playerid][pWhisperFrom], 5.0) && (!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be near that player to whisper them.");
	}
	PlayerInfo[PlayerInfo[playerid][pWhisperFrom]][pWhisperFrom] = playerid;
	SM(PlayerInfo[playerid][pWhisperFrom], COLOR_YELLOW, "** Whisper from %s: %s **", GetRPName(playerid), params);
	SM(playerid, COLOR_YELLOW, "** Whisper to %s: %s **", GetRPName(PlayerInfo[playerid][pWhisperFrom]), params);

    foreach(new i : Player)
    {
	    if(PlayerInfo[i][pPMListen])
		{
			SM(i, COLOR_YELLOW, "(L) %s whispers to %s: %s", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pWhisperFrom]), params);
        }
	} // GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
	return 1;
}

CMD:skema(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Bulalakars (/skema)", GetRPName(playerid));
	return 1;
}

CMD:xgun(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Weapon Hack (/xgun)", GetRPName(playerid));
	return 1;
}

CMD:slp(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Slap Hack (/slp)", GetRPName(playerid));
	return 1;
}

CMD:fcrash(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Crasher (/fcrash)", GetRPName(playerid));
	return 1;
}

CMD:menu(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Chenh4x Menu (/menu)", GetRPName(playerid));
	return 1;
}

CMD:xcrash(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Crasher (/xcrash)", GetRPName(playerid));
	return 1;
}

CMD:salo(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Aimbot (/salo)", GetRPName(playerid));
	return 1;
}

CMD:ccar(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Invi vehicle (/ccar)", GetRPName(playerid));
	return 1;
}

CMD:kenzo(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Hacks (/kenzo)", GetRPName(playerid));
	return 1;
}

CMD:fspawn(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Fake Spawn (/fspawn)", GetRPName(playerid));
	return 1;
}

CMD:tr(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Troll H4x | Slapper (/tr)", GetRPName(playerid));
	return 1;
}

CMD:takecar(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: H4x | Car Taker (/takecar)", GetRPName(playerid));
	return 1;
}

CMD:follow(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: H4x | Follow Player (/follow)", GetRPName(playerid));
	return 1;
}

CMD:lagtroll(playerid, params[])
{
	KickPlayer(playerid);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by AK:RP BOT, reason: Troll H4x | Lag Troll (/lagtroll)", GetRPName(playerid));
	return 1;
}

CMD:mykits(playerid, params[])
{
 
	SM(playerid, COLOR_GREEN, "%s's Kits", GetRPName(playerid));
	SM(playerid, COLOR_BLUE, "Repair Kits: %i - Used to repair vehicles.", PlayerInfo[playerid][pRepairKit]);
	SM(playerid, COLOR_YELLOW, "Tool Kit: %i - Used to /hotwire an off engine vehicle.", PlayerInfo[playerid][pToolkit]);
	return 1;
}

CMD:userepairkit(playerid, const params[])
{

	new Float:health;
	new vehicleid = GetPlayerVehicleID(playerid);
	new count;

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
	if(PlayerInfo[playerid][pRepairKit] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must have a repair kit to use this command. [Buy Repair Kit in any 7/11 or Supermarket around the city]");
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
		PlayerInfo[playerid][pRepairKit]--;
		TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid,"~w~Fixing the vehicle..",10000,6);
		//PlayerTextDrawShow(playerid, PROGRESS1[playerid][0]);
        //PlayerText_MoveTextSize(playerid, PROGRESS1[playerid][1] ,116.69, 10000, EASE_IN_SINE);
        //PlayerText_InterpolateColor(playerid, PROGRESS1[playerid][1], 16744447, 10000, EASE_IN_SINE);
		SetTimerEx("TimerSelfRepair", 10000, false, "i", playerid);
		SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s is repairing his/her vehicle.", GetRPName(playerid));
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

	}
	return 1;
}

forward Surgery(playerid, targetid);
public Surgery(playerid, targetid)
{
	PlayerInfo[playerid][pInjured] = 0;
	SetPlayerHealth(playerid, 100.0);
	ClearAnimations(playerid, SYNC_ALL);
	GivePlayerCash(playerid, -20000);
	GameTextForPlayer(playerid, "~w~Discharged~n~~g~-$5000", 5000, 1);
	SendClientMessage(playerid, COLOR_DOCTOR, "You have been revived by an Doctor/medic!");
	return 1;
}

