CMD:packfruit(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5.0, -2252.951416, -2317.525634, 29.305549))
    {

	   if(!PlayerHasJob(playerid, JOB_FRUITPICKER))
	   {
         return SendClientMessage(playerid, COLOR_GREY, "You are not a  FruitPicker");
	   }
   	   if(PlayerInfo[playerid][pFruitExTime] > 0)
	   {
	     return SendClientMessage(playerid, COLOR_SYNTAX, "You are Packing Fruits. Wait until you are done.");
	   }
       if(PlayerInfo[playerid][pFruitEx] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	   {
	     return SendClientMessage(playerid, COLOR_SYNTAX, "You need to drop off your current box");
	   }
	   if(PlayerInfo[playerid][pApple] == 0)
       {
         return SendClientMessage(playerid, COLOR_RED, "You Dont Have Fruits ");
       }
       else
       {
          if(PlayerInfo[playerid][pApple] > 10)
          {
	        CountDownForPlayer(playerid, "~r~WAIT", "~w~PACKING FRUITS", 3);
	        PlayerInfo[playerid][pApple] -= 10;
	        PlayerInfo[playerid][pFruitExTime] = 4;
       	    TogglePlayerControllable(playerid, 0);
	        SetTimerEx("UnfreezePlayerEx", 4000, false, "i", playerid);
		  }
	      else
          {
	        SendClientMessage(playerid, COLOR_RED, "At Least 10 Apple To Pack");
		  }
	   }
	}
    return 1;
}
CMD:sellhouse(playerid, params[])
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
CMD:buybiz(playerid, params[])
{
	new businessid;

	if((businessid = GetNearbyBusiness(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no business in range. You must be near a business.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /buybiz [confirm]");
	}
	if(BusinessInfo[businessid][bOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This business already has an owner.");
	}
	if(PlayerInfo[playerid][pCash] < BusinessInfo[businessid][bPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this business.");
	}
    if(GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
	{
	    return SM(playerid, COLOR_SYNTAX, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
	}

	SetBusinessOwner(businessid, playerid);
	GivePlayerCash(playerid, -BusinessInfo[businessid][bPrice]);

	SM(playerid, COLOR_YELLOW, "You paid $%i for this %s. /bizhelp for a list of commands.", BusinessInfo[businessid][bPrice], bizInteriors[BusinessInfo[businessid][bType]][intType]);
    //Log_Write("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], BusinessInfo[businessid][bPrice]);
	return 1;
}
CMD:sellmyhouse(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any house of yours.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellmyhouse [confirm]");
	    SM(playerid, COLOR_WHITE, "This command sells your house back to the state. You will receive $%i back.", percent(HouseInfo[houseid][hPrice], 75));
	    return 1;
	}

	SetHouseOwner(houseid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(HouseInfo[houseid][hPrice], 75));

	SM(playerid, COLOR_YELLOW, "You have sold your house to the state and received $%i back.", percent(HouseInfo[houseid][hPrice], 75));
    //Log_Write("log_property", "%s (uid: %i) sold their house (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], HouseInfo[houseid][hID], percent(HouseInfo[houseid][hPrice], 75));
	return 1;
}
CMD:loadfruit(playerid, params[])
{
	new vehicle = GetNearbyVehicle(playerid);
	new id = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_FRUITPICKER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Fruit Picker.");
	}
 	if(PlayerInfo[playerid][pFruitEx] == 0)
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "You need to get the Fruitbox first before you load it to the truck");
		return 0;
	}
    if(GetVehicleModel(GetNearbyVehicle(playerid)) != 422)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Bobcat");
	}
	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_SYNTAX, "You need to open the trunk before you load the Fruit Box.");
    	return 1;
   	}


  	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
 	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

  
	if(Vehicle_WheatCount(id) >= OILEXPO_LIMIT)
			return SendClientMessage(playerid, COLOR_ERROR, "You can't load any more Fruit box to this vehicle.");
	for(new i; i < 5; i++)
    {
      if(!IsValidDynamicObject(FruitBoxObjects[id][i]))
      {
         FruitBoxObjects[id][i] = CreateDynamicObject(19636, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
         AttachDynamicObjectToVehicle(FruitBoxObjects[id][i], id, LogsAttachOffsets[i][0], LogsAttachOffsets[i][1], LogsAttachOffsets[i][2], 0.0, 0.0, LogsAttachOffsets[i][3]);
         break;
       }
    }
    RemovePlayerAttachedObject(playerid, 0);
  	ClearAnimations(playerid, SYNC_ALL);
  	PlayerInfo[playerid][pFruitEx] = 0;
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}
CMD:exportfruit(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_FRUITPICKER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not a  FruitPicker");
	}
 	if(PlayerInfo[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}
	if(PlayerInfo[playerid][pFruitEx] < 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You dont have Fruits yet go to the site and get some.");
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsAFruitCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
		SendClientMessage(playerid, COLOR_AQUA, "Go to the checkpoint to drop off this Fruit Containers.");
		SetPlayerCheckpoint(playerid, -2027.535766, -2542.656982, 30.625000, 10);
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		GettingOilContainer[playerid] = 1;
 	}
  	else return SendClientMessage(playerid, COLOR_GREY, "Manager: You must be driving a Truck vehicle!");
	return 1;
}
CMD:unloadfruits(playerid, params[])
{
	new id = GetNearbyVehicle(playerid);
 	new vehicle = GetNearbyVehicle(playerid);
	if(!PlayerHasJob(playerid, JOB_FRUITPICKER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Fruit Picker.");
	}
	if(GetVehicleModel(GetNearbyVehicle(playerid)) != 422)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Fruit Picker Vehicle");
	}
	if(Vehicle_WheatCount(id) < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "This Vehicle doesn't have any Fruit Boxex.");

	if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_RED, "You are not near the trunk! ");
 	new engine, lights, alarm, doors, bonnet, boot, objective;
  	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
  	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
 	{
  		SendClientMessageEx(playerid, COLOR_GRAD2, "You need to open the trunk first before you unload the Fruit Boxes.");
    	return 1;
   	}

    for(new i = (OILEXPO_LIMIT - 1); i >= 0; i--)
   	{
    	if(IsValidDynamicObject(FruitBoxObjects[id][i]))
        {
        	DestroyDynamicObject(FruitBoxObjects[id][i]);
	        FruitBoxObjects[id][i] = -1;
  			break;
	    }
   	}
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, 0, 19636, 1, -0.040999, 0.429000, 0.000000, 90.800018, 89.900009, -2.599999, 0.678000, 0.698000, 0.889999);
	ApplyAnimationEx(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
	SetPlayerCheckpoint(playerid,  -2027.535766, -2542.656982, 30.625000, 2.0);
	PlayerInfo[playerid][pFruitEx] = 1;

   	PlayerInfo[playerid][pCP] = CHECKPOINT_FRUIT;

	if(IsPlayerInRangeOfPoint(playerid, 10.0, -2027.535766, -2542.656982, 30.625000))
	{
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid, SYNC_ALL);
	}
	return 1;
}
CMD:pickapple(playerid)
{
    if(!PlayerHasJob(playerid, JOB_FRUITPICKER))
        return 1;

    
    new nearestApple = -1;
    new Float:nearestDist = 3; 

    for(new i = 0; i < 14; i++)
    {

        new Float:dist = GetPlayerDistanceFromPoint(playerid, AllFruit[i][0], AllFruit[i][1], AllFruit[i][2]);

        if(dist < nearestDist)
        {
            nearestApple = i;
            nearestDist = dist;
        }
    }

    if(nearestApple != -1)
    {

        if(PlayerInfo[playerid][pPicked][nearestApple] == 1)
        {
            return 0;
        }


        PlayerInfo[playerid][pPicked][nearestApple] = 1;
        DeletePlayer3DTextLabel(playerid, label1[nearestApple]);
        DestroyDynamicObject(apples[nearestApple]);

        TogglePlayerControllable(playerid, 0);
        ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.0, 1, 0, 0, 0, 0);
        CountDownForPlayer(playerid, "~y~WAIT:", "~w~PICKING FRUITS", 3);
        SetTimerEx("UnfreezePlayerEx", 3000, false, "d", playerid);

        
        if(PlayerInfo[playerid][pApple] <= 50)
        {
            PlayerInfo[playerid][pApple]++;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET apple = %i  WHERE uid = %i", PlayerInfo[playerid][pApple], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
        else
        {
            return SendClientMessage(playerid, COLOR_RED, "You Have 50 Apples Sell it Or Use it");
        }
    }
    return 1;
}
CMD:buyitems(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1112.057617, -1304.383300, 13.944063) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1241.751220, -1371.480957, 14.268212))	return 1;
	ShowPlayerDialog(playerid, DIALOG_BLACKMARKET6, DIALOG_STYLE_LIST, "7/11 ", "Phone (25,000$)\nRadio (10,000$)\nPocket watch (2,000$)\nGPS (10,000$)\nFishingRod (1,000$)\nFishingBait (5,000$)\nFlashlight (5,000$)\nMp3 (5,000$)\nphonebook (3,000$)\nRepairKit (5,000$)\nAceTone (30) (5,000$)\nBatteries (30) (20,000$)\nPepperSpray (10000$)", "Buy", "Cancel");
	return 1;
}
CMD:start1(playerid)
{
	if(!Job_CanJoin(playerid, JOB_FRUITPICKER))
	{
		return 1;
	}

	if(gettime() - PlayerInfo[playerid][pLastStart] < 30)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only Use This every 30 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastStart]));
	}
    if(IsPlayerInRangeOfPoint(playerid, 2.0, -2254.117675, -2313.822998, 29.20066))
    {
        PlayerInfo[playerid][pJob] = JOB_FRUITPICKER;
        
        
        for(new i = 0; i < 14; ++i) {
            if(apples[i] != INVALID_OBJECT_ID) {
                DestroyDynamicObject(apples[i]);
                apples[i] = INVALID_OBJECT_ID;
                DeletePlayer3DTextLabel(playerid, label1[i]);
				PlayerInfo[playerid][pPicked][i] = 0;
            }
        }
        
        
        for(new i = 0; i < 14; ++i) {
            apples[i] = CreateDynamicObject(19575, AllFruit[i][0], AllFruit[i][1], AllFruit[i][2], 0.0, 0.0, AllFruit[i][3], -1, -1, -1, 300.0, 1000.0, -1, 0);
            if(apples[i] == INVALID_OBJECT_ID) {
                
                printf("Error creating apple object %d for player %d", i, playerid);
            }
        }

        
        SetPlayerCheckpoint(playerid, -2269.559326, -2324.976807, 26.808689, 1);
        PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
        PlayerInfo[playerid][pLastStart] = gettime();

        
        for(new i = 0; i < 14; i++)
        {

            label1[i] = CreatePlayer3DTextLabel(playerid, "{FFF0FF}[Y]\n {FFFFFF}to pick", 0xFFFF00FF, AllFruit[i][0], AllFruit[i][1], AllFruit[i][2], 40.0); // Yellow color (RGB: 255, 255, 0)

        }
        SendClientMessage(playerid, COLOR_YELLOW, "Go to the Red Marker on the Map to Pick Apple");
    }
    return 1;
}

