CMD:gate(playerid, params[]) return callcmd::open(playerid, params);
CMD:door(playerid, params[]) return callcmd::open(playerid, params);
CMD:open(playerid, params[])
{
	new id = Gate_Nearest(playerid);

	if (id != -1)
	{
		if (strlen(GateData[id][gatePass]))
		{
		    //ShowPlayerDialog(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
		}
		else
		{
		    if (GateData[id][gateFaction] != -1 && PlayerInfo[playerid][pFaction] != GetFactionByID(GateData[id][gateFaction]))
				return SendClientMessage(playerid, COLOR_SYNTAX, "You can't open this gate/door.");

			Gate_Operate(id);

			switch (GateData[id][gateOpened])
			{
			    case 0:
				{
				    Dyuze(playerid, "Notice", "You have closed the gate/door!");
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their card to close the gate/door.", GetRPName(playerid));
				}
                case 1:
				{
				    Dyuze(playerid, "Notice", "You have opened the gate/door!");
					SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their card to open the gate/door.", GetRPName(playerid));
				}
			}
		}
	}
	return 1;
}

CMD:maphelp(playerid)
{
	if (strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	SendClientMessage(playerid, COLOR_WHITE, "** Mapper: /createobj, /dupobj, /nearobj, /editobj, /delobj ");
	return 1;
}

CMD:nearobj(playerid, params[])
{
	new id;

    if (strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if((id = Object_Nearest(playerid)) >= 0)
	{
		SM(playerid, COLOR_GREY2, "You are in range of object ID %i.", id);
	}
	return 1;
}

CMD:dupobj(playerid, params[])
{
	static id = -1, idx;
    if(strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	if (sscanf(params, "d", idx)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /dupobj [id]");

	id = Object_Duplicate(playerid, idx);
	if (id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for objects.");
	SM(playerid, COLOR_WHITE, "You have successfully duplicate object ID: %d.", id);
	return 1;
}

CMD:createobj(playerid, params[])
{
	static id = -1, idx;
    if(strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	if (sscanf(params, "d", idx)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /createobj [objid]");

	id = Object_Create(playerid, idx);
	if (id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for objects.");
	SM(playerid, COLOR_WHITE, "You have successfully created object ID: %d.", id);
	return 1;
}

CMD:editobj(playerid, params[])
{
	static id;
    if (strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	if (sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editobj [id]");
	if ((id < 0 || id >= MAX_MAPOBJECTS) || !ObjectData[id][mobjExists]) return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid object ID.");

	PlayerInfo[playerid][pEditmObject] = -1;
	EditDynamicObject(playerid, ObjectData[id][mobjObject]);
	PlayerInfo[playerid][pEditmObject] = id;
	PlayerInfo[playerid][pEditType] = EDIT_OBJECT_PREVIEW;
	SM(playerid, COLOR_WHITE, "You are now adjusting the position of object ID: %d.", id);
	return 1;
}

CMD:delobj(playerid, params[])
{
	static id = 0;
    if (strcmp(PlayerInfo[playerid][pCustomTitle], "Mapper", true) != 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");
	if (sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /delobj [id]");
	if ((id < 0 || id >= MAX_MAPOBJECTS) || !ObjectData[id][mobjExists]) return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid object ID.");

	Object_Delete(id);
	SM(playerid, COLOR_WHITE, "You have successfully destroyed object ID: %d.", id);
	return 1;
}

CMD:creategate(playerid, params[])
{
	static
	    id = -1;

	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	id = Gate_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for gates.");

	SM(playerid, COLOR_WHITE, "You have successfully created gate ID: %d.", id);
	return 1;
}

CMD:createvendor(playerid, params[])
{
	static
	    id = -1;

	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	id = Vendor_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for gates.");

	SM(playerid, COLOR_WHITE, "You have successfully created vendor stall ID: %d.", id);
	return 1;
}

CMD:removevendor(playerid, params[])
{
	static
	    id = 0;

	if(PlayerInfo[playerid][pAdmin] < 6)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /removevendor [stall id]");

	if ((id < 0 || id >= MAX_VENDOR) || !VendorData[id][vendorExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid vendor stall ID.");

	Vendor_Delete(id);
	SM(playerid, COLOR_WHITE, "You have successfully removed vendor stall ID: %d.", id);
	return 1;
}

CMD:gotogate(playerid, params[])
{
	new houseid;

	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotogate [gateid]");
	}
	if(!(0 <= houseid < MAX_GATES) || !GateData[houseid][gateExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gate.");
	}
	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);
	SetPlayerPos(playerid, GateData[houseid][gatePos][0] - (2.5 * floatsin(-GateData[houseid][gatePos][3], degrees)), GateData[houseid][gatePos][1] - (2.5 * floatcos(-GateData[houseid][gatePos][3], degrees)), GateData[houseid][gatePos][2]);
	SetPlayerInterior(playerid, GateData[houseid][gateInterior]);
	SetPlayerVirtualWorld(playerid, GateData[houseid][gateWorld]);
	SetCameraBehindPlayer(playerid);
	return 1;
}


CMD:destroygate(playerid, params[])
{
	static
	    id = 0;

	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /destroygate [gate id]");

	if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");

	Gate_Delete(id);
	SM(playerid, COLOR_WHITE, "You have successfully destroyed gate ID: %d.", id);
	return 1;
}


CMD:editgate(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if(PlayerInfo[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [name]");
	    SendClientMessage(playerid, COLOR_ORANGE, "Names:{FFFFFF} location, speed, radius, time, model, pos, move, pass, linkid, faction");
		return 1;
	}
	if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");

    if (!strcmp(type, "location", true))
	{
		static
		    Float:x,
		    Float:y,
		    Float:z,
		    Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);

		GateData[id][gatePos][0] = x;
		GateData[id][gatePos][1] = y;
		GateData[id][gatePos][2] = z;
		GateData[id][gatePos][3] = 0.0;
		GateData[id][gatePos][4] = 0.0;
		GateData[id][gatePos][5] = angle;

		SetDynamicObjectPos(GateData[id][gateObject], x, y, z);
		SetDynamicObjectRot(GateData[id][gateObject], 0.0, 0.0, angle);

		GateData[id][gateOpened] = false;

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the position of gate ID: %d.", GetRPName(playerid), id);
		return 1;
	}
	else if (!strcmp(type, "speed", true))
	{
	    static
	        Float:speed;

		if (sscanf(string, "f", speed))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [speed] [move speed]");

		if (speed < 0.0 || speed > 20.0)
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The specified speed can't be below 0 or above 20.");

        GateData[id][gateSpeed] = speed;

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the speed of gate ID: %d to %.2f.", GetRPName(playerid), id, speed);
		return 1;
	}
	else if (!strcmp(type, "radius", true))
	{
	    static
	        Float:radius;

		if (sscanf(string, "f", radius))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [radius] [open radius]");

		if (radius < 0.0 || radius > 20.0)
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The specified radius can't be below 0 or above 20.");

        GateData[id][gateRadius] = radius;

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the radius of gate ID: %d to %.2f.", GetRPName(playerid), id, radius);
		return 1;
	}
	else if (!strcmp(type, "time", true))
	{
	    static
	        time;

		if (sscanf(string, "d", time))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [time] [close time] (0 to disable)");

		if (time < 0 || time > 60000)
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The specified time can't be 0 or above 60,000 ms.");

        GateData[id][gateTime] = time;

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the close time of gate ID: %d to %d.", GetRPName(playerid), id, time);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static
	        model;

		if (sscanf(string, "d", model))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [model] [gate model]");

        GateData[id][gateModel] = model;

		DestroyDynamicObject(GateData[id][gateObject]);
		GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the model of gate ID: %d to %d.", GetRPName(playerid), id, model);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    PlayerInfo[playerid][pEditGate] = -1;
	   	EditDynamicObject(playerid, GateData[id][gateObject]);

		PlayerInfo[playerid][pEditGate] = id;
		PlayerInfo[playerid][pEditType] = 1;

		SM(playerid, COLOR_WHITE, "You are now adjusting the position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "move", true))
	{
	    PlayerInfo[playerid][pEditGate] = -1;
	   	EditDynamicObject(playerid, GateData[id][gateObject]);

		PlayerInfo[playerid][pEditGate] = id;
		PlayerInfo[playerid][pEditType] = 2;

		SM(playerid, COLOR_WHITE, "You are now adjusting the moving position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "linkid", true))
	{
	    static
	        linkid = -1;

		if (sscanf(string, "d", linkid))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [linkid] [gate link] (-1 for none)");

        if ((linkid < -1 || linkid >= MAX_GATES) || (linkid != -1 && !GateData[linkid][gateExists]))
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");

        GateData[id][gateLinkID] = (linkid == -1) ? (-1) : (GateData[linkid][gateID]);
		Gate_Save(id);

		if (id == -1)
			SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no gate.", GetRPName(playerid), id);

		else
		    SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to ID: %d.", GetRPName(playerid), id, linkid);

		return 1;
	}
	else if (!strcmp(type, "faction", true))
	{
	    static
	        factionid = 0;

		if (sscanf(string, "d", factionid))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [faction] [gate faction] (-1 for none)");

		if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
			return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid faction.");


        GateData[id][gateFaction] = (factionid == -1) ? (-1) : (FactionInfo[factionid][fType]);
		Gate_Save(id);

		if (factionid == -1)
			SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no faction.", GetRPName(playerid), id);

		else
		    SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to \"%s\".", GetRPName(playerid), id, FactionInfo[factionid][fName]);

		return 1;
	}
	else if (!strcmp(type, "pass", true))
	{
	    static
	        pass[32];

		if (sscanf(string, "s[32]", pass))
		    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editgate [id] [pass] [gate password] (Use 'none' to disable)");

		if (!strcmp(params, "none", true))
			GateData[id][gatePass][0] = 0;

		else format(GateData[id][gatePass], 32, pass);

		Gate_Save(id);
		SAM(COLOR_LIGHTRED, "ACmd: %s has adjusted the password of gate ID: %d to %s.", GetRPName(playerid), id, pass);
		return 1;
	}
	return 1;
}

CMD:creategarage(playerid, params[])
{
	new size[8], type = -1, Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[8]", size))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /creategarage [small/medium/large]");
	}
	if(GetNearbyGarage(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a garage in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create garages indoors.");
	}

	if(!strcmp(size, "small", true)) {
	    type = 0;
	} else if(!strcmp(size, "medium", true)) {
	    type = 1;
	} else if(!strcmp(size, "large", true)) {
	    type = 2;
	}

	if(type == -1)
	{
	     SendClientMessage(playerid, COLOR_SYNTAX, "Invalid size. Valid sizes range from Small, Medium and Large.");
	}
	else
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		for(new i = 0; i < MAX_GARAGES; i ++)
		{
		    if(!GarageInfo[i][gExists])
		    {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO garages (type, price, pos_x, pos_y, pos_z, pos_a, exit_x, exit_y, exit_z, exit_a) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", type, garageInteriors[type][intPrice], x, y, z, a, x - 3.0 * floatsin(-a, degrees), y - 3.0 * floatcos(-a, degrees), z, a - 180.0);
				mysql_tquery(connectionID, queryBuffer, "OnAdminCreateGarage", "iiiffff", playerid, i, type, x, y, z, a);
				return 1;
			}
		}

		SendClientMessage(playerid, COLOR_SYNTAX, "Garage slots are currently full. Ask the developer to increase the internal limit.");
	}

	return 1;
}

CMD:editgarage(playerid, params[])
{
	new garageid, option[10], param[32];

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[10]S()[32]", garageid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgarage [garageid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Entrance, Exit, Type, Owner, Price, Locked");
	    return 1;
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid garage.");
	}

	if(!strcmp(option, "entrance", true))
	{
	    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create garages indoors.");
		}

	    GetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
	    GetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f' WHERE id = %i", GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], GarageInfo[garageid][gPosA], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadGarage(garageid);
	    SM(playerid, COLOR_AQUA, "** You've changed the entrance of garage %i.", garageid);
	}
	else if(!strcmp(option, "exit", true))
	{
	    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot create garages indoors.");
		}

	    GetPlayerPos(playerid, GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ]);
	    GetPlayerFacingAngle(playerid, GarageInfo[garageid][gExitA]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET exit_x = '%f', exit_y = '%f', exit_z = '%f', exit_a = '%f' WHERE id = %i", GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ], GarageInfo[garageid][gExitA], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadGarage(garageid);
	    SM(playerid, COLOR_AQUA, "** You've changed the vehicle exit spawn of garage %i.", garageid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new size[8], type = -1;

	    if(sscanf(param, "s[8]", size))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgarage [garageid] [type] [small/medium/large]");
		}

		if(!strcmp(size, "small", true)) {
		    type = 0;
		} else if(!strcmp(size, "medium", true)) {
		    type = 1;
		} else if(!strcmp(size, "large", true)) {
		    type = 2;
		}

		if(type == -1)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		GarageInfo[garageid][gType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET type = %i WHERE id = %i", type, GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SM(playerid, COLOR_AQUA, "** You've changed the type of garage %i to %s.", garageid, size);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /editgarage [garageid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(!PlayerInfo[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
		}

        SetGarageOwner(garageid, targetid);
	    SM(playerid, COLOR_AQUA, "** You've changed the owner of garage %i to %s.", garageid, GetRPName(targetid));
	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgarage [garageid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $0.");
		}

		GarageInfo[garageid][gPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET price = %i WHERE id = %i", GarageInfo[garageid][gPrice], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SM(playerid, COLOR_AQUA, "** You've changed the price of garage %i to $%i.", garageid, price);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editgarage [garageid] [locked] [0/1]");
		}

		GarageInfo[garageid][gLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[garageid][gLocked], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SM(playerid, COLOR_AQUA, "** You've changed the lock state of garage %i to %i.", garageid, locked);
	}

	return 1;
}

CMD:removegarage(playerid, params[])
{
	new garageid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removegarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid garage.");
	}

	DestroyDynamic3DTextLabel(GarageInfo[garageid][gText]);
	DestroyDynamicPickup(GarageInfo[garageid][gPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM garages WHERE id = %i", GarageInfo[garageid][gID]);
	mysql_tquery(connectionID, queryBuffer);

	GarageInfo[garageid][gExists] = 0;
	GarageInfo[garageid][gID] = 0;
	GarageInfo[garageid][gOwnerID] = 0;

	SM(playerid, COLOR_AQUA, "** You have removed garage %i.", garageid);
	return 1;
}

CMD:gotogarage(playerid, params[])
{
	new garageid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotogarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid garage.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
	SetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:garagehelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "** GARAGE: /buygarage, /lock, /sellgarage, /sellmygarage, /garageinfo.");
	SendClientMessage(playerid, COLOR_WHITE, "** GARAGE: /repair, /refuel, /tune.");
	return 1;
}

CMD:sellgarage(playerid, params[])
{
	new garageid = GetNearbyGarageEx(playerid), targetid, amount;

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any garage of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellgarage [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must specify an amount above zero.");
	}

	PlayerInfo[targetid][pGarageOffer] = playerid;
	PlayerInfo[targetid][pGarageOffered] = garageid;
	PlayerInfo[targetid][pGaragePrice] = amount;

	SM(targetid, COLOR_AQUA, "** %s offered you their garage for $%i (/accept garage).", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your garage for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:garageinfo(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid);

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any garage of yours.");
	}

    SM(playerid, SERVER_COLOR, "Garage ID %i:", garageid);
	SM(playerid, COLOR_GREY2, "(Value: $%i) - (Size: %s) - (Location: %s) - (Active: %s) - (Locked: %s)", GarageInfo[garageid][gPrice], garageInteriors[GarageInfo[garageid][gType]][intName], GetZoneName(GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]), (gettime() - GarageInfo[garageid][gTimestamp] > 1209600) ? (""SVRCLR"No{C8C8C8}") : ("Yes"), (GarageInfo[garageid][gLocked]) ? ("Yes") : ("No"));
	return 1;
}
CMD:buyload(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid), string[500];
    
    if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_MOBILE)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any business where you can buy stuff.");
    }
    
    if(PlayerInfo[playerid][pSIM] == SIM_NONE)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a SIM card. Use /buy to buy one.");
    }
    
    format(string, sizeof(string), "%s {ff2424}Pack - 2 Days Validity\n%s {ccff67}Pack - 4 Days Validity\n%s {52ffe9}Pack - 6 Days Validity\n%s {ff75ea}Pack - 8 Days Validity\n%s {fff40d}Pack - 9 Days Validity\n%s{28fdb3} Pack - 10 Days Validity",
        FormatNumber(BusinessInfo[businessid][bPrices][3]), // Price for 20 load
        FormatNumber(BusinessInfo[businessid][bPrices][4]), // Price for 30 load
        FormatNumber(BusinessInfo[businessid][bPrices][5]), // Price for 40 load
        FormatNumber(BusinessInfo[businessid][bPrices][6]), // Price for 50 load
        FormatNumber(BusinessInfo[businessid][bPrices][7]), // Price for 80 load
        FormatNumber(BusinessInfo[businessid][bPrices][8])  // Price for 100 load
    );
    
    ShowPlayerDialog(playerid, LOAD_DIALOG, DIALOG_STYLE_LIST, "{ff39fc} OFFERS", string, "Buy", "Cancel");
    return 1;
}


CMD:createbiz(playerid, params[])
{
	new type, Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createbiz [type]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar (8) Mobile Shop");
	    return 1;
	}
	if(!(1 <= type <= sizeof(bizInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
	}
	if(GetNearbyBusiness(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is a business in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	type--;

 	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(!BusinessInfo[i][bExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO businesses (type, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", type, bizInteriors[type][intPrice], x, y, z, a - 180.0,
			bizInteriors[type][intX], bizInteriors[type][intY], bizInteriors[type][intZ], bizInteriors[type][intA], bizInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateBusiness", "iiiffff", playerid, i, type, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "Business slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editbiz(playerid, params[])
{
	new businessid, option[14], param[32];

	if(PlayerInfo[playerid][pAdmin] < 8)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[32]", businessid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [option]");
	    SendClientMessage(playerid, COLOR_GREY2, "List of options: Entrance, Exit, Interior, World, Type, Owner, Price, EntryFee, Products, Materials, Locked");
	    return 1;
	}
	if(!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid business.");
	}

	if(!strcmp(option, "entrance", true))
	{
	    GetPlayerPos(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]);
	    GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bPosA]);

	    BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
	    BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], BusinessInfo[businessid][bPosA], BusinessInfo[businessid][bOutsideInt], BusinessInfo[businessid][bOutsideVW], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the entrance of business %i.", businessid);
	}
	else if(!strcmp(option, "exit", true))
	{
	    new type = -1;

	    for(new i = 0; i < sizeof(bizInteriors); i ++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 100.0, bizInteriors[i][intX], bizInteriors[i][intY], bizInteriors[i][intZ]))
	        {
	            type = i;
			}
	    }

	    GetPlayerPos(playerid, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ]);
	    GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bIntA]);

	    BusinessInfo[businessid][bInterior] = GetPlayerInterior(playerid);
		BusinessInfo[businessid][bType] = type;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the exit of business %i.", businessid);
	}
	else if(!strcmp(option, "interior", true))
	{
		new string[1024];

		for(new i = 0; i < sizeof(bizInteriorArray); i ++)
		{
		    format(string, sizeof(string), "%s\n%s", string, bizInteriorArray[i][intName]);
	    }

	    PlayerInfo[playerid][pSelected] = businessid;
	    ShowPlayerDialog(playerid, DIALOG_BIZINTERIOR, DIALOG_STYLE_LIST, "Choose an interior to set for this business.", string, "Select", "Cancel");
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [world] [vw]");
		}

		BusinessInfo[businessid][bWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET world = %i WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the virtual world of business %i to %i.", businessid, worldid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SM(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [type] [value (1-%i)]", sizeof(bizInteriors));
	        SendClientMessage(playerid, COLOR_GREY2, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar");
	        return 1;
		}
		if(!(1 <= type <= sizeof(bizInteriors)))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		BusinessInfo[businessid][bType] = type-1;
		BusinessInfo[businessid][bInterior] = bizInteriors[type][intID];
		BusinessInfo[businessid][bIntX] = bizInteriors[type][intX];
		BusinessInfo[businessid][bIntY] = bizInteriors[type][intY];
		BusinessInfo[businessid][bIntZ] = bizInteriors[type][intZ];
		BusinessInfo[businessid][bIntA] = bizInteriors[type][intA];

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type-1, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the type of business %i to %i.", businessid, type);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(!PlayerInfo[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
		}

        SetBusinessOwner(businessid, targetid);
	    SM(playerid, COLOR_AQUA, "** You've changed the owner of business %i to %s.", businessid, GetRPName(targetid));
	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $0.");
		}

		BusinessInfo[businessid][bPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET price = %i WHERE id = %i", BusinessInfo[businessid][bPrice], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the price of business %i to $%i.", businessid, price);
	}
	else if(!strcmp(option, "entryfee", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [entryfee] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The price can't be below $0.");
		}

		BusinessInfo[businessid][bEntryFee] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the entry fee of business %i to $%i.", businessid, price);
	}
	else if(!strcmp(option, "products", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [products] [value]");
		}

		BusinessInfo[businessid][bProducts] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the products amount of business %i to %i.", businessid, amount);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editbiz [businessid] [locked] [0/1]");
		}

		BusinessInfo[businessid][bLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[businessid][bLocked], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SM(playerid, COLOR_AQUA, "** You've changed the lock state of business %i to %i.", businessid, locked);
	}

	return 1;
}

