CMD:toggle(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(tog)gle [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Textdraws, OOC, Global, Phone, Newbie, PortableRadio, Radio, Streams, News, Lands");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: SpawnCam, HUD, Admin, Helper, VIP, Faction, Gang, Whisper, PM, Turfs, Points, ChatAnim");
	}
	else if(!strcmp(params, "textdraws", true))
	{
	    if(!PlayerInfo[playerid][pToggleTextdraws])
	    {
	        HideGPSTextdraw(playerid);

            for(new j = 0; j < 24; j ++)
            {
               PlayerTextDrawHide(playerid, VALO[playerid][j]);
            }
			

			#if defined Christmas
  				PlayerTextDrawHide(playerid, EventTextdraw[playerid]);
			#endif

	        TextDrawHideForPlayer(playerid, TimeTD);

	        PlayerInfo[playerid][pToggleTextdraws] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Textdraws toggled. You will no longer see any textdraws.");
	    }
	    else
	    {
	        if(PlayerInfo[playerid][pGPSOn])
	        {
	            ShowGPSTextdraw(playerid);
	        }
	        if(PlayerInfo[playerid][pWatchOn])
	        {
	           TextDrawShowForPlayer(playerid, TimeTD);
	        }
            for(new j = 0; j < 24; j ++)
            {
               PlayerTextDrawShow(playerid, VALO[playerid][j]);
            }

			#if defined Christmas
  				PlayerTextDrawShow(playerid, EventTextdraw[playerid]);
			#endif

	        PlayerInfo[playerid][pToggleTextdraws] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Textdraws enabled. You will now see textdraws again.");
	    }
	}
	else if(!strcmp(params, "ooc", true))
	{
	    if(!PlayerInfo[playerid][pToggleOOC])
	    {
	        PlayerInfo[playerid][pToggleOOC] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "OOC chat toggled. You will no longer see any messages in /o.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleOOC] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "OOC chat enabled. You will now see messages in /o again.");
	    }
	}
	else if(!strcmp(params, "chatanim", true))
	{
	    if(!PlayerInfo[playerid][pChatAnim])
	    {
	        PlayerInfo[playerid][pChatAnim] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Chat animation enabled.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pChatAnim] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Chat animation disabled.");
	    }
	}
	else if(!strcmp(params, "global", true))
	{
	    if(!PlayerInfo[playerid][pToggleGlobal])
	    {
	        PlayerInfo[playerid][pToggleGlobal] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Global chat toggled. You will no longer see any messages in /g.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleGlobal] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Global chat enabled. You can now speak to other players in /g.");
	    }
	}
	else if(!strcmp(params, "phone", true))
	{
	    if(!PlayerInfo[playerid][pTogglePhone])
	    {
	        if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
	        {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't do this while in a call.");
	        }

	        PlayerInfo[playerid][pTogglePhone] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Phone toggled. You will no longer receive calls or texts.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pTogglePhone] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Phone enabled. You can now receive calls and texts again.");
	    }
	}
    else if(!strcmp(params, "admin", true))
	{
	    if(!PlayerInfo[playerid][pAdmin])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not an admin and therefore cannot toggle this feature.");
		}

	    if(!PlayerInfo[playerid][pToggleAdmin])
	    {
	        PlayerInfo[playerid][pToggleAdmin] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Admin chat toggled. You will no longer see any messages in admin chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleAdmin] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Admin chat enabled. You will now see messages in admin chat again.");
	    }
	}
	else if(!strcmp(params, "helper", true))
	{
	    if(!PlayerInfo[playerid][pHelper])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a helper and therefore cannot toggle this feature.");
		}

	    if(!PlayerInfo[playerid][pToggleHelper])
	    {
	        PlayerInfo[playerid][pToggleHelper] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Helper chat toggled. You will no longer see any messages in helper chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleHelper] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Helper chat enabled. You will now see messages in helper chat again.");
	    }
	}
	else if(!strcmp(params, "newbie", true))
	{
	    if(!PlayerInfo[playerid][pToggleNewbie])
	    {
	        PlayerInfo[playerid][pToggleNewbie] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Newbie chat toggled. You will no longer see any messages in newbie chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleNewbie] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Newbie chat enabled. You will now see messages in newbie chat again.");
	    }
	}
    else if(!strcmp(params, "portableradio", true))
	{
	    if(!PlayerInfo[playerid][pWalkieTalkie])
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Portable Radio.");
		}

	    if(!PlayerInfo[playerid][pToggleWT])
	    {
	        PlayerInfo[playerid][pToggleWT] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Portable Radio toggled. You will no longer receive any messages on your Portable Radio.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleWT] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Portable Radio enabled. You will now receive messages on your Portable Radio again.");
	    }
	}
	else if(!strcmp(params, "radio", true))
	{
 		if(PlayerInfo[playerid][pFaction] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a faction and therefore can't toggle your radio.");
		}

	    if(!PlayerInfo[playerid][pToggleRadio])
	    {
	        PlayerInfo[playerid][pToggleRadio] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Radio chat toggled. You will no longer receive any messages on your radio.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleRadio] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Radio chat enabled. You will now receive messages on your radio again.");
	    }
	}
	else if(!strcmp(params, "streams", true))
	{
	    if(!PlayerInfo[playerid][pToggleMusic])
	    {
	        PlayerInfo[playerid][pToggleMusic] = 1;
	        StopAudioStreamForPlayer(playerid);
	        SendClientMessage(playerid, COLOR_AQUA, "Music streams toggled. You will no longer hear any music played locally & globally.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleMusic] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Music streams enabled. You will now hear music played locally & globally again.");
	    }
	}
	else if(!strcmp(params, "vip", true))
	{
	    if(!PlayerInfo[playerid][pVIPPackage])
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a VIP member and therefore cannot toggle this feature.");
		}

	    if(!PlayerInfo[playerid][pToggleVIP])
	    {
	        PlayerInfo[playerid][pToggleVIP] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "VIP chat toggled. You will no longer see any messages in VIP chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleVIP] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "VIP chat enabled. You will now see messages in VIP chat again.");
	    }
	}
	else if(!strcmp(params, "faction", true))
	{
	    if(PlayerInfo[playerid][pFaction] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a faction and therefore can't toggle this chat.");
		}

	    if(!PlayerInfo[playerid][pToggleFaction])
	    {
	        PlayerInfo[playerid][pToggleFaction] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Faction chat toggled. You will no longer see any messages in faction chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleFaction] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Faction chat enabled. You will now see messages in faction chat again.");
	    }
	}
	else if(!strcmp(params, "gang", true))
	{
	    if(PlayerInfo[playerid][pGang] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not a gang member and therefore can't toggle this chat.");
		}

	    if(!PlayerInfo[playerid][pToggleGang])
	    {
	        PlayerInfo[playerid][pToggleGang] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Gang chat toggled. You will no longer see any messages in gang chat.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleGang] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Gang chat enabled. You will now see messages in gang chat again.");
	    }
	}
	else if(!strcmp(params, "news", true))
	{
	    if(!PlayerInfo[playerid][pToggleNews])
	    {
	        PlayerInfo[playerid][pToggleNews] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "News chat toggled. You will no longer see any news broadcasts.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleNews] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "News chat enabled. You will now see news broadcasts again.");
	    }
	}
	else if(!strcmp(params, "lands", true))
	{
	    callcmd::lands(playerid);
	}
	else if(!strcmp(params, "whisper", true))
	{
	    if(PlayerInfo[playerid][pToggleWhisper] == 0)
	    {
	        PlayerInfo[playerid][pToggleWhisper] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Whisper chat disabled. You have blocked all incoming whispers.");
		}
		else
		{
		    PlayerInfo[playerid][pToggleWhisper] = 0;
		    SendClientMessage(playerid, COLOR_AQUA, "Whisper chat enabled. You will now receive whisper messages again.");
		}
	}
	else if(!strcmp(params, "pm", true))
	{
	    if(PlayerInfo[playerid][pTogglePM] == 0)
	    {
	        PlayerInfo[playerid][pTogglePM] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "PM chat disabled. You have blocked all incoming private messages.");
		}
		else
		{
		    PlayerInfo[playerid][pTogglePM] = 0;
		    SendClientMessage(playerid, COLOR_AQUA, "PM chat enabled. You will now receive private messages again.");
		}
	}
	else if(!strcmp(params, "spawncam", true))
	{
	    if(!PlayerInfo[playerid][pToggleCam])
	    {
	        PlayerInfo[playerid][pToggleCam] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Spawn camera toggled. You will no longer see the camera effects upon spawning.");
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleCam] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Spawn camera enabled. You will now see the camera effects when you spawn again.");
	    }
	}
	else if(!strcmp(params, "hud", true))
	{
	    if(!PlayerInfo[playerid][pToggleHUD])
	    {
	        PlayerInfo[playerid][pToggleHUD] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "HUD toggled. You will no longer see your health & armor indicators.");

	        for(new j = 0; j < 24; j ++)
            {
               PlayerTextDrawHide(playerid, VALO[playerid][j]);
            }
            //PlayerText_InterpolateColor(playerid, VALO[playerid][19], 0, 500, EASE_OUT_QUAD);
            //PlayerText_MoveSize(playerid, VALO[playerid][20], 3.00, 0, 1000, EASE_OUT_QUAD);
            //PlayerText_MoveSize(playerid, VALO[playerid][23], 3.00, 0, 1000, EASE_OUT_QUAD);
	
	    }
	    else
	    {
	        PlayerInfo[playerid][pToggleHUD] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "HUD enabled. You will now see your health & armor indicators again.");
	        
            for(new j = 0; j < 24; j ++)
            {
          
               PlayerTextDrawShow(playerid, VALO[playerid][j]);
	        }
	    }
	}
	else if(!strcmp(params, "turfs", true))
	{
		if(!PlayerInfo[playerid][pShowTurfs])
		{
	    	ShowTurfsOnMap(playerid, true);
	    	ShowLandsOnMap(playerid, false);
	    	ShowPointsOnMap(playerid, false);
	    	SendClientMessage(playerid, COLOR_AQUA, "You will now see turfs on your mini-map.");
		}
		else
		{
	    	ShowTurfsOnMap(playerid, false);
	    	SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any turfs on your mini-map.");
		}
	}
    else if(!strcmp(params, "points", true))
	{
		if(!PlayerInfo[playerid][pShowPoints])
		{
	    	ShowPointsOnMap(playerid, true);
	    	ShowLandsOnMap(playerid, false);
	    	ShowTurfsOnMap(playerid, false);
	    	//GangZoneShowForPlayer(playerid, PointInfo[8][pGangZone],  0xFF00008C);
	    	SendClientMessage(playerid, COLOR_AQUA, "You will now see points on your mini-map.");
		}
		else
		{
	    	ShowPointsOnMap(playerid, false);
	    	SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any Points on your mini-map.");
		}
	}

	return 1;
}

