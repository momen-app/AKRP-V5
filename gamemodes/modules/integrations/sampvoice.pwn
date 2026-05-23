#if defined _akrp_sampvoice_included
	#endinput
#endif
#define _akrp_sampvoice_included

#define AKRP_VOICE_KEY_PUSH_TO_TALK (0x42)
#define AKRP_MAX_VOICE_RADIO (30)

new AKRPVoicePhoneTarget[MAX_PLAYERS];
new AKRPVoiceRadioId[MAX_PLAYERS];
new AKRPVoiceFactionRadioId[MAX_PLAYERS];
new SV_LSTREAM:AKRPVoiceLocalStream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:AKRPVoiceRadioStream[AKRP_MAX_VOICE_RADIO + 1] = { SV_NULL, ... };
new SV_GSTREAM:AKRPVoiceCallStream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:AKRPVoiceFactionGangStream[MAX_RADIOS][2];

stock AKRPVoice_ResetPlayer(playerid)
{
	AKRPVoicePhoneTarget[playerid] = INVALID_PLAYER_ID;
	AKRPVoiceRadioId[playerid] = 0;
	AKRPVoiceFactionRadioId[playerid] = 0;
	return 1;
}

stock AKRPVoice_DeleteCallStream(playerid)
{
	if(AKRPVoiceCallStream[playerid])
	{
		new targetid = AKRPVoicePhoneTarget[playerid];
		new SV_GSTREAM:stream = AKRPVoiceCallStream[playerid];

		SvDeleteStream(stream);
		AKRPVoiceCallStream[playerid] = SV_NULL;
		AKRPVoicePhoneTarget[playerid] = INVALID_PLAYER_ID;

		if(IsPlayerConnected(targetid) && AKRPVoiceCallStream[targetid] == stream)
		{
			AKRPVoiceCallStream[targetid] = SV_NULL;
			AKRPVoicePhoneTarget[targetid] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

stock AKRPVoice_OnGameModeInit()
{
	new string[32];

	for(new i = 1; i <= AKRP_MAX_VOICE_RADIO; i++)
	{
		if(AKRPVoiceRadioStream[i])
		{
			continue;
		}

		format(string, sizeof(string), "radio_freq-%i", i);
		AKRPVoiceRadioStream[i] = SvCreateGStream(0xffff0000, string);
	}

	print("[AKRP:SAMPVoice] Integrated voice module loaded.");
	return 1;
}

stock AKRPVoice_OnGameModeExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(AKRPVoiceLocalStream[i])
		{
			SvDeleteStream(AKRPVoiceLocalStream[i]);
			AKRPVoiceLocalStream[i] = SV_NULL;
		}

		if(AKRPVoiceCallStream[i])
		{
			AKRPVoice_DeleteCallStream(i);
		}
	}

	for(new i = 1; i <= AKRP_MAX_VOICE_RADIO; i++)
	{
		if(AKRPVoiceRadioStream[i])
		{
			SvDeleteStream(AKRPVoiceRadioStream[i]);
			AKRPVoiceRadioStream[i] = SV_NULL;
		}
	}

	destroyfgstream();
	print("[AKRP:SAMPVoice] Integrated voice module unloaded.");
	return 1;
}

stock AKRPVoice_OnPlayerConnect(playerid)
{
	AKRPVoice_ResetPlayer(playerid);

	if(SvGetVersion(playerid) == SV_NULL)
	{
		SetPVarInt(playerid, "hasVoiceOnClient", 0);
		SendClientMessage(playerid, -1, "[{00FFFF}AK{FFFFFF}RP] : {FFFF00} SAMP VOICE {FFFFFF} NOT FOUND");
		SendClientMessage(playerid, -1, "[{00FFFF}AK{FFFFFF}RP] : {FFFF00} [{FF00FF}BOT{FFFFFF}-AKRP] You Have Kicked Reason :{FF0000} SAMP-VOICE NOT FOUND {FFFFFF}");
		//KickPlayer(playerid);
		return 1;
	}

	if(SvHasMicro(playerid) == SV_FALSE)
	{
		SetPVarInt(playerid, "hasVoiceOnClient", 2);
		SendClientMessage(playerid, -1, "[{00FFFF}AK{FFFFFF}RP] : {FFFF00} MICRO PHONE {FFFFFF} NOT FOUND");
		return 1;
	}

	new localName[] = "Local";
	AKRPVoiceLocalStream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, localName);
	if(AKRPVoiceLocalStream[playerid])
	{
		SvAddKey(playerid, AKRP_VOICE_KEY_PUSH_TO_TALK);
		SetPVarInt(playerid, "hasVoiceOnClient", 1);
		SendClientMessage(playerid, -1, "{00FFFF}[AKRP]{FFFFFF} : {FFFF00}SAMP VOICE SUCCESSFULLY ACTIVATED{FFFFFF}");
	}

	return 1;
}

