public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
	if(RobberyInfo[rPlanning] && objectid == RobberyInfo[rObjects][1])
	{
		for(new i = 0; i < MAX_BANK_ROBBERS; i ++)
		{
		    if(RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
		    {
			    PlayerPlaySound(RobberyInfo[rRobbers][i], 3401, 0.0, 0.0, 0.0);
			    GameTextForPlayer(RobberyInfo[rRobbers][i], "~w~Heist started", 5000, 1);
			    SetPlayerAttachedObject(RobberyInfo[rRobbers][i], 8, 19801, 2, 0.091000, 0.012000, -0.000000, 0.099999, 87.799957, 179.500015, 1.345999, 1.523000, 1.270001, 0, 0);
				SetPlayerAttachedObject(RobberyInfo[rRobbers][i], 9, 1550, 1, 0.116999, -0.170999, -0.016000, -3.099997, 87.800018, -179.400009, 0.602000, 0.640000, 0.625000, 0, 0);
				ApplyAnimationEx(RobberyInfo[rRobbers][i], "GOGGLES", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);

				if(!Maskara[playerid]) {
					PlayerInfo[RobberyInfo[rRobbers][i]][pWantedLevel] = 6;
				}

				PlayerInfo[RobberyInfo[rRobbers][i]][pCrimes]++;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO charges VALUES(null, %i, 'The State', NOW(), 'Bank Robbery')", PlayerInfo[RobberyInfo[rRobbers][i]][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 6, crimes = crimes + 1 WHERE uid = %i", PlayerInfo[RobberyInfo[rRobbers][i]][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}

		foreach(new i : Player)
		{
		    if(IsLawEnforcement(i))
		    {
		        SM(i, COLOR_ROYALBLUE, "HQ: A robbery is occurring at the Mulholland Bank. There are %i confirmed robbers.", GetBankRobbers());
			}
		}

        GetDynamicObjectPos(RobberyInfo[rObjects][1], x, y, z);
	    MoveDynamicObject(RobberyInfo[rObjects][0], 1678.248901, -988.181152, 670.224853, 5.0, 90.000000, 0.000000, 0.000000);
		DestroyDynamicObject(RobberyInfo[rObjects][1]);

	    CreateExplosion(x, y, z, 12, 6.0);
		SMA(COLOR_LIGHTGREEN, "Breaking News"WHITE": A bank robbery is currently taking place at the Mulholland Bank!");

		RobberyInfo[rText][0] = CreateDynamic3DTextLabel("[Bank]\n/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2344, -994.6146, 671.0032, 10.0);
		RobberyInfo[rText][1] = CreateDynamic3DTextLabel("[Bank]\n/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2335, -998.6115, 671.0032, 10.0);
		RobberyInfo[rText][2] = CreateDynamic3DTextLabel("[Bank]\n/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2344, -1002.5356, 671.0032, 10.0);
		RobberyInfo[rText][3] = CreateDynamic3DTextLabel("[Bank]\n/lootbox\nto loot deposit box.", COLOR_YELLOW, 1674.2708, -998.4954, 671.0032, 10.0);
		RobberyInfo[rText][4] = CreateDynamic3DTextLabel("[Bank]\n/lootbox\nto loot deposit box.", COLOR_YELLOW, 1674.2708, -994.5173, 671.0032, 10.0);

		RobberyInfo[rStarted] = 1;
		RobberyInfo[rStolen] = 0;
		RobberyInfo[rPlanning] = 0;
	}
    for(new i = 0; i < gasCount; i++)
    {
        if (objectid == GasCans[i][3])
        {

            GetDynamicObjectPos(objectid, x, y, z);
            CreateExplosion(x, y, z, 1, 6.0);
            foreach(new s : Player)
            {
               if(IsPlayerInRangeOfPoint(s, 1.0, x , y, z) && !PlayerInfo[s][pInjured])
               {
                  DamagePlayer(s, 200, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
			   }
			   else if(IsPlayerInRangeOfPoint(s, 5.0, x , y, z) && !PlayerInfo[s][pInjured])
               {
                  DamagePlayer(s, 100, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
			   }
               else if(IsPlayerInRangeOfPoint(s, 10.0, x , y, z) && !PlayerInfo[s][pInjured])
               {
                  DamagePlayer(s, 5, playerid, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
			   }
			}


            DestroyDynamicObject(objectid);
			objectid = INVALID_OBJECT_ID;

            SendClientMessage(playerid, COLOR_LIGHTGREEN, "You shot a gas can and it exploded!");


            for(new j = i; j < gasCount - 1; j++)
            {
                for(new k = 0; k < 4; k++)
                {
                    GasCans[j][k] = GasCans[j + 1][k];
                }
            }
            PlayerInfo[playerid][pGasplace] --;
            gasCount--;


            break;
        }
    }
    return 1;
}
public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
		if((1 <= EventInfo[eType] <= 2) && PlayerInfo[playerid][pJoinedEvent])
		{
		    if(!EventInfo[eStarted])
		    {
		     	GameTextForPlayer(playerid, "~r~Don't shoot until the event starts!", 2000, 3);
			    return 0;
			}
			else if(EventInfo[eType] == 2 && PlayerInfo[hitid][pEventTeam] == PlayerInfo[playerid][pEventTeam])
			{
	            GameTextForPlayer(playerid, "~r~Do not teamkill!", 2000, 3);
			    return 0;
			}
		}
		if(PlayerInfo[playerid][pPaintball] == 2 && PlayerInfo[hitid][pPaintballTeam] == PlayerInfo[playerid][pPaintballTeam])
		{
            GameTextForPlayer(playerid, "~r~Do not teamkill!", 2000, 3);
		    return 0;
		}
		if(PlayerInfo[playerid][pInjured])
		{
			Dyuze(playerid, "Notice", "~r~Don't shoot knock down Player!");
		    return 0;
		}
		if(PlayerInfo[playerid][pAcceptedHelp])
		{
		    GameTextForPlayer(playerid, "~r~Don't shoot at newbies!", 2000, 3);
		    return 0;
		}
	}

    if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{

	
		new bool:playerInGreenZone = IsPlayerAtGreenZone(playerid);
		new bool:issuerInGreenZone = IsPlayerAtGreenZone(hitid);
		if (playerInGreenZone || issuerInGreenZone)
		{
			if (PlayerInfo[playerid][pHitSz] < 5)
			{
				PlayerInfo[playerid][pHitSz]++;
				SCMf(playerid, COLOR_RED, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff} | ANTI-EXPLOIT]{00FFF8} Warning! You have fired at %s in the SafeZone. (%i/5 warnings)", GetRPName(hitid), PlayerInfo[playerid][pHitSz]);
			}
			else
			{
				PlayerInfo[playerid][pHitSz] = 0;
				SendClientMessage(playerid, COLOR_RED, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff} | ANTI-EXPLOIT]{00FFF8} You have been jailed for 50 minutes for exceeding 5 warnings for firing in the safe zone.");
			    PlayerInfo[playerid][pJailType] = 2;

				new reasona[64] = "Firing In SafeZone";
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonedby = 'Naju_Sir', prisonreason = '%s' WHERE uid = %i", reasona, playerid);
		        mysql_tquery(connectionID, queryBuffer);

                PlayerInfo[playerid][pJailTime] = 50 * 60;
	            SetPlayerInJail(playerid);
			}
		}
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
	    if(PlayerInfo[hitid][pGased])
	    {
	        GameTextForPlayer(hitid, "~r~Respawning...", 20000, 5);
            SetTimerEx("Burn3", 1000, false, "i", hitid);
	        SetTimerEx("Burn", 20000, false, "i", hitid);
	        
	        PlayerInfo[hitid][pGased] = false;
            
            SAM(COLOR_YELLOW, "AdmWarning:%s was burned by %s", GetRPName(hitid), GetRPName(playerid), playerid);
            return 0;
	     }
	}
    if(weaponid != WEAPON:22 && weaponid != WEAPON:26 && weaponid != WEAPON:28 && weaponid != WEAPON:32)
	{
		if(PlayerInfo[playerid][pClip] > 0)
		{
		    new
				string[12];

		    PlayerInfo[playerid][pCurrentAmmo] = GetPlayerAmmo(playerid);
		    PlayerInfo[playerid][pClip]--;

		    format(string, sizeof(string), "%i", PlayerInfo[playerid][pClip]);
		    DynamicPlayerTextDrawSetString(playerid, PlayerInfo[playerid][pText][5], string);
		}
	}


	if(!PlayerHasWeapon(playerid, weaponid, true) && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked] && gettime() > PlayerInfo[playerid][pACTime])
	{
	    new
	        string[48];

		format(string, sizeof(string), "Weapon hacks (%s)", GetWeaponNameEx(weaponid));

		SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: %s", GetRPName(playerid), SERVER_BOT, string);
		//BanPlayer(playerid, SERVER_BOT, string);
		Kick(playerid);
	    return 0;
	}

	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
	    if(!PlayerInfo[hitid][pJoinedEvent] && !PlayerInfo[hitid][pPaintball] && PlayerInfo[hitid][pDueling] == INVALID_PLAYER_ID)
		{
	    	GetPlayerArmour(hitid, PlayerInfo[hitid][pArmor]);
		}
	}

    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(WEAPON:22 <= GetPlayerWeapon(playerid) <= WEAPON:36)
		{
	  		if(PlayerInfo[playerid][pACAmmo] == GetPlayerAmmo(playerid))
			{
	  			PlayerInfo[playerid][pACFired]++;
			}

		    if(!PlayerInfo[playerid][pReloading] && PlayerInfo[playerid][pACFired] >= 20)
    		{
		        if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
    		    {
					SAM(COLOR_YELLOW, "AdmWarning: %s was automatically kicked for infinite ammo.", GetRPName(playerid));
					////Log_Write("log_cheat", "%s (uid: %i) was automatically kicked for infinite ammo.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
					KickPlayer(playerid);
				}
			}

			PlayerInfo[playerid][pACAmmo] = GetPlayerAmmo(playerid);
		}
	}
	return 1;
}
CMD:asellland(playerid, params[])
{
	new landid;

    if (!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /asellland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid land.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell a land to a player, bobo!", GetRPName(playerid));
	}

	SetLandOwner(landid, INVALID_PLAYER_ID);
	SM(playerid, COLOR_AQUA, "** You have admin sold land %i.", landid);
	return 1;
}

CMD:lock(playerid, params[])
{
	new id, houseid = GetInsideHouse(playerid), landid = GetNearbyLand(playerid);

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
    	{
		   	if(houseid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
			{
			    if(!(IsHouseOwner(playerid, houseid) || PlayerInfo[playerid][pRentingHouse] == HouseInfo[houseid][hID] || PlayerInfo[playerid][pFurniturePerms] == houseid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission from the house owner to lock this door.");
			    }

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		 		mysql_tquery(connectionID, queryBuffer, "OnPlayerLockFurnitureDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
			else if(landid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
			{
			    if(!(IsLandOwner(playerid, landid) || PlayerInfo[playerid][pLandPerms] == landid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission from the land owner to lock this door.");
			    }

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
				mysql_tquery(connectionID, queryBuffer, "OnPlayerLockLandDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    return 1;
			}
		}
	}

    if((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID && (IsVehicleOwner(playerid, id) || PlayerInfo[playerid][pVehicleKeys] == id || (VehicleInfo[id][vGang] >= 0 && VehicleInfo[id][vGang] == PlayerInfo[playerid][pGang]) || VehicleInfo[id][vFactionType] >= 0 && VehicleInfo[id][vFactionType] == PlayerInfo[playerid][pFaction] || PlayerInfo[playerid][pAdmin]))
	{
	    if(!VehicleInfo[id][vLocked])
	    {
            new string[24];
			VehicleInfo[id][vLocked] = 1;
   		    format(string, sizeof(string), "~r~%s locked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their %s.", GetRPName(playerid), GetVehicleName(id));
		}
		else
		{
			VehicleInfo[id][vLocked] = 0;
            new string[24];
            format(string, sizeof(string), "~b~%s unlocked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their %s.", GetRPName(playerid), GetVehicleName(id));
		}

		SetVehicleParams(id, VEHICLE_DOORS, VehicleInfo[id][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[id][vLocked], VehicleInfo[id][vID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyHouseEx(playerid)) >= 0 && (IsHouseOwner(playerid, id) || PlayerInfo[playerid][pRentingHouse] == HouseInfo[id][hID]))
	{
	    if(!HouseInfo[id][hLocked])
	    {
			HouseInfo[id][hLocked] = 1;

			GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their house door.", GetRPName(playerid));
		}
		else
		{
			HouseInfo[id][hLocked] = 0;

			GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their house door.", GetRPName(playerid));
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[id][hLocked], HouseInfo[id][hID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyGarageEx(playerid)) >= 0 && IsGarageOwner(playerid, id))
	{
	    if(!GarageInfo[id][gLocked])
	    {
			GarageInfo[id][gLocked] = 1;

			GameTextForPlayer(playerid, "~r~Garage locked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their garage door.", GetRPName(playerid));
		}
		else
		{
			GarageInfo[id][gLocked] = 0;

			GameTextForPlayer(playerid, "~g~Garage unlocked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their garage door.", GetRPName(playerid));
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[id][gLocked], GarageInfo[id][gID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyBusinessEx(playerid)) >= 0 && IsBusinessOwner(playerid, id))
	{
	    if(!BusinessInfo[id][bLocked])
	    {
			BusinessInfo[id][bLocked] = 1;

			GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their business door.", GetRPName(playerid));
			ReloadBusiness(id);
		}
		else
		{
			BusinessInfo[id][bLocked] = 0;

			GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their business door.", GetRPName(playerid));
			ReloadBusiness(id);
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyEntranceEx(playerid)) >= 0)
	{
	    new correct_pass;

	    if(!IsEntranceOwner(playerid, id) && strcmp(EntranceInfo[id][ePassword], "None", true) != 0)
		{
			if(isnull(params)) {
                return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /lock [password]");
			} else if(strcmp(params, EntranceInfo[id][ePassword]) != 0) {
			    return SendClientMessage(playerid, COLOR_SYNTAX, "Incorrect password.");
			} else {
				correct_pass = true;
			}
	    }

	    if((correct_pass) || IsEntranceOwner(playerid, id))
	    {
		    if(!EntranceInfo[id][eLocked])
		    {
				EntranceInfo[id][eLocked] = 1;

				GameTextForPlayer(playerid, "~r~Entrance locked", 3000, 6);
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their entrance door.", GetRPName(playerid));
			}
			else
			{
				EntranceInfo[id][eLocked] = 0;

				GameTextForPlayer(playerid, "~g~Entrance unlocked", 3000, 6);
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their entrance door.", GetRPName(playerid));
			}

            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[id][eLocked], EntranceInfo[id][eID]);
			mysql_tquery(connectionID, queryBuffer);
		}

		return 1;
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "You are not close to anything which you can lock.");

	return 1;
}

CMD:househelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "** House Commands: /buyhouse, /lock, /stash, /furniture, /sellhouse, /sellmyhouse.");
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "** House Commands: /lopen, /renthouse, /unrent, /setrent, /tenants, /evict, /evictall, /houseinfo.");
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "** House Commands: /houseinvite");
	return 1;
}

CMD:stash(playerid, params[])
{
	new houseid;

	if((houseid = GetInsideHouse(playerid)) >= 0 && IsHouseOwner(playerid, houseid))
	{
	    new option[14], param[32];

		if(!HouseInfo[houseid][hLevel])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This house has no stash upgrade. '/upgradehouse level' to purchase one.");
	    }
		if(PlayerInfo[playerid][pAdminDuty])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Karibamra Polayadi");
		}
		if(sscanf(params, "s[14]S()[32]", option, param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [balance | deposit | withdraw]");
	    }
	    if(!strcmp(option, "balance", true))
	    {
	        new count;

	        for(new i = 0; i < 10; i ++)
	        {
	            if(HouseInfo[houseid][hWeapons][i])
	            {
	                count++;
	            }
	        }

	        SendClientMessage(playerid, SERVER_COLOR, "Stash Balance:");
	        SM(playerid, COLOR_GREY2, "Cash: $%i/$%i", HouseInfo[houseid][hCash], GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH));
			SM(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", HouseInfo[houseid][hMaterials], GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS), count, GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS));
	        SM(playerid, COLOR_GREY2, "Pot: %i/%i grams | Crack: %i/%i grams", HouseInfo[houseid][hPot], GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED), HouseInfo[houseid][hCrack], GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE));
	        SM(playerid, COLOR_GREY2, "Meth: %i/%i grams | Painkillers: %i/%i pills", HouseInfo[houseid][hMeth], GetHouseStashCapacity(houseid, STASH_CAPACITY_METH), HouseInfo[houseid][hPainkillers], GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS));
            SendClientMessage(playerid, SERVER_COLOR, "Stash Ammunition:");
			SM(playerid, COLOR_GREY2, "HP Ammo: %i/%i | Poison Ammo: %i/%i", HouseInfo[houseid][hHPAmmo], GetHouseStashCapacity(houseid, STASH_CAPACITY_HPAMMO), HouseInfo[houseid][hPoisonAmmo], GetHouseStashCapacity(houseid, STASH_CAPACITY_POISONAMMO));
            SM(playerid, COLOR_GREY2, "FMJ Ammo: %i/%i", HouseInfo[houseid][hFMJAmmo], GetHouseStashCapacity(houseid, STASH_CAPACITY_FMJAMMO));

			if(count > 0)
			{
				SendClientMessage(playerid, SERVER_COLOR, "Stash Weapons:");

            	for(new i = 0; i < 10; i ++)
	            {
    	            if(HouseInfo[houseid][hWeapons][i])
	    	        {
	        	        SM(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]));
					}
				}
	        }
		}
		else if(!strcmp(option, "deposit", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [option]");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Materials, Pot, Crack, Meth, Painkillers, Weapon");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, PoisonAmmo, FMJAmmo");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [cash] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pCash])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH) < HouseInfo[houseid][hCash] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to $%i at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH));
			    }

			    GivePlayerCash(playerid, -value);
			    HouseInfo[houseid][hCash] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored $%i in your house stash.", value);
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [materials] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pMaterials])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS) < HouseInfo[houseid][hMaterials] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i materials at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS));
			    }

			    PlayerInfo[playerid][pMaterials] -= value;
			    HouseInfo[houseid][hMaterials] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i materials in your house stash.", value);
   			}
			else if(!strcmp(option, "pot", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [pot] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPot])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED) < HouseInfo[houseid][hPot] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i grams of pot at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED));
			    }

			    PlayerInfo[playerid][pPot] -= value;
			    HouseInfo[houseid][hPot] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET pot = %i WHERE id = %i", HouseInfo[houseid][hPot], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of pot in your house stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [Crack] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pCrack])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE) < HouseInfo[houseid][hCrack] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i grams of Crack at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE));
			    }

			    PlayerInfo[playerid][pCrack] -= value;
			    HouseInfo[houseid][hCrack] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET crack = %i WHERE id = %i", HouseInfo[houseid][hCrack], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of Crack in your house stash.", value);
   			}
   			else if(!strcmp(option, "meth", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [meth] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pMeth])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_METH) < HouseInfo[houseid][hMeth] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i grams of meth at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_METH));
			    }

			    PlayerInfo[playerid][pMeth] -= value;
			    HouseInfo[houseid][hMeth] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET meth = %i WHERE id = %i", HouseInfo[houseid][hMeth], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of meth in your house stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [painkillers] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS) < HouseInfo[houseid][hPainkillers] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i painkillers at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS));
			    }

			    PlayerInfo[playerid][pPainkillers] -= value;
			    HouseInfo[houseid][hPainkillers] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i painkillers in your house stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new weaponid;

   			    if(sscanf(param, "i", weaponid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
				}
				if(PlayerInfo[playerid][pFaction] >= 0)
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "You are not allowed to store a weapon while in faction.");
				}
				if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
				}
				if(GetHealth(playerid) < 60)
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't store weapons as your health is below 60.");
				}

				for(new i = 0; i < GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS); i ++)
				{
					if(!HouseInfo[houseid][hWeapons][i])
   				    {
						HouseInfo[houseid][hWeapons][i] = weaponid;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weapon_%i = %i WHERE id = %i", i + 1, HouseInfo[houseid][hWeapons][i], HouseInfo[houseid][hID]);
						mysql_tquery(connectionID, queryBuffer);

						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						SM(playerid, COLOR_AQUA, "** You have stored a %s in slot %i of your house stash.", GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]), value + 1);
						return 1;
					}
				}

				SendClientMessage(playerid, COLOR_SYNTAX, "Your house stash has no more slots available for weapons.");
			}
   			else if(!strcmp(option, "hpammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [hpammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pHPAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_HPAMMO) < HouseInfo[houseid][hHPAmmo] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i hollow point ammo at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_HPAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] - value);
			    HouseInfo[houseid][hHPAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET hpammo = %i WHERE id = %i", HouseInfo[houseid][hHPAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of hollow point ammo in your house stash.", value);
   			}
   			else if(!strcmp(option, "poisonammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [poisonammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPoisonAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_POISONAMMO) < HouseInfo[houseid][hPoisonAmmo] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i poison tip ammo at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_POISONAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] - value);
			    HouseInfo[houseid][hPoisonAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET poisonammo = %i WHERE id = %i", HouseInfo[houseid][hPoisonAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of poison tip ammo in your house stash.", value);
   			}
   			else if(!strcmp(option, "fmjammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [deposit] [fmjammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pFMJAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_FMJAMMO) < HouseInfo[houseid][hFMJAmmo] + value)
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your stash can only hold up to %i FMJ ammo at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_FMJAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] - value);
			    HouseInfo[houseid][hFMJAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET fmjammo = %i WHERE id = %i", HouseInfo[houseid][hFMJAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of full metal jacket ammo in your house stash.", value);
   			}
		}
		else if(!strcmp(option, "withdraw", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [option]");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Pot, Crack, Meth, Painkillers, Weapon");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, PoisonAmmo, FMJAmmo");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [cash] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hCash])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }

			    GivePlayerCash(playerid, value);
			    HouseInfo[houseid][hCash] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken $%i from your house stash.", value);
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [materials] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hMaterials])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    PlayerInfo[playerid][pMaterials] += value;
			    HouseInfo[houseid][hMaterials] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i materials from your house stash.", value);
   			}
			else if(!strcmp(option, "pot", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [pot] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hPot])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPot] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

			    PlayerInfo[playerid][pPot] += value;
			    HouseInfo[houseid][hPot] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET pot = %i WHERE id = %i", HouseInfo[houseid][hPot], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of pot from your house stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [Crack] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hCrack])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pCrack] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    PlayerInfo[playerid][pCrack] += value;
			    HouseInfo[houseid][hCrack] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET crack = %i WHERE id = %i", HouseInfo[houseid][hCrack], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of Crack from your house stash.", value);
   			}
   			else if(!strcmp(option, "meth", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [meth] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hMeth])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pMeth] + value > GetPlayerCapacity(playerid, CAPACITY_METH))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
				}

			    PlayerInfo[playerid][pMeth] += value;
			    HouseInfo[houseid][hMeth] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET meth = %i WHERE id = %i", HouseInfo[houseid][hMeth], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of meth from your house stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [painkillers] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    PlayerInfo[playerid][pPainkillers] += value;
			    HouseInfo[houseid][hPainkillers] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i painkillers from your house stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new slots = GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS);

   			    if(sscanf(param, "i", value))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [weapon] [slot (1-%i)]", slots);
				}
				if(value < 1 || value > slots)
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
   			    }
   			    if(!HouseInfo[houseid][hWeapons][value-1])
   			    {
   			        return SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
				}

				GiveWeapon(playerid, HouseInfo[houseid][hWeapons][value-1]);
				SM(playerid, COLOR_AQUA, "** You have taken a %s from slot %i of your house stash.", GetWeaponNameEx(HouseInfo[houseid][hWeapons][value-1]), value);

				HouseInfo[houseid][hWeapons][value-1] = 0;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weapon_%i = 0 WHERE id = %i", value, HouseInfo[houseid][hID]);
				mysql_tquery(connectionID, queryBuffer);
			}
   			else if(!strcmp(option, "hpammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [hpammo] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hHPAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pHPAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + value);
			    HouseInfo[houseid][hHPAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET hpammo = %i WHERE id = %i", HouseInfo[houseid][hHPAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of hollow point ammo from your house stash.", value);
   			}
   			else if(!strcmp(option, "poisonammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [poisonammo] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hPoisonAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPoisonAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i poison ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPoisonAmmo], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + value);
			    HouseInfo[houseid][hPoisonAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET poisonammo = %i WHERE id = %i", HouseInfo[houseid][hPoisonAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of poison tip ammo from your house stash.", value);
   			}
   			else if(!strcmp(option, "fmjammo", true))
			{
       			if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stash [withdraw] [fmjammo] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hFMJAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pFMJAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i FMJ ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] + value);
			    HouseInfo[houseid][hFMJAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET fmjammo = %i WHERE id = %i", HouseInfo[houseid][hFMJAmmo], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of full metal jacket ammo from your house stash.", value);
   			}
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any stash which you can use.");
	}

	return 1;
}
CMD:robstore(playerid)
{
	new count;

	if(!IsPlayerInRangeOfPoint(playerid, 20.0, 1111.884033, -1304.514526, 13.944063) && !IsPlayerInRangeOfPoint(playerid, 20.0, 1301.288085 , -1875.521484, 13.632812))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} You are not in range of the Store Rob.");
	}
	if(PlayerInfo[playerid][pLockpick] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any lockpicks left.");
	}
    
	if(OtherRobberyInfo[rStoreTime] > 0)
	{
	    return SCMf(playerid, COLOR_ERROR, "[ERROR]{ffffff} The Store can be robbed again in %i hours. You can't rob it now.", OtherRobberyInfo[rStoreTime]);
	}
	if(IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]{ffffff} You can't rob the Store as a law enforcer.");
	}

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}

	if(count < 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There needs to be at least 2+ LEO on-duty in order to rob the store.");
	}

	foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SM(i, COLOR_RED, "** ALERT: Idlewood Store Robbery Has Been Started");
			PlayerPlaySound(playerid, 2200, 0.0, 0.0, 0.0);
		}
	}
	
	
	PlayerInfo[playerid][pLockpick] --;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET lockpick = %i WHERE uid = %i", PlayerInfo[playerid][pLockpick], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	
	new string[128];
	format(string, sizeof(string), "~r~Store Robbery on Progress");
    //DynamicTextDrawSetString(Textdraw, string);

	GameTextForPlayer(playerid, "~w~Robbing The Store wait for 60sec....", 60000, 3);
	ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 60000, 0);
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("storerob", 60000, false, "i", playerid);
	//ApplyActorAnimation(bRobbing[0], "SHOP", "SHP_HandsUp_Scr", 4.1, 0, 0, 0, 1, 0);
	return 1;
}