CMD:removedoor(playerid, params[]) { return callcmd::removeentrance(playerid, params); }
CMD:removeentrance(playerid, params[])
{
	new entranceid;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", entranceid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removeentrance [entranceid]");
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid entrance.");
	}

	DestroyDynamic3DTextLabel(EntranceInfo[entranceid][eText]);
	DestroyDynamicPickup(EntranceInfo[entranceid][ePickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM entrances WHERE id = %i", EntranceInfo[entranceid][eID]);
	mysql_tquery(connectionID, queryBuffer);

	EntranceInfo[entranceid][eExists] = 0;
	EntranceInfo[entranceid][eID] = 0;
	EntranceInfo[entranceid][eOwnerID] = 0;

	SM(playerid, COLOR_AQUA, "** You have removed entrance %i.", entranceid);
	return 1;
}

CMD:gotodoor(playerid, params[]) { return callcmd::gotoentrance(playerid, params); }
CMD:gotoentrance(playerid, params[])
{
	new entranceid;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", entranceid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotoentrance [entranceid]");
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid entrance.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
	SetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);
	SetPlayerInterior(playerid, EntranceInfo[entranceid][eOutsideInt]);
	SetPlayerVirtualWorld(playerid, EntranceInfo[entranceid][eOutsideVW]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:quitjob(playerid, params[])
{
	new slot;

	if(PlayerInfo[playerid][pVIPPackage] >= 1 && sscanf(params, "i", slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /quitjob [1/2]");
	}

	if((PlayerInfo[playerid][pVIPPackage] < 1) || (PlayerInfo[playerid][pVIPPackage] >= 1 && slot == 1))
	{
	    if(PlayerInfo[playerid][pJob] == JOB_NONE)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a job which you can quit.");
	    }

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET job = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have quit your job as a "SVRCLR"%s{CCFFFF}.", GetJobName(PlayerInfo[playerid][pJob]));
		PlayerInfo[playerid][pJob] = JOB_NONE;
	}
	else if(slot == 2 && PlayerInfo[playerid][pVIPPackage] >= 1)
	{
	    if(PlayerInfo[playerid][pSecondJob] == JOB_NONE)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a job in this slot which you can quit.");
	    }

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have quit your secondary job as a "SVRCLR"%s{CCFFFF}.", GetJobName(PlayerInfo[playerid][pSecondJob]));
		PlayerInfo[playerid][pSecondJob] = JOB_NONE;
	}

	return 1;
}


