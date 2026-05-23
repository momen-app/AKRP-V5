CMD:event(playerid, params[])
{
	new option[10], param[128];

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "s[10]S()[128]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Position, JoinText, Type, Health, Armor, Weapon, Skin, Rules");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Ready, Start, Lock, Countdown, Balance, End");
		return 1;
	}
	if(!strcmp(option, "position", true))
	{
	    if(EventInfo[eType] == 2)
	    {
	        if(isnull(param))
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [position] [red/blue]");
			}
	        else if(!strcmp(param, "red", true))
	        {
	            GetPlayerPos(playerid, EventInfo[ePosX][RED_TEAM], EventInfo[ePosY][RED_TEAM], EventInfo[ePosZ][RED_TEAM]);
				GetPlayerFacingAngle(playerid, EventInfo[ePosA][RED_TEAM]);
				EventInfo[eInterior] = GetPlayerInterior(playerid);
				EventInfo[eWorld] = GetPlayerVirtualWorld(playerid);
				SendClientMessage(playerid, COLOR_AQUA, "You have set the spawn point for {FF0000}Red{CCFFFF} team.");
	        }
	        else if(!strcmp(param, "blue", true))
	        {
	            GetPlayerPos(playerid, EventInfo[ePosX][BLUE_TEAM], EventInfo[ePosY][BLUE_TEAM], EventInfo[ePosZ][BLUE_TEAM]);
				GetPlayerFacingAngle(playerid, EventInfo[ePosA][BLUE_TEAM]);
				EventInfo[eInterior] = GetPlayerInterior(playerid);
				EventInfo[eWorld] = GetPlayerVirtualWorld(playerid);
				SendClientMessage(playerid, COLOR_AQUA, "You have set the spawn point for {0000FF}Blue{CCFFFF} team.");
    		}
		}
		else
		{
			GetPlayerPos(playerid, EventInfo[ePosX][0], EventInfo[ePosY][0], EventInfo[ePosZ][0]);
			GetPlayerFacingAngle(playerid, EventInfo[ePosA][0]);
			EventInfo[eInterior] = GetPlayerInterior(playerid);
			EventInfo[eWorld] = GetPlayerVirtualWorld(playerid);
			SendClientMessage(playerid, COLOR_AQUA, "You have set the event spawn point.");
	    }
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [type] [1=DM 2=TDM 3=Race 4=Other]");
	    }
	    if(!(1 <= type <= 4))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	    }

		EventInfo[eType] = type;

	    switch(type)
	    {
	        case 1:
	        {
	            SendClientMessage(playerid, COLOR_AQUA, "You have set the event type to "SVRCLR"Deathmatch{CCFFFF}.");
	        }
	        case 2:
	        {
	            SendClientMessage(playerid, COLOR_AQUA, "You have set the event type to "SVRCLR"Team Deathmatch{CCFFFF}.");
	            EventInfo[eNext] = RED_TEAM;

	            if(EventInfo[ePosX][RED_TEAM] == 0.0 && EventInfo[ePosY][RED_TEAM] == 0.0 && EventInfo[ePosZ][RED_TEAM] == 0.0)
	                SendClientMessage(playerid, COLOR_LIGHTRED, "** Red Team position not set. '/event position red' to set position.");

                if(EventInfo[ePosX][BLUE_TEAM] == 0.0 && EventInfo[ePosY][BLUE_TEAM] == 0.0 && EventInfo[ePosZ][BLUE_TEAM] == 0.0)
	                SendClientMessage(playerid, COLOR_LIGHTRED, "** Blue Team position not set. '/event position blue' to set position.");
	        }
            case 3:
	        {
	            SendClientMessage(playerid, COLOR_AQUA, "You have set the event type to "SVRCLR"Race{CCFFFF}. /veh to spawn the vehicles.");
	        }
	        case 4:
	        {
	            SendClientMessage(playerid, COLOR_AQUA, "You have set the event type to "SVRCLR"Other{CCFFFF}.");
	        }
		}
	}
	else if(!strcmp(option, "health", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [health] [amount]");
		}

	    EventInfo[eHealth] = amount;
	    SM(playerid, COLOR_AQUA, "You set the event health to %.1f.", amount);
	}
	else if(!strcmp(option, "armor", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [armor] [amount]");
		}

	    EventInfo[eArmor] = amount;
	    SM(playerid, COLOR_AQUA, "You set the event armor to %.1f.", amount);
	}
	else if(!strcmp(option, "jointext", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [jointext] [text]");
		}

		strcpy(EventInfo[eJoinText], param, 128);
		SM(playerid, COLOR_AQUA, "You set the join text to '%s'.", param);
	}
	else if(!strcmp(option, "weapon", true))
	{
	    new slot, weaponid;

	    if(sscanf(param, "ii", slot, weaponid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [weapon] [slot (1-5)] [weaponid]");
	    }
	    if(!(1 <= slot <= 5))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
	    }
	    if(!(2 <= weaponid <= 46))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid weapon.");
	    }

	    EventInfo[eWeapons][slot-1] = weaponid;
	    SM(playerid, COLOR_AQUA, "You set the weapon in slot %i to %s.", slot, GetWeaponNameEx(weaponid));
	}
	else if(!strcmp(option, "skin", true))
	{
	    new team[6], skinid;

	    if(EventInfo[eType] == 2)
	    {
	        if(sscanf(param, "s[6]i", team, skinid))
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [skin] [red/blue] [skinid]");
			}
			if(!(0 <= skinid <= 311))
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin ID.");
			}
			if(!strcmp(team, "red", true))
			{
	            EventInfo[eSkin][RED_TEAM] = skinid;
	            SM(playerid, COLOR_AQUA, "You set the skin for {FF0000}Red{CCFFFF} team to %i.", skinid);
	        }
	        else if(!strcmp(team, "blue", true))
			{
	            EventInfo[eSkin][BLUE_TEAM] = skinid;
	            SM(playerid, COLOR_AQUA, "You set the skin for {0000FF}Blue{CCFFFF} team to %i.", skinid);
	        }
		}
		else
		{
		    if(sscanf(param, "i", skinid))
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [skin] [skinid (0 = reset)]");
			}
			if(!(0 <= skinid <= 311))
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin ID.");
			}

			EventInfo[eSkin][0] = skinid;
   			SM(playerid, COLOR_AQUA, "You set the event skin to %i.", skinid);
		}
	}
	else if(!strcmp(option, "rules", true))
	{
	    new rule[8], toggle;

	    if(sscanf(param, "s[8]i", rule, toggle) || !(0 <= toggle <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [rules] [cs/qs/healing] [0/1]");
		}
		if(EventInfo[eType] != 1 && EventInfo[eType] != 2)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can only set rules for DM & TDM events.");
		}

		if(!strcmp(rule, "cs", true))
		{
		    EventInfo[eCS] = toggle;

		    if(toggle)
		        SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"allowed{CCFFFF} crackshooting in the event.");
	        else
	            SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"disallowed{CCFFFF} crackshooting in the event.");
		}
		else if(!strcmp(rule, "qs", true))
		{
		    EventInfo[eQS] = toggle;

		    if(toggle)
		        SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"allowed{CCFFFF} quickswapping in the event.");
	        else
	            SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"disallowed{CCFFFF} quickswapping in the event.");
		}
		else if(!strcmp(rule, "healing", true))
		{
		    EventInfo[eHeal] = toggle;

		    if(toggle)
		        SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"allowed{CCFFFF} healing in the event.");
	        else
	            SendClientMessage(playerid, COLOR_AQUA, "You have "SVRCLR"disallowed{CCFFFF} healing in the event.");
		}
	}
	else if(!strcmp(option, "ready", true))
	{
		if(isnull(param) || strcmp(param, "confirm", true) != 0)
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /event [ready] [confirm]");
		    SendClientMessage(playerid, COLOR_WHITE, "This command will announce to the whole server that an event is ready to join.");
			return 1;
	    }
	    if(EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The event is already marked as ready.");
	    }

		if(EventInfo[eType] == 2)
		{
		    if(EventInfo[ePosX][RED_TEAM] == 0.0 && EventInfo[ePosY][RED_TEAM] == 0.0 && EventInfo[ePosZ][RED_TEAM] == 0.0)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no spawn point set for red team.");
		    }
		    if(EventInfo[ePosX][BLUE_TEAM] == 0.0 && EventInfo[ePosY][BLUE_TEAM] == 0.0 && EventInfo[ePosZ][BLUE_TEAM] == 0.0)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no spawn point set for blue team.");
		    }
		    if(!EventInfo[eSkin][RED_TEAM])
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no skin set for red team.");
		    }
		    if(!EventInfo[eSkin][BLUE_TEAM])
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no skin set for blue team.");
		    }
		}
		else
		{
		    if(!EventInfo[eType])
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "The event type has not been set.");
		    }
  			if(EventInfo[ePosX][0] == 0.0 && EventInfo[ePosY][0] == 0.0 && EventInfo[ePosZ][0] == 0.0)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "The spawn point has not been set.");
		    }
	    }

	    EventInfo[eReady] = 1;

	    switch(EventInfo[eType])
	    {
	    	case 1: SMA(COLOR_AQUA, "%s has started a Deathmatch event, use /joinevent to join!", GetRPName(playerid));
	    	case 2: SMA(COLOR_AQUA, "%s has started a Team-Deathmatch event, use /joinevent to join!", GetRPName(playerid));
	    	case 3: SMA(COLOR_AQUA, "%s has started a Race event, use /joinevent to join!", GetRPName(playerid));
	    	case 4: SMA(COLOR_AQUA, "%s has started an event, use /joinevent to join!", GetRPName(playerid));
	    }

	    SendClientMessage(playerid, COLOR_WHITE, "** Use '/event lock' to lock the event and '/event start' to start.");
	}
	else if(!strcmp(option, "lock", true))
	{
        if(!EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no event ready. Please set one up first.");
	    }

		if(!EventInfo[eLocked])
		{
		    EventInfo[eLocked] = 1;
		    SMA(COLOR_AQUA, "The event has been locked by %s.", GetRPName(playerid));
	    }
	    else
	    {
		    EventInfo[eLocked] = 0;
		    SMA(COLOR_AQUA, "The event was unlocked by %s.", GetRPName(playerid));
	    }
	}
	else if(!strcmp(option, "start", true))
	{
	    if(!EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no event ready. Please set one up first.");
	    }
	    if(EventInfo[eStarted])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The event has already started.");
	    }

	    foreach(new i : Player)
		{
	        if(PlayerInfo[i][pJoinedEvent])
	        {
				SendClientMessage(i, COLOR_AQUA, "The event has started. Good luck!");
    			for(new x = 0; x < 5; x ++)
    			{
        			if(EventInfo[eWeapons][x])
        			{
            			GiveWeapon(i, EventInfo[eWeapons][x], true); // Fixed
					}   // by Jeck
        		}
			}
			else
			{
			    SendClientMessage(i, COLOR_AQUA, "The event has started. Better luck next time!");
			}
		}

		EventInfo[eStarted] = 1;
	}
	else if(!strcmp(option, "countdown", true))
	{
	    if(!EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no event ready. Please set one up first.");
	    }

	    SetTimerEx("Countdown", 1000, false, "ii", playerid, 3);
	    SendClientMessage(playerid, COLOR_AQUA, "You have initiated a countdown for all players in the event.");
	}
	else if(!strcmp(option, "balance", true))
	{
	    new teamid = RED_TEAM;

	    if(!EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no event ready. Please set one up first.");
	    }
	    if(EventInfo[eType] != 2)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "The event currently active is not a TDM event.");
		}

		foreach(new i : Player)
		{
		    if(PlayerInfo[i][pJoinedEvent])
		    {
				PlayerInfo[i][pEventTeam] = teamid;

				SetPlayerSkin(i, EventInfo[eSkin][teamid]);
				SetPlayerPos(i, EventInfo[ePosX][teamid], EventInfo[ePosY][teamid], EventInfo[ePosZ][teamid]);
				SetPlayerFacingAngle(i, EventInfo[ePosA][teamid]);

				teamid = teamid == RED_TEAM ? BLUE_TEAM : RED_TEAM;

				if(PlayerInfo[i][pEventTeam] == RED_TEAM) {
				    GameTextForPlayer(i, "~w~You are on~n~~r~Red Team", 3000, 4);
				} else if(PlayerInfo[i][pEventTeam] == BLUE_TEAM) {
				    GameTextForPlayer(i, "~w~You are on~n~~b~Blue Team", 3000, 6);
				}

				SM(i, COLOR_AQUA, "%s has balanced the teams. You are now in %s{CCFFFF} team.", GetRPName(playerid), (PlayerInfo[i][pEventTeam] == RED_TEAM) ? ("{FF0000}Red") : ("{0000FF}Blue"));
		    }
		}

		SendClientMessage(playerid, COLOR_AQUA, "You have balanced the event teams.");
	}
	else if(!strcmp(option, "end", true))
	{
	    if(!EventInfo[eReady])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "There is no event ready. Please set one up first.");
	    }

	    ResetEvent();
	    SMA(COLOR_AQUA, "The event was ended by %s.", GetRPName(playerid));
	}

	return 1;
}
CMD:mrepair(playerid, params[]) //PASTE IT UNDER "CMD:revive(playerid, params[])"
{
    new Float:x, Float:y, Float:z, Float:a;
    new vehicleid = GetPlayerVehicleID(playerid);
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    new count;

    foreach(new i : Player)
    {
        if(IsMechanic(i) && PlayerInfo[i][pDuty] == 1)
        {
            count++;
        }
    }
    if(PlayerInfo[playerid][pRepairing] == 1)
    {
      return SendClientMessage(playerid, COLOR_GREY2, "Already repairing");
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
    if(PlayerInfo[playerid][pCash]<5000)
    {
        return SendClientMessage(playerid, COLOR_GREY,"You don't have enough money to call Mechanic.");
    }
    
    GameTextForPlayer(playerid, "~p~Repairing...", 30000, 5);
    SetTimerEx("BotRepair", 30000, false, "i", playerid);
    SetVehicleHealth(vehicleid, 1000.0);
    PlayerInfo[playerid][pRepairing] = 1;
    //PlayerTextDrawShow(playerid, PROGRESS1[playerid][0]);
    //PlayerText_MoveTextSize(playerid, PROGRESS1[playerid][1] ,116.69, 10000, EASE_IN_SINE);
    //PlayerText_InterpolateColor(playerid, PROGRESS1[playerid][1], 16744447, 10000, EASE_IN_SINE);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Mech Bot use Repair Kit And Fixing %s Vehicle.", GetRPName(playerid));
    SAM(COLOR_YELLOW, "AdmWarning:%s (%i) Using Bot Repair", GetRPName(playerid), playerid);

    return 1;
}

CMD:oban(playerid, params[])
{
	new username[MAX_PLAYER_NAME + 1], reason[128];

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]s[128]", username, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /oban [username] [reason]");
	}
    if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. Use /ban instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, ip, uid FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineBan", "iss", playerid, username, reason);
	return 1;
}

