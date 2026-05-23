public OnGameModeExit()
{
	Module_StopAll();

    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) if(!IsPlayerNPC(i))	for(new a = 0; a < 10; a++)	if(IsPlayerAttachedObjectSlotUsed(i, a)) RemovePlayerAttachedObject(i, a);

    for(new o=0; o<MAX_STATIC_OBJECTS; o++)
	{
	    DestroyObject(o);
    }
  

	mysql_close(connectionID);

	// CCTV
	TextDrawHideForAll(TD);
	TextDrawDestroy(TD);

	for(new i; i<TotalMenus; i++)
	{
		DestroyMenu(CCTVMenu[i]);
	}
	/*--------------------*/

	if(gDoubleXP)
	{
	    gDoubleXP = 0;
	}
	
	if(gRobbery)
	{
		gRobbery = 0;
	}

	if(gDoubleSalary)
	{
	    gDoubleSalary = 0;
	}

	return 1;
}


forward HTTP_ProxyCheck(playerid, response_code, data[]);
public HTTP_ProxyCheck(playerid, response_code, data[])
{
	if(response_code == 200)
	{
		if(data[0] == 'Y')
		{
			SendAdminMessage(COLOR_RED,"AdmWarning: %s[%i] has attempted to connect with a Proxy/VPN.", GetRPName(playerid), playerid);
  			SendClientMessage(playerid, COLOR_RED, "========[ Please disable your proxy/VPN and rejoin! ]========");
   			KickPlayer(playerid);
		}
		if(data[0] == 'X')
		{
			printf("WRONG IP FORMAT");
		}
	}
	else
	{
		//printf("The request failed! The response code was: %d", response_code);
	}
	return 1;
}
forward SendDelayMessage(playerid);
public SendDelayMessage(playerid)
{
    notification_show(playerid,str_format("Welcome back! You've Logged In Automatically"),2000, NOTIF_SUCCESS);
	SCMf(playerid, COLOR_GREEN, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] Welcome back! You've Logged In Automatically");
    return 1;
}

public OnClientCheckResponse(playerid, actionid, memaddr, retndata)
{
    new string[256];
   

    switch (retndata)
    {
        case 0xA0: 
		{
            SendClientMessage(playerid, COLOR_SYNTAX, 
                "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}| ANTI-EXPLOIT] Your game files have been verified and are clean.");
            format(string, sizeof(string), 
                "Player %s (ID: %d) has clean game files. No modification detected.", 
                 GetRPName(playerid), playerid);
            SendDiscordMessage(2, string);
			
		}
        default:
		{
            SendClientMessage(playerid, COLOR_SYNTAX, 
                "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}| ANTI-EXPLOIT]{ed0023} Modified game files detected!");
            //SetTimerEx("SendDelayMessage", 6000, false, "i", playerid);
	    }
    }

    
    return 1;
}