CMD:removeskin(playerid, params[])
{
    if(PlayerInfo[playerid][pGender] == 1)
    {
	   SetPlayerSkin( playerid, 97 );
	}
	else if(PlayerInfo[playerid][pGender] == 2)
	{
    	SetPlayerSkin( playerid, 251 );
	}
	ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
    SetTimerEx("Skin", 750, false, "i", playerid);

	return 1;
}
CMD:refreshskin(playerid, params[])
{
    new
	    Float:x,
    	Float:y,
    	Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 0.5);

	ClearAnimations(playerid, SYNC_ALL);
	TogglePlayerControllable(playerid, true);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);

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
    return 1;
}
CMD:help(playerid, params[])
{
	new str[2084];
	strcat(str, ""SVRCLR"Help Commands:"WHITE" /report /reportdm (/newb)ie /tognewbie");

	strcat(str, ""SVRCLR"\nAccount Commands:"WHITE" /rules /serverstats /inventory /buylevel /upgrade /myupgrades /changepass /killcheckpoint");

	strcat(str, ""SVRCLR"\nChat Commands:"WHITE" /w(hisper) /o(oc) /s(hout) /l(ow) /b /ad(vertise) /f(amily) /me /toggc /togfam /togcrew /togwhisper /tognews");

	strcat(str, ""SVRCLR"\nBank Commands:"WHITE" /balance /withdraw /deposit /wiretransfer /abalance /awithdraw /adeposit /awiretransfer /houseinvite");

	strcat(str, ""SVRCLR"\nGeneral Commands:"WHITE" /pay /charity /time /buy /id /music /showlicenses /clothes /buyclothes /finddealership /locate");

	strcat(str, ""SVRCLR"\nGeneral Commands:"WHITE" /stopani /do /me /kill /drop /calculate /car /families /requesthelp /members /togchatanim");
	strcat(str, ""SVRCLR"\nGeneral Commands:"WHITE" /cancel /accept /eject /usepot /usecrack /blindfold /tie /contract /call /info /clearmyscreen\n");

	switch(PlayerInfo[playerid][pJob])
	{
	
		case JOB_COURIER: strcat(str, "\n"SVRCLR"Job Commands:"WHITE" /load, /deliver, /cancelcp.");

 	}

 	if(PlayerInfo[playerid][pSecondJob] != JOB_NONE)
 	{
 	    switch(PlayerInfo[playerid][pSecondJob])
		{
			
			case JOB_COURIER: strcat(str, "\n"SVRCLR"Secondary Commands:"WHITE" /load, /deliver.");

	 	}
	}
	strcat(str, "\n\n"SVRCLR"Other Commands:"WHITE" /cellphonehelp /carhelp /househelp /toyhelp /renthelp /jobhelp /leaderhelp /animhelp /fishhelp /insurehelp /businesshelp /bankhelp");
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, ""GREY"GENERAL HELP", str, "Okay", "");
}