CMD:checkcargo(playerid, params[])
{
	new targetid;
	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /checkcargo [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(PlayerInfo[targetid][pShipment] == -1)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "The player currently doesn't have a cargo to deliver.");
	}
	if(PlayerInfo[targetid][pIllegalCargo] == -1)
	{
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s checks the cargo load of %s.", GetRPName(playerid), GetRPName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, "Cargo Check: {28c12d}LEGAL PRODUCTS");
	}
	if(PlayerInfo[targetid][pIllegalCargo] == ILLEGAL_GUNS)
	{
 		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s checks the cargo load of %s.", GetRPName(playerid), GetRPName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, "Cargo Check: {ff4242}ILLEGAL WEAPONS");
	}
	if(PlayerInfo[targetid][pIllegalCargo] == ILLEGAL_MATS)
	{
 		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s checks the cargo load of %s.", GetRPName(playerid), GetRPName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, "Cargo Check: {ff4242}ILLEGAL MATERIALS");
	}
	if(PlayerInfo[targetid][pIllegalCargo] == ILLEGAL_DRUGS)
	{
   		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s checks the cargo load of %s.", GetRPName(playerid), GetRPName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, "Cargo Check: {ff4242}ILLEGAL DRUGS");
	}
	return 1;
}

CMD:deliver(playerid, params[])
{
	new businessid, amount,
	products = (GetJobLevel(playerid, JOB_COURIER) * 10) + 10,
	products2 = 100 * products;

    if(!PlayerHasJob(playerid, JOB_COURIER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you are not a trucker.");
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsACourierCar(vehicleid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be driving a Mule.");
	}
	if(PlayerInfo[playerid][pShipment] == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no shipment loaded which you can deliver.");
	}
	if((businessid = GetNearbyBusiness(playerid, 7.0)) == -1 || BusinessInfo[businessid][bType] != PlayerInfo[playerid][pShipment])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of a business which accepts this type of load.");
	}
	if(BusinessInfo[businessid][bCash] < products2)
	{
		return SM(playerid, COLOR_SYNTAX, "This business doesn't have any cash left in the safe. Business needs [$%i] inorder to make the transaction success.", products2);
	}

	if(gettime() - PlayerInfo[playerid][pLastLoad] < 20 && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pKicked])
    {
        PlayerInfo[playerid][pACWarns]++;

        if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport delivering (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerInfo[playerid][pLastLoad]);
		}
		else
		{
		    SMA(COLOR_LIGHTRED, "AdmCmd: %s was autobanned by %s, reason: Teleport delivering", GetRPName(playerid), SERVER_BOT);
			new reason[] = "Teleport delivering";
			new from[] = "AK:RP Bot";
		    BanPlayer(playerid, from, reason);
		}
    }

	if(PlayerInfo[playerid][pShipment] == BUSINESS_STORE) {
		amount = (GetJobLevel(playerid, JOB_COURIER) * 50000) + 1500;
  	} else if(PlayerInfo[playerid][pShipment] == BUSINESS_GUNSHOP) {
	  	amount = (GetJobLevel(playerid, JOB_COURIER) * 50000) + 2000;
    } else if(PlayerInfo[playerid][pShipment] == BUSINESS_CLOTHES) {
		amount = (GetJobLevel(playerid, JOB_COURIER) * 50000) + 1700;
  	} else if(PlayerInfo[playerid][pShipment] == BUSINESS_RESTAURANT) {
	  	amount = (GetJobLevel(playerid, JOB_COURIER) * 50000) + 1600;
 	} else if(PlayerInfo[playerid][pShipment] == BUSINESS_BARCLUB) {
	 	amount = (GetJobLevel(playerid, JOB_COURIER) * 50000) + 1500;
	}

	amount += floatround(GetPlayerDistanceFromPoint(playerid, -63.4372, -1121.4932, 1.1103) / 6.0);

	if(PlayerInfo[playerid][pLaborUpgrade] > 0)
	{
		amount += percent(amount, PlayerInfo[playerid][pLaborUpgrade]);
	}
	if(gDoubleSalary)
	{
 		amount = amount*2;
   		SendClientMessage(playerid, COLOR_GREEN, "You have earned 2x of the salary.");
	}
	SM(playerid, COLOR_AQUA, "** You have earned "SVRCLR"$%i{33CCFF} on your paycheck for delivering %i products.", amount, products);
	AddToPaycheck(playerid, amount);
	if(PlayerInfo[playerid][pIllegalCargo] == ILLEGAL_DRUGS)
	{
		switch(random(4))
		{
	    	case 0:
			{
				SendClientMessage(playerid, COLOR_RED, "You have received 5 grams of pot as a reward for delivering illegal drugs.");
				PlayerInfo[playerid][pPot] += 5;
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = pot + 5 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
	    	case 1:
			{
				SendClientMessage(playerid, COLOR_RED, "You have received 5 grams of meth as a reward for delivering illegal drugs.");
    			PlayerInfo[playerid][pMeth] += 5;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = meth + 5 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
	    	case 2:
	    	{
				SendClientMessage(playerid, COLOR_RED, "You have received 5 grams of crack as a reward for delivering illegal drugs.");
   				PlayerInfo[playerid][pCrack] += 5;
   				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = crack + 5 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
	    	case 3:
			{
				SendClientMessage(playerid, COLOR_RED, "SPECIAL REWARD: You have received 5 grams of crack, pot & meth for delivering the drugs.");
   				PlayerInfo[playerid][pCrack] += 5;
      			PlayerInfo[playerid][pMeth] += 5;
      			PlayerInfo[playerid][pPot] += 5;
      			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = crack + 5, meth = meth + 5, pot = pot + 5 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
      		}
		}
	}
	if(PlayerInfo[playerid][pIllegalCargo] == ILLEGAL_MATS)
	{
		switch(PlayerInfo[playerid][pCourierSkill])
		{
			case 0..49:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 1]: "RED"You have received 200 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 200;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 200 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
	    	case 50..99:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 2]: "RED"You have received 300 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 300;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 300 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
			case 100..199:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 3]: "RED"You have received 400 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 400;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 400 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
			case 200..349:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 4]: "RED"You have received 500 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 500;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 500 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
			case 350..500:
			{
				SendClientMessage(playerid, COLOR_RED, ""YELLOW"[LEVEL 5]: "RED"You have received 600 materials as a reward for delivering illegal materials.");
    			PlayerInfo[playerid][pMaterials] += 600;
    			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = materials + 600 WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
	}
	if(PlayerInfo[playerid][pIllegalCargo] == ILLEGAL_GUNS)
	{
		switch(random(5))
		{
	    	case 0:
			{
				SendClientMessage(playerid, COLOR_RED, "NO BONUS SINCE IT'S LEGAL.");
    			//GiveWeapon(playerid, 25);
			}
	    	case 1:
			{
				SendClientMessage(playerid, COLOR_RED, "NO BONUS SINCE IT'S LEGAL.");
    			//GiveWeapon(playerid, 24);
			}
  			case 2:
			{
				SendClientMessage(playerid, COLOR_RED, "NO BONUS SINCE IT'S LEGAL.");
    			//GiveWeapon(playerid, 27);
			}
  			case 3:
			{
				SendClientMessage(playerid, COLOR_RED, "{NO BONUS SINCE IT'S LEGAL.");
    			//GiveWeapon(playerid, 28);
			}
  			case 4:
			{
				SendClientMessage(playerid, COLOR_RED, "NO BONUS SINCE IT'S LEGAL.");
    			//GiveWeapon(playerid, 31);
			}
		}
	}
	BusinessInfo[businessid][bProducts] += products;
	BusinessInfo[businessid][bCash] -= products2; 
	PlayerInfo[playerid][pShipment] = -1;
	PlayerInfo[playerid][pCourierCooldown] = 120;
	PlayerInfo[playerid][pIllegalCargo] = -1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

    IncreaseJobSkill(playerid, JOB_COURIER);

	return 1;
}



