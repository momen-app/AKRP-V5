#if defined _akrp_jobs_registry_included
	#endinput
#endif
#define _akrp_jobs_registry_included

#define MAX_REGISTERED_JOBS (32)
#define INVALID_JOB_INDEX (-1)

enum eRegisteredJob
{
	rjJobId,
	rjName[32],
	bool:rjEnabled
};

new RegisteredJobs[MAX_REGISTERED_JOBS][eRegisteredJob];
new RegisteredJobCount;

stock JobRegistry_Reset()
{
	RegisteredJobCount = 0;
	for(new i = 0; i < MAX_REGISTERED_JOBS; i++)
	{
		RegisteredJobs[i][rjJobId] = JOB_NONE;
		RegisteredJobs[i][rjName][0] = EOS;
		RegisteredJobs[i][rjEnabled] = false;
	}
	return 1;
}

stock Job_Register(jobid, const name[], bool:enabled = true)
{
	if(RegisteredJobCount >= MAX_REGISTERED_JOBS)
	{
		printf("[AKRP:Jobs] Cannot register %s. MAX_REGISTERED_JOBS reached.", name);
		return INVALID_JOB_INDEX;
	}

	new index = RegisteredJobCount++;
	RegisteredJobs[index][rjJobId] = jobid;
	format(RegisteredJobs[index][rjName], 32, "%s", name);
	RegisteredJobs[index][rjEnabled] = enabled;
	return index;
}

stock Job_FindById(jobid)
{
	for(new i = 0; i < RegisteredJobCount; i++)
	{
		if(RegisteredJobs[i][rjJobId] == jobid)
		{
			return i;
		}
	}
	return INVALID_JOB_INDEX;
}

stock Job_FindByName(const name[])
{
	for(new i = 0; i < RegisteredJobCount; i++)
	{
		if(!strcmp(RegisteredJobs[i][rjName], name, true))
		{
			return i;
		}
	}
	return INVALID_JOB_INDEX;
}

stock Job_SetEnabled(jobid, bool:enabled)
{
	new index = Job_FindById(jobid);
	if(index == INVALID_JOB_INDEX)
	{
		return 0;
	}

	RegisteredJobs[index][rjEnabled] = enabled;
	return 1;
}

stock Job_IsEnabled(jobid)
{
	if(jobid == JOB_NONE)
	{
		return 1;
	}

	if(!Module_IsEnabled(MODULE_JOBS))
	{
		return 0;
	}

	new index = Job_FindById(jobid);
	if(index == INVALID_JOB_INDEX)
	{
		return 0;
	}

	return RegisteredJobs[index][rjEnabled];
}

stock Job_CanJoin(playerid, jobid)
{
	if(!Job_IsEnabled(jobid))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "This job is currently disabled by server configuration.");
		return 0;
	}
	return 1;
}

stock PlayerHasAnyEnabledJob(playerid)
{
	return ((PlayerInfo[playerid][pJob] != JOB_NONE && Job_IsEnabled(PlayerInfo[playerid][pJob])) ||
		(PlayerInfo[playerid][pSecondJob] != JOB_NONE && Job_IsEnabled(PlayerInfo[playerid][pSecondJob])));
}

stock JobRegistry_ApplyConfigLine(line[])
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

	if(strfind(key, "job.", true) != 0)
	{
		return 1;
	}

	strdel(key, 0, 4);

	new index = Job_FindByName(key);
	if(index != INVALID_JOB_INDEX)
	{
		RegisteredJobs[index][rjEnabled] = bool:(strval(value) != 0);
	}
	return 1;
}

stock JobRegistry_LoadConfig()
{
	if(!fexist(AKRP_MODULE_CONFIG))
	{
		return 1;
	}

	new File:handle = fopen(AKRP_MODULE_CONFIG, io_read);
	if(!handle)
	{
		return 0;
	}

	new line[128];
	while(fread(handle, line))
	{
		JobRegistry_ApplyConfigLine(line);
	}
	fclose(handle);
	return 1;
}

stock JobRegistry_Bootstrap()
{
	JobRegistry_Reset();

	Job_Register(JOB_FARMER, "farmer", true);
	Job_Register(JOB_COURIER, "trucker", true);
	Job_Register(JOB_MINER, "miner", true);
	Job_Register(JOB_CORONER, "coroner", true);
	Job_Register(JOB_OILEXPO, "oil_expo", true);
	Job_Register(JOB_ATM, "atm_deliver", true);
	Job_Register(JOB_SANDALWOOD, "sandal_wood", true);
	Job_Register(JOB_FRUITPICKER, "fruit_picker", true);
	Job_Register(JOB_SIGNAL, "signal", true);

	JobRegistry_LoadConfig();
	return 1;
}

stock JobRegistry_OnQueryResult(requestid)
{
	#pragma unused requestid
	return 1;
}

stock JobRegistry_BuildEnabledList(dest[], len)
{
	dest[0] = EOS;

	for(new i = 0; i < sizeof(jobLocations); i++)
	{
		if(!Job_IsEnabled(i))
		{
			continue;
		}

		format(dest, len, "%s%s\n", dest, jobLocations[i][jobName]);
	}
	return 1;
}

CMD:jobs(playerid, params[])
{
	if(!Module_IsEnabled(MODULE_JOBS))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The jobs module is currently disabled.");
	}

	new string[512];
	JobRegistry_BuildEnabledList(string, sizeof(string));
	if(!string[0])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "No jobs are currently enabled.");
	}

	ShowPlayerDialog(playerid, DIALOG_JOBINFO, DIALOG_STYLE_LIST, "Available Jobs", string, "Close", "");
	return 1;
}

CMD:jobmodule(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	new name[32], enabledState;
	if(sscanf(params, "s[32]i", name, enabledState))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /jobmodule [job_name] [0/1]");
	}

	new index = Job_FindByName(name);
	if(index == INVALID_JOB_INDEX)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Unknown job. Use /jobs to view enabled job display names.");
	}

	RegisteredJobs[index][rjEnabled] = bool:(enabledState != 0);

	new string[96], stateText[12];
	if(RegisteredJobs[index][rjEnabled])
	{
		format(stateText, sizeof(stateText), "enabled");
	}
	else
	{
		format(stateText, sizeof(stateText), "disabled");
	}
	format(string, sizeof(string), "Job %s is now %s.", RegisteredJobs[index][rjName], stateText);
	SendClientMessage(playerid, COLOR_AQUA, string);
	return 1;
}