CMD:phreward(playerid, params[])
{
	return ShowPlayerDialog(playerid, DIALOG_PHREWARD, DIALOG_STYLE_LIST, "Playing Hours Rewards", "5 Playing Hours\n15 Playing Hours\n45 Playing Hours\n80 Playing Hours\n130 Playing Hours\n170 Playing Hours\n230 Playing Hours\n300 Playing Hours", "Claim", "Close");
}

CMD:locate(playerid, params[])
{
	if(!PlayerInfo[playerid][pGPS])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a GPS. You can buy one at 24/7.");
	}
	if(isnull(params)) ShowDialogToPlayer(playerid, DIALOG_LOCATE);
	else LocateMethod(playerid, params);
	return 1;
}

CMD:findjob(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_WHITE, "This command is merged with [/locate], and if you want more jobs, use [/findsidejob]");
}

CMD:ccp(playerid, params[]) return callcmd::cancelcp(playerid, params);
CMD:kcp(playerid, params[]) return callcmd::cancelcp(playerid, params);
CMD:killcp(playerid, params[]) return callcmd::cancelcp(playerid, params);
CMD:killcheckpoint(playerid, params[]) return callcmd::cancelcp(playerid, params);
CMD:cancelcp(playerid, params[])
{
	CancelActiveCheckpoint(playerid);
	PlayerInfo[playerid][pRobCash] = 0;
	SendClientMessage(playerid, COLOR_WHITE, "You have cancelled all active checkpoints.");
	return 1;
}
CMD:raobj(playerid, params[])
{
	CancelActiveCheckpoint(playerid);
	PlayerInfo[playerid][pRobCash] = 0;
	RemovePlayerAttachedObject(playerid, 0);
	RemovePlayerAttachedObject(playerid, 9);
	return 1;
}


CMD:afk(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /afk [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	if(PlayerInfo[targetid][pAFK])
	{
	    SM(playerid, COLOR_WHITE, "** %s has been marked as Away from keyboard for %i minutes.", GetRPName(targetid), PlayerInfo[targetid][pAFKTime] / 60);
	}
	else
	{
	    SM(playerid, COLOR_WHITE, "** %s is currently not marked as Away from keyboard.", GetRPName(targetid));
	}

	return 1;
}

CMD:afklist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Away from Keyboard:");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAFK])
	    {
	        SM(playerid, COLOR_GREY2, "(ID: %i) %s - Time: %i seconds", i, GetRPName(i), PlayerInfo[i][pAFKTime]);
		}
	}

	return 1;
}

