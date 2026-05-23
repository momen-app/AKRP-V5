DCMD:players(user, channel, params[]) {

    new szDialog[(1024 * 2)], title[128];

	foreach(new i : Player)
	{
		format(szDialog, sizeof(szDialog), "```%s(%d) - %s - %d - %s\n```", szDialog, i, ReturnName(i), GetPlayerPing(i), IsPlayerAndroid(i) ? ("Mobile") : ("PC/Desktop"));
	}

	format(title, sizeof(title), "> %s (%d/%d)", SERVER_NAME, Iter_Count(Player), MAX_PLAYERS);
	DCC_SendChannelMessage(channel, title);
	DCC_SendChannelMessage(channel, szDialog);
    return 1;
}

DCMD:ip(user, channel, params[])
{
	//DCC_SendChannelMessage(channel, "> Original IP:``178.128.216.41:8999");
	new chan[500], str[1500];
    format(str, sizeof(str), "178.128.216.41:8999", chan);
    new DCC_Embed:embed = DCC_CreateEmbed("Original IP Adress", str);
    DCC_SetEmbedColor(embed, 0xFFFF00);
    return DCC_SendChannelEmbedMessage(channel, embed);
}

SendTurfAdminMessage(turfid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
		SAM(color, text);
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4


		SAM(color, str);
		printf("Trufid %i",turfid);
		#emit RETN
	}
	return 1;
}

SendPointAdminMessage(pointid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
		SAM(color, text);
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4


		SAM(color, str);
		printf("pointid %i",pointid);
		#emit RETN
	}
	return 1;
}
stock ReturnName(playerid)
{
    new
        color, sz_playerName[MAX_PLAYER_NAME];

    if(!isnull(PlayerInfo[playerid][pUsername]))
    {
        if((color = GetPlayerColor(playerid)) == 0xFFFFFF00)
        {
            color = 0xAAAAAAFF;
        }
        format(sz_playerName, sizeof(sz_playerName), "{%06x}%s", color >>> 8, PlayerInfo[playerid][pUsername]);
    }
    else
    {
        GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
    }
    return sz_playerName;
}

