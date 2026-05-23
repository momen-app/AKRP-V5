CMD:ah(playerid, params[]) return callcmd::adminhelp(playerid, params);
CMD:ahelp(playerid, params[]) return callcmd::adminhelp(playerid, params);

CMD:adminhelp(playerid, params[])
{
    new str[3890]; // Increased buffer size to accommodate more content

    if (PlayerInfo[playerid][pAdmin] > 0)
    {
        if (PlayerInfo[playerid][pAdmin] >= 1)
        {
            strcat(str, "{FFFFFF}[1-HID]{FFFFFF} Hidden Admin:");
            strcat(str, "\n{B0C4DE} /a, /skick, /sban, /sjail, /pinfo, /spec, /reports, /admins, /flag, /removeflag");
            strcat(str, "\n{B0C4DE} /ocheck, /oflag, /listflagged, /(am)egaphone, /listflags, /check, /dm");
        }
        if (PlayerInfo[playerid][pAdmin] >= 2)
        {
            strcat(str, "\n{00FF00}[2-JUN]{00FF00} Junior Admin:");
            strcat(str, "\n{32CD32} /aduty, /adminname, /kick, /ban, /warn, /slap, /ar, /trashr, /rr, /cr, /getip, /iplookup, /ogetip, /setint, /setvw");
            strcat(str, "\n{32CD32} /setskin, /revive, /heject, /goto, /gethere, /gotocar, /getcar, /gotocoords, /gotoint, /listen, /jetpack, /sendto");
            strcat(str, "\n{32CD32} /freeze, /unfreeze, /rwarn, /runmute, /nmute, /admute, /hmute, /gmute, /listguns, /disarm, /c, /listenpm");
            strcat(str, "\n{32CD32} /prisonic, /listjailed, /lastactive, /checkinv, /afklist, /acceptname, /denyname, /namechanges, /nrn");
            strcat(str, "\n{32CD32} /prisoninfo, /relog, /rtnc, /sth, /nro, /nao, /nor, /post, /contracts, /denyhit, /mark, /gotomark");
        }
        if (PlayerInfo[playerid][pAdmin] >= 3)
        {
            strcat(str, "\n{0000FF}[3-GEN]{0000FF} General Admin:");
            strcat(str, "\n{1E90FF} /prison, /sprison, /oprison, /release, /fine, /pfine, /ofine, /sethp, /sethelmet, /setarmor, /forcelottery");
            strcat(str, "\n{1E90FF} /veh, /destroyveh, /respawncars, /broadcast, /fixveh, /clearchat, /healrange, /shots, /damages");
            strcat(str, "\n{1E90FF} /resetadtimer, /baninfo, /banhistory, /kills, /togooc, (/togn)ewbie, /togglobal, /listpvehs, /despawnpveh");
            strcat(str, "\n{1E90FF} /aclearwanted, /removedm, /savevehicle, /editvehicle, /removevehicle, /refillcars, /refilldrug, /duel");
            strcat(str, "\n{1E90FF} /startchat, /invitechat, /kickchat, /endchat");
        }
        if (PlayerInfo[playerid][pAdmin] >= 4)
        {
            strcat(str, "\n{FFD700}[4-SNR]{FFD700} Senior Admin:");
            strcat(str, "\n{FFA500} /szcreate, /setname, /permaban, /szdelete, /szedit, /unbanip, /banip, /lockaccount, /unlockaccount");
            strcat(str, "\n{FFA500} /explode, /event, /gplay, /gplayurl, /gstop, /sethpall, /setarmorall, /settime, /addtoevent");
        }
        if (PlayerInfo[playerid][pAdmin] >= 5)
        {
            strcat(str, "\n{FFA500}[5-CHF]{FFA500} Chief Admin:");
            strcat(str, "\n{FF8C00} /givemoneyall, /givejacketall, /setdonator, /forcepayday, /givebackpack, /clearreports");
            strcat(str, "\n{FF8C00} /removedonator, /rangeban, /doublexp, /previewint, /nearest, /dynamichelp, /setscore, /resetbackpack");
            strcat(str, "\n{FF8C00} /saveaccounts, /adestroyboombox, /setbanktimer, /resetrobbery, /givepayday, /givepveh, /givedoublexp, /setweather");
        }
        if (PlayerInfo[playerid][pAdmin] >= 6)
        {
            strcat(str, "\n{FF69B4}[6-TOP]{FF69B4} Top Leader:");
            strcat(str, "\n{FF1493} /makehelper, /omakeadmin, /omakehelper, /setmotd, /forceaduty, /oadmins");
            strcat(str, "\n{FF1493} /olisthelpers, /sellinactive, /changelist, /fixplayerid, /reloadlands");
        }
        if (PlayerInfo[playerid][pAdmin] >= 7)
        {
            strcat(str, "\n{800080}[7-ASM]{800080} Assistant Manager:");
            strcat(str, "\n{DA70D6} /forcepayday, /anticheat, /doublexp, /setformeradmin, /dre");
        }
        if (PlayerInfo[playerid][pAdmin] >= 8)
        {
            strcat(str, "\n{FFFF00}[8-MGR]{FFFF00} Manager:");
            strcat(str, "\n{FFD700} /deleteaccount, /forcepayday, /setstat, /anticheat, /doublexp, /setstaff, /makeadmin, /omakeadmin, /setformeradmin");
        }
        if (PlayerInfo[playerid][pAdmin] >= 9)
        {
            strcat(str, "\n{8B0000}[9-HCL]{8B0000} High Council:");
            strcat(str, "\n{8B0000}[NOTE]{8B0000} ALL COMMAND LISTED ON THIS IS ON DEVELOPMENT");
            strcat(str, "\n{B22222} /entirecheck, /createbog , /togobb, /cpuload, /setcode");
        }
        if (PlayerInfo[playerid][pAdmin] >= 10)
        {
            strcat(str, "\n{4B0082}[10-SUP]{4B0082} Supreme Council:");
            strcat(str, "\n{9400D3} /citysf, /doublexp, /dumpprofiler, /seepass, /listadmins");
        }
        if (PlayerInfo[playerid][pAdmin] >= 11)
        {
            strcat(str, "\n{00CED1}[11-EXE]{00CED1} Executive Director:");
            strcat(str, "\n{48D1CC} /seeactivity, /setstat, /givemoney, /seeadactivity, /setconfig, /screenroom");
        }
        if (PlayerInfo[playerid][pAdmin] >= 12)
        {
            strcat(str, "\n{DC143C}[12-GMS]{DC143C} Grandmaster:");
            strcat(str, "\n{FF6347} /rconlists, /invisible, /kickinadmins, /autoadmin, /drgsall, /drgs, /de");
        }
        if (PlayerInfo[playerid][pFactionMod])
        {
            strcat(str, "\n{00FF00}Faction Mod:");
            strcat(str, "\n{32CD32} /createfaction, /editfaction, /setfaction, /purgefaction");
        }
        if (PlayerInfo[playerid][pGangMod])
        {
            strcat(str, "\n{FF4500}Gang Mod:");
            strcat(str, "\n{FF6347} /creategang, /editgang, /removegang, /gangstrike, /setgang");
            strcat(str, "\n{FF6347} /createpoint, /editpoint, /removepoint");
        }
        if (PlayerInfo[playerid][pBanAppealer])
        {
            strcat(str, "\n{808080}Ban Appealer:");
            strcat(str, "\n{A9A9A9} /banip, /baninfo, /banhistory, /unbanip, /unban");
        }

        ShowPlayerDialog(playerid, DIALOG_ADMINHELP, DIALOG_STYLE_MSGBOX, "{708090}ADMINISTRATOR HELP", str, "Okay", "Cancel");
    }
    else
    {
        return SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
    }
    return 1;
}

