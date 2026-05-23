stock GetFactionByID(sqlid)
{
	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionInfo[i][fType] == sqlid)
	    return i;

	return -1;
}

stock GetGateByID(sqlid)
{
	for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateID] == sqlid)
	    return i;

	return -1;
}

forward OnObjectCreated(gateid);
public OnObjectCreated(gateid)
{
	if (gateid == -1 || !ObjectData[gateid][mobjExists])
	    return 0;

	ObjectData[gateid][mobjID] = cache_insert_id();
	Object_Save(gateid);

	return 1;
}

forward OnVendorCreated(vendorid);
public OnVendorCreated(vendorid)
{
	if (vendorid == -1 || !VendorData[vendorid][vendorExists])
	    return 0;

	VendorData[vendorid][vendorID] = cache_insert_id();
	Vendor_Save(vendorid);

	return 1;
}

forward OnGateCreated(gateid);
public OnGateCreated(gateid)
{
	if (gateid == -1 || !GateData[gateid][gateExists])
	    return 0;

	GateData[gateid][gateID] = cache_insert_id();
	Gate_Save(gateid);

	return 1;
}

stock Speed_Refresh(speedid)
{
	if (speedid != -1 && SpeedData[speedid][speedExists])
	{
	    new
	        string[64];

		if (IsValidDynamicObject(SpeedData[speedid][speedObject]))
		    DestroyDynamicObject(SpeedData[speedid][speedObject]);

		if (IsValidDynamic3DTextLabel(SpeedData[speedid][speedText3D]))
		    DestroyDynamic3DTextLabel(SpeedData[speedid][speedText3D]);

		format(string, sizeof(string), "%.0f MPH Speed Limit\n"GREY"(( Type '/rules' > 'Speed Laws' for info. ))", SpeedData[speedid][speedLimit]);

		SpeedData[speedid][speedText3D] = CreateDynamic3DTextLabel(string, 0xFF0000FF, SpeedData[speedid][speedPos][0], SpeedData[speedid][speedPos][1], SpeedData[speedid][speedPos][2] + 2.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
        SpeedData[speedid][speedObject] = CreateDynamicObject(18880, SpeedData[speedid][speedPos][0], SpeedData[speedid][speedPos][1], SpeedData[speedid][speedPos][2], 0.0, 0.0, SpeedData[speedid][speedPos][3]);
		//SpeedData[speedid][sMapIcon] = CreateDynamicMapIcon(SpeedData[speedid][speedPos][0], SpeedData[speedid][speedPos][1], SpeedData[speedid][speedPos][2], 56, 0, .style = MAPICON_GLOBAL);
	}
	return 1;
}

stock Speed_Save(speedid)
{
	new
	    query[255];

	format(query, sizeof(query), "UPDATE `speedcameras` SET `speedRange` = '%.4f', `speedLimit` = '%.4f', `speedX` = '%.4f', `speedY` = '%.4f', `speedZ` = '%.4f', `speedAngle` = '%.4f' WHERE `speedID` = '%d'",
	    SpeedData[speedid][speedRange],
	    SpeedData[speedid][speedLimit],
	    SpeedData[speedid][speedPos][0],
	    SpeedData[speedid][speedPos][1],
	    SpeedData[speedid][speedPos][2],
	    SpeedData[speedid][speedPos][3],
	    SpeedData[speedid][speedID]
	);
	return mysql_tquery(connectionID, query);
}

stock Speed_Nearest(playerid)
{
	for (new i = 0; i < MAX_SPEED_CAMERAS; i ++) if (SpeedData[i][speedExists] && IsPlayerInRangeOfPoint(playerid, SpeedData[i][speedRange], SpeedData[i][speedPos][0], SpeedData[i][speedPos][1], SpeedData[i][speedPos][2]))
	    return i;

	return -1;
}

stock Speed_Delete(speedid)
{
    if (speedid != -1 && SpeedData[speedid][speedExists])
	{
	    new
	        string[64];

		if (IsValidDynamicObject(SpeedData[speedid][speedObject]))
		    DestroyDynamicObject(SpeedData[speedid][speedObject]);

		if (IsValidDynamic3DTextLabel(SpeedData[speedid][speedText3D]))
		    DestroyDynamic3DTextLabel(SpeedData[speedid][speedText3D]);

		format(string, sizeof(string), "DELETE FROM `speedcameras` WHERE `speedID` = '%d'", SpeedData[speedid][speedID]);
		mysql_tquery(connectionID, string);

		SpeedData[speedid][speedExists] = false;
		SpeedData[speedid][speedLimit] = 0.0;
		SpeedData[speedid][speedRange] = 0.0;
		SpeedData[speedid][speedID] = 0;
	}
	return 1;
}

stock Speed_Create(playerid, Float:limit, Float:range)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	for (new i = 0; i < MAX_SPEED_CAMERAS; i ++) if (!SpeedData[i][speedExists])
	{
	    SpeedData[i][speedExists] = true;
	    SpeedData[i][speedRange] = range;
        SpeedData[i][speedLimit] = limit;

		SpeedData[i][speedPos][0] = x + (1.5 * floatsin(-angle, degrees));
	    SpeedData[i][speedPos][1] = y + (1.5 * floatcos(-angle, degrees));
	    SpeedData[i][speedPos][2] = z - 1.2;
	    SpeedData[i][speedPos][3] = angle;

	    Speed_Refresh(i);
	    mysql_tquery(connectionID, "INSERT INTO `speedcameras` (`speedRange`) VALUES(0.0)", "OnSpeedCreated", "d", i);
	    return i;
	}
	return -1;
}
forward OnSpeedCreated(speedid);
public OnSpeedCreated(speedid)
{
	if (speedid == -1 || !SpeedData[speedid][speedExists])
	    return 0;

	SpeedData[speedid][speedID] = cache_insert_id();
	Speed_Save(speedid);

	return 1;
}
forward Speed_Load();
public Speed_Load()
{
	static
	    rows,
	    fields;

	SQL_GetCacheData(rows, fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_SPEED_CAMERAS)
	{
	    SpeedData[i][speedExists] = true;
	    SpeedData[i][speedID] = SQL_GetInt(i, "speedID");
	    SpeedData[i][speedRange] = SQL_GetFloat(i, "speedRange");
	    SpeedData[i][speedLimit] = SQL_GetFloat(i, "speedLimit");
	    SpeedData[i][speedPos][0] = SQL_GetFloat(i, "speedX");
	    SpeedData[i][speedPos][1] = SQL_GetFloat(i, "speedY");
	    SpeedData[i][speedPos][2] = SQL_GetFloat(i, "speedZ");
	    SpeedData[i][speedPos][3] = SQL_GetFloat(i, "speedAngle");

	    Speed_Refresh(i);
	}
	return 1;
}

stock Float:GetPlayerSpeed(playerid)
{
	static Float:velocity[3];

	if (IsPlayerInAnyVehicle(playerid))
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);
	else
	    GetPlayerVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);

	return floatsqroot((velocity[0] * velocity[0]) + (velocity[1] * velocity[1]) + (velocity[2] * velocity[2])) * 100.0;
}

stock IsEngineVehicle(vehicleid)
{
	static const g_aEngineStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
    new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

forward HidePlayerBox(playerid, PlayerText:boxid);
public HidePlayerBox(playerid, PlayerText:boxid)
{
	if (!IsPlayerConnected(playerid))
	    return 0;

	PlayerTextDrawHide(playerid, boxid);
	PlayerTextDrawDestroy(playerid, boxid);

	return 1;
}

stock PlayerText:ShowPlayerBox(playerid, color)
{
	new
	    PlayerText:textid;

    textid = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, textid, 1);
	PlayerTextDrawLetterSize(playerid, textid, 0.500000, 50.000000);
	PlayerTextDrawColour(playerid, textid, -1);
	PlayerTextDrawUseBox(playerid, textid, 1);
	PlayerTextDrawBoxColour(playerid, textid, color);
	PlayerTextDrawTextSize(playerid, textid, 640.000000, 30.000000);
	PlayerTextDrawShow(playerid, textid);

	return textid;
}



forward CheckKeyPress(playerid);
public CheckKeyPress(playerid)
{
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
	if(CurrentCCTV[playerid] > -1 && PlayerMenu[playerid] == -1)
	{
	    if(leftright == KEY_RIGHT)
	  	{
	  	    if(keys == KEY_SPRINT)
			{
	 	    	CCTVDegree[playerid] = (CCTVDegree[playerid] - 2.0);
			}
			else
			{
			    CCTVDegree[playerid] = (CCTVDegree[playerid] - 0.5);
			}
	  	    if(CCTVDegree[playerid] < 0)
	  	    {
	  	        CCTVDegree[playerid] = 359;
			}
	  	    MovePlayerCCTV(playerid);

		}
	    if(leftright == KEY_LEFT)
	    {
	        if(keys == KEY_SPRINT)
			{
	 	    	CCTVDegree[playerid] = (CCTVDegree[playerid] + 2.0);
			}
			else
			{
			    CCTVDegree[playerid] = (CCTVDegree[playerid] + 0.5);
			}
			if(CCTVDegree[playerid] >= 360)
	  	    {
	  	        CCTVDegree[playerid] = 0;
			}
	        MovePlayerCCTV(playerid);

	    }
	    if(updown == KEY_UP)
	    {
	        if(CCTVRadius[playerid] < 25)
	        {
		        if(keys == KEY_SPRINT)
				{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.5);
		        	MovePlayerCCTV(playerid);
				}
				else
				{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.1);
		        	MovePlayerCCTV(playerid);
				}
			}
		}
		if(updown == KEY_DOWN)
	    {
			if(keys == KEY_SPRINT)
			{
			    if(CCTVRadius[playerid] >= 0.6)
	        	{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.5);
			       	MovePlayerCCTV(playerid);
				}
			}
			else
			{
			    if(CCTVRadius[playerid] >= 0.2)
	        	{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.1);
			       	MovePlayerCCTV(playerid);
				}
			}
		}
		if(keys == KEY_CROUCH)
		{
		    SetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
			SetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
			SetPlayerInterior(playerid, LastPos[playerid][LInterior]);
			TogglePlayerControllable(playerid, true);
			KillTimer(KeyTimer[playerid]);
			SetCameraBehindPlayer(playerid);
			TextDrawHideForPlayer(playerid, TD);
			CurrentCCTV[playerid] = -1;
		}
	}
	MovePlayerCCTV(playerid);
}

stock MovePlayerCCTV(playerid)
{
	CCTVLA[playerid][0] = CCTVLAO[CurrentCCTV[playerid]][0] + (floatmul(CCTVRadius[playerid], floatsin(-CCTVDegree[playerid], degrees)));
	CCTVLA[playerid][1] = CCTVLAO[CurrentCCTV[playerid]][1] + (floatmul(CCTVRadius[playerid], floatcos(-CCTVDegree[playerid], degrees)));
	SetPlayerCameraLookAt(playerid, CCTVLA[playerid][0], CCTVLA[playerid][1], CCTVLA[playerid][2]);
}

stock AddCCTV(const name[], Float:X, Float:Y, Float:Z, Float:Angle)
{
	if(TotalCCTVS >= MAX_CCTVS) return 0;
	format(CameraName[TotalCCTVS], 32, "%s", name);
	CCTVCP[TotalCCTVS][0] = X;
	CCTVCP[TotalCCTVS][1] = Y;
	CCTVCP[TotalCCTVS][2] = Z;
	CCTVCP[TotalCCTVS][3] = Angle;
	CCTVLAO[TotalCCTVS][0] = X;
	CCTVLAO[TotalCCTVS][1] = Y;
	CCTVLAO[TotalCCTVS][2] = Z-10;
	TotalCCTVS++;
	return TotalCCTVS-1;
}

SetPlayerToCCTVCamera(playerid, CCTV)
{
	if(CCTV >= TotalCCTVS)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "Invald CCTV");
	    return 1;
	}
	if(CurrentCCTV[playerid] == -1)
    {
	    GetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
		GetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
        LastPos[playerid][LInterior] = GetPlayerInterior(playerid);
	}
	else
	{
		KillTimer(KeyTimer[playerid]);
	}
	CurrentCCTV[playerid] = CCTV;
    TogglePlayerControllable(playerid, 0);
	//SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], (CCTVCP[CCTV][2]-50));
	SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], -100.0);
	SetPlayerCameraPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], CCTVCP[CCTV][2]);
	SetPlayerCameraLookAt(playerid, CCTVLAO[CCTV][0], (CCTVLAO[CCTV][1]+0.2), CCTVLAO[CCTV][2]);
	CCTVLA[playerid][0] = CCTVLAO[CCTV][0];
	CCTVLA[playerid][1] = CCTVLAO[CCTV][1]+0.2;
	CCTVLA[playerid][2] = CCTVLAO[CCTV][2];
	CCTVRadius[playerid] = 12.5;
	CCTVDegree[playerid] = CCTVCP[CCTV][3];
	MovePlayerCCTV(playerid);
    KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 75, 1, "i", playerid);
	TextDrawShowForPlayer(playerid, TD);
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:Current = GetPlayerMenu(playerid);
	for(new menu; menu<TotalMenus; menu++)
	{

		if(Current == CCTVMenu[menu])
		{
		    if(MenuType[PlayerMenu[playerid]] == 1)
		    {
		        if(row == 11)
		        {
		            ShowMenuForPlayer(CCTVMenu[menu+1], playerid);
		            TogglePlayerControllable(playerid, 0);
		            PlayerMenu[playerid] = (menu+1);
				}
				else
				{
				    if(PlayerMenu[playerid] == 0)
				    {
				    	SetPlayerToCCTVCamera(playerid, row);
				    	PlayerMenu[playerid] = -1;
					}
					else
					{
					    SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
					    PlayerMenu[playerid] = -1;
					}
				}
			}
			else
			{
			    if(PlayerMenu[playerid] == 0)
			    {
			    	SetPlayerToCCTVCamera(playerid, row);
			    	PlayerMenu[playerid] = -1;
				}
				else
				{
				    SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
				    PlayerMenu[playerid] = -1;
				}
			}
		}
	}

	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid, true);
	PlayerMenu[playerid] = -1;
	return 1;
}

forward CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ);
public CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new id = -1;

	if (GateData[gateid][gateExists] && GateData[gateid][gateOpened])
 	{
	 	MoveDynamicObject(GateData[gateid][gateObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);

	 	if ((id = GetGateByID(linkid)) != -1)
            MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], speed, GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);

		GateData[id][gateOpened] = 0;
		return 1;
	}
	return 0;
}
stock RestartCarRob()
{
	DestroyVehicle(robcar);
}
stock Gate_Operate(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
	    new id = -1;

		if (!GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = true;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gateMove][0], GateData[gateid][gateMove][1], GateData[gateid][gateMove][2], GateData[gateid][gateSpeed], GateData[gateid][gateMove][3], GateData[gateid][gateMove][4], GateData[gateid][gateMove][5]);

            if (GateData[gateid][gateTime] > 0) {
				GateData[gateid][gateTimer] = SetTimerEx("CloseGate", GateData[gateid][gateTime], false, "ddfffffff", gateid, GateData[gateid][gateLinkID], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);
			}
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = true;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gateMove][0], GateData[id][gateMove][1], GateData[id][gateMove][2], GateData[id][gateSpeed], GateData[id][gateMove][3], GateData[id][gateMove][4], GateData[id][gateMove][5]);
			}
		}
		else if (GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = false;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);

            if (GateData[gateid][gateTime] > 0) {
				KillTimer(GateData[gateid][gateTimer]);
		    }
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = false;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gateSpeed], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);
			}
		}
	}
	return 1;
}

stock Object_Duplicate(playerid, idx)
{
	for (new i = 0; i < MAX_MAPOBJECTS; i ++) if (!ObjectData[i][mobjExists])
	{
		ObjectData[i][mobjExists] = true;
		ObjectData[i][mobjModel] = ObjectData[idx][mobjModel];

		ObjectData[i][mobjPos][0] = ObjectData[idx][mobjPos][0];
		ObjectData[i][mobjPos][1] = ObjectData[idx][mobjPos][1];
		ObjectData[i][mobjPos][2] = ObjectData[idx][mobjPos][2];
		ObjectData[i][mobjPos][3] = ObjectData[idx][mobjPos][3];
		ObjectData[i][mobjPos][4] = ObjectData[idx][mobjPos][4];
		ObjectData[i][mobjPos][5] = ObjectData[idx][mobjPos][5];

		ObjectData[i][mobjInterior] = ObjectData[idx][mobjInterior];
		ObjectData[i][mobjWorld] = ObjectData[idx][mobjInterior];

		ObjectData[i][mobjObject] = CreateDynamicObject(ObjectData[idx][mobjModel], ObjectData[idx][mobjPos][0], ObjectData[idx][mobjPos][1], ObjectData[idx][mobjPos][2], ObjectData[idx][mobjPos][3], ObjectData[idx][mobjPos][4], ObjectData[idx][mobjPos][5], ObjectData[idx][mobjWorld], ObjectData[idx][mobjInterior]);

		new string[48];
		format(string, sizeof(string), "[%i]\nID: %i", ObjectData[i][mobjModel], i);
		ObjectData[i][mobjname2] = CreateDynamic3DTextLabel(string, COLOR_GREY, ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2], 5.0);

		mysql_tquery(connectionID, "INSERT INTO `object` (`mobjModel`) VALUES(980)", "OnObjectCreated", "d", i);

		PlayerInfo[playerid][pEditmObject] = -1;
		EditDynamicObject(playerid, ObjectData[i][mobjObject]);
		PlayerInfo[playerid][pEditmObject] = i;
		PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW;
		SM(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", i);
		return i;
	}
	return -1;
}

stock Object_Create(playerid, idx)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_MAPOBJECTS; i ++) if (!ObjectData[i][mobjExists])
		{
		    ObjectData[i][mobjExists] = true;
			ObjectData[i][mobjModel] = idx;

			ObjectData[i][mobjPos][0] = x + (3.0 * floatsin(-angle, degrees));
			ObjectData[i][mobjPos][1] = y + (3.0 * floatcos(-angle, degrees));
			ObjectData[i][mobjPos][2] = z;
			ObjectData[i][mobjPos][3] = 0.0;
			ObjectData[i][mobjPos][4] = 0.0;
			ObjectData[i][mobjPos][5] = angle;

            ObjectData[i][mobjInterior] = GetPlayerInterior(playerid);
            ObjectData[i][mobjWorld] = GetPlayerVirtualWorld(playerid);

            ObjectData[i][mobjObject] = CreateDynamicObject(ObjectData[i][mobjModel], ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2], ObjectData[i][mobjPos][3], ObjectData[i][mobjPos][4], ObjectData[i][mobjPos][5], ObjectData[i][mobjWorld], ObjectData[i][mobjInterior]);

			new string[48];
			format(string, sizeof(string), "[%i]\nID: %i", ObjectData[i][mobjModel], i);
			ObjectData[i][mobjname2] = CreateDynamic3DTextLabel(string, COLOR_GREY, ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2], 5.0);

			mysql_tquery(connectionID, "INSERT INTO `object` (`mobjModel`) VALUES(980)", "OnObjectCreated", "d", i);

			PlayerInfo[playerid][pEditmObject] = -1;
			EditDynamicObject(playerid, ObjectData[i][mobjObject]);
			PlayerInfo[playerid][pEditmObject] = i;
			PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW;
			SM(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", i);
			return i;
		}
	}
	return -1;
}

stock Gate_Create(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_GATES; i ++) if (!GateData[i][gateExists])
		{
		    GateData[i][gateExists] = true;
			GateData[i][gateModel] = 980;
			GateData[i][gateSpeed] = 3.0;
			GateData[i][gateRadius] = 5.0;
			GateData[i][gateOpened] = 0;
			GateData[i][gateTime] = 0;

			GateData[i][gatePos][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gatePos][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gatePos][2] = z;
			GateData[i][gatePos][3] = 0.0;
			GateData[i][gatePos][4] = 0.0;
			GateData[i][gatePos][5] = angle;

			GateData[i][gateMove][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gateMove][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gateMove][2] = z - 10.0;
			GateData[i][gateMove][3] = -1000.0;
			GateData[i][gateMove][4] = -1000.0;
			GateData[i][gateMove][5] = -1000.0;

            GateData[i][gateInterior] = GetPlayerInterior(playerid);
            GateData[i][gateWorld] = GetPlayerVirtualWorld(playerid);

            GateData[i][gateLinkID] = -1;
            GateData[i][gateFaction] = -1;

            GateData[i][gatePass][0] = '\0';
            GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);

			mysql_tquery(connectionID, "INSERT INTO `gates` (`gateModel`) VALUES(980)", "OnGateCreated", "d", i);
			return i;
		}
	}
	return -1;
}

stock IsAtVendor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_VENDOR; x++)
		{
			if(VendorData[x][vendorPosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, VendorData[x][vendorPosX], VendorData[x][vendorPosY], VendorData[x][vendorPosZ]) && GetPlayerInterior(playerid) == VendorData[x][vendorInterior] && GetPlayerVirtualWorld(playerid) == VendorData[x][vendorWorld]) return 1;
			}
		}
	}
	return 0;
}

stock Vendor_Create(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_VENDOR; i ++) if (!VendorData[i][vendorExists])
		{
		    VendorData[i][vendorExists] = true;
			VendorData[i][vendorModel] = 1340;

			VendorData[i][vendorPosX] = x;
			VendorData[i][vendorPosY] = y;
			VendorData[i][vendorPosZ] = z - 0.10;
			VendorData[i][vendorAngle] = angle;

            VendorData[i][vendorInterior] = GetPlayerInterior(playerid);
            VendorData[i][vendorWorld] = GetPlayerVirtualWorld(playerid);


            //VendorData[i][vendorObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
            new string[128];
		    format(string,sizeof(string),"Street Vendor (ID: %d)\nPress "SVRCLR"F"YELLOW" to buy street foods", i);
		    VendorData[i][vendorTextId] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ] + 0.4, 10.0, .worldid = VendorData[i][vendorWorld], .testlos = 0, .streamdistance = 25.0);
		    VendorData[i][vendorObject] = CreateDynamicObject(VendorData[i][vendorModel], VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ], 0.0, 0.0, VendorData[i][vendorAngle], VendorData[i][vendorWorld], VendorData[i][vendorInterior], .streamdistance = 100.0);
			mysql_tquery(connectionID, "INSERT INTO `vendors` (`vendorModel`) VALUES(1340)", "OnVendorCreated", "d", i);
			Streamer_UpdateEx(playerid, VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ]);
			RenderVendor(i);
			return i;
		}
	}
	return -1;
}

stock RenderVendor(id)
{
	DestroyDynamicObject(VendorData[id][vendorObject]);
	DestroyDynamic3DTextLabel(VendorData[id][vendorTextId]);
	if(VendorData[id][vendorPosX] != 0.0)
	{
		new string[128];
		format(string,sizeof(string),"Street Vendor (ID: %d)\nPress "SVRCLR"F "YELLOW" to buy street foods", id);
		VendorData[id][vendorTextId] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ] + 0.4, 10.0, .worldid = VendorData[id][vendorWorld], .testlos = 0, .streamdistance = 25.0);
		VendorData[id][vendorObject] = CreateDynamicObject(VendorData[id][vendorModel], VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ], 0.0, 0.0, VendorData[id][vendorAngle], VendorData[id][vendorWorld], VendorData[id][vendorInterior], .streamdistance = 100.0);
	}
	return 1;
}

stock Vendor_Delete(vendorid)
{
	if (vendorid != -1 && VendorData[vendorid][vendorExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `vendors` WHERE `vendorID` = '%d'", VendorData[vendorid][vendorID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(VendorData[vendorid][vendorObject]))
		    DestroyDynamicObject(VendorData[vendorid][vendorObject]);
		DestroyDynamic3DTextLabel(VendorData[vendorid][vendorTextId]);
		for (new i = 0; i != MAX_VENDOR; i ++) if (VendorData[i][vendorExists] && VendorData[vendorid][vendorID]) {
		    Vendor_Save(i);
		}
	    VendorData[vendorid][vendorExists] = false;
	    VendorData[vendorid][vendorID] = 0;
	}
	return 1;
}

stock Gate_Delete(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `gates` WHERE `gateID` = '%d'", GateData[gateid][gateID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(GateData[gateid][gateObject]))
		    DestroyDynamicObject(GateData[gateid][gateObject]);

		for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateLinkID] == GateData[gateid][gateID]) {
		    GateData[i][gateLinkID] = -1;
		    Gate_Save(i);
		}
		if (GateData[gateid][gateOpened] && GateData[gateid][gateTime] > 0) {
		    KillTimer(GateData[gateid][gateTimer]);
		}
	    GateData[gateid][gateExists] = false;
	    GateData[gateid][gateID] = 0;
	    GateData[gateid][gateOpened] = 0;
	}
	return 1;
}