CMD:robhouse(playerid, params[])//robhouse
{
	new houseid = GetInsideHouse(playerid), count;
	new amount =  30000 + random(1000);
	if(houseid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You aren't inside a house that you can rob.");
	}
	if(IsHouseOwner(playerid, houseid)) 
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't rob the your house.");
	}
	if(PlayerInfo[playerid][pRobbingHouse] >= 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You're already robbing a house.");
	}
	if(OtherRobberyInfo[rHousetime] > 0)
	{
	    return SCMf(playerid, COLOR_ERROR, "[ERROR]{ffffff} House can be robbed again in %i minitues. You can't rob it now.", OtherRobberyInfo[rHousetime]);
	}
	if(PlayerInfo[playerid][pDuty] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You can't rob the house while on-duty.");
	}

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}

	if(count < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "There needs to be at least 1+ LEO on-duty in order to rob the house.");
	}

	foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SM(i, COLOR_ROYALBLUE, "** HQ: A robbery is occurring at the %s. All units respond immediately.", GetZoneName(HouseInfo[houseid][hPosX],HouseInfo[houseid][hPosY],HouseInfo[houseid][hPosZ]));
			SetPlayerCheckpoint(i, HouseInfo[houseid][hPosX],HouseInfo[houseid][hPosY],HouseInfo[houseid][hPosZ], 3.0);
		}
	}
	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 0, 60000);

	new string[128];
	SCMf(playerid, COLOR_GENERAL3, "[RobInfo]{ffffff} You earned %i for robing this house vault.",amount);
	SMA( COLOR_GLOBAL, "House Robbery Sucess Thief Earned %i Black Money", amount);
	format(string, sizeof(string), "~r~House Robbery on Progress");
    DynamicTextDrawSetString(Textdraw2, string);
 	SendProximityMessage(playerid, 20.0, COLOR_BLUE, "* %s attempts to rob the house.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_GREY2,"** Wait until cops arrive for roleplay purposes. (( You can door shout by inputting '/ds'. ))");
	PlayerInfo[playerid][pDirtyCash] += amount;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	OtherRobberyInfo[rHousetime] = 25;
	return 1;
}