CMD:loadtruck(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_COURIER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you are not a Trucker.");
	}
	if(PlayerInfo[playerid][pCourierCooldown] > 0)
	{
	    return SM(playerid, COLOR_SYNTAX, "You need to wait %i more seconds before you can load another delivery.", PlayerInfo[playerid][pCourierCooldown]);
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsACourierCar(vehicleid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be driving a Benson.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 8.0, 2460.9790,-2119.2590,13.5530))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the loading dock.");
	}
	if(PlayerInfo[playerid][pShipment] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have a shipment loaded already. You need to deliver it first.");
	}

	ShowPlayerDialog(playerid, DIALOG_PICKLOAD, DIALOG_STYLE_LIST, "Choose the load you want to deliver.", "Grocery supplies\nAmmunition\nClothing items\nFood & drinks\nBeverages\nWeapon Supply\nIllegal Materials\nIllegal Drugs\nPharmacies", "Select", "Cancel");
	return 1;
}


CMD:getmats(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1421.6913, -1318.4719, 13.5547) && !IsPlayerInRangeOfPoint(playerid, 3.0, 2393.4885, -2008.5726, 13.3467))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any materials pickup.");
	}
	if(PlayerInfo[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}
	if(PlayerInfo[playerid][pCash] < 1000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least $1000 in cash to smuggle materials.");
	}
    if(PlayerInfo[playerid][pMaterials] + 500 > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
	{
	    return SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
	}

	PlayerInfo[playerid][pCP] = CHECKPOINT_MATS;
	PlayerInfo[playerid][pSmuggleTime] = gettime();

	GivePlayerCash(playerid, -1000);
	SendClientMessage(playerid, COLOR_AQUA, "** You paid $1000 for a load of materials. Smuggle them to the depot to collect them.");

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1421.6913, -1318.4719, 13.5547))
	{
	    AddPointMoney(POINT_MATPICKUP1, 75);
		SetPlayerCheckpoint(playerid, 2173.2129, -2264.1548, 13.3467, 3.0);
		PlayerInfo[playerid][pSmuggleMats] = 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2393.4885, -2008.5726, 13.3467))
	{
	    AddPointMoney(POINT_MATPICKUP2, 75);
		SetPlayerCheckpoint(playerid, 2288.0918, -1105.6555, 37.9766, 3.0);
		PlayerInfo[playerid][pSmuggleMats] = 2;
	}

	return 1;
}