stock Object_Delete(gateid)
{
	if (gateid != -1 && ObjectData[gateid][mobjExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `object` WHERE `mobjID` = '%d'", ObjectData[gateid][mobjID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(ObjectData[gateid][mobjObject]))
		    DestroyDynamicObject(ObjectData[gateid][mobjObject]);

		if (IsValidDynamic3DTextLabel(ObjectData[gateid][mobjname2]))
			DestroyDynamic3DTextLabel(ObjectData[gateid][mobjname2]);

	    ObjectData[gateid][mobjExists] = false;
	    ObjectData[gateid][mobjID] = 0;
	}
	return 1;
}

stock Object_Save(gateid)
{
	new
	    query[768];

	format(query, sizeof(query), "UPDATE `object` SET `mobjModel` = '%d', `mobjX` = '%.4f', `mobjY` = '%.4f', `mobjZ` = '%.4f', `mobjRX` = '%.4f', `mobjRY` = '%.4f', `mobjRZ` = '%.4f', `mobjInterior` = '%d', `mobjWorld` = '%d' WHERE `mobjID` = '%d'",
	    ObjectData[gateid][mobjModel],
	    ObjectData[gateid][mobjPos][0],
	    ObjectData[gateid][mobjPos][1],
	    ObjectData[gateid][mobjPos][2],
	    ObjectData[gateid][mobjPos][3],
	    ObjectData[gateid][mobjPos][4],
	    ObjectData[gateid][mobjPos][5],
	    ObjectData[gateid][mobjInterior],
	    ObjectData[gateid][mobjWorld],
	    ObjectData[gateid][mobjID]
	);
	return mysql_tquery(connectionID, query);
}

stock Gate_Save(gateid)
{
	new
	    query[768];

	format(query, sizeof(query), "UPDATE `gates` SET `gateModel` = '%d', `gateSpeed` = '%.4f', `gateRadius` = '%.4f', `gateTime` = '%d', `gateX` = '%.4f', `gateY` = '%.4f', `gateZ` = '%.4f', `gateRX` = '%.4f', `gateRY` = '%.4f', `gateRZ` = '%.4f', `gateInterior` = '%d', `gateWorld` = '%d', `gateMoveX` = '%.4f', `gateMoveY` = '%.4f', `gateMoveZ` = '%.4f', `gateMoveRX` = '%.4f', `gateMoveRY` = '%.4f', `gateMoveRZ` = '%.4f', `gateLinkID` = '%d', `gateFaction` = '%d', `gatePass` = '%s' WHERE `gateID` = '%d'",
	    GateData[gateid][gateModel],
	    GateData[gateid][gateSpeed],
	    GateData[gateid][gateRadius],
	    GateData[gateid][gateTime],
	    GateData[gateid][gatePos][0],
	    GateData[gateid][gatePos][1],
	    GateData[gateid][gatePos][2],
	    GateData[gateid][gatePos][3],
	    GateData[gateid][gatePos][4],
	    GateData[gateid][gatePos][5],
	    GateData[gateid][gateInterior],
	    GateData[gateid][gateWorld],
	    GateData[gateid][gateMove][0],
	    GateData[gateid][gateMove][1],
	    GateData[gateid][gateMove][2],
	    GateData[gateid][gateMove][3],
	    GateData[gateid][gateMove][4],
	    GateData[gateid][gateMove][5],
	    GateData[gateid][gateLinkID],
	    GateData[gateid][gateFaction],
	    SQL_ReturnEscaped(GateData[gateid][gatePass]),
	    GateData[gateid][gateID]
	);
	return mysql_tquery(connectionID, query);
}

stock Vendor_Save(vendorid)
{
	new
	    query[768];

	format(query, sizeof(query), "UPDATE `vendors` SET `vendorModel` = '%d', `vendorPosX` = '%f', `vendorPosY` = '%f', `vendorPosZ` = '%f', `vendorInterior` = '%d', `vendorWorld` = '%d', `vendorAngle` = '%f' WHERE `vendorID` = '%d'",
	    VendorData[vendorid][vendorModel],
	    VendorData[vendorid][vendorPosX],
	    VendorData[vendorid][vendorPosY],
	    VendorData[vendorid][vendorPosZ],
	    VendorData[vendorid][vendorInterior],
	    VendorData[vendorid][vendorWorld],
	    VendorData[vendorid][vendorAngle],
	    VendorData[vendorid][vendorID]
	);
	return mysql_tquery(connectionID, query);
}

forward Vendor_Load();
public Vendor_Load()
{
    static
	    rows,
	    fields;

	SQL_GetCacheData(rows, fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_VENDOR)
	{
	    VendorData[i][vendorExists] = true;

	    VendorData[i][vendorID] = SQL_GetInt(i, "vendorID");
	    VendorData[i][vendorModel] = SQL_GetInt(i, "vendorModel");
	    VendorData[i][vendorInterior] = SQL_GetInt(i, "vendorInterior");
	    VendorData[i][vendorWorld] = SQL_GetInt(i, "vendorWorld");
	    VendorData[i][vendorAngle] = SQL_GetInt(i, "vendorAngle");

	    VendorData[i][vendorPosX] = SQL_GetFloat(i, "vendorPosX");
	    VendorData[i][vendorPosY] = SQL_GetFloat(i, "vendorPosY");
	    VendorData[i][vendorPosZ] = SQL_GetFloat(i, "vendorPosZ");

	    new string[128];
	    format(string,sizeof(string),"Street Vendor (ID: %d)\nPress F to buy street foods", i);
	    VendorData[i][vendorTextId] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ] + 0.4, 10.0, .worldid = VendorData[i][vendorWorld], .testlos = 0, .streamdistance = 25.0);
	    VendorData[i][vendorObject] = CreateDynamicObject(VendorData[i][vendorModel], VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ], 0.0, 0.0, VendorData[i][vendorAngle], VendorData[i][vendorWorld], VendorData[i][vendorInterior], .streamdistance = 100.0);
	    RenderVendor(i);
	   // VendorData[i][VendorObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
	}
	return 1;
}

forward Gate_Load();
public Gate_Load()
{
    static
	    rows,
	    fields;

	SQL_GetCacheData(rows, fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_GATES)
	{
	    GateData[i][gateExists] = true;
	    GateData[i][gateOpened] = false;

	    GateData[i][gateID] = SQL_GetInt(i, "gateID");
	    GateData[i][gateModel] = SQL_GetInt(i, "gateModel");
	    GateData[i][gateSpeed] = SQL_GetFloat(i, "gateSpeed");
	    GateData[i][gateRadius] = SQL_GetFloat(i, "gateRadius");
	    GateData[i][gateTime] = SQL_GetInt(i, "gateTime");
	    GateData[i][gateInterior] = SQL_GetInt(i, "gateInterior");
	    GateData[i][gateWorld] = SQL_GetInt(i, "gateWorld");

	    GateData[i][gatePos][0] = SQL_GetFloat(i, "gateX");
	    GateData[i][gatePos][1] = SQL_GetFloat(i, "gateY");
	    GateData[i][gatePos][2] = SQL_GetFloat(i, "gateZ");
	    GateData[i][gatePos][3] = SQL_GetFloat(i, "gateRX");
	    GateData[i][gatePos][4] = SQL_GetFloat(i, "gateRY");
	    GateData[i][gatePos][5] = SQL_GetFloat(i, "gateRZ");

        GateData[i][gateMove][0] = SQL_GetFloat(i, "gateMoveX");
	    GateData[i][gateMove][1] = SQL_GetFloat(i, "gateMoveY");
	    GateData[i][gateMove][2] = SQL_GetFloat(i, "gateMoveZ");
	    GateData[i][gateMove][3] = SQL_GetFloat(i, "gateMoveRX");
	    GateData[i][gateMove][4] = SQL_GetFloat(i, "gateMoveRY");
	    GateData[i][gateMove][5] = SQL_GetFloat(i, "gateMoveRZ");

        GateData[i][gateLinkID] = SQL_GetInt(i, "gateLinkID");
	    GateData[i][gateFaction] = SQL_GetInt(i, "gateFaction");

	    SQL_GetString(i, "gatePass", GateData[i][gatePass], 32);

	    GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
	}
	return 1;
}

forward Object_Load();
public Object_Load()
{
    static
	    rows,
	    fields;

	SQL_GetCacheData(rows, fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_MAPOBJECTS)
	{
	    ObjectData[i][mobjExists] = true;
	    ObjectData[i][mobjID] = SQL_GetInt(i, "mobjID");
	    ObjectData[i][mobjModel] = SQL_GetInt(i, "mobjModel");
	    ObjectData[i][mobjInterior] = SQL_GetInt(i, "mobjInterior");
	    ObjectData[i][mobjWorld] = SQL_GetInt(i, "mobjWorld");
	    ObjectData[i][mobjPos][0] = SQL_GetFloat(i, "mobjX");
	    ObjectData[i][mobjPos][1] = SQL_GetFloat(i, "mobjY");
	    ObjectData[i][mobjPos][2] = SQL_GetFloat(i, "mobjZ");
	    ObjectData[i][mobjPos][3] = SQL_GetFloat(i, "mobjRX");
	    ObjectData[i][mobjPos][4] = SQL_GetFloat(i, "mobjRY");
	    ObjectData[i][mobjPos][5] = SQL_GetFloat(i, "mobjRZ");

	    ObjectData[i][mobjObject] = CreateDynamicObject(ObjectData[i][mobjModel], ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2], ObjectData[i][mobjPos][3], ObjectData[i][mobjPos][4], ObjectData[i][mobjPos][5], ObjectData[i][mobjWorld], ObjectData[i][mobjInterior]);

		new string[48];
		format(string, sizeof(string), "[%i]\nID: %i", ObjectData[i][mobjModel], i);
		ObjectData[i][mobjname2] = CreateDynamic3DTextLabel(string, COLOR_GREY, ObjectData[i][mobjPos][0], ObjectData[i][mobjPos][1], ObjectData[i][mobjPos][2], 5.0);
	}
	return 1;
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

stock RBS(bizid)
{
	new string[128];
	if(BusinessInfo[bizid][bLocked] == 1) format(string, sizeof(string), "{AA3333}Closed"WHITE"");
    else if(BusinessInfo[bizid][bLocked] == 0) format(string, sizeof(string), "{00FF00}Opened"WHITE"");
	return string;
}

stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

stock TerminateInfo(playerid, reason)
{
    if(Reconnecting[playerid] == true)
    {
    	new string[64];
     	format(string, sizeof(string), "unbanip %s", ReconnectIP[playerid]);
        SendRconCommand(string);
       	Reconnecting[playerid] = false;
       	SendRconCommand("reloadbans");
	}
    if(IsPlayerNPC(playerid)) return 1;

	PlayerTextDrawDestroy(playerid, NumberTD22[playerid]);

	PlayerTextDrawDestroy(playerid, NumberTD[playerid]);

	for(new i = 0; i < 13; i ++)
	{
	       PlayerTextDrawDestroy(playerid, HUD[playerid][i]);
	}
    for(new i = 0; i < 7; i ++)
	{
	       PlayerTextDrawDestroy(playerid, LOGO[playerid][i]);
	}
	DestroyDynamic3DTextLabel(PlayerLabel[playerid]);


	PlayerTextDrawDestroy(playerid, BanPlayerTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, BanPlayerTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, BanPlayerTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, BanPlayerTD[playerid][3]);
	PlayerTextDrawDestroy(playerid, BanPlayerTD[playerid][4]);


	#if defined Christmas
		PlayerTextDrawDestroy(playerid, EventTextdraw[playerid]);
	#endif

	Maskara[playerid] = 0;
	MaskaraID[playerid] = 0;
	PowerSpec[playerid] = 0;
	Harvesting[playerid] = 0;

	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0)
	{
	    new reasona[64] = "Quitting During Arrest", prisonbay[64] = "ANTI RB";
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET prisonedby = '%e', prisonreason = '%e' WHERE uid = %i", prisonbay, reasona, playerid);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerInfo[playerid][pPrisonReason], "Quitting During Arrest", 128);
	    SMA(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for 15 minutes by ANTI RB, reason: Quitting During Arrest", GetRPName(playerid));
	}
	if(CurrentCCTV[playerid] > -1)
	{
	    KillTimer(KeyTimer[playerid]);
	    TextDrawHideForPlayer(playerid, TD);
	}
	CurrentCCTV[playerid] = -1;

 	DestroyDynamic3DTextLabel(PlayerInfo[playerid][aMeID]);
 	PlayerInfo[playerid][aMeStatus] = 0;

	KillTimer(Timer[playerid]);
    KillTimer(killtimerz[playerid]);
    pBlood[playerid] = false;
	ResetPlayerVariables(playerid);
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pSpectating] == playerid)
	    {
	        SM(i, COLOR_ORANGE, "You are no longer spectating %s (ID %i).", GetRPName(PlayerInfo[i][pSpectating]), PlayerInfo[i][pSpectating]);
			CallRemoteFunction("ToggleListenerLocalStream", "iii", playerid , i , 0);
	    	PlayerInfo[i][pSpectating] = INVALID_PLAYER_ID;
	    	SetPlayerToSpawn(i);
		}
		if(PlayerInfo[i][pHouseOffer] == playerid)
		{
		    PlayerInfo[i][pHouseOffer] = INVALID_PLAYER_ID;
		}
        if(PlayerInfo[i][pGarageOffer] == playerid)
		{
		    PlayerInfo[i][pGarageOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pBizOffer] == playerid)
		{
		    PlayerInfo[i][pBizOffer] = INVALID_PLAYER_ID;
		}
 		if(PlayerInfo[i][pMarriageOffer] == playerid)
		{
		    PlayerInfo[i][pMarriageOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pVestOffer] == playerid)
		{
		    PlayerInfo[i][pVestOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pCarOffer] == playerid)
		{
		    PlayerInfo[i][pCarOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pFactionOffer] == playerid)
		{
		    PlayerInfo[i][pFactionOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pGangOffer] == playerid)
		{
		    PlayerInfo[i][pGangOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pFriskOffer] == playerid)
		{
		    PlayerInfo[i][pFriskOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pCarryOffer] == playerid)
		{
		    PlayerInfo[i][pCarryOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pTicketOffer] == playerid)
		{
		    PlayerInfo[i][pTicketOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pLiveOffer] == playerid)
		{
		    PlayerInfo[i][pLiveOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pLiveBroadcast] == playerid)
		{
		    PlayerInfo[i][pLiveBroadcast] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pShakeOffer] == playerid)
		{
		    PlayerInfo[i][pShakeOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pGpsOffer] == playerid)
		{
		    PlayerInfo[i][pGpsOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pLandOffer] == playerid)
		{
		    PlayerInfo[i][pLandOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pSellOffer] == playerid)
		{
		    PlayerInfo[i][pSellOffer] = INVALID_PLAYER_ID;
		}
 		if(PlayerInfo[i][pAllianceOffer] == playerid)
		{
		    PlayerInfo[i][pSellOffer] = INVALID_PLAYER_ID;
		}
        if(PlayerInfo[i][pDefendOffer] == playerid)
		{
		    PlayerInfo[i][pDefendOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pDiceOffer] == playerid)
		{
		    PlayerInfo[i][pDiceOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pSendRob] == playerid)
		{
		    PlayerInfo[i][pSendRob] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pInviteOffer] == playerid)
		{
		    PlayerInfo[i][pInviteOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pRobberyOffer] == playerid)
		{
		    PlayerInfo[i][pRobberyOffer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pTextFrom] == playerid)
		{
		    PlayerInfo[i][pTextFrom] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pWhisperFrom] == playerid)
		{
		    PlayerInfo[i][pWhisperFrom] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pFindPlayer] == playerid)
		{
		    PlayerInfo[i][pFindPlayer] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pRemoveFrom] == playerid)
		{
		    PlayerInfo[i][pRemoveFrom] = INVALID_PLAYER_ID;
		}
		if(chattingWith[i]{playerid})
		{
		    SM(i, COLOR_YELLOW, "Your chat with %s (ID %i) has ended as they left the server.", GetRPName(playerid), playerid);
		    chattingWith[i]{playerid} = false;
		}
		if(PlayerInfo[i][pActiveReport] >= 0 && (ReportInfo[PlayerInfo[i][pActiveReport]][rHandledBy] == playerid || ReportInfo[PlayerInfo[i][pActiveReport]][rReporter] == playerid))
		{
		    if(ReportInfo[PlayerInfo[i][pActiveReport]][rHandledBy] == playerid)
				SendClientMessage(i, COLOR_YELLOW, "The player who made the report has left the server.");
			else
                SendClientMessage(i, COLOR_YELLOW, "The admin who accepted the report has left the server.");

		    ReportInfo[PlayerInfo[i][pActiveReport]][rExists] = 0;
		    PlayerInfo[i][pActiveReport] = -1;
		}
		if(PlayerInfo[i][pDueling] == playerid)
		{
		    SendClientMessage(i, COLOR_WHITE, "Your duel target has left the server.");
		    PlayerInfo[i][pDueling] = INVALID_PLAYER_ID;
		    SetPlayerToSpawn(i);
		}
		if(PlayerInfo[i][pContractTaken] == playerid)
		{
		    SendClientMessage(i, COLOR_YELLOW, "Your contract target has disconnected from the server.");
		    PlayerInfo[i][pContractTaken] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pDraggedBy] == playerid)
		{
		    SendClientMessage(i, COLOR_GREEN, "The person dragging you has disconnected. You are free!");
			PlayerInfo[i][pDraggedBy] = INVALID_PLAYER_ID;
		}
		if(PlayerInfo[i][pCallLine] == playerid)
		{
		    HangupCall(PlayerInfo[i][pCallLine], HANGUP_DROPPED);
		}
	}
	if(PlayerInfo[playerid][pLogged])
	{
	    SavePlayerVariables(playerid);
	    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
		{
	    	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s left the server while tazed or cuffed.", GetRPName(playerid));
        	ResetPlayerWeaponsEx(playerid);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET jailtype = 2, jailtime = 1200, prisonedby = 'Server', prisonreason = 'Logging to avoid arrest' WHERE uid = %i", PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	if(PlayerInfo[playerid][pActiveReport] >= 0)
	{
	    callcmd::cr(playerid);
	}
	if(PlayerInfo[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
	{
		SM(PlayerInfo[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has left the server while injured.", GetRPName(playerid));
		PlayerInfo[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
	}
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAcceptedEMS] == playerid)
	    {
	        SendClientMessage(i, COLOR_YELLOW, "Your medic has left the server while rescuing you. (you can now accept your fate)");
	        PlayerInfo[i][pAcceptedEMS] = INVALID_PLAYER_ID;
	    }
	}
	if(PlayerInfo[playerid][pTutorial])
	{
	    KillTimer(PlayerInfo[playerid][pTutorialTimer]);
	}
	if(IsValidDynamicObject(PlayerInfo[playerid][pEditObject]))
	{
	    DestroyDynamicObject(PlayerInfo[playerid][pEditObject]);
	}
	if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pSpecialTag]))
	{
	    DestroyDynamic3DTextLabel(PlayerInfo[playerid][pSpecialTag]);
	}
	if(IsValidDynamicObject(PlayerInfo[playerid][pBombObject]))
	{
	    DestroyDynamicObject(PlayerInfo[playerid][pBombObject]);
	}
	if(IsValidDynamicObject(PlayerInfo[playerid][pPotObject]))
	{
	    DestroyDynamicObject(PlayerInfo[playerid][pPotObject]);
	}
	if(PlayerInfo[playerid][pLockBreak] != INVALID_VEHICLE_ID)
	{
	    CancelBreakIn(playerid);
	}
	if(PlayerInfo[playerid][pAdminDuty])
	{
	    SetPlayerName(playerid, PlayerInfo[playerid][pUsername]);
	}
	if(PlayerInfo[playerid][pBoomboxPlaced])
	{
	    DestroyBoombox(playerid);
	}
	if(PlayerInfo[playerid][pZoneID] >= 0)
	{
	    GangZoneDestroy(PlayerInfo[playerid][pZoneID]);
	}
	if(RobberyInfo[rPlanning] || RobberyInfo[rStarted])
	{
		RemoveFromBankRobbery(playerid);
	}
	if(PlayerInfo[playerid][pDyuze])
	{
	    KillTimer(PlayerInfo[playerid][pDyuzeTimer]);
	}
	if(PlayerInfo[playerid][pWaypoint])
	{
        PlayerInfo[playerid][pWaypoint] = 0;
		PlayerTextDrawHide(playerid, PlayerInfo[playerid][pTextdraws][1]);
	}


	if(PlayerInfo[playerid][pLogged])
	{
		foreach(new i : Vehicle)
		{
	    	if(IsValidVehicle(i) && IsVehicleOwner(playerid, i) && VehicleInfo[i][vTimer] == -1)
		    {
				VehicleInfo[i][vTimer] = SetTimerEx("DespawnTimer", 600000, false, "i", i);
	   		}
		}
	}

	for(new i = 0; i < MAX_REPORTS; i ++)
	{
	    if(ReportInfo[i][rExists] && ReportInfo[i][rReporter] == playerid)
	    {
	        ReportInfo[i][rExists] = 0;
		}
	}

	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && PointInfo[i][pCaptureTime] > 0 && PointInfo[i][pCapturer] == playerid)
	    {
	        SendProximityMessage(i, 20.0, COLOR_RED, "(( %s disconnected and therefore failed to capture the point. ))", GetRPName(playerid));

	        PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
	        PointInfo[i][pCaptureTime] = 0;
	    }
	}

	switch(reason)
	{
	    case 0: SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s has left the server. (ForceClosed)", GetRPName(playerid));
	    case 1: SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s has left the server. (Leaving)", GetRPName(playerid));
	    case 2: SendProximityMessage(playerid, 20.0, COLOR_WHITE, "** %s has left the server. (Kicked)", GetRPName(playerid));
	}
    new time = gettime();
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET lasttime = %i WHERE uid = %i",time, PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM shots WHERE (playerid = %i) OR (hitid = %i AND hittype = 1)", playerid, playerid);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

// Vehicle Tank Explode
stock Float: GetDistanceCameraToLocation(Float: cam_X, Float: cam_Y, Float: cam_Z, Float: vect_X, Float: vect_Y, Float: vect_Z, Float: dest_X, Float: dest_Y, Float: dest_Z, Float: targetDist = 0.0)
{
        cam_X -= dest_X;
        cam_Y -= dest_Y;
        cam_Z -= dest_Z;

        targetDist = floatsqroot(cam_X * cam_X + cam_Y * cam_Y + cam_Z * cam_Z);

        cam_X += vect_X * targetDist;
        cam_Y += vect_Y * targetDist;
        cam_Z += vect_Z * targetDist;

        return floatsqroot(cam_X * cam_X + cam_Y * cam_Y + cam_Z * cam_Z);
}
IsPlayerInRangeOfBackpack(playerid, Float:radius)
{
	for(new i = 0; i < MAX_BACK_PACKS; i++)
	{
		if(IsValidDynamicObject(BackpackData[i][bpObject]))
		{
			if(IsPlayerInRangeOfPoint(playerid, radius, BackpackData[i][bp_X], BackpackData[i][bp_Y], BackpackData[i][bp_Z]) && GetPlayerInterior(playerid) == BackpackData[i][bp_Interior] && GetPlayerVirtualWorld(playerid) == BackpackData[i][bp_World])
			{
				return i;
			}
		}
	}
	return -1;
}
DropBackpack(playerid)
{
	if(PlayerInfo[playerid][pBackpack])
	{
		new Float:a, Float:x, Float:y, Float:z;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		for(new i = 1; i < MAX_BACK_PACKS; i++) {
			if(!IsValidDynamicObject(BackpackData[i][bpObject])) {
				if(PlayerInfo[playerid][bpWearing]) PlayerInfo[playerid][bpWearing] = 0, RemovePlayerAttachedObject(playerid, 1);

				BackpackData[i][bpObject] = CreateDynamicObject(371, x, y, z - 0.750, 1.699972, -0.299987, a);

				new str[128];
				format(str, sizeof(str), "A backpack (ID: %d)\nType '{33AA33}/grabbackpack{FFFFFF}' to grab the backpack\nType '"SVRCLR"/inspectbackpack{FFFFFF}' to inspect the content", i);
				BackpackData[i][bpLabel] = CreateDynamic3DTextLabel(str, -1, x, y, z - 1.0, 20.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid));

				for(new j = 0; j < 15; j++)
				{
					BackpackData[i][bp_Weapon][j] = PlayerInfo[playerid][bpWeapons][j];
					BackpackData[i][bp_Ammo][j] = PlayerInfo[playerid][bpAmmo][j];
				}

				BackpackData[i][bp_Backpack] = PlayerInfo[playerid][pBackpack];
				BackpackData[i][bp_Cash] = PlayerInfo[playerid][bpCash];
				BackpackData[i][bp_Materials] = PlayerInfo[playerid][bpMaterials];
				BackpackData[i][bp_Pot] = PlayerInfo[playerid][bpPot];
				BackpackData[i][bp_Crack] = PlayerInfo[playerid][bpCrack];
				BackpackData[i][bp_Meth] = PlayerInfo[playerid][bpMeth];
				BackpackData[i][bp_Painkillers] = PlayerInfo[playerid][bpPainkillers];

				BackpackData[i][bp_X] = x; BackpackData[i][bp_Y] = y; BackpackData[i][bp_Z] = z;
				BackpackData[i][bp_Interior] = GetPlayerInterior(playerid); BackpackData[i][bp_World] = GetPlayerVirtualWorld(playerid);
				return 1;
			}
		}
		SendClientMessage(playerid, COLOR_ERROR, "Unable to drop the backpack, Contact the server developer or an admin!");
	}
	return 0;
}

stock IsPlayerAimingAtPoint(playerid, Float: pos_X, Float: pos_Y, Float: pos_Z, Float: aimRadius)
{
        new
                Float: cam_Pos[3],
                Float: cam_Vect[3]
        ;
        GetPlayerCameraPos(playerid, cam_Pos[0], cam_Pos[1], cam_Pos[2]);
        GetPlayerCameraFrontVector(playerid, cam_Vect[0], cam_Vect[1], cam_Vect[2]);

        new
                Float: aimOffset
        ;
        switch(GetPlayerWeapon(playerid))
        {
                case 22, 23, 24, 25, 26, 27, 28, 29, 32, 38: aimOffset = -2.1;
                case 30, 31: aimOffset = -1.3;
                case 33: aimOffset = -0.9;
                case 34: return GetDistanceCameraToLocation(cam_Pos[0], cam_Pos[1], cam_Pos[2], cam_Vect[0], cam_Vect[1], cam_Vect[2], pos_X, pos_Y, pos_Z) < aimRadius;
                default: return 0;
        }
        new
                Float: aimAngle = atan2(cam_Vect[2], floatsqroot(cam_Vect[0] * cam_Vect[0] + cam_Vect[1] * cam_Vect[1])),
                Float: tmpVar
        ;
        cam_Vect[2] = floatcos(aimAngle + (aimOffset * -2), degrees) * floatsin(-(atan2(cam_Vect[1], cam_Vect[0]) + aimOffset + 270.0), degrees);
        tmpVar = floatcos(aimAngle + (aimOffset * -2), degrees) * floatcos(-(atan2(cam_Vect[1], cam_Vect[0]) + aimOffset + 270.0), degrees);

        return GetDistanceCameraToLocation(cam_Pos[0], cam_Pos[1], cam_Pos[2], cam_Vect[2], tmpVar, floatsin(aimAngle + (aimOffset * -2), degrees), pos_X, pos_Y, pos_Z) < aimRadius;
}

