CMD:carol(playerid, params[])
{
	#if defined Christmas
		new houseid = GetNearbyHouse(playerid);
		if(PlayerInfo[playerid][pHours] < 1)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You need to played 1 playing hour.");
		}
		if(houseid == -1)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You must be near a house to use this command.");
		}
		if(IsHouseOwner(playerid, houseid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot carol at a house that you own.");
		}
		if(PlayerInfo[playerid][pLastCarolTime] > 0)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You can only carol every 30 seconds.");
		}
		if(PlayerInfo[playerid][pLastHouseCarol] == houseid)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You have carolled at this house already.");
		}
		PlayerInfo[playerid][pLastHouseCarol] = houseid;
		CarolLyrics[playerid] = Random(1, 5);
		ShowDialogToPlayer(playerid, DIALOG_CAROL);
	#else
		SendClientMessage(playerid, COLOR_SYNTAX, "It isn't Christmas!");
	#endif
	return 1;
}

stock ReturnLyrics(lyricid)
{
	new lyString[65];
	switch(lyricid)
	{
	    case 1: lyString = "Jingle bells, jingle bells, jingle all, the way!";
		case 2: lyString = "We wish you a merry christmas and a happy new year!";
		case 3: lyString = "I wanna wish you a merry christmas!";
		case 4: lyString = "Last christmas, i gave you my heart";
		case 5: lyString = "Santa claus is coming to town!";
	}
	return lyString;
}

stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
			InventoryData[playerid][i][invAmount] = 0;
		}
	}
	return 1;
}

stock Inventory_GetItemID(playerid, const item[])
{
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 20)
		return -1;

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
    new count;

    for(new i = 0; i < MAX_INVENTORY; i++) if (InventoryData[playerid][i][invExists])
	{
        count++;
	}
	return count;
}

stock Inventory_Count(playerid, const item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invAmount];

	return 0;
}

stock PlayerHasItem(playerid, const item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_Set(playerid, const item[], model, amount)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Addset(playerid, item, model, amount);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

stock Inventory_SetQuantity(playerid, const item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    InventoryData[playerid][itemid][invAmount] = quantity;
	}
	return 1;
}

stock Inventory_Remove(playerid, const item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);
		

	if (itemid != -1)
	{
			
	    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			
		    if (InventoryData[playerid][itemid][invAmount] > 0)
		    {
				
		        InventoryData[playerid][itemid][invAmount] -= quantity;
		        
			}
			if (quantity == -1 || InventoryData[playerid][itemid][invAmount] < 1)
			{
			    InventoryData[playerid][itemid][invExists] = false;
			    InventoryData[playerid][itemid][invModel] = 0;
			    InventoryData[playerid][itemid][invAmount] = 0;
			    
			}
		}
		return 1;
	}
	return 0;
}
stock Inventory_Addset(playerid, const item[], model, amount = 1)
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);
	    if (itemid != -1)
	    {
	   		InventoryData[playerid][itemid][invExists] = true;
		    InventoryData[playerid][itemid][invModel] = model;
			InventoryData[playerid][itemid][invAmount] = amount;
			

		    strpack(InventoryData[playerid][itemid][invItem], item, 32 char);

	
		    return itemid;
		}
		return -1;
	}
	else
	{
		InventoryData[playerid][itemid][invAmount] += amount;
		
	}
	return itemid;
}

stock Inventory_Add(playerid, const item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);


	if (itemid == -1)
	{    
       	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			if(InventoryData[playerid][itemid][invExists])
			{   
				itemid = Inventory_GetFreeID(playerid);
				if (itemid != -1){
					InventoryData[playerid][itemid][invExists] = true;
					InventoryData[playerid][itemid][invModel] = model;
					InventoryData[playerid][itemid][invAmount] = quantity;
				}
				
			}
			else{
				InventoryData[playerid][itemid][invAmount] += quantity;
			}     	 	  	
			
			return itemid;
		}
		
		return -1;
	}
	return itemid;
}

NearPlayer(playerid, targetid, Float:radius)
{
    static
        Float:fX,
        Float:fY,
        Float:fZ;

    GetPlayerPos(targetid, fX, fY, fZ);

    return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock Inventory_Close(playerid)
{
	if(BukaInven[playerid] == 0)
		return 1;

	CancelSelectTextDraw(playerid);
	PlayerInfo[playerid][pSelectItem] = -1;
	PlayerInfo[playerid][pGiveAmount] = 1;
	BukaInven[playerid] = 0;
	for(new a = 0; a < 6; a++)
	{
		PlayerTextDrawHide(playerid, INVNAME[playerid][a]);
	}
	for(new a = 0; a < 11; a++)
	{
		PlayerTextDrawHide(playerid, INVINFO[playerid][a]);
	}
	DynamicPlayerTextDrawSetString(playerid,INVINFO[playerid][6], "Amount");
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		PlayerTextDrawHide(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawColour(playerid, INDEXTD[playerid][i], 859394047);
		PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
		PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
	}
	for(new inv = 0; inv<17; inv++)PlayerTextDrawHide(playerid, DropTD[playerid][inv]);
	for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropModel[playerid][inv]);
    for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropName[playerid][inv]);
    for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropValue[playerid][inv]);
	return 1;
}

stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock Inventory_Show(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	new str[256], string[256];
	format(str,1000,"%s", GetName(playerid));
	DynamicPlayerTextDrawSetString(playerid, INVNAME[playerid][3], str);
	for(new a = 0; a < 6; a++)
	{
		PlayerTextDrawShow(playerid, INVNAME[playerid][a]);
	}
	for(new a = 0; a < 11; a++)
	{
		PlayerTextDrawShow(playerid, INVINFO[playerid][a]);
	}
 	for(new inv = 0; inv < 17; inv++)PlayerTextDrawShow(playerid, DropTD[playerid][inv]);
    PlayerInfo[playerid][pGiveAmount] = 1;
	BarangMasuk(playerid);
	BukaInven[playerid] = 1;
	PlayerPlaySound(playerid, 1039, 0,0,0);
	SelectTextDraw(playerid, 0xFFA500FF);
	

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    PlayerTextDrawShow(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawShow(playerid, AMOUNTTD[playerid][i]);
		
		if(InventoryData[playerid][i][invExists])
		{
			PlayerTextDrawShow(playerid, NAMETD[playerid][i]);
			PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][i], InventoryData[playerid][i][invModel]);

			if(InventoryData[playerid][i][invModel] == 18867)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[playerid][i][invModel] == 16776)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[playerid][i][invModel] == 1581)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			PlayerTextDrawShow(playerid, MODELTD[playerid][i]);
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			DynamicPlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%dx", InventoryData[playerid][i][invAmount]);
			DynamicPlayerTextDrawSetString(playerid, AMOUNTTD[playerid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
			PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
			PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		}
	}
	return 1;
}
forward OnPlayerPickItem(playerid,  name[], value);
public OnPlayerPickItem(playerid, name[], value)
{
	
    if(!strcmp(name, "Phone"))
	{
    	PlayerInfo[playerid][pPhonee] = 1;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "GPS"))
	{
	    PlayerInfo[playerid][pGPS] = 1;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Milkshake"))
	{
	   
		if(!PlayerInfo[playerid][pMilkshake] + value > 20)
	       PlayerInfo[playerid][pMilkshake] += value;
		else
		   notification_show(playerid, str_format("You can only have 20 Milkshake at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Redbull"))
	{
		if(!PlayerInfo[playerid][pRedbull] + value > 10)
	       PlayerInfo[playerid][pRedbull] += value;
		else
		   notification_show(playerid, str_format("You can only have 10 Redbull at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Burger"))
	{
	   
		if(!PlayerInfo[playerid][pFMJAmmo] + value > 20)
	       PlayerInfo[playerid][pFMJAmmo] += value;
		else
		   notification_show(playerid, str_format("You can only have 20 Burger at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Chickenroll"))
	{
	   
		if(!PlayerInfo[playerid][pRedroll] + value > 10)
	       PlayerInfo[playerid][pRedroll] += value;
		else
		   notification_show(playerid, str_format("You can only have 10 chickenRoll at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Cigar"))
	{
		if(!PlayerInfo[playerid][pCigars] + value > 20)
	       PlayerInfo[playerid][pCigars] += value;
		else
		   notification_show(playerid, str_format("You can only have 20 Cigars at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);

		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Pot"))
	{
		if(!PlayerInfo[playerid][pPot] + value > 100)
	       PlayerInfo[playerid][pPot] += value;
		else
		   notification_show(playerid, str_format("You can only have 100 Pot at a Time Or you can only pick %d now",100 - PlayerInfo[playerid][pPot]), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Cocaine"))
	{  
		if(!PlayerInfo[playerid][pCrack] + value > 100)
	       PlayerInfo[playerid][pCrack] += value;
		else
		   notification_show(playerid, str_format("You can only have 100 Cocaine at a Time Or you can only pick %d now", 100 - PlayerInfo[playerid][pCrack]), 2000, NOTIF_ERROR);

		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Joint"))
	{  
		if(!PlayerInfo[playerid][pPainkillers] + value > 100)
	       PlayerInfo[playerid][pPainkillers] += value;
		else
			notification_show(playerid, str_format("You can only have 100 Joint at a Time Or you can only pick %d now", 100 - PlayerInfo[playerid][pPainkillers]), 2000, NOTIF_ERROR);

	    PlayerInfo[playerid][pPainkillers] += value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Meth"))
	{
		if(!PlayerInfo[playerid][pMeth] + value > 100)
	       PlayerInfo[playerid][pMeth] += value;
		else
			notification_show(playerid, str_format("You can only have 100 Meth at a Time Or you can only pick %d now", 100 - PlayerInfo[playerid][pMeth]), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Vest"))
	{
		if(!PlayerInfo[playerid][pVest] + value > 5)
	       PlayerInfo[playerid][pVest] += value;
		else
		   notification_show(playerid, str_format("You can only have 5 Vest at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Helmet"))
	{
		if(!PlayerInfo[playerid][pHelmet1] + value > 5)
	       PlayerInfo[playerid][pHelmet1] += value;
		else
		   notification_show(playerid, str_format("You can only have 5 Helmets at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Mask"))
	{
	    PlayerInfo[playerid][pMask] = 1;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Apple"))
	{
	    PlayerInfo[playerid][pApple] += value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Mats"))
	{
	    PlayerInfo[playerid][pMaterials] += value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "RepairKit"))
	{
		if(!PlayerInfo[playerid][pRepairKit] + value > 2)
	       PlayerInfo[playerid][pRepairKit] += value;
		else
		   notification_show(playerid, str_format("You can only have 2 repair kits at a Time Or you can only pick 1"), 2000, NOTIF_ERROR);
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Acetone"))
	{ 
	    PlayerInfo[playerid][pAcetone] += value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Battery"))
	{
	    PlayerInfo[playerid][pBatteries] += value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "MobileMeth"))
	{
		if(!PlayerInfo[playerid][pMobileMethLab] + value > 5)
	       PlayerInfo[playerid][pMobileMethLab] += value;
		else
		   notification_show(playerid, str_format("You can only have 5 MobileMethLab at a Time Or you can only pick one now"), 2000, NOTIF_ERROR);
	
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Boombox"))
	{
	    PlayerInfo[playerid][pBoombox] = 1;
		Inventory_Update(playerid);
	}
    return 1;
}
forward OnPlayerDropItem(playerid,  name[], value);
public OnPlayerDropItem(playerid, name[], value)
{
	
    if(!strcmp(name, "Phone"))
	{
    	PlayerInfo[playerid][pPhonee] = 0;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "GPS"))
	{
	    PlayerInfo[playerid][pGPS] = 0;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Milkshake"))
	{
	    PlayerInfo[playerid][pMilkshake] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Redbull"))
	{
	    PlayerInfo[playerid][pRedbull] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Burger"))
	{
	    PlayerInfo[playerid][pFMJAmmo] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Chickenroll"))
	{
	    PlayerInfo[playerid][pRedroll] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Gascan"))
	{
        PlayerInfo[playerid][pGasCan] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Cigar"))
	{
	    PlayerInfo[playerid][pCigars] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Pot"))
	{
	    PlayerInfo[playerid][pPot] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Cocaine"))
	{  
	    PlayerInfo[playerid][pCrack] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Joint"))
	{  
	    PlayerInfo[playerid][pPainkillers] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Meth"))
	{
	    PlayerInfo[playerid][pMeth] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Vest"))
	{
		PlayerInfo[playerid][pVest] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Helmet"))
	{
		PlayerInfo[playerid][pHelmet1] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Mask"))
	{
	    PlayerInfo[playerid][pMask] = 0;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Apple"))
	{
	    PlayerInfo[playerid][pApple] -= value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Mats"))
	{
	    PlayerInfo[playerid][pMaterials] -= value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "RepairKit"))
	{
	    PlayerInfo[playerid][pRepairKit] -= value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Acetone"))
	{ 
	    PlayerInfo[playerid][pAcetone] -= value;
		Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Battery"))
	{
	    PlayerInfo[playerid][pBatteries] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "MobileMeth"))
	{
	    PlayerInfo[playerid][pMobileMethLab] -= value;
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Boombox"))
	{
	    PlayerInfo[playerid][pBoombox] = 0;
		Inventory_Update(playerid);
	}
    return 1;
}
forward OnPlayerUseItem(playerid, itemid, name[], value);
public OnPlayerUseItem(playerid, itemid, name[], value)
{
	if(!strcmp(name, "Money"))
	{
	    SCMf(playerid, -1, "Money %i", PlayerInfo[playerid][pCash]);
	    Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Dirtycash"))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Dirtycash");
	}
	else if(!strcmp(name, "Phone"))
	{
    	Inventory_Close(playerid);
		showitembox(playerid, "Phone", "USE", 18870 , 3);
    	callcmd::phone(playerid);
	}
	else if(!strcmp(name, "GPS"))
	{
	    ShowDialogToPlayer(playerid, DIALOG_LOCATE);
	    showitembox(playerid, "GPS", "USE", 18874, 3);
	    Inventory_Close(playerid);
	    Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Milkshake"))
	{
		new drinkitem[] = "milkshake";
	    callcmd::drink(playerid, drinkitem);
    	Inventory_Remove(playerid, "Milkshake", 1);
		showitembox(playerid, "Milkshake", "USE1x", 2647, 3);
        Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Redbull"))
	{
		new drinkitem1[] = "redbull";
	    callcmd::drink(playerid, drinkitem1);
    	Inventory_Remove(playerid, "Redbull", 1);
		showitembox(playerid, "Redbull", "USE1x", 2601, 3);
    	Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Burger"))
	{
		new drinkitem2[] = "burger";
	    callcmd::eat(playerid, drinkitem2);
    	Inventory_Remove(playerid, "Burger", 1);
		showitembox(playerid, "Burger", "USE1x", 2703, 3);
   	    Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Chickenroll"))
	{
		new drinkitem3[] = "chickenroll";
	    callcmd::eat(playerid, drinkitem3);
		Inventory_Remove(playerid, "Chickenroll", 1);
		showitembox(playerid, "Chickenroll", "USE1x", 2768, 3);
        Inventory_Update(playerid);
    	
	}
	else if(!strcmp(name, "Gascan"))
	{
        new vehicleid = GetPlayerVehicleID(playerid);

        if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        {
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any vehicle of yours.");
		}
		if(!IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't refuel this vehicle as it doesn't belong to you.");
		}

        PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pGasCan] -= 1;
        vehicleFuel[vehicleid] += 20;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
                
	   
	    Inventory_Remove(playerid, "Gascan", 1);
		showitembox(playerid, "GASCAN", "USE", 1650, 3);
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Cigar"))
	{
	    callcmd::usecigar(playerid);
    	Inventory_Remove(playerid, "Cigar", 1);
		showitembox(playerid, "Cigar", "USE", 19897, 3);
    	Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Pot"))
	{
		if(gettime() - PlayerInfo[playerid][pLastDrug] < 5)
		{
	   		return SM(playerid, COLOR_SYNTAX, "You can only consume drugs every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastDrug]));
		}
		new druguse[] = "pot";
	    callcmd::usedrug(playerid, druguse);
 		Inventory_Remove(playerid, "Pot", 1);
		showitembox(playerid, "Pot", "USED_1x", 1361, 2);
 		Inventory_Update(playerid);
 		
	}
	else if(!strcmp(name, "Cocaine"))
	{  
		if(gettime() - PlayerInfo[playerid][pLastDrug] < 5)
		{
	   		return SM(playerid, COLOR_SYNTAX, "You can only consume drugs every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastDrug]));
		}
		new druguse1[] = "Cocaine";
	    callcmd::usedrug(playerid, druguse1);
 		Inventory_Remove(playerid, "Cocaine",2);
		showitembox(playerid, "Coacine", "USED_2x", 1577, 2);
 		Inventory_Update(playerid);
 		
	}
	else if(!strcmp(name, "Joint"))
	{  
		
		if(gettime() - PlayerInfo[playerid][pLastDrug] < 5)
		{
	   		return SM(playerid, COLOR_SYNTAX, "You can only consume drugs every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastDrug]));
		}
		new druguse2[] = "Joint";
	    callcmd::usedrug(playerid, druguse2);
 		Inventory_Remove(playerid, "Joint", 2);
		showitembox(playerid, "Joint", "USED_2x", 2647, 2);
 		Inventory_Update(playerid);
 		
	}
	else if(!strcmp(name, "Meth"))
	{
		
		if(gettime() - PlayerInfo[playerid][pLastDrug] < 5)
		{
	   		return SM(playerid, COLOR_SYNTAX, "You can only consume drugs every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerInfo[playerid][pLastDrug]));
		}
		new druguse3[] = "Meth";
	    callcmd::usedrug(playerid, druguse3);
	    Inventory_Remove(playerid, "Meth", 2);
        Inventory_Update(playerid);
	    showitembox(playerid, "Meth","USED_2x", 1580, 2);
	}
	else if(!strcmp(name, "Vest"))
	{
		new itemuse[] = "vest";
		callcmd::use(playerid, itemuse);	
    	Inventory_Remove(playerid, "vest", 1);
		showitembox(playerid, "Vest", "USED_1x", 373, 2);
		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Helmet"))
	{
		new itemuse1[] = "helmet";
		callcmd::use(playerid, itemuse1);
    	Inventory_Remove(playerid, "Helmet", 1);
		showitembox(playerid, "Helmet", "USED_1x", 18645, 2);
   		Inventory_Update(playerid);
	}
	else if(!strcmp(name, "Mask"))
	{
	    callcmd::mask(playerid);
		showitembox(playerid, "Mask", "USED_1x", 19163, 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Apple"))
	{
	    callcmd::apple(playerid);
    	Inventory_Remove(playerid, "Apple", 1);
		showitembox(playerid, "Apple", "USED_1x", 19575, 2);
	    Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Mats"))
	{
	   SendClientMessage(playerid, COLOR_BLUE , "Used To craft something");
	}
    else if(!strcmp(name, "RepairKit"))
	{
	   callcmd::userepairkit(playerid, "");
	   Inventory_Remove(playerid, "RepairKit", 1);
	   showitembox(playerid, "RepairKit", "USED_1x",19921 , 2);
	   Inventory_Update(playerid);
	}
    else if(!strcmp(name, "Acetone"))
	{
	  SendClientMessage(playerid, COLOR_BLUE , "Used To Cook something");
	}
    else if(!strcmp(name, "Battery"))
	{
	  SendClientMessage(playerid, COLOR_BLUE , "Used To cook something");
	}
	else if(!strcmp(name, "MobileMeth"))
	{
	  SendClientMessage(playerid, COLOR_BLUE , "Used To cook something");
	}
    return 1;
}

stock BarangMasuk(playerid)
{
	Inventory_Set(playerid, "Money", 1212, PlayerInfo[playerid][pCash]);
	Inventory_Set(playerid, "Dirtycash", 1580, PlayerInfo[playerid][pDirtyCash]);
	Inventory_Set(playerid, "Phone", 18870, PlayerInfo[playerid][pPhonee]);
	Inventory_Set(playerid, "Vest", 373, PlayerInfo[playerid][pVest]);
	Inventory_Set(playerid, "Mask", 18914, PlayerInfo[playerid][pMask]);
	Inventory_Set(playerid, "Burger", 2703, PlayerInfo[playerid][pFMJAmmo]);
	Inventory_Set(playerid, "GPS", 18874, PlayerInfo[playerid][pGPS]);
	Inventory_Set(playerid, "Milkshake", 2647, PlayerInfo[playerid][pMilkshake]);
	Inventory_Set(playerid, "Boombox", 19423, PlayerInfo[playerid][pBoombox]);
	Inventory_Set(playerid, "Gascan", 1650, PlayerInfo[playerid][pGasCan]);
	Inventory_Set(playerid, "Meth", 1577, PlayerInfo[playerid][pMeth]);
	Inventory_Set(playerid, "Cigar", 19897, PlayerInfo[playerid][pCigars]);
	Inventory_Set(playerid, "Pot", 1580, PlayerInfo[playerid][pPot]);
	Inventory_Set(playerid, "Cocaine", 1579, PlayerInfo[playerid][pCrack]);
	Inventory_Set(playerid, "Joint", 2647, PlayerInfo[playerid][pPainkillers]);
	Inventory_Set(playerid, "Helmet", 18645, PlayerInfo[playerid][pHelmet1]);
	Inventory_Set(playerid, "Redbull", 2601, PlayerInfo[playerid][pRedbull]);
	Inventory_Set(playerid, "Chickenroll", 2768, PlayerInfo[playerid][pRedroll]);
	Inventory_Set(playerid, "Apple", 19575, PlayerInfo[playerid][pApple]);
	Inventory_Set(playerid, "Mats", 1575, PlayerInfo[playerid][pMaterials]);
	Inventory_Set(playerid, "RepairKit", 2919, PlayerInfo[playerid][pRepairKit]);
	Inventory_Set(playerid, "Acetone", 2841, PlayerInfo[playerid][pAcetone]);
	Inventory_Set(playerid, "Battery", 365, PlayerInfo[playerid][pBatteries]);
	Inventory_Set(playerid, "MobileMeth", 18869, PlayerInfo[playerid][pMobileMethLab]);
	Inventory_Update(playerid);
}

stock Inventory_Update(playerid)
{
	new str[256], string[256];
	new
		count = 0,
		id = Item_Nearest(playerid);
        //otherid[1080];

    if (id != -1)
    {
		for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropModel[playerid][inv]);
        for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropName[playerid][inv]);
        for(new inv = 0; inv<15; inv++)PlayerTextDrawHide(playerid, DropValue[playerid][inv]);
        for (new i = 0; i < MAX_DROPPED_ITEMS; i ++) if (count < 17 && DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.9, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]) && GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld]) {
            NearestItems[playerid][count] = i;
            PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][count], DroppedItems[i][droppedModel]);
            DynamicPlayerTextDrawSetString(playerid, DropName[playerid][count], DroppedItems[i][droppedItem]);
            new valuedrop[128];
            format(valuedrop, sizeof valuedrop, "%dx", DroppedItems[i][droppedQuantity]);
            DynamicPlayerTextDrawSetString(playerid, DropValue[playerid][count], valuedrop);
            PlayerTextDrawShow(playerid, DropModel[playerid][count]);
            PlayerTextDrawShow(playerid, DropName[playerid][count]);
            PlayerTextDrawShow(playerid, DropValue[playerid][count]);
			DroppedItems[i][droptext] = count;
			count++;
		
        }

    }
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		if(InventoryData[playerid][i][invExists])
		{
		    PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][i], InventoryData[playerid][i][invModel]);

			if(InventoryData[playerid][i][invModel] == 18867)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[playerid][i][invModel] == 16776)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[playerid][i][invModel] == 1581)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			DynamicPlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%dx", InventoryData[playerid][i][invAmount]);
			DynamicPlayerTextDrawSetString(playerid, AMOUNTTD[playerid][i], str);
			//BarangMasuk(playerid)
		}
		else
		{
			PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
			PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
			PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
			
		}
	}
}

stock MenuStore_SelectRow(playerid, row)
{
	PlayerInfo[playerid][pSelectItem] = row;
    PlayerTextDrawHide(playerid, INDEXTD[playerid][row]);
	PlayerTextDrawColour(playerid, INDEXTD[playerid][row], -7232257);
	PlayerTextDrawShow(playerid, INDEXTD[playerid][row]);
	PlayerTextDrawHide(playerid, INVNAME[playerid][0]);
	PlayerTextDrawShow(playerid, INVNAME[playerid][0]);
	SelectTextDraw(playerid, 0xFFA500FF);
}

stock MenuStore_UnselectRow(playerid)
{
	if(PlayerInfo[playerid][pSelectItem] != -1)
	{
		new row = PlayerInfo[playerid][pSelectItem];
		PlayerTextDrawHide(playerid, INDEXTD[playerid][row]);
		PlayerTextDrawColour(playerid, INDEXTD[playerid][row], 859394047);
		PlayerTextDrawShow(playerid, INDEXTD[playerid][row]);
		PlayerTextDrawHide(playerid, INVNAME[playerid][0]);
		PlayerTextDrawShow(playerid, INVNAME[playerid][0]);
	}
	PlayerInfo[playerid][pSelectItem] = -1;
}

forward OnPlayerGiveInvItem(playerid, userid, itemid, name[], value);
public OnPlayerGiveInvItem(playerid, userid, itemid, name[], value)
{
    new str[64];

	if(Inventory_Count(playerid, name) < PlayerInfo[playerid][pGiveAmount])
		return SendClientMessage(playerid, COLOR_SYNTAX, "Error: You don't have anything serious that you want to give him/her.");

	if(!strcmp(name, "Money", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Money", str, 1212, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Money", str, 1212, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pCash] -= value;
		PlayerInfo[userid][pCash] += value;
		
        new szString[128];
  	    format(szString, sizeof(szString),"%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), PlayerInfo[playerid][pGiveAmount], GetPlayerNameEx(userid), PlayerInfo[userid][pID], GetPlayerIP(userid));
  	    SendDiscordMessage(12, szString);
		
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[userid][pCash], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}

	else if(!strcmp(name, "Dirtycash", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Dirtycash", str, 1580, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Dirtycash", str, 1580, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pDirtyCash] -= value;
		PlayerInfo[userid][pDirtyCash] += value;
		
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[userid][pDirtyCash], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);


	}
	else if(!strcmp(name, "Milkshake", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Milkshake", str, 19570, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Milkshake", str, 19570, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pMilkshake] -= value;
		PlayerInfo[userid][pMilkshake] += value;
		
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET poisonammo = %i WHERE uid = %i", PlayerInfo[playerid][pMilkshake], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET poisonammo = %i WHERE uid = %i", PlayerInfo[userid][pMilkshake], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Burger", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Burger", str, 2703, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Burger", str, 2703, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pFMJAmmo] -= value;
		PlayerInfo[userid][pFMJAmmo] += value;
		
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fmjammo = %i WHERE uid = %i", PlayerInfo[playerid][pFMJAmmo], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fmjammo = %i WHERE uid = %i", PlayerInfo[userid][pFMJAmmo], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Redbull", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Redbull", str, 2601, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Redbull", str, 2601, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pRedbull] -= value;
		PlayerInfo[userid][pRedbull] += value;
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energydrink = %i WHERE uid = %i", PlayerInfo[playerid][pRedbull], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energydrink = %i WHERE uid = %i", PlayerInfo[userid][pRedbull], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Chickenroll", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Chickenroll", str, 2768, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Chickenroll", str, 2768, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pRedroll] -= value;
		PlayerInfo[userid][pRedroll] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energyroll = %i WHERE uid = %i", PlayerInfo[playerid][pRedroll], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energyroll = %i WHERE uid = %i", PlayerInfo[userid][pRedroll], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);

	}
    else if(!strcmp(name, "GPS", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "GPS", str, 18874, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "GPS", str, 18874, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pGPS] -= value;
		PlayerInfo[userid][pGPS] += value;
	}
	else if(!strcmp(name, "GASCAN", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "GASCAN", str, 1650, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "GASCAN", str, 1650, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pGasCan] -= value;
		PlayerInfo[userid][pGasCan] += value;
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerInfo[userid][pGasCan], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Phone", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Phone", str, 18870, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Phone", str, 18870, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pPhonee] -= value;
		PlayerInfo[userid][pPhonee] += value;
	}
	else if(!strcmp(name, "Mask", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Mask", str, 18914, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Mask", str, 18914, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pMask] -= value;
		PlayerInfo[userid][pMask] += value;
	}
	else if(!strcmp(name, "Repair Kit", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Repair Kit", str, 920, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Repair Kit", str, 920, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pRepairKit] -= value;
		PlayerInfo[userid][pRepairKit] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[userid][pRepairKit], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Vest", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Vest", str, 373, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Vest", str, 373, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pVest] -= value;
		PlayerInfo[userid][pVest] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[playerid][pVest], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[userid][pVest], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Helmet", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Helmet", str, 18645, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Helmet", str, 18645, 2);

	    ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pHelmet1] -= value;
		PlayerInfo[userid][pHelmet1] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmetp = %i WHERE uid = %i", PlayerInfo[playerid][pHelmet1], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmetp = %i WHERE uid = %i", PlayerInfo[userid][pHelmet1], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Mats", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Mats", str, 1575, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Mats", str, 1575, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0);

	
        PlayerInfo[playerid][pMaterials] -= value;
		PlayerInfo[userid][pMaterials] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[userid][pMaterials], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);

	}
	else if(!strcmp(name, "Joint", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Joints", str, 1575, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Joints", str, 1575, 2);

		ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimationEx(userid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        PlayerInfo[playerid][pPainkillers] -= value;
		PlayerInfo[userid][pPainkillers] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[userid][pPainkillers], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "Meth", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Mats", str, 1575, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Mats", str, 1575, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);

        PlayerInfo[playerid][pMeth] -= value;
		PlayerInfo[userid][pMeth] += value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[userid][pMeth], PlayerInfo[userid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(name, "RepairKit", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "RepairKit", str, 1575, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "RepairKit", str, 1575, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);

        PlayerInfo[playerid][pRepairKit] -= value;
		PlayerInfo[userid][pRepairKit] += value;
	}
    else if(!strcmp(name, "Acetone"))
	{
	  	format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Acetone", str, 1575, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Acetone", str, 1575, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);

        PlayerInfo[playerid][pAcetone] -= value;
		PlayerInfo[userid][pAcetone] += value;
	}
    else if(!strcmp(name, "Battery"))
	{
	  	format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "Battery", str, 330, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "Battery", str, 330, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);

        PlayerInfo[playerid][pBatteries] -= value;
		PlayerInfo[userid][pBatteries] += value;
	}
	else if(!strcmp(name, "MobileMeth"))
	{
	  	format(str, sizeof(str), "Removed_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(playerid, "MobileMeth", str, 18869, 2);

		format(str, sizeof(str), "Received_%dx", PlayerInfo[playerid][pGiveAmount]);
		showitembox(userid, "MobileMeth", str, 18869, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, false, false, false, false, false, SYNC_ALL);

        PlayerInfo[playerid][pMobileMethLab] -= value;
		PlayerInfo[userid][pMobileMethLab] += value;
	}
	return Inventory_Close(playerid);
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
    DisablePlayerRaceCheckpoint(playerid);
    CancelTracing(playerid);
    return 1;
}

#define MAX_FREQUENCY 30

new PlayerFrequency[MAX_PLAYERS][MAX_FREQUENCY + 1];
new lastfreq[MAX_PLAYERS];

stock SendClientMessageToFrequency(frequency_id, color, const message[]) {
    foreach(new player : Player) {
        if (PlayerFrequency[player][frequency_id] == 1) {
            SendClientMessage(player, color, message);
        }
    }
}

CMD:fq(playerid, params[]) {
    callcmd::frequency(playerid, params);
}

CMD:frequency(playerid, params[]) {
    new frequency_id, string[64];

    if (sscanf(params, "i", frequency_id)) {
        return SendClientMessage(playerid, -1, "Use: /frequency [frequency-id 1 - 30] [0 to disconnect]");
    }

    if (frequency_id < 0 || frequency_id > MAX_FREQUENCY) {
        return SendClientMessage(playerid, -1, "Use: [frequency-id 1 - 30] [0 to disconnect]");
    }

    if (frequency_id == 0) {
        // Disconnect from all frequencies
        for (new i = 1; i <= MAX_FREQUENCY; i++) {
            PlayerFrequency[playerid][i] = 0;
        }
        if(isUsingRadioVoip[playerid] == false)
		{
			return 1;
		}
        CallRemoteFunction("LeaveGroupVoiceChannel", "i", playerid);
        isUsingRadioVoip[playerid] = false;
        
        format(string, sizeof(string), "Someone Disconnected From Frequency %i", lastfreq[playerid]);
        SendClientMessage(playerid, COLOR_AQUA, "Disconnected From Public Radio");
        SendClientMessageToFrequency(lastfreq[playerid], COLOR_GREEN, string);
    } else {
        // Connect to a specific frequency
        if (isUsingRadioVoip[playerid] == true) {
            CallRemoteFunction("LeaveGroupVoiceChannel", "i", playerid);
        }

        CallRemoteFunction("JoinGroupVoiceChannel", "ii", playerid, frequency_id);
        isUsingRadioVoip[playerid] = true;
        PlayerFrequency[playerid][frequency_id] = 1;
        
        SCMf(playerid, COLOR_AQUA, "Connected To Frequency %i", frequency_id);
        lastfreq[playerid] = frequency_id;
        
        format(string, sizeof(string), "Someone Connected To Frequency %i", frequency_id);
        SendClientMessageToFrequency(frequency_id, COLOR_GREEN, string);
    }
    
    return 1;
}

CMD:voipstats(playerid) {
  new hasVoiceOnClient = GetPVarInt(playerid,"hasVoiceOnClient");
  if(hasVoiceOnClient == 0) {
      SendClientMessage(playerid, -1, "No plugin VOIP installed");
  }
  else if(hasVoiceOnClient == 2) {
      SendClientMessage(playerid, -1, "With plugin VOIP and NO MICRO");
  }
  else if(hasVoiceOnClient == 1) {
      SendClientMessage(playerid, -1, "With plugin VOIP and MICRO");
  }
  return true;
}
CMD:uselaptop(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 5, 966.832397, -1739.891113, 14.079087) && !IsPlayerInRangeOfPoint(playerid, 9.0, 966.832397, -1739.891113, 14.079087))
    {
        SendClientMessage(playerid, COLOR_WHITE, "Your aren't near in the fleeca vault!");
        return 1;
    }
    if(!PlayerInfo[playerid][pLaptop])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "[!]{ffffff} You don't have any Laptop.");
	}
	if(RobberyInfo[rTime] > 0)
	{
		    return SCMf(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} The Bank can be robbed again in %i hours. You can't rob it now.", RobberyInfo[rTime]);
	}
    if(IsLawEnforcement(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "Law Enforcement Officials cannot rob an fleeca bank.");
		return 1;
	}
	new	iSuccess;
	foreach(new i :Player)
	{
		if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
		{
			iSuccess ++;
		}
	}
	if(iSuccess < 4)
	{
		return SendClientMessage(playerid, COLOR_GREY, "There need to be 4+ LEO online in order to rob the fleeca bank!");
	}
    if(HackerJob[playerid] > 0)
        {
			SendClientMessage(playerid,0xFF0000AA,"You have started a Hacker Job and can't use this command.");
			return 1;
		}
	foreach(new i : Player)
		{
			if(IsLawEnforcement(i))
			{
				SM(i, COLOR_ROYALBLUE, "** HQ: A robbery is occurring at the Fleeca Bank. All units respond immediately.");
				SetPlayerCheckpoint(i, 946.102539, -1675.799804, 14.079088, 10.0);
			}
	    }
    PlayerInfo[playerid][pLaptop] -= 1;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET laptop = %i WHERE uid = %i", PlayerInfo[playerid][pLaptop], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    HackerJob[playerid] = 1;
    SMA(COLOR_GREEN, "%s was working as a Hacker.", GetRPName(playerid));
    HJLimitTimer = SetTimerEx("HJTimeLimit", 300000, false, "d", playerid);

    HackerSetup(playerid);
    return 1;
}

forward HJTimeLimit(playerid);
public HJTimeLimit(playerid)
{
	ShowPlayerDialog(playerid,-1,0,"","","","");
	HackerJob[playerid] = 0;
	SendClientMessage(playerid,0xFF0000AA,"* Working time you're done, and you dont finish it.");
	return 1;
}

forward HackerSetup(playerid);
public HackerSetup(playerid)
{
    ApplyAnimationEx(playerid,"INT_OFFICE","OFF_Sit_Type_Loop", 4.0, true, false, false, false, false);
	SetTimerEx("HackerOne", 4000, false, "d", playerid);
}

forward HackerOne(playerid);
public HackerOne(playerid)
{
	ShowPlayerDialog(playerid, 1998, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nSystem is ready to rip off an important center\nType 8877554330 to Hack Flecca Bank", "Submit", "Cancel");
}

forward HackerTwo(playerid);
public HackerTwo(playerid)
{
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",1000,6);
	ShowPlayerDialog(playerid, 1999, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nThe system continues to the next center\nType 004555675775 to Hack Flecca Bank", "Submit", "Cancel");
}

forward HackerThree(playerid);
public HackerThree(playerid)
{
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",1000,6);
	ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nThe system continues to the next center\nType 6600551456 to Hack Flecca Bank", "Submit", "Cancel");
}
forward HackerFour(playerid);
public HackerFour(playerid)
{
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",1000,6);
	ShowPlayerDialog(playerid, 2001, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nThe system continues to the next center\nType 3056432167 to Hack Flecca Bank", "Submit", "Cancel");
}
forward HackerFive(playerid);
public HackerFive(playerid)
{
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",1000,6);
	ShowPlayerDialog(playerid, 2002, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nThe system continues to the next center\nType 87543709754 to Hack Flecca Bank", "Submit", "Cancel");
}

forward HackerSix(playerid);
public HackerSix(playerid)
{
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",1000,6);
	ShowPlayerDialog(playerid, 2003, DIALOG_STYLE_INPUT, "root@localhost:~", "Login as: root\nThe system continues to the next center\nType 901155875456 to Hack Flecca Bank", "Submit", "Cancel");
}

forward HackerSeven(playerid);
public HackerSeven(playerid)
{
    KillTimer(HJLimitTimer);
    PlayerPlaySound( playerid, 1058, 0, 0, 0 );
    GameTextForPlayer(playerid,"~p~succeed",2000,6);
    SetTimerEx("HackerSuccesed", 3000, false, "d", playerid);
    if (Robfleecabank[playerid] == 0 )
    {
    	Dyuze(playerid, "Notice", "~g~Robbing Fleeca Vault...");
        Robfleecabank[playerid] = 1;
        ApplyAnimationEx(playerid,"BOMBER","BOM_Plant", 4.1, true, true, true, false, false);
        SetTimerEx("RobFleecabank", 20000, false, "i", playerid);
        TogglePlayerControllable(playerid, 0);
    }
}

forward HackerSuccesed(playerid);
public HackerSuccesed(playerid)
{
    foreach(new i : Player)
		{
			if(IsLawEnforcement(i))
			{
				SM(i, COLOR_ROYALBLUE, "** Successful Flecca Robbery Finished");
				SetPlayerCheckpoint(i, 684.8798,-1178.2994,15.2313, 3.0);
			}
	    }
    TogglePlayerControllable(playerid,true);
	HackerJob[playerid] = 0;
    return 1;
 }