stock AKRPVoice_OnPlayerDisconnect(playerid, reason)
{
	#pragma unused reason

	if(AKRPVoiceLocalStream[playerid])
	{
		SvDeleteStream(AKRPVoiceLocalStream[playerid]);
		AKRPVoiceLocalStream[playerid] = SV_NULL;
	}

	AKRPVoice_DeleteCallStream(playerid);
	LeavePrivateVoiceChannel(playerid);
	LeaveGroupVoiceChannel(playerid);
	LeaveFgVoiceChannel(playerid, 0);
	LeaveFgVoiceChannel(playerid, 1);
	AKRPVoice_ResetPlayer(playerid);
	return 1;
}

stock AKRPVoice_OnDialogResponse(playerid, requestid, response, listitem, inputtext[])
{
	#pragma unused playerid
	#pragma unused requestid
	#pragma unused response
	#pragma unused listitem
	#pragma unused inputtext
	return 0;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return;
	}

	if(keyid != AKRP_VOICE_KEY_PUSH_TO_TALK)
	{
		return;
	}

	new pvarTalkStats = GetPVarInt(playerid, "talkStats");
	new pvarTalkStats2 = GetPVarInt(playerid, "radiostat");

	if(pvarTalkStats != 3)
	{
		new callid = AKRPVoicePhoneTarget[playerid];
		if(callid != INVALID_PLAYER_ID && AKRPVoiceCallStream[playerid])
		{
			if(!SvHasSpeakerInStream(AKRPVoiceCallStream[playerid], playerid))
			{
				SvAttachSpeakerToStream(AKRPVoiceCallStream[playerid], playerid);
			}
		}
		else if(AKRPVoiceLocalStream[playerid])
		{
			if(!SvHasSpeakerInStream(AKRPVoiceLocalStream[playerid], playerid))
			{
				SvAttachSpeakerToStream(AKRPVoiceLocalStream[playerid], playerid);
			}
		}
	}
	else
	{
		new radioid = AKRPVoiceRadioId[playerid];
		if(1 <= radioid <= AKRP_MAX_VOICE_RADIO && AKRPVoiceRadioStream[radioid])
		{
			if(!SvHasSpeakerInStream(AKRPVoiceRadioStream[radioid], playerid))
			{
				SvAttachSpeakerToStream(AKRPVoiceRadioStream[radioid], playerid);
			}
		}
	}

	if(pvarTalkStats2 == 1)
	{
		new factionid = AKRPVoiceFactionRadioId[playerid];
		if(0 <= factionid < MAX_RADIOS && AKRPVoiceFactionGangStream[factionid][1])
		{
			if(!SvHasSpeakerInStream(AKRPVoiceFactionGangStream[factionid][1], playerid))
			{
				SvAttachSpeakerToStream(AKRPVoiceFactionGangStream[factionid][1], playerid);
			}
		}
	}
	else if(pvarTalkStats2 == 2)
	{
		new gangid = AKRPVoiceFactionRadioId[playerid];
		if(0 <= gangid < MAX_RADIOS && AKRPVoiceFactionGangStream[gangid][0])
		{
			if(!SvHasSpeakerInStream(AKRPVoiceFactionGangStream[gangid][0], playerid))
			{
				SvAttachSpeakerToStream(AKRPVoiceFactionGangStream[gangid][0], playerid);
			}
		}
	}
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return;
	}

	if(keyid != AKRP_VOICE_KEY_PUSH_TO_TALK)
	{
		return;
	}

	if(AKRPVoiceCallStream[playerid] && SvHasSpeakerInStream(AKRPVoiceCallStream[playerid], playerid))
	{
		SvDetachSpeakerFromStream(AKRPVoiceCallStream[playerid], playerid);
	}

	if(AKRPVoiceLocalStream[playerid] && SvHasSpeakerInStream(AKRPVoiceLocalStream[playerid], playerid))
	{
		SvDetachSpeakerFromStream(AKRPVoiceLocalStream[playerid], playerid);
	}

	new radioid = AKRPVoiceRadioId[playerid];
	if(1 <= radioid <= AKRP_MAX_VOICE_RADIO && AKRPVoiceRadioStream[radioid])
	{
		if(SvHasSpeakerInStream(AKRPVoiceRadioStream[radioid], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceRadioStream[radioid], playerid);
		}
	}

	new factionid = AKRPVoiceFactionRadioId[playerid];
	if(0 <= factionid < MAX_RADIOS && AKRPVoiceFactionGangStream[factionid][1])
	{
		if(SvHasSpeakerInStream(AKRPVoiceFactionGangStream[factionid][1], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceFactionGangStream[factionid][1], playerid);
		}
	}

	new gangid = AKRPVoiceFactionRadioId[playerid];
	if(0 <= gangid < MAX_RADIOS && AKRPVoiceFactionGangStream[gangid][0])
	{
		if(SvHasSpeakerInStream(AKRPVoiceFactionGangStream[gangid][0], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceFactionGangStream[gangid][0], playerid);
		}
	}
}