CMD:fixplayerid(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fixplayerid [playerid]");
	    SendClientMessage(playerid, COLOR_WHITE, "Sometimes player IDs can become bugged causing sscanf to not identify that ID until server restart.");
    	SendClientMessage(playerid, COLOR_WHITE, "(e.g. a command used upon a valid player ID saying the player is disconnected, invalid or offline.)");
        return 1;
	}
	if(IsPlayerConnected(targetid))
	{
		SSCANF_Join(targetid, GetPlayerNameEx(targetid), false);
	}

	SM(playerid, COLOR_WHITE, "** Player ID %i has been fixed.", targetid);
	return 1;
}

CMD:disablevpn(playerid, params[])
{
	new status;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /disablevpn [0/1]");
	}

	if(status) {
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disabled joining with VPN.", GetRPName(playerid));
	} else {
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has enabled joining with VPN.", GetRPName(playerid));
	}

	gDisabledVPN = status;
	return 1;
}
CMD:anticheat(playerid, params[])
{
	new status;

	if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /anticheat [0/1]");
	}

	if(status) {
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has enabled the server anticheat.", GetRPName(playerid));
	} else {
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has disabled the server anticheat.", GetRPName(playerid));
	}

	gAnticheat = status;
	return 1;
}

CMD:notifyenable(playerid, params[])
{
	new status;

	if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /notifyenable [0/1]");
	}

	if(status) {
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has enabled the server notification System.", GetRPName(playerid));
	} else {
		SAM(COLOR_LIGHTRED, "AdmCmd: %s has disabled the server notification System.", GetRPName(playerid));
	}

	gNotification = status;
	return 1;
}

CMD:animhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "** Animation: /dance, /wave, /point, /salute, /laugh, /cry, /deal, /sit, /lay, /fall, /handsup.");
	SendClientMessage(playerid, COLOR_WHITE, "** Animation: /tired, /cower, /crack, /injured, /fishing, /reload, /aim, /bomb, /checktime.");
	SendClientMessage(playerid, COLOR_WHITE, "** Animation: /dodge, /stop, /scratch, /what, /wash, /come, /hitch, /cpr, /slapass, /drunk.");
	SendClientMessage(playerid, COLOR_WHITE, "** Animation: /vomit, /fucku, /taichi, /shifty, /smoke, /chat, /lean, /wank, /crossarms.");
	SendClientMessage(playerid, COLOR_WHITE, "** Animation: /ghands, /rap, /dj, /walk, /fuckme, /bj, /kiss, /piss, /robman, /stopanim.");
	return 1;
}

CMD:dance(playerid, params[])
{
	if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
		    return notification_show(playerid, str_format("You're currently unable to use animations at this moment"),2000, NOTIF_ERROR);	
	    else
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}

	switch(strval(params))
	{
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
		default: 
		{   
			if(gNotification)
				notification_show(playerid, str_format("USAGE: /dance [1-4]"));	
			else
			    SendClientMessage(playerid, COLOR_WHITE, "USAGE: /dance [1-4]");
		}
	}
	return 1;
}

CMD:wave(playerid, params[])
{
	if(!PlayerUseAnims(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}

	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0);
	    case 2: ApplyAnimationEx(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0);
		case 3: ApplyAnimationEx(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0);
		default: 
		{
			if(gNotification)
				notification_show(playerid, str_format("USAGE: /wave [1-3]"));	
			else
			    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /wave [1-3]");
		}
	}

	return 1;
}

CMD:point(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}

	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_point", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0);
		default: 
		{
			if(gNotification)
			    notification_show(playerid, str_format("USAGE: /point [1-2]"));	
			else
				SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /point [1-2]");
		}
	}

	return 1;
}

