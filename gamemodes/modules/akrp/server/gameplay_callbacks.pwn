public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	new weapon[24];
	
	if(gettime() - PlayerInfo[playerid][pLastDeath] < 2)
	{
	    return 1;
	}
	
	if(killerid != INVALID_PLAYER_ID)
	{

       killeffect[killerid] = PlayerText_InterpolateBoxColor(killerid,BLINK[killerid][0] , 0xFFFFFF00, 1000, EASE_OUT_SINE);
       SetTimerEx("Hide", 1003, false, "ii", killerid, 1);
      
	}
    GetWeaponName(reason,weapon,sizeof(weapon));
	if(PlayerInfo[playerid][pLogged])
	{
        if (CarRadars[playerid] == 1)
	    {
		  	CarRadars[playerid] = 0;
			PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
			PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawHide(playerid, _crTickets[playerid]);
		 	DeletePVar(playerid, "_lastTicketWarning");
	    }
		if(PlayerInfo[playerid][pJoinedEvent])
		{
		    foreach(new i : Player)
			{
			    if(PlayerInfo[i][pJoinedEvent])
			    {
			        if(killerid == INVALID_PLAYER_ID)
			            SM(i, COLOR_LIGHTORANGE, "(( %s died. ))", GetRPName(playerid));
			        else
						SM(i, COLOR_LIGHTORANGE, "(( %s was killed by %s. ))", GetRPName(playerid), GetRPName(killerid));
				}
			}
		}
		else if(PlayerInfo[playerid][pPaintball] > 0)
		{
		    foreach(new i : Player)
			{
			    if(PlayerInfo[playerid][pPaintball] == PlayerInfo[i][pPaintball])
			    {
			        if(killerid == INVALID_PLAYER_ID)
			            SM(i, COLOR_RED, "[Paintball Arena] %s has died.",GetPlayerNameEx(playerid));

			        else
						SM(i, COLOR_RED, "[Paintball Arena] %s has killed %s with a %s.", GetPlayerNameEx(killerid), GetPlayerNameEx(playerid), weapon);
				}
			}
		}
		else if(PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
		{
			SM(playerid, COLOR_LIGHTORANGE, "(( You lost your duel against %s! ))", GetRPName(PlayerInfo[playerid][pDueling]));

			if(killerid != INVALID_PLAYER_ID)
		    {
				SM(killerid, COLOR_LIGHTORANGE, "(( You won the duel against %s! ))", GetRPName(playerid));
				SAM(COLOR_LIGHTRED, "AdmCmd: %s has won their duel against %s.", GetRPName(killerid), GetRPName(playerid));
				SetPlayerToSpawn(killerid);
			}
		}
		else
		{
		    if(killerid != INVALID_PLAYER_ID)
			{
			    HandleContract(playerid, killerid);
			}
		    if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pJailType] == 0)
		    {
			    if(PlayerInfo[playerid][pInjured] == 0)
				{
				    ResetPlayer(playerid);
				    PlayerInfo[playerid][pInjured] = 1;
					foreach(new i : Player)
					{
					    if(GetFactionType(i) == FACTION_MEDIC)
					    {
					    	SM(i, COLOR_DISPATCH, "Beacon %s (%i) is in need of immediate medical assistance.", GetRPName(playerid), playerid);
						}
					}
				}
				else
				{
					Dyuze(playerid, "Wasted", "You died.");
					

					PlayerInfo[playerid][pDeathActor] = CreateActor(PlayerInfo[playerid][pSkin],PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ],PlayerInfo[playerid][pPosA]);
					ApplyActorAnimation(PlayerInfo[playerid][pDeathActor], "PED", "KO_shot_front", 4.1, false, true, true, true, false);
					CreateCorpse(playerid, PlayerInfo[playerid][pDeathReason]);
					SetActorHealth(PlayerInfo[playerid][pDeathActor], 0.0);
				    new szString[128];
				    format(szString, sizeof(szString), "Kill Log: %s Killed by %s.", GetRPName(playerid), GetRPName(killerid));
				    SendDiscordMessage(18, szString);
					SetActorInvulnerable(PlayerInfo[playerid][pDeathActor], true);
					SetActorVirtualWorld(PlayerInfo[playerid][pDeathActor], GetPlayerVirtualWorld(playerid));

					new string[128]; // String of GOD
        			format(string, sizeof(string), "%s's "WHITE"body", GetRPName(playerid));
					PlayerInfo[playerid][pDeathInfo] = CreateDynamic3DTextLabel(string, SERVER_COLOR, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ], 10.0);

					SetTimerEx("DEATHACTOR", 60000, false, "i", playerid);
					PlayerInfo[playerid][pInjured] = 0;
				    for(new td = 0; td < 4; td ++)
				    {
				      	PlayerTextDrawHide(playerid, DEATH[playerid][td]);
			     	}
				    for(new i = 0; i < 15; i++)
				    {
				        TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
			        }
			        PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
			        CancelSelectTextDraw(playerid);
					PlayerInfo[playerid][pHospital] = 1;
					if(PlayerInfo[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
					{
						SM(PlayerInfo[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has bled out.", GetRPName(playerid));
                        PlayerInfo[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
					}
				}
			}
			else
			{
			    PlayerInfo[playerid][pHealth] = 32767.0;
			}
			
            if(killerid != INVALID_PLAYER_ID)
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO kills VALUES(null, %i, %i, '%s', '%s', '%s', NOW())", PlayerInfo[killerid][pID], PlayerInfo[playerid][pID], GetPlayerNameEx(killerid), GetPlayerNameEx(playerid), GetDeathReason(reason));
			    mysql_tquery(connectionID, queryBuffer);

				new dc_str[454];
				format(dc_str, sizeof(dc_str), "%s was knock down by %s.", GetRPName(playerid), GetRPName(killerid));
				SendDiscordMessage(8, dc_str);
				SAM(COLOR_LIGHTGREEN, "knock down Log: %s Killde by %s.", GetRPName(playerid), GetRPName(killerid));
			}
			
			GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
	        GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);

	        PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
	        PlayerInfo[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
		}
	}

	if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
	    HangupCall(PlayerInfo[playerid][pCallLine], HANGUP_DROPPED);
	}

	if(reason == 50 && killerid != INVALID_PLAYER_ID)
	{
	    SAM(COLOR_YELLOW, "AdmWarning: %s[%i] was helibladed by %s[%i].", GetRPName(playerid), playerid, GetRPName(killerid), killerid);
	}
	if(reason == 51 && killerid != INVALID_PLAYER_ID)
	{
	    SAM(COLOR_YELLOW, "AdmWarning: %s[%i] was Exploded by %s[%i].", GetRPName(playerid), playerid, GetRPName(killerid), killerid);
	    SetPVarInt(playerid, "Playerid", playerid);
	    SetPVarInt(playerid, "killer", killerid);
	}
	if(reason == 37 && killerid == INVALID_PLAYER_ID)
	{
		if(GetPVarInt(playerid, "playerid") == playerid)
		{
	      SAM(COLOR_YELLOW, "AdmWarning: %s[%i] was Burned by %s[%i]", GetRPName(playerid), playerid,GetRPName(GetPVarInt(playerid, "killer")), GetPVarInt(playerid, "killer"));
		}
	}
	PlayerInfo[playerid][pLastDeath] = gettime();
 	foreach(new i : Player)
	{
  		if(PlayerInfo[i][pAdmin])
		{
    		SendDeathMessageToPlayer(i, killerid, playerid, reason);
    	}
	}
	if(killerid != INVALID_PLAYER_ID)
	{
	    gTotalKills++;
	}
	
	new i = GetNearbyTurf(playerid);
	if(i != -1)
    {
		if(PlayerInfo[playerid][pInjured] && i > 0)
		{
		
			if(TurfInfo[i][tExists] && TurfInfo[i][tType] == 11 && TurfInfo[i][tTime] == 0 || TurfInfo[i][tExists] && InfluenceInfo[iStart] == 1)
			{
				if(PlayerInfo[playerid][pGang] > 0)
				{

					SendTurfAdminMessage(i, COLOR_LIGHTRED, "{007bff}[Turf Kills] {%06x}%s "WHITE"has been Knocked inside the turf. Gang Name: %s ", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
					SetTimerEx("TeleportPlayerFromTurf", 6000, false, "i", playerid);
					if(killerid != INVALID_PLAYER_ID)
					{
						new string[64];
						format(string, sizeof(string), "%s Knocks Down %s In Turf", GetRPName(killerid), GetRPName(playerid));
						foreach(new k : Player)
						{

							DynamicPlayerTextDrawSetString(k, KILLFEED[k][0], string);
							PlayerTextDrawShow(k, KILLFEED[k][0]);
							SetTimerEx("Hide", 5000, false, "ii", k, 2);
						}
						SendTurfAdminMessage(i, COLOR_LIGHTRED, "{007bff}[Turf Kills] {%06x}%s "WHITE"has been Knocked inside the turf. Gang Name: %s By : %s ", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName] ,GetRPName(killerid));

					}
					
				}
				else if(IsLawEnforcement(playerid))
				{
					SendTurfAdminMessage(i, COLOR_LIGHTRED, "{007bff}[Turf Kills] "WHITE"%s has been Knocked inside the turf. Faction: Police", GetRPName(playerid));
					if(killerid != INVALID_PLAYER_ID)
					{
						new string[64];
						format(string, sizeof(string), "%s Knocks Down %s In Turf", GetRPName(killerid), GetRPName(playerid));
						foreach(new k : Player)
						{
						DynamicPlayerTextDrawSetString(k, KILLFEED[k][0], string);
						PlayerTextDrawShow(k, KILLFEED[k][0]);
						SetTimerEx("Hide2", 5000, false, "i", k);
						}

					}
					SetTimerEx("TeleportPlayerFromTurf", 6000, false, "i", playerid);
				}
			}
		}
	}
	new j = GetNearbyPoints2(playerid);
	if(j != -1)
	if(PlayerInfo[playerid][pInjured] && j > 0)
	{

		if(PointInfo[j][pExists]&& PointInfo[j][pTime] == 0 && PointInfo[j][pCapturer] != INVALID_PLAYER_ID)
		{
			if(PlayerInfo[playerid][pGang] > 0)
			{
				SendPointAdminMessage(j, COLOR_LIGHTRED, "{007bff}[Point Kills] {%06x}%s "WHITE"has been Knocked inside the Point. Gang Name: %s", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
				SetTimerEx("TeleportPlayerFromPoint", 10000, false, "i", playerid);

			}
			else if(IsLawEnforcement(playerid))
			{
				SendPointAdminMessage(j, COLOR_LIGHTRED, "{007bff}[Point Kills] "WHITE"%s has been Knocked inside the Point. Faction: Police", GetRPName(playerid));

				SetTimerEx("TeleportPlayerFromPoint", 10000, false, "i", playerid);
			}
		}
	}
	gTotalDeaths++;
	SaveServerInfo();
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(gettime() - PlayerInfo[playerid][pLastDeath] > 10 && (areaid == area_paintball[0] || areaid == area_paintball[1]))
	{
	    if(PlayerInfo[playerid][pPaintball] == 3 || PlayerInfo[playerid][pPaintball] == 4)
	    {
	    	SendClientMessage(playerid, COLOR_RED, "You were poisoned to death for leaving the arena. (Use /exit)");
	    	SetPlayerHealth(playerid, 0.0);
		}
	}
	if(areaid == jailarea && PlayerInfo[playerid][pJailType] > 0)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, 
                "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}| ANTI-EXPLOIT]{ed0023} Exploiting bugs will result in a permanent ban.");

        SetPlayerPos(playerid, 940.830993, -1635.128417, 15.107945);
	}
	new turfid = InfluenceInfo[iTurf];
	if(InfluenceInfo[iTurf] != -1)
	if(areaid == TurfInfo[turfid][tArea]&& InfluenceInfo[iStart] == 1)
	{
	   if(InfluenceInfo[iStart] == 1 && turfid > 0 && PlayerInfo[playerid][pInjured] == 0 && PlayerInfo[playerid][pAdminDuty] == 0)
	   {
		   if(PlayerInfo[playerid][pGang] > 0)
		   {
		       
				SendTurfAdminMessage(turfid, COLOR_LIGHTRED, "{05ff93}[Turf Exits] {%06x}%s "RED"Exited "WHITE"The Turf Boundaries. Gang Name: %s", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
           }
           else if(IsLawEnforcement(playerid))
		   {
                SendTurfAdminMessage(turfid, COLOR_LIGHTRED, "{05ff93}[Turf Exits] {1900ff}%s "RED"Exited "WHITE"The Turf Boundaries. Faction Name: Police", GetRPName(playerid));
		   }
	   }

	}
	new id = GetNearbyTurf(playerid);
	if(id <= 0)
	{
		HideTurfTD(playerid);
	}
	new turfid1 = GetPVarInt(playerid, "turfid");
	if(areaid == TurfInfo[turfid1][tArea] && TurfInfo[turfid1][tType] == 11 && TurfInfo[turfid1][tTime] == 0)
	{
	   if(turfid1 > 0 && PlayerInfo[playerid][pInjured] == 0 && PlayerInfo[playerid][pAdminDuty] == 0)
	   {
		   if(PlayerInfo[playerid][pGang] > 0)
		   {
				SendClientMessage(playerid, COLOR_LIGHTRED, "[Turf Exits] You Exited The Turf Boundaries.");
				SendTurfAdminMessage(turfid1, COLOR_LIGHTRED, "{05ff93}[Turf Exits] {%06x}%s "RED"Exited "WHITE"The Turf Boundaries. Gang Name: %s", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
           }
           else if(IsLawEnforcement(playerid))
		   {
                SendTurfAdminMessage(turfid1, COLOR_LIGHTRED, "{05ff93}[Turf Exits] {1900ff}%s "RED"Exited "WHITE"The Turf Boundaries. Faction Name: Police", GetRPName(playerid));
		   }
	   }

	}
    new pid = GetPVarInt(playerid, "pointid");
	if(pid != -1)
	if(PointInfo[pid][pTime] == 0 && PointInfo[pid][pCapturer] != INVALID_PLAYER_ID && areaid == PointInfo[pid][pArea])
	{
	   if(PointInfo[pid][pTime] == 0 && pid > 0 && PlayerInfo[playerid][pInjured] == 0 && PlayerInfo[playerid][pAdminDuty] == 0)
	   {
		   if(PlayerInfo[playerid][pGang] > 0)
		   {
				SendTurfAdminMessage(pid, COLOR_LIGHTRED, "{05ff93}[Point Exits] {%06x}%s "RED"Exited "WHITE"The Point  Boundaries. Gang Name: %s", GangInfo[PlayerInfo[playerid][pGang]][gColor] >>> 8, GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
           }
           else if(IsLawEnforcement(playerid))
		   {
                SendTurfAdminMessage(pid, COLOR_LIGHTRED, "{05ff93}[Point  Exits] {1900ff}%s "RED"Exited "WHITE"The Point  Boundaries. Faction Name: Police", GetRPName(playerid));
		   }
	   }

	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(Vehicle_WheatCount(GetNearbyVehicle(playerid)) >= WHEAT_LIMIT)
 	{
		SendClientMessage(playerid, COLOR_ERROR, "Deliver the crop to the crop buyer.");
		SetPlayerCheckpoint(playerid, -599.343383, -1478.591552, 13.721575, 2.0);
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    new
	        Float:x,
	        Float:y,
	        Float:z;
	    GetPlayerPos(playerid, x, y, z);
	    SetPlayerPos(playerid, x, y, z + 0.5);
	    ClearAnimations(playerid, SYNC_ALL);
	}
	if((!ispassenger) && (PlayerInfo[playerid][pCuffed] || PlayerInfo[playerid][pTied] || PlayerInfo[playerid][pInjured]))
	{
	    new
	        Float:x,
	        Float:y,
	        Float:z;
	    GetPlayerPos(playerid, x, y, z);
	    SetPlayerPos(playerid, x, y, z + 0.5);
	    ClearAnimations(playerid, SYNC_ALL);
	}
	if(!ispassenger)
	{
	    if((courierVehicles[0] <= vehicleid <= courierVehicles[6]) && !PlayerHasJob(playerid, JOB_COURIER))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a Trucker.");
	        ClearAnimations(playerid, SYNC_ALL);
	    }

     	if((sandalvehicle[0] <= vehicleid <= sandalvehicle[3]) && !PlayerHasJob(playerid, JOB_SANDALWOOD))
	    {
     		SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a Sandal Driver.");
	        ClearAnimations(playerid, SYNC_ALL);
		}
		if((Signal[0]  <= vehicleid <= Signal[3]) && !PlayerHasJob(playerid, JOB_SIGNAL))
	    {
     		SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a Signal Worker");
	        ClearAnimations(playerid, SYNC_ALL);
		}
		
	    if((FarmerVehicles[0] <= vehicleid <= FarmerVehicles[9]) && !PlayerHasJob(playerid, JOB_FARMER))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a Farmer.");
	        ClearAnimations(playerid, SYNC_ALL);
	    }

	    if((testVehicles[0] <= vehicleid <= testVehicles[2]) && !PlayerInfo[playerid][pDrivingTest])
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not taking your drivers test.");
	        ClearAnimations(playerid, SYNC_ALL);
	    }
	    if(VehicleInfo[vehicleid][vFactionType] != FACTION_NONE && GetFactionType(playerid) != VehicleInfo[vehicleid][vFactionType])
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as it doesn't belong to your faction.");
	        ClearAnimations(playerid, SYNC_ALL);
	    }
        if(VehicleInfo[vehicleid][vVip] != 0 && PlayerInfo[playerid][pGang] != VehicleInfo[vehicleid][vGang])
        {
            SM(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a Member in %s.", GangInfo[VehicleInfo[vehicleid][vGang]][gName]);
	        ClearAnimations(playerid, SYNC_ALL);
        }
	    if(VehicleInfo[vehicleid][vJob] >= 0 && PlayerInfo[playerid][pJob] != VehicleInfo[vehicleid][vJob])
	    {
	        SM(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a %s.", GetJobName(VehicleInfo[vehicleid][vJob]));
	        ClearAnimations(playerid, SYNC_ALL);
	    }
	}
	Corpse_OnPlayerEnterVehicle(playerid);
	ExBJck[playerid] = 0;
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	
	switch(PlayerInfo[playerid][pCP])
	{
	   
        case CHECKPOINT_ATM:
		{
			new string[128];
			format(string, sizeof(string), "~n~ You earned $%d.", 5000);
			Dyuze(playerid, "Notice", string);

			// Add $10,000 to the ATM
			for (new i = 0; i < MAX_ATMS; i++)
			{
				if (AtmInfo[i][aExists] && AtmInfo[i][aPosX] == PlayerInfo[playerid][checkpointPosX] && AtmInfo[i][aPosY] == PlayerInfo[playerid][checkpointPosY] && AtmInfo[i][aPosZ] == PlayerInfo[playerid][checkpointPosZ])
				{
					AtmInfo[i][amoney] += 1000000; // Add $10,000 to the ATM's money
                    ReloadAtmText(i);
					new query[256];
					mysql_format(connectionID, query, sizeof(query), "UPDATE atms SET amoney = %d WHERE id = %d", AtmInfo[i][amoney], AtmInfo[i][aID]);
					mysql_tquery(connectionID, query, "", "");
					break;
				}
			}
			new dist = GetPVarInt(playerid, "dist");
			GivePlayerCash(playerid, 10000 + dist * 6);
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
			SM(playerid, COLOR_WHITE, "You received %i", 10000 + dist * 6);

			// Reset checkpoint position
			PlayerInfo[playerid][checkpointPosX] = 0.0;
			PlayerInfo[playerid][checkpointPosY] = 0.0;
			PlayerInfo[playerid][checkpointPosZ] = 0.0;

			return 1; // Remember to return 1 at the end of the case
		}
		case CHECKPOINT_CARROBBERY:
		{
			new vehicleid = PlayerInfo[playerid][pRobCar];

			DestroyVehicle(vehicleid);
			SendClientMessage(playerid, COLOR_CYAN, "[CAR-ROBBERY]: You successfully completed Car Robbery.");
			SendClientMessage(playerid, COLOR_CYAN, "[CAR-ROBBERY]: $25000 dirtymoney for delivering the illegal vehicle.");

			PlayerInfo[playerid][pRobCar] = -1;
			PlayerInfo[playerid][pDirtyCash] += 25000;
			PlayerInfo[playerid][pWantedLevel] -= 2;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
			SavePlayerVariables(playerid);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

		}
		case CHECKPOINT_MATS1:
		{
		   switch(PlayerInfo[playerid][pCourierSkill])
		  {
			case 0..49:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 1]: "RED"You have received 200 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 200;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 200 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				DisablePlayerCheckpoint(playerid);
			}
	    	case 50..99:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 2]: "RED"You have received 300 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 300;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 300 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				DisablePlayerCheckpoint(playerid);
			}
			case 100..199:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 3]: "RED"You have received 400 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 400;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 400 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				DisablePlayerCheckpoint(playerid);
			}
			case 200..349:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 4]: "RED"You have received 500 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 500;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 500 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				DisablePlayerCheckpoint(playerid);
			}
			case 350..500:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 5]: "RED"You have received 600 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 600;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 600 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				DisablePlayerCheckpoint(playerid);
			}
		  }
		}
	    case CHECKPOINT_TEST:
	    {
	        PlayerInfo[playerid][pTestCP]++;

	        if(PlayerInfo[playerid][pTestCP] < sizeof(drivingTestCPs))
	        {
	            if(!(testVehicles[0] <= GetPlayerVehicleID(playerid) <= testVehicles[2]))
	            {
					SendClientMessage(playerid, COLOR_LIGHTRED, "** You failed the test as you exited your vehicle.");
	                DisablePlayerCheckpoint(playerid);
		    		SetVehicleToRespawn(PlayerInfo[playerid][pTestVehicle]);

				    PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
		            PlayerInfo[playerid][pDrivingTest] = 0;
				}
				else
				{
		            SetPlayerCheckpoint(playerid, drivingTestCPs[PlayerInfo[playerid][pTestCP]][0], drivingTestCPs[PlayerInfo[playerid][pTestCP]][1], drivingTestCPs[PlayerInfo[playerid][pTestCP]][2], 3.0);
				}
			}
			else
			{
			    new
			        Float:health;

				GetVehicleHealth(PlayerInfo[playerid][pTestVehicle], health);

			    if(health < 900.0)
			    {
					Dyuze(playerid, "Notice", "Failed.");
			        SendClientMessage(playerid, COLOR_LIGHTRED, "** You brought back the vehicle damaged and therefore failed your test.");
			    }
			    else
			    {
                   	Dyuze(playerid, "Notice", "Passed.");
			        SendClientMessage(playerid, COLOR_GREEN, "You successfully passed your drivers test and received your license!");

			        GivePlayerCash(playerid, -10000);
			        PlayerInfo[playerid][pCarLicense] = 1;

			        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carlicense = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
			        mysql_tquery(connectionID, queryBuffer);
			    }

	    		DisablePlayerCheckpoint(playerid);
	    		SetVehicleToRespawn(PlayerInfo[playerid][pTestVehicle]);

			    PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
	            PlayerInfo[playerid][pDrivingTest] = 0;
	        }
	    }
	    case CHECKPOINT_FARMER:
	    {
	        new cost, string[128];

	        if(PlayerInfo[playerid][pWheat] == 1)
			{
	            cost = 3 * 5000;
			}

			if(gDoubleSalary)
			{
			    cost = cost*2;
			    SendClientMessage(playerid, COLOR_GREEN, "You have earned 2x of the salary.");
			}
			AddToPaycheck(playerid, cost);

			SM(playerid, COLOR_GREEN, "You have earned $%i on your paycheck for your harvest crop.", cost);
			ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0);

			format(string, sizeof(string), "~g~+$%i", cost);
			GameTextForPlayer(playerid, string, 5000, 1);

			PlayerInfo[playerid][pWheat] = 0;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);

			DisablePlayerCheckpoint(playerid);
	    }
	    case CHECKPOINT_SIGNAL:
	    {
          
            DisablePlayerCheckpoint(playerid);
	    }
	    case CHECKPOINT_MATS:
	    {
	        if((PlayerInfo[playerid][pSmuggleMats] == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2173.2129, -2264.1548, 13.3467)) || (PlayerInfo[playerid][pSmuggleMats] == 2 && IsPlayerInRangeOfPoint(playerid, 3.0, 2288.0918, -1105.6555, 37.9766)))
			{
			    if(gettime() - PlayerInfo[playerid][pSmuggleTime] < 20 && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
			    {
			        PlayerInfo[playerid][pACWarns]++;

			        if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
			        {
			            SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport matrunning (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerInfo[playerid][pSmuggleTime]);
					}
					else
					{
					    SMA(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Teleport matrun", GetRPName(playerid), SERVER_BOT);
					    //BanPlayer(playerid, SERVER_BOT, "Teleport matrun");
					    Kick(playerid);
					}
			    }

                if(PlayerInfo[playerid][pMaterials] + 150 > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
				{
	    			return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    if(PlayerInfo[playerid][pSmuggleMats] == 1) {
			        AddPointMoney(POINT_MATFACTORY1, 75);
			    } else {
			        AddPointMoney(POINT_MATFACTORY2, 75);
			    }

			    if(PlayerInfo[playerid][pGang] >= 0)
			    {
			        GiveGangPoints(PlayerInfo[playerid][pGang], 1);
				}

				if(PlayerInfo[playerid][pSmuggleMats] == 1)
				{
			        AddPointMoney(POINT_MATFACTORY1, 75);
			        PlayerInfo[playerid][pMaterials] += 500;
			    }
				else if (PlayerInfo[playerid][pSmuggleMats] == 2)
				{
			        AddPointMoney(POINT_MATFACTORY2, 75);
			        PlayerInfo[playerid][pMaterials] += 500;
			    }
		    	PlayerInfo[playerid][pSmuggleMats] = 0;
		    	PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

			    SendClientMessage(playerid, COLOR_GREEN, "You have dropped off your load and collected 500 materials from the depot.");
		    	DisablePlayerCheckpoint(playerid);

		    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
		    	mysql_tquery(connectionID, queryBuffer);
			}
	    }
	    case CHECKPOINT_HOUSE:
	    {
            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has entered the house.", GetRPName(playerid));
			SetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pInviteHouse]][hIntX], HouseInfo[PlayerInfo[playerid][pInviteHouse]][hIntY], HouseInfo[PlayerInfo[playerid][pInviteHouse]][hIntZ]);
			SetPlayerFacingAngle(playerid, HouseInfo[PlayerInfo[playerid][pInviteHouse]][hIntA]);
			SetPlayerInterior(playerid, HouseInfo[PlayerInfo[playerid][pInviteHouse]][hInterior]);
			SetPlayerVirtualWorld(playerid, HouseInfo[PlayerInfo[playerid][pInviteHouse]][hWorld]);
			SetCameraBehindPlayer(playerid);

			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
	        DisablePlayerCheckpoint(playerid);
	    }
		case CHECKPOINT_MISC:
		{
		
		    PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
	        DisablePlayerCheckpoint(playerid);
		}
     	case CHECKPOINT_BUS:
		{
		    // Jexc Realistic Bus Job, Commerce-Market
		    if(IsPlayerInRangeOfPoint(playerid, 10, 1660.959350, -1547.258178, 13.411951))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1658.022460, -1589.302612, 13.412823, 10);
	        }
	        if(IsPlayerInRangeOfPoint(playerid, 10, 1658.022460, -1589.302612, 13.412823))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1429.913085, -1592.316162, 13.420095, 10);
	        }
	        if(IsPlayerInRangeOfPoint(playerid, 10, 1429.913085, -1592.316162, 13.420095))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1326.054443, -1573.310180, 13.460653, 10);
	        }
	        if(IsPlayerInRangeOfPoint(playerid, 10, 1326.054443, -1573.310180, 13.460653))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1334.201049, -1400.769042, 13.364155, 10);
	        }
	        if(IsPlayerInRangeOfPoint(playerid, 10, 1334.201049, -1400.769042, 13.364155))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1065.049926, -1357.635620, 13.407435, 10);
	        }
	        if(IsPlayerInRangeOfPoint(playerid, 10, 1065.049926, -1357.635620, 13.407435))
	        {
	            DisablePlayerCheckpoint(playerid);
	            SetPlayerCheckpoint(playerid, 1687.551392, -1478.814331, 13.415037, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1687.551392, -1478.814331, 13.415037))
	        {
	            new string[128], vehicleid;
	            new amount = 500 + random(3500);
	            format(string, sizeof(string), "[Legal Job] You've earned $%d for your Legal work. This will be added to your Paycheck ($%i)", amount, PlayerInfo[playerid][pPaycheck]);
			    SendClientMessage(playerid, COLOR_GREY, string);
			    SetVehicleToRespawn(vehicleid);
			    GivePlayerCash(playerid, amount);
		 	    DisablePlayerCheckpoint(playerid);
				PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
				Startjob[playerid] = 0;
				PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			}
		}
		case CHECKPOINT_BUS2:
		{
		    // Jexc Realistic Bus Job, Commerce-LS Airport
		    if(IsPlayerInRangeOfPoint(playerid, 10, 1660.959350, -1547.258178, 13.411951))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1658.022460, -1589.302612, 13.412823, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1658.022460, -1589.302612, 13.412823))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1820.872192, -1612.415283, 13.414143, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1820.872192, -1612.415283, 13.414143))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1821.599365, -1730.029051, 13.411751, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1821.599365, -1730.029051, 13.411751))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1821.578247, -1915.911132, 13.409232, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1821.578247, -1915.911132, 13.409232))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1955.394165, -1932.777832, 13.410431, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1955.394165, -1932.777832, 13.410431))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1961.345092, -2050.862304, 13.433226, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1961.345092, -2050.862304, 13.433226))
		    {
			    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 1934.881958, -2149.536621, 13.575621, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1934.881958, -2149.536621, 13.575621))
		    {
		        DisablePlayerCheckpoint(playerid);
		        SetPlayerCheckpoint(playerid, 1687.551392, -1478.814331, 13.415037, 10);
			}
			if(IsPlayerInRangeOfPoint(playerid, 10, 1687.551392, -1478.814331, 13.415037))
		    {
		        new amount = 500 + random(5000);
		        new string[128], vehicleid;
		        format(string, sizeof(string), "[Legal Job] You've earned $%d for your Legal work. This will be added to your Paycheck ($%i)", amount, PlayerInfo[playerid][pPaycheck]);
			    SendClientMessage(playerid, COLOR_GREY, string);
			    SetVehicleToRespawn(vehicleid);
			    GivePlayerCash(playerid, amount);
		 	    DisablePlayerCheckpoint(playerid);
				PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
				Startjob[playerid] = 0;
				PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			}
		}
	    case CHECKPOINT_ROBBERY:
	    {
	        if(IsPlayerInBankRobbery(playerid) && PlayerInfo[playerid][pRobCash] > 0)
	        {
				if(PlayerInfo[playerid][pGang] >= 0)
				{
					GiveGangPoints(PlayerInfo[playerid][pGang], 50);
				}
				RobberyInfo[rStolen] += PlayerInfo[playerid][pRobCash];
				PlayerInfo[playerid][pDirtyCash] += PlayerInfo[playerid][pRobCash];
				gVault -= PlayerInfo[playerid][pRobCash];
				SaveServerInfo();

				SM(playerid, COLOR_GREEN, "You have earned $%i dirty cash for successfully completing the bank robbery.", PlayerInfo[playerid][pRobCash]);
				SendClientMessage(playerid, COLOR_SYNTAX, "You must wash your dirty money to convert it into real cash.");
				RemoveFromBankRobbery(playerid);
			}

			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
	    }
   	    case CHECKPOINT_ROBBERYBIZ:
	    {
			new businessid = PlayerInfo[playerid][pRobbingBiz];

			if(PlayerInfo[playerid][pGang] >= 0)
			{
				GiveGangPoints(PlayerInfo[playerid][pGang], 50);
			}

			PlayerInfo[playerid][pDirtyCash] += PlayerInfo[playerid][pRobCash];
			BusinessInfo[businessid][bCash] -= PlayerInfo[playerid][pRobCash];

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);

			SM(playerid, COLOR_GREEN, "You have earned $%i dirty cash for successfully completing the business robbery.", PlayerInfo[playerid][pRobCash]);

			BusinessInfo[businessid][bRobbed] = 3;
			BusinessInfo[businessid][bRobbing] = 0;
			ReloadBusiness(businessid);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET robbed = %i, robbing = %i WHERE id = %i", BusinessInfo[businessid][bRobbed], BusinessInfo[businessid][bRobbing], BusinessInfo[businessid][bID]);
 			mysql_tquery(connectionID, queryBuffer);

			PlayerInfo[playerid][pRobCash] = 0;
			PlayerInfo[playerid][pRobbingBiz] = -1;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
			SavePlayerVariables(playerid);
		}
   	    case CHECKPOINT_ROBBERYHOUSE:
	    {
			new houseid = PlayerInfo[playerid][pRobbingHouse];

			if(PlayerInfo[playerid][pGang] >= 0)
			{
				GiveGangPoints(PlayerInfo[playerid][pGang], 50);
			}

			PlayerInfo[playerid][pDirtyCash] += PlayerInfo[playerid][pRobCash];
			HouseInfo[houseid][hCash] -= PlayerInfo[playerid][pRobCash];

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
			mysql_tquery(connectionID, queryBuffer);

			SM(playerid, COLOR_GREEN, "You have earned $%i dirty cash for successfully completing the house robbery.", PlayerInfo[playerid][pRobCash]);

			HouseInfo[houseid][hRobbed] = 3;
			HouseInfo[houseid][hRobbing] = 0;
			ReloadHouse(houseid);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET robbed = %i, robbing = %i WHERE id = %i", HouseInfo[houseid][hRobbed], HouseInfo[houseid][hRobbing], HouseInfo[houseid][hID]);
 			mysql_tquery(connectionID, queryBuffer);

			PlayerInfo[playerid][pRobCash] = 0;
			PlayerInfo[playerid][pRobbingHouse] = -1;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
			SavePlayerVariables(playerid);
		}
		case CHECKPOINT_SANDAL:
		{
 			if(!(GetVehicleModel(GetPlayerVehicleID(playerid)) == 578 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
			    return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a Sandal Truck.");

			if(PlayerInfo[playerid][pSandal] == 1)
			{
   				if(IsPlayerInRangeOfPoint(playerid, 5.0, 1338.852661, 336.368713, 19.554687))
			    {
					GameTextForPlayer(playerid, "Unloading SandalWood....~n~Please wait.", 5000, 3);
					PlayerInfo[playerid][pSandal] = 0;
					DisablePlayerCheckpoint(playerid);
                	DestroyDynamicObject(sandelwoodveh);
                	sandelwoodveh = INVALID_OBJECT_ID;

					new amount = 40000 + random(5000);
					GivePlayerDirtyCash(playerid, amount);
					SendClientMessageEx(playerid, COLOR_AQUA, "You've earned $%i [dirtycash ]for your time working as a Sandal Driver.", amount);

					PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

	   				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}
			}
		}
	
		case CHECKPOINT_OILEXPO:
	    {
	        new cost, string[128];

	        if(PlayerInfo[playerid][pOilEx] == 1)
			{
	            cost = 5000 + random(6900);
			}

			if(gDoubleSalary)
			{
			    cost = cost*2;
			    SendClientMessage(playerid, COLOR_GREEN, "You have earned 2x of the salary.");
			}
			AddToPaycheck(playerid, cost);

			PlayerInfo[playerid][pGasCan] ++;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

			SM(playerid, COLOR_GREEN, "You have earned $%i on your paycheck for your Oil exports", cost);
			SendClientMessage(playerid, COLOR_VIP, "You receive a 1 Gascan from your oil export, keep it up!");

			format(string, sizeof(string), "~g~+$%i", cost);
			GameTextForPlayer(playerid, string, 5000, 1);

			PlayerInfo[playerid][pOilEx] = 0;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);

			DisablePlayerCheckpoint(playerid);
	    }
    	case CHECKPOINT_FRUIT:
	    {
	        new cost, string[128];

	        if(PlayerInfo[playerid][pFruitEx] == 1)
			{
	            cost = 5000 * (1 + random(20));
			}

			if(gDoubleSalary)
			{
			    cost = cost*2;
			    SendClientMessage(playerid, COLOR_GREEN, "You have earned 2x of the salary.");
			}
			AddToPaycheck(playerid, cost);


			SM(playerid, COLOR_GREEN, "You have earned $%i on your paycheck for your Fruit exports", cost);

			format(string, sizeof(string), "~g~+$%i", cost);
			GameTextForPlayer(playerid, string, 5000, 1);

			PlayerInfo[playerid][pFruitEx] = 0;
			PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;

            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);

			DisablePlayerCheckpoint(playerid);
	    }


	}

    if(PlayerInfo[playerid][pWaypoint])
    {
		PlayerInfo[playerid][pWaypoint] = 0;

		DisablePlayerCheckpoint(playerid);
		PlayerTextDrawHide(playerid, PlayerInfo[playerid][pTextdraws][1]);
	}
	return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &WEAPON:weapon, &bodypart)
{

	if(playerid != INVALID_PLAYER_ID && issuerid != INVALID_PLAYER_ID)
	{
		if((22 <= weapon <= 36) && !PlayerHasWeapon(issuerid, weapon, true) && PlayerInfo[issuerid][pAdmin] < 2 && !PlayerInfo[issuerid][pKicked])
		{
		    new
		        string[48];

			format(string, sizeof(string), "Weapon hacks (%s)", GetWeaponNameEx(weapon));

			SAM(COLOR_LIGHTRED, "AdmCmd: %s is possibly weapon hacking by %s, reason: %s", GetRPName(issuerid), SERVER_BOT, string);
			//BanPlayer(issuerid, SERVER_BOT, string);
//			Kick(playerid);
		    return 0;
		}
		if((weapon == 23) && ((IsLawEnforcement(issuerid) || GetFactionType(issuerid) == FACTION_GOVERNMENT) && PlayerInfo[issuerid][pTazer] && GetPlayerState(issuerid) == PLAYER_STATE_ONFOOT) && amount > 5.0)
		{
			if(PlayerInfo[playerid][pAdminDuty])
			{
			    SendClientMessage(issuerid, COLOR_SYNTAX, "You can't taze an administrator currently on duty.");
				return 0;
			}
			if(PlayerInfo[playerid][pTazedTime])
			{
			    SendClientMessage(issuerid, COLOR_SYNTAX, "This player has already been tazed.");
			    return 0;
			}
		
			if(!IsPlayerInRangeOfPlayer(issuerid, playerid, 40.0))
			{
			    SendClientMessage(issuerid, COLOR_SYNTAX, "You can't taze that player. They are too far from you.");
			    return 0;
			}
			if((22 <= GetPlayerWeapon(playerid) <= 38) && IsPlayerAimingEx(playerid))
			{
	  			SendClientMessage(issuerid, COLOR_SYNTAX, "Rush-tazing is forbidden. This means tazing a player who is aiming a gun at you.");
	  			return 0;
			}

			PlayerInfo[playerid][pTazedTime] = 10;
			RemovePlayerFromVehicle(playerid);
			TogglePlayerControllable(playerid, 0);

			ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0);
            PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
			Dyuze(playerid, "Notice", "Tazed.");

			new szString[128];
			format(szString, sizeof(szString), "**[Auto RP] %s aims their tazer full of electricity at %s and stuns them.", GetRPName(issuerid), GetRPName(playerid));
			SendDiscordMessage(4, szString);

			SendProximityMessage(issuerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s aims their tazer full of electricity at %s and stuns them.", GetRPName(issuerid), GetRPName(playerid));
			SM(playerid, COLOR_AQUA, "You've been "SVRCLR"stunned{CCFFFF} with electricity by %s's tazer.", GetRPName(issuerid));
			SM(issuerid, COLOR_AQUA, "You have stunned %s with electricity. They are disabled for 10 seconds.", GetRPName(playerid));
			return 0;
		}
		if (weapon == 41) 
		{
			PepperHealth[playerid] += amount;
           
			if (GetTickCount() - PepperTick[playerid] > 12000 && PepperHealth[playerid] > 4.0) 
			{
				TogglePlayerControllable(playerid, false);
				SCMf(playerid, COLOR_RED, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] You have been pepper-sprayed! You cannot see or move for 12 seconds.");
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s PepperSprayed %s", GetRPName(issuerid), GetRPName(playerid));
				PlayerTextDrawShow(playerid, BLACK[playerid][0]);
				SetTimerEx("delayadd", 11000, false, "ii", playerid, 1);
				SetTimerEx("UnfreezePlayerEx", 12000, false, "d", playerid);

				PepperTick[playerid] = GetTickCount();
				PepperHealth[playerid] = 0.0;
			}
		}
		if(gettime() - PlayerInfo[playerid][pLastUpdate] >= 3 && !PlayerInfo[playerid][pHurt])
		{
		    GameTextForPlayer(issuerid, "The player is AFK!", 5000, 3);
		    return 0;
		}
		if(PlayerInfo[issuerid][pFreezeTimer] != -1)
		{
		    PlayerInfo[issuerid][pFreezeTimer] = -1;
		}
		if(PlayerInfo[playerid][pInjured])
		{
            GameTextForPlayer(issuerid, "That player is injured", 2000, 5);
            return 0;
		}

		if(IsPlayerInRangeOfPoint(playerid, 150.0, 1144.7922, 2620.3928, 1049.8481) && !IsLawEnforcement(issuerid))
		{
		    new Float:iPos[3];
		    GameTextForPlayer(issuerid, "~r~Shooting ~w~inside the ~g~Casino ~w~is ~r~prohibited.", 5000, 3);
			GetPlayerPos(playerid, iPos[0], iPos[1], iPos[2]);
      		PlayerInfo[issuerid][pFreezeTimer] = SetTimerEx("UnfreezePlayer", 3000, false, "ifff", issuerid, iPos[0], iPos[1], iPos[2]);
    		TogglePlayerControllable(issuerid, false);

		    return 0;
  		}
		if(!PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pPaintball] == 0 && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[issuerid][pAdminDuty])
		{
			PlayerInfo[playerid][pHurt] = 60;
		}
	}
	if(GetHealth(playerid) < 49.0 && !IsPlayerNPC(playerid) && !pBlood[playerid])
	{
    	ShowBlood(playerid, 2);
    	pBlood[playerid] = true;
    }
    if (issuerid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID)
    {
        if (PlayerInfo[playerid][pHelmet] == 0)
        {
            if (bodypart == 9 && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
            {
               amount += 8;
               //SM(issuerid, COLOR_SYNTAX, "You hit %s's head therefore the damage was added by 5", GetRPName(playerid));
            }
        }
        else
        {
           if (bodypart == 9)
           {
                if (PlayerInfo[playerid][pHelmet] >= 5)
                {
                  PlayerInfo[playerid][pHelmet] -= 10;
				  amount += -7;
                  SetPlayerProgressBarValue(playerid, helmetbar,PlayerInfo[playerid][pHelmet]);

                }
                else
                {
                   PlayerInfo[playerid][pHelmet] = 0;
                   SendClientMessage(playerid,COLOR_RED,"Helmet Damaged");
                   
	            }
		   }

        }
        
    }
	return 1;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, WEAPON:weapon, bodypart)
{
	if(playerid != INVALID_PLAYER_ID && issuerid != INVALID_PLAYER_ID) // MOTHERFUCKER
	{
		if(IsPlayerConnected(issuerid))
		{
		    if(weapon == 4 && PlayerHasWeapon(issuerid, 4) && IsPlayerInRangeOfPlayer(playerid, issuerid, 20.0) && amount > 100.0)
		    {
		        DamagePlayer(playerid, 300, issuerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
		        HandleContract(playerid, issuerid);
		        new szString[128];
				format(szString, sizeof(szString), "**[Auto RP] %s has damaging %s.", GetRPName(playerid), issuerid);
				SendDiscordMessage(15, szString);
		    }
	        if(weapon == 31 && PlayerHasWeapon(issuerid, 31) && bodypart == 9) {
           // SM(issuerid, COLOR_LIGHTGREEN, "You had shot on %s head.", GetRPName(playerid));
				new headstring1[61];
				format(headstring1, sizeof(headstring1), "~r~HEADSHOT");
				Dyuze(issuerid, "Notice", headstring1);
				
				new szString[128];
				format(szString, sizeof(szString), "%s was headshot by %s.", GetRPName(playerid), GetRPName(issuerid));
				SendDiscordMessage(15, szString);
		    }
		
		}
	}
	return 1;
}

stock ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[]) {
    SetPVarInt(playerid, "dialog", dialogid);
    ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);

    return 1;
}
stock IsASinyal(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2, 609.7753,-1782.9929,18.7570) ||
		IsPlayerInRangeOfPoint(playerid, 2, 929.3642,-1415.3500,17.9962) ||
		IsPlayerInRangeOfPoint(playerid, 2, 1971.0820,-1826.2044,18.1881) ||
		IsPlayerInRangeOfPoint(playerid, 2, 2175.7668,-1730.8120,18.4971) ||
		IsPlayerInRangeOfPoint(playerid, 2, 851.1854,-1038.8979,30.4627)) return true;
	else return false;
}