//=================MADE BY NEEL || TRP-X3======================//

GetNearestCorpse(playerid, Float:corpse_range = 2.0)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return -1;

	for(new i = 0; i < sizeof(CorpInfo); i++)
    {
        if (CorpInfo[i][cUsed] == 1)
        {
            if (IsPlayerInRangeOfPoint(playerid, corpse_range, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]))
            {
                return i;
            }
        }
    }
    return -1;
}
RemoveCorpse(id)
{
	if (id == 0) return 1;
	if (CorpInfo[id][cUsed] == 1)
	{
	    CorpInfo[id][cUsed]=0;
        CorpInfo[id][cType]=0;
	    CorpInfo[id][cX]=0;
        CorpInfo[id][cY]=0;
        CorpInfo[id][cZ]=0;
		CorpInfo[id][cSkin]=0;
		CorpInfo[id][cBodyTimeLeft]=0;

		if (IsValidActor(CorpInfo[id][cBody]))           DestroyActor(CorpInfo[id][cBody]);
        if (IsValidDynamicObject(CorpInfo[id][cBody]))   DestroyDynamicObject(CorpInfo[id][cBody]);

        if (CorpInfo[id][cVeh] > 0 && GetVehicleModel(CorpInfo[id][cVeh]) > 0) {
		    VehicleInfo[CorpInfo[id][cVeh]][vCorp]=0;
		} else { DestroyDynamic3DTextLabel(CorpInfo[id][cText]); }

        for(new i; i < MAX_PLAYERS; i++) {
            if (pTemp[i][UsingCorpse] == id) {
                pTemp[i][UsingCorpse] = 0;
                break;
            }
        }
	}
	return 1;
}

forward CorpseCountdown(id);
public CorpseCountdown(id)
{
    if(CorpInfo[id][cBodyTimeLeft] > 1) {
        CorpInfo[id][cBodyTimeLeft]--;

    }else if(CorpInfo[id][cBodyTimeLeft] == 1) {
		RemoveCorpse(id);
    }

	return 1;
}

