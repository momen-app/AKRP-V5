CMD:removeitems(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 7)
	{
		for (new i = 0; i < MAX_DROPPED_ITEMS; i++)
		{
			if (DroppedItems[i][droppedModel])
			{
			    Item_Delete(i);
			}
		}	

	}
	else
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Ninak Kayiv Illa");
	}
	return 1;
}
CMD:removepveh(playerid, params[])
{
	new targetid;

    if(PlayerInfo[playerid][pAdmin] < 3)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removepveh [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, interior FROM vehicles WHERE ownerid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListVehiclesForRemoval", "ii", playerid, targetid);
	return 1;
}

CMD:releasecar(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1824.496704, -1426.201660, 13.655930))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the desk in the DMV / Licensing Department.");
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT tickets, modelid FROM vehicles WHERE ownerid = %i AND impounded = 1", PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_DMVRELEASE, playerid);
	return 1;
}

CMD:sb(playerid, params[])
{
	return callcmd::seatbelt(playerid);
}
CMD:hm(playerid, params[])
{
	return callcmd::seatbelt(playerid);
}
CMD:helmet(playerid, params[])
{
	return callcmd::seatbelt(playerid);
}

CMD:givekeys(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givekeys [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't give keys to yourself.");
	}
	if(PlayerInfo[targetid][pVehicleKeys] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player already has keys to your vehicle.");
	}

	PlayerInfo[targetid][pVehicleKeys] = vehicleid;

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s gives %s the keys to their %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
	SM(targetid, COLOR_AQUA, "%s has given you the keys to their "SVRCLR"%s{CCFFFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
	SM(playerid, COLOR_AQUA, "You have given %s the keys to your "SVRCLR"%s{CCFFFF}.", GetRPName(targetid), GetVehicleName(vehicleid));
	return 1;
}

CMD:takekeys(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /takekeys [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't take keys from yourself.");
	}
	if(PlayerInfo[targetid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player doesn't have the keys to your vehicle.");
	}

	PlayerInfo[targetid][pVehicleKeys] = INVALID_VEHICLE_ID;

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes back the keys to their %s from %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
	SM(targetid, COLOR_AQUA, "%s has taken back the keys to their "SVRCLR"%s{CCFFFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
	SM(playerid, COLOR_AQUA, "You have taken back the keys to your "SVRCLR"%s{CCFFFF} from %s.", GetRPName(targetid), GetVehicleName(vehicleid));
	return 1;
}

CMD:trackcar(playerid, params[])
{
	return callcmd::findcar(playerid, params);
}

CMD:findcar(playerid, params[])
{
    new string[MAX_SPAWNED_VEHICLES * 64], count;

 	string = "#\tModel\tLocation";

 	for(new i = 1; i < MAX_VEHICLES; i ++)
 	{
 	    if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i))
 	    {
 	        format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
 	        count++;
		}
	}

	if(!count)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You have no vehicles spawned at the moment.");
	}
	else
	{
	    ShowPlayerDialog(playerid, DIALOG_FINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to track.", string, "Select", "Cancel");
	}

	return 1;
}

CMD:tune(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(!IsPlayerInMech(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the tuning place.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you tune this vehicle.");
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, ""SVRCLR"Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics", "Enter", "Close");
	return 1;
}

CMD:upgradevehicle(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), option[8], param[32];

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you upgrade this vehicle.");
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!IsPlayerInMech(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of Meachanic.");
	}
	if(sscanf(params, "s[8]S()[32]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradevehicle [stash | neon | plate]");
	}

	if(!strcmp(option, "stash", true))
	{
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradevehicle [stash] [confirm]");
	        SM(playerid, COLOR_WHITE, "Your vehicle's stash level is at %i/3. Upgrading your stash will cost you $1000.", VehicleInfo[vehicleid][vTrunk]);
	        return 1;
		}
		if(VehicleInfo[vehicleid][vTrunk] >= 3)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle's stash is already at its maximum level.");
		}
		if(PlayerInfo[playerid][pCash] < 1000)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money to upgrade your trunk.");
		}

		VehicleInfo[vehicleid][vTrunk]++;

		GivePlayerCash(playerid, -1000);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $1000 for stash level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);
		//Log_Write("log_property", "%s (uid: %i) upgraded the stash of their %s (id: %i) to level %i/3.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], VehicleInfo[vehicleid][vTrunk]);
	}
	else if(!strcmp(option, "neon", true))
	{
	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradevehicle [neon] [color] (costs $3000)");
			SendClientMessage(playerid, COLOR_GREY2, "List of colors: Red, Blue, Green, Yellow, Pink, White");
			return 1;
	    }
	    if(PlayerInfo[playerid][pCash] < 3000)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least $30,000 to upgrade your neon.");
		}
		if(!VehicleHasWindows(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't support neon.");
		}

		if(!strcmp(param, "red", true))
		{
		    SetVehicleNeon(vehicleid, 18647);
		    GivePlayerCash(playerid, -3000);
		    

			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for red neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased red neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "blue", true))
		{
		    SetVehicleNeon(vehicleid, 18648);
		    GivePlayerCash(playerid, -3000);
		

			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for blue neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased blue neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "green", true))
		{
		    SetVehicleNeon(vehicleid, 18649);
		    GivePlayerCash(playerid, -3000);


			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for green neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased green neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "yellow", true))
		{
		    SetVehicleNeon(vehicleid, 18650);
		    GivePlayerCash(playerid, -3000);
			

			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for yellow neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased yellow neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "pink", true))
		{
		    SetVehicleNeon(vehicleid, 18651);
		    GivePlayerCash(playerid, -3000);
		
			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for pink neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased pink neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "white", true))
		{
		    SetVehicleNeon(vehicleid, 18652);
		    GivePlayerCash(playerid, -3000);
			

			SendClientMessage(playerid, COLOR_YELLOW, "You have paid $3000 for white neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased white neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
	}
	else if(!strcmp(option, "plate", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /upgradevehicle [plate] [text] (costs $2000)");
	    }
		if(PlayerInfo[playerid][pCash] < 2000)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money to upgrade your trunk.");
		}
	    if(!VehicleHasEngine(vehicleid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no license plate. Therefore you can't buy this upgrade.");
	    }

	    strcpy(VehicleInfo[vehicleid][vPlate], param, 32);

		SetVehicleNumberPlate(vehicleid, param);
	    ResyncVehicle(vehicleid);

	    GivePlayerCash(playerid, -2000);


		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET plate = '%e' WHERE id = %i", param, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $2000 for license plate '%s'. Changes will take effect once vehicle is parked.", param);
		//Log_Write("log_property", "%s (uid: %i) paid $2000 to set the license plate of their %s (id: %i) to %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], param);
	}

	return 1;
}
CMD:neon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vNeon])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no neon installed.");
	}

	if(!VehicleInfo[vehicleid][vNeonEnabled])
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 1;
	    GameTextForPlayer(playerid, "~g~Neon activated", 3000, 3);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s presses a button to activate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_AQUA, "** Neon enabled. The tubes appear under your vehicle.");
	}
	else
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 0;
	    GameTextForPlayer(playerid, "~r~Neon deactivated", 3000, 3);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s presses a button to deactivate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_AQUA, "** Neon disabled.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vNeonEnabled], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadVehicleNeon(vehicleid);
	return 1;
}
CMD:robcar(playerid)
{ 
    new color1, color2, Float:x, Float:y, Float:z, Float:a, vehicleid, count;
    
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1698.923461, -2094.260987, 13.546875))
    {
       return SendClientMessage(playerid, COLOR_YELLOW, "You are not in range of car robbery area.");   
    }
    if(RobberyInfo[rTime] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} The Car Robbery can be robbed again in %i hours. You can't rob it now.", RobberyInfo[rTime]);
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
	    return SendClientMessage(playerid, COLOR_GREY2, "There needs to be at least 2+ LEO on-duty in order to rob the business.");
	}
	
	foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SM(i, COLOR_ROYALBLUE, "** HQ: A robbery is occurring at the car robbery. All units respond immediately. /mdc for player location.");
			SetPlayerMarkerForPlayer(i, playerid, 0xFF0000FF);
		}
	}
     
    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = AddStaticVehicleEx(587, x, y, z, a, color1, color2, -1);

	if(vehicleid == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	}
	ResetVehicleObjects(vehicleid);
	adminVehicle{vehicleid} = false;
	vehicleFuel[vehicleid] = 100;
	vehicleColors[vehicleid][0] = color1;
	vehicleColors[vehicleid][1] = color2;

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
	
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has started a car robbery.", GetRPName(playerid));

	PutPlayerInVehicle(playerid, vehicleid, 0);
	//VehicleInfo[vehicleid][robcar] = 1;
	PlayerInfo[playerid][pWantedLevel] = 2;
	PlayerInfo[playerid][pRobCar] = vehicleid;
	RobberyInfo[rTime] = 1;
	SendClientMessage(playerid, COLOR_CYAN, "[CAR-ROBBERY]: You started Car Robbery. Beware PD got Information.");
	SendClientMessage(playerid, COLOR_CYAN, "[CAR-ROBBERY]: Goto to check point and deliver the Vehicle.");
	
	
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crimes = %i WHERE uid = %i", PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	
	
	PlayerInfo[playerid][pCP] = CHECKPOINT_CARROBBERY;
	SetPlayerCheckpoint(playerid, 2358.284423, 2749.128906, 10.820312, 2.0);
	new string[128];
	format(string, sizeof(string), "~w~Priority Cooldown: ~r~Car Robbery on Progress");
	DynamicTextDrawSetString(Textdraw2, string);	
	return 1;
}