forward BotRevive(playerid);
public BotRevive(playerid)
{
	if(IsValidActor(PlayerInfo[playerid][pMedicActor]))
		DestroyActor(PlayerInfo[playerid][pMedicActor]);

	PlayerInfo[playerid][pInjured] = 0;
	PlayerInfo[playerid][pHunger] = 100;
	PlayerInfo[playerid][pHungerTimer] = 0;
    PlayerInfo[playerid][pThirst] = 100;
	PlayerInfo[playerid][pThirstTimer] = 0;
	PlayerInfo[playerid][pReving] = 0;
    PlayerInfo[playerid][pGased] = false;
    PlayerInfo[playerid][pGased1] = false;

	SetCameraBehindPlayer(playerid);

    TogglePlayerControllable(playerid, true);
	SetPlayerHealth(playerid, 50.0);
	GivePlayerCash(playerid, -5000);
	ClearAnimations(playerid, SYNC_ALL);
	

	SetFreezePos(playerid, 1800.020874, -1713.662841, 14.112992);

	SendClientMessage(playerid, COLOR_YELLOW, "You have been revived by an Doctor");
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Medic successfully healed %s wound.", GetRPName(playerid));
    
    
    return 1;
}
CMD:mrevive(playerid)
{
    new count, id;

    if(!PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not injured");
	}
	if(PlayerInfo[playerid][pGased1])
	{
	   return SM(playerid, COLOR_SYNTAX, "You Cant Revive AnyBody Gasoiled You");
	}
	if(PlayerInfo[playerid][pRevCooldown] > 0)
	{
 	    return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds before you can Bot Revive.", PlayerInfo[playerid][pRevCooldown]);
	}
	if(PlayerInfo[playerid][pReving] > 0)
	{
 	    return SM(playerid, COLOR_SYNTAX, "Already reviving");
	}
    if((id = GetNearbyTurf(playerid)) >= 0 && TurfInfo[id][tCapturer] != INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_GREY2, " You are in Turf You can't call EMS");
	}
	foreach(new i : Player)
	{
	    if(IsMedic(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}
	if(count > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There are Ems online /call 911");
	}
    if(PlayerInfo[playerid][pCash]<5000)
	{
		return SendClientMessage(playerid, COLOR_GREY,"You don't have enough money to call EMS doctor.");
	}
		
    PlayerInfo[playerid][pMedicActor] = CreateActor(308, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ],PlayerInfo[playerid][pPosA]);
    GameTextForPlayer(playerid, "~p~Healing...", 10000, 5);
	ApplyActorAnimation(PlayerInfo[playerid][pMedicActor], "MEDIC", "CPR", 4.0, true, true, true, false, false);
	KillTimer(killtimerz[playerid]);
	SetActorHealth(PlayerInfo[playerid][pMedicActor], 0.0);
	PlayerInfo[playerid][pReving] = 1;
	SetActorInvulnerable(PlayerInfo[playerid][pMedicActor], true);
	SetActorVirtualWorld(PlayerInfo[playerid][pMedicActor], GetPlayerVirtualWorld(playerid));
	SetTimerEx("BotRevive", 10000, false, "i", playerid);
	for(new i = 0; i < 15; i++)
    {
        TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
    }
   	for(new td = 0; td < 4; td ++)
	{
		PlayerTextDrawHide(playerid, DEATH[playerid][td]);
	}
	PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Medic uses alcohol, cotton and bandage to cure %s wound.", GetRPName(playerid));
	SAM(COLOR_YELLOW, "AdmWarning: %s (%i) Using Bot Revive", GetRPName(playerid), playerid);

	return 1;
}
CMD:joinevent(playerid, params[])
{
	if(PlayerInfo[playerid][pJailType])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are in jail and therefore cannot participate in an event.");
	}
	if(PlayerInfo[playerid][pJoinedEvent])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You already joined the event. /quitevent to leave.");
	}
	if(!EventInfo[eReady])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There are no events you can join at the moment.");
	}
	if(EventInfo[eLocked])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The event is locked. Better luck next time!");
	}
	if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't join the event while you are playing paintball.");
	}
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pAcceptedHelp] || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't join the event at the moment.");
	}
    if((PlayerInfo[playerid][pWeaponRestricted] > 0) && (1 <= EventInfo[eType] <= 2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are restricted from weapons and therefore can't join this type of event.");
    }

	SetPlayerInEvent(playerid);
	return 1;
}

