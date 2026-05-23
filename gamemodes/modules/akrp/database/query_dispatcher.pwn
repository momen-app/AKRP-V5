forward OnQueryFinished(threadid, extraid);
public OnQueryFinished(threadid, extraid)
{
	new rows = SQL_GetRows();

	switch(threadid)
	{
	    case THREAD_LOOKUP_BANS:
	    {
	        if(rows)
        	{
	            new bannedby[24], date[24], reason[128], ip[32], name[64], string[64];

	            SQL_GetString(0, "name", name);
	            SQL_GetString(0, "ip", ip);
	            SQL_GetString(0, "bannedby", bannedby);
	            SQL_GetString(0, "date", date);
	            SQL_GetString(0, "reason", reason);

				Dyuze(extraid, "Notice", "You are banned!", 999999);

				if(SQL_GetInt(0, "permanent"))
				    SM(extraid, COLOR_YELLOW, "You are permanently banned from this server.");
				else
					SM(extraid, COLOR_YELLOW, "You are banned from this server. You can appeal your ban at ("SERVER_URL")");


	            format(string, sizeof(string), "%s", name);
				DynamicPlayerTextDrawSetString(extraid, BanPlayerTD[extraid][0], string);

				format(string, sizeof(string), "%s", ip);
				DynamicPlayerTextDrawSetString(extraid, BanPlayerTD[extraid][1], string);

				format(string, sizeof(string), "%s", bannedby);
				DynamicPlayerTextDrawSetString(extraid, BanPlayerTD[extraid][2], string);

				format(string, sizeof(string), "%s", date);
				DynamicPlayerTextDrawSetString(extraid, BanPlayerTD[extraid][3], string);

				format(string, sizeof(string), "%s", reason);
				DynamicPlayerTextDrawSetString(extraid, BanPlayerTD[extraid][4], string);

				TextDrawShowForPlayer(extraid, BanTD[0]);
				TextDrawShowForPlayer(extraid, BanTD[1]);
				TextDrawShowForPlayer(extraid, BanTD[2]);
				TextDrawShowForPlayer(extraid, BanTD[3]);
				TextDrawShowForPlayer(extraid, BanTD[4]);
				TextDrawShowForPlayer(extraid, BanTD[5]);
				TextDrawShowForPlayer(extraid, BanTD[6]);
				TextDrawShowForPlayer(extraid, BanTD[7]);
				TextDrawShowForPlayer(extraid, BanTD[8]);
				TextDrawShowForPlayer(extraid, BanTD[9]);
				TextDrawShowForPlayer(extraid, BanTD[10]);
				PlayerTextDrawShow(extraid, BanPlayerTD[extraid][0]);
				PlayerTextDrawShow(extraid, BanPlayerTD[extraid][1]);
				PlayerTextDrawShow(extraid, BanPlayerTD[extraid][2]);
				PlayerTextDrawShow(extraid, BanPlayerTD[extraid][3]);
				PlayerTextDrawShow(extraid, BanPlayerTD[extraid][4]);

				KickPlayer(extraid);
	        }
	        else
	        {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, ip, lasttime FROM users WHERE username = '%s'", GetPlayerNameEx(extraid));
				mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOOKUP_ACCOUNT, extraid);
	        }
		}

		case THREAD_LOOKUP_ACCOUNT:
		{
			if (rows)
			{
				new playerip[32], lastlogin, currentip[32], uid;
				new specifiers[] = "%D of %M, %Y @ %k:%i";


				lastlogin = SQL_GetInt(0, "lasttime");
				uid = SQL_GetInt(0, "uid");
				SQL_GetString(0, "ip", playerip, sizeof(playerip));


				GetPlayerIp(extraid, currentip, sizeof(currentip));

				new currentTime = gettime();
			
				if ((currentTime - lastlogin) <= 600 && !strcmp(playerip, currentip, true)) 
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT *, DATE_FORMAT(lastlogin, '%s') AS login_date FROM users WHERE uid = %d", specifiers, uid);
					mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_PROCESS_LOGIN, extraid);
					PlayerInfo[extraid][pLoggedAuto] = 1;		
				}
				else
				{
					SCMf(extraid, COLOR_GREEN, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] Welcome back! Please login with your {ff6600}Credentials{ffffff}.");
					new i;
					for (i = 0; i < 51; i++)
					{
						new string[44];
						format(string, sizeof(string), "%s", GetRPName(extraid));
						PlayerTextDrawShow(extraid, LOGINTD[extraid][i]);
						DynamicPlayerTextDrawSetString(extraid, LOGINTD[extraid][20], string);
					}

					SelectTextDraw(extraid, 0x33AA33AA); 
				}
			}
			else
			{
				if (strfind(GetPlayerNameEx(extraid), "_") == -1)
				{
					ShowPlayerDialog(extraid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-Roleplay Name", "An administrator has concluded that your name is non-RP.\nTherefore, you have been given this free name change to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:","Submit", "");
				}
				else
				{
					new i;
					for (i = 0; i < 15; i++)
					{
						PlayerTextDrawShow(extraid, REGISTER[extraid][i]);
					}

					SelectTextDraw(extraid, COLOR_RED);  
				}
			}
		}
	    case THREAD_VALET_CARS:
		{
		    if(!rows)
		    {
		        SM(extraid, COLOR_SYNTAX, "You own no vehicles which you can spawn.");
		    }
		    else
		    {
		        new string[2084], vehicleid;

		        string = "#\tModel\tStatus\tLocation";

		        for(new i = 0; i < rows; i ++)
		        {
		            if((vehicleid = GetVehicleLinkedID(SQL_GetInt(i, "id"))) != INVALID_VEHICLE_ID)
		                format(string, sizeof(string), "%s\n%i\t%s\t"GREEN"Spawned"WHITE"\t%s", string, i + 1, vehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleZoneName(vehicleid));
					else if(SQL_GetInt(i, "impounded"))
						format(string, sizeof(string), "%s\n%i\t%s\t{FF0000}Impounded{FFFFFF}\tDMV", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400]);
					else
						format(string, sizeof(string), "%s\n%i\t%s\t"RED"Despawned"WHITE"\t%s", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "world")) ? ("Garage") : (GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"))));
				}

				ShowPlayerDialog(extraid, DIALOG_VALETSTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");

		    }
		}
	    case THREAD_ACCOUNT_REGISTER:
	    {
	        new
	            id = cache_insert_id();

			if(id)
	        {
	        	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE uid = %i", id);
	        	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_PROCESS_LOGIN, extraid);
	        }
	    }
	   case THREAD_PROCESS_MUSIC:
       {
           new loginmusic[128];
		   if(!rows)
		   {
			  SendClientMessage(extraid,COLOR_SYNTAX,"Login music URL is null or empty. Cannot play audio stream.");
		   }
           else if(SQL_GetString(0, "loginurl", loginmusic, sizeof(loginmusic)))
           {
                PlayerInfo[extraid][pLoginmusic] = loginmusic;

                if (strlen(PlayerInfo[extraid][pLoginmusic]) > 0)
                {
                     PlayAudioStreamForPlayer(extraid, PlayerInfo[extraid][pLoginmusic]);
                }
                else
                {
                     SendClientMessage(extraid,COLOR_SYNTAX,"Login music URL is null or empty. Cannot play audio stream.");
                }
            }
    
       }
	   case THREAD_PROCESS_LOGIN:
	    {	// OnPlayerLogin
	        if(!rows)
	        {
	            PlayerInfo[extraid][pLoginTries]++;

				if(PlayerInfo[extraid][pLoginTries] < 3)
				{

				     //PlayerText_InterpolateColor(extraid, LOGINTD[extraid][9], 0xFF0000FF, 500, EASE_OUT_QUAD);
                     //PlayerText_InterpolateColor(extraid, LOGINTD[extraid][10], 0xFF0000FF, 500, EASE_OUT_QUAD);
				     
		             SM(extraid, COLOR_LIGHTRED, "Incorrect password. You have %i more attempts before you are kicked.", 3 - PlayerInfo[extraid][pLoginTries]);
				}
				else
				{
					Kick(extraid);
				}
				
		    } // put "!" for whitelist
			
	        else if(!SQL_GetInt(0, "locked"))
         	{
          		SendClientMessage(extraid, COLOR_LIGHTRED, "** This account is not whitelsted. Contact us "SERVER_URL" to put your account in the whitelist.");
            	SAM(COLOR_YELLOW, "AdmWarning: %s tried to login with not whitelist.", GetRPName(extraid));
             	KickPlayer(extraid);
            }
			else
   			{
	            new date[64];
                for(new i = 0; i < 51; i ++)
                {
			       PlayerTextDrawDestroy(extraid,LOGINTD[extraid][i]);
			       CancelSelectTextDraw(extraid);
                }
               	
	            SQL_GetString(0, "login_date", date, 64);
	            SQL_GetString(0, "accent", PlayerInfo[extraid][pAccent], 16);
	            SQL_GetString(0, "adminname", PlayerInfo[extraid][pAdminName], MAX_PLAYER_NAME);
	            SQL_GetString(0, "contractby", PlayerInfo[extraid][pContractBy], MAX_PLAYER_NAME);
	            SQL_GetString(0, "prisonedby", PlayerInfo[extraid][pPrisonedBy], MAX_PLAYER_NAME);
	            SQL_GetString(0, "prisonreason", PlayerInfo[extraid][pPrisonReason], 128);
	            PlayerInfo[extraid][pDonateWeapon] = SQL_GetInt(0, "donateweapon");
	            SQL_GetString(0, "passportname", PlayerInfo[extraid][pPassportName], MAX_PLAYER_NAME);
	            SQL_GetString(0, "customtitle", PlayerInfo[extraid][pCustomTitle], 64);
	            PlayerInfo[extraid][pCustomTColor] = SQL_GetInt(0, "customcolor");
	            PlayerInfo[extraid][pID] = SQL_GetInt(0, "uid");
				PlayerInfo[extraid][pSetup] = SQL_GetInt(0, "setup");
                PlayerInfo[extraid][pGender] = SQL_GetInt(0, "gender");
                PlayerInfo[extraid][pAge] = SQL_GetInt(0, "age");
                PlayerInfo[extraid][pSkin] = SQL_GetInt(0, "skin");
                PlayerInfo[extraid][pCameraX] = SQL_GetFloat(0, "camera_x");
                PlayerInfo[extraid][pCameraY] = SQL_GetFloat(0, "camera_y");
                PlayerInfo[extraid][pCameraZ] = SQL_GetFloat(0, "camera_z");
                PlayerInfo[extraid][pPosX] = SQL_GetFloat(0, "pos_x");
                PlayerInfo[extraid][pPosY] = SQL_GetFloat(0, "pos_y");
                PlayerInfo[extraid][pPosZ] = SQL_GetFloat(0, "pos_z");
                PlayerInfo[extraid][pPosA] = SQL_GetFloat(0, "pos_a");
                PlayerInfo[extraid][pInterior] = SQL_GetInt(0, "interior");
                PlayerInfo[extraid][pWorld] = SQL_GetInt(0, "world");
                PlayerInfo[extraid][pCash] = SQL_GetInt(0, "cash");
                PlayerInfo[extraid][pVoted] = SQL_GetInt(0, "voted");
                PlayerInfo[extraid][pBank] = SQL_GetInt(0, "bank");
                PlayerInfo[extraid][pPaycheck] = SQL_GetInt(0, "paycheck");
                PlayerInfo[extraid][pLevel] = SQL_GetInt(0, "level");
                PlayerInfo[extraid][pEXP] = SQL_GetInt(0, "exp");
                PlayerInfo[extraid][pMinutes] = SQL_GetInt(0, "minutes");
                PlayerInfo[extraid][pHours] = SQL_GetInt(0, "hours");
                PlayerInfo[extraid][pAdmin] = SQL_GetInt(0, "adminlevel");
                PlayerInfo[extraid][pHelper] = SQL_GetInt(0, "helperlevel");
                PlayerInfo[extraid][pHealth] = SQL_GetFloat(0, "health");
                PlayerInfo[extraid][pArmor] = SQL_GetFloat(0, "armor");
                PlayerInfo[extraid][pUpgradePoints] = SQL_GetInt(0, "upgradepoints");
				PlayerInfo[extraid][pWarnings] = SQL_GetInt(0, "warnings");
				PlayerInfo[extraid][pComserv] = SQL_GetInt(0, "comserv");
				PlayerInfo[extraid][pInjured] = SQL_GetInt(0, "injured");
				PlayerInfo[extraid][pHospital] = SQL_GetInt(0, "hospital");
				PlayerInfo[extraid][pSpawnHealth] = SQL_GetFloat(0, "spawnhealth");
                PlayerInfo[extraid][pSpawnArmor] = SQL_GetFloat(0, "spawnarmor");
                PlayerInfo[extraid][pJailType] = SQL_GetInt(0, "jailtype");
                PlayerInfo[extraid][pJailTime] = SQL_GetInt(0, "jailtime");
                PlayerInfo[extraid][pFormerAdmin] = SQL_GetInt(0, "formeradmin");
                PlayerInfo[extraid][pNewbieMuted] = SQL_GetInt(0, "newbiemuted");
                PlayerInfo[extraid][pHelpMuted] = SQL_GetInt(0, "helpmuted");
                PlayerInfo[extraid][pAdMuted] = SQL_GetInt(0, "admuted");
                PlayerInfo[extraid][pLiveMuted] = SQL_GetInt(0, "livemuted");
                PlayerInfo[extraid][pGlobalMuted] = SQL_GetInt(0, "globalmuted");
                PlayerInfo[extraid][pReportMuted] = SQL_GetInt(0, "reportmuted");
                PlayerInfo[extraid][pReportWarns] = SQL_GetInt(0, "reportwarns");
                PlayerInfo[extraid][pFightStyle] = SQL_GetInt(0, "fightstyle");
                PlayerInfo[extraid][pDirtyCash] = SQL_GetInt(0, "dirtycash");
                PlayerInfo[extraid][pRedbull] = SQL_GetInt(0, "energydrink");
                PlayerInfo[extraid][pRedroll] = SQL_GetInt(0, "energyroll");
                PlayerInfo[extraid][pSIM] = SQL_GetInt(0, "sim");
				PlayerInfo[extraid][pLoadExpiry] = SQL_GetInt(0, "loadtime");
				PlayerInfo[extraid][pLoad] = SQL_GetInt(0, "load");
				PlayerInfo[extraid][pPepperSpray] = SQL_GetInt(0, "pepperspray");
				PlayerInfo[extraid][pToggleHUD] = 1;
                
                PlayerInfo[extraid][pPassword] = 0;
                
				#if defined Christmas
					PlayerInfo[extraid][pCandy] = SQL_GetInt(0, "candy");
				#endif             

                PlayerInfo[extraid][pFood] = SQL_GetInt(0, "food");
				PlayerInfo[extraid][pDrink] = SQL_GetInt(0, "drink");

                //kits
                PlayerInfo[extraid][pRepairKit] = SQL_GetInt(0, "repairkit");
                PlayerInfo[extraid][pToolkit] = SQL_GetInt(0, "toolkit");
                PlayerInfo[extraid][pLockpick] = SQL_GetInt(0, "lockpick");
				

				PlayerInfo[extraid][pPhonee] = SQL_GetInt(0, "Phonep");
				PlayerInfo[extraid][pHelmet] = SQL_GetInt(0, "helmet");
				PlayerInfo[extraid][pHelmet1] = SQL_GetInt(0, "helmetp");
				PlayerInfo[extraid][pHidehelmet] = SQL_GetInt(0, "helmethide");
				
				
				PlayerInfo[extraid][pPhone] = SQL_GetInt(0, "phone");
				PlayerInfo[extraid][pJob] = SQL_GetInt(0, "job");
				PlayerInfo[extraid][pSecondJob] = SQL_GetInt(0, "secondjob");
				PlayerInfo[extraid][pCrimes] = SQL_GetInt(0, "crimes");
				PlayerInfo[extraid][pArrested] = SQL_GetInt(0, "arrested");
				PlayerInfo[extraid][pWantedLevel] = SQL_GetInt(0, "wantedlevel");
				PlayerInfo[extraid][pMaterials] = SQL_GetInt(0, "materials");
				PlayerInfo[extraid][pPot] = SQL_GetInt(0, "pot");
				PlayerInfo[extraid][pCrack] = SQL_GetInt(0, "crack");
				PlayerInfo[extraid][pMeth] = SQL_GetInt(0, "meth");
                PlayerInfo[extraid][pMedkit] = SQL_GetInt(0, "medkit");
				PlayerInfo[extraid][pPainkillers] = SQL_GetInt(0, "painkillers");
				PlayerInfo[extraid][pBandage] = SQL_GetInt(0, "bandage");
				PlayerInfo[extraid][pVest] = SQL_GetInt(0, "vest");
				PlayerInfo[extraid][pSeeds] = SQL_GetInt(0, "seeds");
				PlayerInfo[extraid][pEphedrine] = SQL_GetInt(0, "ephedrine");
				PlayerInfo[extraid][pMuriaticAcid] = SQL_GetInt(0, "muriaticacid");
				PlayerInfo[extraid][pMobileMethLab] = SQL_GetInt(0, "MobileMethLab");
				PlayerInfo[extraid][pBatteries] = SQL_GetInt(0, "batteries");
				PlayerInfo[extraid][pAcetone] = SQL_GetInt(0, "acetone");
				PlayerInfo[extraid][pBakingSoda] = SQL_GetInt(0, "bakingsoda");
				PlayerInfo[extraid][pCigars] = SQL_GetInt(0, "cigars");
				PlayerInfo[extraid][pWalkieTalkie] = SQL_GetInt(0, "walkietalkie");
				PlayerInfo[extraid][pChannel] = SQL_GetInt(0, "channel");
				PlayerInfo[extraid][pRentingHouse] = SQL_GetInt(0, "rentinghouse");
				PlayerInfo[extraid][pSpraycans] = SQL_GetInt(0, "spraycans");
				PlayerInfo[extraid][pBoombox] = SQL_GetInt(0, "boombox");
				PlayerInfo[extraid][pMP3Player] = SQL_GetInt(0, "mp3player");
				PlayerInfo[extraid][pPhonebook] = SQL_GetInt(0, "phonebook");
				PlayerInfo[extraid][pFishingRod] = SQL_GetInt(0, "fishingrod");
				PlayerInfo[extraid][pFishingBait] = SQL_GetInt(0, "fishingbait");
				PlayerInfo[extraid][pFishWeight] = SQL_GetInt(0, "fishweight");
				PlayerInfo[extraid][pFishingSkill] = SQL_GetInt(0, "fishingskill");
				PlayerInfo[extraid][pCourierSkill] = SQL_GetInt(0, "courierskill");
				PlayerInfo[extraid][pGuardSkill] = SQL_GetInt(0, "guardskill");
				PlayerInfo[extraid][pWeaponSkill] = SQL_GetInt(0, "weaponskill");
				PlayerInfo[extraid][pLawyerSkill] = SQL_GetInt(0, "lawyerskill");
				PlayerInfo[extraid][pSmugglerSkill] = SQL_GetInt(0, "smugglerskill");
            	PlayerInfo[extraid][pDetectiveSkill] = SQL_GetInt(0, "detectiveskill");
				PlayerInfo[extraid][pToggleTextdraws] = SQL_GetInt(0, "toggletextdraws");
				PlayerInfo[extraid][pToggleOOC] = SQL_GetInt(0, "toggleooc");
				PlayerInfo[extraid][pTogglePhone] = SQL_GetInt(0, "togglephone");
				PlayerInfo[extraid][pToggleAdmin] = SQL_GetInt(0, "toggleadmin");
				PlayerInfo[extraid][pToggleHelper] = SQL_GetInt(0, "togglehelper");
				PlayerInfo[extraid][pToggleNewbie] = SQL_GetInt(0, "togglenewbie");
				PlayerInfo[extraid][pToggleWT] = SQL_GetInt(0, "togglewt");
				PlayerInfo[extraid][pToggleRadio] = SQL_GetInt(0, "toggleradio");
				PlayerInfo[extraid][pToggleVIP] = SQL_GetInt(0, "togglevip");
				PlayerInfo[extraid][pToggleMusic] = SQL_GetInt(0, "togglemusic");
				PlayerInfo[extraid][pToggleFaction] = SQL_GetInt(0, "togglefaction");
				PlayerInfo[extraid][pToggleNews] = SQL_GetInt(0, "togglenews");
				PlayerInfo[extraid][pToggleGlobal] = SQL_GetInt(0, "toggleglobal");
				PlayerInfo[extraid][pToggleCam] = SQL_GetInt(0, "togglecam");
				PlayerInfo[extraid][pToggleHUD] = 1;
				PlayerInfo[extraid][pCarLicense] = SQL_GetInt(0, "carlicense");
				PlayerInfo[extraid][pWeaponLicense] = SQL_GetInt(0, "gunlicense");
				PlayerInfo[extraid][pBuygun] = SQL_GetInt(0, "buygun");
				PlayerInfo[extraid][pBGTime] = SQL_GetInt(0, "bgtime");
				PlayerInfo[extraid][pVIPPackage] = SQL_GetInt(0, "vippackage");
				PlayerInfo[extraid][pVIPTime] = SQL_GetInt(0, "viptime");
				PlayerInfo[extraid][pVIPCooldown] = SQL_GetInt(0, "vipcooldown");
				PlayerInfo[extraid][pWeapons][0] = SQL_GetInt(0, "weapon_0");
				PlayerInfo[extraid][pWeapons][1] = SQL_GetInt(0, "weapon_1");
				PlayerInfo[extraid][pWeapons][2] = SQL_GetInt(0, "weapon_2");
				PlayerInfo[extraid][pWeapons][3] = SQL_GetInt(0, "weapon_3");
				PlayerInfo[extraid][pWeapons][4] = SQL_GetInt(0, "weapon_4");
				PlayerInfo[extraid][pWeapons][5] = SQL_GetInt(0, "weapon_5");
				PlayerInfo[extraid][pWeapons][6] = SQL_GetInt(0, "weapon_6");
				PlayerInfo[extraid][pWeapons][7] = SQL_GetInt(0, "weapon_7");
				PlayerInfo[extraid][pWeapons][8] = SQL_GetInt(0, "weapon_8");
				PlayerInfo[extraid][pWeapons][9] = SQL_GetInt(0, "weapon_9");
				PlayerInfo[extraid][pWeapons][10] = SQL_GetInt(0, "weapon_10");
				PlayerInfo[extraid][pWeapons][11] = SQL_GetInt(0, "weapon_11");
				PlayerInfo[extraid][pWeapons][12] = SQL_GetInt(0, "weapon_12");
				PlayerInfo[extraid][pFaction] = SQL_GetInt(0, "faction");
				PlayerInfo[extraid][pFactionRank] = SQL_GetInt(0, "factionrank");
				PlayerInfo[extraid][pGang] = SQL_GetInt(0, "gang");
				PlayerInfo[extraid][pGangRank] = SQL_GetInt(0, "gangrank");
				PlayerInfo[extraid][pDivision] = SQL_GetInt(0, "division");
				PlayerInfo[extraid][pContracted] = SQL_GetInt(0, "contracted");
				PlayerInfo[extraid][pBombs] = SQL_GetInt(0, "bombs");
				PlayerInfo[extraid][pCompletedHits] = SQL_GetInt(0, "completedhits");
				PlayerInfo[extraid][pFailedHits] = SQL_GetInt(0, "failedhits");
				PlayerInfo[extraid][pReports] = SQL_GetInt(0, "reports");
				PlayerInfo[extraid][pNewbies] = SQL_GetInt(0, "newbies");
				PlayerInfo[extraid][pHelpRequests] = SQL_GetInt(0, "helprequests");
				PlayerInfo[extraid][pSpeedometer] = SQL_GetInt(0, "speedometer");
				PlayerInfo[extraid][pFactionMod] = SQL_GetInt(0, "factionmod");
				PlayerInfo[extraid][pGangMod] = SQL_GetInt(0, "gangmod");
				PlayerInfo[extraid][pBanAppealer] = SQL_GetInt(0, "banappealer");
				PlayerInfo[extraid][pFactionBan] = SQL_GetInt(0, "factionban");
				PlayerInfo[extraid][pGangBan] = SQL_GetInt(0, "gangban");
				PlayerInfo[extraid][pPotPlanted] = SQL_GetInt(0, "potplanted");
				PlayerInfo[extraid][pPotTime] = SQL_GetInt(0, "pottime");
				PlayerInfo[extraid][pPotGrams] = SQL_GetInt(0, "potgrams");
				PlayerInfo[extraid][pPotX] = SQL_GetFloat(0, "pot_x");
				PlayerInfo[extraid][pPotY] = SQL_GetFloat(0, "pot_y");
				PlayerInfo[extraid][pPotZ] = SQL_GetFloat(0, "pot_z");
				PlayerInfo[extraid][pPotA] = SQL_GetFloat(0, "pot_a");
				PlayerInfo[extraid][pInventoryUpgrade] = SQL_GetInt(0, "inventoryupgrade");
				PlayerInfo[extraid][pAddictUpgrade] = SQL_GetInt(0, "addictupgrade");
                PlayerInfo[extraid][pTraderUpgrade] = SQL_GetInt(0, "traderupgrade");
                PlayerInfo[extraid][pAssetUpgrade] = SQL_GetInt(0, "assetupgrade");
                PlayerInfo[extraid][pLaborUpgrade] = SQL_GetInt(0, "laborupgrade");
   				PlayerInfo[extraid][pHPAmmo] = SQL_GetInt(0, "hpammo");
				PlayerInfo[extraid][pPoisonAmmo] = SQL_GetInt(0, "poisonammo");
				PlayerInfo[extraid][pFMJAmmo] = SQL_GetInt(0, "fmjammo");
				PlayerInfo[extraid][pAmmoType] = SQL_GetInt(0, "ammotype");
				PlayerInfo[extraid][pAmmoWeapon] = SQL_GetInt(0, "ammoweapon");
				PlayerInfo[extraid][pDMWarnings] = SQL_GetInt(0, "dmwarnings");
				PlayerInfo[extraid][pWeaponRestricted] = SQL_GetInt(0, "weaponrestricted");
				PlayerInfo[extraid][pReferralUID] = SQL_GetInt(0, "referral_uid");
				PlayerInfo[extraid][pWatch] = SQL_GetInt(0, "watch");
				PlayerInfo[extraid][pGPS] = SQL_GetInt(0, "gps");
				PlayerInfo[extraid][pGiveAmount] = SQL_GetInt(0, "Amount");
                PlayerInfo[extraid][pSelectItem] = SQL_GetInt(0, "Select");
				PlayerInfo[extraid][pClothes] = SQL_GetInt(0, "clothes");
				PlayerInfo[extraid][pShowLands] = SQL_GetInt(0, "showlands");
				PlayerInfo[extraid][pShowTurfs] = SQL_GetInt(0, "showturfs");
				PlayerInfo[extraid][pWatchOn] = SQL_GetInt(0, "watchon");
				PlayerInfo[extraid][pGPSOn] = SQL_GetInt(0, "gpson");
				PlayerInfo[extraid][pDoubleXP] = SQL_GetInt(0, "doublexp");
				PlayerInfo[extraid][pCourierCooldown] = SQL_GetInt(0, "couriercooldown");
                PlayerInfo[extraid][pDeathCooldown] = SQL_GetInt(0, "deathcooldown");
                PlayerInfo[extraid][pDetectiveCooldown] = SQL_GetInt(0, "detectivecooldown");
            	PlayerInfo[extraid][pGasCan] = SQL_GetInt(0, "gascan");
            	PlayerInfo[extraid][pDuty] = SQL_GetInt(0, "duty");
            	PlayerInfo[extraid][pRefunded] = SQL_GetInt(0, "refunded");
            	PlayerInfo[extraid][pBackpack] = SQL_GetInt(0, "backpack");
            	PlayerInfo[extraid][bpCash] = SQL_GetInt(0, "bpcash");
				PlayerInfo[extraid][bpMaterials] = SQL_GetInt(0, "bpmaterials");
				PlayerInfo[extraid][bpPot] = SQL_GetInt(0, "bppot");
				PlayerInfo[extraid][bpCrack] = SQL_GetInt(0, "bpcrack");
				PlayerInfo[extraid][bpMeth] = SQL_GetInt(0, "bpmeth");
				PlayerInfo[extraid][bpPainkillers] = SQL_GetInt(0, "bppainkillers");
    			PlayerInfo[extraid][bpWeapons][0] = SQL_GetInt(0, "bpweapon_0");
				PlayerInfo[extraid][bpWeapons][1] = SQL_GetInt(0, "bpweapon_1");
				PlayerInfo[extraid][bpWeapons][2] = SQL_GetInt(0, "bpweapon_2");
				PlayerInfo[extraid][bpWeapons][3] = SQL_GetInt(0, "bpweapon_3");
				PlayerInfo[extraid][bpWeapons][4] = SQL_GetInt(0, "bpweapon_4");
				PlayerInfo[extraid][bpWeapons][5] = SQL_GetInt(0, "bpweapon_5");
				PlayerInfo[extraid][bpWeapons][6] = SQL_GetInt(0, "bpweapon_6");
				PlayerInfo[extraid][bpWeapons][7] = SQL_GetInt(0, "bpweapon_7");
				PlayerInfo[extraid][bpWeapons][8] = SQL_GetInt(0, "bpweapon_8");
				PlayerInfo[extraid][bpWeapons][9] = SQL_GetInt(0, "bpweapon_9");
				PlayerInfo[extraid][bpWeapons][10] = SQL_GetInt(0, "bpweapon_10");
				PlayerInfo[extraid][bpWeapons][11] = SQL_GetInt(0, "bpweapon_11");
				PlayerInfo[extraid][bpWeapons][13] = SQL_GetInt(0, "bpweapon_13");
				PlayerInfo[extraid][bpWeapons][14] = SQL_GetInt(0, "bpweapon_14");
				PlayerInfo[extraid][bpHPAmmo] = SQL_GetInt(0, "bphpammo");
				PlayerInfo[extraid][bpPoisonAmmo] = SQL_GetInt(0, "bppoisonammo");
				PlayerInfo[extraid][bpFMJAmmo] = SQL_GetInt(0, "bpfmjammo");
                PlayerInfo[extraid][pPassport] = SQL_GetInt(0, "passport");
                PlayerInfo[extraid][pPassportLevel] = SQL_GetInt(0, "passportlevel");
                PlayerInfo[extraid][pPassportSkin] = SQL_GetInt(0, "passportskin");
                PlayerInfo[extraid][pPassportPhone] = SQL_GetInt(0, "passportphone");
                PlayerInfo[extraid][pRope] = SQL_GetInt(0, "rope");
                PlayerInfo[extraid][pBlindfold] = SQL_GetInt(0, "blindfold");
                PlayerInfo[extraid][pInsurance] = SQL_GetInt(0, "insurance");
                PlayerInfo[extraid][pMask] = SQL_GetInt(0, "mask");
    			PlayerInfo[extraid][pTotalPatients] = SQL_GetInt(0, "totalpatients");
				PlayerInfo[extraid][pTotalFires] = SQL_GetInt(0, "totalfires");
				PlayerInfo[extraid][pChatAnim] = SQL_GetInt(0, "chatanim");

                PlayerInfo[extraid][pLogged] = 1;
                PlayerInfo[extraid][pACTime] = gettime() + 5;

                PlayerInfo[extraid][pRareTime] = SQL_GetInt(0, "rarecooldown");
                PlayerInfo[extraid][pVipTimes] = SQL_GetInt(0, "vipdlcooldown");
                PlayerInfo[extraid][pDiamonds] = SQL_GetInt(0, "diamonds");
                PlayerInfo[extraid][pSkates] = SQL_GetInt(0, "rollerskates");
				PlayerInfo[extraid][pHunger] = SQL_GetInt(0, "hunger");
				PlayerInfo[extraid][pHungerTimer] = SQL_GetInt(0, "hungertimer");
				PlayerInfo[extraid][pThirst] = SQL_GetInt(0, "thirst");
				PlayerInfo[extraid][pThirstTimer] = SQL_GetInt(0, "thirsttimer");
				PlayerInfo[extraid][pLottery] = SQL_GetInt(0, "Lottery");
				PlayerInfo[extraid][pLotteryB] = SQL_GetInt(0, "LotteryB");
				PlayerInfo[extraid][pMarriedTo] = SQL_GetInt(0, "marriedto");
				PlayerInfo[extraid][pVoiceChat] = SQL_GetInt(0, "voicechat");
                PlayerInfo[extraid][pOre] = SQL_GetInt(0, "ore");
                PlayerInfo[extraid][pLaptop] = SQL_GetInt(0, "laptop");
	            PlayerInfo[extraid][pMetalCapacity] = SQL_GetInt(0, "metals");
                PlayerInfo[extraid][pCopper] = SQL_GetInt(0, "copper");
                PlayerInfo[extraid][pIorn] = SQL_GetInt(0, "iorn");
                PlayerInfo[extraid][pGold] = SQL_GetInt(0, "gold");
               
                PlayerInfo[extraid][pPSM4] = SQL_GetInt(0, "psm4");
                PlayerInfo[extraid][pPSCash] = SQL_GetInt(0, "pscash");
                PlayerInfo[extraid][pPSDCash] = SQL_GetInt(0, "psdcash");
                PlayerInfo[extraid][pPSCRACK] = SQL_GetInt(0, "pscrack");
                PlayerInfo[extraid][pPSMETH] = SQL_GetInt(0, "psmeth");
                PlayerInfo[extraid][pPSPOT] = SQL_GetInt(0, "pspot");
                PlayerInfo[extraid][pPSDEAGLE] = SQL_GetInt(0, "psdeagle");
                PlayerInfo[extraid][pPSMP5] = SQL_GetInt(0, "psmp5");
                PlayerInfo[extraid][pPSAK] = SQL_GetInt(0, "psak");
                PlayerInfo[extraid][pLastlogin] = SQL_GetInt(0, "lasttime");

                

				SQL_GetString(0, "discordtag", PlayerInfo[extraid][pDiscordTag], 8);
				SQL_GetString(0, "discordname", PlayerInfo[extraid][pDiscordName], 16);

                //Verification - Stewart
                PlayerInfo[extraid][pVerified] = SQL_GetInt(0, "verify");

				//Verification - Stewart
				PlayerInfo[extraid][pCode] = SQL_GetInt(0, "code");
				if(PlayerInfo[extraid][pVerified] == 1)
				{
					PlayerInfo[extraid][pCode] = 0;
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET code = %i WHERE uid = %i", PlayerInfo[extraid][pCode], PlayerInfo[extraid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}

				TogglePlayerControllable(extraid, 0);
				SetTimerEx("UnfreezePlayerEx", 5000, false, "i", extraid);

				if(PlayerInfo[extraid][pMarriedTo] != -1)
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username FROM users WHERE uid = %i", PlayerInfo[extraid][pMarriedTo]);
    				mysql_tquery(connectionID, queryBuffer, "OnUpdatePartner", "i", extraid);
				}
				else
				{
				    strcpy(PlayerInfo[extraid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
				}

                if(!PlayerInfo[extraid][pAdminDuty])
				{
					ClearChat(extraid);
                }

				if(!PlayerInfo[extraid][pToggleTextdraws])
				{

					if(PlayerInfo[extraid][pWatchOn])
					{
					   TextDrawShowForPlayer(extraid, TimeTD);
					}
					if(PlayerInfo[extraid][pGPSOn])
					{
                        ShowGPSTextdraw(extraid);
					}
				}

            	if(!isnull(gServerMOTD))
            	{
            		SM(extraid, SERVER_COLOR, "News:"WHITE" %s", gServerMOTD);
            	}
            	if(!isnull(adminMOTD) && PlayerInfo[extraid][pAdmin] > 0)
            	{
            		SM(extraid, COLOR_LIGHTRED, "Admin News:"WHITE" %s", adminMOTD);
            	}
            	if(!isnull(helperMOTD) && (PlayerInfo[extraid][pHelper] > 0 || PlayerInfo[extraid][pAdmin] > 0))
            	{
            		SM(extraid, COLOR_GREEN, "Helper News:"WHITE" %s", helperMOTD);
            	}
            	if(PlayerInfo[extraid][pGang] >= 0 && strcmp(GangInfo[PlayerInfo[extraid][pGang]][gMOTD], "None", true) != 0)
            	{
            		SM(extraid, COLOR_GREEN, "Gang News:"WHITE" %s", GangInfo[PlayerInfo[extraid][pGang]][gMOTD]);
            	}

				if(SQL_GetInt(0, "refercount") > 0)
				{
				    new
						count = SQL_GetInt(0, "refercount");

				    SM(extraid, COLOR_YELLOW, "%i players who you've referred reached level 3. Therefore you received +1 level!", count);

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET refercount = 0 WHERE uid = %i", PlayerInfo[extraid][pID]);
				    mysql_tquery(connectionID, queryBuffer);
				}

                if(!PlayerInfo[extraid][pSetup])
                {
                    if(!PlayerInfo[extraid][pAdminDuty] && !PlayerInfo[extraid][pToggleCam])
                    {
                        PlayerInfo[extraid][pLoginCamera] = 1;
					}
                    if(PlayerInfo[extraid][pPotPlanted] && PlayerInfo[extraid][pPotObject] == INVALID_OBJECT_ID)
                    {
                        PlayerInfo[extraid][pPotObject] = CreateDynamicObject(3409, PlayerInfo[extraid][pPotX], PlayerInfo[extraid][pPotY], PlayerInfo[extraid][pPotZ] - 1.8, 0.0, 0.0, PlayerInfo[extraid][pPotA]);
					}
					if(PlayerInfo[extraid][pShowTurfs])
					{
					    ShowTurfsOnMap(extraid, true);
					}
					if(PlayerInfo[extraid][pShowLands])
					{
					    ShowLandsOnMap(extraid, true);
					}

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET lastlogin = NOW(), ip = '%s' WHERE uid = %i", GetPlayerIP(extraid), PlayerInfo[extraid][pID]);
				    mysql_tquery(connectionID, queryBuffer);

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM flags WHERE uid = %i", PlayerInfo[extraid][pID]);
				    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_FLAGS, extraid);

			     	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM clothing WHERE uid = %i", PlayerInfo[extraid][pID]);
				    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_CLOTHING, extraid);

				    if(!PlayerInfo[extraid][pTogglePhone])
				    {
					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM texts WHERE recipient_number = %i", PlayerInfo[extraid][pPhone]);
					    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_TEXTS, extraid);
					}

					foreach(new i :Vehicle)
					{
					    if(IsValidVehicle(i) && IsVehicleOwner(extraid, i) && VehicleInfo[i][vTimer] >= 0)
					    {
							KillTimer(VehicleInfo[i][vTimer]);
							VehicleInfo[i][vTimer] = -1;
					    }
					}

					// Just in case.
					//SetPlayerSpecialTag(extraid, TAG_NORMAL);

				    if(PlayerInfo[extraid][pAdminDuty])
				    {
				    	PlayerInfo[extraid][pAdminDuty] = 0;
				    	SetPlayerName(extraid, PlayerInfo[extraid][pUsername]);

				        SAM(COLOR_LIGHTRED, "AdmCmd: %s is no longer on admin duty.", GetRPName(extraid));
				        SendClientMessage(extraid, COLOR_WHITE, "** You are no longer on admin duty. Your account's statistics have been preserved.");
				    }
				    else
				    {
					    if(PlayerInfo[extraid][pAdmin])
					    {
					        SAM(COLOR_LIGHTRED, "AdmCmd: %s %s has logged in.", GetAdminRank(extraid), GetRPName(extraid));
					    }
					    if(PlayerInfo[extraid][pGang] >= 0)
					    {
							SendGangMessage(PlayerInfo[extraid][pGang], COLOR_GREEN, "(( %s %s has logged in. ))", GangRanks[PlayerInfo[extraid][pGang]][PlayerInfo[extraid][pGangRank]], GetRPName(extraid));
						}
						if(PlayerInfo[extraid][pFaction] >= 0)
					    {
							SendFactionMessage(PlayerInfo[extraid][pFaction], COLOR_FACTIONCHAT, "(( %s %s has logged in. ))", FactionRanks[PlayerInfo[extraid][pFaction]][PlayerInfo[extraid][pFactionRank]], GetRPName(extraid));
						}

        	        	if(PlayerInfo[extraid][pAdmin] > 0) {
							SM(extraid, COLOR_WHITE, "Welcome back to "SVRCLR""SERVER_NAME""WHITE". You have logged in as a level %i %s.", PlayerInfo[extraid][pAdmin], GetAdminRank(extraid));
						} else if(PlayerInfo[extraid][pHelper] > 0) {
						    SM(extraid, COLOR_WHITE, "Welcome back to "SVRCLR""SERVER_NAME""WHITE". You have logged in as a %s.", GetHelperRank(extraid));
						} else if(PlayerInfo[extraid][pVIPPackage] > 0) {
						    SM(extraid, COLOR_WHITE, "Welcome back to "SVRCLR""SERVER_NAME""WHITE". You have logged in as a %s Donator.", GetDonatorRank(PlayerInfo[extraid][pVIPPackage]));
        	        	} else {
        	        	    SM(extraid, COLOR_WHITE, "Welcome back to "SVRCLR""SERVER_NAME""WHITE". You have logged in as a level %i player.", PlayerInfo[extraid][pLevel]);
        	        	}
					    StopAudioStreamForPlayer(extraid);
					}

					if(PlayerInfo[extraid][pFaction] >= 0 && FactionInfo[PlayerInfo[extraid][pFaction]][fType] == FACTION_NONE)
					{
			         	ResetPlayerWeaponsEx(extraid);
				        SM(extraid, COLOR_LIGHTRED, "You were either kicked from the faction while offline or it was deleted.");
			            SetPlayerSkin(extraid, 230);

				        PlayerInfo[extraid][pFaction] = -1;
				        PlayerInfo[extraid][pFactionRank] = 0;
				        PlayerInfo[extraid][pDivision] = -1;
				        PlayerInfo[extraid][pDuty] = 0;

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET faction = -1, factionrank = 0, division = -1 WHERE uid = %i", PlayerInfo[extraid][pID]);
					    mysql_tquery(connectionID, queryBuffer);
					}
					if(PlayerInfo[extraid][pGang] >= 0 && !GangInfo[PlayerInfo[extraid][pGang]][gSetup])
					{
					    SendClientMessage(extraid, COLOR_LIGHTRED, "You have either been kicked from the gang while offline or it was deleted.");
					    PlayerInfo[extraid][pGang] = -1;
					    PlayerInfo[extraid][pGangRank] = 0;

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerInfo[extraid][pID]);
					    mysql_tquery(connectionID, queryBuffer);
					}
				}
				new current_time = gettime();
				new time = current_time - PlayerInfo[extraid][pLastlogin];
                if (time > 1800 && PlayerInfo[extraid][pAdutyl] == 0 && !PlayerInfo[extraid][pInjured]) {
					for(new i = 0; i < 23; i++)
				 	{
					   PlayerTextDrawShow(extraid,SPAWN[extraid][i]);
					}
					SelectTextDraw(extraid,0x33AA33AA);
					PlayerInfo[extraid][pSpawn] = 2;
					InterpolateCameraPos(extraid, 263.017791, -2009.502685, 10.038359 , 260.985015, -1898.844848, 24.536014 , 14000);
					InterpolateCameraLookAt(extraid, 223.017791, -1950.502685, 10.038359,   263.017791, -2009.502685, 10.038359, 14000);
                }
	            else {
                    SetPlayerToSpawn(extraid);
				}
                   

	        }
	    }
	    case THREAD_COUNT_FLAGS:
	    {
	        if(rows)
	        {
				SAM(COLOR_YELLOW, "AdmWarning: %s[%i] has %i pending flags. (/listflags %i)", GetRPName(extraid), extraid, rows, extraid);
			}
		}
		case THREAD_TRACE_IP:
		{
		    if(rows)
		    {
		        new username[24], date[24];

		        SM(extraid, SERVER_COLOR, "%i Results Found", rows);

		        for(new i = 0; i < rows; i ++)
		        {
		            SQL_GetString(i, "username", username);
		            SQL_GetString(i, "lastlogin", date);

		            SM(extraid, COLOR_GREY2, "Name: %s - Last Seen: %s", username, date);
		        }
		    }
		    else
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "This IP address is not associated with any accounts.");
			}
		}
		case THREAD_LIST_CHANGES:
		{
		    new text[128];

		    SendClientMessage(extraid, SERVER_COLOR, ""REVISION"");

		    for(new i = 0; i < rows; i ++)
			{
			    SQL_GetString(i, "text", text);
			    SM(extraid, COLOR_GREY1, "%s", text);
			}
		}
		case THREAD_LIST_HELPERS:
		{
		    new username[MAX_PLAYER_NAME], lastlogin[24];

		    SendClientMessage(extraid, SERVER_COLOR, "Helper Roster:");

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "username", username);
		        SQL_GetString(i, "lastlogin", lastlogin);

		        switch(SQL_GetInt(i, "helperlevel"))
				{
					case 1: SM(extraid, COLOR_GREEN, "[H1]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 2: SM(extraid, COLOR_GREEN, "[H2]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 3: SM(extraid, COLOR_GREEN, "[H3]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 4: SM(extraid, COLOR_GREEN, "[H4]"WHITE" %s - Last Seen: %s", username, lastlogin);
				}
		    }
		}
		case THREAD_LIST_ADMINS:
		{
		    new username[MAX_PLAYER_NAME], lastlogin[24];

		    SendClientMessage(extraid, SERVER_COLOR, "Admin Roster:");

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "username", username);
		        SQL_GetString(i, "lastlogin", lastlogin);

		        switch(SQL_GetInt(i, "adminlevel"))
				{
					case 1: SM(extraid, SERVER_COLOR, "[A1]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 2: SM(extraid, SERVER_COLOR, "[A2]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 3: SM(extraid, SERVER_COLOR, "[A3]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 4: SM(extraid, SERVER_COLOR, "[A4]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 5: SM(extraid, SERVER_COLOR, "[A5]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 6: SM(extraid, SERVER_COLOR, "[A6]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 7: SM(extraid, SERVER_COLOR, "[A7]"WHITE" %s - Last Seen: %s", username, lastlogin);
					case 8: SM(extraid, SERVER_COLOR, "[A8]"WHITE" %s - Last Seen: %s", username, lastlogin);
				}
		    }
		}
		case THREAD_UPDATE_LANDLABELS:
		{
		    new landid = extraid;
			new string[128];
			if(IsValidDynamic3DTextLabel(LandInfo[landid][lText]))
			{
				if(LandInfo[landid][lOwnerID] > 0)
				{
					format(string, sizeof(string), "This land is owned by %s\n{FFD700}Level: %i/3\n{FFFFFF}%i/%i Objects", LandInfo[landid][lOwner], LandInfo[landid][lLevel], SQL_GetIntByIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
            		UpdateDynamic3DTextLabelText(LandInfo[landid][lText], COLOR_GREY, string);
				}
				else
				{
				    format(string, sizeof(string), "This land is for sale by the state\n{00AA00}Price: %s{FFFFFF}\n{FFD700}Level: %i/3\n{FFFFFF}%i/%i Objects", FormatNumber(LandInfo[landid][lPrice]), LandInfo[landid][lLevel], SQL_GetIntByIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
				    UpdateDynamic3DTextLabelText(LandInfo[landid][lText], COLOR_GREY, string);
				}
			}
		}
		case THREAD_LOAD_ATMS: //main
		{
		    for(new i = 0; i < rows && i < MAX_ATMS; i ++)
		    {
		        AtmInfo[i][aID] = SQL_GetInt(i, "id");
		        AtmInfo[i][aPosX] = SQL_GetFloat(i, "pos_x");
		        AtmInfo[i][aPosY] = SQL_GetFloat(i, "pos_y");
			   	AtmInfo[i][aPosZ] = SQL_GetFloat(i, "pos_z");
			   	AtmInfo[i][aPosA] = SQL_GetFloat(i, "pos_r");
			   	AtmInfo[i][amoney] = SQL_GetInt(i, "amoney");
				AtmInfo[i][aExists] = true;
				ReloadAtm(i);
			}
			printf("[Script] %i atms loaded", (rows < MAX_ATMS) ? (rows) : (MAX_ATMS));
		}
		case THREAD_LOAD_LOCKERS:
		{
		    for(new i = 0; i < rows && i < MAX_LOCKERS; i ++)
		    {
		        LockerInfo[i][lID] = SQL_GetInt(i, "id");
		        LockerInfo[i][lFaction] = SQL_GetInt(i, "factionid");
		        LockerInfo[i][lPosX] = SQL_GetFloat(i, "pos_x");
		        LockerInfo[i][lPosY] = SQL_GetFloat(i, "pos_y");
		        LockerInfo[i][lPosZ] = SQL_GetFloat(i, "pos_z");
		        LockerInfo[i][lInterior] = SQL_GetInt(i, "interior");
		        LockerInfo[i][lWorld] = SQL_GetInt(i, "world");
				LockerInfo[i][lIcon] = SQL_GetInt(i, "iconid");
				LockerInfo[i][lLabel] = SQL_GetInt(i, "label");

				LockerInfo[i][locKevlar][0] = SQL_GetInt(i, "weapon_kevlar");
			    LockerInfo[i][locMedKit][0] = SQL_GetInt(i, "weapon_medkit");
			    LockerInfo[i][locNitestick][0] = SQL_GetInt(i, "weapon_nitestick");
			    LockerInfo[i][locMace][0] = SQL_GetInt(i, "weapon_mace");
			    LockerInfo[i][locDeagle][0] = SQL_GetInt(i, "weapon_deagle");
			    LockerInfo[i][locShotgun][0] = SQL_GetInt(i, "weapon_shotgun");
			    LockerInfo[i][locMP5][0] = SQL_GetInt(i, "weapon_mp5");
			    LockerInfo[i][locM4][0] = SQL_GetInt(i, "weapon_m4");
			    LockerInfo[i][locSniper][0] = SQL_GetInt(i, "weapon_sniper");
			    LockerInfo[i][locCamera][0] = SQL_GetInt(i, "weapon_camera");
			    LockerInfo[i][locFireExt][0] = SQL_GetInt(i, "weapon_fire_extinguisher");
			    LockerInfo[i][locPainKillers][0] = SQL_GetInt(i, "weapon_painkillers");

                LockerInfo[i][locKevlar][1] = SQL_GetInt(i, "price_kevlar");
			    LockerInfo[i][locMedKit][1] = SQL_GetInt(i, "price_medkit");
			    LockerInfo[i][locNitestick][1] = SQL_GetInt(i, "price_nitestick");
			    LockerInfo[i][locMace][1] = SQL_GetInt(i, "price_mace");
			    LockerInfo[i][locDeagle][1] = SQL_GetInt(i, "price_deagle");
			    LockerInfo[i][locShotgun][1] = SQL_GetInt(i, "price_shotgun");
			    LockerInfo[i][locMP5][1] = SQL_GetInt(i, "price_mp5");
			    LockerInfo[i][locM4][1] = SQL_GetInt(i, "price_m4");
			    LockerInfo[i][locSniper][1] = SQL_GetInt(i, "price_sniper");
			    LockerInfo[i][locCamera][1] = SQL_GetInt(i, "price_camera");
			    LockerInfo[i][locFireExt][1] = SQL_GetInt(i, "price_fire_extinguisher");
			    LockerInfo[i][locPainKillers][1] = SQL_GetInt(i, "price_painkillers");

		        LockerInfo[i][lText] = Text3D:INVALID_3DTEXT_ID;
		        LockerInfo[i][lPickup] = -1;
		        LockerInfo[i][lExists] = 1;

		        ReloadLocker(i);
		    }
		}
		case THREAD_LOAD_GGARAGE: //pgarge also
		{
		    for(new i = 0; i < rows && i < MAX_GGARAGE; i ++)
		    {
		        GGInfo[i][aID] = SQL_GetInt(i, "id");
		        GGInfo[i][aPosX] = SQL_GetFloat(i, "pos_x");
		        GGInfo[i][aPosY] = SQL_GetFloat(i, "pos_y");
			   	GGInfo[i][aPosZ] = SQL_GetFloat(i, "pos_z");
			   	GGInfo[i][aPosA] = SQL_GetFloat(i, "pos_r");
				GGInfo[i][aExists] = true;
				ReloadGG(i);
			}
     	    printf("[Script] %i Gang Garage loaded", (rows < MAX_GGARAGE) ? (rows) : (MAX_GGARAGE));
     	}
		case THREAD_LOAD_PGARAGE:
		{
		    for(new i = 0; i < rows && i < MAX_PGARAGE; i ++)
		    {
		        PGInfo[i][aID] = SQL_GetInt(i, "id");
		        PGInfo[i][aPosX] = SQL_GetFloat(i, "pos_x");
		        PGInfo[i][aPosY] = SQL_GetFloat(i, "pos_y");
			   	PGInfo[i][aPosZ] = SQL_GetFloat(i, "pos_z");
			   	PGInfo[i][aPosA] = SQL_GetFloat(i, "pos_r");
				PGInfo[i][aExists] = true;
				ReloadPG(i);
			}
			printf("[Script] %i Public Garage loaded", (rows < MAX_PGARAGE) ? (rows) : (MAX_PGARAGE));
		}
		case THREAD_LOAD_HOUSES:
		{
		    for(new i = 0; i < rows && i < MAX_HOUSES; i ++)
		    {
		        SQL_GetString(i, "owner", HouseInfo[i][hOwner], MAX_PLAYER_NAME);

		        HouseInfo[i][hID] = SQL_GetInt(i, "id");
		        HouseInfo[i][hOwnerID] = SQL_GetInt(i, "ownerid");
		        HouseInfo[i][hType] = SQL_GetInt(i, "type");
		        HouseInfo[i][hPrice] = SQL_GetInt(i, "price");
		        HouseInfo[i][hRentPrice] = SQL_GetInt(i, "rentprice");
		        HouseInfo[i][hLevel] = SQL_GetInt(i, "level");
		        HouseInfo[i][hLocked] = SQL_GetInt(i, "locked");
		        HouseInfo[i][hTimestamp] = SQL_GetInt(i, "timestamp");
		        HouseInfo[i][hPosX] = SQL_GetFloat(i, "pos_x");
		        HouseInfo[i][hPosY] = SQL_GetFloat(i, "pos_y");
		        HouseInfo[i][hPosZ] = SQL_GetFloat(i, "pos_z");
		        HouseInfo[i][hPosA] = SQL_GetFloat(i, "pos_a");
                HouseInfo[i][hIntX] = SQL_GetFloat(i, "int_x");
		        HouseInfo[i][hIntY] = SQL_GetFloat(i, "int_y");
		        HouseInfo[i][hIntZ] = SQL_GetFloat(i, "int_z");
		        HouseInfo[i][hIntA] = SQL_GetFloat(i, "int_a");
		        HouseInfo[i][hInterior] = SQL_GetInt(i, "interior");
		        HouseInfo[i][hWorld] = SQL_GetInt(i, "world");
		        HouseInfo[i][hOutsideInt] = SQL_GetInt(i, "outsideint");
		        HouseInfo[i][hOutsideVW] = SQL_GetInt(i, "outsidevw");
		        HouseInfo[i][hCash] = SQL_GetInt(i, "cash");
		        HouseInfo[i][hMaterials] = SQL_GetInt(i, "materials");
                HouseInfo[i][hPot] = SQL_GetInt(i, "pot");
                HouseInfo[i][hCrack] = SQL_GetInt(i, "crack");
                HouseInfo[i][hMeth] = SQL_GetInt(i, "meth");
                HouseInfo[i][hPainkillers] = SQL_GetInt(i, "painkillers");
                HouseInfo[i][hWeapons][0] = SQL_GetInt(i, "weapon_1");
                HouseInfo[i][hWeapons][1] = SQL_GetInt(i, "weapon_2");
                HouseInfo[i][hWeapons][2] = SQL_GetInt(i, "weapon_3");
                HouseInfo[i][hWeapons][3] = SQL_GetInt(i, "weapon_4");
                HouseInfo[i][hWeapons][4] = SQL_GetInt(i, "weapon_5");
                HouseInfo[i][hWeapons][5] = SQL_GetInt(i, "weapon_6");
                HouseInfo[i][hWeapons][6] = SQL_GetInt(i, "weapon_7");
                HouseInfo[i][hWeapons][7] = SQL_GetInt(i, "weapon_8");
                HouseInfo[i][hWeapons][8] = SQL_GetInt(i, "weapon_9");
                HouseInfo[i][hWeapons][9] = SQL_GetInt(i, "weapon_10");
                HouseInfo[i][hHPAmmo] = SQL_GetInt(i, "hpammo");
                HouseInfo[i][hPoisonAmmo] = SQL_GetInt(i, "poisonammo");
                HouseInfo[i][hFMJAmmo] = SQL_GetInt(i, "fmjammo");
                HouseInfo[i][hText] = Text3D:INVALID_3DTEXT_ID;
                HouseInfo[i][hPickup] = -1;
                HouseInfo[i][hLabels] = 0;
                HouseInfo[i][hExists] = 1;
				HouseInfo[i][hRobbed] = SQL_GetInt(i, "robbed");
				HouseInfo[i][hRobbing] = SQL_GetInt(i, "robbing");
                ReloadHouse(i);
		    }

		    printf("[Script] %i houses loaded.", rows);
		}
		case THREAD_LIST_TENANTS:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "There is nobody currently renting at your home.");
			}
			else
			{
			    new username[MAX_PLAYER_NAME], date[24];

				SendClientMessage(extraid, SERVER_COLOR, "List of Tenants");

			    for(new i = 0; i < rows; i ++)
			    {
			        SQL_GetString(i, "username", username);
			        SQL_GetString(i, "lastlogin", date);

			        SM(extraid, COLOR_GREY2, "Name: %s - Last Seen: %s", username, date);
				}
			}
		}
		case THREAD_LOAD_FURNITURE:
		{
		    for(new i = 0; i < rows; i ++)
		    {
		        new objectid = CreateDynamicObject(SQL_GetInt(i, "modelid"), SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"), SQL_GetFloat(i, "rot_x"), SQL_GetFloat(i, "rot_y"), SQL_GetFloat(i, "rot_z"), SQL_GetInt(i, "world"), SQL_GetInt(i, "interior"));

				Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_FURNITURE);
				Streamer_SetExtraInt(objectid, E_OBJECT_INDEX_ID, SQL_GetInt(i, "id"));
				Streamer_SetExtraInt(objectid, E_OBJECT_EXTRA_ID, SQL_GetInt(i, "houseid"));

				if(extraid)
				{
				    new
				        string[48];

				    SQL_GetString(i, "name", string);

					format(string, sizeof(string), "[%i] - %s", objectid, string);
					Streamer_SetExtraInt(objectid, E_OBJECT_3DTEXT_ID, _:CreateDynamic3DTextLabel(string, COLOR_GREY2, SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"), 10.0, .worldid = SQL_GetInt(i, "world"), .interiorid = SQL_GetInt(i, "interior")));
				}
			}
		}
		case THREAD_LOAD_GARAGES:
		{
		    for(new i = 0; i < rows && i < MAX_GARAGES; i ++)
		    {
		        SQL_GetString(i, "owner", GarageInfo[i][gOwner], MAX_PLAYER_NAME);

		        GarageInfo[i][gID] = SQL_GetInt(i, "id");
		        GarageInfo[i][gOwnerID] = SQL_GetInt(i, "ownerid");
		        GarageInfo[i][gType] = SQL_GetInt(i, "type");
		        GarageInfo[i][gPrice] = SQL_GetInt(i, "price");
		        GarageInfo[i][gLocked] = SQL_GetInt(i, "locked");
		        GarageInfo[i][gTimestamp] = SQL_GetInt(i, "timestamp");
		        GarageInfo[i][gPosX] = SQL_GetFloat(i, "pos_x");
		        GarageInfo[i][gPosY] = SQL_GetFloat(i, "pos_y");
		        GarageInfo[i][gPosZ] = SQL_GetFloat(i, "pos_z");
		        GarageInfo[i][gPosA] = SQL_GetFloat(i, "pos_a");
		        GarageInfo[i][gExitX] = SQL_GetFloat(i, "exit_x");
		        GarageInfo[i][gExitY] = SQL_GetFloat(i, "exit_y");
		        GarageInfo[i][gExitZ] = SQL_GetFloat(i, "exit_z");
		        GarageInfo[i][gExitA] = SQL_GetFloat(i, "exit_a");
		        GarageInfo[i][gWorld] = SQL_GetInt(i, "world");
		        GarageInfo[i][gText] = Text3D:INVALID_3DTEXT_ID;
		        GarageInfo[i][gPickup] = -1;
		        GarageInfo[i][gExists] = 1;

				ReloadGarage(i);
		    }

		    printf("[Script] %i garages loaded.", rows);
		}
        case THREAD_LOAD_BUSINESSES:
		{
		    for(new i = 0; i < rows && i < MAX_BUSINESSES; i ++)
		    {
		        SQL_GetString(i, "owner", BusinessInfo[i][bOwner], MAX_PLAYER_NAME);

		        BusinessInfo[i][bID] = SQL_GetInt(i, "id");
		        BusinessInfo[i][bOwnerID] = SQL_GetInt(i, "ownerid");
		        BusinessInfo[i][bType] = SQL_GetInt(i, "type");
		        BusinessInfo[i][bPrice] = SQL_GetInt(i, "price");
		        BusinessInfo[i][bEntryFee] = SQL_GetInt(i, "entryfee");
		        BusinessInfo[i][bLocked] = SQL_GetInt(i, "locked");	
		        BusinessInfo[i][bTimestamp] = SQL_GetInt(i, "timestamp");
		        BusinessInfo[i][bPosX] = SQL_GetFloat(i, "pos_x");
		        BusinessInfo[i][bPosY] = SQL_GetFloat(i, "pos_y");
		        BusinessInfo[i][bPosZ] = SQL_GetFloat(i, "pos_z");
		        BusinessInfo[i][bPosA] = SQL_GetFloat(i, "pos_a");
                BusinessInfo[i][bIntX] = SQL_GetFloat(i, "int_x");
		        BusinessInfo[i][bIntY] = SQL_GetFloat(i, "int_y");
		        BusinessInfo[i][bIntZ] = SQL_GetFloat(i, "int_z");
		        BusinessInfo[i][bIntA] = SQL_GetFloat(i, "int_a");
		        BusinessInfo[i][bInterior] = SQL_GetInt(i, "interior");
		        BusinessInfo[i][bWorld] = SQL_GetInt(i, "world");
		        BusinessInfo[i][bOutsideInt] = SQL_GetInt(i, "outsideint");
		        BusinessInfo[i][bOutsideVW] = SQL_GetInt(i, "outsidevw");
		        BusinessInfo[i][bCash] = SQL_GetInt(i, "cash");
                BusinessInfo[i][bProducts] = SQL_GetInt(i, "products");
                BusinessInfo[i][bText] = Text3D:INVALID_3DTEXT_ID;
                BusinessInfo[i][bPickup] = -1;
                BusinessInfo[i][bMapIcon] = -1;
                BusinessInfo[i][bExists] = 1;
          		SQL_GetString(i, "name", BusinessInfo[i][bName], 64);
                SQL_GetString(i, "message", BusinessInfo[i][bMessage], 128);
				BusinessInfo[i][bRobbed] = SQL_GetInt(i, "robbed");
				BusinessInfo[i][bRobbing] = SQL_GetInt(i, "robbing");

				new str[64];
				for (new j = 0; j < 25; j ++)
				{
					format(str, 32, "prices%d", j);
					BusinessInfo[i][bPrices][j] = SQL_GetInt(i, str);
				}

                ReloadBusiness(i);
		    }

		    printf("[Script] %i businesses loaded.", rows);
		}
		case THREAD_LOAD_ENTRANCES:
		{
		    for(new i = 0; i < rows && i < MAX_ENTRANCES; i ++)
		    {
		        SQL_GetString(i, "owner", EntranceInfo[i][eOwner], MAX_PLAYER_NAME);
		        SQL_GetString(i, "name", EntranceInfo[i][eName], 40);
		        SQL_GetString(i, "password", EntranceInfo[i][ePassword], 64);

				EntranceInfo[i][eID] = SQL_GetInt(i, "id");
				EntranceInfo[i][eOwnerID] = SQL_GetInt(i, "ownerid");
				EntranceInfo[i][eIcon] = SQL_GetInt(i, "iconid");
                EntranceInfo[i][eLocked] = SQL_GetInt(i, "locked");
                EntranceInfo[i][eRadius] = SQL_GetFloat(i, "radius");
                EntranceInfo[i][ePosX] = SQL_GetFloat(i, "pos_x");
                EntranceInfo[i][ePosY] = SQL_GetFloat(i, "pos_y");
                EntranceInfo[i][ePosZ] = SQL_GetFloat(i, "pos_z");
                EntranceInfo[i][ePosA] = SQL_GetFloat(i, "pos_a");
                EntranceInfo[i][eIntX] = SQL_GetFloat(i, "int_x");
                EntranceInfo[i][eIntY] = SQL_GetFloat(i, "int_y");
                EntranceInfo[i][eIntZ] = SQL_GetFloat(i, "int_z");
                EntranceInfo[i][eIntA] = SQL_GetFloat(i, "int_a");
                EntranceInfo[i][eInterior] = SQL_GetInt(i, "interior");
                EntranceInfo[i][eWorld] = SQL_GetInt(i, "world");
                EntranceInfo[i][eOutsideInt] = SQL_GetInt(i, "outsideint");
                EntranceInfo[i][eOutsideVW] = SQL_GetInt(i, "outsidevw");
                EntranceInfo[i][eAdminLevel] = SQL_GetInt(i, "adminlevel");
                EntranceInfo[i][eFactionType] = SQL_GetInt(i, "factiontype");
                EntranceInfo[i][eVIP] = SQL_GetInt(i, "vip");
                EntranceInfo[i][eVehicles] = SQL_GetInt(i, "vehicles");
                EntranceInfo[i][eFreeze] = SQL_GetInt(i, "freeze");
                EntranceInfo[i][eLabel] = SQL_GetInt(i, "label");
                EntranceInfo[i][eMapIcon] = SQL_GetInt(i, "mapicon");
                EntranceInfo[i][eColor] = SQL_GetInt(i, "color");
                EntranceInfo[i][eText] = Text3D:INVALID_3DTEXT_ID;
                EntranceInfo[i][ePickup] = -1;
                EntranceInfo[i][eExists] = 1;
                EntranceInfo[i][eMapIconID] = -1;

                ReloadEntrance(i);
			}

			printf("[Script] %i entrances loaded.", rows);
		}
		case THREAD_LOAD_FACTIONS:
		{
		    for(new i = 0; i < rows && i < MAX_FACTIONS; i ++)
		    {
		        new factionid = SQL_GetInt(i, "id");

		        SQL_GetString(i, "name", FactionInfo[factionid][fName], 48);
		        SQL_GetString(i, "shortname", FactionInfo[factionid][fShortName], 24);
		        SQL_GetString(i, "leader", FactionInfo[factionid][fLeader], MAX_PLAYER_NAME);

		        FactionInfo[factionid][fType] = SQL_GetInt(i, "type");
		        FactionInfo[factionid][fColor] = SQL_GetInt(i, "color");
		        FactionInfo[factionid][fRankCount] = SQL_GetInt(i, "rankcount");
		        FactionInfo[factionid][fLockerX] = SQL_GetFloat(i, "lockerx");
		        FactionInfo[factionid][fLockerY] = SQL_GetFloat(i, "lockery");
		        FactionInfo[factionid][fLockerZ] = SQL_GetFloat(i, "lockerz");
		        FactionInfo[factionid][fLockerInterior] = SQL_GetInt(i, "lockerinterior");
		        FactionInfo[factionid][fLockerWorld] = SQL_GetInt(i, "lockerworld");
		        FactionInfo[factionid][fTurfTokens] = SQL_GetInt(i, "turftokens");
                FactionInfo[factionid][fText] = Text3D:INVALID_3DTEXT_ID;
                FactionInfo[factionid][fPickup] = -1;
				if(FactionInfo[factionid][fType] != FACTION_NONE)
			    {
			    	CallRemoteFunction("createfgstream", "ii", factionid, 1);
			    }
		    }

		    printf("[Script] %i factions loaded.", rows);
		}
		case THREAD_LOAD_FACTIONRANKS:
		{
		    for(new i = 0; i < MAX_FACTIONS; i ++)
	    	{
		        for(new r = 0; r < MAX_FACTION_RANKS; r ++)
		        {
		            strcpy(FactionRanks[i][r], "Unspecified", 32);
		        }
		    }

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "name", FactionRanks[SQL_GetInt(i, "id")][SQL_GetInt(i, "rank")], 32);
      		}
		}
        case THREAD_LOAD_FACTIONSKINS:
		{
		    for(new i = 0; i < rows; i ++)
		    {
				FactionInfo[SQL_GetInt(i, "id")][fSkins][SQL_GetInt(i, "slot")] = SQL_GetInt(i, "skinid");
		    }
		}
		case THREAD_LOAD_FACTIONPAY:
		{
		    for(new i = 0; i < rows; i ++)
		    {
				FactionInfo[SQL_GetInt(i, "id")][fPaycheck][SQL_GetInt(i, "rank")] = SQL_GetInt(i, "amount");
		    }
		}
		case THREAD_LOAD_DIVISIONS:
		{
		    for(new i = 0; i < MAX_FACTIONS; i ++)
	    	{
		        for(new r = 0; r < MAX_FACTION_DIVISIONS; r ++)
		        {
		            FactionDivisions[i][r][0] = 0;
		        }
		    }

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "name", FactionDivisions[SQL_GetInt(i, "id")][SQL_GetInt(i, "divisionid")], 32);
      		}
		}
		case THREAD_LOAD_LANDS:
		{
		    for(new i = 0; i < rows && i < MAX_LANDS; i ++)
		    {
		        SQL_GetString(i, "owner", LandInfo[i][lOwner], MAX_PLAYER_NAME);

		        LandInfo[i][lID] = SQL_GetInt(i, "id");
		        LandInfo[i][lOwnerID] = SQL_GetInt(i, "ownerid");
		        LandInfo[i][lLevel] = SQL_GetInt(i, "level");
		        LandInfo[i][lPrice] = SQL_GetInt(i, "price");
		        LandInfo[i][lMinX] = SQL_GetFloat(i, "min_x");
		        LandInfo[i][lMinY] = SQL_GetFloat(i, "min_y");
		        LandInfo[i][lMaxX] = SQL_GetFloat(i, "max_x");
		        LandInfo[i][lMaxY] = SQL_GetFloat(i, "max_y");
		        LandInfo[i][lHeight] = SQL_GetFloat(i, "height");
		        LandInfo[i][lX] = SQL_GetFloat(i, "lx");
		        LandInfo[i][lY] = SQL_GetFloat(i, "ly");
		        LandInfo[i][lZ] = SQL_GetFloat(i, "lz");
		        LandInfo[i][lGangZone] = -1;
		        LandInfo[i][lArea] = -1;
		        LandInfo[i][lLabels] = 0;
		        LandInfo[i][lExists] = 1;
				LandInfo[i][lPickup] = -1;

		        ReloadLand(i);
			}

			printf("[Script] %i lands loaded.", rows);
		}
		case THREAD_LOAD_LANDOBJECTS:
		{
		    for(new i = 0; i < rows; i ++)
		    {
		        new objectid = CreateDynamicObject(SQL_GetInt(i, "modelid"), SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"), SQL_GetFloat(i, "rot_x"), SQL_GetFloat(i, "rot_y"), SQL_GetFloat(i, "rot_z"));

				Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_LAND);
				Streamer_SetExtraInt(objectid, E_OBJECT_INDEX_ID, SQL_GetInt(i, "id"));
				Streamer_SetExtraInt(objectid, E_OBJECT_EXTRA_ID, SQL_GetInt(i, "landid"));
				Streamer_SetExtraFloat(objectid, E_OBJECT_X, SQL_GetFloat(i, "pos_x"));
                Streamer_SetExtraFloat(objectid, E_OBJECT_Y, SQL_GetFloat(i, "pos_y"));
                Streamer_SetExtraFloat(objectid, E_OBJECT_Z, SQL_GetFloat(i, "pos_z"));

				if(extraid)
				{
				    new
				        landstring[48];

				    SQL_GetString(i, "name", landstring);

					format(landstring, sizeof(landstring), "[%i] - %s", objectid, landstring);
					Streamer_SetExtraInt(objectid, E_OBJECT_3DTEXT_ID, _:CreateDynamic3DTextLabel(landstring, COLOR_GREY2, SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"), 10.0));
				}
			}
		}
		case THREAD_LOAD_GANGS:
		{
		    for(new i = 0; i < rows && i < MAX_GANGS; i ++)
		    {
		        new gangid = SQL_GetInt(i, "id");

		        SQL_GetString(i, "name", GangInfo[gangid][gName], 32);
		        SQL_GetString(i, "motd", GangInfo[gangid][gMOTD], 128);
		        SQL_GetString(i, "leader", GangInfo[gangid][gLeader], MAX_PLAYER_NAME);
		        SQL_GetString(i, "theme", GangInfo[gangid][gTheme], 32);

		        GangInfo[gangid][gColor] = SQL_GetInt(i, "color");
		        GangInfo[gangid][gStrikes] = SQL_GetInt(i, "strikes");
		        GangInfo[gangid][gLevel] = SQL_GetInt(i, "level");
		        GangInfo[gangid][gPoints] = SQL_GetInt(i, "points");
		        GangInfo[gangid][gTurfTokens] = SQL_GetInt(i, "turftokens");
		        GangInfo[gangid][gStashX] = SQL_GetFloat(i, "stash_x");
		        GangInfo[gangid][gStashY] = SQL_GetFloat(i, "stash_y");
		        GangInfo[gangid][gStashZ] = SQL_GetFloat(i, "stash_z");
		        GangInfo[gangid][gStashInterior] = SQL_GetInt(i, "stashinterior");
		        GangInfo[gangid][gStashWorld] = SQL_GetInt(i, "stashworld");
		        GangInfo[gangid][gCash] = SQL_GetInt(i, "cash");
		        GangInfo[gangid][gMaterials] = SQL_GetInt(i, "materials");
		        GangInfo[gangid][gPot] = SQL_GetInt(i, "pot");
		        GangInfo[gangid][gCrack] = SQL_GetInt(i, "crack");
		        GangInfo[gangid][gMeth] = SQL_GetInt(i, "meth");
		        GangInfo[gangid][gPainkillers] = SQL_GetInt(i, "painkillers");
				GangInfo[gangid][gHPAmmo] = SQL_GetInt(i, "hpammo");
				GangInfo[gangid][gPoisonAmmo] = SQL_GetInt(i, "poisonammo");
				GangInfo[gangid][gFMJAmmo] = SQL_GetInt(i, "fmjammo");
				GangInfo[gangid][gAlliance] = SQL_GetInt(i, "alliance");

				// Gang stash weapons
		        GangInfo[gangid][gWeapons][GANGWEAPON_9MM] = SQL_GetInt(i, "weapon_9mm");
		        GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL] = SQL_GetInt(i, "weapon_sdpistol");
		        GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] = SQL_GetInt(i, "weapon_deagle");
		        GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] = SQL_GetInt(i, "weapon_shotgun");
		        GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12] = SQL_GetInt(i, "weapon_spas12");
		        GangInfo[gangid][gWeapons][GANGWEAPON_SAWNOFF] = SQL_GetInt(i, "weapon_sawnoff");
		        GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] = SQL_GetInt(i, "weapon_tec9");
		        GangInfo[gangid][gWeapons][GANGWEAPON_UZI] = SQL_GetInt(i, "weapon_uzi");
		        GangInfo[gangid][gWeapons][GANGWEAPON_MP5] = SQL_GetInt(i, "weapon_mp5");
		        GangInfo[gangid][gWeapons][GANGWEAPON_AK47] = SQL_GetInt(i, "weapon_ak47");
		        GangInfo[gangid][gWeapons][GANGWEAPON_M4] = SQL_GetInt(i, "weapon_m4");
		        GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] = SQL_GetInt(i, "weapon_rifle");
		        GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER] = SQL_GetInt(i, "weapon_sniper");
		        GangInfo[gangid][gWeapons][GANGWEAPON_MOLOTOV] = SQL_GetInt(i, "weapon_molotov");

				// Gang arms & drug dealer
		        GangInfo[gangid][gArmsDealer] = SQL_GetInt(i, "armsdealer");
		        GangInfo[gangid][gDrugDealer] = SQL_GetInt(i, "drugdealer");
		        GangInfo[gangid][gArmsX] = SQL_GetFloat(i, "arms_x");
		        GangInfo[gangid][gArmsY] = SQL_GetFloat(i, "arms_y");
		        GangInfo[gangid][gArmsZ] = SQL_GetFloat(i, "arms_z");
		        GangInfo[gangid][gArmsA] = SQL_GetFloat(i, "arms_a");
		        GangInfo[gangid][gDrugX] = SQL_GetFloat(i, "drug_x");
		        GangInfo[gangid][gDrugY] = SQL_GetFloat(i, "drug_y");
		        GangInfo[gangid][gDrugZ] = SQL_GetFloat(i, "drug_z");
		        GangInfo[gangid][gDrugA] = SQL_GetFloat(i, "drug_a");
		        GangInfo[gangid][gArmsWorld] = SQL_GetInt(i, "armsworld");
		        GangInfo[gangid][gDrugWorld] = SQL_GetInt(i, "drugworld");
                GangInfo[gangid][gDrugPot] = SQL_GetInt(i, "drugpot");
                GangInfo[gangid][gDrugCrack] = SQL_GetInt(i, "drugcrack");
                GangInfo[gangid][gDrugMeth] = SQL_GetInt(i, "drugmeth");
                GangInfo[gangid][gArmsMaterials] = SQL_GetInt(i, "armsmaterials");
                GangInfo[gangid][gArmsPrices][0] = SQL_GetInt(i, "armsprice_1");
                GangInfo[gangid][gArmsPrices][1] = SQL_GetInt(i, "armsprice_2");
                GangInfo[gangid][gArmsPrices][2] = SQL_GetInt(i, "armsprice_3");
                GangInfo[gangid][gArmsPrices][3] = SQL_GetInt(i, "armsprice_4");
                GangInfo[gangid][gArmsPrices][4] = SQL_GetInt(i, "armsprice_5");
                GangInfo[gangid][gArmsPrices][5] = SQL_GetInt(i, "armsprice_6");
                GangInfo[gangid][gArmsPrices][6] = SQL_GetInt(i, "armsprice_7");
                GangInfo[gangid][gArmsPrices][7] = SQL_GetInt(i, "armsprice_8");
                GangInfo[gangid][gArmsPrices][8] = SQL_GetInt(i, "armsprice_9");
                GangInfo[gangid][gArmsPrices][9] = SQL_GetInt(i, "armsprice_10");
                GangInfo[gangid][gArmsPrices][10] = SQL_GetInt(i, "armsprice_11");
                GangInfo[gangid][gArmsPrices][11] = SQL_GetInt(i, "armsprice_12");
                GangInfo[gangid][gDrugPrices][0] = SQL_GetInt(i, "pot_price");
                GangInfo[gangid][gDrugPrices][1] = SQL_GetInt(i, "crack_price");
                GangInfo[gangid][gDrugPrices][2] = SQL_GetInt(i, "meth_price");
                GangInfo[gangid][gArmsHPAmmo] = SQL_GetInt(i, "armshpammo");
                GangInfo[gangid][gArmsPoisonAmmo] = SQL_GetInt(i, "armspoisonammo");
                GangInfo[gangid][gArmsFMJAmmo] = SQL_GetInt(i, "armsfmjammo");

		        GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
		        GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
		        GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;
		        GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
    			GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
		        GangInfo[gangid][gPickup] = -1;
		        GangInfo[gangid][gSetup] = 1;
				
				CallRemoteFunction("createfgstream", "ii", gangid, 0);

				ReloadGang(gangid);
			}

			printf("[Script] %i gangs loaded.", rows);
		}
		case THREAD_LOAD_GANGRANKS:
		{
		    for(new i = 0; i < MAX_GANGS; i ++)
	    	{
		        for(new r = 0; r < 7; r ++)
		        {
		            strcpy(GangRanks[i][r], "Unspecified", 32);
		        }
		    }

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "name", GangRanks[SQL_GetInt(i, "id")][SQL_GetInt(i, "rank")], 32);
      		}
		}
        case THREAD_LOAD_GANGSKINS:
		{
		    for(new i = 0; i < rows; i ++)
		    {
				GangInfo[SQL_GetInt(i, "id")][gSkins][SQL_GetInt(i, "slot")] = SQL_GetInt(i, "skinid");
		    }
		}
		case THREAD_LOAD_POINTS:
		{
		    for(new i = 0; i < rows && i < MAX_POINTS; i ++)
		    {
		        new pointid = SQL_GetInt(i, "id");

		        SQL_GetString(i, "name", PointInfo[pointid][pName], 32);
		        SQL_GetString(i, "capturedby", PointInfo[pointid][pCapturedBy], MAX_PLAYER_NAME);

		        PointInfo[pointid][pCapturedGang] = SQL_GetInt(i, "capturedgang");
		        PointInfo[pointid][pType] = SQL_GetInt(i, "type");
		        PointInfo[pointid][pProfits] = SQL_GetInt(i, "profits");
		        PointInfo[pointid][pTime] = SQL_GetInt(i, "time");
		        PointInfo[pointid][pPointX] = SQL_GetFloat(i, "point_x");
		        PointInfo[pointid][pPointY] = SQL_GetFloat(i, "point_y");
		        PointInfo[pointid][pPointZ] = SQL_GetFloat(i, "point_z");
		        PointInfo[pointid][pMinX] = SQL_GetFloat(i, "min_x");
		        PointInfo[pointid][pMinY] = SQL_GetFloat(i, "min_y");
		        PointInfo[pointid][pMaxX] = SQL_GetFloat(i, "max_x");
		        PointInfo[pointid][pMaxY] = SQL_GetFloat(i, "max_y");
		        PointInfo[pointid][pHeight] = SQL_GetFloat(i, "height");
		        PointInfo[pointid][pPointInterior] = SQL_GetInt(i, "pointinterior");
		        PointInfo[pointid][pPointWorld] = SQL_GetInt(i, "pointworld");
		        PointInfo[pointid][pCaptureTime] = 0;
 	            PointInfo[pointid][pGangZone] = -1;
		        PointInfo[pointid][pArea] = -1;
		        PointInfo[pointid][pCapturer] = INVALID_PLAYER_ID;
		        PointInfo[pointid][pText] = Text3D:INVALID_3DTEXT_ID;
		        PointInfo[pointid][pPickup] = -1;
		        PointInfo[pointid][pExists] = 1;

				if(PointInfo[pointid][pCapturedGang] >= 0 && !GangInfo[PointInfo[pointid][pCapturedGang]][gSetup])
				{
				    PointInfo[pointid][pCapturedGang] = -1;

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedgang = -1 WHERE id = %i", pointid);
				    mysql_tquery(connectionID, queryBuffer);
				}

				ReloadPoint(pointid);
		    }

		    printf("[Script] %i points loaded.", rows);
		}
        case THREAD_LOAD_TURFS:
		{
		    for(new i = 0; i < rows && i < MAX_TURFS; i ++)
		    {
		        new turfid = SQL_GetInt(i, "id");

		        SQL_GetString(i, "name", TurfInfo[turfid][tName], 32);
		        SQL_GetString(i, "capturedby", TurfInfo[turfid][tCapturedBy], MAX_PLAYER_NAME);

		        TurfInfo[turfid][tCapturedGang] = SQL_GetInt(i, "capturedgang");
		        TurfInfo[turfid][tType] = SQL_GetInt(i, "type");
		        TurfInfo[turfid][tTime] = SQL_GetInt(i, "time");
		        TurfInfo[turfid][tMinX] = SQL_GetFloat(i, "min_x");
		        TurfInfo[turfid][tMinY] = SQL_GetFloat(i, "min_y");
		        TurfInfo[turfid][tMaxX] = SQL_GetFloat(i, "max_x");
		        TurfInfo[turfid][tMaxY] = SQL_GetFloat(i, "max_y");
		        TurfInfo[turfid][tHeight] = SQL_GetFloat(i, "height");
		        TurfInfo[turfid][tGangZone] = -1;
		        TurfInfo[turfid][tArea] = -1;
		        TurfInfo[turfid][tCaptureTime] = 0;
				TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
		        TurfInfo[turfid][tExists] = 1;
		        TurfInfo[turfid][tInfluenceTime]  = 0;
				TurfInfo[turfid][tInfluenceGang]  = -1;
				TurfInfo[turfid][tInfluence]  = 0;

		        ReloadTurf(turfid);
			}

			printf("[Script] %i turfs loaded.", rows);
		}
		case THREAD_LOAD_CLOTHING:
		{
		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "name", ClothingInfo[extraid][i][cName], 32);

		        ClothingInfo[extraid][i][cID] = SQL_GetInt(i, "id");
		        ClothingInfo[extraid][i][cModel] = SQL_GetInt(i, "modelid");
		        ClothingInfo[extraid][i][cBone] = SQL_GetInt(i, "boneid");
		        ClothingInfo[extraid][i][cAttached] = SQL_GetInt(i, "attached");
		        ClothingInfo[extraid][i][cPosX] = SQL_GetFloat(i, "pos_x");
		        ClothingInfo[extraid][i][cPosY] = SQL_GetFloat(i, "pos_y");
		        ClothingInfo[extraid][i][cPosZ] = SQL_GetFloat(i, "pos_z");
		        ClothingInfo[extraid][i][cRotX] = SQL_GetFloat(i, "rot_x");
		        ClothingInfo[extraid][i][cRotY] = SQL_GetFloat(i, "rot_y");
		        ClothingInfo[extraid][i][cRotZ] = SQL_GetFloat(i, "rot_z");
		        ClothingInfo[extraid][i][cScaleX] = SQL_GetFloat(i, "scale_x");
		        ClothingInfo[extraid][i][cScaleY] = SQL_GetFloat(i, "scale_y");
		        ClothingInfo[extraid][i][cScaleZ] = SQL_GetFloat(i, "scale_z");
		        ClothingInfo[extraid][i][cExists] = 1;
		        ClothingInfo[extraid][i][cAttachedIndex] = -1;
		    }

		    PlayerInfo[extraid][pAwaitingClothing] = 1;
		}
		case THREAD_HOUSE_INFORMATION:
		{
			new type[16], houseid = GetNearbyHouseEx(extraid);

		    if(HouseInfo[houseid][hType] == -1)
			{
				type = "Other";
			}
			else
			{
				strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
			}

			SM(extraid, SERVER_COLOR, "House ID %i", houseid);
			SM(extraid, COLOR_GREY2, "(Value: $%i) - (Rent Price: $%i) - (Level: %i/5) - (Active: %s) - (Locked: %s)", HouseInfo[houseid][hPrice], HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hLevel], (gettime() - HouseInfo[houseid][hTimestamp] > 1209600) ? ("{FFA500}No{C8C8C8}") : ("Yes"), (HouseInfo[houseid][hLocked]) ? ("Yes") : ("No"));
			SM(extraid, COLOR_GREY2, "(Class: %s) - (Location: %s) - (Furniture: %i/%i) - (Tenants: %i/%i)", type, GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]), SQL_GetIntByIndex(0, 0), GetHouseFurnitureCapacity(houseid), SQL_GetIntByIndex(0, 1), GetHouseTenantCapacity(houseid));
		}
		case THREAD_COUNT_FURNITURE:
		{
		    new houseid = GetInsideHouse(extraid);

		    if(SQL_GetIntByIndex(0, 0) >= GetHouseFurnitureCapacity(houseid))
		    {
		        SM(extraid, COLOR_SYNTAX, "Your house is only allowed up to %i furniture at its current level.", GetHouseFurnitureCapacity(houseid));
		    }
		    else
		    {
				ShowDialogToPlayer(extraid, DIALOG_BUYFURNITURE1);
			}
		}
		case THREAD_SELL_FURNITURE:
		{
		    if(SQL_GetRows())
		    {
		        new name[32], price = percent(SQL_GetInt(0, "price"), 75);

		        SQL_GetString(0, "name", name);
		        GivePlayerCash(extraid, price);

		        SM(extraid, COLOR_GREEN, "You have sold "SVRCLR"%s{CCFFFF} and received a 75 percent refund of $%i.", name, price);
		        RemoveFurniture(PlayerInfo[extraid][pSelected]);
			}
		}
		case THREAD_CLEAR_FURNITURE:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "Your home contains no furniture which can be sold.");
		    }
		    else
		    {
		        new price, houseid = GetInsideHouse(extraid);

			    for(new i = 0; i < rows; i ++)
				{
				    price += percent(SQL_GetInt(i, "price"), 75);
				}

				RemoveAllFurniture(houseid);

				GivePlayerCash(extraid, price);
				SM(extraid, COLOR_GREEN, "You have sold a total of %i items and received $%i back.", rows, price);
			}
		}
		case THREAD_COUNT_TEXTS:
		{
		    rows = SQL_GetIntByIndex(0, 0);

		    if(rows)
		    {
		        //SM(extraid, COLOR_YELLOW, "** You have %i unread text messages. (/texts)", rows);
			}
		}
		case THREAD_COUNT_VOTERS:
		{
		    rows = SQL_GetIntByIndex(0, 0);

		    if(rows)
		    {
		        SM(extraid, COLOR_YELLOW, "** %i Players Voted", rows);
			}
		}
		case THREAD_VIEW_TEXTS:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "You have no more unread text messages to read.");
			}
			else
			{
		    	static listString[4096], sender[MAX_PLAYER_NAME], date[24], message[128];

				listString = "Texts sent to you while offline (recent first):\n";

			    for(new i = 0; i < min(rows, 25); i ++)
			    {
			        SQL_GetString(i, "sender", sender);
		    	    SQL_GetString(i, "date", date);
		        	SQL_GetString(i, "message", message);

			        format(listString, sizeof(listString), "%s\n[%s] SMS from %s (%i): %s", listString, date, sender, SQL_GetInt(i, "sender_number"), message);
				}

				if(rows > 25)
				{
				    ShowPlayerDialog(extraid, DIALOG_UNREADTEXTS, DIALOG_STYLE_MSGBOX, "Unread Texts", listString, "Next", "OK");
				}
				else
				{
				    ShowPlayerDialog(extraid, DIALOG_UNREADTEXTS, DIALOG_STYLE_MSGBOX, "Unread Texts", listString, "OK", "");
				}
			}
		}
		case THREAD_LIST_VEHICLES:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "You own no vehicles which you can spawn.");
		    }
		    else
		    {
		        new string[1024];

		        string = "#\tModel\tLocation";

		        for(new i = 0; i < rows; i ++)
		        {
		            format(string, sizeof(string), "%s\n%i\t%s\t%s", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "world")) ? ("Garage") : (GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"))));
				}

				ShowPlayerDialog(extraid, DIALOG_SPAWNCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to spawn.", string, "Select", "Cancel");
		    }
		}
        case THREAD_CAR_GSTORAGE:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "Your Gang own no vehicles which you can spawn");
		    }
		    else
		    {
		        new string[2084], vehicleid;

		        string = "#\tModel\tStatus\tLocation";

		        for(new i = 0; i < rows; i ++)
		        {
		            if((vehicleid = GetVehicleLinkedID(SQL_GetInt(i, "id"))) != INVALID_VEHICLE_ID)
		                format(string, sizeof(string), "%s\n%i\t%s\t"GREEN"Spawned"WHITE"\t%s", string, i + 1, vehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleZoneName(vehicleid));
					else
						format(string, sizeof(string), "%s\n%i\t%s\t"RED"Despawned"WHITE"\t%s", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "world")) ? ("Garage") : (GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"))));
				}
				ShowPlayerDialog(extraid, DIALOG_GCARSTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");
		    }
		}
        case THREAD_VOTE_LOAD:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "There is no Partys");
		    }
		    else
		    {
		        new string[2084];

		        string = "Party\tLeader";
		        

		        for(new i = 0; i < rows; i ++)
		        {
	                new party = SQL_GetInt(i, "id");
	                new color = FactionInfo[party][fColor];
		            if(party != -1)
		                format(string, sizeof(string), "%s\n{%06x}%s\t%s", string, color >>> 8, FactionInfo[party][fName], FactionInfo[party][fLeader]);
                    }
				ShowPlayerDialog(extraid, DIALOG_VOTE, DIALOG_STYLE_TABLIST_HEADERS, "Choose a Party to Vote.", string, "Select", "Cancel");
		    }
		}
        case THREAD_VOTE_LOAD1:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "There is no Partys");
		    }
		    else
		    {
		        new string[2084];

		        string = "Party\tVotes";


		        for(new i = 0; i < rows; i ++)
		        {
	                new party = SQL_GetInt(i, "id");
	                new color = FactionInfo[party][fColor];
		            if(party != -1)
		                format(string, sizeof(string), "%s\n{%06x}%s\t%i", string, color >>> 8, FactionInfo[party][fName], FactionInfo[party][fVote]);
									}
				ShowPlayerDialog(extraid, DIALOG_VOTE1, DIALOG_STYLE_TABLIST_HEADERS, "ADMIN VOTE LIST SELECT PARTY TO CHECK VOTE", string, "Select", "Cancel");
		    }
		}
		case THREAD_CAR_STORAGE:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "You own no vehicles which you can spawn.");
		    }
		    else
		    {
		        new string[1024], vehicleid;

		        string = "#\tModel\tStatus\tLocation";

		        for(new i = 0; i < rows; i ++)
		        {
		            if((vehicleid = GetVehicleLinkedID(SQL_GetInt(i, "id"))) != INVALID_VEHICLE_ID)
		                format(string, sizeof(string), "%s\n%i\t%s\t"GREEN"Spawned"WHITE"\t%s", string, i + 1, vehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleZoneName(vehicleid));
					else if(SQL_GetInt(i, "impounded"))
						format(string, sizeof(string), "%s\n%i\t%s\t{FF0000}Impounded{FFFFFF}\tDMV", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400]);
					else if(SQL_GetInt(i, "broken"))
						format(string, sizeof(string), "%s\n%i\t%s\t"LIGHTRED"Broken{FFFFFF}\tGarage", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400]);
					else
						format(string, sizeof(string), "%s\n%i\t%s\t"RED"Despawned"WHITE"\t%s", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "world")) ? ("Garage") : (GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"))));
				}

				ShowPlayerDialog(extraid, DIALOG_CARSTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");
		    }
         }
		case THREAD_LIST_PGVEHICLES_VALLEY:
        {
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "You own no vehicles which you can spawn.");
		    }
		    else
		    {
		        new string[1024], vehicleid;

		        string = "#\tModel\tStatus\tLocation";

		        for(new i = 0; i < rows; i ++)
		        {
		            if((vehicleid = GetVehicleLinkedID(SQL_GetInt(i, "id"))) != INVALID_VEHICLE_ID)
		                format(string, sizeof(string), "%s\n%i\t%s\t"GREEN"Spawned"WHITE"\t%s", string, i + 1, vehicleNames[GetVehicleModel(vehicleid) - 400], GetVehicleZoneName(vehicleid));
		            else if(SQL_GetInt(i, "impounded"))
						format(string, sizeof(string), "%s\n%i\t%s\t{FF0000}Impounded{FFFFFF}\tDMV", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400]);
					else
						format(string, sizeof(string), "%s\n%i\t%s\t"RED"Despawned"WHITE"\t%s", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], (SQL_GetInt(i, "world")) ? ("Garage") : (GetZoneName(SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z"))));
				}

				ShowPlayerDialog(extraid, DIALOG_VALLEY, DIALOG_STYLE_TABLIST_HEADERS, "[VALLEY]", string, "Select", "Cancel");
		    }
		}
		case THREAD_DMVRELEASE:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "[ERROR]{ffffff} You do not have any impounded vehicles.");
		    }
		    else
		    {
		        new string[1024];

		        string = "#\tModel\tTickets";

		        for(new i = 0; i < rows; i ++)
					format(string, sizeof(string), "%s\n%i\t%s\t{ff0000}%s{ffffff}", string, i + 1, vehicleNames[SQL_GetInt(i, "modelid") - 400], FormatNumber(SQL_GetInt(i, "tickets")));

				ShowPlayerDialog(extraid, DIALOG_DMVRELEASE, DIALOG_STYLE_TABLIST_HEADERS, "Impound Department", string, "Release", "Cancel");
		    }
		}
		case THREAD_FACTION_ROSTER:
		{
		    new username[MAX_PLAYER_NAME], date[24];

		    SendClientMessage(extraid, SERVER_COLOR, "Faction Roster:");

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "username", username);
		        SQL_GetString(i, "lastlogin", date);

		        SM(extraid, COLOR_GREY2, "%s %s - Last Seen: %s", FactionRanks[PlayerInfo[extraid][pFaction]][SQL_GetInt(i, "factionrank")], username, date);
		    }
		}
		case THREAD_GANG_ROSTER:
		{
		    new username[MAX_PLAYER_NAME], date[24];

		    SendClientMessage(extraid, SERVER_COLOR, "Gang Roster:");

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetString(i, "username", username);
		        SQL_GetString(i, "lastlogin", date);

		        SM(extraid, COLOR_GREY2, "[%i] %s %s - Last Seen: %s", SQL_GetInt(i, "gangrank"), GangRanks[PlayerInfo[extraid][pGang]][SQL_GetInt(i, "gangrank")], username, date);
		    }
		}
		case THREAD_VIEW_PHONEBOOK:
		{
		    if((!rows) && PlayerInfo[extraid][pPage] == 1)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "The phonebook directory is currently empty.");
		    }
		    else
		    {
		        static string[MAX_LISTED_NUMBERS * 32], name[MAX_PLAYER_NAME];

		        string = "#\tName\tNumber";

		        for(new i = 0; i < rows; i ++)
		        {
		            SQL_GetString(i, "name", name);
		            format(string, sizeof(string), "%s\n%i\t%s\t%i", string, ((PlayerInfo[extraid][pPage] - 1) * MAX_LISTED_NUMBERS) + (i + 1), name, SQL_GetInt(i, "number"));
				}

				if(PlayerInfo[extraid][pPage] > 1)
				{
				    strcat(string, "\n"SVRCLR"<< Go back"WHITE"");
				}
    			if(rows == MAX_LISTED_NUMBERS)
    			{
    			    strcat(string, "\n"SVRCLR">> Next page"WHITE"");
				}

				ShowPlayerDialog(extraid, DIALOG_PHONEBOOK, DIALOG_STYLE_TABLIST_HEADERS, "Phonebook directory", string, "Select", "Close");
		    }
		}
		case THREAD_COUNT_LANDOBJECTS:
		{
			new landid = GetNearbyLand(extraid);
		    if(SQL_GetIntByIndex(0, 0) >= GetLandObjectCapacity(LandInfo[landid][lLevel]))
		    {
		        SM(extraid, COLOR_GREY, "You are only only allowed up to %i objects for your land.", GetLandObjectCapacity(LandInfo[landid][lLevel]));
		    }
		    else
		    {
		        ShowDialogToPlayer(extraid, DIALOG_LANDBUILDTYPE);
				//ShowDialogToPlayer(extraid, DIALOG_LANDBUILD1);
			}
		}
		case THREAD_SELL_LANDOBJECT:
		{
		    if(SQL_GetRows())
		    {
		        new name[32], price = percent(SQL_GetInt(0, "price"), 75);

		        SQL_GetString(0, "name", name);
		        GivePlayerCash(extraid, price);

		        SM(extraid, COLOR_GREEN, "You have sold "SVRCLR"%s{CCFFFF} and received a 75 percent refund of $%i.", name, price);
		        RemoveLandObject(PlayerInfo[extraid][pSelected]);
			}
		}
		case THREAD_DUPLICATE_LANDOBJECT:
		{
			//name, modelid, price, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z

  			if(SQL_GetRows())
			{
			    new string[20], name[32], landid = GetNearbyLand(extraid);

			    new modelid = SQL_GetInt(0, "modelid");
			    new price = SQL_GetInt(0, "price");
			    new Float:x = SQL_GetFloat(0, "pos_x");
			    new Float:y = SQL_GetFloat(0, "pos_y");
			    new Float:z = SQL_GetFloat(0, "pos_z");
			    new Float:rx = SQL_GetFloat(0, "rot_x");
			    new Float:ry = SQL_GetFloat(0, "rot_y");
			    new Float:rz = SQL_GetFloat(0, "rot_z");

			    if(PlayerInfo[extraid][pCash] < price)
			    {
			        SendClientMessage(extraid, COLOR_SYNTAX, "You can't afford to duplicate this object.");
			    }
			    else
			    {
			    	if(SQL_GetIntByIndex(0, 0) >= GetLandObjectCapacity(LandInfo[PlayerInfo[extraid][pObjectLand]][lLevel]))
					{
		 				SM(extraid, COLOR_GREY, "You are only allowed up to %i objects for your land.", GetLandObjectCapacity(LandInfo[PlayerInfo[extraid][pObjectLand]][lLevel]));
		   			}
			        PlayerInfo[extraid][pObjectLand] = landid;
				    SQL_GetString(0, "name", name);

			    	GivePlayerCash(extraid, -price);
			    	SM(extraid, COLOR_YELLOW, "%s duplicated for $%i. You will now edit this object.", name, price);

				    format(string, sizeof(string), "~r~-$%i", price);
				    GameTextForPlayer(extraid, string, 5000, 1);

				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO landobjects VALUES(null, %i, %i, '%e', %i, '%f', '%f', '%f', '%f', '%f', '%f', 0, 0, '%f', '%f', '%f', '-1000.0', '-1000.0', '-1000.0')", LandInfo[landid][lID], modelid, name, price, x, y, z, rx, ry, rz, x, y, z - 10.0);
					mysql_tquery(connectionID, queryBuffer);

					mysql_tquery(connectionID, "SELECT * FROM landobjects WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, LandInfo[landid][lLabels]);
					mysql_tquery(connectionID, "SELECT LAST_INSERT_ID() FROM landobjects LIMIT 1", "OnQueryFinished", "ii", THREAD_DUPLICATED_OBJECT, extraid);
				}
			}
		}
		case THREAD_DUPLICATED_OBJECT:
		{
			if(SQL_GetRows())
			{
			    new id = SQL_GetIntByIndex(0, 0);

			    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
			    {
			        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID) == id)
			        {
			            PlayerInfo[extraid][pEditType] = EDIT_LAND_OBJECT;
		    	    	PlayerInfo[extraid][pEditObject] = i;

						EditDynamicObject(extraid, i);
	    		    	GameTextForPlayer(extraid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);

			            //PlayerInfo[extraid][pSelected] = i;
						//ShowDialogToPlayer(extraid, DIALOG_LANDOBJECTMENU);
			            break;
					}
			    }
		    }
		}
		case THREAD_CLEAR_LANDOBJECTS:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "Your land contains no furniture which can be sold.");
		    }
		    else
		    {
		        new price, landid = GetNearbyLand(extraid);

			    for(new i = 0; i < rows; i ++)
				{
				    price += percent(SQL_GetInt(i, "price"), 75);
				}

				RemoveAllLandObjects(landid);

				GivePlayerCash(extraid, price);
				SM(extraid, COLOR_GREEN, "You have sold a total of %i items and received $%i back.", rows, price);
			}
		}
		case THREAD_LIST_LANDOBJECTS:
		{
		    if((!rows) && PlayerInfo[extraid][pPage] == 1)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "Your land contains no objects which can be listed.");
		    }
		    else
		    {
		        static string[MAX_LISTED_OBJECTS * 48], name[32];

		        string = "#\tName\tCost\tDistance";

		        for(new i = 0; i < rows; i ++)
		        {
		            SQL_GetString(i, "name", name);
		            format(string, sizeof(string), "%s\n%i\t%s\t"SVRCLR"$%i"WHITE"\t%.1fm", string, GetLandObjectID(SQL_GetInt(i, "id")), name, SQL_GetInt(i, "price"), GetPlayerDistanceFromPoint(extraid, SQL_GetFloat(i, "pos_x"), SQL_GetFloat(i, "pos_y"), SQL_GetFloat(i, "pos_z")));
				}

				if(PlayerInfo[extraid][pPage] > 1)
				{
				    strcat(string, "\n"SVRCLR"<< Go back"WHITE"");
				}
    			if(rows == MAX_LISTED_OBJECTS)
    			{
    			    strcat(string, "\n"SVRCLR">> Next page"WHITE"");
				}

				ShowPlayerDialog(extraid, DIALOG_LANDOBJECTS, DIALOG_STYLE_TABLIST_HEADERS, "List of objects", string, "Select", "Back");
		    }
		}
		case THREAD_LAND_MAINMENU:
		{
			new
		        landid = GetNearbyLand(extraid),
		        string[64];

			format(string, sizeof(string), "Land Menu {FFD700}(Level: %i/3) (%i/%i objects)", LandInfo[landid][lLevel], SQL_GetIntByIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
		    ShowPlayerDialog(extraid, DIALOG_LANDMENU, DIALOG_STYLE_LIST, string, "Build object\nEdit object\nToggle labels\nSell all objects\nPermissions\nUpgrade Land", "Select", "Cancel");
		}
		case THREAD_LAND_INFORMATION:
		{
		    new landid = GetNearbyLand(extraid);

		    SendClientMessage(extraid, SERVER_COLOR, "Land Info:");
			SM(extraid, COLOR_WHITE, "** Your level %i/3 land in %s is worth {00AA00}%s{FFFFFF} and contains %i/%i objects.", LandInfo[landid][lLevel], GetZoneName(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lHeight]), FormatNumber(LandInfo[landid][lPrice]), SQL_GetIntByIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
		}
		case THREAD_LOAD_WEAPON:
		{
			for(new i = 0; i < rows && i < MAX_WEAPONS; i ++)
			{
				new index = SQL_GetInt(i, "uid");
				WeaponInfo[index][wId] = SQL_GetInt(i, "uid");
				WeaponInfo[index][wWeaponId] = SQL_GetInt(i, "weaponid");
				WeaponInfo[index][wAmmo] = SQL_GetInt(i, "ammo");
				WeaponInfo[index][wSlot] = SQL_GetInt(i, "slot");
				WeaponInfo[index][wOwnerID] = SQL_GetInt(i, "ownerid");
				SQL_GetString(i, "ownername", WeaponInfo[index][wOwner], MAX_PLAYER_NAME);

			}

		}
		case THREAD_LOAD_VEHICLES:
		{
		    new modelid, Float:pos_x, Float:pos_y, Float:pos_z, Float:pos_a, color1, color2, respawndelay, vehicleid;

		    for(new i = 0; i < rows; i ++)
		    {
	            modelid 		= SQL_GetInt(i, "modelid"),
				pos_x 			= SQL_GetFloat(i, "pos_x"),
				pos_y 			= SQL_GetFloat(i, "pos_y"),
				pos_z 			= SQL_GetFloat(i, "pos_z"),
				pos_a 			= SQL_GetFloat(i, "pos_a"),
				color1 			= SQL_GetInt(i, "color1"),
				color2 			= SQL_GetInt(i, "color2"),
				respawndelay 	= SQL_GetInt(i, "respawndelay");
		        vehicleid 		= CreateVehicle(modelid, pos_x, pos_y, pos_z, pos_a, color1, color2, respawndelay);

				if(vehicleid != INVALID_VEHICLE_ID)
				{
					VehicleInfo[vehicleid][vID] = SQL_GetInt(i, "id");
					VehicleInfo[vehicleid][vGang] = SQL_GetInt(i, "gangid");
					Milliage[vehicleid] = SQL_GetInt(i, "milliage");
					VehicleInfo[vehicleid][vFactionType] = SQL_GetInt(i, "factiontype");
					VehicleInfo[vehicleid][vJob] = SQL_GetInt(i, "job");
					VehicleInfo[vehicleid][vHealth] = SQL_GetInt(i, "health");

					if(VehicleInfo[vehicleid][vGang] >= 0)
					{
					    VehicleInfo[vehicleid][vPrice] = SQL_GetInt(i, "price");
					    VehicleInfo[vehicleid][vLocked] = SQL_GetInt(i, "locked");
					    VehicleInfo[vehicleid][vPaintjob] = SQL_GetInt(i, "paintjob");
					    VehicleInfo[vehicleid][vInterior] = SQL_GetInt(i, "interior");
				        VehicleInfo[vehicleid][vWorld] = SQL_GetInt(i, "world");
				        VehicleInfo[vehicleid][vMods][0] = SQL_GetInt(i, "mod_1");
				        VehicleInfo[vehicleid][vMods][1] = SQL_GetInt(i, "mod_2");
				        VehicleInfo[vehicleid][vMods][2] = SQL_GetInt(i, "mod_3");
				        VehicleInfo[vehicleid][vMods][3] = SQL_GetInt(i, "mod_4");
				        VehicleInfo[vehicleid][vMods][4] = SQL_GetInt(i, "mod_5");
				        VehicleInfo[vehicleid][vMods][5] = SQL_GetInt(i, "mod_6");
				        VehicleInfo[vehicleid][vMods][6] = SQL_GetInt(i, "mod_7");
				        VehicleInfo[vehicleid][vMods][7] = SQL_GetInt(i, "mod_8");
				        VehicleInfo[vehicleid][vMods][8] = SQL_GetInt(i, "mod_9");
				        VehicleInfo[vehicleid][vMods][9] = SQL_GetInt(i, "mod_10");
				        VehicleInfo[vehicleid][vMods][10] = SQL_GetInt(i, "mod_11");
				        VehicleInfo[vehicleid][vMods][11] = SQL_GetInt(i, "mod_12");
				        VehicleInfo[vehicleid][vMods][12] = SQL_GetInt(i, "mod_13");
				        VehicleInfo[vehicleid][vMods][13] = SQL_GetInt(i, "mod_14");
						VehicleInfo[vehicleid][vVip] = SQL_GetInt(i, "vip");
						ReloadVehicle(vehicleid);
					}

					VehicleInfo[vehicleid][vModel] = modelid;
					VehicleInfo[vehicleid][vPosX] = pos_x;
					VehicleInfo[vehicleid][vPosY] = pos_y;
					VehicleInfo[vehicleid][vPosZ] = pos_z;
					VehicleInfo[vehicleid][vPosA] = pos_a;
					VehicleInfo[vehicleid][vColor1] = color1;
					VehicleInfo[vehicleid][vColor2] = color2;
					VehicleInfo[vehicleid][vRespawnDelay] = respawndelay;
					VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
					VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
					VehicleInfo[vehicleid][vTimer] = -1;
					vehicleFuel[vehicleid] = 100;

					SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
		        }
			}
		}
		case THREAD_GANG_INFORMATION:
		{
			if(rows)
			{
			    new count, total;

			    for(new i = 0; i < MAX_TURFS; i ++)
			    {
			        if(TurfInfo[i][tExists])
			        {
			            if(TurfInfo[i][tCapturedGang] == PlayerInfo[extraid][pGang])
			                count++;
			            else if(TurfInfo[i][tType] != 8)
			                total++;
			        }
				}

			    SM(extraid, SERVER_COLOR, "%s:", GangInfo[PlayerInfo[extraid][pGang]][gName]);
			    SM(extraid, COLOR_GREY2, "Theme: %s - Level: %i/3 - Strikes: %i/3 - Members: %i/%i - Vehicles: %i/%i", GangInfo[PlayerInfo[extraid][pGang]][gTheme], GangInfo[PlayerInfo[extraid][pGang]][gLevel], GangInfo[PlayerInfo[extraid][pGang]][gStrikes], SQL_GetIntByIndex(0, 0), GetGangMemberLimit(PlayerInfo[extraid][pGang]), GetGangVehicles(PlayerInfo[extraid][pGang]), GetGangVehicleLimit(PlayerInfo[extraid][pGang]));
			    SM(extraid, COLOR_GREY2, "Gang Points: %i GP - Turf Tokens: %i - Cash: $%i/$%i - Materials: %i/%i", GangInfo[PlayerInfo[extraid][pGang]][gPoints], GangInfo[PlayerInfo[extraid][pGang]][gTurfTokens], GangInfo[PlayerInfo[extraid][pGang]][gCash], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_CASH), GangInfo[PlayerInfo[extraid][pGang]][gMaterials], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_MATERIALS));
			    SM(extraid, COLOR_GREY2, "Turfs: %i/%i - Pot: %i/%ig - Crack: %i/%ig - Meth: %i/%ig - Painkillers: %i/%i", count, total, GangInfo[PlayerInfo[extraid][pGang]][gPot], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_WEED), GangInfo[PlayerInfo[extraid][pGang]][gCrack], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_COCAINE), GangInfo[PlayerInfo[extraid][pGang]][gMeth], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_METH),
					GangInfo[PlayerInfo[extraid][pGang]][gPainkillers], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_PAINKILLERS));
				SM(extraid, COLOR_GREY2, "Hollow point: %i/%i - Poison tip: %i/%i - Full metal jacket: %i/%i", GangInfo[PlayerInfo[extraid][pGang]][gHPAmmo], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_HPAMMO), GangInfo[PlayerInfo[extraid][pGang]][gPoisonAmmo], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_POISONAMMO), GangInfo[PlayerInfo[extraid][pGang]][gFMJAmmo], GetGangStashCapacity(PlayerInfo[extraid][pGang], STASH_CAPACITY_FMJAMMO));
			}
		}
		case THREAD_OFFLINE_IP:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "The username specified is not registered.");
		    }
		    else
		    {
		        new username[MAX_PLAYER_NAME], ip[16];

		        SQL_GetString(0, "username", username);
		        SQL_GetString(0, "ip", ip);

		        SM(extraid, COLOR_WHITE, "** %s's IP: %s **", username, ip);

		    }
		}
		case THREAD_CHECK_REFERRAL:
		{
		    if(!rows)
		    {
		        SendClientMessage(extraid, COLOR_SYNTAX, "The player specified doesn't exist.");
		        ShowDialogToPlayer(extraid, DIALOG_REFERRAL);
		    }
		    else
		    {
		        new username[MAX_PLAYER_NAME], ip[16];

		        SQL_GetString(0, "username", username);
		        SQL_GetString(0, "ip", ip);

		        if(!strcmp(GetPlayerIP(extraid), ip))
		        {
		            SendClientMessage(extraid, COLOR_SYNTAX, "This account is listed under your own IP address. You can't refer yourself.");
		            ShowDialogToPlayer(extraid, DIALOG_REFERRAL);
		        }
		        else
		        {
		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET referral_uid = %i WHERE uid = %i", SQL_GetInt(0, "uid"), PlayerInfo[extraid][pID]);
		            mysql_tquery(connectionID, queryBuffer);

					PlayerInfo[extraid][pTutorial] = 1;
					PlayerInfo[extraid][pTutorialTimer] = SetTimerEx("PlayerSpawn", 3000, false, "i", extraid);

	                SM(extraid, COLOR_YELLOW, "** You have chosen %s as your referrer. They will be rewarded once you reach level 3.", username);
				}
		    }
		}
		case THREAD_REWARD_REFERRER:
		{
		    if(rows)
		    {
			    new username[MAX_PLAYER_NAME], ip[16], referralid = INVALID_PLAYER_ID;

				SQL_GetString(0, "username", username);
				SQL_GetString(0, "ip", ip);

				// Check to see if any of the players online match the player's referral UID.
			    foreach(new i : Player)
			    {
			        if(i != extraid && PlayerInfo[i][pLogged] && PlayerInfo[i][pID] == PlayerInfo[extraid][pReferralUID])
			        {
			            referralid = i;
			            break;
			        }
			    }

				// Referrer is online.
			    if(referralid != INVALID_PLAYER_ID && strcmp(GetPlayerIP(referralid), GetPlayerIP(extraid)) != 0)
			    {
			        PlayerInfo[referralid][pLevel]++;
			        SendClientMessage(referralid, COLOR_YELLOW, "A player who you've referred reached level 3. Therefore you received 1 level!");
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET level = level + 1 WHERE uid = %i", PlayerInfo[referralid][pID]);
					mysql_tquery(connectionID, queryBuffer);

				}
				else
				{
				    // Referrer is offline. Let's give them their dirtycash and increment refercount which sends them an alert on login!
				    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET level = level + 1, refercount = refercount + 1 WHERE uid = %i AND ip != '%s'", PlayerInfo[extraid][pReferralUID], GetPlayerIP(extraid));
					mysql_tquery(connectionID, queryBuffer);
				}

				// Finally, remove the player's link to the referrer as the prize has been given.
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET referral_uid = 0 WHERE uid = %i", PlayerInfo[extraid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
		case THREAD_LIST_FLAGGED:
		{
		    new
				flags[MAX_PLAYERS],
				username[MAX_PLAYER_NAME],
				targetid;

		    SendClientMessage(extraid, SERVER_COLOR, "Flagged Players:");

		    for(new i = 0; i < rows; i ++)
		    {
		        SQL_GetStringByIndex(i, 0, username);

		        if(IsPlayerOnline(username, targetid))
		        {
		            flags[targetid]++;
				}
		    }

		    foreach(new i : Player)
		    {
		        if(flags[i] > 0)
		        {
		            SM(extraid, COLOR_WHITE, "** %s[%i] has %i active flags.", GetRPName(i), i, flags[i]);
				}
			}
		}
	}
}