Corpse_OnPlayerEdit(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rz)
{
    if (GetPVarInt(playerid, #CorpsEdit) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
		new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;

		GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
		GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

	    new id = GetPVarInt(playerid, #CorpsEdit)-1;
		DeletePVar(playerid, #CorpsEdit);

	    if (id < 0 || id >= sizeof(CorpInfo) || !CorpInfo[id][cUsed])
	    {
	    	return SendClientMessage(playerid, COLOR_GRAD1, "The body was not found.");
	    }
	    if (objectid != CorpInfo[id][cBody])
	    {
	    	return  SendClientMessage(playerid, COLOR_GRAD1, "Corpse edit error.");
	    }

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, 0.0, 0.0, rz);

        GetDynamicObjectPos(objectid, CorpInfo[id][cX], CorpInfo[id][cY], CorpInfo[id][cZ]);

        if (IsValidDynamic3DTextLabel(CorpInfo[id][cText])) DestroyDynamic3DTextLabel(CorpInfo[id][cText]);
        CorpInfo[id][cText] = CreateDynamic3DTextLabel("(( DEAD BODY ))\npress '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[id][cX], CorpInfo[id][cY], CorpInfo[id][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
	}
    return 1;
}

stock GetXYInFrontOfPlayerEx(playerid, &Float:X, &Float:Y, &Float:Z, Float:distance)
{
	new Float:A;
	GetPlayerPos(playerid, X, Y, Z);

	if (GetPlayerVehicleID(playerid))	GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
	else								GetPlayerFacingAngle(playerid, A);

	X += (distance * floatsin(-A, degrees));
	Y += (distance * floatcos(-A, degrees));
}

Corpse_OnPlayerUpdate(playerid)
{
    if(pTemp[playerid][UsingBort] && pTemp[playerid][UsingCorpse])
	{
        new Float:X, Float:Y, Float:Z, Float:R;
        GetPlayerPos(playerid, X, Y, Z);
        GetPlayerFacingAngle(playerid, R);
        GetXYInFrontOfPlayerEx(playerid, X, Y, Z, 1.8);

        new idx = pTemp[playerid][UsingCorpse];
        CorpInfo[idx][cX]=X;
        CorpInfo[idx][cY]=Y;
        CorpInfo[idx][cZ]=Z;
        SetActorPos(CorpInfo[idx][cBody], X, Y, Z + 0.60);
        SetActorFacingAngle(CorpInfo[idx][cBody], R);
    }
    return 1;
}

Corpse_OnPlayerEnterVehicle(playerid)
{
    if (pTemp[playerid][UsingBort])
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid,x,y,z);
        SendClientMessage(playerid,COLOR_GRAD1, "You cannot get into the vehicle while holding the wheelchair.");
    }
    return 1;
}

CreateCorpse(playerid, weaponid)
{
    if (weaponid == 53) return 1;

    new
        found = 0,
        foundid = 0,
        Float:x,
        Float:y,
        Float:z,
        sex[8],
        age
    ;

    GetPlayerPos(playerid, x, y, z);

	for(new o = 0; o < sizeof(CorpInfo); o++)
	{
		if (o != 0)
		{
	        if (CorpInfo[o][cUsed] == 0 && found == 0)
		    {
		        found++;
			    foundid=o;
                break;
            }
        }
    }
    if (found == 0) return 1;

    CorpInfo[foundid][cUsed]=1;
    CorpInfo[foundid][cVeh]=0;

    format(CorpInfo[foundid][cName], 25, "%s", GetRPName(playerid));
    CorpInfo[foundid][cType] = 0;
    CorpInfo[foundid][cTime] = gettime();

    CorpInfo[foundid][cX]=x;
    CorpInfo[foundid][cY]=y;
    CorpInfo[foundid][cZ]=z;

    if (weaponid == 54) CorpInfo[foundid][cX] -= 0.5;

	CorpInfo[foundid][cSkin]=GetPlayerSkin(playerid);
	CorpInfo[foundid][cBody]=CreateActor(GetPlayerSkin(playerid), x, y, z, 0.0);
	SetActorInvulnerable(CorpInfo[foundid][cBody], true);
	ApplyActorAnimation(CorpInfo[foundid][cBody], "PED", "KO_shot_stom", 4.0, false, false, false, true, false);
    SetActorVirtualWorld(CorpInfo[foundid][cBody], GetPlayerVirtualWorld(playerid));

	if (PlayerInfo[playerid][pGender] == 1)	format(sex, sizeof(sex), "Male");
	else 			                        format(sex, sizeof(sex), "Female");

    age = PlayerInfo[playerid][pAge];

    format(CorpInfo[foundid][cNote], 200, "{FFFFFF}(( Name: %s ))\n\nAge about: %d\nVictim gender: %s\n\n", GetRPName(playerid), age, sex);

    new count;
    for(new i = 0; i != MAX_DAMAGES; i++)
    {
        if (DamageInfo[playerid][i][damageOn] != 1) continue;
        count++;
    }

    if (count > 0) format(CorpInfo[foundid][cNote], 200, "%sThe victim was injured: %d time(s)\n\n", CorpInfo[foundid][cNote], count);
    else  format(CorpInfo[foundid][cNote], 200, "%sNo visible wounds / burns on the body.\n\n", CorpInfo[foundid][cNote]);

    switch(weaponid)
    {
        case 0: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Was beaten.", CorpInfo[foundid][cNote]);
        case 1 .. 16: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Beaten with an object.", CorpInfo[foundid][cNote]);
        case 22 .. 34: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Was shot using %s.", CorpInfo[foundid][cNote], weaponid);
        case 17, 41 .. 42: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Probably suffocated.", CorpInfo[foundid][cNote]);
        case 49: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Hit (s) by a vehicle.", CorpInfo[foundid][cNote]);
        case 50: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Torn apart by aircraft blades.", CorpInfo[foundid][cNote]);
        case 18: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Multiple burns.", CorpInfo[foundid][cNote]);
        case 51: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Died from explosion.", CorpInfo[foundid][cNote]);
        case 53: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Choked with water.", CorpInfo[foundid][cNote]);
        case 54: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Fell (a) from a great height.", CorpInfo[foundid][cNote]);
        default: format(CorpInfo[foundid][cNote], 200, "%sCause of death: Unknown.", CorpInfo[foundid][cNote]);
    }
    CorpInfo[foundid][cText] = CreateDynamic3DTextLabel("(( DEAD BODY ))\n type '/corpse'", COLOR_LIGHTRED, x, y, z-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
	return 1;
}

CMD:removecorpse(playerid, params[])
{
	static
	    id = 0;

	if(PlayerInfo[playerid][pAdmin] < 1)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /gotobody [corpse id]");

	if ((id < 0 || id >= MAX_CORPS) || !CorpInfo[id][cUsed])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid corpse ID.");

	RemoveCorpse(id);
	SM(playerid, COLOR_WHITE, "** Checkpoint marked at the body location of %s.", CorpInfo[id][cName]);
	return 1;
}

CMD:gotobody(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_CORONER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Coroner.");
	}
	static
	    id = 0;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /gotobody [corpse id]");

	if ((id < 0 || id >= MAX_CORPS) || !CorpInfo[id][cUsed])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid corpse ID.");

	PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	SetPlayerCheckpoint(playerid, CorpInfo[id][cX], CorpInfo[id][cY], CorpInfo[id][cZ], 3.0);
	SM(playerid, COLOR_WHITE, "** Checkpoint marked at the body location of %s.", CorpInfo[id][cName]);
	return 1;
}

CMD:getbody(playerid, params[])
{
	new i;

	if(!PlayerHasJob(playerid, JOB_CORONER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Coroner.");
	}

    if ((i = GetNearestCorpse(playerid)) == -1)
    {
    	return SendClientMessage(playerid, COLOR_RED, "There is no corpse near you.");
    }
	if(PlayerInfo[playerid][pCoronerBody])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need to drop off your current body first.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}

	new string[129];
	format(string, sizeof(string), "Pickup\ncorpse...");
	GameTextForPlayer(playerid, string, 5000, 1);
	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0);
	SetTimerEx("PackingCorpse", 5000, false, "ii", playerid, i);
    return 1;
}

forward PackingCorpse(playerid, i);
public PackingCorpse(playerid, i)
{
	PlayerInfo[playerid][pCoronerBody] = 1;
	PlayerInfo[playerid][pLoopAnim] = 0;
    CorpInfo[i][cTime] = gettime();
    CorpInfo[i][cX] =
    CorpInfo[i][cY] =
    CorpInfo[i][cZ] = 0.0;

    TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid, SYNC_ALL);
	RemoveCorpse(i);
    DestroyDynamic3DTextLabel(CorpInfo[i][cText]);
	SetPlayerAttachedObject(playerid, 9, 11745, 6, 0.291999, -0.009999, 0.045000, 5.799998, -105.899955, -99.999984, 0.571000, 1.497001, 1.253999);
    SetPlayerCheckpoint(playerid, 885.858093, -1077.377197, 24.294555, 2.0);
    if (!CorpInfo[i][cType] && IsValidActor(CorpInfo[i][cBody])) DestroyActor(CorpInfo[i][cBody]);
    else if (CorpInfo[i][cType] && IsValidDynamicObject(CorpInfo[i][cBody])) DestroyDynamicObject(CorpInfo[i][cBody]);
	return 1;
}

