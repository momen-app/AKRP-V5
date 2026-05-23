#if defined _akrp_async_dialogs_included
	#endinput
#endif
#define _akrp_async_dialogs_included

#define ASYNC_DIALOG_BASE (30000)
#define ASYNC_DIALOG_ID(%0) (ASYNC_DIALOG_BASE + (%0))

new bool:AsyncDialogActive[MAX_PLAYERS];
new AsyncDialogModule[MAX_PLAYERS];
new AsyncDialogRequest[MAX_PLAYERS];

stock AsyncDialog_Reset(playerid)
{
	AsyncDialogActive[playerid] = false;
	AsyncDialogModule[playerid] = INVALID_MODULE_ID;
	AsyncDialogRequest[playerid] = 0;
	return 1;
}

stock AsyncDialog_Show(playerid, moduleid, requestid, style, const caption[], const info[], const button1[], const button2[])
{
	if(!Module_IsEnabled(MODULE_DIALOGS))
	{
		return ShowPlayerDialog(playerid, ASYNC_DIALOG_ID(playerid), style, caption, info, button1, button2);
	}

	AsyncDialogActive[playerid] = true;
	AsyncDialogModule[playerid] = moduleid;
	AsyncDialogRequest[playerid] = requestid;
	return ShowPlayerDialog(playerid, ASYNC_DIALOG_ID(playerid), style, caption, info, button1, button2);
}

stock AsyncDialog_Close(playerid)
{
	AsyncDialog_Reset(playerid);
	return ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
}

stock AsyncDialog_OnResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid != ASYNC_DIALOG_ID(playerid))
	{
		return 0;
	}

	if(!AsyncDialogActive[playerid])
	{
		return 1;
	}

	new moduleid = AsyncDialogModule[playerid];
	new requestid = AsyncDialogRequest[playerid];
	AsyncDialog_Reset(playerid);

	return Module_OnDialogResponse(moduleid, playerid, requestid, response, listitem, inputtext);
}