CMD:resetrobhouse(playerid, params[])
{
	new businessid;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", businessid))
	{
	    SendClientMessage(playerid, COLOR_GREY2, "Usage: /resetrobhouse [businessid]");
	    return 1;
	}
	HouseInfo[businessid][hRobbed] = 0;
	HouseInfo[businessid][hRobbing] = 0;
	ReloadHouse(businessid);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET robbed = %i, robbing = %i WHERE id = %i", HouseInfo[businessid][hRobbed], HouseInfo[businessid][hRobbing], HouseInfo[businessid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has reset house (ID: %d) the house robbery timer.", GetRPName(playerid), businessid);
	return 1;
}

forward storerob(playerid);
public storerob(playerid)
{
    PlayerInfo[playerid][pDirtyCash] += 80000;
    OtherRobberyInfo[rStoreTime] = 45;

	
    SMA(COLOR_WHITE, ""GREEN"Breaking News"WHITE" Idlewood Store Has Been Robbed %d Has Been Stolen.", PlayerInfo[playerid][pDirtyCash]);
    TogglePlayerControllable(playerid, true);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

}
CMD:srev(playerid, params[])
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
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /revive [playerid]");
	}
	if(!PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not injured.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't heal yourself.");
	}

	GivePlayerCash(targetid, -10000);
	GivePlayerCash(playerid, 5000);
    KillTimer(killtimerz[targetid]);
    ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.0, 1, 1, 1, 0, 0);
    GameTextForPlayer(targetid, "~g~Reving...", 10000, 5);
	SetTimerEx("SRevive", 10000, false, "i", targetid);
	SetTimerEx("Food", 10000, false, "i", playerid);
	SendProximityMessage(targetid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has been revived.", GetRPName(targetid));
	SAM(COLOR_YELLOW, "AdmWarning:%s has been Revived by ems %s", GetRPName(targetid), GetRPName(playerid), playerid);

	return 1;
}

