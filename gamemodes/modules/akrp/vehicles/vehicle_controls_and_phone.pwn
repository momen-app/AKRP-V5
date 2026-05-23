CMD:hotwire(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:health;
	
	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	}
	if(PlayerInfo[playerid][pToolkit] == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must have a toolkit to use this command.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be turned on.");
	}
	if(vehicleFuel[vehicleid] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no fuel left in this vehicle.");
	}

	if(!GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
	    if(PlayerInfo[playerid][pEngine])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are already attempting to hotwire this vehicle.");
		}
	    GetVehicleHealth(vehicleid, health);

	    PlayerInfo[playerid][pEngine] = 1;
		SetTimerEx("SetVehicleEngineHotwire", 20010, 0, "dd",  vehicleid, playerid);
  		SendClientMessage(playerid,COLOR_WHITE,"You are currently hotwiring this vehicle.");
  		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s starts hotwiring the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle's engine is already on.");
	}

	return 1;
}

CMD:engine(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:health;

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	if(!VehicleHasEngine(vehicleid)) return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be turned on.");
	if(vehicleFuel[vehicleid] <= 0) return SendClientMessage(playerid, COLOR_SYNTAX, "There is no fuel left in this vehicle.");
	if(VehicleInfo[vehicleid][vOwnerID] && !IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't start/stop the engine this vehicle as it doesn't belong to you.");
	}
	if(VehicleInfo[vehicleid][vGang] > 0 && PlayerInfo[playerid][pGang] != VehicleInfo[vehicleid][vGang])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't start/stop the engine this vehicle as it doesn't belong to your gang.");
	}
	if(vehicleid == robcar) return SendClientMessage(playerid, COLOR_TEAL, "Error:"WHITE" You do not have keys to this vehicle, therefore you can't turn on its engine.\n (use /hotwire)");

	if(!GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		GetVehicleHealth(vehicleid, health);
 		if(PlayerInfo[playerid][pEngine]) return SendClientMessage(playerid, COLOR_SYNTAX, "You are already attempting to turn your engine on.");
		if(health < 251.0) return SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle engine won't start. This vehicle engine was wrecked!");

		PlayerInfo[playerid][pEngine] = 1;
		SetTimerEx("SetVehicleEngine", 1010, 0, "dd",  vehicleid, playerid);
		SendClientMessage(playerid,COLOR_WHITE,"Vehicle engine starting, please wait..");
	}
	else
	{
		SetVehicleParams(vehicleid, VEHICLE_ENGINE, false);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off the engine of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}
CMD:resetrobcar(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You are not authorized to use this command.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /resetrobcar [confirm]");
	}
	OtherRobberyInfo[rCarTime] = 0;
	RestartCarRob();
	SAM(COLOR_LIGHTRED,"AdmCmd: %s has reset car robbery timer.", GetRPName(playerid));
	return 1;
}
CMD:flash(playerid, params[])
{
	new vehicleid,panels,doors,lights,tires;
	vehicleid = GetPlayerVehicleID(playerid);

	if(!IsLawEnforcement(playerid) && GetFactionType(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessage(playerid, COLOR_WHITE, "You are not the driver.");
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, "You are not in a vehicle!");
        return 1;
	}
	if(!IsAFlashingEXB(GetPlayerVehicleID(playerid)))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "This vehicle doesn't support ELM lights.");
	}
	if(!Flasher[vehicleid])
	{
		GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
		SetVehicleParams(vehicleid, VEHICLE_LIGHTS, true);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on the emergency lights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		Flasher[vehicleid] = 1;
	}
	else
	{
		GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
		UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);
		Flasher[vehicleid] = 0;
		SetVehicleParams(vehicleid, VEHICLE_LIGHTS, false);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off the emergency lights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}

CMD:seatbelt(playerid)
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	{
        SendClientMessage(playerid, COLOR_WHITE, "You are not in a vehicle!");
        return 1;
    }
    if(IsPlayerInAnyVehicle(playerid) == 1 && ExBJck[playerid] == 0)
	{
        ExBJck[playerid] = 1;
        if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
		    SetPlayerAttachedObject(playerid, 0, 18645, 2, 0.1, 0.02, 0.0, 0.0, 90.0, 90.0, 1.0, 1.0, 1.0);
            SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s reaches for their helmet, and puts it on.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have put on your helmet.");
        }
        else
		{
            SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s reaches for their seatbelt, and buckles it up.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have put on your seatbelt.");
        }

    }
    else if(IsPlayerInAnyVehicle(playerid) == 1 && ExBJck[playerid] == 1)
	{
        ExBJck[playerid] = 0;
		if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
		    RemovePlayerAttachedObject(playerid, 7);
            SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s reaches for their helmet, and takes it off.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have taken off your helmet.");
        }
        else
		{
            SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s reaches for their seatbelt, and unbuckles it.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
        }
    }
    return 1;
}

