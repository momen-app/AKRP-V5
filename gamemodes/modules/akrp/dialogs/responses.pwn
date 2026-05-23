public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(PlayerInfo[playerid][pKicked]) return 0;


	// This is a fix to a known exploit where inserting '%' in the dialog box would crash the server.
	for(new i = 0, l = strlen(inputtext); i < l; i ++)
	{
	    if(inputtext[i] == '%') inputtext[i] = '#';
	}

	if(AsyncDialog_OnResponse(playerid, dialogid, response, listitem, inputtext))
	{
		return 1;
	}

	if(dialogid == DIALOG_VALETSTORAGE)
    {
       if(response)
       {
		  if(listitem != -1)
		  {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerInfo[playerid][pID], listitem);
                mysql_tquery(connectionID, queryBuffer, "OnPlayerUseValetStorage", "i", playerid);	  
		  }
          
       }
	   return 1;
    }
	if(dialogid == INVENTORY_PICKUP)
	{
		if(response)
		{
			new itemid = NearestItems[playerid][listitem];
			PickupItem(playerid, itemid);
		}
	}
	if(dialogid == LOAD_DIALOG)
    {
        if(response)
        {
		    new businessid = GetNearbyBusinessEx(playerid);
            new loadCost, loadAmount, loadDuration;
            switch(listitem)
            {
                case 0: // 20 Load - 2 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][3];
                    loadAmount = 20;
                    loadDuration = 2;
                }
                case 1: // 30 Load - 4 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][4];
                    loadAmount = 30;
                    loadDuration = 4;
                }
                case 2: // 40 Load - 6 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][5];
                    loadAmount = 40;
                    loadDuration = 6;
                }
                case 3: // 50 Load - 8 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][6];
                    loadAmount = 50;
                    loadDuration = 8;
                }
                case 4: // 80 Load - 9 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][7];
                    loadAmount = 80;
                    loadDuration = 9;
                }
                case 5: // 100 Load - 10 Days
                {
                    loadCost = BusinessInfo[businessid][bPrices][8];
                    loadAmount = 100;
                    loadDuration = 10;
                }
            }

            if(PlayerInfo[playerid][pCash]  >= loadCost)
            {
                PlayerInfo[playerid][pLoad] = loadAmount;
                PlayerInfo[playerid][pLoadExpiry] = gettime() + (loadDuration * 24 * 60 * 60);
                GivePlayerMoney(playerid, -loadCost);
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET `load` = %i , `loadtime` = %i , `sim` = %i WHERE uid = %i", PlayerInfo[playerid][pLoad] , PlayerInfo[playerid][pLoadExpiry] , PlayerInfo[playerid][pSIM] , PlayerInfo[playerid][pID]);
		        mysql_tquery(connectionID, queryBuffer);
                SCMf(playerid, COLOR_GREEN, "You have bought %d calls for %d days for %d. You can now make calls.", loadAmount, loadDuration, loadCost);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy this pack.");
            }
        }
        return 1;
    }
	if(dialogid == DIALOG_RADIOCHAT)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(PlayerInfo[playerid][pFaction] == -1)
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not apart of any faction.");
				}
				if(PlayerInfo[playerid][pFactionRadio] == 0)
				{
					PlayerInfo[playerid][pFactionRadio] = 1;
					
					CallRemoteFunction("JoinFgVoiceChannel", "iii", PlayerInfo[playerid][pFaction], playerid, 1);
					callcmd::radiochat(playerid);
					SetPVarInt(playerid,"radiostat",1);
					SM(playerid, COLOR_GREY, "Succesfuly connected to %s radio channel.", FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
				}
				else if(PlayerInfo[playerid][pFactionRadio] == 1)
				{
					PlayerInfo[playerid][pFactionRadio] = 0;
					CallRemoteFunction("LeaveFgVoiceChannel", "ii", playerid, 1);
					callcmd::radiochat(playerid);
					SetPVarInt(playerid,"radiostat",0);
					SM(playerid, COLOR_GREY, "You have disconnected on %s radio channel.", FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
				}
			}
			if(listitem == 1)
			{
				if(PlayerInfo[playerid][pGang] == -1)
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of any gang at the moment.");
				}
				if(PlayerInfo[playerid][pGangRadio] == 0)
				{
					PlayerInfo[playerid][pGangRadio] = 1;
					CallRemoteFunction("JoinFgVoiceChannel", "iii", PlayerInfo[playerid][pGang] , playerid, 0);
					callcmd::radiochat(playerid);
					SetPVarInt(playerid,"radiostat",2);
					SM(playerid, COLOR_GREY, "Succesfuly connected to %s radio channel.", GangInfo[PlayerInfo[playerid][pGang]][gName]);
				}
				else if(PlayerInfo[playerid][pGangRadio] == 1)
				{
					PlayerInfo[playerid][pGangRadio] = 0;
					CallRemoteFunction("LeaveFgVoiceChannel", "ii", playerid, 0);
					callcmd::radiochat(playerid);
					SetPVarInt(playerid,"radiostat",0);
					SM(playerid, COLOR_GREY, "You have disconnected on %s radio channel.", GangInfo[PlayerInfo[playerid][pGang]][gName]);
				}
			}
		}
	}
	if(dialogid == DIALOG_RADIO)
	{
		if(response)
		{
			if(listitem == 0)
			{
				
				if(PlayerInfo[playerid][pRadioUse] == 0)
				{
					PlayerInfo[playerid][pRadioUse] = 1;
					
					SetPVarInt(playerid,"talkstats",3);
					SM(playerid, COLOR_GREY, "Succesfuly connected to Public radio channel. /frequency or /fq");
				}
				else 
				{
					PlayerInfo[playerid][pRadioUse] = 0;
				    SetPVarInt(playerid,"talkstats",0);
					CallRemoteFunction("LeaveGroupVoiceChannel", "i", playerid);
                    isUsingRadioVoip[playerid] = false;
					SM(playerid, COLOR_GREY, "You have disconnected on public radio channel.");
				}
			}

		}
	}
   	if(dialogid == CorpseInfo)
	{
		if (!response)	return 1;

	    new dlg[90], i = GetNearestCorpse(playerid);

	    switch(CorpInfo[i][cType]) {
	        case 0: {//??????? = 0
	            dlg="Drag into vehicle\nPut in a bag\nBury";
	        }
	        case 1: { //???????
	            dlg="Remove the corpse from the wheelchair";
	        }
	        case 2: { //????? ?????
	            dlg="Drag into vehicle\nGet the corpse out of the bag";
	        }
	        case 3:{ //??????????
	            dlg="Unearth a corpse";
	        }
	    }

	    if (!CorpInfo[i][cType] && PlayerInfo[playerid][pDuty] == 1 && (GetFactionType(playerid) == FACTION_MEDIC))
	        strcat(dlg,"\nPut on a gurney");

	    if (PlayerInfo[playerid][pAdmin] || (PlayerInfo[playerid][pDuty] == 1 && (GetFactionType(playerid) == FACTION_MEDIC)))
	        strcat(dlg,"\nRemove corpse object");

	    ShowPlayerDialog(playerid, CorpseInfo2, DIALOG_STYLE_LIST, "Dead body", dlg, "Select", "Return");
	    return 1;
	}
	if(dialogid == CorpseInfo2)
	{
		if (!response)	return callcmd::corpse(playerid);

	    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
		}

	    if(!PlayerInfo[playerid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are not logged in yet.");
		}

		new i = GetNearestCorpse(playerid);

	    switch(listitem) {
	        case 0: {
	            switch(CorpInfo[i][cType]) {
	                case 0: listitem=0;
	                case 1: listitem=1;
	                case 2: listitem=0;
	                case 3: listitem=2;
	            }
	        }
	        case 1: {
	            switch(CorpInfo[i][cType]) {
	                case 0: listitem=5;
	                case 1: listitem=7;
	                case 2: listitem=2;
	                case 3: listitem=7;
	            }
	        }
	        case 2: {
	            switch(CorpInfo[i][cType]) {
	                case 0: listitem=6;
	                case 2: listitem=7;
	            }
	        }
	        case 3: listitem=4;
	        case 4: listitem=7;
	    }

	    switch(listitem)
	    {
	        case 0:
	        {
	            new vehicle = GetNearbyVehicle(playerid);
	            if (vehicle == -1)                         return SendClientMessage(playerid, COLOR_GRAD1, "You are not near vehicle.");
	            if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk! ");
	            new engine, lights, alarm, doors, bonnet, boot, objective;
		        GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

		        if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
		        {
		            SendClientMessageEx(playerid, COLOR_GRAD2, "The vehicle's trunk must be opened to load corpse.");
		            return 1;
		        }

	            if (VehicleInfo[vehicle][vCorp] > 0 && CorpInfo[VehicleInfo[vehicle][vCorp]][cUsed] == 1)
	                return SendClientMessage(playerid, COLOR_GRAD1, "There is already a corpse in the trunk!");

	            new mes[128];
	            format(mes, sizeof(mes), "drags a corpse %s in the trunk.", CorpInfo[i][cName]);
	            callcmd::me(playerid, mes);

	            SendClientMessage(playerid, COLOR_GRAD1, "You put your body in the trunk. (( /car corpse - to pull out ))");

	            CorpInfo[i][cTime] = gettime();
	            CorpInfo[i][cVeh]=vehicle;
	            VehicleInfo[vehicle][vCorp]=i+1;

	            CorpInfo[i][cX] =
	            CorpInfo[i][cY] =
	            CorpInfo[i][cZ] = 0.0;


	            DestroyDynamic3DTextLabel(CorpInfo[i][cText]);
	            if (!CorpInfo[i][cType] && IsValidActor(CorpInfo[i][cBody])) DestroyActor(CorpInfo[i][cBody]);
	            else if (CorpInfo[i][cType] && IsValidDynamicObject(CorpInfo[i][cBody])) DestroyDynamicObject(CorpInfo[i][cBody]);
	        }
	        case 1: {
	            new Float:x, Float:y, Float:z;
	            GetPlayerPos(playerid, x, y, z);

	            CorpInfo[i][cType] = 0;
	            CorpInfo[i][cX] = x+0.75;
	            CorpInfo[i][cY] = y;
	            CorpInfo[i][cZ] = z-0.5;
	            CorpInfo[i][cTime] = gettime();

	            CorpInfo[i][cText]=CreateDynamic3DTextLabel("(( DEAD BODY ))\npress '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);

	            pTemp[playerid][UsingCorpse] = 0;

	            SetActorPos(CorpInfo[i][cBody], CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]);
	            SendClientMessage(playerid, COLOR_GRAD1, "You removed the body from the wheelchair.");
	        }
	        case 2: {
	            if (IsValidDynamicObject(CorpInfo[i][cBody]))        DestroyDynamicObject(CorpInfo[i][cBody]);
	            if (IsValidDynamic3DTextLabel(CorpInfo[i][cText]))   DestroyDynamic3DTextLabel(CorpInfo[i][cText]);

	            new Float:x, Float:y, Float:z;
	            GetPlayerPos(playerid, x, y, z);

	            CorpInfo[i][cType] = 0;
	            CorpInfo[i][cX] = x+0.75;
	            CorpInfo[i][cY] = y;
	            CorpInfo[i][cZ] = z-0.5;
	            CorpInfo[i][cTime] = gettime();

	            CorpInfo[i][cBody]=CreateActor(CorpInfo[i][cSkin], x+0.75-0.5, y, z, 0.0);
	            SetActorInvulnerable(CorpInfo[i][cBody], true);
	            ApplyActorAnimation(CorpInfo[i][cBody], "PED", "KO_shot_stom", 4.0, false, false, false, true, false);

	            CorpInfo[i][cText]=CreateDynamic3DTextLabel("(( DEAD BODY ))\npress '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);

	            if (CorpInfo[i][cType] == 3) SendClientMessage(playerid, COLOR_GRAD1, "You have unearthed the body.");
	            else                        SendClientMessage(playerid, COLOR_GRAD1, "You got the body out of the bag.");
	        }
	        case 4:
	        {
	            if (!pTemp[playerid][UsingBort])  return SendClientMessage(playerid, COLOR_GRAD1, "Take the wheelchair first! (/stretcher)");
	            if (pTemp[playerid][UsingCorpse]) return SendClientMessage(playerid, COLOR_GRAD1, "You already have a body on a gurney!");

	            if (IsValidDynamic3DTextLabel(CorpInfo[i][cText]))   DestroyDynamic3DTextLabel(CorpInfo[i][cText]);

	            pTemp[playerid][UsingCorpse] = i;
	            CorpInfo[i][cType] = 1;

	            SendClientMessage(playerid, COLOR_GRAD1, "You put the body on a wheelchair.");
	        }
	        case 5:
	        {
	            if (PlayerInfo[playerid][pBodyBag] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You don't have a body bag.");

	            new Float:posZs;
	            GetActorFacingAngle(CorpInfo[i][cBody], posZs);

	            if (IsValidActor(CorpInfo[i][cBody]))  DestroyActor(CorpInfo[i][cBody]);

	            SetPVarInt(playerid, #CorpsEdit, i+1);

	            CorpInfo[i][cType] = 2;
	            CorpInfo[i][cBody]=CreateDynamicObject(19944, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 0.0, 0.0, posZs, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

	            EditDynamicObject(playerid, CorpInfo[i][cBody]);

	            SM(playerid, COLOR_GRAD1, "You put the body in a bag. [ID:%i]", i);
				new mes[128];
	            format(mes, sizeof(mes), "packs the body in a bag.");
	            callcmd::me(playerid, mes);
	        }
	        case 6:
	        {
	            if (GetPlayerVirtualWorld(playerid) || GetPlayerInterior(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot bury a body here!");
	            new weaponid = GetScriptWeapon(playerid);
	            if(weaponid != 6) return SendClientMessage(playerid, COLOR_GRAD1, "The shovel should be in hand!");

	            new Float:posZs;
	            GetActorFacingAngle(CorpInfo[i][cBody], posZs);

	            if (IsValidActor(CorpInfo[i][cBody]))  DestroyActor(CorpInfo[i][cBody]);
	            if (IsValidDynamicObject(CorpInfo[i][cBody]))  DestroyDynamicObject(CorpInfo[i][cBody]);

	            SetPVarInt(playerid, #CorpsEdit, i+1);

	            CorpInfo[i][cType] = 3;
	            CorpInfo[i][cBody]=CreateDynamicObject(19944 , CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 0.0, 0.0, posZs, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	            SetObjectMaterial(CorpInfo[i][cBody], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);

	            EditDynamicObject(playerid, CorpInfo[i][cBody]);

	            SM(playerid, COLOR_GRAD1, "You buried the corpse. [ID:%i]", i);
				new mes[128];
	            format(mes, sizeof(mes), "buries the corpse.");
	            callcmd::me(playerid, mes);
	        }
	        case 7:
	        {
	            SM(playerid, COLOR_GRAD1, "You have deleted the corpse object. [ID:%i]", i);
	            RemoveCorpse(i);
	            return 1;
	        }
	    }
	}
	if(dialogid == DIALOG_AMOUNT)
	{
		if (response)
		{
			new str[125];

			PlayerInfo[playerid][pGiveAmount] = strval(inputtext);
			format(str, sizeof(str), "%d", strval(inputtext));
			DynamicPlayerTextDrawSetString(playerid, INVINFO[playerid][6], str);
		}
	}
	if(dialogid == ANTICHEAT_SETTINGS)
	{
		if(!response)
	    {
	        pAntiCheatSettingsPage{playerid} = 0;
	        return 1; // Закрываем диалог
	    }

	    if (!strcmp(inputtext, AC_DIALOG_NEXT_PAGE_TEXT))
	    {
	        pAntiCheatSettingsPage{playerid}++;
	    }
	    else if (!strcmp(inputtext, AC_DIALOG_PREVIOUS_PAGE_TEXT))
	    {
	        pAntiCheatSettingsPage{playerid}--;
	    }
	    else // Если игрко выбрал какой-либо из кодов анти-чита
	    {
	        pAntiCheatSettingsEditCodeId[playerid] = pAntiCheatSettingsMenuListData[playerid][listitem];
	        return ShowPlayer_AntiCheatEditCode(playerid, pAntiCheatSettingsEditCodeId[playerid]);
	    }
	    return ShowPlayer_AntiCheatSettings(playerid);
	}
	if(dialogid == ANTICHEAT_EDIT_CODE)
	{
		if (!response) // Если игрок закрыл диалог
	    {
	        pAntiCheatSettingsEditCodeId[playerid] = -1;
	        return ShowPlayer_AntiCheatSettings(playerid);
	    }

	    new
	        item = pAntiCheatSettingsEditCodeId[playerid];

	    if (AC_CODE_TRIGGER_TYPE[item] == listitem)
	        return ShowPlayer_AntiCheatSettings(playerid);

	    if (AC_CODE_TRIGGER_TYPE[item] == AC_CODE_TRIGGER_TYPE_DISABLED && listitem != AC_CODE_TRIGGER_TYPE_DISABLED)
	        EnableAntiCheat(item, 1);

	    AC_CODE_TRIGGER_TYPE[item] = listitem;

	    new
	        sql_query[101 - 4 + 1 + 2];

	    format(sql_query, sizeof(sql_query), "UPDATE "AC_TABLE_SETTINGS" SET `"AC_TABLE_FIELD_TRIGGER"` = '%d' WHERE `"AC_TABLE_FIELD_CODE"` = '%d'",
	        listitem,
	        item);

	    mysql_tquery(connectionID, sql_query); // async update
	    return ShowPlayer_AntiCheatSettings(playerid); // Показываем главное меню настроек анти-чита
	}
 	if(dialogid == DIALOG_GIVE)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = PlayerInfo[playerid][pSelectItem];
			new value = PlayerInfo[playerid][pGiveAmount];
			
            if (strlen(InventoryData[playerid][itemid][invItem]) == 0)
            {
               printf("Error: InventoryData for playerid (%d) and itemid (%d) is an empty string", playerid, itemid);
               return 0; 
            }

			
            OnPlayerGiveInvItem(playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	if(dialogid == DIALOG_METH_QUESTION_1)
	{
		if(response)
		{
			if(listitem == 0)
			{
				PlayerInfo[playerid][pMethScore] ++;
 			}
	 		GameTextForPlayer(playerid, "~g~COOKING", 1000, 5);
		}
	}
	if(dialogid == DIALOG_METH_QUESTION_2)
	{
		if(response)
		{
			if(listitem == 1)
			{
				PlayerInfo[playerid][pMethScore] ++;
  			}
	  		GameTextForPlayer(playerid, "~g~COOKING", 1000, 5);
		}
	}
	if(dialogid == DIALOG_METH_QUESTION_3)
	{
		if(response)
		{
		    GameTextForPlayer(playerid, "~g~COOKING", 1000, 5);
			if(listitem == 2)
			{
				PlayerInfo[playerid][pMethScore] ++;
			}
		}
	}
	if(dialogid == DIALOG_METH_QUESTION_4)
	{
		if(response)
		{
		    GameTextForPlayer(playerid, "~y~Nice Color", 1000, 5);
			if(listitem == 2)
			{
				PlayerInfo[playerid][pMethScore] ++;
			}
		}
	}
	if(dialogid == DIALOG_METH_QUESTION_5)//final question
	{
		if(response)
		{
			new
			Float:x,
			Float:y,
			Float:z;

			GetPlayerPos(playerid, x, y, z);
			if(listitem == 0) // 0
			{
				PlayerInfo[playerid][pMethScore] ++;
				DestroyDynamicObject(methveh);
                methveh = INVALID_OBJECT_ID;
				if(PlayerInfo[playerid][pMethScore] >= 3)
				{
                    GameTextForPlayer(playerid, "~b~Cooked", 1000, 5);
					PlayerInfo[playerid][pMeth] += 8;
                    PlayerInfo[playerid][pCooking] = 0;
					PlayerInfo[playerid][pMethScore] = 0;
				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);
				}
				if(PlayerInfo[playerid][pMethScore])
				{
                    GameTextForPlayer(playerid, "~r~COOKER EXPLODED", 1000, 5);
                    PlayerInfo[playerid][pCooking] = 0;
                    CreateExplosion(x, y, z, 6, 6.0);
				}
	   	     }
		}
	}
    if(dialogid == DIALOG_VERIFICATION)
	{
		new string[900];
		if(response)
		{
			switch(listitem)
			{
				case 0: return 1; // Name
				case 2:
				{
					if(PlayerInfo[playerid][pVerified])
					{
						SetPVarInt(playerid, "Unverification", 1);
						format(string, sizeof(string), "Welcome to "SERVER_NAME" %s,\nDo you want to be unverified?\nYou will not be able to view some channels such as:\n> Global Chatroom\n> Report System\n> Newbie Chatroom\n.", GetRPName(playerid), PlayerInfo[playerid][pCode]);
						return ShowPlayerDialog(playerid, DIALOG_VERIFICATION1, DIALOG_STYLE_MSGBOX, "Account Verification", string, "Okay", "");
					}
					else
					{
						//SetTimerEx("Expiration", 300000, true, "i", playerid);
						SetPVarInt(playerid, "Verification", 1);
						SendClientMessage(playerid, COLOR_SYNTAX, "If your code is ''0', please use /verify to have another code.");
						format(string, sizeof(string), "Welcome to "SERVER_NAME" %s,\nYou can verify your account using this code %i.", GetRPName(playerid), PlayerInfo[playerid][pCode]);
						return ShowPlayerDialog(playerid, DIALOG_VERIFICATION1, DIALOG_STYLE_MSGBOX, "Account Verification", string, "Okay", "");
					}
    	 		}
			    case 3:
				{
					callcmd::vc(playerid);
				}
				
   			}
  		}
	}
	if(dialogid == DIALOG_LOGINMUSIC1)
	{
		if(response)
	    {
			new string[255];
			format(string,sizeof(string),"You Have Chosen '%s' as Login Music", inputtext);
			SendClientMessage(playerid, COLOR_BLUE, string);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET loginurl = '%e' WHERE uid = %i", inputtext, PlayerInfo[playerid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
	    }
	}
	if(dialogid == DIALOG_VERIFICATION1)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "Verification") == 1)
			{
				DeletePVar(playerid, "Verification");
				new string[900];
				format(string, sizeof(string), "Name:\t%s\n\
				Discord: %s#%s\n\
				Verification:\t %s\n\
    "WHITE"     \n\
				Stats\n\
   	"WHITE"Toggle Voicechat", GetRPName(playerid), PlayerInfo[playerid][pDiscordName], PlayerInfo[playerid][pDiscordTag], (PlayerInfo[playerid][pVerified]?(""GREEN"Verified"WHITE""):(""RED"Not Verified")));
				ShowPlayerDialog(playerid, DIALOG_VERIFICATION, DIALOG_STYLE_LIST, "Account Verification", string, "Select", "Cancel");
			}
			else if(GetPVarInt(playerid, "Unverification") == 1)
			{
				new string[64];

				// Unlinking Discord Account
				new DCC_Guild:guild = DCC_FindGuildById("911932751115063296"); // Now to get the guild ID //
                new DCC_Role:role = DCC_FindRoleById("911933029264543804"); // Verified Role
                new DCC_Role:role1 = DCC_FindRoleById("911933029910470737"); // Unverified Role
				new DCC_User:user = DCC_FindUserByName(PlayerInfo[playerid][pDiscordName], PlayerInfo[playerid][pDiscordTag]);
				DCC_RemoveGuildMemberRole(guild, user, role);
				DCC_AddGuildMemberRole(guild, user, role1);
				string = "";
				DCC_SetGuildMemberNickname(guild, user, string);
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET discordname = 'None', discordtag = '0000', discordid = '0' WHERE uid = %i", PlayerInfo[playerid][pID]);
            	mysql_tquery(connectionID, queryBuffer);

				// In-Game Unverification
				DeletePVar(playerid, "Unverification");
				PlayerInfo[playerid][pVerified] = 0;
				return SendClientMessage(playerid, COLOR_YELLOW, "You are not Un-Verified. You can verify Yourself again using '/settings'");
			}
		}
	}
	if(dialogid == DIALOG_TYPE_MAIN)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0: // Hoods
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
        	    }
        	    case 1: // Vents
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 2: // Lights
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Exhausts
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
        	    }
				case 4: // Front Bumpers
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 5: // Rear Bumpers
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 6: // Roofs
        	    {
                    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
        	    }
				case 7: // Spoilers
        	    {
				    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
        	    }
				case 8: // Side Skirts
        	    {
				    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
        	    }
				case 9: // Bullbars
        	    {
				    ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
        	    }
				case 10: // Wheels
        	    {
     			    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nDollar\n \nBack", "Apply", "Close");
        	    }
				case 11: // Car Stereo
        	    {
				    ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
        	    }
				case 12: // Hydraulics
        	    {
 				    ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
        	    }
				case 13: // Nitrous Oxide
        	    {
					ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_EXHAUSTS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562)
		            {
		            	AddVehicleComponent(car,1034);
		            	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            	SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565)
					{
					    AddVehicleComponent(car,1046);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559)
					{
					    AddVehicleComponent(car,1065);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561)
					{
					    AddVehicleComponent(car,1064);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560)
					{
					    AddVehicleComponent(car,1028);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)
					{
					    AddVehicleComponent(car,1089);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
	    			}
					}
	  			 	else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562)
			        {
			            AddVehicleComponent(car,1037);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565)
					{
					    AddVehicleComponent(car,1045);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559)
					{
					    AddVehicleComponent(car,1066);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561)
					{
					    AddVehicleComponent(car,1059);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560)
					{
					    AddVehicleComponent(car,1029);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)
					{
					    AddVehicleComponent(car,1092);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1044);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		             	SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1126);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1129);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	                    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1104);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
 						AddVehicleComponent(car,1113);
 						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1136);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					   	SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1043);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1127);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1132);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1105);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1114);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1135);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 4:// Large
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
				}
        	    case 5: // Medium
        	    {
                        if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr350
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 6: // Small
        	    {
                        if(
					pmodelid[playerid] == 436)//previon
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1022);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 7: // Twin
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405 ) // sentinel
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 8: // Upswept
        	    {
                        if(
                    pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1018);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
				case 9: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
        	    }
        	    case 10: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_FBUMPS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
				{
		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1171);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1153);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1160);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1155);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1169);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1166);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1172);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1152);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1173);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1157);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1170);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1165);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
				{
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1174);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1179);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1189);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1182);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1115);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1191);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 536 ||
	            pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 576)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1175);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1185);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1188);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1181);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

				    else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1116);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1190);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
             	ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
			}
		}
	}
	//=========================//=====Advance Mines & Lumberjack========================//===================//
	if(dialogid == DIALOG_TYPE_RBUMPS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1149);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1150);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1159);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1154);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1141);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1168);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1148);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"YComponent successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1151);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1161);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1156);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1140);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1167);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
		        {


              		new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1176);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1180);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1187);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1184);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1109);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1192);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
     }
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1177);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1178);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1186);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1183);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

						else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1110);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

						else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1193);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
            	    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
     				ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_ROOFS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1038);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1054);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1067);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1055);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1032);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1088);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1035);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1053);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1068);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1061);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1033);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1091);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 567) // Savanna
			        {
			            AddVehicleComponent(car,1130);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
	   					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1128);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 567) // Savanna
			        {
			            AddVehicleComponent(car,1131);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
	   					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1103);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                 if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 603 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 436 ||
					pmodelid[playerid] == 580 ||
					pmodelid[playerid] == 550||
					pmodelid[playerid] == 477)
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
        	    }
				case 5:
        	    {
                 ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
        	    }
				case 6:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_SPOILERS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1147);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1049);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1162);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1158);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1138);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1164);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1146);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1150);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1158);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1060);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1139);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1163);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:// Win
        	    {
                if(
                    pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 3: // Fury
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 4: // Alpha
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 5: // Pro
        	    {
                        if(
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 492 ||//greenwood
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405)//sentinel
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // club
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
        				AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
				case 6: // Champ
        	    {
                        if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 405)//sentinel
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
        				AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 7: // Race
        	    {
                if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542)//clover
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
				case 8: // Drag
        	    {
                if(
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517)//majestic
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1002);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1002);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 9:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
        	    }
				case 10:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_SIDESKIRTS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1036);
		            	AddVehicleComponent(car,1040);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1047);
					    AddVehicleComponent(car,1051);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1069);
					    AddVehicleComponent(car,1071);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"YComponent successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1056);
					    AddVehicleComponent(car,1062);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1026);
					    AddVehicleComponent(car,1027);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1090);
					    AddVehicleComponent(car,1094);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1039);
			            AddVehicleComponent(car,1041);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1048);
					    AddVehicleComponent(car,1052);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1070);
					    AddVehicleComponent(car,1072);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1057);
					    AddVehicleComponent(car,1063);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1031);
					    AddVehicleComponent(car,1030);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1093);
					    AddVehicleComponent(car,1095);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                if(pmodelid[playerid] == 575 ||
	               pmodelid[playerid] == 536 ||
	               pmodelid[playerid] == 576 ||
		 	       pmodelid[playerid] == 567)
	               {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
	       		        AddVehicleComponent(car,1042);
	       		        AddVehicleComponent(car,1099);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
	   				else if(pmodelid[playerid] == 567) // Savanna
					{
					    AddVehicleComponent(car,1102);
					    AddVehicleComponent(car,1133);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    		        ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
	                else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1134);
					    AddVehicleComponent(car,1137);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    		        ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
	                else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1108);
					    AddVehicleComponent(car,1107);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	                    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                if(pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 534)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1122);
			            AddVehicleComponent(car,1101);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                if(pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 534)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1106);
			            AddVehicleComponent(car,1124);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 5:
        	    {
                if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1118);
			            AddVehicleComponent(car,1120);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 6:
        	    {
				if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1119);
			            AddVehicleComponent(car,1121);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 7:
        	    {
				if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 527 ||
					pmodelid[playerid] == 415 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 517 ||
					pmodelid[playerid] == 603 ||
					pmodelid[playerid] == 436 ||
					pmodelid[playerid] == 439 ||
					pmodelid[playerid] == 580 ||
					pmodelid[playerid] == 549 ||
					pmodelid[playerid] == 477)
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
        	    }
				case 8:
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
        	    }
				case 9:
        	    {
    			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_BULLBARS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1100);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
			        }
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1123);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1125);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1117);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] ou cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_WHEELS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1025);
		            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Offroad Wheels ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 1:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1074);
           			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Mega Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 2:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1076);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Wires Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 3:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1078);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Twist Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	      		 	SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 4:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1080);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added GoldRims Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 5:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1082);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Import Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 6:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1085);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Atomic Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 7:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1096);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Ahab Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 8:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1097);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Virtual Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 9:
        	    {
     			if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1098);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Access Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 10:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1084);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Trance Wheels ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 11:
        	    {
 				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1073);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Shadow Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 12:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1075);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Rimshine Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	      	 		SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 13:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1077);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Classic Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 14:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1079);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Cutter Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 15:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1083);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added Dollar Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 16:
        	    {
					ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGoldRims\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
        	    }
				case 17:
        	    {
     			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_CSTEREO)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1086);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added. ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
			    }
        	    }
        	    case 1:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
        	    }
        	    case 2:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_HYDRAULICS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1087);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added. ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
			    }
        	    }
        	    case 1:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
        	    }
        	    case 2:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_NITRO)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1008);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added. ");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
        			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
			    }
        	    }
        	    case 1:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1009);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
				}
        	    }
        	    case 2:
        	    if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1010);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
				}
        	    case 3:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
        	    }
        	    case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_HOODS)// HOODS
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// fury
        	    {
                	if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 550)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
	    		}
        	    case 1: // Champ
        	    {
                if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 550)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
				case 2: // Race
        	    {
                if(
					pmodelid[playerid] == 549)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1011);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 3: // Worx
        	    {
                if(
					pmodelid[playerid] == 549)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1012);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
        	    }
				case 5: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
			}
		}
	}
	////////////////////////////////////////end of hoods///////////
    if(dialogid == DIALOG_TYPE_VENTS)//////////////////VENTS//////////////////
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// Oval
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 439 ||//stallion
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
							SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
							ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
				}
        	    case 1: // Square
        	    {
                if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 439 ||//stallion
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
              			else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    }
				case 2: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
			}
		}
	}


	///////////END OF VENTS///////////
	if(dialogid == DIALOG_TYPE_LIGHTS)//////////////////LIGTS//////////////////
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// round
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 439)//stallion
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
               			AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
               			ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
               			ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
                    else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
				}
        	    case 1: // Square
        	    {
                if(
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 400)//landstalker
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
        	    }
				case 2: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Hoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide", "Enter", "Close");
        	    }
			}
		}
	}
	switch(dialogid)
	{
	    case DIALOG_CARSTORAGE:
		{
		    if(response)
		    {
				if(listitem != -1)
		        {
		        	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerInfo[playerid][pID], listitem);
		        	mysql_tquery(connectionID, queryBuffer, "OnPlayerUseCarStorage", "i", playerid);
				}
			}

		}
	    case DIALOG_VOTE:
		{
		    if(response)
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM factions WHERE type = 4 LIMIT %i, 1", listitem);
		        mysql_tquery(connectionID, queryBuffer, "OnPlayerUseVote", "i", playerid);
			}
		}

		case DIALOG_GCARSTORAGE:
		{
		    if(response)
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM vehicles WHERE gangid = %i LIMIT %i, 1", PlayerInfo[playerid][pGang], listitem);
		        mysql_tquery(connectionID, queryBuffer, "OnPlayerUseGCarStorage", "i", playerid);
			}
		}
		case DIALOG_VALLEY:
		{
		    if(response)
		    {
				if(listitem != -1)
		        {
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerInfo[playerid][pID], listitem);
		        	mysql_tquery(connectionID, queryBuffer, "OnPlayerUseCarValley", "i", playerid);
				}
			}
		}
		case DIALOG_DMVRELEASE:
		{
			if(response)
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, tickets, modelid FROM vehicles WHERE ownerid = %i AND impounded = 1 LIMIT %i, 1", PlayerInfo[playerid][pID], listitem);
		        mysql_tquery(connectionID, queryBuffer, "OnPlayerDMVRelease", "i", playerid);
			}
		}
		case DIALOG_PAYCHECK:
		{
	 		if(!response) return 1;
			new
				szMessage[150];
	   		if(strlen(inputtext) < 1)
			{
	            format(szMessage, sizeof(szMessage), "You must enter the check code before signing.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
				ShowPlayerDialog(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, SERVER_DIALOG, szMessage, "Paycheck","Cancel");
				return 1;
	        }
			if(!IsNumeric(inputtext))
			{
	 			format(szMessage, sizeof(szMessage), "Wrong check code. The check code consists out of numbers only.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
				ShowPlayerDialog(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, SERVER_DIALOG, szMessage, "Paycheck","Cancel");
				return 1;
			}
	        if(strlen(inputtext) > 2 || (strlen(inputtext) > 0 && strlen(inputtext) < 2))
			{
	           	format(szMessage, sizeof(szMessage), "Wrong check code. The check code consists out of 2 digits.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
				ShowPlayerDialog(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, SERVER_DIALOG, szMessage, "Paycheck","Cancel");
				return 1;
	        }
	        new code = strval(inputtext);
        	if(code == PayCheckCode[playerid])
	        {
				SendPaycheck(playerid);
	        	PayCheckCode[playerid] = 0;
			}
			else
			{
	            SendClientMessage(playerid, COLOR_WHITE, "Wrong check code.");
	        }
		}
		case DIALOG_PAINTBALL:
		{
		    if(response)
		    {
			    SendProximityMessage(playerid, 20.0, COLOR_LE, "** %s has entered the paintball arena.", GetRPName(playerid));
				SetPlayerInPaintball(playerid, listitem+1);

				foreach(new i : Player)
				{
				    if(PlayerInfo[playerid][pPaintball] == PlayerInfo[i][pPaintball])
				    {
				        SM(i, COLOR_WHITE, "[Paintball Arena] %s has joined the Paintball Arena!", GetRPName(playerid));
					}
			    }
		    }
		}
		case DIALOG_ROUTEMENU:
		{
	        switch(listitem)
	        {
	            case 0: // Commerce-Market
	            {
                    GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
					SendClientMessage(playerid, COLOR_AQUA, "Follow the checkpoints to find the passengers.");
					SetPlayerCheckpoint(playerid, 1660.959350, -1547.258178, 13.411951, 10);
					PlayerInfo[playerid][pCP] = CHECKPOINT_BUS;
					Startjob[playerid] = 1;
	            }
	            case 1: // Commerce-LS Airport
	            {
	                GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
					SendClientMessage(playerid, COLOR_AQUA, "Follow the checkpoints to find the passengers.");
					SetPlayerCheckpoint(playerid, 1660.959350, -1547.258178, 13.411951, 10);
					PlayerInfo[playerid][pCP] = CHECKPOINT_BUS2;
					Startjob[playerid] = 1;
				}
			}
		}
 		case DIALOG_GRAFFITICOLOR:
		{
			if (response)
			{
			    new id = Graffiti_Nearest(playerid);

				if (id == -1)
				    return 0;

			    if (IsSprayingInProgress(id))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "There is another player spraying at this point already.");
				}

			    switch (listitem)
			    {
			        case 0:
			        {
		    	        PlayerInfo[playerid][pGraffitiColor] = 0xFFFFFFFF;
					}

			        case 1:
			        {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFFFF0000;
					}

			        case 2:
			        {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFFFFFF00;
					}

			        case 3:
			        {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFF33CC33;
					}

			        case 4:
			        {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFF33CCFF;
					}

		    	    case 5:
		    	    {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFF0080FF;
					}

		    	    case 6:
		    	    {
			            PlayerInfo[playerid][pGraffitiColor] = 0xFF1394BF;
					}
					case 7:
					{
						PlayerInfo[playerid][pGraffitiColor] = 0x000000AA;
					}
			    }
			    ShowPlayerDialog(playerid, DIALOG_GRAFFITITEXT, DIALOG_STYLE_INPUT, SERVER_DIALOG, "Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
			}
		}
		case DIALOG_GUNSHOP:
	    {
	        if(response)
	        {
	 			if(listitem == 0)
				{
                    if(PlayerInfo[playerid][pCash] < 50000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have cash. You can't buy this.");
                    }
				    PlayerInfo[playerid][pCash] -= 50000;
                    GiveWeapon(playerid, 25);
					Dyuze(playerid, "Transaction", "You have successfully bought an Shotgun from Gunshop!");
                }
                else if(listitem == 1)
                {
                	if(PlayerInfo[playerid][pCash] < 35000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                    PlayerInfo[playerid][pCash] -= 35000;
                    GiveWeapon(playerid, 23);
					Dyuze(playerid, "Transaction", "You have successfully bought an Silent Pistol from Gunshop!");
                }
                else if(listitem == 2)
                {
               		if(PlayerInfo[playerid][pCash] < 25000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                    PlayerInfo[playerid][pCash] -= 25000;
                    GiveWeapon(playerid, 22);
                    SendClientMessage(playerid, COLOR_WHITE, "** You have successfully bought an 9mm from GunShop!");
                }
                else if(listitem == 3)
                {
               		if(PlayerInfo[playerid][pCash] < 95000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                    PlayerInfo[playerid][pCash] -= 95000;
                    GiveWeapon(playerid, 29);
                    SendClientMessage(playerid, COLOR_WHITE, "** You have successfully bought an MP5 from Gunshop!");
                }
                else if(listitem == 4)
                {
               		if(PlayerInfo[playerid][pCash] < 5000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                    if(PlayerInfo[playerid][pVest] >= 5)
                    {
						return SendClientMessage(playerid,COLOR_SYNTAX,"Maximum 5 vests");
                    }
                    else
                    {
						PlayerInfo[playerid][pVest] += 1;
						PlayerInfo[playerid][pCash] -= 5000;
						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[playerid][pVest], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);
					}
					Dyuze(playerid, "Transaction", "You have successfully bought an Vest from Gunshop");
                }
                else if(listitem == 5)
                {
               		if(PlayerInfo[playerid][pCash] < 5000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                    if(PlayerInfo[playerid][pHelmet1] > 5)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You Have 5 helmets");
                    }
				    if(PlayerInfo[playerid][pHelmet1] >= 5)
                    {
						return SendClientMessage(playerid,COLOR_SYNTAX,"Maximum 5 Helmet");
                    }
                    else
                    {
                         PlayerInfo[playerid][pHelmet1] += 1;
					}
                    PlayerInfo[playerid][pCash] -= 5000;
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET helmetp = %i WHERE uid = %i", PlayerInfo[playerid][pHelmet1], PlayerInfo[playerid][pID]);
                 	mysql_tquery(connectionID, queryBuffer);
					Dyuze(playerid, "Transaction", "You have successfully bought an helmet from Gunshop /use helmet");
                }
				  else if(listitem == 6)
                {
               		if(PlayerInfo[playerid][pCash] < 20000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough cash. You can't buy this.");
                    }
                   
                    PlayerInfo[playerid][pCash] -= 20000;
                    GiveWeapon(playerid, WEAPON_PARACHUTE);
					Dyuze(playerid, "Transaction", "You have successfully bought an Silent Pistol from Gunshop!");
                }
			}
		}
		case DIALOG_GRAFFITITEXT:
		{
			if (response)
			{
			    new id = Graffiti_Nearest(playerid);

				if (id == -1)
				    return 0;

			    if (isnull(inputtext))
			    {
			        return ShowPlayerDialog(playerid, DIALOG_GRAFFITITEXT, DIALOG_STYLE_INPUT, SERVER_DIALOG, "Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
				}
				if (strlen(inputtext) > 64)
				{
				    return ShowPlayerDialog(playerid, DIALOG_GRAFFITITEXT, DIALOG_STYLE_INPUT, SERVER_DIALOG, "[!] Your input can't exceed 64 characters.\n\nPlease enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
				}
		        if (IsSprayingInProgress(id))
		        {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "There is another player spraying at this point already.");
				}
		        PlayerInfo[playerid][pGraffiti] = id;
		        PlayerInfo[playerid][pGraffitiTime] = 15;

				strpack(PlayerInfo[playerid][pGraffitiText], inputtext, 64 char);
				ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);

				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);

				SendProximityMessage(playerid, 30.0, SERVER_COLOR, "**{C2A2DA} %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
		}
		case DIALOG_FOODSHOP:
		{
			if(response)
			{
				switch(listitem)
				 {

			        case 1: // Water
					{
						if(PlayerInfo[playerid][pCash] < 500)
							return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least 500 $.");

						PlayerInfo[playerid][pVendorTime] = 1;

						GivePlayerCash(playerid, -500);
						ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

	                    if(PlayerInfo[playerid][pMilkshake] >= 30)
					    {
					        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 milkshakes.");
					    }
						PlayerInfo[playerid][pMilkshake] += 1;

	                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET poisonammo = %i WHERE uid = %i", PlayerInfo[playerid][pMilkshake], PlayerInfo[playerid][pID]);
	                    mysql_tquery(connectionID, queryBuffer);

						SCMf(playerid, COLOR_TEAL, "* "WHITE"%s"TEAL" has purchased a Milshake from the Food Shop.", GetPlayerNameEx(playerid));

						SendClientMessage(playerid, COLOR_TEAL, "* You have paid 500 $  From Food Shop.");
					}
					case 0: // burger
					{
						if(PlayerInfo[playerid][pCash] < 1000)
							return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least 1000 $.");

						PlayerInfo[playerid][pVendorTime] = 1;

						GivePlayerCash(playerid, -1000);
						ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

	                    if(PlayerInfo[playerid][pFMJAmmo] >= 40)
					    {
					        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 40 Burger.");
					    }

						PlayerInfo[playerid][pFMJAmmo] += 1;


	                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fmjammo = %i WHERE uid = %i", PlayerInfo[playerid][pFMJAmmo], PlayerInfo[playerid][pID]);
	                    mysql_tquery(connectionID, queryBuffer);

						SCMf(playerid, COLOR_TEAL, "* "WHITE"%s"TEAL" has purchased a Burger from the Food Shop.", GetPlayerNameEx(playerid));

						SendClientMessage(playerid, COLOR_TEAL, "*You have paid 1000 $  From Food Shop.");
				    }
				    case 2: // REDBULL
					{
						if(PlayerInfo[playerid][pCash] < 5000)
							return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least 5000 $.");

						PlayerInfo[playerid][pVendorTime] = 1;

						GivePlayerCash(playerid, -5000);
						ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

	                    if(PlayerInfo[playerid][pRedbull] >= 2)
					    {
					        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 2 RedBull.");
					    }
						PlayerInfo[playerid][pRedbull] += 1;

	                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energydrink = %i WHERE uid = %i", PlayerInfo[playerid][pRedbull], PlayerInfo[playerid][pID]);
	                    mysql_tquery(connectionID, queryBuffer);

						SCMf(playerid, COLOR_TEAL, "* "WHITE"%s"TEAL" has purchased a RedBull from the Food Shop.", GetPlayerNameEx(playerid));

						SendClientMessage(playerid, COLOR_TEAL, "* You have paid 5000 $  From Food Shop.");
					}
					case 3: // burger
					{
						if(PlayerInfo[playerid][pCash] < 5000)
							return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least 5000 $.");

						PlayerInfo[playerid][pVendorTime] = 1;

						GivePlayerCash(playerid, -5000);
						ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

	                    if(PlayerInfo[playerid][pRedroll] >= 3)
					    {
					        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 3 Energy Beef Roll");
					    }

						PlayerInfo[playerid][pRedroll] += 1;


	                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET energyroll = %i WHERE uid = %i", PlayerInfo[playerid][pRedroll], PlayerInfo[playerid][pID]);
	                    mysql_tquery(connectionID, queryBuffer);

						SCMf(playerid, COLOR_TEAL, "* "WHITE"%s"TEAL" has purchased a Energy Beef Roll from the Food Shop.", GetPlayerNameEx(playerid));

						SendClientMessage(playerid, COLOR_TEAL, "*You have paid 5000 $  From Food Shop.");
				    }

				}
			}
		}
		case DIALOG_MP3URL2:
		{
		    if(response)
		    {
		        if(isnull(inputtext))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_MP3URL2, DIALOG_STYLE_INPUT, "Youtube URL", "Please enter the URL of the Youtube you want to play:", "Submit", "Back");
          		}

		    }
		    else
		    {
                 ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
			}
		}
		case DIALOG_PCP:
		{
			if(response)
			{
				new params[158], string[200];
				if(listitem == 0)
				{
					format(string,sizeof(string),"Please enter the reason why you wish to report this player:");
					ShowPlayerDialog(playerid, DIALOG_PCP_REPORT, DIALOG_STYLE_INPUT, "{00FF5C}Player Control Panel :: Reporting", string, "Report", "Cancel");
				}
				if(listitem == 1)
				{
					ShowPlayerDialog(playerid, DIALOG_PM, DIALOG_STYLE_INPUT, "Private Message", "Input your private message text:", "Send", "Cancel");
				}
				if(listitem == 2)
				{
					format(string,sizeof(string),"Please enter the reason why you wish to kick this player:");
					ShowPlayerDialog(playerid, DIALOG_PCP_KICK, DIALOG_STYLE_INPUT, "{00FF5C}Player Control Panel :: Kicking", string, "Kick", "Cancel");
				}
				if(listitem == 3)
				{
					format(string,sizeof(string),"Please enter the time to ban this player for:");
					ShowPlayerDialog(playerid, DIALOG_PCP_BAN1, DIALOG_STYLE_INPUT, "{00FF5C}Player Control Panel :: Banning", string, "Continue", "Cancel");
				}
				if(listitem == 4)
				{
					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::spec(playerid, params);
				}

				if(listitem == 5)
				{
					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::gethere(playerid, params);
				}
				if(listitem == 6)
				{
					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::goto(playerid, params);
				}
				if(listitem == 7)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::nmute(playerid, params);
				}
				if(listitem == 8)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::freeze(playerid, params);
				}
				if(listitem == 9)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::unfreeze(playerid, params);
				}
				if(listitem == 10)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::slap(playerid, params);
				}
				if(listitem == 11)
				{

					format(params, sizeof(params), "%i AdminAction", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::revive(playerid, params);
				}
				if(listitem == 12)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::check(playerid, params);
				}
				if(listitem == 13)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::nrn(playerid, params);
				}
				if(listitem == 14)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::rules(playerid, params);
				}

				if(listitem == 15)
				{

					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::listguns(playerid, params);
				}
				if(listitem == 16)
				{
					format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
					DeletePVar(playerid, "pClickedID");
					return callcmd::listpvehs(playerid, params);
				}
				if(listitem == 17) { 
					format(params, sizeof(params), "%i %s", GetPVarInt(playerid, "pClickedID"), GetPlayerIP(GetPVarInt(playerid, "pClickedID")));
					DeletePVar(playerid, "pClickedID"); 
					return callcmd::banip(playerid, params);
				}
				if(listitem == 18) { 
					DeletePVar(playerid, "pClickedID"); 
					return 1;
				}
			}
			else
			{
				DeletePVar(playerid, "pClickedID");
				return 1;
			}
		}
		case DIALOG_PCP_REPORT:
		{
			if(response)
			{
				new params[158];
				format(params, sizeof(params), "%i %s", GetPVarInt(playerid, "pClickedID"), inputtext);
				DeletePVar(playerid, "pClickedID");
				return callcmd::report(playerid, params);
			}
			else
			{
				DeletePVar(playerid, "pClickedID");
				return 1;
			}
		}
		case DIALOG_PCP_KICK:
		{
			if(response)
			{
				new params[158];
				format(params, sizeof(params), "%i %s", GetPVarInt(playerid, "pClickedID"), inputtext);
				DeletePVar(playerid, "pClickedID");
				return callcmd::kick(playerid, params);
			}
			else
			{
				DeletePVar(playerid, "pClickedID");
				return 1;
			}
		}
		case DIALOG_PCP_BAN1:
		{
			if(response)
			{
				new string[128];
				SetPVarInt(playerid, "pBanTime", strval(inputtext));
				format(string,sizeof(string),"Please enter the reason why you wish to ban this player:");
				ShowPlayerDialog(playerid, DIALOG_PCP_BAN2, DIALOG_STYLE_INPUT, "{00FF5C}Player Control Panel :: Banning", string, "Ban", "Cancel");
			}
			else
			{
				DeletePVar(playerid, "pClickedID");
				DeletePVar(playerid, "pBanTime");
			}
			return 1;
		}
		case DIALOG_PCP_BAN2:
		{
			if(response)
			{
				new params[158];
				format(params, sizeof(params), "%i %i %s", GetPVarInt(playerid, "pClickedID"), GetPVarInt(playerid, "pBanTime"), inputtext);
				DeletePVar(playerid, "pClickedID");
				DeletePVar(playerid, "pBanTime");
				return callcmd::ban(playerid, params);
			}
			else
			{
				DeletePVar(playerid, "pClickedID");
				DeletePVar(playerid, "pBanTime");
				return 1;
			}
		}
		case DIALOG_FACTIONCLOTHS:
		{
			if(response)
			{
				if(listitem == 0)
				{
					if (IsPlayerAttachedObjectSlotUsed(playerid, 7))
					{
						RemovePlayerAttachedObject(playerid, 7);	
					}
					SetPlayerAttachedObject(playerid, 7, 18637, 13, 0.35, 0.0,  0.0,  0.0,   0.0, 180.0);
					if(gNotification)
						return notification_show(playerid, str_format("Attached To Slot 7"),2000, NOTIF_SUCCESS);
					else		
						return SendClientMessage(playerid, COLOR_GREY, "Attached To Slot 7.");
				}
				else if(listitem == 1)
				{
					if (IsPlayerAttachedObjectSlotUsed(playerid, 1))
					{
						RemovePlayerAttachedObject(playerid, 1);
						
					}
					SetPlayerAttachedObject(playerid, 1, 19138, 2, 0.099000, 0.037999, -0.002000, 0.000000, 90.000152, 88.300041, 0.990999, 0.967000, 1.138000);
					if(gNotification)
						return notification_show(playerid, str_format("Attached To Slot 1"),2000, NOTIF_SUCCESS);
					else		
						return SendClientMessage(playerid, COLOR_GREY, "Attached To Slot 1.");
				}
			    else if(listitem == 2)
				{
					if (IsPlayerAttachedObjectSlotUsed(playerid, 1))
					{
						RemovePlayerAttachedObject(playerid, 1);
					}
					SetPlayerAttachedObject(playerid, 1, 19139, 2, 0.099000, 0.037999, -0.002000, 0.000000, 90.000152, 88.300041, 0.990999, 0.967000, 1.138000);
					if(gNotification)
						return notification_show(playerid, str_format("Attached To Slot 1"),2000, NOTIF_SUCCESS);
					else		
						return SendClientMessage(playerid, COLOR_GREY, "Attached To Slot 1.");
				}
				else if(listitem == 3)
				{
					if (IsPlayerAttachedObjectSlotUsed(playerid, 1))
					{
						RemovePlayerAttachedObject(playerid, 1);
					
					}
					SetPlayerAttachedObject(playerid, 1, 19140, 2, 0.099000, 0.037999, -0.002000, 0.000000, 90.000152, 88.300041, 0.990999, 0.967000, 1.138000);
					if(gNotification)
						return notification_show(playerid, str_format("Attached To Slot 1"),2000, NOTIF_SUCCESS);
					else		
						return SendClientMessage(playerid, COLOR_GREY, "Attached To Slot 1.");
				}
				else if (listitem == 4)
				{
					if (IsPlayerAttachedObjectSlotUsed(playerid, 6))
					{
						RemovePlayerAttachedObject(playerid, 6);
						
					}
					SetPlayerAttachedObject(playerid, 6, 373, 1, 0.287000, -0.010000, -0.158000, 72.099990, 26.599996, 32.099990, 1.039000, 0.926000, 1.029001);
					if(gNotification)
						return notification_show(playerid, str_format("Attached To Slot 6"),2000, NOTIF_SUCCESS);
					else		
						return SendClientMessage(playerid, COLOR_GREY, "Attached To Slot 6.");
				}
			}
			else
			{
				return 1;
			}
		}
  		case DIALOG_BLACKMARKET6:
	    {
	        if(response)
	        {
	 			if(listitem == 0)
				{
					if(PlayerInfo[playerid][pCash] < 15000)
                    {
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enoughcash. You can't buy this.");
                    }
                    PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    GivePlayerCash(playerid, -15000);

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);

	                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $15000 to the shopkeeper and received a mobile phone.", GetRPName(playerid));
					if(gNotification)
			            notification_show(playerid, str_format("Mobile phone purchased. Your new phone number is %i.", PlayerInfo[playerid][pPhone]), 2000, NOTIF_SUCCESS);
					else		
	                    SM(playerid, COLOR_WHITE, " Mobile phone purchased. Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
                else if(listitem == 1)
                {
                	if(PlayerInfo[playerid][pCash] < 10000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enoughcash. You can't buy this.");
						
					}

                    PlayerInfo[playerid][pWalkieTalkie] = 1;
	                GivePlayerCash(playerid,-10000);

	                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET walkietalkie = %i WHERE uid = %i", PlayerInfo[playerid][pWalkieTalkie], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
              
                    
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received a Portable Radio.", GetRPName(playerid));
                    if(gNotification)
			        	notification_show(playerid, str_format("Portable Radio purchased. Use /radiosv to speak and /fr to change the frequency"), 2000, NOTIF_SUCCESS);
					else		
                        SendClientMessage(playerid, COLOR_WHITE, "** Portable Radio purchased. Use /radio to speak and /channel to change the frequency.");
                }
                else if(listitem == 2)
                {
               		if(PlayerInfo[playerid][pCash] < 2000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enoughcash. You can't buy this.");
                        
					}


                    PlayerInfo[playerid][pWatch] = 1;
	                GivePlayerCash(playerid, -2000);


	                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = %i WHERE uid = %i", PlayerInfo[playerid][pWatch], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $2000 to the shopkeeper and received a pocket watch.", GetRPName(playerid));
          	        if(gNotification)
			        	notification_show(playerid, str_format("Pocket watch purchased. Use /ww to toggle it"), 2000, NOTIF_SUCCESS);
					else
					SendClientMessage(playerid, COLOR_WHITE, " Pocket watch purchased. Use /ww to toggle it.");
				}
                else if(listitem == 3)
                {
              		if(PlayerInfo[playerid][pCash] < 10000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
							return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}

                    PlayerInfo[playerid][pGPS] = 1;
	                GivePlayerCash(playerid, -10000);



                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = %i WHERE uid = %i", PlayerInfo[playerid][pGPS], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);

	                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received a GPS.", GetRPName(playerid));
	                if(gNotification)
			        	notification_show(playerid, str_format("GPS purchased. (( /gps, /locate ))"), 2000, NOTIF_SUCCESS);
					else
				    	SendClientMessage(playerid, COLOR_WHITE, "** GPS purchased. (( /gps, /locate ))");
				}
			    else if(listitem == 4)
                {
                    if(PlayerInfo[playerid][pCash] < 1000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
							return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}

		     	    PlayerInfo[playerid][pFishingRod] = 1;
                    GivePlayerCash(playerid, -1000);

	                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingrod = %i WHERE uid = %i", PlayerInfo[playerid][pFishingRod], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);

                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} $1000 paid $ to the shopkeeper and received a fishing rod.", GetRPName(playerid));
	                if(gNotification)
			        	notification_show(playerid, str_format("Fishing rod purchased. Use (/fish) at the pier or in a boat to begin fishing"), 2000, NOTIF_SUCCESS);
					else
					    SendClientMessage(playerid, COLOR_WHITE, "** Fishing rod purchased. Use /fish at the pier or in a boat to begin fishing.");
				}
				else if(listitem == 5)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else		
							return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pFishingBait] + 10 >= 20)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You can't have more than 20 pieces of bait."), 2000, NOTIF_ERROR);
					    else
							return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 pieces of bait.");
					}

					PlayerInfo[playerid][pFishingBait] += 10;
					GivePlayerCash(playerid, -5000);
     

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingbait = %i WHERE uid = %i", PlayerInfo[playerid][pFishingBait], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $ 5000 to the shopkeeper and received fish bait.", GetRPName(playerid));
					if(gNotification)
			        	notification_show(playerid, str_format("** Fishing bait purchased. Bait increases the odds of catching bigger fish."), 2000, NOTIF_SUCCESS);
					else
						SendClientMessage(playerid, COLOR_WHITE, "** Fishing bait purchased. Bait increases the odds of catching bigger fish.");
				}
				else if(listitem == 6)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You don't have enoughcash. You can't buy this."), 2000, NOTIF_ERROR);
					    else
							return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pFlashlight] == 1)
					{
						if(gNotification)
			        	    return notification_show(playerid, str_format("You can't have more than 1 flashlight."), 2000, NOTIF_ERROR);
					    else
							return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 flashlight.");
					}


					PlayerInfo[playerid][pFlashlight] = 1;
					GivePlayerCash(playerid, -5000);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received a flashlight.", GetRPName(playerid));
					if(gNotification)
			        	notification_show(playerid, str_format("Flashlight purchased. use /flashlight to use it on your hand and /taclight to use it on your weapon."), 2000, NOTIF_SUCCESS);
					else
						SendClientMessage(playerid, COLOR_WHITE, "Flashlight purchased. use /flashlight to use it on your hand and /taclight to use it on your weapon.	");
				}
				else if(listitem == 7)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pMP3Player] == 1)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 Mp3.");
					}
					PlayerInfo[playerid][pMP3Player] = 1;
					GivePlayerCash(playerid, -5000);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mp3player = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received an MP3 player.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** MP3 player purchased. Use /mp3 for a list of options.");
				}
				else if(listitem == 8)
				{
					if(PlayerInfo[playerid][pCash] < 3000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pPhonebook] == 1)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 phonebook.");
					}
					PlayerInfo[playerid][pPhonebook] = 1;
					GivePlayerCash(playerid, -3000);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebook = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $3000 to the shopkeeper and received an Phonebook.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** Phonebook purchased. Use /number [id] for a list of options.");
				}
				else if(listitem == 9)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pRepairKit] > 5)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 5 repairkit");
					}
					PlayerInfo[playerid][pRepairKit] ++;
					GivePlayerCash(playerid, -5000);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i",PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $3000 to the shopkeeper and received an Repair Kit", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** /userepairkit to use ");
				}
				else if(listitem == 10)
				{
					if(PlayerInfo[playerid][pCash] < 20000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pAcetone] > 30)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 60 Acetone");
					}
					PlayerInfo[playerid][pAcetone] +=30;
					GivePlayerCash(playerid, -20000);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET acetone = %i WHERE uid = %i",PlayerInfo[playerid][pAcetone], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $20000 to the shopkeeper and received an Acetone", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** Used To Cook Meth ");
				}
				else if(listitem == 11)
				{
					if(PlayerInfo[playerid][pCash] < 20000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pBatteries] > 30)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 60 Batteries");
					}
					PlayerInfo[playerid][pBatteries] += 30;
					GivePlayerCash(playerid, -20000);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET batteries = %i WHERE uid = %i",PlayerInfo[playerid][pBatteries], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $20000 to the shopkeeper and received an Batteries", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** Used To Cook Meth ");
				}
				else if(listitem == 12)
				{
					if(PlayerInfo[playerid][pCash] < 10000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pPepperSpray])
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You Already Have PepperSpray");
					}
					PlayerInfo[playerid][pPepperSpray] = 1;
					PlayerInfo[playerid][pPepperAmmo] = 100;
					GivePlayerCash(playerid, -10000);
					GiveWeapon(playerid, WEAPON_SPRAYCAN);
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pepperspray = %i WHERE uid = %i",PlayerInfo[playerid][pPepperSpray], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received an PepperSpray", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Self Defence");
				}	
		 	}
		}
		case DIALOG_BLACKMARKET7:
	    {
	        if(response)
	        {
	            if(listitem == 0)
				{
				    if(PlayerInfo[playerid][pCash] < 15000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} You don't have enough money. You can't buy this.");
                    }
		            if(PlayerInfo[playerid][pCrowbar] == 1)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than one crowbar.");
		            }
		            PlayerInfo[playerid][pCrowbar] = 1;
		            GivePlayerCash(playerid, -15000);


		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crowbar = %i WHERE uid = %i", PlayerInfo[playerid][pCrowbar], PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);

                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $25000 to the shopkeeper and received a Crowbar.", GetRPName(playerid));
                    SendClientMessage(playerid, COLOR_WHITE, "HINT: Use '/breakcuffs' to break cuffs from anybody's hand.");
				}
				else if(listitem == 1)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}

					PlayerInfo[playerid][pMask] = 1;
					GivePlayerCash(playerid, -50000);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mask = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received a Mask.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "** Mask purchased. Use /mask to toggle it.");
				}
				else if(listitem == 2)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pBlindfold] == 1)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 blindfolds.");
					}

					PlayerInfo[playerid][pBlindfold] += 1;
					GivePlayerCash(playerid, -5000);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET blindfold = %i WHERE uid = %i", PlayerInfo[playerid][pBlindfold], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received 1 blindfolds.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Blindfold purchased. Use /blindfold to blindfold people in your vehicle.");
				}
				else if(listitem == 3)
				{
					if(PlayerInfo[playerid][pCash] < 5000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pRope] == 1)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 ropes.");
					}


					PlayerInfo[playerid][pRope] += 1;
					GivePlayerCash(playerid, -5000);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = %i WHERE uid = %i", PlayerInfo[playerid][pRope], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received 2 ropes.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Ropes purchased. Use /tie to tie people in your vehicle.");
				}
				else if(listitem == 4)
				{
					if(PlayerInfo[playerid][pCash] < 10000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pLockpick] >= 3)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 3 lockpick.");
					}


					PlayerInfo[playerid][pLockpick] += 1;
					GivePlayerCash(playerid, -10000);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET toolkit = %i WHERE uid = %i", PlayerInfo[playerid][pToolkit], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received 1 ropes.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Lockpick purchased. Use /lockpick to tie people in your vehicle.");
				}
				else if(listitem == 5)
				{
					if(PlayerInfo[playerid][pCash] < 1000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pWeaponClip] == 15)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 15 Weaponclip.");
					}


					PlayerInfo[playerid][pWeaponClip] += 1;
					GivePlayerCash(playerid, -1000);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET weaponclip = %i WHERE uid = %i", PlayerInfo[playerid][pWeaponClip], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $5000 to the shopkeeper and received 1 ropes.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Weapon Clip purchased. Useless");
				}
				else if(listitem == 6)
				{
					if(PlayerInfo[playerid][pCash] < 10000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pPendrive] == 1)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 Pendrive.");
					}


					PlayerInfo[playerid][pPendrive] += 1;
					GivePlayerCash(playerid, -10000);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pendrive = %i WHERE uid = %i", PlayerInfo[playerid][pPendrive], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received 1 Pendrive.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, "Pendrive purchased.You can Use in Drug Heist");
				}
				else if(listitem == 7)
				{
					if(PlayerInfo[playerid][pCash] < 10000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pLaptop] == 5)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 5 Laptop.");
					}


					PlayerInfo[playerid][pLaptop] += 1;
					GivePlayerCash(playerid, -10000);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET laptop = %i WHERE uid = %i", PlayerInfo[playerid][pLaptop], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received 1 Laptop.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, " purchased.Use /uselaptop to rob Flecca Bank.");
				}
				else if(listitem == 8)
				{
					if(PlayerInfo[playerid][pCash] < 30000)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
					}
					if(PlayerInfo[playerid][pToolkit] >= 3)
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 3 toolkit.");
					}
					PlayerInfo[playerid][pToolkit] += 1;
					GivePlayerCash(playerid, -34513);


					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET laptop = %i WHERE uid = %i", PlayerInfo[playerid][pLaptop], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received Toolkit.", GetRPName(playerid));
					SendClientMessage(playerid, COLOR_WHITE, " purchased.Use /hotwire or press'2' to hotwire vehicle.");

				}
			    else if(listitem == 9)
                {
                    if(PlayerInfo[playerid][pCash] < 10000)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
                    }
				    if(PlayerInfo[playerid][pMobileMethLab] > 5)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 5 MobileMethLab.");
				    }
				    PlayerInfo[playerid][pMobileMethLab] += 1;
                    GivePlayerCash(playerid, -10000);


                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mobilemethlab = %i WHERE uid = %i", PlayerInfo[playerid][pMobileMethLab], PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);

                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $10000 to the shopkeeper and received MethLab", GetRPName(playerid));
                    SendClientMessage(playerid, COLOR_WHITE, "Used To Cook Meth");


				}
			}
		}
		case DIALOG_LOGINMUSIC:
		{
  			if(response)
      		{
				switch(listitem)
				{
				    case 0: // illuminati
				    {

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET loginurl = 'https://stream.zeno.fm/9sfpn7udkfwuv' WHERE uid = %i", PlayerInfo[playerid][pID]);
	                	mysql_tquery(connectionID, queryBuffer);

				    }
				    case 1: // 
				    {
	                    SendClientMessage(playerid, COLOR_SYNTAX, "coming soon");
				    }
				    case 2: // custom
				    {
				    	ShowPlayerDialog(playerid, DIALOG_LOGINMUSIC1, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to login music:", "Submit", "Back");
				    }
				}
          	}
		}
		case DIALOG_INSTA:
		{
             if(response) {
			    strcpy(tweet, inputtext);
			    if(gettime() - PlayerInfo[playerid][pLastInsta] < 10)
	            {
	                return SM(playerid, COLOR_SYNTAX, "You can only send messages in every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerInfo[playerid][pLastInsta]));
	            }
			    SMA(COLOR_PINK, "[Instagram]: @%s  "WHITE" %s, ", GetRPName(playerid),tweet);
			    new szstring[2500];
                format(szstring, sizeof(szstring), "[INSTAGRAM] **%s:** %s.", GetRPName(playerid), tweet);
                SendDiscordMessage(23,szstring);
			}
		}
		case DIALOG_CRAFTING:
		{
		    if(response)
		    {
		        if(listitem == 0)//Rope
		        {
		            if(PlayerInfo[playerid][pMaterials] < 50)
		            {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't materials to craft this.");
		            }
		            PlayerInfo[playerid][pCrafting] = 1;
		            GameTextForPlayer(playerid, "~g~crafting...", 60000, 3);
		            ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
		            SetTimerEx("craftrope", 60000, false, "i", playerid);
		        }
		        if(listitem == 1)//Mp5
		        {
		            if(PlayerInfo[playerid][pMaterials] < 350)
                    {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have materials enough to craft this.");
		            }
                    if(PlayerInfo[playerid][pGunFrame] < 1)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have Gunframe enough to craft this.");
                    }
                    if(PlayerInfo[playerid][pIorn] < 5)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough iorns to craft this.");
                    }
		            PlayerInfo[playerid][pCrafting] = 1;
		            GameTextForPlayer(playerid, "~g~crafting...", 120000, 3);
		            ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
		            SetTimerEx("craftMp5", 120000, false, "i", playerid);
		        }
		        if(listitem == 2)//Ak
		        {
		            if(PlayerInfo[playerid][pMaterials] < 500)
                    {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough materials to craft this.");
		            }
                    if(PlayerInfo[playerid][pGunFrame] < 2)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough Gunframe to craft this.");
                    }
                    if(PlayerInfo[playerid][pIorn] < 5)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough iorns to craft this.");
                    }
                    if(PlayerInfo[playerid][pCopper] < 2)
                    {
                        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough coppers to craft this.");
                    }
		            PlayerInfo[playerid][pCrafting] = 1;
		            GameTextForPlayer(playerid, "~g~crafting...", 120000, 3);
		            ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 1, 1, 0, 0);
		            SetTimerEx("craftAK", 120000, false, "i", playerid);
		        }
		    }
		}
		case DIALOG_BIZMENU:
		{
		    if(response)
			{
			    if(listitem == 0)
			    {
			    	ShowPlayerDialog(playerid, DIALOG_BIZNAME, DIALOG_STYLE_INPUT, SERVER_DIALOG, "Enter new name below for your business.", "Confirm", "Return");
				}
				if(listitem == 1)
			    {
			    	ShowPlayerDialog(playerid, DIALOG_MESSAGE, DIALOG_STYLE_INPUT, SERVER_DIALOG, "Enter new message below for your business.", "Confirm", "Return");
				}
				if(listitem == 2)
			    {
				    new businessid = GetNearbyBusinessEx(playerid);
				    new string[128];
					format(string, sizeof(string),"Your business's safe currently contain:\n\t\t$%s\n\t\tProducts: %i.", number_format(BusinessInfo[businessid][bCash]), BusinessInfo[businessid][bProducts]);
    				ShowPlayerDialog(playerid,DIALOG_BIZSAFE,DIALOG_STYLE_MSGBOX,SERVER_DIALOG,string,"Deposit","Withdraw");
				}
				if(listitem == 3)
	   		   	{
				    new businessid = GetNearbyBusinessEx(playerid);
				    new string[128];
					format(string, sizeof(string),""WHITE"Are you sure you want to "SVRCLR"%s "WHITE"your business?", RBS(businessid));
    				ShowPlayerDialog(playerid,DIALOG_BIZLOCK,DIALOG_STYLE_MSGBOX,SERVER_DIALOG,string,"Unlock","Lock");
				}
			}
		}
        case DIALOG_BIZNAME:
		{
		    new businessid = GetNearbyBusinessEx(playerid);
            new string28[150];

			format(BusinessInfo[businessid][bName], 64, inputtext);
			format(string28,sizeof(string28), "You have set your business name to %s.", inputtext);
			SendClientMessage(playerid, COLOR_GREEN, string28);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET name = '%e' WHERE id = %i", BusinessInfo[businessid][bName], BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);

			ReloadBusiness(businessid);
		}
        case DIALOG_BIZSAFE:
        {
            if(!response)
            {
                if(!response)
                {
                    new businessid = GetNearbyBusinessEx(playerid);
                    new string[128];
                    format(string, sizeof(string),""WHITE"Enter the amount of money you want to withdraw your business vault.\n\t\t\t"SVRCLR"Current Vault Balance: $%s", number_format(BusinessInfo[businessid][bCash]));
			    	ShowPlayerDialog(playerid,DIALOG_WITHDRAW,DIALOG_STYLE_INPUT,SERVER_DIALOG,string,"Confirm","Cancel");
			    }
			}
			else
			{
			    new businessid = GetNearbyBusinessEx(playerid);
			    new string[128];
			    format(string, sizeof(string),""WHITE"Enter the amount of money you want to deposit your business vault.\n\t\t\t"SVRCLR"Current Vault Balance: $%s", number_format(BusinessInfo[businessid][bCash]));
		    	ShowPlayerDialog(playerid,DIALOG_DEPOSIT,DIALOG_STYLE_INPUT,SERVER_DIALOG,string,"Confirm","Cancel");
		    }
		}
		case DIALOG_WITHDRAW:
		{
		    new businessid = GetNearbyBusinessEx(playerid);
		    new string[128];
            if(!IsNumeric(inputtext))
		    {
      			format(string, sizeof(string),"{FF0000}ENTRY DECLINED: You must enter a number!\n"WHITE"Enter the amount of money you want to withdraw your business vault.\n\n\t\t\t"SVRCLR"Current Vault Balance: $%s", number_format(BusinessInfo[businessid][bCash]));
   				ShowPlayerDialog(playerid,DIALOG_WITHDRAW,DIALOG_STYLE_INPUT,SERVER_DIALOG,string,"Confirm","Cancel");
    		}
            new string28[128];
    		new money = strval(inputtext);
   			if(money > BusinessInfo[businessid][bCash]) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this much money in your business vault.");
    		BusinessInfo[businessid][bCash] -= money;
    		GivePlayerCash(playerid, money);

    		SendProximityMessage(playerid, 15.0, SERVER_COLOR, "**{C2A2DA} %s has withdrawn money from their business vault.", GetRPName(playerid));
			format(string28, sizeof(string28), " You have withdrawn $%s from your business vault, There is now $%s remaining", number_format(money), number_format(BusinessInfo[businessid][bCash]));
			SendClientMessage(playerid, COLOR_GREEN, string28);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);
		}
        case DIALOG_DEPOSIT:
		{
		    new businessid = GetNearbyBusinessEx(playerid);
		    new string[128];
            if(!IsNumeric(inputtext))
		    {
      			format(string, sizeof(string),"{FF0000}ENTRY DECLINED: You must enter a number!\n"WHITE"Enter the amount of money you want to withdraw your business vault.\n\n\t\t\t"SVRCLR"Current Vault Balance: $%s", number_format(BusinessInfo[businessid][bCash]));
   				ShowPlayerDialog(playerid,DIALOG_WITHDRAW,DIALOG_STYLE_INPUT,SERVER_DIALOG,string,"Confirm","Cancel");
    		}
            new string28[128];
    		new money = strval(inputtext);
   			if(money > PlayerInfo[playerid][pCash]) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this much money on you.");
    		BusinessInfo[businessid][bCash] += money;
    		GivePlayerCash(playerid, -money);

			format(string28, sizeof(string28), " You have deposit $%s from your business vault, There is now $%s available", number_format(money), number_format(BusinessInfo[businessid][bCash]));
			SendClientMessage(playerid, COLOR_GREEN, string28);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);
		}
        case DIALOG_MESSAGE:
		{
		    new businessid = GetNearbyBusinessEx(playerid);
            new string28[150];

			format(BusinessInfo[businessid][bMessage], 128, inputtext);
			format(string28,sizeof(string28), "You have set your business message to %s.", inputtext);
			SendClientMessage(playerid, COLOR_GREEN, string28);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET message = '%e' WHERE id = %i", BusinessInfo[businessid][bMessage], BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);

			ReloadBusiness(businessid);
		}
		case DIALOG_BIZLOCK:
		{
		    if(!response)
	    	{
	    	    new businessid = GetNearbyBusinessEx(playerid);

                if(!BusinessInfo[businessid][bLocked])
				{
    				BusinessInfo[businessid][bLocked] = 1;
    				GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
			    	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks their business door.", GetRPName(playerid));

			    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[businessid][bLocked], BusinessInfo[businessid][bID]);
					mysql_tquery(connectionID, queryBuffer);

					ReloadBusiness(businessid);
				}
			}
			else
			{
			    new businessid = GetNearbyBusinessEx(playerid);
			    BusinessInfo[businessid][bLocked] = 0;
			    GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks their business door.", GetRPName(playerid));

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[businessid][bLocked], BusinessInfo[businessid][bID]);
				mysql_tquery(connectionID, queryBuffer);

				ReloadBusiness(businessid);
			}
		}
		case DIALOG_TOP: { // Crimes, Rich, Level
			if(response) {
				switch(listitem)
				{
					case 0: mysql_tquery(connectionID, "SELECT crimes, username FROM users ORDER BY crimes DESC LIMIT 20", "OnTopListQuery", "ii", playerid, listitem);
					case 1: mysql_tquery(connectionID, "SELECT bank, username FROM users ORDER BY bank DESC LIMIT 20", "OnTopListQuery", "ii", playerid, listitem);
					case 2: mysql_tquery(connectionID, "SELECT hours, username FROM users ORDER BY hours DESC LIMIT 20", "OnTopListQuery", "ii", playerid, listitem);
				}
			}
		}
		case DIALOG_DLOCKER: {
			if(response) {
				ShowPlayerDialog(playerid, DIALOG_DGUN, DIALOG_STYLE_TABLIST_HEADERS, "Donator Gun Locker", "Weapon\tAmount\nKevlar Vest\t$10000\nFirst aid kit\t$250\nKatana\tFree\n9mm\t$2500\nMp5\t$2500\nShoutgun\t$250", "Buy", "Cancel");
			}
		}
		case DIALOG_DGUN: {
			if(response) {
				switch(listitem) {
					case 0:
					{
						if(PlayerInfo[playerid][pCash] >= 0)
						{
							SetScriptArmour(playerid, 100.0);
							GivePlayerCash(playerid, -10000);
							Dyuze(playerid, "Transaction", "You have bought a Kevlar Vest for $10000.");
						}
						else return SendClientMessage(playerid, COLOR_GREY, "You don't have cash.");
					}
					case 1:
					{
						if(PlayerInfo[playerid][pCash] >= 0)
						{
							SetPlayerHealth(playerid, 100);
							GivePlayerCash(playerid, -250);
							Dyuze(playerid, "Transaction", "You have bought a First aid kit for $250.");
						}
						else return SendClientMessage(playerid, COLOR_GREY, "You don't have cash.");
					}
					case 2:
					{
						if(PlayerInfo[playerid][pHours] < 2)
						{
							return SendClientMessage(playerid, COLOR_GREEN, "You need atleast 2 hours to get this weapon.");
						}
						if(PlayerHasWeapon(playerid, 8))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
					    GiveWeapon(playerid, 8);
					    Dyuze(playerid, "Transaction", "You have been given a free Katana from the VIP Locker.");
					}
					case 3:
					{
						if(PlayerInfo[playerid][pHours] < 2)
						{
							return SendClientMessage(playerid, COLOR_GREEN, "You need atleast 2 hours to get this weapon.");
						}
						if(PlayerHasWeapon(playerid, 22))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
					    GiveWeapon(playerid, 22);
					    Dyuze(playerid, "Transaction", "You have bought a 9mm for $2500");
					}
    		        case 4:
					{
						if(PlayerInfo[playerid][pHours] < 2)
						{
							return SendClientMessage(playerid, COLOR_GREEN, "You need atleast 2 hours to get this weapon.");
						}
						if(PlayerHasWeapon(playerid, 29))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
					    GiveWeapon(playerid, 29);
					    Dyuze(playerid, "Transaction", "You have bought a Mp5 for $2500");
					}
					case 5:
					{
						if(PlayerInfo[playerid][pHours] < 2)
						{
							return SendClientMessage(playerid, COLOR_GREEN, "You need atleast 2 hours to get this weapon.");
						}
						if(PlayerHasWeapon(playerid, 25))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
					    GiveWeapon(playerid, 25);
					    Dyuze(playerid, "Transaction", "You have bought a Shotgun for $2500");
					}

				}
			}
		}
 		case DIALOG_CREATEQUIZ:
		{
			if(response) {
				if(CreateQuiz == 0)
				{
				    strcpy(quizQuestion, inputtext);
				    CreateQuiz = 1;
	                ShowDialogToPlayer(playerid, DIALOG_CREATEQUIZ);
				}
				else if(CreateQuiz == 1)
				{
				    strcpy(quizAnswer, inputtext);
	                CreateQuiz = -1;
	                SAM(COLOR_LIGHTRED, "AdmCmd: %s has started a quiz.", GetRPName(playerid));
	                SMA(COLOR_LIGHTRED, "Quiz: %s Type (/answer) to answer", quizQuestion);
				}
			}
			else CreateQuiz = -1;

		}
		case DIALOG_NEWBWELCOME:
		{
		    if(response)
		    {
		        new count;
				foreach(new i : Player)
				{
					if(PlayerInfo[i][pHelper] > 0)
					{
					    count++;
					}
				}
				if(count > 0)
				{
		        	new string[30];
		        	format(string, sizeof(string), "Show me around Los Santos, I am new here.");
					strcpy(PlayerInfo[playerid][pHelpRequest], string, 128);
					SendHelperMessage(COLOR_GREEN, "** Help Request: New Player %s (ID:%d) is requesting a helper to show them around. **", GetRPName(playerid), playerid);

					PlayerInfo[playerid][pLastRequest] = gettime();
					SendClientMessage(playerid, COLOR_GREEN, "Your help request was sent to all helpers. Please wait for a response.");
				}
				else
				{
				    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "No Helpers Online", ""WHITE"Unfortunately there are no members of the helper team online.\nYou can also try /(n)ewbie, This is where most of the community can help you with simple questions such as 'Where is the Bank'.\nYou can also checkout "SERVER_URL" for beginner tutorials.", "Cancel", "");
				}
			}
		}
		case DIALOG_POINTLIST:
		{
		    if(response)
		    {
		        if(strlen(psstring) < 5)
		        {
 					//SendClientMessage(playerid, COLOR_GREEN, "Please use /tog turfs to enable turf bounds.");
				}
				else
				{
				    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, ""SVRCLR"Point List"WHITE" ("REVISION")", psstring, "", "Cancel");
				}
			}
		}
		case DIALOG_TURFLIST:
		{
		    if(response)
		    {
		        if(strlen(tsstring) < 5)
		        {
 					//SendClientMessage(playerid, COLOR_GREEN, "Please use /tog turfs to enable turf bounds.");
				}
				else
				{
				    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, ""SVRCLR"Turf List"WHITE" ("REVISION")", tsstring, "", "Cancel");
				}
			}
		}
    	case DIALOG_RULES:
		{
  			if(response)
      		{
      		    new sstring[2048];
				switch(listitem)
				{
				    case 0: // SERVER
				    {
				        format(sstring, sizeof(sstring), ""SVRCLR"- First of all, Always roleplay. Your character's behavior needs to be as realistic, and close to real life as possible! -\n");
						strcat(sstring, ""WHITE"1. "SVRCLR"You can't Metagaming! Don't mix in-character (IC) and out-of-character (OOC) chat/information. IC chat is the default chat, OOC is used by typing /b!\n");
						strcat(sstring, ""WHITE"2. "SVRCLR"You can't Killing on sight (KOS). Killing a player on sight without a word or any attempt to roleplay is not allowed and is prisonable!\n");
						strcat(sstring, ""WHITE"3. "SVRCLR"You can't Revenge killing (RK). If a player critically injured you, you are not allowed to go back to kill them! After hospital, you lose all memory of the last 30 minutes!\n");
						strcat(sstring, ""WHITE"4. "SVRCLR"You can't Powergaming! Impossible roleplay, meaning anything that is cannot be done in real life is forbidden! Do not force roleplay on others!\n");
						strcat(sstring, ""WHITE"5. "SVRCLR"You can't Car ramming or Car parking! Do not repeatedly ram other people with your car, and don't park on top of a player to kill them!\n");
						strcat(sstring, ""WHITE"6. "SVRCLR"You can't Logging to avoid! Never log out or alt-tab out of game to avoid death, arrest or prison!\n");
						strcat(sstring, ""WHITE"Note: "SVRCLR"This is a short version of our server rulebook. Please visit  to see a full list of "SERVER_URL"");
				        ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, ""WHITE"Server Rules", sstring, "Ok","");
				    }
				    case 1: // TRAFFIC
				    {
				        format(sstring, sizeof(sstring), ""WHITE"1. "SVRCLR"Drive on the right side of the road at all times or else you will get punishment.\n");
				        strcat(sstring, ""WHITE"2. "SVRCLR"Yield to emergency vehicles.\n");
				        strcat(sstring, ""WHITE"3. "SVRCLR"Move over and slow down for stopped emergency vehicles.\n");
				        strcat(sstring, ""WHITE"4. "SVRCLR"Turn your headlights on at night. Type (/lights) to turn it.\n");
				        strcat(sstring, ""WHITE"5. "SVRCLR"Wear your seatbelt or helmet always. Type (/seatbelt) to wear it.\n");
				        strcat(sstring, ""WHITE"6. "SVRCLR"Traffic lights are synced Red is for Stop, Yellow is for Slow down and Green is for Go\n");
				        strcat(sstring, ""WHITE"7. "SVRCLR"Only follow traffic lights above a junction. (Marked with a solid white line)\n");
				        strcat(sstring, ""WHITE"8. "SVRCLR"Remain at a safe distance from other vehicles when driving, atleast 3 car lengths\n");
				        strcat(sstring, ""WHITE"9. "SVRCLR"Only follow traffic lights above a junction. (Marked with a solid white line)\n");
				        strcat(sstring, ""WHITE"10. "SVRCLR"Pedistrians always have the right of way, regardless of the situation.\n");
				        strcat(sstring, ""WHITE"11. "SVRCLR"Drive how you would in real life, dont be a moron.\n");
				        strcat(sstring, ""SVRCLR"- If you fail at driving you will be jailed or banned. -\n");
				        strcat(sstring, ""WHITE"Note: "SVRCLR"This is a short version of our traffic laws. Please visit  to see a full list of "SERVER_URL"");
				    	ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, ""WHITE"Traffic Rules", sstring, "Ok","");
				    }
				    case 2: // SPEED
				    {
				        format(sstring, sizeof(sstring), ""SVRCLR"- This server has limitations. -\n");
				        strcat(sstring, ""WHITE"1. "SVRCLR"50 MPH if you are in the City.\n");
				        strcat(sstring, ""WHITE"2. "SVRCLR"70 MPH on the County roads.\n");
				        strcat(sstring, ""WHITE"3. "SVRCLR"90 MPH on the Highways and Interstates.\n");
				        strcat(sstring, ""WHITE"4. "SVRCLR"Box trucks cannot exceed 50 MPH.\n");
				        strcat(sstring, ""WHITE"5. "SVRCLR"Any vehicles with 3 or more axles aren't allowed to go more than 55 mph. Regardless of roadway limits.\n");
				        strcat(sstring, ""WHITE"Note: "SVRCLR"This is a short version of our speed laws. Please visit  to see a full list of "SERVER_URL"");
				        ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, ""WHITE"Speed Rules", sstring, "Ok","");
				    }
				}
      		}
		}
		case DIALOG_PSTASH:
	    {
	        if(response)
	        {
	            if(listitem == 0)
	            {
					PlayerInfo[playerid][pPSSelected] = 0;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 1)
				{
					PlayerInfo[playerid][pPSSelected] = 1;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 2)
				{
	                new string[128];
                    format(string, sizeof(string), "M4(%i/10)\nAK(%i/10)\nMP5(%i/10)\nUzi(%i/10)\n9mm Pistol(%i/10)\nDeagle(%i/10)", PlayerInfo[playerid][pPSM4], PlayerInfo[playerid][pPSAK],  PlayerInfo[playerid][pPSMP5], PlayerInfo[playerid][pPSUZI], PlayerInfo[playerid][pPS9MM], PlayerInfo[playerid][pPSDEAGLE]);
					ShowPlayerDialog(playerid, DIALOG_PSWEAPONS, DIALOG_STYLE_LIST, "Public Locker", string, "Select", "Close");
				}
				else if(listitem == 3)
				{
	                new string[128];
                    format(string, sizeof(string), "Pot(%i/2000)\nMeth(%i/2000)\nCrack(%i/2000)", PlayerInfo[playerid][pPSPOT], PlayerInfo[playerid][pPSMETH],  PlayerInfo[playerid][pPSCRACK]);
					ShowPlayerDialog(playerid, DIALOG_PSDRUGS, DIALOG_STYLE_LIST, "Public Locker", string, "Select", "Close");
				}
	        }
	    }
		case DIALOG_PSDRUGS:
		{
			if(response)
			{
				if(listitem == 0)
				{
					PlayerInfo[playerid][pPSSelected] = 8;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 1)
				{
					PlayerInfo[playerid][pPSSelected] = 9;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 2)
				{
	                PlayerInfo[playerid][pPSSelected] = 10;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
			}
		}
		case DIALOG_PSWEAPONS:
		{
			if(response)
			{
				if(listitem == 0)
				{
					PlayerInfo[playerid][pPSSelected] = 2;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 1)
				{
					PlayerInfo[playerid][pPSSelected] = 3;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 2)
				{
	                PlayerInfo[playerid][pPSSelected] = 4;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 3)
				{
	                PlayerInfo[playerid][pPSSelected] = 5;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 4)
				{
	                PlayerInfo[playerid][pPSSelected] = 6;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
				else if(listitem == 5)
				{
	                PlayerInfo[playerid][pPSSelected] = 7;
	                ShowPlayerDialog(playerid, DIALOG_PSDW, DIALOG_STYLE_LIST, "Public Locker", "Deposit\nWithdraw", "Select", "Close");
				}
			}
		}
		case DIALOG_PSDW:
	    {
	        if(response)
	        {
	            if(listitem == 0)
	            {
					if(PlayerInfo[playerid][pPSSelected] == 0)
					{
						if(PlayerInfo[playerid][pPSCash] == 100000000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "Your Public Locker cash is already full");
						}
						else
						{
							ShowPlayerDialog(playerid, DIALOG_PSCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
						}
					}
					else if(PlayerInfo[playerid][pPSSelected] == 1)
					{
						if(PlayerInfo[playerid][pPSDCash] == 100000000)
						{
							SendClientMessage(playerid, COLOR_ERROR, "Your Public Locker dirty cash is already full");
						}
						else
						{
							ShowPlayerDialog(playerid, DIALOG_PSDCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
						}
					}
					else if(PlayerInfo[playerid][pPSSelected] == 2)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 31)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the M4.");
	                    }
						if(PlayerInfo[playerid][pPSM4] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your M4 slot is full");
						}

	                   
						
						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPSM4] = PlayerInfo[playerid][pPSM4] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psm4 = %i WHERE uid = %i", PlayerInfo[playerid][pPSM4], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 3)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 30)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the AK.");
	                    }
						if(PlayerInfo[playerid][pPSAK] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your AK slot is full");
						}

	                    
						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPSAK] = PlayerInfo[playerid][pPSAK] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psak = %i WHERE uid = %i", PlayerInfo[playerid][pPSAK], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 4)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 29)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the MP5.");
	                    }
						if(PlayerInfo[playerid][pPSMP5] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your MP5 slot is full");
						}
					    
						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPSMP5] = PlayerInfo[playerid][pPSMP5] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psmp5 = %i WHERE uid = %i", PlayerInfo[playerid][pPSMP5], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 5)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 28)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the Uzi.");
	                    }
						if(PlayerInfo[playerid][pPSUZI] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Uzi slot is full");
						}

					
						
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPSUZI] = PlayerInfo[playerid][pPSUZI] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psuzi = %i WHERE uid = %i", PlayerInfo[playerid][pPSUZI],  PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 6)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 23)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the 9MM Pistol.");
	                    }
						if(PlayerInfo[playerid][pPS9MM] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your 9MM Pistol slot is full");
						}

	                    
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPS9MM] = PlayerInfo[playerid][pPS9MM] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ps9mm = %i WHERE uid = %i", PlayerInfo[playerid][pPS9MM], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 7)
					{
						new weaponid = GetScriptWeapon(playerid);

	                    if(weaponid != 24)
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the Deagle.");
	                    }
						if(PlayerInfo[playerid][pPS9MM] == 10)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Deagle slot is full");
						}

	                    
						RemovePlayerWeaponEx(playerid, weaponid);
						
						PlayerInfo[playerid][pPSDEAGLE] = PlayerInfo[playerid][pPSDEAGLE] + 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psdeagle = %i  WHERE uid = %i", PlayerInfo[playerid][pPSDEAGLE], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 8)
					{
						if(PlayerInfo[playerid][pPSPOT] == 2000)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker Pot is already full");
						}
						else
						{
							ShowPlayerDialog(playerid, DIALOG_PSPOTINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
						}
					}
					else if(PlayerInfo[playerid][pPSSelected] == 9)
					{
						if(PlayerInfo[playerid][pPSMETH] == 2000)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker Meth is already full");
						}
						else
						{
							ShowPlayerDialog(playerid, DIALOG_PSMEINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
						}
					}
					else if(PlayerInfo[playerid][pPSSelected] == 10)
					{
						if(PlayerInfo[playerid][pPSCRACK] == 2000)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker Crack is already full");
						}
						else
						{
							ShowPlayerDialog(playerid, DIALOG_PSCRINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
						}
					}
				}
				else if(listitem == 1)
				{
					if(PlayerInfo[playerid][pPSSelected] == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_PSCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
					}
					else if(PlayerInfo[playerid][pPSSelected] == 1)
					{
						ShowPlayerDialog(playerid, DIALOG_PSDCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
					}
					else if(PlayerInfo[playerid][pPSSelected] == 2)
					{
						if(PlayerInfo[playerid][pPSM4] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your M4 slot is empty");
						}
						if(PlayerHasWeapon(playerid, 31))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 31);
						PlayerInfo[playerid][pPSM4] = PlayerInfo[playerid][pPSM4] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psm4 = %i WHERE uid = %i", PlayerInfo[playerid][pPSM4], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 3)
					{
						if(PlayerInfo[playerid][pPSAK] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your AK slot is empty");
						}
						if(PlayerHasWeapon(playerid, 30))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 30);
						PlayerInfo[playerid][pPSAK] = PlayerInfo[playerid][pPSAK] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psak = %i WHERE uid = %i", PlayerInfo[playerid][pPSAK], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 4)
					{
						if(PlayerInfo[playerid][pPSMP5] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your MP5 slot is empty");
						}
						if(PlayerHasWeapon(playerid, 29))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 29);
						PlayerInfo[playerid][pPSMP5] = PlayerInfo[playerid][pPSMP5] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psmp5 = %i WHERE uid = %i", PlayerInfo[playerid][pPSMP5], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 5)
					{
						if(PlayerInfo[playerid][pPSUZI] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Uzi slot is empty");
						}
						if(PlayerHasWeapon(playerid, 28))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 28);
						PlayerInfo[playerid][pPSUZI] = PlayerInfo[playerid][pPSUZI] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET a = %i WHERE uid = %i", PlayerInfo[playerid][pPSUZI], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 6)
					{
						if(PlayerInfo[playerid][pPS9MM] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your 9MM Pistol slot is empty");
						}
						if(PlayerHasWeapon(playerid, 23))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 23);
						PlayerInfo[playerid][pPS9MM] = PlayerInfo[playerid][pPS9MM] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ps9mm = %i WHERE uid = %i", PlayerInfo[playerid][pPS9MM], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 7)
					{
						if(PlayerInfo[playerid][pPSDEAGLE] == 0)
						{
							return SendClientMessage(playerid, COLOR_SYNTAX, "Your Deagle slot is empty");
						}
						if(PlayerHasWeapon(playerid, 24))
	                    {
	                        return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}
						
						GiveWeapon(playerid, 24);
						PlayerInfo[playerid][pPSDEAGLE] = PlayerInfo[playerid][pPSDEAGLE] - 1;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psdeagle = %i WHERE uid = %i", PlayerInfo[playerid][pPSDEAGLE], PlayerInfo[playerid][pID]);
				        mysql_tquery(connectionID, queryBuffer);
					}
					else if(PlayerInfo[playerid][pPSSelected] == 8)
					{
						ShowPlayerDialog(playerid, DIALOG_PSPOTWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount of pot you would like to withdraw", "Withdraw", "Cancel");
					}
					else if(PlayerInfo[playerid][pPSSelected] == 9)
					{
						ShowPlayerDialog(playerid, DIALOG_PSMEWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount of meth you would like to withdraw", "Withdraw", "Cancel");
					}
					else if(PlayerInfo[playerid][pPSSelected] == 10)
					{
						ShowPlayerDialog(playerid, DIALOG_PSCRWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount of crack you would like to withdraw", "Withdraw", "Cancel");
					}
				}
	        }
	    }
		case DIALOG_PSCINPUT:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pCash])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much money.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if((amount + PlayerInfo[playerid][pPSCash]) > 100000000)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker maximum capacity is 100000000.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}

				PlayerInfo[playerid][pPSCash] += amount;
				GivePlayerCash(playerid, -amount);
				
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pscash = %i WHERE uid = %i", PlayerInfo[playerid][pPSCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
				
		    }
		}
		case DIALOG_PSCWITH:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPSCash])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker didn't have that much money.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}

				PlayerInfo[playerid][pPSCash] -= amount;
				PlayerInfo[playerid][pCash] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pscash = %i WHERE uid = %i", PlayerInfo[playerid][pPSCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSDCINPUT:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSDCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSDCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pDirtyCash])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much dirty cash");
				    return ShowPlayerDialog(playerid, DIALOG_PSDCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if((amount + PlayerInfo[playerid][pPSDCash]) > 100000000)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker maximum capacity is 100000000.");
				    return ShowPlayerDialog(playerid, DIALOG_PSDCINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}

				PlayerInfo[playerid][pPSDCash] += amount;
				PlayerInfo[playerid][pDirtyCash]  -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psdcash = %i WHERE uid = %i", PlayerInfo[playerid][pPSDCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSDCWITH:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSDCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSDCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPSDCash])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker didn't have that much dirty money.");
				    return ShowPlayerDialog(playerid, DIALOG_PSDCWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}

				PlayerInfo[playerid][pPSDCash]  -= amount;
				PlayerInfo[playerid][pDirtyCash] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psdcash = %i WHERE uid = %i", PlayerInfo[playerid][pPSDCash], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSPOTINPUT:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSPOTINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSPOTINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPot])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much pot");
				    return ShowPlayerDialog(playerid, DIALOG_PSPOTINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if((amount + PlayerInfo[playerid][pPSPOT]) > 2000)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker maximum capacity is 2000.");
				    return ShowPlayerDialog(playerid, DIALOG_PSPOTINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}

				PlayerInfo[playerid][pPSPOT] = PlayerInfo[playerid][pPSPOT] + amount;
				PlayerInfo[playerid][pPot] = PlayerInfo[playerid][pPot] - amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pspot = %i WHERE uid = %i", PlayerInfo[playerid][pPSPOT], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSMEINPUT:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSMEINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSMEINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pMeth])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much meth");
				    return ShowPlayerDialog(playerid, DIALOG_PSMEINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if((amount + PlayerInfo[playerid][pPSMETH]) > 2000)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker maximum capacity is 2000.");
				    return ShowPlayerDialog(playerid, DIALOG_PSMEINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}

				PlayerInfo[playerid][pPSMETH] = PlayerInfo[playerid][pPSMETH] + amount;
				PlayerInfo[playerid][pMeth] = PlayerInfo[playerid][pMeth] - amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psmeth = %i WHERE uid = %i", PlayerInfo[playerid][pPSMETH], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSCRINPUT:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSCRINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCRINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pCrack])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much crack");
				    return ShowPlayerDialog(playerid, DIALOG_PSCRINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}
				if((amount + PlayerInfo[playerid][pPSCRACK]) > 2000)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker maximum capacity is 2000.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCRINPUT, DIALOG_STYLE_INPUT, "Deposit", "Enter the amount you would like to deposit", "Deposit", "Cancel");
				}

				PlayerInfo[playerid][pPSCRACK] = PlayerInfo[playerid][pPSCRACK] + amount;
				PlayerInfo[playerid][pCrack] = PlayerInfo[playerid][pCrack] - amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pscrack = %i WHERE uid = %i", PlayerInfo[playerid][pPSCRACK], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSPOTWITH:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSPOTWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSPOTWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPSPOT])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker didn't have that much pot.");
				    return ShowPlayerDialog(playerid, DIALOG_PSPOTWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}

				PlayerInfo[playerid][pPSPOT] = PlayerInfo[playerid][pPSPOT] - amount;
				PlayerInfo[playerid][pPot] = PlayerInfo[playerid][pPot] + amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pspot = %i WHERE uid = %i", PlayerInfo[playerid][pPSPOT], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSMEWITH:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSMEWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSMEWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPSMETH])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker didn't have that much meth.");
				    return ShowPlayerDialog(playerid, DIALOG_PSMEWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}

				PlayerInfo[playerid][pPSMETH] = PlayerInfo[playerid][pPSMETH] - amount;
				PlayerInfo[playerid][pMeth] = PlayerInfo[playerid][pMeth] + amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET psmeth = %i WHERE uid = %i", PlayerInfo[playerid][pPSMETH], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_PSCRWITH:
		{
		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PSCRWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below 0.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCRWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				if(amount > PlayerInfo[playerid][pPSCRACK])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your Public Locker didn't have that much crack.");
				    return ShowPlayerDialog(playerid, DIALOG_PSCRWITH, DIALOG_STYLE_INPUT, "Withdraw", "Enter the amount you would like to withdraw", "Withdraw", "Cancel");
				}

				PlayerInfo[playerid][pPSCRACK] = PlayerInfo[playerid][pPSCRACK] - amount;
				PlayerInfo[playerid][pCrack] = PlayerInfo[playerid][pCrack] + amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pscrack = %i WHERE uid = %i", PlayerInfo[playerid][pPSCRACK], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
		    }
		}
		case DIALOG_REMOVEPVEH:
		{
      		if(response)
		    {
		        new targetid = PlayerInfo[playerid][pRemoveFrom];

				if(targetid == INVALID_PLAYER_ID)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "The player has disconnected. You can't remove their vehicles now.");
				}

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerInfo[targetid][pID], listitem);
				mysql_tquery(connectionID, queryBuffer, "OnVerifyRemoveVehicle", "ii", playerid, targetid);
		    }
		}
	    case DIALOG_LOCATE:
		{
  			if(response)
      		{
				switch(listitem)
				{
				    case 0: // JOBS
				    {
				    	ShowPlayerDialog(playerid, DIALOG_LOCATELIST1, DIALOG_STYLE_LIST, "Select Destination", "Signal Job     {00FF00} LEGAL\nTrucker     {FF0000} ILLEGAL\nMiner     {00FF00} LEGAL\nOilExpo     {00FF00} LEGAL\nAtm Job     {00ff00} LEGAL\nFruitPicker     {00ff00} LEGAL\nCoroner Job     {00ff00} LEGAL\nFarmer     {00ff00} LEGAL\nSandalWood     {FF0000}ILLEGAL", "Select", "Close");
				    }
				    case 1: // STORES
				    {
				    	ShowPlayerDialog(playerid, DIALOG_LOCATELIST2, DIALOG_STYLE_LIST, "Select Destination", "U-Tools\nGun Shop\nDress Shop\nGym\nFood Shop\nSim Center", "Select", "Close");
				    }
				    case 2: // GENERAL LOCATIONS
				    {
				    	ShowPlayerDialog(playerid, DIALOG_LOCATELIST3, DIALOG_STYLE_LIST, "Select Destination", "DMV\nImpound\nBank\nFleeca Location\nCityHall LS\nMechanic Autoparts\nDealership\nJewellery\nPublicLocker\nVotting Booth\nRdc", "Select", "Close");
				    }
			    	case 3: // Find Points
					{
					    new string[34 * MAX_POINTS];
					    for(new x = 0; x < MAX_POINTS; x++)
						{
						    if(PointInfo[x][pExists]) {
					    		strcat(string, PointInfo[x][pName]);
								strcat(string, "\n");
							}
						}
						if(strlen(string) > 2) {
							ShowPlayerDialog(playerid, DIALOG_LOCATEPOINTS, DIALOG_STYLE_LIST, "Select Destination", string, "Select", "Close");
						} else {
          					SendClientMessage(playerid, COLOR_WHITE, "Unable to locate any new locations.");
						}
					}
					case 4: // Find Turfs
					{
					    new string[34 * MAX_TURFS];
					    for(new x = 0; x < MAX_TURFS; x++)
						{
						    if(TurfInfo[x][tExists]) {
					    		strcat(string, TurfInfo[x][tName]);
								strcat(string, "\n");
							}
						}
						if(strlen(string) > 2) {
							ShowPlayerDialog(playerid, DIALOG_LOCATETURFS, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
						} else {
						    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "GPS - Signal Lost", "Unable to locate any new locations.", "Cancel", "");
						}
					}
					case 5: //Fuel Bunk
					{
							ShowPlayerDialog(playerid, DIALOG_ILLEGALLOC, DIALOG_STYLE_LIST, "Select Destination", "Car Rob\nIllegalRevive\nBlackMarket\nBlackIndustry\nCraft", "Select", "Close");
					}
				    
				
				}
      		}
		}
		case DIALOG_LOCATELISTC:
		{
		    if(response)
		    {
				LocateMethod(playerid, inputtext);
		    }
		}
		case DIALOG_LOCATETURFS:
		{
			if(response)
			{
			    for(new i = 0; i < MAX_TURFS; i ++)
			    {
			        if(strfind(TurfInfo[i][tName], inputtext) != -1)
			        {
				   	 	PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
				    	SetPlayerCheckpoint(playerid, TurfInfo[i][tMinX], TurfInfo[i][tMinY], TurfInfo[i][tHeight], 3.0);
				    	SM(playerid, COLOR_WHITE, "** Checkpoint marked at the location of %s.", TurfInfo[i][tName]);
				    	break;
					}
				}
			}
		}
		case DIALOG_LOCATEPOINTS:
		{
		    if(response)
			{
			    if(PointInfo[listitem][pExists])
			    {
	                PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
				    SetPlayerCheckpoint(playerid, PointInfo[listitem][pPointX], PointInfo[listitem][pPointY], PointInfo[listitem][pPointZ], 3.0);
				    SM(playerid, COLOR_WHITE, "** Checkpoint marked at the location of %s.", PointInfo[listitem][pName]);
			    }
			}
		}
		case DIALOG_LOCATELIST1:
		{
			if(response)
			{
			    switch(listitem)
			    {
				    case 0:
						LocateMethod(playerid,"signaljob");
					case 1:
					    LocateMethod(playerid,"Trucker");
	                case 2:
					    LocateMethod(playerid,"Miner");
					case 3:
					    LocateMethod(playerid,"oilexporter");
                    case 4:
					    LocateMethod(playerid,"atmjob");
			        case 5:
					    LocateMethod(playerid,"fruit");
	                case 6:
					    LocateMethod(playerid,"coroner");
				    case 7:
						LocateMethod(playerid,"farmer");
					case 8:
						LocateMethod(playerid,"sandal");

				}
			}
		}
		case DIALOG_LOCATELIST2:
		{
		    if(response)
			{
			    switch(listitem)
			    {
				    case 0:
						LocateMethod(playerid,"7/11");
				    case 1:
				        LocateMethod(playerid,"GunShop");
				  	case 2:
					    LocateMethod(playerid,"dressshop");
				    case 3:
				        LocateMethod(playerid,"Gym");
				    case 4:
				        LocateMethod(playerid,"foodshop");
					case 5:
				        LocateMethod(playerid,"sim");
				}
			}
		}
		case DIALOG_ILLEGALLOC:
		{
		    if(response)
			{
			    switch(listitem)
			    {
				    case 0:
						LocateMethod(playerid,"Carrob");
				    case 1:
				        LocateMethod(playerid,"irev");
     			    case 2:
					    LocateMethod(playerid,"Blackmarket");
                    case 3:
					    LocateMethod(playerid,"blackmarket2");
				    case 4:
					    LocateMethod(playerid,"craft");
				}
			}
		}
		case DIALOG_LOCATELIST3:
		{
		    if(response)
			{
			    switch(listitem)
			    {

                    case 0:
						LocateMethod(playerid,"DMV");
					case 1:
						LocateMethod(playerid,"Impound");
                    case 2:
						LocateMethod(playerid,"Bank");
					case 3:
					    LocateMethod(playerid,"fleeca");
                    case 4:
					    LocateMethod(playerid,"cityhallls");
					case 5:
					    LocateMethod(playerid,"Mechanic Autoparts");
					case 6:
					    LocateMethod(playerid,"Dealership");
                    case 7:
					    LocateMethod(playerid,"jewel");
                    case 8:
                        LocateMethod(playerid,"publiclocker");
                    case 9:
                        LocateMethod(playerid,"vote");
					case 10:
					    LocateMethod(playerid,"RDC");

				}
			}
		}
		case DIALOG_LOCATEWASHMONEY:
		{
		    if(response)
			{
			    switch(listitem)
			    {
			        case 0:
			            LocateMethod(playerid,"Els");
			        case 1:
			            LocateMethod(playerid,"Ps");
			        case 2:
			            LocateMethod(playerid,"Gp");
			        case 3:
			            LocateMethod(playerid,"Vb");
			        case 4:
                        LocateMethod(playerid,"Cm");
				}
			}
		}
		case DIALOG_SIDEJOB:
		{
		    if(response)
			{
			    switch(listitem)
			    {
			        case 0:
			            LocateMethod(playerid,"meatchopper");
					case 1:
					    LocateMethod(playerid,"harvester");
					case 2:
					    LocateMethod(playerid,"lumberjack");
				}
			}
		}
	    case DIALOG_REGISTER:
    	{
	        if(response)
	        {
	            if(isnull(inputtext))
	            {
	                ShowDialogToPlayer(playerid, DIALOG_REGISTER);
	                return 1;
				}
	            if(strlen(inputtext) < 4)
	            {
	                SendClientMessage(playerid, COLOR_LIGHTRED, "** Please choose a password containing at least 4 characters.");
	                ShowDialogToPlayer(playerid, DIALOG_REGISTER);
	                return 1;
	            }

	            WP_Hash(PlayerInfo[playerid][pPassword], 129, inputtext);
	            
			}
			else
			{
			    KickPlayer(playerid);
				SAM(COLOR_RED, "%s Was Kicked NO PASS", GetRPName(playerid));
			}
		}
		case DIALOG_CONFIRMPASS:
		{
		    if(response)
		    {
		        if(isnull(inputtext))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD, ""SVRCLR"Confirmation", ""WHITE"Please repeat your account password for verification:", "Submit", "Back");
				}

				WP_Hash(PlayerInfo[playerid][pPassword1],129, inputtext);
				if(strcmp(PlayerInfo[playerid][pPassword], PlayerInfo[playerid][pPassword1]))
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
                   // PlayerText_InterpolateColor(playerid, REGISTER[playerid][8], 0xFF0000FF, 500, EASE_OUT_QUAD);
                    //PlayerText_InterpolateColor(playerid, REGISTER[playerid][9], 0xFF0000FF, 500, EASE_OUT_QUAD);
                    //PlayerText_InterpolateColor(playerid, REGISTER[playerid][11], 0xFF0000FF, 500, EASE_OUT_QUAD);
                    PlayerInfo[playerid][pRegpass] = 0;
				    SendClientMessage(playerid, COLOR_LIGHTRED, "** Your repeated password does not match your chosen password. Please try again.");
				}
				else
				{
                    PlayerInfo[playerid][pRegpass] = 2;
				  	PlayerTextDrawHide(playerid,REGISTER[playerid][5]);
					PlayerTextDrawHide(playerid,REGISTER[playerid][8]);
					PlayerTextDrawHide(playerid,REGISTER[playerid][9]);
					PlayerTextDrawHide(playerid,REGISTER[playerid][11]);

					PlayerTextDrawColour(playerid, REGISTER[playerid][5],548580095);
					PlayerTextDrawColour(playerid, REGISTER[playerid][8],548580095);
					PlayerTextDrawColour(playerid, REGISTER[playerid][9],548580095);
					PlayerTextDrawColour(playerid, REGISTER[playerid][11],548580095);

					PlayerTextDrawShow(playerid,REGISTER[playerid][5]);
					PlayerTextDrawShow(playerid,REGISTER[playerid][8]);
					PlayerTextDrawShow(playerid,REGISTER[playerid][9]);
					PlayerTextDrawShow(playerid,REGISTER[playerid][11]);
				  //PlayerText_InterpolateColor(playerid, REGISTER[playerid][5], 548580095, 300, EASE_OUT_QUAD);
                  //PlayerText_InterpolateColor(playerid, REGISTER[playerid][8], 548580095, 300, EASE_OUT_QUAD);
                  //PlayerText_InterpolateColor(playerid, REGISTER[playerid][9], 548580095, 300, EASE_OUT_QUAD);
                  //PlayerText_InterpolateColor(playerid, REGISTER[playerid][11], 548580095, 300, EASE_OUT_QUAD);
				}
		    }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_REGISTER);
	        }
	    }
	    case DIALOG_TWEET:
		{
			if ( DarKTwtInfo[rTwtTime] > 0)
			{
				return SCMf(playerid, COLOR_ERROR, "[ERROR]{ffffff} You can post tweet for every 30 seconds.Wait for %i second to post new tweet.", DarKTwtInfo[rTwtTime]);
			}
			if(response)
			{
			    strcpy(tweet, inputtext);
                //SAM(COLOR_WHITE, ""WHITE"%s"TWEET" has tweeted"WHITE": %s", GetRPName(playerid), inputtext);
				new twt_msg[128];
			    format(twt_msg, sizeof twt_msg, "```%s @%s[%d]: %s```", GetPlayerNameEx(playerid), playerid);
	            SendClientMessageToAll(COLOR_ORANGE,  twt_msg);
	            SendDiscordMessage(24, twt_msg);
				SMA(COLOR_AQUA, "[TWEET]: @%s  "WHITE" %s, ", GetRPName(playerid),tweet);

				DarKTwtInfo[rTwtTime] +=30;
			}



		}
	   	case DIALOG_LOGIN:
	    {
	        if(response)
	        {
	            

				if(isnull(inputtext))
				{
				    ShowDialogToPlayer(playerid, DIALOG_LOGIN);
				    return 1;
	 			}
	 			 
	            
				DynamicPlayerTextDrawSetString(playerid, LOGINTD[playerid][48], "xxxxxxxx");
	            WP_Hash(PlayerInfo[playerid][pPassword], 129, inputtext);
			
	        }
	        else
	        {
				KickPlayer(playerid);
				SAM(COLOR_RED, "%s Was Kicked NO pass", GetRPName(playerid));
			}
	    }
	    case DIALOG_GENDER:
	    {
	        if(response)
	        {
	            if(listitem == 0)
	            {
	                PlayerInfo[playerid][pGender] = 1;
	                PlayerInfo[playerid][pSkin] = 299;
	                SendClientMessage(playerid, COLOR_LIGHTRED, "Alright, so you're a Male. Please enter the approximate age of your character.");
				}
				else if(listitem == 1)
				{
	                PlayerInfo[playerid][pGender] = 2;
	                PlayerInfo[playerid][pSkin] = 12;
	                SendClientMessage(playerid, COLOR_LIGHTRED, "Alright, so you're a Female. Please enter the approximate age of your character.");
				}
		        ShowDialogToPlayer(playerid, DIALOG_AGE);
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_GENDER);
			}
	    }
	    case DIALOG_AGE:
	    {
	        if(response)
	        {
	            new age = strval(inputtext);

				if(!(13 <= age <= 99))
				{
				    ShowDialogToPlayer(playerid, DIALOG_AGE);
				    SendClientMessage(playerid, COLOR_SYNTAX, "You may only enter a number from 13 to 99. Please try again.");
				    return 1;
	            }

	            PlayerInfo[playerid][pAge] = age;
	            PlayerInfo[playerid][pReferralUID] = 0;

	            SM(playerid, COLOR_LIGHTRED, "Alright, so you're %s and %i years old. Now you will need to pick a referrer.", (PlayerInfo[playerid][pGender] == 2) ? ("Female") : ("Male"), age);
	            ShowDialogToPlayer(playerid, DIALOG_REFERRAL);
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_AGE);
			}
	    }
	    case DIALOG_REFERRAL:
	    {
	        if(response)
	        {
	            if(isnull(inputtext) || strlen(inputtext) > 24)
	            {
	                return ShowDialogToPlayer(playerid, DIALOG_REFERRAL);
				}
				if(!strcmp(inputtext, GetPlayerNameEx(playerid)))
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "You can't put down your own name as a referral.");
				    return ShowDialogToPlayer(playerid, DIALOG_REFERRAL);
				}

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip, uid FROM users WHERE username = '%e'", inputtext);
				mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CHECK_REFERRAL, playerid);
	        }
	        else
	        {
				PlayerInfo[playerid][pTutorial] = 1;
				PlayerInfo[playerid][pTutorialTimer] = SetTimerEx("PlayerSpawn", 3000, false, "i", playerid);
			}
	    }
		#if defined Christmas
			case DIALOG_CAROL:
			{
				if(response)
				{
					new badingsiseanz = Random(3,10);
					if(isnull(inputtext) || strlen(inputtext) < 4)
					{
						SendClientMessage(playerid, COLOR_SYNTAX, "You have failed sing the lyrics.");
						PlayerInfo[playerid][pLastCarolTime] = 30;
						return 1;
					}
					if(!strcmp(inputtext, ReturnLyrics(CarolLyrics[playerid])))
					{
						SM(playerid, SERVER_COLOR, "You have successfully sung the lyrics! "GREEN"You recieved %i candy.", badingsiseanz);
						PlayerInfo[playerid][pCandy] += badingsiseanz;
						PlayerInfo[playerid][pLastCarolTime] = 30;
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_SYNTAX, "You have failed sing the lyrics.");
						PlayerInfo[playerid][pLastCarolTime] = 30;
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "You have failed sing the lyrics.");
					PlayerInfo[playerid][pLastCarolTime] = 30;
					return 1;
				}
			}
		#endif
	    case DIALOG_INTERIORS:
	    {
	        if(response)
	        {
	            TeleportToCoords(playerid, interiorArray[listitem][intX], interiorArray[listitem][intY], interiorArray[listitem][intZ], interiorArray[listitem][intA], interiorArray[listitem][intID], GetPlayerVirtualWorld(playerid));
	            GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);
	        }
	    }
	    case DIALOG_BUYFURNITURE1:
	    {
	        new houseid = GetInsideHouse(playerid);

		    if(houseid == -1 || !HasFurniturePerms(playerid, houseid))
			{
				return 0;
			}

	   	    if(response)
	        {
				PlayerInfo[playerid][pCategory] = listitem;
				ShowDialogToPlayer(playerid, DIALOG_BUYFURNITURE2);
	        }
	    }
	    case DIALOG_BUYFURNITURE2:
	    {
	        new houseid = GetInsideHouse(playerid);

	        if(houseid == -1 || !HasFurniturePerms(playerid, houseid))
			{
				return 0;
			}

	        if(response)
	        {
	            listitem += PlayerInfo[playerid][pFurnitureIndex];

	            if(PlayerInfo[playerid][pCash] < furnitureArray[listitem][fPrice])
	            {
	                return SendClientMessage(playerid, COLOR_SYNTAX, "You can't purchase this. You don't have enough money for it.");
	            }
	            else
	            {
		            new
		                Float:x,
	    	            Float:y,
	        	        Float:z,
	            	    Float:a;

					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, a);

					PlayerInfo[playerid][pEditType] = EDIT_FURNITURE_PREVIEW;
					PlayerInfo[playerid][pEditObject] = CreateDynamicObject(furnitureArray[listitem][fModel], x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z + 1.0, 0.0, 0.0, ((19353 <= furnitureArray[listitem][fModel] <= 19417) || (19426 <= furnitureArray[listitem][fModel] <= 19465)) ? (a + 90.0) : (a), GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                    PlayerInfo[playerid][pSelected] = listitem;

					SM(playerid, COLOR_GREEN, "You are now previewing "SVRCLR"%s{CCFFFF}. This furniture item costs $%i to purchase.", furnitureArray[listitem][fName], furnitureArray[listitem][fPrice]);
					SM(playerid, COLOR_GREEN, "Use your cursor to control the editor interface. Click the floppy disk to save changes.");
                    EditDynamicObject(playerid, PlayerInfo[playerid][pEditObject]);
				}
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_BUYFURNITURE1);
			}
	    }
		case GatePass:
		{
			if (response)
			{
				new id = Gate_Nearest(playerid);

				if (id == -1)
					return 0;

				if (isnull(inputtext))
					return ShowPlayerDialog(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");

				if (strcmp(inputtext, GateData[id][gatePass]) != 0)
					return ShowPlayerDialog(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Error: Incorrect password specified.\n\nPlease enter the password for this gate below:", "Submit", "Cancel");

				Gate_Operate(id);
			}
		}
		case DIALOG_CALL:
		{
			if (response)
			{
				new number = strval(inputtext);

				if(!PlayerInfo[playerid][pPhone])
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
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

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s dials a number on their keypad and begins a call.", GetRPName(playerid));
						SendProximityMessage(i, 20.0, SERVER_COLOR, "**{C2A2DA} %s's mobile phone begins to ring.", GetRPName(i));

				        SM(playerid, COLOR_YELLOW, "** You've placed a call to number: %i. Please wait for your call to be answered.", number);
				        SM(i, COLOR_YELLOW, "** Incoming call from #%i. Use /pickup to take this call.", PlayerInfo[playerid][pPhone]);
				        return 1;
					}
				}

				SendClientMessage(playerid, COLOR_SYNTAX, "That number is either not in service or the owner is offline.");
			}
		}
		case DIALOG_CONTACTS_OPTIONS:
		{
			if (response)
			{
				switch (listitem)
				{
					case 0:
					{
						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT contact_name, contact_number FROM phone_contacts WHERE contact_id = %i", PlayerInfo[playerid][pSelected]);
						mysql_tquery(connectionID, queryBuffer, "OnPlayerCallContact", "i", playerid);
					}
					case 1:
					{
						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT contact_name, contact_number FROM phone_contacts WHERE contact_id = %i", PlayerInfo[playerid][pSelected]);
						mysql_tquery(connectionID, queryBuffer, "OnPlayerTextContact", "i", playerid);
					}
					case 2:
					{
						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM phone_contacts WHERE contact_id = %i", PlayerInfo[playerid][pSelected]);
						mysql_tquery(connectionID, queryBuffer);

						ListContacts(playerid);
						SM(playerid, COLOR_YELLOW, "You have deleted the selected contact.");
					}
				}
			}
			else
			{
				ListContacts(playerid);
			}
		}
	     case DIALOG_LSPD:
		{
  			if(response)
      		{
      		    new rand = random(10);
				switch(listitem)
				{
				    
				    case 0: // LSPD Car
				    {
				        new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 596;
                        
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
                        VehicleInfo[Pdveh][vHealth] =  10000.0;
	                    vehicleColors[Pdveh][1] = color2;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "LSPD CAR SPAWNED");
				    }
				    case 1: // Police Ranger
				    {
				    	new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 599;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Ranger SPAWNED");
				    }
				    case 2: // Swat
				    {
				    	new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 1;
                        color2 = 0;
                        modelid = 601;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Swat Truck SPAWNED");
				    }
					case 3: // Cheetah
					{
				        new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 0;
                        modelid = 415;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;


	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Cheetah SPAWNED");
					}
					case 4: // LSPD Truck
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 0;
                        modelid = 528;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "LSPD Truck SPAWNED");
					}
                    case 5: // Sulthan
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 0;
                        modelid = 560;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Sulthan SPAWNED");
					}
                    case 6: // Buffalo
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 0;
                        modelid = 402;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Buffalo SPAWNED");
					}
					case 7: // enforcer
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 427;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Buffalo SPAWNED");
					}
					case 8: // LVPD CAR
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 598;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "LVPD CAR SPAWNED");
					}
					case 9: // SFPD CAR
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 597;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "SFPD CAR SPAWNED");
					}
					case 10: // BULLET CAR
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 541;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "BULLET SPAWNED");
					}
					case 11: // PD BIKE
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 523;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "PD BIKE SPAWNED");
					}
					case 12: // TOW TRUCK
					{
					    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, Pdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = 0;
                        color2 = 1;
                        modelid = 525;
	                    Pdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(Pdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[Pdveh][vFactionType] = 1;
	                    factionVehicle{Pdveh} = true;
	                    vehicleFuel[Pdveh] = 100;
	                    vehicleColors[Pdveh][0] = color1;
	                    vehicleColors[Pdveh][1] = color2;
	                    VehicleInfo[Pdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(Pdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(Pdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, Pdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "PD BIKE SPAWNED");
					}

				}
        	}
		}
		case DIALOG_MEDIC:
		{
  			if(response)
      		{
			    new rand = random(10);
				switch(listitem)
				{
				    case 0: // Ambulance
				    {
				        new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, mdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = -1;
                        color2 = -1;
                        modelid = 416;
	                    mdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(mdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[mdveh][vFactionType] = 2;
	                    factionVehicle{mdveh} = true;
	                    vehicleFuel[mdveh] = 100;
	                    vehicleColors[mdveh][0] = color1;
	                    vehicleColors[mdveh][1] = color2;
	                    VehicleInfo[mdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(mdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(mdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, mdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Ambulance SPAWNED");
				    }
			        case 1: // Ambulance
				    {
				        new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, mdveh;

				    	GetPlayerPos(playerid, x, y, z);
	                    GetPlayerFacingAngle(playerid, a);

                        color1 = -1;
                        color2 = -1;
                        modelid = 522;
	                    mdveh = AddStaticVehicleEx(modelid, x + float(rand), y + float(rand), z, a, color1, color2, -1);

	                    if(mdveh == INVALID_PLAYER_ID)
	                    {
	                       return SendClientMessage(playerid, COLOR_SYNTAX, "Cannot spawn vehicle. The vehicle pool is currently full.");
	                    }
	                    VehicleInfo[mdveh][vFactionType] = 2;
	                    factionVehicle{mdveh} = true;
	                    vehicleFuel[mdveh] = 100;
	                    vehicleColors[mdveh][0] = color1;
	                    vehicleColors[mdveh][1] = color2;
	                    VehicleInfo[mdveh][vHealth] =  10000.0;

	                    SetVehicleVirtualWorld(mdveh, GetPlayerVirtualWorld(playerid));
	                    LinkVehicleToInterior(mdveh, GetPlayerInterior(playerid));

	                    PutPlayerInVehicle(playerid, mdveh, 0);
	                    SendClientMessage(playerid, COLOR_SYNTAX, "Nrg SPAWNED");
				    }
				}

        	}
		}
		case DIALOG_CONTACTS_NUMBER:
		{
			if (response)
			{
				new number, string[128];

				if (sscanf(inputtext, "i", number))
				{
					format(string, sizeof(string), "Please input the number for the contact '%s':", gTargetName[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_CONTACTS_NUMBER, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", string, "Submit", "Cancel");
				}
				else if (number < 1)
				{
					format(string, sizeof(string), "You have entered an invalid number.\n\nPlease input the number for the contact '%s':", gTargetName[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_CONTACTS_NUMBER, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", string, "Submit", "Cancel");
				}
				else
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO phone_contacts (phone_number, contact_name, contact_number) VALUES(%i, '%e', %i)", PlayerInfo[playerid][pPhone], gTargetName[playerid], number);
					mysql_tquery(connectionID, queryBuffer);

					ListContacts(playerid);
					SM(playerid, COLOR_YELLOW, "You have added a contact: %s (%i).", gTargetName[playerid], number);
				}
			}
		}
		case DIALOG_CONTACTS_ADD:
		{
			if (response)
			{
				if (isnull(inputtext))
				{
					return ShowPlayerDialog(playerid, DIALOG_CONTACTS_ADD, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "Please input the name of the contact to add below:", "Submit", "Cancel");
				}
				else if (strlen(inputtext) > 24)
				{
					return ShowPlayerDialog(playerid, DIALOG_CONTACTS_ADD, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "The contact name must be below 24 characters.\n\nPlease input the name of the contact to add below:", "Submit", "Cancel");
				}
				else
				{
					strcpy(gTargetName[playerid], inputtext, MAX_PLAYER_NAME);

					new string[128];
					format(string, sizeof(string), "Please input the number for the contact '%s':", gTargetName[playerid]);
					ShowPlayerDialog(playerid, DIALOG_CONTACTS_NUMBER, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", string, "Submit", "Cancel");
				}
			}
			else
			{
				ListContacts(playerid);
			}
			return 1;
		}
		case DIALOG_CONTACTS:
		{
			if (response)
			{
				if (listitem == 0)
				{
					ShowPlayerDialog(playerid, DIALOG_CONTACTS_ADD, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "Please input the name of the contact to add below:", "Submit", "Cancel");
				}
				else
				{
					PlayerInfo[playerid][pSelected] = gListedItems[playerid][--listitem];

					ShowPlayerDialog(playerid, DIALOG_CONTACTS_OPTIONS, DIALOG_STYLE_LIST, "{FFFFFF}Contact options", "Call contact\nText Message\nDelete contact", "Select", "Cancel");
				}
			}
		}
		case DIALOG_PHONE_SMS_TEXT:
		{
			new text[128];
			new number = PlayerInfo[playerid][pPhoneSMS];

			if (response)
			{
				if (sscanf(inputtext, "s[128]", text))
				{
					ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "SMS Text", "Please type your message:", "Send", "Cancel");
				}
				else
				{
					foreach(new i : Player)
					{
						if(PlayerInfo[i][pPhone] == number)
						{
							if(PlayerInfo[i][pJailType] > 0)
							{
								return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That player is currently imprisoned and cannot use their phone.");
							}
							if(PlayerInfo[i][pTogglePhone])
							{
								return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" That player has their mobile phone switched off.");
							}

							SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s takes out a cellphone and sends a message.", GetRPName(playerid));

							if(strlen(text) > MAX_SPLIT_LENGTH)
							{
								SM(i, COLOR_OOC, "** [Text from %s] (%i): %.*s... **", GetRPName(playerid), PlayerInfo[playerid][pPhone], MAX_SPLIT_LENGTH, text);
								SM(i, COLOR_OOC, "** [Text from %s] (%i): ...%s **", GetRPName(playerid), PlayerInfo[playerid][pPhone], text[MAX_SPLIT_LENGTH]);

								SM(playerid, COLOR_RED, "** [Text to %s] (%i): %.*s... **", GetRPName(i), PlayerInfo[i][pPhone], MAX_SPLIT_LENGTH, text);
								SM(playerid, COLOR_RED, "** [Text to %s] (%i): ...%s **", GetRPName(i), PlayerInfo[i][pPhone], text[MAX_SPLIT_LENGTH]);
							}
							else
							{
								SM (i, COLOR_OOC, "** [Text from %s] (%i): %s **", GetRPName(playerid), PlayerInfo[playerid][pPhone], text);
								SM(playerid, COLOR_RED, "** [Text to %s] (%i): %s **", GetRPName(i), PlayerInfo[i][pPhone], text);
							}

							if(PlayerInfo[i][pTextFrom] == INVALID_PLAYER_ID)
							{
								SM(i, COLOR_WHITE, "** You can use '/rsms [message]' to reply to this text message.");
							}

							PlayerInfo[i][pTextFrom] = playerid;

							return 1;
						}
					}

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, jailtype, togglephone FROM users WHERE phone = %i", number);
					mysql_tquery(connectionID, queryBuffer, "OnPlayerSendTextMessage", "iis", playerid, number, text);
				}
			}
		}
		case DIALOG_PHONE_SMS:
		{
			new number;

			if (response)
			{
				if(PlayerInfo[playerid][pTogglePhone])
					return SendClientMessage(playerid, COLOR_ERROR, "You have your phone toggled.");

				if (sscanf(inputtext, "i", number))
				{
					return ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "SMS", "Cancel");
				}
				else if (PlayerInfo[playerid][pPhone] == number)
				{
					return ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "You can't text your own number.\n\nPlease specify the number you would like to SMS:", "SMS", "Cancel");
				}
				else if (number < 1)
				{
					return ShowPlayerDialog(playerid, DIALOG_PHONE_SMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "SMS", "Cancel");
				}
				else
				{
					PlayerInfo[playerid][pPhoneSMS] = number;

					ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "SMS Text", "Please type your message:", "Send", "Cancel");
				}
			}
		}
		case LotteryNumber:
		{
			if (response)
			{
				new bizid = GetInsideBusiness(playerid);

				if (bizid != -1)
				{
					new price = BusinessInfo[bizid][bPrices][18];
					if (isnull(inputtext) || (strval(inputtext) < 1 || strval(inputtext) > 60)) {
						return ShowPlayerDialog(playerid, LotteryNumber, DIALOG_STYLE_INPUT, "Lottery Number", "Please enter your desired lottery number below (from 1-60):", "Submit", "Cancel");
					}
					PlayerInfo[playerid][pLottery] = strval(inputtext);
					PlayerInfo[playerid][pLotteryB] = 1;

					SendProximityMessage(playerid, 30.0, SERVER_COLOR, "**{D0AEEB} %s has paid %s and received a lottery ticket.", FormatNumber(price));

					GivePlayerCash(playerid, -price);

					BusinessInfo[bizid][bCash] += price;
					BusinessInfo[bizid][bProducts]--;

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[bizid][bCash], BusinessInfo[bizid][bProducts], BusinessInfo[bizid][bID]);
					mysql_tquery(connectionID, queryBuffer);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Lottery = %i, LotteryB = %i WHERE uid = %i", PlayerInfo[playerid][pLottery],PlayerInfo[playerid][pLotteryB], PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}
			}
		}
		case DIALOG_EDITBUY:
		{
			if(response)
			{
				PlayerInfo[playerid][pProductChoose] = listitem;
				//SM(playerid, COLOR_SYNTAX,"You are editing product number: %i", PlayerInfo[playerid][pProductChoose]);
				ShowPlayerDialog(playerid, DIALOG_EDITBUY2, DIALOG_STYLE_INPUT, SERVER_DIALOG, "Please enter the new product price:", "Modify", "");
			}
		}
		case DIALOG_EDITBUY2: {
			if(response)
			{
				new number = strval(inputtext), businessid = GetInsideBusiness(playerid), product = PlayerInfo[playerid][pProductChoose];
				if(!(1 <= number <= 100000))
				{
					return SM(playerid, COLOR_SYNTAX, "Don't go below $1, or above $100,000 at once.");
				}
				BusinessInfo[businessid][bPrices][product] = number;
				//SM(playerid, COLOR_SYNTAX,"You set product %d to %i.", BusinessInfo[businessid][bPrices][product], number);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET prices%d = %i WHERE id = %i", product, number,BusinessInfo[businessid][bID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
		case DIALOG_BUYCLOTHESCP:
	    {
	        if(response)
	        {
	            new businessid = GetInsideBusiness(playerid);

	            if(BusinessInfo[businessid][bProducts] <= 0)
	            {
	                return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock.");
	            }
	            if(PlayerInfo[playerid][pVIPPackage] == 0 && PlayerInfo[playerid][pCash] < 50)
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy new clothes.");
                }

	            if(BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
	            {
	                new skinid;

	                if(sscanf(inputtext, "i", skinid))
	                {
	                    return ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHESCP);
					}
					if(!(0 <= skinid <= 311) || (265 <= skinid <= 267) || (274 <= skinid <= 288) || (300 <= skinid <= 302) || (306 <= skinid <= 311))
					{
					    SendClientMessage(playerid, COLOR_SYNTAX, "You are not allowed to use that skin as it is either invalid or faction reserved.");
                        return ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHESCP);
					}

					if(PlayerInfo[playerid][pVIPPackage] == 0)
					{
					    new price = 50;

						GivePlayerCash(playerid, -price);

						BusinessInfo[businessid][bCash] += price;
                    	BusinessInfo[businessid][bProducts]--;

                    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
                    	mysql_tquery(connectionID, queryBuffer);

                    	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a new set of clothes.", GetRPName(playerid), price);
                 		SM(playerid, COLOR_WHITE, "** You've changed your skin for $%i.", price);
                    }
                    else
                    {
                        SendClientMessage(playerid, COLOR_VIP, "** Donator perk: You changed your clothes free of charge.");
					}

					SetPlayerSkin(playerid, skinid);
                    PlayerInfo[playerid][pSkin] = skinid;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
	            }
			}
	    }

		case DIALOG_BUYCLOTHES:
	    {
	        if(response)
	        {
	        	if(listitem==0)
				{

					ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHES, "Clothes Shop", clothesShopSkins, sizeof(clothesShopSkins));

				}
				if(listitem==1)
				{
					new businessid = GetInsideBusiness(playerid);

		            if(BusinessInfo[businessid][bProducts] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock.");
		            }
		            if(PlayerInfo[playerid][pVIPPackage] == 0 && PlayerInfo[playerid][pCash] < 50)
	                {
	                    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy new clothes.");
	                }

		            if(BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
		            {
		                new skinid;

		                if(sscanf(inputtext, "i", skinid))
		                {
		                    return ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHESCP);
						}
						if(!(0 <= skinid <= 311) || (265 <= skinid <= 267) || (274 <= skinid <= 288) || (300 <= skinid <= 302) || (306 <= skinid <= 311))
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "You are not allowed to use that skin as it is either invalid or faction reserved.");
	                        return ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHESCP);
						}

						if(PlayerInfo[playerid][pVIPPackage] == 0)
						{
						    new price = 50;

							GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                    	BusinessInfo[businessid][bProducts]--;

	                    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                    	mysql_tquery(connectionID, queryBuffer);

	                    	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a new set of clothes.", GetRPName(playerid), price);
	                 		SM(playerid, COLOR_WHITE, "** You've changed your skin for $%i.", price);
	                    }
	                    else
	                    {
	                        SendClientMessage(playerid, COLOR_VIP, "** Donator perk: You changed your clothes free of charge.");
						}

						SetPlayerSkin(playerid, skinid);
	                    PlayerInfo[playerid][pSkin] = skinid;

	                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
	                    mysql_tquery(connectionID, queryBuffer);
		            }
		        }
			}
		}
		case DIALOG_CITY_HALL:
		{
			if(response)
			{
			for(new i = 0; i < sizeof(jobLocations); i++)
			{
			if(!Job_IsEnabled(i))
			{
				continue;
			}
			if(strfind(inputtext, jobLocations[i][jobName], false) != -1)
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
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You have two jobs already. Please quit one of them before getting another one.");
	   	    }
	        if(PlayerInfo[playerid][pJob] == i)
    	    {
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
			SM(playerid, COLOR_AQUA, "You are now a "SVRCLR"%s{CCFFFF}. Use /jobhelp for a list of commands related to your new job.", jobLocations[i][jobName]);
			return 1;
		}

      }
			}
		}
     	case DIALOG_BUY:
	    {
	        if(response)
	        {
	            new businessid = GetNearbyBusinessEx(playerid);

	            if(BusinessInfo[businessid][bProducts] <= 0)
	            {
	                return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock.");
	            }
				if(BusinessInfo[businessid][bType] == BUSINESS_MOBILE)
                {
                    switch(listitem)
	                {
	                    
      		            case 0: // airtle
						{
							new price = BusinessInfo[businessid][bPrices][0];
							if(PlayerInfo[playerid][pCash] >= price) // Cost: 100
							{
								PlayerInfo[playerid][pSIM] = SIM_TNT;
								GivePlayerMoney(playerid, -price);
								SendClientMessage(playerid, COLOR_GREEN, "You have bought a {ff1e1e} Airtle {ffffff}SIM card. Use /buyload to add load.");
							}
							else
							{
								SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy a {ff1e1e} Airtle {ffffff} SIM card.");
							}
						}
						case 1: // Globe jio
						{
							new price = BusinessInfo[businessid][bPrices][1];
							if(PlayerInfo[playerid][pCash] >= price) // Cost: 150
							{
								PlayerInfo[playerid][pSIM] = SIM_GLOBE;
								GivePlayerMoney(playerid, -price);
								SendClientMessage(playerid, COLOR_GREEN, "You have bought a {0049d2} Jio {ffffff} SIM card. Use /buyload to add load.");
							}
							else
							{
								SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy a {0049d2} Jio {ffffff} SIM card.");
							}
						}
						case 2: // Smart idea
						{
							new price = BusinessInfo[businessid][bPrices][2];
							if(PlayerInfo[playerid][pCash] >= price) // Cost: 200
							{
								PlayerInfo[playerid][pSIM] = SIM_SMART;
								GivePlayerMoney(playerid, -price);
								SendClientMessage(playerid, COLOR_GREEN, "You have bought a {f4ff30}Idea {ffffff} SIM card. Use /buyload to add load.");
							}
							else
							{
								SendClientMessage(playerid, COLOR_RED, "You don't have enough money to buy a {f4ff30} Idea {ffffff} SIM card.");
							}
						}

					}
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET `sim` = %i WHERE uid = %i",  PlayerInfo[playerid][pSIM] , PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);
                
                }

	            if(BusinessInfo[businessid][bType] == BUSINESS_STORE)
	            {
	                switch(listitem)
	                {
	                    case 0:
	                    {
							new price = BusinessInfo[businessid][bPrices][0];

	                        if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pPhone] = random(100000) + 899999;
	                        GivePlayerCash(playerid, -price);
                            PlayerInfo[playerid][pPhonee] = 1;
							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);
	                        
	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET Phonep = %i WHERE uid = %i", PlayerInfo[playerid][pPhonee], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a mobile phone.", GetRPName(playerid), price);
	                        SM(playerid, COLOR_WHITE, "** Mobile phone purchased. Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
						}
						case 1:
						{
						    new price = BusinessInfo[businessid][bPrices][1];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pWalkieTalkie])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have a Portable Radio already.");
						    }

						    PlayerInfo[playerid][pWalkieTalkie] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET walkietalkie = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Portable Radio.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Portable Radio purchased. Use /pr to speak and /channel to change the frequency.");
						}
						case 2:
						{
						    new price = BusinessInfo[businessid][bPrices][2];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pCigars] >= 20)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 cigars.");
						    }

						    PlayerInfo[playerid][pCigars] += 10;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", PlayerInfo[playerid][pCigars], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a pack of cigars.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Cigars purchased. Use /usecigar to smoke a cigar.");
						}
						case 3:
						{
						    new price = BusinessInfo[businessid][bPrices][3];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pSpraycans] + 10 >= 20)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 spraycans.");
						    }

						    PlayerInfo[playerid][pSpraycans] += 10;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = %i WHERE uid = %i", PlayerInfo[playerid][pSpraycans], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received 10 spraycans.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Spraycans purchased. Use /colorcar and /paintcar in a vehicle to use them.");
						}
						case 4:
						{
						    new price = BusinessInfo[businessid][bPrices][4];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pPhonebook])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have a phonebook already.");
						    }

						    PlayerInfo[playerid][pPhonebook] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebook = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a phonebook.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Phonebook purchased. Use /phonebook to lookup a player's number.");
						}
						case 5:
						{
						    new price = BusinessInfo[businessid][bPrices][5];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

							GiveWeapon(playerid, 43);
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a camera.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Camera purchased.");
						}
						case 6:
						{
						    new price = BusinessInfo[businessid][bPrices][6];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pMP3Player])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have an MP3 player already.");
						    }

						    PlayerInfo[playerid][pMP3Player] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mp3player = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received an MP3 player.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** MP3 player purchased. Use /mp3 for a list of options.");
						}
						case 7:
						{
						    new price = BusinessInfo[businessid][bPrices][7];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pFishingRod])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have a fishing rod already.");
						    }

						    PlayerInfo[playerid][pFishingRod] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingrod = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a fishing rod.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Fishing rod purchased. Use /fish at the pier or in a boat to begin fishing.");
						}
						case 8:
						{
						    new price = BusinessInfo[businessid][bPrices][8];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pFishingBait] + 10 >= 20)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 pieces of bait.");
						    }

						    PlayerInfo[playerid][pFishingBait] += 10;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingbait = %i WHERE uid = %i", PlayerInfo[playerid][pFishingBait], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received fish bait.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Fishing bait purchased. Bait increases the odds of catching bigger fish.");
						}
						case 9:
						{
						    new price = BusinessInfo[businessid][bPrices][9];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pMuriaticAcid] + 1 >= 21)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 bottles of muriatic acid.");
						    }

						    PlayerInfo[playerid][pMuriaticAcid] += 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET muriaticacid = %i WHERE uid = %i", PlayerInfo[playerid][pMuriaticAcid], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottle of muriatic acid.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Muriatic acid purchased.");
						}
						case 10:
						{
						    new price = BusinessInfo[businessid][bPrices][10];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pBakingSoda] + 1 >= 21)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 20 bottles of baking soda.");
						    }

						    PlayerInfo[playerid][pBakingSoda] += 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bakingsoda = %i WHERE uid = %i", PlayerInfo[playerid][pBakingSoda], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottle of baking soda.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Baking soda purchased.");
						}
						case 11:
						{
						    new price = BusinessInfo[businessid][bPrices][11];
						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pWatch])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have a pocket watch already.");
						    }

						    PlayerInfo[playerid][pWatch] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a pocket watch.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** Pocket watch purchased. Use /ww to toggle it.");
						}
						case 12:
						{
						    new price = BusinessInfo[businessid][bPrices][12];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pGPS])
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You have a GPS already.");
						    }

						    PlayerInfo[playerid][pGPS] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a GPS.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "** GPS purchased. (( /gps, /locate ))");
						}
					
						case 13:
						{
						    new price = BusinessInfo[businessid][bPrices][14];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pRope] + 2 > 10)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 10 ropes.");
						    }


						    PlayerInfo[playerid][pRope] += 2;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = %i WHERE uid = %i", PlayerInfo[playerid][pRope], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received 2 ropes.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "Ropes purchased. Use /tie to tie people in your vehicle.");
						}
						case 14:
						{
						    new price = BusinessInfo[businessid][bPrices][15];
						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pBlindfold] + 2 > 10)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 10 blindfolds.");
						    }


						    PlayerInfo[playerid][pBlindfold] += 2;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET blindfold = %i WHERE uid = %i", PlayerInfo[playerid][pBlindfold], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received 2 blindfolds.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "Blindfold purchased. Use /blindfold to blindfold people in your vehicle.");
						}
					
						case 15:
						{
		    				new price = BusinessInfo[businessid][bPrices][16];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pToolkit] == 1)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 1 toolkits.");
						    }


						    PlayerInfo[playerid][pToolkit] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);
	                        
	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET toolkit = %i WHERE uid = %i", PlayerInfo[playerid][pToolkit], PlayerInfo[playerid][pID]);
							mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a toolkit.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "Toolkit purchased. Use /hotwire to hotwire people's vehicles.");
						}
	                    case 16:
						{
						    new price = BusinessInfo[businessid][bPrices][16];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
							if(PlayerInfo[playerid][pBackpack] > 1)
							{
						    	return SendClientMessage(playerid, COLOR_SYNTAX, "You already have a small backpack.");
							}

						    PlayerInfo[playerid][pBackpack] = 1;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received small backpack.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "Small Backpack purchased. Use /(b)ack(p)ack to check your backpack.");
						}
						case 17:
						{
							if (PlayerInfo[playerid][pLottery])
								return SendClientMessage(playerid, COLOR_SYNTAX, "You have a lottery ticket already.");

							ShowPlayerDialog(playerid, LotteryNumber, DIALOG_STYLE_INPUT, "Lottery Number", "Please enter your desired lottery number below (from 1-60):", "Submit", "Cancel");
						}
						case 18: {
							new price = BusinessInfo[businessid][bPrices][16];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
						    if(PlayerInfo[playerid][pRepairKit] >= 2)
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't have more than 2 Repair Kit.");
						    }


						    PlayerInfo[playerid][pRepairKit]++;
	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);
	                        
	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
							mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Repair Kit.", GetRPName(playerid), price);
	                        SendClientMessage(playerid, COLOR_WHITE, "Repair Kit purchased. Use /userepairkit to repair your car when it's needed.");
						}
					}
				}
				else if(BusinessInfo[businessid][bType] == BUSINESS_GUNSHOP)
				{
				    if(PlayerInfo[playerid][pWeaponRestricted])
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You are either weapon restricted or you played less than 2 hours. You can't buy stuff here.");
					}
					if(PlayerInfo[playerid][pHours] < 2)
					{
  	  					return SendClientMessage(playerid, COLOR_SYNTAX, "You need 2 hours to buy a weapon in here");
					}
					if(!PlayerInfo[playerid][pWeaponLicense])
					{
						return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have weapon license, get weapon license from the cops.");
					}
				    switch(listitem)
					{
				        case 0:
				        {
				            new price = BusinessInfo[businessid][bPrices][0];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerHasWeapon(playerid, 22))
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

							if(PlayerInfo[playerid][pBuygun] == 0)
							{
		                        GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 22);
		                        PlayerInfo[playerid][pBuygun]++;

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a 9mm pistol.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** 9mm pistol purchased, and you still have 1 slot for this day.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 1)
		                    {
		                    	GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 22);

		                        PlayerInfo[playerid][pBuygun]++;
		                        PlayerInfo[playerid][pBGTime] = gettime() + (1 * 86400);

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i, bgtime = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pBGTime], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a 9mm pistol.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** 9mm pistol purchased, but you don't have any slot for this day and cooldown has been activated.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 2)
		                    {
		                    	return SendClientMessage(playerid, COLOR_SYNTAX, "Cooldown is still going on, You're not allowed to buy any gun as of the moment.");
		                    }
				        }
				        case 1:
				        {
				            new price = BusinessInfo[businessid][bPrices][1];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerHasWeapon(playerid, 1))
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}
							if(PlayerInfo[playerid][pBuygun] == 0)
							{
		                        GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 1);
		                        PlayerInfo[playerid][pBuygun]++;

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);


		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);


		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Brass Knuckles.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** Brass Knuckles purchased, and you still have 1 slot for this day.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 1)
		                    {
		                    	GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 1);

		                        PlayerInfo[playerid][pBuygun]++;
		                        PlayerInfo[playerid][pBGTime] = gettime() + (1 * 86400);

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i, bgtime = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pBGTime], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Brass Knuckles.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** Brass Knuckles purchased, but you don't have any slot for this day and cooldown has been activated.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 2)
		                    {
		                    	return SendClientMessage(playerid, COLOR_SYNTAX, "Cooldown is still going on, You're not allowed to buy any gun as of the moment.");
		                    }
				        }
				        case 2:
				        {
				            new price = BusinessInfo[businessid][bPrices][2];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerHasWeapon(playerid, 5))
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

							if(PlayerInfo[playerid][pBuygun] == 0)
							{
		                        GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 5);
		                        PlayerInfo[playerid][pBuygun]++;

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Bat.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** Bat purchased, and you still have 1 slot for this day.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 1)
		                    {
		                    	GivePlayerCash(playerid, -price);
		                        GiveWeapon(playerid, 5);

		                        PlayerInfo[playerid][pBuygun]++;
		                        PlayerInfo[playerid][pBGTime] = gettime() + (1 * 86400);

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i, bgtime = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pBGTime], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Bat.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** Bat purchased, but you don't have any slot for this day and cooldown has been activated.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 2)
		                    {
		                    	return SendClientMessage(playerid, COLOR_SYNTAX, "Cooldown is still going on, You're not allowed to buy any gun as of the moment.");
		                    }
		
				        }
				        case 3:
				        {
				            new price = BusinessInfo[businessid][bPrices][3];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        if(PlayerInfo[playerid][pBuygun] == 0)
							{
		                        SetScriptArmour(playerid, 50.0);
	                        	GivePlayerCash(playerid, -price);
		                        PlayerInfo[playerid][pBuygun]++;

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Light Armor.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** 50 points of Armor purchased, and you still have 1 slot for this day.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 1)
		                    {
		                    	SetScriptArmour(playerid, 50.0);
	                        	GivePlayerCash(playerid, -price);

		                        PlayerInfo[playerid][pBuygun]++;
		                        PlayerInfo[playerid][pBGTime] = gettime() + (1 * 86400);

								BusinessInfo[businessid][bCash] += price;
		                        BusinessInfo[businessid][bProducts]--;

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
		                        mysql_tquery(connectionID, queryBuffer);

		                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = %i, bgtime = %i WHERE uid = %i", PlayerInfo[playerid][pBuygun], PlayerInfo[playerid][pBGTime], PlayerInfo[playerid][pID]);
		                    	mysql_tquery(connectionID, queryBuffer);

		                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a Light Armor.", GetRPName(playerid), price);
		                        SendClientMessage(playerid, COLOR_WHITE, "** 50 points of Armor purchased, but you don't have any slot for this day and cooldown has been activated.");
		                    }
		                    else if(PlayerInfo[playerid][pBuygun] == 2)
		                    {
		                    	return SendClientMessage(playerid, COLOR_SYNTAX, "Cooldown is still going on, You're not allowed to buy any gun as of the moment.");
		                    }
				        }
					}
				}
				else if(BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
                {
                    new
                        string[128];

                    format(string, sizeof(string), "%s's %s [%i Products]", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

                    if(listitem == 0)
                    {
                        //ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
                        //ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHES);
                        ShowPlayerDialog(playerid, DIALOG_BUYCLOTHES, DIALOG_STYLE_LIST, "Choose a Browsing Method", "Browse by Model\nBrowse by Skin id","Select","Cancel");
                        //ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHES, "Clothes Shop", clothesShopSkins, sizeof(clothesShopSkins));
                    }
                    else
                    {
                        PlayerInfo[playerid][pCategory] = listitem - 1;
                        ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
                    }
                }
				
				else if(BusinessInfo[businessid][bType] == BUSINESS_GYM)
				{
				    switch(listitem)
				    {
				        case 0:
				        {
	                        if(PlayerInfo[playerid][pFightStyle] == FIGHT_STYLE_NORMAL)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this fighting style.");
	                        }

	                        PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
	                        SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendClientMessage(playerid, COLOR_WHITE, "** You have chosen the normal fighting style.");
						}
						case 1:
						{
						    new price = BusinessInfo[businessid][bPrices][0];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerInfo[playerid][pFightStyle] == FIGHT_STYLE_BOXING)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this fighting style.");
	                        }


	                        GivePlayerCash(playerid, -price);
	                        BusinessInfo[businessid][bCash] += price;

                            PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
	                        SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SM(playerid, COLOR_WHITE, "** You have purchased the Boxing fighting style for $%i.", price);
						}
						case 2:
						{
						    new price = BusinessInfo[businessid][bPrices][1];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerInfo[playerid][pFightStyle] == FIGHT_STYLE_KUNGFU)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this fighting style.");
	                        }


	                        GivePlayerCash(playerid, -price);
	                        BusinessInfo[businessid][bCash] += price;

	                        PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
	                        SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SM(playerid, COLOR_WHITE, "** You have purchased the Kung-Fu fighting style for $%i.", price);
						}
						case 3:
						{
						    new price = BusinessInfo[businessid][bPrices][2];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerInfo[playerid][pFightStyle] == FIGHT_STYLE_KNEEHEAD)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this fighting style.");
	                        }


	                        GivePlayerCash(playerid, -price);
	                        BusinessInfo[businessid][bCash] += price;

	                        PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
	                        SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SM(playerid, COLOR_WHITE, "** You have purchased the Kneehead fighting style for $%i.", price);
						}
						case 4:
						{
						    new price = BusinessInfo[businessid][bPrices][3];

						    if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }
	                        if(PlayerInfo[playerid][pFightStyle] == FIGHT_STYLE_GRABKICK)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You already have this fighting style.");
	                        }


	                        GivePlayerCash(playerid, -price);
	                        BusinessInfo[businessid][bCash] += price;

	                        PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
	                        SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fightstyle = %i WHERE uid = %i", PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SM(playerid, COLOR_WHITE, "** You have purchased the Grabkick fighting style for $%i.", price);
						}
					}
				}
				else if(BusinessInfo[businessid][bType] == BUSINESS_RESTAURANT)
				{
				    switch(listitem)
				    {
				        case 0:
				        {
				            new price = BusinessInfo[businessid][bPrices][0];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
	                        }

 							PlayerInfo[playerid][pDrink] += 1;

	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = %i WHERE uid = %i", PlayerInfo[playerid][pDrink], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottled water.", GetRPName(playerid), price);
						}
						case 1:
				        {
				            new price = BusinessInfo[businessid][bPrices][1];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
	                        }

         					PlayerInfo[playerid][pDrink] += 3;

	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET drink = %i WHERE uid = %i", PlayerInfo[playerid][pDrink], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a can of sprunk.", GetRPName(playerid), price);
						}
						case 2:
				        {
				            new price = BusinessInfo[businessid][bPrices][2];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
	                        }

        					PlayerInfo[playerid][pFood] += 2;

	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[playerid][pFood], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received kid's meal.", GetRPName(playerid), price);
						}
						case 3:
				        {
				            new price = BusinessInfo[businessid][bPrices][3];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pFood] += 3;

	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[playerid][pFood], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a medium meal.", GetRPName(playerid), price);
						}
						case 4:
				        {
				            new price = BusinessInfo[businessid][bPrices][4];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pFood] += 4;

	                        GivePlayerCash(playerid, -price);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET food = %i WHERE uid = %i", PlayerInfo[playerid][pFood], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a big meal.", GetRPName(playerid), price);
						}
					}
				}
				else if(BusinessInfo[businessid][bType] == BUSINESS_BARCLUB)
				{
				    switch(listitem)
				    {
				        case 0:
				        {
				            new price = BusinessInfo[businessid][bPrices][0];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pThirst] += 25;
							PlayerInfo[playerid][pThirstTimer] = 0;
			        		if (PlayerInfo[playerid][pThirst] > 100)
							{
								PlayerInfo[playerid][pThirst] = 100;
							}

	                        GivePlayerCash(playerid, -price);
	                        GivePlayerHealth(playerid, 10.0);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottled water.", GetRPName(playerid), price);
						}
						case 1:
				        {
				            new price = BusinessInfo[businessid][bPrices][1];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pThirst] += 30;
							PlayerInfo[playerid][pThirstTimer] = 0;
			        		if (PlayerInfo[playerid][pThirst] > 100)
							{
								PlayerInfo[playerid][pThirst] = 100;
							}

	                        GivePlayerCash(playerid, -price);
	                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a can of sprunk.", GetRPName(playerid), price);
						}
						case 2:
				        {
				            new price = BusinessInfo[businessid][bPrices][2];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pThirst] += 35;
							PlayerInfo[playerid][pThirstTimer] = 0;
			        		if (PlayerInfo[playerid][pThirst] > 100)
							{
								PlayerInfo[playerid][pThirst] = 100;
							}

	                        GivePlayerCash(playerid, -price);
	                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottle of beer.", GetRPName(playerid), price);
						}
						case 3:
				        {
				            new price = BusinessInfo[businessid][bPrices][3];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pThirst] += 40;
							PlayerInfo[playerid][pThirstTimer] = 0;
			        		if (PlayerInfo[playerid][pThirst] > 100)
							{
								PlayerInfo[playerid][pThirst] = 100;
							}

	                        GivePlayerCash(playerid, -price);
	                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottle of wine.", GetRPName(playerid), price);
						}
						case 4:
				        {
				            new price = BusinessInfo[businessid][bPrices][4];

				            if(PlayerInfo[playerid][pCash] < price)
	                        {
	                            return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
	                        }

	                        PlayerInfo[playerid][pThirst] += 50;
							PlayerInfo[playerid][pThirstTimer] = 0;
			        		if (PlayerInfo[playerid][pThirst] > 100)
							{
								PlayerInfo[playerid][pThirst] = 100;
							}

	                        GivePlayerCash(playerid, -price);
	                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);

							BusinessInfo[businessid][bCash] += price;
	                        BusinessInfo[businessid][bProducts]--;

	                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	                        mysql_tquery(connectionID, queryBuffer);

	                        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the shopkeeper and received a bottle of whiskey.", GetRPName(playerid), price);
						}
					}
				}
			}
		}		
		case DIALOG_ATM:
	    {
	        if(response)
	        {
				switch(listitem) {
					case 0: ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
					case 1: ShowDialogToPlayer(playerid, DIALOG_ATMDEPOSIT);
				}
	        }
		}
   		case DIALOG_PICKLOAD:
	    {
	        if(response)
	        {
	            if(!PlayerHasJob(playerid, JOB_COURIER))
				{
				    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you are not a Trucker.");
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

				switch(listitem)
				{
				    case 0:
				    {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Grocery supplies{33CCFF}. Use /deliver at any Supermarket to drop off this shipment.");
						PlayerInfo[playerid][pShipment] = BUSINESS_STORE;
	                }
	                case 1:
				    {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Ammunition{33CCFF}. Use /deliver at any Gun Shop to drop off this shipment.");
						PlayerInfo[playerid][pShipment] = BUSINESS_GUNSHOP;
	                }
	                case 2:
				    {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Clothing items{33CCFF}. Use /deliver at any Clothes Shop to drop off this shipment.");
						PlayerInfo[playerid][pShipment] = BUSINESS_CLOTHES;
	                }
	                case 3:
				    {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Food & drinks{33CCFF}. Use /deliver at any Restaurant to drop off this shipment.");
						PlayerInfo[playerid][pShipment] = BUSINESS_RESTAURANT;
	                }
	                case 4:
				    {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Beverages{33CCFF}. Use /deliver at any Club/Bar to drop off this shipment.");
						PlayerInfo[playerid][pShipment] = BUSINESS_BARCLUB;
	                }
	                case 5:
	                {
				        SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Illegal Weapons{33CCFF}. Use /deliver at any Gun Shop to drop off this shipment.");
        				SendClientMessage(playerid, COLOR_RED, "NOTE:"WHITE" You are delivering a legal gun supply.");
						PlayerInfo[playerid][pShipment] = BUSINESS_GUNSHOP;
						PlayerInfo[playerid][pIllegalCargo] = ILLEGAL_GUNS;
					}
					case 6:
					{
    					SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Illegal Materials{33CCFF}. Use /deliver at any Gun Shop to drop off this shipment.");
        				SendClientMessage(playerid, COLOR_RED, "NOTE:"WHITE" You are delivering an illegal cargo. Watch out for the cops!");
        				SetPlayerCheckpoint(playerid, 1295.488891, -1858.275390, 13.546875, 4.0);
						PlayerInfo[playerid][pCP] = CHECKPOINT_MATS1;
						PlayerInfo[playerid][pIllegalCargo] = ILLEGAL_MATS;
					}
					case 7:
					{
    					SendClientMessage(playerid, COLOR_GREEN, "You selected {FF6347}Illegal Drugs{33CCFF}. Use /deliver at any Club/Bar to drop off this shipment.");
        				SendClientMessage(playerid, COLOR_RED, "NOTE:"WHITE" You are delivering an illegal cargo. Watch out for the cops!");
						PlayerInfo[playerid][pShipment] = BUSINESS_BARCLUB;
						PlayerInfo[playerid][pIllegalCargo] = ILLEGAL_DRUGS;
					}
				}

				PlayerInfo[playerid][pLastLoad] = gettime();
	        }
	    }
	    case DIALOG_UNREADTEXTS:
	    {
	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM texts WHERE recipient_number = %i ORDER BY date DESC LIMIT 25", PlayerInfo[playerid][pPhone]);
	        mysql_tquery(connectionID, queryBuffer);

	        if(response)
	        {
				callcmd::texts(playerid);
	        }
	    }
     	case DIALOG_ATMDEPOSIT:
		{
			if(response)
	        {
	            new amount;

	            if(sscanf(inputtext, "i", amount))
	            {
					return ShowDialogToPlayer(playerid, DIALOG_ATM);
	            }
	            if(amount < 1 || amount > PlayerInfo[playerid][pCash])
	            {
	                SendClientMessage(playerid, COLOR_GREY, "Insufficient amount. Please try again.");
	                ShowDialogToPlayer(playerid, DIALOG_ATMDEPOSIT);
	                return 1;
	            }

	            PlayerInfo[playerid][pBank] += amount;
	            GivePlayerCash(playerid, -amount);

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	            mysql_tquery(connectionID, queryBuffer);

	            SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s presses a button and deposits some cash in their bank account.", GetRPName(playerid));
	            SCMf(playerid, COLOR_WHITE, "You have deposited %s into your account. Your new balance is %s.", FormatNumber(amount), FormatNumber(PlayerInfo[playerid][pBank]));

	            
	        }
		}
	    case DIALOG_ATMWITHDRAW: //main
	    {
	        if(response)
	        {
	            new amount, fee;

	            new atmid = GetNearbyAtm(playerid);

	            if(sscanf(inputtext, "i", amount))
	            {
					return ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
	            }
	            if(amount < 1 || amount > PlayerInfo[playerid][pBank])
	            {
	                SendClientMessage(playerid, COLOR_GREY, "Insufficient amount. Please try again.");
	                ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
	                return 1;
	            }
	            if(AtmInfo[atmid][amoney] <= 0)
 	            {
	 	           return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount in Atm. Please try again.");
            	}

	            PlayerInfo[playerid][pBank] -= amount;
                AtmInfo[atmid][amoney] -= amount;
	            GivePlayerCash(playerid, amount);

	            if(PlayerInfo[playerid][pDonator] == 0)
	            {
	                fee = percent(amount, 1);

	                PlayerInfo[playerid][pBank] -= fee;
	            }

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE atms SET amoney = %i WHERE id = %i",AtmInfo[atmid][amoney], atmid);
                mysql_tquery(connectionID, queryBuffer);
	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	            mysql_tquery(connectionID, queryBuffer);

	            SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s presses a button and withdraws some cash from the ATM.", GetRPName(playerid));
	            SCMf(playerid, COLOR_WHITE, "You have withdrawn %s from your account. Your new balance is %s.", FormatNumber(amount), FormatNumber(PlayerInfo[playerid][pBank]));

				if(fee)
				{
				    SCMf(playerid, COLOR_WHITE, "A 1 percent convenience fee of %s was deducted from your bank account.", FormatNumber(fee));
				    AddToTaxVault(fee);
	            }
	            else if(PlayerInfo[playerid][pDonator] > 0)
	            {
					SendClientMessage(playerid, COLOR_VIP, "DONATOR Perk: You do not pay the 3 percent convenience fee as you are a Donator!");
	            }
                ReloadAtmText(atmid);
	        }
		}
	    case DIALOG_ATM_TRANSFER:
	    {
	        if(response)
	        {
	            new id;

	            if(sscanf(inputtext, "i", id))
	            {
					return ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
	            }

	            if(!IsPlayerConnected(id))
	            {
	                SendClientMessage(playerid, COLOR_GREY, "That player is not connected.");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
	                return 1;
	            }
				if(!PlayerInfo[id][pLogged])
				{
	                SendClientMessage(playerid, COLOR_ERROR, "(( That player has not logged in yet ))");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
	                return 1;
				}

				SetPVarInt(playerid, "transfer_id", id);
				ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER2);
	        }
		}
	    case DIALOG_ATM_TRANSFER2:
	    {
	        if(response)
	        {
	            new id = GetPVarInt(playerid, "transfer_id"), amount, fee;
	            new string[128];
	            new i;

	            if(sscanf(inputtext, "i", amount))
	            {
					return ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER2);
	            }
	            if(amount < 1 || amount > PlayerInfo[playerid][pBank])
	            {
	                SendClientMessage(playerid, COLOR_GREY, "Insufficient amount. Please try again.");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER2);
	                return 1;
	            }
	            if(amount > 1000000)
	            {
	                SendClientMessage(playerid, COLOR_GREY, "You can't withdraw more than $1,000,000 at a time.");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER2);
	                return 1;
	            }
				if(!IsPlayerConnected(id))
				{
					DeletePVar(playerid, "transfer_id");
	                SendClientMessage(playerid, COLOR_GREY, "The player that you are trying to transfer the money to has disconnected.");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
					return 1;
				}
				if(!PlayerInfo[id][pLogged])
				{
					DeletePVar(playerid, "transfer_id");
	                SendClientMessage(playerid, COLOR_ERROR, "(( That player is not logged in ))");
	                ShowDialogToPlayer(playerid, DIALOG_ATM_TRANSFER);
					return 1;
				}

	            PlayerInfo[playerid][pBank] -= amount;
	            PlayerInfo[id][pBank] += amount;

	            if(PlayerInfo[playerid][pVIPPackage] == 0)
	            {
	                fee = percent(amount, 3);

	                PlayerInfo[playerid][pBank] -= fee;
	            }

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
	            mysql_tquery(connectionID, queryBuffer);
	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[id][pBank], PlayerInfo[id][pID]);
	            mysql_tquery(connectionID, queryBuffer);

	            SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s presses a button transferring some cash to someone.", GetRPName(playerid));
	            format(string, sizeof(string), "%s has Wiretransferred", GetRPName(playerid));
                DynamicPlayerTextDrawSetString(id, WireTD[playerid][1], string);
	            format(string, sizeof(string), "~g~$%d", amount);
                DynamicPlayerTextDrawSetString(id, WireTD[playerid][2], string);
				PlayerTextDrawShow(id, WireTD[playerid][i]);
				SetTimerEx("WireHide", 5000, false, "i", i);
				SetTimerEx("WireHide", 5000, false, "d", playerid);
	            SM(id, COLOR_GREEN, "** %s has Wiretransferred $%i to your bank account.", GetRPName(playerid), amount);
	            SM(playerid, COLOR_WHITE, "You have transferred %s to %s. Your new balance is %s.", FormatNumber(amount), GetRPName(id), FormatNumber(PlayerInfo[playerid][pBank]));

				if(fee)
				{
				    SM(playerid, COLOR_WHITE, "A 3 percent convenience fee of %s was deducted from your bank account.", FormatNumber(fee));
				    AddToTaxVault(fee);
	            }
	            else if(PlayerInfo[playerid][pVIPPackage] > 0)
	            {
					SendClientMessage(playerid, COLOR_VIP, "DONATOR Perk: You do not pay the 3 percent convenience fee as you are a Donator!");
	            }
	        }
		}
		case DIALOG_SETTINGS1:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
					    callcmd::engine(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 1:
		            {
					    callcmd::lights(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 2:
		            {
					    callcmd::trunk(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 3:
		            {
					    callcmd::hood(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 4:
		            {
					    callcmd::windows(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 5:
		            {
					    callcmd::seatbelt(playerid);
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
		            }
		            case 6: ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
				}
			}
			return 1;
		}
		case DIALOG_SETTINGS2:
		{
			if(response)
			{
		        switch(listitem)
		        {
		            case 0:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 1:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 2:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 3:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 4:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 5:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 6:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 7:
					{
				        SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
					}
		            case 8:
		            {
					    SendClientMessage(playerid, COLOR_GREY, "This feature is under Maintenance");
					    ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
		            }
		            case 9: ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
				}
			}
			return 1;
		}
		case DIALOG_GPS1:
		{
			if (response)
			{
				if (listitem == 0)
				{
					ShowDialogToPlayer(playerid, DIALOG_LOCATE);
				}
				else
				{
					ShowDialogToPlayer(playerid, DIALOG_SENDGPS);
				}
			}
		}
		case DIALOG_SENDGPS:
	    {
	        if(response)
	        {
	            new targetid;

	            if(sscanf(inputtext, "ui", targetid))
	            {
					return ShowDialogToPlayer(playerid, DIALOG_SENDGPS);
	            }

	            if(!IsPlayerConnected(targetid))
	            {
	                SendClientMessage(playerid, COLOR_GREY, "That player is not connected.");
	                ShowDialogToPlayer(playerid, DIALOG_SENDGPS);
	                return 1;
	            }
				if(!PlayerInfo[targetid][pLogged])
				{
	                SendClientMessage(playerid, COLOR_ERROR, "(( That player has not logged in yet ))");
	                ShowDialogToPlayer(playerid, DIALOG_SENDGPS);
	                return 1;
				}

				PlayerInfo[targetid][pGpsOffer] = playerid;

				SM(targetid, COLOR_GREEN, "** %s has offered location. (/accept location)", GetRPName(playerid));
				SM(playerid, COLOR_GREEN, "** You have sent %s a Location offer.", GetRPName(targetid));
	        }
		}
	    case DIALOG_TWITTER:
	    {
	        if(response)
            {
                new text[128];
	            new string[128];

                if(sscanf(inputtext, "s[128]", text))
                {
             	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /twt [text] ($60/char)");
                }
                if(!PlayerInfo[playerid][pPhone])
            	{
             	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a cellphone and therefore can't use this command.");
            	}
                if(gettime() - gLastTwt < 15)
            	{
             	    return SendClientMessage(playerid, COLOR_SYNTAX, "Twitter can only be posted every 15 seconds.");
            	}
            	foreach(new i : Player)
            	{
             	    new User = Random(1000, 10000);
             	    UserCode[i] = User;
             	    format(string, sizeof(string), "User%d", UserCode[playerid]);
             	    DynamicTextDrawSetString(TwtTD[4], string);
             	    DynamicTextDrawSetString(TwtTD[3], text);
             	    format(string, sizeof(string), "%s", GetRPName(playerid));
             	    DynamicTextDrawSetString(TwtTD[2], string);
             	    for(new f = 0; f < 5; f ++)
             	    {
                          TextDrawShowForPlayer(i, TwtTD[f]);
             	    }
             	    gLastTwt = gettime();
             	    SetTimerEx("TwtTDHIDE", 10000, false, "i", i);
             	    PlayerPlaySound(i,1150,0.0,0.0,0.0);
             	    GivePlayerCash(playerid, -60);
             	    GameTextForPlayer(playerid, "~w~Tweet sent!~n~~r~-$60", 2000, 1);
 	            }
	        }
		}
		case DIALOG_CHANGEPASS:
		{
		    if(response)
		    {
		        if(strlen(inputtext) < 4)
		        {
		            return SendClientMessage(playerid, COLOR_SYNTAX, "You need to enter a password greater than 4 characters.");
		        }

				new
				    password[129];

				WP_Hash(password, sizeof(password), inputtext);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET password = '%s' WHERE uid = %i", password, PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessage(playerid, COLOR_WHITE, "** Your account password was changed successfully.");
    		}
		}
		case DIALOG_BUYCLOTHINGTYPE:
		{
		    if(response)
		    {
		        PlayerInfo[playerid][pMenuType] = listitem;

		        if(listitem == 0)
					ShowClothingSelectionMenu(playerid);
				else
					ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHING);
		    }
		    else
		    {
		        callcmd::buy(playerid);
			}
		}
		case DIALOG_BUYCLOTHING:
		{
		    if(response)
		    {
		        PreviewClothing(playerid, listitem + PlayerInfo[playerid][pClothingIndex]);
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
			}
		}
		case DIALOG_CLOTHING:
		{
		    if(response)
		    {
		        if(!ClothingInfo[playerid][listitem][cExists])
		        {
		            return SendClientMessage(playerid, COLOR_SYNTAX, "The slot you've selected does not contain any item of clothing.");
		        }

		        if(ClothingInfo[playerid][listitem][cAttached]) {
					ShowPlayerDialog(playerid, DIALOG_CLOTHINGMENU, DIALOG_STYLE_LIST, ClothingInfo[playerid][listitem][cName], "Detach\nEdit\nDelete", "Select", "Cancel");
		        } else {
                    ShowPlayerDialog(playerid, DIALOG_CLOTHINGMENU, DIALOG_STYLE_LIST, ClothingInfo[playerid][listitem][cName], "Attach\nEdit\nDelete", "Select", "Cancel");
		        }

		        PlayerInfo[playerid][pSelected] = listitem;
			}
		}
		case DIALOG_CLOTHINGMENU:
		{
		    if(response)
		    {
		        new clothingid = PlayerInfo[playerid][pSelected];

		        switch(listitem)
		        {
		            case 0:
		            {
		                if(!ClothingInfo[playerid][clothingid][cAttached])
		                {
		                    ClothingInfo[playerid][clothingid][cAttachedIndex] = GetAvailableAttachedSlot(playerid);

		                    if(ClothingInfo[playerid][clothingid][cAttachedIndex] >= 0)
		                    {
			                    ClothingInfo[playerid][clothingid][cAttached] = 1;
                                if (IsPlayerAttachedObjectSlotUsed(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]))
								{
									RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
								}
			                    SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cPosZ], ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cRotZ],
									ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cScaleZ]);
								SM(playerid, COLOR_WHITE, "** %s attached to slot %i/10.", ClothingInfo[playerid][clothingid][cName], ClothingInfo[playerid][clothingid][cAttachedIndex] + 6);

								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET attached = 1 WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);
								mysql_tquery(connectionID, queryBuffer);
							}
							else
							{
							    SendClientMessage(playerid, COLOR_SYNTAX, "No attachment slots available. You can only have up to five clothing items attached at once.");
		                    }
		                }
		                else
		                {
		                    RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
		                    ClothingInfo[playerid][clothingid][cAttached] = 0;
		                    ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;

		                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET attached = 0 WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);
							mysql_tquery(connectionID, queryBuffer);

							SM(playerid, COLOR_WHITE, "** %s detached and added to inventory.", ClothingInfo[playerid][clothingid][cName]);
		                }
		            }
					case 1:
					{
				    	ShowPlayerDialog(playerid, DIALOG_CLOTHINGEDIT, DIALOG_STYLE_LIST, "Edition menu", "Edit offset\nChange bone", "Select", "Cancel");
					}
					case 2:
					{
				    	RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
				    	SM(playerid, COLOR_WHITE, "** %s deleted from your clothing inventory.", ClothingInfo[playerid][clothingid][cName]);

				    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM clothing WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);
				    	mysql_tquery(connectionID, queryBuffer);

					    ClothingInfo[playerid][clothingid][cAttached] = 0;
			            ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;
					    ClothingInfo[playerid][clothingid][cExists] = 0;
					    ClothingInfo[playerid][clothingid][cID] = 0;
					    ClothingInfo[playerid][clothingid][cName] = 0;
					}
				}
			}
		}
		case DIALOG_CLOTHINGEDIT:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                PlayerInfo[playerid][pEditType] = EDIT_CLOTHING;

		                if(!ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttached]) {
		                    SetPlayerAttachedObject(playerid, 9, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
								ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);

							EditAttachedObject(playerid, 9);
		                }
		                else {
		                    EditAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		                }

		                GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_CLOTHINGBONE, DIALOG_STYLE_LIST, "Choose a new bone for this clothing item.", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft shoulder\nRight shoulder\nNeck\nJaw", "Select", "Cancel");
					}
				}
			}
		}
		case DIALOG_CLOTHINGBONE:
		{
		    if(response)
		    {
		        ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone] = listitem + 1;

		        if(ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttached])
		        {
		            RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		            SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
		                ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
				}

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET boneid = %i WHERE id = %i", ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cID]);
				mysql_tquery(connectionID, queryBuffer);

				SM(playerid, COLOR_WHITE, "** Bone for "SVRCLR"%s"WHITE" changed to '%s'.", ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cName], inputtext);
		    }
		}
		case DIALOG_BUYVEHICLE:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pCash] < vehicleArray[listitem][carPrice])
		        {
		            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
		        }

		        new
		            string[128];

		        PlayerInfo[playerid][pSelected] = listitem;

				format(string, sizeof(string), "{FFD700}Confirmation:\nAre you sure you want to purchase this %s for "SVRCLR"$%i{FFD700}?", vehicleNames[vehicleArray[listitem][carModel] - 400], vehicleArray[listitem][carPrice]);
				ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE2, DIALOG_STYLE_MSGBOX, "Purchase confirmation", string, "Yes", "No");
			}
		}
		case DIALOG_BUYBOAT:
		{
		    if(response)
		    {
		        for(new i = 0; i < sizeof(vehicleArray); i ++)
		        {
		            if(!strcmp(vehicleArray[i][carCategory], "Boats"))
		            {
		                listitem += i;

		                if(PlayerInfo[playerid][pCash] < vehicleArray[listitem][carPrice])
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
				        }

				        new
				            string[128];

				        PlayerInfo[playerid][pSelected] = listitem;

						format(string, sizeof(string), "{FFD700}Confirmation:\nAre you sure you want to purchase this %s for "SVRCLR"$%i{FFD700}?", vehicleNames[vehicleArray[listitem][carModel] - 400], vehicleArray[listitem][carPrice]);
						ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE2, DIALOG_STYLE_MSGBOX, "Purchase confirmation", string, "Yes", "No");
						return 1;
					}
				}
		    }
		}
		case DIALOG_BUYAIRCRAFT:
		{
		    if(response)
		    {
		        for(new i = 0; i < sizeof(vehicleArray); i ++)
		        {
		            if(!strcmp(vehicleArray[i][carCategory], "Aircraft"))
		            {
		                listitem += i;

		                if(PlayerInfo[playerid][pCash] < vehicleArray[listitem][carPrice])
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
				        }

				        new
				            string[128];

				        PlayerInfo[playerid][pSelected] = listitem;

						format(string, sizeof(string), "{FFD700}Confirmation:\nAre you sure you want to purchase this %s for "SVRCLR"$%i{FFD700}?", vehicleNames[vehicleArray[listitem][carModel] - 400], vehicleArray[listitem][carPrice]);
						ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE2, DIALOG_STYLE_MSGBOX, "Purchase confirmation", string, "Yes", "No");
						return 1;
					}
				}
		    }
		}
		case DIALOG_BUYRENTVEH:
		{
		    if(response)
		    {
		        for(new i = 0; i < sizeof(vehicleArray); i ++)
		        {
		            if(!strcmp(vehicleArray[i][carCategory], "Rent"))
		            {
		                listitem += i;

		                if(PlayerInfo[playerid][pCash] < vehicleArray[listitem][carPrice])
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
				        }

				        new
				            string[128];

				        PlayerInfo[playerid][pSelected] = listitem;

						format(string, sizeof(string), "{FFD700}Confirmation:\nAre you sure you want to purchase this %s for "SVRCLR"$%i{FFD700}?", vehicleNames[vehicleArray[listitem][carModel] - 400], vehicleArray[listitem][carPrice]);
						ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE2, DIALOG_STYLE_MSGBOX, "Purchase confirmation", string, "Yes", "No");
						return 1;
					}
				}
		    }
		}
		case DIALOG_BUYVEHICLE2:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pGangCar])
		        {
		            new
		                string[20];

		            listitem = PlayerInfo[playerid][pSelected];

		            if(PlayerInfo[playerid][pCash] < vehicleArray[listitem][carPrice])
			        {
			            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
			        }
			        if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
					}
					if(GetGangVehicles(PlayerInfo[playerid][pGang]) >= GetGangVehicleLimit(PlayerInfo[playerid][pGang]))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your gang can't have more than %i vehicles at its level.", GetGangVehicleLimit(PlayerInfo[playerid][pGang]));
				    }

		            new
						Float:x,
						Float:y,
						Float:z,
						Float:angle;

		            if(IsPlayerInRangeOfPoint(playerid, 3.0, 542.0433, -1293.5909, 17.2422))
					{
						switch(random(3))
			    	    {
			        	    case 0: x = 562.3970, y = -1283.8485, z = 17.0007, angle = 0.0000;
			            	case 1: x = 557.8670, y = -1283.9822, z = 17.0007, angle = 0.0000;
			            	case 2: x = 552.8177, y = -1284.1307, z = 17.0007, angle = 0.0000;
						}
					}
					else if(IsPlayerInRangeOfPoint(playerid, 3.0, 154.2223, -1946.3030, 5.1920))
					{
					    switch(random(4))
			    	    {
			        	    case 0: x = 138.0530, y = -1828.8923, z = -0.4000, angle = 90.0000;
			            	case 1: x = 138.0067, y = -1819.7065, z = -0.4000, angle = 90.0000;
			            	case 2: x = 137.9428, y = -1810.7821, z = -0.4000, angle = 90.0000;
			            	case 3: x = 137.0448, y = -1801.4567, z = -0.4000, angle = 90.0000;
						}
					}
					else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1892.6315, -2328.6721, 13.5469))
					{
					    switch(random(3))
			    	    {
			        	    case 0: x = 1806.3048, y = -2424.4480, z = 15.0087, angle = 180.0000;
			            	case 1: x = 1847.3726, y = -2428.7100, z = 15.0087, angle = 180.0000;
			            	case 2: x = 1891.6610, y = -2433.3047, z = 15.0087, angle = 180.0000;
						}
					}

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (modelid, price, pos_x, pos_y, pos_z, pos_a, gangid, respawndelay) VALUES(%i, %i, '%f', '%f', '%f', '%f', %i, 600)", vehicleArray[listitem][carModel], vehicleArray[listitem][carPrice], x, y, z, angle, PlayerInfo[playerid][pGang]);
					mysql_tquery(connectionID, queryBuffer);

                    AddPointMoney(POINT_AUTOEXPORT, percent(vehicleArray[listitem][carPrice], 3));
			        mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);

			        format(string, sizeof(string), "~r~-$%i", vehicleArray[listitem][carPrice]);
		    	    GameTextForPlayer(playerid, string, 5000, 1);

					GivePlayerCash(playerid, -vehicleArray[listitem][carPrice]);
					PlayerInfo[playerid][pGangCar] = 0;

			        SM(playerid, COLOR_GREEN, "%s purchased for your gang for $%i. /ganghelp for more commands.", vehicleNames[vehicleArray[listitem][carModel] - 400], vehicleArray[listitem][carPrice]);
		    	    //Log_Write("log_give", "%s (uid: %i) purchased a %s for %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], vehicleNames[vehicleArray[listitem][carModel] - 400], GangInfo[PlayerInfo[playerid][pGang]][gName], vehicleArray[listitem][carPrice]);
		        }
		        else if(PlayerInfo[playerid][pRentCar])
		        {
		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM vehicles WHERE ownerid = %i AND rent = 1", PlayerInfo[playerid][pID]);
			        mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptBuyRentVehicle", "ii", playerid, PlayerInfo[playerid][pSelected]);
                    PlayerInfo[playerid][pRentCar] = 0;
				}
		        else
		        {
			        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerInfo[playerid][pID]);
			        mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptBuyVehicle", "ii", playerid, PlayerInfo[playerid][pSelected]);
				}
			}
		}
  		case DIALOG_SPAWNCAR:
		{
		    if(response)
		    {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerInfo[playerid][pID], listitem);
				mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehicle", "ii", playerid, false);
		    }
		}
		case DIALOG_DESPAWNCAR:
		{
		    if(response)
		    {
		        new count;

		        for(new i = 1; i < MAX_VEHICLES; i ++)
			 	{
			 	    if((VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i)) && (count++ == listitem))
			 	    {
			 	        if(IsVehicleOccupied(i) && GetVehicleDriver(i) != playerid)
			 	        {
			 	            return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is occupied.");
			 	        }

			 	        SM(playerid, COLOR_GREEN, "Your "SVRCLR"%s{CCFFFF} which is located in %s has been despawned.", GetVehicleName(i), GetVehicleZoneName(i));
            			DespawnVehicle(i);
            			return 1;
			 	    }
		        }
		    }
		}
		case DIALOG_FINDCAR:
		{
		    if(response)
		    {
		        new count, garageid;

		        for(new i = 1; i < MAX_VEHICLES; i ++)
			 	{
			 	    if((VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i)) && (count++ == listitem))
			 	    {
                        PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

			            if((garageid = GetVehicleGarage(i)) >= 1)
			            {
			                SetPlayerCheckpoint(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
			                SM(playerid, COLOR_YELLOW, "** Your %s is located in a garage. Checkpoint marked at the garage's location.", GetVehicleName(i));
			            }
			            else
			            {
			                new
			                    Float:x,
			                    Float:y,
			                    Float:z;

			                GetVehiclePos(i, x, y, z);
			                SetPlayerCheckpoint(playerid, x, y, z, 3.0);
			                SM(playerid, COLOR_YELLOW, "** Your %s is located in %s. Checkpoint marked at the location.", GetVehicleName(i), GetZoneName(x, y, z));
			            }

			            return 1;
		            }
				}
			}
		}
		case DIALOG_BIZINTERIOR:
		{
		    if(response)
		    {
		        new businessid = PlayerInfo[playerid][pSelected];

		        foreach(new i : Player)
		        {
		            if(GetInsideBusiness(i) == businessid)
		            {
						SetPlayerPos(i, bizInteriorArray[listitem][intX], bizInteriorArray[listitem][intY], bizInteriorArray[listitem][intZ]);
						SetPlayerFacingAngle(i, bizInteriorArray[listitem][intA]);
						SetPlayerInterior(i, bizInteriorArray[listitem][intID]);
						SetCameraBehindPlayer(i);
		            }
		        }

                BusinessInfo[businessid][bIntX] = bizInteriorArray[listitem][intX];
                BusinessInfo[businessid][bIntY] = bizInteriorArray[listitem][intY];
                BusinessInfo[businessid][bIntZ] = bizInteriorArray[listitem][intZ];
                BusinessInfo[businessid][bIntA] = bizInteriorArray[listitem][intA];
			    BusinessInfo[businessid][bInterior] = bizInteriorArray[listitem][intID];

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bID]);
			    mysql_tquery(connectionID, queryBuffer);

				ReloadBusiness(businessid);
			    SM(playerid, COLOR_GREEN, "You've changed the interior of business %i to %s.", businessid, bizInteriorArray[listitem][intName]);
		    }
		}
         case DIALOG_FACTIONLOCKER:
		{
		    if((response) && PlayerInfo[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerInfo[playerid][pFaction]))
		    {
				switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
				{
					case FACTION_POLICE, FACTION_MEDIC, FACTION_FEDERAL, FACTION_TERRORIST, FACTION_ARMY:
					{
					    if(listitem == 0) // Toggle duty
					    {
					        if(!PlayerInfo[playerid][pDuty])
					        {
					            if(IsLawEnforcement(playerid) || IsTerrorist(playerid))
					            {
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks in and grabs their police issued equipment from the locker.", GetRPName(playerid));
								}
								else if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_MEDIC)
					            {
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks in and grabs their medical supplies from the locker.", GetRPName(playerid));
								}

                                PlayerInfo[playerid][pDuty] = 1;

								SetPlayerHealth(playerid, 100.0);
								SetScriptArmour(playerid, 100.0);
							}
							else
							{
							    PlayerInfo[playerid][pDuty] = 0;
							    ResetPlayerWeaponsEx(playerid);

							    SetScriptArmour(playerid, 0.0);
								SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks out and puts their equipment back in the locker.", GetRPName(playerid));
							}
						}
						else if(listitem == 1) // Equipment
						{
		    				if(IsLawEnforcement(playerid) || IsTerrorist(playerid))
		    				{
						    	ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Vest\nMedkit\nNitestick\nMP5\nM4\ndeagle\nCompactShotgun", "Select", "Cancel");
							}
							else
							{
							    ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nFire Extinguisher\nPainkillers", "Select", "Cancel");
							}
						}
						else if(listitem == 2) // Uniforms
						{
						    if(!GetFactionSkinCount(PlayerInfo[playerid][pFaction]))
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no uniforms setup for your faction.");
							}
							if(PlayerInfo[playerid][pClothes] >= 0)
							{
							    PlayerInfo[playerid][pSkin] = PlayerInfo[playerid][pClothes];
							    PlayerInfo[playerid][pClothes] = -1;

							    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i, clothes = -1 WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
							    mysql_tquery(connectionID, queryBuffer);

							    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
							    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s switches back to their old outfit.", GetRPName(playerid));
							}
							else
							{
	                            PlayerInfo[playerid][pSkinSelected] = -1;
							    ShowPlayerDialog(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press "SVRCLR">> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
							}
						}
						else if(listitem == 3) //cloths
						{
						  
							ShowPlayerDialog(playerid, DIALOG_FACTIONCLOTHS, DIALOG_STYLE_LIST, "Toys", "Shield\nBlackGlass\nRedGlass\nBlueGlass\nVest", "Select", "Cancel");
						}
					}
					case FACTION_MECHANIC:
					{
						if(listitem == 0) // Toggle duty
					    {
					        if(!PlayerInfo[playerid][pDuty])
					        {
								if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_GOVERNMENT)
					            {
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks in and grabs their equipment from the locker.", GetRPName(playerid));
								}

                                PlayerInfo[playerid][pDuty] = 1;


							}
							else
							{
							    PlayerInfo[playerid][pDuty] = 0;
								SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks out and puts their equipment back in the locker.", GetRPName(playerid));
							}
						}
						if(listitem == 1) // Equipment
					    {
							ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Repairkit\nShortGun\nKelvarVest\nMedkit", "Select", "Cancel");

						}
						else if(listitem == 2) // Uniforms
						{
						    if(!GetFactionSkinCount(PlayerInfo[playerid][pFaction]))
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no uniforms setup for your faction.");
							}
							if(PlayerInfo[playerid][pClothes] >= 0)
							{
							    PlayerInfo[playerid][pSkin] = PlayerInfo[playerid][pClothes];
							    PlayerInfo[playerid][pClothes] = -1;

							    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i, clothes = -1 WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
							    mysql_tquery(connectionID, queryBuffer);

							    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
							    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s switches back to their old outfit.", GetRPName(playerid));
							}
							else
							{
	                            PlayerInfo[playerid][pSkinSelected] = -1;
							    ShowPlayerDialog(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press "SVRCLR">> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
							}
						}
					}

					case FACTION_GOVERNMENT, FACTION_NEWS:
					{
						if(listitem == 0) // Toggle duty
					    {
					        if(!PlayerInfo[playerid][pDuty])
					        {
								if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_GOVERNMENT)
					            {
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks in and grabs their equipment from the locker.", GetRPName(playerid));
								}

                                PlayerInfo[playerid][pDuty] = 1;

								SetPlayerHealth(playerid, 100.0);
								SetScriptArmour(playerid, 100.0);
							}
							else
							{
							    PlayerInfo[playerid][pDuty] = 0;
							    ResetPlayerWeaponsEx(playerid);

							    SetScriptArmour(playerid, 0.0);
								SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s clocks out and puts their equipment back in the locker.", GetRPName(playerid));
							}
						}
					    if(listitem == 1) // Equipment
					    {

					        if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FACTION_GOVERNMENT)
          					{
          					    ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nMP5\nM4", "Select", "Cancel");
							}
							else
							{
							    ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nCamera", "Select", "Cancel");
							}
						}
						else if(listitem == 2) // Uniforms
						{
						    if(!GetFactionSkinCount(PlayerInfo[playerid][pFaction]))
						    {
						        return SendClientMessage(playerid, COLOR_SYNTAX, "There are no uniforms setup for your faction.");
							}
							if(PlayerInfo[playerid][pClothes] >= 0)
							{
							    PlayerInfo[playerid][pSkin] = PlayerInfo[playerid][pClothes];
							    PlayerInfo[playerid][pClothes] = -1;

							    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i, clothes = -1 WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
							    mysql_tquery(connectionID, queryBuffer);

							    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s switches back to their old outfit.", GetRPName(playerid));
							}
							else
							{
							    PlayerInfo[playerid][pSkinSelected] = -1;
						    	ShowPlayerDialog(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press "SVRCLR">> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
							}
						}
					}
					
					case FACTION_HITMAN:
					{
					    if(listitem == 0) // Order weapons
					    {
					        ShowPlayerDialog(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Order weapons", "Kevlar Vest ($100)\nKnife ($150)\nSilenced pistol ($100)\nShotgun ($150)\nDesert Eagle ($200)\nMP5 ($250)\nCountry rifle ($400)\nAK-47 ($600)\nM4 ($800)\nSniper rifle ($900)\nBomb ($750)", "Order", "Cancel");
						}
						else if(listitem == 1) // Change clothes
						{
						    ShowPlayerDialog(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.net/wiki/Skins:All ))", "Submit", "Cancel");
						}
					}
		        }
			}
		}

		case DIALOG_HITMANCLOTHES:
		{
		    if((response) && PlayerInfo[playerid][pFaction] >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, FactionInfo[PlayerInfo[playerid][pFaction]][fLockerX], FactionInfo[PlayerInfo[playerid][pFaction]][fLockerY], FactionInfo[PlayerInfo[playerid][pFaction]][fLockerZ]))
		    {
				new skinid;

		    	if(sscanf(inputtext, "i", skinid))
				{
					return ShowPlayerDialog(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.net/wiki/Skins:All ))", "Submit", "Cancel");
		        }
		        if(!(0 <= skinid <= 311))
		        {
		            SendClientMessage(playerid, COLOR_SYNTAX, "Invalid skin.");
		            return ShowPlayerDialog(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.net/wiki/Skins:All ))", "Submit", "Cancel");
		        }

		        PlayerInfo[playerid][pSkin] = skinid;
		        SetPlayerSkin(playerid, skinid);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				Dyuze(playerid, "Notice", "~w~Clothes changed for free");
		    }
		}
	
		case DIALOG_FACTIONSKINS:
		{
		    if(PlayerInfo[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerInfo[playerid][pFaction]))
		    {
		        if(response)
		        {
					new index = PlayerInfo[playerid][pSkinSelected] + 1;

					if(index >= MAX_FACTION_SKINS)
					{
					    // When the player is shown the dialog for the first time, their skin isn't changed until they click >> Next.
					    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
					    PlayerInfo[playerid][pSkinSelected] = -1;
					}
					else
					{
					    // Find the next skin in the array.
						for(new i = index; i < MAX_FACTION_SKINS; i ++)
						{
						    if(FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i] != 0)
						    {
						        SetPlayerSkin(playerid, FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i]);
						        PlayerInfo[playerid][pSkinSelected] = i;
						        break;
					        }
		                }

		                if(index == PlayerInfo[playerid][pSkinSelected] + 1)
		                {
		                    // Looks like there was no skin found. So, we'll go back to the very first valid skin in the skin array.
		                    for(new i = 0; i < MAX_FACTION_SKINS; i ++)
							{
						    	if(FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i] != 0)
						    	{
		                            SetPlayerSkin(playerid, FactionInfo[PlayerInfo[playerid][pFaction]][fSkins][i]);
						        	PlayerInfo[playerid][pSkinSelected] = i;
						        	break;
								}
							}
		                }
		            }

		            ShowPlayerDialog(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press "SVRCLR">> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
		        }
		        else
		        {
		            PlayerInfo[playerid][pClothes] = PlayerInfo[playerid][pSkin];
		            PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
		            PlayerInfo[playerid][pSkinSelected] = -1;

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i, clothes = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pClothes], PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);

		            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes a uniform out of the locker and puts it on.", GetRPName(playerid));
				}
		    }
		}
		case DIALOG_FACTIONEQUIPMENT:
		{
		    if((response) && PlayerInfo[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerInfo[playerid][pFaction]))
		    {
				switch(FactionInfo[PlayerInfo[playerid][pFaction]][fType])
				{
					case FACTION_POLICE, FACTION_FEDERAL, FACTION_TERRORIST, FACTION_ARMY:
					{
					    switch(listitem)
					    {
					        case 0:
					        {
								if( PlayerInfo[playerid][pVest] >= 5)
								{
									if(gNotification)
										notification_show(playerid, str_format("You can't carry more than 5 vest"),2000, NOTIF_ERROR);			
									return SendClientMessage(playerid, COLOR_SYNTAX, "You can't carry more than 5 vest.");
								}
					            PlayerInfo[playerid][pVest] ++;
								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerInfo[playerid][pVest], PlayerInfo[playerid][pID]);
					            mysql_tquery(connectionID, queryBuffer);
								if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an Vest from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);			
								SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a Vest from the locker and and stores it in locker.", GetRPName(playerid));
					        }
					        case 1:
					        {
					            SetPlayerHealth(playerid, 100.0);
								if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an Medkit from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);			
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
					        }
					        case 2:
					        {
                                GiveWeapon(playerid, 3);
								if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an nitestick from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);			
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a nitestick from the locker.", GetRPName(playerid));
					        }
					        case 3:
					        {
								GiveWeapon(playerid, 29);
								if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an mp5 from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);			
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a MP5 from the locker.", GetRPName(playerid));
					        }
					        case 4:
					        {
					            GiveWeapon(playerid, 31);
								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO weapons (weaponid, ammo, slot, ownername, ownerid) VALUES(31, 99999, %i, '%s', %i)", GetWeaponSlot(31), GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
	                            mysql_tquery(connectionID, queryBuffer);
								mysql_tquery(connectionID, "SELECT * FROM weapons WHERE uid = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_WEAPON, 0);
								if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an m4 from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);			
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs an m4 from the locker.", GetRPName(playerid));
					        }
							case 5:
					        {
					            GiveWeapon(playerid, 24);
				                if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an Deagle from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);								
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs an Deagle from the locker.", GetRPName(playerid));
					        }
							case 6:
					        {
					            GiveWeapon(playerid, 27);
				                if(gNotification)
									notification_show(playerid, str_format("**{C2A2DA} %s grabs an Combat Shotgun from the locker.", GetRPName(playerid)),2000, NOTIF_SUCCESS);				
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs an Combat Shotgun from the locker.", GetRPName(playerid));
					        }
							

						}
					}
					case FACTION_MEDIC:
					{
					    switch(listitem)
					    {
					        case 0:
					        {
					            SetScriptArmour(playerid, 100.0);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
					        }
					        case 1:
					        {
					            PlayerInfo[playerid][pMedkit] += 1;
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a Medkits from the locker.", GetRPName(playerid));

					            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET medkit = %i WHERE uid = %i", PlayerInfo[playerid][pMedkit], PlayerInfo[playerid][pID]);
	                            mysql_tquery(connectionID, queryBuffer);
					        }
					        case 2:
					        {
                                GiveWeapon(playerid, 42);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a fire extinguisher from the locker.", GetRPName(playerid));
					        }
					        case 3:
					        {
					            PlayerInfo[playerid][pPainkillers] += 2;
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a 2 pack of painkillers from the locker.", GetRPName(playerid));

					            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
					            mysql_tquery(connectionID, queryBuffer);
					        }
						}
					}
					case FACTION_MECHANIC:
					{
						switch(listitem)
						{
						        case 0:
						        {
						            new price = 500;
						            if (PlayerInfo[playerid][pCash] < price)
						            {
										SM(playerid, COLOR_AQUA, "You need 500$ in your hand to take repairkit from locker.");
										return SendClientMessage(playerid, COLOR_SYNTAX, "~n~ Not Enough Money");
									}
						            PlayerInfo[playerid][pRepairKit] += 1;
								    GivePlayerCash(playerid, -price);

								    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
								    mysql_tquery(connectionID, queryBuffer);
									SM(playerid, COLOR_AQUA, "** You ordered a repairkit for $500.");
									SendClientMessage(playerid,COLOR_BLUE, " +1 repairkit");
								}
					            case 1:
					            {
					               GiveWeapon(playerid, 25);
					               SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a Shotgun from the locker.", GetRPName(playerid));
					            }
								case 2:
					            {
					                SetScriptArmour(playerid, 100.0);
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
					            }
	                            case 3:
					            {
					                PlayerInfo[playerid][pMedkit] += 1;
					                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a Medkits from the locker.", GetRPName(playerid));

					                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET medkit = %i WHERE uid = %i", PlayerInfo[playerid][pMedkit], PlayerInfo[playerid][pID]);
	                                mysql_tquery(connectionID, queryBuffer);
					            }
						}
					}
					case FACTION_GOVERNMENT:
					{
					    switch(listitem)
					    {
					        case 0:
					        {
					            SetScriptArmour(playerid, 100.0);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
					        }
					        case 1:
					        {
					            SetPlayerHealth(playerid, 100.0);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
					        }
					    
					        case 2:
					        {
					            GiveWeapon(playerid, 29);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs an MP5 from the locker.", GetRPName(playerid));
					        }
					        case 3:
					        {
					            GiveWeapon(playerid, 31);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs an M4 from the locker.", GetRPName(playerid));
					        }
					    }
					}
					case FACTION_NEWS:
					{
					    switch(listitem)
					    {
					        case 0:
					        {
					            SetScriptArmour(playerid, 100.0);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
					        }
					        case 1:
					        {
					            SetPlayerHealth(playerid, 100.0);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
					        }
					        case 2:
					        {
					            GiveWeapon(playerid, 43);
					            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s grabs a digital camera from the locker.", GetRPName(playerid));
					        }
					    }
					}
					case FACTION_HITMAN:
					{
					    switch(listitem)
					    {
					        case 0:
							{
							    if(PlayerInfo[playerid][pCash] < 100)
							    {

							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

					            GivePlayerCash(playerid, -100);
					            SetScriptArmour(playerid, 100.0);

					            SM(playerid, COLOR_AQUA, "** You ordered a kevlar vest for $100.");


					    	}
							case 1:
							{
							    if(PlayerInfo[playerid][pCash] < 150)
							    {
								
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

					            GiveWeapon(playerid, 4);
					            GivePlayerCash(playerid, -150);

					            SM(playerid, COLOR_AQUA, "** You ordered a knife for $150.");
								
					    	}
					    	case 2:
							{
							    if(PlayerInfo[playerid][pCash] < 100)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 23);
					            GivePlayerCash(playerid, -100);

					            SM(playerid, COLOR_AQUA, "** You ordered  for $100.");
								

					    	}
					    	case 3:
							{
							    if(PlayerInfo[playerid][pCash] < 150)
							    {
								
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 25);
					            GivePlayerCash(playerid, -150);
					            
					    	}
					    	case 4:
							{
							    if(PlayerInfo[playerid][pCash] < 200)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");

					            }

								GiveWeapon(playerid, 24);
					            GivePlayerCash(playerid, -200);

								
					    	}
					    	case 5:
							{
							    if(PlayerInfo[playerid][pCash] < 250)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 29);
					            GivePlayerCash(playerid, -250);

					            SM(playerid, COLOR_AQUA, "** You ordered an MP5 for $250.");
					            
					    	}
					    	case 6:
							{
							    if(PlayerInfo[playerid][pCash] < 400)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 33);
					            GivePlayerCash(playerid, -400);

					            SM(playerid, COLOR_AQUA, "** You ordered a country rifle for $400.");
	                        }
					    	case 7:
							{
							    if(PlayerInfo[playerid][pCash] < 600)
							    {
								
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 30);
					            GivePlayerCash(playerid, -600);

					            SM(playerid, COLOR_AQUA, "** You ordered an AK-47 for $600.");

					    	}
					    	case 8:
							{
							    if(PlayerInfo[playerid][pCash] < 800)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 31);
					            GivePlayerCash(playerid, -800);

					            SM(playerid, COLOR_AQUA, "** You ordered an M4 for $800.");
							
					    	}
					    	case 9:
							{
							    if(PlayerInfo[playerid][pCash] < 900)
							    {
									
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }

								GiveWeapon(playerid, 34);
					            GivePlayerCash(playerid, -900);

					            SM(playerid, COLOR_AQUA, "** You ordered a sniper rifle for $900.");
								
					    	}
					    	case 10:
							{
							    if(PlayerInfo[playerid][pCash] < 750)
							    {
							        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford this weapon.");
					            }
					            if(PlayerInfo[playerid][pBombs] > 3)
					            {
					                return SendClientMessage(playerid, COLOR_SYNTAX, "You have more than 3 bombs. You can't buy anymore.");
								}

					            PlayerInfo[playerid][pBombs]++;
					            GivePlayerCash(playerid, -750);

								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bombs = %i WHERE uid = %i", PlayerInfo[playerid][pBombs], PlayerInfo[playerid][pID]);
								mysql_tquery(connectionID, queryBuffer);

					            SM(playerid, COLOR_AQUA, "** You ordered a bomb for $750. /plantbomb to place the bomb.");
								
					    	}
					    }
					}
				}
			}
		}
     
        case DIALOG_MDC:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                static string[2048], count;

		                string = "Suspect\tLocation\tWanted level";

		                count = 0;

						foreach(new i : Player)
						{
						    if(PlayerInfo[i][pWantedLevel] > 0)
						    {
						        format(string, sizeof(string), "%s\n%s\t%s\t%i/6", string, GetRPName(i), GetPlayerZoneName(i), PlayerInfo[i][pWantedLevel]);
						        count++;
						    }
						}

						if(!count)
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "There are currently no wanted suspects online.");
						}

						ShowPlayerDialog(playerid, DIALOG_MDCWANTED, DIALOG_STYLE_TABLIST_HEADERS, "Suspects wanted", string, "Track", "Cancel");
					}
					case 1:
					{
					    ShowPlayerDialog(playerid, DIALOG_PLAYERLOOKUP, DIALOG_STYLE_INPUT, "Player lookup", "Enter the full name of the player to lookup:", "Submit", "Cancel");
					}
					case 2:
					{
					    ShowPlayerDialog(playerid, DIALOG_VEHICLELOOKUP1, DIALOG_STYLE_INPUT, "Vehicle lookup", "Enter the ID of the vehicle to lookup.\n(( You can find out the ID of a vehicle by using /dl. ))", "Submit", "Cancel");
					}
				}
			}
		}
  case DIALOG_MDCWANTED:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
		        foreach(new i : Player)
				{
    				if(!strcmp(GetRPName(i), inputtext))
    				{
    				    new
    				        Float:x,
    				        Float:y,
    				        Float:z;

    				    GetPlayerPosEx(i, x, y, z);

    				    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

    				    SetPlayerCheckpoint(playerid, x, y, z, 3.0);
    				    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the suspect's last known location.");
						return 1;
					}
				}

				SendClientMessage(playerid, COLOR_SYNTAX, "The suspect you've selected has went offline.");
			}
		}
		case DIALOG_PLAYERLOOKUP:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
		        new username[MAX_PLAYER_NAME];

		        if(sscanf(inputtext, "s[24]", username))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_PLAYERLOOKUP, DIALOG_STYLE_INPUT, "Player lookup", "Enter the full name of the player to lookup:", "Submit", "Cancel");
				}

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, gender, age, wantedlevel, crimes, arrested, carlicense, gunlicense FROM users WHERE username = '%e'", username);
				mysql_tquery(connectionID, queryBuffer, "MDC_PlayerLookup", "is", playerid, username);
			}
		}
  case DIALOG_MDCPLAYER1:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
		        ShowPlayerDialog(playerid, DIALOG_MDCPLAYER2, DIALOG_STYLE_LIST, "Options", "Show active charges\nClear charges\nCheck Vehicles", "Select", "Cancel");
			}
		}
  case DIALOG_MDCPLAYER2:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM charges WHERE uid = %i", PlayerInfo[playerid][pSelected]);
		                mysql_tquery(connectionID, queryBuffer, "MDC_ListCharges", "i", playerid);
		            }
		            case 1:
		            {
		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username FROM users WHERE uid = %i", PlayerInfo[playerid][pSelected]);
		                mysql_tquery(connectionID, queryBuffer, "MDC_ClearCharges", "i", playerid);
		            }
		            case 2:
		            {
		                SM(playerid, SERVER_COLOR, "[!]"WHITE" Coming soon.");
					}
				}
		    }
		}
		case DIALOG_MDCCHARGES:
		{
		    ShowPlayerDialog(playerid, DIALOG_MDCPLAYER2, DIALOG_STYLE_LIST, "Options", "Show active charges\nClear charges", "Select", "Cancel");
		}
		case DIALOG_VEHICLELOOKUP1:
		{
		    if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
			    new vehicleid, string[512];

			    if(sscanf(inputtext, "i", vehicleid))
			    {
		    	    return ShowPlayerDialog(playerid, DIALOG_VEHICLELOOKUP1, DIALOG_STYLE_INPUT, "Vehicle lookup", "Enter the ID of the vehicle to lookup.\n(( You can find out the ID of a vehicle by using /dl. ))", "Submit", "Cancel");
				}
				if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The vehicle ID specified is not owned by any particular person.");
			    	return ShowPlayerDialog(playerid, DIALOG_VEHICLELOOKUP1, DIALOG_STYLE_INPUT, "Vehicle lookup", "Enter the ID of the vehicle to lookup.\n(( You can find out the ID of a vehicle by using /dl. ))", "Submit", "Cancel");
				}

				PlayerInfo[playerid][pSelected] = vehicleid;

				format(string, sizeof(string), "Name: %s\nPlate: %s\nOwner: %s\nTickets: $%i\nLocation: %s", GetVehicleName(vehicleid), VehicleInfo[vehicleid][vPlate], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vTickets], GetVehicleZoneName(vehicleid));
            	ShowPlayerDialog(playerid, DIALOG_VEHICLELOOKUP2, DIALOG_STYLE_MSGBOX, "Vehicle lookup", string, "Track", "Cancel");
			}
		}
		case DIALOG_VEHICLELOOKUP2:
		{
			if((response) && (IsLawEnforcement(playerid) || IsGovernment(playerid)))
		    {
				new garageid, vehicleid = PlayerInfo[playerid][pSelected];

				if((garageid = GetVehicleGarage(vehicleid)) >= 0)
				{
				    SetPlayerCheckpoint(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
				    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the garage this vehicle is inside of.");
				}
				else
				{
				    new
						Float:x,
						Float:y,
						Float:z;

                    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the vehicle's last known location.");

					GetVehiclePos(vehicleid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);
				}

    			PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
			}
		}
		case DIALOG_FACTIONPAY1:
		{
		    if((response) && GetFactionType(playerid) == FACTION_GOVERNMENT)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowPlayerDialog(playerid, DIALOG_FACTIONPAY2, DIALOG_STYLE_INPUT, "Change paycheck", "Enter the new paycheck amount for this rank:", "Submit", "Back");
		    }
		}
		case DIALOG_FACTIONPAY2:
		{
		    if(GetFactionType(playerid) == FACTION_GOVERNMENT)
		    {
		        if(response)
		        {
		            new amount, factionid = PlayerInfo[playerid][pFactionEdit], rankid = PlayerInfo[playerid][pSelected];

		            if(sscanf(inputtext, "i", amount))
		            {
		                return ShowPlayerDialog(playerid, DIALOG_FACTIONPAY2, DIALOG_STYLE_INPUT, "Change paycheck", "Enter the new paycheck amount for this rank:", "Submit", "Back");
					}
					if(!(1 <= amount <= 30000))
					{
					    SendClientMessage(playerid, COLOR_SYNTAX, "The specified amount must range from $1 to $30000.");
					    return ShowPlayerDialog(playerid, DIALOG_FACTIONPAY2, DIALOG_STYLE_INPUT, "Change paycheck", "Enter the new paycheck amount for this rank:", "Submit", "Back");
					}

					FactionInfo[factionid][fPaycheck][rankid] = amount;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionpay VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE amount = %i", factionid, rankid, amount, amount);
				    mysql_tquery(connectionID, queryBuffer);

					SM(playerid, COLOR_GREEN, "You have set the paycheck for rank %i to $%i.", rankid, amount);
				    ////Log_Write("log_faction", "%s (uid: %i) set %s's (id: %i) paycheck for rank %i to $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], FactionInfo[factionid][fName], factionid, rankid, amount);				
		        }

				ShowDialogToPlayer(playerid, DIALOG_FACTIONPAY1);
		    }
		}
		case DIALOG_PHONEBOOK:
		{
		    if(response)
		    {
		        if(!strcmp(inputtext, ">> Next page", true))
		        {
		            PlayerInfo[playerid][pPage]++;
		            ShowDialogToPlayer(playerid, DIALOG_PHONEBOOK);
		        }
		        else if(!strcmp(inputtext, "<< Go back", true) && PlayerInfo[playerid][pPage] > 1)
		        {
		            PlayerInfo[playerid][pPage]--;
		            ShowDialogToPlayer(playerid, DIALOG_PHONEBOOK);
		        }
		    }
		}
		case DIALOG_CREATEZONE:
		{
		    if((response) && PlayerInfo[playerid][pAdmin] >= 5)
		    {
		        PlayerInfo[playerid][pMinX] = 0.0;
		        PlayerInfo[playerid][pMinY] = 0.0;
		        PlayerInfo[playerid][pMaxX] = 0.0;
		        PlayerInfo[playerid][pMaxY] = 0.0;

		        if(PlayerInfo[playerid][pZoneType] == ZONETYPE_LAND)
				{
					new Float:lx = PlayerInfo[playerid][plX],
					    Float:ly = PlayerInfo[playerid][plY],
					    Float:lz = PlayerInfo[playerid][plZ];

                    GetPlayerPos(playerid, lx, ly, lz);
					PlayerInfo[playerid][plX] = lx;
					PlayerInfo[playerid][plY] = ly;
					PlayerInfo[playerid][plZ] = lz;

			        PlayerInfo[playerid][pZoneCreation] = ZONETYPE_LAND;
			        SendClientMessage(playerid, COLOR_WHITE, "** Your land needs to be within a square or rectangle. /confirm to set the four boundary points.");
				}
				else if(PlayerInfo[playerid][pZoneType] == ZONETYPE_TURF)
				{
			        PlayerInfo[playerid][pZoneCreation] = ZONETYPE_TURF;
			        SendClientMessage(playerid, COLOR_WHITE, "** Your turf needs to be within a square or rectangle. /confirm to set the four boundary points.");
				}
				else if(PlayerInfo[playerid][pZoneType] == ZONETYPE_POINT)
				{
			        PlayerInfo[playerid][pZoneCreation] = ZONETYPE_POINT;
			        SendClientMessage(playerid, COLOR_WHITE, "** Your Point needs to be within a square or rectangle. /confirm to set the four boundary points.");
				}
		    }
		}
		case DIALOG_CONFIRMZONE:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_LAND)
		        {
			        for(new i = 0; i < MAX_LANDS; i ++)
					{
					    if(!LandInfo[i][lExists])
					    {
					        new
					            Float:minx = PlayerInfo[playerid][pMinX],
					            Float:miny = PlayerInfo[playerid][pMinY],
					            Float:maxx = PlayerInfo[playerid][pMaxX],
					            Float:maxy = PlayerInfo[playerid][pMaxY],
					            Float:z;

	            			GetPlayerPos(playerid, z, z, z);

					        if(minx > maxx)
							{
	                            PlayerInfo[playerid][pMinX] = maxx;
	                            PlayerInfo[playerid][pMaxX] = minx;
					        }
					        if(miny > maxy)
							{
					            PlayerInfo[playerid][pMinY] = maxy;
					            PlayerInfo[playerid][pMaxY] = miny;
					        }

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO lands (price, min_x, min_y, max_x, max_y, height, lx, ly, lz) VALUES(%i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", PlayerInfo[playerid][pLandCost], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z, PlayerInfo[playerid][plX], PlayerInfo[playerid][plY], PlayerInfo[playerid][plZ]);
							mysql_tquery(connectionID, queryBuffer, "OnAdminCreateLand", "iiiffffffff", playerid, i, PlayerInfo[playerid][pLandCost], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z, PlayerInfo[playerid][plX], PlayerInfo[playerid][plY], PlayerInfo[playerid][plZ]);
	      					CancelZoneCreation(playerid);
							return 1;
						}
					}

					SendClientMessage(playerid, COLOR_SYNTAX, "Land slots are currently full. Ask supervisors to increase the internal limit.");
					CancelZoneCreation(playerid);
		    	}
		    	else if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_TURF)
		    	{
		    	    for(new i = 1; i < MAX_TURFS; i ++)
					{
					    if(!TurfInfo[i][tExists])
					    {
					        new
					            Float:minx = PlayerInfo[playerid][pMinX],
					            Float:miny = PlayerInfo[playerid][pMinY],
					            Float:maxx = PlayerInfo[playerid][pMaxX],
					            Float:maxy = PlayerInfo[playerid][pMaxY],
					            Float:z;

	            			GetPlayerPos(playerid, z, z, z);

					        if(minx > maxx)
							{
	                            PlayerInfo[playerid][pMinX] = maxx;
	                            PlayerInfo[playerid][pMaxX] = minx;
					        }
					        if(miny > maxy)
							{
					            PlayerInfo[playerid][pMinY] = maxy;
					            PlayerInfo[playerid][pMaxY] = miny;
					        }

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO turfs (id, name, type, min_x, min_y, max_x, max_y, height) VALUES(%i, '%e', %i, '%f', '%f', '%f', '%f', '%f')", i, PlayerInfo[playerid][pTurfName], PlayerInfo[playerid][pTurfType], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z);
							mysql_tquery(connectionID, queryBuffer, "OnAdminCreateTurf", "iisifffff", playerid, i, PlayerInfo[playerid][pTurfName], PlayerInfo[playerid][pTurfType], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z);
	      					CancelZoneCreation(playerid);
							return 1;
						}
					}

					SendClientMessage(playerid, COLOR_SYNTAX, "Turf slots are currently full. Ask supervisors to increase the internal limit.");
					CancelZoneCreation(playerid);
		    	}
                else if(PlayerInfo[playerid][pZoneCreation] == ZONETYPE_POINT)
		    	{
		    	    for(new i = 1; i < MAX_POINTS; i ++)
					{
					    if(!PointInfo[i][pExists])
					    {
					        new
					            Float:minx = PlayerInfo[playerid][pMinX],
					            Float:miny = PlayerInfo[playerid][pMinY],
					            Float:maxx = PlayerInfo[playerid][pMaxX],
					            Float:maxy = PlayerInfo[playerid][pMaxY],
					            Float:z;

	            			GetPlayerPos(playerid, z, z, z);

					        if(minx > maxx)
							{
	                            PlayerInfo[playerid][pMinX] = maxx;
	                            PlayerInfo[playerid][pMaxX] = minx;
					        }
					        if(miny > maxy)
							{
					            PlayerInfo[playerid][pMinY] = maxy;
					            PlayerInfo[playerid][pMaxY] = miny;
					        }

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO points (id, name, type, min_x, min_y, max_x, max_y, height) VALUES(%i, '%e', %i, '%f', '%f', '%f', '%f', '%f')", i, PlayerInfo[playerid][pPointName], PlayerInfo[playerid][pPointType], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z);
							mysql_tquery(connectionID, queryBuffer, "OnAdminCreatePoint", "iisifffff", playerid, i, PlayerInfo[playerid][pPointName], PlayerInfo[playerid][pPointType], PlayerInfo[playerid][pMinX], PlayerInfo[playerid][pMinY], PlayerInfo[playerid][pMaxX], PlayerInfo[playerid][pMaxY], z);
	      					CancelZoneCreation(playerid);
							return 1;
						}
					}

					SendClientMessage(playerid, COLOR_SYNTAX, "Point slots are currently full. Ask supervisors to increase the internal limit.");
					CancelZoneCreation(playerid);
		    	}
			}
			else
			{
			    CancelZoneCreation(playerid);

		        if(PlayerInfo[playerid][pZoneType] == ZONETYPE_LAND)
				{
					SendClientMessage(playerid, COLOR_WHITE, "** Your land needs to be within a square or rectangle. /confirm to set the four boundary points.");
					SendClientMessage(playerid, COLOR_WHITE, "** Note: You can use /landcancel to exit land creation mode.");
					PlayerInfo[playerid][pZoneCreation] = ZONETYPE_LAND;
				}
				else if(PlayerInfo[playerid][pZoneType] == ZONETYPE_TURF)
				{
					SendClientMessage(playerid, COLOR_WHITE, "** Your turf needs to be within a square or rectangle. /confirm to set the four boundary points.");
					SendClientMessage(playerid, COLOR_WHITE, "** Note: You can use /turfcancel to exit turf creation mode.");
					PlayerInfo[playerid][pZoneCreation] = ZONETYPE_TURF;
				}
				else if(PlayerInfo[playerid][pZoneType] == ZONETYPE_POINT)
				{
					SendClientMessage(playerid, COLOR_WHITE, "** Your Point needs to be within a square or rectangle. /confirm to set the four boundary points.");
					SendClientMessage(playerid, COLOR_WHITE, "** Note: You can use /pointcancel to exit turf creation mode.");
					PlayerInfo[playerid][pZoneCreation] = ZONETYPE_POINT;
				}
			}
		}
		case DIALOG_LANDBUILDTYPE:
		{
		    new landid = GetNearbyLand(playerid);

		    if(landid == -1 || !HasLandPerms(playerid, landid))
			{
				return 0;
			}

	   	    if(response)
	        {
				PlayerInfo[playerid][pMenuType] = listitem;
				ShowDialogToPlayer(playerid, DIALOG_LANDBUILD1);
			}
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
			}
		}
        case DIALOG_LANDBUILD1:
	    {
	        new landid = GetNearbyLand(playerid);

		    if(landid == -1 || !HasLandPerms(playerid, landid))
			{
				return 0;
			}

	   	    if(response)
	        {
	            switch(PlayerInfo[playerid][pMenuType])
	            {
	                case 0: // Model selection
	                {
						PlayerInfo[playerid][pCategory] = listitem;
						ShowObjectSelectionMenu(playerid, MODEL_SELECTION_LANDOBJECTS);
	                }
	                case 1:
	                {
						PlayerInfo[playerid][pCategory] = listitem;
						ShowDialogToPlayer(playerid, DIALOG_LANDBUILD2);
					}
     	       }
			}
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_LANDBUILDTYPE);
			}
	    }
	    case DIALOG_LANDBUILD2:
	    {
	        new landid = GetNearbyLand(playerid);

		    if(landid == -1 || !HasLandPerms(playerid, landid))
			{
				return 0;
			}

	        if(response)
	        {
                PurchaseLandObject(playerid, landid, listitem + PlayerInfo[playerid][pFurnitureIndex]);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_LANDBUILD1);
			}
	    }
	    case DIALOG_LANDMENU:
	    {
	        new landid = GetNearbyLand(playerid);

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
		        switch(listitem)
		        {
		            case 0:
		            {
           		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
						mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_LANDOBJECTS, playerid);
					}
					case 1:
					{
					    ShowPlayerDialog(playerid, DIALOG_LANDEDITOBJECT, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
					}
					case 2:
					{
						if(!LandInfo[landid][lLabels])
					    {
					        LandInfo[landid][lLabels] = 1;
					        SendClientMessage(playerid, COLOR_GREEN, "You will now see labels appear above the objects in your land.");
					    }
					    else
					    {
					        LandInfo[landid][lLabels] = 0;
					        SendClientMessage(playerid, COLOR_GREEN, "You will no longer see any labels appear above your land objects.");
					    }

					    ReloadAllLandObjects(landid);
					    ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
					}
					case 3:
					{
					    ShowPlayerDialog(playerid, DIALOG_LANDSELLALL, DIALOG_STYLE_MSGBOX, "Clear objects", "This option sells all the objects in your land. You will receive\n75 percent of the total cost of all your objects.\n\nPress "SVRCLR"Confirm{A9C4E4} to proceed with the operation.", "Confirm", "Back");
					}
					case 4:
					{
					    ShowPlayerDialog(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
					}
					case 5:
					{
					    if(LandInfo[landid][lLevel] >= 3)
					    {
					        return SendClientMessage(playerid, COLOR_GREY, "Your land can't be upgraded any further.");
					    }

					    new
					        string[224];

					    format(string, sizeof(string), "You are about to upgrade your land to level %i/5.\n\nThis upgrade will cost you {00AA00}$100,000{A9C4E4} and unlocks %i more\nobject slots for your land.\n\nAre you sure you want to upgrade your land?", LandInfo[landid][lLevel] + 1, GetLandObjectCapacity(LandInfo[landid][lLevel] + 1) - GetLandObjectCapacity(LandInfo[landid][lLevel]));
						ShowPlayerDialog(playerid, DIALOG_LANDUPGRADE, DIALOG_STYLE_MSGBOX, "Upgrade land", string, "Yes", "No");
					}
   				}
	        }
	    }
	    case DIALOG_LANDUPGRADE:
	    {
	        new landid = GetNearbyLand(playerid);

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
	            if(LandInfo[landid][lLevel] < 5)
            	{
	                if(PlayerInfo[playerid][pCash] < 100000)
	                {
	                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade your land.");
	                }

	                LandInfo[landid][lLevel]++;
	                UpdateLandText(landid);

	                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET level = level + 1 WHERE id = %i", LandInfo[landid][lID]);
	                mysql_tquery(connectionID, queryBuffer);

	                GivePlayerCash(playerid, -100000);
	                GameTextForPlayer(playerid, "~r~-$100000", 5000, 1);
	                SM(playerid, COLOR_GREEN, "You paid $100,000 to upgrade your land to level %i/3. Your land can now have up to %i objects.", LandInfo[landid][lLevel], GetLandObjectCapacity(LandInfo[landid][lLevel]));
	            }
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
	        }
	    }
	    case DIALOG_LANDEDITOBJECT:
	    {
	        new landid = GetNearbyLand(playerid);

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
	            new objectid;

	            if(sscanf(inputtext, "i", objectid))
	            {
	                return ShowPlayerDialog(playerid, DIALOG_LANDEDITOBJECT, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
				}
				if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. You can find out an object's ID by enabling labels.");
				    return ShowPlayerDialog(playerid, DIALOG_LANDEDITOBJECT, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
		        }
		        if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
		        {
		            SendClientMessage(playerid, COLOR_SYNTAX, "Invalid object. This land object is not apart of your land.");
		            return ShowPlayerDialog(playerid, DIALOG_LANDEDITOBJECT, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
		        }

		        PlayerInfo[playerid][pSelected] = objectid;
				ShowDialogToPlayer(playerid, DIALOG_LANDOBJECTMENU);
	        }
	        else
	        {
	            ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
			}
		}
	    case DIALOG_LANDOBJECTMENU:
	    {
            new landid = GetNearbyLand(playerid);

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
	            new objectid = PlayerInfo[playerid][pSelected];

	            if(!strcmp(inputtext, "Edit object"))
	            {
	                if(Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't edit your gate while it is opened.");
					}

	    	        PlayerInfo[playerid][pEditType] = EDIT_LAND_OBJECT;
		    	    PlayerInfo[playerid][pEditObject] = objectid;
	        		PlayerInfo[playerid][pObjectLand] = landid;

					EditDynamicObject(playerid, objectid);
	    		    GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
	            }
	            else if(!strcmp(inputtext, "Edit gate destination"))
	            {
	                if(Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
					{
					    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't edit your gate while it is opened.");
					}

			        PlayerInfo[playerid][pEditType] = EDIT_LAND_GATE_MOVE;
			        PlayerInfo[playerid][pEditObject] = objectid;
			        PlayerInfo[playerid][pObjectLand] = landid;

					EditDynamicObject(playerid, objectid);
					SendClientMessage(playerid, COLOR_WHITE, "** You are now editing the move-to position for your gate.");
			        GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
	            }
	            else if(!strcmp(inputtext, "Duplicate object"))
	            {
	                PlayerInfo[playerid][pSelected] = objectid;

	                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, modelid, price, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
			        mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_DUPLICATE_LANDOBJECT, playerid);
	            }
	            else if(!strcmp(inputtext, "Sell object"))
	            {
	                PlayerInfo[playerid][pSelected] = objectid;

			        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, price FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
			        mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_SELL_LANDOBJECT, playerid);
				}
			}
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_LANDEDITOBJECT, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
			}
		}
		case DIALOG_LANDOBJECTS:
		{
		    if(response)
		    {
		        if(!strcmp(inputtext, ">> Next page", true))
		        {
		            PlayerInfo[playerid][pPage]++;
		            ShowDialogToPlayer(playerid, DIALOG_LANDOBJECTS);
		        }
		        else if(!strcmp(inputtext, "<< Go back", true) && PlayerInfo[playerid][pPage] > 1)
		        {
		            PlayerInfo[playerid][pPage]--;
		            ShowDialogToPlayer(playerid, DIALOG_LANDOBJECTS);
		        }
		        else
		        {
		            new objectid = strval(inputtext);

		            if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
		            {
			            PlayerInfo[playerid][pSelected] = objectid;
						ShowDialogToPlayer(playerid, DIALOG_LANDOBJECTMENU);
					}
		        }
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
			}
		}
		case DIALOG_LANDSELLALL:
		{
		    new landid = GetNearbyLand(playerid);

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
		    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT price FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
        		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CLEAR_LANDOBJECTS, playerid);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
			}
		}
		case DIALOG_LANDPERMS:
		{
		    new landid = GetNearbyLand(playerid), targetid;

	        if(landid == -1 || !HasLandPerms(playerid, landid))
	        {
	            return 1;
	        }

	        if(response)
	        {
				if(sscanf(inputtext, "u", targetid))
				{
					return ShowPlayerDialog(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
		        }
		        if(!IsPlayerConnected(targetid))
		        {
		            SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		            return ShowPlayerDialog(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
		        }
		        if(targetid == playerid)
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "You can't give permissions to yourself.");
					return ShowPlayerDialog(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
				}

		        if(PlayerInfo[targetid][pLandPerms] == landid)
		        {
		            PlayerInfo[targetid][pLandPerms] = -1;

		            SM(targetid, COLOR_GREEN, "%s has removed your access to their land's objects.", GetRPName(playerid));
					SM(playerid, COLOR_GREEN, "You have removed %s's access to your land's objects.", GetRPName(targetid));
				}
				else
				{
				    PlayerInfo[targetid][pLandPerms] = landid;

		            SM(targetid, COLOR_GREEN, "%s has granted you access to their land's objects.", GetRPName(playerid));
					SM(playerid, COLOR_GREEN, "You have granted %s access to your land's objects.", GetRPName(targetid));
				}
			}

			ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
		}
		case DIALOG_MP3PLAYER:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, DIALOG_MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
		            }
		            case 1:
		            {
		                ShowPlayerDialog(playerid, DIALOG_MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
		            }
		            case 2:
		            {
						if(!radioConnectionID)
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "The radio station database is currently unavailable.");
						}

						ShowDialogToPlayer(playerid, DIALOG_MP3RADIO);
					}
		            case 3:
		            {
						switch(PlayerInfo[playerid][pMusicType])
						{
				            case MUSIC_MP3PLAYER:
				            {
				                SetMusicStream(MUSIC_MP3PLAYER, playerid, "");
				                SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off their MP3 player.", GetRPName(playerid));
							}
							case MUSIC_BOOMBOX:
							{
							    SetMusicStream(MUSIC_BOOMBOX, playerid, "");
								SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off their boombox.", GetRPName(playerid));
							}
							case MUSIC_VEHICLE:
							{
							    if(IsPlayerInAnyVehicle(playerid))
							    {
								    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), "");
									SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns off the radio in the vehicle.", GetRPName(playerid));
								}
							}
						}
					}
		        }
			}
		}
		case DIALOG_MP3MUSIC:
		{
		    if(response)
		    {
		        new url[128];

		        if(isnull(inputtext))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
				}

				for(new i = 0, l = strlen(inputtext); i < l; i ++)
				{
				    switch(inputtext[i])
				    {
				        case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '\'', ' ':
				        {
							continue;
						}
						default:
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "The name of the .mp3 contains invalid characters, please try again.");
						    return ShowPlayerDialog(playerid, DIALOG_MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /musicfor a list of all music uploaded to the server.)", "Submit", "Back");
						}
				    }
				}

				format(url, sizeof(url), "http://%s/%s", SERVER_MUSIC_URL, inputtext);

				switch(PlayerInfo[playerid][pMusicType])
				{
		            case MUSIC_MP3PLAYER:
		            {
		                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
        		  		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on their MP3 player.", GetRPName(playerid));
					}
					case MUSIC_BOOMBOX:
					{
					    SetMusicStream(MUSIC_BOOMBOX, playerid, url);
						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on their boombox.", GetRPName(playerid));
					}
					case MUSIC_VEHICLE:
					{
					    if(IsPlayerInAnyVehicle(playerid))
					    {
						    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
							SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on the radio.", GetRPName(playerid));
						}
					}
				}

				SM(playerid, COLOR_GREEN, "You have started the playback of "SVRCLR"%s{CCFFFF}.", inputtext);
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
			}
		}
		case DIALOG_MP3URL:
		{
		    if(response)
		    {
		        if(isnull(inputtext))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
          		}

          		switch(PlayerInfo[playerid][pMusicType])
				{
		            case MUSIC_MP3PLAYER:
		            {
		                SetMusicStream(MUSIC_MP3PLAYER, playerid, inputtext);
        		  		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on their MP3 player.", GetRPName(playerid));
					}
					case MUSIC_BOOMBOX:
					{
					    SetMusicStream(MUSIC_BOOMBOX, playerid, inputtext);
						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on their boombox.", GetRPName(playerid));
					}
					case MUSIC_VEHICLE:
					{
					    if(IsPlayerInAnyVehicle(playerid))
					    {
						    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), inputtext);
							SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the song on the radio.", GetRPName(playerid));
						}
					}
				}
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
			}
		}
		case DIALOG_MP3RADIO:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                ShowDialogToPlayer(playerid, DIALOG_MP3RADIOGENRES);
		            }
		            case 1:
		            {
		                ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSEARCH);
		            }
		        }
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_MP3PLAYER);
			}
		}
		case DIALOG_MP3RADIOGENRES:
		{
		    if(response)
		    {
		        strcpy(PlayerInfo[playerid][pGenre], inputtext, 32);
		        ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSUBGENRES);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_MP3RADIO);
		    }
		}
		case DIALOG_MP3RADIOSUBGENRES:
		{
		    if(response)
		    {
		        PlayerInfo[playerid][pPage] = 1;
	     		PlayerInfo[playerid][pSearch] = 0;

		        strcpy(PlayerInfo[playerid][pSubgenre], inputtext, 32);
	     		ShowDialogToPlayer(playerid, DIALOG_MP3RADIORESULTS);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_MP3RADIOGENRES);
			}
		}
		case DIALOG_MP3RADIORESULTS:
		{
		    if(response)
		    {
		        if(!strcmp(inputtext, ">> Next page", true))
		        {
		            PlayerInfo[playerid][pPage]++;
		            ShowDialogToPlayer(playerid, DIALOG_MP3RADIORESULTS);
		        }
		        else if(!strcmp(inputtext, "<< Go back", true) && PlayerInfo[playerid][pPage] > 1)
		        {
		            PlayerInfo[playerid][pPage]--;
		            ShowDialogToPlayer(playerid, DIALOG_MP3RADIORESULTS);
		        }
		        else
		        {
			        listitem = ((PlayerInfo[playerid][pPage] - 1) * MAX_LISTED_STATIONS) + listitem;

					if(PlayerInfo[playerid][pSearch])
					{
					    mysql_format(radioConnectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, url FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, 1", PlayerInfo[playerid][pGenre], PlayerInfo[playerid][pGenre], listitem);
						mysql_tquery(radioConnectionID, queryBuffer, "Radio_PlayStation", "i", playerid);
					}
					else
					{
						mysql_format(radioConnectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, url FROM radiostations WHERE genre = '%e' AND subgenre = '%e' ORDER BY name LIMIT %i, 1", PlayerInfo[playerid][pGenre], PlayerInfo[playerid][pSubgenre], listitem);
			        	mysql_tquery(radioConnectionID, queryBuffer, "Radio_PlayStation", "i", playerid);
					}
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pSearch])
			    {
			        ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSEARCH);
			    }
			    else
			    {
			        ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSUBGENRES);
				}
			}
		}
		case DIALOG_MP3RADIOSEARCH:
		{
		    if(response)
		    {
		        if(strlen(inputtext) < 3)
		        {
		            SendClientMessage(playerid, COLOR_SYNTAX, "Your search query must contain 3 characters or more.");
		            return ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSEARCH);
		        }

		        PlayerInfo[playerid][pPage] = 1;
		        PlayerInfo[playerid][pSearch] = 1;

		        strcpy(PlayerInfo[playerid][pGenre], inputtext, 32);
                ShowDialogToPlayer(playerid, DIALOG_MP3RADIORESULTS);
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_MP3RADIO);
			}
		}
		case DIALOG_PAWNSHOP:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pJailType] > 0 && listitem != 2)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command when you're in prisoned.");
				}

		        switch(listitem)
		        {
					case 0:
					{
					    if(PlayerInfo[playerid][pDiamonds] < 400)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough diamonds to get this item.");
		                }

		                PlayerInfo[playerid][pDiamonds] -= 400;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Pawnshop Exchange', NOW(), '[E] Free business of any type')", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You exchanged 100 diamonds to a {00AA00}Free business ticket{33CCFF}. /report for your prize.");
						SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a business ticket (any type).", GetRPName(playerid), playerid);
					}
					case 1:
					{
					    if(PlayerInfo[playerid][pDiamonds] < 500)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough diamonds to get this item.");
		                }

		                PlayerInfo[playerid][pDiamonds] -= 500;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Pawnshop Exchange', NOW(), '[E] Free house (LC House Type)')", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You have exchanged 100 Diamonds into a {00AA00}Free house ticket{33CCFF}. /report for your prize.");
						SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a house ticket (Low Class House Type).", GetRPName(playerid), playerid);
					}
					case 2:
					{
					    if(PlayerInfo[playerid][pDiamonds] < 500)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough diamonds to get this item.");
		                }

		                PlayerInfo[playerid][pDiamonds] -= 500;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Pawnshop Exchange', NOW(), '[E] Entrance/Door Ticket')", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You exchanged 150 diamonds to an {00AA00}entrance/door ticket.{33CCFF}. /report for your prize.");
						SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for an entrance/door ticket(normal int).", GetRPName(playerid), playerid);
					}
					case 3:
					{
					    if(PlayerInfo[playerid][pDiamonds] < 100)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough diamonds to get this item.");
		                }

		                PlayerInfo[playerid][pDiamonds] -= 100;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Pawnshop Exchange', NOW(), '[E] Gate Ticket')", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You exchanged 50 diamonds to a {00AA00}gate ticket.{33CCFF}. /report for your prize.");
						SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a gate ticket.", GetRPName(playerid), playerid);
					}
					case 4:
					{
					    if(PlayerInfo[playerid][pDiamonds] < 500)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough diamonds to get this item.");
		                }

		                PlayerInfo[playerid][pDiamonds] -= 500;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET diamonds = %i WHERE uid = %i", PlayerInfo[playerid][pDiamonds], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Pawnshop Exchange', NOW(), '[E] Rare Car Ticket')", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You exchanged 75 diamonds to a {00AA00}rare car ticket.{33CCFF}. /report for your prize.");
						SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a rare car ticket.", GetRPName(playerid), playerid);
					}
				}
			}
		}

		case DIALOG_BLACKMARKET:
		{
		    if(response)
		    {
		    	if(PlayerInfo[playerid][pAdminDuty])
		    	{
		    		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command as you're aduty.");
		    	}
		        switch(listitem)
		        {
					case 0:
					{
					    if(PlayerInfo[playerid][pCash] < 150000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to get this item.");
		               	}
		                if(PlayerInfo[playerid][pMask])
		                {
		                	return SendClientMessage(playerid, COLOR_SYNTAX, "You have a mask already, use /mask to use it.");
		                }


			            PlayerInfo[playerid][pMask] = 1;
			            GivePlayerCash(playerid, -150000);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mask = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendClientMessage(playerid, COLOR_GREEN, "You bought $150,000 for {00AA00}Mask{33CCFF}.");
					}
					case 1:
					{
					    if(PlayerInfo[playerid][pCash] < 150000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to get this item.");
		                }

		                if(PlayerHasWeapon(playerid, 8))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}

					    GiveWeapon(playerid, 8);
			            GivePlayerCash(playerid, -150000);

						SendClientMessage(playerid, COLOR_GREEN, "You bought $150,000 for {00AA00}Katana{33CCFF}.");
					}
					case 2:
					{
					    if(PlayerInfo[playerid][pCash] < 300000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to get this item.");
		                }

		                if(PlayerHasWeapon(playerid, 24))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}

					    GiveWeapon(playerid, 24);
			            GivePlayerCash(playerid, -300000);

						SendClientMessage(playerid, COLOR_GREEN, "You bought $300,000 for {00AA00}Deagle{33CCFF}.");
					}
					case 3:
					{
					    if(PlayerInfo[playerid][pCash] < 700000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to get this item.");
		                }

		                if(PlayerHasWeapon(playerid, 25))
				        {
				            return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
						}

					    GiveWeapon(playerid, 25);
			            GivePlayerCash(playerid, -700000);

						SendClientMessage(playerid, COLOR_GREEN, "You bought $700,000 for {00AA00}Shotgun{33CCFF}.");
					}
					case 4:
					{
					   	if(PlayerInfo[playerid][pCash] < 100000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to get this item.");
		                }
			            SetScriptArmour(playerid, 100.0);

			            GivePlayerCash(playerid, -100000);

						SendClientMessage(playerid, COLOR_GREEN, "You bought $100,000 for {00AA00}Full Armor{33CCFF}.");
					}
				}
			}
		}

		case DIALOG_GANGSTASH:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
			            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHWEAPONS1);
		            }
		            case 1:
		            {
		                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS1);
		            }
					case 2:
					{
					    PlayerInfo[playerid][pSelected] = ITEM_MATERIALS;
					    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
					}
		            case 3:
		            {
		                PlayerInfo[playerid][pSelected] = ITEM_CASH;
		                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
					}
		            case 4:
		            {
		                ShowDialogToPlayer(playerid, DIALOG_GCLOTHES);
					}
		        }
		    }
		}
		case DIALOG_GANGSTASHWEAPONS1:
		{
	        if(PlayerInfo[playerid][pGang] == -1)
	        {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowPlayerDialog(playerid, DIALOG_GANGSTASHWEAPONS2, DIALOG_STYLE_LIST, "Gang Locker | Weapons", "Withdraw\nDeposit", "Select", "Back");
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
		    }
		}
		case DIALOG_GANGSTASHWEAPONS2:
		{
          	if(PlayerInfo[playerid][pGang] == -1)
	        {
		        return 1;
		    }
		    if(response)
		    {
				if(listitem == 0)
				{
				    if(PlayerInfo[playerid][pGangRank] < 1)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 1+ in order to withdraw weapons.");
		            }

				    switch(PlayerInfo[playerid][pSelected])
				    {
				        case GANGWEAPON_9MM:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 1)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_9MM] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 22))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_9MM]--;
				            GiveWeapon(playerid, 22);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_9mm = weapon_9mm - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a 9mm from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a 9mm from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
                        case GANGWEAPON_SDPISTOL:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 1)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 23))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]--;
				            GiveWeapon(playerid, 23);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sdpistol = weapon_sdpistol - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a silenced pistol from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a silenced pistol from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_DEAGLE:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 4)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 24))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]--;
				            GiveWeapon(playerid, 24);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_deagle = weapon_deagle - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a Desert Eagle from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a Desert Eagle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SHOTGUN:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 1)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 25))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]--;
				            GiveWeapon(playerid, 25);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_shotgun = weapon_shotgun - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a shotgun from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a shotgun from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SPAS12:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 4)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 27))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]--;
				            GiveWeapon(playerid, 27);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_spas12 = weapon_spas12 - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a SPAS-12 from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a SPAS-12 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SAWNOFF:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 4)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 26))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF]--;
				            GiveWeapon(playerid, 26);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sawnoff = weapon_sawnoff - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a sawnoff shotgun from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a sawnoff shotgun from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
                        case GANGWEAPON_TEC9:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 3)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_TEC9] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 32))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]--;
				            GiveWeapon(playerid, 32);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_tec9 = weapon_tec9 - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a Tec-9 from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a Tec-9 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_UZI:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 3)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_UZI] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 28))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_UZI]--;
				            GiveWeapon(playerid, 28);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_uzi = weapon_uzi - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a Micro Uzi from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a Micro Uzi from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_MP5:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 3)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MP5] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 29))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MP5]--;
				            GiveWeapon(playerid, 29);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_mp5 = weapon_mp5 - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws an MP5 from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws an MP5 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_AK47:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 4)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_AK47] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 30))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_AK47]--;
				            GiveWeapon(playerid, 30);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_ak47 = weapon_ak47 - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws an AK-47 from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws an AK-47 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_M4:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 4)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_M4] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 31))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_M4]--;
				            GiveWeapon(playerid, 31);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_m4 = weapon_m4 - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws an M4 from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws an M4 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_RIFLE:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 2)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 33))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]--;
				            GiveWeapon(playerid, 33);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_rifle = weapon_rifle - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a rifle from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a rifle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SNIPER:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 5)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 34))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]--;
				            GiveWeapon(playerid, 34);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sniper = weapon_sniper - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a sniper rifle from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a sniper rifle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_MOLOTOV:
				        {
				            if(PlayerInfo[playerid][pGangRank] < 5)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "Your rank isn't high enough to withdraw this weapon.");
							}
				            if(GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV] <= 0)
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "The gang stash doesn't have any of this weapon left.");
				            }
				            if(PlayerHasWeapon(playerid, 18))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You have this weapon already.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV]--;
				            GiveWeapon(playerid, 18);

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_molotov = weapon_molotov - 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws a molotov from the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) withdraws a molotov from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
					}
				}
				else if(listitem == 1)
		        {
                    switch(PlayerInfo[playerid][pSelected])
				    {
				        case GANGWEAPON_9MM:
				        {
				            if(!PlayerHasWeapon(playerid, 22))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_9MM]++;
				           
							RemovePlayerWeaponEx(playerid, 22);
	                       

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_9mm = weapon_9mm + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a 9mm in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a 9mm in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
                        case GANGWEAPON_SDPISTOL:
				        {
				            if(!PlayerHasWeapon(playerid, 23))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]++;
				           
							RemovePlayerWeaponEx(playerid, 23);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sdpistol = weapon_sdpistol + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a silenced pistol in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a silenced pistol in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_DEAGLE:
				        {
				            if(!PlayerHasWeapon(playerid, 24))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]++;
				           	
							RemovePlayerWeaponEx(playerid, 24);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_deagle = weapon_deagle + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a Desert Eagle in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a Desert Eagle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SHOTGUN:
				        {
				            if(!PlayerHasWeapon(playerid, 25))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]++;
				          	 
							RemovePlayerWeaponEx(playerid, 25);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_shotgun = weapon_shotgun + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a shotgun in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SPAS12:
				        {
				            if(!PlayerHasWeapon(playerid, 27))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]++;
				            
							RemovePlayerWeaponEx(playerid, 27);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_spas12 = weapon_spas12 + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a SPAS-12 in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a SPAS-12 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SAWNOFF:
				        {
				            if(!PlayerHasWeapon(playerid, 26))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF]++;
				           
							RemovePlayerWeaponEx(playerid, 26);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sawnoff = weapon_sawnoff + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a sawnoff shotgun in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a sawnoff shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
                        case GANGWEAPON_TEC9:
				        {
				            if(!PlayerHasWeapon(playerid, 32))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]++;
				           
							RemovePlayerWeaponEx(playerid, 32);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_tec9 = weapon_tec9 + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a Tec-9 in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a Tec-9 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_UZI:
				        {
				            if(!PlayerHasWeapon(playerid, 28))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_UZI]++;
				            
							RemovePlayerWeaponEx(playerid, 28);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_uzi = weapon_uzi + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a Micro Uzi in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a Micro Uzi in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_MP5:
				        {
				            if(!PlayerHasWeapon(playerid, 29))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MP5]++;
				            
							RemovePlayerWeaponEx(playerid, 29);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_mp5 = weapon_mp5 + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits an MP5 in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits an MP5 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_AK47:
				        {
				            if(!PlayerHasWeapon(playerid, 30))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_AK47]++;
				           
							RemovePlayerWeaponEx(playerid, 30);
							
				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_ak47 = weapon_ak47 + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits an AK-47 in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits an AK-47 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_M4:
				        {
				            if(!PlayerHasWeapon(playerid, 31))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_M4]++;
				            
							RemovePlayerWeaponEx(playerid, 31);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_m4 = weapon_m4 + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits an M4 in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits an M4 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_RIFLE:
				        {
				            if(!PlayerHasWeapon(playerid, 33))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]++;
				           
							RemovePlayerWeaponEx(playerid, 33);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_rifle = weapon_rifle + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a rifle in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_SNIPER:
				        {
				            if(!PlayerHasWeapon(playerid, 34))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]++;
				            
							RemovePlayerWeaponEx(playerid, 34);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_sniper = weapon_sniper + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a sniper rifle in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a sniper rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
						case GANGWEAPON_MOLOTOV:
				        {
				            if(!PlayerHasWeapon(playerid, 18))
				            {
				                return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have this weapon.");
							}

				            GangInfo[PlayerInfo[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV]++;
				           
							RemovePlayerWeaponEx(playerid, 18);
							

				            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_molotov = weapon_molotov + 1 WHERE id = %i", PlayerInfo[playerid][pGang]);
				            mysql_tquery(connectionID, queryBuffer);

				            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits a molotov in the gang stash.", GetRPName(playerid));
				            //Log_Write("log_gang", "%s (uid: %i) deposits a molotov in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
						}
					}
				}
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHWEAPONS1);
			}
		}
		case DIALOG_GANGSTASHDRUGS1:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: PlayerInfo[playerid][pSelected] = ITEM_WEED;
		            case 1: PlayerInfo[playerid][pSelected] = ITEM_COCAINE;
		            case 2: PlayerInfo[playerid][pSelected] = ITEM_METH;
		            case 3: PlayerInfo[playerid][pSelected] = ITEM_PAINKILLERS;
		        }

				ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
		    }
			else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
			}
		}
		case DIALOG_GANGSTASHDRUGS2:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(PlayerInfo[playerid][pGangRank] < 2)
		            {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 2+ in order to withdraw drugs.");
		            }

		            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
		        }
		        else if(listitem == 1)
		        {
		            ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
		        }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS1);
			}
		}
		case DIALOG_GANGSTASHAMMO1:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: PlayerInfo[playerid][pSelected] = ITEM_HPAMMO;
		            case 1: PlayerInfo[playerid][pSelected] = ITEM_POISONAMMO;
		            case 2: PlayerInfo[playerid][pSelected] = ITEM_FMJAMMO;
		        }

				ShowDialogToPlayer(playerid, DIALOG_GANGSTASHAMMO2);
		    }
			else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
			}
		}
		case DIALOG_GANGSTASHAMMO2:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(PlayerInfo[playerid][pGangRank] < 5)
		            {
		                return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 5+ in order to withdraw ammo.");
		            }

		            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
		        }
		        else if(listitem == 1)
		        {
		            ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
		        }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHAMMO1);
			}
		}
		case DIALOG_GANGWITHDRAW:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 3)
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    if(sscanf(inputtext, "i", amount))
			    {
			        return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				switch(PlayerInfo[playerid][pSelected])
				{
				    case ITEM_WEED:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gPot])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pPot] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPot] -= amount;
						PlayerInfo[playerid][pPot] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET pot = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPot], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some pot from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i grams of pot from the gang stash.", amount);
					}
					case ITEM_COCAINE:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gCrack])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pCrack] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gCrack] -= amount;
						PlayerInfo[playerid][pCrack] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET crack = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gCrack], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some Crack from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i grams of Crack from the gang stash.", amount);
					}
                    case ITEM_METH:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gMeth])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pMeth] + amount > GetPlayerCapacity(playerid, CAPACITY_METH))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gMeth] -= amount;
						PlayerInfo[playerid][pMeth] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET meth = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gMeth], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some meth from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i grams of meth from the gang stash.", amount);
					}
					case ITEM_PAINKILLERS:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gPainkillers])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPainkillers] -= amount;
						PlayerInfo[playerid][pPainkillers] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET painkillers = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPainkillers], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some painkillers from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i painkillers from the gang stash.", amount);
					}
					case ITEM_MATERIALS:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gMaterials])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gMaterials] -= amount;
						PlayerInfo[playerid][pMaterials] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gMaterials], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some materials from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i materials from the gang stash.", amount);
					}
					case ITEM_CASH:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gCash])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gCash] -= amount;
						GivePlayerCash(playerid, amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gCash], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some cash from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn $%i from the gang stash.", amount);
					}
					case ITEM_HPAMMO:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pHPAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET hpammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some hollow point ammo from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i rounds of hollow point ammo from the gang stash.", amount);
					}
					case ITEM_POISONAMMO:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pPoisonAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i poison ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPoisonAmmo], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET poisonammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some poison tip ammo from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i rounds of poison tip ammo from the gang stash.", amount);
					}
					case ITEM_FMJAMMO:
				    {
				        if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}
						if(PlayerInfo[playerid][pFMJAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
						{
						    SM(playerid, COLOR_SYNTAX, "You currently have %i/%i FMJ ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET fmjammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s withdraws some full metal jacket ammo from the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have withdrawn %i rounds of full metal jacket ammo from the gang stash.", amount);
					}
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pSelected] == ITEM_MATERIALS) {
			        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
				} else if(PlayerInfo[playerid][pSelected] == ITEM_CASH) {
					ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
				} else if(ITEM_HPAMMO <= PlayerInfo[playerid][pSelected] <= ITEM_FMJAMMO) {
					ShowDialogToPlayer(playerid, DIALOG_GANGSTASHAMMO2);
				} else {
				    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
				}
			}
		}
		case DIALOG_GANGDEPOSIT:
		{
		    if(PlayerInfo[playerid][pGang] == -1)
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    if(sscanf(inputtext, "i", amount))
			    {
			        return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				switch(PlayerInfo[playerid][pSelected])
				{
				    case ITEM_WEED:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pPot])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gPot] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_WEED))
						{
						    SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i grams of pot.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_WEED));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPot] += amount;
						PlayerInfo[playerid][pPot] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET pot = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPot], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some pot in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i grams of pot in the gang stash.", amount);
					}
					case ITEM_COCAINE:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pCrack])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gCrack] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_COCAINE))
						{
						    SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i grams of Crack.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_COCAINE));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gCrack] += amount;
						PlayerInfo[playerid][pCrack] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET crack = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gCrack], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some Crack in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i grams of Crack in the gang stash.", amount);
					}
                    case ITEM_METH:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pMeth])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gMeth] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_METH))
						{
						    SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i grams of meth.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_METH));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gMeth] += amount;
						PlayerInfo[playerid][pMeth] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET meth = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gMeth], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some meth in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i grams of meth in the gang stash.", amount);
					}
					case ITEM_PAINKILLERS:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pPainkillers])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gPainkillers] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_PAINKILLERS))
						{
						    SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i painkillers.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPainkillers] += amount;
						PlayerInfo[playerid][pPainkillers] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET painkillers = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPainkillers], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET painkillers = %i WHERE uid = %i", PlayerInfo[playerid][pPainkillers], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some painkillers in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i painkillers in the gang stash.", amount);
					}
					case ITEM_MATERIALS:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pMaterials])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gMaterials] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS))
						{
						    SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i materials.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_MATERIALS));
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gMaterials] += amount;
						PlayerInfo[playerid][pMaterials] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gMaterials], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some materials in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i materials in the gang stash.", amount);
					}
					case ITEM_CASH:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pCash])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gCash] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH))
						{
							SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than $%i.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_CASH));
							return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gCash] += amount;
						GivePlayerCash(playerid, -amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gCash], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some cash in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited $%i in the gang stash.", amount);
					}
					case ITEM_HPAMMO:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pHPAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_HPAMMO))
						{
							SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i rounds of hollow point ammo.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_HPAMMO));
							return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET hpammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gHPAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some hollow point ammo in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i rounds of hollow point ammo in the gang stash.", amount);
					}
					case ITEM_POISONAMMO:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pPoisonAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_POISONAMMO))
						{
							SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i rounds of poison tip ammo.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_POISONAMMO));
							return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET poisonammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoisonAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some poison tip ammo in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i rounds of poison tip ammo in the gang stash.", amount);
					}
					case ITEM_FMJAMMO:
				    {
				        if(amount < 1 || amount > PlayerInfo[playerid][pFMJAmmo])
				        {
				            SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
				            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo] + amount > GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_FMJAMMO))
						{
							SM(playerid, COLOR_SYNTAX, "The gang stash can't contain more than %i rounds of FMJ ammo.", GetGangStashCapacity(PlayerInfo[playerid][pGang], STASH_CAPACITY_FMJAMMO));
							return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET fmjammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gFMJAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s deposits some full metal jacket ammo in the gang stash.", GetRPName(playerid));
						SM(playerid, COLOR_GREEN, "** You have deposited %i rounds of full metal jacket ammo in the gang stash.", amount);
					}
				}
			}
			else
			{
				if(PlayerInfo[playerid][pSelected] == ITEM_MATERIALS) {
			        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
				} else if(PlayerInfo[playerid][pSelected] == ITEM_CASH) {
					ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
				} else if(ITEM_HPAMMO <= PlayerInfo[playerid][pSelected] <= ITEM_FMJAMMO) {
					ShowDialogToPlayer(playerid, DIALOG_GANGSTASHAMMO2);
				} else {
				    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
				}
			}
		}
		case DIALOG_GANGSTASHMATS:
		{
		    if(response)
		    {
		        if(listitem == 0)
				{
				    if(PlayerInfo[playerid][pGangRank] < 5)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 5+ in order to withdraw materials.");
		            }

					ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				else if(listitem == 1)
				{
					ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
			}
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
		    }
		}
		case DIALOG_GANGSTASHCASH:
		{
		    if(response)
		    {
		        if(listitem == 0)
				{
				    if(PlayerInfo[playerid][pGangRank] < 6)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be at least rank 6+ in order to withdraw cash.");
		            }

					ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				else if(listitem == 1)
				{
					ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
			}
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
		    }
		}
		case DIALOG_GANGSKINS:
		{
		    if(PlayerInfo[playerid][pGang] >= 0)
		    {
		        if(response)
		        {
					new index = PlayerInfo[playerid][pSkinSelected] + 1;

					if(index >= MAX_GANG_SKINS)
					{
					    // When the player is shown the dialog for the first time, their skin isn't chnaged until they click >> Next.
					    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
					    PlayerInfo[playerid][pSkinSelected] = -1;
					}
					else
					{
					    // Find the next skin in the array.
						for(new i = index; i < MAX_GANG_SKINS; i ++)
						{
						    if(GangInfo[PlayerInfo[playerid][pGang]][gSkins][i] != 0)
						    {
						        SetPlayerSkin(playerid, GangInfo[PlayerInfo[playerid][pGang]][gSkins][i]);
						        PlayerInfo[playerid][pSkinSelected] = i;
						        break;
					        }
		                }

		                if(index == PlayerInfo[playerid][pSkinSelected] + 1)
		                {
		                    // Looks like there was no skin found. So, we'll go back to the very first valid skin in the skin array.
		                    for(new i = 0; i < MAX_GANG_SKINS; i ++)
							{
						    	if(GangInfo[PlayerInfo[playerid][pGang]][gSkins][i] != 0)
						    	{
		                            SetPlayerSkin(playerid, GangInfo[PlayerInfo[playerid][pGang]][gSkins][i]);
						        	PlayerInfo[playerid][pSkinSelected] = i;
						        	break;
								}
							}
		                }
		            }

		            ShowPlayerDialog(playerid, DIALOG_GANGSKINS, DIALOG_STYLE_MSGBOX, "Skin selection", "Press "SVRCLR">> Next{A9C4E4} to browse through available gang skins.", ">> Next", "Confirm");
		        }
		        else
		        {
		            PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
		            PlayerInfo[playerid][pSkinSelected] = -1;

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = %i WHERE uid = %i", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
		            mysql_tquery(connectionID, queryBuffer);

		            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes their clothes.", GetRPName(playerid));
				}
		    }
		}
		case DIALOG_NEWBIE:
	    {
			if(response)
			{
				new string[128];
				if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] == 0)
				{
			 		PlayerInfo[playerid][pLastNewbie] = gettime();
				}
				if(isnull(inputtext)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot send no question!");
				if(strlen(inputtext) > 110) return SendClientMessageEx(playerid, COLOR_GREY, "That message is too long!");
				format(string, sizeof(string), "{FF0000}New Question! {FFFFFF}%s(%d): %s", GetPlayerNameEx(playerid), playerid, inputtext);
				SendQuestionToStaff(COLOR_RED, string);
				SendQuestionToStaff(COLOR_WHITE, "** /nanswer (/na) to asnwer | /trashnewb (/tn) to trash **");
				new szString[128];
				format(szString, sizeof(szString), "{FF0000}New Question! {FFFFFF}%s(%d): %s", GetPlayerNameEx(playerid), playerid, inputtext);
				SetPVarInt(playerid, "SendQuestion", 1);
				SetPVarString(playerid, "Question", inputtext);
				SendClientMessage(playerid, COLOR_WHITE, "Your question was successfully submitted, please wait. An helper will reply shortly.");

			}
		}
		case DIALOG_GANGFINDCAR:
		{
		    if(response)
		    {
		        new count, garageid;

		        for(new i = 1; i < MAX_VEHICLES; i ++)
			 	{
			 	    if((VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerInfo[playerid][pGang]) && (count++ == listitem))
			 	    {
                        PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;

			            if((garageid = GetVehicleGarage(i)) >= 1)
			            {
			                SetPlayerCheckpoint(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
			                SM(playerid, COLOR_YELLOW, "** This %s is located in a garage. Checkpoint marked at the garage's location.", GetVehicleName(i));
			            }
			            else
			            {
			                new
			                    Float:x,
			                    Float:y,
			                    Float:z;

			                GetVehiclePos(i, x, y, z);
			                SetPlayerCheckpoint(playerid, x, y, z, 3.0);
			                SM(playerid, COLOR_YELLOW, "** This %s is located in %s. Checkpoint marked at the location.", GetVehicleName(i), GetZoneName(x, y, z));
			            }

			            return 1;
		            }
				}
			}
		}
		case DIALOG_GANGPOINTSHOP:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 6)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                if(GangInfo[PlayerInfo[playerid][pGang]][gPoints] < 500)
		                {
		                    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have enough points.");
						}
						if(PlayerInfo[playerid][pCash] < 50000)
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You need $50000 on hand to purchase this upgrade.");
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gDrugDealer])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang already has this upgrade.");
						}

						GangInfo[PlayerInfo[playerid][pGang]][gDrugDealer] = 1;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugX] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugY] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugZ] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugPot] = 0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth] = 0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack] = 0;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][0] = 500;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][1] = 1000;
						GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][2] = 1500;
						GangInfo[PlayerInfo[playerid][pGang]][gPoints] -= 500;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugdealer = 1, drug_x = 0.0, drug_y = 0.0, drug_z = 0.0, drugpot = 0, drugcrack = 0, drugmeth = 0, pot_price = 500, crack_price = 1000, meth_price = 1500, points = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoints], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						GivePlayerCash(playerid, -50000);
						GiveGangPoints(PlayerInfo[playerid][pGang], -500);
						SendClientMessage(playerid, COLOR_GREEN, "You have spent 500 GP & $50000 on an "SVRCLR"NPC drug dealer{CCFFFF}. '/gang npc' to edit your drug dealer.");
					}
					case 1:
		            {
		                if(GangInfo[PlayerInfo[playerid][pGang]][gPoints] < 500)
		                {
		                    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have enough points.");
						}
						if(PlayerInfo[playerid][pCash] < 50000)
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You need $50000 on hand to purchase this upgrade.");
						}
						if(GangInfo[PlayerInfo[playerid][pGang]][gArmsDealer])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang already has this upgrade.");
						}

						GangInfo[PlayerInfo[playerid][pGang]][gArmsDealer] = 1;
						GangInfo[PlayerInfo[playerid][pGang]][gArmsX] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gArmsY] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gArmsZ] = 0.0;
						GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials] = 0;
						GangInfo[PlayerInfo[playerid][pGang]][gPoints] -= 500;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsdealer = 1, arms_x = 0.0, arms_y = 0.0, arms_z = 0.0, armsmaterials = 0, points = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoints], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						GivePlayerCash(playerid, -50000);
						GiveGangPoints(PlayerInfo[playerid][pGang], -500);
						SendClientMessage(playerid, COLOR_GREEN, "You have spent 500 GP & $50000 on an "SVRCLR"NPC arms dealer{CCFFFF}. '/gang npc' to edit your arms dealer.");
					}
					case 2:
					{
					    switch(GangInfo[PlayerInfo[playerid][pGang]][gLevel])
					    {
					        case 1:
					        {
					            if(GangInfo[PlayerInfo[playerid][pGang]][gPoints] < 6000)
				                {
				                    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have enough points.");
								}
								if(PlayerInfo[playerid][pCash] < 75000)
								{
								    return SendClientMessage(playerid, COLOR_SYNTAX, "You need $75000 on hand to purchase this upgrade.");
								}

								GangInfo[PlayerInfo[playerid][pGang]][gLevel] = 2;
								GangInfo[PlayerInfo[playerid][pGang]][gPoints] -= 6000;

								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET level = 2, points = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoints], PlayerInfo[playerid][pGang]);
								mysql_tquery(connectionID, queryBuffer);

								GivePlayerCash(playerid, -75000);
								ReloadGang(PlayerInfo[playerid][pGang]);

								SM(playerid, COLOR_YELLOW, "You have spent 6000 GP & $75000 for gang level 2/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerInfo[playerid][pGang]), GetGangVehicleLimit(PlayerInfo[playerid][pGang]));
								SendClientMessage(playerid, COLOR_YELLOW, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

								//Log_Write("log_gang", "%s (uid: %i) spent 6000 GP & $75000 for gang level 2/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
							}
							case 2:
					        {
					            if(GangInfo[PlayerInfo[playerid][pGang]][gPoints] < 12000)
				                {
				                    return SendClientMessage(playerid, COLOR_SYNTAX, "Your gang doesn't have enough points.");
								}
								if(PlayerInfo[playerid][pCash] < 100000)
								{
								    return SendClientMessage(playerid, COLOR_SYNTAX, "You need $100000 on hand to purchase this upgrade.");
								}

								GangInfo[PlayerInfo[playerid][pGang]][gLevel] = 3;
								GangInfo[PlayerInfo[playerid][pGang]][gPoints] -= 12000;

								mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET level = 3, points = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gPoints], PlayerInfo[playerid][pGang]);
								mysql_tquery(connectionID, queryBuffer);

								GivePlayerCash(playerid, -100000);
								ReloadGang(PlayerInfo[playerid][pGang]);

								SM(playerid, COLOR_YELLOW, "You have spent 12000 GP & $100000 for gang level 3/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerInfo[playerid][pGang]), GetGangVehicleLimit(PlayerInfo[playerid][pGang]));
								SendClientMessage(playerid, COLOR_YELLOW, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

								//Log_Write("log_gang", "%s (uid: %i) spent 12000 GP & $100000 for gang level 3/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang]);
							}
						}
					}
		        }
		    }
		}
		case DIALOG_GANGARMSPRICES:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowPlayerDialog(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item:", "Submit", "Back");
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
			}
		}
		case DIALOG_GANGARMSPRICE:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
				}

				GangInfo[PlayerInfo[playerid][pGang]][gArmsPrices][PlayerInfo[playerid][pSelected]] = amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsprice_%i = %i WHERE id = %i", PlayerInfo[playerid][pSelected] + 1, amount, PlayerInfo[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				if(PlayerInfo[playerid][pSelected] == 0) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Micro Uzi{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 1) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Tec-9{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 2) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"MP5{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 3) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Desert Eagle{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 4) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Molotov{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 5) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"AK-47{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 6) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"M4{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 7) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Sniper{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 8) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Sawnoff Shotgun{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 9) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Hollow Point Ammo{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 10) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"Poison Tip Ammo{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 11) {
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"FMJ Ammo{CCFFFF} to $%i.", amount);
		        }
		    }

		    ShowDialogToPlayer(playerid, DIALOG_GANGARMSPRICES);
		}
		case DIALOG_GANGARMSDEALER:
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsX], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsY], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    if(listitem == 0)
			    {
					ShowDialogToPlayer(playerid, DIALOG_GANGARMSWEAPONS);
				}
				else if(listitem == 1)
				{
				    ShowDialogToPlayer(playerid, DIALOG_GANGARMSAMMO);
				}
				else if(listitem == 2)
				{
				    if(PlayerInfo[playerid][pGang] != PlayerInfo[playerid][pDealerGang])
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "This arms dealer doesn't belong to your gang.");
				    }
				    if(PlayerInfo[playerid][pGangRank] < 6)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be rank 6+ in order to edit.");
					}

					ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
				}
			}
		}
		case DIALOG_GANGARMSWEAPONS:
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsX], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsY], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    switch(listitem)
			    {
			        case 0:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 5000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 5000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 28);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a micro uzi.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"micro uzi{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 1:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 5000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 5000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 32);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a Tec-9.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"Tec-9{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 2:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 10000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 10000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 29);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received an MP5.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased an "SVRCLR"MP5{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 3:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 20000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 20000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 24);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a Desert Eagle.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"Desert Eagle{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 4:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 999999)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 999999;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 18);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a molotov.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"molotov{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 5:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 30000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 30000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 30);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received an AK-47.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased an "SVRCLR"AK-47{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 6:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 40000)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 40000;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 31);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received an M4.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased an "SVRCLR"M4{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 7:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 999999)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 999999;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 34);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a sniper.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"sniper{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
			        case 8:
			        {
			            if(GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] < 999999)
			            {
			                return SendClientMessage(playerid, COLOR_SYNTAX, "This gang's arms dealer doesn't have enough materials for this weapon.");
						}
						if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem])
						{
						    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this weapon.");
			            }

			            GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials] -= 999999;
			            GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem];

			            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
			            mysql_tquery(connectionID, queryBuffer);

			            GivePlayerCash(playerid, -GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            GiveWeapon(playerid, 26);

			            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received a sawnoff shotgun.", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			            SM(playerid, COLOR_GREEN, "You have purchased a "SVRCLR"sawnoff shotgun{CCFFFF} for $%i.", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][listitem]);
			        }
				}
			}
			else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEALER);
			}
		}

		case DIALOG_GANGARMSAMMO:
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsX], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsY], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    PlayerInfo[playerid][pSelected] = listitem;
			    ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEALER);
			}
		}

  		case DIALOG_GANGAMMOBUY:
		{
            if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsX], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsY], GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    switch(PlayerInfo[playerid][pSelected])
			    {
			        case 0: // Hollow point ammo
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsHPAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][9] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many rounds.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pHPAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][9] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsHPAmmo] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + amount);
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armshpammo = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsHPAmmo], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received %i rounds of hollow point ammo.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i rounds of "SVRCLR"hollow point ammo{CCFFFF} for $%i.", amount, cost);
					}
					case 1: // Poison tip ammo
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPoisonAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][10] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many rounds.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pPoisonAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i poison ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPoisonAmmo], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][10] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPoisonAmmo] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + amount);
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armspoisonammo = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPoisonAmmo], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received %i rounds of poison tip ammo.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i rounds of "SVRCLR"poison tip ammo{CCFFFF} for $%i.", amount, cost);
					}
					case 2: // FMJ ammo
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsFMJAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][11] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many rounds.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
			            }
			            if(PlayerInfo[playerid][pFMJAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i FMJ ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsPrices][11] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsFMJAmmo] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] + amount);
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsfmjammo = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gArmsFMJAmmo], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the arms dealer and received %i rounds of FMJ ammo.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i rounds of "SVRCLR"FMJ ammo{CCFFFF} for $%i.", amount, cost);
					}
		        }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGARMSAMMO);
			}
		}
		case DIALOG_GANGARMSEDIT:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 6)
		    {
		        return 1;
			}

			if(response)
			{
			    switch(listitem)
			    {
			        case 0: ShowDialogToPlayer(playerid, DIALOG_GANGARMSPRICES);
					case 1: ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEPOSITMATS);
					case 2: ShowDialogToPlayer(playerid, DIALOG_GANGARMSWITHDRAWMATS);
					case 3: ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSITS);
					case 4: ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAWS);
			    }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEALER);
			}
		}
		case DIALOG_GANGARMSDEPOSITMATS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 6)
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    if(sscanf(inputtext, "i", amount))
			    {
			        return ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEPOSITMATS);
				}
				if(amount < 1 || amount > PlayerInfo[playerid][pMaterials])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			        return ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEPOSITMATS);
			    }

			    GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials] += amount;
			    PlayerInfo[playerid][pMaterials] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials], PlayerInfo[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SM(playerid, COLOR_GREEN, "You have deposited %i materials in your arms dealer NPC.", amount);
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
		}
		case DIALOG_GANGARMSWITHDRAWMATS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 6)
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    if(sscanf(inputtext, "i", amount))
			    {
			        return ShowDialogToPlayer(playerid, DIALOG_GANGARMSWITHDRAWMATS);
				}
				if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials])
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			        return ShowDialogToPlayer(playerid, DIALOG_GANGARMSWITHDRAWMATS);
			    }

			    GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials] -= amount;
			    PlayerInfo[playerid][pMaterials] += amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsMaterials], PlayerInfo[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SM(playerid, COLOR_GREEN, "You have withdrawn %i materials from your arms dealer NPC.", amount);
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
		}
		case DIALOG_GANGAMMODEPOSITS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
		    }
		}
		case DIALOG_GANGAMMOWITHDRAWS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
		    }
		}
		case DIALOG_GANGAMMODEPOSIT:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        switch(PlayerInfo[playerid][pSelected])
		        {
		            case 0: // HP ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pHPAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armshpammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i rounds of "SVRCLR"hollow point ammo{CCFFFF} in your arms dealer NPC.", amount);
					}
					case 1: // Poison ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pPoisonAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armspoisonammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i rounds of "SVRCLR"poison tip ammo{CCFFFF} in your arms dealer NPC.", amount);
					}
					case 2: // FMJ ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pFMJAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo] += amount;
						SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] - amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsfmjammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i rounds of "SVRCLR"FMJ ammo{CCFFFF} in your arms dealer NPC.", amount);
					}
				}
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGAMMODEPOSITS);
		}
		case DIALOG_GANGAMMOWITHDRAW:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        switch(PlayerInfo[playerid][pSelected])
		        {
		            case 0: // HP ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pHPAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_HPAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i HP ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pHPAmmo], GetPlayerCapacity(playerid, CAPACITY_HPAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_HP, PlayerInfo[playerid][pHPAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armshpammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsHPAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i rounds of "SVRCLR"hollow point ammo{CCFFFF} from your arms dealer NPC.", amount);
					}
					case 1: // Poison ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pPoisonAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_POISONAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i poison ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPoisonAmmo], GetPlayerCapacity(playerid, CAPACITY_POISONAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_POISON, PlayerInfo[playerid][pPoisonAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armspoisonammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsPoisonAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i rounds of "SVRCLR"poison tip ammo{CCFFFF} from your arms dealer NPC.", amount);
					}
					case 2: // FMJ ammo
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pFMJAmmo] + amount > GetPlayerCapacity(playerid, CAPACITY_FMJAMMO))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i FMJ ammo. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pFMJAmmo], GetPlayerCapacity(playerid, CAPACITY_FMJAMMO));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo] -= amount;
						SetWeaponAmmo(playerid, AMMO_FMJ, PlayerInfo[playerid][pFMJAmmo] + amount);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET armsfmjammo = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gArmsFMJAmmo], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i rounds of "SVRCLR"FMJ ammo{CCFFFF} from your arms dealer NPC.", amount);
					}
				}
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGAMMOWITHDRAWS);
		}
		case DIALOG_GANGDRUGDEALER:
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugX], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugY], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    if(listitem == 0)
			    {
					ShowDialogToPlayer(playerid, DIALOG_GANGDRUGSHOP);
				}
				else if(listitem == 1)
				{
				    if(PlayerInfo[playerid][pGang] != PlayerInfo[playerid][pDealerGang])
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "This drug dealer doesn't belong to your gang.");
				    }
				    if(PlayerInfo[playerid][pGangRank] < 6)
				    {
				        return SendClientMessage(playerid, COLOR_SYNTAX, "You need to be rank 6+ in order to edit.");
					}

					ShowDialogToPlayer(playerid, DIALOG_GANGDRUGEDIT);
				}
			}
		}
		case DIALOG_GANGDRUGSHOP:
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugX], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugY], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    PlayerInfo[playerid][pSelected] = listitem;
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEALER);
			}
		}
		case DIALOG_GANGDRUGBUY:
		{
            if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugX], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugY], GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugZ]))
		    {
		        return 1;
			}

			if(response)
			{
			    new amount;

			    switch(PlayerInfo[playerid][pSelected])
			    {
			        case 0: // Pot
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPot])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][0] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many grams.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pPot] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][0] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPot] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						PlayerInfo[playerid][pPot] += amount;
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugpot = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPot], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the drug dealer and received %i grams of pot.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i grams of "SVRCLR"pot{CCFFFF} for $%i.", amount, cost);
					}
					case 1: // Crack
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugCrack])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][1] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many grams.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pCrack] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][1] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugCrack] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						PlayerInfo[playerid][pCrack] += amount;
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugcrack = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugCrack], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the drug dealer and received %i grams of Crack.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i grams of "SVRCLR"Crack{CCFFFF} for $%i.", amount, cost);
					}
					case 2: // Meth
			        {
			            if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugMeth])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pCash] < GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][2] * amount)
			            {
			                SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to buy that many grams.");
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
			            }
			            if(PlayerInfo[playerid][pMeth] + amount > GetPlayerCapacity(playerid, CAPACITY_METH))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGBUY);
						}

						new cost = GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugPrices][2] * amount;

						GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugMeth] -= amount;
						GangInfo[PlayerInfo[playerid][pDealerGang]][gCash] += cost;

						PlayerInfo[playerid][pMeth] += amount;
						GivePlayerCash(playerid, -cost);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugmeth = %i, cash = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pDealerGang]][gDrugMeth], GangInfo[PlayerInfo[playerid][pDealerGang]][gCash], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i to the drug dealer and received %i grams of meth.", GetRPName(playerid), cost, amount);
						SM(playerid, COLOR_GREEN, "You have purchased %i grams of "SVRCLR"meth{CCFFFF} for $%i.", amount, cost);
					}
			    }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGSHOP);
			}
		}
        case DIALOG_GANGDRUGEDIT:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 6)
		    {
		        return 1;
			}

			if(response)
			{
			    switch(listitem)
			    {
			        case 0: ShowDialogToPlayer(playerid, DIALOG_GANGDRUGPRICES);
					case 1: ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSITS);
					case 2: ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAWS);
			    }
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEALER);
			}
		}
        case DIALOG_GANGDRUGPRICES:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowPlayerDialog(playerid, DIALOG_GANGDRUGPRICE, DIALOG_STYLE_INPUT, "Drug dealer | Prices", "Enter the new price for this drug:", "Submit", "Back");
		    }
		    else
		    {
		        ShowDialogToPlayer(playerid, DIALOG_GANGDRUGEDIT);
			}
		}
		case DIALOG_GANGDRUGPRICE:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        if(sscanf(inputtext, "i", amount))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_GANGDRUGPRICE, DIALOG_STYLE_INPUT, "Drug dealer | Prices", "Enter the new price for this drug:", "Submit", "Back");
				}
				if(amount < 0)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The amount can't be below $0.");
				    return ShowPlayerDialog(playerid, DIALOG_GANGDRUGPRICE, DIALOG_STYLE_INPUT, "Drug dealer | Prices", "Enter the new price for this drug:", "Submit", "Back");
				}

				GangInfo[PlayerInfo[playerid][pGang]][gDrugPrices][PlayerInfo[playerid][pSelected]] = amount;

				if(PlayerInfo[playerid][pSelected] == 0) {
				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET pot_price = %i WHERE id = %i", amount, PlayerInfo[playerid][pGang]);
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"pot{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 1) {
		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET crack_price = %i WHERE id = %i", amount, PlayerInfo[playerid][pGang]);
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"crack{CCFFFF} to $%i.", amount);
		        } else if(PlayerInfo[playerid][pSelected] == 2) {
		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET meth_price = %i WHERE id = %i", amount, PlayerInfo[playerid][pGang]);
				    SM(playerid, COLOR_GREEN, "You have set the price of "SVRCLR"meth{CCFFFF} to $%i.", amount);
		        }

		        mysql_tquery(connectionID, queryBuffer);
		    }

		    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGPRICES);
		}
		case DIALOG_GANGDRUGDEPOSITS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGEDIT);
		    }
		}
		case DIALOG_GANGDRUGWITHDRAWS:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        PlayerInfo[playerid][pSelected] = listitem;
		        ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
			}
			else
			{
			    ShowDialogToPlayer(playerid, DIALOG_GANGDRUGEDIT);
		    }
		}
		case DIALOG_GANGDRUGDEPOSIT:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        switch(PlayerInfo[playerid][pSelected])
		        {
		            case 0: // Pot
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pPot])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gDrugPot] += amount;
						PlayerInfo[playerid][pPot] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugpot = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i grams of "SVRCLR"pot{CCFFFF} in your drug dealer NPC.", amount);
					}
					case 1: // Crack
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pCrack])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack] += amount;
						PlayerInfo[playerid][pCrack] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugcrack = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i grams of "SVRCLR"Crack{CCFFFF} in your drug dealer NPC.", amount);
					}
					case 2: // Meth
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
						}
						if(amount < 1 || amount > PlayerInfo[playerid][pMeth])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSIT);
			            }

						GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth] += amount;
						PlayerInfo[playerid][pMeth] -= amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugmeth = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth], PlayerInfo[playerid][pDealerGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have deposited %i grams of "SVRCLR"meth{CCFFFF} in your drug dealer NPC.", amount);
					}
				}
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGDRUGDEPOSITS);
		}
		case DIALOG_GANGDRUGWITHDRAW:
		{
		    if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
		    {
		        return 1;
		    }

		    if(response)
		    {
		        new amount;

		        switch(PlayerInfo[playerid][pSelected])
		        {
		            case 0: // Pot
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gDrugPot])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pPot] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i pot. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pPot], GetPlayerCapacity(playerid, CAPACITY_WEED));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gDrugPot] -= amount;
						PlayerInfo[playerid][pPot] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugpot = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugPot], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i grams of "SVRCLR"pot{CCFFFF} from your drug dealer NPC.", amount);
					}
					case 1: // Crack
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pCrack] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i Crack. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pCrack], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack] -= amount;
						PlayerInfo[playerid][pCrack] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugcrack = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugCrack], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i grams of "SVRCLR"Crack{CCFFFF} from your drug dealer NPC.", amount);
					}
					case 2: // Meth
		            {
		                if(sscanf(inputtext, "i", amount))
			            {
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}
						if(amount < 1 || amount > GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth])
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
						    return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
			            }
			            if(PlayerInfo[playerid][pMeth] + amount > GetPlayerCapacity(playerid, CAPACITY_METH))
			            {
			                SM(playerid, COLOR_SYNTAX, "You currently have %i/%i meth. You can't carry anymore until you upgrade your inventory skill.", PlayerInfo[playerid][pMeth], GetPlayerCapacity(playerid, CAPACITY_METH));
			                return ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAW);
						}

						GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth] -= amount;
						PlayerInfo[playerid][pMeth] += amount;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET drugmeth = %i WHERE id = %i", GangInfo[PlayerInfo[playerid][pGang]][gDrugMeth], PlayerInfo[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET meth = %i WHERE uid = %i", PlayerInfo[playerid][pMeth], PlayerInfo[playerid][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(playerid, COLOR_GREEN, "You have withdrawn %i grams of "SVRCLR"meth{CCFFFF} from your drug dealer NPC.", amount);
					}
				}
			}

			ShowDialogToPlayer(playerid, DIALOG_GANGDRUGWITHDRAWS);
		}
		case DIALOG_FREENAMECHANGE:
		{
		    if(response)
		    {
		        if(isnull(inputtext))
		        {
		            return ShowPlayerDialog(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
				}
				if(!(3 <= strlen(inputtext) <= 20))
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "Your name must contain 3 to 20 characters.");
				    return ShowPlayerDialog(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
				}
				if(strfind(inputtext, "_") == -1)
				{
				    SendClientMessage(playerid, COLOR_SYNTAX, "The name needs to contain at least one underscore.");
				    return ShowPlayerDialog(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
				}
                if(!IsValidName(inputtext))
                {
				    SendClientMessage(playerid, COLOR_SYNTAX, "That name is not supported by SA-MP.");
				    return ShowPlayerDialog(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
				}

		        PlayerInfo[playerid][pFreeNamechange] = 1;

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", inputtext);
		        mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptNameChange", "is", playerid, inputtext);
		    }
		    else
		    {
		    	if(!PlayerInfo[playerid][pLogged])
		        {
		            SAM(COLOR_YELLOW, "AdmWarning: %s[%i] has been kicked for failing to change their name.", GetRPName(playerid), playerid);
		            KickPlayer(playerid);
		        }
		        else
		        {
			    	PlayerInfo[playerid][pJailType] = 2;
				    PlayerInfo[playerid][pJailTime] = 10 * 60;

					ResetPlayerWeaponsEx(playerid);
					ResetPlayer(playerid);

					SetPlayerInJail(playerid);
					GameTextForPlayer(playerid, "~w~Welcome to~n~~r~admin jail", 5000, 3);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonedby = 'Server', prisonreason = 'Failing to change their name' WHERE uid = %i", PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);

					strins(PlayerInfo[playerid][pPrisonedBy], "Server", 0);
					strins(PlayerInfo[playerid][pPrisonReason], "Failing to change their name", 0);

	                SAM(COLOR_YELLOW, "AdmWarning: %s [%i] has been prisoned for failing to change their name.", GetRPName(playerid), playerid);
				}
			}
		}
	}
	return 1;
}

// Commands //

forward LastAlertPayCheck(playerid);
public LastAlertPayCheck(playerid)
{
	if(PayCheckCode[playerid] != 0)
	{
    	//GameTextForPlayer(playerid, "~w~Type /signcheck", 2500, 1);
		Dyuze(playerid, "Payday", "Type /signcheck to get your paycheck.");
    	SendClientMessage(playerid, COLOR_WHITE, "You have one minute left before your paycheck code expires. Please type /signcheck to get your paycheck.");
        SetTimerEx("DestroyCheck", 63000, false, "i", playerid);
	}
}

forward DestroyCheck(playerid);
public DestroyCheck(playerid)
{
	if(PayCheckCode[playerid] != 0)
	{
    	PayCheckCode[playerid] = 0;
    	SendClientMessage(playerid, COLOR_WHITE, "Your paycheck code expired. Please remember to use /signcheck next time.");
	}
}