forward SRevive(targetid);
public SRevive(targetid)
{

	PlayerInfo[targetid][pInjured] = 0;
	PlayerInfo[targetid][pHunger] = 25;
	PlayerInfo[targetid][pHungerTimer] = 0;
    PlayerInfo[targetid][pThirst] = 25;
	PlayerInfo[targetid][pThirstTimer] = 0;
	PlayerInfo[targetid][pGased] = false;


    TogglePlayerControllable(targetid, 1);
	SetPlayerHealth(targetid, 50.0);
	GivePlayerCash(targetid, -5000);
	ClearAnimations(targetid, SYNC_ALL);
	
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

	SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by an Doctor");
	SendProximityMessage(targetid, 20.0, SERVER_COLOR, "**{C2A2DA} Medic successfully healed %s wound.", GetRPName(targetid));
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET thirst = %i, thirsttimer = %i WHERE uid = %i", PlayerInfo[targetid][pThirst], PlayerInfo[targetid][pThirstTimer], PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET hunger = %i, hungertimer = %i WHERE uid = %i", PlayerInfo[targetid][pHunger], PlayerInfo[targetid][pHungerTimer], PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return 1;
}
forward Food(playerid);
public Food(playerid)
{
	
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
    return 1;
}

CMD:sr(playerid) {
	new Float:health;
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1087.855957, -1363.594116, 13.714235) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2284.585204, -1677.628662, 14.455604)&& !IsPlayerInRangeOfPoint(playerid, 6.0, 429.939117, -1793.747680, 5.546875)&& !IsPlayerInRangeOfPoint(playerid, 10.0, 1115.476640, -929.294067, 43.134517)) return 1;
	if(gettime() - PlayerInfo[playerid][pLastSell] < 15)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only use this command every 15 sec. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastSell]));
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You are not inside of any vehicle.");
	}
	if(PlayerInfo[playerid][pCash] < 5000)
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
	    PlayerInfo[playerid][pLastSell] = gettime();
	    GivePlayerCash(playerid, -5000);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("TimerSelfRepair", 10000, false, "i", playerid);
		SendProximityMessage(playerid, 20.0, COLOR_AQUA, "** %s is repairing his/her vehicle.", GetRPName(playerid));
	}
	return 1;
}