CMD:checkbelt(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "i", giveplayerid)) return SM(playerid, COLOR_SYNTAX, "Usage: /checkbelt [playerid]");

    if(GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
	{
        SM(playerid,COLOR_GREY,"That player is not in any vehicle!");
        return 1;
    }
    if(!IsPlayerConnected(giveplayerid) || !IsPlayerInRangeOfPlayer(playerid, giveplayerid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}

    new stext[4];
    if(ExBJck[giveplayerid] == 0)
	{
		stext = "off";
	}
    else
	{
		stext = "on";
	}
    if(IsAMotorBike(GetPlayerVehicleID(playerid)))
	{
        SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s looks at %s, checking to see if they are wearing a helmet.", GetRPName(playerid),GetRPName(giveplayerid));
        SM(playerid,COLOR_WHITE, "%s's helmet is currently %s.", GetRPName(giveplayerid) , stext);
	}
	else
	{
    	SendProximityMessage(playerid, 20.0, COLOR_LE, "* %s peers through the window at %s, checking to see if they are wearing a seatbelt.", GetRPName(playerid),GetRPName(giveplayerid));
    	SM(playerid,COLOR_WHITE, "%s's seat belt is currently %s.", GetRPName(giveplayerid) , stext);
    }
    return 1;
}

CMD:checkmybelt(playerid, params[])
{
    if(ExBJck[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have your seatbelt on.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Your seatbelt is off.");
	}
	return 1;
}

CMD:callems(playerid, params[])
{
    foreach(new i : Player)
    if(GetFactionType(i) == FACTION_MEDIC)
    {
	    SM(i, COLOR_DOCTOR, "Emergency Hotline:");
		SM(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerInfo[playerid][pPhone]);
		SM(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
		SM(i, COLOR_WHITE, "** Use '/trackcall %i' to track the caller's location.", playerid);
	}
	
	PlayerInfo[playerid][pEmergencyCall] = 120;
	PlayerInfo[playerid][pEmergencyType] = FACTION_MEDIC;
						
	SendClientMessage(playerid, COLOR_DISPATCH, "All onduty medical teams in the area has notified.");
	return 1;
}

CMD:backfire(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	}
	if(Player_Fire_Enabled[playerid])
	{
		Player_Fire_Enabled[playerid] = false;
		SendClientMessage(playerid, COLOR_RED, "You turn off the backfire mode of you car.");
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off the backfire mode of his %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
		Player_Fire_Enabled[playerid] = true;
		SendClientMessage(playerid, COLOR_RED, "You turn on the backfire mode of you car.");
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on the backfire mode of his %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}

CMD:lights(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a vehicle to use this command.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no lights which can be turned on.");
	}

	if(!GetVehicleParams(vehicleid, VEHICLE_LIGHTS))
	{
	    SetVehicleParams(vehicleid, VEHICLE_LIGHTS, true);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_LIGHTS, false);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:hood(playerid)
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleHasWindows(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no hood.");
	}

	if(!GetVehicleParams(vehicleid, VEHICLE_BONNET))
	{
	    SetVehicleParams(vehicleid, VEHICLE_BONNET, true);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_BONNET, false);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s closes the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:trunk(playerid)
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleHasWindows(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no boot.");
	}

	if(!GetVehicleParams(vehicleid, VEHICLE_BOOT))
	{
	    SetVehicleParams(vehicleid, VEHICLE_BOOT, true);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_BOOT, false);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s closes the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}


CMD:myupgrades(playerid, params[])
{
    SM(playerid, COLOR_YELLOW, "_____ %s's upgrades (%i points available) _____", GetRPName(playerid), PlayerInfo[playerid][pUpgradePoints]);
	SM(playerid, SERVER_COLOR, "Shealth: %.0f/100{C8C8C8} You spawn with %.1f health at the hospital after death.", PlayerInfo[playerid][pSpawnHealth], PlayerInfo[playerid][pSpawnHealth]);
	SM(playerid, COLOR_YELLOW, "Sarmor: %.0f/100{C8C8C8} You spawn with %.1f armor at the hospital after death.", PlayerInfo[playerid][pSpawnArmor], PlayerInfo[playerid][pSpawnArmor]);
	SM(playerid, SERVER_COLOR, "Addict: %i/3{C8C8C8} You gain an extra %.1f health and armor when using drugs.", PlayerInfo[playerid][pAddictUpgrade], PlayerInfo[playerid][pAddictUpgrade] * 5.0);
	SM(playerid, COLOR_YELLOW, "Asset: %i/4{C8C8C8} You can own %i houses, %i businesses, %i garages & %i vehicles.", PlayerInfo[playerid][pAssetUpgrade], GetPlayerAssetLimit(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
    SM(playerid, SERVER_COLOR, "Labor: %i/5{C8C8C8} You earn an extra %i percent cash to your paycheck when working.", PlayerInfo[playerid][pLaborUpgrade], PlayerInfo[playerid][pLaborUpgrade] * 2);
    SM(playerid, COLOR_YELLOW, "Inventory: %i/5{C8C8C8} This upgrade increases the capacity for your items. [/inv]", PlayerInfo[playerid][pInventoryUpgrade]);
	return 1;
}
CMD:changename(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1483.496459, -1768.248901, 18.810064))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the desk at city hall.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /changename [new name]");
	}
	if(!(3 <= strlen(params) <= 20))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your name must range from 3 to 20 characters.");
	}
	if(strfind(params, "_") == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your name needs to contain at least one underscore.");
	}
	if(!IsValidName(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid characters. Your name may only contain letters and underscores.");
	}
	if(PlayerInfo[playerid][pCash] < PlayerInfo[playerid][pLevel] * 5000)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need at least $%i to change your name at your level.", PlayerInfo[playerid][pLevel] * 5000);
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You aren't allowed to change your name while on admin duty,");
	}

    PlayerInfo[playerid][pFreeNamechange] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", params);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptNameChange", "is", playerid, params);
	return 1;
}
CMD:upgrade(playerid, params[])
{
    new cost = 15000;
    new cost2 = cost - PlayerInfo[playerid][pCash];

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1483.496459, -1768.248901, 18.810064))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the desk at city hall.");
	}
	if(PlayerInfo[playerid][pUpgradePoints] < 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You have no upgrade points available which you can spend.");
	}
	if(PlayerInfo[playerid][pCash] < cost)
	{
		return SM(playerid, COLOR_GREY, "You can't afford any upgrade. You need more %d to afford upgrade.", cost2);
	}
	if(isnull(params))
	{
	    SM(playerid, COLOR_SYNTAX, "Usage: /upgrade [option] (%i points available)", PlayerInfo[playerid][pUpgradePoints]);
	    SendClientMessage(playerid, COLOR_WHITE, "List of options: Addict, Asset, SpawnHealth, SpawnArmor, Labor, Inventory");
	}
	else if(!strcmp(params, "inventory", true))
	{
	    if(PlayerInfo[playerid][pInventoryUpgrade] >= 5)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Your inventory skill is already upgraded to its maximum level of 5.");
		}

		PlayerInfo[playerid][pInventoryUpgrade]++;
		PlayerInfo[playerid][pUpgradePoints]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET inventoryupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerInfo[playerid][pInventoryUpgrade], PlayerInfo[playerid][pUpgradePoints], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_GREEN, "You upgraded your inventory skill to %i/5. Your inventory capacity was increased.", PlayerInfo[playerid][pInventoryUpgrade]);
 	}
 	else if(!strcmp(params, "addict", true))
	{
	    if(PlayerInfo[playerid][pAddictUpgrade] >= 3)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Your addict skill is already upgraded to its maximum level of 3.");
		}

  		if(PlayerInfo[playerid][pCash] < cost)
		{
	    	return SM(playerid, COLOR_SYNTAX, "You need to have at least $%i on hand to buy this upgrade.", cost);
		}

		PlayerInfo[playerid][pCash] -= cost;

		PlayerInfo[playerid][pAddictUpgrade]++;
		PlayerInfo[playerid][pUpgradePoints]--;

  		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET addictupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerInfo[playerid][pAddictUpgrade], PlayerInfo[playerid][pUpgradePoints], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		SM(playerid, COLOR_YELLOW, "You upgraded your addict skill to level %i/3. You now gain %.1f more health & armor when using drugs.", PlayerInfo[playerid][pAddictUpgrade], PlayerInfo[playerid][pAddictUpgrade] * 5.0);
 	}
 	else if(!strcmp(params, "labor", true))
	{
	    if(PlayerInfo[playerid][pLaborUpgrade] >= 5)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Your labor skill is already upgraded to its maximum level of 5.");
		}

		PlayerInfo[playerid][pLaborUpgrade]++;
		PlayerInfo[playerid][pUpgradePoints]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET laborupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerInfo[playerid][pLaborUpgrade], PlayerInfo[playerid][pUpgradePoints], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_GREEN, "You upgraded your labor skill to level %i/5. You now earn %i percent more extra cash when you work.", PlayerInfo[playerid][pLaborUpgrade], PlayerInfo[playerid][pLaborUpgrade] * 2);
	}
 	else if(!strcmp(params, "asset", true))
	{
	    if(PlayerInfo[playerid][pAssetUpgrade] >= 4)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Your asset skill is already upgraded to its maximum level of 4.");
		}
  		if(PlayerInfo[playerid][pCash] < cost)
		{
	    	return SM(playerid, COLOR_SYNTAX, "You need to have at least $%i on hand to buy this upgrade.", cost);
		}

		PlayerInfo[playerid][pCash] -= cost;

		PlayerInfo[playerid][pAssetUpgrade]++;
		PlayerInfo[playerid][pUpgradePoints]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET assetupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerInfo[playerid][pAssetUpgrade], PlayerInfo[playerid][pUpgradePoints], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You upgraded your asset skill to level %i/4. You can now own %i/%i houses and garages and %i/%i businesses and vehicles.", PlayerInfo[playerid][pAssetUpgrade], GetPlayerAssetLimit(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
 	}
	else if(!strcmp(params, "spawnhealth", true))
	{
	    if(PlayerInfo[playerid][pSpawnHealth] >= 100)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Your spawn health is at maximum (100).");
	    }
  		if(PlayerInfo[playerid][pCash] < cost)
		{
	    	return SM(playerid, COLOR_SYNTAX, "You need to have at least $%i on hand to buy this upgrade.", cost);
		}

		PlayerInfo[playerid][pCash] -= cost;

	    PlayerInfo[playerid][pSpawnHealth] += 0.5;
	    PlayerInfo[playerid][pUpgradePoints]--;

	    SM(playerid, COLOR_YELLOW, "You have upgraded your spawn health. You will now spawn with %.1f health after death.", PlayerInfo[playerid][pSpawnHealth]);
	}
	else if(!strcmp(params, "spawnarmor", true))
	{
	    if(PlayerInfo[playerid][pSpawnArmor] > 25)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Your spawn armor is at maximum (25).");
	    }
  		if(PlayerInfo[playerid][pCash] < cost)
		{
	    	return SM(playerid, COLOR_SYNTAX, "You need to have at least $%i on hand to buy this upgrade.", cost);
		}

		PlayerInfo[playerid][pCash] -= cost;

	    PlayerInfo[playerid][pSpawnArmor] += 0.5;
	    PlayerInfo[playerid][pUpgradePoints]--;

	    SM(playerid, COLOR_YELLOW, "You have upgraded your spawn armor. You will now spawn with %.1f armor after death.", PlayerInfo[playerid][pSpawnArmor]);
	}
	return 1;
}