forward ToggleListenerLocalStream(playerid, targetid, status);
public ToggleListenerLocalStream(playerid, targetid, status)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	if(!(0 <= playerid < MAX_PLAYERS) || !(0 <= targetid < MAX_PLAYERS))
	{
		return 1;
	}

	if(!AKRPVoiceLocalStream[playerid])
	{
		return 1;
	}

	if(status)
	{
		if(!SvHasListenerInStream(AKRPVoiceLocalStream[playerid], targetid))
		{
			SvAttachListenerToStream(AKRPVoiceLocalStream[playerid], targetid);
		}
	}
	else
	{
		if(SvHasListenerInStream(AKRPVoiceLocalStream[playerid], targetid))
		{
			SvDetachListenerFromStream(AKRPVoiceLocalStream[playerid], targetid);
		}
	}
	return 1;
}

forward deletecallstream(playerid);
public deletecallstream(playerid)
{
	return AKRPVoice_DeleteCallStream(playerid);
}

forward callstreams(targetid, playerid);
public callstreams(targetid, playerid)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	if(!IsPlayerConnected(targetid) || !IsPlayerConnected(playerid))
	{
		return 1;
	}

	AKRPVoice_DeleteCallStream(playerid);
	AKRPVoice_DeleteCallStream(targetid);

	new callName[] = "Call";
	new SV_GSTREAM:stream = SvCreateGStream(0xffff0000, callName);
	if(stream)
	{
		AKRPVoiceCallStream[playerid] = stream;
		AKRPVoiceCallStream[targetid] = stream;
		AKRPVoicePhoneTarget[playerid] = targetid;
		AKRPVoicePhoneTarget[targetid] = playerid;
		SvAttachListenerToStream(stream, playerid);
		SvAttachListenerToStream(stream, targetid);
	}
	return 1;
}

forward createfgstream(fgid, type);
public createfgstream(fgid, type)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	if(!(0 <= fgid < MAX_RADIOS) || !(0 <= type <= 1))
	{
		return 1;
	}

	if(AKRPVoiceFactionGangStream[fgid][type])
	{
		return 1;
	}

	new string[32];
	if(type == 0)
	{
		format(string, sizeof(string), "gang_radio-%i", fgid);
	}
	else
	{
		format(string, sizeof(string), "faction_radio-%i", fgid);
	}

	AKRPVoiceFactionGangStream[fgid][type] = SvCreateGStream(0xffff0000, string);
	return 1;
}

forward destroyfgstream();
public destroyfgstream()
{
	for(new i = 0; i < MAX_RADIOS; i++)
	{
		if(AKRPVoiceFactionGangStream[i][0])
		{
			SvDeleteStream(AKRPVoiceFactionGangStream[i][0]);
			AKRPVoiceFactionGangStream[i][0] = SV_NULL;
		}

		if(AKRPVoiceFactionGangStream[i][1])
		{
			SvDeleteStream(AKRPVoiceFactionGangStream[i][1]);
			AKRPVoiceFactionGangStream[i][1] = SV_NULL;
		}
	}
	return 1;
}