CMD:delivercar(playerid, params[])
{
    new amount = 45000 + random(1000);
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, -1947.6255,1001.1357,35.0141))
	{
		return SendClientMessage(playerid, COLOR_RED, "You Are Not In Car Robbery Garage");
	}
    if(PlayerInfo[playerid][pRob] == 0) return SendClientMessage(playerid, COLOR_RED, "You Haven't Rob Car");
    {
    	PlayerInfo[playerid][pDirtyCash] += amount;
	    PlayerInfo[playerid][pWantedLevel] = 2;
        PlayerInfo[playerid][pRob] -= 1;
        DisablePlayerCheckpoint(playerid);
        DestroyVehicle(robcar);
		SCMf(playerid, COLOR_GENERAL3, "[RobInfo]{ffffff} You earned %i for delivering this car.",amount);
	    SMA( COLOR_GLOBAL, "Car Robbery Sucess Thief Earned %i Black Money", amount);
	    
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET `dirtycash` = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

CMD:bp(playerid, params[]) { return callcmd::backpack(playerid, params); }
CMD:backpack(playerid, params[])
{
    if(PlayerInfo[playerid][pBackpack] != 0)
    {
		new option[14], param[32];
	 	if(sscanf(params, "s[14]S()[32]", option, param))
		{
	 		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [wear | balance | deposit | withdraw]");
	 	}
		if(!strcmp(option, "wear", true))
		{
		    if(PlayerInfo[playerid][pJoinedEvent])
		    {
		        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
			}
		    if(!PlayerInfo[playerid][bpWearing])
		    {
		        if(PlayerInfo[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s wears his small backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerInfo[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s wears his medium backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerInfo[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s wears his large backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
				}
    			PlayerInfo[playerid][bpWearing] = 1;
			}
			else
			{
		        if(PlayerInfo[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes off his small backpack from his back.", GetRPName(playerid));
					PlayerInfo[playerid][bpWearing] = 0;
				}
				else if(PlayerInfo[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes off his medium backpack from his back.", GetRPName(playerid));
					PlayerInfo[playerid][bpWearing] = 0;
				}
				else if(PlayerInfo[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes off his large backpack from his back.", GetRPName(playerid));
					PlayerInfo[playerid][bpWearing] = 0;
				}
				RemovePlayerAttachedObject(playerid, 1);
				return 1;
			}
		}
		if(PlayerInfo[playerid][bpWearing])
		{
			if(!strcmp(option, "balance", true))
		 	{
    			new count;

				for(new i = 0; i < 15; i ++)
    			{
		        	if(PlayerInfo[playerid][bpWeapons][i])
          			{
            			count++;
          			}
       			}
				SendClientMessage(playerid, SERVER_COLOR, "Backpack Balance:");
    			SM(playerid, COLOR_GREY2, "(Cash: $%i/$%i)", PlayerInfo[playerid][bpCash], GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				SM(playerid, COLOR_GREY2, "(Materials: %i/%i) | (Weapons: %i/%i)", PlayerInfo[playerid][bpMaterials], GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS), count, GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS));
		        SM(playerid, COLOR_GREY2, "(Pot: %i/%i grams) | (Crack: %i/%i grams)", PlayerInfo[playerid][bpPot], GetBackpackCapacity(playerid, STASH_CAPACITY_WEED), PlayerInfo[playerid][bpCrack], GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
		        SM(playerid, COLOR_GREY2, "(Meth: %i/%i grams) | (Painkillers: %i/%i pills)", PlayerInfo[playerid][bpMeth], GetBackpackCapacity(playerid, STASH_CAPACITY_METH), PlayerInfo[playerid][bpPainkillers], GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
          		SendClientMessage(playerid, SERVER_COLOR, "Backpack Ammunition:");
				SM(playerid, COLOR_GREY2, "(HP Ammo: %i/%i) | (Poison Ammo: %i/%i)", PlayerInfo[playerid][bpHPAmmo], GetBackpackCapacity(playerid, STASH_CAPACITY_HPAMMO), PlayerInfo[playerid][bpPoisonAmmo], GetBackpackCapacity(playerid, STASH_CAPACITY_POISONAMMO));
	            SM(playerid, COLOR_GREY2, "(FMJ Ammo: %i/%i)", PlayerInfo[playerid][bpFMJAmmo], GetBackpackCapacity(playerid, STASH_CAPACITY_FMJAMMO));
				return 1;
			}
			else if(!strcmp(option, "deposit", true))
		 	{
				new value;

				if(sscanf(param, "s[14]S()[32]", option, param))
		  		{
		    		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [option]");
		      		SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Materials, Pot, Crack, Meth, Acetone, Painkillers, Weapon");
		        	SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, Milkshake, burger");
			        return 1;
		    	}
			    if(!strcmp(option, "cash", true))
				{
		  			if(sscanf(param, "i", value))
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [cash] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pCash])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpCash] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_CASH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to $%i at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				    }

				    GivePlayerCash(playerid, -value);
				    PlayerInfo[playerid][bpCash] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored $%i in your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [materials] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pMaterials])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpMaterials] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i materials at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS));
				    }

				    PlayerInfo[playerid][pMaterials] -= value;
				    PlayerInfo[playerid][bpMaterials] += value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have stored %i materials in your backpack.", value);
	   			}
				else if(!strcmp(option, "pot", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [pot] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pPot])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpPot] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_WEED))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of pot at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_WEED));
				    }

				    PlayerInfo[playerid][pPot] -= value;
				    PlayerInfo[playerid][bpPot] += value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of pot in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "crack", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [Crack] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pCrack])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpCrack] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of Crack at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
				    }

				    PlayerInfo[playerid][pCrack] -= value;
				    PlayerInfo[playerid][bpCrack] += value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of Crack in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "meth", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [meth] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pMeth])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpMeth] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of meth at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_METH));
				    }

				    PlayerInfo[playerid][pMeth] -= value;
				    PlayerInfo[playerid][bpMeth] += value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of meth in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pPainkillers])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpPainkillers] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i painkillers at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
				    }

				    PlayerInfo[playerid][pPainkillers] -= value;
				    PlayerInfo[playerid][bpPainkillers] += value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have stored %i painkillers in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new weaponid;

	   			    if(sscanf(param, "i", weaponid))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
					}
					if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
					}
					if(GetHealth(playerid) < 60)
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't store weapons as your health is below 60.");
					}
					for(new i = 0; i < GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS); i ++)
					{
						if(!PlayerInfo[playerid][bpWeapons][i])
	   				    {
							PlayerInfo[playerid][bpWeapons][i] = weaponid;
						    
							RemovePlayerWeaponEx(playerid, weaponid);
							
							
							SM(playerid, COLOR_AQUA, "** You have stored a %s in slot %i of your backpack.", GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][i]), i + 1);
							return 1;
						}
					}

					SendClientMessage(playerid, COLOR_SYNTAX, "This backpack has no more slots available for weapons.");
				}
	            else if(!strcmp(option, "hpammo", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [hpammo] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pHPAmmo])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpHPAmmo] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_HPAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i HP ammo at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_HPAMMO));
				    }

				    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] - value);
				    PlayerInfo[playerid][bpHPAmmo] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of hollow point ammo in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "Milkshake", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [milkshake] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pMilkshake])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpPoisonAmmo] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_POISONAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i  at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_POISONAMMO));
				    }

				    PlayerInfo[playerid][bpPoisonAmmo] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored %i Milkshakes in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "Burger", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [burger] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pFMJAmmo])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpFMJAmmo] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_FMJAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i FMJ ammo at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_FMJAMMO));
				    }
				    PlayerInfo[playerid][bpFMJAmmo] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of full metal jacket ammo in your backpack.", value);
	   			}
   				else if(!strcmp(option, "Acetone", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [Acetone] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pAcetone])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpAcetone] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i  at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_METH));
				    }

				    PlayerInfo[playerid][bpAcetone] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored %i Acetone in your backpack.", value);
	   			}
   				else if(!strcmp(option, "Battery", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [Battery] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][pBatteries])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpBatteries] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i  at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_METH));
				    }

				    PlayerInfo[playerid][bpBatteries] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored %i Battery in your backpack.", value);
	   			}
			}
	        else if(!strcmp(option, "withdraw", true))
		    {
		        new value;

		        if(sscanf(param, "s[14]S()[32]", option, param))
		        {
		            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [option]");
		            SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Pot, Crack, Meth, Painkillers, Weapon");
		            SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, PoisonAmmo, FMJAmmo");
		            return 1;
		        }
		        if(!strcmp(option, "cash", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [cash] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpCash])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }

				    GivePlayerCash(playerid, value);
				    PlayerInfo[playerid][bpCash] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken $%i from your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [materials] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpMaterials])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][bpMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
					}

				    PlayerInfo[playerid][pMaterials] += value;
				    PlayerInfo[playerid][bpMaterials] -= value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have taken %i materials from your backpack.", value);
	   			}
				else if(!strcmp(option, "pot", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [pot] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpPot])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pPot] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
					}

				    PlayerInfo[playerid][pPot] += value;
				    PlayerInfo[playerid][bpPot] -= value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of pot from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "crack", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [Crack] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpCrack])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pCrack] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
					}

				    PlayerInfo[playerid][pCrack] += value;
				    PlayerInfo[playerid][bpCrack] -= value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of Crack from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "meth", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [meth] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpMeth])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pMeth] + value > GetPlayerCapacity(playerid, CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
					}

				    PlayerInfo[playerid][pMeth] += value;
				    PlayerInfo[playerid][bpMeth] -= value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of meth from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpPainkillers])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
					}

				    PlayerInfo[playerid][pPainkillers] += value;
				    PlayerInfo[playerid][bpPainkillers] -= value;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    SM(playerid, COLOR_AQUA, "** You have taken %i painkillers from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new slots = GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS);

	   			    if(sscanf(param, "i", value))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [weapon] [slot (1-%i)]", slots);
					}
					if(!(1 <= value <= slots))
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
	   			    }
	   			    if(!PlayerInfo[playerid][bpWeapons][value-1])
	   			    {
	   			        return SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
					}

					GiveWeapon(playerid, PlayerInfo[playerid][bpWeapons][value-1]);
					SM(playerid, COLOR_AQUA, "** You have taken a %s from slot %i of your backpack.", GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][value-1]), value);

					PlayerInfo[playerid][bpWeapons][value-1] = 0;
				}
	   			else if(!strcmp(option, "hpammo", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [hpammo] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpHPAmmo])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pHPAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
					}

				    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + value);
				    PlayerInfo[playerid][bpHPAmmo] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of hollow point ammo from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "milkshake", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [milkshake] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpPoisonAmmo])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pMilkshake] + value > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i milkshakes You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMilkshake], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
					}

				    SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + value);
				    PlayerInfo[playerid][bpPoisonAmmo] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of poison tip ammo from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "Burger", true))
				{
	       			if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [Burger] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpFMJAmmo])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pFMJAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Burger. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
					}
					
				    PlayerInfo[playerid][bpFMJAmmo] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken %i Burger from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "Acetone", true))
				{
	       			if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [Acetone] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpAcetone])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pAcetone] + value > GetPlayerCapacity(playerid, CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Acetone. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pAcetone], GetPlayerCapacity(playerid, CAPACITY_METH));
					}

				    PlayerInfo[playerid][bpAcetone] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken %i Acetone from your backpack stash.", value);
	   			}
   				else if(!strcmp(option, "Battery", true))
				{
	       			if(sscanf(param, "i", value))
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [Battery] [amount]");
					}
					if(value < 1 || value > PlayerInfo[playerid][bpBatteries])
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerInfo[playerid][pBatteries] + value > GetPlayerCapacity(playerid, CAPACITY_METH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Batteries. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pBatteries], GetPlayerCapacity(playerid, CAPACITY_METH));
					}

				    PlayerInfo[playerid][bpBatteries] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken %i batteries from your backpack stash.", value);
	   			}
			}
		}
		else
		{
	 		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be wearing your backpack to use these commands.");
	 	}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in possession of a backpack.");
	}
	return 1;
}