CMD:buylevel(playerid, params[]) return callcmd::levelup(playerid, params);
CMD:levelup(playerid, params[])
{
	new
		exp = (PlayerInfo[playerid][pLevel] * 10),
		cost = (PlayerInfo[playerid][pLevel] + 1) * 1500,
		string[64];
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1483.496459, -1768.248901, 18.810064))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the desk at city hall.");
	}
	if(PlayerInfo[playerid][pEXP] < exp)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need %i more respect points in order to level up.", exp - PlayerInfo[playerid][pEXP]);
	}
	if(PlayerInfo[playerid][pCash] < cost)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to have at least %s on hand to buy your next level.", FormatNumber(cost));
	}
	if(PlayerInfo[playerid][pPassport])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have an active passport. You can't level up at the moment.");
	}
	PlayerInfo[playerid][pEXP] -= exp;
	PlayerInfo[playerid][pCash] -= cost;
	PlayerInfo[playerid][pLevel]++;
	PlayerInfo[playerid][pUpgradePoints] += 2;

	if(PlayerInfo[playerid][pLevel] == 3 && PlayerInfo[playerid][pReferralUID] > 0)
	{
	    ReferralCheck(playerid);
	}

	format(string, sizeof(string), "~g~Level Up~n~~w~You are now level %i", PlayerInfo[playerid][pLevel]);
	GameTextForPlayer(playerid, string, 5000, 1);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET exp = exp - %i, cash = cash - %i, level = level + 1,  upgradepoints = upgradepoints + 2 WHERE uid = %i", exp, cost, PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_YELLOW, "You have moved up to level %i.", PlayerInfo[playerid][pLevel]);
	SM(playerid, COLOR_YELLOW, "You now have %i upgrade points. Use /upgrade to learn more.", PlayerInfo[playerid][pUpgradePoints]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	return 1;
}