public OnPlayerConnect(playerid)
{
	if(!Module_OnPlayerConnect(playerid))
	{
		return 0;
	}
	AsyncDialog_Reset(playerid);
	PlayerUpdateMoneyTick[playerid] = 0;
	PlayerUpdateTimeTick[playerid] = 0;
	PlayerUpdateHudTick[playerid] = 0;
	PlayerUpdateSafezoneTick[playerid] = 0;
	AdminNameTagSynced[playerid] = false;

	foreach(new i : Player)
	{
		AdminNameTagSynced[i] = false;
	}

	RemoveMappingObject(playerid);

    if(gDisabledVPN)
	{
		new formato[128];
		format(formato, sizeof formato, "blackbox.ipinfo.app/lookup/%s", GetPlayerIP(playerid));
		HTTP(playerid, HTTP_GET, formato, "", "HTTP_ProxyCheck");
	}
    
	if(CountIP(GetIP(playerid)) >= MAX_BOT_CONNECTIONS) return BanAllBots(playerid), 0;
	if(IsPlayerNPC(playerid))
	{
	   SAM(COLOR_RED, "%s Was Kicked Samp Npc", GetRPName(playerid));
	   KickPlayer(playerid);
	   return 0;
	}

 	new name[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, name, sizeof(name));
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	new string[228];
	format(string, sizeof(string), "%s has joined the server {33AA33}[IP:{FFFFFF} %s]", name, ip);
	SendAdminMessage(COLOR_LIGHTGREEN, string);
	new szString[228];
	format(szString, sizeof(szString), "**`%s has joined the server [IP:`%s`]`**", name, GetPlayerIP(playerid));
	SendDiscordMessage(17, szString);
	SetPVarString(playerid, "IP", GetPlayerIP(playerid));
	
   	pAntiCheatSettingsPage{playerid} = 0; // Присваиваем значение 0 переменной, хранящей номер страницы настроек анти-чита, на которой находится игрок
    pAntiCheatSettingsEditCodeId[playerid] = -1;
	PlayerInfo[playerid][pDonateWeapon] = 0;
	PlayerInfo[playerid][pWatchingIntro] = 0;
	
    ExBJck[playerid] = 0;
    pBlind[playerid] = 0;
    Maskara[playerid] = 0;
    MaskaraID[playerid] = 0;
    ShowingBounds[playerid] = 0;
	Sliding[playerid] = 0;
    InsideTut[playerid] = 0;
    CurrentCCTV[playerid] = -1;
	pvehicleid[playerid] = 0;
	IsShownZoneTD[playerid] = false;
    pmodelid[playerid] = 0;
	PayCheckCode[playerid] = 0;
	PowerSpec[playerid] = 0;
	
	
	// Default values are handled via MySQL/PhpMyAdmin. Don't assign default values here.
	PlayerInfo[playerid][pRobbingHouse] = -1;
	PlayerInfo[playerid][pToolkit] = 0;
	PlayerInfo[playerid][pLockpick] = 0;
	PlayerInfo[playerid][pRepairKit] = 0;
	PlayerInfo[playerid][pPassword] = 0;
	PlayerInfo[playerid][pPassword1] = 0;
 	PlayerInfo[playerid][pPassword3] = 0;
 	PlayerInfo[playerid][pRegpass] = 0;
 	PlayerInfo[playerid][pGasplace] = 0;
	PlayerInfo[playerid][pHitSz] = 0;
	
	
    PlayerInfo[playerid][pGraffiti] = -1;
    PlayerInfo[playerid][pChatAnim] = 0;
    PlayerInfo[playerid][pGraffitiTime] = 0;
    PlayerInfo[playerid][pGraffitiColor] = 0;
    PlayerInfo[playerid][pRentCar] = 0;
    PlayerInfo[playerid][pEditGraffiti] = -1;
	PlayerInfo[playerid][pEditGate] = -1;
	PlayerInfo[playerid][pEditmObject] = -1;
	PlayerInfo[playerid][pHurt] = 0;
	PlayerInfo[playerid][pSkates] = 0;
	PlayerInfo[playerid][pSkateObj] = 0;
	PlayerInfo[playerid][pSkating] = false;
	PlayerInfo[playerid][pRobbingBiz] = -1;
	PlayerInfo[playerid][pProductChoose] = -1;
	PlayerInfo[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pDiamonds] = 0;
	PlayerInfo[playerid][pEngine] = 0;
	PlayerInfo[playerid][pID] = 0;
	PlayerInfo[playerid][pLogged] = 0;
	PlayerInfo[playerid][pKicked] = 0;
	PlayerInfo[playerid][pLoginTries] = 0;
	PlayerInfo[playerid][pGiveAmount] = 1;
	PlayerInfo[playerid][pSetup] = 0;
	PlayerInfo[playerid][pGender] = 0;
	PlayerInfo[playerid][pAge] = 0;
	PlayerInfo[playerid][pSkin] = 0;
	PlayerInfo[playerid][pSafezone] = 0;
	PlayerInfo[playerid][pSafezoneEnter] = 0;
	PlayerInfo[playerid][pCameraX] = 0;
	PlayerInfo[playerid][pFormerAdmin] = 0;
	PlayerInfo[playerid][pGiveAmount] = 1;
	PlayerInfo[playerid][pCameraY] = 0;
	PlayerInfo[playerid][pCameraZ] = 0;
	PlayerInfo[playerid][pPosX] = 0;
	PlayerInfo[playerid][pPosY] = 0;
	PlayerInfo[playerid][pPosZ] = 0;
	PlayerInfo[playerid][pPosA] = 0;
	PlayerInfo[playerid][pLastlogin] = 0;
	PlayerInfo[playerid][pSpawn] = 0;

	PlayerInfo[playerid][pFood] = 0;
	PlayerInfo[playerid][pDrink] = 0;

	PlayerInfo[playerid][pInterior] = 0;
	PlayerInfo[playerid][pWorld] = 0;
	PlayerInfo[playerid][pCash] = 50000;
	PlayerInfo[playerid][pBank] = 50000;
	PlayerInfo[playerid][pPaycheck] = 0;
	PlayerInfo[playerid][pLevel] = 1;
	PlayerInfo[playerid][pAdvertWarnings] = 0;
	PlayerInfo[playerid][pEXP] = 0;
	PlayerInfo[playerid][pMinutes] = 0;
	PlayerInfo[playerid][pHours] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pAdminName] = 0;
	PlayerInfo[playerid][pHelper] = 0;
	PlayerInfo[playerid][pHealth] = 100.0;
	PlayerInfo[playerid][pArmor] = 0.0;
	PlayerInfo[playerid][pHelmet] = 0;
	PlayerInfo[playerid][pHelmet1] = 0;
	PlayerInfo[playerid][pUpgradePoints] = 0;
	PlayerInfo[playerid][pWarnings] = 0;
	PlayerInfo[playerid][pComserv] = 0;
	PlayerInfo[playerid][pInjured] = 0;
	PlayerInfo[playerid][pAdutyl] = 0;
	PlayerInfo[playerid][pHospital] = 0;
	PlayerInfo[playerid][pSpawnHealth] = 50.0;
	PlayerInfo[playerid][pSpawnArmor] = 0;
	PlayerInfo[playerid][pJailType] = 0;
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pNewbieMuted] = 0;
	PlayerInfo[playerid][pHelpMuted] = 0;
	PlayerInfo[playerid][pAdMuted] = 0;
	PlayerInfo[playerid][pLiveMuted] = 0;
	PlayerInfo[playerid][pGlobalMuted] = 0;
	PlayerInfo[playerid][pReportMuted] = 0;
	PlayerInfo[playerid][pReportWarns] = 0;
	PlayerInfo[playerid][pFightStyle] = 0;
	PlayerInfo[playerid][pAccent] = 0;
	PlayerInfo[playerid][pDirtyCash] = 0;

	#if defined Christmas
		PlayerInfo[playerid][pCandy] = 0;
	#endif
	PlayerInfo[playerid][pPhone] = 0;
	PlayerInfo[playerid][pJob] = JOB_NONE;
	PlayerInfo[playerid][pSecondJob] = JOB_NONE;
	PlayerInfo[playerid][pCrimes] = 0;
	PlayerInfo[playerid][pArrested] = 0;
	PlayerInfo[playerid][pWantedLevel] = 0;
	PlayerInfo[playerid][pMaterials] = 0;
	PlayerInfo[playerid][pPot] = 0;
	PlayerInfo[playerid][pCrack] = 0;
	PlayerInfo[playerid][pMeth] = 0;
    PlayerInfo[playerid][pGunFrame] = 0;
	PlayerInfo[playerid][pGold] = 0;
	PlayerInfo[playerid][pIorn] = 0;
	PlayerInfo[playerid][pPainkillers] = 0;
	PlayerInfo[playerid][pBandage] = 0;
	PlayerInfo[playerid][pSeeds] = 0;
	PlayerInfo[playerid][pVest] = 0;
	PlayerInfo[playerid][pEphedrine] = 0;
	PlayerInfo[playerid][pMuriaticAcid] = 0;
	PlayerInfo[playerid][pBatteries] = 0;
    PlayerInfo[playerid][pAcetone] = 0;
    PlayerInfo[playerid][pMobileMethLab] = 0;
	PlayerInfo[playerid][pBakingSoda] = 0;
	PlayerInfo[playerid][pCigars] = 0;
	PlayerInfo[playerid][pWalkieTalkie] = 0;
	PlayerInfo[playerid][pChannel] = 0;
	PlayerInfo[playerid][pRentingHouse] = 0;
	PlayerInfo[playerid][pSpraycans] = 0;
	PlayerInfo[playerid][pBoombox] = 0;
	PlayerInfo[playerid][pMask] = 0;
	PlayerInfo[playerid][pVerified] = 0;
	PlayerInfo[playerid][pBlindfold] = 0;
	PlayerInfo[playerid][pMP3Player] = 0;
	PlayerInfo[playerid][pPhonebook] = 0;
	PlayerInfo[playerid][pFishingRod] = 0;
	PlayerInfo[playerid][pFishingBait] = 0;
	PlayerInfo[playerid][pFishWeight] = 0;
	PlayerInfo[playerid][pCrafting] = 0;
	PlayerInfo[playerid][pFishingSkill] = 0;
	PlayerInfo[playerid][pCourierSkill] = 0;
	PlayerInfo[playerid][pGuardSkill] = 0;
	PlayerInfo[playerid][pWeaponSkill] = 0;
	PlayerInfo[playerid][pLawyerSkill] = 0;
	PlayerInfo[playerid][pSmugglerSkill] = 0;
	PlayerInfo[playerid][pToggleTextdraws] = 0;
	PlayerInfo[playerid][pToggleOOC] = 0;
	PlayerInfo[playerid][pTogglePhone] = 0;
	PlayerInfo[playerid][pToggleAdmin] = 0;
	PlayerInfo[playerid][pToggleHelper] = 0;
	PlayerInfo[playerid][pToggleNewbie] = 0;
	PlayerInfo[playerid][pToggleWT] = 0;
	PlayerInfo[playerid][pToggleRadio] = 0;
	PlayerInfo[playerid][pToggleVIP] = 0;
	PlayerInfo[playerid][pToggleMusic] = 0;
	PlayerInfo[playerid][pToggleFaction] = 0;
	PlayerInfo[playerid][pToggleGang] = 0;
	PlayerInfo[playerid][pToggleNews] = 0;
	PlayerInfo[playerid][pToggleGlobal] = 1;
	PlayerInfo[playerid][pToggleCam] = 0;
	PlayerInfo[playerid][pCarLicense] = 0;
	PlayerInfo[playerid][pWeaponLicense] = 0;
	PlayerInfo[playerid][pBuygun] = 0;
	PlayerInfo[playerid][pBGTime] = 0;
	PlayerInfo[playerid][pVIPPackage] = 1;
	PlayerInfo[playerid][pVIPTime] = gettime() + (15 * 86400);
	PlayerInfo[playerid][pVIPCooldown] = 0;
	PlayerInfo[playerid][pWeapons] = 0;
	PlayerInfo[playerid][pAmmo] = 0;
	PlayerInfo[playerid][pFaction] = 0;
	PlayerInfo[playerid][pFactionRank] = 0;
	PlayerInfo[playerid][pGang] = -1;
	PlayerInfo[playerid][pGiveAmount] = 1;
    PlayerInfo[playerid][pSelectItem] = 0;
	PlayerInfo[playerid][pGangRank] = 0;
	PlayerInfo[playerid][pDivision] = 0;
	PlayerInfo[playerid][pContracted] = 0;
	PlayerInfo[playerid][pContractBy] = 0;
	PlayerInfo[playerid][pBombs] = 0;
	PlayerInfo[playerid][pOilExTime] = 0;
	PlayerInfo[playerid][pFruitExTime] = 0;
	PlayerInfo[playerid][pOilEx] = 0;
	PlayerInfo[playerid][pCompletedHits] = 0;
	PlayerInfo[playerid][pFailedHits] = 0;
	PlayerInfo[playerid][pReports] = 0;
	PlayerInfo[playerid][pNewbies] = 0;
	PlayerInfo[playerid][pHelpRequests] = 0;
	PlayerInfo[playerid][pSpeedometer] = 0;
	PlayerInfo[playerid][pFactionMod] = 0;
	PlayerInfo[playerid][pGangMod] = 0;
	PlayerInfo[playerid][pFactionBan] = 0;
	PlayerInfo[playerid][pGangBan] = 0;
	PlayerInfo[playerid][pBanAppealer] = 0;
	PlayerInfo[playerid][pPotPlanted] = 0;
	PlayerInfo[playerid][pPotTime] = 0;
	PlayerInfo[playerid][pPotGrams] = 0;
	PlayerInfo[playerid][pPotX] = 0;
	PlayerInfo[playerid][pPotY] = 0;
	PlayerInfo[playerid][pPotZ] = 0;
	PlayerInfo[playerid][pPotA] = 0;
	PlayerInfo[playerid][pInventoryUpgrade] = 0;
	PlayerInfo[playerid][pAddictUpgrade] = 0;
	PlayerInfo[playerid][pTraderUpgrade] = 0;
	PlayerInfo[playerid][pAssetUpgrade] = 0;
	PlayerInfo[playerid][pHPAmmo] = 0;
	PlayerInfo[playerid][pPoisonAmmo] = 0;
	PlayerInfo[playerid][pFMJAmmo] = 0;
	PlayerInfo[playerid][pAmmoType] = 0;
	PlayerInfo[playerid][pAmmoWeapon] = 0;
	PlayerInfo[playerid][pLastReport] = 0;
	PlayerInfo[playerid][pLastNewbie] = 0;
	PlayerInfo[playerid][pLastRequest] = 0;
	PlayerInfo[playerid][pLastPay] = 0;
	PlayerInfo[playerid][pLastRepair] = 0;
	PlayerInfo[playerid][pLastRefuel] = 0;
	PlayerInfo[playerid][pLastDrug] = 0;
	PlayerInfo[playerid][pLastSell] = 0;
	PlayerInfo[playerid][pLastEnter] = 0;
	PlayerInfo[playerid][pLastPress] = 0;
	PlayerInfo[playerid][pLastDeath] = 0;
	PlayerInfo[playerid][pLastDesync] = 0;
	PlayerInfo[playerid][pLastGlobal] = 0;
	PlayerInfo[playerid][pLastTweet] = 0;
	PlayerInfo[playerid][pSpectating] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pAdminDuty] = 0;
	PlayerInfo[playerid][pActiveReport] = -1;
	PlayerInfo[playerid][pHospitalTime] = 0;
	PlayerInfo[playerid][pListen] = 0;
	PlayerInfo[playerid][pPMListen] = 0;
	PlayerInfo[playerid][pJoinedEvent] = 0;
	PlayerInfo[playerid][pPaintball] = 0;
	PlayerInfo[playerid][pPaintballTeam] = -1;
	PlayerInfo[playerid][pDueling] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pEventTeam] = 0;
	PlayerInfo[playerid][pAwaitingClothing] = 0;
	PlayerInfo[playerid][pTutorial] = 0;
	PlayerInfo[playerid][pFreezeTimer] = -1;
	PlayerInfo[playerid][pNameChange][0] = 0;
	PlayerInfo[playerid][pHelpRequest][0] = 0;
	PlayerInfo[playerid][pAcceptedHelp] = 0;
	PlayerInfo[playerid][pHouseOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pGarageOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pBizOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pVestOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pCarOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pFactionOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pGangOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pFriskOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pCarryOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pTicketOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pLiveOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pShakeOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pGpsOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pLandOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pSellOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pAllianceOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pDefendOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pDiceOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pSendRob] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pInviteOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pRobberyOffer] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pEditType] = 0;
    PlayerInfo[playerid][pEditObject] = INVALID_OBJECT_ID;
    PlayerInfo[playerid][pFurniturePerms] = -1;
    PlayerInfo[playerid][pLandPerms] = -1;
	PlayerInfo[playerid][pLastStuck] = 0;
	PlayerInfo[playerid][pLastUpdate] = 0;
	PlayerInfo[playerid][pLastLoad] = 0;
	PlayerInfo[playerid][pLastBet] = 0;
	PlayerInfo[playerid][pLastClean] = 0;
	PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;
	PlayerInfo[playerid][pShipment] = -1;
	PlayerInfo[playerid][pIllegalCargo] = -1;
	PlayerInfo[playerid][pFishTime] = 0;
	PlayerInfo[playerid][pUsedBait] = 0;
	PlayerInfo[playerid][pSmuggleMats] = 0;
	PlayerInfo[playerid][pSmuggleTime] = 0;
	PlayerInfo[playerid][pSmuggleDrugs] = 0;
	PlayerInfo[playerid][pRefuel] = INVALID_VEHICLE_ID;
	PlayerInfo[playerid][pCallLine] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pAFK] = 0;
    PlayerInfo[playerid][pAFKTime] = 0;
	PlayerInfo[playerid][pLoopAnim] = 0;
	PlayerInfo[playerid][pHarvestTime] = 0;
	PlayerInfo[playerid][pWheat] = 0;
	PlayerInfo[playerid][pDrivingTest] = 0;
	PlayerInfo[playerid][pSpecialTag] = Text3D:INVALID_3DTEXT_ID;
	PlayerInfo[playerid][pTagType] = TAG_NORMAL;
	PlayerInfo[playerid][pVIPColor] = 0;
    PlayerInfo[playerid][pFaction] = -1;
    PlayerInfo[playerid][pFactionRank] = 0;
    PlayerInfo[playerid][pGang] = -1;
    PlayerInfo[playerid][pGangRank] = 0;
	PlayerInfo[playerid][pDuty] = 0;
	PlayerInfo[playerid][pBackup] = 0;
	PlayerInfo[playerid][pTazer] = 0;
	PlayerInfo[playerid][pTazedTime] = 0;
	PlayerInfo[playerid][pCuffed] = 0;
	PlayerInfo[playerid][pTied] = 0;
	PlayerInfo[playerid][pDraggedBy] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pSkinSelected] = -1;
	PlayerInfo[playerid][pFirstAid] = 0;
    PlayerInfo[playerid][pDelivered] = 0;
    PlayerInfo[playerid][pPlantedBomb] = 0;
    PlayerInfo[playerid][pBombObject] = INVALID_OBJECT_ID;
    PlayerInfo[playerid][pContractTaken] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pSpamTime] = 0;
    PlayerInfo[playerid][pMuted] = 0;
    PlayerInfo[playerid][pBoomboxPlaced] = 0;
    PlayerInfo[playerid][pBoomboxObject] = INVALID_OBJECT_ID;
	PlayerInfo[playerid][pBoomboxListen] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pZonePickups][0] = -1;
    PlayerInfo[playerid][pZonePickups][1] = -1;
    PlayerInfo[playerid][pZonePickups][2] = -1;
    PlayerInfo[playerid][pZonePickups][3] = -1;
    PlayerInfo[playerid][pZoneID] = -1;
    PlayerInfo[playerid][pZoneCreation] = 0;
    PlayerInfo[playerid][pShowLands] = 0;
    PlayerInfo[playerid][pShowTurfs] = 0;
    PlayerInfo[playerid][pStreamType] = MUSIC_NONE;
    PlayerInfo[playerid][pFreeNamechange] = 0;
	PlayerInfo[playerid][pVehicleKeys] = INVALID_VEHICLE_ID;
    PlayerInfo[playerid][pCurrentWeapon] = 0;
    PlayerInfo[playerid][pCurrentAmmo] = 0;
    PlayerInfo[playerid][pCurrentVehicle] = 0;
    PlayerInfo[playerid][pVehicleCount] = 0;
    PlayerInfo[playerid][pACWarns] = 0;
    PlayerInfo[playerid][pACTime] = 0;
    PlayerInfo[playerid][pArmorTime] = 0;
    PlayerInfo[playerid][pACFired] = 0;
    PlayerInfo[playerid][pPotObject] = INVALID_OBJECT_ID;
    PlayerInfo[playerid][pPickPlant] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pPickTime] = 0;
    PlayerInfo[playerid][pDrugsUsed] = 0;
    PlayerInfo[playerid][pDrugsTime] = 0;
    PlayerInfo[playerid][pBandana] = 0;
	PlayerInfo[playerid][pCapturingPoint] = -1;
	PlayerInfo[playerid][pCaptureTime] = 0;
	PlayerInfo[playerid][pWatchingIntro] = 0;
	PlayerInfo[playerid][pLoginCamera] = 0;
	PlayerInfo[playerid][pPoisonTime] = 0;
	PlayerInfo[playerid][pJetpack] = 0;
    PlayerInfo[playerid][pWatchOn] = 0;
    PlayerInfo[playerid][pGPSOn] = 0;
    PlayerInfo[playerid][pTextFrom] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pWhisperFrom] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pMechanicCall] = 0;
    PlayerInfo[playerid][pEmergencyCall] = 0;
	PlayerInfo[playerid][pClip] = 0;
	PlayerInfo[playerid][pReloading] = 0;
    PlayerInfo[playerid][pFindTime] = 0;
    PlayerInfo[playerid][pFindPlayer] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][pRobCash] = 0;
	PlayerInfo[playerid][pLootTime] = 0;
	PlayerInfo[playerid][pRemoveFrom] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pLockBreak] = INVALID_VEHICLE_ID;
	PlayerInfo[playerid][pLockTimer] = 0;
	PlayerInfo[playerid][pLockText] = Text3D:INVALID_3DTEXT_ID;
    PlayerInfo[playerid][pAnimation] = 0;
	PlayerInfo[playerid][pDropTime] = 0;
	PlayerInfo[playerid][pRefunded] = 0;
	PlayerInfo[playerid][pTogglePM] = 0;
	PlayerInfo[playerid][pPMFrom] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pToggleWhisper] = 0;
	PlayerInfo[playerid][pRareTime] = 0;
	PlayerInfo[playerid][pVipTimes] = 0;
	PlayerInfo[playerid][pBL] = 0;
	PlayerInfo[playerid][pBackpack] = 0;
	PlayerInfo[playerid][bpWearing] = 0;
	PlayerInfo[playerid][bpCash] = 0;
	PlayerInfo[playerid][bpMaterials] = 0;
	PlayerInfo[playerid][bpPot] = 0;
	PlayerInfo[playerid][bpCrack] = 0;
	PlayerInfo[playerid][bpMeth] = 0;
	PlayerInfo[playerid][bpPainkillers] = 0;
	PlayerInfo[playerid][bpWeapons] = 0;
	PlayerInfo[playerid][bpHPAmmo] = 0;
	PlayerInfo[playerid][bpPoisonAmmo] = 0;
	PlayerInfo[playerid][bpFMJAmmo] = 0;
	PlayerInfo[playerid][pMarriedTo] = -1;
	PlayerInfo[playerid][pHunger] = 100;
	PlayerInfo[playerid][pHungerTimer] = 0;
	PlayerInfo[playerid][pThirst] = 100;
	PlayerInfo[playerid][pThirstTimer] = 0;
	PlayerInfo[playerid][pLottery] = 0;
	PlayerInfo[playerid][pLotteryB] = 0;
    for(new i = 0; i < 100; i ++)
	{
	    chattingWith[playerid]{i} = false;
    }

	for(new i = 0; i < 13; i ++)
	{
	    PlayerInfo[playerid][pWeapons][i] = 0;
	    PlayerInfo[playerid][pTempWeapons][i] = 0;
	}

	for(new i = 0; i < 3; i ++)
	{
	    MarkedPositions[playerid][i][mPosX] = 0.0;
	    MarkedPositions[playerid][i][mPosY] = 0.0;
	    MarkedPositions[playerid][i][mPosZ] = 0.0;
	}

	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    ClothingInfo[playerid][i][cExists] = 0;
	    ClothingInfo[playerid][i][cID] = 0;
	    ClothingInfo[playerid][i][cName] = 0;
	    ClothingInfo[playerid][i][cModel] = 0;
	    ClothingInfo[playerid][i][cBone] = 0;
	    ClothingInfo[playerid][i][cAttached] = 0;
	    ClothingInfo[playerid][i][cAttachedIndex] = -1;
	}

	// Reset the player's client attributes.
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i ++)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i))
	    {
	        RemovePlayerAttachedObject(playerid, i);
		}
	}

	ResetPlayerWeapons(playerid);
	SetPlayerColor(playerid, 0xFFFFFF00);


    for (new i = 0; i != MAX_INVENTORY; i ++)
	{
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	}
    createinv(playerid);

   	PlayerInfo[playerid][pGased] = false;
	PlayerInfo[playerid][pGased1] = false;


    DEATHBUTTONP[playerid][0] = CreatePlayerTextDraw(playerid, 329.500, 282.000, "CALL_EMS");
    PlayerTextDrawLetterSize(playerid, DEATHBUTTONP[playerid][0], 0.300, 1.998);
    PlayerTextDrawTextSize(playerid, DEATHBUTTONP[playerid][0], 30.000, 61.000);
    PlayerTextDrawAlignment(playerid, DEATHBUTTONP[playerid][0], 2);
    PlayerTextDrawColour(playerid, DEATHBUTTONP[playerid][0], -1);
    PlayerTextDrawSetShadow(playerid, DEATHBUTTONP[playerid][0], 1);
    PlayerTextDrawSetOutline(playerid, DEATHBUTTONP[playerid][0], 1);
    PlayerTextDrawBackgroundColour(playerid, DEATHBUTTONP[playerid][0], 0);
    PlayerTextDrawFont(playerid, DEATHBUTTONP[playerid][0], 2);
    PlayerTextDrawSetProportional(playerid, DEATHBUTTONP[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, DEATHBUTTONP[playerid][0], 1);

	PlayerInfo[playerid][pTextdraws][1] = CreatePlayerTextDraw(playerid,274.000000, 382.000000, "Vehicle ~g~engine ~w~starting...");
	PlayerTextDrawBackgroundColour(playerid,PlayerInfo[playerid][pTextdraws][1], 255);
	PlayerTextDrawFont(playerid,PlayerInfo[playerid][pTextdraws][1], 1);
	PlayerTextDrawLetterSize(playerid,PlayerInfo[playerid][pTextdraws][1], 0.250000, 1.400001);
	PlayerTextDrawColour(playerid,PlayerInfo[playerid][pTextdraws][1], -1);
	PlayerTextDrawSetOutline(playerid,PlayerInfo[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetProportional(playerid,PlayerInfo[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetSelectable(playerid,PlayerInfo[playerid][pTextdraws][1], 0);

	CALP[playerid][0] = CreatePlayerTextDraw(playerid, 395.000, 199.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, CALP[playerid][0], 41.000, 45.000);
	PlayerTextDrawAlignment(playerid, CALP[playerid][0], 1);
	PlayerTextDrawColour(playerid, CALP[playerid][0], -1448498689);
	PlayerTextDrawSetShadow(playerid, CALP[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, CALP[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, CALP[playerid][0], 255);
	PlayerTextDrawFont(playerid, CALP[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, CALP[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, CALP[playerid][0], 1);

	CALP[playerid][1] = CreatePlayerTextDraw(playerid, 520.000, 163.000, "0");
	PlayerTextDrawLetterSize(playerid, CALP[playerid][1], 0.799, 3.698);
	PlayerTextDrawAlignment(playerid, CALP[playerid][1], 3);
	PlayerTextDrawColour(playerid, CALP[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, CALP[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, CALP[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, CALP[playerid][1], 0);
	PlayerTextDrawFont(playerid, CALP[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CALP[playerid][1], 1);

	CALP[playerid][2] = CreatePlayerTextDraw(playerid, 409.000, 213.000, "AC");
	PlayerTextDrawLetterSize(playerid, CALP[playerid][2], 0.300, 1.500);
	PlayerTextDrawAlignment(playerid, CALP[playerid][2], 1);
	PlayerTextDrawColour(playerid, CALP[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, CALP[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, CALP[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, CALP[playerid][2], 0);
	PlayerTextDrawFont(playerid, CALP[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, CALP[playerid][2], 1);



    APPLOCKGET[playerid][0] = CreatePlayerTextDraw(playerid, 504.000, 154.000, "GET");
	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][0], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, APPLOCKGET[playerid][0], 2);
	PlayerTextDrawColour(playerid, APPLOCKGET[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, APPLOCKGET[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, APPLOCKGET[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, APPLOCKGET[playerid][0], 0);
	PlayerTextDrawFont(playerid, APPLOCKGET[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, APPLOCKGET[playerid][0], 1);

	APPLOCKGET[playerid][1] = CreatePlayerTextDraw(playerid, 504.000, 196.000, "GET");
	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][1], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, APPLOCKGET[playerid][1], 2);
	PlayerTextDrawColour(playerid, APPLOCKGET[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, APPLOCKGET[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, APPLOCKGET[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, APPLOCKGET[playerid][1], 0);
	PlayerTextDrawFont(playerid, APPLOCKGET[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, APPLOCKGET[playerid][1], 1);

	APPLOCKGET[playerid][2] = CreatePlayerTextDraw(playerid, 504.000, 240.000, "GET");
	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][2], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, APPLOCKGET[playerid][2], 2);
	PlayerTextDrawColour(playerid, APPLOCKGET[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, APPLOCKGET[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, APPLOCKGET[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, APPLOCKGET[playerid][2], 0);
	PlayerTextDrawFont(playerid, APPLOCKGET[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, APPLOCKGET[playerid][2], 1);

	APPLOCKGET[playerid][3] = CreatePlayerTextDraw(playerid, 504.000, 284.000, "GET");
	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][3], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, APPLOCKGET[playerid][3], 2);
	PlayerTextDrawColour(playerid, APPLOCKGET[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, APPLOCKGET[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, APPLOCKGET[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, APPLOCKGET[playerid][3], 0);
	PlayerTextDrawFont(playerid, APPLOCKGET[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, APPLOCKGET[playerid][3], 1);

	APPLOCKGET[playerid][4] = CreatePlayerTextDraw(playerid, 504.000, 327.000, "GET");
	PlayerTextDrawLetterSize(playerid, APPLOCKGET[playerid][4], 0.170, 0.790);
	PlayerTextDrawAlignment(playerid, APPLOCKGET[playerid][4], 2);
	PlayerTextDrawColour(playerid, APPLOCKGET[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, APPLOCKGET[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, APPLOCKGET[playerid][4], 1);
	PlayerTextDrawBackgroundColour(playerid, APPLOCKGET[playerid][4], 0);
	PlayerTextDrawFont(playerid, APPLOCKGET[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, APPLOCKGET[playerid][4], 1);

	DIALERP[playerid] = CreatePlayerTextDraw(playerid, 462.000, 152.000, "_");
	PlayerTextDrawLetterSize(playerid, DIALERP[playerid], 0.300, 1.500);
	PlayerTextDrawAlignment(playerid, DIALERP[playerid], 2);
	PlayerTextDrawColour(playerid, DIALERP[playerid], 255);
	PlayerTextDrawSetShadow(playerid, DIALERP[playerid], 1);
	PlayerTextDrawSetOutline(playerid, DIALERP[playerid], 1);
	PlayerTextDrawBackgroundColour(playerid, DIALERP[playerid], 0);
	PlayerTextDrawFont(playerid, DIALERP[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DIALERP[playerid], 1);
	
  
	
	REGISTER[playerid][0] = CreatePlayerTextDraw(playerid, -67.000, -60.000, "_");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][0], 0.300, 60.699);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][0], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, REGISTER[playerid][0], 1);
	PlayerTextDrawBoxColour(playerid, REGISTER[playerid][0], 175);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][0], 150);
	PlayerTextDrawFont(playerid, REGISTER[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][0], 1);

	REGISTER[playerid][1] = CreatePlayerTextDraw(playerid, 96.000, 118.000, "ALL");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][1], 0.537, 3.799);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][1], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][1], 16744447);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][1], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][1], 1);

	REGISTER[playerid][2] = CreatePlayerTextDraw(playerid, 140.000, 118.000, "KERALA");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][2], 0.537, 3.799);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][2], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][2], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][2], 1);

	REGISTER[playerid][3] = CreatePlayerTextDraw(playerid, 229.000, 118.000, "ROLEPLAY");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][3], 0.537, 3.799);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][3], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][3], 16744447);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][3], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][3], 1);

	REGISTER[playerid][4] = CreatePlayerTextDraw(playerid, 163.000, 147.000, "registration");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][4], 0.398, 1.899);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][4], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][4], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][4], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][4], 1);

	REGISTER[playerid][5] = CreatePlayerTextDraw(playerid, 152.000, 186.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][5], 132.000, 27.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][5], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][5], 548580095);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][5], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][5], 1);

	REGISTER[playerid][6] = CreatePlayerTextDraw(playerid, 149.000, 186.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][6], 2.000, 128.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][6], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][6], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][6], 1);

	REGISTER[playerid][7] = CreatePlayerTextDraw(playerid, 219.000, 193.000, "CHOOSE_YOUR_PASSWORD");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][7], 0.187, 1.199);
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][7], 10.000, 30.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][7], 2);
	PlayerTextDrawColour(playerid, REGISTER[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][7], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][7], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][7], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, REGISTER[playerid][7], 1);

	REGISTER[playerid][8] = CreatePlayerTextDraw(playerid, 271.000, 179.500, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][8], 25.000, 40.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][8], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][8], 548580095);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][8], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][8], 1);

	REGISTER[playerid][9] = CreatePlayerTextDraw(playerid, 152.000, 237.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][9], 132.000, 27.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][9], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][9], 548580095);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][9], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][9], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][9], 1);

	REGISTER[playerid][10] = CreatePlayerTextDraw(playerid, 219.000, 244.000, "CONFIRM_PASSWORD");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][10], 0.187, 1.199);
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][10], 15.000, 30.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][10], 2);
	PlayerTextDrawColour(playerid, REGISTER[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][10], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][10], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][10], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][10], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, REGISTER[playerid][10], 1);

	REGISTER[playerid][11] = CreatePlayerTextDraw(playerid, 271.000, 230.500, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][11], 25.000, 40.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][11], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][11], 548580095);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][11], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][11], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][11], 1);

	REGISTER[playerid][12] = CreatePlayerTextDraw(playerid, 152.000, 287.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][12], 132.000, 27.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][12], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][12], 16744447);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][12], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][12], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][12], 1);

	REGISTER[playerid][13] = CreatePlayerTextDraw(playerid, 219.000, 294.000, "REGISTER");
	PlayerTextDrawLetterSize(playerid, REGISTER[playerid][13], 0.187, 1.199);
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][13], 15.000, 30.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][13], 2);
	PlayerTextDrawColour(playerid, REGISTER[playerid][13], 255);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][13], 1);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][13], 1);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][13], 0);
	PlayerTextDrawFont(playerid, REGISTER[playerid][13], 2);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, REGISTER[playerid][13], 1);

	REGISTER[playerid][14] = CreatePlayerTextDraw(playerid, 271.000, 280.500, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, REGISTER[playerid][14], 25.000, 40.000);
	PlayerTextDrawAlignment(playerid, REGISTER[playerid][14], 1);
	PlayerTextDrawColour(playerid, REGISTER[playerid][14], 16744447);
	PlayerTextDrawSetShadow(playerid, REGISTER[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, REGISTER[playerid][14], 0);
	PlayerTextDrawBackgroundColour(playerid, REGISTER[playerid][14], 255);
	PlayerTextDrawFont(playerid, REGISTER[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, REGISTER[playerid][14], 1);


	ShotsTD[playerid][0] = CreatePlayerTextDraw(playerid, 86.000000, 149.000000, "_");
	PlayerTextDrawFont(playerid, ShotsTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, ShotsTD[playerid][0], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, ShotsTD[playerid][0], 298.500000, 75.000000);
	PlayerTextDrawSetOutline(playerid, ShotsTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, ShotsTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, ShotsTD[playerid][0], 2);
	PlayerTextDrawColour(playerid, ShotsTD[playerid][0], -1);
	PlayerTextDrawBackgroundColour(playerid, ShotsTD[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, ShotsTD[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, ShotsTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, ShotsTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, ShotsTD[playerid][0], 0);

	ShotsTD[playerid][1] = CreatePlayerTextDraw(playerid, 86.000000, 153.000000, "_");
	PlayerTextDrawFont(playerid, ShotsTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, ShotsTD[playerid][1], 0.600000, 1.150000);
	PlayerTextDrawTextSize(playerid, ShotsTD[playerid][1], 298.500000, 75.000000);
	PlayerTextDrawSetOutline(playerid, ShotsTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, ShotsTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, ShotsTD[playerid][1], 2);
	PlayerTextDrawColour(playerid, ShotsTD[playerid][1], -1);
	PlayerTextDrawBackgroundColour(playerid, ShotsTD[playerid][1], 16777215);
	PlayerTextDrawBoxColour(playerid, ShotsTD[playerid][1], 65415);
	PlayerTextDrawUseBox(playerid, ShotsTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, ShotsTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, ShotsTD[playerid][1], 0);

	ShotsTD[playerid][2] = CreatePlayerTextDraw(playerid, 54.000000, 151.000000, "Gunshot Alert!");
	PlayerTextDrawFont(playerid, ShotsTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, ShotsTD[playerid][2], 0.266666, 1.450000);
	PlayerTextDrawTextSize(playerid, ShotsTD[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ShotsTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, ShotsTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, ShotsTD[playerid][2], 1);
	PlayerTextDrawColour(playerid, ShotsTD[playerid][2], -1);
	PlayerTextDrawBackgroundColour(playerid, ShotsTD[playerid][2], 255);
	PlayerTextDrawBoxColour(playerid, ShotsTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, ShotsTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, ShotsTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, ShotsTD[playerid][2], 0);

	ShotsTD[playerid][3] = CreatePlayerTextDraw(playerid, 64.000000, 169.000000, "LOCATION:");
	PlayerTextDrawFont(playerid, ShotsTD[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, ShotsTD[playerid][3], 0.266666, 0.950000);
	PlayerTextDrawTextSize(playerid, ShotsTD[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ShotsTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, ShotsTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, ShotsTD[playerid][3], 1);
	PlayerTextDrawColour(playerid, ShotsTD[playerid][3], -1);
	PlayerTextDrawBackgroundColour(playerid, ShotsTD[playerid][3], 255);
	PlayerTextDrawBoxColour(playerid, ShotsTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, ShotsTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, ShotsTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, ShotsTD[playerid][3], 0);

	ShotsTD[playerid][4] = CreatePlayerTextDraw(playerid, 86.000000, 196.000000, "MARKET");
	PlayerTextDrawFont(playerid, ShotsTD[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, ShotsTD[playerid][4], 0.266666, 1.450000);
	PlayerTextDrawTextSize(playerid, ShotsTD[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ShotsTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, ShotsTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, ShotsTD[playerid][4], 2);
	PlayerTextDrawColour(playerid, ShotsTD[playerid][4], -1);
	PlayerTextDrawBackgroundColour(playerid, ShotsTD[playerid][4], 255);
	PlayerTextDrawBoxColour(playerid, ShotsTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, ShotsTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, ShotsTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, ShotsTD[playerid][4], 0);
	
	SPAWN[playerid][0] = CreatePlayerTextDraw(playerid, 317.500, 316.000, "Freeway");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][0], 0.238, 0.898);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][0], 2);
	PlayerTextDrawColour(playerid, SPAWN[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][0], 0);
	PlayerTextDrawFont(playerid, SPAWN[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][0], 1);

	SPAWN[playerid][1] = CreatePlayerTextDraw(playerid, 214.000, 374.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][1], 212.000, 10.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][1], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][1], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][1], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][1], 1);

	SPAWN[playerid][2] = CreatePlayerTextDraw(playerid, 318.500, 373.000, "LAST LOCATION");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][2], 0.228, 1.098);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][2], 2);
	PlayerTextDrawColour(playerid, SPAWN[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][2], 0);
	PlayerTextDrawFont(playerid, SPAWN[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][2], 1);

	SPAWN[playerid][3] = CreatePlayerTextDraw(playerid, 216.500, 372.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][3], 207.000, 15.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][3], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][3], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][3], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][3], 1);

	SPAWN[playerid][4] = CreatePlayerTextDraw(playerid, 281.500, 372.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][4], 73.000, 15.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][4], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][4], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][4], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][4], 1);

	SPAWN[playerid][5] = CreatePlayerTextDraw(playerid, 319.799, 334.000, "SPAWN");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][5], 0.448, 2.098);
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][5], 10.000, 32.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][5], 2);
	PlayerTextDrawColour(playerid, SPAWN[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][5], 0);
	PlayerTextDrawFont(playerid, SPAWN[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][5], 1);

	SPAWN[playerid][6] = CreatePlayerTextDraw(playerid, 274.500, 335.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][6], 91.000, 20.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][6], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][6], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][6], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][6], 1);

	SPAWN[playerid][7] = CreatePlayerTextDraw(playerid, 277.500, 331.500, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][7], 85.000, 26.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][7], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][7], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][7], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][7], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][7], 1);

	SPAWN[playerid][8] = CreatePlayerTextDraw(playerid, 382.500, 326.000, "LD_BEAT:up");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][8], 48.000, 25.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][8], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][8], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][8], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][8], 1);

	SPAWN[playerid][9] = CreatePlayerTextDraw(playerid, 382.500, 363.000, "LD_BEAT:up");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][9], 48.000, -25.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][9], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][9], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][9], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][9], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][9], 1);

	SPAWN[playerid][10] = CreatePlayerTextDraw(playerid, 355.500, 348.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][10], 12.000, 11.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][10], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][10], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][10], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][10], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][10], 1);

	SPAWN[playerid][11] = CreatePlayerTextDraw(playerid, 272.500, 348.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][11], 12.000, 11.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][11], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][11], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][11], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][11], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][11], 1);

	SPAWN[playerid][12] = CreatePlayerTextDraw(playerid, 272.500, 330.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][12], 12.000, 11.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][12], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][12], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][12], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][12], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][12], 1);

	SPAWN[playerid][13] = CreatePlayerTextDraw(playerid, 355.500, 330.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][13], 12.000, 11.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][13], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][13], 16744447);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][13], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][13], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][13], 1);

	SPAWN[playerid][14] = CreatePlayerTextDraw(playerid, 403.500, 335.000, ">");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][14], 0.388, 2.197);
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][14], 411.000, 20.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][14], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][14], 1);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][14], 1);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][14], 150);
	PlayerTextDrawFont(playerid, SPAWN[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][14], 1);

	SPAWN[playerid][15] = CreatePlayerTextDraw(playerid, 210.500, 326.000, "LD_BEAT:up");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][15], 48.000, 25.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][15], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][15], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][15], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][15], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][15], 1);

	SPAWN[playerid][16] = CreatePlayerTextDraw(playerid, 210.500, 363.000, "LD_BEAT:up");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][16], 48.000, -25.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][16], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][16], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][16], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][16], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][16], 1);

	SPAWN[playerid][17] = CreatePlayerTextDraw(playerid, 229.500, 335.000, "<");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][17], 0.388, 2.197);
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][17], 237.000, 20.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][17], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][17], 1);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][17], 1);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][17], 150);
	PlayerTextDrawFont(playerid, SPAWN[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, SPAWN[playerid][17], 1);

	SPAWN[playerid][18] = CreatePlayerTextDraw(playerid, 213.000, 371.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][18], 7.000, 7.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][18], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][18], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][18], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][18], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][18], 1);

	SPAWN[playerid][19] = CreatePlayerTextDraw(playerid, 213.000, 381.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][19], 7.000, 7.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][19], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][19], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][19], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][19], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][19], 1);

	SPAWN[playerid][20] = CreatePlayerTextDraw(playerid, 420.000, 381.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][20], 7.000, 7.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][20], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][20], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][20], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][20], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][20], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][20], 1);

	SPAWN[playerid][21] = CreatePlayerTextDraw(playerid, 420.000, 371.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SPAWN[playerid][21], 7.000, 7.000);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][21], 1);
	PlayerTextDrawColour(playerid, SPAWN[playerid][21], 255);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][21], 0);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][21], 0);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][21], 255);
	PlayerTextDrawFont(playerid, SPAWN[playerid][21], 4);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][21], 1);

	SPAWN[playerid][22] = CreatePlayerTextDraw(playerid, 320.500, 298.000, "AKRP ISLAND");
	PlayerTextDrawLetterSize(playerid, SPAWN[playerid][22], 0.428, 1.700);
	PlayerTextDrawAlignment(playerid, SPAWN[playerid][22], 2);
	PlayerTextDrawColour(playerid, SPAWN[playerid][22], -1);
	PlayerTextDrawSetShadow(playerid, SPAWN[playerid][22], 1);
	PlayerTextDrawSetOutline(playerid, SPAWN[playerid][22], 1);
	PlayerTextDrawBackgroundColour(playerid, SPAWN[playerid][22], 0);
	PlayerTextDrawFont(playerid, SPAWN[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, SPAWN[playerid][22], 1);

	VALO[playerid][0] = CreatePlayerTextDraw(playerid, 263.500, 374.000, "/");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][0], 1.859, 6.799);
	PlayerTextDrawTextSize(playerid, VALO[playerid][0], -10.000, 0.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][0], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][0], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][0], 1);

	VALO[playerid][1] = CreatePlayerTextDraw(playerid, 196.500, 422.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][1], 72.000, 5.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][1], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][1], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][1], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][1], 1);

	VALO[playerid][2] = CreatePlayerTextDraw(playerid, 283.500, 390.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][2], 72.000, 5.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][2], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][2], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][2], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][2], 1);

	VALO[playerid][3] = CreatePlayerTextDraw(playerid, 375.500, 374.000, "/");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][3], -1.850, 6.789);
	PlayerTextDrawTextSize(playerid, VALO[playerid][3], 10.000, 0.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][3], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][3], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][3], 1);

	VALO[playerid][4] = CreatePlayerTextDraw(playerid, 369.500, 422.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][4], 72.000, 5.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][4], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][4], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][4], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][4], 1);

	VALO[playerid][5] = CreatePlayerTextDraw(playerid, 284.000, 374.000, "_");
	PlayerTextDrawTextSize(playerid, VALO[playerid][5], 90.000, 90.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][5], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][5], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, VALO[playerid][5], 356);
	PlayerTextDrawSetPreviewRot(playerid, VALO[playerid][5], 0.000, 0.000, 0.000, 2.200);
	PlayerTextDrawSetPreviewVehCol(playerid, VALO[playerid][5], 0, 0);

	VALO[playerid][6] = CreatePlayerTextDraw(playerid, 260.000, 404.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][6], 3.000, 15.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][6], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][6], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][6], 1);

	VALO[playerid][7] = CreatePlayerTextDraw(playerid, 260.799, 405.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][7], 1.500, -3.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][7], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][7], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][7], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][7], 1);

	VALO[playerid][8] = CreatePlayerTextDraw(playerid, 255.000, 404.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][8], 3.000, 15.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][8], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][8], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][8], 1);

	VALO[playerid][9] = CreatePlayerTextDraw(playerid, 255.799, 405.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][9], 1.500, -3.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][9], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][9], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][9], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][9], 1);

	VALO[playerid][10] = CreatePlayerTextDraw(playerid, 250.000, 404.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][10], 3.000, 15.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][10], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][10], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][10], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][10], 1);

	VALO[playerid][11] = CreatePlayerTextDraw(playerid, 250.799, 405.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][11], 1.500, -3.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][11], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][11], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][11], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][11], 1);

	VALO[playerid][12] = CreatePlayerTextDraw(playerid, 233.000, 398.000, "50");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][12], 0.429, 2.199);
	PlayerTextDrawAlignment(playerid, VALO[playerid][12], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][12], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][12], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][12], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][12], 1);

	VALO[playerid][13] = CreatePlayerTextDraw(playerid, 230.000, 416.000, "AMMO");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][13], 0.150, 0.499);
	PlayerTextDrawAlignment(playerid, VALO[playerid][13], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][13], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][13], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][13], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][13], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][13], 1);

	VALO[playerid][14] = CreatePlayerTextDraw(playerid, 375.000, 387.000, "HEALTH : 100");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][14], 0.140, 1.099);
	PlayerTextDrawAlignment(playerid, VALO[playerid][14], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][14], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][14], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][14], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][14], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][14], 1);

	VALO[playerid][15] = CreatePlayerTextDraw(playerid, 375.000, 407.000, "ARMORY : 100");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][15], 0.140, 1.099);
	PlayerTextDrawAlignment(playerid, VALO[playerid][15], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][15], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][15], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][15], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][15], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][15], 1);

	VALO[playerid][16] = CreatePlayerTextDraw(playerid, 376.000, 397.000, "HELMET : 100");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][16], 0.140, 1.099);
	PlayerTextDrawAlignment(playerid, VALO[playerid][16], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][16], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][16], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][16], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][16], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][16], 1);

	VALO[playerid][17] = CreatePlayerTextDraw(playerid, 208.000, 399.000, "PARTICLE:lockonFire");
	PlayerTextDrawTextSize(playerid, VALO[playerid][17], 10.000, 12.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][17], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][17], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][17], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][17], 1);


    VALO[playerid][18] = CreatePlayerTextDraw(playerid, 213.000, 413.000, "AVERAGE");
    PlayerTextDrawLetterSize(playerid, VALO[playerid][18], 0.128, 0.699);
    PlayerTextDrawAlignment(playerid, VALO[playerid][18], 2);
    PlayerTextDrawColour(playerid, VALO[playerid][18], -1);
    PlayerTextDrawSetShadow(playerid, VALO[playerid][18], 1);
    PlayerTextDrawSetOutline(playerid, VALO[playerid][18], 1);
    PlayerTextDrawBackgroundColour(playerid, VALO[playerid][18], 0);
    PlayerTextDrawFont(playerid, VALO[playerid][18], 2);
    PlayerTextDrawSetProportional(playerid, VALO[playerid][18], 1);


    VALO[playerid][19] = CreatePlayerTextDraw(playerid, 208.899, 409.500, "LD_BEAT:chit");
    PlayerTextDrawTextSize(playerid, VALO[playerid][19], 8.300, -9.000);
    PlayerTextDrawAlignment(playerid, VALO[playerid][19], 1);
    PlayerTextDrawColour(playerid, VALO[playerid][19], -65281);
    PlayerTextDrawSetShadow(playerid, VALO[playerid][19], 0);
    PlayerTextDrawSetOutline(playerid, VALO[playerid][19], 0);
    PlayerTextDrawBackgroundColour(playerid, VALO[playerid][19], 255);
    PlayerTextDrawFont(playerid, VALO[playerid][19], 4);
    PlayerTextDrawSetProportional(playerid, VALO[playerid][19], 1);

	VALO[playerid][20] = CreatePlayerTextDraw(playerid, 416.000, 418.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][20], 3.000, -30.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][20], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][20], -65281);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][20], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][20], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][20], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][20], 1);

	VALO[playerid][21] = CreatePlayerTextDraw(playerid, 421.000, 391.000, "WATER >");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][21], 0.090, 0.699);
	PlayerTextDrawAlignment(playerid, VALO[playerid][21], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][21], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][21], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][21], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][21], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][21], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][21], 1);

	VALO[playerid][22] = CreatePlayerTextDraw(playerid, 421.000, 412.000, "< FOOD");
	PlayerTextDrawLetterSize(playerid, VALO[playerid][22], 0.090, 0.699);
	PlayerTextDrawAlignment(playerid, VALO[playerid][22], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][22], -1);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][22], 1);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][22], 1);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][22], 0);
	PlayerTextDrawFont(playerid, VALO[playerid][22], 2);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][22], 1);

	VALO[playerid][23] = CreatePlayerTextDraw(playerid, 438.000, 418.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, VALO[playerid][23], 3.000, -30.000);
	PlayerTextDrawAlignment(playerid, VALO[playerid][23], 1);
	PlayerTextDrawColour(playerid, VALO[playerid][23], 512819199);
	PlayerTextDrawSetShadow(playerid, VALO[playerid][23], 0);
	PlayerTextDrawSetOutline(playerid, VALO[playerid][23], 0);
	PlayerTextDrawBackgroundColour(playerid, VALO[playerid][23], 255);
	PlayerTextDrawFont(playerid, VALO[playerid][23], 4);
	PlayerTextDrawSetProportional(playerid, VALO[playerid][23], 1);



	WireTD[playerid][0] = CreatePlayerTextDraw(playerid, 73.000000, 286.000000, "_");
	PlayerTextDrawFont(playerid, WireTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, WireTD[playerid][0], 0.600000, 2.050002);
	PlayerTextDrawTextSize(playerid, WireTD[playerid][0], 305.000000, 122.000000);
	PlayerTextDrawSetOutline(playerid, WireTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, WireTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, WireTD[playerid][0], 2);
	PlayerTextDrawColour(playerid, WireTD[playerid][0], -1);
	PlayerTextDrawBackgroundColour(playerid, WireTD[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, WireTD[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, WireTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, WireTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, WireTD[playerid][0], 0);

	WireTD[playerid][1] = CreatePlayerTextDraw(playerid, 12.000000, 283.000000, "Kurosaki Madrazo has Wiretransferred");
	PlayerTextDrawFont(playerid, WireTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, WireTD[playerid][1], 0.191666, 1.150000);
	PlayerTextDrawTextSize(playerid, WireTD[playerid][1], 136.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, WireTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, WireTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, WireTD[playerid][1], 1);
	PlayerTextDrawColour(playerid, WireTD[playerid][1], -1);
	PlayerTextDrawBackgroundColour(playerid, WireTD[playerid][1], 255);
	PlayerTextDrawBoxColour(playerid, WireTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, WireTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, WireTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, WireTD[playerid][1], 0);

	WireTD[playerid][2] = CreatePlayerTextDraw(playerid, 12.000000, 294.000000, "$1000000");
	PlayerTextDrawFont(playerid, WireTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, WireTD[playerid][2], 0.191666, 1.150000);
	PlayerTextDrawTextSize(playerid, WireTD[playerid][2], 116.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, WireTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, WireTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, WireTD[playerid][2], 1);
	PlayerTextDrawColour(playerid, WireTD[playerid][2], 16711935);
	PlayerTextDrawBackgroundColour(playerid, WireTD[playerid][2], 255);
	PlayerTextDrawBoxColour(playerid, WireTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, WireTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, WireTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, WireTD[playerid][2], 0);

	WireTD[playerid][3] = CreatePlayerTextDraw(playerid, 52.000000, 294.000000, "to your bank account.");
	PlayerTextDrawFont(playerid, WireTD[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, WireTD[playerid][3], 0.191666, 1.150000);
	PlayerTextDrawTextSize(playerid, WireTD[playerid][3], 151.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, WireTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, WireTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, WireTD[playerid][3], 1);
	PlayerTextDrawColour(playerid, WireTD[playerid][3], -1);
	PlayerTextDrawBackgroundColour(playerid, WireTD[playerid][3], 255);
	PlayerTextDrawBoxColour(playerid, WireTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, WireTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, WireTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, WireTD[playerid][3], 0);


	HUD[playerid][0] = CreatePlayerTextDraw(playerid, 8.000, 254.000, "HUD:radar_girlfriend");
	PlayerTextDrawTextSize(playerid, HUD[playerid][0], 10.000, 11.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][0], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][0], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][0], 1);

	HUD[playerid][1] = CreatePlayerTextDraw(playerid, 20.000, 255.000, "100");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][1], 0.280, 0.898);
	PlayerTextDrawAlignment(playerid, HUD[playerid][1], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][1], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][1], 1);

	HUD[playerid][2] = CreatePlayerTextDraw(playerid, 8.000, 266.000, "HUD:radar_tshirt");
	PlayerTextDrawTextSize(playerid, HUD[playerid][2], 10.000, 11.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][2], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][2], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][2], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][2], 1);

	HUD[playerid][3] = CreatePlayerTextDraw(playerid, 20.000, 267.000, "100");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][3], 0.280, 0.898);
	PlayerTextDrawAlignment(playerid, HUD[playerid][3], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][3], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][3], 1);

	HUD[playerid][4] = CreatePlayerTextDraw(playerid, 14.500, 280.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, HUD[playerid][4], -3.000, 8.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][4], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][4], 2096890111);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][4], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][4], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][4], 1);

	HUD[playerid][5] = CreatePlayerTextDraw(playerid, 11.500, 278.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, HUD[playerid][5], 7.000, 12.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][5], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][5], 2096890111);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][5], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][5], 1);

	HUD[playerid][6] = CreatePlayerTextDraw(playerid, 7.500, 278.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, HUD[playerid][6], 7.000, 12.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][6], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][6], 2096890111);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][6], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][6], 1);

	HUD[playerid][7] = CreatePlayerTextDraw(playerid, 14.000, 278.000, "'");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][7], -0.389, 0.498);
	PlayerTextDrawTextSize(playerid, HUD[playerid][7], 26.000, -55.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][7], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][7], 2096890111);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][7], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][7], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][7], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][7], 1);

	HUD[playerid][8] = CreatePlayerTextDraw(playerid, 20.000, 279.000, "100");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][8], 0.280, 0.898);
	PlayerTextDrawAlignment(playerid, HUD[playerid][8], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][8], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][8], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][8], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][8], 1);

	HUD[playerid][9] = CreatePlayerTextDraw(playerid, 9.000, 291.000, "LD_BEAT:up");
	PlayerTextDrawTextSize(playerid, HUD[playerid][9], 8.000, 11.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][9], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][9], 512819199);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][9], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][9], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][9], 1);

	HUD[playerid][10] = CreatePlayerTextDraw(playerid, 8.000, 294.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, HUD[playerid][10], 10.000, 11.000);
	PlayerTextDrawAlignment(playerid, HUD[playerid][10], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][10], 512819199);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][10], 0);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][10], 255);
	PlayerTextDrawFont(playerid, HUD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][10], 1);

	HUD[playerid][11] = CreatePlayerTextDraw(playerid, 20.000, 294.000, "100");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][11], 0.280, 0.898);
	PlayerTextDrawAlignment(playerid, HUD[playerid][11], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][11], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][11], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][11], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][11], 1);

	HUD[playerid][12] = CreatePlayerTextDraw(playerid, 507, 98, "ID:1");
	PlayerTextDrawLetterSize(playerid, HUD[playerid][12], 0.388, 1.299);
	PlayerTextDrawAlignment(playerid, HUD[playerid][12], 1);
	PlayerTextDrawColour(playerid, HUD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, HUD[playerid][12], 1);
	PlayerTextDrawSetOutline(playerid, HUD[playerid][12], 1);
	PlayerTextDrawBackgroundColour(playerid, HUD[playerid][12], 0);
	PlayerTextDrawFont(playerid, HUD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, HUD[playerid][12], 1);


	PlayeridTD2[playerid] = CreatePlayerTextDraw(playerid, 517.000000, 340.000000, "ID: 666");
	PlayerTextDrawFont(playerid, PlayeridTD2[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayeridTD2[playerid], 0.162498, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayeridTD2[playerid], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, PlayeridTD2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayeridTD2[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayeridTD2[playerid], 2);
	PlayerTextDrawColour(playerid, PlayeridTD2[playerid], -1);
	PlayerTextDrawBackgroundColour(playerid, PlayeridTD2[playerid], 255);
	PlayerTextDrawBoxColour(playerid, PlayeridTD2[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayeridTD2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayeridTD2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayeridTD2[playerid], 0);

	#if defined Christmas
		EventTextdraw[playerid] = CreatePlayerTextDraw(playerid, 608.000000, 97.000000, "C0");
		PlayerTextDrawFont(playerid, EventTextdraw[playerid], 3);
		PlayerTextDrawLetterSize(playerid, EventTextdraw[playerid], 0.541665, 2.299998);
		PlayerTextDrawTextSize(playerid, EventTextdraw[playerid], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, EventTextdraw[playerid], 2);
		PlayerTextDrawSetShadow(playerid, EventTextdraw[playerid], 0);
		PlayerTextDrawAlignment(playerid, EventTextdraw[playerid], 3);
		PlayerTextDrawColour(playerid, EventTextdraw[playerid], SERVER_COLOR);
		PlayerTextDrawBackgroundColour(playerid, EventTextdraw[playerid], 255);
		PlayerTextDrawBoxColour(playerid, EventTextdraw[playerid], 50);
		PlayerTextDrawUseBox(playerid, EventTextdraw[playerid], 0);
		PlayerTextDrawSetProportional(playerid, EventTextdraw[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, EventTextdraw[playerid], 0);
	#endif
	ModernPlayerText[playerid][0] = CreatePlayerTextDraw(playerid, 270.000000, 403.000000, "Don PISIKITO DEV turns off the engine of the");
	PlayerTextDrawFont(playerid, ModernPlayerText[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, ModernPlayerText[playerid][0], 0.191667, 1.049998);
	PlayerTextDrawTextSize(playerid, ModernPlayerText[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ModernPlayerText[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, ModernPlayerText[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, ModernPlayerText[playerid][0], 1);
	PlayerTextDrawColour(playerid, ModernPlayerText[playerid][0], -1);
	PlayerTextDrawBackgroundColour(playerid, ModernPlayerText[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, ModernPlayerText[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, ModernPlayerText[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, ModernPlayerText[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, ModernPlayerText[playerid][0], 0);
	
	PROGRESS1[playerid][0] = CreatePlayerTextDraw(playerid, 261.000, 339.000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, PROGRESS1[playerid][0], 118.000, 18.000);
    PlayerTextDrawAlignment(playerid, PROGRESS1[playerid][0], 1);
    PlayerTextDrawColour(playerid, PROGRESS1[playerid][0], 255);
    PlayerTextDrawSetShadow(playerid, PROGRESS1[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, PROGRESS1[playerid][0], 0);
    PlayerTextDrawBackgroundColour(playerid, PROGRESS1[playerid][0], 255);
    PlayerTextDrawFont(playerid, PROGRESS1[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, PROGRESS1[playerid][0], 1);

    PROGRESS1[playerid][1] = CreatePlayerTextDraw(playerid, 261.799, 339.600, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, PROGRESS1[playerid][1], 0.699, 16.790);
    PlayerTextDrawAlignment(playerid, PROGRESS1[playerid][1], 1);
    PlayerTextDrawColour(playerid, PROGRESS1[playerid][1], 0xFF0000FF);
    PlayerTextDrawSetShadow(playerid, PROGRESS1[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, PROGRESS1[playerid][1], 0);
    PlayerTextDrawBackgroundColour(playerid, PROGRESS1[playerid][1], 255);
    PlayerTextDrawFont(playerid, PROGRESS1[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, PROGRESS1[playerid][1], 1);


	//548.000000, 153.000000

	_crTextTarget[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 388.000000, "Target Vehicle: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTextTarget[playerid], 2);
	PlayerTextDrawBackgroundColour(playerid, _crTextTarget[playerid], 255);
	PlayerTextDrawFont(playerid, _crTextTarget[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTextTarget[playerid], 0.500000, 1.600000);
	PlayerTextDrawColour(playerid, _crTextTarget[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTextTarget[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTextTarget[playerid], 1);

	_crTextSpeed[playerid] = CreatePlayerTextDraw(playerid, 190.000000, 410.000000, "Speed: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawBackgroundColour(playerid, _crTextSpeed[playerid], 255);
	PlayerTextDrawFont(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTextSpeed[playerid], 0.500000, 1.600000);
	PlayerTextDrawColour(playerid, _crTextSpeed[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTextSpeed[playerid], 1);

	_crTickets[playerid] = CreatePlayerTextDraw(playerid, 340.000000, 410.000000, "Tickets: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTickets[playerid], 1);
	PlayerTextDrawBackgroundColour(playerid, _crTickets[playerid], 255);
	PlayerTextDrawFont(playerid, _crTickets[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTickets[playerid], 0.500000, 1.600000);
	PlayerTextDrawColour(playerid, _crTickets[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTickets[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTickets[playerid], 1);

    NumberTD[playerid] = CreatePlayerTextDraw(playerid, 476.000000, 292.000000, "999999");
	PlayerTextDrawFont(playerid, NumberTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, NumberTD[playerid], 0.349999, 1.500000);
	PlayerTextDrawTextSize(playerid, NumberTD[playerid], 571.000000, 172.000000);
	PlayerTextDrawSetOutline(playerid, NumberTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, NumberTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, NumberTD[playerid], 2);
	PlayerTextDrawColour(playerid, NumberTD[playerid], -764862721);
	PlayerTextDrawBackgroundColour(playerid, NumberTD[playerid], 255);
	PlayerTextDrawBoxColour(playerid, NumberTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, NumberTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, NumberTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, NumberTD[playerid], 0);


    NumberTD22[playerid] = CreatePlayerTextDraw(playerid, 464.000000, 231.000000, "999999");
	PlayerTextDrawFont(playerid, NumberTD22[playerid], 1);
	PlayerTextDrawLetterSize(playerid, NumberTD22[playerid], 0.391665, 1.750000);
	PlayerTextDrawTextSize(playerid, NumberTD22[playerid], 586.500000, 68.000000);
	PlayerTextDrawSetOutline(playerid, NumberTD22[playerid], 1);
	PlayerTextDrawSetShadow(playerid, NumberTD22[playerid], 0);
	PlayerTextDrawAlignment(playerid, NumberTD22[playerid], 2);
	PlayerTextDrawColour(playerid, NumberTD22[playerid], -8388353);
	PlayerTextDrawBackgroundColour(playerid, NumberTD22[playerid], 255);
	PlayerTextDrawBoxColour(playerid, NumberTD22[playerid], 50);
	PlayerTextDrawUseBox(playerid, NumberTD22[playerid], 0);
	PlayerTextDrawSetProportional(playerid, NumberTD22[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, NumberTD22[playerid], 0);
	
	BLINK[playerid][0] = CreatePlayerTextDraw(playerid, 320.000, -51.000, "_");
	PlayerTextDrawLetterSize(playerid, BLINK[playerid][0], 0.209, 57.097);
	PlayerTextDrawAlignment(playerid, BLINK[playerid][0], 2);
	PlayerTextDrawColour(playerid, BLINK[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, BLINK[playerid][0], 1);
	PlayerTextDrawBoxColour(playerid, BLINK[playerid][0], -206);
	PlayerTextDrawSetShadow(playerid, BLINK[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, BLINK[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, BLINK[playerid][0], 0);
	PlayerTextDrawFont(playerid, BLINK[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, BLINK[playerid][0], 1);




	DEATH[playerid][0] = CreatePlayerTextDraw(playerid, 320.000, -51.000, "_");
	PlayerTextDrawLetterSize(playerid, DEATH[playerid][0], 0.209, 57.098);
	PlayerTextDrawAlignment(playerid, DEATH[playerid][0], 2);
	PlayerTextDrawColour(playerid, DEATH[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, DEATH[playerid][0], 1);
	PlayerTextDrawBoxColour(playerid, DEATH[playerid][0], 92);
	PlayerTextDrawSetShadow(playerid, DEATH[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, DEATH[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, DEATH[playerid][0], 0);
	PlayerTextDrawFont(playerid, DEATH[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, DEATH[playerid][0], 1);

	DEATH[playerid][1] = CreatePlayerTextDraw(playerid, 319.000, 137.000, "14:56");
	PlayerTextDrawLetterSize(playerid, DEATH[playerid][1], 0.509, 2.799);
	PlayerTextDrawTextSize(playerid, DEATH[playerid][1], 8.000, 10.000);
	PlayerTextDrawAlignment(playerid, DEATH[playerid][1], 2);
	PlayerTextDrawColour(playerid, DEATH[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, DEATH[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, DEATH[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, DEATH[playerid][1], 0);
	PlayerTextDrawFont(playerid, DEATH[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, DEATH[playerid][1], 1);

	DEATH[playerid][2] = CreatePlayerTextDraw(playerid, 320.000, 161.000, "LEFT BEFORE");
	PlayerTextDrawLetterSize(playerid, DEATH[playerid][2], 0.209, 1.098);
	PlayerTextDrawAlignment(playerid, DEATH[playerid][2], 2);
	PlayerTextDrawColour(playerid, DEATH[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, DEATH[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, DEATH[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, DEATH[playerid][2], 0);
	PlayerTextDrawFont(playerid, DEATH[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, DEATH[playerid][2], 1);

	DEATH[playerid][3] = CreatePlayerTextDraw(playerid, 322.000, 170.000, "BLEEDING OUT");
	PlayerTextDrawLetterSize(playerid, DEATH[playerid][3], 0.300, 1.999);
	PlayerTextDrawAlignment(playerid, DEATH[playerid][3], 2);
	PlayerTextDrawColour(playerid, DEATH[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, DEATH[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, DEATH[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, DEATH[playerid][3], 0);
	PlayerTextDrawFont(playerid, DEATH[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, DEATH[playerid][3], 1);

	BLACK[playerid][0] = CreatePlayerTextDraw(playerid, -73.000, -22.000, "_");
	PlayerTextDrawLetterSize(playerid, BLACK[playerid][0], 0.300, 60.700);
	PlayerTextDrawAlignment(playerid, BLACK[playerid][0], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, BLACK[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, BLACK[playerid][0], true);
	PlayerTextDrawBoxColour(playerid, BLACK[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, BLACK[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, BLACK[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, BLACK[playerid][0], 150);
	PlayerTextDrawFont(playerid, BLACK[playerid][0], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, BLACK[playerid][0], true);

	BanPlayerTD[playerid][0] = CreatePlayerTextDraw(playerid, 316.000000, 199.000000, "Amelia Chevron");
	PlayerTextDrawFont(playerid, BanPlayerTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, BanPlayerTD[playerid][0], 0.266666, 1.500000);
	PlayerTextDrawTextSize(playerid, BanPlayerTD[playerid][0], 400.000000, 292.500000);
	PlayerTextDrawSetOutline(playerid, BanPlayerTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, BanPlayerTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, BanPlayerTD[playerid][0], 2);
	PlayerTextDrawColour(playerid, BanPlayerTD[playerid][0], -65281);
	PlayerTextDrawBackgroundColour(playerid, BanPlayerTD[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, BanPlayerTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, BanPlayerTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, BanPlayerTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, BanPlayerTD[playerid][0], 0);

	BanPlayerTD[playerid][1] = CreatePlayerTextDraw(playerid, 316.000000, 226.000000, "192.0.0.1");
	PlayerTextDrawFont(playerid, BanPlayerTD[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, BanPlayerTD[playerid][1], 0.266666, 1.500000);
	PlayerTextDrawTextSize(playerid, BanPlayerTD[playerid][1], 400.000000, 292.500000);
	PlayerTextDrawSetOutline(playerid, BanPlayerTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, BanPlayerTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, BanPlayerTD[playerid][1], 2);
	PlayerTextDrawColour(playerid, BanPlayerTD[playerid][1], -65281);
	PlayerTextDrawBackgroundColour(playerid, BanPlayerTD[playerid][1], 255);
	PlayerTextDrawBoxColour(playerid, BanPlayerTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, BanPlayerTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, BanPlayerTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, BanPlayerTD[playerid][1], 0);

	BanPlayerTD[playerid][2] = CreatePlayerTextDraw(playerid, 316.000000, 253.000000, "Ashley Maddox");
	PlayerTextDrawFont(playerid, BanPlayerTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, BanPlayerTD[playerid][2], 0.266666, 1.500000);
	PlayerTextDrawTextSize(playerid, BanPlayerTD[playerid][2], 400.000000, 292.500000);
	PlayerTextDrawSetOutline(playerid, BanPlayerTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, BanPlayerTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, BanPlayerTD[playerid][2], TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawColour(playerid, BanPlayerTD[playerid][2], -65281);
	PlayerTextDrawBackgroundColour(playerid, BanPlayerTD[playerid][2], 255);
	PlayerTextDrawBoxColour(playerid, BanPlayerTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, BanPlayerTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, BanPlayerTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, BanPlayerTD[playerid][2], 0);

	BanPlayerTD[playerid][3] = CreatePlayerTextDraw(playerid, 316.000000, 279.000000, "01/28/2002");
	PlayerTextDrawFont(playerid, BanPlayerTD[playerid][3], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, BanPlayerTD[playerid][3], 0.266666, 1.500000);
	PlayerTextDrawTextSize(playerid, BanPlayerTD[playerid][3], 400.000000, 292.500000);
	PlayerTextDrawSetOutline(playerid, BanPlayerTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, BanPlayerTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, BanPlayerTD[playerid][3], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, BanPlayerTD[playerid][3], -65281);
	PlayerTextDrawBackgroundColour(playerid, BanPlayerTD[playerid][3], 255);
	PlayerTextDrawBoxColour(playerid, BanPlayerTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, BanPlayerTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, BanPlayerTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, BanPlayerTD[playerid][3], 0);

	BanPlayerTD[playerid][4] = CreatePlayerTextDraw(playerid, 316.000000, 305.000000, "HACKING");
	PlayerTextDrawFont(playerid, BanPlayerTD[playerid][4], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, BanPlayerTD[playerid][4], 0.183333, 1.500000);
	PlayerTextDrawTextSize(playerid, BanPlayerTD[playerid][4], 384.500000, 167.000000);
	PlayerTextDrawSetOutline(playerid, BanPlayerTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, BanPlayerTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, BanPlayerTD[playerid][4], TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawColour(playerid, BanPlayerTD[playerid][4], -65281);
	PlayerTextDrawBackgroundColour(playerid, BanPlayerTD[playerid][4], 255);
	PlayerTextDrawBoxColour(playerid, BanPlayerTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, BanPlayerTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, BanPlayerTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, BanPlayerTD[playerid][4], 0);

    SpeedPlayerTD[playerid][0] = CreatePlayerTextDraw(playerid, 638.000000, 433.000000, "_");
	PlayerTextDrawFont(playerid, SpeedPlayerTD[playerid][0], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpeedPlayerTD[playerid][0], 0.229166, 1.450000);
	PlayerTextDrawTextSize(playerid, SpeedPlayerTD[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpeedPlayerTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, SpeedPlayerTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, SpeedPlayerTD[playerid][0], TEXT_DRAW_ALIGN_RIGHT);
	PlayerTextDrawColour(playerid, SpeedPlayerTD[playerid][0], -1378294017);
	PlayerTextDrawBackgroundColour(playerid, SpeedPlayerTD[playerid][0], 100);
	PlayerTextDrawBoxColour(playerid, SpeedPlayerTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, SpeedPlayerTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, SpeedPlayerTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, SpeedPlayerTD[playerid][0], 0);
	
	LOGO[playerid][0] = CreatePlayerTextDraw(playerid, 572.000, 416.000, "V");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][0], 0.659, 2.698);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][0], -7.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][0], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][0], 6553855);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][0], 255);
	PlayerTextDrawFont(playerid, LOGO[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][0], 1);

	LOGO[playerid][1] = CreatePlayerTextDraw(playerid, 598.000, 400.000, "P");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][1], 0.459, 2.798);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][1], -7.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][1], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][1], 16423679);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][1], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][1], 0);
	PlayerTextDrawFont(playerid, LOGO[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][1], 1);

	LOGO[playerid][2] = CreatePlayerTextDraw(playerid, 561.000, 400.000, "A");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][2], 0.459, 2.798);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][2], -7.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][2], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][2], 16423679);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][2], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][2], 0);
	PlayerTextDrawFont(playerid, LOGO[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][2], 1);

	LOGO[playerid][3] = CreatePlayerTextDraw(playerid, 574.000, 400.000, "k");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][3], 0.449, 2.789);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][3], 0.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][3], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][3], -251662081);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][3], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][3], -1131442177);
	PlayerTextDrawFont(playerid, LOGO[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][3], 1);

	LOGO[playerid][4] = CreatePlayerTextDraw(playerid, 586.000, 400.000, "R");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][4], 0.459, 2.798);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][4], -7.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][4], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][4], 16423679);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][4], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][4], 0);
	PlayerTextDrawFont(playerid, LOGO[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][4], 1);

	LOGO[playerid][5] = CreatePlayerTextDraw(playerid, 587.000, 427.000, "5");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][5], 0.179, 1.199);
	PlayerTextDrawTextSize(playerid, LOGO[playerid][5], -7.000, 6.000);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][5], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][5], 255);
	PlayerTextDrawFont(playerid, LOGO[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][5], 1);

	LOGO[playerid][6] = CreatePlayerTextDraw(playerid, 290.000, 426.000, "ALL KERALA ROLEPLAY");
	PlayerTextDrawLetterSize(playerid, LOGO[playerid][6], 0.129, 0.899);
	PlayerTextDrawAlignment(playerid, LOGO[playerid][6], 1);
	PlayerTextDrawColour(playerid, LOGO[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, LOGO[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, LOGO[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGO[playerid][6], 255);
	PlayerTextDrawFont(playerid, LOGO[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, LOGO[playerid][6], 1);



	INTRO[playerid][0] = CreatePlayerTextDraw(playerid, -129.000, -28.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INTRO[playerid][0], 120.000, 496.000);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][0], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][0], 255);
	PlayerTextDrawFont(playerid, INTRO[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][0], 1);

	INTRO[playerid][1] = CreatePlayerTextDraw(playerid, 967.000, -28.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INTRO[playerid][1], -329.000, 496.000);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][1], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][1], 0);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][1], 255);
	PlayerTextDrawFont(playerid, INTRO[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][1], 1);

	INTRO[playerid][2] = CreatePlayerTextDraw(playerid, -90.000, 108.000, "A");
	PlayerTextDrawLetterSize(playerid, INTRO[playerid][2], 2.948, 20.700);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][2], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][2], 16423679);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][2], 1724754687);
	PlayerTextDrawFont(playerid, INTRO[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][2], 1);

	INTRO[playerid][3] = CreatePlayerTextDraw(playerid, -90.000, 108.000, "K");
	PlayerTextDrawLetterSize(playerid, INTRO[playerid][3], 2.948, 20.700);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][3], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][3], -1);
	PlayerTextDrawFont(playerid, INTRO[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][3], 1);

	INTRO[playerid][4] = CreatePlayerTextDraw(playerid, 671.000, 108.000, "RP");
	PlayerTextDrawLetterSize(playerid, INTRO[playerid][4], 2.948, 20.700);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][4], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][4], 16423679);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][4], 1);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][4], -1);
	PlayerTextDrawFont(playerid, INTRO[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][4], 1);

	INTRO[playerid][5] = CreatePlayerTextDraw(playerid, 272.000, 460.000, "ALL KERALA ROLEPLAY");
	PlayerTextDrawLetterSize(playerid, INTRO[playerid][5], 0.428, 1.098);
	PlayerTextDrawAlignment(playerid, INTRO[playerid][5], 1);
	PlayerTextDrawColour(playerid, INTRO[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, INTRO[playerid][5], 1);
	PlayerTextDrawSetOutline(playerid, INTRO[playerid][5], 1);
	PlayerTextDrawBackgroundColour(playerid, INTRO[playerid][5], 0);
	PlayerTextDrawFont(playerid, INTRO[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, INTRO[playerid][5], 1);




	//speedo
		
	SPEEDO[playerid][0] = CreatePlayerTextDraw(playerid, 422.000, 274.000, "199");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][0], 0.488, 2.398);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][0], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][0], 0);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][0], TEXT_DRAW_FONT_3);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][0], true);

	SPEEDO[playerid][1] = CreatePlayerTextDraw(playerid, 407.000, 306.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][1], 38.000, -1.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][1], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][1], 16777215);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][1], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][1], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][1], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][1], true);

	SPEEDO[playerid][2] = CreatePlayerTextDraw(playerid, 413.000, 294.000, "99");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][2], 0.159, 0.799);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][2], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][2], 16777215);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][2], 0);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][2], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][2], true);

	SPEEDO[playerid][3] = CreatePlayerTextDraw(playerid, 399.000, 294.000, "FUEL :");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][3], 0.128, 0.799);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][3], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][3], 16777215);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][3], 0);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][3], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][3], true);

	SPEEDO[playerid][4] = CreatePlayerTextDraw(playerid, 426.000, 296.000, "KM/H");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][4], 0.108, 0.499);
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][4], -10.000, 0.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][4], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][4], 1);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][4], 0);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][4], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][4], true);

	SPEEDO[playerid][5] = CreatePlayerTextDraw(playerid, 448.000, 302.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][5], 1.000, -13.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][5], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][5], -2686721);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][5], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][5], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][5], true);

	SPEEDO[playerid][6] = CreatePlayerTextDraw(playerid, 450.000, 265.000, "U");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][6], 0.128, 1.299);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][6], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][6], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][6], 150);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][6], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][6], true);

	SPEEDO[playerid][7] = CreatePlayerTextDraw(playerid, 446.000, 271.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][7], 5.000, 6.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][7], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][7], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][7], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][7], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][7], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][7], true);

	SPEEDO[playerid][8] = CreatePlayerTextDraw(playerid, 446.500, 268.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][8], 4.000, 3.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][8], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][8], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][8], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][8], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][8], true);

	SPEEDO[playerid][9] = CreatePlayerTextDraw(playerid, 446.898, 269.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][9], 3.000, 2.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][9], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][9], 255);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][9], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][9], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][9], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][9], true);

	SPEEDO[playerid][10] = CreatePlayerTextDraw(playerid, 446.500, 271.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][10], 4.000, 5.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][10], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][10], 255);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][10], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][10], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][10], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][10], true);

	SPEEDO[playerid][11] = CreatePlayerTextDraw(playerid, 452.000, 275.000, "U");
	PlayerTextDrawLetterSize(playerid, SPEEDO[playerid][11], 0.128, -0.800);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][11], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][11], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][11], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][11], 150);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][11], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][11], true);

	SPEEDO[playerid][12] = CreatePlayerTextDraw(playerid, 395.000, 303.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][12], -1.000, 5.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][12], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][12], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][12], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][12], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][12], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][12], true);

	SPEEDO[playerid][13] = CreatePlayerTextDraw(playerid, 396.000, 305.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][13], -1.000, 1.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][13], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][13], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][13], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][13], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][13], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][13], true);

	SPEEDO[playerid][14] = CreatePlayerTextDraw(playerid, 397.000, 303.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][14], 6.000, 5.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][14], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][14], -65281);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][14], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][14], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][14], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][14], true);

	SPEEDO[playerid][15] = CreatePlayerTextDraw(playerid, 397.000, 304.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][15], 5.000, 3.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][15], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][15], 255);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][15], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][15], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][15], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][15], true);

	SPEEDO[playerid][16] = CreatePlayerTextDraw(playerid, 438.000, 301.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, SPEEDO[playerid][16], 4.000, -32.000);
	PlayerTextDrawAlignment(playerid, SPEEDO[playerid][16], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SPEEDO[playerid][16], -16776961);
	PlayerTextDrawSetShadow(playerid, SPEEDO[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, SPEEDO[playerid][16], 0);
	PlayerTextDrawBackgroundColour(playerid, SPEEDO[playerid][16], 255);
	PlayerTextDrawFont(playerid, SPEEDO[playerid][16], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, SPEEDO[playerid][16], true);


		
    KILLFEED[playerid][0] = CreatePlayerTextDraw(playerid, 557.000, 195.000, ".......................................................................................");
    PlayerTextDrawLetterSize(playerid, KILLFEED[playerid][0], 0.150, 0.999);
    PlayerTextDrawAlignment(playerid, KILLFEED[playerid][0], TEXT_DRAW_ALIGN_CENTRE);
    PlayerTextDrawColour(playerid, KILLFEED[playerid][0], -1);
    PlayerTextDrawSetShadow(playerid, KILLFEED[playerid][0], 1);
    PlayerTextDrawSetOutline(playerid, KILLFEED[playerid][0], 1);
    PlayerTextDrawBackgroundColour(playerid, KILLFEED[playerid][0], 0);
    PlayerTextDrawFont(playerid, KILLFEED[playerid][0], 2);
    PlayerTextDrawSetProportional(playerid, KILLFEED[playerid][0], 1);
		
	CharTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 140.000, 79.000, "_");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][0], 0.600, 26.850);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][0], 298.500, 145.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][0], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][0], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][0], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][0], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][0], true);

	CharTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 140.000, 79.000, "_");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][1], 0.600, -0.048);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][1], 298.500, 145.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][1], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][1], 16744447);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][1], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][1], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][1], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][1], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][1], true);

	CharTextdraw[playerid][2] = CreatePlayerTextDraw(playerid, 139.000, 82.000, "Character Setup");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][2], 0.201, 1.149);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][2], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][2], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][2], 0);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][2], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][2], true);

	CharTextdraw[playerid][3] = CreatePlayerTextDraw(playerid, 69.000, 101.000, "Name: Emz Dejar");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][3], 0.187, 1.200);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][3], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][3], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][3], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][3], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][3], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][3], true);

	CharTextdraw[playerid][4] = CreatePlayerTextDraw(playerid, 69.000, 113.000, "Gender: Male");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][4], 0.187, 1.200);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][4], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][4], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][4], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][4], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][4], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][4], true);

	CharTextdraw[playerid][5] = CreatePlayerTextDraw(playerid, 69.000, 125.000, "Skin: 294");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][5], 0.187, 1.200);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][5], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][5], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][5], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][5], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][5], true);

	CharTextdraw[playerid][6] = CreatePlayerTextDraw(playerid, 69.000, 137.000, "Age: 24");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][6], 0.187, 1.200);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][6], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][6], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][6], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][6], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][6], true);

	CharTextdraw[playerid][7] = CreatePlayerTextDraw(playerid, 140.000, 155.000, "_");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][7], 0.600, -0.048);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][7], 298.500, 145.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][7], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][7], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][7], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][7], 1);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][7], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][7], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][7], true);

	CharTextdraw[playerid][8] = CreatePlayerTextDraw(playerid, 106.000, 159.000, "Choose Your Gender");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][8], 0.156, 0.999);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][8], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][8], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][8], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][8], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][8], true);

	CharTextdraw[playerid][9] = CreatePlayerTextDraw(playerid, 103.000, 176.000, "_");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][9], 0.574, 1.950);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][9], 295.500, 60.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][9], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][9], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][9], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][9], 12582911);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][9], 1);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][9], 12582911);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][9], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][9], true);

	CharTextdraw[playerid][10] = CreatePlayerTextDraw(playerid, 177.000, 176.000, "_");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][10], 0.574, 1.950);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][10], 295.500, 60.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][10], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][10], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][10], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][10], -16711681);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][10], 1);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][10], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][10], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][10], true);

	CharTextdraw[playerid][11] = CreatePlayerTextDraw(playerid, 89.000, 179.000, "Male");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][11], 0.265, 1.199);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][11], 130.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][11], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][11], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][11], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][11], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][11], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][11], true);

	CharTextdraw[playerid][12] = CreatePlayerTextDraw(playerid, 157.000, 179.000, "Female");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][12], 0.259, 1.190);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][12], 204.000, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][12], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][12], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][12], -16711681);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][12], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][12], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][12], true);

	CharTextdraw[playerid][13] = CreatePlayerTextDraw(playerid, 109.000, 200.000, "Choose Your Age");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][13], 0.165, 0.898);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][13], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][13], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][13], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][13], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][13], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][13], true);

	CharTextdraw[playerid][14] = CreatePlayerTextDraw(playerid, 102.698, 220.000, "<");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][14], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][14], 21.500, 60.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][14], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][14], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][14], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][14], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][14], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][14], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][14], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][14], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][14], true);

	CharTextdraw[playerid][15] = CreatePlayerTextDraw(playerid, 176.000, 220.000, ">");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][15], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][15], 21.500, 60.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][15], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][15], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][15], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][15], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][15], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][15], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][15], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][15], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][15], true);

	CharTextdraw[playerid][16] = CreatePlayerTextDraw(playerid, 109.000, 244.000, "Choose Your Skin");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][16], 0.155, 0.898);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][16], 211.500, 17.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][16], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][16], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][16], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][16], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][16], true);

	CharTextdraw[playerid][17] = CreatePlayerTextDraw(playerid, 103.000, 266.000, "<");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][17], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][17], 19.500, 60.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][17], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][17], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][17], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][17], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][17], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][17], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][17], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][17], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][17], true);

	CharTextdraw[playerid][18] = CreatePlayerTextDraw(playerid, 176.000, 266.000, ">");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][18], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][18], 16.500, 62.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][18], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][18], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][18], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][18], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][18], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][18], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][18], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][18], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][18], true);

	CharTextdraw[playerid][19] = CreatePlayerTextDraw(playerid, 68.000, 311.000, "AKRP v5");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][19], 0.170, 1.100);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][19], 211.500, 29.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][19], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][19], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][19], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][19], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][19], true);

	CharTextdraw[playerid][20] = CreatePlayerTextDraw(playerid, 234.000, 305.700, "CONFIRM");
	PlayerTextDrawLetterSize(playerid, CharTextdraw[playerid][20], 0.225, 1.600);
	PlayerTextDrawTextSize(playerid, CharTextdraw[playerid][20], 255.000, 36.000);
	PlayerTextDrawAlignment(playerid, CharTextdraw[playerid][20], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, CharTextdraw[playerid][20], -1);
	PlayerTextDrawUseBox(playerid, CharTextdraw[playerid][20], true);
	PlayerTextDrawBoxColour(playerid, CharTextdraw[playerid][20], 16744447);
	PlayerTextDrawSetShadow(playerid, CharTextdraw[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, CharTextdraw[playerid][20], 0);
	PlayerTextDrawBackgroundColour(playerid, CharTextdraw[playerid][20], 255);
	PlayerTextDrawFont(playerid, CharTextdraw[playerid][20], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, CharTextdraw[playerid][20], true);
	PlayerTextDrawSetSelectable(playerid, CharTextdraw[playerid][20], true);


	ClotheTD[playerid][0] = CreatePlayerTextDraw(playerid, 396.000, 356.000, ">");
	PlayerTextDrawLetterSize(playerid, ClotheTD[playerid][0], 0.733, 2.449);
	PlayerTextDrawTextSize(playerid, ClotheTD[playerid][0], 12.500, 12.000);
	PlayerTextDrawAlignment(playerid, ClotheTD[playerid][0], 2);
	PlayerTextDrawColour(playerid, ClotheTD[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, ClotheTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, ClotheTD[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, ClotheTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, ClotheTD[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, ClotheTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, ClotheTD[playerid][0], 1);

	ClotheTD[playerid][1] = CreatePlayerTextDraw(playerid, 241.000, 356.000, "<");
	PlayerTextDrawLetterSize(playerid, ClotheTD[playerid][1], 0.733, 2.449);
	PlayerTextDrawTextSize(playerid, ClotheTD[playerid][1], 16.500, 14.000);
	PlayerTextDrawAlignment(playerid, ClotheTD[playerid][1], 2);
	PlayerTextDrawColour(playerid, ClotheTD[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, ClotheTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, ClotheTD[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, ClotheTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, ClotheTD[playerid][1], 3);
	PlayerTextDrawSetProportional(playerid, ClotheTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, ClotheTD[playerid][1], 1);

	ClotheTD[playerid][2] = CreatePlayerTextDraw(playerid, 568.000, 397.000, "SELECT");
	PlayerTextDrawLetterSize(playerid, ClotheTD[playerid][2], 0.300, 1.450);
	PlayerTextDrawTextSize(playerid, ClotheTD[playerid][2], 21.000, 97.500);
	PlayerTextDrawAlignment(playerid, ClotheTD[playerid][2], 2);
	PlayerTextDrawColour(playerid, ClotheTD[playerid][2], 255);
	PlayerTextDrawUseBox(playerid, ClotheTD[playerid][2], 1);
	PlayerTextDrawBoxColour(playerid, ClotheTD[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, ClotheTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, ClotheTD[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, ClotheTD[playerid][2], -1);
	PlayerTextDrawFont(playerid, ClotheTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, ClotheTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, ClotheTD[playerid][2], 1);

	ClotheTD[playerid][3] = CreatePlayerTextDraw(playerid, 319.000, 379.000, "17");
	PlayerTextDrawLetterSize(playerid, ClotheTD[playerid][3], 0.433, 3.000);
	PlayerTextDrawTextSize(playerid, ClotheTD[playerid][3], 139.000, 166.000);
	PlayerTextDrawAlignment(playerid, ClotheTD[playerid][3], 2);
	PlayerTextDrawColour(playerid, ClotheTD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, ClotheTD[playerid][3], 1);
	PlayerTextDrawBoxColour(playerid, ClotheTD[playerid][3], 50);
	PlayerTextDrawSetShadow(playerid, ClotheTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, ClotheTD[playerid][3], 1);
	PlayerTextDrawBackgroundColour(playerid, ClotheTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, ClotheTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, ClotheTD[playerid][3], 1);



	// GPS
	PlayerInfo[playerid][pText][0] = CreatePlayerTextDraw(playerid, 54.817008, 425.833496, "Los Santos");
	PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][0], 0.229166, 1.450000);
	PlayerTextDrawTextSize(playerid, PlayerInfo[playerid][pText][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerInfo[playerid][pText][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][0], 1);
	PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][0], -1);
	PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][0], 100);
	PlayerTextDrawBoxColour(playerid, PlayerInfo[playerid][pText][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfo[playerid][pText][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfo[playerid][pText][0], 0);

	PlayerInfo[playerid][pText][1] = CreatePlayerTextDraw(playerid, 21.551994, 430.083251, "S"); // GPS
	PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][1], 0.229166, 1.450000);
	PlayerTextDrawTextSize(playerid, PlayerInfo[playerid][pText][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerInfo[playerid][pText][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][1], 2);
	PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][1], -2686721);
	PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][1], 100);
	PlayerTextDrawBoxColour(playerid, PlayerInfo[playerid][pText][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerInfo[playerid][pText][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerInfo[playerid][pText][1], 0);

    PlayerInfo[playerid][pText][6] = CreatePlayerTextDraw(playerid, 5.645705, 425.916625, "I");
    PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][6], 2);
    PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][6], 0.287499, 2.649996);
    PlayerTextDrawTextSize(playerid, PlayerInfo[playerid][pText][6], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][6], 1);
    PlayerTextDrawSetShadow(playerid, PlayerInfo[playerid][pText][6], 0);
    PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][6], 1);
    PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][6], -16776961);
    PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][6], 100);
    PlayerTextDrawBoxColour(playerid, PlayerInfo[playerid][pText][6], 50);
    PlayerTextDrawUseBox(playerid, PlayerInfo[playerid][pText][6], 0);
    PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][6], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerInfo[playerid][pText][6], 0);

    PlayerInfo[playerid][pText][7] = CreatePlayerTextDraw(playerid, 35.708663, 425.333221, "I");
    PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][7], 2);
    PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][7], 0.287499, 2.649996);
    PlayerTextDrawTextSize(playerid, PlayerInfo[playerid][pText][7], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][7], 1);
    PlayerTextDrawSetShadow(playerid, PlayerInfo[playerid][pText][7], 0);
    PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][7], 2);
    PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][7], -16776961);
    PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][7], 100);
    PlayerTextDrawBoxColour(playerid, PlayerInfo[playerid][pText][7], 50);
    PlayerTextDrawUseBox(playerid, PlayerInfo[playerid][pText][7], 0);
    PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][7], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerInfo[playerid][pText][7], 0);
	// End

	// HP & armor
	PlayerInfo[playerid][pText][3] = CreatePlayerTextDraw(playerid, 577.000000, 43.500000, "100");
	PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][3], 2);
	PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][3], 255);
	PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][3], 2);
	PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][3], 0.220000, 1.100000);
	PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][3], 1);

	PlayerInfo[playerid][pText][4] = CreatePlayerTextDraw(playerid, 577.000000, 65.500000, "100");
	PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][4], 2);
	PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][4], 255);
	PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][4], 2);
	PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][4], 0.220000, 1.100000);
	PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][4], -1);
	PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][4], 1);


	TurfTD[playerid][0] = CreatePlayerTextDraw(playerid, 10.732, 175.750, "Control:");
	PlayerTextDrawLetterSize(playerid, TurfTD[playerid][0], 0.252, 1.628);
	PlayerTextDrawAlignment(playerid, TurfTD[playerid][0], 1);
	PlayerTextDrawColour(playerid, TurfTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, TurfTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TurfTD[playerid][0], 1);
	PlayerTextDrawBackgroundColour(playerid, TurfTD[playerid][0], 0);
	PlayerTextDrawFont(playerid, TurfTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, TurfTD[playerid][0], 1);

	TurfTD[playerid][1] = CreatePlayerTextDraw(playerid, 10.281, 209.082, "Turf_Time:");
	PlayerTextDrawLetterSize(playerid, TurfTD[playerid][1], 0.201, 1.424);
	PlayerTextDrawAlignment(playerid, TurfTD[playerid][1], 1);
	PlayerTextDrawColour(playerid, TurfTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, TurfTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TurfTD[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, TurfTD[playerid][1], 0);
	PlayerTextDrawFont(playerid, TurfTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, TurfTD[playerid][1], 1);

	TurfTD[playerid][2] = CreatePlayerTextDraw(playerid, 10.281, 224.082, "Influence:");
	PlayerTextDrawLetterSize(playerid, TurfTD[playerid][2], 0.201, 1.424);
	PlayerTextDrawAlignment(playerid, TurfTD[playerid][2], 1);
	PlayerTextDrawColour(playerid, TurfTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, TurfTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, TurfTD[playerid][2], 1);
	PlayerTextDrawBackgroundColour(playerid, TurfTD[playerid][2], 0);
	PlayerTextDrawFont(playerid, TurfTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, TurfTD[playerid][2], 1);


    BelowNotTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000, 346.000, "PRESS ~P~N ~W~TO RESPAWN AVAILABLE IN 00:59");
	PlayerTextDrawLetterSize(playerid, BelowNotTD[playerid][0], 0.300, 1.500);
	PlayerTextDrawAlignment(playerid, BelowNotTD[playerid][0], 2);
	PlayerTextDrawColour(playerid, BelowNotTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, BelowNotTD[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, BelowNotTD[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, BelowNotTD[playerid][0], 150);
	PlayerTextDrawFont(playerid, BelowNotTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, BelowNotTD[playerid][0], 1);

	// Ammo notification
	PlayerInfo[playerid][pText][5] = CreatePlayerTextDraw(playerid, 521.000000, 63.000000, "30");
	PlayerTextDrawAlignment(playerid, PlayerInfo[playerid][pText][5], 2);
	PlayerTextDrawBackgroundColour(playerid, PlayerInfo[playerid][pText][5], 255);
	PlayerTextDrawFont(playerid, PlayerInfo[playerid][pText][5], 1);
	PlayerTextDrawLetterSize(playerid, PlayerInfo[playerid][pText][5], 0.270000, 1.300000);
	PlayerTextDrawColour(playerid, PlayerInfo[playerid][pText][5], -1446714113);
	PlayerTextDrawSetOutline(playerid, PlayerInfo[playerid][pText][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerInfo[playerid][pText][5], 1);
	
 
	LOGINTD[playerid][0] = CreatePlayerTextDraw(playerid, -66.000, 11.000, "PARTICLE:cloudmasked");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][0], 735.000, 410.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][0], 512819199);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][0], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][0], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][0], true);

	LOGINTD[playerid][1] = CreatePlayerTextDraw(playerid, -35.000, -46.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][1], 0.300, 59.699);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][1], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][1], 252515695);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][1], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][1], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][1], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][1], true);

	LOGINTD[playerid][2] = CreatePlayerTextDraw(playerid, 258.000, 121.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][2], 73.000, 15.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][2], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][2], 1163132671);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][2], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][2], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][2], true);

	LOGINTD[playerid][3] = CreatePlayerTextDraw(playerid, 256.000, 123.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][3], 77.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][3], 1163132671);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][3], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][3], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][3], true);

	LOGINTD[playerid][4] = CreatePlayerTextDraw(playerid, 319.500, 155.500, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][4], 0.400, 3.690);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][4], 12.000, 153.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][4], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][4], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][4], 943208703);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][4], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][4], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][4], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][4], true);

	LOGINTD[playerid][5] = CreatePlayerTextDraw(playerid, 261.000, 129.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][5], -6.000, 8.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][5], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][5], 1163132671);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][5], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][5], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][5], true);

	LOGINTD[playerid][6] = CreatePlayerTextDraw(playerid, 334.000, 129.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][6], -7.000, 8.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][6], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][6], 1163132671);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][6], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][6], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][6], true);

	LOGINTD[playerid][7] = CreatePlayerTextDraw(playerid, 334.000, 120.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][7], -7.000, 7.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][7], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][7], 1163132671);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][7], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][7], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][7], true);

	LOGINTD[playerid][8] = CreatePlayerTextDraw(playerid, 257.000, 114.000, "uthorization");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][8], 0.328, 1.598);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][8], -19.000, 0.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][8], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][8], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][8], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][8], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][8], TEXT_DRAW_FONT_3);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][8], true);

	LOGINTD[playerid][9] = CreatePlayerTextDraw(playerid, 240.000, 101.000, "A");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][9], 0.717, 3.898);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][9], -9.000, 0.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][9], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][9], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][9], 2);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][9], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][9], TEXT_DRAW_FONT_2);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][9], true);

	LOGINTD[playerid][10] = CreatePlayerTextDraw(playerid, 242.000, 154.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][10], 155.000, 36.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][10], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][10], 757935615);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][10], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][10], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][10], true);

	LOGINTD[playerid][11] = CreatePlayerTextDraw(playerid, 257.000, 162.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][11], 0.108, 2.299);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][11], 250.000, 16.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][11], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][11], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][11], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][11], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][11], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][11], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][11], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][11], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][11], true);

	LOGINTD[playerid][12] = CreatePlayerTextDraw(playerid, 257.000, 165.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][12], 0.259, 1.598);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][12], 257.000, 21.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][12], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][12], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][12], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][12], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][12], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][12], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][12], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][12], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][12], true);

	LOGINTD[playerid][13] = CreatePlayerTextDraw(playerid, 263.000, 159.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][13], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][13], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][13], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][13], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][13], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][13], true);

	LOGINTD[playerid][14] = CreatePlayerTextDraw(playerid, 263.000, 177.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][14], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][14], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][14], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][14], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][14], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][14], true);

	LOGINTD[playerid][15] = CreatePlayerTextDraw(playerid, 244.000, 177.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][15], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][15], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][15], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][15], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][15], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][15], true);

	LOGINTD[playerid][16] = CreatePlayerTextDraw(playerid, 244.000, 159.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][16], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][16], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][16], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][16], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][16], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][16], true);

	LOGINTD[playerid][17] = CreatePlayerTextDraw(playerid, 253.000, 162.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][17], 7.000, 8.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][17], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][17], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][17], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][17], true);

	LOGINTD[playerid][18] = CreatePlayerTextDraw(playerid, 253.000, 171.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][18], 8.000, 10.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][18], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][18], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][18], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][18], true);

	LOGINTD[playerid][19] = CreatePlayerTextDraw(playerid, 272.000, 160.000, "Username");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][19], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][19], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][19], 1280068863);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][19], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][19], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][19], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][19], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][19], true);

	LOGINTD[playerid][20] = CreatePlayerTextDraw(playerid, 272.000, 171.000, "Naju_Sir");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][20], 0.200, 0.999);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][20], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][20], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][20], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][20], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][20], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][20], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][20], true);

	LOGINTD[playerid][21] = CreatePlayerTextDraw(playerid, 319.500, 203.500, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][21], 0.400, 3.690);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][21], 12.000, 153.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][21], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][21], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][21], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][21], 943208703);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][21], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][21], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][21], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][21], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][21], true);

	LOGINTD[playerid][22] = CreatePlayerTextDraw(playerid, 242.000, 202.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][22], 155.000, 36.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][22], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][22], 757935615);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][22], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][22], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][22], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][22], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][22], true);

	LOGINTD[playerid][23] = CreatePlayerTextDraw(playerid, 257.000, 210.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][23], 0.108, 2.299);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][23], 250.000, 16.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][23], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][23], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][23], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][23], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][23], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][23], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][23], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][23], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][23], true);

	LOGINTD[playerid][24] = CreatePlayerTextDraw(playerid, 257.000, 213.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][24], 0.259, 1.598);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][24], 257.000, 21.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][24], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][24], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][24], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][24], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][24], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][24], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][24], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][24], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][24], true);

	LOGINTD[playerid][25] = CreatePlayerTextDraw(playerid, 263.000, 207.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][25], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][25], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][25], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][25], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][25], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][25], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][25], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][25], true);

	LOGINTD[playerid][26] = CreatePlayerTextDraw(playerid, 263.000, 225.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][26], 7.000, 8.500);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][26], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][26], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][26], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][26], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][26], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][26], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][26], true);

	LOGINTD[playerid][27] = CreatePlayerTextDraw(playerid, 244.000, 225.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][27], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][27], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][27], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][27], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][27], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][27], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][27], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][27], true);

	LOGINTD[playerid][28] = CreatePlayerTextDraw(playerid, 244.000, 207.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][28], 7.000, 9.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][28], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][28], 976894719);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][28], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][28], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][28], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][28], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][28], true);

	LOGINTD[playerid][29] = CreatePlayerTextDraw(playerid, 252.500, 213.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][29], 9.000, 11.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][29], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][29], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][29], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][29], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][29], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][29], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][29], true);

	LOGINTD[playerid][30] = CreatePlayerTextDraw(playerid, 253.500, 214.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][30], 7.000, 8.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][30], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][30], 1280068863);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][30], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][30], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][30], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][30], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][30], true);

	LOGINTD[playerid][31] = CreatePlayerTextDraw(playerid, 252.600, 219.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][31], 9.000, 10.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][31], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][31], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][31], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][31], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][31], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][31], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][31], true);

	LOGINTD[playerid][32] = CreatePlayerTextDraw(playerid, 270.000, 202.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][32], 127.000, 36.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][32], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][32], 741092607);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][32], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][32], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][32], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][32], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][32], true);
	PlayerTextDrawSetSelectable(playerid, LOGINTD[playerid][32], true);

	LOGINTD[playerid][33] = CreatePlayerTextDraw(playerid, 272.000, 208.000, "Enter password");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][33], 0.170, 0.799);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][33], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][33], 1280068863);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][33], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][33], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][33], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][33], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][33], true);

	LOGINTD[playerid][34] = CreatePlayerTextDraw(playerid, 255.500, 221.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][34], 3.000, 8.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][34], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][34], 1280068863);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][34], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][34], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][34], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][34], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][34], true);

	LOGINTD[playerid][35] = CreatePlayerTextDraw(playerid, 10.000, -242.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][35], -0.900, 51.099);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][35], 0.000, 18.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][35], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][35], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][35], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][35], 1228013567);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][35], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][35], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][35], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][35], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][35], true);

	LOGINTD[playerid][36] = CreatePlayerTextDraw(playerid, 240.000, 303.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][36], 11.000, -10.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][36], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][36], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][36], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][36], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][36], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][36], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][36], true);

	LOGINTD[playerid][37] = CreatePlayerTextDraw(playerid, 387.000, 304.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][37], 12.000, -12.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][37], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][37], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][37], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][37], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][37], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][37], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][37], true);

	LOGINTD[playerid][38] = CreatePlayerTextDraw(playerid, 240.000, 266.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][38], 13.000, -12.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][38], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][38], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][38], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][38], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][38], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][38], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][38], true);

	LOGINTD[playerid][39] = CreatePlayerTextDraw(playerid, 387.000, 266.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][39], 12.000, -12.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][39], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][39], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][39], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][39], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][39], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][39], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][39], true);

	LOGINTD[playerid][40] = CreatePlayerTextDraw(playerid, 246.000, 256.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][40], 147.000, 46.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][40], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][40], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][40], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][40], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][40], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][40], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][40], true);

	LOGINTD[playerid][41] = CreatePlayerTextDraw(playerid, 242.000, 260.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][41], 155.000, 37.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][41], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][41], 1146552319);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][41], 0);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][41], 0);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][41], 255);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][41], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][41], true);
	PlayerTextDrawSetSelectable(playerid, LOGINTD[playerid][41], true);

	LOGINTD[playerid][42] = CreatePlayerTextDraw(playerid, 306.000, 272.000, "LOGIN");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][42], 0.300, 1.500);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][42], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][42], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][42], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][42], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][42], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][42], TEXT_DRAW_FONT_3);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][42], true);

	LOGINTD[playerid][43] = CreatePlayerTextDraw(playerid, 371.500, -2.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][43], 0.019, 3.299);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][43], -30.000, 660.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][43], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][43], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][43], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][43], -640824180);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][43], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][43], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][43], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][43], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][43], true);

	LOGINTD[playerid][44] = CreatePlayerTextDraw(playerid, 290.500, 386.000, "ALL KERALA ROLEPLAY");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][44], 0.158, 0.898);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][44], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][44], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][44], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][44], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][44], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][44], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][44], true);

	LOGINTD[playerid][45] = CreatePlayerTextDraw(playerid, 30.000, -242.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][45], -0.900, 51.099);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][45], 0.000, 18.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][45], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][45], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][45], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][45], -640824180);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][45], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][45], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][45], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][45], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][45], true);

	LOGINTD[playerid][46] = CreatePlayerTextDraw(playerid, 10.000, 221.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][46], -0.900, 51.099);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][46], 0.000, 18.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][46], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][46], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][46], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][46], -640824180);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][46], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][46], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][46], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][46], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][46], true);

	LOGINTD[playerid][47] = CreatePlayerTextDraw(playerid, 30.000, 191.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][47], -0.900, 51.099);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][47], 0.000, 18.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][47], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][47], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][47], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][47], 1228013567);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][47], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][47], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][47], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][47], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][47], true);

	LOGINTD[playerid][48] = CreatePlayerTextDraw(playerid, 272.000, 219.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][48], 0.200, 0.999);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][48], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][48], -1);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][48], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][48], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][48], 0);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][48], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][48], true);

	LOGINTD[playerid][49] = CreatePlayerTextDraw(playerid, 50.000, 31.000, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][49], -0.900, 20.799);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][49], 0.000, 18.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][49], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][49], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][49], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][49], 1228013567);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][49], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][49], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][49], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][49], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][49], true);

	LOGINTD[playerid][50] = CreatePlayerTextDraw(playerid, 352.000, 64.500, "_");
	PlayerTextDrawLetterSize(playerid, LOGINTD[playerid][50], -2.928, -4.099);
	PlayerTextDrawTextSize(playerid, LOGINTD[playerid][50], 42.000, -587.000);
	PlayerTextDrawAlignment(playerid, LOGINTD[playerid][50], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LOGINTD[playerid][50], -1);
	PlayerTextDrawUseBox(playerid, LOGINTD[playerid][50], true);
	PlayerTextDrawBoxColour(playerid, LOGINTD[playerid][50], 1228013567);
	PlayerTextDrawSetShadow(playerid, LOGINTD[playerid][50], 1);
	PlayerTextDrawSetOutline(playerid, LOGINTD[playerid][50], 1);
	PlayerTextDrawBackgroundColour(playerid, LOGINTD[playerid][50], 150);
	PlayerTextDrawFont(playerid, LOGINTD[playerid][50], TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, LOGINTD[playerid][50], true);


	Streamer_ToggleIdleUpdate(playerid, true);

    init_notificationtext(playerid);
	GetPlayerName(playerid, PlayerInfo[playerid][pUsername], MAX_PLAYER_NAME);


	PlayerLabel[playerid] = CreateDynamic3DTextLabel("", -1, 0.0, 0.0, -1.5, 10, .attachedplayer = playerid, .testlos = 1);

    	



	PlayerTextDrawShow(playerid, INTRO[playerid][0]);
	PlayerTextDrawShow(playerid, INTRO[playerid][1]);
	PlayerTextDrawShow(playerid, INTRO[playerid][2]);
	PlayerTextDrawShow(playerid, INTRO[playerid][3]);
	PlayerTextDrawShow(playerid, INTRO[playerid][4]);
	PlayerTextDrawShow(playerid, INTRO[playerid][5]);
		

	
	gConnections++;
	SaveServerInfo();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Module_OnPlayerDisconnect(playerid, reason);
	TerminateInfo(playerid, reason);

	Iter_Clear(g_rgNotifUsed[playerid]);

	if(pool_valid(g_rgpNotificationQueue[playerid]))
		pool_delete_deep(g_rgpNotificationQueue[playerid]);

	for(new i = 0; i < 4; i ++)
	{
	    if(IsValidDynamicPickup(PlayerInfo[playerid][pZonePickups][i]))
	    {
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, PlayerInfo[playerid][pZonePickups][i], E_STREAMER_WORLD_ID, 99999);
	        DestroyDynamicPickup(PlayerInfo[playerid][pZonePickups][i]);
	    }
	}
	
	// BACKFIRE SYSTEM BY NAJU
	Player_Fire_Enabled[playerid] = false;
	Player_Key_Sprint_Time[playerid] = 0;
	if(PlayerInfo[playerid][pGangRadio] == 1)
	{
		CallRemoteFunction("LeaveFgVoiceChannel", "ii", playerid, 0);
	}
    if(PlayerInfo[playerid][pFactionRadio] == 1)
	{
		CallRemoteFunction("LeaveFgVoiceChannel", "ii", playerid, 1);
	}

    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    new szString[128];
    new ip[29];
    GetPVarString(playerid, "IP", ip , sizeof(ip));
    format(szString, sizeof(szString),"**EXIT >> `%s has exited the server [IP:`%s`]`**", name ,ip);
	SendDiscordMessage(17, szString);

	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "IndiHome"));
	DeletePVar(playerid, "IndiHome");
	return 1;
}