stock CanPlayerCbug(playerid)
{
    if((23 <= GetPlayerWeapon(playerid) <= 25) || GetPlayerWeapon(playerid) == 34)
	{
     	if(PlayerInfo[playerid][pPaintball] == 0 && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID && !(PlayerInfo[playerid][pJoinedEvent] && EventInfo[eCS]))
		{
	    	return 0;
		}
	}
 	return 1;
}

public OnPlayerSelectionMenuResponse(playerid, extraid, response, listitem, modelid)
{
	switch(extraid)
	{
   	    case MODEL_SELECTION_CLOTHES:
	    {
	        if(response)
	        {
		        new
					businessid = GetInsideBusiness(playerid);

		        if(businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
		        {
		            if(BusinessInfo[businessid][bProducts] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock.");
		            }
		            if(PlayerInfo[playerid][pVIPPackage] == 0 && PlayerInfo[playerid][pCash] < 50)
	                {
	                    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy new clothes.");
	                }
					if((PlayerInfo[playerid][pVIPPackage] == 0 && GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC) && (!(0 <= modelid <= 311) || (265 <= modelid <= 267) || (274 <= modelid <= 288) || (300 <= modelid <= 302) || (306 <= modelid <= 311)))
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not allowed to use that skin as it is either invalid or faction reserved.");
					}

					if(PlayerInfo[playerid][pVIPPackage] == 0)
					{
					    new price = BusinessInfo[businessid][bPrices][0];

						GivePlayerCash(playerid, -price);

						BusinessInfo[businessid][bCash] += price;
	                	BusinessInfo[businessid][bProducts]--;

	                	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                	mysql_tquery(connectionID, queryBuffer);

	                	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid %s to the shopkeeper and received a new set of clothes.", GetRPName(playerid), FormatNumber(price));
	             		SM(playerid, COLOR_WHITE, "You've changed your clothes for $%i.", price);
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You changed your clothes free of charge.");
					}
				    SetScriptSkin(playerid, modelid);				    
		        }
			}
	    }	
   	    case MODEL_SELECTION_CLOTHING:
	    {
	        if(response)
	        {
	            new businessid = GetInsideBusiness(playerid);

	            if(businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
	            {
					PreviewClothing(playerid, listitem + PlayerInfo[playerid][pClothingIndex]);
				}
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
			}
	    }
	    case MODEL_SELECTION_LANDOBJECTS:
	    {
	        if(response)
	        {
	            new landid = GetNearbyLand(playerid);

		    	if(landid >= 0 && HasLandPerms(playerid, landid))
				{
					PurchaseLandObject(playerid, landid, listitem + PlayerInfo[playerid][pFurnitureIndex]);
				}
			}
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_LANDBUILD1);
			}
	    }
	}

	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	// Finally... an end to that ANNOYING spectate bug!

	foreach (new i : Player) {
		if (PlayerInfo[i][pSpectating] == playerid) {
			SetPlayerInterior(i, newinteriorid);
  		}
	}
   
	if((newinteriorid == 0) && IsPlayerInBankRobbery(playerid))
	{
	    PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
	}

	return 1;
}