CMD:dollarrims(playerid, params[])
{
    if(IsPlayerConnected(playerid)) {
        if(PlayerInfo[playerid][pAdmin] < 1) {
            SM(playerid, COLOR_SYNTAX, "You are not authorized to use that command!");
            return 1;
        }
        if(IsPlayerInAnyVehicle(playerid)) {
            AddVehicleComponent(GetPlayerVehicleID(playerid), 1083);
            SM(playerid, COLOR_SYNTAX, "   Dollar Rims Added to Vehicle!");
        }
    }
    return 1;
}

CMD:sr1(playerid, params[]) {
	return callcmd::shadowrims(playerid, params);
}

CMD:shadowrims(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
 	{
		return SM(playerid, COLOR_LIGHTRED, " You are not authorized to use that command.");
	}
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not driving a vehicle.");
	AddVehicleComponent(GetPlayerVehicleID(playerid),1073);
    SendClientMessage(playerid, 0xFFFFFFFF, "You have added shadow rims to your vehicle.");
    return 1;
}

CMD:ctr(playerid, params[]) {
	return callcmd::cutterrims(playerid, params);
}

CMD:cutterrims(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
 	{
		return SM(playerid, COLOR_LIGHTRED, " You are not authorized to use that command.");
	}
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not driving a vehicle.");
	AddVehicleComponent(GetPlayerVehicleID(playerid),1079);
    SendClientMessage(playerid, 0xFFFFFFFF, "You have added cutter rims to your vehicle.");
    return 1;
}