stock GetPetrolcapOffsets(modelID, &Float: aimOffset_X, &Float: aimOffset_Y, &Float: aimOffset_Z)
{
        enum e_PetrolcaPlayerInfo
        {
                e_ModelID,
                Float: e_Offset_X,
                Float: e_Offset_Y,
                Float: e_Offset_Z
        };
        static const
                g_PetrolcaPlayerInfo[][e_PetrolcaPlayerInfo] =
                {
                        { 400, -1.100, -2.059, -0.070 },
                        { 401, 1.090, -0.939, 0.000 },
                        { 402, 1.039, -1.919, 0.140 },
                        { 403, -1.450, 0.070, -0.800 },
                        { 404, -0.939, -2.359, -0.009 },
                        { 405, -1.039, -2.180, -0.039 },
                        { 407, -1.110, -3.660, -0.540 },
                        { 408, -1.230, 1.299, -0.660 },
                        { 409, -0.980, -2.829, 0.119 },
                        { 410, -1.019, -1.669, 0.209 },
                        { 411, 1.090, -2.099, 0.090 },
                        { 412, 0.000, -3.549, -0.170 },
                        { 413, -1.049, 0.340, -0.529 },
                        { 414, -0.920, -0.740, -0.699 },
                        { 415, -1.129, -2.069, 0.019 },
                        { 416, -1.350, -2.740, -0.189 },
                        { 418, -1.179, -1.769, -0.019 },
                        { 418, 1.210, -1.570, -0.079 },
                        { 419, -1.080, -1.990, 0.029 },
                        { 420, -1.100, -2.150, 0.100 },
                        { 421, -1.070, -2.440, -0.170 },
                        { 422, -1.080, -0.419, -0.200 },
                        { 423, -1.169, -1.899, -0.319 },
                        { 424, 0.180, 1.080, 0.430 },
                        { 426, -1.100, -2.150, 0.090 },
                        { 427, -1.269, -3.200, -0.159 },
                        { 428, -1.009, -3.059, -0.490 },
                        { 429, 0.990, -2.140, 0.140 },
                        { 431, -1.450, -5.469, -0.129 },
                        { 433, -1.519, 0.159, -0.680 },
                        { 434, -0.730, -1.580, 0.289 },
                        { 436, -1.070, -1.820, 0.140 },
                        { 437, -1.490, -4.969, -0.500 },
                        { 438, -1.090, -1.929, -0.019 },
                        { 439, -1.110, -1.509, 0.059 },
                        { 440, -1.090, -0.460, -0.419 },
                        { 442, -1.210, -2.210, 0.059 },
                        { 443, -1.529, 1.240, -0.899 },
                        { 444, 0.000, -2.599, -0.059 },
                        { 445, -1.039, -1.940, 0.129 },
                        { 451, 1.059, -1.220, -0.039 },
                        { 455, -1.529, -0.009, -0.759 },
                        { 456, 0.790, -0.050, -0.610 },
                        { 458, -1.110, -2.049, -0.109 },
                        { 459, -0.819, -2.390, -0.479 },
                        { 459, -1.049, -2.289, 0.219 },
                        { 461, 0.000, 0.140, 0.540 },
                        { 463, 0.000, 0.170, 0.469 },
                        { 466, 0.000, -3.000, -0.129 },
                        { 467, -1.070, -2.299, 0.119 },
                        { 468, 0.000, 0.009, 0.409 },
                        { 470, -1.259, -2.380, 0.239 },
                        { 475, -1.070, -1.600, 0.129 },
                        { 477, -1.200, -1.529, 0.239 },
                        { 478, 1.090, -0.340, 0.230 },
                        { 479, -1.090, -1.970, 0.029 },
                        { 480, -1.000, -0.879, 0.100 },
                        { 482, 1.070, -2.190, 0.000 },
                        { 483, 0.930, -2.509, -0.039 },
                        { 485, -0.889, 0.720, 0.019 },
                        { 486, -0.699, -3.170, 0.579 },
                        { 489, 1.159, -0.740, 0.000 },
                        { 490, 1.370, -1.250, 0.000 },
                        { 491, -1.070, -2.180, 0.000 },
                        { 492, -0.980, -2.240, 0.119 },
                        { 494, -1.019, -2.200, 0.119 },
                        { 495, 1.210, -1.909, -0.100 },
                        { 496, 1.059, -1.860, 0.150 },
                        { 498, -1.299, -0.009, 0.090 },
                        { 499, -1.110, -1.070, -0.349 },
                        { 500, -0.980, -1.710, -0.070 },
                        { 502, -1.080, -1.879, 0.140 },
                        { 503, -1.100, -2.049, 0.029 },
                        { 504, 0.000, -3.000, -0.129 },
                        { 504, -1.159, -1.830, 0.109 },
                        { 505, 1.159, -0.740, 0.000 },
                        { 506, 1.049, -1.110, -0.050 },
                        { 507, -1.169, -2.299, 0.109 },
                        { 508, -1.379, -3.049, -0.670 },
                        { 514, 1.429, 0.379, -0.649 },
                        { 515, -1.450, 0.479, -1.309 },
                        { 516, -1.100, -2.450, -0.029 },
                        { 517, -1.179, -1.950, 0.070 },
                        { 518, 1.210, -2.190, -0.070 },
                        { 521, 0.000, 0.129, 0.610 },
                        { 522, 0.000, 0.140, 0.610 },
                        { 523, 0.000, 0.150, 0.550 },
                        { 524, 1.529, 0.479, -0.990 },
                        { 525, -1.389, -0.509, -0.090 },
                        { 526, -0.990, -1.960, 0.059 },
                        { 527, -1.139, -1.690, 0.140 },
                        { 528, -1.090, -2.029, 0.119 },
                        { 529, -1.200, -2.220, 0.200 },
                        { 531, -0.009, 0.819, 0.430 },
                        { 533, 1.019, -1.960, 0.140 },
                        { 534, -1.039, -0.819, -0.200 },
                        { 535, -1.200, -0.560, 0.270 },
                        { 536, -1.070, -1.690, 0.090 },
                        { 540, -1.169, -2.519, -0.019 },
                        { 541, 1.009, -1.990, 0.150 },
                        { 542, -1.120, -1.919, 0.310 },
                        { 543, -1.100, -0.949, 0.000 },
                        { 544, -1.299, 2.069, 0.319 },
                        { 545, 0.000, -2.220, -0.319 },
                        { 546, 1.090, -2.029, 0.150 },
                        { 547, -1.169, -2.009, 0.119 },
                        { 549, -1.080, -1.179, 0.219 },
                        { 550, -1.070, -2.490, 0.039 },
                        { 551, -1.149, -2.670, 0.090 },
                        { 552, -1.289, -0.959, 0.490 },
                        { 554, 1.210, -2.390, 0.119 },
                        { 555, -0.790, -1.500, 0.180 },
                        { 557, 1.190, -2.569, 0.850 },
                        { 558, -1.090, -1.940, 0.270 },
                        { 559, -1.080, -1.710, 0.270 },
                        { 560, 1.139, -1.899, 0.129 },
                        { 561, 1.110, -2.299, 0.109 },
                        { 562, 1.039, -0.699, 0.070 },
                        { 565, 0.910, -0.870, 0.029 },
                        { 566, 1.080, -2.440, 0.019 },
                        { 567, 0.000, -2.859, -0.460 },
                        { 568, -0.500, -0.660, 0.379 },
                        { 571, 0.000, 0.189, 0.019 },
                        { 572, -0.379, -0.970, 0.159 },
                        { 573, -1.179, 0.479, -0.479 },
                        { 574, -0.750, -0.970, 0.280 },
                        { 575, 0.000, -2.779, -0.050 },
                        { 576, 0.000, -3.160, -0.250 },
                        { 578, -1.240, 2.910, -0.019 },
                        { 579, 1.220, -2.299, 0.170 },
                        { 580, 1.190, -1.820, 0.239 },
                        { 581, 0.000, 0.129, 0.540 },
                        { 582, -1.059, 0.140, -0.280 },
                        { 583, -0.759, 0.409, -0.059 },
                        { 584, 0.000, 0.000, 0.000 },
                        { 585, 1.139, -2.299, 0.200 },
                        { 587, -1.230, -1.220, 0.100 },
                        { 588, -1.460, -2.160, 0.219 },
                        { 589, 0.980, -0.889, 0.119 },
                        { 596, -1.110, -2.160, 0.100 },
                        { 597, -1.100, -2.150, 0.100 },
                        { 598, -1.080, -1.960, 0.159 },
                        { 599, 1.159, -0.740, 0.000 },
                        { 600, 1.090, -2.029, 0.079 },
                        { 601, -1.330, -1.690, 0.920 },
                        { 602, 1.090, -1.990, 0.109 },
                        { 603, 1.179, -2.190, -0.079 },
                        { 604, 0.000, -3.000, -0.129 },
                        { 605, -1.100, -0.949, 0.000 },
                        { 609, -1.299, 0.000, 0.100 }
                }
        ;
        for(new i; i < sizeof(g_PetrolcaPlayerInfo); ++i)
        {
                if(g_PetrolcaPlayerInfo[i][e_ModelID] == modelID)
                {
                        aimOffset_X = g_PetrolcaPlayerInfo[i][e_Offset_X];
                        aimOffset_Y = g_PetrolcaPlayerInfo[i][e_Offset_Y];
                        aimOffset_Z = g_PetrolcaPlayerInfo[i][e_Offset_Z];
                        return 1;
                }
        }
        return 0;
}

GetNearbyLand(playerid)
{
    if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
		for(new i = 0; i < MAX_LANDS; i ++)
		{
			if(LandInfo[i][lExists] && IsPlayerInDynamicArea(playerid, LandInfo[i][lArea]))
			{
			    return i;
			}
		}
	}

	return -1;
}

TurfTaxCheck(playerid, amount)
{
	new turfid = GetNearbyTurf(playerid);

	if(turfid >= 0 && TurfInfo[turfid][tType] == 7 && TurfInfo[turfid][tCapturedGang] >= 0)
	{
	    amount = percent(amount, 10);

	    SM(playerid, COLOR_GREEN, "You have been taxed a 10 percent fee of "SVRCLR"$%i{CCFFFF} for selling in %s's turf.", amount, GangInfo[TurfInfo[turfid][tCapturedGang]][gName]);
	    GivePlayerCash(playerid, -amount);

	    GangInfo[TurfInfo[turfid][tCapturedGang]][gCash] += amount;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[TurfInfo[turfid][tCapturedGang]][gCash], TurfInfo[turfid][tCapturedGang]);
	    mysql_tquery(connectionID, queryBuffer);
	}
}

GetNearbyTurf(playerid)
{
    if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
		for(new i = 0; i < MAX_TURFS; i ++)
		{
			if(TurfInfo[i][tExists] && IsPlayerInDynamicArea(playerid, TurfInfo[i][tArea]))
			{
			    return i;
			}
		}
	}
	return -1;
}
GetNearbyPoints2(playerid)
{
    if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
		for(new i = 0; i < MAX_POINTS; i ++)
		{
			if(PointInfo[i][pExists] && IsPlayerInDynamicArea(playerid, PointInfo[i][pArea]))
			{
			    return i;
			}
		}
	}
	return -1;
}

GetNearbyPoint(playerid, Float:radius = 3.0)
{
    for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && IsPlayerInRangeOfPoint(playerid, radius, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]) && GetPlayerInterior(playerid) == PointInfo[i][pPointInterior] && GetPlayerVirtualWorld(playerid) == PointInfo[i][pPointWorld])
		{
		    return i;
		}
	}
	return -1;
}


GetTurfColor(turfid)
{
	if(TurfInfo[turfid][tCapturedGang] >= 0)
	{
	    return (GangInfo[TurfInfo[turfid][tCapturedGang]][gColor] & ~0xff) + 0xAA;
	}

	return 0x000000AA;
}

ReloadTurf(turfid)
{
	if(TurfInfo[turfid][tExists])
	{
	    DestroyDynamicArea(TurfInfo[turfid][tArea]);
	    GangZoneDestroy(TurfInfo[turfid][tGangZone]);

	    TurfInfo[turfid][tArea] = CreateDynamicRectangle(TurfInfo[turfid][tMinX], TurfInfo[turfid][tMinY], TurfInfo[turfid][tMaxX], TurfInfo[turfid][tMaxY]);
	    TurfInfo[turfid][tGangZone] = GangZoneCreateEx(TurfInfo[turfid][tMinX], TurfInfo[turfid][tMinY], TurfInfo[turfid][tMaxX], TurfInfo[turfid][tMaxY]);

	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pShowTurfs])
	        {
	            ShowTurfsOnMap(i, true);
			}
		}
	}
}

GetNearbyEntranceEx(playerid)
{
	return GetNearbyEntrance(playerid) == -1 ? GetInsideEntrance(playerid) : GetNearbyEntrance(playerid);
}

GetNearbyEntrance(playerid)
{
	for(new i = 0; i < MAX_ENTRANCES; i ++)
	{
	    if(EntranceInfo[i][eExists] && IsPlayerInRangeOfPoint(playerid, EntranceInfo[i][eRadius], EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]) && GetPlayerInterior(playerid) == EntranceInfo[i][eOutsideInt] && GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideEntrance(playerid)
{
	for(new i = 0; i < MAX_ENTRANCES; i ++)
	{
	    if(EntranceInfo[i][eExists] && IsPlayerInRangeOfPoint(playerid, 100.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]) && GetPlayerInterior(playerid) == EntranceInfo[i][eInterior] && GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eWorld])
	    {
	        return i;
		}
	}

	return -1;
}

SetEntranceOwner(entranceid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(EntranceInfo[entranceid][eOwner], "Nobody", MAX_PLAYER_NAME);
	    EntranceInfo[entranceid][eOwnerID] = 0;
	}
	else
	{
	    GetPlayerName(playerid, EntranceInfo[entranceid][eOwner], MAX_PLAYER_NAME);
	    EntranceInfo[entranceid][eOwnerID] = PlayerInfo[playerid][pID];
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET ownerid = %i, owner = '%s' WHERE id = %i", EntranceInfo[entranceid][eOwnerID], EntranceInfo[entranceid][eOwner], EntranceInfo[entranceid][eID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadEntrance(entranceid);
}

ReloadEntrance(entranceid)
{
	if(EntranceInfo[entranceid][eExists])
	{
	    new
	        string[128];

		DestroyDynamic3DTextLabel(EntranceInfo[entranceid][eText]);
		DestroyDynamicPickup(EntranceInfo[entranceid][ePickup]);
		DestroyDynamicMapIcon(EntranceInfo[entranceid][eMapIconID]);

		if(EntranceInfo[entranceid][eLabel])
		{
			if(EntranceInfo[entranceid][eOwnerID])
			{
			    format(string, sizeof(string), "%s\nOwned by %s\n"WHITE"%s %d", EntranceInfo[entranceid][eName], EntranceInfo[entranceid][eOwner], GetZoneName(EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]), entranceid);
			}
			else
			{
		        format(string, sizeof(string), "%s\n"WHITE"%s %d", EntranceInfo[entranceid][eName], GetZoneName(EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]), entranceid);
			}
            new color = COLOR_GREY1;
			if(EntranceInfo[entranceid][eColor] != -256)
			{
				color = EntranceInfo[entranceid][eColor];
			}
			EntranceInfo[entranceid][eText] = CreateDynamic3DTextLabel(string, color, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], (EntranceInfo[entranceid][eIcon] == 19902) ? (EntranceInfo[entranceid][ePosZ] + 0.1) : (EntranceInfo[entranceid][ePosZ]), 10.0, .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);
        }

		EntranceInfo[entranceid][ePickup] = CreateDynamicPickup(EntranceInfo[entranceid][eIcon], 1, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], (EntranceInfo[entranceid][eIcon] == 19902) ? (EntranceInfo[entranceid][ePosZ] - 1.0) : (EntranceInfo[entranceid][ePosZ]), .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);

		if(EntranceInfo[entranceid][eMapIcon])
		{
		    EntranceInfo[entranceid][eMapIconID] = CreateDynamicMapIcon(EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], EntranceInfo[entranceid][eMapIcon], 0, .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);
		}
	}
}

IsEntranceOwner(playerid, entranceid)
{
	return (EntranceInfo[entranceid][eOwnerID] == PlayerInfo[playerid][pID]) || (EntranceInfo[entranceid][eOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

GetClosestBusiness(playerid, type)
{
	new
	    Float:distance[2] = {99999.0, 0.0},
	    index = -1;

	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
		if((BusinessInfo[i][bExists] && BusinessInfo[i][bType] == type) && (BusinessInfo[i][bOutsideInt] == 0 && BusinessInfo[i][bOutsideVW] == 0))
		{
			distance[1] = GetPlayerDistanceFromPoint(playerid, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]);

			if(distance[0] > distance[1])
			{
			    distance[0] = distance[1];
			    index = i;
			}
		}
	}

	return index;
}
IsMedic(playerid)
{
	return GetFactionType(playerid) == FACTION_MEDIC;
}
GetNearbyBusinessEx(playerid)
{
	return GetNearbyBusiness(playerid) == -1 ? GetInsideBusiness(playerid) : GetNearbyBusiness(playerid);
}

GetNearbyBusiness(playerid, Float:radius = 2.0)
{
	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, radius, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bOutsideInt] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideBusiness(playerid)
{
	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, 100.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bInterior] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bWorld])
	    {
	        return i;
		}
	}

	return -1;
}

SetBusinessOwner(businessid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);
	    BusinessInfo[businessid][bOwnerID] = 0;
	}
	else
	{
     	GetPlayerName(playerid, BusinessInfo[businessid][bOwner], MAX_PLAYER_NAME);
	    BusinessInfo[businessid][bOwnerID] = PlayerInfo[playerid][pID];
	}

	BusinessInfo[businessid][bTimestamp] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", BusinessInfo[businessid][bTimestamp], BusinessInfo[businessid][bOwnerID], BusinessInfo[businessid][bOwner], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
}

ReloadBusiness(businessid)
{
    if (!BusinessInfo[businessid][bExists]) return;

    
    DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
    DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
    DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

    new string[128*2];
    new pickupType = (BusinessInfo[businessid][bType] == BUSINESS_MOBILE) ? 1277 : 1272;
    new mapIconID;

    
    if (BusinessInfo[businessid][bOwnerID] == 0)
    {
        format(string, sizeof(string), "Business Info\n\n"SVRCLR"[Business Type]: "WHITE"%s\n"SVRCLR"[Business Price]: "WHITE"$%i\n"SVRCLR"[Business Entrance]: "WHITE"$%i\n"SVRCLR"[Business Address]: "WHITE"%s %d\n\nPress 'Y' to enter",
               bizInteriors[BusinessInfo[businessid][bType]][intType],
               BusinessInfo[businessid][bPrice],
               BusinessInfo[businessid][bEntryFee],
               GetZoneName(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]),
               businessid);
    }
    else
    {
        if (BusinessInfo[businessid][bType] == BUSINESS_MOBILE)
        {
            format(string, sizeof(string), "{26FE4A}%s\n\n{30FCBC}[Owner]: "WHITE"%s\n Press 'N' to Buy",
                   BusinessInfo[businessid][bName],
                   BusinessInfo[businessid][bOwner]);
        }
        else
        {
            format(string, sizeof(string), "Business Info\n\n"SVRCLR"[Business Name]: "WHITE"%s\n"SVRCLR"[Business Owner]: "WHITE"%s\n"SVRCLR"[Business Entrance]: "WHITE"$%i\n"SVRCLR"[Business Address]: "WHITE"%s %d\n\nPress 'Y' to enter",
                   BusinessInfo[businessid][bName],
                   BusinessInfo[businessid][bOwner],
                   BusinessInfo[businessid][bEntryFee],
                   GetZoneName(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]),
                   businessid);
        }
    }

    
    BusinessInfo[businessid][bText] = CreateDynamic3DTextLabel(string, BIZ_COLOR, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ] + 0.1, 10.0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);
    BusinessInfo[businessid][bPickup] = CreateDynamicPickup(pickupType, 1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);

    
    switch (BusinessInfo[businessid][bType])
    {
        case BUSINESS_STORE:        mapIconID = 17;
        case BUSINESS_GUNSHOP:      mapIconID = 6;
        case BUSINESS_CLOTHES:      mapIconID = 45;
        case BUSINESS_RESTAURANT:   mapIconID = 10;
        case BUSINESS_GYM:          mapIconID = 54;
        case BUSINESS_AGENCY:       mapIconID = 58;
        case BUSINESS_MOBILE:       mapIconID = 49;
        case BUSINESS_BARCLUB:      mapIconID = 49;
        default:                   mapIconID = -1; 
    }

    if (mapIconID != -1)
    {
        BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], mapIconID, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
    }
}

stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = -1,
		Float: fVehiclePos[4];

	foreach(new i : Vehicle) if(GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}

IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

ShowBlood(playerid, time)
{
    for(new i = 0; i < 8;i++)
    {
		if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pAdminDuty])
        {
        	TextDrawShowForPlayer(playerid, Blood[i]);
		}
    }
    Timer[playerid] = SetTimerEx("RemoveBlood", time*1000, false, "i", playerid);
    return 1;
}

IsBusinessOwner(playerid, businessid)
{
	return (BusinessInfo[businessid][bOwnerID] == PlayerInfo[playerid][pID]) || (BusinessInfo[businessid][bOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

IsGarageOwner(playerid, garageid)
{
	return (GarageInfo[garageid][gOwnerID] == PlayerInfo[playerid][pID]) || (GarageInfo[garageid][gOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

GetNearbyGarageEx(playerid)
{
	return GetNearbyGarage(playerid) == -1 ? GetInsideGarage(playerid) : GetNearbyGarage(playerid);
}

GetNearbyGarage(playerid)
{
	for(new i = 0; i < MAX_GARAGES; i ++)
	{
	    if(GarageInfo[i][gExists] && IsPlayerInRangeOfPoint(playerid, 4.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideGarage(playerid)
{
	for(new i = 0; i < MAX_GARAGES; i ++)
	{
	    if(GarageInfo[i][gExists] && IsPlayerInRangeOfPoint(playerid, 50.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]) && GetPlayerInterior(playerid) == garageInteriors[GarageInfo[i][gType]][intID] && GetPlayerVirtualWorld(playerid) == GarageInfo[i][gWorld])
	    {
	        return i;
		}
	}

	return -1;
}

ReloadGarage(garageid)
{
	if(GarageInfo[garageid][gExists])
	{
	    new string[128];

		DestroyDynamic3DTextLabel(GarageInfo[garageid][gText]);
		DestroyDynamicPickup(GarageInfo[garageid][gPickup]);

        if(GarageInfo[garageid][gOwnerID] == 0)
        {
	        format(string, sizeof(string), "%s Garage\nPrice: $%i\n> %i cars capacity <\n"WHITE"%s %d", garageInteriors[GarageInfo[garageid][gType]][intName],GarageInfo[garageid][gPrice], GarageInfo[garageid][gType] + 1,GetZoneName(GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]),garageid);
		}
		else
		{
		    format(string, sizeof(string), "%s Garage\nOwned by %s\n> %i cars capacity <\n"WHITE"%s %d", garageInteriors[GarageInfo[garageid][gType]][intName],GarageInfo[garageid][gOwner], GarageInfo[garageid][gType] + 1,GetZoneName(GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]),garageid);
		}

		GarageInfo[garageid][gText] = CreateDynamic3DTextLabel(string, 0xc1ff75ff, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ] + 0.1, 10.0);
        GarageInfo[garageid][gPickup] = CreateDynamicPickup(1316, 1, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
	}
}

SetGarageOwner(garageid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(GarageInfo[garageid][gOwner], "Nobody", MAX_PLAYER_NAME);
	    GarageInfo[garageid][gOwnerID] = 0;
	}
	else
	{
	    GetPlayerName(playerid, GarageInfo[garageid][gOwner], MAX_PLAYER_NAME);
	    GarageInfo[garageid][gOwnerID] = PlayerInfo[playerid][pID];
	}

	GarageInfo[garageid][gTimestamp] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", GarageInfo[garageid][gTimestamp], GarageInfo[garageid][gOwnerID], GarageInfo[garageid][gOwner], GarageInfo[garageid][gID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadGarage(garageid);
}

HasFurniturePerms(playerid, houseid)
{
	return IsHouseOwner(playerid, houseid) || PlayerInfo[playerid][pFurniturePerms] == houseid;
}

IsHouseOwner(playerid, houseid)
{
	return (HouseInfo[houseid][hOwnerID] == PlayerInfo[playerid][pID]) || (HouseInfo[houseid][hOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

GetVehicleStashCapacity(vehicleid, item)
{
	static const stashCapacities[][] = {
		// Cash   Mats    W     C    M    P   HP   PT   FMJ  WEP
	    {25000,   5000,   25,   25,  10,  5,  80,  60,  50,  3}, // level 1
	    {50000,   10000,  50,   50,  25,  10, 100, 80,  60,  4}, // level 2
	    {100000,  25000,  100,  75,  50,  20, 125, 100, 70,  5} // level 3
	};

	if(VehicleInfo[vehicleid][vTrunk] > 0)
	{
		return stashCapacities[VehicleInfo[vehicleid][vTrunk] - 1][item];
	}

	return 0;
}
GetBackpackCapacity(playerid, item)
{
	static const stashCapacities[][] = {
		// Cash   Mats    W     C    M    P   HP   PT   FMJ  WEP
	    {30000,   5000,   25,   25,  10,  5,  80,  60,  50,  4}, // Small
	    {55000,   10000,  50,   50,  25,  10, 100, 80,  60,  8}, // Medium
	    {120000,  25000,  100,  75,  50,  20, 125, 100, 70,  12} // Large
	};

	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		return stashCapacities[PlayerInfo[playerid][pBackpack] - 1][item];
	}

	return 0;
}
GetGangStashCapacity(gangid, item)
{
	static const stashCapacities[][] = {
		{1000000, 100000, 500,  500,  250,  50,  1000, 500,  250},
		{2000000, 200000, 1000, 1000, 500,  100, 1500, 1000, 500},
		{3000000, 300000, 1500, 1500, 1000, 250, 2000, 1500, 1000}
	};

	return stashCapacities[GangInfo[gangid][gLevel] - 1][item];
}

GetHouseStashCapacity(houseid, item)
{
	static const stashCapacities[][] = {
		// Cash   Mats    W    C    M    P   HP   PT   FMJ  WEP
	    {50000,   5000,   50,  25,  20,  10, 80,  60,  50,  2}, // level 1
	    {100000,  10000,  100, 50,  40,  20, 100, 80,  60,  4}, // level 2
	    {250000,  25000,  150, 75,  60,  30, 125, 100, 70,  6}, // level 3
	    {500000,  50000,  200, 100, 80,  40, 150, 125, 80,  8}, // level 4
	    {1000000, 100000, 300, 200, 100, 50, 200, 150, 100, 10} // level 5
	};

	return stashCapacities[HouseInfo[houseid][hLevel] - 1][item];
}

GetHouseTenantCapacity(houseid)
{
	switch(HouseInfo[houseid][hLevel])
	{
	    case 0: return 5;
	    case 1: return 10;
	    case 2: return 15;
	    case 3: return 20;
	    case 4: return 25;
	    case 5: return 30;
	}

	return 0;
}

GetHouseFurnitureCapacity(houseid)
{
	switch(HouseInfo[houseid][hLevel])
	{
	    case 0: return 50;
	    case 1: return 75;
	    case 2: return 100;
	    case 3: return 150;
	    case 4: return 300;
	    case 5: return 500;
	}

	return 0;
}

GetNearbyHouseEx(playerid)
{
	return GetNearbyHouse(playerid) == -1 ? GetInsideHouse(playerid) : GetNearbyHouse(playerid);
}

GetNearbyHouse(playerid)
{
	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hOutsideInt] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideHouse(playerid)
{
	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 100.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hInterior] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hWorld])
	    {
	        return i;
		}
	}

	return -1;
}

SetHouseOwner(houseid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);
	    HouseInfo[houseid][hOwnerID] = 0;
	}
	else
	{
	    GetPlayerName(playerid, HouseInfo[houseid][hOwner], MAX_PLAYER_NAME);
	    HouseInfo[houseid][hOwnerID] = PlayerInfo[playerid][pID];
	}

	HouseInfo[houseid][hTimestamp] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", HouseInfo[houseid][hTimestamp], HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hOwner], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
}

RemoveFurniture(objectid)
{
    if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
 		new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteFurnitureObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM furniture WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer);
	}
}

