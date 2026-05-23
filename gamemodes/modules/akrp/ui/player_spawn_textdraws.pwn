public OnPlayerRequestClass(playerid, classid)
{
    if(!PlayerInfo[playerid][pLogged])
    {
        ClearChat(playerid);
        for(new i = 0; i < 5; i ++)
        {
            SendClientMessage(playerid, -1, " ");
        }

        TogglePlayerSpectating(playerid, 1);
        SetPlayerColor(playerid, 0xFFFFFF00);

        SetTimerEx("IntroTimer9", 1500, false, "i", playerid); //here dont change this  will cause bug
        // Due to a SA-MP bug, you can't apply camera coordinates directly after enabling spectator mode (to hide HUD).
        // In this case, we'll use a timer to defer this action.
        //SetTimerEx("AnimationEntryPhases", 2000, false, "ii", playerid, 0);
        //SetTimerEx("AnimationEntryPhases", 3000, false, "ii", playerid, 1);
    }

    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(PlayerInfo[playerid][pKicked]) return 0;
	

	if (PlayerInfo[playerid][pLoggedAuto]) 
	{
		PlayerInfo[playerid][pLoggedAuto] = 0;
		SetTimerEx("SendDelayMessage", 1000, false, "i", playerid);
	}
    if(!PlayerInfo[playerid][pPreloaded])
	{
	
		PreloadAnims(playerid);
	    PreloadAnimLibs(playerid);
		PlayerInfo[playerid][pPreloaded] = 1;
	}
    	
	helmetbar = CreatePlayerProgressBar(playerid, 547, 101, 55.5, 3.2,-21557249, 100.0, BAR_DIRECTION_RIGHT);
	SetPlayerProgressBarValue(playerid, helmetbar,PlayerInfo[playerid][pHelmet]);

    PlayerTextDrawDestroy(playerid, INTRO[playerid][0]);
    PlayerTextDrawDestroy(playerid, INTRO[playerid][1]);
    PlayerTextDrawDestroy(playerid, INTRO[playerid][2]);
    PlayerTextDrawDestroy(playerid, INTRO[playerid][3]);
    PlayerTextDrawDestroy(playerid, INTRO[playerid][4]);
    PlayerTextDrawDestroy(playerid, INTRO[playerid][5]);
    for(new i = 0; i < 23; i++)
    {
      PlayerTextDrawDestroy(playerid, SPAWN[playerid][i]);
    }

	if(PlayerInfo[playerid][pSetup])
    {
        if(PlayerInfo[playerid][pTutorial])
        {
            KillTimer(PlayerInfo[playerid][pTutorialTimer]);
            PlayerInfo[playerid][pTutorial] = 0;
        }

        TogglePlayerControllable(playerid, false);


        InsideTut[playerid] = 1;
        SetPlayerVirtualWorld(playerid, 0);
        TogglePlayerSpectating(playerid, false);
        InsideTut[playerid] = 1;
        SetPlayerPos(playerid, 1381.626586, -770.586059, 3007.127929);
        SetPlayerFacingAngle(playerid, 358.72);
        InterpolateCameraPos(playerid, 1381.339843, -765.349975, 3007.127929, 1381.339843, -765.349975, 3007.127929, 5000);
        InterpolateCameraLookAt(playerid, 1381.345336, -766.516662, 3007.127929 , 1381.345336, -766.516662, 3007.127929 , 5000);
        SetPlayerVirtualWorld(playerid, playerid);
        SelectTextDraw(playerid, COLOR_RED);

        SetPlayerVirtualWorld(playerid, playerid);
        TogglePlayerControllable(playerid, 0);

        ResetCharacterSetup(playerid);

        for (new i = 0; i < 21; i ++) {
           PlayerTextDrawShow(playerid, CharTextdraw[playerid][i]);
        }
        SetPlayerVirtualWorld(playerid, 0);
        StopAudioStreamForPlayer(playerid);
    }
	else if(PlayerInfo[playerid][pJailTime] > 0)
	{
	    SetPlayerInJail(playerid);
	    if(PlayerInfo[playerid][pJailType] == 2)
	    {
	        SM(playerid, COLOR_LIGHTRED, "** You were placed in admin prison by %s, reason: %s", PlayerInfo[playerid][pPrisonedBy], PlayerInfo[playerid][pPrisonReason]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "** You havent completed your jail sentence yet.");
		}
	}
	else if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    SetPlayerInPaintball(playerid, PlayerInfo[playerid][pPaintball]);
	}
	else
	{
	    PlayerInfo[playerid][pJoinedEvent] = 0;

	    if(PlayerInfo[playerid][pInjured])
	    {
	        SetPlayerHealth(playerid, 100.0);
	        SetPlayerArmour(playerid, 0.0);
            
            ApplyAnimation(playerid, "SWEET", "SWEET_INJUREDLOOP", 4.1, true, false, false, true, 0, SYNC_OTHER);
			
	        SendClientMessage(playerid, COLOR_DOCTOR, "[!] >> You are badly injured.You can wait for and ambulance by entering '/call 911'");
	        SendClientMessage(playerid, COLOR_DOCTOR, "You have been Brutally Wounded, Now if a medic or somebody doesn't help you. you will die.");

			new string[128];
			format(string, sizeof(string), "(( Has been wounded ))");
			for(new td = 0; td < 4; td ++)
	        {
	         	PlayerTextDrawShow(playerid, DEATH[playerid][td]);
            }
            for(new i = 0; i < 15; i++)
            {
	           TextDrawShowForPlayer(playerid, DEATHBUTTON[i]);
	        }
            SelectTextDraw(playerid, COLOR_RED);
        	PlayerTextDrawShow(playerid, DEATHBUTTONP[playerid][0]);
                                       
            killtimerz[playerid] = SetTimerEx("Dcstart", 1000, true, "i", playerid);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("UnfreezePlayerEx", 5000, false, "i", playerid);

            if(PlayerInfo[playerid][pTagType] == TAG_MASK)
			{
			 	SetPlayerSpecialTag(playerid, TAG_NORMAL);
			}
		   	Maskara[playerid] = 0;
		   	MaskaraID[playerid] = 0;
	        PlayerInfo[playerid][pDeathCooldown] = 360;
	        PlayerInfo[playerid][pRevCooldown] = 30;
	    }
	    else if(PlayerInfo[playerid][pHospital])
	    {
	        if(PlayerInfo[playerid][pInsurance] == 0)
     	   		SetPlayerInHospital(playerid);
	        else
				SetPlayerInHospital(playerid, .type = PlayerInfo[playerid][pInsurance]);

			ResetPlayerWeaponsEx(playerid);
	    }
	    else
		{
		    SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
		    SetScriptArmour(playerid, PlayerInfo[playerid][pArmor]);
			
		    //SetTimerEx("AKRP", 4000, false, "ii", playerid, 0);
		}

		if(!PlayerInfo[playerid][pHospital])
		{
		    if(PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
			{
				PlayerInfo[PlayerInfo[playerid][pDueling]][pDueling] = INVALID_PLAYER_ID;
				PlayerInfo[playerid][pDueling] = INVALID_PLAYER_ID;
			}
            if(PlayerInfo[playerid][pLastlog] == 0)
            {
			   SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
               SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
			   SetPlayerWeapons(playerid);
			}
			SetPlayerWeapons(playerid);
			PlayerInfo[playerid][pLastlog] = 0;
			
		}
	}
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 998);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 998);
 	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 998);
	SetPlayerClothing(playerid);


	#if defined Christmas
    	PlayerTextDrawShow(playerid, EventTextdraw[playerid]);
	#endif

	for(new i = 0; i < 13; i ++)
	{
		PlayerTextDrawShow(playerid, HUD[playerid][i]);
    }
	for(new i = 0; i < 7; i ++)
	{
		PlayerTextDrawShow(playerid, 	LOGO[playerid][i]);
    }

   

	TextDrawShowForPlayer(playerid, TextdrawTD);
   	TextDrawShowForPlayer(playerid, Textdraw2);
	return 1;
}