CMD:dropbody(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_CORONER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Coroner.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 885.858093, -1077.377197, 24.294555))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of Cementery.");
	}
	if(PlayerInfo[playerid][pCoronerBody] == 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have carry dead body");

    new amount = 2500 + random(2500);
    new string[64];
    format(string, sizeof(string), "~p~payout ~g~$%i", amount);
	GameTextForPlayer(playerid, string, 5000, 1);
	AddToPaycheck(playerid, amount);
	RemovePlayerAttachedObject(playerid, 9);
	PlayerInfo[playerid][pCoronerBody] = 0;
    return 1;
}

CMD:findbodies(playerid, params[])
{
	new string[1800], str[1800], found; // overkill af but just in case

	if(!PlayerHasJob(playerid, JOB_CORONER))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Coroner.");
	}

	format(string, sizeof(string), "Body Name\tCorpse Command\tTime Left\n");
	format(str, sizeof(str), ""WHITE"'Type /gotobody to pickup corpse'");

	for(new i; i < MAX_CORPS; i++)
	{
	    if(!CorpInfo[i][cUsed]) continue;
	    format(string, sizeof(string), "%s\n"WHITE"(ID:%i) "WHITE"%s\t%s\t%s", string, i, CorpInfo[i][cName], str, FormatTime(CorpInfo[i][cBodyTimeLeft]));
	    found++;
	}

	if(found > 0) {
	    new title[24];
	    format(title, sizeof(title), "Corpse | %d Found", found);
	    ShowPlayerDialog(playerid, DIALOG_CORPSE, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Close", "");
	}else{
	    ShowPlayerDialog(playerid, DIALOG_CORPSE1, DIALOG_STYLE_MSGBOX, "Corpse", "No Corpse found.", "Close", "");
	}

	return 1;
}
CMD:iloveakrp(playerid, params[])
{
	if(PlayerInfo[playerid][pRefunded] == 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You have already claimed your refund package.");
	}
	else
    RefundPlayer(playerid);
	SMA(COLOR_LIGHTRED, "SERVER: %s has claimed their refund package using [/iloveV5].", GetRPName(playerid));
	ShowPlayerDialog(playerid, DIALOG_REFUNDED, DIALOG_STYLE_MSGBOX, "You have claimed your refund package", "{FFFFFF}As you came to our server, you have received the following as a starter package:\n\n {369b26}$100,000\n{A028AD}Gold Donator{FFFFFF}(100 days)\n\n{FFFFFF}We hope that you will invite more of your friends to play on the server!\n{FFFFFF}/info","Enjoy!","");
	return 1;
}

CMD:corpse(playerid)
{
    new i;

    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
    if(!PlayerInfo[playerid][pLogged])
	{
	    SendClientMessage(playerid, COLOR_RED, "You cannot use commands if you're not logged in.");
		return 0;
	}
    if ((i = GetNearestCorpse(playerid)) == -1)
    {
    	return SendClientMessage(playerid, COLOR_RED, "There is no corpse near you.");
    }
    ShowPlayerDialog(playerid, CorpseInfo, DIALOG_STYLE_MSGBOX, "Information about an unknown body", CorpInfo[i][cNote], "Options", "Close");
    return 1;
}

CMD:reports(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Pending Reports:");

	for(new i = 0; i < MAX_REPORTS; i ++)
	{
	    if(ReportInfo[i][rExists] && !ReportInfo[i][rAccepted])
	    {
	        SM(playerid, COLOR_GREY2, "(RID: %i) %s[%i] reports: %s", i, GetRPName(ReportInfo[i][rReporter]), ReportInfo[i][rReporter], ReportInfo[i][rText]);
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "** Use /ar [rid] or /trashr [rid] to handle these reports.");
	return 1;
}

CMD:rtnc(playerid, params[])
{
    new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rtnc [reportid] (Sends to newbie chat)");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report specified is being handled by another admin.");
	}

    SAM(COLOR_LIGHTRED, "AdmCmd: %s has sent report %i to newbie chat.", GetRPName(playerid), reportid);
	SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "%s has redirected your report to the newbie chat.", GetRPName(playerid));
    SendNewbieChatMessage(ReportInfo[reportid][rReporter], ReportInfo[reportid][rText]);
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:sth(playerid, params[])
{
    new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sth [reportid] (Sends to helpers)");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report specified is being handled by another admin.");
	}

    SAM(COLOR_LIGHTRED, "AdmCmd: %s has sent report %i to helpers.", GetRPName(playerid), reportid);
	SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "%s has redirected your report to all helpers online.", GetRPName(playerid));

    strcpy(PlayerInfo[ReportInfo[reportid][rReporter]][pHelpRequest], ReportInfo[reportid][rText], 128);
	SendHelperMessage(COLOR_AQUA, "** Help Request from %s[%i]: %s **", GetRPName(ReportInfo[reportid][rReporter]), ReportInfo[reportid][rReporter], ReportInfo[reportid][rText]);

	PlayerInfo[playerid][pLastRequest] = gettime();
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:ar(playerid, params[])
{
	new reportid, chat;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "iI(1)", reportid, chat))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ar [reportid] [chat (optional - 0/1)]");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rReporter] == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot accept your own report.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report specified is being handled by another admin.");
	}
	if(PlayerInfo[playerid][pActiveReport] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have a report active already. Use /cr to close it.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has accepted report %i from %s.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));

	if(chat)
	{
		SendClientMessage(playerid, COLOR_WHITE, "** You can use /rr to speak with the reporter and /cr to close the report.");
		SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "%s has accepted your report and is now reviewing it.", GetRPName(playerid));
		SendClientMessage(ReportInfo[reportid][rReporter], COLOR_YELLOW, "You can use /rr to reply to the admin handling your report.");

		PlayerInfo[playerid][pActiveReport] = reportid;
		PlayerInfo[ReportInfo[reportid][rReporter]][pActiveReport] = reportid;

		ReportInfo[reportid][rHandledBy] = playerid;
		ReportInfo[reportid][rAccepted] = 1;
	}
	else
	{
	    SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "%s has accepted your report and is now reviewing it.", GetRPName(playerid));
	    ReportInfo[reportid][rExists] = 0;
	}

	PlayerInfo[playerid][pReports]++;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET reports = %i WHERE uid = %i", PlayerInfo[playerid][pReports], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:trashr(playerid, params[])
{
	new reportid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "iS(N/A)[128]", reportid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /trashr [reportid] [reason (optional)]");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid report ID.");
	}
    if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The report specified is being handled by another admin.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s, reason: %s", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]), reason);
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "** %s has trashed your report, reason: %s", GetRPName(playerid), reason);
	ReportInfo[reportid][rExists] = 0;

	ShowPlayerDialog(ReportInfo[reportid][rReporter], 0, DIALOG_STYLE_MSGBOX,"Report Tips","Tips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.","Close", "");
	return 1;
}