DeleteFurnitureObject(objectid)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
    	new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);

        if(IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }

        DestroyDynamicObject(objectid);
	}
}

RemoveAllFurniture(houseid)
{
    if(HouseInfo[houseid][hExists])
	{
	    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
	        {
             	DeleteFurnitureObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

ReloadFurniture(objectid, labels)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
	    new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteFurnitureObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM furniture WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, labels);
	}
}

ReloadAllFurniture(houseid)
{
    if(HouseInfo[houseid][hExists])
	{
	    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
	        {
             	DeleteFurnitureObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, HouseInfo[houseid][hLabels]);
	}
}

ReloadHouse(houseid)
{
	if(HouseInfo[houseid][hExists])
	{
	    new
	        housestring[128*2],
			type[16];

		DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
		DestroyDynamicPickup(HouseInfo[houseid][hPickup]);

		if(HouseInfo[houseid][hType] == -1)
		{
		    type = "Other";
		}
		else
		{
		    strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
		}

        if(HouseInfo[houseid][hOwnerID] == 0)
        {
	        format(housestring, sizeof(housestring), "%s\nHouse Level: %i\nCost: $%i\n"WHITE"%s %d", type, HouseInfo[houseid][hLevel], HouseInfo[houseid][hPrice], GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]), houseid);
			HouseInfo[houseid][hText] = CreateDynamic3DTextLabel(housestring, 0xffea5eff, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ] + 0.1, 10.0, .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
			HouseInfo[houseid][hPickup] = CreateDynamicPickup(19524, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
			HouseInfo[houseid][hMapIcon] = CreateDynamicMapIcon(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 31, 1, -1, -1, -1, 45.0);
		}
		else
		{
		    if(HouseInfo[houseid][hRentPrice] > 0)
		    {
		        format(housestring, sizeof(housestring), "%s\nHouse Level: %i\nOwned by %s\nRent Cost: $%i\n"WHITE"%s %d", type, HouseInfo[houseid][hLevel], HouseInfo[houseid][hOwner], HouseInfo[houseid][hRentPrice], GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]), houseid);
		    }
		    else
		    {
			    format(housestring, sizeof(housestring), "%s\nHouse Level: %i\nOwned by %s\n"WHITE"%s %d", type, HouseInfo[houseid][hLevel], HouseInfo[houseid][hOwner], GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]), houseid);
			}
			HouseInfo[houseid][hText] = CreateDynamic3DTextLabel(housestring, 0xff3838ff, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ] + 0.1, 10.0, .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
	        HouseInfo[houseid][hPickup] = CreateDynamicPickup(19522, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
			HouseInfo[houseid][hMapIcon] = CreateDynamicMapIcon(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 32, 1, -1, -1, -1, 45.0);
		}

	}
}



GetVehicleParams(vehicleid, param)
{
	new
	    params[7];

	GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	return params[param] == VEHICLE_PARAMS_ON;
}

SetVehicleParams(vehicleid, param, status)
{
	new
	    params[7];

	GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);

	params[param] = status;

	return SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
}

Float:GetVehicleSpeed(vehicleid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	if(GetVehicleVelocity(vehicleid, x, y, z))
	{
		return floatsqroot((x * x) + (y * y) + (z * z)) * 181.5;
	}

	return 0.0;
}

VehicleHasWindows(vehicleid)
{
    static const vehicleWindows[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0,
		0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,
		0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};

	new
	    model = GetVehicleModel(vehicleid);

	if(400 <= model <= 611)
	{
	    return vehicleWindows[model - 400];
	}

	return 0;
}

VehicleHasEngine(vehicleid)
{
	static const vehicleEngines[] = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1,
		1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};

	new
	    modelid = GetVehicleModel(vehicleid);

	if(400 <= modelid <= 611)
	{
		return vehicleEngines[modelid - 400];
	}

	return 0;
}

GetVehicleSeatCount(vehicleid)
{
    static const vehicleSeats[] =
	{
		4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
		1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4,
		4, 2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2,
		2, 4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2,
		1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4,
		2, 2, 4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2,
		4, 4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0,
		4, 0, 0
	};

	new
	    modelid = GetVehicleModel(vehicleid);

	if(400 <= modelid <= 611)
	{
		return vehicleSeats[modelid - 400];
	}

	return 0;
}

IsSeatOccupied(vehicleid, seatid)
{
	foreach(new i : Player)
	{
	    if(IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seatid)
	    {
	        return 1;
		}
	}

	return 0;
}
GetVehicleName(vehicleid)
{
	new
		modelid = GetVehicleModel(vehicleid),
		name[32];

	if(400 <= modelid <= 611)
	    strcat(name, vehicleNames[modelid - 400]);
	else
	    name = "Unknown";

	return name;
}

GetVehicleModelByName(const string[])
{
	new
	    modelid = strval(string);

	if(400 <= modelid <= 611)
	{
	    return modelid;
	}

	for(new i = 0; i < sizeof(vehicleNames); i ++)
	{
		if(strfind(vehicleNames[i], string, true) != -1)
  		{
			return i + 400;
		}
	}

	return 0;
}

AnticheatCheck(playerid)
{
	if(gettime() > PlayerInfo[playerid][pACTime] && !PlayerInfo[playerid][pKicked] && InsideTut[playerid] == 0)
	{
	    // Speedhacking
		if((gAnticheat) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 350 && PlayerInfo[playerid][pAdmin] < 2)
		{
		    PlayerInfo[playerid][pACWarns]++;

		    if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
		        SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly speedhacking, speed: %.1f km/h.", GetRPName(playerid), playerid, GetVehicleSpeed(GetPlayerVehicleID(playerid)));
			}
			else
			{
			    SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Speed hacking", GetRPName(playerid), SERVER_BOT);
			    //BanPlayer(playerid, SERVER_BOT, "Speed hacking");
			    new szString[128];
			    format(szString, sizeof(szString),   "%s (uid: %i) possibly speedhacked, speed: %.1f km/h", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleSpeed(GetPlayerVehicleID(playerid)));
			    SendDiscordMessage(2, szString);
			    Kick(playerid);
			}
		}
  
		// Jetpack
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && PlayerInfo[playerid][pAdmin] < 2 && !PlayerInfo[playerid][pJetpack])
		{
		    SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Jetpack", GetRPName(playerid), SERVER_BOT);
	    	//BanPlayer(playerid, SERVER_BOT, "Jetpack");
			new szString[128];
		    format(szString, sizeof(szString),   "%s (uid: %i) possibly speedhacked, speed: %.1f km/h", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleSpeed(GetPlayerVehicleID(playerid)));
		    SendDiscordMessage(2, szString);
	    	
	    	Kick(playerid);
		}

		// Flying hacks
		if((gAnticheat) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			switch(GetPlayerAnimationIndex(playerid))
			{
			    case 958, 1538, 1539, 1543:
			    {
			        new
			            Float:z,
			            Float:vx,
			            Float:vy,
			            Float:vz;

					GetPlayerPos(playerid, z, z, z);
                    GetPlayerVelocity(playerid, vx, vy, vz);

                    if((z > 20.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9) && (!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6))
                    {
                    	SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Flying Hacks", GetRPName(playerid), SERVER_BOT);
		    			//BanPlayer(playerid, SERVER_BOT, "Flying hacks");
		    			new szString[128];
			            format(szString, sizeof(szString),   "%s (uid: %i) possibly speedhacked, speed: %.1f km/h", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleSpeed(GetPlayerVehicleID(playerid)));
			            SendDiscordMessage(2, szString);
		    			Kick(playerid);
					}
				}
			}
		}

		// Armor hacks
		if(!PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pPaintball] == 0 && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID)
		{
		    new
   				Float:armor;

			GetPlayerArmour(playerid, armor);

  			if(!(gettime() - PlayerInfo[playerid][pLastUpdate] > 5))
  			{
				if(floatround(armor) > floatround(PlayerInfo[playerid][pArmor]) && gettime() > PlayerInfo[playerid][pACTime] && gettime() > PlayerInfo[playerid][pArmorTime] && PlayerInfo[playerid][pAdmin] < 2)
				{
		            PlayerInfo[playerid][pACWarns]++;
	    	        PlayerInfo[playerid][pArmorTime] = gettime() + 10;

				    if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
				    {
				        SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly armor hacking. (old: %.2f, new: %.2f)", GetRPName(playerid), playerid, PlayerInfo[playerid][pArmor], armor);
                        new szString[128];
					    format(szString, sizeof(szString),   "%s (uid: %i) had a desynced %s with %i ammunition.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetWeaponNameEx(PlayerInfo[playerid][pCurrentWeapon]), GetPlayerAmmo(playerid));
					    SendDiscordMessage(2, szString);
					    ////Log_Write("log_cheat", "%s (uid: %i) possibly hacked armor. (old: %.2f, new: %.2f)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], PlayerInfo[playerid][pArmor], armor);
					}
					else
					{
					    SAM(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: Armor hacking", GetRPName(playerid), SERVER_BOT);
					    //BanPlayer(playerid, SERVER_BOT, "Armor hacking");
					    Kick(playerid);
					}
				}
			}

			PlayerInfo[playerid][pArmor] = armor;
		}
	}

	// Ammo hacks
	if(!PlayerInfo[playerid][pJoinedEvent] && PlayerInfo[playerid][pDueling] == INVALID_PLAYER_ID && !(PlayerInfo[playerid][pTazer] && GetPlayerWeapon(playerid) == 23))
	{
	    new
			weapon,
			ammo;

		GetPlayerWeaponData(playerid, 8, weapon, ammo);

		if((16 <= weapon <= 18) && ammo <= 0)
		{
			
			RemovePlayerWeaponEx(playerid, weapon);
			
		}
	}
}

IsAnIP(const ip[])
{
	new part[4];

	if(!sscanf(ip, "p<.>iiii", part[0], part[1], part[2], part[3]))
	{
	    return (0 <= part[0] <= 255) && (0 <= part[1] <= 255) && (0 <= part[2] <= 255) && (0 <= part[3] <= 255);
	}
	else if(!sscanf(ip, "p<.>iicc", part[0], part[1], part[2], part[3]))
	{
	    return (0 <= part[0] <= 255) && (0 <= part[1] <= 255) && (part[2] == '*' && part[3] == '*');
	}

	return 0;
}

IsValidName(const name[])
{
	for(new i = 0, j = strlen(name); i < j; i ++)
	{
	    if(!(3 <= j <= MAX_PLAYER_NAME))
	        return 0;

	    switch(name[i])
	    {
	        case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '[', ']', '(', ')', '=', '@':
	        {
	            continue;
			}
			default:
			{
			    return 0;
			}
		}
	}

	return 1;
}

IsValidModel(modelid)
{
    static modeldat[] =
	{
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -128,
        -515899393, -134217729, -1, -1, 33554431, -1, -1, -1, -14337, -1, -33,
      	127, 0, 0, 0, 0, 0, -8388608, -1, -1, -1, -16385, -1, -1, -1, -1, -1,
       -1, -1, -33, -1, -771751937, -1, -9, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, 33554431, -25, -1, -1, -1, -1, -1, -1,
       -1073676289, -2147483648, 34079999, 2113536, -4825600, -5, -1, -3145729,
       -1, -16777217, -63, -1, -1, -1, -1, -201326593, -1, -1, -1, -1, -1,
       -257, -1, 1073741823, -133122, -1, -1, -65, -1, -1, -1, -1, -1, -1,
       -2146435073, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1073741823, -64, -1,
       -1, -1, -1, -2635777, 134086663, 0, -64, -1, -1, -1, -1, -1, -1, -1,
       -536870927, -131069, -1, -1, -1, -1, -1, -1, -1, -1, -16384, -1,
       -33554433, -1, -1, -1, -1, -1, -1610612737, 524285, -128, -1,
       2080309247, -1, -1, -1114113, -1, -1, -1, 66977343, -524288, -1, -1, -1,
       -1, -2031617, -1, 114687, -256, -1, -4097, -1, -4097, -1, -1,
       1010827263, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -32768, -1, -1, -1, -1, -1,
       2147483647, -33554434, -1, -1, -49153, -1148191169, 2147483647,
       -100781080, -262145, -57, 134217727, -8388608, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1048577, -1, -449, -1017, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1835009, -2049, -1, -1, -1, -1, -1, -1,
       -8193, -1, -536870913, -1, -1, -1, -1, -1, -87041, -1, -1, -1, -1, -1,
       -1, -209860, -1023, -8388609, -2096897, -1, -1048577, -1, -1, -1, -1,
       -1, -1, -897, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1610612737,
       -3073, -28673, -1, -1, -1, -1537, -1, -1, -13, -1, -1, -1, -1, -1985,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1056964609, -1, -1, -1,
       -1, -1, -1, -1, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -236716037, -1, -1, -1, -1, -1, -1, -1, -536870913, 3, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -2097153, -2109441, -1, 201326591, -4194304, -1, -1,
       -241, -1, -1, -1, -1, -1, -1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, -32768, -1, -1, -1, -2, -671096835, -1, -8388609, -66323585, -13,
       -1793, -32257, -247809, -1, -1, -513, 16252911, 0, 0, 0, -131072,
       33554383, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 8356095, 0, 0, 0, 0, 0,
       0, -256, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -268435449, -1, -1, -2049, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       92274627, -65536, -2097153, -268435457, 591191935, 1, 0, -16777216, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 127
	};

	if((modelid >= 0) && ((modelid / 32) < sizeof (modeldat)) && (modeldat[modelid / 32] & (1 << (modelid % 32))))
  	{
   	    return 1;
	}

	if((18632 <= modelid <= 19999) || (11682 <= modelid <= 11753))
	{
	    return 1;
	}

 	return 0;
}

forward SetVehicleEngine(vehicleid, playerid);
public SetVehicleEngine(vehicleid, playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{
	    PlayerInfo[playerid][pEngine] = 0;
		SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s turns on the engine of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}

forward SetVehicleEngineHotwire(vehicleid, playerid);
public SetVehicleEngineHotwire(vehicleid, playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{
		new hotwire = random(100);
		switch(hotwire)
		{
			case 0..40:
			{
				PlayerInfo[playerid][pEngine] = 0;
				SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has successfully hotwired the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
			}
			case 41..100:
			{
				if(PlayerInfo[playerid][pWantedLevel] < 6)
				{
					PlayerInfo[playerid][pWantedLevel]++;
				}
				PlayerInfo[playerid][pEngine] = 0;
				SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has failed to hotwire the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = %i WHERE uid = %i", PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
	}
	return 1;
}

IsPlayerOnline(const name[], &id = INVALID_PLAYER_ID)
{
	foreach(new i : Player)
	{
	    if(!strcmp(GetPlayerNameEx(i), name) && PlayerInfo[i][pLogged])
	    {
	        id = i;
	        return 1;
		}
	}

	id = INVALID_PLAYER_ID;
	return 0;
}

IsPlayerAimingEx(playerid)
{
    new
		keys,
		ud,
		lr;

	GetPlayerKeys(playerid, keys, ud, lr);

	if((keys & KEY_HANDBRAKE) & KEY_HANDBRAKE && (22 <= GetPlayerWeapon(playerid) <= 38))
	{
		switch(GetPlayerAnimationIndex(playerid))
		{
			case 1160..1167, 360..363, 220, 640, 1189, 1331, 1365, 1453, 1449, 1643:
			{
			    return 1;
			}
		}
	}

	return 0;
}

IsPlayerInOilExpoArea(playerid)
{
    for(new i = 0; i < sizeof(oilexpoPositions); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4.0, oilexpoPositions[i][0], oilexpoPositions[i][1], oilexpoPositions[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}
IsPlayerInFruitArea(playerid)
{
    
    if(IsPlayerInRangeOfPoint(playerid, 4.0, -2252.951416, -2317.525634, 29.305549))
    {
   	   return 1;
    }
	return 0;
}

IsPlayerInHarvestArea(playerid)
{
    for(new i = 0; i < sizeof(harvestPositions); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4.0, harvestPositions[i][0], harvestPositions[i][1], harvestPositions[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}

IsPlayerInSurgeryArea(playerid)
{
    for(new i = 0; i < sizeof(SurgeryPositions); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4.0, SurgeryPositions[i][0], SurgeryPositions[i][1], SurgeryPositions[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}

IsPlayerAtFuelStation(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 12.0, 1004.0070, -939.3102, 42.1797) || IsPlayerInRangeOfPoint(playerid, 12.0, 1944.3260, -1772.9254, 13.3906) || IsPlayerInRangeOfPoint(playerid, 12.0, -90.5515, -1169.4578, 2.4079) || IsPlayerInRangeOfPoint(playerid, 12.0, -1609.7958, -2718.2048, 48.5391)|| IsPlayerInRangeOfPoint(playerid, 12.0, 1165.1558,1341.8663,10.8440)) {
        return 1;
	} else if(IsPlayerInRangeOfPoint(playerid, 12.0, -2029.4968, 156.4366, 28.9498) || IsPlayerInRangeOfPoint(playerid, 12.0, -2408.7590, 976.0934, 45.4175) || IsPlayerInRangeOfPoint(playerid, 12.0, -2243.9629, -2560.6477, 31.8841) || IsPlayerInRangeOfPoint(playerid, 12.0, -1676.6323, 414.0262, 6.9484) || IsPlayerInRangeOfPoint(playerid, 12.0, 1165.5591,1347.2380,10.8440) || IsPlayerInRangeOfPoint(playerid, 12.0, 1033.3330, 1727.5920, 10.8203)) {
	    return 1;
	} else if(IsPlayerInRangeOfPoint(playerid, 12.0, 2202.2349, 2474.3494, 10.5258) || IsPlayerInRangeOfPoint(playerid, 12.0, 614.9333, 1689.7418, 6.6968) || IsPlayerInRangeOfPoint(playerid, 12.0, -1328.8250, 2677.2173, 49.7665) || IsPlayerInRangeOfPoint(playerid, 12.0, 70.3882, 1218.6783, 18.5165) || IsPlayerInRangeOfPoint(playerid, 12.0, 1165.3307,1352.8799,10.8440) || IsPlayerInRangeOfPoint(playerid, 12.0, 1077.2427, -1367.4689, 13.6777)) {
	    return 1;
	} else if(IsPlayerInRangeOfPoint(playerid, 12.0, 654.9641, -559.7485, 16.5015) || IsPlayerInRangeOfPoint(playerid, 12.0, 654.9617, -570.4176, 16.5015) || IsPlayerInRangeOfPoint(playerid, 12.0, 1382.9899, 461.9903, 20.1245) || IsPlayerInRangeOfPoint(playerid, 12.0, 1172.7735, -1327.6424, 13.6519) || IsPlayerInRangeOfPoint(playerid, 12.0, 1165.0531, -1327.9595, 13.7192) || IsPlayerInRangeOfPoint(playerid, 12.0, 977.1491,-1452.3787,13.4795)) {
        return 1;
	}

	return 0;
}

IsPlayerInRangeOfDynamicObject(playerid, objectid, Float:radius)
{
	if(IsValidDynamicObject(objectid))
	{
		new
		    interiorid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID),
			worldid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID),
		    Float:x,
		    Float:y,
		    Float:z;

		GetDynamicObjectPos(objectid, x, y, z);

		if(interiorid == -1) {
		    interiorid = GetPlayerInterior(playerid);
		} if(worldid == -1) {
		    worldid = GetPlayerVirtualWorld(playerid);
		}

		if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z) && GetPlayerInterior(playerid) == interiorid && GetPlayerVirtualWorld(playerid) == worldid)
		{
		    return 1;
		}
	}

	return 0;
}

IsPlayerInRangeOfPlayer(playerid, targetid, Float:radius)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
	{
	    return 1;
	}

	return 0;
}

SetMusicStream(type, extraid, const url[])
{
	switch(type)
	{
	    case MUSIC_MP3PLAYER:
	    {
	        if(isnull(url) && PlayerInfo[extraid][pStreamType] == type)
	        {
	            StopAudioStreamForPlayer(extraid);
	            PlayerInfo[extraid][pStreamType] = MUSIC_NONE;
	        }
	        else
	        {
	            PlayAudioStreamForPlayer(extraid, url);
	            PlayerInfo[extraid][pStreamType] = type;
	        }
		}
		case MUSIC_BOOMBOX:
		{
		    foreach(new i : Player)
		    {
		        if(PlayerInfo[i][pBoomboxListen] == extraid)
		        {
				    if(isnull(url) && PlayerInfo[i][pStreamType] == type)
				    {
				        StopAudioStreamForPlayer(i);
			            PlayerInfo[i][pStreamType] = MUSIC_NONE;
			        }
			        else if(PlayerInfo[i][pStreamType] == MUSIC_NONE || PlayerInfo[i][pStreamType] == MUSIC_BOOMBOX)
			        {
			            PlayAudioStreamForPlayer(i, url);
			            PlayerInfo[i][pStreamType] = type;
			        }
				}
			}

			strcpy(PlayerInfo[extraid][pBoomboxURL], url, 128);
		}
		case MUSIC_VEHICLE:
		{
		    foreach(new i : Player)
		    {
		        if(IsPlayerInVehicle(i, extraid))
		        {
				    if(isnull(url) && PlayerInfo[i][pStreamType] == type)
				    {
		        		StopAudioStreamForPlayer(i);
	            		PlayerInfo[i][pStreamType] = MUSIC_NONE;
			        }
	    		    else if(PlayerInfo[i][pStreamType] == MUSIC_NONE || PlayerInfo[i][pStreamType] == MUSIC_VEHICLE)
			        {
	    		        PlayAudioStreamForPlayer(i, url);
	           		 	PlayerInfo[i][pStreamType] = type;
					}
				}
			}

			strcpy(vehicleStream[extraid], url, 128);
		}
	}
}

DestroyPotPlant(playerid)
{
	if(PlayerInfo[playerid][pPotPlanted])
	{
	    DestroyDynamicObject(PlayerInfo[playerid][pPotObject]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET potplanted = 0, pottime = 0, potgrams = 0, pot_x = 0.0, pot_y = 0.0, pot_z = 0.0, pot_a = 0.0 WHERE uid = %i", PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerInfo[playerid][pPotPlanted] = 0;
	    PlayerInfo[playerid][pPotTime] = 0;
	    PlayerInfo[playerid][pPotGrams] = 0;
	    PlayerInfo[playerid][pPotX] = 0.0;
	    PlayerInfo[playerid][pPotY] = 0.0;
	    PlayerInfo[playerid][pPotZ] = 0.0;
	    PlayerInfo[playerid][pPotA] = 0.0;
	}
}

DestroyBoombox(playerid)
{
	if(PlayerInfo[playerid][pBoomboxPlaced])
	{
    	DestroyDynamicObject(PlayerInfo[playerid][pBoomboxObject]);
		DestroyDynamic3DTextLabel(PlayerInfo[playerid][pBoomboxText]);

		PlayerInfo[playerid][pBoomboxObject] = INVALID_OBJECT_ID;
		PlayerInfo[playerid][pBoomboxText] = Text3D:INVALID_3DTEXT_ID;
        PlayerInfo[playerid][pBoomboxPlaced] = 0;
        PlayerInfo[playerid][pBoomboxURL] = 0;
	}
}

GetNearbyBoombox(playerid)
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pBoomboxPlaced] && IsPlayerInRangeOfDynamicObject(playerid, PlayerInfo[i][pBoomboxObject], 30.0))
	    {
	        return i;
		}
	}

	return INVALID_PLAYER_ID;
}

forward SaveAccount();
public SaveAccount()
{
	new saved, checked;
	while(checked < MAX_PLAYERS && saved < 30)
	{
		new i = AutoSaveCursor;
		AutoSaveCursor++;

		if(AutoSaveCursor >= MAX_PLAYERS)
		{
			AutoSaveCursor = 0;
		}

		checked++;

		if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
		{
			SavePlayerVariables(i);
			saved++;
		}
	}
    return 1;
}

stock SendQuestionToStaff(color, const text[])
{
	foreach(new x: Player)
	{
		if(PlayerInfo[x][pHelper] >= 1 || PlayerInfo[x][pAdmin] >= 1)
		{
		    SendClientMessageEx(x, color, text);
		}
	}
}

SendClientMessageEx(playerid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    SendClientMessage(playerid, color, text);
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

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

SendMessage(playerid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    SendClientMessage(playerid, color, text);
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

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

SendMessageToAll(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged])
	        {
			    SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged])
	        {
			    SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

SendFactionMessage(factionid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == factionid)
	        {
	    		SendClientMessage(i, color, text);
			}
		}
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

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == factionid)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

SendGangMessage(gangid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pGang] == gangid)
	        {
	    		SendClientMessage(i, color, text);
			}
		}
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

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pGang] == gangid)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

forward SendAdminMessage(color, const text[], {Float,_}:...);
public SendAdminMessage(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0)
	        {
	    		SendClientMessage(i, color, text);
			}
		}

		print(text);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 1)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		print(str);

		#emit RETN
	}
	return 1;
}


SendHelperMessage(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pHelper] > 0)
	        {
	    		SendClientMessage(i, color, text);
			}
		}

		print(text);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && PlayerInfo[i][pHelper] > 0)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		print(str);

		#emit RETN
	}
	return 1;
}