CMD:salute(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}

	ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:laugh(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "RAPPING", "Laugh_01", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:cry(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:deal(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:bpfrisk(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("USAGE: /bpfrisk [playerid]"),2000);	
		else
	        return SCMf(playerid, COLOR_GREY, "USAGE:"WHITE" /bpfrisk [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" The player specified is disconnected or out of range.");
	}

	if(PlayerInfo[targetid][pBackpack] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" The player specified has no backpack with them.");

	if(IsLawEnforcement(playerid))
	{
	    BPFriskPlayer(playerid, targetid);
	}
	else
	{
	    PlayerInfo[targetid][pBPFriskOffer] = playerid;

	    SCMf(targetid, SERVER_COLOR, "** %s is attempting to search your backpack for illegal items. (/accept bpfrisk)", GetRPName(playerid));
	    SCMf(playerid, SERVER_COLOR, "** You have sent a backpack frisk offer to %s.", GetRPName(targetid));
	}
	return 1;
}

CMD:destroybackpacks(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return SendClientMessage(playerid, COLOR_ERROR, "You are not an admin.");

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
	    if(!IsValidDynamicObject(i) || Streamer_GetExtraInt(i, E_OBJECT_TYPE) != E_OBJECT_BACKPACK)
			continue;

		new Text3D:textid = Text3D:Streamer_GetExtraInt(i, E_OBJECT_3DTEXT_ID);

        if(IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }

	    DestroyDynamicObject(i);
	}

	SAM(COLOR_ERROR, "AdmWarning: %s destroyed all dropped backpacks.", GetPlayerNameEx(playerid));
	return 1;
}

CMD:inspectbackpack(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You need to be onfoot in order to pickup weapons.");

    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You can't use this command at the moment.");

	new count, i = -1;

	if((i = IsPlayerInRangeOfBackpack(playerid, 2.0)) != -1) {

		for(new j = 0; j < 15; j ++)
		{
			if(BackpackData[i][bp_Weapon][j])
			{
				count++;
			}
		}

		SCMf(playerid, SERVER_COLOR, "Backpack Content (ID: %d):", i);
		SCMf(playerid, COLOR_GREY2, "(Cash: $%i) | (Materials: %i) | (Weapons: %i)", BackpackData[i][bp_Cash], BackpackData[i][bp_Materials], count);
		SCMf(playerid, COLOR_GREY2, "(Pot: %ig) | (Crack: %ig)", BackpackData[i][bp_Pot], BackpackData[i][bp_Crack]);
		SCMf(playerid, COLOR_GREY2, "(Meth: %ig) | (Painkillers: %i pills)", BackpackData[i][bp_Meth], BackpackData[i][bp_Painkillers]);
		if(count > 0)
		{
			SendClientMessage(playerid, COLOR_ERROR, "Weapons:");
			for(new x = 0; x < 15; x++)
			{
				if(BackpackData[i][bp_Weapon][x])
				{
					SCMf(playerid, COLOR_GREY2, "[%d] %s (Ammo: %d)", x + 1, GetWeaponNameEx(BackpackData[i][bp_Weapon][x]), BackpackData[i][bp_Ammo][x]);
				}
			}
		}
	    return 1;
	}

	SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You are not in range of any dropped backpacks.");
	return 1;
}
CMD:removebags(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	for(new i = 0; i < 100; i ++){
      if(IsValidDynamic3DTextLabel(BackpackData[i][bpLabel]))
      {
            DestroyDynamic3DTextLabel(BackpackData[i][bpLabel]);
      }
	  DestroyDynamicObject(BackpackData[i][bpObject]);
	}
	return 0;
}
	    
CMD:removecorpses1(playerid, params[])
{
	new corpse;
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	   if(gNotification)
			return notification_show(playerid, str_format("You are not authorized to use this command."),2000, NOTIF_ERROR);
		else		
	        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}

	for(new i = 0; i < MAX_CORPS; i ++)
	{
		RemoveCorpse(i);
	    corpse++;
	}
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has remove all corpses", GetRPName(playerid));
	return 1;
}
CMD:war(playerid, params[])
{
	new string[64];
	if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
    {
         return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /war [war chat]");
	}
	if(PlayerInfo[playerid][pGang] == -1 || PlayerInfo[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not rank 5+ in any gang at the moment.");
	}
	if(gettime() - PlayerInfo[playerid][pLastWar] < 30)
	{
	    return SM(playerid, COLOR_SYNTAX, "You can only speak in this channel every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerInfo[playerid][pLastWar]));
	}
	if(PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while dead.");
	}
	if(PlayerInfo[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while cuffed");
	}
	if(PlayerInfo[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command while tied.");
	}
	if(!enabledGlobal1 && PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The war channel is disabled at the moment.");
	}
	if(PlayerInfo[playerid][pGlobalMuted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are muted from speaking in this channel.");
	}
    if(PlayerInfo[playerid][pToggleGlobal])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the war chat as you have it toggled.");
	}

    if(PlayerInfo[playerid][pGang] >= 0) {
	format(string, sizeof(string), "[WAR] [%s]", GangInfo[PlayerInfo[playerid][pGang]][gName]);
	} else {
        string = "War";
	}

	foreach(new i : Player)
	{
		if(!PlayerInfo[i][pToggleGlobal])
		{
		    if(strlen(params) > MAX_SPLIT_LENGTH)
		    {
		        SM(i, COLOR_YELLOW, " %s %s: %.*s... ", string, GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SM(i, COLOR_YELLOW, " %s %s: ...%s ", string, GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SM(i, COLOR_YELLOW, " %s %s: %s ", string, GetRPName(playerid), params);
			}
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 6 && !PlayerInfo[playerid][pFormerAdmin])
	{
		PlayerInfo[playerid][pLastWar] = gettime();
	}

	return 1;
}

CMD:pay(playerid, params[])
{
    new targetid, amount;

    if(sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pay [playerid] [amount]");
    }
    if(gettime() - PlayerInfo[playerid][pLastPay] < 3)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Please wait three seconds between each transaction.");
    }
    if(PlayerInfo[playerid][pAdminDuty] == 1)
    {
	   SAM(COLOR_RED, "%s Ee Admin on aduty  pay akkan noki", GetRPName(playerid));
       return SendClientMessage(playerid, COLOR_SYNTAX, "Admin Bro You Are Idiot");
    }
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
    }
    if(targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't pay yourself.");
    }
    if(amount > PlayerInfo[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much.");
    }
    if(!(1 <= amount <= 100000000))
    {
        return SM(playerid, COLOR_SYNTAX, "Don't go below $1, or above $100000000 at once.");
    }
    if(amount < 1)
    {
        return SM(playerid, COLOR_SYNTAX, "Invalid amount");
    }

    PlayerInfo[playerid][pLastPay] = gettime();

    GivePlayerCash(playerid, -amount);
    GivePlayerCash(targetid, amount);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);

    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s takes out $%i and gives it to %s.", GetRPName(playerid), amount, GetRPName(targetid));
    //Log_Write("log_give", "%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));

    new szString[128];
	format(szString, sizeof(szString),"%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), amount, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));
	SendDiscordMessage(12, szString);
	
    SM(targetid, COLOR_AQUA, "You have been given $%i by %s.", amount, GetRPName(playerid));
    SM(playerid, COLOR_AQUA, "You have given "SVRCLR"$%i{CCFFFF} to %s.", amount, GetRPName(targetid));

    if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
    {
        SAM(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has given $%i to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(targetid), GetPlayerIP(targetid));
    }
    return 1;
}
CMD:grabbackpack(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You need to be onfoot in order to pickup weapons.");

    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You can't use this command at the moment.");

	if(PlayerInfo[playerid][pBackpack] > 0)
		return SendClientMessage(playerid, COLOR_ERROR, "You already have a backpack! Drop it first before picking up this one.");

	new i = -1;
	if((i = IsPlayerInRangeOfBackpack(playerid, 2.0)) != -1) {

		for(new j = 0; j < 15; j++) {
			PlayerInfo[playerid][bpWeapons][j] = BackpackData[i][bp_Weapon][j];
			PlayerInfo[playerid][bpAmmo][j] = BackpackData[i][bp_Ammo][j];
		}

		PlayerInfo[playerid][pBackpack] = BackpackData[i][bp_Backpack];
		PlayerInfo[playerid][bpCash] = BackpackData[i][bp_Cash];
		PlayerInfo[playerid][bpMaterials] = BackpackData[i][bp_Materials];
		PlayerInfo[playerid][bpPot] = BackpackData[i][bp_Pot];
		PlayerInfo[playerid][bpCrack] = BackpackData[i][bp_Crack];
		PlayerInfo[playerid][bpMeth] = BackpackData[i][bp_Meth];
		PlayerInfo[playerid][bpPainkillers] = BackpackData[i][bp_Painkillers];

        if(IsValidDynamic3DTextLabel(BackpackData[i][bpLabel]))
        {
            DestroyDynamic3DTextLabel(BackpackData[i][bpLabel]);
        }

	    DestroyDynamicObject(BackpackData[i][bpObject]);
		SendProximityMessage(playerid, 20.0, COLOR_GLOBAL, "**{C2A2DA} %s picks up a backup from the ground.", GetRPName(playerid));
		SendClientMessage(playerid, COLOR_NEWBIE, "You have picked up a backpack");
		ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
	    return 1;
	}

	SendClientMessage(playerid, COLOR_ERROR, "Error:"WHITE" You are not in range of any dropped backpacks.");
	return 1;
}
CMD:sit(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0);
	    case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 0, 0, 0, 1, 0);
	    case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
	    case 5: ApplyAnimationEx(playerid, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
     	case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0);
       	case 7: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0);
       	case 8: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0);
       	case 9: ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Eat1", 4.1, 1, 0, 0, 0, 0);
       	case 10: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 0, 0, 0, 1, 0);
	    default:
		{
            if(gNotification)
			    return notification_show(playerid, str_format("Usage: /sit [1-10]"));	
		    else
			    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sit [1-10]");
		} 
		
	}

	return 1;
}