CMD:repair(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:health;
    if(vehicleid != -1)
	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(gettime() - PlayerInfo[playerid][pLastRepair] < 20)
	{
		return SM(playerid, COLOR_SYNTAX, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerInfo[playerid][pLastRepair]));
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be repaired.");
	}

	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	GetVehicleHealth(vehicleid, health);

	if(health >= 1000.0)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't need to be repaired.");
	}
	else
	{
		PlayerInfo[playerid][pLastRepair] = gettime();

        RepairVehicle(GetPlayerVehicleID(playerid));
		SendClientMessage(playerid, COLOR_WHITE, "You have repaired the health and bodywork on this vehicle..");

		SetVehicleHealth(vehicleid, 1000.0);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s repairs the vehicle.", GetRPName(playerid));
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	}
	return 1;
}
CMD:refill(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    // Check if player is a Mechanic
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command unless you're a Mechanic.");
    }
    // Check if player is on-duty
    if(PlayerInfo[playerid][pDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    // Check if 20 seconds have passed since last refuel
    if(gettime() - PlayerInfo[playerid][pLastRefuel] < 20)
    {
        return SCMf(playerid, COLOR_SYNTAX, "You can only refuel a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerInfo[playerid][pLastRefuel]));
    }
    // Check if player is inside a vehicle
    if(!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
    }
    // Check if the vehicle has an engine
    if(!VehicleHasEngine(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be refueled.");
    }
    // Check if vehicle needs refueling
    if(vehicleFuel[vehicleid] >= 100)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't need to be refueled.");
    }
    // Check if the engine is running
    if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
    }

    // Refuel the vehicle
    vehicleFuel[vehicleid] += 10;
    if(vehicleFuel[vehicleid] > 100)
    {
        vehicleFuel[vehicleid] = 100;
    }

    // Update the last refuel time
    PlayerInfo[playerid][pLastRefuel] = gettime();

    // Notify players nearby
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s pours some gasoline to the vehicle.", GetRPName(playerid));
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

    return 1;
}

CMD:nos(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	switch(GetVehicleModel(vehicleid))
    {
		case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449:
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle can't be modified with nitrous.");
    }

	AddVehicleComponent(vehicleid, 1009);

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s attaches a 2x NOS Canister on the engine feed.", GetRPName(playerid));
	return 1;
}

CMD:hyd(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	AddVehicleComponent(vehicleid, 1087);

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s attaches a set of hydraulics to the vehicle.", GetRPName(playerid));
	return 1;
}

CMD:tow(playerid, params[])
{
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in a tow truck to use this command.");
	}
 	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

	new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);
    new Float:vX, Float:vY, Float:vZ;
    new Found = 0;
    new vid = 0;
    while ((vid<MAX_VEHICLES) && (!Found)) {
        vid++;
        GetVehiclePos(vid, vX, vY, vZ);
        if ((floatabs(pX - vX)<7.0) && (floatabs(pY - vY)<7.0) && (floatabs(pZ - vZ)<7.0) && (vid != GetPlayerVehicleID(playerid))) {
            Found = 1;
            if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) {
                DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
            }
            AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s lowers their tow hook, attaching it to the vehicle.", GetRPName(playerid));
            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s raises the tow hook, locking the vehicle in place..", GetRPName(playerid));
        }
    }
    if (!Found) {
        SendClientMessage(playerid, COLOR_SYNTAX, "There is no vehicle in range that you can tow.");
    }
    return 1;
}