SendTurfMessage(turfid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && GetNearbyTurf(i) == turfid)
	        {
	    		SendClientMessage(i, color, text);
			}
		}
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

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && GetNearbyTurf(i) == turfid)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}
getTurftype(tid)
{
	new ret[32], id = TurfInfo[tid][tType];
	switch(id)
	{
		case 0: { ret = "Normal"; }
		case 1: { ret = "Hollow point ammo"; } // hollowpoimt
		case 2: { ret = "Poison tip ammo"; }// poisontip
		case 3: { ret = "FMJ ammo"; }// fmj
		case 4: { ret = "Materials"; } // old weps
		case 5: { ret = "Traphouse"; }
		case 6: { ret = "Crackhouse"; }
		case 7: { ret = "Sales tax"; }
		case 8: { ret = "Low class weapons"; }
		case 9: { ret = "Medium class weapons"; }
		case 10: { ret = "High class weapons"; }
		case 11: { ret = "Gang Influence Place"; }
	}
	return ret;
}
SendStaffMessage(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && (PlayerInfo[i][pAdmin] > 0 || PlayerInfo[i][pHelper] > 0))
	        {
	    		SendClientMessage(i, color, text);
			}
		}

		print(text);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && (PlayerInfo[i][pAdmin] > 0 || PlayerInfo[i][pHelper] > 0))
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		print(str);

		#emit RETN
	}
	return 1;
}

SetPlayerBubbleText(playerid, Float:drawdistance, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 4)
	{
	    SetPlayerChatBubble(playerid, text, color, drawdistance, 8000);
	}
	else
	{
		while(--args >= 4)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri    8
		#emit CONST.alt     4
		#emit SUB
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		SetPlayerChatBubble(playerid, str, color, drawdistance, 8000);

		#emit RETN
	}
	return 1;
}


SendProximityMessage(playerid, Float:radius, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 4)
	{
	    foreach(new i : Player)
		{
	        if(IsPlayerInRangeOfPlayer(i, playerid, radius) || PlayerInfo[i][pListen])
	        {
	            SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 4)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri    8
		#emit CONST.alt     4
		#emit SUB
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
		{
	        if(IsPlayerInRangeOfPlayer(i, playerid, radius) || PlayerInfo[i][pListen])
	        {
	            SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

SendProximityFadeMessage(playerid, Float:radius, const text[], color1, color2, color3, color4, color5)
{
    foreach(new i : Player)
    {
	    if(IsPlayerInRangeOfPlayer(i, playerid, radius / 16))
		{
            SendClientMessage(i, color1, text);
        }
		else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 8))
		{
            SendClientMessage(i, color2, text);
        }
		else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 4))
		{
            SendClientMessage(i, color3, text);
        }
		else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 2))
		{
            SendClientMessage(i, color4, text);
        }
		else if(IsPlayerInRangeOfPlayer(i, playerid, radius))
		{
            SendClientMessage(i, color5, text);
        }
        else if(PlayerInfo[i][pListen])
        {
            SendClientMessage(i, color5, text);
        }
	}
}



forward RemoveBlood(playerid);
public RemoveBlood(playerid)
{
    for(new i = 0; i < 8;i++)
    {
        TextDrawHideForPlayer(playerid, Blood[i]);
    }
    pBlood[playerid] = false;
    return 1;
}

// After registration
forward PlayerSpawn(playerid);
public PlayerSpawn(playerid)
{
	if(PlayerInfo[playerid][pLogged] && PlayerInfo[playerid][pTutorial])
	{
		if(PlayerInfo[playerid][pLogged] && PlayerInfo[playerid][pTutorial])
		{
			for (new i = 0; i < 21; i ++) {
				PlayerTextDrawDestroy(playerid, CharTextdraw[playerid][i]);
			}

  	        InsideTut[playerid] = 0;
			PlayerInfo[playerid][pTutorial] = 0;
			PlayerInfo[playerid][pSetup] = 0;

			SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);

			SetPlayerPos(playerid, 824.180358, -1361.649902, -0.507812);
			SetPlayerFacingAngle(playerid, 318.04);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);

			SetCameraBehindPlayer(playerid);
			StopAudioStreamForPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", PlayerInfo[playerid][pGender], PlayerInfo[playerid][pAge], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

            // Refund
			SendClientMessage(playerid, COLOR_BLUE, "[Welcome to "SERVER_NAME". Use the {FFFF90}/requesthelp{FFFFFF} command to guide you around the server.]");
			SendClientMessage(playerid, COLOR_BLUE, "[Use the {FFFF90}/locate{FFFFFF} command to point to locations of jobs, businesses, and common places.]");
			SendClientMessage(playerid, COLOR_BLUE, "[We are well aware of the script in use, please get to know our community before you pass on any judgement.]");

			SendClientMessage(playerid, COLOR_YELLOW, "And also you're a poor guy, You need to find a job just type /findjob");
			SMA(COLOR_LIGHTRED, "AK:RP AIRLINES: [%s(%d)] has just arrived to the city, welcome him/her through [/g]", GetRPName(playerid), playerid);
		}
	}
}

forward ShowMainMenuCamera(playerid);
public ShowMainMenuCamera(playerid)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM bans WHERE username = '%e' OR ip = '%e' OR ip LIKE '%e'", GetPlayerNameEx(playerid), GetPlayerIP(playerid), GetPlayerIPRange(playerid));
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOOKUP_BANS, playerid);
	 
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE username = '%e'", GetPlayerNameEx(playerid));
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_PROCESS_MUSIC, playerid);
}

stock SetVehicleSpeed(vehicleid, Float:speed,
	E_TDW_MATH_VEHICLE_SPEED_TYPE:type = EI_MATH_SPEED_KMPH)
{
	new
		Float:x,
		Float:y,
		Float:z;

	if (GetVehicleVelocity(vehicleid, x, y, z))
	{
		new
			Float:angle;

		GetVehicleVelocity(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);

		switch (type)
		{
			case EI_MATH_SPEED_KMPH:
				speed = floatdiv(speed, 180.0);
			case EI_MATH_SPEED_MPH:
				speed = floatdiv(speed, 111.846814);
		}

		x = floatmul(speed, floatsin(-angle, degrees));
		y = floatmul(speed, floatcos(-angle, degrees));

		SetVehicleVelocity(vehicleid, x, y, z);
	}
	return 0;
}

stock Dyuze(playerid, const title[], const string[], time = 5000)
{
	if(PlayerInfo[playerid][pDyuze])
	{
		PlayerTextDrawHide(playerid, ModernPlayerText[playerid][0]);
		KillTimer(PlayerInfo[playerid][pDyuzeTimer]);
	}
	new string2[128];
	format(string2, sizeof(string2), "%s~n~_", title);
	DynamicPlayerTextDrawSetString(playerid, ModernPlayerText[playerid][0], string2);
	PlayerTextDrawShow(playerid, ModernPlayerText[playerid][0]);

	DynamicPlayerTextDrawSetString(playerid, ModernPlayerText[playerid][0], string);
	PlayerTextDrawShow(playerid, ModernPlayerText[playerid][0]);

	PlayerInfo[playerid][pDyuze] = true;
	PlayerInfo[playerid][pDyuzeTimer] = SetTimerEx("HidetheDyuze", time, false, "d", playerid);
}

forward HidetheDyuze(playerid);
public HidetheDyuze(playerid)
{
	if (!PlayerInfo[playerid][pDyuze])
	    return 0;

	PlayerInfo[playerid][pDyuze] = false;
	PlayerTextDrawHide(playerid, ModernPlayerText[playerid][0]);
	return 1;
}

forward Countdown(playerid, count);
public Countdown(playerid, count)
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pJoinedEvent])
	    {
	        switch(count)
	        {
	        	case 3:
				{
					Dyuze(i, "Countdown", "3");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 2:
				{
					Dyuze(i, "Countdown", "2");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 1:
				{
					Dyuze(i, "Countdown", "1");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 0:
				{
					Dyuze(i, "Countdown", "Go! Go! Go!");
					PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
				}
			}
		}
	}

	count--;

	if(count >= 0)
	{
 		SetTimerEx("Countdown", 1000, false, "ii", playerid, count);
	}
}

forward CountdownAll(playerid, count);
public CountdownAll(playerid, count)
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pLogged])
	    {
	        switch(count)
	        {
	        	case 3:
				{
					Dyuze(i, "Countdown", "3");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 2:
				{
					Dyuze(i, "Countdown", "2");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 1:
				{
					Dyuze(i, "Countdown", "1");
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
				}
				case 0:
				{
					Dyuze(i, "Countdown", "Go! Go! Go!");
					PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
				}
			}
		}
	}

	count--;

	if(count >= 0)
	{
 		SetTimerEx("CountdownAll", 1000, false, "ii", playerid, count);
	}
}
forward UnfreezeNewbie(playerid);
public UnfreezeNewbie(playerid)
{
    TogglePlayerControllable(playerid, true);
}

forward VehicleUnfreeze(playerid, vehicleid, Float:x, Float:y, Float:z, interior, world);
public VehicleUnfreeze(playerid, vehicleid, Float:x, Float:y, Float:z, interior, world)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInRangeOfPoint(playerid, 100.0, x, y, z) && GetPlayerInterior(playerid) == interior && GetPlayerVirtualWorld(playerid) == world)
	{
		SetVehiclePos(vehicleid, x, y, z);
	}

	TogglePlayerControllable(playerid, true);
}

forward UnfreezePlayer(playerid, Float:x, Float:y, Float:z);
public UnfreezePlayer(playerid, Float:x, Float:y, Float:z)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
	{
	    SetPlayerPos(playerid, x, y, z);
	    TogglePlayerControllable(playerid, true);
	}
}

forward UnfreezePlayerEx(playerid);
public UnfreezePlayerEx(playerid)
{
	TogglePlayerControllable(playerid, true);
	return 1;
}

forward DestroyWater(objectid);
public DestroyWater(objectid)
{
	DestroyDynamicObject(objectid);
}

forward LotteryUpdate();
public LotteryUpdate()
{
	new number = random(60) + 1, jackpot = random(20000) + 10000;
	foreach (new i : Player)
	{
		if(PlayerInfo[i][pLotteryB] == 1)
		{
			if (PlayerInfo[i][pLottery] == number)
			{
				GivePlayerCash(i, jackpot);
				SMA(COLOR_YELLOW, "Lottery: %s have won the lottery jackpot of %s!", GetRPName(i), FormatNumber(jackpot));
			}
			else
			{
				SendClientMessage(i, COLOR_WHITE, "Lottery: You didn't win the lottery draw this time.");
			}
			PlayerInfo[i][pLottery] = 0;
			PlayerInfo[i][pLotteryB] = 0;
		}
	}
	return 1;
}

IsHelicopter(vehid)
{
    new pveh = GetVehicleModel(vehid);
    if(pveh == 417|| pveh == 425 || pveh == 447 || pveh == 469 || pveh == 487
	|| pveh == 488 || pveh == 497 || pveh == 548 || pveh == 563) {
        return true;
    }
	return false;
}

IsSurfable(vehid)
{
	switch(GetVehicleModel(vehid)) {
		case 422, 535, 470, 406, 478, 543, 554, 600, 605, 607, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454:
			return 1;
	}
	if(IsHelicopter(vehid)) return 1;
	return 0;
}

AntiCarSurf(playerid)
{
    new vehid = GetPlayerSurfingVehicleID(playerid);
    if(vehid != INVALID_VEHICLE_ID && GetVehicleSpeed(vehid) >= 20.0)
    {
		if(IsSurfable(vehid)) {
			SetPVarInt(playerid, "DistortAim", 1);
        }
        else {
        	GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
            SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY]+1.0, PlayerInfo[playerid][pPosZ]+1.0);
        }
    }
}


Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo)
{
	new
		Float: fPlayerPos[3];

	GetPlayerPos(iPlayerOne, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
	return GetPlayerDistanceFromPoint(iPlayerTwo, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
}

Float:GetVehicleSpeedMPH(vehicleid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	if(GetVehicleVelocity(vehicleid, x, y, z))
	{
		return floatsqroot((x * x) + (y * y) + (z * z)) * 100;
	}

	return 0.0;
}

GetPlayerVehicle(playerid, vehicleid)
{
	#pragma unused playerid
    foreach(new v : Vehicle)
    {
        if(VehicleInfo[v][vID] == vehicleid)
        {
            return v;
        }
    }
    return 0;
}

forward UpdateCarRadars();
public UpdateCarRadars()
{
	foreach(new p : Player)
	{
		if (!IsPlayerConnected(p) || !IsPlayerInAnyVehicle(p) || CarRadars[p] == 0) continue;

		new target = -1;
		new Float:tempDist = 50.0;

		if(CarRadars[p] == 1)
		{
			foreach(new t : Player)
			{
				if (!IsPlayerInAnyVehicle(t) || t == p || IsPlayerInVehicle(t, GetPlayerVehicleID(p))) continue;

				new Float:distance = GetDistanceBetweenPlayers(p, t);

				if (distance < tempDist)
				{
					target = t;
					tempDist = distance;
				}
			}

			if (target == -1)
			{
				// no target was found
				DynamicPlayerTextDrawSetString(p, _crTextTarget[p], "Target Vehicle: ~r~N/A");
				DynamicPlayerTextDrawSetString(p, _crTextSpeed[p], "Speed: ~r~N/A");
				DynamicPlayerTextDrawSetString(p, _crTickets[p], "Tickets: ~r~N/A");
			}
			else
			{
				new targetVehicle = GetPlayerVehicleID(target);

				new str[60];

				format(str, sizeof(str), "Target Vehicle: ~r~%s (%i)", GetVehicleName(targetVehicle), targetVehicle);
				DynamicPlayerTextDrawSetString(p, _crTextTarget[p], str);
				if(RadarType[p] == 0) {
					format(str, sizeof(str), "Speed: ~r~%.0f MP/H", GetVehicleSpeedMPH(targetVehicle));
					DynamicPlayerTextDrawSetString(p, _crTextSpeed[p], str);
				}
				else {
					format(str, sizeof(str), "Speed: ~r~%.0f KM/H", GetVehicleSpeed(targetVehicle));
					DynamicPlayerTextDrawSetString(p, _crTextSpeed[p], str);
				}
				foreach(new i : Player)
				{
					new veh = GetPlayerVehicle(i, targetVehicle);
					if (veh != -1 && VehicleInfo[veh][vTickets] > 0)
					{
						format(str, sizeof(str), "Tickets: ~r~$%s", number_format(VehicleInfo[veh][vTickets]));
						DynamicPlayerTextDrawSetString(p, _crTickets[p], str);
						if (gettime() >= (GetPVarInt(p, "_lastTicketWarning") + 10))
						{
							SetPVarInt(p, "_lastTicketWarning", gettime());
							PlayerPlaySound(p, 4202, 0.0, 0.0, 0.0);
						}
					}
				}
			}
		}
	}
}

ComServ(playerid)
{
	if (PlayerInfo[playerid][pComserv] > 1)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 100.0, 1477.3464, -1667.8080, 14.5532))
		{
			SetPlayerPos(playerid, 1482.4253,-1717.5935,14.0469);
			SetPlayerFacingAngle(playerid, 9.8095);
			PlayerInfo[playerid][pComserv] += 2;
			SM(playerid, COLOR_GREY2,"** You can not escape. Your community service has been extended to %i", PlayerInfo[playerid][pComserv]);
		}
	}
}


forward IntroTimer9(playerid);
public IntroTimer9(playerid)
{
	SetPlayerFacingAngle(playerid, 129.10);
	InterpolateCameraPos(playerid, -2325.500976, -1655.345458, 483.703125, -2321.599121, -1647.181640, 483.703125 , 14000);
    InterpolateCameraLookAt(playerid, -2320.599121, -1648.181640, 483.703125, -2314.346679, -1633.997436, 483.703125, 14000, CAMERA_MOVE);

	SetTimerEx("ShowMainMenuCamera", 400, false, "i", playerid);
}

forward VehicleTimer();
public VehicleTimer()
{
	new string[16];
	foreach(new i : Player) {
    	if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
		{ // UPDATE SPEEDO

			new vehicleid = GetPlayerVehicleID(i);
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER && VehicleHasEngine(vehicleid))
		    {
        		new
					Float:health;
				new hour, minute;

				gettime(hour, minute);
				GetVehicleHealth(vehicleid, health);
				if(VehicleHasEngine(vehicleid))
				{
					format(string, sizeof(string), "%i", vehicleFuel[vehicleid]);
					DynamicPlayerTextDrawSetString(i, SPEEDO[i][2], string);
      				format(string, sizeof(string), "%.0f", GetVehicleSpeedMPH(vehicleid));
					DynamicPlayerTextDrawSetString(i, SPEEDO[i][0], string);

                    new Float:textDrawSizeY;

                 // Calculate the TextDraw size based on fuel percentage
                    textDrawSizeY = (vehicleFuel[vehicleid] / 100.0) * -32.0; // Maximum size is 32
                   // Set the text size for the TextDraw element
                    PlayerTextDrawTextSize(i, SPEEDO[i][16], 4.0, textDrawSizeY);
					PlayerTextDrawHide(i, SPEEDO[i][16]);
					PlayerTextDrawShow(i, SPEEDO[i][16]);
				}
				for(new x = 0; x < MAX_DEPLOYABLES; x++)
				{
				    if(DeployInfo[x][dExists] && DeployInfo[x][dType] == DEPLOY_SPIKESTRIP && IsPlayerInRangeOfPoint(i, 3.0, DeployInfo[x][dPosX], DeployInfo[x][dPosY], DeployInfo[x][dPosZ]))
			        {
			            new
			                panels,
			                doors,
			                lights,
			                tires;

			            GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

			            if(tires != 15)
			            {
			                UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
			                SendClientMessage(i, COLOR_SYNTAX, "Spiked!");
			            }
			        }
				}
			}
		}
	}
}