stock SpeedVehicle(playerid)
{
	new Float:ST[4];
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);

	ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.0;
	return floatround(ST[3]);
}
new lastweapon1[MAX_PLAYERS];

public OnPlayerUpdate(playerid)
{
	new index = GetPlayerAnimationIndex(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	new tick = GetTickCount();

    if(PlayerInfo[playerid][pKicked]) return 0;
	if(!PlayerInfo[playerid][pLogged]) return 1;
	
	
	new keys, ud, lr, string[128];
	GetPlayerKeys(playerid, keys, ud, lr);
	if(PlayerInfo[playerid][pHospital] && GetPlayerAnimationIndex(playerid) != 385) ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	if(tick - PlayerUpdateMoneyTick[playerid] >= 1000)
	{
		if(GetPlayerMoney(playerid) != PlayerInfo[playerid][pCash])
		{
		    ResetPlayerMoney(playerid);
		    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
		}
		if(GetPlayerScore(playerid) != PlayerInfo[playerid][pLevel])
		{
		    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
		}
		PlayerUpdateMoneyTick[playerid] = tick;
	}
	if((GetPlayerAnimationIndex(playerid) != 1209) && ((PlayerInfo[playerid][pInjured] && GetVehicleModel(GetPlayerVehicleID(playerid)) != 416) || (PlayerInfo[playerid][pTazedTime] > 0 && PlayerInfo[playerid][pDraggedBy] == INVALID_PLAYER_ID)))
	{
	    ApplyAnimationEx(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0);
	}
	if(GetPlayerWeapon(playerid) > 1 && PlayerInfo[playerid][pInjured])
	{
		SetPlayerArmedWeapon(playerid, 0);
	}
	if(tick - PlayerUpdateTimeTick[playerid] >= 5000)
	{
	    if(!GetPlayerInterior(playerid))
		{
	     	SetPlayerTime(playerid, gWorldTime, 0);
		}
		else
		{
		    new garageid;

			if((garageid = GetInsideGarage(playerid)) >= 0 && GarageInfo[garageid][gType] == 2)
			    SetPlayerTime(playerid, 0, 0);
		    else
	          	SetPlayerTime(playerid, 12, 0);
		}
		PlayerUpdateTimeTick[playerid] = tick;
	}


	if(GetPlayerWeaponState(playerid) == WEAPONSTATE_RELOADING)
	{
	    if(GetPlayerWeapon(playerid) != 25 && GetPlayerWeapon(playerid) != 33 && GetPlayerWeapon(playerid) != 34)
	    {
		    PlayerInfo[playerid][pReloading] = 1;
		}

	    PlayerInfo[playerid][pACFired] = 0;
	}
	if (GetPlayerWeapon(playerid) == 41 && GetPlayerAmmo(playerid) > 0) 
	{
		PlayerInfo[playerid][pPepperAmmo] = GetPlayerAmmo(playerid);
	} 
	else 
	{
		PlayerInfo[playerid][pPepperSpray] = 0;
		PlayerInfo[playerid][pPepperAmmo] = 0;
	}


	if(PlayerInfo[playerid][pReloading] && GetPlayerWeaponState(playerid) != WEAPONSTATE_RELOADING)
	{
		PlayerInfo[playerid][pClip] = GetWeaponClipSize(GetPlayerWeapon(playerid));
		PlayerInfo[playerid][pReloading] = 0;
	}

	if(PlayerInfo[playerid][pCurrentVehicle] != vehicleid)
	{
	    PlayerInfo[playerid][pCurrentVehicle] = vehicleid;
	    PlayerInfo[playerid][pVehicleCount]++;

	    if((!IsABoat(vehicleid) && GetVehicleModel(vehicleid) != 539) && PlayerInfo[playerid][pVehicleCount] >= 4 && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
	    {
	        SAM(COLOR_YELLOW, "%s possibly using bulalacars. [SPEC PLAYER]", GetRPName(playerid));
			PlayerInfo[playerid][pACWarns]++;
			if(PlayerInfo[playerid][pACWarns] >= MAX_ANTICHEAT_WARNINGS){
				SAM(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Crasher", GetRPName(playerid), SERVER_BOT);
		    	KickPlayer(playerid);
			}
	        return 0;
		}
	}

	if(tick - armedbody_pTick[playerid] > 300){ //prefix check itter
        new
            weaponid[13],weaponammo[13],pArmedWeapon;
        pArmedWeapon = GetPlayerWeapon(playerid);
        GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
        GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
        GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
        GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
        #if ARMEDBODY_USE_HEAVY_WEAPON
        GetPlayerWeaponData(playerid,7,weaponid[7],weaponammo[7]);
        #endif
        if(weaponid[1] && weaponammo[1] > 0){
            if(pArmedWeapon != weaponid[1]){
                if(!IsPlayerAttachedObjectSlotUsed(playerid,0)){
                    SetPlayerAttachedObject(playerid,0,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                }
            }
            else {
                if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
                    RemovePlayerAttachedObject(playerid,0);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
            RemovePlayerAttachedObject(playerid,0);
        }
        if(weaponid[2] && weaponammo[2] > 0){
            if(pArmedWeapon != weaponid[2]){
                if(!IsPlayerAttachedObjectSlotUsed(playerid,1)){
                    SetPlayerAttachedObject(playerid,1,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                }
            }
            else {
                if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
                    RemovePlayerAttachedObject(playerid,1);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
            RemovePlayerAttachedObject(playerid,1);
        }
        if(weaponid[4] && weaponammo[4] > 0){
            if(pArmedWeapon != weaponid[4]){
                if(!IsPlayerAttachedObjectSlotUsed(playerid,2)){
                    SetPlayerAttachedObject(playerid,2,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                }
            }
            else {
                if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
                    RemovePlayerAttachedObject(playerid,2);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
            RemovePlayerAttachedObject(playerid,2);
        }
        if(weaponid[5] && weaponammo[5] > 0){
            if(pArmedWeapon != weaponid[5]){
                if(!IsPlayerAttachedObjectSlotUsed(playerid,3)){
                    SetPlayerAttachedObject(playerid,3,GetWeaponModel(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                }
            }
            else {
                if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
                    RemovePlayerAttachedObject(playerid,3);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
            RemovePlayerAttachedObject(playerid,3);
        }
        #if ARMEDBODY_USE_HEAVY_WEAPON
        if(weaponid[7] && weaponammo[7] > 0){
            if(pArmedWeapon != weaponid[7]){
                if(!IsPlayerAttachedObjectSlotUsed(playerid,4)){
                    SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1,-0.100000, 0.000000, -0.100000, 84.399932, 112.000000, 10.000000, 1.099999, 1.000000, 1.000000);
                }
            }
            else {
                if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
                    RemovePlayerAttachedObject(playerid,4);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
            RemovePlayerAttachedObject(playerid,4);
        }
        #endif
        armedbody_pTick[playerid] = GetTickCount();
    }

	if((44 <= GetPlayerWeapon(playerid) <= 45) && keys & KEY_FIRE)
	{
	    return 0;
	}
	
	if (!PlayerInfo[playerid][pToggleHUD] && !PlayerInfo[playerid][pToggleTextdraws] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && tick - PlayerUpdateHudTick[playerid] >= 250) 
	{
		PlayerUpdateHudTick[playerid] = tick;
		new Float:health, Float:armour, helmet;
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);
		helmet = PlayerInfo[playerid][pHelmet];

		// ARMOUR TextDraw
		if (armour > 0.0) 
		{
			format(string, sizeof(string), "ARMORY:%.0f%%", armour);
			DynamicPlayerTextDrawSetString(playerid, VALO[playerid][15], string);
			PlayerTextDrawShow(playerid, VALO[playerid][15]);
		} 
		else 
		{
			PlayerTextDrawHide(playerid, VALO[playerid][15]);
		}

		// HELMET TextDraw
		if (helmet > 0) 
		{
			format(string, sizeof(string), "HELMET:%i%%", helmet);
			DynamicPlayerTextDrawSetString(playerid, VALO[playerid][16], string);
			PlayerTextDrawShow(playerid, VALO[playerid][16]);
		} 
		else 
		{
			PlayerTextDrawHide(playerid, VALO[playerid][16]);
		}

		// HEALTH TextDraw
		format(string, sizeof(string), "HEALTH:%.0f%%", health);
		DynamicPlayerTextDrawSetString(playerid, VALO[playerid][14], string);

		// CLIP/RELOADING TextDraw
		if (PlayerInfo[playerid][pReloading]) 
		{
			DynamicPlayerTextDrawSetString(playerid, VALO[playerid][12], "0");
		} 
		else 
		{
			format(string, sizeof(string), "%i", PlayerInfo[playerid][pClip]);
			DynamicPlayerTextDrawSetString(playerid, VALO[playerid][12], string);
		}

		// WEAPON MODEL TextDraw
		new weaponid = GetScriptWeapon(playerid);
		if (weaponid > 0) 
		{
			if (lastweapon1[playerid] != weaponid) 
			{
				PlayerTextDrawHide(playerid, VALO[playerid][5]);
				PlayerTextDrawSetPreviewModel(playerid, VALO[playerid][5], weaponModelIDs[weaponid]);
				PlayerTextDrawShow(playerid, VALO[playerid][5]);
				lastweapon1[playerid] = weaponid;
			}
		} 
		else if (lastweapon1[playerid] != 0) 
		{
			PlayerTextDrawHide(playerid, VALO[playerid][5]);
			lastweapon1[playerid] = 0;
		}
	}

	if(PlayerInfo[playerid][pAnimation] != index)
	{
	    if(PlayerInfo[playerid][pLockBreak] != INVALID_VEHICLE_ID)
	    {
	        vehicleid = PlayerInfo[playerid][pLockBreak];

	        if(!IsValidVehicle(vehicleid) || VehicleInfo[vehicleid][vOwnerID] == 0)
	        {
	            SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as it despawned.");
				CancelBreakIn(playerid);
	        }
	        else if(GetNearbyVehicle(playerid) != vehicleid)
	        {
	            SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as you left its location.");
				CancelBreakIn(playerid);
	        }
	        else if(VehicleInfo[vehicleid][vLocked] == 0)
	        {
	            SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as it was unlocked.");
	            CancelBreakIn(playerid);
	        }
	        else if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	        {
	            SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as you aren't onfoot.");
	            CancelBreakIn(playerid);
	        }
	        else
	        {
			    switch(index)
			    {
					case 17..19, 1545..1547, 312..314, 1136..1138, 472..474, 482..484, 494..496, 504..505, 1165:
					{
					    if(IsValidVehicle(vehicleid) && (IsPlayerAtVehicleDoor(playerid, vehicleid, DOOR_DRIVER) || IsPlayerAtVehicleDoor(playerid, vehicleid, DOOR_PASSENGER)))
					    {
					        new
					            damage[4];

					        GetVehicleDamageStatus(vehicleid, damage[0], damage[1], damage[2], damage[3]);

							if(2 <= GetPlayerWeapon(playerid) <= 9)
							    PlayerInfo[playerid][pLockHealth] -= 20.0;
					        else
								PlayerInfo[playerid][pLockHealth] -= 10.0;

					        if(PlayerInfo[playerid][pLockHealth] <= 0)
					        {
					            VehicleInfo[vehicleid][vLocked] = 0;

								SetVehicleParams(vehicleid, VEHICLE_DOORS, false);
						        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

								GameTextForPlayer(playerid, "~g~Vehicle unlocked!", 3000, 6);
								SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s successfully kicked down the door of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

								CancelBreakIn(playerid);
								UpdateVehicleDamageStatus(vehicleid, damage[0], 262144, damage[2], damage[3]);
					        }
					        else
					        {
								new
								    Float:x,
								    Float:y,
								    Float:z,
									garageid = GetVehicleGarage(vehicleid);

		      					if(!GetVehicleParams(vehicleid, VEHICLE_ALARM))
		      					{
		      					    if(VehicleInfo[vehicleid][vAlarm] > 0)
									{
										foreach(new i : Player)
		      					    	{
		      					        	if(IsVehicleOwner(i, vehicleid))
		      					        	{
		      					        	    SM(i, COLOR_YELLOW, "** SMS from OnStar: The alarm was activated on your %s located in %s, Ph: 999 **", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
											}

											if(GetFactionType(i) == FACTION_POLICE || GetFactionType(i) == FACTION_NPOLICE)
											{
												if(VehicleInfo[vehicleid][vAlarm] == 2)
												{
												    SM(i, COLOR_ROYALBLUE, "** HQ: The alarm was activated on %s's %s in %s. **", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			      					            }
			      					            else if(VehicleInfo[vehicleid][vAlarm] == 3)
												{
												    if(PlayerInfo[playerid][pCP] == CHECKPOINT_NONE)
												    {
												        PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

												        if(garageid >= 0)
														{
													        SetPlayerCheckpoint(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
												        }
														else
														{
												            GetVehiclePos(vehicleid, x, y, z);
												            SetPlayerCheckpoint(playerid, x, y, z, 3.0);
												        }
												    }

												    SM(i, COLOR_ROYALBLUE, "** HQ: The alarm was activated on %s's %s in %s (marked on map). **", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			      					            }
		      					            }
		      					        }
		      					    }

		      					    SetVehicleParams(vehicleid, VEHICLE_ALARM, true);
								}

		                        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, z);
		                        UpdateVehicleDamageStatus(vehicleid, damage[0], 131072, damage[2], damage[3]);

								format(string, sizeof(string), "%.0f HP", PlayerInfo[playerid][pLockHealth]);

								if(PlayerInfo[playerid][pLockText] == Text3D:INVALID_3DTEXT_ID)
								{
								    if(IsPlayerAtVehicleDoor(playerid, PlayerInfo[playerid][pLockBreak], DOOR_DRIVER)) {
									    PlayerInfo[playerid][pLockText] = CreateDynamic3DTextLabel(string, COLOR_GREEN, -x * 2, y + 0.25, z, 5.0, .attachedvehicle = vehicleid);
									} else if(IsPlayerAtVehicleDoor(playerid, PlayerInfo[playerid][pLockBreak], DOOR_PASSENGER)) {
									    PlayerInfo[playerid][pLockText] = CreateDynamic3DTextLabel(string, COLOR_GREEN, x * 2, y + 0.25, z, 5.0, .attachedvehicle = vehicleid);
									}
								}
								else
								{
								    UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pLockText], COLOR_GREEN, string);
								}

								KillTimer(PlayerInfo[playerid][pLockTimer]);
								PlayerInfo[playerid][pLockTimer] = SetTimerEx("DestroyLockText", 5000, false, "i", playerid);
							}
					    }
					}
			    }
			}
		}

	    PlayerInfo[playerid][pAnimation] = index;
	}
	
	if (tick - PlayerUpdateSafezoneTick[playerid] >= 750 && IsPlayerConnected(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) 
	{
		PlayerUpdateSafezoneTick[playerid] = tick;
		if (PlayerInfo[playerid][pSafezoneEnter] < 2) 
		{
			if (IsPlayerAtGreenZone(playerid)) 
			{
				if (PlayerInfo[playerid][pSafezoneEnter] == 0) 
				{
					if(gNotification)
						notification_show(playerid, str_format("You have entered a SafeZone."));	
					else
					SCMf(playerid, COLOR_GREEN, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] You have entered a SafeZone.");
					PlayerInfo[playerid][pSafezoneEnter] = 1;
					return 1;
				}
			} 
			else 
			{
				if (PlayerInfo[playerid][pSafezoneEnter] == 1) 
				{
					if(gNotification)
						notification_show(playerid, str_format("You have exited the SafeZone"));	
					else
					    SCMf(playerid, COLOR_RED, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] You have exited the SafeZone.");
					PlayerInfo[playerid][pSafezoneEnter] = 0;
					return 1;
				}
			}
		}
	}

	Corpse_OnPlayerUpdate(playerid);
	PlayerInfo[playerid][pLastUpdate] = gettime();

	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
	    VehicleInfo[vehicleid][vColor1] = color1;
	    VehicleInfo[vehicleid][vColor2] = color2;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
	    VehicleInfo[vehicleid][vPaintjob] = paintjobid;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(!GetPlayerInterior(playerid) && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
	{
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Illegal modding", GetRPName(playerid), SERVER_BOT);
	    //BanPlayer(playerid, SERVER_BOT, "Illegal modding");
	    Kick(playerid);
	    return 0;
	}

	if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
	    new slotid = GetVehicleComponentType(componentid);

	    VehicleInfo[vehicleid][vMods][slotid] = componentid;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_%i = %i WHERE id = %i", slotid + 1, componentid, VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(adminVehicle{vehicleid})
	{
	    DestroyVehicleEx(vehicleid);
	    adminVehicle{vehicleid} = false;
	}
	if(IsValidDynamicObject(vehicleSiren[vehicleid]))
	{
	    DestroyDynamicObject(vehicleSiren[vehicleid]);
	    vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
	}
	if(IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
		vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
		DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
	}
   
	if((VehicleInfo[vehicleid][vID] > 0 && VehicleInfo[vehicleid][vOwnerID] > 0) || (VehicleInfo[vehicleid][vGang] >= 0))
	{
	    ReloadVehicle(vehicleid);

	    if(VehicleInfo[vehicleid][vGang] >= 0)
	    {
	        vehicleFuel[vehicleid] = 100;
         	Milliage[vehicleid] = 0;
		}
	}
	else
	{
     	if(VehicleInfo[vehicleid][vID] > 0 && VehicleInfo[vehicleid][vHealth] > 300.0)
     	{
    		SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
     	}
        Milliage[vehicleid] = 0;
		vehicleFuel[vehicleid] = 100;
	}
	vehicleStream[vehicleid][0] = 0;
	return 1;
}
public OnPlayerText(playerid, text[])
{
    if (playerid < 0 || playerid >= MAX_PLAYERS) return 0;  // Validate playerid range
    if (text[0] == EOS) return 0; // Ensure text is not empty

    // Ensure PlayerInfo and other arrays are correctly initialized before use
    if (PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pKicked])
    {
        if (PlayerInfo[playerid][pHospital])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "** You are currently in the hospital. Chatting is disabled.");
            return 0;
        }
        if (PlayerInfo[playerid][pMuted])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "** You are currently muted. Chatting is disabled.");
            return 0;
        }
        if (++PlayerInfo[playerid][pSpamTime] >= 4 && PlayerInfo[playerid][pAdmin] < 2)
        {
            PlayerInfo[playerid][pMuted] = 10;
            SendClientMessage(playerid, COLOR_YELLOW, "** You've been temporarily muted for ten seconds due to suspected spamming.");
            return 0;
        }
        if (PlayerInfo[playerid][pAdmin] < 12 && CheckServerAd(text))
        {
            new string[128];
            format(string, sizeof(string), "{AA3333}AdWarning{FFFF00}: %s (ID: %d): '{AA3333}%s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, text);
            SAM(COLOR_YELLOW, string, 2);
            // //Log_Write("logs/hack.log", string);
            if (++PlayerInfo[playerid][pAdvertWarnings] > MAX_ANTICHEAT_WARNINGS)
            {
                SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Server advertisement", GetRPName(playerid), SERVER_BOT);
                // BanPlayer(playerid, SERVER_BOT, "Server advertisement");
                Kick(playerid);
            }
            return 0;
        }

        if (Maskara[playerid])
        {
            new string[128]; // String of GOD
            format(string, sizeof(string), "Stranger(B%d): %s", MaskaraID[playerid], text);

            SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
            SetPlayerBubbleText(playerid, 20.0, COLOR_GREY1, "(Says) %s", text);
            return 0;
        }

        if (PlayerInfo[playerid][pJoinedEvent])
        {
            foreach (new i : Player)
            {
                if (PlayerInfo[i][pJoinedEvent])
                {
                    if (EventInfo[eType] == 2)
                    {
                        SM(i, COLOR_LIGHTORANGE, "(( {%06x}%s:{F7A763} %s ))", GetPlayerColor(playerid) >>> 8, GetRPName(playerid), text);
                    }
                    else
                    {
                        SM(i, COLOR_LIGHTORANGE, "(( %s: %s ))", GetRPName(playerid), text);
                    }
                }
            }
        }
        else
        {
            new string[144];

            if (PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
            {
                if (PlayerInfo[playerid][pCallLine] != playerid && PlayerInfo[playerid][pCallStage] == 2)
                {
                    if (!strcmp(PlayerInfo[playerid][pAccent], "None", true))
                    {
                        SM(PlayerInfo[playerid][pCallLine], COLOR_YELLOW, "(cellphone) %s: %s", GetRPName(playerid), text);
                    }
                    else
                    {
                        SM(PlayerInfo[playerid][pCallLine], COLOR_YELLOW, "(%s) (cellphone) %s: %s", PlayerInfo[playerid][pAccent], GetRPName(playerid), text);
                    }
                }

                if (!strcmp(PlayerInfo[playerid][pAccent], "None", true))
                {
                    format(string, sizeof(string), "(cellphone) %s: %s", GetRPName(playerid), text);
                }
                else
                {
                    format(string, sizeof(string), "(%s) (cellphone) %s: %s", PlayerInfo[playerid][pAccent], GetRPName(playerid), text);
                }

                SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

                if (PlayerInfo[playerid][pCallLine] == playerid)
                {
                    switch (PlayerInfo[playerid][pCallStage])
                    {
                        case 911:
                        {
                            if (!strcmp(text, "police", true))
                            {
                                SendClientMessage(playerid, COLOR_DISPATCH, "This is the Los Santos Police Department. What is your emergency?");
                                PlayerInfo[playerid][pCallStage] = 912;
                            }
                            else if (!strcmp(text, "medic", true))
                            {
                                SendClientMessage(playerid, COLOR_DISPATCH, "This is the Los Santos Fire & Medical Department. What is your emergency?");
                                PlayerInfo[playerid][pCallStage] = 913;
                            }
                            else
                            {
                                SendClientMessage(playerid, COLOR_DISPATCH, "Sorry? I don't know what you mean... Enter 'police' or 'medic'.");
                            }

                        }
                        case 912:
                        {
                            foreach (new i : Player)
                            {
                                if (IsLawEnforcement(i))
                                {
                                    SM(i, COLOR_ROYALBLUE, "Emergency Hotline:");
                                    SM(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerInfo[playerid][pPhone]);
                                    SM(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
                                    SM(i, COLOR_GREY2, "Emergency: %s", text);
                                    SM(i, COLOR_WHITE, "** Use '/trackcall %i' to track the caller's location.", playerid);
                                }
                            }

                            strcpy(PlayerInfo[playerid][pEmergency], text, 128);
                            PlayerInfo[playerid][pEmergencyCall] = 120;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_POLICE;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_FEDERAL;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_ARMY;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_NPOLICE;

                            SendClientMessage(playerid, COLOR_DISPATCH, "All units in the area have been notified. Thank you for your time.");
                            HangupCall(playerid, HANGUP_USER);

                        }
                        case 913:
                        {
                            foreach (new i : Player)
                            {
                                if (GetFactionType(i) == FACTION_MEDIC)
                                {
                                    SM(i, COLOR_DOCTOR, "Emergency Hotline:");
                                    SM(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerInfo[playerid][pPhone]);
                                    SM(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
                                    SM(i, COLOR_GREY2, "Emergency: %s", text);
                                    SM(i, COLOR_WHITE, "** Use '/trackcall %i' to track the caller's location.", playerid);
                                }
                            }

                            strcpy(PlayerInfo[playerid][pEmergency], text, 128);
                            PlayerInfo[playerid][pEmergencyCall] = 120;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_MEDIC;

                            SendClientMessage(playerid, COLOR_DISPATCH, "All units in the area have been notified. Thank you for your time.");
                            HangupCall(playerid, HANGUP_USER);

                        }
                        case 6397:
                        {
                            foreach (new i : Player)
                            {
                                if (GetFactionType(i) == FACTION_NEWS)
                                {
                                    SM(i, SERVER_COLOR, "News Hotline:");
                                    SM(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerInfo[playerid][pPhone]);
                                    SM(i, COLOR_GREY2, "Message: %s", text);
                                }
                            }

                            SendClientMessage(playerid, SERVER_COLOR, "News Team: Thank you. We will get back to you shortly!");
                            HangupCall(playerid, HANGUP_USER);

                        }
                        case 6324:
                        {
                            foreach (new i : Player)
                            {
                                if (GetFactionType(i) == FACTION_MECHANIC)
                                {
                                    SM(i, COLOR_DOCTOR, "Mechanic Hotline:");
                                    SM(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerInfo[playerid][pPhone]);
                                    SM(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
                                    SM(i, COLOR_GREY2, "Message: %s", text);
                                    SM(i, COLOR_WHITE, "** Use '/trackcall %i' to track the caller's location.", playerid);
                                }
                            }

                            strcpy(PlayerInfo[playerid][pEmergency], text, 128);
                            PlayerInfo[playerid][pEmergencyCall] = 120;
                            PlayerInfo[playerid][pEmergencyType] = FACTION_MECHANIC;

                            SendClientMessage(playerid, COLOR_DISPATCH, "Thank you. We will alert all mechanics on duty.");
                            HangupCall(playerid, HANGUP_USER);

                        }
                    }
                }
            }
            else if (PlayerInfo[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
            {
                foreach (new i : Player)
                {
                    if (!PlayerInfo[i][pToggleNews])
                    {
                        if (GetFactionType(playerid) == FACTION_NEWS)
                        {
                            SM(i, 0x489348FF, "Live Reporter %s: %s", GetRPName(playerid), text);
                        }
                        else
                        {
                            SM(i, 0x489348FF, "Live Guest %s: %s", GetRPName(playerid), text);
                        }
                    }
                }

                // SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
            }
            else
            {
                if (PlayerInfo[playerid][pHelper] > 0 && PlayerInfo[playerid][pAcceptedHelp])
                {
                    callcmd::b(playerid, text);
                }
                else if (IsPlayerInAnyVehicle(playerid) && CarWindows[GetPlayerVehicleID(playerid)])
                {
                    foreach (new i : Player)
                    {
                        if (IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
                        {
                            if (!strcmp(PlayerInfo[playerid][pAccent], "None", true))
                            {
                                SM(i, COLOR_GREY1, "(windows) %s says: %s", GetRPName(playerid), text);
                            }
                            else
                            {
                                SM(i, COLOR_GREY1, "(windows) (%s) %s says: %s", PlayerInfo[playerid][pAccent], GetRPName(playerid), text);
                            }
                        }
                    }
                }
                else
                {
                    new string2[144];
                    if (!strcmp(PlayerInfo[playerid][pAccent], "None", true))
                    {
                        format(string, sizeof(string), "%s says: %s", GetRPName(playerid), text);
                        format(string2, sizeof(string2), "says: %s", text);
                    }
                    else
                    {
                        format(string, sizeof(string), "(%s) %s says: %s", PlayerInfo[playerid][pAccent], GetRPName(playerid), text);
                        format(string2, sizeof(string2), "says: %s", text);
                    }

                    SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
                    SetPlayerBubbleText(playerid, 20.0, COLOR_GREY1, "(Says) %s", text);
                }
            }
        }
    }
    new szString[128];
    format(szString, sizeof(szString), " >**%s Say's**: %s", GetRPName(playerid), text);
    SendDiscordMessage(16, szString);

    PlayerInfo[playerid][pAFKPos][0] = 0.0;
    PlayerInfo[playerid][pAFKPos][1] = 0.0;
    PlayerInfo[playerid][pAFKPos][2] = 0.0;
    return 0;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(PlayerInfo[playerid][pKicked]) return 0;

	if(!PlayerInfo[playerid][pLogged])
	{
	    SendClientMessage(playerid, COLOR_RED, "You cannot use commands if you're not logged in.");
		return 0;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "** You are currently dead. Commands are disabled.");
    	return 0;
	}
	if(PlayerInfo[playerid][pMuted])
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "** You are currently muted. Commands are disabled.");
        return 0;
	}
	if(++PlayerInfo[playerid][pSpamTime] >= 4 && PlayerInfo[playerid][pAdmin] < 2)
	{
	    PlayerInfo[playerid][pMuted] = 10;
	    SendClientMessage(playerid, COLOR_YELLOW, "** You've been temporarily muted for ten seconds due to suspected flooding.");
	    return 0;
	}
	if(PlayerInfo[playerid][pAdmin] < 12 && CheckServerAd(params))
	{
		new string[128];
		format(string,sizeof(string),"{AA3333}AdWarning{FFFF00}: %s (ID: %d): '{AA3333}/%s %s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, cmd, params);
		SAM(COLOR_YELLOW, string, 2);
		////Log_Write("logs/hack.log", string);
        PlayerInfo[playerid][pAdvertWarnings] ++;
		return 0;
	}
	new szString[128];
	format(szString,sizeof(szString),"[cmd] [%s](uid: %d):%s %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], cmd, params);
	SendDiscordMessage(14, szString);
	
	PlayerInfo[playerid][pAFKPos][0] = 0.0;
    PlayerInfo[playerid][pAFKPos][1] = 0.0;
    PlayerInfo[playerid][pAFKPos][2] = 0.0;
	return 1;
}

ShowTurfTD(playerid)
{
	PlayerTextDrawShow(playerid, TurfTD[playerid][0]);
	PlayerTextDrawShow(playerid, TurfTD[playerid][1]);
	PlayerTextDrawShow(playerid, TurfTD[playerid][2]);
   	return 1;
}

HideTurfTD(playerid)
{
	PlayerTextDrawHide(playerid, TurfTD[playerid][0]);
	PlayerTextDrawHide(playerid, TurfTD[playerid][1]);
	PlayerTextDrawHide(playerid, TurfTD[playerid][2]);
	return 1;
}


forward GagoKaba(playerid);
public GagoKaba(playerid)
{
	for(new i = 0; i < 4; i ++)
	{
		TextDrawHideForPlayer(playerid, UnknownTD[i]);
	}
    return 1;
}

forward DEATHACTOR(playerid);
public DEATHACTOR(playerid)
{
	if(IsValidActor(PlayerInfo[playerid][pDeathActor]))
		DestroyActor(PlayerInfo[playerid][pDeathActor]);
	if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pDeathInfo]))
		DestroyDynamic3DTextLabel(PlayerInfo[playerid][pDeathInfo]);
    return 1;
}
forward TeleportPlayerFromPoint(playerid);
public TeleportPlayerFromPoint(playerid)
{
    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pHunger] = 100;
    PlayerInfo[playerid][pHungerTimer] = 0;
    PlayerInfo[playerid][pThirst] = 100;
    PlayerInfo[playerid][pThirstTimer] = 0;

    TogglePlayerControllable(playerid, true);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerVirtualWorld(playerid, 0);
    ClearAnimations(playerid, SYNC_ALL);
   	for(new td = 0; td < 4; td ++)
	{
		PlayerTextDrawHide(playerid, DEATH[playerid][td]);
	}
    for(new i = 0; i < 15; i++)
    {
       TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
    }
   	PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
    CancelSelectTextDraw(playerid);
    SetPlayerPos(playerid, 334.949951, -1794.299926, 6.918820);

    SM(playerid, COLOR_AQUA, "You have been send to Garage From Point.");
}

forward TeleportPlayerFromTurf(playerid);
public TeleportPlayerFromTurf(playerid)
{
    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pHunger] = 100;
    PlayerInfo[playerid][pHungerTimer] = 0;
    PlayerInfo[playerid][pThirst] = 100;
    PlayerInfo[playerid][pThirstTimer] = 0;

    TogglePlayerControllable(playerid, true);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerVirtualWorld(playerid, 0);
    ClearAnimations(playerid, SYNC_ALL);
   	for(new td = 0; td < 4; td ++)
	{
		PlayerTextDrawHide(playerid, DEATH[playerid][td]);
	}
    for(new i = 0; i < 15; i++)
    {
       TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
    }
   	PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
    CancelSelectTextDraw(playerid);
    SetPlayerPos(playerid, 334.949951, -1794.299926, 6.918820);
    
    SM(playerid, COLOR_AQUA, "You have been send to Garage From Turf.");
}

forward IRevive(playerid);
public IRevive(playerid)
{
	PlayerInfo[playerid][pInjured] = 0;
	PlayerInfo[playerid][pHunger] = 25;
	PlayerInfo[playerid][pHungerTimer] = 0;
    PlayerInfo[playerid][pThirst] = 25;
	PlayerInfo[playerid][pThirstTimer] = 0;
	
	PlayerInfo[playerid][pGased] = false;
	PlayerInfo[playerid][pGased1] = false;


    TogglePlayerControllable(playerid, true);
	SetPlayerHealth(playerid, 50.0);
	GivePlayerCash(playerid, -15000);
	ClearAnimations(playerid, SYNC_ALL);
	for(new td = 0; td < 4; td ++)
	{
		PlayerTextDrawHide(playerid, DEATH[playerid][td]);
	}
    for(new i = 0; i < 15; i++)
    {
       TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
    }
   	PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
    CancelSelectTextDraw(playerid);
	
	SendClientMessage(playerid, COLOR_YELLOW, "You have been revived by an Illegal Doctor");
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} Medic successfully healed %s wound.", GetRPName(playerid));
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET thirst = %i, thirsttimer = %i WHERE uid = %i", PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pThirstTimer], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hunger = %i, hungertimer = %i WHERE uid = %i", PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pHungerTimer], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return 1;
}

forward OnPlayerEquipVest(playerid);
public OnPlayerEquipVest(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		SetScriptArmour(playerid, 100);
		TogglePlayerControllable(playerid, true);
		GameTextForPlayer(playerid, "~g~equipped", 2000, 1);
	}
	
	ClearAnimations(playerid, SYNC_ALL);

	PlayerInfo[playerid][pEquipVest] = false;
	KillTimer(PlayerInfo[playerid][pEquipTimer]);
	PlayerInfo[playerid][pEquipTimer] = -1;
	return 1;
}
forward OnPlayerEquipHelmet(playerid);
public OnPlayerEquipHelmet(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	
        PlayerInfo[playerid][pHelmet] = 100;
        SetPlayerProgressBarValue(playerid, helmetbar,PlayerInfo[playerid][pHelmet]);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmet = %i WHERE uid = %i", PlayerInfo[playerid][pHelmet], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        ShowPlayerProgressBar(playerid, helmetbar);
        SendClientMessage(playerid, COLOR_GREEN, "Helmet System Is Currently On Develepoment You Share Your Suggetion");
        
		TogglePlayerControllable(playerid, true);
		GameTextForPlayer(playerid, "~g~equipped", 2000, 1);
	}

	ClearAnimations(playerid, SYNC_ALL);

	PlayerInfo[playerid][pEquipHelmet] = false;
	KillTimer(PlayerInfo[playerid][pEquipTimer]);
	PlayerInfo[playerid][pEquipTimer] = -1;
	//PlayerTextDrawTextSize(playerid, PROGRESS1[playerid][1], 0.699, 16.790);
	//PlayerTextDrawColour(playerid, PROGRESS1[playerid][1], 0xFF0000FF);
    //PlayerTextDrawHide(playerid, PROGRESS1[playerid][0]);
    //PlayerTextDrawHide(playerid, PROGRESS1[playerid][1]);
	SendClientMessage(playerid,COLOR_SYNTAX,"/toghelmet To hide helmet");
	return 1;
}


forward ANNHIDE(playerid);
public ANNHIDE(playerid)
{
	for(new i = 0; i < 3; i ++)
	{
		TextDrawHideForPlayer(playerid, ANN[i]);
	}
    return 1;
}

forward TwtTDHIDE(playerid);
public TwtTDHIDE(playerid)
{
	for(new i = 0; i < 5; i ++)
	{
		TextDrawHideForPlayer(playerid, TwtTD[i]);
	}
    return 1;
}

forward WireHide(playerid);
public WireHide(playerid)
{
	for(new i = 0; i < 3; i ++)
	{
        new targetid;
		PlayerTextDrawHide(targetid, WireTD[playerid][0]);
		PlayerTextDrawHide(targetid, WireTD[playerid][1]);
		PlayerTextDrawHide(targetid, WireTD[playerid][2]);
		PlayerTextDrawHide(targetid, WireTD[playerid][3]);
	}
    return 1;
}

forward Textdraw2Hide(playerid);
public Textdraw2Hide(playerid)
{
	for(new i = 0; i < 3; i ++)
	{
		TextDrawHideForPlayer(playerid, Textdraw2);
	}
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result == -1)
	{   
		if(gNotification)
			notification_show(playerid, str_format("Command doesn't exist. Try /help"), 2000, NOTIF_ERROR);	
		else {
			for(new i = 0; i < 4; i ++)
			{
				TextDrawShowForPlayer(playerid, UnknownTD[i]);
			}
			SetTimerEx("GagoKaba", 5000, false, "i", playerid);
		}
	 	PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
	} else {
		printf("[cmd] %s: [%s]", GetRPName(playerid), cmd);
	}
	return 1;
}

#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
public  OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{

    if(PlayerInfo[playerid][pSkating] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    //static bool:act;
	    SetPlayerArmedWeapon(playerid, 0);
	    if(newkeys & KEY_FIRE)
		{
	        ApplyAnimationEx(playerid, "SKATE","skate_sprint",4.1,1,1,1,1,1);
	        if(!PlayerInfo[playerid][pSkateAct])
			{
	                PlayerInfo[playerid][pSkateAct] = true;
	                RemovePlayerAttachedObject(playerid, 5);
	                DestroyDynamicObject(PlayerInfo[playerid][pSkateObj]);
	                PlayerInfo[playerid][pSkateObj] = CreateDynamicObject(19878,0,0,0,0,0,0, .playerid = playerid);
	                AttachDynamicObjectToPlayer(PlayerInfo[playerid][pSkateObj], playerid, -0.2,0,-0.9,0,0,90);
	        }
	    }
        if(oldkeys & KEY_FIRE)
		{
            ApplyAnimationEx(playerid, "CARRY","crry_prtial",4.0,0,0,0,0,0);
            if(PlayerInfo[playerid][pSkateAct])
			{
                PlayerInfo[playerid][pSkateAct] = false;
                DestroyDynamicObject(PlayerInfo[playerid][pSkateObj]);
                RemovePlayerAttachedObject(playerid, 5);
                SetPlayerAttachedObject(playerid, 5,19878,6,-0.055999,0.013000,0.000000,-84.099983,0.000000,-106.099998,1.000000,1.000000,1.000000);
            }
        }
   	}

   	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1760.675659, -1675.778320, 13.558287))
        {
        if(GetFactionType(playerid) != FACTION_MEDIC)
        {
			if(gNotification)
				return notification_show(playerid, str_format("You can't use this command as you aren't a medic."),2000, NOTIF_ERROR);	
			else
                return SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} You can't use this command as you aren't a medic.");
	    }
        ShowPlayerDialog(playerid, DIALOG_MEDIC, DIALOG_STYLE_LIST, "MEDIC VEHICLES", "Ambulance\nNrg500", "Select", "Close");
        }
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1940.153442, -1823.597045, 13.586874) || IsPlayerInRangeOfPoint(playerid, 1.0, 1940.144287, -1825.208007, 13.586874))
        {
		  callcmd::vote(playerid);
        }
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1579.525878, -1654.947998, 16.202812))
        {
        if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_POLICE)
        {
			if(gNotification)
				return notification_show(playerid, str_format("You can't use this command as you aren't apart of law enforcement."),2000, NOTIF_ERROR);	
			else
                return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
    	}
        ShowPlayerDialog(playerid, DIALOG_LSPD, DIALOG_STYLE_LIST, "LSPD VEHICLES", "LSPD Car\nPolice Ranger\nSwat\nCheeta\nLSPD Truck\nSultan\nBuffalo", "Select", "Close");
        }
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
 	{
		callcmd::takejoint(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
 	{
		if(GetNearbyBusinessEx(playerid) > 0)
		{
			callcmd::buy(playerid);
		}
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
 	{
		callcmd::deliverjoint(playerid);
	}
	if(newkeys & KEY_CROUCH && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
		callcmd::sr(playerid);
	}
    if(newkeys & KEY_CROUCH && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerAtFuelStation(playerid))
 	{
		callcmd::refuel(playerid);
	}
    if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && IsPlayerAtFuelStation(playerid))
 	{
		callcmd::buygascan(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	   callcmd::getflower(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	   callcmd::dryflower(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	   callcmd::getcocaine(playerid);
	}
   	if(newkeys & KEY_NO)
	{
		for(new i = 0; i < sizeof(jobLocations); i ++)
		{
			if(!Job_IsEnabled(i))
			{
				continue;
			}

		    if(IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
		    {
				if(!Job_CanJoin(playerid, i))
				{
					return 1;
				}

		        if(PlayerInfo[playerid][pJob] != JOB_NONE)
		        {
		            if(PlayerInfo[playerid][pVIPPackage] >= 1)
		        	{
		        	    if(PlayerInfo[playerid][pSecondJob] != JOB_NONE)
		        	    {
						    if(gNotification)
								return notification_show(playerid, str_format("You have two jobs already. Please quit one of them before getting another one."),2000, NOTIF_ERROR);	
							else
		        	            return SendClientMessage(playerid, COLOR_SYNTAX, "You have two jobs already. Please quit one of them before getting another one.");
		        	    }
		        	    if(PlayerInfo[playerid][pJob] == i)
		        	    {
							if(gNotification)
								return notification_show(playerid, str_format("You have This jobs already"),2000, NOTIF_ERROR);	
							else
		        	            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this job already.");
		        	    }

		        	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = %i WHERE uid = %i", i, PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						PlayerInfo[playerid][pSecondJob] = i;
						SM(playerid, COLOR_AQUA, "You are now a "SVRCLR"%s{CCFFFF}. Use /jobhelp for a list of commands related to your new job.", jobLocations[i][jobName]);
		            }
		            else
		            {
		            	SendClientMessage(playerid, COLOR_SYNTAX, "You have a job already. Please quit your current job before getting another one.");
					}

					return 1;
				}

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET job = %i WHERE uid = %i", i, PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				PlayerInfo[playerid][pJob] = i;
				PlayerInfo[playerid][pLastPress] = gettime(); // Prevents spamming. Sometimes keys get messed up and register twice.
				SM(playerid, COLOR_AQUA, "You are now a "SVRCLR"%s{CCFFFF}. Use /jobhelp for a list of commands related to your new job.", jobLocations[i][jobName]);
				return 1;
			}
		}
	}
   	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
 	{
		callcmd::buydress(playerid);
	}
    if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    callcmd::blackmarket(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(PlayerInfo[playerid][pIndiHome1] == 0)
		{
           callcmd::start(playerid);
		}
		else
		{
		  callcmd::finish(playerid);
		}
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       callcmd::start1(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       callcmd::buyitems(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       if(IsPlayerInRangeOfPoint(playerid, 2.0, 1494.339599, 760.679687, 11.130325))
       {
           callcmd::buyvehicle(playerid);
	   }
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       if(IsPlayerInRangeOfPoint(playerid, 2.0, -545.220642, -188.894531, 78.406250))
       {
           callcmd::loadsandal(playerid);
	   }
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       callcmd::pickapple(playerid);
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
       if(IsPlayerInRangeOfPoint(playerid, 2.0, -2252.951416, -2317.525634, 29.305549))
       {
           callcmd::packfruit(playerid);
	   }
	}
   	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		callcmd::buyfood(playerid);
	}
   	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(GetNearbyGG(playerid) >= 0 && PlayerInfo[playerid][pGang] > 0)
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, world FROM vehicles WHERE gangid = %i", PlayerInfo[playerid][pGang]);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CAR_GSTORAGE, playerid);
			return 1;
		}
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	   callcmd::buygun(playerid);
	}
 	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(GetNearbyGG(playerid) >= 0 && PlayerInfo[playerid][pGang] > 0)
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, world, impounded FROM vehicles WHERE gangid = %i", PlayerInfo[playerid][pGang]);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CAR_GSTORAGE, playerid);
			return 1;
		}
	}
   	if(newkeys & KEY_NO)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new closestcar = GetClosestCar(playerid, vehicleid);
		if(IsPlayerInRangeOfVehicle(playerid, closestcar, 3.0) && GetVehicleModel(closestcar) == 508)
		{
		    if(VehicleStatus{closestcar} == 1) return SendClientMessage(playerid, COLOR_WHITE, "You're not allowed to enter this Journey as it's been damaged!");
			SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s enters the Journey as a passenger.", GetRPName(playerid));
			SetFreezePos(playerid, 1589.275634, 1603.419433, 2001.095947);
			SetPlayerPos(playerid, 1589.275634, 1603.419433, 2001.095947);
	     	SetPlayerFacingAngle(playerid, 88.00);
	        SetCameraBehindPlayer(playerid);
			PlayerInfo[playerid][pVW] = closestcar;
			SetPlayerVirtualWorld(playerid, closestcar);
			SetPVarInt(playerid, "DoorID", 50519);
			PlayerInfo[playerid][pInt] = 1;
	        SetPlayerInterior(playerid, 1);
			VehicleInterior[playerid] = closestcar;
			SendClientMessage(playerid, COLOR_WHITE, "Press N to exit the vehicle.");
		}
		if(IsPlayerInRangeOfVehicle(playerid, closestcar, 3.0) && GetVehicleModel(closestcar) == 416)
		{
		    if(VehicleStatus{closestcar} == 1) return SendClientMessage(playerid, COLOR_WHITE, "You're not allowed to enter this Ambulance as it's been damaged!");
			SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s enters the Ambulance as a passenger.", GetRPName(playerid));
			SetFreezePos(playerid, 1597.860229, 1530.246948, 3001.085937);
			SetPlayerPos(playerid, 1597.860229, 1530.246948, 3001.085937);
	     	SetPlayerFacingAngle(playerid, 176.14);
	        SetCameraBehindPlayer(playerid);
			PlayerInfo[playerid][pVW] = closestcar;
			SetPlayerVirtualWorld(playerid, closestcar);
			SetPVarInt(playerid, "DoorID", 50519);
			PlayerInfo[playerid][pInt] = 1;
	        SetPlayerInterior(playerid, 1);
			VehicleInterior[playerid] = closestcar;
			SendClientMessage(playerid, COLOR_WHITE, "Press N to exit the vehicle.");
		}
  
	 	if(VehicleInterior[playerid] != INVALID_VEHICLE_ID && IsPlayerInRangeOfPoint(playerid,3, 1589.275634, 1603.419433, 2001.095947))
		{
	        if(VehicleInterior[playerid] == INVALID_VEHICLE_ID || GetVehicleModel(VehicleInterior[playerid]) != 508) {
	      		SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s exits the Journey vehicle.", GetRPName(playerid));
	            SetPlayerPos(playerid, 0.000000, 0.000000, 420.000000);
	        }
	        else {
	            new Float:X, Float:Y, Float:Z;
	            GetVehiclePos(VehicleInterior[playerid], X, Y, Z);
	            SetPlayerPos(playerid, X-4, Y-2.3, Z);

	            new Float:XB, Float:YB, Float:ZB;
	            GetVehiclePos(VehicleInterior[playerid], XB, YB, ZB);
	            if(ZB > 50.0) {
	            }
	        }

	        PlayerInfo[playerid][pVW] = 0;
	        SetPlayerVirtualWorld(playerid, 0);
	        PlayerInfo[playerid][pInt] = 0;
	        SetPlayerInterior(playerid, 0);
	        VehicleInterior[playerid] = INVALID_VEHICLE_ID;
		}
		if(VehicleInterior[playerid] != INVALID_VEHICLE_ID && IsPlayerInRangeOfPoint(playerid,3, 1597.860229, 1530.246948, 3001.085937))
		{
	        if(VehicleInterior[playerid] == INVALID_VEHICLE_ID || GetVehicleModel(VehicleInterior[playerid]) != 416) {
	      		SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s exits the Ambulance vehicle.", GetRPName(playerid));
	            SetPlayerPos(playerid, 0.000000, 0.000000, 420.000000);
	        }
	        else {
	            new Float:X, Float:Y, Float:Z;
	            GetVehiclePos(VehicleInterior[playerid], X, Y, Z);
	            SetPlayerPos(playerid, X-4, Y-2.3, Z);

	            new Float:XB, Float:YB, Float:ZB;
	            GetVehiclePos(VehicleInterior[playerid], XB, YB, ZB);
	            if(ZB > 50.0) {
	            }
	        }
	        PlayerInfo[playerid][pVW] = 0;
	        SetPlayerVirtualWorld(playerid, 0);
	        PlayerInfo[playerid][pInt] = 0;
	        SetPlayerInterior(playerid, 0);
	        VehicleInterior[playerid] = INVALID_VEHICLE_ID;
		}
	}
	if(newkeys & KEY_CTRL_BACK && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	 	{
			callcmd::irev(playerid);
		}
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
	    if(IsAtVendor(playerid))
	    {
	        if(gettime() - PlayerInfo[playerid][pLastVendor] < 15)
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "You can only buy streetfoods in every 15 seconds.");
		    }
		    if(PlayerInfo[playerid][pHunger] == 100 && PlayerInfo[playerid][pThirst] == 100)
		    {
		    	return SendClientMessage(playerid, COLOR_SYNTAX, "You are not hungry you don't need to eat or drink.");
		    }
		    PlayerInfo[playerid][pLastVendor] = gettime();
		    PlayerInfo[playerid][pThirst] += 10;
		    if(PlayerInfo[playerid][pThirst] > 100)
		    {
		    	PlayerInfo[playerid][pThirst] = 100;
		    }
		    PlayerInfo[playerid][pHunger] += 10;
		    if(PlayerInfo[playerid][pHunger] > 100)
		    {
		    	PlayerInfo[playerid][pHunger] = 100;
		    }
		    GivePlayerHealth(playerid, 10.0);
		    GivePlayerCash(playerid, -10);
		    ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
		    SendClientMessage(playerid, COLOR_GREY, "You have bought street foods for $10");
	    }
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(GetNearbyPG(playerid) >= 0)
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, world, impounded, broken FROM vehicles WHERE ownerid = %i", PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CAR_STORAGE, playerid);
			return 1;
		}
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(GetNearbyPG(playerid) >= 0)
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, world, impounded, broken FROM vehicles WHERE ownerid = %i", PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CAR_STORAGE, playerid);
			return 1;
		}
	}

    if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1033.212890, -1982.294921, 13.242181) || IsPlayerInRangeOfPoint(playerid, 3.0, 333.316040, -1802.997680, 6.939134))
	    {
			new string[128];
            format(string, sizeof(string), "Cash(%i/100000000)\nDirty Cash(%i/100000000)\nWeapons\nDrugs", PlayerInfo[playerid][pPSCash], PlayerInfo[playerid][pPSDCash]);
			ShowPlayerDialog(playerid, DIALOG_PSTASH, DIALOG_STYLE_LIST, "Public locker", string, "Select", "Close");
        }
	}
	if(newkeys & KEY_YES)
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	    {
    		if(IsPlayerInRangeOfLocker(playerid, PlayerInfo[playerid][pFaction]))
    		{
				switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
				{
				    case FACTION_POLICE, FACTION_NPOLICE, FACTION_MEDIC, FACTION_FEDERAL, FACTION_TERRORIST, FACTION_ARMY, FACTION_JAILGUARDS:
				    {
				        ShowPlayerDialog(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms\nClothings", "Select", "Cancel");
					}
					case FACTION_GOVERNMENT, FACTION_NEWS, FACTION_MECHANIC:
					{
					    ShowPlayerDialog(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms", "Select", "Cancel");
					}
					case FACTION_HITMAN:
					{
					    ShowPlayerDialog(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Order weapons\nChange clothes", "Select", "Cancel");
					}
				}
			}
		}
	}
    if(newkeys & KEY_NO)
	{
		if(GetInsideBusiness(playerid) >= 0)
		{
			return callcmd::buy(playerid);
		}
	}

	if(!pCBugging[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID)
	{
	    if(!PlayerInfo[playerid][pJoinedEvent])
		{
			if(PRESSED(KEY_FIRE))
			{
				switch(GetPlayerWeapon(playerid))
				{
					case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
					{
						ptsLastFiredWeapon[playerid] = gettime();
					}
				}
			}
			else if(PRESSED(KEY_CROUCH))
			{
				if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
				{
                 	//ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
					pCBugging[playerid] = true;
					//ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 1, 0, 0, 0, 1000);
					KillTimer(ptmCBugFreezeOver[playerid]);
					ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1500, false, "i", playerid);
				}
			}
		}
	    if(PlayerInfo[playerid][pJoinedEvent] && !EventInfo[eCS])
		{
			if(PRESSED(KEY_FIRE))
			{
				switch(GetPlayerWeapon(playerid))
				{
					case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
					{
						ptsLastFiredWeapon[playerid] = gettime();
					}
				}
			}
			else if(PRESSED(KEY_CROUCH))
			{
				if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
				{
				  	new Float:health;
	    			GetPlayerHealth(playerid, health);
		    		SetPlayerHealth(playerid, health - 9.0);
		    		//ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
					pCBugging[playerid] = true;
					ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkE", 4.1, 1, 0, 0, 0, 1000);
					KillTimer(ptmCBugFreezeOver[playerid]);
					ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1500, false, "i", playerid);
				}
			}
		}
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
        callcmd::vpanel(playerid);
        PlayerInfo[playerid][pLastPress] = gettime();
	}
	if(newkeys & KEY_SPRINT)
	{
	    if(PlayerInfo[playerid][pLoopAnim])
	    {
	        PlayerInfo[playerid][pLoopAnim] = 0;

		    ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		    TextDrawHideForPlayer(playerid, AnimationTD);
		}
	}
 	if((gettime() - PlayerInfo[playerid][pLastPress]) >= 1)
	{
		if(newkeys & KEY_YES)
		{
			if(!EnterCheck(playerid)) ExitCheck(playerid);

			new id = Gate_Nearest(playerid);
			if (id != -1)
			{
				if(PlayerInfo[playerid][pHurt] - 30 > 0)
					return SM(playerid, COLOR_GREY, "You are too hurt to operate/enter anything. Please wait %i seconds before trying again.", (PlayerInfo[playerid][pHurt] - 30));

				if (strlen(GateData[id][gatePass]))
				{
					ShowPlayerDialog(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
				}
				else
				{
					if (GateData[id][gateFaction] != -1 && PlayerInfo[playerid][pFaction] != GetFactionByID(GateData[id][gateFaction]))
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't open this gate/door.");

					Gate_Operate(id);

					switch (GateData[id][gateOpened])
					{
						case 0:
							Dyuze(playerid, "Notice", "You have closed the gate/door!");

						case 1:
							Dyuze(playerid, "Notice", "You have opened the gate/door!");
					}
				}
			}
			PlayerInfo[playerid][pLastPress] = gettime(); 
		}
		else if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 		{
		  	callcmd::engine(playerid);
			PlayerInfo[playerid][pLastPress] = gettime();
		}
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1481.073242, -1768.236450, 18.810064))
	    {
			new string[1024];
			for(new i = 0; i < sizeof(jobLocations); i++)
			{
				if(!Job_IsEnabled(i))
				{
					continue;
				}

				format(string, sizeof(string), "%sApply for %s\n", string, jobLocations[i][jobName]);
			}
			ShowPlayerDialog(playerid, DIALOG_CITY_HALL, DIALOG_STYLE_LIST, "Choose your job", string, "Select", "Close");
        }
	}
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
 	{
 	    new id = GetNearbyVehicle(playerid);
		if(PlayerHasJob(playerid, JOB_FARMER))
	    {
			if(IsPlayerInHarvestArea(playerid))
			{
				if(Vehicle_WheatCount(id) >= WHEAT_LIMIT)
				{
					SendClientMessage(playerid, COLOR_ERROR, "You can't take a wheat any more.");
				}
				if(PlayerInfo[playerid][pHarvestTime] > 0)
				{
	    		return SendClientMessage(playerid, COLOR_SYNTAX, "You are harvesting already. Wait until you are done.");
				}
				if(PlayerInfo[playerid][pWheat] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
				{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to drop off your current rock first.");
				}
                GameTextForPlayer(playerid, "~g~Harvesting...", 6000, 3);
			    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);

				DisablePlayerCheckpoint(playerid);

				PlayerInfo[playerid][pHarvestTime] = 6;
			}
		}
	}
   	if(PollOn && PollVoted[playerid] == 0)
	{
	    if(newkeys == KEY_YES)
	    {
			PollY++;
			PollVoted[playerid] = 1;
			SendClientMessage(playerid, COLOR_SYNTAX, "You Have Voted Yes.");
		}
	    if(newkeys == KEY_NO)
	    {
			PollN++;
			PollVoted[playerid] = 1;
			SendClientMessage(playerid, SERVER_COLOR, "** "WHITE" You Have Voted No.");
	    }
	}

	return 1;
}