CMD:upgradehouse(playerid, params[])
{
	new
		houseid = GetNearbyHouseEx(playerid),
		option[10],
		param[12],
		string[20];

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "s[10]S()[12]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradehouse [level]");
	}
	if(!strcmp(option, "level", true))
	{
	    new cost = (HouseInfo[houseid][hLevel] * 25000) + 25000;

	    if(HouseInfo[houseid][hLevel] >= 5)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Your house is already at the maximum level possible.");
		}
		if(isnull(param) || strcmp(param, "confirm", true) != 0)
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradehouse [level] [confirm]");
		    SM(playerid, COLOR_WHITE, "You are about to upgrade to level %i/5 which will cost you $%i.", HouseInfo[houseid][hLevel] + 1, cost);
			return 1;
		}
		if(PlayerInfo[playerid][pCash] < cost)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much cash.");
		}

		HouseInfo[houseid][hLevel]++;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET level = level + 1 WHERE id = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer);

		format(string, sizeof(string), "~r~-$%i", cost);
		GameTextForPlayer(playerid, string, 5000, 1);

		GivePlayerCash(playerid, -cost);
		ReloadHouse(houseid);

		if(HouseInfo[houseid][hLevel] == 1)
		{
		    SM(playerid, COLOR_YELLOW, "You have upgraded your house to level %i/5. You unlocked a stash for your house! (/stash)", HouseInfo[houseid][hLevel]);
		}
		else
		{
			SM(playerid, COLOR_YELLOW, "You have upgraded your house to level %i/5. Your stash capacity was increased.", HouseInfo[houseid][hLevel]);
		}

		SM(playerid, COLOR_YELLOW, "Your tenant and furniture capacity were also both increased to %i/%i.", GetHouseTenantCapacity(houseid), GetHouseFurnitureCapacity(houseid));
		//Log_Write("log_property", "%s (uid: %i) upgraded their house (id: %i) to level %i for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], HouseInfo[houseid][hID], HouseInfo[houseid][hLevel], cost);
	}
	return 1;
}