CMD:quitevent(playerid, params[])
{
    if(!PlayerInfo[playerid][pJoinedEvent])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in an event which you can quit.");
	}

 	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pJoinedEvent])
	    {
	        SM(i, COLOR_LIGHTORANGE, "(( %s has left the event. ))", GetPlayerNameEx(playerid));
		}
	}

	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pJoinedEvent] = 0;
	SetPlayerToSpawn(playerid);
	return 1;
}

CMD:permaban(playerid, params[])
{
	new targetid, reason[128];

 	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /permaban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(PlayerInfo[targetid][pAdmin] == 8)
	{
 		SAM(COLOR_YELLOW, "Warning: %s has been autokicked for trying to ban a Server Manager(%s).", GetRPName(playerid), GetRPName(targetid));
 		KickPlayer(playerid);
 		return 1;
	}

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was permanently banned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	BanPlayer(targetid, GetPlayerNameEx(playerid), reason, true);
	return 1;
}
CMD:gpark(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

	if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
	}
	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any of your gang vehicles.");
	}
	if(VehicleInfo[vehicleid][vGang] != PlayerInfo[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't park this vehicle as it doesn't belong to your gang.");
	}

	// Save the vehicle's information.
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

	SendClientMessage(playerid, COLOR_AQUA, "** Gang vehicle parked. It will now spawn here.");

	// Update the database record with the new information, then despawn the vehicle.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET health = 1500, pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SaveVehicleModifications(vehicleid);
 	DespawnVehicle(vehicleid, false);

	// Finally, we reload the vehicle from the database.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);

	return 1;
}
CMD:grc(playerid, params[])
{
	return callcmd::grespawncars(playerid, params);
}
CMD:grespawncars(playerid, params[])
{
    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
	}

    for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerInfo[playerid][pGang] && !IsVehicleOccupied(i))
	    {
	        SetVehicleToRespawn(i);
		}
	}

	SAM(COLOR_YELLOW, "AdmWarning: %s[%i] has respawned their gang vehicles.", GetRPName(playerid), playerid);
	SendClientMessage(playerid, COLOR_YELLOW, "You have respawned all of your unoccupied gang vehicles.");
	return 1;
}

