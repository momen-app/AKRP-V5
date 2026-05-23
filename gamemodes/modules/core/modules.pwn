#if defined _akrp_modules_included
	#endinput
#endif
#define _akrp_modules_included

#define AKRP_MODULE_CONFIG "akrp_modules.ini"
#define INVALID_MODULE_ID (-1)

enum
{
	MODULE_CORE,
	MODULE_DATABASE,
	MODULE_DIALOGS,
	MODULE_JOBS,
	MODULE_SAFEZONES,
	MODULE_INVENTORY,
	MODULE_BACKGUN,
	MODULE_ANTICHEAT,
	MODULE_DISCORD,
	MODULE_MAPPINGS,
	MODULE_SAMPVOICE,
	MODULE_COUNT
};

enum
{
	MODULE_CATEGORY_CORE,
	MODULE_CATEGORY_SERVER,
	MODULE_CATEGORY_CLIENT,
	MODULE_CATEGORY_JOB,
	MODULE_CATEGORY_INTEGRATION
};

new ModuleName[MODULE_COUNT][32];
new ModuleCategory[MODULE_COUNT];
new bool:ModuleEnabled[MODULE_COUNT];
new bool:ModuleRunning[MODULE_COUNT];

stock Module_Reset()
{
	for(new i = 0; i < MODULE_COUNT; i++)
	{
		ModuleName[i][0] = EOS;
		ModuleCategory[i] = MODULE_CATEGORY_SERVER;
		ModuleEnabled[i] = true;
		ModuleRunning[i] = false;
	}
	return 1;
}

stock Module_Register(moduleid, const name[], category, bool:enabled = true)
{
	if(!(0 <= moduleid < MODULE_COUNT))
	{
		return 0;
	}

	format(ModuleName[moduleid], 32, "%s", name);
	ModuleCategory[moduleid] = category;
	ModuleEnabled[moduleid] = enabled;
	ModuleRunning[moduleid] = false;
	return 1;
}

stock Module_IsValid(moduleid)
{
	return (0 <= moduleid < MODULE_COUNT && ModuleName[moduleid][0] != EOS);
}

stock Module_IsEnabled(moduleid)
{
	if(!Module_IsValid(moduleid))
	{
		return 0;
	}

	return ModuleEnabled[moduleid];
}

stock Module_FindByName(const name[])
{
	for(new i = 0; i < MODULE_COUNT; i++)
	{
		if(ModuleName[i][0] && !strcmp(ModuleName[i], name, true))
		{
			return i;
		}
	}
	return INVALID_MODULE_ID;
}