CMD:gr(playerid, params[]) {
	return callcmd::goldrims(playerid, params);
}

CMD:goldrims(playerid, params[])
{
    if(IsPlayerConnected(playerid)) {
        if(PlayerInfo[playerid][pAdmin] < 4) {
            SM(playerid, COLOR_SYNTAX, "You are not authorized to use that command!");
            return 1;
        }
        if(IsPlayerInAnyVehicle(playerid)) {
            AddVehicleComponent(GetPlayerVehicleID(playerid), 1080);
            SM(playerid, COLOR_SYNTAX, "Gold Rims Added to Vehicle!");
        }
    }
    return 1;
}

CMD:selfienaju(playerid)
{
	if(takingselfie[playerid] == 0)
	{
	    GetPlayerPos(playerid,TX[playerid],TY[playerid],TZ[playerid]);
		static Float: nTX, Float: nTY;
		if(Degree[playerid] >= 360) Degree[playerid] = 0;
		Degree[playerid] += Speed;
		nTX = TX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		nTY = TY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		SetPlayerCameraPos(playerid, nTX, nTY, TZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, TX[playerid], TY[playerid], TZ[playerid]+1);
		SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		takingselfie[playerid] = 1;
		ApplyAnimationEx(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1);
		return 1;
	}
    if(takingselfie[playerid] == 1)
	{
	    TogglePlayerControllable(playerid,1);
		SetCameraBehindPlayer(playerid);
	    takingselfie[playerid] = 0;
	    ApplyAnimationEx(playerid, "PED", "ATM", 4.1, 0, 1, 1, 0, 1);
	    return 1;
	}
    return 1;
}
CMD:Phonehide(playerid)
{
    CancelSelectTextDraw(playerid);
    for(new i = 0; i < 109; i++) {
	  TextDrawHideForPlayer(playerid, PHONE[i]);
	}
	for(new i = 0; i <42 ; i++) {
		TextDrawHideForPlayer(playerid, PHONELOCK[i]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
    }
	return 1;
}
CMD:ph(playerid)
{
	return callcmd::phone(playerid);
}
CMD:phone(playerid)
{
	if(PlayerInfo[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use your mobile phone right now as you have it toggled ((/tog phone)).");
	}
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
	}
    if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pLootTime] > 0)
	    return SendClientMessage(playerid, COLOR_GREY, "You're currently unable to use phone at this moment.");

	SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Use /cursor to get your cursor back active.");
    SelectTextDraw(playerid,0x33AA33AA);
    for(new i = 0; i < 42; i++) {
	 TextDrawShowForPlayer(playerid, PHONELOCK[i]);
	}

	return 1;
}