UpdateCharacterSetup(playerid)
{
	new string[64], gender[8];
	if(PlayerInfo[playerid][pGender] == 1) gender = "Male";
	else if(PlayerInfo[playerid][pGender] == 2) gender = "Female";
	else if(PlayerInfo[playerid][pGender] == 3) gender = "Shemale";
	format(string, sizeof(string), "Name: %s", GetRPName(playerid));
	DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][3], string);

	format(string, sizeof(string), "Gender: %s", gender);
	DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][4], string);

	format(string, sizeof(string), "Skin: %i", PlayerInfo[playerid][pOutfit]);
	DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][5], string);

	format(string, sizeof(string), "Age: %i", PlayerInfo[playerid][pAge]);
	DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][6], string);

	if (PlayerInfo[playerid][pGender] == GENDER_MALE) {
		DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][11], "Male");
		DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][12], "Female");
	} else if (PlayerInfo[playerid][pGender] == GENDER_FEMALE) {
		DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][11], "Male");
		DynamicPlayerTextDrawSetString(playerid, CharTextdraw[playerid][12], "Female");
	}
}
ResetCharacterSetup(playerid)
{
    if (PlayerInfo[playerid][pSetup])
    {
        PlayerInfo[playerid][pSkin] = g_MaleSkins[0];
        PlayerInfo[playerid][pAge] = 13;
        PlayerInfo[playerid][pGender] = GENDER_MALE;
        PlayerInfo[playerid][pOutfit] = 0;

        SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
        UpdateCharacterSetup(playerid);
    }
}
UpdateSkinSelection(playerid, index)
{
	new size;

	if (PlayerInfo[playerid][pGender] == GENDER_MALE) {
		size = sizeof(g_MaleSkins);
	} else if (PlayerInfo[playerid][pGender] == GENDER_FEMALE) {
		size = sizeof(g_FemaleSkins);
	}

	if (index < 0) {
		index = --size;
	} else if (index >= size) {
		index = 0;
	}

	PlayerInfo[playerid][pOutfit] = index;

	if (PlayerInfo[playerid][pGender] == GENDER_MALE) {
		PlayerInfo[playerid][pSkin] = g_MaleSkins[index];
	} else if (PlayerInfo[playerid][pGender] == GENDER_FEMALE) {
		PlayerInfo[playerid][pSkin] = g_FemaleSkins[index];
	}

	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
}
UpdateCamera(playerid, index)
{
   switch(index)
   {
	 case 0:
	 {
	 	InterpolateCameraPos(playerid, 356.160736, -1782.627563, 12.331799 , 359.160736, -1782.627563, 12.331799 , 14000);
		InterpolateCameraLookAt(playerid, 356.160736, -1782.627563, 12.331799,  356.160736, -1782.627563, 12.331799, 14000);
		DynamicPlayerTextDrawSetString(playerid, SPAWN[playerid][22], "BEACH GARAGE");
	 }
	 case 1:
	 {
	 
   	 	InterpolateCameraPos(playerid,1029.351074, -2027.496215, 16.079614, 1034.351074, -2027.496215, 16.079614 , 14000);
		InterpolateCameraLookAt(playerid, 1029.351074, -2027.496215, 16.079614,  1029.351074, -2027.496215, 16.079614, 14000);
		DynamicPlayerTextDrawSetString(playerid, SPAWN[playerid][22], "MAIN GARAGE");
     }
	 case 2:
	 {
	 
   	 	InterpolateCameraPos(playerid, 263.017791, -2009.502685, 10.038359 , 260.985015, -1898.844848, 24.536014 , 14000);
		InterpolateCameraLookAt(playerid, 223.017791, -1950.502685, 10.038359,   263.017791, -2009.502685, 10.038359, 14000);
		DynamicPlayerTextDrawSetString(playerid, SPAWN[playerid][22], "AKRP ISLAND");
     }
   
   }
}
#define CAMERA_LEFT 0
#define CAMERA_CENTER 1
#define CAMERA_RIGHT 2
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new title[68], string[500], ip[32];
	GetPlayerIp(clickedplayerid, ip, 32);
    format(string, sizeof(string), "Report Player\nPrivate Message\n");
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		format(string, sizeof(string), "%sKick Player\nBan Player\nSpectate Player\nBring Player\nGoto Player\nNewbie Mute Player\nFreeze Player\nUnfreeze Player\nSlap Player\nRevive Player\nCheck Player\nNon-Roleplay Name\nShow Rules\nCheck Player's Gun\nCheck Player's Vehicles\nBan Ip\n{00FF5C}IP Address: {FFFFFF}%s", string, ip);
	}
	SetPVarInt(playerid, "pClickedID", clickedplayerid);
	format(title, sizeof(title), "{00FF5C}"SERVER_NAME" Panel {FFFFFF}ID: %d", clickedplayerid);
	ShowPlayerDialog(playerid, DIALOG_PCP,DIALOG_STYLE_LIST,title,string,"Select","Cancel");
	return 1;
}
public OnClickDynamicPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if (PlayerInfo[playerid][pSetup])
	{
		if (playertextid == CharTextdraw[playerid][11]) {
			PlayerInfo[playerid][pGender] = GENDER_MALE;
			UpdateSkinSelection(playerid, 0);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		} else if (playertextid == CharTextdraw[playerid][12]) {
			PlayerInfo[playerid][pGender] = GENDER_FEMALE;
			UpdateSkinSelection(playerid, 0);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		} else if (playertextid == CharTextdraw[playerid][14] && PlayerInfo[playerid][pAge] > 13) {
			PlayerInfo[playerid][pAge]--;
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		} else if (playertextid == CharTextdraw[playerid][15] && PlayerInfo[playerid][pAge] < 99) {
			PlayerInfo[playerid][pAge]++;
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		} else if (playertextid == CharTextdraw[playerid][17]) {
			UpdateSkinSelection(playerid, PlayerInfo[playerid][pOutfit] - 1);
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		} else if (playertextid == CharTextdraw[playerid][18]) {
			UpdateSkinSelection(playerid, PlayerInfo[playerid][pOutfit] + 1);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		}
		else if (playertextid == CharTextdraw[playerid][20])
		{
		    PlayerInfo[playerid][pTutorial] = 1;
			PlayerInfo[playerid][pTutorialTimer] = SetTimerEx("PlayerSpawn", 1000, false, "i", playerid);
		}
		UpdateCharacterSetup(playerid);
	}
	for(new i = 0; i < MAX_INVENTORY; i++)
     {
        if(playertextid == MODELTD[playerid][i])
		{
			if(InventoryData[playerid][i][invExists])
			{
			    MenuStore_UnselectRow(playerid);
				MenuStore_SelectRow(playerid, i);
			    new name[48];
            	strunpack(name, InventoryData[playerid][PlayerInfo[playerid][pSelectItem]][invItem]);
			}
		}
	}
	if(BukaInven[playerid])
	{
        new id = Item_Nearest(playerid);
        //otherid[1080];

	    if (id != -1)
	    {
			for(new i = 0; i<20; i++) if(playertextid == DropModel[playerid][i])
			{
	            new itemid = NearestItems[playerid][i];
				PickupItem(playerid, itemid);
			}
		}
	}
	
	if(playertextid == INVINFO[playerid][2])
	{
 	    new id = PlayerInfo[playerid][pSelectItem];

		if(id == -1)
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] There are no items in the slot");
		}
		else
		{
			new string[64];
		    strunpack(string, InventoryData[playerid][id][invItem]);

		    if(!PlayerHasItem(playerid, string))
		    {
		   		SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] You Don't Own These Items");
                Inventory_Show(playerid);
			}
			else
			{
				CallLocalFunction("OnPlayerUseItem", "dds", playerid, id, string);
			}
		}
	}
    else if(playertextid == INVINFO[playerid][5])
	{
		Inventory_Close(playerid);
	}
	else if(playertextid == INVINFO[playerid][4])
	{
	    new id = PlayerInfo[playerid][pSelectItem];

		if (id == -1)
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] There are no items in the slot");
		}
		else
		{
			new item[64];
			strunpack(item, InventoryData[playerid][id][invItem]);
            
			if(Inventory_Count(playerid, item) < PlayerInfo[playerid][pGiveAmount])
		       return SendClientMessage(playerid, COLOR_SYNTAX, "Error: You don't have anything serious that you want to Drop");

			if (!PlayerHasItem(playerid, item))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] You Don't Own These Items");
				Inventory_Show(playerid);
			}	
			if (PlayerInfo[playerid][pAdminDuty])
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] Da Manushyaraya Andas Venam Andass");
				return 1;
			}
			else
			{
				if (strcmp(item, "Gascan", true) == 0)
				{
					callcmd::gascanplace132(playerid);
				}
		
				else
				{
				
					for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], InventoryData[playerid][id][invItem], true))
					{
						if(g_aInventoryItems[i][e_InventoryDrop] == false) return SCMf(playerid,COLOR_RED, "You can't drop this item (%s).", InventoryData[playerid][id][invItem]);
					}
					//Drop Item
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					if(IsWeaponModel(InventoryData[playerid][id][invModel]))
					{
						//DropItem(InventoryData[playerid][id][invItem], playerid, InventoryData[playerid][id][invModel], InventoryData[playerid][id][invAmount], x, y, z-1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), InventoryData[playerid][id][invWeapon], InventoryData[playerid][id][invAmmo]);
						//ResetWeapon(playerid, InventoryData[playerid][id][invWeapon]);
					}
					else DropItem(id , InventoryData[playerid][id][invItem], playerid, InventoryData[playerid][id][invModel],PlayerInfo[playerid][pGiveAmount], x, y, z-1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
				
				}
				
			}
		}
	}
    else if(playertextid == INVINFO[playerid][3])
	{
		new str[1024], id = PlayerInfo[playerid][pSelectItem], count = 0;

		if(id == -1)
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] Choose the item farthest; it is the first.");
		}
		else
		{
		    if (PlayerInfo[playerid][pGiveAmount] < 1)
				return SendClientMessage(playerid, COLOR_SYNTAX, "[Inventory] Choose how much you want to remove from that item in the quantity");

            foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
			    format(str, sizeof(str), "%s Pocket - %i\n", GetRPName(i), i);
			    SetPlayerListitemValue(playerid, count++, i);
			}

			if(!count) SendClientMessage(playerid, COLOR_SYNTAX, "There is No one Near!");
			else ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_LIST, "All Kerala - Inventory", str, "Yes", "No");
		}
	}
	else if(playertextid == INVINFO[playerid][1])
	{
		ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Inventory - Amount", "Enter how much:", "Yes", "No");
	}
	if (playertextid == ClotheTD[playerid][1])
	{
		UpdateClotheSelection(playerid, PlayerInfo[playerid][pOutfit] - 1);
		PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		UpdateClotheSetup(playerid);
	}
	else if (playertextid == ClotheTD[playerid][0]) {
		UpdateClotheSelection(playerid, PlayerInfo[playerid][pOutfit] + 1);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		UpdateClotheSetup(playerid);
	}
	else if(playertextid == ClotheTD[playerid][2])
    {
		callcmd::hidedressmenu(playerid);
	}
	if(playertextid == LOGINTD[playerid][32])
	{
	   ShowDialogToPlayer(playerid, DIALOG_LOGIN);
	  
	   PlayerInfo[playerid][pPassword3] = 1;

	}
	if(playertextid == LOGINTD[playerid][41])
	{
	   new
       specifiers[] = "%D of %M, %Y @ %k:%i";
	   if(PlayerInfo[playerid][pPassword3] == 1)
	   {
          mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT *, DATE_FORMAT(lastlogin, '%s') AS login_date FROM users WHERE username = '%e' AND password = '%e'", specifiers, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPassword]);
          mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_PROCESS_LOGIN, playerid);
          PlayerInfo[playerid][pPassword3] = 0;
	   }
	}
	
	if(playertextid == REGISTER[playerid][7])
	{
	  if(PlayerInfo[playerid][pRegpass] == 0)
	  {
	    ShowDialogToPlayer(playerid, DIALOG_REGISTER);
	    PlayerInfo[playerid][pRegpass] = 1;

		PlayerTextDrawHide(playerid,REGISTER[playerid][5]);
		PlayerTextDrawHide(playerid,REGISTER[playerid][8]);
	    PlayerTextDrawColour(playerid, REGISTER[playerid][5],1724754687);
	    PlayerTextDrawColour(playerid, REGISTER[playerid][8],172475468);
		PlayerTextDrawShow(playerid,REGISTER[playerid][5]);
		PlayerTextDrawShow(playerid,REGISTER[playerid][8]);

        //PlayerText_InterpolateColor(playerid, REGISTER[playerid][5], 548580095, 300, EASE_OUT_QUAD);
        //PlayerText_InterpolateColor(playerid, REGISTER[playerid][8], 548580095, 300, EASE_OUT_QUAD);
	  }
	}
	if(playertextid == SPAWN[playerid][4])
	{
	   SetPlayerToSpawn(playerid);
	}
	if(playertextid == SPAWN[playerid][5])
	{
       SetPlayerToSpawnEx(playerid, PlayerInfo[playerid][pSpawn]);
       PlayerInfo[playerid][pLastlog] = 1;
	}
	if (playertextid == SPAWN[playerid][17]) // Right arrow
	{
		// Cycle to the right
		PlayerInfo[playerid][pSpawn]++;
		
		// Loop back to the first camera if we exceed the maximum
		if (PlayerInfo[playerid][pSpawn] > CAMERA_RIGHT) {
			PlayerInfo[playerid][pSpawn] = CAMERA_LEFT; // Reset to the left camera
		}
		
		UpdateCamera(playerid, PlayerInfo[playerid][pSpawn]);
	}
	else if (playertextid == SPAWN[playerid][14]) // Left arrow
	{
		// Cycle to the left
		PlayerInfo[playerid][pSpawn]--;
		
		// Loop back to the last camera if we go below the minimum
		if (PlayerInfo[playerid][pSpawn] < CAMERA_LEFT) {
			PlayerInfo[playerid][pSpawn] = CAMERA_RIGHT; // Reset to the right camera
		}
		
		UpdateCamera(playerid, PlayerInfo[playerid][pSpawn]);
	}
	if(playertextid == REGISTER[playerid][10])
	{
	  if(PlayerInfo[playerid][pRegpass] == 1)
	  {
         
		 ShowPlayerDialog(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD, ""SVRCLR"Confirmation", ""WHITE"Please repeat your account password for verification:", "Submit", "Back");
      }
	  else
	  {
        if(PlayerInfo[playerid][pRegpass] == 0)
        {
		
			PlayerTextDrawHide(playerid,REGISTER[playerid][5]);
			PlayerTextDrawHide(playerid,REGISTER[playerid][8]);
			PlayerTextDrawColour(playerid, REGISTER[playerid][5],0xFF0000FF);
			PlayerTextDrawColour(playerid, REGISTER[playerid][8],0xFF0000FF);
			PlayerTextDrawShow(playerid,REGISTER[playerid][5]);
			PlayerTextDrawShow(playerid,REGISTER[playerid][8]);

          //PlayerText_InterpolateColor(playerid, REGISTER[playerid][5], 0xFF0000FF, 500, EASE_OUT_QUAD);
          //PlayerText_InterpolateColor(playerid, REGISTER[playerid][8], 0xFF0000FF, 500, EASE_OUT_QUAD);
        }
	  }
	}
	if(playertextid == REGISTER[playerid][13])
	{
      if(PlayerInfo[playerid][pRegpass] == 2)
      {
	    
        if(!strcmp(PlayerInfo[playerid][pPassword], PlayerInfo[playerid][pPassword1]))
        {
           gTotalRegistered++;
           SaveServerInfo();

           for(new i = 0; i < 15; i ++)
           {
               PlayerTextDrawDestroy(playerid,REGISTER[playerid][i]);
           }
           CancelSelectTextDraw(playerid);

           mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users (username, password, regdate, lastlogin, ip) VALUES('%e', '%e', NOW(), NOW(), '%e')", GetPlayerNameEx(playerid), PlayerInfo[playerid][pPassword1], GetPlayerIP(playerid));
           mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_ACCOUNT_REGISTER, playerid);
       }
	  }
	  else
	  {

		
		PlayerTextDrawHide(playerid,REGISTER[playerid][5]);
		PlayerTextDrawHide(playerid,REGISTER[playerid][8]);
		PlayerTextDrawHide(playerid,REGISTER[playerid][9]);
		PlayerTextDrawHide(playerid,REGISTER[playerid][11]);

	    PlayerTextDrawColour(playerid, REGISTER[playerid][5],0xFF0000FF);
	    PlayerTextDrawColour(playerid, REGISTER[playerid][8],0xFF0000FF);
		PlayerTextDrawColour(playerid, REGISTER[playerid][9],0xFF0000FF);
	    PlayerTextDrawColour(playerid, REGISTER[playerid][11],0xFF0000FF);

		PlayerTextDrawShow(playerid,REGISTER[playerid][5]);
		PlayerTextDrawShow(playerid,REGISTER[playerid][8]);
		PlayerTextDrawShow(playerid,REGISTER[playerid][9]);
		PlayerTextDrawShow(playerid,REGISTER[playerid][11]);
		//PlayerText_InterpolateColor(playerid, REGISTER[playerid][5], 0xFF0000FF, 500, EASE_OUT_QUAD);
		//PlayerText_InterpolateColor(playerid, REGISTER[playerid][8], 0xFF0000FF, 500, EASE_OUT_QUAD);
		//PlayerText_InterpolateColor(playerid, REGISTER[playerid][9], 0xFF0000FF, 500, EASE_OUT_QUAD);
		//PlayerText_InterpolateColor(playerid, REGISTER[playerid][11], 0xFF0000FF, 500, EASE_OUT_QUAD);
	  
	  }
	}
    if(playertextid == DEATHBUTTONP[playerid][0])
    {
	    
	    new count;
    	foreach(new i : Player)
	    {
	       if(IsMedic(i) && PlayerInfo[i][pDuty] == 1)
	       {
				count++;
		   }
	    }
	    if(count > 0)
     	{
	        callcmd::callems(playerid, cmdtext2);
	       	for(new i = 0; i < 15; i++)
            {
               TextDrawHideForPlayer(playerid, DEATHBUTTON[i]);
            }
			PlayerTextDrawHide(playerid, DEATHBUTTONP[playerid][0]);
	    }
	    else
	    {
	       callcmd::mrevive(playerid);
	    }
     
	}
    if(playertextid == CALP[playerid][0])
    {
		DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], "");
		PlayerTextDrawShow(playerid, CALP[playerid][1]);
		DynamicPlayerTextDrawSetString(playerid,CALP[playerid][1], "");
		PlayerTextDrawShow(playerid, CALP[playerid][1]);
		calculation_string[playerid] = "";
		calculation_result[playerid] = 0;
		numberc[playerid] = "";
		anumberc[playerid] = "";
    }
    return 1;
}
forward IInsta(playerid);
public IInsta(playerid)
{
	if(PlayerInfo[playerid][pInstallInsta])
	{
	   TextDrawShowForPlayer(playerid, PHONE[45]);
 	   TextDrawShowForPlayer(playerid, PHONE[89]);
       TextDrawShowForPlayer(playerid, PHONE[77]);
       TextDrawShowForPlayer(playerid, PHONE[107]);
       TextDrawShowForPlayer(playerid, PHONE[108]);

	}
	else
	{
        TextDrawHideForPlayer(playerid, PHONE[45]);
 	    TextDrawHideForPlayer(playerid, PHONE[89]);
        TextDrawHideForPlayer(playerid, PHONE[77]);
        TextDrawHideForPlayer(playerid, PHONE[107]);
        TextDrawHideForPlayer(playerid, PHONE[108]);
	}
}
forward DownloadInsta(playerid);
public DownloadInsta(playerid)
{

	PlayerInfo[playerid][pInstallInsta] = 1;

	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][3], 0.100, 0.799);
	PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
	PlayerTextDrawShow(playerid, APPLOCKGET[playerid][3]);
	DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][3], "INSTALLING");

	SetTimerEx("ChangeText", 2000, false, "i", playerid); // Set a timer for 2 seconds

	return 1;
}
forward ITaxi(playerid);
public ITaxi(playerid)
{
	if(PlayerInfo[playerid][pInstallTaxi])
	{
	   TextDrawShowForPlayer(playerid, PHONE[87]);
 	   TextDrawShowForPlayer(playerid, PHONE[50]);
       TextDrawShowForPlayer(playerid, PHONE[39]);

	}
	else
	{
        TextDrawHideForPlayer(playerid, PHONE[87]);
 	    TextDrawHideForPlayer(playerid, PHONE[50]);
        TextDrawHideForPlayer(playerid, PHONE[39]);
	}
}
forward DownloadTaxi(playerid);
public DownloadTaxi(playerid)
{

	PlayerInfo[playerid][pInstallTaxi] = 1;

	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][1], 0.100, 0.799);
	PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
	PlayerTextDrawShow(playerid, APPLOCKGET[playerid][1]);
	DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][1], "INSTALLING");

	SetTimerEx("ChangeText", 2000, false, "i", playerid); // Set a timer for 2 seconds

	return 1;
}
forward IValley(playerid);
public IValley(playerid)
{
	if(PlayerInfo[playerid][pInstallValley])
	{
	   TextDrawShowForPlayer(playerid, PHONE[86]);
 	   TextDrawShowForPlayer(playerid, PHONE[75]);
       TextDrawShowForPlayer(playerid, PHONE[40]);

	}
	else
	{
        TextDrawHideForPlayer(playerid, PHONE[86]);
 	    TextDrawHideForPlayer(playerid, PHONE[75]);
        TextDrawHideForPlayer(playerid, PHONE[40]);
	}
}
forward DownloadValley(playerid);
public DownloadValley(playerid)
{

	PlayerInfo[playerid][pInstallValley] = 1;

	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][0], 0.100, 0.799);
	PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
	PlayerTextDrawShow(playerid, APPLOCKGET[playerid][0]);
	DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][0], "INSTALLING");

	SetTimerEx("ChangeText", 2000, false, "i", playerid); // Set a timer for 2 seconds

	return 1;
}
forward ITwitter(playerid);
public ITwitter(playerid)
{
	if(PlayerInfo[playerid][pInstallTweet])
	{
	   TextDrawShowForPlayer(playerid, PHONE[88]);
 	   TextDrawShowForPlayer(playerid, PHONE[76]);
       TextDrawShowForPlayer(playerid, PHONE[46]);

	}
	else
	{
 		TextDrawHideForPlayer(playerid, PHONE[88]);
 	    TextDrawHideForPlayer(playerid, PHONE[76]);
        TextDrawHideForPlayer(playerid, PHONE[46]);
	}
}
forward DownloadTweet(playerid);
public DownloadTweet(playerid)
{

	PlayerInfo[playerid][pInstallTweet] = 1;

	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][2], 0.100, 0.799);
	PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
	PlayerTextDrawShow(playerid, APPLOCKGET[playerid][2]);
	DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][2], "INSTALLING");

	SetTimerEx("ChangeText", 2000, false, "i", playerid); // Set a timer for 2 seconds

	return 1;
}