stock Module_IsWhitespace(ch)
{
	return (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n');
}

stock Module_Trim(text[])
{
	new start;
	while(text[start] && Module_IsWhitespace(text[start]))
	{
		start++;
	}
	if(start > 0)
	{
		strdel(text, 0, start);
	}

	new end = strlen(text) - 1;
	while(end >= 0 && Module_IsWhitespace(text[end]))
	{
		text[end] = EOS;
		end--;
	}
	return 1;
}

stock Module_SetEnabledRaw(moduleid, bool:enabled)
{
	if(!Module_IsValid(moduleid))
	{
		return 0;
	}

	ModuleEnabled[moduleid] = enabled;
	return 1;
}

stock Module_ApplyConfigLine(line[])
{
	Module_Trim(line);

	if(!line[0] || line[0] == '#' || line[0] == ';')
	{
		return 1;
	}

	new equals = strfind(line, "=");
	if(equals == -1)
	{
		return 1;
	}

	new key[32], value[16];
	strmid(key, line, 0, equals, sizeof(key));
	strmid(value, line, equals + 1, strlen(line), sizeof(value));
	Module_Trim(key);
	Module_Trim(value);

	if(strfind(key, "module.", true) != 0)
	{
		return 1;
	}

	strdel(key, 0, 7);

	new moduleid = Module_FindByName(key);
	if(moduleid != INVALID_MODULE_ID)
	{
		Module_SetEnabledRaw(moduleid, bool:(strval(value) != 0));
	}
	return 1;
}

stock Module_LoadConfig()
{
	if(!fexist(AKRP_MODULE_CONFIG))
	{
		printf("[AKRP:Modules] %s not found. Using compiled defaults.", AKRP_MODULE_CONFIG);
		return 1;
	}

	new File:handle = fopen(AKRP_MODULE_CONFIG, io_read);
	if(!handle)
	{
		printf("[AKRP:Modules] Unable to open %s. Using compiled defaults.", AKRP_MODULE_CONFIG);
		return 0;
	}

	new line[128];
	while(fread(handle, line))
	{
		Module_ApplyConfigLine(line);
	}
	fclose(handle);
	return 1;
}

stock Module_Bootstrap()
{
	Module_Reset();

	Module_Register(MODULE_CORE, "core", MODULE_CATEGORY_CORE, true);
	Module_Register(MODULE_DATABASE, "database", MODULE_CATEGORY_CORE, true);
	Module_Register(MODULE_DIALOGS, "dialogs", MODULE_CATEGORY_CORE, true);
	Module_Register(MODULE_JOBS, "jobs", MODULE_CATEGORY_JOB, true);
	Module_Register(MODULE_SAFEZONES, "safezones", MODULE_CATEGORY_SERVER, true);
	Module_Register(MODULE_INVENTORY, "inventory", MODULE_CATEGORY_CLIENT, true);
	Module_Register(MODULE_BACKGUN, "backgun", MODULE_CATEGORY_CLIENT, true);
	Module_Register(MODULE_ANTICHEAT, "anticheat", MODULE_CATEGORY_SERVER, true);
	Module_Register(MODULE_DISCORD, "discord", MODULE_CATEGORY_INTEGRATION, true);
	Module_Register(MODULE_MAPPINGS, "mappings", MODULE_CATEGORY_SERVER, true);
	Module_Register(MODULE_SAMPVOICE, "sampvoice", MODULE_CATEGORY_INTEGRATION, true);

	Module_LoadConfig();
	return 1;
}

stock Module_Start(moduleid)
{
	if(!Module_IsEnabled(moduleid) || ModuleRunning[moduleid])
	{
		return 1;
	}

	switch(moduleid)
	{
		case MODULE_JOBS:
		{
			JobRegistry_Bootstrap();
		}
		case MODULE_SAMPVOICE:
		{
			AKRPVoice_OnGameModeInit();
		}
	}

	ModuleRunning[moduleid] = true;
	return 1;
}

stock Module_Stop(moduleid)
{
	if(!Module_IsValid(moduleid) || !ModuleRunning[moduleid])
	{
		return 1;
	}

	switch(moduleid)
	{
		case MODULE_SAMPVOICE:
		{
			AKRPVoice_OnGameModeExit();
		}
	}

	ModuleRunning[moduleid] = false;
	return 1;
}

stock Module_StartAll()
{
	for(new i = 0; i < MODULE_COUNT; i++)
	{
		Module_Start(i);
	}
	return 1;
}

stock Module_StopAll()
{
	for(new i = MODULE_COUNT - 1; i >= 0; i--)
	{
		Module_Stop(i);
	}
	return 1;
}

stock Module_SetEnabled(moduleid, bool:enabled)
{
	if(!Module_IsValid(moduleid))
	{
		return 0;
	}

	if(ModuleEnabled[moduleid] == enabled)
	{
		return 1;
	}

	if(enabled)
	{
		ModuleEnabled[moduleid] = true;
		Module_Start(moduleid);
	}
	else
	{
		Module_Stop(moduleid);
		ModuleEnabled[moduleid] = false;
	}
	return 1;
}

stock Module_OnPlayerConnect(playerid)
{
	if(Module_IsEnabled(MODULE_SAMPVOICE))
	{
		if(!AKRPVoice_OnPlayerConnect(playerid))
		{
			return 0;
		}
	}
	return 1;
}

stock Module_OnPlayerDisconnect(playerid, reason)
{
	if(Module_IsEnabled(MODULE_SAMPVOICE))
	{
		AKRPVoice_OnPlayerDisconnect(playerid, reason);
	}
	return 1;
}

stock Module_OnDialogResponse(moduleid, playerid, requestid, response, listitem, inputtext[])
{
	switch(moduleid)
	{
		case MODULE_SAMPVOICE:
		{
			return AKRPVoice_OnDialogResponse(playerid, requestid, response, listitem, inputtext);
		}
	}
	return 0;
}

stock Module_OnQueryResult(moduleid, requestid)
{
	switch(moduleid)
	{
		case MODULE_JOBS:
		{
			return JobRegistry_OnQueryResult(requestid);
		}
	}
	return 1;
}

stock Module_GetStateText(moduleid, dest[], len)
{
	if(!Module_IsValid(moduleid))
	{
		format(dest, len, "invalid");
	}
	else if(ModuleEnabled[moduleid])
	{
		format(dest, len, "enabled");
	}
	else
	{
		format(dest, len, "disabled");
	}
	return 1;
}

CMD:modules(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	new line[96], stateText[12];
	SendClientMessage(playerid, COLOR_AQUA, "Loaded AKRP modules:");
	for(new i = 0; i < MODULE_COUNT; i++)
	{
		Module_GetStateText(i, stateText, sizeof(stateText));
		format(line, sizeof(line), "- %s: %s", ModuleName[i], stateText);
		SendClientMessage(playerid, COLOR_AQUA, line);
	}
	return 1;
}

CMD:module(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	new name[32], enabledState;
	if(sscanf(params, "s[32]i", name, enabledState))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /module [name] [0/1]");
	}

	new moduleid = Module_FindByName(name);
	if(moduleid == INVALID_MODULE_ID)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Unknown module. Use /modules to list loaded modules.");
	}

	Module_SetEnabled(moduleid, bool:(enabledState != 0));

	new string[96], stateText[12];
	Module_GetStateText(moduleid, stateText, sizeof(stateText));
	format(string, sizeof(string), "Module %s is now %s.", ModuleName[moduleid], stateText);
	SendClientMessage(playerid, COLOR_AQUA, string);
	return 1;
}