forward JoinPrivateVoiceChannel(playerid, targetid);
public JoinPrivateVoiceChannel(playerid, targetid)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	LeavePrivateVoiceChannel(playerid);
	if(IsPlayerConnected(targetid) && AKRPVoiceCallStream[targetid])
	{
		if(!SvHasListenerInStream(AKRPVoiceCallStream[targetid], playerid))
		{
			SvAttachListenerToStream(AKRPVoiceCallStream[targetid], playerid);
		}
		AKRPVoiceCallStream[playerid] = AKRPVoiceCallStream[targetid];
		AKRPVoicePhoneTarget[playerid] = targetid;
	}
	return 1;
}

forward LeavePrivateVoiceChannel(playerid);
public LeavePrivateVoiceChannel(playerid)
{
	new oldchannelid = AKRPVoicePhoneTarget[playerid];
	AKRPVoicePhoneTarget[playerid] = INVALID_PLAYER_ID;

	if(oldchannelid != INVALID_PLAYER_ID && AKRPVoiceCallStream[playerid])
	{
		if(SvHasSpeakerInStream(AKRPVoiceCallStream[playerid], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceCallStream[playerid], playerid);
		}

		if(SvHasListenerInStream(AKRPVoiceCallStream[playerid], playerid))
		{
			SvDetachListenerFromStream(AKRPVoiceCallStream[playerid], playerid);
		}
	}
	return 1;
}

forward JoinFgVoiceChannel(fgid, playerid, type);
public JoinFgVoiceChannel(fgid, playerid, type)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	if(!(0 <= fgid < MAX_RADIOS) || !(0 <= type <= 1))
	{
		return 1;
	}

	LeaveFgVoiceChannel(playerid, type);
	if(AKRPVoiceFactionGangStream[fgid][type])
	{
		if(!SvHasListenerInStream(AKRPVoiceFactionGangStream[fgid][type], playerid))
		{
			SvAttachListenerToStream(AKRPVoiceFactionGangStream[fgid][type], playerid);
		}
	}

	AKRPVoiceFactionRadioId[playerid] = fgid;
	return 1;
}

forward LeaveFgVoiceChannel(playerid, type);
public LeaveFgVoiceChannel(playerid, type)
{
	new oldchannelid = AKRPVoiceFactionRadioId[playerid];
	AKRPVoiceFactionRadioId[playerid] = 0;

	if(0 <= oldchannelid < MAX_RADIOS && 0 <= type <= 1 && AKRPVoiceFactionGangStream[oldchannelid][type])
	{
		if(SvHasSpeakerInStream(AKRPVoiceFactionGangStream[oldchannelid][type], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceFactionGangStream[oldchannelid][type], playerid);
		}

		if(SvHasListenerInStream(AKRPVoiceFactionGangStream[oldchannelid][type], playerid))
		{
			SvDetachListenerFromStream(AKRPVoiceFactionGangStream[oldchannelid][type], playerid);
		}
	}
	return 1;
}

forward JoinGroupVoiceChannel(playerid, frequency_id);
public JoinGroupVoiceChannel(playerid, frequency_id)
{
	if(!Module_IsEnabled(MODULE_SAMPVOICE))
	{
		return 1;
	}

	LeaveGroupVoiceChannel(playerid);
	if(1 <= frequency_id <= AKRP_MAX_VOICE_RADIO && AKRPVoiceRadioStream[frequency_id])
	{
		if(!SvHasListenerInStream(AKRPVoiceRadioStream[frequency_id], playerid))
		{
			SvAttachListenerToStream(AKRPVoiceRadioStream[frequency_id], playerid);
		}
		AKRPVoiceRadioId[playerid] = frequency_id;
	}
	return 1;
}

forward LeaveGroupVoiceChannel(playerid);
public LeaveGroupVoiceChannel(playerid)
{
	new oldchannelid = AKRPVoiceRadioId[playerid];
	AKRPVoiceRadioId[playerid] = 0;

	if(1 <= oldchannelid <= AKRP_MAX_VOICE_RADIO && AKRPVoiceRadioStream[oldchannelid])
	{
		if(SvHasSpeakerInStream(AKRPVoiceRadioStream[oldchannelid], playerid))
		{
			SvDetachSpeakerFromStream(AKRPVoiceRadioStream[oldchannelid], playerid);
		}

		if(SvHasListenerInStream(AKRPVoiceRadioStream[oldchannelid], playerid))
		{
			SvDetachListenerFromStream(AKRPVoiceRadioStream[oldchannelid], playerid);
		}
	}
	return 1;
}