CMD:sssellhouse(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid), targetid, amount;

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellhouse [playerid] [amount]");
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

	PlayerInfo[targetid][pHouseOffer] = playerid;
	PlayerInfo[targetid][pHouseOffered] = houseid;
	PlayerInfo[targetid][pHousePrice] = amount;

	SM(targetid, COLOR_AQUA, "** %s offered you their house for $%i (/accept house).", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your house for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:houseinfo(playerid, params[])
{
    new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
 }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT (SELECT COUNT(*) FROM furniture WHERE houseid = %i) AS furnitureCount, (SELECT COUNT(*) FROM users WHERE rentinghouse = %i) AS tenantCount", HouseInfo[houseid][hID], HouseInfo[houseid][hID]);
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_HOUSE_INFORMATION, playerid);

	return 1;
}

CMD:donate(playerid, params[])
{
    new targetid;
    
    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /donateweapon [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is either weapon restricted or played less than two playing hours.");
    }
    if(PlayerInfo[targetid][pDonateWeapon] == 1) {
		return SendClientMessage(playerid, COLOR_GREY2, "The player has already Donated");
	}

    PlayerInfo[targetid][pDonateWeapon] = 1;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET donateweapon = %i WHERE uid = %i", PlayerInfo[targetid][pDonateWeapon], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
    
    SM(targetid, COLOR_AQUA, "You have received a "RED"Weapon Permanent{CCFFFF} from Donator By %s", GetRPName(playerid));
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has given a Weapon Permanent to %s From Donator", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

iscop(playerid)
{
	return GetFactionType(playerid) == FACTION_POLICE || GetFactionType(playerid) == FACTION_FEDERAL;
}

CMD:vradar(playerid, params[])
{
	if(!iscop(playerid))
	    return SendClientMessage(playerid, COLOR_GREY, "You are not a law enforcement officer!");
	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xFF0000FF, "You cannot use a dashboard radar outside of a vehicle.");

	switch (CarRadars[playerid])
	{
		case 0: // player has not deployed dashboard radar
		{
			CarRadars[playerid] = 1;
			PlayerTextDrawShow(playerid, _crTextTarget[playerid]);
			PlayerTextDrawShow(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawShow(playerid, _crTickets[playerid]);

			SendClientMessage(playerid, COLOR_WHITE, "You are now using your dashboard radar.");
			SetPVarInt(playerid, "_lastTicketWarning", 0);
		}

		case 1..2: // dashboard radar has been deployed
		{
			CarRadars[playerid] = 0;
			PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
			PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawHide(playerid, _crTickets[playerid]);

			SendClientMessage(playerid, COLOR_WHITE, "You are no longer using your dashboard radar.");
			DeletePVar(playerid, "_lastTicketWarning");
		}
	}

	return 1;
}

CMD:prio(playerid, params[])
{
	new text[128];
    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[128]", text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /prio [text]");
	}
	foreach(new i : Player)
	{
		DynamicTextDrawSetString(Textdraw2, text);
		TextDrawShowForPlayer(i, Textdraw2);
		SetTimerEx("Textdraw2Hide", 10000, false, "i", i);
		PlayerPlaySound(i,1150,0.0,0.0,0.0);
	}
	return 1;
}
CMD:apple(playerid)
{
    if(PlayerInfo[playerid][pApple] <= 0)
    {
        return SendClientMessage(playerid, COLOR_TWEET, "[ERROR]{ffffff} You don't have any Apple in your inventory.");
    }
    if(PlayerInfo[playerid][pHunger] >= 100)
    {
       return SendClientMessage(playerid, COLOR_GREY, "You aren't hungry!");
	}
    PlayerInfo[playerid][pApple]--; 
    if(IsPlayerInAnyVehicle(playerid) == true)
    {
         ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
    }
    PlayerInfo[playerid][pHunger] += 20;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET apple = %i, hunger = %i WHERE uid = %i", PlayerInfo[playerid][pApple], PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
    return 1;
}