CMD:answer(playerid, params[])
{
	new param[32];
	if(sscanf(params, "S()[32]", param))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /answer [text]");
		return 1;
	}
	if(isnull(quizAnswer))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "There is no active quiz!");
	}
	if(!isnull(param))
	{
		if(!strcmp(quizAnswer, param, true))
		{
			SMA(COLOR_LIGHTRED, "%s has answered the quiz correctly. answer: "SVRCLR"%s", GetRPName(playerid), quizAnswer);
			quizQuestion[0] = EOS;
			quizAnswer[0] = EOS;
		}
		else
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "Sorry bud, that ain't the right answer.");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /answer [text]");
	}
	return 1;
}

CMD:rp(playerid, params[])
{
	new option[10];
	if(sscanf(params, "s[10]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rp [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Guns: GrabGun, HideGun, AimHead, AimBody, AimFeet, AimHand");
        SendClientMessage(playerid, COLOR_WHITE, "Player: handsup, handsdown");
        if(GetFactionType(playerid) == FACTION_POLICE && GetFactionType(playerid) == FACTION_NPOLICE && GetFactionType(playerid) == FACTION_ARMY && GetFactionType(playerid) == FACTION_FEDERAL && GetFactionType(playerid) == FACTION_JAILGUARDS)
  		{
			SendClientMessage(playerid, COLOR_BLUE, "Police RP: Tazer");
		}
		if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
			SendClientMessage(playerid, COLOR_DOCTOR, "Saving Patient Step: Rushpt, Stopbleed, Getst, Lowst, Rusham");
			SendClientMessage(playerid, COLOR_DOCTOR, "Medic RP: Heal");
		}
		if(GetFactionType(playerid) == FACTION_MECHANIC)
		{
		    SendClientMessage(playerid, COLOR_GREEN, "OpenL, GetTools, CarHood, Nitro, Hyd, GetWheels, InWheel, BodyKits");
		    SendClientMessage(playerid, COLOR_GREEN, "Install");
		}
	    return 1;
	}
	if(!strcmp(option, "bodykits", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s attempts to install bodykits towards the car.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "inwheel", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s removes the old 4 wheels of the car as he/she installs new ones.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "getwheels", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s takes 4 pieces of wheels from the locker.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "hyd", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s attempts to install the Hydraulics to the car.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "nitro", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s attempts to install the nitro boost to the car.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "install", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** Installed. ((%s))", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "openl", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s opens the locker with his/her right hand.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "gettools", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s takes the tools/bodykits from the locker.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "carhood", true))
	{
	    if(GetFactionType(playerid) == FACTION_MECHANIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s uses his/her force to open the car's hood.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "handsup", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s raises both of his/her hands onto the air, levels it at his/her head.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "rushpt", true))
	{
	    if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s rushes towards the patient with the medkit.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "stopbleed", true))
	{
	    if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s uses alcohol, cotton and bandage to stop the bleeding of the wound.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "getst", true))
	{
	    if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s rushes at the back of the ambulance, taking out a stretcher and rushes back towards the patient.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "lowst", true))
	{
	    if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s lowers the stretcher, levels it towards the patient and gently move the patient on it.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "rusham", true))
	{
	   	if(GetFactionType(playerid) == FACTION_MEDIC)
  		{
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s rushes towards at the back of the ambulance, loading the patient inside.", GetRPName(playerid));
		}
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}

	if(!strcmp(option, "handsdown", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s moves his hands down freely.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "grabgun", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s grabs his/her gun out, loads it and switches the safety to OFF.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "hidegun", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s hides/slings his/her gun back to its old position and flicking the safety to ON.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "aimhead", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s aims the gun at the head of the enemy.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "aimbody", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s aims the gun at the body of the enemy.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "aimfeet", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s aims the gun at the feet of the enemy.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "aimhand", true))
	{
	    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s aims the gun at the hand of the enemy.", GetRPName(playerid));
		return 1;
	}
	if(!strcmp(option, "tazer", true))
	{
	    if(IsLawEnforcement(playerid))
	    {
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s shoots the tazer towards the enemy.", GetRPName(playerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
		return 1;
	}
	if(!strcmp(option, "heal", true))
	{
	    if(GetFactionType(playerid) == FACTION_MEDIC)
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
	    }
	    else
	    {
	    	SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s uses alcohol, cotton and bandage to cure the patient's wound.", GetRPName(playerid));
		}
		return 1;
	}
	return 1;
}