forward load(playerid);
public load(playerid)
{
	for(new i = 0; i < 35; i++)
	{
		TextDrawHideForPlayer(playerid, APPLOCK[i]);
		TextDrawHideForPlayer(playerid, APPLOADING[0]);
		TextDrawHideForPlayer(playerid, APPLOADING[1]);
		TextDrawHideForPlayer(playerid, APPLOADING[2]);
	}

	for(new i = 0; i < 91; i++)
	{
		TextDrawShowForPlayer(playerid, APPLOCK[i]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][0]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][1]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][2]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][3]);
		DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][4], "OPEN");
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][4]);
	}
	isLoaded[playerid] = false;
}
forward ChangeText(playerid);
public ChangeText(playerid)
{
    // You can check if the player is still installing the tweet here, just in case.
    if(PlayerInfo[playerid][pInstallTweet])
    {
        PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][2], 0.170, 0.799);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][2]);
        DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][2], "OPEN");
    }
    if(PlayerInfo[playerid][pInstallValley])
    {
        PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][0], 0.170, 0.799);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][0]);
        DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][0], "OPEN");
    }
    if(PlayerInfo[playerid][pInstallTaxi])
    {
        PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][1], 0.170, 0.799);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][1]);
        DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][1], "OPEN");
    }
    if(PlayerInfo[playerid][pInstallInsta])
    {
        PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][3], 0.170, 0.799);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
		PlayerTextDrawShow(playerid, APPLOCKGET[playerid][3]);
        DynamicPlayerTextDrawSetString(playerid, APPLOCKGET[playerid][3], "OPEN");
    }
    return 1;
}
public OnClickDynamicTextDraw(playerid, Text:clickedid)
{
	if(clickedid == PHONELOCK[40])
	{
        for(new i = 0; i < 42; i++) {
		TextDrawHideForPlayer(playerid, PHONELOCK[i]);
		}
        for(new i = 0; i < 109; i++) {
		TextDrawShowForPlayer(playerid, PHONE[i]);

		}
		ITwitter(playerid);
		IValley(playerid);
		ITaxi(playerid);
		IInsta(playerid);

        SelectTextDraw(playerid,0x33AA33AA);
	}
	if(clickedid == PHONELOCK[41])
	{
	    for(new i = 0; i < 42; i++) {
		TextDrawHideForPlayer(playerid, PHONELOCK[i]);
		}
		return callcmd::Phonehide(playerid);
    }
   	if(clickedid == PHONE[36])
	{
	    ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Sms", "Cancel");
    }
   	if(clickedid == PHONE[35])
	{
	    callcmd::selfienaju(playerid);
    }
   	if(clickedid == PHONE[38])
	{
        ShowPlayerDialog(playerid, DIALOG_MP3URL2, DIALOG_STYLE_INPUT, "Youtube URL", "Please enter the URL of the Youtube you want to play:", "Submit", "Back");
    }
    if(clickedid == PHONE[37])
    {
      ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
	}
	if(clickedid == PHONE[94])
	{
	  ListContacts(playerid);
	}
	if(clickedid == PHONE[40])
	{
		if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	    {
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	    }
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, world, impounded FROM vehicles WHERE ownerid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii",THREAD_VALET_CARS, playerid);
	}
	if(clickedid == PHONE[71])
	{
		ShowDialogToPlayer(playerid, DIALOG_LOCATE);
	}
	if(clickedid == PHONE[45])
	{
        for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}

		for(new i = 0; i < 50; i++)
        {
			TextDrawShowForPlayer(playerid, INSTA[i]);
			SelectTextDraw(playerid,0x33AA33AA);
		}

	}
	if(clickedid == INSTA[35])
	{

		for(new i = 0; i < 50; i++)
        {
			TextDrawHideForPlayer(playerid, INSTA[i]);
		}
        for(new i = 0; i < 109; i++)
        {
			TextDrawShowForPlayer(playerid, PHONE[i]);
			ITwitter(playerid);
            IValley(playerid);
            ITaxi(playerid);
            IInsta(playerid);
		}

	}
	if(clickedid == INSTA[47]) {

		ShowPlayerDialog(playerid, DIALOG_INSTA, DIALOG_STYLE_INPUT, "Instagram", "What's on your mind?", "Post", "Back");
	}
	if(clickedid == PHONE[46]) {

		ShowPlayerDialog(playerid, DIALOG_TWEET, DIALOG_STYLE_INPUT, "Tweet", "What's on your mind?", "Post", "Back");
	}
	if(clickedid == PHONE[41]) {

		SendClientMessage(playerid, COLOR_RED, "App server crashed! shutting phone");
		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
	}
	if(clickedid == PHONE[39]) {

		SendClientMessage(playerid, COLOR_RED, "App crashed with exitcode 0x00fsa11! shutting phone");
		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
	}
	if(clickedid == PHONE[91]) {

		SendClientMessage(playerid, COLOR_RED, "Setting not responding! shuting Phone");
		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
	}
	if(clickedid == PHONE[95]) {
 		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == PHONE[43]) {
		SendClientMessage(playerid, COLOR_AQUA,"We focus solely on non-stealable items, Made By AKRP_TEAM ");
	}
	if(clickedid == PHONE[93] && !isLoaded[playerid])
    {
 		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
		for(new i = 0; i < 35; i++)
        {
			TextDrawShowForPlayer(playerid, APPLOCK[i]);
			TextDrawShowForPlayer(playerid, APPLOADING[0]);
			TextDrawShowForPlayer(playerid, APPLOADING[1]);
			TextDrawShowForPlayer(playerid, APPLOADING[2]);
		}
		SetTimerEx("load", 4000, false, "i", playerid);
        isLoaded[playerid] = true; // Set the flag to indicate that the load operation has been scheduled
	}
	if(clickedid == PHONE[92])
    {
 		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
		for(new i = 0; i < 35; i++)
        {
			TextDrawShowForPlayer(playerid, APPLOCK[i]);
		}
		for(new i = 0; i < 38; i++)
        {
			TextDrawShowForPlayer(playerid, DIALER[i]);
			PlayerTextDrawShow(playerid, DIALERP[playerid]);
		}

	}
	if(clickedid == PHONE[44])
    {
 		for(new i = 0; i < 109; i++)
        {
			TextDrawHideForPlayer(playerid, PHONE[i]);
		}
        for(new i = 0; i < 79; i++)
        {
			TextDrawShowForPlayer(playerid, CAL[i]);
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			PlayerTextDrawShow(playerid, CALP[playerid][0]);
			PlayerTextDrawShow(playerid, CALP[playerid][2]);

		}
		SendClientMessage(playerid, COLOR_YELLOW, "Please use AC button after each calculation. We'll fix bugs soon. Thank you for your understanding.");

	}

	if(clickedid == CAL[55])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "0");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "0");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "0");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "0");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[47])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "1");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "1");
			DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "1");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "1");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[48])
	{
	    if(calculation_result[playerid] == 0)
	    {
	    	strcat(numberc[playerid], "2");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "2");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "2");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid],"2");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[49])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "3");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "3");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "3");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "3");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[43])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "4");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "4");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
   		}
		else
		{
            strcat(anumberc[playerid], "4");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "4");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);

		}
	}
	if(clickedid == CAL[44])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "5");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "5");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "5");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "5");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[45])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "6");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "6");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "6");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "6");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[39])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "7");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "7");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);

		}
		else
		{
            strcat(anumberc[playerid], "7");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "7");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);

		}
	}
	if(clickedid == CAL[40])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "8");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "8");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "8");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "8");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);

		}
	}
	if(clickedid == CAL[41])
	{
	    if(calculation_result[playerid] == 0)
	    {
			strcat(numberc[playerid], "9");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
  			strcat(calculation_string[playerid], "9");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
		else
		{
            strcat(anumberc[playerid], "9");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "9");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[50])
	{
		if(calculation_result[playerid] == 0)
		{
			calculation_result[playerid] = 1;
			strcat(calculation[playerid], "+");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "+");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == INVALID_TEXT_DRAW)
	{
	  	Inventory_Close(playerid);
	}
	if(clickedid == CAL[46])
	{
		if(calculation_result[playerid] == 0)
		{
			calculation_result[playerid] = 2;
			strcat(calculation[playerid], "-");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "-");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[42])
	{
		if(calculation_result[playerid] == 0)
		{
			calculation_result[playerid] = 3;
			strcat(calculation[playerid], "x");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], "x");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);

		}
	}
	if(clickedid == CAL[38])
	{
		if(calculation_result[playerid] == 0)
		{
			calculation_result[playerid] = 4;
			strcat(calculation[playerid], ":");
			PlayerTextDrawShow(playerid, CALP[playerid][1]);
			strcat(calculation_string[playerid], ":");
            DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], calculation_string[playerid]);
		}
	}
	if(clickedid == CAL[52])
	{
	    new string[128];
		if(calculation_result[playerid] >= 1)
		{
			if(calculation_result[playerid] == 1)
			{
				resultq[playerid] = strval(numberc[playerid]) + strval(anumberc[playerid]);
				PlayerTextDrawShow(playerid, CALP[playerid][1]);
				format(string, 128, "%d", resultq[playerid]);
                DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], string);
			}
			if(calculation_result[playerid] == 2)
			{
				resultq[playerid] = strval(numberc[playerid]) - strval(anumberc[playerid]);
				PlayerTextDrawShow(playerid, CALP[playerid][1]);
				format(string, 128, "%d", resultq[playerid]);
                DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], string);
			}
			if(calculation_result[playerid] == 3)
			{
				resultq[playerid] = strval(numberc[playerid]) * strval(anumberc[playerid]);
				PlayerTextDrawShow(playerid, CALP[playerid][1]);
				format(string, 128, "%d", resultq[playerid]);
                DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], string);
			}
			if(calculation_result[playerid] == 4)
			{
				resultq[playerid] = strval(numberc[playerid]) / strval(anumberc[playerid]);
				PlayerTextDrawShow(playerid, CALP[playerid][1]);
				format(string, 128, "%d", resultq[playerid]);
                DynamicPlayerTextDrawSetString(playerid, CALP[playerid][1], string);
			}

		}
	}
	if(clickedid == CAL[35])
	{
		for(new i = 0; i < 79; i++)
        {
			TextDrawHideForPlayer(playerid, CAL[i]);
			PlayerTextDrawHide(playerid, CALP[playerid][0]);
			PlayerTextDrawHide(playerid, CALP[playerid][1]);
			PlayerTextDrawHide(playerid, CALP[playerid][2]);

		}
		for(new i = 0; i < 109; i++)
        {
			TextDrawShowForPlayer(playerid, PHONE[i]);
			ITwitter(playerid);
            IValley(playerid);
            ITaxi(playerid);
            IInsta(playerid);
		}
	}
    if(clickedid == DIALER[37])
    {

        for(new i = 0; i < 38; i++)
        {
			TextDrawHideForPlayer(playerid, DIALER[i]);
			PlayerTextDrawHide(playerid, DIALERP[playerid]);
		}
		for(new i = 0; i < 35; i++)
        {
			TextDrawHideForPlayer(playerid, APPLOCK[i]);
		}
	    for(new i = 0; i < 109; i++)
        {
			TextDrawShowForPlayer(playerid, PHONE[i]);
			ITwitter(playerid);
            IValley(playerid);
            ITaxi(playerid);
            IInsta(playerid);
		}

	}
	if(clickedid == APPLOCK[66])
    {
        if(PlayerInfo[playerid][pInstallTweet])
        {
           for(new i = 0; i < 91; i++)
           {
				TextDrawHideForPlayer(playerid, APPLOCK[i]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
		   }
		   for(new i = 0; i < 109; i++) {
				TextDrawShowForPlayer(playerid, PHONE[i]);
				ITwitter(playerid);
				IValley(playerid);
				ITaxi(playerid);
				IInsta(playerid);
		   }
        }
        else{
 		DownloadTweet(playerid);
	  }
	}
	if(clickedid == APPLOCK[49])
    {
        if(PlayerInfo[playerid][pInstallValley])
        {
           for(new i = 0; i < 91; i++)
           {
				TextDrawHideForPlayer(playerid, APPLOCK[i]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
		   }
		   for(new i = 0; i < 109; i++) {
				TextDrawShowForPlayer(playerid, PHONE[i]);
				ITwitter(playerid);
				IValley(playerid);
				ITaxi(playerid);
				IInsta(playerid);
		   }
        }
        else{
 			DownloadValley(playerid);
	  }
	}
	if(clickedid == APPLOCK[61])
    {
        if(PlayerInfo[playerid][pInstallTaxi])
        {
           for(new i = 0; i < 91; i++)
           {
				TextDrawHideForPlayer(playerid, APPLOCK[i]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
		   }
		   for(new i = 0; i < 109; i++) {
				TextDrawShowForPlayer(playerid, PHONE[i]);
				ITwitter(playerid);
				IValley(playerid);
				ITaxi(playerid);
				IInsta(playerid);
		   }
        }
        else{
 			DownloadTaxi(playerid);
	  }
	}
	if(clickedid == APPLOCK[75])
    {
        if(PlayerInfo[playerid][pInstallInsta])
        {
           for(new i = 0; i < 91; i++)
           {
				TextDrawHideForPlayer(playerid, APPLOCK[i]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
		   }
		   for(new i = 0; i < 109; i++) {
				TextDrawShowForPlayer(playerid, PHONE[i]);
				ITwitter(playerid);
				IValley(playerid);
				ITaxi(playerid);
				IInsta(playerid);
		   }
        }
        else{
 			DownloadInsta(playerid);
	  }
	}
	if(clickedid == APPLOCK[84])
    {

           for(new i = 0; i < 91; i++)
           {
				TextDrawHideForPlayer(playerid, APPLOCK[i]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
				PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);
		   }
		   for(new i = 0; i < 109; i++) {
				TextDrawShowForPlayer(playerid, PHONE[i]);
				ITwitter(playerid);
				IValley(playerid);
				ITaxi(playerid);
				IInsta(playerid);
		   }
	}
	if(clickedid == APPLOCK[88])
	{
        for(new i = 0; i < 91; i++) {
		TextDrawHideForPlayer(playerid, APPLOCK[i]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][2]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][0]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][1]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][3]);
		PlayerTextDrawHide(playerid, APPLOCKGET[playerid][4]);

		}
        for(new i = 0; i < 109; i++) {
		   TextDrawShowForPlayer(playerid, PHONE[i]);
		}
		IValley(playerid);
		ITwitter(playerid);
		ITaxi(playerid);
		IInsta(playerid);
        SelectTextDraw(playerid,0x33AA33AA);
	}
	if(clickedid == DIALER[1])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "1");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[2])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "2");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[3])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "3");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[4])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "4");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[5])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "5");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[6])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "6");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[7])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "7");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[8])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "8");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[9])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "9");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[10])
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	    strcat(called[playerid], "0");
	    DynamicPlayerTextDrawSetString(playerid, DIALERP[playerid], called[playerid]);
	}
	if(clickedid == DIALER[11]) //Delete
	{
	    PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
        new size = strlen(called[playerid]);
	    if(size == 1) strdel(called[playerid],0,1),DynamicPlayerTextDrawSetString(playerid,DIALERP[playerid],"_");
	    else strdel(called[playerid],size-1,size), DynamicPlayerTextDrawSetString(playerid,DIALERP[playerid],called[playerid]);
	}
	if(clickedid == DIALER[35]) //Call
	{
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

   	    new number = strval(called[playerid]);

		if(number < 1)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid Number");
		}

		if(PlayerInfo[playerid][pSIM] == SIM_NONE)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a SIM card.");
		}
		if(PlayerInfo[playerid][pLoad] <= 0 || PlayerInfo[playerid][pLoadExpiry] < gettime())
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough load or your load has expired.");
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

		if(number == 911)
		{
			PlayerInfo[playerid][pCallLine] = playerid;
			PlayerInfo[playerid][pCallStage] = 911;

			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_DISPATCH, "911, what is your emergency? Enter 'police' or 'medic'.");
			return 1;
		}
		else if(number == 6397)
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

				PlayerInfo[playerid][pLoad] -= 1;
				SM(playerid, COLOR_YELLOW, "** You now have %i Calls Left", PlayerInfo[playerid][pLoad]);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET load = %i WHERE uid = %i", PlayerInfo[playerid][pLoad], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);


				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
				SendProximityMessage(i, 20.0, SERVER_COLOR, "**{C2A2DA} %s's mobile phone begins to ring.", GetRPName(i));

				SM(playerid, COLOR_YELLOW, "** You've placed a call to number: %i. Please wait for your call to be answered.", number);
				SM(i, COLOR_YELLOW, "** Incoming call from #%i. Use /pickup to take this call.", PlayerInfo[playerid][pPhone]);
				return 1;
			}
			SendClientMessage(playerid, COLOR_SYNTAX, "Error:"WHITE" That number is either not in service or the owner is offline.");
		}
    }
    if(clickedid == Text:INVALID_TEXT_DRAW && !PlayerInfo[playerid][pLogged])
	{
		SelectTextDraw(playerid, COLOR_LIGHTBLUE);
	}
	
	return 0;
}