CMD:nro(playerid, params[])
{
	new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nro [reportid]");
 		SendClientMessage(playerid, COLOR_WHITE, "This command will clear a report for not being a rulebreaking offense.");
 		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This report is already being handled by another administrator.");
	}

 	SAM(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as their report involves a non-rulebreaking offense.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as it involves a non-rulebreaking offense", GetRPName(playerid));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "Please visit our rules page at ("SERVER_URL") for a full list of rulebreaking offenses.");
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:nao(playerid, params[])
{
	new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nao [reportid]");
   		SendClientMessage(playerid, COLOR_WHITE, "This command will clear a report if there isn't a high enough administrator online.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This report is already being handled by another administrator.");
	}

  	SAM(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as there are no admins online to handle it.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as there no admins online with the authority to handle it.", GetRPName(playerid));
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:norevive(playerid, params[])
{
	return callcmd::nor(playerid, params);
}

CMD:nor(playerid, params[])
{
	new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nor [reportid]");
   		SendClientMessage(playerid, COLOR_WHITE, "This command will clear a report if the reporters revive request is invalid.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This report is already being handled by another administrator.");
	}

 	SAM(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as their request for a revive is invalid.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as your request for a revive is invalid. (/call 911)", GetRPName(playerid));
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:post(playerid, params[])
{
	new reportid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /nor [reportid]");
   		SendClientMessage(playerid, COLOR_WHITE, "This command will clear a report and notify the player to post an admin request.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This report is already being handled by another administrator.");
	}

 	SAM(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as it needs to be handled on the forums.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as your issue at hand must be handled on our forums.", GetRPName(playerid));
	SM(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "Please visit our website at ("SERVER_URL") in order to to resolve this issue.");
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:rr(playerid, params[])
{
	new reportid = PlayerInfo[playerid][pActiveReport];

    if(reportid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no active report to reply to.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rr [reply text]");
	}

	if(ReportInfo[reportid][rReporter] == playerid)
	{
	    SM(ReportInfo[reportid][rHandledBy], COLOR_YELLOW, "** Player %s (ID %i): %s **", GetRPName(playerid), playerid, params);
	    SM(playerid, COLOR_YELLOW, "** Reply to %s (ID %i): %s **", GetRPName(ReportInfo[reportid][rHandledBy]), ReportInfo[reportid][rHandledBy], params);
	}
	else
	{
	    SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "** Admin %s (ID %i): %s **", GetRPName(playerid), playerid, params);
	    SM(playerid, COLOR_YELLOW, "** Reply to %s (ID %i): %s **", GetRPName(ReportInfo[reportid][rReporter]), ReportInfo[reportid][rReporter], params);
	}

	return 1;
}

CMD:cr(playerid)
{
    new reportid = PlayerInfo[playerid][pActiveReport];

    if(reportid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no active report which you can close.");
	}

	if(ReportInfo[reportid][rReporter] == playerid)
	{
	    SM(ReportInfo[reportid][rHandledBy], COLOR_YELLOW, "** Player %s has closed the report. **", GetRPName(playerid));
	    SM(playerid, COLOR_YELLOW, "You have closed the report and ended your conversation with the admin.");
	}
	else
	{
	    SM(ReportInfo[reportid][rReporter], COLOR_YELLOW, "** Administrator %s has closed the report. **", GetRPName(playerid));
	    SM(playerid, COLOR_YELLOW, "You have closed the report and ended your conversation with the reporter.");
	}

	if(ReportInfo[reportid][rReporter] != INVALID_PLAYER_ID)
	{
		PlayerInfo[ReportInfo[reportid][rReporter]][pActiveReport] = -1;
	}
	if(ReportInfo[reportid][rHandledBy] != INVALID_PLAYER_ID)
	{
		PlayerInfo[ReportInfo[reportid][rHandledBy]][pActiveReport] = -1;
	}

	ReportInfo[reportid][rExists] = 0;
	ReportInfo[reportid][rAccepted] = 0;
	ReportInfo[reportid][rReporter] = INVALID_PLAYER_ID;
	ReportInfo[reportid][rHandledBy] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pActiveReport] = -1;

	return 1;
}

CMD:skick(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /skick [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be kicked.");
	}
	SAM(COLOR_LIGHTRED, "AdmCmd: %s has silently kicked %s, reason: %s", GetRPName(playerid), GetRPName(targetid), reason);
	KickPlayer(targetid);
	return 1;
}

CMD:sban(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(PlayerInfo[targetid][pAdmin] == 8)
	{
 		SAM(COLOR_YELLOW, "Warning: %s has been autokicked for trying to ban a Server Manager(%s).", GetRPName(playerid), GetRPName(targetid));
 		KickPlayer(playerid);
 		return 1;
	}

	new szString[128];
	format(szString, sizeof(szString), "%s (uid: %i) silently banned %s (uid: %i), reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], reason);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s was silently banned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	new from[] = "Secret Admin";
	BanPlayer(targetid, from, reason, true);
	return 1;
}

CMD:sjail(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sjail [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be jailed.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(minutes < 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The amount of minutes specified cannot be below zero.");
	}

    PlayerInfo[targetid][pJailType] = 1;
    PlayerInfo[targetid][pJailTime] = minutes * 60;

    ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);
	SetPlayerInJail(targetid);

    SMA(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by an Admin, reason: %s", GetRPName(targetid), minutes, reason);
    SM(targetid, COLOR_AQUA, "** You have been jailed for %i minutes by an admin.", minutes);
    return 1;
}

CMD:pinfo(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pinfo [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	SM(playerid, COLOR_GREY1, "(ID: %i) - (Name: %s) - (Ping: %i) - (Packet Loss: %.1f%c)", targetid, GetRPName(targetid), GetPlayerPing(targetid), NetStats_PacketLossPercent(targetid), '%');
	return 1;
}

CMD:admins(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	SendClientMessage(playerid, SERVER_COLOR, "Admins Online");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAdmin] > 0)
		{
			new division[5];
			strcpy(division, GetAdminDivision(i));
            if(strlen(division) < 1) division = "None";
			if(!strcmp(PlayerInfo[i][pAdminName], "None", true))
            	SM(playerid, COLOR_GREY2, "(ID: %i) %s %s - Division: %s - Status: %s - "SVRCLR"Reports Handled: %i{C8C8C8} - Tabbed: %s", i, GetAdminRank(i), PlayerInfo[i][pUsername], division, (PlayerInfo[i][pAdminDuty]) ? (""SVRCLR"On Duty") : ("Off Duty"), PlayerInfo[i][pReports], (PlayerInfo[i][pAFK]) ? ("Yes") : ("No"));
        	else
				SM(playerid, COLOR_GREY2, "(ID: %i) %s %s (%s) - Division: %s - Status: %s - "SVRCLR"Reports Handled: %i{C8C8C8} - Tabbed: %s", i, GetAdminRank(i), PlayerInfo[i][pUsername], PlayerInfo[i][pAdminName], division, (PlayerInfo[i][pAdminDuty]) ? (""SVRCLR"On Duty") : ("Off Duty"), PlayerInfo[i][pReports], (PlayerInfo[i][pAFK]) ? ("Yes") : ("No"));
		}
	}
	return 1;
}

CMD:checknewbies(playerid, params[])
{
	new targetid;
	if(!PlayerInfo[playerid][pAdmin] && PlayerInfo[playerid][pHelper] < 3)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /checknewbies [playerid]");
	}
	SM(playerid, COLOR_SYNTAX, "Level %i Player %s has used newbie {00FF00}%s times.", PlayerInfo[targetid][pLevel], GetRPName(targetid), FormatNumber(PlayerInfo[targetid][pNewbies], 0));
	return 1;
}

CMD:helpers(playerid, params[])
{
	SendClientMessage(playerid, SERVER_COLOR, "Helpers Online:");

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pHelper] > 0 && !PlayerInfo[i][pPassport])
	    {
	        if(PlayerInfo[playerid][pAdmin] > 0 || PlayerInfo[playerid][pHelper] > 0)
	            SM(playerid, COLOR_WHITE, "(ID: %i) %s %s - Help Requests: %s - Newbies: %s", i, GetHelperRank(i), GetRPName(i), FormatNumber(PlayerInfo[i][pHelpRequests], 0), FormatNumber(PlayerInfo[i][pNewbies], 0));
	        else
				SM(playerid, COLOR_WHITE, "(ID: %i) %s %s", i, GetHelperRank(i), GetRPName(i));
		}
	}

	return 1;
}