CMD:vstash(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
	{
	    new option[14], param[32];

		if(!VehicleInfo[vehicleid][vTrunk])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no trunk installed. /upgradevehicle to purchase one.");
	    }
		if(VehicleInfo[vehicleid][vLocked])
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is locked. /unlock");
		}
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command from within the vehicle.");
		}
		if(sscanf(params, "s[14]S()[32]", option, param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [balance | deposit | withdraw]");
	    }
	    if(!strcmp(option, "balance", true))
	    {
	        new count;

	        for(new i = 0; i < 3; i ++)
	        {
	            if(VehicleInfo[vehicleid][vWeapons][i])
	            {
	                count++;
	            }
	        }

	        SendClientMessage(playerid, SERVER_COLOR, "Stash Balance:");
	        SM(playerid, COLOR_GREY2, "Cash: $%i/$%i", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
			SM(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
	        SM(playerid, COLOR_GREY2, "Pot: %i/%i grams | Crack: %i/%i grams", VehicleInfo[vehicleid][vPot], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCrack], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
	        SM(playerid, COLOR_GREY2, "Meth: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vMeth], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_METH), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));
            SendClientMessage(playerid, SERVER_COLOR, "Stash Ammunition:");
			SM(playerid, COLOR_GREY2, "HP Ammo: %i/%i | Poison Ammo: %i/%i", VehicleInfo[vehicleid][vHPAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HPAMMO), VehicleInfo[vehicleid][vPoisonAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_POISONAMMO));
            SM(playerid, COLOR_GREY2, "FMJ Ammo: %i/%i", VehicleInfo[vehicleid][vFMJAmmo], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_FMJAMMO));

			if(count > 0)
			{
				SendClientMessage(playerid, SERVER_COLOR, "Stash Weapons:");

            	for(new i = 0; i < 3; i ++)
	            {
    	            if(VehicleInfo[vehicleid][vWeapons][i])
	    	        {
	        	        SM(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
					}
				}
	        }
		}
		else if(!strcmp(option, "deposit", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [option]");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Materials, Pot, Crack, Meth, Painkillers, Weapon");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, PoisonAmmo, FMJAmmo");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [cash] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pCash])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vCash] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to $%i at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
			    }

			    GivePlayerCash(playerid, -value);
			    VehicleInfo[vehicleid][vCash] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored $%i in your vehicle stash.", value);
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [materials] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pMaterials])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vMaterials] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i materials at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS));
			    }

			    PlayerInfo[playerid][pMaterials] -= value;
			    VehicleInfo[vehicleid][vMaterials] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i materials in your vehicle stash.", value);
   			}
			else if(!strcmp(option, "pot", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [pot] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPot])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vPot] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i grams of pot at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED));
			    }

			    PlayerInfo[playerid][pPot] -= value;
			    VehicleInfo[vehicleid][vPot] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pot = %i WHERE id = %i", VehicleInfo[vehicleid][vPot], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of pot in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [Crack] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pCrack])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vCrack] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i grams of Crack at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
			    }

			    PlayerInfo[playerid][pCrack] -= value;
			    VehicleInfo[vehicleid][vCrack] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET crack = %i WHERE id = %i", VehicleInfo[vehicleid][vCrack], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of Crack in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "meth", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [meth] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pMeth])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vMeth] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_METH))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i grams of meth at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_METH));
			    }

			    PlayerInfo[playerid][pMeth] -= value;
			    VehicleInfo[vehicleid][vMeth] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET meth = %i WHERE id = %i", VehicleInfo[vehicleid][vMeth], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %ig of meth in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [painkillers] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vPainkillers] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i painkillers at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));
			    }

			    PlayerInfo[playerid][pPainkillers] -= value;
			    VehicleInfo[vehicleid][vPainkillers] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i painkillers in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new weaponid;

   			    if(sscanf(param, "i", weaponid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
				}
				if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
				}
				if(GetHealth(playerid) < 60)
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't store weapons as your health is below 60.");
				}

				for(new i = 0; i < GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS); i ++)
				{
					if(!VehicleInfo[vehicleid][vWeapons][i])
   				    {
						VehicleInfo[vehicleid][vWeapons][i] = weaponid;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_%i = %i WHERE id = %i", i + 1, VehicleInfo[vehicleid][vWeapons][i], VehicleInfo[vehicleid][vID]);
						mysql_tquery(connectionID, queryBuffer);

						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						SM(playerid, COLOR_AQUA, "** You have stored a %s in slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]), i + 1);
						return 1;
					}
				}

	            
				SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no more slots available for weapons.");
			}
            else if(!strcmp(option, "hpammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [hpammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pHPAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vHPAmmo] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HPAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i HP ammo at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HPAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] - value);
			    VehicleInfo[vehicleid][vHPAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET hpammo = %i WHERE id = %i", VehicleInfo[vehicleid][vHPAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of hollow point ammo in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "poisonammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [poisonammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pPoisonAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vPoisonAmmo] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_POISONAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i  at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_POISONAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] - value);
			    VehicleInfo[vehicleid][vPoisonAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET poisonammo = %i WHERE id = %i", VehicleInfo[vehicleid][vPoisonAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of poison tip ammo in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "fmjammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [deposit] [fmjammo] [amount]");
				}
				if(value < 1 || value > PlayerInfo[playerid][pFMJAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vFMJAmmo] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_FMJAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Your vehicle's stash can only hold up to %i FMJ ammo at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_FMJAMMO));
			    }

			    SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] - value);
			    VehicleInfo[vehicleid][vFMJAmmo] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET fmjammo = %i WHERE id = %i", VehicleInfo[vehicleid][vFMJAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have stored %i rounds of full metal jacket ammo in your vehicle stash.", value);
   			}
		}
		else if(!strcmp(option, "withdraw", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [option]");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: Cash, Pot, Crack, Meth, Painkillers, Weapon");
	            SendClientMessage(playerid, COLOR_WHITE, "Available options: HPAmmo, PoisonAmmo, FMJAmmo");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [cash] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vCash])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }

			    GivePlayerCash(playerid, value);
			    VehicleInfo[vehicleid][vCash] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken $%i from your vehicle stash.", value);
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [materials] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vMaterials])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    PlayerInfo[playerid][pMaterials] += value;
			    VehicleInfo[vehicleid][vMaterials] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i materials from your vehicle stash.", value);
   			}
			else if(!strcmp(option, "pot", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [pot] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vPot])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPot] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

			    PlayerInfo[playerid][pPot] += value;
			    VehicleInfo[vehicleid][vPot] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pot = %i WHERE id = %i", VehicleInfo[vehicleid][vPot], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of pot from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [Crack] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vCrack])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pCrack] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    PlayerInfo[playerid][pCrack] += value;
			    VehicleInfo[vehicleid][vCrack] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET crack = %i WHERE id = %i", VehicleInfo[vehicleid][vCrack], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of Crack from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "meth", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [meth] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vMeth])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pMeth] + value > GetPlayerCapacity(playerid, CAPACITY_METH))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
				}

			    PlayerInfo[playerid][pMeth] += value;
			    VehicleInfo[vehicleid][vMeth] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET meth = %i WHERE id = %i", VehicleInfo[vehicleid][vMeth], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %ig of meth from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [painkillers] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    PlayerInfo[playerid][pPainkillers] += value;
			    VehicleInfo[vehicleid][vPainkillers] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i painkillers from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new slots = GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS);

   			    if(sscanf(param, "i", value))
			    {
			        return SM(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [weapon] [slot (1-%i)]", slots);
				}
				if(!(1 <= value <= slots))
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
   			    }
   			    if(!VehicleInfo[vehicleid][vWeapons][value-1])
   			    {
   			        return SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
				}

				GiveWeapon(playerid, VehicleInfo[vehicleid][vWeapons][value-1]);
				SM(playerid, COLOR_AQUA, "** You have taken a %s from slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][value-1]), value);

				VehicleInfo[vehicleid][vWeapons][value-1] = 0;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_%i = 0 WHERE id = %i", value, VehicleInfo[vehicleid][vID]);
				mysql_tquery(connectionID, queryBuffer);
			}
   			else if(!strcmp(option, "hpammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [hpammo] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vHPAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pHPAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + value);
			    VehicleInfo[vehicleid][vHPAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET hpammo = %i WHERE id = %i", VehicleInfo[vehicleid][vHPAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of hollow point ammo from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "poisonammo", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [poisonammo] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vPoisonAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pPoisonAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i poison ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPoisonAmmo], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + value);
			    VehicleInfo[vehicleid][vPoisonAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET poisonammo = %i WHERE id = %i", VehicleInfo[vehicleid][vPoisonAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of poison tip ammo from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "fmjammo", true))
			{
       			if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vstash [withdraw] [fmjammo] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vFMJAmmo])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			    }
			    if(PlayerInfo[playerid][pFMJAmmo] + value > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
			    {
			        return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i FMJ ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
				}

			    SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] + value);
			    VehicleInfo[vehicleid][vFMJAmmo] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET fmjammo = %i WHERE id = %i", VehicleInfo[vehicleid][vFMJAmmo], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SM(playerid, COLOR_AQUA, "** You have taken %i rounds of full metal jacket ammo from your vehicle stash.", value);
   			}
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle");
	}

	return 1;
}