CMD:lay(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /lay [1-3]");
	}

	return 1;
}

CMD:fall(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0);
	    case 2: ApplyAnimationEx(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0);
	    case 3: ApplyAnimationEx(playerid, "PED", "KO_shot_face", 4.1, 0, 1, 1, 1, 0);
	    case 4: ApplyAnimationEx(playerid, "PED", "KO_shot_front", 4.1, 0, 1, 1, 1, 0);
	    case 5: ApplyAnimationEx(playerid, "PED", "KO_shot_stom", 4.1, 0, 1, 1, 1, 0);
	    case 6: ApplyAnimationEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fall [1-6]");
	}

	return 1;
}

CMD:handsup(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "SHOP", "SHP_HandsUp_Scr", 4.1, 0, 0, 0, 1, 0);
	return 1;
}

CMD:tired(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /tired [1-2]");
	}

	return 1;
}

CMD:hide(playerid, params[])
{
	return callcmd::cower(playerid, params);
}

CMD:cover(playerid, params[])
{
	return callcmd::cower(playerid, params);
}

CMD:cower(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:crack(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);
        case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0);
        case 4: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /crack [1-4]");
	}

	return 1;
}

CMD:injured(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "SWAT", "gnstwall_injurd", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /injured [1-2]");
	}

	return 1;
}

CMD:reload(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0);
        case 4: ApplyAnimationEx(playerid, "RIFLE", "RIFLE_load", 4.1, 0, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /reload [1-4]");
	}

	return 1;
}

CMD:aim(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "SHOP", "ROB_loop", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /aim [1-2]");
	}

	return 1;
}