CMD:baninfo(playerid, params[])
{
	new string[MAX_PLAYER_NAME];

	if(PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pBanAppealer])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", string))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /baninfo [username/ip]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM bans WHERE username = '%e' OR ip = '%e'", string, string);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckBan", "is", playerid, string);
	return 1;
}

CMD:banhistory(playerid, params[])
{
	new name[MAX_PLAYER_NAME];

	if(PlayerInfo[playerid][pAdmin] < 12 && !PlayerInfo[playerid][pBanAppealer])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /banhistory [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT a.date, a.description FROM log_bans a, users b WHERE a.uid = b.uid AND b.username = '%e' ORDER BY a.date DESC", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckBanHistory", "is", playerid, name);

	return 1;
}

CMD:unban(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerInfo[playerid][pAdmin] < 12 && !PlayerInfo[playerid][pBanAppealer])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unban [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, permanent FROM bans WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminUnbanUser", "is", playerid, username);
	return 1;
}

CMD:unbanip(playerid, params[])
{
	new string[25];

    if(PlayerInfo[playerid][pAdmin] < 12 && !PlayerInfo[playerid][pBanAppealer])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!IsAnIP(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unbanip [ip address]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM bans WHERE ip = '%e'", params);
	mysql_tquery(connectionID, queryBuffer);

	format(string, sizeof(string), "unbanip %s", params);
	SendRconCommand(string);
	SendRconCommand("reloadbans");

	UnBlockIpAddress(params);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has unbanned IP '%s'.", GetRPName(playerid), params);
	return 1;
}


CMD:banip(playerid, params[])
{
	new ip[16], reason[128];

    if(PlayerInfo[playerid][pAdmin] < 3 && !PlayerInfo[playerid][pBanAppealer])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[16]S(N/A)[128]", ip, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /banip [ip address] [reason (optional)]");
	}
	if (IsBanned(ip))
    {
       return SendClientMessage(playerid, COLOR_SYNTAX, "Already  Banned");
    }
	if(!IsAnIP(ip))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid IP address.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM bans WHERE ip = '%e'", ip);
	mysql_tquery(connectionID, queryBuffer, "OnAdminBanIP", "iss", playerid, ip, reason);
	return 1;
}

CMD:whitelist(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /whitelist [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminLockAccount", "is", playerid, username);
	return 1;
}

CMD:unwhitelist(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unwhitelist [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e' AND locked = 1", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminUnlockAccount", "is", playerid, username);
	return 1;
}

CMD:sprison(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sprison [playerid] [minutes] [reason]");
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

    ResetPlayerWeaponsEx(targetid);
    ResetPlayer(targetid);
    SetPlayerInJail(targetid);

    SMA(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by an Admin, reason: %s", GetRPName(targetid), minutes, reason);
    SM(targetid, COLOR_AQUA, "** You have been admin prisoned for %i minutes by an admin.", minutes);
    return 1;
}

CMD:sethpall(playerid, params[])
{
	new Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sethpall [amount]");
	}
	if(amount < 1.0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Health can't be under 1.0.");
	}

	foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pAdminDuty] && !PlayerInfo[i][pJoinedEvent] && !PlayerInfo[i][pPaintball] && PlayerInfo[i][pDueling] == INVALID_PLAYER_ID)
	    {
		    SetPlayerHealth(i, amount);
		}
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s set everyone's health to %.1f.", GetRPName(playerid), amount);
	return 1;
}

CMD:setarmorall(playerid, params[])
{
	new Float:amount;

    if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setarmorall [amount]");
	}
	if(amount < 0.0 || amount > 150.0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Armor can't be under 0.0 or above 150.0.");
	}

	foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pAdminDuty] && !PlayerInfo[i][pJoinedEvent] && !PlayerInfo[i][pPaintball] && PlayerInfo[i][pDueling] == INVALID_PLAYER_ID)
	    {
		    SetScriptArmour(i, amount);
		}
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s set everyone's armor to %.1f.", GetRPName(playerid), amount);
	return 1;
}

CMD:enter(playerid, params[])
{
	if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1395.1077, -1385.9746, 13.5547))
	{
		if(PlayerInfo[playerid][pAcceptedHelp])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can not enter the paintball arena while on helper duty!");
	    }
	    if(PlayerInfo[playerid][pWeaponRestricted] > 0)
    	{
        	return SendClientMessage(playerid, COLOR_GREY, "You are restricted from weapons and therefore can't join paintball.");
    	}
	    ShowDialogToPlayer(playerid, DIALOG_PAINTBALL);
	}
	else
	{
		EnterCheck(playerid);
	}

	return 1;
}

CMD:exit(playerid, params[])
{
    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(PlayerInfo[playerid][pPaintball] > 0)
	{
 		foreach(new i : Player)
		{
		    if(PlayerInfo[playerid][pPaintball] == PlayerInfo[i][pPaintball])
	    	{
	        	SM(i, COLOR_WHITE, "[Paintball Arena] %s has left the Paintball Arena!", GetRPName(playerid));
			}
		}

        ResetPlayerWeapons(playerid);
        SetPlayerArmedWeapon(playerid, WEAPON_FIST);
		PlayerInfo[playerid][pPaintball] = 0;
		PlayerInfo[playerid][pPaintballTeam] = -1;
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		GangZoneHideForPlayer(playerid, zone_paintball[0]);
		GangZoneHideForPlayer(playerid, zone_paintball[1]);
		SetPlayerToSpawn(playerid);
	}
	else
	{
		ExitCheck(playerid);
	}

	return 1;
}