CMD:quiz(playerid, params[])
{
	new option[10], param[32];
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    if(PlayerInfo[playerid][pAdmin] >= 2)
	    {
			SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /quiz [option]");
			SendClientMessage(playerid, COLOR_WHITE, "Available options: create, end, edit");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
		}
		return 1;
	}
 	if(!strcmp(option, "create", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 2) return 1;
		if(isnull(quizQuestion))
	    {
			if(CreateQuiz == -1)
			{
	        	ShowDialogToPlayer(playerid, DIALOG_CREATEQUIZ);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "There is already an on-going quiz!");
		}
		return 1;
	}
	else if(!strcmp(option, "end", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 2) return 1;
	    if(!isnull(quizQuestion))
	    {
	        quizQuestion[0] = EOS;
            SMA(COLOR_LIGHTRED, "The quiz was ended by %s, answer: %s", GetRPName(playerid), quizAnswer);
			quizAnswer[0] = EOS;
	    }
	    return 1;
	}
	else if(!strcmp(option, "edit", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 2) return 1;
		if(strlen(param) > 0)
		{
		    strcpy(quizAnswer, param);
			SAM(COLOR_LIGHTRED, "AdmCmd: %s changed the quiz answer to %s.", GetRPName(playerid), quizAnswer);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /quiz edit [answer]");
		}
	}
	return 1;
}
/// fully debbuged by naju
CMD:getcash(playerid, params[])
{

    if (!PlayerHasJob(playerid, JOB_ATM))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you are not an ATM Deliverer.");
    }
    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 499)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be driving a Benson.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1718.224121, -1095.284667, 24.085935))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be closer to the job /join label..");
    }
    const NEW_ATM_LIMIT = 10000000;

    new Float:atmPosX = 0.0, Float:atmPosY = 0.0, Float:atmPosZ = 0.0, 	Float:dist;

    for (new i = 0; i < MAX_ATMS; i++)
    {
        if (AtmInfo[i][aExists] && AtmInfo[i][amoney] < NEW_ATM_LIMIT)
        {
            atmPosX = AtmInfo[i][aPosX];
            atmPosY = AtmInfo[i][aPosY];
            atmPosZ = AtmInfo[i][aPosZ];
            break; 
        }
    }


    if (atmPosX == 0.0 && atmPosY == 0.0 && atmPosZ == 0.0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "All ATMs are full. Please try again later.");
    }

    PlayerInfo[playerid][pCP] = CHECKPOINT_ATM;
    SetPlayerCheckpoint(playerid, atmPosX, atmPosY, atmPosZ, 10);

    PlayerInfo[playerid][checkpointPosX] = atmPosX;
    PlayerInfo[playerid][checkpointPosY] = atmPosY;
    PlayerInfo[playerid][checkpointPosZ] = atmPosZ;

    SM(playerid, COLOR_WHITE, "** You loaded money. Deliver it to the ATM.");
    dist = GetPlayerDistanceFromPoint(playerid, atmPosX, atmPosY,  atmPosZ);
    SetPVarInt(playerid, "dist", floatround(dist));
    return 1;
}