CMD:impound(playerid)
{
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You must be in a tow truck to use this command.");
	}
	if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You are not towing a vehicle.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 7.0, 1596.938964, -1614.594482, 13.429326) && !IsPlayerInRangeOfPoint(playerid, 7.0, -17.6671, -2532.2358, 36.6484) && !IsPlayerInRangeOfPoint(playerid, 7.0, 1027.9797,1791.9083,10.8203))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You are not in range of the impound lot.");
	}
	new vehicleid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
    if(!VehicleInfo[vehicleid][vOwnerID] || !IsValidVehicle(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" You can only impound player owned vehicles.");
	}

	VehicleInfo[vehicleid][vTickets] += 50000;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "> Dispatch: %s %s has impounded a %s with %s unpaid tickets.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetVehicleName(vehicleid), FormatNumber(VehicleInfo[vehicleid][vTickets]));

	VehicleInfo[vehicleid][vPosX] = 2479.3637;
	VehicleInfo[vehicleid][vPosY] = -1946.9062;
	VehicleInfo[vehicleid][vPosZ] = 13.4864;
	VehicleInfo[vehicleid][vPosA] = 0.0000;
    VehicleInfo[vehicleid][vInterior] = 0;
    VehicleInfo[vehicleid][vWorld] = 0;
	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET impounded = '1', pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);
	DespawnVehicle(vehicleid);
	return 1;
}