forward SecondTimer();
public SecondTimer()
{
	new hour, minute, boomboxid, string[128];
	gettime(hour, minute);
	
	if(InfluenceInfo[iTime] > 0)
	{
	    InfluenceInfo[iTime]--;
	}
	new Float:vhp;
	foreach(new vehicleid : Vehicle)
	{
		if(GetVehicleModel(vehicleid) == 0) continue; //only returns 0 when vehicle is invalid (not spawned)
		GetVehicleHealth(vehicleid,vhp);
		if(vhp < 300.0) {
			SetVehicleParams(vehicleid, VEHICLE_ENGINE, false);
			SetVehicleHealth(vehicleid, 251.0);
		}
	}

	foreach(new i : Player)
	{
  		//SetPlayerTime(i, hour, minute);
		if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
		{
			ComServ(i);
		    AFKCheck(i);
			AntiCarSurf(i);
			

		#if defined Christmas
			if(PlayerInfo[i][pLastCarolTime] > 0)
			{
				PlayerInfo[i][pLastCarolTime] -= 1;
			}
		#endif

			if(!AdminNameTagSynced[i] || AdminNameTagState[i] != PlayerInfo[i][pAdminDuty])
			{
				foreach (new j : Player) {
					ShowPlayerNameTagForPlayer(i, j, PlayerInfo[i][pAdminDuty] ? true : false);
				}

				AdminNameTagState[i] = PlayerInfo[i][pAdminDuty];
				AdminNameTagSynced[i] = true;
			}

			if(!PlayerInfo[i][pToggleHUD] && !PlayerInfo[i][pToggleTextdraws] && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
			{
				new hunger = PlayerInfo[i][pHunger], thirst = PlayerInfo[i][pThirst];
				if(hunger > 0)
				{
					new Float:hun = (hunger / 100.0) * -30.0;
					PlayerTextDrawHide(i,VALO[i][20]);
					PlayerTextDrawTextSize(i, VALO[i][20], 3.00, hun);
					PlayerTextDrawShow(i,VALO[i][20]);
					//PlayerText_MoveSize(i, VALO[i][20], 3.00, hun, 1000, EASE_OUT_QUAD);
				}
				else
				{
					PlayerTextDrawHide(i,VALO[i][20]);
					PlayerTextDrawTextSize(i, VALO[i][20], 3.00, 0);
					PlayerTextDrawShow(i,VALO[i][20]);
					//PlayerText_MoveSize(i, VALO[i][20], 3.00, 0, 1000, EASE_OUT_QUAD);
				}
				if(thirst > 0)
				{
					new Float:hun = (thirst / 100.0) * -30.0;

					PlayerTextDrawHide(i,VALO[i][23]);
					PlayerTextDrawTextSize(i, VALO[i][23], 3.00, hun);
					PlayerTextDrawShow(i,VALO[i][23]);
					//PlayerText_MoveSize(i, VALO[i][23], 3.00, hun, 1000, EASE_OUT_QUAD);
				}
				else
				{
					PlayerTextDrawHide(i,VALO[i][23]);
					PlayerTextDrawTextSize(i, VALO[i][23], 3.00, 0);
					PlayerTextDrawShow(i,VALO[i][23]);
					//PlayerText_MoveSize(i, VALO[i][23], 3.00, 0, 1000, EASE_OUT_QUAD);
				}
				new ping = GetPlayerPing(i);
				if(NetStats_PacketLossPercent(i) > 20.0 && gettime() - PlayerInfo[i][pLastDesync] > 420)
				{
					//PlayerText_InterpolateColor(i, VALO[i][19], -16776961, 500, EASE_OUT_QUAD);
					PlayerTextDrawHide(i,VALO[i][19]);
					PlayerTextDrawColour(i, VALO[i][19],-16776961);
					PlayerTextDrawShow(i,VALO[i][19]);
					DynamicPlayerTextDrawSetString(i, VALO[i][18] , "DESYNCED");
					PlayerInfo[i][pLastDesync] = gettime();
				}
				if(ping > 250)
				{
					//PlayerText_InterpolateColor(i, VALO[i][19], -16776961, 500, EASE_OUT_QUAD);]
					PlayerTextDrawHide(i,VALO[i][19]);
					PlayerTextDrawColour(i, VALO[i][19],-16776961);
					PlayerTextDrawShow(i,VALO[i][19]);
					DynamicPlayerTextDrawSetString(i, VALO[i][18] , "UNSTABLE");

				}
				else if(ping > 140)
				{
					//PlayerText_InterpolateColor(i, VALO[i][19], -65281, 500, EASE_OUT_QUAD);
					PlayerTextDrawHide(i,VALO[i][19]);
					PlayerTextDrawColour(i, VALO[i][19],-65281);
					PlayerTextDrawShow(i,VALO[i][19]);

					DynamicPlayerTextDrawSetString(i, VALO[i][18] , "AVERAGE");
				}
				else
				{
					//PlayerText_InterpolateColor(i, VALO[i][19], 16711935, 500, EASE_OUT_QUAD);
					PlayerTextDrawHide(i,VALO[i][19]);
					PlayerTextDrawColour(i, VALO[i][19],16711935);
					PlayerTextDrawShow(i,VALO[i][19]);
					DynamicPlayerTextDrawSetString(i, VALO[i][18] , "STABLE");

				}
			}
        	if(PlayerInfo[i][pCapturingPoint] >= 0)
			{
				PlayerInfo[i][pCaptureTime]--;

				if(PlayerInfo[i][pCaptureTime] <= 0)
				{
					new Float:x, Float:y, Float:z;

					GetPlayerPos(i, x, y, z);

					if(PointInfo[PlayerInfo[i][pCapturingPoint]][pTime] == 0 && PlayerInfo[i][pPointX] == x && PlayerInfo[i][pPointY] == y && PlayerInfo[i][pPointZ] == z)
					{
						SMA(COLOR_GREEN, "%s attempted to capture %s for %s. It will be theirs in 15 minutes.", GetRPName(i), PointInfo[PlayerInfo[i][pCapturingPoint]][pName], GangInfo[PlayerInfo[i][pGang]][gName]);

						PointInfo[PlayerInfo[i][pCapturingPoint]][pCaptureTime] = 15;
						PointInfo[PlayerInfo[i][pCapturingPoint]][pCapturer] = i;
					}
					else
					{
						SendClientMessage(i, COLOR_SYNTAX, "You moved from your position and therefore failed to capture.");
					}

					PlayerInfo[i][pCapturingPoint] = -1;
					PlayerInfo[i][pCaptureTime] = 0;
				}
			}
			/*
           
	       	if(Maskara[i] && !PlayerInfo[i][pAdminDuty])
	    	{
	        	format(string, sizeof(string), "Stranger_%d", MaskaraID[i]);
				SetPlayerName(i, string);
	    	}
	    	if(!Maskara[i] && !PlayerInfo[i][pAdminDuty])
	    	{
				SetPlayerName(i, PlayerInfo[i][pUsername]);
	    	}*/ // connection close bug

			if(PlayerInfo[i][pLoopAnim] && !PlayerInfo[i][pToggleTextdraws])
			{
				TextDrawShowForPlayer(i, AnimationTD);
		    }
			else
			{
		        TextDrawHideForPlayer(i, AnimationTD);
		    }

			#if defined Christmas
				if(PlayerInfo[i][pCandy])
				{
					format(string,sizeof(string),"C%d",PlayerInfo[i][pCandy]);
					DynamicPlayerTextDrawSetString(i, EventTextdraw[i], string);
				}
			#endif

		   	if(++PlayerInfo[i][pHungerTimer] >= 180 && PlayerInfo[i][pHunger] > 0) // 3 minutes
			{
				PlayerInfo[i][pHungerTimer] = 0;
				PlayerInfo[i][pHunger] -= 1;
				if(PlayerInfo[i][pHunger] == 10)
				{
					SendMessage(i, COLOR_GREY, "You hear your stomach rumble, you need to eat. You can die due to starvation");
				}
				if(PlayerInfo[i][pHunger] == 1) // 2 minutes
				{
					SendMessage(i, COLOR_GREY, "You fall unconscious due to starvation.");
					SetPlayerHealth(i, 0);
				}
			}
			if(++PlayerInfo[i][pThirstTimer] >= 120 && PlayerInfo[i][pThirst] > 0) // 2 minutes
			{
				PlayerInfo[i][pThirstTimer] = 0;
				PlayerInfo[i][pThirst] -= 1;

				if(PlayerInfo[i][pThirst] == 10)
				{
					SendMessage(i, COLOR_GREY, "You are thirsty, you need to drink. You can die due to thirst!");
				}
   				if(PlayerInfo[i][pThirst] == 1) // 2 minutes
				{
					SendMessage(i, COLOR_GREY, "You fall unconscious due to thirst.");
     				SetPlayerHealth(i, 0);
				}
			}
		   
			if(InfluenceInfo[iEnabled] == 1)
			{
				new turfid = GetNearbyTurf(i);
				new gangid = InfluenceInfo[iGangid];
				if(turfid > 0)
				{
			     
					if(gangid > 0)
					{
					format(string, sizeof(string), "Control:%s", GangInfo[gangid][gName]);
					DynamicPlayerTextDrawSetString(i, TurfTD[i][0], string);
					PlayerTextDrawColour(i, TurfTD[i][0], (GangInfo[gangid][gColor] & ~0xff) + 0xFF);
					ShowTurfTD(i);
					}
					else if(gangid == -1)
					{
						format(string, sizeof(string), "Control:Police");
						DynamicPlayerTextDrawSetString(i, TurfTD[i][0], string);
						PlayerTextDrawColour(i, TurfTD[i][0], (COLOR_BLUE & ~0xff) + 0xFF);
						ShowTurfTD(i);
					}
				}
				else
				{
					HideTurfTD(i);
				}
 	        }
 	        else
 	        {
				HideTurfTD(i);
			}
			new turfid = GetNearbyTurf(i);
   
            if(turfid > 0)
            {

	   	 	    if(InfluenceInfo[iTime] > 0)
			    {
			        new time = InfluenceInfo[iTime];
                    format(string, sizeof(string), "~y~Turf Time: ~w~%s", FormatTime(time));
                    DynamicPlayerTextDrawSetString(i, TurfTD[i][1], string);
                   	PlayerTextDrawShow(i, TurfTD[i][1]);
			    }
			    else
			    {
                  	PlayerTextDrawHide(i, TurfTD[i][1]);
			    }
			}
			else
			{
                PlayerTextDrawHide(i, TurfTD[i][1]);
			}

			format(string, sizeof(string), "%d%s", GetHealth(i),"%");
            DynamicPlayerTextDrawSetString(i, HUD[i][1], string);

            format(string, sizeof(string), "%d%s", GetArmor(i),"%");
            DynamicPlayerTextDrawSetString(i, HUD[i][3], string);
			
			format(string, sizeof(string), "%d%s", PlayerInfo[i][pHunger],"%");
			DynamicPlayerTextDrawSetString(i, HUD[i][8], string);
			
			format(string, sizeof(string), "%d%s", PlayerInfo[i][pThirst],"%");
			DynamicPlayerTextDrawSetString(i, HUD[i][11], string);

			format(string, sizeof(string), "ID:%d", i);
			DynamicPlayerTextDrawSetString(i, HUD[i][12], string);

			format(string, sizeof(string), "%i", PlayerInfo[i][pPhone]);
			DynamicPlayerTextDrawSetString(i, NumberTD22[i], string);
            if (PlayerInfo[i][pHelmet] != 0 && PlayerInfo[i][pHidehelmet] == 0) 
			{
				if (!IsPlayerAttachedObjectSlotUsed(i, 9)) 
				{
					SetPlayerAttachedObject(i, 9, 19141, 2, 0.103, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
				}
				ShowPlayerProgressBar(i, helmetbar);
				SetPlayerProgressBarValue(i, helmetbar, PlayerInfo[i][pHelmet]);
			} 
			else if (PlayerInfo[i][pHelmet] == 0) 
			{
				if (IsPlayerAttachedObjectSlotUsed(i, 9)) 
				{
					RemovePlayerAttachedObject(i, 9);
	
				}
				HidePlayerProgressBar(i, helmetbar);

			}


			if (PlayerInfo[i][pSpeedTime] > 0)
			{
			    PlayerInfo[i][pSpeedTime]--;
			}
		    if(PlayerInfo[i][pShipment] >= 0)
			{
				new vehicleid = GetPlayerVehicleID(i);
				if(!IsAFarmerCar(vehicleid) && GetPlayerState(i) != PLAYER_STATE_DRIVER)
				{
			    	PlayerInfo[i][pShipment] = -1;
			    	SendClientMessage(i, COLOR_SYNTAX, "Shipment cancelled. You went into another vehicle.");
				}
		    }

			else if (PlayerInfo[i][pGraffiti] != -1 && PlayerInfo[i][pGraffitiTime] > 0)
			{
				if (Graffiti_Nearest(i) != PlayerInfo[i][pGraffiti])
				{
				    PlayerInfo[i][pGraffiti] = -1;
            	    PlayerInfo[i][pGraffitiTime] = 0;
				}
				else
				{
	    	        PlayerInfo[i][pGraffitiTime]--;

		            if (PlayerInfo[i][pGraffitiTime] < 1)
					{
                        new str[500];
					    strunpack(str, PlayerInfo[i][pGraffitiText]);
	        	        format(GraffitiData[PlayerInfo[i][pGraffiti]][graffitiText], 64, str);

					    GraffitiData[PlayerInfo[i][pGraffiti]][graffitiColor] = PlayerInfo[i][pGraffitiColor];

						Graffiti_Refresh(PlayerInfo[i][pGraffiti]);
					    Graffiti_Save(PlayerInfo[i][pGraffiti]);

					    ClearAnimations(i, SYNC_ALL);
						SendProximityMessage(i, 30.0, SERVER_COLOR, "**{C2A2DA} %s puts their can of spray paint away.", GetRPName(i));

		   	            PlayerInfo[i][pGraffiti] = -1;
		   	            PlayerInfo[i][pGraffitiTime] = 0;
					}
				}
			}
		    if(!PlayerInfo[i][pToggleTextdraws])
		    {
			    if(PlayerInfo[i][pGPSOn])
				{
				    if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
					{
				        HideGPSTextdraw(i);
					}
				    else {
						new Float:rz;
						if(IsPlayerInAnyVehicle(i)) {
							GetVehicleZAngle(GetPlayerVehicleID(i), rz);
						}
						else {
							GetPlayerFacingAngle(i, rz);
						}
                        ShowGPSTextdraw(i);
						if(rz >= 348.75 || rz < 11.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "N");
						else if(rz >= 326.25 && rz < 348.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NE");
						else if(rz >= 303.75 && rz < 326.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NE");
						else if(rz >= 281.25 && rz < 303.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NE");
						else if(rz >= 258.75 && rz < 281.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "E");
						else if(rz >= 236.25 && rz < 258.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SE");
						else if(rz >= 213.75 && rz < 236.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SE");
						else if(rz >= 191.25 && rz < 213.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SE");
						else if(rz >= 168.75 && rz < 191.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "S");
						else if(rz >= 146.25 && rz < 168.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SW");
						else if(rz >= 123.25 && rz < 146.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SW");
						else if(rz >= 101.25 && rz < 123.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "SW");
						else if(rz >= 78.75 && rz < 101.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "W");
						else if(rz >= 56.25 && rz < 78.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NW");
						else if(rz >= 33.75 && rz < 56.25) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NW");
						else if(rz >= 11.5 && rz < 33.75) DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][1], "NW");
						DynamicPlayerTextDrawSetString(i, PlayerInfo[i][pText][0], GetPlayerZoneName(i));
					}
				}
				if(PlayerInfo[i][pWatchOn])
				{
					if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
						TextDrawHideForPlayer(i, TimeTD);
					else
					   TextDrawShowForPlayer(i, TimeTD);
				}
				if(!PlayerInfo[i][pToggleHUD] && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
				{
			        for(new j = 0; j < 24; j ++)
			        {
                       PlayerTextDrawHide(i, VALO[i][j]);
                    }
				}
			}

		    if(NetStats_PacketLossPercent(i) > 20.0 && gettime() - PlayerInfo[i][pLastDesync] > 120)
	        {
	            SendClientMessage(i, COLOR_REALRED, "** WARNING: You are desynced. You need to relog. NETWORK ISSUE!!");
	            PlayerInfo[i][pLastDesync] = gettime();
	        }

		    if(PlayerInfo[i][pSpectating] != INVALID_PLAYER_ID)
		    {
		        if(GetPlayerInterior(i) != GetPlayerInterior(PlayerInfo[i][pSpectating])) SetPlayerInterior(i, GetPlayerInterior(PlayerInfo[i][pSpectating]));
		        if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(PlayerInfo[i][pSpectating])) SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(PlayerInfo[i][pSpectating]));
		    }
		    if(PlayerInfo[i][pTutorial])
		    {
		        TogglePlayerControllable(i, 0);
		    }
			if(PlayerInfo[i][pAwaitingClothing])
			{
			    SetPlayerClothing(i);
			}
			if(PlayerInfo[i][pDraggedBy] != INVALID_PLAYER_ID)
			{
	    		TeleportToPlayer(i, PlayerInfo[i][pDraggedBy]);
			}
			if(PlayerInfo[i][pBuygun] == 2 && gettime() > PlayerInfo[i][pBGTime])
			{
			    PlayerInfo[i][pBuygun] = 0;
			    PlayerInfo[i][pBGTime] = 0;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET buygun = 0, bgtime = 0 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    if(PlayerInfo[i][pWeaponLicense])
			    {
			    	SendClientMessage(i, COLOR_GREEN, "You may now buy atleast 2 guns per day.");
			    }
			}
			if(PlayerInfo[i][pVIPPackage] > 0 && gettime() > PlayerInfo[i][pVIPTime])
			{
			    PlayerInfo[i][pVIPPackage] = 0;
			    PlayerInfo[i][pVIPTime] = 0;
			    PlayerInfo[i][pSecondJob] = -1;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = 0, viptime = 0, secondjob = -1 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessage(i, COLOR_LIGHTRED, "Your donator subscription has expired. You are no longer a VIP.");
			}
			if(PlayerInfo[i][pVIPPackage] < 1 && PlayerInfo[i][pSecondJob] != JOB_NONE)
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = -1 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    PlayerInfo[i][pSecondJob] = JOB_NONE;
			    SendClientMessage(i, COLOR_LIGHTRED, "Your second job has been removed as you don't have a Donator subscription.");
			}
			if(PlayerInfo[i][pFirstAid])
			{
				new
				    Float:health;

				GetPlayerHealth(i, health);

				if((health + 1.0) > 100.0)
				{
				    SetPlayerHealth(i, 100.0);
				    PlayerInfo[i][pFirstAid] = 0;
				}
				else
				{
				    SetPlayerHealth(i, health + 1.0);
				}
			}
			if(PlayerInfo[i][pTazedTime] > 0)
			{
			    PlayerInfo[i][pTazedTime]--;

			    if(!PlayerInfo[i][pTazedTime])
			    {
			        ClearAnimations(i, SYNC_ALL);
			        TogglePlayerControllable(i, 1);
			    }
			}
			if(PlayerInfo[i][pHurt] > 0)
			{
				PlayerInfo[i][pHurt]--;
			}
			if(PlayerInfo[i][pJailType] > 0)
			{
				if(PlayerInfo[i][pJailType] > 0)
				{
 					PlayerInfo[i][pJailTime]--;
				}
			    if(PlayerInfo[i][pJailTime] <= 0)
			    {
			        ResetPlayerWeaponsEx(i);

			        SendClientMessage(i, COLOR_GREY2, "Your jail sentence has expired.");
			        SetPlayerPos(i, 1544.4407, -1675.5522, 13.5584);
					SetPlayerFacingAngle(i, 90.0000);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
					SetCameraBehindPlayer(i);

					PlayerInfo[i][pJailType] = 0;
			        PlayerInfo[i][pJailTime] = 0;
				}
			}
			if(PlayerInfo[i][pHospital] && PlayerInfo[i][pHospitalTime])
			{
				PlayerInfo[i][pHospitalTime]--;

				if(PlayerInfo[i][pHospitalTime] == 0)
				{
                    new
					    Float:x,
					    Float:y,
					    Float:z,
						Float:a;

					GetPlayerPos(i, x, y, z);
					GetPlayerFacingAngle(i, a);
					SetFreezePos(i,x, y, z);
					SetPlayerFacingAngle(i, a);
					SetCameraBehindPlayer(i);

					if(!enabledpurge) {
						GivePlayerCash(i, -500);
						Dyuze(i, "Notice", "Discharged we deduct you $500.");
						if(PlayerInfo[i][pDelivered])
						{
							SendClientMessage(i, COLOR_DOCTOR, "You have been billed $500 for your stay. Your items is safed!");
							PlayerInfo[i][pDelivered] = 0;
						}
						else
						{
							SendClientMessage(i, COLOR_DOCTOR, "You have been billed $500 for your stay. Your illegal items have been confiscated by staff.");
							SendClientMessage(i, COLOR_LIGHTRED, "(( You have lost 30 minutes of your memory. ))");
						}
					} else SendClientMessage(i, COLOR_DOCTOR, "You have been discharged for free for the purge event. (( Type /purgeme to refill your weapons. ))");

					new hospital[32];
					switch(PlayerInfo[i][pHospitalType])
					{
					    case HOSPITAL_COUNTY: strcat(hospital, "Northern Hospital");
					    case HOSPITAL_ALLSAINTS: strcat(hospital, "All Saints Hospital");
					    case HOSPITAL_VIP: strcat(hospital, "County Gen");
					}

	

					SetPlayerHealth(i, PlayerInfo[i][pSpawnHealth]);
					SetScriptArmour(i, PlayerInfo[i][pSpawnArmor]);
					PlayerInfo[i][pHunger] = 50; // Hunger

					PlayerInfo[i][pHungerTimer] = 0;
					PlayerInfo[i][pThirst] = 100; // Thirst
					PlayerInfo[i][pThirstTimer] = 0;
					PlayerInfo[i][pDirtyCash] = 0;

					PlayerInfo[i][pHospital] = 0;
		            PlayerInfo[i][pHospitalTime] = 0;
		        }
			}
			if(PlayerInfo[i][pRefuel] != INVALID_VEHICLE_ID)
			{
			    PlayerInfo[i][pRefuelAmount] += 25;
			    vehicleFuel[PlayerInfo[i][pRefuel]]++;

			    if(vehicleFuel[PlayerInfo[i][pRefuel]] >= 100 || PlayerInfo[i][pCash] < PlayerInfo[i][pRefuelAmount] || GetVehicleParams(PlayerInfo[i][pRefuel], VEHICLE_ENGINE))
			    {
			        AddPointMoney(POINT_FUEL, PlayerInfo[i][pRefuelAmount]);
			        GivePlayerCash(i, -PlayerInfo[i][pRefuelAmount]);
			        SM(i, COLOR_GREEN, "You've refilled your vehicle's gas tank for "SVRCLR"$%i{CCFFFF}.", PlayerInfo[i][pRefuelAmount]);

			        PlayerInfo[i][pRefuel] = INVALID_VEHICLE_ID;
			        PlayerInfo[i][pRefuelAmount] = 0;
			    }
			}
			if(PlayerInfo[i][pOilExTime] > 0)
			{
			    PlayerInfo[i][pOilExTime]--;

			    if(PlayerInfo[i][pOilExTime] <= 0)
				{
					if(IsPlayerInOilExpoArea(i) && GetPlayerState(i) == PLAYER_STATE_ONFOOT && !PlayerInfo[i][pTazedTime] && !PlayerInfo[i][pCuffed])
				    {
				        SetPlayerAttachedObject(i, 9, 3632, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
						PlayerInfo[i][pOilEx] = 1;
					}
				}
			}
			if(PlayerInfo[i][pFruitExTime] > 0)
			{
			    PlayerInfo[i][pFruitExTime]--;

			    if(PlayerInfo[i][pFruitExTime] <= 0)
				{
					if(IsPlayerInFruitArea(i) && GetPlayerState(i) == PLAYER_STATE_ONFOOT && !PlayerInfo[i][pTazedTime] && !PlayerInfo[i][pCuffed])
				    {
				        SetPlayerSpecialAction(i, SPECIAL_ACTION_CARRY);
                        SetPlayerAttachedObject(i, 0, 19636, 1, -0.040999, 0.429000, 0.000000, 90.800018, 89.900009, -2.599999, 0.678000, 0.698000, 0.889999);
						PlayerInfo[i][pFruitEx] = 1;
					}
				}
			}
			if(PlayerInfo[i][pHarvestTime] > 0)
			{
			    PlayerInfo[i][pHarvestTime]--;

			    if(PlayerInfo[i][pHarvestTime] <= 0)
				{
					if(IsPlayerInHarvestArea(i) && GetPlayerState(i) == PLAYER_STATE_ONFOOT && !PlayerInfo[i][pTazedTime] && !PlayerInfo[i][pCuffed])
				    {
				        SetPlayerAttachedObject(i, 9, 1453, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
						SetPlayerSpecialAction(i, SPECIAL_ACTION_CARRY);
						ApplyAnimationEx(i, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
						PlayerInfo[i][pWheat] = 1;
					}
				}
			}
			if(PlayerInfo[i][pMuted] > 0)
			{
			    PlayerInfo[i][pMuted]--;

			    if(PlayerInfo[i][pMuted] <= 0)
			    {
			        SendClientMessage(i, SERVER_COLOR, "**"WHITE" You are no longer muted.");
				}
			}
			if(PlayerInfo[i][pSpamTime] > 0)
			{
			    PlayerInfo[i][pSpamTime]--;
			}
			if(PlayerInfo[i][pVehicleCount] > 0)
			{
			    PlayerInfo[i][pVehicleCount]--;
			}
			if(PlayerInfo[i][pMechanicCall] > 0)
			{
			    PlayerInfo[i][pMechanicCall]--;
			}
			if(PlayerInfo[i][pEmergencyCall] > 0)
			{
			    PlayerInfo[i][pEmergencyCall]--;
			}
			if(PlayerInfo[i][pCourierCooldown] > 0)
			{
			    PlayerInfo[i][pCourierCooldown]--;
			}
			if(PlayerInfo[i][pRareTime] > 0)
			{
		    	PlayerInfo[i][pRareTime]--;
			}
			if(PlayerInfo[i][pVipTimes] > 0)
			{
		    	PlayerInfo[i][pVipTimes]--;
			}
   			if(PlayerInfo[i][pDeathCooldown] > 0)
			{
       	    	PlayerInfo[i][pDeathCooldown]--;
			}
			if(PlayerInfo[i][pRevCooldown] > 0)
			{
       	    	PlayerInfo[i][pRevCooldown]--;
			}
			if(PlayerInfo[i][pInjured])
			{
			    if(PlayerInfo[i][pDeathCooldown] == 0)
			    {
                   DamagePlayer(i, 300, i, WEAPON_EXPLOSION, BODY_PART_UNKNOWN, false);
                   
			    }
			}
			if(PlayerInfo[i][pDetectiveCooldown] > 0)
			{
       			PlayerInfo[i][pDetectiveCooldown]--;
			}
			if(PlayerInfo[i][pLootTime] > 0)
			{
			    PlayerInfo[i][pLootTime]--;

			    if(IsPlayerInBankRobbery(i) && PlayerInfo[i][pLootTime] <= 0)
			    {
			        new amount = random(50000) + 10000;

			        ClearAnimations(i, SYNC_ALL);

			        PlayerInfo[i][pRobCash] += amount;
			        PlayerInfo[i][pCP] = CHECKPOINT_ROBBERY;
			        PlayerInfo[i][pLastLoad] = gettime();

					format(string, sizeof(string), "~g~+$%i", amount);
					GameTextForPlayer(i, string, 5000, 1);

			        SM(i, COLOR_GREEN, "You have looted $%i and now have $%i. You can keep looting or deliver the cash to the "SVRCLR"marker{CCFFFF}.", amount, PlayerInfo[i][pRobCash]);
					SetPlayerCheckpoint(i, 1462.0673, -1021.0866, 24.0908, 3.0);
			    }
				else if((PlayerInfo[i][pRobbingBiz] >= 0 && PlayerInfo[i][pRobbingBiz] == GetInsideBusiness(i)) && PlayerInfo[i][pLootTime] <= 0)
			    {
					if(PlayerInfo[i][pRobCash] >= BusinessInfo[PlayerInfo[i][pRobbingBiz]][bCash])
					{
						SendClientMessage(i, COLOR_GREY2, "Your pockets can't hold anymore!");
						PlayerInfo[i][pLootTime] = 0;
					} else {
						PlayerInfo[i][pLootTime] = 5;
						Dyuze(i, "Notice", "Looting business vault...");
					}

			        new amount = random(25000) + 25000;

			        //ClearAnimations(i, 1);

			        PlayerInfo[i][pRobCash] += amount;
			        PlayerInfo[i][pCP] = CHECKPOINT_ROBBERYBIZ;
			        PlayerInfo[i][pLastLoad] = gettime();

					format(string, sizeof(string), "~g~+P%i", amount);
					GameTextForPlayer(i, string, 5000, 1);

			        SM(i, COLOR_GREEN, "You have looted P%i and now have P%i. You can keep looting or deliver the cash to the "SVRCLR"marker{CCFFFF}.", amount, PlayerInfo[i][pRobCash]);
					SetPlayerCheckpoint(i, BusinessInfo[PlayerInfo[i][pRobbingBiz]][bPosX], BusinessInfo[PlayerInfo[i][pRobbingBiz]][bPosY], BusinessInfo[PlayerInfo[i][pRobbingBiz]][bPosZ], 3.0);
			    }
				else if((PlayerInfo[i][pRobbingHouse] >= 0 && PlayerInfo[i][pRobbingHouse] == GetInsideHouse(i)) && PlayerInfo[i][pLootTime] <= 0)
			    {
					if(PlayerInfo[i][pRobCash] >= HouseInfo[PlayerInfo[i][pRobbingHouse]][hCash])
					{
						SendClientMessage(i, COLOR_GREY2, "Your pockets can't hold anymore!");
						PlayerInfo[i][pLootTime] = 0;
					} else {
						PlayerInfo[i][pLootTime] = 5;
						Dyuze(i, "Notice", "Looting house vault...");
					}

			        new amount = random(5000) + 20000;

			        //ClearAnimations(i, 1);

			        PlayerInfo[i][pRobCash] += amount;
			        PlayerInfo[i][pCP] = CHECKPOINT_ROBBERYHOUSE;
			        PlayerInfo[i][pLastLoad] = gettime();

					format(string, sizeof(string), "~g~+P%i", amount);
					GameTextForPlayer(i, string, 5000, 1);

			        SM(i, COLOR_GREEN, "You have looted P%i and now have P%i. You can keep looting or deliver the cash to the "SVRCLR"marker{CCFFFF}.", amount, PlayerInfo[i][pRobCash]);
					SetPlayerCheckpoint(i, HouseInfo[PlayerInfo[i][pRobbingHouse]][hPosX], HouseInfo[PlayerInfo[i][pRobbingHouse]][hPosY], HouseInfo[PlayerInfo[i][pRobbingHouse]][hPosZ], 3.0);
			    }
			}
			if(PlayerInfo[i][pFindTime] > 0)
			{
			    PlayerInfo[i][pFindTime]--;

			    if(PlayerInfo[i][pFindTime] == 0)
			    {
			        SetPlayerMarkerForPlayer(i, PlayerInfo[i][pFindPlayer], GetPlayerColor(PlayerInfo[i][pFindPlayer]));
					PlayerInfo[i][pFindPlayer] = INVALID_PLAYER_ID;
				}
			}
			if((PlayerInfo[i][pToggleMusic]) || (PlayerInfo[i][pBoomboxListen] != INVALID_PLAYER_ID && GetNearbyBoombox(i) != PlayerInfo[i][pBoomboxListen]))
			{
				PlayerInfo[i][pBoomboxListen] = INVALID_PLAYER_ID;

				if(PlayerInfo[i][pStreamType] == MUSIC_BOOMBOX)
				{
				    StopAudioStreamForPlayer(i);
				    PlayerInfo[i][pStreamType] = MUSIC_NONE;
				}
			}
			if((!PlayerInfo[i][pToggleMusic]) && ((boomboxid = GetNearbyBoombox(i)) != INVALID_PLAYER_ID && PlayerInfo[i][pBoomboxListen] != boomboxid))
			{
			    PlayerInfo[i][pBoomboxListen] = boomboxid;

			    if(PlayerInfo[i][pStreamType] == MUSIC_NONE)
			    {
			        PlayAudioStreamForPlayer(i, PlayerInfo[boomboxid][pBoomboxURL]);
			        PlayerInfo[i][pStreamType] = MUSIC_BOOMBOX;
			    }
			}

            if(PlayerInfo[i][pPickPlant] != INVALID_PLAYER_ID)
            {
                PlayerInfo[i][pPickTime]--;

                if(PlayerInfo[i][pPickTime] <= 0)
                {
                    new planterid = PlayerInfo[i][pPickPlant];

                    if(!IsPlayerConnected(planterid) || !PlayerInfo[planterid][pLogged] || !PlayerInfo[planterid][pPotPlanted])
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "This plant is no longer available to pick.");
					}
					else if(!IsPlayerInRangeOfPoint(i, 3.0, PlayerInfo[planterid][pPotX], PlayerInfo[planterid][pPotY], PlayerInfo[planterid][pPotZ]))
					{
					    SendClientMessage(i, COLOR_SYNTAX, "Picking failed. You left the area of the plant.");
					}
					else if(GetPlayerSpecialAction(i) != SPECIAL_ACTION_DUCK)
					{
					    SendClientMessage(i, COLOR_SYNTAX, "Picking failed. You must stay crouched when picking a plant.");
					}
					else
					{
					    PlayerInfo[i][pPot] += PlayerInfo[planterid][pPotGrams];

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[i][pPot], PlayerInfo[i][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SM(i, COLOR_GREEN, "You have harvested %i grams of pot from this plant.", PlayerInfo[planterid][pPotGrams]);
					    DestroyPotPlant(planterid);
					}

					PlayerInfo[i][pPickPlant] = INVALID_PLAYER_ID;
					PlayerInfo[i][pPickTime] = 0;
				}
			}
            if(PlayerInfo[i][pDrugsUsed] >= 2)
			{
			    PlayerInfo[i][pDrugsTime]--;

			    if(PlayerInfo[i][pDrugsTime] <= 0)
			    {
			        SendClientMessage(i, SERVER_COLOR, "**"WHITE" You are no longer stoned.");
			        SetPlayerWeather(i, gWeather);

					SetPlayerTime(i, gWorldTime, 0);

			        PlayerInfo[i][pDrugsUsed] = 0;
			        PlayerInfo[i][pDrugsTime] = 0;
			    }
			    else
			    {
			        SetPlayerWeather(i, -66);
			        SetPlayerTime(i, 12, 0);
				}
			}
			if(PlayerInfo[i][pPoisonTime] > 0)
			{
			    new
			        Float:health;
			    GetPlayerHealth(i, health);
			    SetPlayerHealth(i, health - 3.0 < 1.0 ? 1.0 : health - 3.0);
			    PlayerInfo[i][pPoisonTime]--;
			}

			AnticheatCheck(i);

			//GetPlayerHealth(i, PlayerInfo[i][pHealth]);

			if(PlayerInfo[i][pGang] >= 0 && !PlayerInfo[i][pBandana])
			{
				new id, gang = PlayerInfo[i][pGang], color;
				if(GangInfo[gang][gColor] == -1 || GangInfo[gang][gColor] == -256)
				{
					color = 0xC8C8C8FF;
				}
				else
				{
					color = GangInfo[gang][gColor];
				}
				if((id = GetNearbyTurf(i)) >= 0 && TurfInfo[id][tTime] == 0 && TurfInfo[id][tCapturer] != INVALID_PLAYER_ID)
				{
					format(string, sizeof(string), "{%06x}%s\n"WHITE"%s", color >>> 8, GangInfo[gang][gName],GangRanks[gang][PlayerInfo[i][pGangRank]]);
					UpdateDynamic3DTextLabelText(PlayerLabel[i], COLOR_WHITE, string);
					PlayerInfo[i][pBandana] = 1;
					SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you entered a turf in an active war.");
				}
				if((id = GetNearbyPoints2(i)) >= 0 && PointInfo[id][pTime] == 0 && PointInfo[id][pCapturer] != INVALID_PLAYER_ID)
				{
					format(string, sizeof(string), "{%06x}%s\n"WHITE"%s", color >>> 8, GangInfo[gang][gName],GangRanks[gang][PlayerInfo[i][pGangRank]]);
					UpdateDynamic3DTextLabelText(PlayerLabel[i], COLOR_WHITE, string);
					PlayerInfo[i][pBandana] = 1;
					SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you are in range of an active point.");
				}
			}
			if(!PlayerInfo[i][pBackup] && !IsPlayerBeingFound(i))
			{
				// Nametag colors gang colors bandana badge
				if(PlayerInfo[i][pJoinedEvent] && EventInfo[eType] == 2)
				{
				    SetPlayerColor(i, (PlayerInfo[i][pEventTeam] == RED_TEAM) ? (0xFF000000) : (0x0000FF00));
				}
				else if(PlayerInfo[i][pPaintball] == 2)
				{
				    SetPlayerColor(i, (PlayerInfo[i][pPaintballTeam] == 1) ? (0x33CCFF00) : (0xFFFF9900));
				}
				else if(PlayerInfo[i][pJailTime] > 0)
				{
				    SetPlayerColor(i, 0xF4A41900);
				}
				else if(PlayerInfo[i][pFaction] >= 0 && PlayerInfo[i][pDuty] && FactionInfo[PlayerInfo[i][pFaction]][fType] != FACTION_HITMAN)
				{
					SetPlayerColor(i, FactionInfo[PlayerInfo[i][pFaction]][fColor] & ~0xff);
				}
				else if(PlayerInfo[i][pGang] >= 0 && PlayerInfo[i][pBandana])
				{
				    SetPlayerColor(i, GangInfo[PlayerInfo[i][pGang]][gColor] & ~0xff);
				}
				else if(PlayerInfo[i][pVIPPackage] > 0 && PlayerInfo[i][pVIPColor])
				{
				    SetPlayerColor(i, 0xC2A2DA00);
				}
				else if(PlayerInfo[i][pMask] && MaskaraID[i])
				{
					SetPlayerSpecialTag(i, TAG_MASK);
				}
				else
				{
				    SetPlayerColor(i, 0xFFFFFF00);
				}
			}
		}
	}
    for(new i = 0; i < MAX_TURFS; i ++)
	{
		if(TurfInfo[i][tExists])
		{
			if(TurfInfo[i][tType] == 11 && TurfInfo[i][tTime] == 0)
			{
				if(TurfInfo[i][tInfluenceTime] > 0)
				{
					TurfInfo[i][tInfluenceTime]--;
					new gcount = 0, ncount = 0;
					foreach (new g : Player)
					{
						if(i == GetNearbyTurf(g))
						{
							if(TurfInfo[i][tInfluenceGang] == PlayerInfo[g][pGang]  && !PlayerInfo[g][pAdmin])
							{
								gcount++;
							}
							else if(PlayerInfo[g][pGang] != -1 && !PlayerInfo[g][pAdmin])
							{
								ncount++;
							}
						}
					}
					if(TurfInfo[i][tInfluence] == 0 && ncount != 0)
					{
						TurfInfo[i][tInfluenceGang] = InfluencingGangInTurf(i);
						TurfInfo[i][tInfluence]++;
					}
					else if(ncount > gcount)
					{
					    if(TurfInfo[i][tInfluence] != 0)
						TurfInfo[i][tInfluence]--;
					}
					else if(gcount > ncount)
					{
				     	if(TurfInfo[i][tInfluence] != 100)
						TurfInfo[i][tInfluence]++;
					}
					UpdateTurfTD(i);
					if(TurfInfo[i][tInfluenceTime] == 0 && (TurfInfo[i][tInfluenceGang] != -1 && TurfInfo[i][tInfluence] == 100))
					{
						EndInfluenceWar(i);
					}
				}
			}
		}
	}
	if((gGMX) && mysql_unprocessed_queries(connectionID) == 0)
	{
	    SendRconCommand("gmx");
        //SendRconCommand("reloadfs propamap");
		//SendRconCommand("reloadfs propawound");
	}

	foreach(new i : Actor)
	{
	    if(IsValidActor(i))
	    {
	        new
	            Float:x,
	            Float:y,
	            Float:z;
	        GetActorPos(i, x, y, z);
	        SetActorPos(i, x, y, z);
	    }
	}
	format(string, sizeof(string), "Marijuana Seeds\n"WHITE"Stock: %i\nPrice: $5/seed\n/getdrug seeds [amount]", gSeedsStock);
	UpdateDynamic3DTextLabelText(gSeedsStockText, COLOR_YELLOW, string);

	if(Iter_Count(Player) > gPlayerRecord)
	{
		gPlayerRecord = Iter_Count(Player);
		gRecordDate = GetDate();
		SaveServerInfo();
	}
}
forward UpdateTurfTD(turfid);
public UpdateTurfTD(turfid)
{
	new string[1024];

	foreach (new i : Player)
	{
		if(turfid == GetNearbyTurf(i))
  		{
  		    HideTurfTD(i);
            format(string, sizeof(string), "TIME: %s", FormatTime(TurfInfo[turfid][tInfluenceTime]));
            DynamicPlayerTextDrawSetString(i, TurfTD[i][1], string);
  		    if(TurfInfo[turfid][tInfluenceGang] != -1)
  		    {
	            format(string, sizeof(string), "CONTROL: %s", GangInfo[TurfInfo[turfid][tInfluenceGang]][gName]);
	            DynamicPlayerTextDrawSetString(i, TurfTD[i][0], string);
	            PlayerTextDrawColour(i, TurfTD[i][0], (GangInfo[TurfInfo[turfid][tInfluenceGang]][gColor] & ~0xff) + 0xFF);
			}
			else
			{
                format(string, sizeof(string), "CONTROL: POLICE");
	            DynamicPlayerTextDrawSetString(i, TurfTD[i][0], string);
	            PlayerTextDrawColour(i, TurfTD[i][0], (COLOR_BLUE & ~0xff) + 0xFF);
			}
			format(string, sizeof(string), "INFLUENCE: %i%", TurfInfo[turfid][tInfluence]);
            DynamicPlayerTextDrawSetString(i, TurfTD[i][2], string);
            ShowTurfTD(i);
  		}
	}
}

forward EndInfluenceWar(turfid);
public EndInfluenceWar(turfid)
{
    foreach (new i : Player)
	{
	    HideTurfTD(i);
	}
	if(TurfInfo[turfid][tInfluenceGang] != -1)
	{
	    SMA(COLOR_GREEN, "{%06x}%s has successfully Influenced the %s Turf.", GangInfo[TurfInfo[turfid][tInfluenceGang]][gColor] >>> 8, GangInfo[TurfInfo[turfid][tInfluenceGang]][gName], TurfInfo[turfid][tName]);
		SendGangMessage(TurfInfo[turfid][tInfluenceGang], COLOR_YELLOW, "Your gang has successfully Influenced the %s Turf.", TurfInfo[turfid][tName]);
		TurfInfo[turfid][tCapturedGang] = TurfInfo[turfid][tInfluenceGang];
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedgang = %i, time = 12 WHERE id = %i", TurfInfo[turfid][tCapturedGang], turfid);
  		mysql_tquery(connectionID, queryBuffer);
  		TurfInfo[turfid][tTime] = 12;
  		TurfInfo[turfid][tInfluenceTime]  = 0;
		TurfInfo[turfid][tInfluence]  = 0;
		TurfInfo[turfid][tInfluenceGang]  = TurfInfo[turfid][tCapturedGang];
	}
	else
	{
	    SMA(COLOR_GREEN, "No Gang Influenced the %s Turf, So it was Influence as Civilian Turf.", TurfInfo[turfid][tName]);
	}
	ReloadTurf(turfid);
}

//[RENT SYSTEM BY NAJU -- SECT DESPAWNED VEH]//
forward RentDecrement();
public RentDecrement()
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "SELECT id , renttime, modelid FROM vehicles WHERE rent = 1");
    mysql_tquery(connectionID, queryBuffer, "OnFetchRentedVehicles");
}

forward OnFetchRentedVehicles();
public OnFetchRentedVehicles()
{
    new vehicleID, renttime, modelid;
    new rows = SQL_GetRows();

    for (new i = 0; i < rows; i++) 
    {
        vehicleID = SQL_GetInt(i, "id"); 
		renttime = SQL_GetInt(i, "renttime"); 
		modelid = SQL_GetInt(i, "modelid"); 
		
        if (GetVehicleLinkedID(vehicleID) == INVALID_VEHICLE_ID)
        {
			if(renttime <= 1 && modelid != 508){
				new dc_str[454];
				format(dc_str, sizeof(dc_str), "Vehicle Recredited to account modelid = %i", modelid);
				SendDiscordMessage(16, dc_str);
			}
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "UPDATE vehicles SET renttime = GREATEST(renttime - 1, 0), rent = IF(renttime - 1 <= 0, 0, rent), ownerid = IF(renttime - 1 <= 0, ogowner, ownerid) WHERE id = %i AND rent = 1", vehicleID);
            mysql_tquery(connectionID, queryBuffer);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "DELETE FROM vehicles WHERE id = %i AND rent = 1 AND renttime <= 0 AND modelid = 508", vehicleID);
            mysql_tquery(connectionID, queryBuffer);
        }
		else
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "DELETE FROM vehicles WHERE id = %i AND rent = 1 AND renttime <= 0 AND modelid = 508", vehicleID);
            mysql_tquery(connectionID, queryBuffer);
		}
		
    }
}

forward MinuteTimer();
public MinuteTimer()
{
	new hour;
	gettime(.hour = hour);
	RefreshTime();	
    RentDecrement();
	//[RENT SYSTEM BY NAJU -- SECT SPAWNED VEH]//
  
	foreach(new vehicleid : Vehicle)
	{
		if(VehicleInfo[vehicleid][vRent] == 1 && vehicleid != INVALID_VEHICLE_ID)
		{
			if(VehicleInfo[vehicleid][vRenttime] > 0)
			{
				VehicleInfo[vehicleid][vRenttime]--;
			}
			if(VehicleInfo[vehicleid][vRenttime] <= 0 && VehicleInfo[vehicleid][vRent] == 1)
			{
				if(VehicleInfo[vehicleid][vOgowner] > 0 && VehicleInfo[vehicleid][vOgowner] != VehicleInfo[vehicleid][vOwnerID]) 
				{
					
					new playerid = GetPlayerLinkedID(VehicleInfo[vehicleid][vOwnerID]);
					if(playerid != INVALID_PLAYER_ID)
					   SendClientMessage(playerid, COLOR_RED, "{ffffff}[{2dff99}A{ffffff}K{2dff99}RP{ffffff}] Your Vehicle Rent Over! Returned To Owner");
					VehicleInfo[vehicleid][vOwnerID] = VehicleInfo[vehicleid][vOgowner];
					VehicleInfo[vehicleid][vRent] = 0;
					VehicleInfo[vehicleid][vOgowner] = 0;
					
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET ogowner = 0, ownerid = %i, rent = 0 WHERE id = %i",VehicleInfo[vehicleid][vOwnerID],VehicleInfo[vehicleid][vID]);
					mysql_tquery(connectionID, queryBuffer);


					DespawnVehicle(vehicleid, true);

				}
			}
		}
	}
    
	if(RobberyInfo[rTime] > 0)
	{
		RobberyInfo[rTime]--;
	}
	if (OtherRobberyInfo[rCarTime] > 0)
	{
		OtherRobberyInfo[rCarTime] --;
		if (OtherRobberyInfo[rCarTime] == 0)
		{
			RestartCarRob();
		}
	}
	if (OtherRobberyInfo[rHousetime] > 0)
	{
		OtherRobberyInfo[rHousetime] --;
	}
	if (OtherRobberyInfo[rStoreTime] > 0)
	{
		OtherRobberyInfo[rStoreTime] --;
	}
   
	if(gHour != hour)
	{
	    SMA(COLOR_WHITE, "The server time is now: %02d:00.", hour);
    	foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
	        {
		        if(PlayerInfo[i][pAFK] && PlayerInfo[i][pAFKTime] > 900)
		        {
		            SendClientMessage(i, COLOR_LIGHTRED, "You didn't receive a paycheck this hour as you were AFK for more than 15 minutes.");
		        }
		        else if(PlayerInfo[i][pMinutes] < 30)
		        {
		            SendClientMessage(i, COLOR_LIGHTRED, "You are ineligible for a paycheck as you played less than 30 minutes this hour.");
		        }
		        else
		        {
					Dyuze(i, "Payday", "Automatic Signcheck.");
					SendPaycheck(i);
				}
				if(PlayerInfo[i][pReportMuted])
				{
					PlayerInfo[i][pReportMuted]--;

					if(PlayerInfo[i][pReportMuted] <= 0)
					{
					    PlayerInfo[i][pReportMuted] = 0;
					    PlayerInfo[i][pReportWarns] = 0;

					    SendClientMessage(i, COLOR_YELLOW, "Your report mute has automatically been lifted.");
				    }
				}
			}
	    }

	    for(new i = 0; i < MAX_POINTS; i ++)
	    {
	        if(PointInfo[i][pExists])
	        {
	            if(PointInfo[i][pTime] > 0)
	            {
	                PointInfo[i][pTime]--;
	                ReloadPoint(i);
				}

				if(!PointInfo[i][pTime])
				{
				    SMA(COLOR_GREEN, "%s is now available to capture.", PointInfo[i][pName]);
				    PointInfo[i][pCapturedGang] = -1;
	            }

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET time = %i, capturedgang = %i WHERE id = %i", PointInfo[i][pTime], PointInfo[i][pCapturedGang], i);
             	mysql_tquery(connectionID, queryBuffer);
	        }
		}

		for(new i = 0; i < MAX_TURFS; i ++)
	    {
	        if(TurfInfo[i][tExists])
	        {
	            if(TurfInfo[i][tTime] > 0)
	            {
	                TurfInfo[i][tTime]--;
	                ReloadTurf(i);
				}

				if(!TurfInfo[i][tTime] && TurfInfo[i][tType] != 8)
				{
				    SendTurfMessage(i, COLOR_GREEN, "%s is now available to capture.", TurfInfo[i][tName]);
	            }

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET time = %i WHERE id = %i", TurfInfo[i][tTime], i);
             	mysql_tquery(connectionID, queryBuffer);
	        }
		}

		switch(hour)
		{
		    case 0, 6, 12, 18:
		    {
		        for(new i = 0; i < MAX_GANGS; i ++)
		        {
		            if(GangInfo[i][gSetup] && GangInfo[i][gTurfTokens] < 20)
		            {
		                GangInfo[i][gTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }

		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_POLICE && FactionInfo[i][fTurfTokens] < 10)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_NPOLICE && FactionInfo[i][fTurfTokens] < 10)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_FEDERAL && FactionInfo[i][fTurfTokens] < 10)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_ARMY && FactionInfo[i][fTurfTokens] < 10)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
			}
		}

		

		for(new i = 0; i < MAX_BUSINESSES; i ++)
		{
			if(BusinessInfo[i][bRobbed] > 0)
			{
				BusinessInfo[i][bRobbed]--;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET robbed = %i WHERE id = %i", BusinessInfo[i][bRobbed], BusinessInfo[i][bID]);
				mysql_tquery(connectionID, queryBuffer);

			}
		}
		for(new i = 0; i < MAX_HOUSES; i ++)
		{
			if(HouseInfo[i][hRobbed] > 0)
			{
				HouseInfo[i][hRobbed]--;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET robbed = %i WHERE id = %i", HouseInfo[i][hRobbed], HouseInfo[i][hID]);
				mysql_tquery(connectionID, queryBuffer);

			}
		}

	    SetWorldTime(hour);

		gWorldTime = hour;
	    gHour = hour;

	    //gCharityHealth = 0;
	    //gCharityArmor = 0;
	}
	else
	{
	    foreach(new i : Player)
		{
		    if(PlayerInfo[i][pPotPlanted] && PlayerInfo[i][pPotTime] > 0)
		    {
		        PlayerInfo[i][pPotTime]--;

		        if((PlayerInfo[i][pPotTime] % 2) == 0)
		        {
		            PlayerInfo[i][pPotGrams]++;
		        }
		    }
		    if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAFKTime] < 900)
		    {
				//new amount = 35 * min(PlayerInfo[i][pLevel], 21);
		        //AddToPaycheck(i, amount);

		        PlayerInfo[i][pMinutes]++;
			}
		}

		for(new i = 0; i < MAX_POINTS; i ++)
	    {
	        if(PointInfo[i][pExists] && PointInfo[i][pCapturer] != INVALID_PLAYER_ID && PointInfo[i][pCaptureTime] > 0)
	        {
	            if(PlayerInfo[PointInfo[i][pCapturer]][pGang] == -1)// || PlayerInfo[PointInfo[i][pCapturer]][pGangRank] < 5)
	            {
	                PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
	                PointInfo[i][pCaptureTime] = 0;
	            }
	            else
	            {
		            PointInfo[i][pCaptureTime]--;

		            if(PointInfo[i][pCaptureTime] <= 0)
		            {
		                GiveGangPoints(PlayerInfo[PointInfo[i][pCapturer]][pGang], 50);

		                GetPlayerName(PointInfo[i][pCapturer], PointInfo[i][pCapturedBy], MAX_PLAYER_NAME);
					    PointInfo[i][pCapturedGang] = PlayerInfo[PointInfo[i][pCapturer]][pGang];

						GangInfo[PointInfo[i][pCapturedGang]][gCash] += PointInfo[i][pProfits];
						SMA(COLOR_GREEN, "{%06x}%s has successfully captured %s for %s.", GangInfo[PointInfo[i][pCapturedGang]][gColor] >>> 8, GetRPName(PointInfo[i][pCapturer]), PointInfo[i][pName], GangInfo[PointInfo[i][pCapturedGang]][gName]);
						SendGangMessage(PointInfo[i][pCapturedGang], COLOR_YELLOW, "Your gang has earned $%i and 50 GP for successfully capturing this point.", PointInfo[i][pProfits]);

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PointInfo[i][pCapturedGang]][gCash], PointInfo[i][pCapturedGang]);
					    mysql_tquery(connectionID, queryBuffer);

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedby = '%s', capturedgang = %i, profits = 0, time = 20 WHERE id = %i", PointInfo[i][pCapturedBy], PointInfo[i][pCapturedGang], i);
					    mysql_tquery(connectionID, queryBuffer);

	                    PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
		                PointInfo[i][pCaptureTime] = 0;
		                PointInfo[i][pProfits] = 0;
		                PointInfo[i][pTime] = 20;

		                ReloadPoint(i);
					}
				}
			}
		}

		for(new i = 0; i < MAX_TURFS; i ++)
	    {
	        if(TurfInfo[i][tExists] && TurfInfo[i][tCapturer] != INVALID_PLAYER_ID && TurfInfo[i][tCaptureTime] > 0)
	        {
	            if(!IsLawEnforcement(TurfInfo[i][tCapturer]) && (PlayerInfo[TurfInfo[i][tCapturer]][pGang] == -1))// || PlayerInfo[TurfInfo[i][tCapturer]][pGangRank] < 5))
	            {
	                TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
	                TurfInfo[i][tCaptureTime] = 0;
	                ReloadTurf(i);
	            }
	            else
	            {
		            TurfInfo[i][tCaptureTime]--;

              		if(TurfInfo[i][tCaptureTime] <= 0)
		            {
		                GetPlayerName(TurfInfo[i][tCapturer], TurfInfo[i][tCapturedBy], MAX_PLAYER_NAME);

		                if(IsLawEnforcement(TurfInfo[i][tCapturer]))
		                {
		                    TurfInfo[i][tCapturedGang] = -1;
							SMA(COLOR_GREEN, "%s has been successfully claimed back as a civilian turf by Officer %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]));
						}
						else
						{
						    new gangid = PlayerInfo[TurfInfo[i][tCapturer]][pGang];

						    TurfInfo[i][tCapturedGang] = gangid;

						    GiveGangPoints(gangid, 25);
						    SMA(COLOR_GREEN, "%s has been successfully claimed by %s for %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]), GangInfo[gangid][gName]);

							switch(TurfInfo[i][tType])
							{
							    case 1:
							    {
							        GangInfo[gangid][gHPAmmo] = GangInfo[gangid][gHPAmmo] + 80 > GetGangStashCapacity(gangid, STASH_CAPACITY_HPAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_HPAMMO) : GangInfo[gangid][gHPAmmo] + 80;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 80 rounds of hollow point ammo in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET hpammo = %i WHERE id = %i", GangInfo[gangid][gHPAmmo], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 2:
							    {
							        GangInfo[gangid][gPoisonAmmo] = GangInfo[gangid][gPoisonAmmo] + 60 > GetGangStashCapacity(gangid, STASH_CAPACITY_POISONAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_POISONAMMO) : GangInfo[gangid][gPoisonAmmo] + 60;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 60 rounds of poison tip ammo in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET poisonammo = %i WHERE id = %i", GangInfo[gangid][gPoisonAmmo], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 3:
							    {
							        GangInfo[gangid][gFMJAmmo] = GangInfo[gangid][gFMJAmmo] + 30 > GetGangStashCapacity(gangid, STASH_CAPACITY_FMJAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_FMJAMMO) : GangInfo[gangid][gFMJAmmo] + 30;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 30 rounds of full metal jacket ammo in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET fmjammo = %i WHERE id = %i", GangInfo[gangid][gFMJAmmo], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
							    case 4:
							    {
							        new amount = 20000;
							        GangInfo[gangid][gMaterials] = GangInfo[gangid][gMaterials] + amount > GetGangStashCapacity(gangid, STASH_CAPACITY_MATERIALS) ? GetGangStashCapacity(gangid, STASH_CAPACITY_MATERIALS) : GangInfo[gangid][gMaterials] + 20000;
									SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %i materials in the stash for capturing this turf!", amount);

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 5:
							    {
							        GangInfo[gangid][gPot] = GangInfo[gangid][gPot] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_WEED) ? GetGangStashCapacity(gangid, STASH_CAPACITY_WEED) : GangInfo[gangid][gPot] + 100;
							        GangInfo[gangid][gMeth] = GangInfo[gangid][gMeth] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_METH) ? GetGangStashCapacity(gangid, STASH_CAPACITY_METH) : GangInfo[gangid][gMeth] + 100;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 100 grams of pot & 100 grams crack in the stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET pot = %i, meth = %i WHERE id = %i", GangInfo[gangid][gPot], GangInfo[gangid][gMeth], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 6:
							    {
							        GangInfo[gangid][gCrack] = GangInfo[gangid][gCrack] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE) ? GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE) : GangInfo[gangid][gCrack] + 100;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 100 grams of Crack in the stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET crack = %i WHERE id = %i", GangInfo[gangid][gCrack], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 7:
								{
									GangInfo[PointInfo[gangid][pCapturedGang]][gCash] += 100000;

								    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PointInfo[gangid][pCapturedGang]][gCash], PointInfo[gangid][pCapturedGang]);
								    mysql_tquery(connectionID, queryBuffer);
								    SendGangMessage(gangid, COLOR_YELLOW, "Your gang will now receive 10 percents of all sales in this turf.");
							    }
							    case 8:
							    {
                                    GangInfo[gangid][gWeapons][GANGWEAPON_9MM] += 5;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] += 3;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_UZI] += 4;

							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned 9mm(5), Rifle(3), and UZI(4) in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_9mm = %i, weapon_rifle = %i, weapon_uzi = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_9MM], GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE], GangInfo[gangid][gWeapons][GANGWEAPON_UZI], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 9:
			    				{
                                    GangInfo[gangid][gWeapons][GANGWEAPON_MP5] += 5;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] += 4;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] += 3;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned MP5(5), Tec9(4), and Shotgun(3) in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_mp5 = %i, weapon_tec9 = %i, weapon_shotgun = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_MP5], GangInfo[gangid][gWeapons][GANGWEAPON_TEC9], GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
								case 10:
								{
                                    GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] += 4;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_AK47] += 3;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_M4] += 3;
                                    GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER] += 2;
							        SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned Deagle(4), AK-47(3), M4(3) and SNIPER(2) in its stash for capturing this turf!");

							        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_deagle = %i, weapon_ak47 = %i, weapon_m4 = %i, weapon_sniper = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE], GangInfo[gangid][gWeapons][GANGWEAPON_AK47], GangInfo[gangid][gWeapons][GANGWEAPON_M4], GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER], gangid);
							        mysql_tquery(connectionID, queryBuffer);
								}
							}
						}

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedby = '%s', capturedgang = %i, time = 12 WHERE id = %i", TurfInfo[i][tCapturedBy], TurfInfo[i][tCapturedGang], i);
					    mysql_tquery(connectionID, queryBuffer);

	                    TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
		                TurfInfo[i][tCaptureTime] = 0;
		                TurfInfo[i][tTime] = 6;

						ReloadTurf(i);
					}
				}
			}
		}

		for(new i = 0; i < MAX_REPORTS; i ++)
		{
		    if(ReportInfo[i][rExists] && ReportInfo[i][rTime] > 0)
		    {
		        ReportInfo[i][rTime]--;

		        if(ReportInfo[i][rTime] <= 0)
		        {
		            SendClientMessage(ReportInfo[i][rReporter], COLOR_SYNTAX, "Your report has expired. You can make an admin request on "SERVER_URL" if you still need help.");
		            ReportInfo[i][rExists] = 0;
		        }
			}
	    }
	}
}