CMD:jobhelp(playerid)
{
	if(!PlayerHasAnyEnabledJob(playerid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You have no job and therefore no job commands to view.");
	}

	if(PlayerInfo[playerid][pJob] != JOB_NONE && Job_IsEnabled(PlayerInfo[playerid][pJob]))
	{
		switch(PlayerInfo[playerid][pJob])
		{
			case JOB_COURIER: SendClientMessage(playerid, COLOR_WHITE, "** Job: /loadtruck, /deliver, /cancelcp.");
			case JOB_FARMER: SendClientMessage(playerid, COLOR_WHITE, "** Job: /hc, /loadcrop, /unloadcrop.");
	        case JOB_ATM: SendClientMessage(playerid, COLOR_WHITE, "** Job: /getcash.");
	        case JOB_SANDALWOOD: SendClientMessage(playerid, COLOR_WHITE, "** Job: /loadsandal.");
	        case JOB_OILEXPO: SendClientMessage(playerid, COLOR_WHITE, "** Job: /export, /oilstake, /loadoils, /unloadoils, /where.");
	        case JOB_CORONER: SendClientMessage(playerid, COLOR_AQUA, "** JOB ** /findbodies, /gotobody, /corpse, /getbody, /dropbody");
	        case JOB_FRUITPICKER: SendClientMessage(playerid, COLOR_WHITE, "** Job: /exportfruit, /unloadfruits, /loadfruit, /pickapple.");
		}
	}

 	if(PlayerInfo[playerid][pSecondJob] != JOB_NONE && Job_IsEnabled(PlayerInfo[playerid][pSecondJob]))
 	{
 	    switch(PlayerInfo[playerid][pSecondJob])
		{
			case JOB_COURIER: SendClientMessage(playerid, COLOR_WHITE, "** Secondary Job: /load, /deliver.");
	        case JOB_FARMER: SendClientMessage(playerid, COLOR_WHITE, "** Job: /hc, /loadcrop, /unloadcrop.");
	        case JOB_SANDALWOOD: SendClientMessage(playerid, COLOR_WHITE, "** Secondary Job: /loadsandal.");
	 	}
	}

	return 1;
}

CMD:vehiclehelp(playerid)
{
    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle: /engine, /lights, /hood, /trunk, /buyvehicle, /vstorage, /park, /lock.");
    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle: /vstash, /neon, /unmod, /colorcar, /paintcar, /upgradevehicle, /sellcar, /sellmycar.");
    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle: /findcar, /givekeys, /takekeys, /setradio, /paytickets, /carinfo, /gascan.");
    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle: /seatbelt, /checkmybelt, /checkbelt, /windows.");
    return 1;
}

CMD:bankhelp(playerid)
{
	SendClientMessage(playerid, COLOR_WHITE, "** Bank: /withdraw, /deposit, /wiretransfer, /balance, /robbank, /invite, /setupvault.");
	return 1;
}

CMD:giveobject(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 10)
	{
		new string[128], giveplayerid, object, slot;
		if(sscanf(params, "udd", giveplayerid, object, slot)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /giveobject [playerid] [object] [slots]");

		if(slot < 0 || slot > 10) return SendClientMessage(playerid, COLOR_WHITE, "* Invalid slot, must be between 0 and 10");
		if (IsPlayerConnected(giveplayerid))
		{
			ClothingInfo[giveplayerid][slot][cModel] = object;
			ClothingInfo[giveplayerid][slot][cBone] = 1;
			ClothingInfo[giveplayerid][slot][cID] = slot;
			ClothingInfo[giveplayerid][slot][cExists] = 1;
			strcpy(ClothingInfo[giveplayerid][slot][cName], "Custom Toy", 32);
			ClothingInfo[giveplayerid][slot][cAttached] = 0;
			ClothingInfo[giveplayerid][slot][cAttachedIndex] = -1;
			format(string, sizeof(string), "You have given %s object %d in slot %d", GetPlayerNameEx(giveplayerid), object, slot);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			SendClientMessage(giveplayerid, COLOR_WHITE, "You have received a new /toys from an administrator!");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO clothing VALUES(null, %i, 'Custom Toy', %i, 1, 0, '0', '0', '0', '0', '0', '0', '1', '1', '1')", PlayerInfo[giveplayerid][pID], object);
			mysql_tquery(connectionID, queryBuffer);
			//g_mysql_NewToy(giveplayerid, v);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "* Invalid object");
		}
	}
	return 1;
}