CMD:givegun(playerid, params[])
{
	new targetid, weaponid;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 8)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "ui", targetid, weaponid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givegun [playerid] [weaponid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is either weapon restricted or played less than two playing hours.");
    }
	if(!(1 <= weaponid <= 46))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid weapon.");
	}

	GiveWeapon(targetid, weaponid);

	SM(targetid, COLOR_AQUA, "You have received a "SVRCLR"%s{CCFFFF} from %s.", GetWeaponNameEx(weaponid), GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given a %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));

	return 1;
}
CMD:fixsignal(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_SIGNAL)) return SendClientMessage(playerid, COLOR_GREY, "You are not working as an Signal worker");
	if(!IsASinyal(playerid)) return SendClientMessage(playerid, COLOR_RED, "[ERROR] No damaged signal nearby");
	{
		if(PlayerInfo[playerid][pIndiHome] == 1) return SendClientMessage(playerid, COLOR_GREY, "Signal already fixed");
		PlayerInfo[playerid][pIndiHome] = 1;
		TogglePlayerControllable(playerid, 0);
		DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "IndiHome"));
		DeletePVar(playerid, "IndiHome");
		ApplyAnimationEx(playerid,"COP_AMBIENT", "Copbrowse_loop",4.0, 1, 0, 0, 0, 0);
		CountDownForPlayer(playerid,"~y~FIXING","~W~Seconds", 3);
		SetTimerEx("UnfreezePlayerEx", 10000, false, "d", playerid);
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		SetPlayerCheckpoint(playerid, 1983.651000, -1983.395996, 13.546875, 5.0);
		SendClientMessage(playerid, -1, "{FF0000}SIGNAL JOB AKRP: {FFFFFF}Return to Work Location");
	}
	return 1;
}
CMD:placeladder(playerid, params[])
{
   	if(PlayerHasJob(playerid, JOB_SIGNAL))
	{
		for (new i = 0; i < 5; ++i) {
			DestroyDynamicObject(ladder[i]);
		}
		ladder[0] = CreateDynamicObject(1437, 611.634399, -1783.442260, 14.364824, 40.000000, 0.000000, 257.000000, -1, -1, -1, 300.00, 300.00);
		ladder[1] = CreateDynamicObject(1437, 927.450378, -1415.378173, 13.619938, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
		ladder[2] = CreateDynamicObject(1437, 1971.078002, -1824.256713, 13.746875, -20.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
		ladder[3] = CreateDynamicObject(1437, 2177.941406, -1730.876098, 13.675001, -20.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
		ladder[4] = CreateDynamicObject(1437, 849.167724, -1038.856933, 25.906068, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
	}

	return 1;
   
}
CMD:start(playerid)
{
	if(!Job_CanJoin(playerid, JOB_SIGNAL))
	{
		return 1;
	}

	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1991.694824,-1991.433837,13.546875))
	{
		new rand = random(5);
		if(PlayerInfo[playerid][pIndiHome1] == 1)
		{
          return SendClientMessage(playerid,COLOR_YELLOW,"First Finish Your Job");
		}
		if(PlayerInfo[playerid][pGender] == 1) SetPlayerSkin(playerid,260);
		else SetPlayerSkin(playerid,211);// female
		PlayerInfo[playerid][pJob] = JOB_SIGNAL;
	    for (new i = 0; i < 5; ++i) {
             DestroyDynamicObject(ladder[i]);
        }
        ladder[0] = CreateDynamicObject(1437, 611.634399, -1783.442260, 14.364824, 40.000000, 0.000000, 257.000000, -1, -1, -1, 300.00, 300.00);
        ladder[1] = CreateDynamicObject(1437, 927.450378, -1415.378173, 13.619938, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
        ladder[2] = CreateDynamicObject(1437, 1971.078002, -1824.256713, 13.746875, -20.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
        ladder[3] = CreateDynamicObject(1437, 2177.941406, -1730.876098, 13.675001, -20.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
        ladder[4] = CreateDynamicObject(1437, 849.167724, -1038.856933, 25.906068, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
		SetPlayerCheckpoint(playerid, RandomIndihome[rand][0], RandomIndihome[rand][1], RandomIndihome[rand][2], 2.0);
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		SetPVarInt(playerid, "salary", floatround(RandomIndihome[rand][3]));
        PlayerInfo[playerid][pIndiHome1] = 1;

		SetPVarInt(playerid, "IndiHome", _:CreateDynamic3DTextLabel("/fixsignal", COLOR_YELLOW, RandomIndihome[rand][0], RandomIndihome[rand][1], RandomIndihome[rand][2], 10.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
		SendClientMessage(playerid,COLOR_YELLOW,"Go to the Red Marker on the Map to Fix the Signal /placeladder If ladder Break");
	}
	return 1;
}
   

CMD:finish(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1983.651000, -1983.395996, 13.546875))
	{
		if(PlayerInfo[playerid][pIndiHome] == 0) return SendClientMessage(playerid, COLOR_GREY, "You haven't fixed the signal yet");
		SetPlayerSkin(playerid,PlayerInfo[playerid][pSkin]);
		new salary = GetPVarInt(playerid, "salary");
		DeletePVar(playerid, "salary");
		SendClientMessage(playerid,-1,"{ffff00}You have completed the job");
		DisablePlayerCheckpoint(playerid);
		PlayerInfo[playerid][pJob] = JOB_NONE;
		PlayerInfo[playerid][pIndiHome] = 0;
		PlayerInfo[playerid][pIndiHome1] = 0;
		AddToPaycheck(playerid, salary);
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i",PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		
		SCMf(playerid, COLOR_BLUE, "[ AKRP ] Added To Paycheck %i$",salary);
	}
	return 1;
}

CMD:setweather(playerid, params[])
{
	new weatherid;

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", weatherid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setweather [weatherid]");
	}

	gWeather = weatherid;
	SetWeather(weatherid);
	SM(playerid, COLOR_GREY2, "Weather changed to %i.", weatherid);
	return 1;
}

CMD:settime(playerid, params[])
{
	new hour;

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", hour))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /settime [hour]");
	}
	if(!(0 <= hour <= 23))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The hour must range from 0 to 23.");
	}

	gWorldTime = hour;

	SetWorldTime(hour);
	SMA(COLOR_GREY2, "Time of day changed to %i hours.", hour);
	return 1;
}

CMD:setstat(playerid, params[])
{
	new targetid, option[24], param[32], value;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [option]");
	    SM(playerid, COLOR_WHITE, "Available options: Gender, Age, Cash, Bank, Level, Respect, Hours, Warnings");
	    SM(playerid, COLOR_WHITE, "Available options: SpawnHealth, SpawnArmor, FightStyle, Accent, Phone, Crimes, Arrested");
	    SM(playerid, COLOR_WHITE, "Available options: WantedLevel, Materials, Pot, Crack, Meth, Painkillers, Cigars, PortableRadio");
	    SM(playerid, COLOR_WHITE, "Available options: Channel, Spraycans, Boombox, Phonebook, Paycheck, CarLicense, Seeds, Ephedrine");
		SM(playerid, COLOR_WHITE, "Available options: InventoryUpgrade, AddictUpgrade, TraderUpgrade, AssetUpgrade, MP3Player, Job");
        SM(playerid, COLOR_WHITE, "Available options: DMWarnings, WeaponRestricted");
        SM(playerid, COLOR_WHITE, "Available options: Watch, GPS, GasCan, FishingSkill, TruckerSkill, GuardSkill, WeaponSkill");
        SM(playerid, COLOR_WHITE, "Available options: LawyerSkill, SmugglerSkill, DetectiveSkill");
        SM(playerid, COLOR_WHITE, "Available options: Mask, Marriage, GunLicense, Hunger, Thirst");
        SM(playerid, COLOR_WHITE, "Available options: Diamonds, Jacket, LaborUpgrade, UpgradePoints, Skates, Food, Drink");
	    return 1;
	}
	if(!strcmp(option, "gender", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [gender] [male | female]");
		}
		if(!strcmp(param, "male", true))
		{
		    PlayerInfo[targetid][pGender] = 1;
		    SM(playerid, COLOR_WHITE, "** You have set %s's gender to Male.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gender = 1 WHERE uid = %i", PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "female", true))
		{
		    PlayerInfo[targetid][pGender] = 2;
		    SM(playerid, COLOR_WHITE, "** You have set %s's gender to Female.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gender = 2 WHERE uid = %i", PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(!strcmp(option, "tag", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [tag] [value]");
		}
		PlayerInfo[targetid][pDiscordTag] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have set %s's Food to %i.", GetRPName(targetid));
	}
	else if(!strcmp(option, "dcname", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [dcname] [value]");
		}
		PlayerInfo[targetid][pDiscordName] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have seted to %i.", GetRPName(targetid));
	}
	else if(!strcmp(option, "food", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [food] [value]");
		}
		PlayerInfo[targetid][pFood] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have set %s's Food to %i.", GetRPName(targetid), value);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[targetid][pFood], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "drink", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [drink] [value]");
		}
		PlayerInfo[targetid][pDrink] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have set %s's drink to %i.", GetRPName(targetid), value);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = %i WHERE uid = %i", PlayerInfo[targetid][pDrink], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "thirst", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [thirst] [value]");
		}
		if(value <= 0)
		{
			value = 2;
			PlayerInfo[playerid][pThirstTimer] = 1799;
		}
		else if(value > 100)
		{
				value = 100;
		}
		PlayerInfo[targetid][pThirst] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have set %s's thirst to %i.", GetRPName(targetid), value);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET thirst = %i, thirsttimer = %i WHERE uid = %i", PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pThirstTimer], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

	}
	else if(!strcmp(option, "hunger", true))
	{
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /setstat [playerid] [hunger] [value]");
		}
		if(value <= 0)
		{
			value = 2;
			PlayerInfo[playerid][pHungerTimer] = 1799;
		}
		else if(value > 100)
		{
				value = 100;
		}
		PlayerInfo[targetid][pHunger] = value;

	    SendMessage(playerid, COLOR_WHITE, "** You have set %s's hunger to %i.", GetRPName(targetid), value);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hunger = %i, hungertimer = %i WHERE uid = %i", PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pHungerTimer], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

	}
	else if(!strcmp(option, "marriage", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [marriedto] [playerid(-1 to reset)]");
		}

		if(IsPlayerConnected(value))
		{
			PlayerInfo[targetid][pMarriedTo] = PlayerInfo[value][pID];
			strcpy(PlayerInfo[targetid][pMarriedName], GetPlayerNameEx(value), MAX_PLAYER_NAME);
	    	SM(playerid, COLOR_WHITE, "You have set %s's marriage to %s.", GetRPName(targetid), GetRPName(value));

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = %i WHERE uid = %i", PlayerInfo[value][pID], PlayerInfo[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
		else if(value == -1)
		{
			PlayerInfo[targetid][pMarriedTo] = -1;
			strcpy(PlayerInfo[targetid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
	    	SM(playerid, COLOR_WHITE, "You have reset %s's marriage.", GetRPName(targetid));

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET marriedto = -1 WHERE uid = %i",  PlayerInfo[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(!strcmp(option, "bandage", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /giveitems [playerid] [Bandage] [value]");
		}

		PlayerInfo[targetid][pBandage] = value;
		ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);

	    SM(playerid, COLOR_WHITE, "** You have set %s's Bandage to %i.", GetRPName(targetid), value);
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s was given Bandage to %s", GetRPName(playerid), GetRPName(targetid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bandage = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "vest", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /giveitems [playerid] [vest] [value]");
		}

		PlayerInfo[targetid][pVest] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's Vest to %i.", GetRPName(targetid), value);
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s was given Vest to %s", GetRPName(playerid), GetRPName(targetid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "skates", true))
	{
	    if(sscanf(param, "i", value) || !(0<=value<=1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [skates] [1/0]");
		}
		else
		{
			PlayerInfo[targetid][pSkates] = value;
	    	SM(playerid, COLOR_WHITE, "You have set %s's skates to %i.", GetRPName(targetid), value);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rollerskates = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(!strcmp(option, "age", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [age] [value]");
		}
		if(!(0 <= value <= 128))
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "The value specified can't be under 0 or above 128.");
		}

		PlayerInfo[targetid][pAge] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's age to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET age = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "cash", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [cash] [value]");
		}

		PlayerInfo[targetid][pCash] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's cash to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "bank", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [bank] [value]");
		}

		PlayerInfo[targetid][pBank] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's bank money to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "level", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [level] [value]");
		}

		PlayerInfo[targetid][pLevel] = value;
	    //SendClientMessage(playerid, COLOR_WHITE, "I can see you Imao");

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET level = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "respect", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [respect] [value]");
		}

		PlayerInfo[targetid][pEXP] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's respect points to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET exp = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "upgradepoints", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [upgradepoints] [value]");
		}

		PlayerInfo[targetid][pUpgradePoints] = value;
	    SM(playerid, COLOR_WHITE, "You have set %s's upgrade points to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET upgradepoints = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "hours", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [hours] [value]");
		}

		PlayerInfo[targetid][pHours] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's playing hours to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hours = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "warnings", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [warnings] [value]");
		}
		if(!(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "The value specified can't be under 0 or above 3.");
		}

		PlayerInfo[targetid][pWarnings] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's warnings to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET warnings = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spawnhealth", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [spawnhealth] [value]");
		}

		PlayerInfo[targetid][pSpawnHealth] = amount;
	    SM(playerid, COLOR_WHITE, "** You have set %s's spawn health to %.1f.", GetRPName(targetid), amount);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spawnhealth = '%f' WHERE uid = %i", amount, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spawnarmor", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [spawnarmor] [value]");
		}

		PlayerInfo[targetid][pSpawnArmor] = amount;
	    SM(playerid, COLOR_WHITE, "** You have set %s's spawn armor to %.1f.", GetRPName(targetid), amount);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spawnarmor = '%f' WHERE uid = %i", amount, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "fightstyle", true))
	{
	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [fightstyle] [option]");
	        SendClientMessage(playerid, COLOR_WHITE, "Available options: Normal, Boxing, Kungfu, Kneehead, Grabkick, Elbow");
	        return 1;
		}
		if(!strcmp(param, "normal", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_NORMAL;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Normal.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_NORMAL);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "boxing", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_BOXING;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Boxing.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_BOXING);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "kungfu", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_KUNGFU;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Kung Fu.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_KUNGFU);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "kneehead", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Kneehead.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_KNEEHEAD);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "grabkick", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_GRABKICK;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Grabkick.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_GRABKICK);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "elbow", true))
		{
		    PlayerInfo[targetid][pFightStyle] = FIGHT_STYLE_ELBOW;

		    SM(playerid, COLOR_WHITE, "** You have set %s's fight style to Elbow.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, FIGHT_STYLE_ELBOW);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[targetid][pFightStyle], PlayerInfo[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
	}
    else if(!strcmp(option, "accent", true))
	{
	    new accent[16];

	    if(sscanf(param, "s[16]", accent))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [accent] [text]");
		}

		strcpy(PlayerInfo[targetid][pAccent], accent, 16);
		SM(playerid, COLOR_WHITE, "** You have set %s's accent to '%s'.", GetRPName(targetid), accent);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET accent = '%e' WHERE uid = %i", accent, PlayerInfo[targetid][pID]);
  		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "diamonds", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [diamonds] [value]");
		}

		PlayerInfo[targetid][pDiamonds] = value;
	    SM(playerid, COLOR_WHITE, "You have set %s's diamonds to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "phone", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [phone] [number]");
		}
		if(value == 911 || value == 6397 || value == 6324 || value == 8294)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid number.");
		}

		PlayerInfo[targetid][pPhone] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's phone number to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "crimes", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [crimes] [value]");
		}

		PlayerInfo[targetid][pCrimes] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's commited crimes to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crimes = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "arrested", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [arrested] [value]");
		}

		PlayerInfo[targetid][pArrested] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's arrested count to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET arrested = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "wantedlevel", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [wantedlevel] [value]");
		}
		if(!(0 <= value <= 6))
		{
		    return SendClientMessage(playerid, COLOR_WHITE, "The value specified can't be under 0 or above 6.");
		}

		PlayerInfo[targetid][pWantedLevel] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's wanted level to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [materials] [value]");
		}

		PlayerInfo[targetid][pMaterials] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's materials to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "pot", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [pot] [value]");
		}

		PlayerInfo[targetid][pPot] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's pot to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [Crack] [value]");
		}

		PlayerInfo[targetid][pCrack] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's Crack to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "meth", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [meth] [value]");
		}

		PlayerInfo[targetid][pMeth] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's meth to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [painkillers] [value]");
		}

		PlayerInfo[targetid][pPainkillers] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's painkillers to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
 	else if(!strcmp(option, "cigars", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [cigars] [value]");
		}

		PlayerInfo[targetid][pCigars] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's cigars to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "portableradio", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [portableradio] [0/1]");
		}

		PlayerInfo[targetid][pWalkieTalkie] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's Portable Radio to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET walkietalkie = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "channel", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [channel] [value]");
		}

		PlayerInfo[targetid][pChannel] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's radio channel to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET channel = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [spraycans] [value]");
		}

		PlayerInfo[targetid][pSpraycans] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's spraycans to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "boombox", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [boombox] [0/1]");
		}

		if((value == 0) && PlayerInfo[targetid][pBoomboxPlaced])
		{
		    DestroyBoombox(targetid);
		}

		PlayerInfo[targetid][pBoombox] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's boombox to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET boombox = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "phonebook", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [phonebook] [0/1]");
		}

		PlayerInfo[targetid][pPhonebook] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's phonebook to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebook = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "paycheck", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [paycheck] [value]");
		}

		PlayerInfo[targetid][pPaycheck] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's paycheck to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET paycheck = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "carlicense", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [carlicense] [0/1]");
		}

		PlayerInfo[targetid][pCarLicense] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's car license to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carlicense = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gunlicense", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [gunlicense] [0/1]");
		}

		PlayerInfo[targetid][pWeaponLicense] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's gun license to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunlicense = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [seeds] [value]");
		}

		PlayerInfo[targetid][pSeeds] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's seeds to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET seeds = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "ephedrine", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [ephedrine] [value]");
		}

		PlayerInfo[targetid][pEphedrine] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's ephedrine to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "job", true))
	{
	    if(sscanf(param, "i", value))
	    {
			SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [job] [value (-1 = none)]");
			SendClientMessage(playerid, COLOR_GREY2, "List of jobs: (1)  (2) Bodyguard (3) Arms Dealer (4) Miner");
			SendClientMessage(playerid, COLOR_GREY2, "List of jobs: (5) Taxi Driver (6) Drug Dealer (7) Lawyer (8) Detective");
			return 1;
		}
		if(!(-1 <= value <= 9))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid job.");
		}

		PlayerInfo[targetid][pJob] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's job to %s.", GetRPName(targetid), GetJobName(value));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET job = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "mask", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [mask] [0/1]");
		}
		if(!(-1 <= value <= 1))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid value.");
		}

		PlayerInfo[targetid][pMask] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's mask to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mask = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "laborupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [laborupgrade] [value]");
		}
		if(!(0 <= value <= 5))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 5.");
		}

		PlayerInfo[targetid][pLaborUpgrade] = value;
	    SM(playerid, COLOR_WHITE, "You have set %s's labor upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET laborupgrade = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "mp3player", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [mp3player] [0/1]");
		}

		PlayerInfo[targetid][pMP3Player] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's MP3 player to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mp3player = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "dmwarnings", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [dmwarnings] [value]");
		}
		if(!(0 <= value <= 4))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The value must range from 0 to 4.");
		}

		PlayerInfo[targetid][pDMWarnings] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's DM warnings to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dmwarnings = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "weaponrestricted", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [weaponrestricted] [hours]");
		}

		PlayerInfo[targetid][pWeaponRestricted] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's weapon restriction to %i hours.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weaponrestricted = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "watch", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [watch] [0/1]");
		}

		PlayerInfo[targetid][pWatch] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's watch to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gps", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [gps] [0/1]");
		}

		PlayerInfo[targetid][pGPS] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's GPS to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gascan", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [gascan] [value]");
		}

		PlayerInfo[targetid][pGasCan] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's gas can to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "truckerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [truckerskill] [value]");
		}

		PlayerInfo[targetid][pCourierSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's trucker skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET courierskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "fishingskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [fishingskill] [value]");
		}

		PlayerInfo[targetid][pFishingSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's fishing skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "guardskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [guardskill] [value]");
		}

		PlayerInfo[targetid][pGuardSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's bodyguard skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET guardskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "weaponskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [weaponskill] [value]");
		}

		PlayerInfo[targetid][pWeaponSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's weapon skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weaponskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "lawyerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [lawyerskill] [value]");
		}

		PlayerInfo[targetid][pLawyerSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's lawyer skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET lawyerskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "detectiveskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setstat [playerid] [detectiveskill] [value]");
		}

		PlayerInfo[targetid][pDetectiveSkill] = value;
	    SM(playerid, COLOR_WHITE, "** You have set %s's detective skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET detectiveskill = %i WHERE uid = %i", value, PlayerInfo[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	    return 1;
	}
	return 1;
}