CMD:unmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /unmod [color | paintjob | mods | neon]");
	}

	if(!strcmp(params, "color", true))
	{
	    VehicleInfo[vehicleid][vColor1] = 0;
	    VehicleInfo[vehicleid][vColor2] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehicleColor(vehicleid, 0, 0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle color has been set back to default.");
	}
	else if(!strcmp(params, "paintjob", true))
	{
	    VehicleInfo[vehicleid][vPaintjob] = -1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehiclePaintjob(vehicleid, -1);
	    SendClientMessage(playerid, COLOR_WHITE, "** Vehicle paintjob has been set back to default.");
	}
	else if(!strcmp(params, "mods", true))
	{
	    for(new i = 0; i < 14; i ++)
	    {
	        if(VehicleInfo[vehicleid][vMods][i] >= 1000)
	        {
	            RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
	        }
	    }

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessage(playerid, COLOR_WHITE, "** All vehicle modifications have been removed.");
	}
	else if(!strcmp(params, "neon", true))
	{
	    if(!VehicleInfo[vehicleid][vNeon])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no neon which you can remove.");
		}

		if(VehicleInfo[vehicleid][vNeonEnabled])
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
		}

		VehicleInfo[vehicleid][vNeon] = 0;
		VehicleInfo[vehicleid][vNeonEnabled] = 0;
		VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neon = 0, neonenabled = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessage(playerid, COLOR_WHITE, "** Neon has been removed from vehicle.");
	}

	return 1;
}