forward OnQueryFinish(threadid, playerid);
public OnQueryFinish(threadid, playerid)
{
    new rows = SQL_GetRows();
    switch(threadid)
    {
        case THREAD_SELECT_CODE:
		{
		    if(!rows)
		    {
                new DCC_Channel:channell = DCC_FindChannelById("911933062533742612");
				new str[500];

		        format(str, sizeof(str), "The code you've been submitting is either invalid or used to an account that is now verified.");
				new DCC_Embed:embed = DCC_CreateEmbed("Invalid Code!", str);
				DCC_SetEmbedColor(embed, 0xFF0000);
                DCC_SendChannelEmbedMessage(channell, embed);
		    }
		    else
		    {
                new DCC_User:user = DCC_FindUserByName(DiscordInfo[dcName], DiscordInfo[dcTag]);//DCC_FindUserById(DiscordInfo[dcId]);
                new DCC_Guild:guild = DCC_FindGuildById("911932751115063296"); // Now to get the guild ID //
                new DCC_Role:role = DCC_FindRoleById("911933029264543804"); // Verified Role
                new DCC_Role:role1 = DCC_FindRoleById("911933029910470737"); // Unverified Role
                new string[128];
                new username[MAX_PLAYER_NAME];
                new code[16];
                
		        SQL_GetString(0, "username", username);
		        SQL_GetString(0, "code", code);
                PlayerInfo[MAX_PLAYERS][pID] = SQL_GetInt(0, "uid");
                PlayerInfo[MAX_PLAYERS][pVerified] = SQL_GetInt(0, "verify");

                if(IsPlayerOnline(username))
                {
                    SendClientMessage(PlayerInfo[MAX_PLAYERS][pID], COLOR_GREEN, "You are now verified.");
                    PlayerInfo[MAX_PLAYERS][pVerified] = 1;
                }
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET verify = 1 WHERE username = '%e'", username);
				mysql_tquery(connectionID, queryBuffer);
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET discordname = '%e', discordtag = '%e' WHERE username = '%e'", DiscordInfo[dcName], DiscordInfo[dcTag], username);
	            mysql_tquery(connectionID, queryBuffer);
                DCC_AddGuildMemberRole(guild, user, role);
                DCC_RemoveGuildMemberRole(guild, user, role1);
                format(string, sizeof(string), "%s", username);
                DCC_SetGuildMemberNickname(guild, user, string);
                DiscordInfo[dcId] = 0;
                DiscordInfo[dcName] = 0;
                DiscordInfo[dcTag] = 0;
		    }
		}
    }
    return 1;
}
CMD:buydress(playerid) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 609.618225, -1520.496215, 15.205955)) return 1;
    if(PlayerInfo[playerid][pCash] < 4000)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
    }


    SetPlayerPos(playerid,609.618225, -1520.496215, 15.205955);
    SetPlayerFacingAngle(playerid, 29.44);
    ResetClotheSetup(playerid);
	SelectTextDraw(playerid, COLOR_AQUA);
	for (new i = 0; i < 4; i ++) {
		PlayerTextDrawShow(playerid, ClotheTD[playerid][i]);
	}
	return 1;
}
CMD:hidedressmenu(playerid) {
	    new businessid = GetNearbyBusinessEx(playerid);

	    if(businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
	    {
	        if(BusinessInfo[businessid][bProducts] <= 0)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "This business is out of stock.");
	        }
	        if(PlayerInfo[playerid][pDonator] == 0 && PlayerInfo[playerid][pCash] < 4000)
	        {
	   			for (new i = 0; i < 4; i ++) {
					PlayerTextDrawHide(playerid, ClotheTD[playerid][i]);
				}
		    	CancelSelectTextDraw(playerid);
	            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy new clothes.");
	        }
			if(PlayerInfo[playerid][pDonator] == 0)
			{
			    new price = 4000;

				GivePlayerCash(playerid, -price);

	            if(PlayerInfo[playerid][pTraderUpgrade] > 0)
	            {
					price -= percent(price, (PlayerInfo[playerid][pTraderUpgrade] * 10));
					SM(playerid, COLOR_YELLOW, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerInfo[playerid][pTraderUpgrade], price);
	            }

				BusinessInfo[businessid][bCash] += price;
	        	BusinessInfo[businessid][bProducts]--;

	        	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	        	mysql_tquery(connectionID, queryBuffer);

	     		SM(playerid, COLOR_WHITE, "You've changed your clothes for $%i.", price);
	        }
	        else
	        {
                SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You changed your clothes free of charge.");
			}
			for (new i = 0; i < 4; i ++) {
               PlayerTextDrawHide(playerid, ClotheTD[playerid][i]);
            }
	    	//SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
  		    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
  		    SetScriptSkin(playerid, PlayerInfo[playerid][pSkin]);
  		    CancelSelectTextDraw(playerid);
        }
	    for (new i = 0; i < 4; i ++) {
		    PlayerTextDrawHide(playerid, ClotheTD[playerid][i]);
        }
         //SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
        SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
        SetScriptSkin(playerid, PlayerInfo[playerid][pSkin]);
        CancelSelectTextDraw(playerid);
	    //ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHES);
  	     //ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHES, "Clothes Shop", clothesShopSkins, sizeof(clothesShopSkins));
        return 1;
}
CMD:settitle(playerid, params[])
{
	new targetid, option[14], param[128];
	if(PlayerInfo[playerid][pAdmin] < 8)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[14]S()[128]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /settitle [playerid] [option]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of options: Name, Color");
		return 1;
	}
	if(!strcmp(option, "name", true))
	{
	    if(isnull(param) || strlen(params) > 32)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /settitle [playerid] [name] [text ('none' to reset)]");
		}

		strcpy(PlayerInfo[targetid][pCustomTitle], param, 64);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET customtitle = '%e' WHERE uid = %i", param, PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the customtitle of %s to '%s'.", GetRPName(playerid), GetRPName(targetid), param);
	}
    else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /settitle [playerid] [color] [0xRRGGBBAA]");
		}

		PlayerInfo[targetid][pCustomTColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET customcolor = %i WHERE uid = %i", PlayerInfo[targetid][pCustomTColor], PlayerInfo[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SAM(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of %s's title.", GetRPName(playerid), color >>> 8, GetRPName(targetid));
	}
	return 1;
}