CMD:bomb(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:checktime(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:dodge(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "DODGE", "Crush_Jump", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:stop(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PED", "endchat_01", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:scratch(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "MISC", "Scratchballs_01", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:what(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:wash(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:come(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "WUZI", "Wuzi_follow", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:hitch(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "MISC", "Hiker_Pose", 4.1, 0, 0, 0, 1, 0);
	return 1;
}

CMD:cpr(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:slapass(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:drunk(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:vomit(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:fucku(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:taichi(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:shifty(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:smoke(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /smoke [1-2]");
	}

	return 1;
}

CMD:chat(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkA", 4.1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkB", 4.1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkC", 4.1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkD", 4.1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkE", 4.1, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkF", 4.1, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkG", 4.1, 1, 1, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkH", 4.1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /chat [1-9]");
	}

	return 1;
}

CMD:lean(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "GANGS", "leanIDLE", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "MISC", "Plyrlean_loop", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /lean [1-2]");
	}

	return 1;
}

CMD:wank(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:traffic(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /traffic [1-2]");
	}

	return 1;
}

CMD:rap(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "RAPPING", "RAP_A_LOOP", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "RAPPING", "RAP_B_LOOP", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "RAPPING", "RAP_C_LOOP", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rap [1-3]");
	}

	return 1;
}

CMD:dj(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0);
        case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /dj [1-4]");
	}

	return 1;
}

CMD:crossarms(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0);
	    case 2: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /crossarms [1-3]");
	}

	return 1;
}

CMD:ghands(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0);
		case 3: ApplyAnimationEx(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0);
		case 4: ApplyAnimationEx(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0);
		case 5: ApplyAnimationEx(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0);
        case 6: ApplyAnimationEx(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0);
		case 7: ApplyAnimationEx(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0);
		case 8: ApplyAnimationEx(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0);
		case 9: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0);
		case 10: ApplyAnimationEx(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ghands [1-10]");
	}

	return 1;
}

CMD:walk(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "PED", "WALK_shuffle", 4.1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimationEx(playerid, "PED", "WALK_Wuzi", 4.1, 1, 1, 1, 1, 1);
		case 11: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1);
		case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1);
		case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1);
		case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1);
		case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walkpro", 4.1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /walk [1-15]");
	}

	return 1;
}

CMD:fuckme(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "SNM", "SPANKING_IDLEW", 4.1, 0, 1, 1, 1, 0);
		case 2: ApplyAnimationEx(playerid, "SNM", "SPANKING_IDLEP", 4.1, 0, 1, 1, 1, 0);
		case 3: ApplyAnimationEx(playerid, "SNM", "SPANKINGW", 4.1, 0, 1, 1, 1, 0);
		case 4: ApplyAnimationEx(playerid, "SNM", "SPANKINGP", 4.1, 0, 1, 1, 1, 0);
		case 5: ApplyAnimationEx(playerid, "SNM", "SPANKEDW", 4.1, 0, 1, 1, 1, 0);
		case 6: ApplyAnimationEx(playerid, "SNM", "SPANKEDP", 4.1, 0, 1, 1, 1, 0);
		case 7: ApplyAnimationEx(playerid, "SNM", "SPANKING_ENDW", 4.1, 0, 1, 1, 1, 0);
		case 8: ApplyAnimationEx(playerid, "SNM", "SPANKING_ENDP", 4.1, 0, 1, 1, 1, 0);
        default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /fuckme [1-8]");
	}

	return 1;
}

CMD:bj(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	switch(strval(params))
	{
	    case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 0, 1, 1, 1, 0);
		case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 0, 1, 1, 1, 0);
		case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 0, 1, 1, 1, 0);
		case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 0, 1, 1, 1, 0);
		case 5: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_END_P", 4.1, 0, 1, 1, 1, 0);
		case 6: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_END_W", 4.1, 0, 1, 1, 1, 0);
		case 7: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 0, 1, 1, 1, 0);
		case 8: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 0, 1, 1, 1, 0);
		case 9: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0);
		case 10: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0);
		case 11: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 0, 1, 1, 1, 0);
		case 12: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 0, 1, 1, 1, 0);
        default: SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /bj [1-12]");
	}

	return 1;
}

CMD:kiss(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
    switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0);
		case 3: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0);
		case 4: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0);
		case 5: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0);
		case 6: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /kiss [1-6]");
	}
    return 1;
}

CMD:robman(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
    ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:stopani(playerid, params[])
{
	return callcmd::stopanim(playerid, params);
}

CMD:stopanim(playerid, params[])
{
    if(!PlayerUseAnims(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use this command at this moment.");
	}

    PlayerInfo[playerid][pLoopAnim] = 0;

   	ClearAnimations(playerid, SYNC_ALL);
	TextDrawHideForPlayer(playerid, AnimationTD);

	ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    SendClientMessage(playerid, COLOR_SYNTAX, "Animations cleared.");
    return 1;
}

CMD:gmx(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gmx [confirm]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command save all player accounts and restarts the server.");
	    return 1;
	}
	if(gGMX)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have already called for a server restart. You can't cancel it.");
	}

	gGMX = 1;

	foreach(new i : Player)
	{
	    Maskara[i] = 0;
	    if(i != playerid)
	    {
     		if(PlayerInfo[i][pAdminDuty])
			{
	    	    callcmd::aduty(i);
			}
			PlayerInfo[i][pHurt] = 0;
	    	TogglePlayerControllable(i, 0);
	    	SM(i, COLOR_AQUA, "** %s has initated a server restart. You have been frozen.", GetRPName(playerid));
		}
		SavePlayerVariables(i);
		GameTextForPlayer(i, "~w~Updating server...", 4000, 3);
	}

	SendClientMessage(playerid, COLOR_WHITE, "** The server will restart once all accounts have been saved.");
	return 1;
}