CMD:untow(playerid, params[])
{
	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in a tow truck to use this command.");
	}
	if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You are not towing a vehicle.");
	}
	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s lowers their tow hook, detaching it from the vehicle.", GetRPName(playerid));
    return 1;
}

CMD:fill(playerid)
{
	return callcmd::refuel(playerid);
}

CMD:refuel(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerAtFuelStation(playerid) && GetInsideGarage(playerid) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at a gas station or inside of a garage.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any vehicle.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine and can't be refilled.");
	}
	if(vehicleFuel[vehicleid] >= 100)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The fuel tank in this vehicle is already full.");
	}
	if(PlayerInfo[playerid][pCash] < (100 - vehicleFuel[vehicleid]) * 2)
	{
	    return SM(playerid, COLOR_SYNTAX, "You don't have enough cash. It will cost you at least $%i.", (100 - vehicleFuel[vehicleid]) * 2);
	}

	if(PlayerInfo[playerid][pRefuel] != INVALID_VEHICLE_ID)
	{
	    GivePlayerCash(playerid, -PlayerInfo[playerid][pRefuelAmount]);
        SM(playerid, COLOR_AQUA, "** You've refilled your vehicle's gas tank for $%i.", PlayerInfo[playerid][pRefuelAmount]);

        PlayerInfo[playerid][pRefuel] = INVALID_VEHICLE_ID;
        PlayerInfo[playerid][pRefuelAmount] = 0;
	}
	else
	{
	    if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	    {
         	return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before proceeding.");
	    }

		PlayerInfo[playerid][pRefuel] = vehicleid;
		PlayerInfo[playerid][pRefuelAmount] = 0;

		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s begins to refuel their vehicle's gas tank.", GetRPName(playerid));
		SM(playerid, COLOR_WHITE, "** This will take about %i seconds. You will be notified once completed.", 100 - vehicleFuel[vehicleid]);
	}

	return 1;
}
CMD:robbigbank(playerid, params[])//unknow robbery
{
    if(!IsPlayerInRangeOfPoint(playerid, 5, 1729.803710, -1109.414794, 26.684938))
    {
        SendClientMessage(playerid, COLOR_WHITE, "Your aren't near in the bigbank vault!");
        return 1;
    }
    if(IsLawEnforcement(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "Law Enforcement Officials cannot rob the Big Bank.");
		return 1;
	}
	new	iSuccess;
	foreach(new i : Player)
	{
		if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
		{
			iSuccess ++;
		}
	}
	if(iSuccess < 4)
	{
		return SendClientMessage(playerid, COLOR_GREY, "There need to be 4+ LEO online in order to rob the Big Bank!");
	}
    if (Robfleecabank[playerid] == 0 )
    {
		GameTextForPlayer(playerid, "~g~Robbing Big Bank Vault...", 10000, 1);
        BigBankMoney[playerid] = 1;
        ApplyAnimationEx(playerid,"BOMBER","BOM_Plant", 4.1, 1, 1, 1, 0, 0);
        SetTimerEx("RobBigbank", 20000, false, "i", playerid);
        TogglePlayerControllable(playerid, 0);
    }
    
    new string[128];
	format(string, sizeof(string), "~r~bank Robbery on Progress");
    DynamicTextDrawSetString(Textdraw2, string);
    
    foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SM(i, COLOR_ROYALBLUE, "** HQ: A robbery is occurring at the Big Bank. All units respond immediately.");
			SetPlayerCheckpoint(i, 606.6394,-1460.2273,14.4079, 3.0);
		}
    }
    SendClientMessage(playerid, COLOR_GREY2,"** Wait until cops arrive for roleplay purposes. (( You can door shout by inputting '/ds'. ))");
    return 1;
}
CMD:buygascan(playerid)
{

	if(!IsPlayerAtFuelStation(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in The range of Fuel Pump");
	}
	if(PlayerInfo[playerid][pCash] < 10000)
	{
	    return SM(playerid, COLOR_SYNTAX, "You don't have enough cash. It will cost you at least $20000 for 1 gascan.");
	}
	if(PlayerInfo[playerid][pGasCan] > 20)
	{
	    return SM(playerid, COLOR_SYNTAX, "You Can Only Carry 20 gascan at a time");
	}
	PlayerInfo[playerid][pGasCan] ++;
    GivePlayerCash(playerid, -10000);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received a Gascan", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_WHITE, "** Gas can purchased. Use /gascan /gascanplace to place /usegascan to spill gasoil and burn.");
	return 1;
}

CMD:withdraw(playerid, params[])
{
	new amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1727.616455, -1129.108032, 24.095937))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SM(playerid, COLOR_WHITE, "USAGE /withdraw [amount] ($%i available)", PlayerInfo[playerid][pBank]);
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pBank])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	PlayerInfo[playerid][pBank] -= amount;
	GivePlayerCash(playerid, amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "** You have withdrawn $%i from your bank account. Your new balance is $%i.", amount, PlayerInfo[playerid][pBank]);
	return 1;
}



