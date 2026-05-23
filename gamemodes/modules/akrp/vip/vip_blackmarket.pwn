CMD:v(playerid, params[])
{
	return callcmd::vip(playerid, params);
}

CMD:vip(playerid, params[])
{
	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(!enabledVip)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The VIP Chat is disabled by an administrator.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(v)ip [vip chat]");
	}
    if(PlayerInfo[playerid][pToggleVIP])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the VIP chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pVIPPackage] > 0 && !PlayerInfo[i][pToggleVIP])
	    {
			SM(i, COLOR_VIP, "** %s Donator %s: %s **", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:viplocker(playerid, params[]) return callcmd::donatorlocker(playerid, params);
CMD:donatorlocker(playerid, params[])
{
	if(PlayerInfo[playerid][pHours] < 2 || PlayerInfo[playerid][pWeaponRestricted] > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use this as you're currently restricted from possessing weapons!");
    if(PlayerInfo[playerid][pVIPPackage] != 3)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a Platinum VIP subscription.");
	}
	new str[1024];
    if(IsPlayerInRangeOfPoint(playerid, 3, 1996.903808, 1003.976501, 994.468750))
    {
		strcat(str, ""SVRCLR""SERVER_NAME"\n");
		strcat(str, ""WHITE"Donator System\n\n");
		strcat(str, ""YELLOW"Features:\n");
		strcat(str, ""WHITE"Below Platinum Donator can still buy guns in the locker.\n");
	//	strcat(str, "Platinum Donator can get Full Weapon Set by using [/vweapons].\n");
		//strcat(str, ""RED"Next Update:\n");
		strcat(str, "Donators now have their own hospital for some specific reasons.\n");
		strcat(str, "You will be immune with the global chat cooldown.\n");
		strcat(str, "A title will be set to you whenever you're a donator.\n");
		strcat(str, "Donator will gain more paycheck than normal players\n\n");
		strcat(str, ""GREEN"All rights reserved to its rightful owners.");
		ShowPlayerDialog(playerid, DIALOG_DLOCKER, DIALOG_STYLE_MSGBOX, ""GREY"Very Important Player", str, "Okay", "Cancel");
	}
    else return SendClientMessage(playerid, COLOR_WHITE, "You're not in the' VIP Lounge.");
    return 1;
}
 
CMD:vipcolor(playerid, params[])
{
    if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}

	if(!PlayerInfo[playerid][pVIPColor])
	{
        PlayerInfo[playerid][pVIPColor] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "** You have enabled the VIP nametag.");
	}
	else
	{

	    PlayerInfo[playerid][pVIPColor] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "** You have disabled the VIP nametag.");
	}

	return 1;
}

CMD:vipinvite(playerid, params[])
{
	new targetid;

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if((PlayerInfo[playerid][pVIPTime] - gettime()) < 259200)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your VIP subscription expires in less than 3 days. You can't do this now.");
	}

	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vipinvite [playerid]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command grants a temporary VIP subscription which lasts one hour to a player of your choice.");

	    if(PlayerInfo[playerid][pVIPCooldown] > gettime()) {
			SM(playerid, COLOR_WHITE, "You can only use this command once every 24 hours. You have %i hours left until you can use it again.", (PlayerInfo[playerid][pVIPCooldown] - gettime()) / 3600);
		} else {
		    SendClientMessage(playerid, COLOR_WHITE, "You can only use this command once every 24 hours. You currently have no cooldown for this command.");
		}

		return 1;
	}
	if(PlayerInfo[playerid][pVIPCooldown] > gettime())
	{
	    return SM(playerid, COLOR_SYNTAX, "You have already used this command today. Please wait another %i hours.", (PlayerInfo[playerid][pVIPCooldown] - gettime()) / 3600);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(PlayerInfo[targetid][pVIPPackage])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player already has a VIP subscription.");
	}

	PlayerInfo[targetid][pVIPPackage] = 1;
	PlayerInfo[targetid][pVIPTime] = gettime() + 3600;
	PlayerInfo[playerid][pVIPCooldown] = gettime() + 86400;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = 1, viptime = 3600 WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipcooldown = %i WHERE uid = %i", PlayerInfo[playerid][pVIPCooldown], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(targetid, COLOR_AQUA, "** %s has given you a temporary one hour donator package.", GetRPName(playerid));
	SM(playerid, COLOR_AQUA, "** You have given %s a temporary one hour donator package.", GetRPName(targetid));
	return 1;
}

CMD:buyguninfo(playerid, params[])
{
	new time = PlayerInfo[playerid][pBGTime] - gettime(),
		string[32],
		buygun = (2 - PlayerInfo[playerid][pBuygun]);
	if(PlayerInfo[playerid][pBuygun] < 2)
	{
		return SM(playerid, COLOR_GREEN, "You can still buy atleast %i in ammu-nation to activate the cooldown.", buygun);
	}
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "COOLDOWN ACTIVATED:");
	if(1 <= time <= 3599)
	{
		format(string, sizeof(string), "{AA3333}%i minutes", time / 60);
	}
	else if(3600 <= time <= 86399)
	{
	    format(string, sizeof(string), ""SVRCLR"%i hours", time / 3600);
	}
	else
	{
	    if(time / 86400 <= 7)
		{
	        format(string, sizeof(string), "{FFD700}%i days", time / 86400);
	    }
		else
		{
		    format(string, sizeof(string), "{33CC33}%i days", time / 86400);
		}
	}
	SM(playerid, COLOR_GREEN, "Cooldown Ends at: %s", string);
	return 1;
}

CMD:vipinfo(playerid, params[])
{
	new time = PlayerInfo[playerid][pVIPTime] - gettime(), cooldown[24] = "{33CC33}No cooldown", string[32];

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}

	SendClientMessage(playerid, COLOR_LIGHTORANGE, "My Package:");

	if(1 <= time <= 3599)
	{
		format(string, sizeof(string), "{AA3333}%i minutes", time / 60);
	}
	else if(3600 <= time <= 86399)
	{
	    format(string, sizeof(string), ""SVRCLR"%i hours", time / 3600);
	}
	else
	{
	    if(time / 86400 <= 7)
		{
	        format(string, sizeof(string), "{FFD700}%i days", time / 86400);
	    }
		else
		{
		    format(string, sizeof(string), "{33CC33}%i days", time / 86400);
		}
	}

	if(PlayerInfo[playerid][pVIPCooldown] > gettime())
	{
	    time = PlayerInfo[playerid][pVIPCooldown] - gettime();

	    if(time > 3600) {
	        format(cooldown, sizeof(cooldown), "{F7A763}%i hours", time / 3600);
		} else {
			format(cooldown, sizeof(cooldown), "{F7A763}%i minutes", time / 60);
	    }
	}

	SM(playerid, COLOR_WHITE, "Package: {C2A2DA}%s Donator", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]));
	SM(playerid, COLOR_WHITE, "Expires In: %s", string);
	SM(playerid, COLOR_WHITE, "Next Invite: %s", cooldown);
	return 1;
}
CMD:vipnumber(playerid, params[])
{
	new number;

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(sscanf(params, "i", number))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vipnumber [phone number]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command costs $100,000 and changes your phone number to your chosen one.");
	    return 1;
	}
	if(PlayerInfo[playerid][pCash] < 100000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least $100,000 for pay for this.");
	}
	if(number == 0 || number == 911 || number == 6397 || number == 6324 || number == 8294)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid number.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE phone = %i", number);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerBuyPhoneNumber", "ii", playerid, number);
	return 1;
}