CMD:colorcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), color1, color2;
	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "ii", color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /colorcar [color1] [color2]");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The color specified must range between 0 and 255.");
	}

    if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
	    VehicleInfo[vehicleid][vColor1] = color1;
	    VehicleInfo[vehicleid][vColor2] = color2;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	ChangeVehicleColor(vehicleid, color1, color2);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));

	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	return 1;
}

CMD:paintcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), paintjobid;

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "i", paintjobid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /paintcar [paintjobid (-1 = none)]");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!(-1 <= paintjobid <= 5))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The paintjob specified must range between -1 and 5.");
	}
	if(paintjobid == -1) paintjobid = 3;

	if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
		VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
	ChangeVehiclePaintjob(vehicleid, paintjobid);
	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);

	return 1;
}

CMD:sssellcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), targetid, amount;

    if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to sell a car to a player while on-duty, bobo!", GetRPName(playerid));
	}

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellcar [playerid] [amount]");
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

	PlayerInfo[targetid][pCarOffer] = playerid;
	PlayerInfo[targetid][pCarOffered] = vehicleid;
	PlayerInfo[targetid][pCarPrice] = amount;
	PlayerInfo[targetid][pCartype] = 0;

	SM(targetid, COLOR_AQUA, "** %s offered you their %s for $%i (/accept vehicle).", GetRPName(playerid), GetVehicleName(vehicleid), amount);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your %s for $%i.", GetRPName(targetid), GetVehicleName(vehicleid), amount);
	return 1;
}