CMD:eat(playerid, params[])
{
    if(PlayerInfo[playerid][pFMJAmmo] <= 0 && PlayerInfo[playerid][pRedroll] <= 0)
    {
        return SendClientMessage(playerid, COLOR_TWEET, "[ERROR]{ffffff} You don't have any food in your inventory.");
    }
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /eat [Burger | Chickenroll]");
	}
    if (PlayerInfo[playerid][pHunger] >= 100)
    return SendClientMessage(playerid, COLOR_GREY, "You aren't hungry!");
	if(!strcmp(params, "burger", true))
	{
       PlayerInfo[playerid][pFMJAmmo]--; // Decrement burger count
       if(IsPlayerInAnyVehicle(playerid) == true)
	   {
         ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
	   }
       PlayerInfo[playerid][pHunger] += 10;
       mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fmjammo = %i, hunger = %i WHERE uid = %i", PlayerInfo[playerid][pFMJAmmo], PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pID]);
       mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "chickenroll", true))
	{
       PlayerInfo[playerid][pRedroll]--; // Decrement burger count
       if(IsPlayerInAnyVehicle(playerid) == true)
	   {
         ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
	   }
       PlayerInfo[playerid][pHunger] = 100;
       mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energyroll = %i, hunger = %i WHERE uid = %i", PlayerInfo[playerid][pRedroll], PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pID]);
       mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /eat [Burger | Chickenroll]");
	}
    PlayerInfo[playerid][pHungerTimer] = 0;
    return 1;
}