CMD:flag(playerid, params[])
{
	new targetid, desc[128];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, desc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /flag [playerid] [description]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, '%s', NOW(), '%e')", PlayerInfo[targetid][pID], GetPlayerNameEx(playerid), desc);
	mysql_tquery(connectionID, queryBuffer);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s flagged %s's account for '%s'.", GetRPName(playerid), GetRPName(targetid), desc);
	return 1;
}

CMD:oflag(playerid, params[])
{
	new name[24], desc[128];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]s[128]", name, desc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /oflag [username] [description]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineFlag", "iss", playerid, name, desc);
	return 1;
}

CMD:listflagged(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	mysql_tquery(connectionID, "SELECT b.username FROM flags a, users b WHERE a.uid = b.uid ORDER BY b.username", "OnQueryFinished", "ii", THREAD_LIST_FLAGGED, playerid);
	return 1;
}

CMD:ocheck(playerid, params[])
{
	new name[24];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ocheck [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineCheck", "is", playerid, name);
	return 1;
}

CMD:removeflag(playerid, params[])
{
	new targetid, slot;

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removeflag [playerid] [slot]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(slot < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot specified.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM flags WHERE uid = %i ORDER BY id LIMIT %i, 1", PlayerInfo[targetid][pID], slot-1);
	mysql_tquery(connectionID, queryBuffer, "OnVerifyRemoveFlag", "iii", playerid, targetid, slot);
	return 1;
}

CMD:listflags(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /listflags [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM flags WHERE uid = %i ORDER BY date DESC", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnListPlayerFlags", "ii", playerid, targetid);
	return 1;
}

CMD:powerall(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 8)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(PowerSpec[playerid] == 0)
	{
		PowerSpec[playerid] = 1;
		SendClientMessage(playerid, COLOR_RED, "You have turned on the power");
	}
	else
	{
	    PowerSpec[playerid] = 0;
	    SendClientMessage(playerid, COLOR_RED, "You have turned off the power");
	}
	return 1;
}

CMD:spec(playerid, params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    
    if(!strcmp(params, "off", true) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
    {
        if(PlayerInfo[playerid][pSpectating] != INVALID_PLAYER_ID)
        {
		  	CallRemoteFunction("ToggleListenerLocalStream", "iii", PlayerInfo[playerid][pSpectating] , playerid , 0);
        }
        
        SM(playerid, COLOR_ORANGE, "You are no longer spectating %s (ID %i).", GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
        SAM(COLOR_RED, "%s stops spectating %s (ID:%i).", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
        PlayerInfo[playerid][pSpectating] = INVALID_PLAYER_ID;
        TogglePlayerSpectating(playerid, false);
        SetPlayerToSpawn(playerid);
        return 1;
    }
    
    if(sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /spec [playerid/off]");
    }
    
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
    }
    
    if(targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't spectate yourself.");
    }
    
    if(!IsPlayerSpawned(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
    }
    
    if(PowerSpec[targetid] == 1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot spectate alenjandro,barako or NAJU as they are currently RP'ing.");
    }

    if(PlayerInfo[playerid][pSpectating] != INVALID_PLAYER_ID)
    {
		CallRemoteFunction("ToggleListenerLocalStream", "iii", PlayerInfo[playerid][pSpectating] , playerid , 0);
    }

    SavePlayerVariables(playerid);
    TogglePlayerSpectating(playerid, true);

    if(IsPlayerInAnyVehicle(targetid))
    {
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
    }
    else
    {
        PlayerSpectatePlayer(playerid, targetid);
    }
    
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    PlayerInfo[playerid][pSpectating] = targetid;
	
	CallRemoteFunction("ToggleListenerLocalStream", "iii", targetid , playerid , 1);

    SM(playerid, COLOR_ORANGE, "You are now spectating %s (ID %i).", GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
    SAM(COLOR_RED, "%s is now spectating %s (ID:%i).", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
    return 1;
}
CMD:breakin(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You may only break into a player owned vehicle.");
	}
	if(VehicleInfo[vehicleid][vLocked] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is unlocked. Therefore you can't break into it.");
	}
	if(PlayerInfo[playerid][pLockBreak] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to break into this vehicle.");
	}
	if(IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Why would you want to break into your own vehicle?");
	}
	if(IsVehicleBeingPicked(vehicleid))
	{
 		return SendClientMessage(playerid, COLOR_GREY, "This vehicle is already being broken into by someone else.");
	}

	PlayerInfo[playerid][pLockBreak] = vehicleid;
	PlayerInfo[playerid][pLockHealth] = 1000.0;

	SendClientMessage(playerid, COLOR_AQUA, "You have started the {FF6347}break-in{33CCFF} process. Start hitting the driver or passenger side door to break it down.");
	SendClientMessage(playerid, COLOR_AQUA, "You can use your fists for this job, however melee weapons are preferred and gets the job done faster.");
	return 1;
}

CMD:am(playerid, params[])
{
	return callcmd::amegaphone(playerid, params);
}
cmd:fixlag(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 11)
	{
       return SendClientMessage(playerid,COLOR_RED,"You can't use this command at the moment");
	}
	resetallvalue();
	SendClientMessage(playerid, COLOR_RED, "Cleared All Offline Account");

	return 1;
}
resetallvalue()
{
	for(new playerid ; playerid < MAX_PLAYERS; playerid++){

		if(!IsPlayerConnected(playerid))
		{
	        PlayerInfo[playerid][pRobbingHouse] = -1;
			PlayerInfo[playerid][pToolkit] = 0;
			PlayerInfo[playerid][pLockpick] = 0;
			PlayerInfo[playerid][pRepairKit] = 0;
			PlayerInfo[playerid][pPassword] = 0;
			PlayerInfo[playerid][pPassword1] = 0;
			PlayerInfo[playerid][pPassword3] = 0;
			PlayerInfo[playerid][pRegpass] = 0;
			PlayerInfo[playerid][pGasplace] = 0;
			
			
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
			PlayerInfo[playerid][pSetup] = 0;
			PlayerInfo[playerid][pGender] = 0;
			PlayerInfo[playerid][pAge] = 0;
			PlayerInfo[playerid][pSkin] = 0;
			PlayerInfo[playerid][pCameraX] = 0;
			PlayerInfo[playerid][pFormerAdmin] = 0;
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
			PlayerInfo[playerid][pCartype] = 0;
			PlayerInfo[playerid][pCartime] = 0;
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

			
		}
	   
	}
	
	
}
CMD:amegaphone(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(am)egaphone [text]");
	}

	SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[Admin Megaphone] %s: %s", GetRPName(playerid), params);
	return 1;
}

CMD:newbinfo(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1564.5627,-2248.6436,13.5469)) return SendClientMessage(playerid, -1, "You are not in the newbie spawn ((Los Santos Airport)).");
	new string[3500];
    strcat(string, "\n");
    strcat(string, "- "SVRCLR"Use "WHITE"/newb"SVRCLR" to ask your questions or "WHITE"/gethelp"SVRCLR" if you need more help.\n");
    strcat(string, "- "SVRCLR"Use "WHITE"/findjob"SVRCLR" to a find a job and "WHITE"/jobhelp"SVRCLR" for more information about the available jobs.\n");
    strcat(string, "- {FF0000}Do not hack."SVRCLR" It is pointless as we have an extensive anti-cheat against hacks and admins that monitor the server 24/7.\n");
    strcat(string, "- "SVRCLR"Use "WHITE"/report"SVRCLR" if you see any rule-breakers.\n");
    strcat(string, "- "SVRCLR"Check "WHITE"/rules"SVRCLR" for a basic list of server rules.\n");
    strcat(string, "- "SVRCLR"Check "WHITE"/help"SVRCLR" to see available commands.\n\n");
    strcat(string, "Be sure to check out our website and forums at "WHITE""SERVER_URL""SVRCLR".\n");
    strcat(string, "You can also join us on Discord at "WHITE""SERVER_DISCORD""SVRCLR"\n\n");
    strcat(string, ""SVRCLR"Have fun!");
    ShowPlayerDialog(playerid, DIALOG_KIOSK, DIALOG_STYLE_MSGBOX, "Welcome to "SVRCLR""SERVER_NAME"", string, "Close", "");
    return 1;
}

CMD:kick(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /kick [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be kicked.");
	}

	SAM(COLOR_LIGHTRED, "AdmCmd: %s was kicked by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	KickPlayer(targetid);
	return 1;
}

CMD:fakeban(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	//Log_Write("log_punishments", "%s (uid: %i) fakebanned %s (uid: %i), reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], reason);

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	return 1;
}


CMD:ban(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(PlayerInfo[targetid][pAdmin] == 8)
	{
 		SAM(COLOR_YELLOW, "Warning: %s has been autokicked for trying to ban a Server Manager(%s).", GetRPName(playerid), GetRPName(targetid));
 		KickPlayer(playerid);
 		return 1;
	}

	SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	BanPlayer(targetid, GetPlayerNameEx(playerid), reason);
	
	new dc_str[454];
	format(dc_str, sizeof(dc_str), "%s was banned by %s for reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	SendDiscordMessage(1, dc_str);
	return 1;
}

CMD:warn(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /warn [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin] || PlayerInfo[targetid][pAdmin] == 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be warned.");
	}

	PlayerInfo[targetid][pWarnings]++;
	
	if(PlayerInfo[targetid][pWarnings] < 3)
	{
	    SAM(COLOR_LIGHTRED, "AdmCmd: %s was warned by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	    SM(targetid, COLOR_YELLOW, "** %s issued a warning to your account, reason: %s", GetRPName(playerid), reason);
    	new dc_str[454];
	    format(dc_str, sizeof(dc_str), "%s warned %s, reason: %s (%i/3)", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason, PlayerInfo[targetid][pWarnings]);
	    SendDiscordMessage(6, dc_str);
	}
	else
	{
	    PlayerInfo[targetid][pWarnings] = 0;

	    SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by %s, reason: %s (3/3 warnings)", GetRPName(targetid), GetRPName(playerid), reason);
		BanPlayer(targetid, GetPlayerNameEx(playerid), reason);
	}

	return 1;
}

forward ComservEx(playerid);
public ComservEx(playerid)
{
	if (PlayerInfo[playerid][pComserv] < 0) {
		PlayerInfo[playerid][pComserv] = 0;
		SendClientMessage(playerid, COLOR_SYNTAX,"** Your service is finished.");
		return 1;
	}
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid, SYNC_ALL);
	PlayerInfo[playerid][pComserv] -= 1;
	SM(playerid,COLOR_GREY2, "** You have %i more actions to complete before you can finish your service.",PlayerInfo[playerid][pComserv]);
	return 1;
}


CMD:comserv(playerid, params[])
{
	new targetid, months, string[128];
	if(!IsLawEnforcement(playerid) && PlayerInfo[playerid][pAdmin] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ui", targetid, months))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "Usage: /comserv [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You can't community service yourself.");
	}
	PlayerInfo[targetid][pSkin] = 50;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET skin = 50 WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SetPlayerSkin(targetid, 50);

	PlayerInfo[targetid][pComserv] = months;
	SetPlayerVirtualWorld(targetid, 0);
	SetPlayerInterior(targetid, 0);
	SetPlayerPos(targetid, 1482.4253,-1717.5935,14.0469);
	SetPlayerFacingAngle(targetid, 9.8095);
	GameTextForPlayer(targetid, "~w~Good Luck~n~~r~Cleaning!", 5000, 3);
    format(string, sizeof(string), "** Breaking News: %s %s put %s into Community Service for %i months.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), months);
	SAM(COLOR_LIGHTGREEN, string);
	SM(targetid, COLOR_AQUA, "** You have been put to Community Service for %i months by %s.", months, GetRPName(playerid));
	return 1;
}

CMD:resetcomserv(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "Usage: /resetcomserv [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY2, "The player specified is disconnected.");
	}
	PlayerInfo[targetid][pComserv] = 0;
    SAM(COLOR_LIGHTRED, "AdmCmd: %s has been reset community service.", GetRPName(targetid));
	return 1;
}

CMD:vpanel(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || PlayerInfo[playerid][pInjured])
	{
	    return SendClientMessage(playerid, SERVER_COLOR, "Error:"WHITE" You must be driving a vehicle to use this command.");
	}
	ShowDialogToPlayer(playerid, DIALOG_SETTINGS1);
	return 1;
}

CMD:clean(playerid, params[]) {
	if (PlayerInfo[playerid][pComserv] < 1) {
		return SendClientMessage(playerid, COLOR_GREY2, "** You are not performing an community service.");
	}
	if(gettime() - PlayerInfo[playerid][pLastClean] < 15)
	{
		return SM(playerid, COLOR_GREY2, "** You can only use this command every 15 seconds. Please wait %i more seconds.", 15 - (gettime() - PlayerInfo[playerid][pLastClean]));
	}
    if(!PlayerUseAnims(playerid))
	{
		if(gNotification)
			return notification_show(playerid, str_format("You're currently unable to use animations at this moment."));	
		else
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You're currently unable to use animations at this moment.");
	}
	for(new i = 0; i < sizeof(comservpoint); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2]))
	    {
			GameTextForPlayer(playerid, "~g~Cleaning...", 10000, 3);
			ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("ComservEx", 10000, false, "i", playerid);
			PlayerInfo[playerid][pLastClean] = gettime();
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GREY2, "You are not in range of cleaning areas.");
	return 1;
}