Vehicle_WheatCount(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 0) return 0;
	new count;
	for(new i; i < WHEAT_LIMIT; i++) if(IsValidDynamicObject(WheatObjects[vehicleid][i])) count++;
	for(new i; i < OILEXPO_LIMIT; i++) if(IsValidDynamicObject(OilExpoObjects[vehicleid][i])) count++;
	for(new i; i < OILEXPO_LIMIT; i++) if(IsValidDynamicObject(FruitBoxObjects[vehicleid][i])) count++;
	return count;
}

CMD:unloadoils(playerid, params[])
{
	new id = GetNearbyVehicle(playerid);
 	new vehicle = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_OILEXPO))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Oil Exporter.");
	}
	if(GetVehicleModel(GetNearbyVehicle(playerid)) != 422)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Oil Expo Trucks.");
	}
	if(Vehicle_WheatCount(id) < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "This Vehicle doesn't have any Oil Container.");

	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
  	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_GRAD2, "You need to open the trunk first before you load the Oil Container.");
    	return 1;
   	}

    for(new i = (OILEXPO_LIMIT - 1); i >= 0; i--)
   	{
    	if(IsValidDynamicObject(OilExpoObjects[id][i]))
        {
        	DestroyDynamicObject(OilExpoObjects[id][i]);
	        OilExpoObjects[id][i] = -1;
  			break;
	    }
   	}
   	SetPlayerAttachedObject(playerid, 9, 3632, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	ApplyAnimationEx(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
	SetPlayerCheckpoint(playerid, 61.698699, 1219.251098, 18.845754, 2.0);
	PlayerInfo[playerid][pOilEx] = 1;

   	PlayerInfo[playerid][pCP] = CHECKPOINT_OILEXPO;

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 61.698699, 1219.251098, 18.845754))
	{
		RemovePlayerAttachedObject(playerid, 9);
		ClearAnimations(playerid, SYNC_ALL);
	}
	return 1;
}