CMD:deposit(playerid, params[])
{
	new amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1727.616455, -1129.108032, 24.095937))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(PlayerInfo[playerid][pAdminDuty] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Command wont work as you're on duty.");
	}
	if(sscanf(params, "d", amount))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "USAGE /deposit [amount]");
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	PlayerInfo[playerid][pBank] += amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %d WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "** You have deposited $%d into your bank account. Your new balance is $%d.", amount, PlayerInfo[playerid][pBank]);
	return 1;
}

CMD:wiretransfer(playerid, params[])
{
	new targetid, amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}
	if(PlayerInfo[playerid][pLevel] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can only use this command if you are level 2+.");
	}
	if(sscanf(params, "ud", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "USAGE /wiretransfer [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or hasn't logged in yet.");
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
		return SAM(COLOR_RED, "%s attempts to wiretransfer to %s with %i", GetRPName(playerid), GetRPName(targetid), amount);
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pBank])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't transfer funds to yourself.");
	}

	PlayerInfo[targetid][pBank] += amount;
	PlayerInfo[playerid][pBank] -= amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %d WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %d WHERE uid = %i", PlayerInfo[targetid][pBank], PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "** You have transferred $%d to %s. Your new balance is $%d.", amount, GetRPName(targetid), PlayerInfo[playerid][pBank]);
	SM(targetid, COLOR_AQUA, "** %s has transferred $%d to your bank account.", GetRPName(playerid), amount);
	//Log_Write("log_give", "%s (uid: %d) (IP: %s) transferred $%i to %s (uid: %d) (IP: %s)", GetRPName(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), amount, GetRPName(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));

    if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
	{
	    SAM(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has transferred $%d to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(targetid), GetPlayerIP(targetid));
	}

	return 1;
}

CMD:balance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1727.406738, -1129.144409, 24.095937))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the bank.");
	}

	SM(playerid, COLOR_YELLOW, "Your bank account balance is $%i.", PlayerInfo[playerid][pBank]);
	return 1;
}

CMD:rt(playerid, params[])
{
	return callcmd::rsms(playerid, params);
}

//CMD:rs(playerid, params[])
//{
	//return callcmd::rsms(playerid, params);
//}

CMD:rsms(playerid, params[])
{
	new number = PlayerInfo[PlayerInfo[playerid][pTextFrom]][pPhone];
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rsms [text]");
	}
	if(PlayerInfo[playerid][pTextFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You havent received a text by anyone since you joined the server.");
	}
    if(PlayerInfo[PlayerInfo[playerid][pTextFrom]][pJailType] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "That player is currently imprisoned and cannot use their phone.");
    }
    if(PlayerInfo[PlayerInfo[playerid][pTextFrom]][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "That player has their mobile phone switched off.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are unable to use your cellphone at the moment.");
	}

	PlayerInfo[PlayerInfo[playerid][pTextFrom]][pTextFrom] = playerid;
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out a cellphone and sends a message.", GetRPName(playerid));

    SM(PlayerInfo[playerid][pTextFrom], COLOR_YELLOW, "** SMS from %s (%i): %s **", GetRPName(playerid), PlayerInfo[playerid][pPhone], params);
    SM(playerid, COLOR_YELLOW, "** SMS to %s (%i): %s **", GetRPName(PlayerInfo[playerid][pTextFrom]), PlayerInfo[PlayerInfo[playerid][pTextFrom]][pPhone], params);

    GivePlayerCash(playerid, -1);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$1", 5000, 1);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO texts VALUES(null, %i, %i, '%s', NOW(), '%e')", PlayerInfo[playerid][pPhone], number, GetPlayerNameEx(playerid), params);
	mysql_tquery(connectionID, queryBuffer);


    return 1;
}

CMD:loadsandal(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(!PlayerHasJob(playerid, JOB_SANDALWOOD))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a Sandal Wood Driver.");
	}
	if(!(GetVehicleModel(GetPlayerVehicleID(playerid)) == 578 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
		return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a Sandal Truck.");
	if(!IsPlayerInRangeOfPoint(playerid, 8.0, -545.220642, -188.894531, 78.406250))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at the starting point");
	}
	if(PlayerInfo[playerid][pSandal] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're already doing a trip!");
	}
    sandelwoodveh = CreateDynamicObject(18609,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
	AttachDynamicObjectToVehicle(sandelwoodveh, vehicleid, -0.013, -4.311, 0.700, 0.000, 0.000, 2.299);
	GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
	PlayerInfo[playerid][pSandal] = 1;
	PlayerInfo[playerid][pCP] = CHECKPOINT_SANDAL;
 	SetPlayerCheckpoint(playerid, 1338.852661, 336.368713, 19.554687, 5.0);
	return 1;
}