CMD:checkinv(playerid, params[])
{
    new targetid;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /checkinv [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}

	DisplayInventory(targetid, playerid);
	return 1;
}

CMD:slap(playerid, params[])
{
    new targetid, Float:height;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "uF(5.0)", targetid, height))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /slap [playerid] [height (optional)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not spawned and therefore cannot be slapped.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin] || PlayerInfo[targetid][pAdmin] == 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you.");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);
	SetPlayerPos(targetid, x, y, z + height);

	SAM(COLOR_LIGHTRED, "AdmCmd: %s was slapped by %s.", GetRPName(targetid), GetRPName(playerid));
	PlayerPlaySound(targetid, 1130, 0.0, 0.0, 0.0);

	return 1;
}

CMD:charity(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_SYNTAX, "It has been disabled due to abuse of this command.");
}

CMD:music(playerid, params[])
{
 	SendClientMessage(playerid, SERVER_COLOR, ""SERVER_URL"/music");
    HTTP(playerid, HTTP_GET, SERVER_FETCH_URL, "", "HTTP_OnMusicFetchResponse");
   	SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gplay - /gplayurl - /setradio");
 	return 1;
}

CMD:stopmusic(playerid, params[])
{
	SendClientMessage(playerid, COLOR_YELLOW, "You have stopped all active audio streams playing for yourself.");
	PlayerInfo[playerid][pStreamType] = MUSIC_NONE;
	StopAudioStreamForPlayer(playerid);
	return 1;
}