CMD:loadoils(playerid, params[])
{
	new vehicle = GetNearbyVehicle(playerid);
	new id = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_OILEXPO))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Oil Exporter.");
	}
 	if(PlayerInfo[playerid][pOilEx] == 0)
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "You need to get the Oil first before you load it to the truck");
		return 0;
	}
    if(GetVehicleModel(GetNearbyVehicle(playerid)) != 422)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Oil Trucks.");
	}
	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_SYNTAX, "You need to open the trunk before you load the Oil container.");
    	return 1;
   	}


  	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
    {
		SendClientMessage(playerid, COLOR_SYNTAX, "You to open the trunk first before you load the logs.");
	}
	if(Vehicle_WheatCount(id) >= OILEXPO_LIMIT)
			return SendClientMessage(playerid, COLOR_ERROR, "You can't load any more oil container to this vehicle.");
	for(new i; i < 5; i++)
    {
      if(!IsValidDynamicObject(OilExpoObjects[id][i]))
      {
         OilExpoObjects[id][i] = CreateDynamicObject(3632, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
         AttachDynamicObjectToVehicle(OilExpoObjects[id][i], id, LogsAttachOffsets[i][0], LogsAttachOffsets[i][1], LogsAttachOffsets[i][2], 0.0, 0.0, LogsAttachOffsets[i][3]);
         break;
       }
    }
    RemovePlayerAttachedObject(playerid, 9);
  	ClearAnimations(playerid, SYNC_ALL);
  	PlayerInfo[playerid][pOilEx] = 0;
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}

CMD:oilstake(playerid, params[])
{
    //new id = GetNearbyVehicle(playerid);

	if(!PlayerHasJob(playerid, JOB_OILEXPO))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Oil Exporter.");
	}
	if(PlayerInfo[playerid][pOilExTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are collecting some oil already. Wait until you are done.");
	}
	if(PlayerInfo[playerid][pOilEx] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to drop off your current container.");
	}
	if(!IsPlayerInOilExpoArea(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the Collecting area.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}

    GameTextForPlayer(playerid, "~g~Collecting Oils...", 6000, 3);
    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);

    DisablePlayerCheckpoint(playerid);

	PlayerInfo[playerid][pOilExTime] = 6;
	return 1;
}

CMD:export(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_OILEXPO))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not a Oil Exporter!");
	}
 	if(PlayerInfo[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}
	if(PlayerInfo[playerid][pOilEx] < 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You dont have a Oil yet go to the site and get some.");
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsAOilExpoCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
		SendClientMessage(playerid, COLOR_AQUA, "Go to the checkpoint to drop off this Oil Containers.");
		SetPlayerCheckpoint(playerid, 61.698699, 1219.251098, 18.845754, 10);
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		GettingOilContainer[playerid] = 1;
 	}
  	else return SendClientMessage(playerid, COLOR_GREY, "Manager: You must be driving a Truck vehicle!");
	return 1;
}

CMD:where(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_OILEXPO))
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a Oil Exporter.");
	}
	if(PlayerInfo[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}
	SetPlayerCheckpoint(playerid, 564.392517, 1319.291625, 10.115003, 10);
	PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	return 1;
}