CMD:changepass(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "Change password", "Enter your new password:", "Submit", "Cancel");
	return 1;
}

CMD:toys(playerid, params[]) return callcmd::clothing(playerid, params);
CMD:clothes(playerid, params[]) return callcmd::clothing(playerid, params);
CMD:clothing(playerid, params[])
{
	new string[MAX_PLAYER_CLOTHING * 64];

	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists])
	    {
	        if(ClothingInfo[playerid][i][cAttached]) {
				format(string, sizeof(string), "%s\n{C8C8C8}%i) "SVRCLR"%s {FFD700}(Attached)", string, i + 1, ClothingInfo[playerid][i][cName]);
			} else {
			    format(string, sizeof(string), "%s\n{C8C8C8}%i) "SVRCLR"%s"WHITE"", string, i + 1, ClothingInfo[playerid][i][cName]);
	        }
		}
		else
		{
			format(string, sizeof(string), "%s\n{C8C8C8}%i) {AFAFAF}Empty Slot"WHITE"", string, i + 1);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, "My clothing items", string, "Select", "Cancel");
	return 1;
}

CMD:wat(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    ClothingInfo[playerid][i][cAttached] = 1;
	    SetPlayerClothing(playerid);
	}
}

CMD:dat(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
	    {
	        RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex]);
		}
	}
}

CMD:taketest(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1824.496704, -1426.201660, 13.655930))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the desk in the Licensing department.");
	}
	if(PlayerInfo[playerid][pCarLicense])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have your drivers license already.");
	}
	if(PlayerInfo[playerid][pDrivingTest])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already taking your drivers test.");
	}
	if(PlayerInfo[playerid][pCash] < 100)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need $100 to pay the licensing fee if you pass the test.");
	}

	SendClientMessage(playerid, COLOR_WHITE, "** You've taken on the drivers test. Go outside and enter one of the vehicles to begin.");
	SendClientMessage(playerid, COLOR_WHITE, "** Once you have passed the test, you will receive your license and pay a $100 licensing fee.");

	PlayerInfo[playerid][pTestVehicle] = INVALID_VEHICLE_ID;
	PlayerInfo[playerid][pDrivingTest] = 1;
	PlayerInfo[playerid][pTestCP] = 0;
	return 1;
}

CMD:buyvehicle(playerid)
{
	static string[4096];
	PlayerInfo[playerid][pGangCar] = 0;

	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to buy a vehicle in dealership while on-duty, bobo!", GetRPName(playerid));
	}

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1494.422973, 758.040588, 11.130325))
	{
  		string = "Category\tVehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(strcmp(vehicleArray[i][carCategory], "Boats") != 0 && strcmp(vehicleArray[i][carCategory], "Aircraft") != 0 && strcmp(vehicleArray[i][carCategory], "Rent") != 0)
	  		{
		    	format(string, sizeof(string), "%s\n%s\t%s\t"SVRCLR"%s"WHITE"", string, vehicleArray[i][carCategory], vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		PlayerInfo[playerid][pGangCar] = 0;
		ShowPlayerDialog(playerid, DIALOG_BUYVEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Grotti Dealership", string, "Buy", "Cancel");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 154.2223, -1946.3030, 5.1920))
	{
    	string = "Vehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(!strcmp(vehicleArray[i][carCategory], "Boats"))
	  		{
		    	format(string, sizeof(string), "%s\n%s\t"SVRCLR"%s"WHITE"", string, vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BUYBOAT, DIALOG_STYLE_TABLIST_HEADERS, "Boat Dealership", string, "Buy", "Cancel");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1892.6315, -2328.6721, 13.5469))
	{
     	string = "Vehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(!strcmp(vehicleArray[i][carCategory], "Aircraft"))
	  		{
		    	format(string, sizeof(string), "%s\n%s\t"SVRCLR"%s"WHITE"", string, vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BUYAIRCRAFT, DIALOG_STYLE_TABLIST_HEADERS, "Aircraft Dealership", string, "Buy", "Cancel");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any dealership.");
	}
	return 1;
}
CMD:buyrentvehicle(playerid, params[])
{
	static string[4096];
	PlayerInfo[playerid][pRentCar] = 0;

	if(PlayerInfo[playerid][pAdminDuty])
	{
	    return SAM(COLOR_RED, "%s has attempted to buy a vehicle in dealership while on-duty, bobo!", GetRPName(playerid));
	}

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1494.422973, 758.040588, 11.130325))
	{
  		string = "Category\tVehicle\tPrice";

		for(new i = 0; i < sizeof(vehicleArray); i ++)
	  	{
	  		if(!strcmp(vehicleArray[i][carCategory], "Rent"))
	  		{
		    	format(string, sizeof(string), "%s\n%s\t%s\t"SVRCLR"%s"WHITE"", string, vehicleArray[i][carCategory], vehicleNames[vehicleArray[i][carModel] - 400], FormatNumber(vehicleArray[i][carPrice]));
			}
		}
		PlayerInfo[playerid][pRentCar] = 1;
		ShowPlayerDialog(playerid, DIALOG_BUYRENTVEH, DIALOG_STYLE_TABLIST_HEADERS, "Grotti Dealership", string, "Buy", "Cancel");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any dealership.");
	}
	return 1;
}