public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if(PlayerInfo[playerid][pKicked]) return 0;

	if(newstate == PLAYER_STATE_DRIVER) {
	    pvehicleid[playerid] = GetPlayerVehicleID(playerid);
	    pmodelid[playerid] = GetVehicleModel(pvehicleid[playerid]);
	} else {
	    pvehicleid[playerid] = 0;
	    pmodelid[playerid] = 0;
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	   
	    if((courierVehicles[0] <= vehicleid <= courierVehicles[6]) && !PlayerHasJob(playerid, JOB_COURIER))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a trucker.");
	        RemovePlayerFromVehicle(playerid);
	        return 1;
	    }
	    if((FarmerVehicles[0] <= vehicleid <= FarmerVehicles[9]) && !PlayerHasJob(playerid, JOB_FARMER))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a Farmer.");
	        RemovePlayerFromVehicle(playerid);
	    }

	    if((testVehicles[0] <= vehicleid <= testVehicles[2]) && !PlayerInfo[playerid][pDrivingTest])
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not taking your drivers test.");
	        RemovePlayerFromVehicle(playerid);
	        return 1;
	    }
	    if(VehicleInfo[vehicleid][vFactionType] != FACTION_NONE && GetFactionType(playerid) != VehicleInfo[vehicleid][vFactionType])
	    {
	        SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as it doesn't belong to your faction.");
	        RemovePlayerFromVehicle(playerid);
	        return 1;
	    }

	    if(VehicleInfo[vehicleid][vJob] >= 0 && PlayerInfo[playerid][pJob] != VehicleInfo[vehicleid][vJob])
	    {
	        SM(playerid, COLOR_SYNTAX, "You cannot operate this vehicle as you are not a %s.", GetJobName(VehicleInfo[vehicleid][vJob]));
	        RemovePlayerFromVehicle(playerid);
	        return 1;
	    }

	    if(!VehicleHasEngine(vehicleid))
	    {
	        SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
		}
		else if(!GetVehicleParams(vehicleid, VEHICLE_ENGINE))
		{
		    if(testVehicles[0] <= vehicleid <= testVehicles[2])
		    {
		        PlayerInfo[playerid][pCP] = CHECKPOINT_TEST;
		        PlayerInfo[playerid][pTestVehicle] = vehicleid;
		        PlayerInfo[playerid][pTestCP] = 0;

		        SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
				SetPlayerCheckpoint(playerid, drivingTestCPs[PlayerInfo[playerid][pTestCP]][0], drivingTestCPs[PlayerInfo[playerid][pTestCP]][1], drivingTestCPs[PlayerInfo[playerid][pTestCP]][2], 3.0);
				SendClientMessage(playerid, COLOR_GREEN, "Drive through the checkpoints to proceed with the test. Try not to damage your vehicle.");
		    }
		    else
		    {
                SendClientMessage(playerid, COLOR_YELLOW, "You can toggle the vehicle engine by pressing 'N' or Pressing 'Y' for vehicle panel.");
			}
	    }
	    if(IsVehicleOwner(playerid, vehicleid) && VehicleInfo[vehicleid][vTickets] > 0)
	    {
	        SM(playerid, COLOR_GREEN, "This vehicle has $%i in unpaid tickets. You can pay your tickets using /paytickets.", VehicleInfo[vehicleid][vTickets]);
	    }

	    if(!PlayerInfo[playerid][pToggleTextdraws])
	    {   // Displaying the Speedo
			for(new i = 0; i < 17; i ++) {
				PlayerTextDrawShow(playerid, SPEEDO[playerid][i]);
			}
		}
	    if(VehicleHasEngine(vehicleid) && vehicleFuel[vehicleid] <= 0)
	    {
	        GameTextForPlayer(playerid, "~b~Out of fuel", 5000, 3);
	    	//TogglePlayerControllable(playerid, 0);
	    }
		SetPlayerArmedWeapon(playerid, 0);
	}
	else if(oldstate == PLAYER_STATE_DRIVER)
	{
     	if(PlayerInfo[playerid][pDrivingTest])
	    {
         	PlayerInfo[playerid][pDrivingTest] = 0;
         	SetVehicleToRespawn(PlayerInfo[playerid][pTestVehicle]);
         	SendClientMessage(playerid, COLOR_LIGHTRED, "** You have exited the vehicle and therefore failed the test.");
		}
		new
	    Float:x,
    	Float:y,
    	Float:z;

        GetPlayerPos(playerid, x, y, z);
  	    if(PlayerInfo[playerid][pCooking])
		{
            GameTextForPlayer(playerid, "~r~COOKER EXPLODED", 1000, 5);
            SendClientMessage(playerid, COLOR_LIGHTRED, "** You have exited the vehicle and therefore cooker exploded.");
            PlayerInfo[playerid][pCooking] = 0;
            CreateExplosion(x, y, z, 6, 6.0);
		}
		new vehicleid = GetNearbyVehicle(playerid);
		if(vehicleid != INVALID_VEHICLE_ID && IsVehicleOwner(playerid, vehicleid))
		{
			if(!VehicleInfo[vehicleid][vLocked])
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Dont Leave Vehicle Unlocked Stash May Be Got stoled!");
			}
			
		}
		// Hiding the Speedo
		for(new i = 0; i < 17; i ++) {
			PlayerTextDrawHide(playerid, SPEEDO[playerid][i]);
		}
	}

	else if(newstate == PLAYER_STATE_PASSENGER)
	{

     	switch(GetPlayerWeapon(playerid))
     	{
     	    case 22, 28, 29, 32:
     	        SetPlayerArmedWeapon(playerid, GetScriptWeapon(playerid));
	        default:
				SetPlayerArmedWeapon(playerid, 0);
		}
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(!(-3.0 <= fScaleX <= 3.0)) fScaleX = fScaleX < -3.0 ? 0.0 : 3.0;
	if(!(-3.0 <= fScaleY <= 3.0)) fScaleY = fScaleY < -3.0 ? 0.0 : 3.0;
	if(!(-3.0 <= fScaleZ <= 3.0)) fScaleZ = fScaleZ < -3.0 ? 0.0 : 3.0;

	switch(PlayerInfo[playerid][pEditType])
	{
	    case EDIT_CLOTHING_PREVIEW:
	    {
	        RemovePlayerAttachedObject(playerid, 9);

	        if(response)
	        {
	            new businessid = GetInsideBusiness(playerid);
	            if(businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
	            {
	                if(BusinessInfo[businessid][bProducts] <= 0)
	                {
	                    return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock now.");
					}
	                if(PlayerInfo[playerid][pCash] < BusinessInfo[businessid][bPrices][1])
	                {
	                    return SendClientMessage(playerid, COLOR_SYNTAX, "You couldn't afford to purchase this item.");
	                }

	                for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	                {
	                    if(!ClothingInfo[playerid][i][cExists])
	                    {
	                        ClothingInfo[playerid][i][cModel] = modelid;
	                        ClothingInfo[playerid][i][cBone] = boneid;
	                        ClothingInfo[playerid][i][cPosX] = fOffsetX;
	                        ClothingInfo[playerid][i][cPosY] = fOffsetY;
	                        ClothingInfo[playerid][i][cPosZ] = fOffsetZ;
	                        ClothingInfo[playerid][i][cRotX] = fRotX;
	                        ClothingInfo[playerid][i][cRotY] = fRotY;
	                        ClothingInfo[playerid][i][cRotZ] = fRotZ;
	                        ClothingInfo[playerid][i][cScaleX] = fScaleX;
	                        ClothingInfo[playerid][i][cScaleY] = fScaleY;
	                        ClothingInfo[playerid][i][cScaleZ] = fScaleZ;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO clothing VALUES(null, %i, '%e', %i, %i, 0, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", PlayerInfo[playerid][pID], clothingArray[PlayerInfo[playerid][pSelected]][clothingName], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
							mysql_tquery(connectionID, queryBuffer, "OnPlayerBuyClothingItem", "isiii", playerid, clothingArray[PlayerInfo[playerid][pSelected]][clothingName], BusinessInfo[businessid][bPrices][1], businessid, i);
							return 1;
						}
					}

					SendClientMessage(playerid, COLOR_SYNTAX, "You have no more clothing slots available. Therefore you can't buy this.");
	            }
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHING);
			}
		}
		case EDIT_CLOTHING:
		{
		    new clothingid = PlayerInfo[playerid][pSelected];

		    if(response)
		    {
		        ClothingInfo[playerid][clothingid][cPosX] = fOffsetX;
		        ClothingInfo[playerid][clothingid][cPosY] = fOffsetY;
		        ClothingInfo[playerid][clothingid][cPosZ] = fOffsetZ;
		        ClothingInfo[playerid][clothingid][cRotX] = fRotX;
		        ClothingInfo[playerid][clothingid][cRotY] = fRotY;
		        ClothingInfo[playerid][clothingid][cRotZ] = fRotZ;
		        ClothingInfo[playerid][clothingid][cScaleX] = fScaleX;
		        ClothingInfo[playerid][clothingid][cScaleY] = fScaleY;
		        ClothingInfo[playerid][clothingid][cScaleZ] = fScaleZ;

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_x = '%f', pos_y = '%f', pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f', scale_x = '%f', scale_y = '%f', scale_z = '%f' WHERE id = %i", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, ClothingInfo[playerid][clothingid][cID]);
		        mysql_tquery(connectionID, queryBuffer);

		        SM(playerid, COLOR_SYNTAX, "Changes saved.");
		    }

			if(!ClothingInfo[playerid][clothingid][cAttached])
	        {
	            RemovePlayerAttachedObject(playerid, 9);
			}
			else
			{
			    RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
			    SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cPosZ],
					ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cRotZ], ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cScaleZ]);
			}
		}
	}

    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
	    if (PlayerInfo[playerid][pEditGraffiti] != -1 && GraffitiData[PlayerInfo[playerid][pEditGraffiti]][graffitiExists])
	    {
			GraffitiData[PlayerInfo[playerid][pEditGraffiti]][graffitiPos][0] = x;
			GraffitiData[PlayerInfo[playerid][pEditGraffiti]][graffitiPos][1] = y;
			GraffitiData[PlayerInfo[playerid][pEditGraffiti]][graffitiPos][2] = z;
			GraffitiData[PlayerInfo[playerid][pEditGraffiti]][graffitiPos][3] = rz;

			Graffiti_Refresh(PlayerInfo[playerid][pEditGraffiti]);
			Graffiti_Save(PlayerInfo[playerid][pEditGraffiti]);
		}
		else if (PlayerInfo[playerid][pEditGate] != -1 && GateData[PlayerInfo[playerid][pEditGate]][gateExists])
	    {
	        switch (PlayerInfo[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerInfo[playerid][pEditGate];

	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][0] = x;
	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][1] = y;
	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][2] = z;
	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][3] = rx;
	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][4] = ry;
	                GateData[PlayerInfo[playerid][pEditGate]][gatePos][5] = rz;

	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

					Gate_Save(id);
                    SM(playerid, COLOR_WHITE, "You have edited the position of gate ID: %d.", id);
				}
				case 2:
	            {
	                new id = PlayerInfo[playerid][pEditGate];

	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][0] = x;
	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][1] = y;
	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][2] = z;
	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][3] = rx;
	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][4] = ry;
	                GateData[PlayerInfo[playerid][pEditGate]][gateMove][5] = rz;

	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

					Gate_Save(id);
                    SM(playerid, COLOR_WHITE, "You have edited the moving position of gate ID: %d.", id);
				}
			}
		}
	}
	switch(PlayerInfo[playerid][pEditType])
	{
		case EDIT_OBJECT_PREVIEW:
		{
			if(response == EDIT_RESPONSE_FINAL)
			{
				if (PlayerInfo[playerid][pEditmObject] != -1 && ObjectData[PlayerInfo[playerid][pEditmObject]][mobjExists])
				{
					new string[48];
					new id = PlayerInfo[playerid][pEditmObject];
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][0] = x;
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][1] = y;
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][2] = z;
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][3] = rx;
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][4] = ry;
					ObjectData[PlayerInfo[playerid][pEditmObject]][mobjPos][5] = rz;

					DestroyDynamicObject(ObjectData[id][mobjObject]);
					ObjectData[id][mobjObject] = CreateDynamicObject(ObjectData[id][mobjModel], ObjectData[id][mobjPos][0], ObjectData[id][mobjPos][1], ObjectData[id][mobjPos][2], ObjectData[id][mobjPos][3], ObjectData[id][mobjPos][4], ObjectData[id][mobjPos][5], ObjectData[id][mobjWorld], ObjectData[id][mobjInterior]);

					DestroyDynamic3DTextLabel(ObjectData[id][mobjname2]);
					format(string, sizeof(string), "[%i]\nID: %i", ObjectData[id][mobjModel], id);
					ObjectData[id][mobjname2] = CreateDynamic3DTextLabel(string, COLOR_GREY, ObjectData[id][mobjPos][0], ObjectData[id][mobjPos][1], ObjectData[id][mobjPos][2], 5.0);

					Object_Save(id);
					SM(playerid, COLOR_WHITE, "You have edited the position of object ID: %d.", id);
				}
			}
		}
	    case EDIT_FURNITURE_PREVIEW:
	    {
			if(response != EDIT_RESPONSE_UPDATE)
			{
			    DestroyDynamicObject(PlayerInfo[playerid][pEditObject]);
				PlayerInfo[playerid][pEditObject] = INVALID_OBJECT_ID;

			    if(response == EDIT_RESPONSE_FINAL)
			    {
			        new houseid = GetInsideHouse(playerid);

					if(houseid >= 0 && HasFurniturePerms(playerid, houseid))
					{
					    if(PlayerInfo[playerid][pCash] < furnitureArray[PlayerInfo[playerid][pSelected]][fPrice])
		                {
		                    return SendClientMessage(playerid, COLOR_SYNTAX, "You couldn't afford to purchase this item.");
		                }

					    new
					        string[16];

					    GivePlayerCash(playerid, -furnitureArray[PlayerInfo[playerid][pSelected]][fPrice]);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO furniture VALUES(null, %i, %i, '%e', %i, '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, 0, 0)", HouseInfo[houseid][hID], furnitureArray[PlayerInfo[playerid][pSelected]][fModel], furnitureArray[PlayerInfo[playerid][pSelected]][fName], furnitureArray[PlayerInfo[playerid][pSelected]][fPrice], x, y, z, rx, ry, rz, HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld]);
						mysql_tquery(connectionID, queryBuffer);
						mysql_tquery(connectionID, "SELECT * FROM furniture WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, HouseInfo[houseid][hLabels]);

						format(string, sizeof(string), "~r~-$%i", furnitureArray[PlayerInfo[playerid][pSelected]][fPrice]);
						GameTextForPlayer(playerid, string, 5000, 1);

						if(!strcmp(furnitureArray[PlayerInfo[playerid][pSelected]][fCategory], "Doors & Gates"))
						{
							SendClientMessage(playerid, COLOR_WHITE, "** You can use /lopen to control your door and /lock to unlock or lock it.");
						}
					}
			    }
			    else if(response == EDIT_RESPONSE_CANCEL)
			    {
			        ShowDialogToPlayer(playerid, DIALOG_BUYFURNITURE2);
				}
			}
		}
		case EDIT_FURNITURE:
		{
		    if(response != EDIT_RESPONSE_UPDATE)
			{
				if(response == EDIT_RESPONSE_FINAL)
				{
				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE furniture SET pos_x = '%f', pos_y = '%f', pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f' WHERE id = %i", x, y, z, rx, ry, rz, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
					mysql_tquery(connectionID, queryBuffer);
					SendClientMessage(playerid, COLOR_SYNTAX, "Changes saved.");
				}

		        ReloadFurniture(objectid, HouseInfo[PlayerInfo[playerid][pFurnitureHouse]][hLabels]);
			}
		}
		case EDIT_LAND_OBJECT_PREVIEW:
	    {
			if(response != EDIT_RESPONSE_UPDATE)
			{
			    DestroyDynamicObject(PlayerInfo[playerid][pEditObject]);
				PlayerInfo[playerid][pEditObject] = INVALID_OBJECT_ID;

			    if(response == EDIT_RESPONSE_FINAL)
			    {
			        new landid = PlayerInfo[playerid][pObjectLand];

					if(landid >= 0 && HasLandPerms(playerid, landid))
					{
					    if(PlayerInfo[playerid][pCash] < furnitureArray[PlayerInfo[playerid][pSelected]][fPrice])
		                {
		                    return SendClientMessage(playerid, COLOR_SYNTAX, "You couldn't afford to purchase this item.");
		                }
		                if(!IsPointInLand(landid, x, y))
		                {
		                    return SendClientMessage(playerid, COLOR_SYNTAX, "The object has exceeded the boundaries for your land.");
						}

					    new
					        string[16];

					    GivePlayerCash(playerid, -furnitureArray[PlayerInfo[playerid][pSelected]][fPrice]);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO landobjects VALUES(null, %i, %i, '%e', %i, '%f', '%f', '%f', '%f', '%f', '%f', 0, 0, '%f', '%f', '%f', '-1000.0', '-1000.0', '-1000.0')", LandInfo[landid][lID], furnitureArray[PlayerInfo[playerid][pSelected]][fModel], furnitureArray[PlayerInfo[playerid][pSelected]][fName], furnitureArray[PlayerInfo[playerid][pSelected]][fPrice], x, y, z, rx, ry, rz, x, y, z - 10.0);
						mysql_tquery(connectionID, queryBuffer);
						mysql_tquery(connectionID, "SELECT * FROM landobjects WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, LandInfo[landid][lLabels]);

						format(string, sizeof(string), "~r~-$%i", furnitureArray[PlayerInfo[playerid][pSelected]][fPrice]);
						GameTextForPlayer(playerid, string, 5000, 1);

						if(!strcmp(furnitureArray[PlayerInfo[playerid][pSelected]][fCategory], "Doors & Gates"))
						{
							if(IsGateModel(furnitureArray[PlayerInfo[playerid][pSelected]][fModel]))
							{
								SendClientMessage(playerid, COLOR_WHITE, "** You can use /lopen to open and close your gate. To change the destination coordinates, use /land and choose 'Edit object'.");
							}
						    else
							{
								SendClientMessage(playerid, COLOR_WHITE, "** You can use /lopen to control your door and /lock to unlock or lock it.");
						    }
						}
					}
			    }
			    else if(response == EDIT_RESPONSE_CANCEL)
			    {
     			    if(PlayerInfo[playerid][pMenuType] == 0)
						ShowObjectSelectionMenu(playerid, MODEL_SELECTION_LANDOBJECTS);
					else
			        ShowDialogToPlayer(playerid, DIALOG_LANDBUILD2);
				}
			}
		}
		case EDIT_LAND_OBJECT:
		{
		    if(response != EDIT_RESPONSE_UPDATE)
			{
				if(response == EDIT_RESPONSE_FINAL)
				{
				    if(!IsPointInLand(PlayerInfo[playerid][pObjectLand], x, y))
        			{
           				SendClientMessage(playerid, COLOR_SYNTAX, "The object has exceeded the boundaries for your land.");
					}
					else
					{
					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET pos_x = '%f', pos_y = '%f', pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f' WHERE id = %i", x, y, z, rx, ry, rz, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
						mysql_tquery(connectionID, queryBuffer);
						SendClientMessage(playerid, COLOR_SYNTAX, "Changes saved.");
					}
				}

		        ReloadLandObject(objectid, LandInfo[PlayerInfo[playerid][pObjectLand]][lLabels]);
			}
		}
		case EDIT_LAND_GATE_MOVE:
		{
		    if(response != EDIT_RESPONSE_UPDATE)
			{
				if(response == EDIT_RESPONSE_FINAL)
				{
				    if(!IsPointInLand(PlayerInfo[playerid][pObjectLand], x, y))
        			{
           				SendClientMessage(playerid, COLOR_SYNTAX, "The object has exceeded the boundaries for your land.");
					}
					else
					{
					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET move_x = '%f', move_y = '%f', move_z = '%f', move_rx = '%f', move_ry = '%f', move_rz = '%f' WHERE id = %i", x, y, z, rx, ry, rz, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
						mysql_tquery(connectionID, queryBuffer);
						SendClientMessage(playerid, COLOR_SYNTAX, "Changes saved.");
					}
				}

		        ReloadLandObject(objectid, LandInfo[PlayerInfo[playerid][pObjectLand]][lLabels]);
			}
		}
	}
    if(GetPVarInt(playerid, #CorpsEdit))
	{
		Corpse_OnPlayerEdit(playerid, objectid, response, x, y, z, rz);
	}
	return 1;
}
forward OnPlayerUseValetStorage(playerid);
public OnPlayerUseValetStorage(playerid)
{
	new vehicleid = GetVehicleLinkedID(SQL_GetInt(0, "id"));

	if(vehicleid != INVALID_VEHICLE_ID)
	{

		if(IsVehicleOccupied(vehicleid) && GetVehicleDriver(vehicleid) != playerid)
        {
            SendClientMessage(playerid, COLOR_GREY, "This vehicle is occupied.");
        }
        else
        {
            new
				Float:health;

			GetVehicleHealth(vehicleid, health);

            if(health < 600.0)
            {
                SendClientMessage(playerid, COLOR_GREY, "This vehicle is too damaged to be despawned.");
            }
            else
            {
		        SendClientMessageEx(playerid, COLOR_AQUA, "Your {FF6347}%s{33CCFF} which is located in %s has been despawned.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
				DespawnVehicle(vehicleid);
			}
		}
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", SQL_GetInt(0, "id"), PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerUseValletSystem", "ii", playerid, false);
	}
}
forward OnPlayerUseValletSystem(playerid, parked);
public OnPlayerUseValletSystem(playerid, parked)
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no valid vehicle which you can spawn.");
	}
	else
	{
        for(new i = 0; i < MAX_VEHICLES; i ++)
	    {
	        if(IsValidVehicle(i) && VehicleInfo[i][vID] == SQL_GetInt(0, "id"))
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is spawned already. /findcar to track it.");
	    	}
	    }
	    if(SQL_GetInt(0, "impounded"))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is impounded. You can release it from the DMV. (/locate > General Location > DMV)");
		}
	    new
			modelid = SQL_GetInt(0, "modelid"),
			Float:x = SQL_GetFloat(0, "pos_x"),
			Float:y = SQL_GetFloat(0, "pos_y"),
			Float:z = SQL_GetFloat(0, "pos_z"),
			Float:a = SQL_GetFloat(0, "pos_a"),
			color1 = SQL_GetInt(0, "color1"),
			color2 = SQL_GetInt(0, "color2"),
			vehicleid;

		vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
		GetPlayerPos(playerid, x, y, z);
		SetVehiclePos(vehicleid, x + 1, y + 1, z + 2.0);
		PutPlayerInVehicle(playerid, vehicleid, 0);


		if(vehicleid != INVALID_VEHICLE_ID)
		{
		    ResetVehicle(vehicleid);

		    SQL_GetString(0, "owner", VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
		    SQL_GetString(0, "plate", VehicleInfo[vehicleid][vPlate], 32);

		    VehicleInfo[vehicleid][vID] = SQL_GetInt(0, "id");
		    VehicleInfo[vehicleid][vOwnerID] = SQL_GetInt(0, "ownerid");
			VehicleInfo[vehicleid][vOgowner] = SQL_GetInt(0, "ogowner");
		    VehicleInfo[vehicleid][vPrice] = SQL_GetInt(0, "price");
		    VehicleInfo[vehicleid][vTickets] = SQL_GetInt(0, "tickets");
		    VehicleInfo[vehicleid][vLocked] = SQL_GetInt(0, "locked");
		    VehicleInfo[vehicleid][vHealth] = SQL_GetFloat(0, "health");
		    VehicleInfo[vehicleid][vPaintjob] = SQL_GetInt(0, "paintjob");
		    VehicleInfo[vehicleid][vInterior] = SQL_GetInt(0, "interior");
	        VehicleInfo[vehicleid][vWorld] = SQL_GetInt(0, "world");
	        VehicleInfo[vehicleid][vNeon] = SQL_GetInt(0, "neon");
	        VehicleInfo[vehicleid][vNeonEnabled] = SQL_GetInt(0, "neonenabled");
	        VehicleInfo[vehicleid][vTrunk] = SQL_GetInt(0, "trunk");
	        VehicleInfo[vehicleid][vMods][0] = SQL_GetInt(0, "mod_1");
	        VehicleInfo[vehicleid][vMods][1] = SQL_GetInt(0, "mod_2");
	        VehicleInfo[vehicleid][vMods][2] = SQL_GetInt(0, "mod_3");
	        VehicleInfo[vehicleid][vMods][3] = SQL_GetInt(0, "mod_4");
	        VehicleInfo[vehicleid][vMods][4] = SQL_GetInt(0, "mod_5");
	        VehicleInfo[vehicleid][vMods][5] = SQL_GetInt(0, "mod_6");
	        VehicleInfo[vehicleid][vMods][6] = SQL_GetInt(0, "mod_7");
	        VehicleInfo[vehicleid][vMods][7] = SQL_GetInt(0, "mod_8");
	        VehicleInfo[vehicleid][vMods][8] = SQL_GetInt(0, "mod_9");
	        VehicleInfo[vehicleid][vMods][9] = SQL_GetInt(0, "mod_10");
	        VehicleInfo[vehicleid][vMods][10] = SQL_GetInt(0, "mod_11");
	        VehicleInfo[vehicleid][vMods][11] = SQL_GetInt(0, "mod_12");
	        VehicleInfo[vehicleid][vMods][12] = SQL_GetInt(0, "mod_13");
	        VehicleInfo[vehicleid][vMods][13] = SQL_GetInt(0, "mod_14");
	        VehicleInfo[vehicleid][vCash] = SQL_GetInt(0, "cash");
	        VehicleInfo[vehicleid][vMaterials] = SQL_GetInt(0, "materials");
			VehicleInfo[vehicleid][vOre] = SQL_GetInt(0, "ore");
			VehicleInfo[vehicleid][vMetalCapacity] = SQL_GetInt(0, "metals");
			VehicleInfo[vehicleid][vCopper] = SQL_GetInt(0, "copper");
			VehicleInfo[vehicleid][vIorn] = SQL_GetInt(0, "iorn");
			VehicleInfo[vehicleid][vGold] = SQL_GetInt(0, "gold");
			VehicleInfo[vehicleid][vDiamond] = SQL_GetInt(0, "diamond");
	        VehicleInfo[vehicleid][vPot] = SQL_GetInt(0, "pot");
	        VehicleInfo[vehicleid][vCrack] = SQL_GetInt(0, "crack");
	        VehicleInfo[vehicleid][vMeth] = SQL_GetInt(0, "meth");
	        VehicleInfo[vehicleid][vPainkillers] = SQL_GetInt(0, "painkillers");
	        VehicleInfo[vehicleid][vWeapons][0] = SQL_GetInt(0, "weapon_1");
	        VehicleInfo[vehicleid][vWeapons][1] = SQL_GetInt(0, "weapon_2");
	        VehicleInfo[vehicleid][vWeapons][2] = SQL_GetInt(0, "weapon_3");
			VehicleInfo[vehicleid][vWeapons][3] = SQL_GetInt(0, "weapon_4");
			VehicleInfo[vehicleid][vWeapons][4] = SQL_GetInt(0, "weapon_5");
			VehicleInfo[vehicleid][vHPAmmo] = SQL_GetInt(0, "hpammo");
            VehicleInfo[vehicleid][vPoisonAmmo] = SQL_GetInt(0, "poisonammo");
            VehicleInfo[vehicleid][vFMJAmmo] = SQL_GetInt(0, "fmjammo");
		    VehicleInfo[vehicleid][vRent] = SQL_GetInt(0, "rent");
            VehicleInfo[vehicleid][vRenttime] = SQL_GetInt(0, "renttime");
	        VehicleInfo[vehicleid][vGang] = -1;
			VehicleInfo[vehicleid][vVip] = 0;
	        VehicleInfo[vehicleid][vFactionType] = FACTION_NONE;
	        VehicleInfo[vehicleid][vJob] = JOB_NONE;
	        VehicleInfo[vehicleid][vRespawnDelay] = -1;
	        VehicleInfo[vehicleid][vModel] = modelid;
		    VehicleInfo[vehicleid][vPosX] = x;
		    VehicleInfo[vehicleid][vPosY] = y;
		    VehicleInfo[vehicleid][vPosZ] = z;
		    VehicleInfo[vehicleid][vPosA] = a;
		    VehicleInfo[vehicleid][vColor1] = color1;
		    VehicleInfo[vehicleid][vColor2] = color2;
		    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vTimer] = -1;
		    VehicleInfo[vehicleid][vRegistered] = SQL_GetInt(0, "registered");

			vehicleFuel[vehicleid] = SQL_GetInt(0, "fuel");
			adminVehicle{vehicleid} = false;

			ReloadVehicle(vehicleid);

		    if(!parked)
			{
			    SM(playerid, COLOR_GREEN, "AKRP BANK : $2500 payed for the valet service of your vehicle %s", GetVehicleName(vehicleid));
			}
	    }
	}

	return 1;
}