CMD:unloadcrop(playerid, params[])
{
	new id = GetNearbyVehicle(playerid);
 	new vehicle = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_FARMER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Farmer.");
	}
	if(GetVehicleModel(GetNearbyVehicle(playerid)) != 478)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Walton.");
	}
	if(Vehicle_WheatCount(id) < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "This Walton doesn't have any crop.");

	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
  	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_GRAD2, "You need to open the trunk first before you load the stone.");
    	return 1;
   	}

    for(new i = (WHEAT_LIMIT - 1); i >= 0; i--)
   	{
    	if(IsValidDynamicObject(WheatObjects[id][i]))
        {
        	DestroyDynamicObject(WheatObjects[id][i]);
	        WheatObjects[id][i] = -1;
  			break;
	    }
   	}
   	SetPlayerAttachedObject(playerid, 9, 1453, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	ApplyAnimationEx(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
	SetPlayerCheckpoint(playerid, -586.545410, -1486.357299, 11.182582, 2.0);
	PlayerInfo[playerid][pWheat] = 1;

   	PlayerInfo[playerid][pCP] = CHECKPOINT_FARMER;

	if(IsPlayerInRangeOfPoint(playerid, 5.0, -586.545410, -1486.357299, 11.182582))
	{
		RemovePlayerAttachedObject(playerid, 9);
		ClearAnimations(playerid, SYNC_ALL);
	}
	return 1;
}

CMD:loadcrop(playerid, params[])
{
	new vehicle = GetNearbyVehicle(playerid);
	new id = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_FARMER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Farmer.");
	}
 	if(PlayerInfo[playerid][pWheat] == 0)
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "You need to get the wheat first before you load it to the truck");
		return 0;
	}
	if(GetVehicleModel(GetNearbyVehicle(playerid)) != 478)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Walton.");
	}
	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_SYNTAX, "You need to open the trunk before you load the wheat.");
    	return 1;
   	}


  	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
    {
		SendClientMessage(playerid, COLOR_SYNTAX, "You to open the trunk first before you load the wheat.");
	}
	if(Vehicle_WheatCount(id) >= WHEAT_LIMIT)
			return SendClientMessage(playerid, COLOR_ERROR, "You can't load any more Wheat to this vehicle.");
	for(new i; i < WHEAT_LIMIT; i++)
   	{
    	if(!IsValidDynamicObject(WheatObjects[id][i]))
    	{
     		WheatObjects[id][i] = CreateDynamicObject(1453, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  			AttachDynamicObjectToVehicle(WheatObjects[id][i], id, WheatAttachOffsets[i][0], WheatAttachOffsets[i][1], WheatAttachOffsets[i][2], 0.0, 0.0, WheatAttachOffsets[i][3]);
  			break;
	    }
   	}
	
    RemovePlayerAttachedObject(playerid, 9);
  	ClearAnimations(playerid, SYNC_ALL);
  	PlayerInfo[playerid][pWheat] = 0;
  	SetPlayerCheckpoint(playerid, -586.545410, -1486.357299, 11.182582, 2.0);
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}

IsNearTrunk(vehicle, playerid, Float: dist = 4.0)
{
	new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicle, x, y, z);

    if (GetPlayerDistanceFromPoint(playerid, x, y, z) > dist) return 0;

	return 1;
}


CMD:hc(playerid, params[])
{
    //new id = GetNearbyVehicle(playerid);
    
	if(!PlayerHasJob(playerid, JOB_FARMER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Farmer.");
	}
	if(PlayerInfo[playerid][pHarvestTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are harvesting already. Wait until you are done.");
	}
	if(PlayerInfo[playerid][pWheat] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to drop off your current rock first.");
	}
	if(!IsPlayerInHarvestArea(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the harvesting area.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}

    GameTextForPlayer(playerid, "~g~Harvesting...", 6000, 3);
    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);

	DisablePlayerCheckpoint(playerid);

	PlayerInfo[playerid][pHarvestTime] = 6;
	return 1;
}


CMD:blackmarket(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, -403.169830, 1232.469482, 6.631836))	return 1;
	ShowPlayerDialog(playerid, DIALOG_BLACKMARKET7, DIALOG_STYLE_LIST, "Blackmarket ", "Cuff Breaker (15,000)\nMask (5,000)\nBlindfold (5,000)\nRope (5, 000)\nLockpick (10,000)\nWeaponclip (1,000)\nPenDrive (10,000)\nLaptop (10,000)\nHotwireKit (34,513)\nMobileMethLab (10,000)", "Buy", "Cancel");
	return 1;
}

CMD:exchange(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -309.5463, 1129.7507, 20.3066))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in the pawnshop.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pHurt] - 40 > 0)
	{
        return SM(playerid, COLOR_GREY, "You are too hurt to use this command. Please wait %i seconds before trying again.", (PlayerInfo[playerid][pHurt] - 40));
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}

	new string[1536] = "Perk\tDescription\tCost", title[64];

    strcat(string, "\nBusiness\tGives you a flagged Business (Any type)\t{F7A763}400 Diamonds{FFFFFF}");
	strcat(string, "\nHouse\tGives you a flagged Mansion House\t{F7A763}500 Diamonds{FFFFFF}");
	strcat(string, "\nDoor\tGives you a flagged entrance/door with your choice name.\t{F7A763}500 Diamonds{FFFFFF}");
	strcat(string, "\nGate\tGives you a flagged Gate\t{F7A763}100 Diamonds{FFFFFF}");
	strcat(string, "\nCar\tGives you a flagged Rare Car.(No Restricted Cars)\t{F7A763}500 Diamonds{FFFFFF}");

	format(title, sizeof(title), "Pawn Shop (You have %i diamond(s).)", PlayerInfo[playerid][pDiamonds]);
	ShowPlayerDialog(playerid, DIALOG_PAWNSHOP, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Exchange", "Cancel");

	return 1;
}