CMD:givemoney(playerid, params[])
{
	new targetid, amount;

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givemoney [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}

	GivePlayerCash(targetid, amount);
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given $%i to %s.", GetRPName(playerid), amount, GetRPName(targetid));
	return 1;
}

CMD:refund(playerid, params[])
{
	if(PlayerInfo[playerid][pRefunded] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have already claimed your refund package.");
	}
	else
    RefundPlayer(playerid);
	SMA(COLOR_LIGHTRED, "SERVER: %s has claimed their refund package using [/refund].", GetRPName(playerid));
	ShowPlayerDialog(playerid, DIALOG_REFUNDED, DIALOG_STYLE_MSGBOX, "You have claimed your refund package", "{FFFFFF}As you came to our server, you have received the following as a starter package:\n\n {369b26}$200,000\n{A028AD}Platinum Donator{FFFFFF}(15 days)\n\n{FFFFFF}We hope that you will invite more of your friends to play on the server!\n{FFFFFF}/info","Enjoy!","");	
	return 1;
}

CMD:givemoneyall(playerid, params[])
{
	new amount;

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givemoneyall [amount]");
    }
	if(amount < 1 || amount > 100000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount specified must range between $1 and $100000.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pLogged])
		{
		    GivePlayerCash(i, amount);
		}
	}

	SMA(COLOR_LIGHTRED, "AdmCmd: %s has given $%i to every player online.", GetRPName(playerid), amount);
	return 1;
}