public Animator_OnFinish(playerid, animator, type)
{
	
    if (animator == killeffect[playerid]) 
    {
        PlayerTextDrawBoxColour(playerid, BLINK[playerid][0], -206);
        PlayerTextDrawHide(playerid, BLINK[playerid][0]);
        killeffect[playerid] = -1;
		
    }
    if (animator == pepper[playerid]) 
    {		
        PlayerTextDrawBoxColour(playerid, BLACK[playerid][0], 255);
        PlayerTextDrawHide(playerid, BLACK[playerid][0]);
        pepper[playerid] = -1; 
		
    }

}
forward delayadd(playerid, type);
public delayadd(playerid, type)
{
    switch(type)
	{	
		case 1 :
		{
			pepper[playerid] = PlayerText_InterpolateBoxColor(playerid, BLACK[playerid][0], 0xFFFFFF00, 1000, EASE_OUT_SINE);
		    SetTimerEx("Hide", 1003, false, "ii", playerid, 3);
		}
	}	

}
forward Hide(playerid, type);
public Hide(playerid, type)
{
    switch(type)
	{
		case 1 :
		{
			PlayerTextDrawBoxColour(playerid, BLINK[playerid][0], -206);
			PlayerTextDrawHide(playerid, BLINK[playerid][0]);
		}
		case 2 :
		{
			PlayerTextDrawHide(playerid, KILLFEED[playerid][0]);
		}
        case 3:
		{
		    PlayerTextDrawBoxColour(playerid, BLACK[playerid][0], 255);
			PlayerTextDrawHide(playerid, BLACK[playerid][0]);
		}
	
	}	

}