CMD:removebiz(playerid, params[])
{
	new businessid;

	if(PlayerInfo[playerid][pAdmin] < 10)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removebiz [businessid]");
	}
	if(!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid business.");
	}

	RemoveAllFurniture(businessid);

	DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
	DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
	DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM businesses WHERE id = %i", BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	BusinessInfo[businessid][bExists] = 0;
	BusinessInfo[businessid][bID] = 0;
	BusinessInfo[businessid][bOwnerID] = 0;

    SAM(COLOR_RED, "ADMWarning: %s has removed a business(BID: %i)", GetRPName(playerid), businessid);
	SM(playerid, COLOR_AQUA, "** You have removed business %i.", businessid);
	return 1;
}

CMD:gotobiz(playerid, params[])
{
	new businessid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotobiz [businessid]");
	}
	if(!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid business.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]);
	SetPlayerFacingAngle(playerid, BusinessInfo[businessid][bPosA]);
	SetPlayerInterior(playerid, BusinessInfo[businessid][bOutsideInt]);
	SetPlayerVirtualWorld(playerid, BusinessInfo[businessid][bOutsideVW]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:bizhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "** BUSINESS: /buybiz, /lock, /bwithdraw, /bdeposit, /sellbiz, /sellmybiz, /bizinfo.");
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "** BUSINESS: /entryfee, /businessmenu, /products.");
	return 1;
}