CMD:setdonator(playerid, params[])
{
	new targetid, rank, days;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uii", targetid, rank, days))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setdonator [playerid] [rank] [days]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of ranks: (1) Gold (2) Diamond (3) Platinum");
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
	if(!(1 <= rank <= 3))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid rank.");
	}
	if(!(1 <= days <= 365))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of days must range from 1 to 365.");
	}

	PlayerInfo[targetid][pVIPPackage] = rank;
	PlayerInfo[targetid][pVIPTime] = gettime() + (days * 86400);
	PlayerInfo[targetid][pVIPCooldown] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[targetid][pVIPPackage], PlayerInfo[targetid][pVIPTime], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(days >= 30)
	{
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has given a {C2A2DA}%s{FF6347} Donator package to %s for %i months.", GetRPName(playerid), GetDonatorRank(rank), GetRPName(targetid), days / 30);
		SM(targetid, COLOR_AQUA, "** %s has given you a {C2A2DA}%s{CCFFFF} Donator package for %i months.", GetRPName(playerid), GetDonatorRank(rank), days / 30);
	}
	else
	{
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has given a {C2A2DA}%s{FF6347} Donator package to %s for %i days.", GetRPName(playerid), GetDonatorRank(rank), GetRPName(targetid), days);
		SM(targetid, COLOR_AQUA, "** %s has given you a {C2A2DA}%s{CCFFFF} Donator package for %i days.", GetRPName(playerid), GetDonatorRank(rank), days);
	}

	return 1;
}