CMD:drink(playerid, params[])
{
    if(PlayerInfo[playerid][pMilkshake] <= 0 && PlayerInfo[playerid][pRedbull] <= 0)
    {
        return SendClientMessage(playerid, COLOR_TWEET, "[ERROR]{ffffff} You don't have any food in your inventory.");
    }
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drink [Milkshake | Redbull]");
	}
    if (PlayerInfo[playerid][pThirst] >= 100)
    return SendClientMessage(playerid, COLOR_GREY, "You aren't thirsty!");
	if(!strcmp(params, "milkshake", true))
	{
       PlayerInfo[playerid][pMilkshake]--; // Decrement burger count
       if(IsPlayerInAnyVehicle(playerid) == true)
       {
         ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	   }
       PlayerInfo[playerid][pThirst] += 10;
       mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET poisonammo = %i, thirst = %i WHERE uid = %i", PlayerInfo[playerid][pMilkshake], PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pID]);
       mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "redbull", true))
	{
       PlayerInfo[playerid][pRedbull]--; // Decrement burger count
       if(IsPlayerInAnyVehicle(playerid) == true)
       {
         ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	   }
       PlayerInfo[playerid][pThirst] = 100;
       mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energydrink = %i, thirst = %i WHERE uid = %i", PlayerInfo[playerid][pRedbull], PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pID]);
       mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drink [Milkshake | Redbull]");
	}



    return 1;
}
CMD:dre(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerInfo[playerid][pAdmin] < 8 && PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(factionVehicle{vehicleid})
	{
        DestroyVehicleEx(vehicleid);
        factionVehicle{vehicleid} = false;
	    return SAM(COLOR_RED, "ADMIN : %s Has Destroyed All Un Occupied Faction Vehicles Spawned From Faction Garage.", GetRPName(playerid));
	}

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(factionVehicle{i})
	    {
	        DestroyVehicle(i);
	        factionVehicle{i} = false;
		}
	}

	SAM(COLOR_RED, "ADMIN : %s Has Destroyed All Un Occupied Faction Vehicles Spawned From Faction Garage.", GetRPName(playerid));
	return 1;

}

CMD:drgs(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(VehicleInfo[vehicleid][vGang] > 0 && !IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
	{
	    DespawnVehicle(vehicleid, true);
	    ResetVehicle(vehicleid);
	    return SAM(COLOR_RED, "ADMIN : %s Has Destroyed vehicle.", GetRPName(playerid));
	}

	return 1;

}
CMD:drgsall(playerid, params[])
{
	
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    foreach(new vehicleid : Vehicle)
	{
		if(VehicleInfo[vehicleid][vGang] > 0 && !IsVehicleOccupied(vehicleid))
		{
			DespawnVehicle(vehicleid, true);
			ResetVehicle(vehicleid);
		}
	}
	SAM(COLOR_RED, "ADMIN : %s Has Destroyed vehicle.", GetRPName(playerid));

	return 1;

}
CMD:de(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(IsValidVehicle(vehicleid))
	{
	    DespawnVehicle(vehicleid, true);
	    ResetVehicle(vehicleid);
	    return SAM(COLOR_RED, "ADMIN : %s Has Destroyed vehicle.", GetRPName(playerid));
	}

	return 1;

}