CMD:buyhouse(playerid, params[])
{
	new houseid, type[16];

	if((houseid = GetNearbyHouse(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no vehicle in range. You must be near a house.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /buyhouse [confirm]");
	}
	if(HouseInfo[houseid][hOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This house already has an owner.");
	}
	if(PlayerInfo[playerid][pCash] < HouseInfo[houseid][hPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this house.");
	}
	if(GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
	{
	    return SM(playerid, COLOR_SYNTAX, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
	}

	if(HouseInfo[houseid][hType]) {
	    type = "House";
	} else {
		strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
	}

	SetHouseOwner(houseid, playerid);
	GivePlayerCash(playerid, -HouseInfo[houseid][hPrice]);

	SM(playerid, COLOR_YELLOW, "You paid $%i to make this house yours! /househelp for a list of commands.", HouseInfo[houseid][hPrice]);
	//Log_Write("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], type, HouseInfo[houseid][hID], HouseInfo[houseid][hPrice]);
	return 1;
}


CMD:park(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not driving any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't park this vehicle as it doesn't belong to you.");
	}

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s parks their %s.", GetRPName(playerid), GetVehicleName(vehicleid));
 	SM(playerid, COLOR_AQUA, "You have parked your "SVRCLR"%s{CCFFFF} which will spawn in this spot from now on.", GetVehicleName(vehicleid));

	// Save the vehicle's information.
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

	// Update the database record with the new information, then despawn the vehicle.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);
	DespawnVehicle(vehicleid);

	// Finally, we reload the vehicle from the database.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehicle", "ii", playerid, true);

	return 1;
}
CMD:bwithdraw(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SM(playerid, COLOR_SYNTAX, "Usage: /bwithdraw [amount] ($%i available)", BusinessInfo[businessid][bCash]);
	}
	if(amount < 1 || amount > BusinessInfo[businessid][bCash])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	BusinessInfo[businessid][bCash] -= amount;
	GivePlayerCash(playerid, amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "** You have withdrawn $%i from the business vault. There is now $%i remaining.", amount, BusinessInfo[businessid][bCash]);
	return 1;
}
stock GetDynamicObjectModelID(objectid)
{
	new id=Streamer_GetIntData(0,objectid,E_STREAMER_MODEL_ID);
	return id;
}

stock IsValidObjectModel(model)
{
	static
		valid_model[] = //credits to Slice
		{
			0b11111111111011111110110111111110, 0b00000000001111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111110000000,
			0b11100001001111111111111111111111, 0b11110111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000001111000000111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111100011111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111011111, 0b11111111111111111111111101111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111100000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111010111101111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111001111111111111,
			0b11111111111111111111111111111111, 0b10000000000011111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111011111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111101011101111111111, 0b11111111111111111111111111110111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111110011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111100111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111011110111101111,
			0b10000000000000000000000000000000, 0b00000010000010000000010011111111,
			0b00000000001000000100000000000000, 0b11111111101101100101111000000000,
			0b01110000111111111111111111111011, 0b00000000001111111111111111000000,
			0b10011111110000000000001111001100, 0b11111111101111001100000000011110,
			0b00001110110111111100111111111111, 0b11111111111111111111111111001110,
			0b11111000000011111111111111111111, 0b11111111111111111110111101101011,
			0b01000000000000000111111101110111, 0b11010111111111111111000001111100,
			0b11110011111111111111111001111111, 0b01011111111111111111111111111111,
			0b01111110100001111011111010101011, 0b10001001010101100100001000010000,
			0b10100000000000000001010000101010, 0b00001000001111101010111100100000,
			0b11111111111111111111111010100001, 0b00000000011111111111110101111111,
			0b00001111111111111111110000111100, 0b11011110111111001111011011111011,
			0b11111111111001111111110011001110, 0b11111111111111111111111111111111,
			0b01111111111111111111111110111111, 0b01111000111111111111110111111111,
			0b00011100000000010000000000000111, 0b00001111111100001000000000000000,
			0b10101111001001110111110011111000, 0b01010101010101010110100000101011,
			0b01110111110101011111110100101001, 0b01111111111100101110111011111011,
			0b11111111111111111100101111001000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000011111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b00010100101000001111111111111111,
			0b11111111101111011111111111000000, 0b00111111111111111111111100000001,
			0b11110000000000000000000000000000, 0b00000101010101010111111111111111,
			0b11110010110111000011111010000000, 0b11111110111110000111110111010000,
			0b00000000000000011111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111000000, 0b11111111111111111111111111111111,
			0b11011111111111111111111111111111, 0b00000000000000000000000000000111,
			0b00000000000000000000000000000000, 0b11010111111000000000000000000000,
			0b10110011001000101111111111111111, 0b00011000010111010101011111010111,
			0b11011111111111111111010101111111, 0b11111111111111100000000000000011,
			0b11111111111111111111111111111111, 0b11111111111111111100000101111111,
			0b00000000000000000000000111111111, 0b00011000000001111000000000000000,
			0b11111111111111100111100000000100, 0b11110100011011111111110000000000,
			0b11111110001001111111110000000111, 0b11111111110110000100101010101000,
			0b11111111111111111100000000000000, 0b11111111111111111111111111111111,
			0b11101011111011110011111111111111, 0b11111111111111111111111111111111,
			0b00010001000001111100001111111111, 0b00100000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111101000000000000000000000000,
			0b11110001110101000001111111111111, 0b00000000000001101111010000010010,
			0b11111111111111111111111110000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11100001111100000111100000000000, 0b11100110011111111101011111111011,
			0b00000000000000000000000100111001, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000100110000101100111111001100,
			0b11111111111110000000000000000000, 0b00000000000001111111111111111111,
			0b11000001111111011100000110000000, 0b00000111111101111111111111111111,
			0b00000000001000011110000111010010, 0b00111000100111110011110000000000,
			0b00111111111110101000001001111110, 0b00000000000000100001111100000000,
			0b11111111111111111111111100000000, 0b01111111111111111111111111111111,
			0b01011100001111111110101111110111, 0b11100010111111100000000000111111,
			0b11011000011000110011100011111001, 0b01100110000011110001100000010000,
			0b00000111100000000000000000000100, 0b00010111111101100011100001101010,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111101111111000000000000000, 0b01111000000111100000000111111111,
			0b00000000011111110111111110111111, 0b11111111111111111111111111111111,
			0b00000000101001101111111111111111, 0b11111111111111111111111111111110,
			0b10100001000000111111111111111111, 0b11111111111111111111111111111011,
			0b00000000000000000000000000000011, 0b00000000000000100000000000000000,
			0b01110001111111010000000000010000, 0b11111101111101100011011111111111,
			0b10000000011111111111110101010111, 0b11011111100000010011001010110111,
			0b11010011101011111111111111111111, 0b10101010000010010000001111111000,
			0b11111000101111100000111110010110, 0b11111111100000000000000000000001,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111101111111111,
			0b11111111111111111111111111111111, 0b00000000000001111111111111111111,
			0b00111000000000010001000000000010, 0b00000000000011100000000000000000,
			0b00000000000000000000100000000000, 0b00000000000000000000000000000000,
			0b11110101000000000000000000000000, 0b00011111111000000101001000000111,
			0b11110000011110100011011101000000, 0b01111110111111111111111111111111,
			0b10101000000111110100101111011100, 0b11111111111111111111110000111010,
			0b00000000000000000000011111111111, 0b11111111111111111111111111111110,
			0b00001000111111111111111111111111, 0b00000000000000000000000000000000,
			0b00001111111110000000001111111101, 0b00111110000001111111101110100000,
			0b00001111111101111100011111000100, 0b11101010111101010011000111110000,
			0b11101010000000000000000111010001, 0b10001110110101100101000001110101,
			0b11000011111010101011111111111111, 0b11010110101111110000000000111111,
			0b00011111111111111111111111010100, 0b11111111111111111111111111111111,
			0b00111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10000000001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000111111111111111111,
			0b00000000000000000000000001000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00011111000000000000000000000000,
			0b00011111111111100111111111111111, 0b00000011111111111111111111111110,
			0b00000000000000000000000000000000, 0b00101100000110000000000000010000,
			0b11100000111110000000001000000000, 0b11111000000000011111111100000000,
			0b11010000111111101011111111111111, 0b11001101010100011100011101000011,
			0b11111111111101010011110011100111, 0b01000000000111111001101111111111,
			0b00000000111010111111110010000111, 0b11111111111000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111011110111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000001100000001111111111, 0b00000000000000000000000000000000,
			0b11100000000000000000000000000000, 0b00000000000000000000000000000001,
			0b11111111111111111111110000010000, 0b00000111111111111111111111111111,
			0b11111111111111111110100000000000, 0b11111111111111111111111110111111,
			0b00000011100001111111111111111111, 0b00000000001100000000000000000000,
			0b01100110001011010000000000000000, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000011111110,
			0b11111111110100000000000000000000, 0b00000000000000000111111111101011,
			0b01100000000000000000000110011100, 0b11111111111111111111111111101010,
			0b11111100000000000111111111111111, 0b00000000000000000000000001111111,
			0b11101111000000000000000000000000, 0b11111110111111111111111111111111,
			0b11111111111111111111011111111111, 0b11000000001000000000000011011001,
			0b11011111111111111111111111111111, 0b11100000011000000000011111111110,
			0b00000000001111100011111111111111, 0b00011110111111000000000000000000,
			0b11001111111100001001011111110100, 0b00110001110001111000011101011110,
			0b00000000000000000000000001110110, 0b11111111111111111100000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00111111111111111111111111111111,
			0b00000000000000000000000000000000, 0b11000000000000000000000000000000,
			0b00000000000000011111111111111111, 0b11101111111111110100001000000000,
			0b00001010000000001111111111111111, 0b00001100000110011000000000000000,
			0b01010011111111111111111111000000, 0b11000001111111111100000000000100,
			0b11111111111111111111111111111111, 0b11001111110000000000111111111111,
			0b11111111111111111111111111111111, 0b00001111111111111111111111011111,
			0b00000011100000000000111000100000, 0b11111111111111111110000000100000,
			0b11111111111001111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000000000000000011111111, 0b10000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111001111,
			0b00000000000000000111111000001111, 0b00000000000000000000000000000000,
			0b11110111100000000000000000000000, 0b00111111111100001011111111111111,
			0b10110111101010010000000000000000, 0b11010000111111110001011011101010,
			0b10000011100000101101001011010000, 0b11111111111110000100000010111101,
			0b11110011011111110100001100011111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000110011111111111111111,
			0b00001111100000000000000000000000, 0b10000000000000001011111010000000,
			0b11100100000001111000000000000000, 0b00000000000000000000000000000011,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00001110001111111101111001011011,
			0b00011110011000011100011000111100, 0b11000000001011111111111110010001,
			0b01111111111111111101101111111111, 0b00111111111111111010100001110010,
			0b01111111111000000100000001011000, 0b00000000001110000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000111000000000000000,
			0b01000001000100000011101000000001, 0b11001111100110110000000000111010,
			0b00000000000000000000000000000000, 0b11111000000000000100000000000000,
			0b01000000001000000001111110111111, 0b11111111111011100111000000000000,
			0b11111111111111111111111111111111, 0b00001111111111111111111111111111,
			0b11111111110000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111100001111,
			0b11111111111111111111111111111111, 0b01111111101111011111111111111111,
			0b00100001000000000000000000000010, 0b10110111011001100111011000001000,
			0b00000000001000000000000010000111, 0b10000100000000011000001111100000,
			0b00000000000000000000000000000100, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11010111111111111111111111111101, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111100000011111111111111111111,
			0b11111111111111111111111111110011, 0b11111111111111111111100011111111,
			0b11111111111111111000000111111111, 0b11111111111111000011111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111110111111111, 0b00000000111101111111111111101111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111100000000000000000,
			0b00000001111111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111000000011111110111111111, 0b11111111111111111111111111111111,
			0b11111111111111101111111111111111, 0b00000111111111111111111111111111,
			0b00001111111111111111111111111111, 0b01110100111101000100000111110000,
			0b10101000000000000000000000000001, 0b00000000111101000000000000000011,
			0b00000000111111000000000000000000, 0b00001001000111000000000000000000,
			0b00100010100000100000000000000000, 0b11111111111110001100000000100100,
			0b11111111111111111111111111111111, 0b01110000011101100011111001111010,
			0b11111000000000000000000000011110, 0b11000001111101100000111111111111,
			0b00000000011111111111111111101110, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111100000000,
			0b11111110001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01010111111111111111111111111111,
			0b01010101010101010101010101010101, 0b01010101000101010101010101010101,
			0b01010101010101010101010101010101, 0b10101010101010000101010101010101,
			0b01111010111111111111111111111010, 0b00000000111010101101100000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b10000000000000111100000000000000,
			0b11110000000000000000000000000101, 0b11111111111111111111111011111111,
			0b11111111111111111111111111111111, 0b11111101101101101100111111100001,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000000000000000011111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000101011000000000000, 0b01111011000000100000000000100000,
			0b11000011111111010000111111011000, 0b11111011100011110110111001111001,
			0b11001101111111110110000111100111, 0b00000101011110110000000001111110,
			0b11111111111111110000000000000000, 0b11111111110111111111111111111111,
			0b11111111111111111111111111111111, 0b00100011011111111111111111111111,
			0b00000000000000000000000000000001, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b00000000001111111111111111111111,
			0b00000000010000000000000000000001, 0b00000011100000000000000000000000,
			0b00000000000000000000001111101010, 0b11111111111111110000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10111111111111111111111111111111, 0b11111111111111111100111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111110011111111111, 0b11101111111111111111000111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11110000000001111111111111111111, 0b00001111111111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00100000000000000000000000000000
		};
	if (model > 19901)
	{
		return 0;
	}
	model -= 320;
	if (model < 0)
	{
		return 0;
	}
	return (valid_model[model >> 5] & (1 << (model & 0x1F)));//not sure what it returns but ****** could give me a hand here
}

CMD:checkobjs(playerid, params[])
{
	for(new i=0;i<CountDynamicObjects();i++)
	{
		new mdl =GetDynamicObjectModelID(i);
		if(!IsValidObjectModel(mdl)) printf("%d", mdl);
	}
 	return 1;
}

CMD:bdeposit(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SM(playerid, COLOR_SYNTAX, "Usage: /bdeposit [amount] ($%i available)", BusinessInfo[businessid][bCash]);
	}
	if(amount < 1 || amount > PlayerInfo[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
	}

	BusinessInfo[businessid][bCash] += amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	SM(playerid, COLOR_AQUA, "** You have deposited $%i in the business vault. There is now $%i available.", amount, BusinessInfo[businessid][bCash]);
	return 1;
}

CMD:sssssellbiz(playerid, params[])
{
	new businessid = GetNearbyBusinessEx(playerid), targetid, amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any business of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellbiz [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must specify an amount above zero.");
	}

	PlayerInfo[targetid][pBizOffer] = playerid;
	PlayerInfo[targetid][pBizOffered] = businessid;
	PlayerInfo[targetid][pBizPrice] = amount;

	SM(targetid, COLOR_AQUA, "** %s offered you their business for $%i (/accept business).", GetRPName(playerid), amount);
	SM(playerid, COLOR_AQUA, "** You have offered %s to buy your business for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:bizinfo(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid);

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any business of yours.");
	}

    SM(playerid, SERVER_COLOR, "Business ID %i:", businessid);
	SM(playerid, COLOR_GREY2, "(Value: $%i) - (Type: %s) - (Location: %s) - (Active: %s) - (Status: %s)", BusinessInfo[businessid][bPrice], bizInteriors[BusinessInfo[businessid][bType]][intType], GetZoneName(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]), (gettime() - BusinessInfo[businessid][bTimestamp] > 1209600) ? (""SVRCLR"No{C8C8C8}") : ("Yes"), (BusinessInfo[businessid][bLocked]) ? ("Closed") : ("Opened"));
	SM(playerid, COLOR_GREY2, "(Vault: $%i) - (Entry Fee: $%i) - (Products: %i)", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bProducts]);
	return 1;
}

CMD:businessmenu(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid);

    if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near any business that you own.");
	}
	ShowPlayerDialog(playerid, DIALOG_BIZMENU, DIALOG_STYLE_LIST, "Business Menu","Change Store Name\nChange Message\nSafe\nLock Business", "Select", "Cancel");
	return 1;
}
CMD:entryfee(playerid, params[])
{
	new businessid = GetNearbyBusinessEx(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /entryfee [amount]");
	}
	if(amount < 0 || amount > 5000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The entry fee can't be below $0 or above $3,000.");
	}

	BusinessInfo[businessid][bEntryFee] = amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
	SM(playerid, COLOR_AQUA, "** You have set the entry fee to $%i.", amount);
	return 1;
}