CMD:removedonator(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removedonator [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(!PlayerInfo[targetid][pVIPPackage])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player doesn't have a donator subscription which you can remove.");
	}

	PlayerInfo[targetid][pVIPPackage] = 0;
	PlayerInfo[targetid][pVIPTime] = 0;
	PlayerInfo[targetid][pVIPColor] = 0;
    PlayerInfo[targetid][pSecondJob] = JOB_NONE;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = 0, viptime = 0 WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has revoked %s's donator subscription.", GetRPName(playerid), GetRPName(targetid));
	SM(targetid, COLOR_AQUA, "** %s has revoked your donator subscription.", GetRPName(playerid));
	return 1;
}

CMD:rangeban(playerid, params[])
{
	new targetid, reason[128];

 	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rangeban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(PlayerInfo[targetid][pAdmin] == 8)
	{
 		SAM(COLOR_YELLOW, "Warning: %s has been autokicked for trying to ban a Server Manager(%s).", GetRPName(playerid), GetRPName(targetid));
 		KickPlayer(playerid);
 		return 1;
	}
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was rangebanned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	Rangeban(targetid, GetPlayerNameEx(playerid), reason);
	return 1;
}

CMD:forcepayday(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    if(sscanf(params, "s", "confirm"))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /forcepayday [confirm] (gives everyone a paycheck)");
	}
	foreach(new i : Player)
	{
	    SendPaycheck(i);
	}

	return 1;
}

CMD:deleteaccount(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /deleteaccount [username]");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is already online and logged in. You can't delete their account.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM users WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminDeleteAccount", "is", playerid, username);
	return 1;
}

CMD:resetbizhouse(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!gRobbery)
	{
		gRobbery = true;
	    SMA(COLOR_GREEN, "*ADMIN DISABLED THE ROBBERY OF THE HOUSE/BIZ*");
	}
	else
	{
		gRobbery = false;
	    SMA(COLOR_AQUA, "*ADMIN ENABLED THE ROBBERY OF THE HOUSE/BIZ*");
	}
	return 1;
}
CMD:track(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;
 	if(GetFactionType(playerid) != FACTION_POLICE)
 	{
  		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a Police!");
 	}
 	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /track [playerid]");
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
 	PlayerInfo[playerid][pFindTime] = 300;
	SetPlayerMarkerForPlayer(playerid, targetid, 0xFF0000FF);
	GetPlayerPos(targetid, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, z, 5.0);
	SM(playerid, COLOR_WHITE, "** %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerInfo[playerid][pFindTime]);
	PlayerInfo[playerid][pFindPlayer] = targetid;
	return 1;
}

CMD:atrack(playerid, params[])
{
	new targetid;
 	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
 	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /track [playerid]");
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
 	PlayerInfo[playerid][pFindTime] = 120;
	SetPlayerMarkerForPlayer(playerid, targetid, 0xFF0000FF);
	SM(playerid, COLOR_WHITE, "** %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerInfo[playerid][pFindTime]);
	PlayerInfo[playerid][pFindPlayer] = targetid;
	return 1;
}

CMD:doublesalary(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!gDoubleSalary)
	{
		gDoubleSalary = true;
	    SMA(COLOR_GREEN, "** Admin enabled double salary. You will now gain double of any jobs salary.");
	}
	else
	{
		gDoubleSalary = false;
	    SMA(COLOR_RED, "** Admin disabled double salary.");
	}

	return 1;
}

CMD:doublexp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!gDoubleXP)
	{
		SendRconCommand("hostname \t All Kerala Roleplay [2XP!]");
		gDoubleXP = true;
	    SMA(COLOR_GREEN, "** Admin enabled double experience. You will now gain double the respect points and job skill points.");
	}
	else
	{
		SendRconCommand("hostname \t All Kerala Roleplay [2XP!]");
		gDoubleXP = false;
	    SMA(COLOR_RED, "** Admin disabled double experience.");
	}

	return 1;
}

CMD:createspeed(playerid, params[])
{
	static
	    Float:limit,
	    Float:range;
    if(PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if (sscanf(params, "ff", limit, range))
		return SendClientMessage(playerid, COLOR_GREY, "/createspeed [speed limit] [range] (default range: 30)");

	if (limit < 5.0 || limit > 200.0)
	    return SendClientMessage(playerid, COLOR_GREY, "The speed limit can't be below 5 or above 200.");

	if (range < 5.0 || range > 50.0)
	    return SendClientMessage(playerid, COLOR_GREY, "The range can't be below 5 or above 50.");

	if (Speed_Nearest(playerid) != -1)
	    return SendClientMessage(playerid, COLOR_GREY, "You can't do this in range another speed camera.");

	new id = Speed_Create(playerid, limit, range);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_GREY, "The server has reached the limit for speed cameras.");

	SM(playerid, COLOR_GREY, "You have created speed camera ID: %d.", id);
	return 1;
}
CMD:buyfood(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid,5.0, 722.189758, -1773.703247, 2.742840) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1296.138305, -975.151000, 38.393463)) return 1;

	ShowPlayerDialog(playerid, DIALOG_FOODSHOP, DIALOG_STYLE_LIST, "Food Shop", "Burger  "GREEN"1000 $\nMilkshake  "GREEN"500 $\n"RED"RED"WHITE"BULL "GREEN"5000$\n"RED"Energy "WHITE"ChickenRoll "GREEN"5000$", "Buy", "Back");

	return 1;
}
CMD:gotospeed(playerid, params[])
{
	new houseid;

    if(PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotogate [gateid]");
	}
	if(!(0 <= houseid < MAX_SPEED_CAMERAS) || !SpeedData[houseid][speedExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gate.");
	}
	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);
	SetPlayerPos(playerid, SpeedData[houseid][speedPos][0] - (2.5 * floatsin(-SpeedData[houseid][speedPos][3], degrees)), SpeedData[houseid][speedPos][1] - (2.5 * floatcos(-SpeedData[houseid][speedPos][3], degrees)), SpeedData[houseid][speedPos][2]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:destroyspeed(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 6)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_GREY, "/destroyspeed [speed id]");

	if ((id < 0 || id >= MAX_SPEED_CAMERAS) || !SpeedData[id][speedExists])
	    return SendClientMessage(playerid, COLOR_GREY, "You have specified an invalid speed camera ID.");

	Speed_Delete(id);
	DestroyDynamicMapIcon(SpeedData[id][sMapIcon]);
	SM(playerid, COLOR_GREY, "You have successfully destroyed speed camera ID: %d.", id);
	return 1;
}