CMD:gplay(playerid, params[])
{
	new url[144];

	if(PlayerInfo[playerid][pAdmin] < 4)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	 	SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gplay [songfolder/name.mp3]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "Go to "SERVER_URL"/music to view a list of our music.");
	 	return 1;
	}

    format(url, sizeof(url), "http://%s/%s", SERVER_MUSIC_URL, params);

    foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pToggleMusic])
	    {
			PlayAudioStreamForPlayer(i, url);
			SM(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of %s.", GetRPName(playerid), params);
			SM(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
		}
	}

	return 1;
}

CMD:gplayurl(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(isnull(params))
	{
	 	SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gplayurl [link]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "Go to "SERVER_URL"/music to view a list of our music.");
	 	return 1;
	}

    foreach(new i : Player)
	{
	    if(!PlayerInfo[i][pToggleMusic])
	    {
			PlayAudioStreamForPlayer(i, params);
			SM(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of a custom URL.", GetRPName(playerid));
			SM(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
		}
	}
	return 1;
}

CMD:gstop(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

    foreach(new i: Player)
	{
	    if(!PlayerInfo[i][pToggleMusic])
	    {
		    StopAudioStreamForPlayer(i);
			SM(i, COLOR_LIGHTRED, "AdmCmd: %s has stopped all active audio streams.", GetRPName(playerid));
		}
	}

	return 1;
}