forward FuelTimer();
public FuelTimer()
{
	foreach(new i : Vehicle)
	{
	    if(VehicleHasEngine(i) && GetVehicleParams(i, VEHICLE_ENGINE))
	    {
			if(vehicleFuel[i] > 0)
			{
			    vehicleFuel[i]--;

			    switch(vehicleFuel[i])
			    {
			        case 15, 10, 5:
			        {
			            SendClientMessage(GetVehicleDriver(i), COLOR_LIGHTRED, "** This vehicle is running low on fuel. Visit the nearest gas station to fill up. (/refuel)");
					}
				}
			}

			if(vehicleFuel[i] <= 0)
			{
			    SetVehicleParams(i, VEHICLE_ENGINE, false);
			}

		}
	}
}

forward InjuredTimer();
public InjuredTimer()
{
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pLogged] && PlayerInfo[i][pInjured] && GetVehicleModel(GetPlayerVehicleID(i)) != 416)
		{
  			new
     			Float:health;
	    	GetPlayerHealth(i, health);
		    SetPlayerHealth(i, health - 1.0);
		}
	}
}
public RobBigbank(playerid)
{
    ClearAnimations(playerid, SYNC_ALL);
    PlayerInfo[playerid][pWantedLevel] = 6;
    new rand = random(sizeof(BIGBANK));
	PlayerInfo[playerid][pDirtyCash] += BIGBANK[rand];
    TogglePlayerControllable(playerid, true);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
    return 1;
}
public RobFleecabank(playerid)
{
	new i;
    SetPlayerCheckpoint(playerid, washmoneyPoints[i][0], washmoneyPoints[i][1], washmoneyPoints[i][2], 7.0);
    ClearAnimations(playerid, SYNC_ALL);
    SetPlayerAttachedObject(playerid, 9, 1550, 1, 0.116999, -0.170999, -0.016000, -3.099997, 87.800018, -179.400009, 0.602000, 0.640000, 0.625000, 0, 0);
    PlayerInfo[playerid][pWantedLevel] = 6;
    new rand = random(sizeof(FLEECAMONEY));
	PlayerInfo[playerid][pDirtyCash] += FLEECAMONEY[rand];
    TogglePlayerControllable(playerid, true);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET dirtycash = %i WHERE uid = %i", PlayerInfo[playerid][pDirtyCash], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
    return 1;
}
forward RandomFire(check);
public RandomFire(check)
{
	new count, index, announced, rand = random(10);

	if(!IsFireActive())
	{
	    if(check)
	    {
			foreach(new i : Player)
			{
			    if(GetFactionType(i) == FACTION_MEDIC)
		    	{
		        	count++;
	        	}
	    	}
	    }
	    else
	    {
	        count = 3;
	    }

	    if(count >= 3)
	    {
	        for(new i = 0; i < sizeof(randomFireSpawns); i ++)
	        {
	            if(randomFireSpawns[i][fireIndex] == rand)
	            {
	                if(!announced)
	                {
	                    foreach(new x : Player)
	                    {
	                        if(IsPlayerInRangeOfPoint(x, 30.0, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ]))
	                        {
	                            SendClientMessage(x, COLOR_LE, "** An explosion can be heard. Smoke is rising from a building nearby.");
	                        }
	                        if(GetFactionType(x) == FACTION_MEDIC)
	                        {
	                            PlayerInfo[x][pCP] = CHECKPOINT_MISC;
	                            SetPlayerCheckpoint(x, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ], 3.0);
	                            SM(x, COLOR_DOCTOR, "** All units, a fire has been reported in %s. Please head to the beacon on your map. **", GetZoneName(randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ]));
							}
	                    }

						announced = 1;
					}

	                gFireObjects[index] = CreateDynamicObject(18691, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ], 0.0, 0.0, randomFireSpawns[i][fireA], .streamdistance = 50.0);
	                gFireHealth[index++] = 50.0;
	            }
	        }

	        gFires = index;
	    }
	}
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	if(!PlayerInfo[playerid][pKicked])
	{
	    PlayerInfo[playerid][pKicked] = 1;
	    SetTimerEx("KickPlayer", 200, false, "i", playerid);
	}
	else
	{
	    PlayerInfo[playerid][pKicked] = 0;
	    Kick(playerid);
	}
}