forward hidebelow(playerid);
public hidebelow(playerid)
{
	PlayerTextDrawHide(playerid, BelowNotTD[playerid][0]);
}

forward OnTopListQuery(playerid, listitem);
public OnTopListQuery(playerid, listitem)
{
	if(!IsPlayerConnected(playerid))
	{
		return 1;
	}

	new Name[MAX_PLAYER_NAME], Money, fString[128], cString[2048], title[64], field[16];
	switch(listitem)
	{
		case 0:
		{
			format(title, sizeof(title), "Mga taong walang puso");
			format(field, sizeof(field), "crimes");
		}
		case 1:
		{
			format(title, sizeof(title), "Mga taong dapat nakawan sa syudad");
			format(field, sizeof(field), "bank");
		}
		default:
		{
			format(title, sizeof(title), "Mga walang buhay sa syudad");
			format(field, sizeof(field), "hours");
		}
	}

	for(new i = 0; i < cache_num_rows(); ++i)
	{
		SQL_GetString(i, "username", Name);
		Money = SQL_GetInt(i, field);

		if(listitem == 1)
		{
			format(fString, sizeof(fString), "%s\t$%d\n", Name, Money);
		}
		else if(listitem == 2)
		{
			format(fString, sizeof(fString), "%s\t%i Playing Hours\n", Name, Money);
		}
		else
		{
			format(fString, sizeof(fString), "%s\t%i Crimes\n", Name, Money);
		}
		strcat(cString, fString);
	}

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST, title, cString, "Okay", "");
	return 1;
}