CMD:buyclothes(playerid) return callcmd::buy(playerid);
CMD:buy(playerid)
{
	new businessid = GetNearbyBusinessEx(playerid), title[64], string[1024];

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any business where you can buy stuff.");
	}
	if(BusinessInfo[businessid][bProducts] <= 0)
 	{
	 	return SendClientMessage(playerid, COLOR_SYNTAX, "This business is out of stock.");
   	}

	format(title, sizeof(title), "%s's %s (( %i Products ))", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

	switch(BusinessInfo[businessid][bType])
	{
	    case BUSINESS_STORE:
	    {
			format(string, sizeof(string), "Mobile Phone\t%s\nPortable Radio\t%s\nCigars\t%s\nSpraycans\t%s\nPhonebook\t%s\nCamera\t%s\nMP3 player\t%s\nFishing rod\t%s\nFish bait\t%s\nMuriatic acid\t%s\nBaking soda\t%s\nPocket watch\t%s\nGPS system\t%s\nRope\t%s\nBlindfold\t%s\nToolkit\t%s\nBackpack\t%s\nLottery Ticket\t%s\nRepair Kit\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]),
				FormatNumber(BusinessInfo[businessid][bPrices][5]),
				FormatNumber(BusinessInfo[businessid][bPrices][6]),
				FormatNumber(BusinessInfo[businessid][bPrices][7]),
				FormatNumber(BusinessInfo[businessid][bPrices][8]),
				FormatNumber(BusinessInfo[businessid][bPrices][9]),
				FormatNumber(BusinessInfo[businessid][bPrices][10]),
				FormatNumber(BusinessInfo[businessid][bPrices][11]),
				FormatNumber(BusinessInfo[businessid][bPrices][12]),
				FormatNumber(BusinessInfo[businessid][bPrices][13]),
				FormatNumber(BusinessInfo[businessid][bPrices][14]),
				FormatNumber(BusinessInfo[businessid][bPrices][15]),
				//FormatNumber(BusinessInfo[businessid][bPrices][16]),
				FormatNumber(BusinessInfo[businessid][bPrices][16]),
				FormatNumber(BusinessInfo[businessid][bPrices][17]),
				FormatNumber(BusinessInfo[businessid][bPrices][18]));

	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_GUNSHOP:
		{
			format(string, sizeof(string), "9mm Pistol\t%s\nBrass Knuckles\t%s\nBat\t%s\nKevlar(Half)\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]));

	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");

		}
		case BUSINESS_CLOTHES:
		{
			format(string, sizeof(string), "Clothes\t%s\nGlasses\t%s\nBandanas & Masks\t%s\nHats & Caps\t%s\nMisc Clothing\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]));
	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_GYM:
		{
			format(string, sizeof(string), "Normal\tFree\nBoxing\t%s\nKung Fu\t%s\nKneehead\t%s\nGrabkick\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]));

	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_MOBILE:
		{
			format(string, sizeof(string), "{ff1e1e}Airtle 5g\t%s\n{0049d2}Jio 5g\t%s\n{f4ff30}Idea 5G\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]));


	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");

		}
		case BUSINESS_RESTAURANT:
		{
			format(string, sizeof(string), "Water\t%s\nSprunk\t%s\nKid's Meal\t%s\nMedium Meal\t%s\nBig Meal\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]));

	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_BARCLUB:
		{
			format(string, sizeof(string), "Water\t%s\nSprunk\t%s\nBeer\t%s\nWine\t%s\nWhiskey\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]));

	        ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
	}
	return 1;
}

CMD:products(playerid, parmas[]) {

    new businessid = GetInsideBusiness(playerid), string[1024], title[64];
    if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near any business that you own.");
	}
	format(title, sizeof(title), "%s's %s (( %i Products ))", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);
	switch(BusinessInfo[businessid][bType])
	{
	    case BUSINESS_STORE:
	    {
			format(string, sizeof(string), "Mobile Phone\t%s\nPortable Radio\t%s\nCigars\t%s\nSpraycans\t%s\nPhonebook\t%s\nCamera\t%s\nMP3 player\t%s\nFishing rod\t%s\nFish bait\t%s\nMuriatic acid\t%s\nBaking soda\t%s\nPocket watch\t%s\nGPS system\t%s\nGasoline can\t%s\nRope\t%s\nBlindfold\t%s\nToolkit\t%s\nFlashlight\t%s\nLottery Ticket\t%s\nRepair Kit\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]),
				FormatNumber(BusinessInfo[businessid][bPrices][5]),
				FormatNumber(BusinessInfo[businessid][bPrices][6]),
				FormatNumber(BusinessInfo[businessid][bPrices][7]),
				FormatNumber(BusinessInfo[businessid][bPrices][8]),
				FormatNumber(BusinessInfo[businessid][bPrices][9]),
				FormatNumber(BusinessInfo[businessid][bPrices][10]),
				FormatNumber(BusinessInfo[businessid][bPrices][11]),
				FormatNumber(BusinessInfo[businessid][bPrices][12]),
				FormatNumber(BusinessInfo[businessid][bPrices][13]),
				FormatNumber(BusinessInfo[businessid][bPrices][14]),
				FormatNumber(BusinessInfo[businessid][bPrices][15]),
				//FormatNumber(BusinessInfo[businessid][bPrices][16]),
				FormatNumber(BusinessInfo[businessid][bPrices][16]),
				FormatNumber(BusinessInfo[businessid][bPrices][17]),
				FormatNumber(BusinessInfo[businessid][bPrices][18]),
				FormatNumber(BusinessInfo[businessid][bPrices][19]));

	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_GUNSHOP:
		{
			format(string, sizeof(string), "9mm Pistol\t%s\nBrass Knuckles\t%s\nBat\t%s\nKevlar(Half)\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]));

	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");

		}
		case BUSINESS_CLOTHES:
		{
			format(string, sizeof(string), "Clothes\t%s\nGlasses\t%s\nBandanas & Masks\t%s\nHats & Caps\t%s\nMisc Clothing\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]));
	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_GYM:
		{
			format(string, sizeof(string), "Normal\tFree\nBoxing\t%s\nKung Fu\t%s\nKneehead\t%s\nGrabkick\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]));

	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_MOBILE:
		{
			format(string, sizeof(string), "{ff1e1e}Airtel 5G\t%s\n{0049d2}Jio 5G\t%s\n{f4ff30}Idea 5G\t%s\n%s$ Pack - 2 Days Validity\t\n%s$ Pack - 4 Days Validity\t\n%s$ Pack - 6 Days Validity\t\n%s$ Pack - 8 Days Validity\t\n%s& Pack - 9 Days Validity\t\n%s$ Pack- 10 Days Validity\t",
					FormatNumber(BusinessInfo[businessid][bPrices][0]), // Airtel 5G price
					FormatNumber(BusinessInfo[businessid][bPrices][1]), // Jio 5G price
					FormatNumber(BusinessInfo[businessid][bPrices][2]), // Idea 5G price
					FormatNumber(BusinessInfo[businessid][bPrices][3]), // Price for 20 load
					FormatNumber(BusinessInfo[businessid][bPrices][4]), // Price for 30 load
					FormatNumber(BusinessInfo[businessid][bPrices][5]), // Price for 40 load
					FormatNumber(BusinessInfo[businessid][bPrices][6]), // Price for 50 load
					FormatNumber(BusinessInfo[businessid][bPrices][7]), // Price for 80 load
					FormatNumber(BusinessInfo[businessid][bPrices][8]) // Price for 100 load
			);
	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");

		}
		case BUSINESS_RESTAURANT:
		{
			format(string, sizeof(string), "Water\t%s\nSprunk\t%s\nKid's Meal\t%s\nMedium Meal\t%s\nBig Meal\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]));

	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
		case BUSINESS_BARCLUB:
		{
			format(string, sizeof(string), "Water\t%s\nSprunk\t%s\nBeer\t%s\nWine\t%s\nWhiskey\t%s",
				FormatNumber(BusinessInfo[businessid][bPrices][0]),
				FormatNumber(BusinessInfo[businessid][bPrices][1]),
				FormatNumber(BusinessInfo[businessid][bPrices][2]),
				FormatNumber(BusinessInfo[businessid][bPrices][3]),
				FormatNumber(BusinessInfo[businessid][bPrices][4]));

	        ShowPlayerDialog(playerid, DIALOG_EDITBUY, DIALOG_STYLE_TABLIST, title, string, "Select", "Cancel");
		}
	}
	return 1;
}

CMD:mark(playerid, params[])
{
	new slot;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /mark [slot (1-3)]");
	}
	if(!(1 <= slot <= 3))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
	}

	slot--;

	GetPlayerPos(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ]);
	GetPlayerFacingAngle(playerid, MarkedPositions[playerid][slot][mPosA]);

	MarkedPositions[playerid][slot][mInterior] = GetPlayerInterior(playerid);
	MarkedPositions[playerid][slot][mWorld] = GetPlayerVirtualWorld(playerid);

	SM(playerid, COLOR_AQUA, "** Position saved in slot %i.", slot + 1);
	return 1;
}

CMD:gotomark(playerid, params[])
{
	new slot;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotomark [slot (1-3)]");
	}
	if(!(1 <= slot <= 3))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot.");
	}
	if(MarkedPositions[playerid][slot-1][mPosX] == 0.0 && MarkedPositions[playerid][slot-1][mPosY] == 0.0 && MarkedPositions[playerid][slot-1][mPosZ] == 0.0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no position in the slot selected.");
	}

	slot--;

	GameTextForPlayer(playerid, "~w~Loading objects...", 5000, 1);

	TeleportToCoords(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ], MarkedPositions[playerid][slot][mPosA], MarkedPositions[playerid][slot][mInterior], MarkedPositions[playerid][slot][mWorld], true);
	SetCameraBehindPlayer(playerid);

	return 1;
}


CMD:createdoor(playerid, params[]) { return callcmd::createentrance(playerid, params); }
CMD:createentrance(playerid, params[])
{
	new name[40], Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[40]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createentrance [name]");
	}
	if(GetNearbyEntrance(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is an entrance in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	for(new i = 0; i < MAX_ENTRANCES; i ++)
	{
	    if(!EntranceInfo[i][eExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO entrances (name, pos_x, pos_y, pos_z, pos_a, outsideint, outsidevw) VALUES('%e', '%f', '%f', '%f', '%f', %i, %i)", name, x, y, z, a - 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateEntrance", "iisffff", playerid, i, name, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_SYNTAX, "Entrance slots are currently full. Ask the developer to increase the internal limit.");
	return 1;
}

CMD:editdoor(playerid, params[]) { return callcmd::editentrance(playerid, params); }
CMD:editentrance(playerid, params[])
{
	new entranceid, option[14], param[64];

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[64]", entranceid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Outside, Inside, Name, Icon, World, Owner, Locked, Radius, AdminLevel");
		SendClientMessage(playerid, COLOR_WHITE, "Available options: Faction, VIP, Vehicles, Freeze, Label, Password, Mapicon, Color");
	    return 1;
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid entrance.");
	}

	if(!strcmp(option, "outside", true))
	{
	    GetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
	    GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);

	    EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
	    EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], EntranceInfo[entranceid][ePosA], EntranceInfo[entranceid][eOutsideInt], EntranceInfo[entranceid][eOutsideVW], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the exterior of entrance %i.", entranceid);
	}
	else if(!strcmp(option, "inside", true))
	{
	    GetPlayerPos(playerid, EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ]);
	    GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][eIntA]);

	    EntranceInfo[entranceid][eInterior] = GetPlayerInterior(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ], EntranceInfo[entranceid][eIntA], EntranceInfo[entranceid][eInterior], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the interior of entrance %i.", entranceid);
	}
	else if(!strcmp(option, "name", true))
	{
	    new name[32];

	    if(sscanf(param, "s[32]", name))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [name] [text]");
		}

		strcpy(EntranceInfo[entranceid][eName], name, 32);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET name = '%e' WHERE id = %i", EntranceInfo[entranceid][eName], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the name of entrance %i to '%s'.", entranceid, name);
	}
	else if(!strcmp(option, "icon", true))
	{
	    new iconid;

	    if(sscanf(param, "i", iconid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [icon] [iconid (19300 = hide)]");
		}
		if(!IsValidModel(iconid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid model ID.");
		}

		EntranceInfo[entranceid][eIcon] = iconid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET iconid = %i WHERE id = %i", EntranceInfo[entranceid][eIcon], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the pickup icon model of entrance %i to %i.", entranceid, iconid);
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [world] [vw]");
		}

		EntranceInfo[entranceid][eWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET world = %i WHERE id = %i", EntranceInfo[entranceid][eWorld], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the virtual world of entrance %i to %i.", entranceid, worldid);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(!isnull(param) && !strcmp(param, "none", true))
		{
 			SetEntranceOwner(entranceid, INVALID_PLAYER_ID);
	    	return SM(playerid, COLOR_AQUA, "** You've reset the owner of entrance %i.", entranceid);
		}
		if(sscanf(param, "u", targetid))
	    {
	        return SM(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [owner] [playerid/none]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
		}
		if(!PlayerInfo[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
		}

        SetEntranceOwner(entranceid, targetid);
	    SM(playerid, COLOR_AQUA, "** You've changed the owner of entrance %i to %s.", entranceid, GetRPName(targetid));
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [locked] [0/1]");
		}

		EntranceInfo[entranceid][eLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[entranceid][eLocked], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the lock state of entrance %i to %i.", entranceid, locked);
	}
	else if(!strcmp(option, "radius", true))
	{
	    new Float:radius;

	    if(sscanf(param, "f", radius))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [radius] [range]");
		}
		if(!(1.0 <= radius <= 20.0))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "The entry radius must range between 1.0 and 20.0.");
		}

		EntranceInfo[entranceid][eRadius] = radius;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET radius = '%f' WHERE id = %i", EntranceInfo[entranceid][eRadius], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the entry radius of entrance %i to %.1f.", entranceid, radius);
	}
	else if(!strcmp(option, "adminlevel", true))
	{
	    new level;

	    if(sscanf(param, "i", level))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [adminlevel] [level]");
		}
		if(!(0 <= level <= 7))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid level. Valid levels range from 0 to 7.");
		}

		EntranceInfo[entranceid][eAdminLevel] = level;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET adminlevel = %i WHERE id = %i", EntranceInfo[entranceid][eAdminLevel], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the admin level of entrance %i to %i.", entranceid, level);
	}
	else if(!strcmp(option, "faction", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [faction] [type]");
	        SendClientMessage(playerid, COLOR_GREY2, "List of types: (0) None (1) Police (2) Medic (3) News (4) Government (5) Hitman (6) Federal (7) Mechanic (8) Terrorist (9) Army (10) JailGuard");
	        SendClientMessage(playerid, COLOR_GREY2, "List of types: (11) NPolice (12) EMS");
	        return 1;
		}
		if(!(0 <= type <= 12))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid type.");
		}

		EntranceInfo[entranceid][eFactionType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET factiontype = %i WHERE id = %i", EntranceInfo[entranceid][eFactionType], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(type == FACTION_NONE)
		    SM(playerid, COLOR_AQUA, "** You've reset the faction type of entrance %i.", entranceid);
		else
	    	SM(playerid, COLOR_AQUA, "** You've changed the faction type of entrance %i to %s (%i).", entranceid, factionTypes[type], type);
	}
	else if(!strcmp(option, "vip", true))
	{
	    new rankid;

	    if(sscanf(param, "i", rankid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [vip] [rankid]");
	        SendClientMessage(playerid, COLOR_GREY2, "List of ranks: (0)None (1) Gold (2) Diamond (3) Platinum");
	        return 1;
		}
		if(!(0 <= rankid <= 3))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid VIP rank.");
		}

		EntranceInfo[entranceid][eVIP] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET vip = %i WHERE id = %i", EntranceInfo[entranceid][eVIP], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the VIP rank of entrance %i to {C2A2DA}%s{CCFFFF} (%i).", entranceid, GetDonatorRank(rankid), rankid);
	}
	else if(!strcmp(option, "vehicles", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [vehicles] [0/1]");
		}

		EntranceInfo[entranceid][eVehicles] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET vehicles = %i WHERE id = %i", EntranceInfo[entranceid][eVehicles], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SM(playerid, COLOR_AQUA, "** You've allowed vehicle entry for entrance %i.", entranceid);
		else
		    SM(playerid, COLOR_AQUA, "** You've disallowed vehicle entry for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "freeze", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [freeze] [0/1]");
		}

		EntranceInfo[entranceid][eFreeze] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET freeze = %i WHERE id = %i", EntranceInfo[entranceid][eFreeze], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SM(playerid, COLOR_AQUA, "** You've enabled freeze & object loading for entrance %i.", entranceid);
		else
		    SM(playerid, COLOR_AQUA, "** You've disabled freeze & object loading for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "label", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [label] [0/1]");
		}

		EntranceInfo[entranceid][eLabel] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET label = %i WHERE id = %i", EntranceInfo[entranceid][eLabel], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SM(playerid, COLOR_AQUA, "** You've enabled the 3D text label for entrance %i.", entranceid);
		else
		    SM(playerid, COLOR_AQUA, "** You've disabled the 3D text label for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "password", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [password] [text ('none' to reset)]");
		}

		strcpy(EntranceInfo[entranceid][ePassword], param, 64);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET password = '%e' WHERE id = %i", EntranceInfo[entranceid][ePassword], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the password of entrance %i to '%s'.", entranceid, param);
	}
	else if(!strcmp(option, "mapicon", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editentrance [entranceid] [mapicon] [type (0-63)]");
		}
		if(!(0 <= type <= 63))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid map icon.");
		}

		EntranceInfo[entranceid][eMapIcon] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET mapicon = %i WHERE id = %i", EntranceInfo[entranceid][eMapIcon], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SM(playerid, COLOR_AQUA, "** You've changed the map icon of entrance %i to %i.", entranceid, type);
	}

	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [color] [0xRRGGBBAA]");
		}

		EntranceInfo[entranceid][eColor] = (color & ~0xFF) | 0xFF;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET color = %i WHERE id = %i", EntranceInfo[entranceid][eColor], EntranceInfo[entranceid][eID]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
		SM(playerid, COLOR_AQUA, "** You have set the {%06x}color{33CCFF} of entrance ID %i.", color >>> 8, entranceid);
	}

	return 1;
}
stock IsaApple(playerid)
{
    new Float:playerPos[3];
    GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

    
    for(new i = 0; i < 14; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2, AllFruit[i][0], AllFruit[i][1], AllFruit[i][2]))
            return true;
    }

    return false;
}