forward DespawnTimer(vehicleid);
public DespawnTimer(vehicleid)
{
	if(VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOccupied(vehicleid))
	{
	    DespawnVehicle(vehicleid);
	}
	else
	{
	    // ANOTHER TEN MINUTES!
	    VehicleInfo[vehicleid][vTimer] = SetTimerEx("DespawnTimer", 600000, false, "i", vehicleid);
	}
}

forward HTTP_OnMusicFetchResponse(index, response_code, data[]);
public HTTP_OnMusicFetchResponse(index, response_code, data[])
{
    if(response_code == 200)
    {
        new
            buffer[2048],
            string[288],
			count,
			start,
			pos;

		strcpy(buffer, data);

        while((pos = strfind(buffer, "<br/>")) != -1)
        {
            strdel(buffer, pos, pos + 5);

            if(++count == 8)
            {
                strmid(string, buffer, start, pos);
                SendClientMessage(index, COLOR_YELLOW, string);

				start = pos;
                count = 0;
			}
			else
			{
			    if((strlen(buffer) - pos) < 6)
			    {
			        strmid(string, buffer, start, pos);
			        SendClientMessage(index, COLOR_YELLOW, string);
			        break;
			    }

			    strins(buffer, ", ", pos);
            }
        }
    }
    else
    {
        SM(index, COLOR_RED, "The music database is currently not available. (error %i)", response_code);
    }
}

forward Radio_PlayStation(playerid);
public Radio_PlayStation(playerid)
{
	if(SQL_GetRows())
	{
	    new name[128], url[128];

	    SQL_GetString(0, "name", name);
	    SQL_GetString(0, "url", url);

	    switch(PlayerInfo[playerid][pMusicType])
	    {
	        case MUSIC_MP3PLAYER:
	        {
			    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the radio station on their MP3 player.", GetRPName(playerid));
	    		SM(playerid, COLOR_GREEN, "You are now tuned in to "SVRCLR"%s{CCFFFF}.", name);
				SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
			}
			case MUSIC_BOOMBOX:
			{
			    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the radio station on their boombox.", GetRPName(playerid));
	    		SM(playerid, COLOR_GREEN, "Your boombox is now tuned in to "SVRCLR"%s{CCFFFF}.", name);
				SetMusicStream(MUSIC_BOOMBOX, playerid, url);
			}
			case MUSIC_VEHICLE:
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s changes the radio station in their vehicle.", GetRPName(playerid));
		    		SM(playerid, COLOR_GREEN, "Your radio is now tuned in to "SVRCLR"%s{CCFFFF}.", name);
					SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
				}
			}
		}
	}
}

forward Radio_ListStations(playerid);
public Radio_ListStations(playerid)
{
	new rows = SQL_GetRows();

	if((!rows) && PlayerInfo[playerid][pSearch] && PlayerInfo[playerid][pPage] == 1)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "No results found.");
	    ShowDialogToPlayer(playerid, DIALOG_MP3RADIOSEARCH);
	}
	else if(rows)
	{
	    static string[MAX_LISTED_STATIONS * 64], name[128];

	    string[0] = 0;

	    for(new i = 0; i < rows; i ++)
	    {
	        SQL_GetString(i, "name", name);
	        format(string, sizeof(string), "%s\n%s", string, name);
		}

		if(PlayerInfo[playerid][pPage] > 1)
		{
		    strcat(string, "\n"SVRCLR"<< Go back"WHITE"");
		}
		if(rows == MAX_LISTED_STATIONS)
		{
		    strcat(string, "\n"SVRCLR">> Next page"WHITE"");
		}

		ShowPlayerDialog(playerid, DIALOG_MP3RADIORESULTS, DIALOG_STYLE_LIST, "Results", string, "Play", "Back");
	}
}

forward MDC_ListCharges(playerid);
public MDC_ListCharges(playerid)
{
	new rows = SQL_GetRows();

	if(!rows)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "This player has no active charges on them.");
	}
	else
	{
	    new chargedby[MAX_PLAYER_NAME], date[24], reason[128], string[512];

	    string = "Charged by\tDate\tReason";

	    for(new i = 0; i < rows; i ++)
	    {
	        SQL_GetString(i, "chargedby", chargedby);
	        SQL_GetString(i, "date", date);
	        SQL_GetString(i, "reason", reason);

	        format(string, sizeof(string), "%s\n%s\t%s\t%s", string, chargedby, date, reason);
		}

		ShowPlayerDialog(playerid, DIALOG_MDCCHARGES, DIALOG_STYLE_TABLIST_HEADERS, "Active charges:", string, "<<", "");
	}

	return 1;
}

forward MDC_ClearCharges(playerid);
public MDC_ClearCharges(playerid)
{
	if(SQL_GetRows())
	{
	    new username[MAX_PLAYER_NAME], id = PlayerInfo[playerid][pSelected];

	    SQL_GetString(0, "username", username);

    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", id);
        mysql_tquery(connectionID, queryBuffer);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 0 WHERE uid = %i", id);
        mysql_tquery(connectionID, queryBuffer);

        foreach(new i : Player)
        {
            if(!strcmp(GetPlayerNameEx(i), username))
            {
                SM(i, COLOR_WHITE, "** Your crimes were cleared by %s.", GetRPName(playerid));
                PlayerInfo[i][pWantedLevel] = 0;
            }
        }

        SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has cleared %s's charges and wanted level.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), username);
	}
}

forward MDC_PlayerLookup(playerid, username[]);
public MDC_PlayerLookup(playerid, username[])
{
	if(!SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That player doesn't exist and therefore has no information to view.");
	    ShowPlayerDialog(playerid, DIALOG_PLAYERLOOKUP, DIALOG_STYLE_INPUT, "Player lookup", "Enter the full name of the player to lookup:", "Submit", "Cancel");
	}
	else
	{
	    new string[512];

	    PlayerInfo[playerid][pSelected] = SQL_GetInt(0, "uid");

	    format(string, sizeof(string), "Name: %s\nGender: %s\nAge: %i years old\nCrimes commited: %i\nTimes arrested: %i\nWanted level: %i/6\nDrivers License: %s\nGun License: %s", username, (SQL_GetInt(0, "gender") == 3) ? ("Female") : ("Male"), SQL_GetInt(0, "age"), SQL_GetInt(0, "crimes"), SQL_GetInt(0, "arrested"), SQL_GetInt(0, "wantedlevel"), SQL_GetInt(0, "carlicense") ? ("Yes") : ("No"), SQL_GetInt(0, "gunlicense") ? ("Yes") : ("No"));
		ShowPlayerDialog(playerid, DIALOG_MDCPLAYER1, DIALOG_STYLE_MSGBOX, "Player lookup", string, "Options", "Cancel");
	}
}
forward OnPlayerUseGCarStorage(playerid);
public OnPlayerUseGCarStorage(playerid)
{
	new vehicleid = GetVehicleLinkedID(SQL_GetInt(0, "id"));

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		if(IsVehicleOccupied(vehicleid) && GetVehicleDriver(vehicleid) != playerid)
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is occupied.");
        }
        else //SendClientMessage(playerid, COLOR_SYNTAX, "This command is disabled.");
        {
            new
				Float:health;

			GetVehicleHealth(vehicleid, health);

            if(health < 600.0)
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is too damaged to be despawned.");
            }
            else
            {
		        SM(playerid, COLOR_AQUA, "Your Gangs "SVRCLR"%s{CCFFFF} which is located in %s has been despawned.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
				DespawnVehicle(vehicleid);
			}
		}
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i AND gangid = %i", SQL_GetInt(0, "id"), PlayerInfo[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehicle", "ii", playerid, false);
	}
}

forward OnPlayerUseCarStorage(playerid);
public OnPlayerUseCarStorage(playerid)
{
	new vehicleid = GetVehicleLinkedID(SQL_GetInt(0, "id"));
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		if(IsVehicleOccupied(vehicleid) && GetVehicleDriver(vehicleid) != playerid)
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is occupied.");
        }
        else //SendClientMessage(playerid, COLOR_SYNTAX, "This command is disabled.");
        {
            new
				Float:health;

			GetVehicleHealth(vehicleid, health);

            if(health < 600.0)
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is too damaged to be despawned.");
            }
            else
            {
		        SM(playerid, COLOR_AQUA, "Your "SVRCLR"%s{CCFFFF} which is located in %s has been despawned.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
				DespawnVehicle(vehicleid);
			}
		}
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", SQL_GetInt(0, "id"), PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehicle", "ii", playerid, false);
	}
}
forward OnPlayerUseVote(playerid);
public OnPlayerUseVote(playerid)
{
	new factionid = SQL_GetInt(0, "id");
	new color = FactionInfo[factionid][fColor];
	if(factionid != -1)
	{
		if(PlayerInfo[playerid][pVoted])
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "You Already Voted");
        }
        else //SendClientMessage(playerid, COLOR_SYNTAX, "This command is disabled.");
        {
            FactionInfo[factionid][fVote]++;
            SCMf(playerid, COLOR_GREEN,"You Have Been Voted to {%06x}%s ", color >>> 8 , FactionInfo[factionid][fName]);
            PlayerInfo[playerid][pVoted] = 1;
           	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET voted = 1  WHERE uid = %i", PlayerInfo[playerid][pID]);
        	mysql_tquery(connectionID, queryBuffer);
        	
           	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET vote = %i  WHERE id = %i", FactionInfo[factionid][fVote] , factionid);
        	mysql_tquery(connectionID, queryBuffer);
		}
	}
	
}

forward OnPlayerUseCarValley(playerid);
public OnPlayerUseCarValley(playerid)
{
	new vehicleid = GetVehicleLinkedID(SQL_GetInt(0, "id"));

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		if(IsVehicleOccupied(vehicleid) && GetVehicleDriver(vehicleid) != playerid)
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is occupied.");
        }
        else //SendClientMessage(playerid, COLOR_SYNTAX, "This command is disabled.");
        {
            new
				Float:health;

			GetVehicleHealth(vehicleid, health);

            if(health < 600.0)
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is too damaged to be despawned.");
            }
            else
            {
		        SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is spawned already. /findcar to track it.");
			}
		}
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", SQL_GetInt(0, "id"), PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehiclePGValley", "ii", playerid, false);
	}
}

forward OnPlayerDMVRelease(playerid);
public OnPlayerDMVRelease(playerid)
{
	new tickets = SQL_GetInt(0, "tickets");

	if(PlayerInfo[playerid][pCash] < tickets)
	{
		return SM(playerid, COLOR_SYNTAX, "[ERROR]{ffffff} You need %s to release this impounded vehicle.", FormatNumber(tickets));
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET impounded = '0', tickets = '0' WHERE id = %i", SQL_GetInt(0, "id"));
	mysql_tquery(connectionID, queryBuffer);
	GivePlayerCash(playerid, -tickets);
	SM(playerid, -1, "You have paid %s to release your %s. /vst to spawn the vehicle.", FormatNumber(tickets), vehicleNames[SQL_GetInt(0, "modelid") - 400]);
	return 1;
}

forward OnBanAttempt(username[], ip[], from[], reason[], permanent);
public OnBanAttempt(username[], ip[], from[], reason[], permanent)
{
	if(SQL_GetRows())
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE bans SET reason = '%e' WHERE id = %i", reason, SQL_GetIntByIndex(0, 0));
		mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO bans VALUES(null, '%s', '%s', '%s', NOW(), '%e', %i)", username, ip, from, reason, permanent);
		mysql_tquery(connectionID, queryBuffer);
	}
}

forward OnPlayerAttemptInviteGang(playerid, targetid);
public OnPlayerAttemptInviteGang(playerid, targetid)
{
    if(SQL_GetIntByIndex(0, 0) >= GetGangMemberLimit(PlayerInfo[playerid][pGang]))
    {
        SM(playerid, COLOR_SYNTAX, "Your gang can't have more than %i members at its level.", GetGangMemberLimit(PlayerInfo[playerid][pGang]));
    }
    else
    {
    	PlayerInfo[targetid][pGangOffer] = playerid;
		PlayerInfo[targetid][pGangOffered] = PlayerInfo[playerid][pGang];

		SM(targetid, COLOR_GREEN, "%s has invited you to join "SVRCLR"%s{CCFFFF} (/accept gang).", GetRPName(playerid), GangInfo[PlayerInfo[playerid][pGang]][gName]);
		SM(playerid, COLOR_GREEN, "You have invited %s to join your gang.", GetRPName(targetid));
	}
}

forward OnPlayerAttemptBuyVehicle(playerid, index);
public OnPlayerAttemptBuyVehicle(playerid, index)
{
	new count = SQL_GetIntByIndex(0, 0);

	if(count >= GetPlayerAssetLimit(playerid, LIMIT_VEHICLES))
	{
	    SM(playerid, COLOR_SYNTAX, "You currently own %i/%i vehicles. You can't own anymore unless you upgrade your asset perk.", count, GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
	}
	else
	{
	    new string[20];

        if(PlayerInfo[playerid][pCash] < vehicleArray[index][carPrice])
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
        }
		else
		{
	        switch(random(3))
    	    {
        	    case 0:
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, price, pos_x, pos_y, pos_z, pos_a) VALUES(%i, '%s', %i, %i, '562.3970', '-1283.8485', '17.0007', '0.0000')", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleArray[index][carModel], vehicleArray[index][carPrice]);
					mysql_tquery(connectionID, queryBuffer);
				}
            	case 1:
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, price, pos_x, pos_y, pos_z, pos_a) VALUES(%i, '%s', %i, %i, '557.8670', '-1283.9822', '17.0007', '0.0000')", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleArray[index][carModel], vehicleArray[index][carPrice]);
					mysql_tquery(connectionID, queryBuffer);
				}
            	case 2:
				{
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, price, pos_x, pos_y, pos_z, pos_a) VALUES(%i, '%s', %i, %i, '552.8177', '-1284.1307', '17.0007', '0.0000')", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleArray[index][carModel], vehicleArray[index][carPrice]);
                    mysql_tquery(connectionID, queryBuffer);
				}
			}

	        AddPointMoney(POINT_AUTOEXPORT, percent(vehicleArray[index][carPrice], 3));
    	    GivePlayerCash(playerid, -vehicleArray[index][carPrice]);

	        format(string, sizeof(string), "~r~-$%i", vehicleArray[index][carPrice]);
    	    GameTextForPlayer(playerid, string, 5000, 1);

	        SM(playerid, COLOR_YELLOW, "%s purchased for $%i. /vstorage to spawn this vehicle.", vehicleNames[vehicleArray[index][carModel] - 400], vehicleArray[index][carPrice]);
    	    //Log_Write("log_property", "%s (uid: %i) purchased a %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], vehicleNames[vehicleArray[index][carModel] - 400], vehicleArray[index][carPrice]);
		}
	}
}
forward OnPlayerAttemptBuyRentVehicle(playerid, index);
public OnPlayerAttemptBuyRentVehicle(playerid, index)
{
	new count = SQL_GetIntByIndex(0, 0);

	if(count >= 1)
	{
	    SM(playerid, COLOR_SYNTAX, "You currently own %i/1 vehicles. You can't own anymore.", count);
	}
	else
	{
	    new string[20];

        if(PlayerInfo[playerid][pCash] < vehicleArray[index][carPrice])
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vehicle.");
        }
		else
		{
	 
		     mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, price, pos_x, pos_y, pos_z, pos_a, rent, renttime) VALUES(%i, '%s', 508, %i, '562.3970', '-1283.8485', '17.0007', '0.0000', 1 , 240)", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleArray[index][carModel], vehicleArray[index][carPrice]);
		     mysql_tquery(connectionID, queryBuffer);
		
    	     GivePlayerCash(playerid, -200000);

	         format(string, sizeof(string), "~r~-$%i", 200000);
    	     GameTextForPlayer(playerid, string, 5000, 1);

	         SM(playerid, COLOR_YELLOW, "%s purchased for $%i. /vstorage to spawn this vehicle only valid for 4 hours after vehicle spawned.", vehicleNames[508 - 400], 200000);
    	     //Log_Write("log_property", "%s (uid: %i) purchased a %s for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], vehicleNames[508 - 400], 200000);
		}
	}
}

forward OnHitmanPassport(playerid, name[], level, skinid);
public OnHitmanPassport(playerid, name[], level, skinid)
{
    if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That name is already taken, please choose another.");
	}
	else
	{
	    strcpy(PlayerInfo[playerid][pNameChange], name, MAX_PLAYER_NAME);

		PlayerInfo[playerid][pFreeNamechange] = 2;
		PlayerInfo[playerid][pChosenLevel] = level;
	    PlayerInfo[playerid][pChosenSkin] = skinid;

		SM(playerid, COLOR_GREEN, "You have requested a namechange to "SVRCLR"%s{CCFFFF} for free, please wait for admin approval.", name);
		SM(playerid, COLOR_GREEN, "Once the namechange has been approved, you will receive your chosen name, level and skin.");

		SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is requesting a namechange to %s. (/acceptname %i or /denyname %i)", GetRPName(playerid), playerid, name, playerid, playerid);
	}
}

forward OnPlayerAttemptNameChange(playerid, name[]);
public OnPlayerAttemptNameChange(playerid, name[])
{
	if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That name is already taken, please choose another.");

	    if(PlayerInfo[playerid][pFreeNamechange])
	    {
	        ShowPlayerDialog(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
		}
	}
	else
	{
	    strcpy(PlayerInfo[playerid][pNameChange], name, MAX_PLAYER_NAME);

		if(PlayerInfo[playerid][pFreeNamechange]) {
			SM(playerid, COLOR_GREEN, "You have requested a namechange to "SVRCLR"%s{CCFFFF} for free, please wait for admin approval.", name);
		} else {
		    SM(playerid, COLOR_GREEN, "You have requested a namechange to "SVRCLR"%s{CCFFFF} for $%i, please wait for admin approval.", name, PlayerInfo[playerid][pLevel] * 5000);
		}
        new dc_str[454];
		format(dc_str, sizeof(dc_str), "AdmWarning: %s is requesting a namechange to %s.", GetRPName(playerid), name);
		SendDiscordMessage(2, dc_str);
		SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is requesting a namechange to %s. (/acceptname %i or /denyname %i)", GetRPName(playerid), playerid, name, playerid, playerid);
	}
}

forward OnPlayerLockFurnitureDoor(playerid, id);
public OnPlayerLockFurnitureDoor(playerid, id)
{
	new status = !SQL_GetInt(0, "door_locked");

	if(status) {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks the door.", GetRPName(playerid));
	} else {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks the door.", GetRPName(playerid));
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE furniture SET door_locked = %i WHERE id = %i", status, id);
	mysql_tquery(connectionID, queryBuffer);
}

forward OnPlayerUseFurnitureDoor(playerid, objectid, id);
public OnPlayerUseFurnitureDoor(playerid, objectid, id)
{
    if(SQL_GetIntByIndex(0, 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "This door is locked.");
	}
	else
	{
		new
			status = !SQL_GetIntByIndex(0, 0),
			Float:rx,
			Float:ry,
			Float:rz;

		GetDynamicObjectRot(objectid, rx, ry, rz);

		if(status) {
		    rz -= 90.0;
		} else {
			rz += 90.0;
		}

		SetDynamicObjectRot(objectid, rx, ry, rz);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE furniture SET rot_z = '%f', door_opened = %i WHERE id = %i", rz, status, id);
		mysql_tquery(connectionID, queryBuffer);

		if(status)
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens the door.", GetRPName(playerid));
		else
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s closes the door.", GetRPName(playerid));
	}
}

forward OnPlayerLockLandDoor(playerid, id);
public OnPlayerLockLandDoor(playerid, id)
{
	new status = !SQL_GetInt(0, "door_locked");

	if(status) {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s locks the door.", GetRPName(playerid));
	} else {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s unlocks the door.", GetRPName(playerid));
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET door_locked = %i WHERE id = %i", status, id);
	mysql_tquery(connectionID, queryBuffer);
}

forward OnPlayerUseLandGate(playerid, objectid, id);
public OnPlayerUseLandGate(playerid, objectid, id)
{
	if(!Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
	{
	    new
         	Float:x = SQL_GetFloat(0, "move_x"),
 			Float:y = SQL_GetFloat(0, "move_y"),
 			Float:z = SQL_GetFloat(0, "move_z");

	    if(x == 0.0 && y == 0.0 && z == 0.0)
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "This gate has no destination set.");
	    }
	    else
	    {
			MoveDynamicObject(objectid, x, y, z, 3.0, SQL_GetFloat(0, "move_rx"), SQL_GetFloat(0, "move_ry"), SQL_GetFloat(0, "move_rz"));
			SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their remote to open the gate.", GetRPName(playerid));
			Streamer_SetExtraInt(objectid, E_OBJECT_OPENED, 1);
		}
	}
	else
	{
		MoveDynamicObject(objectid, SQL_GetFloat(0, "pos_x"), SQL_GetFloat(0, "pos_y"), SQL_GetFloat(0, "pos_z"), 3.0, SQL_GetFloat(0, "rot_x"), SQL_GetFloat(0, "rot_y"), SQL_GetFloat(0, "rot_z"));
		SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their remote to close the gate.", GetRPName(playerid));
		Streamer_SetExtraInt(objectid, E_OBJECT_OPENED, 0);
	}
}
forward OnPlayerUseLandDoor(playerid, objectid, id);
public OnPlayerUseLandDoor(playerid, objectid, id)
{
    if(SQL_GetIntByIndex(0, 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "This door is locked.");
	}
	else
	{
		new
			status = !SQL_GetIntByIndex(0, 0),
			Float:rx,
			Float:ry,
			Float:rz;

		GetDynamicObjectRot(objectid, rx, ry, rz);

		if(status) {
		    rz -= 90.0;
		} else {
			rz += 90.0;
		}

		SetDynamicObjectRot(objectid, rx, ry, rz);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET rot_z = '%f', door_opened = %i WHERE id = %i", rz, status, id);
		mysql_tquery(connectionID, queryBuffer);

		if(status)
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens the door.", GetRPName(playerid));
		else
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s closes the door.", GetRPName(playerid));
	}
}
forward OnPlayerAddToPhonebook(playerid, number, name[]);
public OnPlayerAddToPhonebook(playerid, number, name[])
{
	if(SQL_GetRows())
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "That number is already in the phonebook.");
	}
	else
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO phonebook VALUES('%e', %i)", name, number);
		mysql_tquery(connectionID, queryBuffer);

	    SM(playerid, COLOR_YELLOW, "You have added %s with number %i to the phonebook directory.", name, number);
	    ////Log_Write("log_faction", "%s (uid: %i) added %s with number %i to the phonebook.", GetRPName(playerid), PlayerInfo[playerid][pID], name, number);
	}

	return 1;
}

forward OnPlayerRemoveFromPhonebook(playerid, number);
