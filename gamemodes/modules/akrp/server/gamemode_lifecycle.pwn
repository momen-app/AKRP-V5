public OnGameModeInit()
{
	Module_Bootstrap();
	Module_StartAll();

	if(Module_IsEnabled(MODULE_MAPPINGS))
	{
		LoadMappings();
	}

	connectionID = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE);
	if(mysql_errno(connectionID))
	{
	    print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
        print("Unable to establish a connection with the MySQL server...");
	    SendRconCommand("exit");
	    return 0;
	}
	
	Profiler_Start();
	Create3DTextLabel("[SIGNAL JOB]\n{FFFF00}Press{FF00FF}[N] to Start.", COLOR_YELLOW,1991.694824,-1991.433837,13.546875, 20.0, 0);
    Create3DTextLabel("[SIGNAL JOB]\n{FFFF00}Press{FF00FF}[N] to Finish.", COLOR_YELLOW, 1983.651000, -1983.395996, 13.546875, 20.0, 0);


    for(new i; i < MAX_VEHICLES; i++) for(new x; x < OILEXPO_LIMIT; x++) OilExpoObjects[i][x] = -1;
	for(new i; i < MAX_VEHICLES; i++) for(new x; x < WHEAT_LIMIT; x++) WheatObjects[i][x] = -1;
	for(new i; i < MAX_VEHICLES; i++) for(new x; x < OILEXPO_LIMIT; x++) FruitBoxObjects[i][x] = -1;
    radioConnectionID = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, "shoutcast");
    CreateDynamicObject(2991, -2250.820068, -2316.830078, 28.776199, 1.399900, 0.099900, -36.182800,-1,-1,-1, 300.000000, 1000.0, -1, 0);
	if(mysql_errno(radioConnectionID))
	{
	    print("Couldn't connect to radio station database... server will continue to operate normally.");
	    radioConnectionID = MYSQL_INVALID_HANDLE;
	}
	OtherRobberyInfo[rCarTime] = 0;
	OtherRobberyInfo[rHousetime] = 0;
	OtherRobberyInfo[rStoreTime] = 0;

    for(new i = 0; i < MAX_VEHICLES; i ++)
	{
	    ResetVehicle(i);
	}
	mysql_tquery(connectionID, "TRUNCATE TABLE shots");
	mysql_tquery(connectionID, "SELECT * FROM atms", "OnQueryFinished", "ii", THREAD_LOAD_ATMS, 0);
	mysql_tquery(connectionID, "SELECT * FROM houses", "OnQueryFinished", "ii", THREAD_LOAD_HOUSES, 0);
	mysql_tquery(connectionID, "SELECT * FROM factionlockers", "OnQueryFinished", "ii", THREAD_LOAD_LOCKERS, 0);
	mysql_tquery(connectionID, "SELECT * FROM ganggarage", "OnQueryFinished", "ii", THREAD_LOAD_GGARAGE, 0);
	mysql_tquery(connectionID, "SELECT * FROM publicgarage", "OnQueryFinished", "ii", THREAD_LOAD_PGARAGE, 0);
	mysql_tquery(connectionID, "SELECT * FROM furniture", "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, 0);
	mysql_tquery(connectionID, "SELECT * FROM garages", "OnQueryFinished", "ii", THREAD_LOAD_GARAGES, 0);
	mysql_tquery(connectionID, "SELECT * FROM graffiti", "Graffiti_Load", "");
	mysql_tquery(connectionID, "SELECT * FROM businesses", "OnQueryFinished", "ii", THREAD_LOAD_BUSINESSES, 0);
	mysql_tquery(connectionID, "SELECT * FROM entrances", "OnQueryFinished", "ii", THREAD_LOAD_ENTRANCES, 0);
	mysql_tquery(connectionID, "SELECT * FROM factions", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONS, 0);
	mysql_tquery(connectionID, "SELECT * FROM factionranks", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONRANKS, 0);
	mysql_tquery(connectionID, "SELECT * FROM factionskins", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONSKINS, 0);
    mysql_tquery(connectionID, "SELECT * FROM factionpay", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONPAY, 0);
    mysql_tquery(connectionID, "SELECT * FROM divisions", "OnQueryFinished", "ii", THREAD_LOAD_DIVISIONS, 0);
    mysql_tquery(connectionID, "SELECT * FROM lands", "OnQueryFinished", "ii", THREAD_LOAD_LANDS, 0);
    mysql_tquery(connectionID, "SELECT * FROM landobjects", "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, 0);
    mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE ownerid = 0", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);
    mysql_tquery(connectionID, "SELECT * FROM gangs", "OnQueryFinished", "ii", THREAD_LOAD_GANGS, 0);
    mysql_tquery(connectionID, "SELECT * FROM gangranks", "OnQueryFinished", "ii", THREAD_LOAD_GANGRANKS, 0);
	mysql_tquery(connectionID, "SELECT * FROM gangskins", "OnQueryFinished", "ii", THREAD_LOAD_GANGSKINS, 0);
	mysql_tquery(connectionID, "SELECT * FROM points", "OnQueryFinished", "ii", THREAD_LOAD_POINTS, 0);
	mysql_tquery(connectionID, "SELECT * FROM turfs", "OnQueryFinished", "ii", THREAD_LOAD_TURFS, 0);
	mysql_tquery(connectionID, "SELECT * FROM `gates`", "Gate_Load", "");
	mysql_tquery(connectionID, "SELECT * FROM `vendors`", "Vendor_Load", "");
	mysql_tquery(connectionID, "SELECT * FROM `object`", "Object_Load", "");
	mysql_tquery(connectionID, "SELECT * FROM `dropped`", "Dropped_Load", "");
	loadAntiCheatSettings();
	LoadSafeZones();
    switch(random(4))
	{
	    case 0: gWeather = 3;
	    case 1: gWeather = 3;
	    case 2: gWeather = 3;
	    case 3: gWeather = 3;
	}

	for(new x=0; x<MAX_VEHICLES; x++)
	{
		Flasher[x] = 0;
		FlasherState[x] = 0;
	}

	SetWeather(gWeather);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	ManualVehicleEngineAndLights();
	SetDamageFeed(true);
	SetDamageSounds(0, 0);
	SetVehicleUnoccupiedDamage(false);
	SetVehiclePassengerDamage(true);
	SetDisableSyncBugs(true);
	ShowNameTags(true);
	DisableNameTagLOS();

    whitelist_log = DCC_FindChannelById("1203596343113818164"); // Discord channel ID
    announce_log = DCC_FindChannelById("1241236082469638242"); // Discord channel ID
    admin_log = DCC_FindChannelById("1145199737381863576"); // Discord channel ID
	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 1000);
	gDoubleXP = false;
	gDoubleSalary = false;
	gRobbery = false;

	// CCTV's (10 MAX)
	AddCCTV("LS Grovestreet", 2491.7839, -1666.6194, 46.3232, 0.0);
	AddCCTV("LS Downtown", 1102.6440, -837.8973, 122.7000, 180.0);
	AddCCTV("SF Wang Cars", -1952.4282,285.9786,57.7031, 90.0);
	AddCCTV("SF Airport", -1275.8070, 52.9402, 82.9162, 0.0);
	AddCCTV("SF Crossroad", -1899.0861,731.0627,65.2969, 90.0);
	AddCCTV("SF Tower", -1753.6606,884.7520,305.8750, 150.0);
	AddCCTV("LV The Strip 1", 2137.2390, 2143.8286, 30.6719, 270.0);
	AddCCTV("LV The Strip 2", 1971.7627, 1423.9323, 82.1563, 270.0);
    AddCCTV("Mount Chiliad", -2432.5852, -1620.1143, 546.8554, 270.0);
	AddCCTV("Sherman Dam", -702.9260, 1848.8094, 116.0507, 0.0);
	AddCCTV("Desert", 35.1291, 2245.0901, 146.6797, 310.0);
	AddCCTV("Query", 588.1079,889.4715,-14.9023, 270.0);
	AddCCTV("Mining", -176.6037,2302.3025,39.6311, 90.0);

	//spec 
	//CreateTextDraws();

	TD = TextDrawCreate(160, 400, "~y~Keys:~n~Arrow-Keys: ~w~Move The Camera~n~~y~Sprint-Key: ~w~Speed Up~n~~y~Crouch-Key: ~w~Exit Camera");
    TextDrawLetterSize(TD, 0.4, 0.9);
    TextDrawSetShadow(TD, 0);
    TextDrawUseBox(TD,1);
	TextDrawBoxColour(TD,0x00000055);
	TextDrawTextSize(TD, 380, 400);

    jailarea = CreateDynamicRectangle(926.048, -1689.75 , 958.605, -1623.15);
	new Count, Left = TotalCCTVS;
	for(new menu; menu<MAX_CCTVMENUS; menu++)
	{
	    if(Left > 12)
	    {
	        CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
	        TotalMenus++;
	        MenuType[menu] = 1;
	        for(new i; i<11; i++)
	        {
	        	AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
	        	Count++;
	        	Left--;
			}
			AddMenuItem(CCTVMenu[menu], 0, "Next");
		}
		else if(Left<13 && Left > 0)
		{
		    CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
		    TotalMenus++;
		    MenuType[menu] = 2;
		    new tmp = Left;
	        for(new i; i<tmp; i++)
	        {
	        	AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
	        	Count++;
	        	Left--;
			}
		}
	}
	/*-----------------------------*/


	//signal job

	CreatePickup(1275, 23, 1991.694824,-1991.433837,13.546875, 0);

	ladder[0] = CreateDynamicObject(1437, 611.634399, -1783.442260, 14.364824, 40.000000, 0.000000, 257.000000, -1, -1, -1, 300.00, 300.00);
	ladder[1] = CreateDynamicObject(1437, 927.450378, -1415.378173, 13.619938, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
	ladder[2] = CreateDynamicObject(1437, 1971.078002, -1824.256713, 13.746875, -20.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	ladder[3] = CreateDynamicObject(1437, 2177.941406, -1730.876098, 13.675001, -20.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	ladder[4] = CreateDynamicObject(1437, 849.167724, -1038.856933, 25.906068, -20.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);


	for(new i = 0; i < sizeof(comservpoint); i ++)
	{
		CreateDynamicPickup(19132, 1, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2]);
		CreateDynamic3DTextLabel("Community Service\n"SVRCLR"(( Type '/clean' to start cleaning. ))", COLOR_GREY, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2], 10.0);
	}
	CreateDynamic3DTextLabel("Car Robbery\n{FF0000}(({006400}/robcar {FF0000}to start robbery)).", COLOR_BLUE, 1698.923461, -2094.260987, 13.546875+ 0.4, 15.0);
	CreateDynamicPickup(1316, 1, 1698.923461, -2094.260987, 13.546875);

	CreateDynamic3DTextLabel("Insurance\nCost: $5000\n"SVRCLR"(( Type '/buyinsurance' to spawn here. ))", COLOR_DOCTOR, 204.8622,1883.6208,369.3091, 10.0);
	CreateDynamicPickup(1240, 1,  2258.595214, -1665.695312, 3001.085937);

	CreateDynamic3DTextLabel("BigBank Vault\nType [/robbigbank] To start robbery",COLOR_YELLOW,1729.803710, -1109.414794, 26.684938+0.6,4.0);
	CreateDynamicPickup(1550, 1, 1729.803710, -1109.414794, 26.684938);

    Create3DTextLabel("Food Shop \n [N]", COLOR_GREEN, 722.189758, -1773.703247, 2.742840, 16.0, 0, 0);
	CreatePickup(2641, 23, 722.189758, -1773.703247, 2.742840);
   
   
    CreateDynamic3DTextLabel("Paintball arena\n/enter to play paintball!", COLOR_YELLOW, 1395.1077, -1385.9746, 13.5547, 10.0);
	CreateDynamicPickup(1254, 1, 1395.1077, -1385.9746, 13.5547);

    // Materials Pickup 1
	CreateDynamic3DTextLabel("Materials\nCost: $75\n"SVRCLR"(( Type '/getmats' to begin. ))", COLOR_GREY, 1421.6913, -1318.4719, 13.5547, 10.0);
	CreateDynamicPickup(1575, 1, 1421.6913, -1318.4719, 13.5547);

	CreateDynamic3DTextLabel("Loading Dock\n"SVRCLR"(( Type '/loadtruck' and pick a load to begin delivery. ))", COLOR_GREY, 2460.9790,-2119.2590,13.5530, 10.0);
	CreateDynamicPickup(1239, 1, 2460.9790,-2119.2590,13.5530);


	CreateDynamic3DTextLabel("Drivers Test\nCost: $100\n"SVRCLR"(( Type '/taketest' to begin. ))\n"GREEN"(( Type '/releasecar' to release your impounded car ))", COLOR_GREY, 1824.496704, -1426.201660, 13.655930, 10.0);
	CreateDynamicPickup(1239, 1, 1824.496704, -1426.201660, 13.655930);
	
	CreateDynamic3DTextLabel(""GREEN"Impound"WHITE"\n{FFFFFF}Type /impound to impound a vehicle.", COLOR_YELLOW, 1596.938964, -1614.594482, 13.429326, 10.0);
	CreateDynamicPickup(1239, 1, 1596.938964, -1614.594482, 13.429326);

	CreateDynamic3DTextLabel(""GREEN"Impound"WHITE"\n{FFFFFF}Type /impound to impound a vehicle.", COLOR_YELLOW, -17.6671,-2532.2358,36.6484, 10.0);
	CreateDynamicPickup(1239, 1, -17.6671,-2532.2358,36.6484);

	CreateDynamic3DTextLabel(""GREEN"Impound"WHITE"\n{FFFFFF}Type /impound to impound a vehicle.", COLOR_YELLOW, 1027.9797,1791.9083,10.8203, 10.0);
	CreateDynamicPickup(1239, 1, 1027.9797,1791.9083,10.8203);

    CreateDynamic3DTextLabel("Oil Exporter\n(( Type '/oilstake' to start the collecting the oil ))", COLOR_AQUA, 564.392517, 1319.291625, 10.115003, 10.0);

    CreateDynamic3DTextLabel("Bank\n"SVRCLR"(( Type '[/bankhelp]' for more help. ))", COLOR_GREY, 1727.616455, -1129.108032, 24.095937, 10.0);
	CreateDynamicPickup(1239, 1, 1727.616455, -1129.108032, 24.095937);

	CreateDynamic3DTextLabel("Akrp Dealership\n"SVRCLR"(( Type '/buyvehicle Or press [N]' to view catalog. '/buyrentvehicle' for rent))", COLOR_GREY, 1494.339599, 760.679687, 11.130325, 10.0);
	CreateDynamicPickup(1274, 1, 1494.339599, 760.679687, 11.130325);

    CreateDynamicPickup(19134, 1, 1481.073242, -1768.236450, 18.810064);
	CreateDynamic3DTextLabel(""GREEN"JOB CENTER\n [ Y ] ",0xDABB3EAA, 1481.073242, -1768.236450, 18.810064, 15);
	CreateDynamic3DTextLabel(""GREEN" VOTE\n [ Y ] OR /vote",0xDABB3EAA, 1940.144287, -1825.208007, 13.586874, 15);
    CreateDynamic3DTextLabel(""GREEN" VOTE\n [ Y ] OR /vote",0xDABB3EAA, 1940.153442, -1823.597045, 13.586874, 15);
	
	CreateDynamic3DTextLabel("Black Market\n"SVRCLR"(( Type '/blackmarket' to view the itemlist. ))", COLOR_GREY, 2076.083007, -1588.446655, 13.491114, 10.0);

    CreateDynamic3DTextLabel("Public Locker\nOwned By Public\n"GREEN"["WHITE"unlocked]"GREEN"", COLOR_WHITE, 1033.212890, -1982.294921, 13.242181, 11.88);
    CreateDynamicPickup(1314, 1, 1033.212890, -1982.294921, 13.242181); //spawn
    
    CreateDynamic3DTextLabel("Public Locker\nOwned By Public\n"GREEN"["WHITE"unlocked]"GREEN"", COLOR_WHITE, 333.316040, -1802.997680, 6.939134, 11.88);
    CreateDynamicPickup(1314, 1, 333.316040, -1802.997680, 6.939134); //spawn




	CreateDynamic3DTextLabel("Name Changes\nCost: $5,000 per level\n"SVRCLR"(( Type '/changename' to request one. ))\n(( Type '/buylevel and '/upgrade' to upgrade. ))\n(([/changename] = $5,000 Per Level))\n(([/upgrade] = $15,000 Per Upgrade))", COLOR_GREY, 1483.496459, -1768.248901, 18.810064, 10.0);
	CreateDynamicPickup(1239, 1, 1483.496459, -1768.248901, 18.810064);

    Create3DTextLabel("/getdrug ", COLOR_YELLOW, -1009.370605, -972.158630, 133.949142, 16.0, 0, 0);
    ActorJob[0] = CreateActor(159, -1009.370605, -972.158630, 133.949142, 17.76);
    
    Create3DTextLabel("/loadsandal of press [n]", COLOR_YELLOW, -545.220642, -188.894531, 78.406250, 16.0, 0, 0);

	Create3DTextLabel(" Press [HORN] to Repair", COLOR_LIGHTBLUE, 1087.855957, -1363.594116, 13.714235, 20.0, 0, 0);
    CreateDynamicMapIcon(1087.855957, -1363.594116, 13.714235, 27, 1, -1, -1, -1, 500000000.0);
    
    CreateDynamicMapIcon(1112.057617, -1304.383300, 13.944063 , 10, 1, -1, -1, -1, 500000000.0);
    Create3DTextLabel("7/11 \n [N] \n /robstore to rob", COLOR_BLUE, 1112.057617, -1304.383300, 13.944063, 16.0, 0, 0);
    Create3DTextLabel("{FF12FF}[FRUIT-PICKER]\n{FFFFFF}[N]", COLOR_YELLOW, -2252.951416, -2317.525634, 29.305549, 16.0, 0, 0);
	CreateActor(159, -2254.117675, -2313.822998, 29.200664, 117.10);
    Create3DTextLabel("[FRUIT PICKER]\n{FFFF00}Press{FF00FF}[N] {FFFF00}to Start", COLOR_YELLOW,-2254.117675, -2313.822998, 29.200664, 20.0, 0);
    CreateDynamic3DTextLabel("blackmarket\n {FFFFFF}/blackmarket to purchase illegal items.", COLOR_YELLOW, -403.169830, 1232.469482, 6.631836, 10.0);
	CreateDynamic3DTextLabel("Press [Y] to take Route.", COLOR_WHITE, 1700.740966, -1539.446777, 13.382812, 10.0);
	
	  //  medic
    CreateDynamic3DTextLabel(""TEAL"["GREEN"Faction Garage"TEAL"]"WHITE"\nPress "RED"'[Y]'"WHITE" to spawn a vehicle.", COLOR_TEAL, 1760.675659, -1675.778320, 13.558287 + 0.4, 20.0);
    CreateDynamicPickup(1316, 1, 1760.675659, -1675.778320, 13.558287);  //spawn

    CreateDynamic3DTextLabel(""TEAL"["GREEN"Faction Garage"TEAL"]"WHITE"\nType "RED"'[/fd]'"WHITE" to despawn a vehicle.", COLOR_TEAL, 1759.596313, -1661.407592, 13.556706  + 0.4, 20.0);
    CreateDynamicPickup(1316, 1, 1759.596313, -1661.407592, 13.556706); //despawn
    
    //pd
    
	CreateDynamic3DTextLabel(""TEAL"["GREEN"Faction Garage"TEAL"]"WHITE"\nPress "RED"'[Y]'"WHITE" to spawn a vehicle.", COLOR_TEAL,1579.525878, -1654.947998, 16.202812 + 0.4, 20.0);
    CreateDynamicPickup(1316, 1, 1579.525878, -1654.947998, 16.202812); //spawn

    CreateDynamic3DTextLabel(""TEAL"["GREEN"Faction Garage"TEAL"]"WHITE"\nType "RED"'[/fd]'"WHITE" to despawn a vehicle.", COLOR_TEAL, 1602.160278, -1657.790283, 16.202812 + 0.4, 20.0);
    CreateDynamicPickup(1316, 1, 1602.160278, -1657.790283, 16.202812); //despawn

	
	CreateDynamic3DTextLabel("NEWBIE INFORMATION:\n"SVRCLR"(( Type '/newbinfo' for more information. ))", COLOR_GREY, 1564.5627,-2248.6436,13.5469, 18.0); // 2
     
    Create3DTextLabel(" Press [H] to Illegal Revive", COLOR_WHITE, 2374.585204, 1958.628662, 6.455604, 16.0, 0, 0);
    Create3DTextLabel(" Press [H] to Illegal Revive", COLOR_WHITE, -1289.585204, 490.628662, 11.455604, 16.0, 0, 0);
    Create3DTextLabel(" Press [H] to Illegal Revive", COLOR_WHITE, -348.081176, -1046.802734, 59.812500, 16.0, 0, 0);
    Create3DTextLabel(" Press [N] to Buy Dress", COLOR_WHITE, 609.618225, -1520.496215, 15.205955, 16.0, 0, 0);

    Create3DTextLabel("Materials Crafing Area\n /craftgun ", COLOR_LIGHTBLUE, -225.547302, 1077.088378, 19.742187, 16.0, 0, 0);
    CreateDynamicMapIcon(-225.547302, 1077.088378, 19.742187, 18, 1, -1, -1, -1, 500000000.0);
    
    CreateDynamic3DTextLabel("Flower Area\n"SVRCLR" [N] ", COLOR_YELLOW, 1561.992919, 1667.608237, 700.968017, 10.0);
	CreateDynamic3DTextLabel("Flower Dry Area\n"SVRCLR" [N] ", COLOR_YELLOW, 1555.256591, 1709.114624, 700.968017, 10.0);
	CreateDynamic3DTextLabel(" Cocaine Packing Area\n"SVRCLR" [N] ", COLOR_BLUE, 1542.924194, 1667.241088, 700.968017, 10.0);
	
    gParachutes[0] = CreateDynamicPickup(371, 1, 1542.9038, -1353.0352, 329.4744); // Star tower
	gParachutes[1] = CreateDynamicPickup(371, 1, 315.9415, 1010.6052, 1953.0031); // Andromada interior

	//PAWNSHOP
	PAWNSHOP = CreateActor(150, 81.9193, 2504.4148, 2001.0847, 181.0000);// PAWNSHOP ACTOR
	ApplyActorAnimation(PAWNSHOP, "PED", "IDLE_CHAT", 4.1, true, true, true, true, true);
	SetActorInvulnerable(PAWNSHOP, true);

	//CITYHALL
	CITYHALL = CreateActor(120, 1481.337646, -1770.527465, 18.798063, 1.08);// CITYHALL ACTOR
	ApplyActorAnimation(CITYHALL, "PED", "IDLE_CHAT", 4.1, true, true, true, true, true);
	SetActorInvulnerable(CITYHALL, true);
	SetActorVirtualWorld(CITYHALL, 1);


  	//HOSPITAL ACTORS
  	HospitalActor[0] = CreateActor(308, 206.3796,1884.5804,369.3091,87.6164);// HOSPITAL ACTOR
    ApplyActorAnimation(HospitalActor[0], "MISC", "Seat_talk_01", 4.1, true, true, true, true, true);
  	SetActorInvulnerable(HospitalActor[0], true);
  	SetActorVirtualWorld(HospitalActor[0], 0);
  	
  	ActorJob[11] = CreateActor(156, 599.431640, 1248.960449, 11.718750, 199.88);// OilExpo ACTOR
	ApplyActorAnimation(ActorJob[11], "PED", "IDLE_CHAT", 4.1, true, true, true, true, true);
	SetActorInvulnerable(ActorJob[11], true);


  	HospitalActor[1] = CreateActor(308, 206.3796,1884.5804,369.3091,87.6164);// HOSPITAL ACTOR
    ApplyActorAnimation(HospitalActor[1], "MISC", "Seat_talk_01", 4.1, true, true, true, true, true);
  	SetActorInvulnerable(HospitalActor[1], true);
  	SetActorVirtualWorld(HospitalActor[1], 1);

  	HospitalActor[2] = CreateActor(308, 206.3796,1884.5804,369.3091,87.6164);// HOSPITAL ACTOR
    ApplyActorAnimation(HospitalActor[2], "MISC", "Seat_talk_01", 4.1, true, true, true, true, true);
  	SetActorInvulnerable(HospitalActor[2], true);
  	SetActorVirtualWorld(HospitalActor[2], 2);

  	HospitalActor[3] = CreateActor(308, 206.3796,1884.5804,369.3091,87.6164);// HOSPITAL ACTOR
    ApplyActorAnimation(HospitalActor[3], "MISC", "Seat_talk_01", 4.1, true, true, true, true, true);
  	SetActorInvulnerable(HospitalActor[3], true);
  	SetActorVirtualWorld(HospitalActor[3], 3);
  	
  	CreateDynamic3DTextLabel("GUNSHOP\n {FFFFFF}/buygun or Press[N] ", COLOR_YELLOW, 1301.185913, -1875.214599, 13.632812 , 10.0);

	for(new i = 0; i < sizeof(jobLocations); i ++)
	{
		if(!Job_IsEnabled(i))
		{
			continue;
		}

		new string[123];
	    format(string, sizeof(string), "%s\n"SVRCLR"(( Press '/join' OR [N] to get job. ))", jobLocations[i][jobName]);
	    CreateDynamic3DTextLabel(string, COLOR_GREY, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 10.0);
	}
	for(new i = 0; i < sizeof(washmoneyPoints); i ++)
	{
	    CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, washmoneyPoints[i][0], washmoneyPoints[i][1], washmoneyPoints[i][2], 7.0);
	    CreateDynamicPickup(1239, 1, washmoneyPoints[i][0], washmoneyPoints[i][1], washmoneyPoints[i][2]);
	}
// VIP Garage
	StaticObject[198] = CreateDynamicObject(10010,-4398.91894531,871.42370605,985.81781006,0.00000000,0.00000000,356.03002930); //object(ugcARPark_sfe) (1)
	CreateDynamicObject(7891,-4432.70019531,906.73614502,988.49066162,0.00000000,0.00000000,90.00000000); //object(vgwspry1) (2)
	CreateDynamicObject(7891,-4425.47021484,906.73535156,988.49066162,0.00000000,0.00000000,90.00000000); //object(vgwspry1) (4)
	CreateDynamicObject(7891,-4432.70019531,906.73535156,993.03997803,0.00000000,0.00000000,90.00000000); //object(vgwspry1) (5)
	CreateDynamicObject(7891,-4425.46972656,906.73535156,993.03997803,0.00000000,0.00000000,90.00000000); //object(vgwspry1) (6)

	zone_paintball[0] = GangZoneCreateEx(1287.0806, 2055.0513, 1487.7770, 2275.3984);
	area_paintball[0] = CreateDynamicRectangle(1287.0806, 2055.0513, 1487.7770, 2275.3984);
	// 	Sniper
	zone_paintball[1] = GangZoneCreateEx(-2591.2288, -1814.2455, -2178.9082, -1394.5500);
	area_paintball[1] = CreateDynamicRectangle(-2591.2288, -1814.2455, -2178.9082, -1394.5500);

//front side of mall in city
    GZArea[0] = CreateDynamicRectangle(1077.25, -1562.62, 1185.78, -1385.67);

	for(new i = 0; i < sizeof(FuelStation); i ++)
	{
		CreateDynamicPickup(1650, 1, FuelStation[i][FuelX], FuelStation[i][FuelY], FuelStation[i][FuelZ]);
	    CreateDynamic3DTextLabel("Fuel Station\n"SVRCLR"(( Press [H] to refill. [N] to buy Gascan ))\n Cost: $5000 per liter", COLOR_GREY, FuelStation[i][FuelX], FuelStation[i][FuelY], FuelStation[i][FuelZ] + 0.4, 12.0);
	}
    for(new i = 0; i < sizeof(mechPosition); i ++)
	{
		CreateDynamicPickup(19131, 1, mechPosition[i][0], mechPosition[i][1], mechPosition[i][2]);
	    CreateDynamic3DTextLabel("Mechanic\n"SVRCLR"(( Type '/tune' for tune upgrades and '/upgradevehicle' for car upgrades. ))",COLOR_GREY, mechPosition[i][0], mechPosition[i][1], mechPosition[i][2], 25.0);
	}

	// - PLATE REGISTRATION CENTER
	CreateDynamicPickup(1581, 1, 2501.0352, -1946.1055, 13.4937);
	CreateDynamic3DTextLabel("(( Type '/registercar' to get a plate number for your vehicle. ))", SERVER_COLOR, 2501.0352, -1946.1055, 13.4937 + 0.4, 15.0);

    CreateDynamic3DTextLabel("(( Type '/propose or /accept marrage' to get married. ))", SERVER_COLOR, 1823.0681, -1272.4365, 131.9194 + 0.4, 15.0);
    
	for(new i = 0; i < sizeof(harvestPositions); i ++)
	{
	    CreateDynamic3DTextLabel("(( Type '/hc' or press 'N' to begin harvest crops. ))", SERVER_COLOR, harvestPositions[i][0], harvestPositions[i][1], harvestPositions[i][2], 25.0);
	}

	for(new i = 0; i < sizeof(SurgeryPositions); i ++)
	{
		CreateDynamic3DTextLabel("Type "RED"'/Surgery'"WHITE" to begin the sugery.", COLOR_TEAL, SurgeryPositions[i][0], SurgeryPositions[i][1], SurgeryPositions[i][2], 20.0);
	}

	for(new i = 0; i < sizeof(arrestPoints); i ++)
	{
	    CreateDynamic3DTextLabel("Arrest\n"SVRCLR"(( Type '/arrest' to arrest a suspect. ))", COLOR_GREY, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2], 7.0);
	    CreateDynamicPickup(1247, 1, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]);
	}

	// Blindfold - Ez Jeck
	Blind = TextDrawCreate(641.199951, 1.500000, "usebox");
	TextDrawLetterSize(Blind, 0.000000, 49.378147);
	TextDrawTextSize(Blind, -2.000000, 0.000000);
	TextDrawAlignment(Blind, 3);
	TextDrawColour(Blind, -1);
	TextDrawUseBox(Blind, true);
	TextDrawBoxColour(Blind, 255);
	TextDrawSetShadow(Blind, 0);
	TextDrawSetOutline(Blind, 0);
	TextDrawBackgroundColour(Blind, 255);
	TextDrawFont(Blind, 1);


	PHONE[0] = TextDrawCreate(401.000, 114.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[0], 0.600, 2.000);
	TextDrawTextSize(PHONE[0], 122.500, 293.000);
	TextDrawAlignment(PHONE[0], 1);
	TextDrawColour(PHONE[0], -1094795521);
	TextDrawSetShadow(PHONE[0], 0);
	TextDrawSetOutline(PHONE[0], 1);
	TextDrawBackgroundColour(PHONE[0], 255);
	TextDrawFont(PHONE[0], 4);
	TextDrawSetProportional(PHONE[0], 1);

	PHONE[1] = TextDrawCreate(390.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[1], 0.600, 2.000);
	TextDrawTextSize(PHONE[1], 144.500, 269.000);
	TextDrawAlignment(PHONE[1], 1);
	TextDrawColour(PHONE[1], -1094795521);
	TextDrawSetShadow(PHONE[1], 0);
	TextDrawSetOutline(PHONE[1], 1);
	TextDrawBackgroundColour(PHONE[1], 255);
	TextDrawFont(PHONE[1], 4);
	TextDrawSetProportional(PHONE[1], 1);

	PHONE[2] = TextDrawCreate(385.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[2], 0.600, 2.000);
	TextDrawTextSize(PHONE[2], 33.000, 31.500);
	TextDrawAlignment(PHONE[2], 1);
	TextDrawColour(PHONE[2], -1094795521);
	TextDrawSetShadow(PHONE[2], 0);
	TextDrawSetOutline(PHONE[2], 1);
	TextDrawBackgroundColour(PHONE[2], 255);
	TextDrawFont(PHONE[2], 4);
	TextDrawSetProportional(PHONE[2], 1);

	PHONE[3] = TextDrawCreate(507.500, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[3], 0.600, 2.000);
	TextDrawTextSize(PHONE[3], 32.000, 33.000);
	TextDrawAlignment(PHONE[3], 1);
	TextDrawColour(PHONE[3], -1094795521);
	TextDrawSetShadow(PHONE[3], 0);
	TextDrawSetOutline(PHONE[3], 1);
	TextDrawBackgroundColour(PHONE[3], 255);
	TextDrawFont(PHONE[3], 4);
	TextDrawSetProportional(PHONE[3], 1);

	PHONE[4] = TextDrawCreate(508.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[4], 0.600, 2.000);
	TextDrawTextSize(PHONE[4], 32.000, 32.000);
	TextDrawAlignment(PHONE[4], 1);
	TextDrawColour(PHONE[4], -1094795521);
	TextDrawSetShadow(PHONE[4], 0);
	TextDrawSetOutline(PHONE[4], 1);
	TextDrawBackgroundColour(PHONE[4], 255);
	TextDrawFont(PHONE[4], 4);
	TextDrawSetProportional(PHONE[4], 1);

	PHONE[5] = TextDrawCreate(385.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[5], 0.600, 2.000);
	TextDrawTextSize(PHONE[5], 32.000, 32.000);
	TextDrawAlignment(PHONE[5], 1);
	TextDrawColour(PHONE[5], -1094795521);
	TextDrawSetShadow(PHONE[5], 0);
	TextDrawSetOutline(PHONE[5], 1);
	TextDrawBackgroundColour(PHONE[5], 255);
	TextDrawFont(PHONE[5], 4);
	TextDrawSetProportional(PHONE[5], 1);

	PHONE[6] = TextDrawCreate(387.000, 110.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[6], 0.600, 2.000);
	TextDrawTextSize(PHONE[6], 27.000, 31.500);
	TextDrawAlignment(PHONE[6], 1);
	TextDrawColour(PHONE[6], 255);
	TextDrawSetShadow(PHONE[6], 0);
	TextDrawSetOutline(PHONE[6], 1);
	TextDrawBackgroundColour(PHONE[6], 255);
	TextDrawFont(PHONE[6], 4);
	TextDrawSetProportional(PHONE[6], 1);

	PHONE[7] = TextDrawCreate(389.000, 113.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[7], 0.600, 2.000);
	TextDrawTextSize(PHONE[7], 29.000, 29.500);
	TextDrawAlignment(PHONE[7], 1);
	TextDrawColour(PHONE[7], 255);
	TextDrawSetShadow(PHONE[7], 0);
	TextDrawSetOutline(PHONE[7], 1);
	TextDrawBackgroundColour(PHONE[7], 255);
	TextDrawFont(PHONE[7], 4);
	TextDrawSetProportional(PHONE[7], 1);

	PHONE[8] = TextDrawCreate(391.500, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[8], 0.600, 2.000);
	TextDrawTextSize(PHONE[8], 141.500, 269.000);
	TextDrawAlignment(PHONE[8], 1);
	TextDrawColour(PHONE[8], 255);
	TextDrawSetShadow(PHONE[8], 0);
	TextDrawSetOutline(PHONE[8], 1);
	TextDrawBackgroundColour(PHONE[8], 255);
	TextDrawFont(PHONE[8], 4);
	TextDrawSetProportional(PHONE[8], 1);

	PHONE[9] = TextDrawCreate(463.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[9], -2.000, -6.000);
	TextDrawAlignment(PHONE[9], 1);
	TextDrawColour(PHONE[9], 548580095);
	TextDrawSetShadow(PHONE[9], 0);
	TextDrawSetOutline(PHONE[9], 0);
	TextDrawBackgroundColour(PHONE[9], 255);
	TextDrawFont(PHONE[9], 4);
	TextDrawSetProportional(PHONE[9], 1);

	PHONE[10] = TextDrawCreate(504.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[10], 0.600, 2.000);
	TextDrawTextSize(PHONE[10], 34.700, 37.000);
	TextDrawAlignment(PHONE[10], 1);
	TextDrawColour(PHONE[10], 255);
	TextDrawSetShadow(PHONE[10], 0);
	TextDrawSetOutline(PHONE[10], 1);
	TextDrawBackgroundColour(PHONE[10], 255);
	TextDrawFont(PHONE[10], 4);
	TextDrawSetProportional(PHONE[10], 1);

	PHONE[11] = TextDrawCreate(506.000, 377.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[11], 0.600, 2.000);
	TextDrawTextSize(PHONE[11], 32.500, 34.500);
	TextDrawAlignment(PHONE[11], 1);
	TextDrawColour(PHONE[11], 255);
	TextDrawSetShadow(PHONE[11], 0);
	TextDrawSetOutline(PHONE[11], 1);
	TextDrawBackgroundColour(PHONE[11], 255);
	TextDrawFont(PHONE[11], 4);
	TextDrawSetProportional(PHONE[11], 1);

	PHONE[12] = TextDrawCreate(386.299, 377.299, "ld_beat:chit");
	TextDrawLetterSize(PHONE[12], 0.600, 2.000);
	TextDrawTextSize(PHONE[12], 33.000, 34.000);
	TextDrawAlignment(PHONE[12], 1);
	TextDrawColour(PHONE[12], 255);
	TextDrawSetShadow(PHONE[12], 0);
	TextDrawSetOutline(PHONE[12], 1);
	TextDrawBackgroundColour(PHONE[12], 255);
	TextDrawFont(PHONE[12], 4);
	TextDrawSetProportional(PHONE[12], 1);

	PHONE[13] = TextDrawCreate(395.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[13], 0.600, 2.000);
	TextDrawTextSize(PHONE[13], 62.000, 263.000);
	TextDrawAlignment(PHONE[13], 1);
	TextDrawColour(PHONE[13], 1768516095);
	TextDrawSetShadow(PHONE[13], 0);
	TextDrawSetOutline(PHONE[13], 1);
	TextDrawBackgroundColour(PHONE[13], 255);
	TextDrawFont(PHONE[13], 4);
	TextDrawSetProportional(PHONE[13], 1);

	PHONE[14] = TextDrawCreate(402.000, 115.097, "LD_SPAC:black");
	TextDrawTextSize(PHONE[14], 118.000, 15.000);
	TextDrawAlignment(PHONE[14], 1);
	TextDrawColour(PHONE[14], -1);
	TextDrawSetShadow(PHONE[14], 0);
	TextDrawSetOutline(PHONE[14], 0);
	TextDrawBackgroundColour(PHONE[14], 255);
	TextDrawFont(PHONE[14], 4);
	TextDrawSetProportional(PHONE[14], 1);

	PHONE[15] = TextDrawCreate(404.000, 395.100, "LD_SPAC:black");
	TextDrawTextSize(PHONE[15], 118.000, 10.500);
	TextDrawAlignment(PHONE[15], 1);
	TextDrawColour(PHONE[15], -1);
	TextDrawSetShadow(PHONE[15], 0);
	TextDrawSetOutline(PHONE[15], 0);
	TextDrawBackgroundColour(PHONE[15], 255);
	TextDrawFont(PHONE[15], 4);
	TextDrawSetProportional(PHONE[15], 1);

	PHONE[16] = TextDrawCreate(457.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[16], 0.600, 2.000);
	TextDrawTextSize(PHONE[16], 75.500, 264.000);
	TextDrawAlignment(PHONE[16], 1);
	TextDrawColour(PHONE[16], 255);
	TextDrawSetShadow(PHONE[16], 0);
	TextDrawSetOutline(PHONE[16], 1);
	TextDrawBackgroundColour(PHONE[16], 255);
	TextDrawFont(PHONE[16], 4);
	TextDrawSetProportional(PHONE[16], 1);

	PHONE[17] = TextDrawCreate(400.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[17], 0.600, 2.000);
	TextDrawTextSize(PHONE[17], 61.000, 280.000);
	TextDrawAlignment(PHONE[17], 1);
	TextDrawColour(PHONE[17], 1768516095);
	TextDrawSetShadow(PHONE[17], 0);
	TextDrawSetOutline(PHONE[17], 1);
	TextDrawBackgroundColour(PHONE[17], 255);
	TextDrawFont(PHONE[17], 4);
	TextDrawSetProportional(PHONE[17], 1);

	PHONE[18] = TextDrawCreate(389.000, 375.000, "ld_beat:chit");
	TextDrawLetterSize(PHONE[18], 0.600, 2.000);
	TextDrawTextSize(PHONE[18], 31.000, 31.500);
	TextDrawAlignment(PHONE[18], 1);
	TextDrawColour(PHONE[18], 0);
	TextDrawSetShadow(PHONE[18], 0);
	TextDrawSetOutline(PHONE[18], 1);
	TextDrawBackgroundColour(PHONE[18], 255);
	TextDrawFont(PHONE[18], 4);
	TextDrawSetProportional(PHONE[18], 1);

	PHONE[19] = TextDrawCreate(391.500, 378.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[19], 23.000, 26.500);
	TextDrawAlignment(PHONE[19], 1);
	TextDrawColour(PHONE[19], 1768516095);
	TextDrawSetShadow(PHONE[19], 0);
	TextDrawSetOutline(PHONE[19], 0);
	TextDrawBackgroundColour(PHONE[19], 255);
	TextDrawFont(PHONE[19], 4);
	TextDrawSetProportional(PHONE[19], 1);

	PHONE[20] = TextDrawCreate(467.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[20], 0.600, 2.000);
	TextDrawTextSize(PHONE[20], 62.000, 263.000);
	TextDrawAlignment(PHONE[20], 1);
	TextDrawColour(PHONE[20], -1061109505);
	TextDrawSetShadow(PHONE[20], 0);
	TextDrawSetOutline(PHONE[20], 1);
	TextDrawBackgroundColour(PHONE[20], 255);
	TextDrawFont(PHONE[20], 4);
	TextDrawSetProportional(PHONE[20], 1);

	PHONE[21] = TextDrawCreate(462.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(PHONE[21], 0.600, 2.000);
	TextDrawTextSize(PHONE[21], 62.000, 280.000);
	TextDrawAlignment(PHONE[21], 1);
	TextDrawColour(PHONE[21], -1061109505);
	TextDrawSetShadow(PHONE[21], 0);
	TextDrawSetOutline(PHONE[21], 1);
	TextDrawBackgroundColour(PHONE[21], 255);
	TextDrawFont(PHONE[21], 4);
	TextDrawSetProportional(PHONE[21], 1);

	PHONE[22] = TextDrawCreate(509.500, 377.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[22], 24.000, 28.500);
	TextDrawAlignment(PHONE[22], 1);
	TextDrawColour(PHONE[22], -1061109505);
	TextDrawSetShadow(PHONE[22], 0);
	TextDrawSetOutline(PHONE[22], 0);
	TextDrawBackgroundColour(PHONE[22], 255);
	TextDrawFont(PHONE[22], 4);
	TextDrawSetProportional(PHONE[22], 1);

	PHONE[23] = TextDrawCreate(392.000, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[23], 20.000, 24.000);
	TextDrawAlignment(PHONE[23], 1);
	TextDrawColour(PHONE[23], 1768516095);
	TextDrawSetShadow(PHONE[23], 0);
	TextDrawSetOutline(PHONE[23], 0);
	TextDrawBackgroundColour(PHONE[23], 255);
	TextDrawFont(PHONE[23], 4);
	TextDrawSetProportional(PHONE[23], 1);

	PHONE[24] = TextDrawCreate(509.500, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[24], 24.000, 24.500);
	TextDrawAlignment(PHONE[24], 1);
	TextDrawColour(PHONE[24], -1061109505);
	TextDrawSetShadow(PHONE[24], 0);
	TextDrawSetOutline(PHONE[24], 0);
	TextDrawBackgroundColour(PHONE[24], 255);
	TextDrawFont(PHONE[24], 4);
	TextDrawSetProportional(PHONE[24], 1);

	PHONE[25] = TextDrawCreate(400.000, 124.000, "AKRP");
	TextDrawLetterSize(PHONE[25], 0.200, 0.898);
	TextDrawAlignment(PHONE[25], 1);
	TextDrawColour(PHONE[25], -1);
	TextDrawSetShadow(PHONE[25], 1);
	TextDrawSetOutline(PHONE[25], 1);
	TextDrawBackgroundColour(PHONE[25], 0);
	TextDrawFont(PHONE[25], 2);
	TextDrawSetProportional(PHONE[25], 1);

	PHONE[26] = TextDrawCreate(429.000, 135.000, "LD_SPAC:black");
	TextDrawTextSize(PHONE[26], 66.000, -11.000);
	TextDrawAlignment(PHONE[26], 1);
	TextDrawColour(PHONE[26], -1);
	TextDrawSetShadow(PHONE[26], 0);
	TextDrawSetOutline(PHONE[26], 0);
	TextDrawBackgroundColour(PHONE[26], 255);
	TextDrawFont(PHONE[26], 4);
	TextDrawSetProportional(PHONE[26], 1);

	PHONE[27] = TextDrawCreate(423.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[27], 16.000, 17.000);
	TextDrawAlignment(PHONE[27], 1);
	TextDrawColour(PHONE[27], 255);
	TextDrawSetShadow(PHONE[27], 0);
	TextDrawSetOutline(PHONE[27], 0);
	TextDrawBackgroundColour(PHONE[27], 255);
	TextDrawFont(PHONE[27], 4);
	TextDrawSetProportional(PHONE[27], 1);

	PHONE[28] = TextDrawCreate(485.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[28], 16.000, 17.000);
	TextDrawAlignment(PHONE[28], 1);
	TextDrawColour(PHONE[28], 255);
	TextDrawSetShadow(PHONE[28], 0);
	TextDrawSetOutline(PHONE[28], 0);
	TextDrawBackgroundColour(PHONE[28], 255);
	TextDrawFont(PHONE[28], 4);
	TextDrawSetProportional(PHONE[28], 1);

	PHONE[29] = TextDrawCreate(508.000, 122.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[29], 2.000, 12.000);
	TextDrawAlignment(PHONE[29], 1);
	TextDrawColour(PHONE[29], -1);
	TextDrawSetShadow(PHONE[29], 0);
	TextDrawSetOutline(PHONE[29], 0);
	TextDrawBackgroundColour(PHONE[29], 255);
	TextDrawFont(PHONE[29], 4);
	TextDrawSetProportional(PHONE[29], 1);

	PHONE[30] = TextDrawCreate(505.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[30], 2.000, -8.000);
	TextDrawAlignment(PHONE[30], 1);
	TextDrawColour(PHONE[30], -1);
	TextDrawSetShadow(PHONE[30], 0);
	TextDrawSetOutline(PHONE[30], 0);
	TextDrawBackgroundColour(PHONE[30], 255);
	TextDrawFont(PHONE[30], 4);
	TextDrawSetProportional(PHONE[30], 1);

	PHONE[31] = TextDrawCreate(502.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[31], 2.000, -5.000);
	TextDrawAlignment(PHONE[31], 1);
	TextDrawColour(PHONE[31], -1);
	TextDrawSetShadow(PHONE[31], 0);
	TextDrawSetOutline(PHONE[31], 0);
	TextDrawBackgroundColour(PHONE[31], 255);
	TextDrawFont(PHONE[31], 4);
	TextDrawSetProportional(PHONE[31], 1);

	PHONE[32] = TextDrawCreate(499.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[32], 2.000, -2.000);
	TextDrawAlignment(PHONE[32], 1);
	TextDrawColour(PHONE[32], -1);
	TextDrawSetShadow(PHONE[32], 0);
	TextDrawSetOutline(PHONE[32], 0);
	TextDrawBackgroundColour(PHONE[32], 255);
	TextDrawFont(PHONE[32], 4);
	TextDrawSetProportional(PHONE[32], 1);

	PHONE[33] = TextDrawCreate(514.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[33], 10.000, -8.000);
	TextDrawAlignment(PHONE[33], 1);
	TextDrawColour(PHONE[33], -1);
	TextDrawSetShadow(PHONE[33], 0);
	TextDrawSetOutline(PHONE[33], 0);
	TextDrawBackgroundColour(PHONE[33], 255);
	TextDrawFont(PHONE[33], 4);
	TextDrawSetProportional(PHONE[33], 1);

	PHONE[34] = TextDrawCreate(523.000, 132.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[34], 3.000, -4.000);
	TextDrawAlignment(PHONE[34], 1);
	TextDrawColour(PHONE[34], -1);
	TextDrawSetShadow(PHONE[34], 0);
	TextDrawSetOutline(PHONE[34], 0);
	TextDrawBackgroundColour(PHONE[34], 255);
	TextDrawFont(PHONE[34], 4);
	TextDrawSetProportional(PHONE[34], 1);

	PHONE[35] = TextDrawCreate(431.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[35], 26.000, 31.000);
	TextDrawAlignment(PHONE[35], 1);
	TextDrawColour(PHONE[35], -1061109505);
	TextDrawSetShadow(PHONE[35], 0);
	TextDrawSetOutline(PHONE[35], 0);
	TextDrawBackgroundColour(PHONE[35], 255);
	TextDrawFont(PHONE[35], 4);
	TextDrawSetProportional(PHONE[35], 1);
	TextDrawSetSelectable(PHONE[35], 1);

	PHONE[36] = TextDrawCreate(403.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[36], 26.000, 31.000);
	TextDrawAlignment(PHONE[36], 1);
	TextDrawColour(PHONE[36], -2686721);
	TextDrawSetShadow(PHONE[36], 0);
	TextDrawSetOutline(PHONE[36], 0);
	TextDrawBackgroundColour(PHONE[36], 255);
	TextDrawFont(PHONE[36], 4);
	TextDrawSetProportional(PHONE[36], 1);
	TextDrawSetSelectable(PHONE[36], 1);

	PHONE[37] = TextDrawCreate(431.000, 201.500, "LD_SPAC:white");
	TextDrawTextSize(PHONE[37], 26.000, 31.000);
	TextDrawAlignment(PHONE[37], 1);
	TextDrawColour(PHONE[37], 1316683775);
	TextDrawSetShadow(PHONE[37], 0);
	TextDrawSetOutline(PHONE[37], 0);
	TextDrawBackgroundColour(PHONE[37], 255);
	TextDrawFont(PHONE[37], 4);
	TextDrawSetProportional(PHONE[37], 1);
	TextDrawSetSelectable(PHONE[37], 1);

	PHONE[38] = TextDrawCreate(403.000, 201.500, "LD_SPAC:white");
	TextDrawTextSize(PHONE[38], 26.000, 31.000);
	TextDrawAlignment(PHONE[38], 1);
	TextDrawColour(PHONE[38], -14873857);
	TextDrawSetShadow(PHONE[38], 0);
	TextDrawSetOutline(PHONE[38], 0);
	TextDrawBackgroundColour(PHONE[38], 255);
	TextDrawFont(PHONE[38], 4);
	TextDrawSetProportional(PHONE[38], 1);
	TextDrawSetSelectable(PHONE[38], 1);

	PHONE[39] = TextDrawCreate(431.000, 248.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[39], 26.000, 31.000);
	TextDrawAlignment(PHONE[39], 1);
	TextDrawColour(PHONE[39], -2686721);
	TextDrawSetShadow(PHONE[39], 0);
	TextDrawSetOutline(PHONE[39], 0);
	TextDrawBackgroundColour(PHONE[39], 255);
	TextDrawFont(PHONE[39], 4);
	TextDrawSetProportional(PHONE[39], 1);
	TextDrawSetSelectable(PHONE[39], 1);

	PHONE[40] = TextDrawCreate(403.000, 248.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[40], 26.000, 31.000);
	TextDrawAlignment(PHONE[40], 1);
	TextDrawColour(PHONE[40], -1);
	TextDrawSetShadow(PHONE[40], 0);
	TextDrawSetOutline(PHONE[40], 0);
	TextDrawBackgroundColour(PHONE[40], 255);
	TextDrawFont(PHONE[40], 4);
	TextDrawSetProportional(PHONE[40], 1);
	TextDrawSetSelectable(PHONE[40], 1);

	PHONE[41] = TextDrawCreate(496.000, 201.500, "LD_SPAC:white");
	TextDrawTextSize(PHONE[41], 26.000, 31.000);
	TextDrawAlignment(PHONE[41], 1);
	TextDrawColour(PHONE[41], -1);
	TextDrawSetShadow(PHONE[41], 0);
	TextDrawSetOutline(PHONE[41], 0);
	TextDrawBackgroundColour(PHONE[41], 255);
	TextDrawFont(PHONE[41], 4);
	TextDrawSetProportional(PHONE[41], 1);
	TextDrawSetSelectable(PHONE[41], 1);

	PHONE[42] = TextDrawCreate(468.000, 201.500, "LD_SPAC:white");
	TextDrawTextSize(PHONE[42], 26.000, 31.000);
	TextDrawAlignment(PHONE[42], 1);
	TextDrawColour(PHONE[42], -1962934017);
	TextDrawSetShadow(PHONE[42], 0);
	TextDrawSetOutline(PHONE[42], 0);
	TextDrawBackgroundColour(PHONE[42], 255);
	TextDrawFont(PHONE[42], 4);
	TextDrawSetProportional(PHONE[42], 1);
	TextDrawSetSelectable(PHONE[42], 1);

	PHONE[43] = TextDrawCreate(496.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[43], 26.000, 31.000);
	TextDrawAlignment(PHONE[43], 1);
	TextDrawColour(PHONE[43], -1);
	TextDrawSetShadow(PHONE[43], 0);
	TextDrawSetOutline(PHONE[43], 0);
	TextDrawBackgroundColour(PHONE[43], 255);
	TextDrawFont(PHONE[43], 4);
	TextDrawSetProportional(PHONE[43], 1);
	TextDrawSetSelectable(PHONE[43], 1);

	PHONE[44] = TextDrawCreate(468.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[44], 26.000, 31.000);
	TextDrawAlignment(PHONE[44], 1);
	TextDrawColour(PHONE[44], -1);
	TextDrawSetShadow(PHONE[44], 0);
	TextDrawSetOutline(PHONE[44], 0);
	TextDrawBackgroundColour(PHONE[44], 255);
	TextDrawFont(PHONE[44], 4);
	TextDrawSetProportional(PHONE[44], 1);
	TextDrawSetSelectable(PHONE[44], 1);

	PHONE[45] = TextDrawCreate(496.000, 248.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[45], 26.000, 31.000);
	TextDrawAlignment(PHONE[45], 1);
	TextDrawColour(PHONE[45], -16711681);
	TextDrawSetShadow(PHONE[45], 0);
	TextDrawSetOutline(PHONE[45], 0);
	TextDrawBackgroundColour(PHONE[45], 255);
	TextDrawFont(PHONE[45], 4);
	TextDrawSetProportional(PHONE[45], 1);
	TextDrawSetSelectable(PHONE[45], 1);

	PHONE[46] = TextDrawCreate(468.000, 248.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[46], 26.000, 31.000);
	TextDrawAlignment(PHONE[46], 1);
	TextDrawColour(PHONE[46], 16777215);
	TextDrawSetShadow(PHONE[46], 0);
	TextDrawSetOutline(PHONE[46], 0);
	TextDrawBackgroundColour(PHONE[46], 255);
	TextDrawFont(PHONE[46], 4);
	TextDrawSetProportional(PHONE[46], 1);
	TextDrawSetSelectable(PHONE[46], 1);

	PHONE[47] = TextDrawCreate(410.000, 162.000, "Q");
	TextDrawLetterSize(PHONE[47], 0.379, 2.098);
	TextDrawAlignment(PHONE[47], 1);
	TextDrawColour(PHONE[47], -1);
	TextDrawSetShadow(PHONE[47], 1);
	TextDrawSetOutline(PHONE[47], 1);
	TextDrawBackgroundColour(PHONE[47], 255);
	TextDrawFont(PHONE[47], 2);
	TextDrawSetProportional(PHONE[47], 1);

	PHONE[48] = TextDrawCreate(435.000, 160.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[48], 18.000, 21.000);
	TextDrawAlignment(PHONE[48], 1);
	TextDrawColour(PHONE[48], 255);
	TextDrawSetShadow(PHONE[48], 0);
	TextDrawSetOutline(PHONE[48], 0);
	TextDrawBackgroundColour(PHONE[48], 255);
	TextDrawFont(PHONE[48], 4);
	TextDrawSetProportional(PHONE[48], 1);

	PHONE[49] = TextDrawCreate(448.000, 161.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[49], 3.000, 3.000);
	TextDrawAlignment(PHONE[49], 1);
	TextDrawColour(PHONE[49], -1061109505);
	TextDrawSetShadow(PHONE[49], 0);
	TextDrawSetOutline(PHONE[49], 0);
	TextDrawBackgroundColour(PHONE[49], 255);
	TextDrawFont(PHONE[49], 4);
	TextDrawSetProportional(PHONE[49], 1);

	PHONE[50] = TextDrawCreate(437.000, 255.000, "T");
	TextDrawLetterSize(PHONE[50], 0.578, 2.299);
	TextDrawAlignment(PHONE[50], 1);
	TextDrawColour(PHONE[50], 255);
	TextDrawSetShadow(PHONE[50], 1);
	TextDrawSetOutline(PHONE[50], 1);
	TextDrawBackgroundColour(PHONE[50], 0);
	TextDrawFont(PHONE[50], 2);
	TextDrawSetProportional(PHONE[50], 1);

	PHONE[51] = TextDrawCreate(435.500, 161.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[51], 17.000, 20.000);
	TextDrawAlignment(PHONE[51], 1);
	TextDrawColour(PHONE[51], -117899265);
	TextDrawSetShadow(PHONE[51], 0);
	TextDrawSetOutline(PHONE[51], 0);
	TextDrawBackgroundColour(PHONE[51], 255);
	TextDrawFont(PHONE[51], 4);
	TextDrawSetProportional(PHONE[51], 1);

	PHONE[52] = TextDrawCreate(436.500, 162.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[52], 15.000, 18.000);
	TextDrawAlignment(PHONE[52], 1);
	TextDrawColour(PHONE[52], 1887473919);
	TextDrawSetShadow(PHONE[52], 0);
	TextDrawSetOutline(PHONE[52], 0);
	TextDrawBackgroundColour(PHONE[52], 255);
	TextDrawFont(PHONE[52], 4);
	TextDrawSetProportional(PHONE[52], 1);

	PHONE[53] = TextDrawCreate(483.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[53], 11.000, 31.000);
	TextDrawAlignment(PHONE[53], 1);
	TextDrawColour(PHONE[53], -1018887944);
	TextDrawSetShadow(PHONE[53], 0);
	TextDrawSetOutline(PHONE[53], 0);
	TextDrawBackgroundColour(PHONE[53], 255);
	TextDrawFont(PHONE[53], 4);
	TextDrawSetProportional(PHONE[53], 1);

	PHONE[54] = TextDrawCreate(468.000, 155.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[54], 14.000, 31.000);
	TextDrawAlignment(PHONE[54], 1);
	TextDrawColour(PHONE[54], -1018887944);
	TextDrawSetShadow(PHONE[54], 0);
	TextDrawSetOutline(PHONE[54], 0);
	TextDrawBackgroundColour(PHONE[54], 255);
	TextDrawFont(PHONE[54], 4);
	TextDrawSetProportional(PHONE[54], 1);

	PHONE[55] = TextDrawCreate(471.000, 152.000, "-");
	TextDrawLetterSize(PHONE[55], 0.717, 1.500);
	TextDrawAlignment(PHONE[55], 1);
	TextDrawColour(PHONE[55], -1);
	TextDrawSetShadow(PHONE[55], 1);
	TextDrawSetOutline(PHONE[55], 1);
	TextDrawBackgroundColour(PHONE[55], 255);
	TextDrawFont(PHONE[55], 1);
	TextDrawSetProportional(PHONE[55], 1);

	PHONE[56] = TextDrawCreate(471.000, 168.000, "+");
	TextDrawLetterSize(PHONE[56], 0.518, 1.500);
	TextDrawAlignment(PHONE[56], 1);
	TextDrawColour(PHONE[56], -1);
	TextDrawSetShadow(PHONE[56], 1);
	TextDrawSetOutline(PHONE[56], 1);
	TextDrawBackgroundColour(PHONE[56], 255);
	TextDrawFont(PHONE[56], 1);
	TextDrawSetProportional(PHONE[56], 1);

	PHONE[57] = TextDrawCreate(485.000, 161.000, "=");
	TextDrawLetterSize(PHONE[57], 0.518, 1.500);
	TextDrawAlignment(PHONE[57], 1);
	TextDrawColour(PHONE[57], -1);
	TextDrawSetShadow(PHONE[57], 1);
	TextDrawSetOutline(PHONE[57], 1);
	TextDrawBackgroundColour(PHONE[57], 255);
	TextDrawFont(PHONE[57], 1);
	TextDrawSetProportional(PHONE[57], 1);

	PHONE[58] = TextDrawCreate(499.000, 151.000, "&");
	TextDrawLetterSize(PHONE[58], 0.750, 3.588);
	TextDrawAlignment(PHONE[58], 1);
	TextDrawColour(PHONE[58], 512819199);
	TextDrawSetShadow(PHONE[58], 1);
	TextDrawSetOutline(PHONE[58], 0);
	TextDrawBackgroundColour(PHONE[58], 512819199);
	TextDrawFont(PHONE[58], 1);
	TextDrawSetProportional(PHONE[58], 1);

	PHONE[59] = TextDrawCreate(519.000, 151.000, "&");
	TextDrawLetterSize(PHONE[59], -0.750, 3.588);
	TextDrawAlignment(PHONE[59], 1);
	TextDrawColour(PHONE[59], 35839);
	TextDrawSetShadow(PHONE[59], 1);
	TextDrawSetOutline(PHONE[59], 0);
	TextDrawBackgroundColour(PHONE[59], 35839);
	TextDrawFont(PHONE[59], 1);
	TextDrawSetProportional(PHONE[59], 1);

	PHONE[60] = TextDrawCreate(408.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[60], 17.000, 8.000);
	TextDrawAlignment(PHONE[60], 1);
	TextDrawColour(PHONE[60], -1);
	TextDrawSetShadow(PHONE[60], 0);
	TextDrawSetOutline(PHONE[60], 0);
	TextDrawBackgroundColour(PHONE[60], 255);
	TextDrawFont(PHONE[60], 4);
	TextDrawSetProportional(PHONE[60], 1);

	PHONE[61] = TextDrawCreate(410.000, 209.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[61], 13.000, 14.000);
	TextDrawAlignment(PHONE[61], 1);
	TextDrawColour(PHONE[61], -1);
	TextDrawSetShadow(PHONE[61], 0);
	TextDrawSetOutline(PHONE[61], 0);
	TextDrawBackgroundColour(PHONE[61], 255);
	TextDrawFont(PHONE[61], 4);
	TextDrawSetProportional(PHONE[61], 1);

	PHONE[62] = TextDrawCreate(407.000, 208.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[62], 5.000, 6.000);
	TextDrawAlignment(PHONE[62], 1);
	TextDrawColour(PHONE[62], -1);
	TextDrawSetShadow(PHONE[62], 0);
	TextDrawSetOutline(PHONE[62], 0);
	TextDrawBackgroundColour(PHONE[62], 255);
	TextDrawFont(PHONE[62], 4);
	TextDrawSetProportional(PHONE[62], 1);

	PHONE[63] = TextDrawCreate(421.000, 208.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[63], 5.000, 6.000);
	TextDrawAlignment(PHONE[63], 1);
	TextDrawColour(PHONE[63], -1);
	TextDrawSetShadow(PHONE[63], 0);
	TextDrawSetOutline(PHONE[63], 0);
	TextDrawBackgroundColour(PHONE[63], 255);
	TextDrawFont(PHONE[63], 4);
	TextDrawSetProportional(PHONE[63], 1);

	PHONE[64] = TextDrawCreate(421.000, 218.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[64], 5.000, 6.000);
	TextDrawAlignment(PHONE[64], 1);
	TextDrawColour(PHONE[64], -1);
	TextDrawSetShadow(PHONE[64], 0);
	TextDrawSetOutline(PHONE[64], 0);
	TextDrawBackgroundColour(PHONE[64], 255);
	TextDrawFont(PHONE[64], 4);
	TextDrawSetProportional(PHONE[64], 1);

	PHONE[65] = TextDrawCreate(407.000, 218.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[65], 5.000, 6.000);
	TextDrawAlignment(PHONE[65], 1);
	TextDrawColour(PHONE[65], -1);
	TextDrawSetShadow(PHONE[65], 0);
	TextDrawSetOutline(PHONE[65], 0);
	TextDrawBackgroundColour(PHONE[65], 255);
	TextDrawFont(PHONE[65], 4);
	TextDrawSetProportional(PHONE[65], 1);

	PHONE[66] = TextDrawCreate(414.000, 210.000, "\\");
	TextDrawLetterSize(PHONE[66], 0.669, 0.799);
	TextDrawAlignment(PHONE[66], 1);
	TextDrawColour(PHONE[66], -16776961);
	TextDrawSetShadow(PHONE[66], 1);
	TextDrawSetOutline(PHONE[66], 1);
	TextDrawBackgroundColour(PHONE[66], 0);
	TextDrawFont(PHONE[66], 1);
	TextDrawSetProportional(PHONE[66], 1);

	PHONE[67] = TextDrawCreate(414.000, 223.000, "\\");
	TextDrawLetterSize(PHONE[67], 0.660, -0.790);
	TextDrawAlignment(PHONE[67], 1);
	TextDrawColour(PHONE[67], -16776961);
	TextDrawSetShadow(PHONE[67], 1);
	TextDrawSetOutline(PHONE[67], 1);
	TextDrawBackgroundColour(PHONE[67], 0);
	TextDrawFont(PHONE[67], 1);
	TextDrawSetProportional(PHONE[67], 1);

	PHONE[68] = TextDrawCreate(414.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[68], 1.000, 9.000);
	TextDrawAlignment(PHONE[68], 1);
	TextDrawColour(PHONE[68], -16776961);
	TextDrawSetShadow(PHONE[68], 0);
	TextDrawSetOutline(PHONE[68], 0);
	TextDrawBackgroundColour(PHONE[68], 255);
	TextDrawFont(PHONE[68], 4);
	TextDrawSetProportional(PHONE[68], 1);

	PHONE[69] = TextDrawCreate(439.000, 202.000, "$");
	TextDrawLetterSize(PHONE[69], 0.708, 2.799);
	TextDrawAlignment(PHONE[69], 1);
	TextDrawColour(PHONE[69], -1);
	TextDrawSetShadow(PHONE[69], 1);
	TextDrawSetOutline(PHONE[69], 1);
	TextDrawBackgroundColour(PHONE[69], 150);
	TextDrawFont(PHONE[69], 1);
	TextDrawSetProportional(PHONE[69], 1);

	PHONE[70] = TextDrawCreate(468.000, 201.500, "LD_SPAC:white");
	TextDrawTextSize(PHONE[70], 26.000, 31.000);
	TextDrawAlignment(PHONE[70], 1);
	TextDrawColour(PHONE[70], -1962934017);
	TextDrawSetShadow(PHONE[70], 0);
	TextDrawSetOutline(PHONE[70], 0);
	TextDrawBackgroundColour(PHONE[70], 255);
	TextDrawFont(PHONE[70], 4);
	TextDrawSetProportional(PHONE[70], 1);
	TextDrawSetSelectable(PHONE[70], 1);

	PHONE[71] = TextDrawCreate(463.000, 207.000, "HUD:radar_gangY");
	TextDrawTextSize(PHONE[71], 36.000, 20.000);
	TextDrawAlignment(PHONE[71], 1);
	TextDrawColour(PHONE[71], -1);
	TextDrawSetShadow(PHONE[71], 0);
	TextDrawSetOutline(PHONE[71], 0);
	TextDrawBackgroundColour(PHONE[71], 255);
	TextDrawFont(PHONE[71], 4);
	TextDrawSetProportional(PHONE[71], 1);
	TextDrawSetSelectable(PHONE[71], 1);

	PHONE[72] = TextDrawCreate(495.000, 199.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[72], 29.000, 35.000);
	TextDrawAlignment(PHONE[72], 1);
	TextDrawColour(PHONE[72], 16711935);
	TextDrawSetShadow(PHONE[72], 0);
	TextDrawSetOutline(PHONE[72], 0);
	TextDrawBackgroundColour(PHONE[72], 255);
	TextDrawFont(PHONE[72], 4);
	TextDrawSetProportional(PHONE[72], 1);

	PHONE[73] = TextDrawCreate(501.000, 223.000, "LD_BEAT:downl");
	TextDrawTextSize(PHONE[73], 6.000, 5.000);
	TextDrawAlignment(PHONE[73], 1);
	TextDrawColour(PHONE[73], 16744447);
	TextDrawSetShadow(PHONE[73], 0);
	TextDrawSetOutline(PHONE[73], 0);
	TextDrawBackgroundColour(PHONE[73], 255);
	TextDrawFont(PHONE[73], 4);
	TextDrawSetProportional(PHONE[73], 1);

	PHONE[74] = TextDrawCreate(506.000, 206.000, "C");
	TextDrawLetterSize(PHONE[74], 0.210, 2.599);
	TextDrawTextSize(PHONE[74], -11.000, 7.000);
	TextDrawAlignment(PHONE[74], 1);
	TextDrawColour(PHONE[74], -1);
	TextDrawSetShadow(PHONE[74], 1);
	TextDrawSetOutline(PHONE[74], 1);
	TextDrawBackgroundColour(PHONE[74], 0);
	TextDrawFont(PHONE[74], 2);
	TextDrawSetProportional(PHONE[74], 1);

	PHONE[75] = TextDrawCreate(406.000, 250.000, "HUD:radar_impound");
	TextDrawTextSize(PHONE[75], 21.000, 25.000);
	TextDrawAlignment(PHONE[75], 1);
	TextDrawColour(PHONE[75], -1);
	TextDrawSetShadow(PHONE[75], 0);
	TextDrawSetOutline(PHONE[75], 0);
	TextDrawBackgroundColour(PHONE[75], 255);
	TextDrawFont(PHONE[75], 4);
	TextDrawSetProportional(PHONE[75], 1);

	PHONE[76] = TextDrawCreate(476.000, 249.000, "T");
	TextDrawLetterSize(PHONE[76], 0.479, 2.999);
	TextDrawAlignment(PHONE[76], 1);
	TextDrawColour(PHONE[76], -1);
	TextDrawSetShadow(PHONE[76], 1);
	TextDrawSetOutline(PHONE[76], 1);
	TextDrawBackgroundColour(PHONE[76], 0);
	TextDrawFont(PHONE[76], 3);
	TextDrawSetProportional(PHONE[76], 1);

	PHONE[77] = TextDrawCreate(497.000, 250.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[77], 24.000, 28.000);
	TextDrawAlignment(PHONE[77], 1);
	TextDrawColour(PHONE[77], -1);
	TextDrawSetShadow(PHONE[77], 0);
	TextDrawSetOutline(PHONE[77], 0);
	TextDrawBackgroundColour(PHONE[77], 255);
	TextDrawFont(PHONE[77], 4);
	TextDrawSetProportional(PHONE[77], 1);

	PHONE[78] = TextDrawCreate(403.000, 186.000, "Messages");
	TextDrawLetterSize(PHONE[78], 0.158, 0.898);
	TextDrawAlignment(PHONE[78], 1);
	TextDrawColour(PHONE[78], -1);
	TextDrawSetShadow(PHONE[78], 1);
	TextDrawSetOutline(PHONE[78], 1);
	TextDrawBackgroundColour(PHONE[78], 0);
	TextDrawFont(PHONE[78], 1);
	TextDrawSetProportional(PHONE[78], 1);

	PHONE[79] = TextDrawCreate(444.000, 186.000, "Camera");
	TextDrawLetterSize(PHONE[79], 0.158, 0.898);
	TextDrawAlignment(PHONE[79], 2);
	TextDrawColour(PHONE[79], -1);
	TextDrawSetShadow(PHONE[79], 1);
	TextDrawSetOutline(PHONE[79], 1);
	TextDrawBackgroundColour(PHONE[79], 0);
	TextDrawFont(PHONE[79], 1);
	TextDrawSetProportional(PHONE[79], 1);

	PHONE[80] = TextDrawCreate(481.000, 186.000, "Calculator");
	TextDrawLetterSize(PHONE[80], 0.158, 0.898);
	TextDrawAlignment(PHONE[80], 2);
	TextDrawColour(PHONE[80], -1);
	TextDrawSetShadow(PHONE[80], 1);
	TextDrawSetOutline(PHONE[80], 1);
	TextDrawBackgroundColour(PHONE[80], 0);
	TextDrawFont(PHONE[80], 1);
	TextDrawSetProportional(PHONE[80], 1);

	PHONE[81] = TextDrawCreate(510.000, 186.000, "Info");
	TextDrawLetterSize(PHONE[81], 0.158, 0.898);
	TextDrawAlignment(PHONE[81], 2);
	TextDrawColour(PHONE[81], -1);
	TextDrawSetShadow(PHONE[81], 1);
	TextDrawSetOutline(PHONE[81], 1);
	TextDrawBackgroundColour(PHONE[81], 0);
	TextDrawFont(PHONE[81], 1);
	TextDrawSetProportional(PHONE[81], 1);

	PHONE[82] = TextDrawCreate(510.000, 232.000, "Whatsapp");
	TextDrawLetterSize(PHONE[82], 0.158, 0.898);
	TextDrawAlignment(PHONE[82], 2);
	TextDrawColour(PHONE[82], -1);
	TextDrawSetShadow(PHONE[82], 1);
	TextDrawSetOutline(PHONE[82], 1);
	TextDrawBackgroundColour(PHONE[82], 0);
	TextDrawFont(PHONE[82], 1);
	TextDrawSetProportional(PHONE[82], 1);

	PHONE[83] = TextDrawCreate(481.000, 232.000, "Jobs");
	TextDrawLetterSize(PHONE[83], 0.158, 0.898);
	TextDrawAlignment(PHONE[83], 2);
	TextDrawColour(PHONE[83], -1);
	TextDrawSetShadow(PHONE[83], 1);
	TextDrawSetOutline(PHONE[83], 1);
	TextDrawBackgroundColour(PHONE[83], 0);
	TextDrawFont(PHONE[83], 1);
	TextDrawSetProportional(PHONE[83], 1);

	PHONE[84] = TextDrawCreate(444.000, 232.000, "Bank");
	TextDrawLetterSize(PHONE[84], 0.158, 0.898);
	TextDrawAlignment(PHONE[84], 2);
	TextDrawColour(PHONE[84], -1);
	TextDrawSetShadow(PHONE[84], 1);
	TextDrawSetOutline(PHONE[84], 1);
	TextDrawBackgroundColour(PHONE[84], 0);
	TextDrawFont(PHONE[84], 1);
	TextDrawSetProportional(PHONE[84], 1);

	PHONE[85] = TextDrawCreate(416.000, 232.000, "Youtube");
	TextDrawLetterSize(PHONE[85], 0.158, 0.898);
	TextDrawAlignment(PHONE[85], 2);
	TextDrawColour(PHONE[85], -1);
	TextDrawSetShadow(PHONE[85], 1);
	TextDrawSetOutline(PHONE[85], 1);
	TextDrawBackgroundColour(PHONE[85], 0);
	TextDrawFont(PHONE[85], 1);
	TextDrawSetProportional(PHONE[85], 1);

	PHONE[86] = TextDrawCreate(416.000, 280.000, "Valley");
	TextDrawLetterSize(PHONE[86], 0.158, 0.898);
	TextDrawAlignment(PHONE[86], 2);
	TextDrawColour(PHONE[86], -1);
	TextDrawSetShadow(PHONE[86], 1);
	TextDrawSetOutline(PHONE[86], 1);
	TextDrawBackgroundColour(PHONE[86], 0);
	TextDrawFont(PHONE[86], 1);
	TextDrawSetProportional(PHONE[86], 1);

	PHONE[87] = TextDrawCreate(444.000, 280.000, "Taxi");
	TextDrawLetterSize(PHONE[87], 0.158, 0.898);
	TextDrawAlignment(PHONE[87], 2);
	TextDrawColour(PHONE[87], -1);
	TextDrawSetShadow(PHONE[87], 1);
	TextDrawSetOutline(PHONE[87], 1);
	TextDrawBackgroundColour(PHONE[87], 0);
	TextDrawFont(PHONE[87], 1);
	TextDrawSetProportional(PHONE[87], 1);

	PHONE[88] = TextDrawCreate(481.000, 280.000, "Twitter");
	TextDrawLetterSize(PHONE[88], 0.158, 0.898);
	TextDrawAlignment(PHONE[88], 2);
	TextDrawColour(PHONE[88], -1);
	TextDrawSetShadow(PHONE[88], 1);
	TextDrawSetOutline(PHONE[88], 1);
	TextDrawBackgroundColour(PHONE[88], 0);
	TextDrawFont(PHONE[88], 1);
	TextDrawSetProportional(PHONE[88], 1);

	PHONE[89] = TextDrawCreate(510.000, 280.000, "Instagram");
	TextDrawLetterSize(PHONE[89], 0.158, 0.898);
	TextDrawAlignment(PHONE[89], 2);
	TextDrawColour(PHONE[89], -1);
	TextDrawSetShadow(PHONE[89], 1);
	TextDrawSetOutline(PHONE[89], 1);
	TextDrawBackgroundColour(PHONE[89], 0);
	TextDrawFont(PHONE[89], 1);
	TextDrawSetProportional(PHONE[89], 1);

	PHONE[90] = TextDrawCreate(399.000, 347.000, "_");
	TextDrawLetterSize(PHONE[90], -0.819, 4.197);
	TextDrawTextSize(PHONE[90], 526.000, 0.000);
	TextDrawAlignment(PHONE[90], 1);
	TextDrawColour(PHONE[90], -1);
	TextDrawUseBox(PHONE[90], 1);
	TextDrawBoxColour(PHONE[90], 124);
	TextDrawSetShadow(PHONE[90], 1);
	TextDrawSetOutline(PHONE[90], 1);
	TextDrawBackgroundColour(PHONE[90], 150);
	TextDrawFont(PHONE[90], 1);
	TextDrawSetProportional(PHONE[90], 1);

	PHONE[91] = TextDrawCreate(432.000, 350.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[91], 26.000, 31.000);
	TextDrawAlignment(PHONE[91], 1);
	TextDrawColour(PHONE[91], -1061109505);
	TextDrawSetShadow(PHONE[91], 0);
	TextDrawSetOutline(PHONE[91], 0);
	TextDrawBackgroundColour(PHONE[91], 255);
	TextDrawFont(PHONE[91], 4);
	TextDrawSetProportional(PHONE[91], 1);
	TextDrawSetSelectable(PHONE[91], 1);

	PHONE[92] = TextDrawCreate(402.000, 350.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[92], 26.000, 31.000);
	TextDrawAlignment(PHONE[92], 1);
	TextDrawColour(PHONE[92], 16711935);
	TextDrawSetShadow(PHONE[92], 0);
	TextDrawSetOutline(PHONE[92], 0);
	TextDrawBackgroundColour(PHONE[92], 255);
	TextDrawFont(PHONE[92], 4);
	TextDrawSetProportional(PHONE[92], 1);
	TextDrawSetSelectable(PHONE[92], 1);

	PHONE[93] = TextDrawCreate(465.000, 350.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[93], 26.000, 31.000);
	TextDrawAlignment(PHONE[93], 1);
	TextDrawColour(PHONE[93], -1);
	TextDrawSetShadow(PHONE[93], 0);
	TextDrawSetOutline(PHONE[93], 0);
	TextDrawBackgroundColour(PHONE[93], 255);
	TextDrawFont(PHONE[93], 4);
	TextDrawSetProportional(PHONE[93], 1);
	TextDrawSetSelectable(PHONE[93], 1);

	PHONE[94] = TextDrawCreate(496.000, 350.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[94], 26.000, 31.000);
	TextDrawAlignment(PHONE[94], 1);
	TextDrawColour(PHONE[94], -1962934017);
	TextDrawSetShadow(PHONE[94], 0);
	TextDrawSetOutline(PHONE[94], 0);
	TextDrawBackgroundColour(PHONE[94], 255);
	TextDrawFont(PHONE[94], 4);
	TextDrawSetProportional(PHONE[94], 1);
	TextDrawSetSelectable(PHONE[94], 1);

	PHONE[95] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(PHONE[95], 72.000, 3.000);
	TextDrawAlignment(PHONE[95], 1);
	TextDrawColour(PHONE[95], -1);
	TextDrawSetShadow(PHONE[95], 0);
	TextDrawSetOutline(PHONE[95], 0);
	TextDrawBackgroundColour(PHONE[95], 255);
	TextDrawFont(PHONE[95], 4);
	TextDrawSetProportional(PHONE[95], 1);
	TextDrawSetSelectable(PHONE[95], 1);

	PHONE[96] = TextDrawCreate(499.000, 364.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[96], 22.000, 17.000);
	TextDrawAlignment(PHONE[96], 1);
	TextDrawColour(PHONE[96], -1);
	TextDrawSetShadow(PHONE[96], 0);
	TextDrawSetOutline(PHONE[96], 0);
	TextDrawBackgroundColour(PHONE[96], 255);
	TextDrawFont(PHONE[96], 4);
	TextDrawSetProportional(PHONE[96], 1);

	PHONE[97] = TextDrawCreate(437.000, 357.000, "HUD:radar_tattoo");
	TextDrawTextSize(PHONE[97], 17.000, 16.000);
	TextDrawAlignment(PHONE[97], 1);
	TextDrawColour(PHONE[97], -1);
	TextDrawSetShadow(PHONE[97], 0);
	TextDrawSetOutline(PHONE[97], 0);
	TextDrawBackgroundColour(PHONE[97], 255);
	TextDrawFont(PHONE[97], 4);
	TextDrawSetProportional(PHONE[97], 1);

	PHONE[98] = TextDrawCreate(425.000, 391.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[98], 4.000, 5.000);
	TextDrawAlignment(PHONE[98], 1);
	TextDrawColour(PHONE[98], -1);
	TextDrawSetShadow(PHONE[98], 0);
	TextDrawSetOutline(PHONE[98], 0);
	TextDrawBackgroundColour(PHONE[98], 255);
	TextDrawFont(PHONE[98], 4);
	TextDrawSetProportional(PHONE[98], 1);

	PHONE[99] = TextDrawCreate(496.000, 391.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[99], 4.000, 5.000);
	TextDrawAlignment(PHONE[99], 1);
	TextDrawColour(PHONE[99], -1);
	TextDrawSetShadow(PHONE[99], 0);
	TextDrawSetOutline(PHONE[99], 0);
	TextDrawBackgroundColour(PHONE[99], 255);
	TextDrawFont(PHONE[99], 4);
	TextDrawSetProportional(PHONE[99], 1);

	PHONE[100] = TextDrawCreate(411.000, 353.000, "C");
	TextDrawLetterSize(PHONE[100], 0.270, 3.098);
	TextDrawAlignment(PHONE[100], 1);
	TextDrawColour(PHONE[100], -1);
	TextDrawSetShadow(PHONE[100], 1);
	TextDrawSetOutline(PHONE[100], 1);
	TextDrawBackgroundColour(PHONE[100], 150);
	TextDrawFont(PHONE[100], 2);
	TextDrawSetProportional(PHONE[100], 1);

	PHONE[101] = TextDrawCreate(474.000, 352.000, "A");
	TextDrawLetterSize(PHONE[101], 0.458, 2.499);
	TextDrawAlignment(PHONE[101], 1);
	TextDrawColour(PHONE[101], -1);
	TextDrawSetShadow(PHONE[101], 1);
	TextDrawSetOutline(PHONE[101], 1);
	TextDrawBackgroundColour(PHONE[101], 150);
	TextDrawFont(PHONE[101], 1);
	TextDrawSetProportional(PHONE[101], 1);

	PHONE[102] = TextDrawCreate(503.000, 351.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[102], 14.000, 18.000);
	TextDrawAlignment(PHONE[102], 1);
	TextDrawColour(PHONE[102], -1);
	TextDrawSetShadow(PHONE[102], 0);
	TextDrawSetOutline(PHONE[102], 0);
	TextDrawBackgroundColour(PHONE[102], 255);
	TextDrawFont(PHONE[102], 4);
	TextDrawSetProportional(PHONE[102], 1);

	PHONE[103] = TextDrawCreate(415.000, 380.000, "Call");
	TextDrawLetterSize(PHONE[103], 0.158, 0.697);
	TextDrawAlignment(PHONE[103], 2);
	TextDrawColour(PHONE[103], -1);
	TextDrawSetShadow(PHONE[103], 1);
	TextDrawSetOutline(PHONE[103], 1);
	TextDrawBackgroundColour(PHONE[103], 0);
	TextDrawFont(PHONE[103], 1);
	TextDrawSetProportional(PHONE[103], 1);

	PHONE[104] = TextDrawCreate(445.000, 380.000, "Settings");
	TextDrawLetterSize(PHONE[104], 0.158, 0.697);
	TextDrawAlignment(PHONE[104], 2);
	TextDrawColour(PHONE[104], -1);
	TextDrawSetShadow(PHONE[104], 1);
	TextDrawSetOutline(PHONE[104], 1);
	TextDrawBackgroundColour(PHONE[104], 0);
	TextDrawFont(PHONE[104], 1);
	TextDrawSetProportional(PHONE[104], 1);

	PHONE[105] = TextDrawCreate(478.000, 380.000, "Appstore");
	TextDrawLetterSize(PHONE[105], 0.158, 0.697);
	TextDrawAlignment(PHONE[105], 2);
	TextDrawColour(PHONE[105], -1);
	TextDrawSetShadow(PHONE[105], 1);
	TextDrawSetOutline(PHONE[105], 1);
	TextDrawBackgroundColour(PHONE[105], 0);
	TextDrawFont(PHONE[105], 1);
	TextDrawSetProportional(PHONE[105], 1);

	PHONE[106] = TextDrawCreate(510.000, 380.000, "Contact");
	TextDrawLetterSize(PHONE[106], 0.158, 0.697);
	TextDrawAlignment(PHONE[106], 2);
	TextDrawColour(PHONE[106], -1);
	TextDrawSetShadow(PHONE[106], 1);
	TextDrawSetOutline(PHONE[106], 1);
	TextDrawBackgroundColour(PHONE[106], 0);
	TextDrawFont(PHONE[106], 1);
	TextDrawSetProportional(PHONE[106], 1);

	PHONE[107] = TextDrawCreate(499.000, 252.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[107], 21.000, 24.000);
	TextDrawAlignment(PHONE[107], 1);
	TextDrawColour(PHONE[107], -16711681);
	TextDrawSetShadow(PHONE[107], 0);
	TextDrawSetOutline(PHONE[107], 0);
	TextDrawBackgroundColour(PHONE[107], 255);
	TextDrawFont(PHONE[107], 4);
	TextDrawSetProportional(PHONE[107], 1);

	PHONE[108] = TextDrawCreate(516.000, 252.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONE[108], 4.000, 4.000);
	TextDrawAlignment(PHONE[108], 1);
	TextDrawColour(PHONE[108], -16711681);
	TextDrawSetShadow(PHONE[108], 0);
	TextDrawSetOutline(PHONE[108], 0);
	TextDrawBackgroundColour(PHONE[108], 255);
	TextDrawFont(PHONE[108], 4);
	TextDrawSetProportional(PHONE[108], 1);


		//PHONELOCK
	PHONELOCK[0] = TextDrawCreate(401.000, 114.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[0], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[0], 122.500, 293.000);
	TextDrawAlignment(PHONELOCK[0], 1);
	TextDrawColour(PHONELOCK[0], -1094795521);
	TextDrawSetShadow(PHONELOCK[0], 0);
	TextDrawSetOutline(PHONELOCK[0], 1);
	TextDrawBackgroundColour(PHONELOCK[0], 255);
	TextDrawFont(PHONELOCK[0], 4);
	TextDrawSetProportional(PHONELOCK[0], 1);

	PHONELOCK[1] = TextDrawCreate(390.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[1], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[1], 144.500, 269.000);
	TextDrawAlignment(PHONELOCK[1], 1);
	TextDrawColour(PHONELOCK[1], -1094795521);
	TextDrawSetShadow(PHONELOCK[1], 0);
	TextDrawSetOutline(PHONELOCK[1], 1);
	TextDrawBackgroundColour(PHONELOCK[1], 255);
	TextDrawFont(PHONELOCK[1], 4);
	TextDrawSetProportional(PHONELOCK[1], 1);

	PHONELOCK[2] = TextDrawCreate(385.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[2], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[2], 33.000, 31.500);
	TextDrawAlignment(PHONELOCK[2], 1);
	TextDrawColour(PHONELOCK[2], -1094795521);
	TextDrawSetShadow(PHONELOCK[2], 0);
	TextDrawSetOutline(PHONELOCK[2], 1);
	TextDrawBackgroundColour(PHONELOCK[2], 255);
	TextDrawFont(PHONELOCK[2], 4);
	TextDrawSetProportional(PHONELOCK[2], 1);

	PHONELOCK[3] = TextDrawCreate(507.500, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[3], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[3], 32.000, 33.000);
	TextDrawAlignment(PHONELOCK[3], 1);
	TextDrawColour(PHONELOCK[3], -1094795521);
	TextDrawSetShadow(PHONELOCK[3], 0);
	TextDrawSetOutline(PHONELOCK[3], 1);
	TextDrawBackgroundColour(PHONELOCK[3], 255);
	TextDrawFont(PHONELOCK[3], 4);
	TextDrawSetProportional(PHONELOCK[3], 1);

	PHONELOCK[4] = TextDrawCreate(508.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[4], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[4], 32.000, 32.000);
	TextDrawAlignment(PHONELOCK[4], 1);
	TextDrawColour(PHONELOCK[4], -1094795521);
	TextDrawSetShadow(PHONELOCK[4], 0);
	TextDrawSetOutline(PHONELOCK[4], 1);
	TextDrawBackgroundColour(PHONELOCK[4], 255);
	TextDrawFont(PHONELOCK[4], 4);
	TextDrawSetProportional(PHONELOCK[4], 1);

	PHONELOCK[5] = TextDrawCreate(385.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[5], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[5], 32.000, 32.000);
	TextDrawAlignment(PHONELOCK[5], 1);
	TextDrawColour(PHONELOCK[5], -1094795521);
	TextDrawSetShadow(PHONELOCK[5], 0);
	TextDrawSetOutline(PHONELOCK[5], 1);
	TextDrawBackgroundColour(PHONELOCK[5], 255);
	TextDrawFont(PHONELOCK[5], 4);
	TextDrawSetProportional(PHONELOCK[5], 1);

	PHONELOCK[6] = TextDrawCreate(387.000, 110.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[6], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[6], 27.000, 31.500);
	TextDrawAlignment(PHONELOCK[6], 1);
	TextDrawColour(PHONELOCK[6], 255);
	TextDrawSetShadow(PHONELOCK[6], 0);
	TextDrawSetOutline(PHONELOCK[6], 1);
	TextDrawBackgroundColour(PHONELOCK[6], 255);
	TextDrawFont(PHONELOCK[6], 4);
	TextDrawSetProportional(PHONELOCK[6], 1);

	PHONELOCK[7] = TextDrawCreate(389.000, 113.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[7], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[7], 29.000, 29.500);
	TextDrawAlignment(PHONELOCK[7], 1);
	TextDrawColour(PHONELOCK[7], 255);
	TextDrawSetShadow(PHONELOCK[7], 0);
	TextDrawSetOutline(PHONELOCK[7], 1);
	TextDrawBackgroundColour(PHONELOCK[7], 255);
	TextDrawFont(PHONELOCK[7], 4);
	TextDrawSetProportional(PHONELOCK[7], 1);

	PHONELOCK[8] = TextDrawCreate(391.500, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[8], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[8], 141.500, 269.000);
	TextDrawAlignment(PHONELOCK[8], 1);
	TextDrawColour(PHONELOCK[8], 255);
	TextDrawSetShadow(PHONELOCK[8], 0);
	TextDrawSetOutline(PHONELOCK[8], 1);
	TextDrawBackgroundColour(PHONELOCK[8], 255);
	TextDrawFont(PHONELOCK[8], 4);
	TextDrawSetProportional(PHONELOCK[8], 1);

	PHONELOCK[9] = TextDrawCreate(463.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[9], -2.000, -6.000);
	TextDrawAlignment(PHONELOCK[9], 1);
	TextDrawColour(PHONELOCK[9], 548580095);
	TextDrawSetShadow(PHONELOCK[9], 0);
	TextDrawSetOutline(PHONELOCK[9], 0);
	TextDrawBackgroundColour(PHONELOCK[9], 255);
	TextDrawFont(PHONELOCK[9], 4);
	TextDrawSetProportional(PHONELOCK[9], 1);

	PHONELOCK[10] = TextDrawCreate(504.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[10], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[10], 34.700, 37.000);
	TextDrawAlignment(PHONELOCK[10], 1);
	TextDrawColour(PHONELOCK[10], 255);
	TextDrawSetShadow(PHONELOCK[10], 0);
	TextDrawSetOutline(PHONELOCK[10], 1);
	TextDrawBackgroundColour(PHONELOCK[10], 255);
	TextDrawFont(PHONELOCK[10], 4);
	TextDrawSetProportional(PHONELOCK[10], 1);

	PHONELOCK[11] = TextDrawCreate(506.000, 377.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[11], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[11], 32.500, 34.500);
	TextDrawAlignment(PHONELOCK[11], 1);
	TextDrawColour(PHONELOCK[11], 255);
	TextDrawSetShadow(PHONELOCK[11], 0);
	TextDrawSetOutline(PHONELOCK[11], 1);
	TextDrawBackgroundColour(PHONELOCK[11], 255);
	TextDrawFont(PHONELOCK[11], 4);
	TextDrawSetProportional(PHONELOCK[11], 1);

	PHONELOCK[12] = TextDrawCreate(386.299, 377.299, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[12], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[12], 33.000, 34.000);
	TextDrawAlignment(PHONELOCK[12], 1);
	TextDrawColour(PHONELOCK[12], 255);
	TextDrawSetShadow(PHONELOCK[12], 0);
	TextDrawSetOutline(PHONELOCK[12], 1);
	TextDrawBackgroundColour(PHONELOCK[12], 255);
	TextDrawFont(PHONELOCK[12], 4);
	TextDrawSetProportional(PHONELOCK[12], 1);

	PHONELOCK[13] = TextDrawCreate(395.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[13], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[13], 62.000, 263.000);
	TextDrawAlignment(PHONELOCK[13], 1);
	TextDrawColour(PHONELOCK[13], 8421631);
	TextDrawSetShadow(PHONELOCK[13], 0);
	TextDrawSetOutline(PHONELOCK[13], 1);
	TextDrawBackgroundColour(PHONELOCK[13], 255);
	TextDrawFont(PHONELOCK[13], 4);
	TextDrawSetProportional(PHONELOCK[13], 1);

	PHONELOCK[14] = TextDrawCreate(402.000, 115.097, "LD_SPAC:black");
	TextDrawTextSize(PHONELOCK[14], 118.000, 15.000);
	TextDrawAlignment(PHONELOCK[14], 1);
	TextDrawColour(PHONELOCK[14], -1);
	TextDrawSetShadow(PHONELOCK[14], 0);
	TextDrawSetOutline(PHONELOCK[14], 0);
	TextDrawBackgroundColour(PHONELOCK[14], 255);
	TextDrawFont(PHONELOCK[14], 4);
	TextDrawSetProportional(PHONELOCK[14], 1);

	PHONELOCK[15] = TextDrawCreate(404.000, 395.100, "LD_SPAC:black");
	TextDrawTextSize(PHONELOCK[15], 118.000, 10.500);
	TextDrawAlignment(PHONELOCK[15], 1);
	TextDrawColour(PHONELOCK[15], -1);
	TextDrawSetShadow(PHONELOCK[15], 0);
	TextDrawSetOutline(PHONELOCK[15], 0);
	TextDrawBackgroundColour(PHONELOCK[15], 255);
	TextDrawFont(PHONELOCK[15], 4);
	TextDrawSetProportional(PHONELOCK[15], 1);

	PHONELOCK[16] = TextDrawCreate(457.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[16], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[16], 75.500, 264.000);
	TextDrawAlignment(PHONELOCK[16], 1);
	TextDrawColour(PHONELOCK[16], 255);
	TextDrawSetShadow(PHONELOCK[16], 0);
	TextDrawSetOutline(PHONELOCK[16], 1);
	TextDrawBackgroundColour(PHONELOCK[16], 255);
	TextDrawFont(PHONELOCK[16], 4);
	TextDrawSetProportional(PHONELOCK[16], 1);

	PHONELOCK[17] = TextDrawCreate(400.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[17], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[17], 61.000, 280.000);
	TextDrawAlignment(PHONELOCK[17], 1);
	TextDrawColour(PHONELOCK[17], 8421631);
	TextDrawSetShadow(PHONELOCK[17], 0);
	TextDrawSetOutline(PHONELOCK[17], 1);
	TextDrawBackgroundColour(PHONELOCK[17], 255);
	TextDrawFont(PHONELOCK[17], 4);
	TextDrawSetProportional(PHONELOCK[17], 1);

	PHONELOCK[18] = TextDrawCreate(389.000, 375.000, "ld_beat:chit");
	TextDrawLetterSize(PHONELOCK[18], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[18], 31.000, 31.500);
	TextDrawAlignment(PHONELOCK[18], 1);
	TextDrawColour(PHONELOCK[18], 0);
	TextDrawSetShadow(PHONELOCK[18], 0);
	TextDrawSetOutline(PHONELOCK[18], 1);
	TextDrawBackgroundColour(PHONELOCK[18], 255);
	TextDrawFont(PHONELOCK[18], 4);
	TextDrawSetProportional(PHONELOCK[18], 1);

	PHONELOCK[19] = TextDrawCreate(391.500, 378.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[19], 23.000, 26.500);
	TextDrawAlignment(PHONELOCK[19], 1);
	TextDrawColour(PHONELOCK[19], 8421631);
	TextDrawSetShadow(PHONELOCK[19], 0);
	TextDrawSetOutline(PHONELOCK[19], 0);
	TextDrawBackgroundColour(PHONELOCK[19], 255);
	TextDrawFont(PHONELOCK[19], 4);
	TextDrawSetProportional(PHONELOCK[19], 1);

	PHONELOCK[20] = TextDrawCreate(467.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(PHONELOCK[20], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[20], 62.000, 263.000);
	TextDrawAlignment(PHONELOCK[20], 1);
	TextDrawColour(PHONELOCK[20], 13554175);
	TextDrawSetShadow(PHONELOCK[20], 0);
	TextDrawSetOutline(PHONELOCK[20], 1);
	TextDrawBackgroundColour(PHONELOCK[20], 255);
	TextDrawFont(PHONELOCK[20], 4);
	TextDrawSetProportional(PHONELOCK[20], 1);

	PHONELOCK[21] = TextDrawCreate(462.000, 120.500, "ld_bum:blkdot"); // for apps 460, 120.500
	TextDrawLetterSize(PHONELOCK[21], 0.600, 2.000);
	TextDrawTextSize(PHONELOCK[21], 62.000, 280.000); //63
	TextDrawAlignment(PHONELOCK[21], 1);
	TextDrawColour(PHONELOCK[21], 13554175);
	TextDrawSetShadow(PHONELOCK[21], 0);
	TextDrawSetOutline(PHONELOCK[21], 1);
	TextDrawBackgroundColour(PHONELOCK[21], 255);
	TextDrawFont(PHONELOCK[21], 4);
	TextDrawSetProportional(PHONELOCK[21], 1);

	PHONELOCK[22] = TextDrawCreate(509.500, 377.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[22], 24.000, 28.500);
	TextDrawAlignment(PHONELOCK[22], 1);
	TextDrawColour(PHONELOCK[22], 13554175);
	TextDrawSetShadow(PHONELOCK[22], 0);
	TextDrawSetOutline(PHONELOCK[22], 0);
	TextDrawBackgroundColour(PHONELOCK[22], 255);
	TextDrawFont(PHONELOCK[22], 4);
	TextDrawSetProportional(PHONELOCK[22], 1);

	PHONELOCK[23] = TextDrawCreate(392.000, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[23], 20.000, 24.000);
	TextDrawAlignment(PHONELOCK[23], 1);
	TextDrawColour(PHONELOCK[23], 8421631);
	TextDrawSetShadow(PHONELOCK[23], 0);
	TextDrawSetOutline(PHONELOCK[23], 0);
	TextDrawBackgroundColour(PHONELOCK[23], 255);
	TextDrawFont(PHONELOCK[23], 4);
	TextDrawSetProportional(PHONELOCK[23], 1);

	PHONELOCK[24] = TextDrawCreate(509.500, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[24], 24.000, 24.500);
	TextDrawAlignment(PHONELOCK[24], 1);
	TextDrawColour(PHONELOCK[24], 13554175);
	TextDrawSetShadow(PHONELOCK[24], 0);
	TextDrawSetOutline(PHONELOCK[24], 0);
	TextDrawBackgroundColour(PHONELOCK[24], 255);
	TextDrawFont(PHONELOCK[24], 4);
	TextDrawSetProportional(PHONELOCK[24], 1);

	PHONELOCK[25] = TextDrawCreate(400.000, 124.000, "AKRP");
	TextDrawLetterSize(PHONELOCK[25], 0.200, 0.898);
	TextDrawAlignment(PHONELOCK[25], 1);
	TextDrawColour(PHONELOCK[25], -1);
	TextDrawSetShadow(PHONELOCK[25], 1);
	TextDrawSetOutline(PHONELOCK[25], 1);
	TextDrawBackgroundColour(PHONELOCK[25], 0);
	TextDrawFont(PHONELOCK[25], 2);
	TextDrawSetProportional(PHONELOCK[25], 1);

	PHONELOCK[26] = TextDrawCreate(429.000, 135.000, "LD_SPAC:black");
	TextDrawTextSize(PHONELOCK[26], 66.000, -11.000);
	TextDrawAlignment(PHONELOCK[26], 1);
	TextDrawColour(PHONELOCK[26], -1);
	TextDrawSetShadow(PHONELOCK[26], 0);
	TextDrawSetOutline(PHONELOCK[26], 0);
	TextDrawBackgroundColour(PHONELOCK[26], 255);
	TextDrawFont(PHONELOCK[26], 4);
	TextDrawSetProportional(PHONELOCK[26], 1);

	PHONELOCK[27] = TextDrawCreate(423.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[27], 16.000, 17.000);
	TextDrawAlignment(PHONELOCK[27], 1);
	TextDrawColour(PHONELOCK[27], 255);
	TextDrawSetShadow(PHONELOCK[27], 0);
	TextDrawSetOutline(PHONELOCK[27], 0);
	TextDrawBackgroundColour(PHONELOCK[27], 255);
	TextDrawFont(PHONELOCK[27], 4);
	TextDrawSetProportional(PHONELOCK[27], 1);

	PHONELOCK[28] = TextDrawCreate(485.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[28], 16.000, 17.000);
	TextDrawAlignment(PHONELOCK[28], 1);
	TextDrawColour(PHONELOCK[28], 255);
	TextDrawSetShadow(PHONELOCK[28], 0);
	TextDrawSetOutline(PHONELOCK[28], 0);
	TextDrawBackgroundColour(PHONELOCK[28], 255);
	TextDrawFont(PHONELOCK[28], 4);
	TextDrawSetProportional(PHONELOCK[28], 1);

	PHONELOCK[29] = TextDrawCreate(508.000, 122.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[29], 2.000, 12.000);
	TextDrawAlignment(PHONELOCK[29], 1);
	TextDrawColour(PHONELOCK[29], -1);
	TextDrawSetShadow(PHONELOCK[29], 0);
	TextDrawSetOutline(PHONELOCK[29], 0);
	TextDrawBackgroundColour(PHONELOCK[29], 255);
	TextDrawFont(PHONELOCK[29], 4);
	TextDrawSetProportional(PHONELOCK[29], 1);

	PHONELOCK[30] = TextDrawCreate(505.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[30], 2.000, -8.000);
	TextDrawAlignment(PHONELOCK[30], 1);
	TextDrawColour(PHONELOCK[30], -1);
	TextDrawSetShadow(PHONELOCK[30], 0);
	TextDrawSetOutline(PHONELOCK[30], 0);
	TextDrawBackgroundColour(PHONELOCK[30], 255);
	TextDrawFont(PHONELOCK[30], 4);
	TextDrawSetProportional(PHONELOCK[30], 1);

	PHONELOCK[31] = TextDrawCreate(502.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[31], 2.000, -5.000);
	TextDrawAlignment(PHONELOCK[31], 1);
	TextDrawColour(PHONELOCK[31], -1);
	TextDrawSetShadow(PHONELOCK[31], 0);
	TextDrawSetOutline(PHONELOCK[31], 0);
	TextDrawBackgroundColour(PHONELOCK[31], 255);
	TextDrawFont(PHONELOCK[31], 4);
	TextDrawSetProportional(PHONELOCK[31], 1);

	PHONELOCK[32] = TextDrawCreate(499.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[32], 2.000, -2.000);
	TextDrawAlignment(PHONELOCK[32], 1);
	TextDrawColour(PHONELOCK[32], -1);
	TextDrawSetShadow(PHONELOCK[32], 0);
	TextDrawSetOutline(PHONELOCK[32], 0);
	TextDrawBackgroundColour(PHONELOCK[32], 255);
	TextDrawFont(PHONELOCK[32], 4);
	TextDrawSetProportional(PHONELOCK[32], 1);

	PHONELOCK[33] = TextDrawCreate(514.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[33], 10.000, -8.000);
	TextDrawAlignment(PHONELOCK[33], 1);
	TextDrawColour(PHONELOCK[33], -1);
	TextDrawSetShadow(PHONELOCK[33], 0);
	TextDrawSetOutline(PHONELOCK[33], 0);
	TextDrawBackgroundColour(PHONELOCK[33], 255);
	TextDrawFont(PHONELOCK[33], 4);
	TextDrawSetProportional(PHONELOCK[33], 1);

	PHONELOCK[34] = TextDrawCreate(523.000, 132.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[34], 3.000, -4.000);
	TextDrawAlignment(PHONELOCK[34], 1);
	TextDrawColour(PHONELOCK[34], -1);
	TextDrawSetShadow(PHONELOCK[34], 0);
	TextDrawSetOutline(PHONELOCK[34], 0);
	TextDrawBackgroundColour(PHONELOCK[34], 255);
	TextDrawFont(PHONELOCK[34], 4);
	TextDrawSetProportional(PHONELOCK[34], 1);

	PHONELOCK[35] = TextDrawCreate(426.000, 153.000, "12:00");
	TextDrawLetterSize(PHONELOCK[35], 0.680, 6.399);
	TextDrawAlignment(PHONELOCK[35], 1);
	TextDrawColour(PHONELOCK[35], -1);
	TextDrawSetShadow(PHONELOCK[35], 1);
	TextDrawSetOutline(PHONELOCK[35], 1);
	TextDrawBackgroundColour(PHONELOCK[35], 0);
	TextDrawFont(PHONELOCK[35], 2);
	TextDrawSetProportional(PHONELOCK[35], 1);

	PHONELOCK[36] = TextDrawCreate(418.000, 199.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[36], 92.000, 1.000);
	TextDrawAlignment(PHONELOCK[36], 1);
	TextDrawColour(PHONELOCK[36], -1);
	TextDrawSetShadow(PHONELOCK[36], 0);
	TextDrawSetOutline(PHONELOCK[36], 0);
	TextDrawBackgroundColour(PHONELOCK[36], 255);
	TextDrawFont(PHONELOCK[36], 4);
	TextDrawSetProportional(PHONELOCK[36], 1);

	PHONELOCK[37] = TextDrawCreate(447.000, 202.000, "1/12/2023");
	TextDrawLetterSize(PHONELOCK[37], 0.160, 0.899);
	TextDrawAlignment(PHONELOCK[37], 1);
	TextDrawColour(PHONELOCK[37], -1);
	TextDrawSetShadow(PHONELOCK[37], 1);
	TextDrawSetOutline(PHONELOCK[37], 1);
	TextDrawBackgroundColour(PHONELOCK[37], 0);
	TextDrawFont(PHONELOCK[37], 2);
	TextDrawSetProportional(PHONELOCK[37], 1);

	PHONELOCK[38] = TextDrawCreate(418.000, 216.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[38], 92.000, 1.000);
	TextDrawAlignment(PHONELOCK[38], 1);
	TextDrawColour(PHONELOCK[38], -1);
	TextDrawSetShadow(PHONELOCK[38], 0);
	TextDrawSetOutline(PHONELOCK[38], 0);
	TextDrawBackgroundColour(PHONELOCK[38], 255);
	TextDrawFont(PHONELOCK[38], 4);
	TextDrawSetProportional(PHONELOCK[38], 1);

	PHONELOCK[39] = TextDrawCreate(444.000, 323.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[39], 37.000, 43.000);
	TextDrawAlignment(PHONELOCK[39], 1);
	TextDrawColour(PHONELOCK[39], -1);
	TextDrawSetShadow(PHONELOCK[39], 0);
	TextDrawSetOutline(PHONELOCK[39], 0);
	TextDrawBackgroundColour(PHONELOCK[39], 255);
	TextDrawFont(PHONELOCK[39], 4);
	TextDrawSetProportional(PHONELOCK[39], 1);

	PHONELOCK[40] = TextDrawCreate(446.000, 325.000, "LD_BEAT:chit");
	TextDrawTextSize(PHONELOCK[40], 33.000, 39.000);
	TextDrawAlignment(PHONELOCK[40], 1);
	TextDrawColour(PHONELOCK[40], -1343295745);
	TextDrawSetShadow(PHONELOCK[40], 0);
	TextDrawSetOutline(PHONELOCK[40], 0);
	TextDrawBackgroundColour(PHONELOCK[40], 255);
	TextDrawFont(PHONELOCK[40], 4);
	TextDrawSetProportional(PHONELOCK[40], 1);
	TextDrawSetSelectable(PHONELOCK[40], 1);

	PHONELOCK[41] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(PHONELOCK[41], 72.000, 3.000);
	TextDrawAlignment(PHONELOCK[41], 1);
	TextDrawColour(PHONELOCK[41], -1);
	TextDrawSetShadow(PHONELOCK[41], 0);
	TextDrawSetOutline(PHONELOCK[41], 0);
	TextDrawBackgroundColour(PHONELOCK[41], 255);
	TextDrawFont(PHONELOCK[41], 4);
	TextDrawSetProportional(PHONELOCK[41], 1);
	TextDrawSetSelectable(PHONELOCK[41], 1);
	

    APPLOCK[0] = TextDrawCreate(401.000, 114.000, "ld_bum:blkdot");
    TextDrawLetterSize(APPLOCK[0], 0.600, 2.000);
    TextDrawTextSize(APPLOCK[0], 122.500, 293.000);
    TextDrawAlignment(APPLOCK[0], 1);
    TextDrawColour(APPLOCK[0], -1094795521);
    TextDrawSetShadow(APPLOCK[0], 0);
    TextDrawSetOutline(APPLOCK[0], 1);
    TextDrawBackgroundColour(APPLOCK[0], 255);
    TextDrawFont(APPLOCK[0], 4);
    TextDrawSetProportional(APPLOCK[0], 1);

    APPLOCK[1] = TextDrawCreate(390.000, 127.000, "ld_bum:blkdot");
    TextDrawLetterSize(APPLOCK[1], 0.600, 2.000);
    TextDrawTextSize(APPLOCK[1], 144.500, 269.000);
    TextDrawAlignment(APPLOCK[1], 1);
    TextDrawColour(APPLOCK[1], -1094795521);
    TextDrawSetShadow(APPLOCK[1], 0);
    TextDrawSetOutline(APPLOCK[1], 1);
    TextDrawBackgroundColour(APPLOCK[1], 255);
    TextDrawFont(APPLOCK[1], 4);
    TextDrawSetProportional(APPLOCK[1], 1);

    APPLOCK[2] = TextDrawCreate(385.000, 109.000, "ld_beat:chit");
    TextDrawLetterSize(APPLOCK[2], 0.600, 2.000);
    TextDrawTextSize(APPLOCK[2], 33.000, 31.500);
    TextDrawAlignment(APPLOCK[2], 1);
    TextDrawColour(APPLOCK[2], -1094795521);
    TextDrawSetShadow(APPLOCK[2], 0);
    TextDrawSetOutline(APPLOCK[2], 1);
    TextDrawBackgroundColour(APPLOCK[2], 255);
    TextDrawFont(APPLOCK[2], 4);
    TextDrawSetProportional(APPLOCK[2], 1);

	APPLOCK[3] = TextDrawCreate(507.500, 109.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[3], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[3], 32.000, 33.000);
	TextDrawAlignment(APPLOCK[3], 1);
	TextDrawColour(APPLOCK[3], -1094795521);
	TextDrawSetShadow(APPLOCK[3], 0);
	TextDrawSetOutline(APPLOCK[3], 1);
	TextDrawBackgroundColour(APPLOCK[3], 255);
	TextDrawFont(APPLOCK[3], 4);
	TextDrawSetProportional(APPLOCK[3], 1);

	APPLOCK[4] = TextDrawCreate(508.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[4], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[4], 32.000, 32.000);
	TextDrawAlignment(APPLOCK[4], 1);
	TextDrawColour(APPLOCK[4], -1094795521);
	TextDrawSetShadow(APPLOCK[4], 0);
	TextDrawSetOutline(APPLOCK[4], 1);
	TextDrawBackgroundColour(APPLOCK[4], 255);
	TextDrawFont(APPLOCK[4], 4);
	TextDrawSetProportional(APPLOCK[4], 1);

	APPLOCK[5] = TextDrawCreate(385.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[5], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[5], 32.000, 32.000);
	TextDrawAlignment(APPLOCK[5], 1);
	TextDrawColour(APPLOCK[5], -1094795521);
	TextDrawSetShadow(APPLOCK[5], 0);
	TextDrawSetOutline(APPLOCK[5], 1);
	TextDrawBackgroundColour(APPLOCK[5], 255);
	TextDrawFont(APPLOCK[5], 4);
	TextDrawSetProportional(APPLOCK[5], 1);

	APPLOCK[6] = TextDrawCreate(387.000, 110.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[6], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[6], 27.000, 31.500);
	TextDrawAlignment(APPLOCK[6], 1);
	TextDrawColour(APPLOCK[6], 255);
	TextDrawSetShadow(APPLOCK[6], 0);
	TextDrawSetOutline(APPLOCK[6], 1);
	TextDrawBackgroundColour(APPLOCK[6], 255);
	TextDrawFont(APPLOCK[6], 4);
	TextDrawSetProportional(APPLOCK[6], 1);

	APPLOCK[7] = TextDrawCreate(389.000, 113.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[7], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[7], 29.000, 29.500);
	TextDrawAlignment(APPLOCK[7], 1);
	TextDrawColour(APPLOCK[7], 255);
	TextDrawSetShadow(APPLOCK[7], 0);
	TextDrawSetOutline(APPLOCK[7], 1);
	TextDrawBackgroundColour(APPLOCK[7], 255);
	TextDrawFont(APPLOCK[7], 4);
	TextDrawSetProportional(APPLOCK[7], 1);

	APPLOCK[8] = TextDrawCreate(391.500, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[8], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[8], 141.500, 269.000);
	TextDrawAlignment(APPLOCK[8], 1);
	TextDrawColour(APPLOCK[8], 255);
	TextDrawSetShadow(APPLOCK[8], 0);
	TextDrawSetOutline(APPLOCK[8], 1);
	TextDrawBackgroundColour(APPLOCK[8], 255);
	TextDrawFont(APPLOCK[8], 4);
	TextDrawSetProportional(APPLOCK[8], 1);

	APPLOCK[9] = TextDrawCreate(463.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[9], -2.000, -6.000);
	TextDrawAlignment(APPLOCK[9], 1);
	TextDrawColour(APPLOCK[9], 548580095);
	TextDrawSetShadow(APPLOCK[9], 0);
	TextDrawSetOutline(APPLOCK[9], 0);
	TextDrawBackgroundColour(APPLOCK[9], 255);
	TextDrawFont(APPLOCK[9], 4);
	TextDrawSetProportional(APPLOCK[9], 1);

	APPLOCK[10] = TextDrawCreate(504.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[10], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[10], 34.700, 37.000);
	TextDrawAlignment(APPLOCK[10], 1);
	TextDrawColour(APPLOCK[10], 255);
	TextDrawSetShadow(APPLOCK[10], 0);
	TextDrawSetOutline(APPLOCK[10], 1);
	TextDrawBackgroundColour(APPLOCK[10], 255);
	TextDrawFont(APPLOCK[10], 4);
	TextDrawSetProportional(APPLOCK[10], 1);

	APPLOCK[11] = TextDrawCreate(506.000, 377.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[11], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[11], 32.500, 34.500);
	TextDrawAlignment(APPLOCK[11], 1);
	TextDrawColour(APPLOCK[11], 255);
	TextDrawSetShadow(APPLOCK[11], 0);
	TextDrawSetOutline(APPLOCK[11], 1);
	TextDrawBackgroundColour(APPLOCK[11], 255);
	TextDrawFont(APPLOCK[11], 4);
	TextDrawSetProportional(APPLOCK[11], 1);

	APPLOCK[12] = TextDrawCreate(386.299, 377.299, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[12], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[12], 33.000, 34.000);
	TextDrawAlignment(APPLOCK[12], 1);
	TextDrawColour(APPLOCK[12], 255);
	TextDrawSetShadow(APPLOCK[12], 0);
	TextDrawSetOutline(APPLOCK[12], 1);
	TextDrawBackgroundColour(APPLOCK[12], 255);
	TextDrawFont(APPLOCK[12], 4);
	TextDrawSetProportional(APPLOCK[12], 1);

	APPLOCK[13] = TextDrawCreate(395.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[13], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[13], 62.000, 263.000);
	TextDrawAlignment(APPLOCK[13], 1);
	TextDrawColour(APPLOCK[13], -252116993);
	TextDrawSetShadow(APPLOCK[13], 0);
	TextDrawSetOutline(APPLOCK[13], 1);
	TextDrawBackgroundColour(APPLOCK[13], 255);
	TextDrawFont(APPLOCK[13], 4);
	TextDrawSetProportional(APPLOCK[13], 1);

	APPLOCK[14] = TextDrawCreate(402.000, 115.097, "LD_SPAC:black");
	TextDrawTextSize(APPLOCK[14], 118.000, 15.000);
	TextDrawAlignment(APPLOCK[14], 1);
	TextDrawColour(APPLOCK[14], -1);
	TextDrawSetShadow(APPLOCK[14], 0);
	TextDrawSetOutline(APPLOCK[14], 0);
	TextDrawBackgroundColour(APPLOCK[14], 255);
	TextDrawFont(APPLOCK[14], 4);
	TextDrawSetProportional(APPLOCK[14], 1);

	APPLOCK[15] = TextDrawCreate(404.000, 395.100, "LD_SPAC:black");
	TextDrawTextSize(APPLOCK[15], 118.000, 10.500);
	TextDrawAlignment(APPLOCK[15], 1);
	TextDrawColour(APPLOCK[15], -1);
	TextDrawSetShadow(APPLOCK[15], 0);
	TextDrawSetOutline(APPLOCK[15], 0);
	TextDrawBackgroundColour(APPLOCK[15], 255);
	TextDrawFont(APPLOCK[15], 4);
	TextDrawSetProportional(APPLOCK[15], 1);

	APPLOCK[16] = TextDrawCreate(457.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[16], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[16], 75.500, 264.000);
	TextDrawAlignment(APPLOCK[16], 1);
	TextDrawColour(APPLOCK[16], 255);
	TextDrawSetShadow(APPLOCK[16], 0);
	TextDrawSetOutline(APPLOCK[16], 1);
	TextDrawBackgroundColour(APPLOCK[16], 255);
	TextDrawFont(APPLOCK[16], 4);
	TextDrawSetProportional(APPLOCK[16], 1);

	APPLOCK[17] = TextDrawCreate(400.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[17], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[17], 61.000, 280.000);
	TextDrawAlignment(APPLOCK[17], 1);
	TextDrawColour(APPLOCK[17], -252116993);
	TextDrawSetShadow(APPLOCK[17], 0);
	TextDrawSetOutline(APPLOCK[17], 1);
	TextDrawBackgroundColour(APPLOCK[17], 255);
	TextDrawFont(APPLOCK[17], 4);
	TextDrawSetProportional(APPLOCK[17], 1);

	APPLOCK[18] = TextDrawCreate(389.000, 375.000, "ld_beat:chit");
	TextDrawLetterSize(APPLOCK[18], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[18], 31.000, 31.500);
	TextDrawAlignment(APPLOCK[18], 1);
	TextDrawColour(APPLOCK[18], 0);
	TextDrawSetShadow(APPLOCK[18], 0);
	TextDrawSetOutline(APPLOCK[18], 1);
	TextDrawBackgroundColour(APPLOCK[18], 255);
	TextDrawFont(APPLOCK[18], 4);
	TextDrawSetProportional(APPLOCK[18], 1);

	APPLOCK[19] = TextDrawCreate(391.500, 378.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[19], 23.000, 26.500);
	TextDrawAlignment(APPLOCK[19], 1);
	TextDrawColour(APPLOCK[19], -252116993);
	TextDrawSetShadow(APPLOCK[19], 0);
	TextDrawSetOutline(APPLOCK[19], 0);
	TextDrawBackgroundColour(APPLOCK[19], 255);
	TextDrawFont(APPLOCK[19], 4);
	TextDrawSetProportional(APPLOCK[19], 1);

	APPLOCK[20] = TextDrawCreate(467.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[20], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[20], 62.000, 263.000);
	TextDrawAlignment(APPLOCK[20], 1);
	TextDrawColour(APPLOCK[20], -252116993);
	TextDrawSetShadow(APPLOCK[20], 0);
	TextDrawSetOutline(APPLOCK[20], 1);
	TextDrawBackgroundColour(APPLOCK[20], 255);
	TextDrawFont(APPLOCK[20], 4);
	TextDrawSetProportional(APPLOCK[20], 1);

	APPLOCK[21] = TextDrawCreate(460.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(APPLOCK[21], 0.600, 2.000);
	TextDrawTextSize(APPLOCK[21], 63.000, 280.000);
	TextDrawAlignment(APPLOCK[21], 1);
	TextDrawColour(APPLOCK[21], -252116993);
	TextDrawSetShadow(APPLOCK[21], 0);
	TextDrawSetOutline(APPLOCK[21], 1);
	TextDrawBackgroundColour(APPLOCK[21], 255);
	TextDrawFont(APPLOCK[21], 4);
	TextDrawSetProportional(APPLOCK[21], 1);

	APPLOCK[22] = TextDrawCreate(509.500, 377.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[22], 24.000, 28.500);
	TextDrawAlignment(APPLOCK[22], 1);
	TextDrawColour(APPLOCK[22], -252116993);
	TextDrawSetShadow(APPLOCK[22], 0);
	TextDrawSetOutline(APPLOCK[22], 0);
	TextDrawBackgroundColour(APPLOCK[22], 255);
	TextDrawFont(APPLOCK[22], 4);
	TextDrawSetProportional(APPLOCK[22], 1);

	APPLOCK[23] = TextDrawCreate(392.000, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[23], 20.000, 24.000);
	TextDrawAlignment(APPLOCK[23], 1);
	TextDrawColour(APPLOCK[23], -252116993);
	TextDrawSetShadow(APPLOCK[23], 0);
	TextDrawSetOutline(APPLOCK[23], 0);
	TextDrawBackgroundColour(APPLOCK[23], 255);
	TextDrawFont(APPLOCK[23], 4);
	TextDrawSetProportional(APPLOCK[23], 1);

	APPLOCK[24] = TextDrawCreate(509.500, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[24], 24.000, 24.500);
	TextDrawAlignment(APPLOCK[24], 1);
	TextDrawColour(APPLOCK[24], -252116993);
	TextDrawSetShadow(APPLOCK[24], 0);
	TextDrawSetOutline(APPLOCK[24], 0);
	TextDrawBackgroundColour(APPLOCK[24], 255);
	TextDrawFont(APPLOCK[24], 4);
	TextDrawSetProportional(APPLOCK[24], 1);

	APPLOCK[25] = TextDrawCreate(400.000, 124.000, "AKRP");
	TextDrawLetterSize(APPLOCK[25], 0.200, 0.898);
	TextDrawAlignment(APPLOCK[25], 1);
	TextDrawColour(APPLOCK[25], -1);
	TextDrawSetShadow(APPLOCK[25], 1);
	TextDrawSetOutline(APPLOCK[25], 1);
	TextDrawBackgroundColour(APPLOCK[25], 0);
	TextDrawFont(APPLOCK[25], 2);
	TextDrawSetProportional(APPLOCK[25], 1);

	APPLOCK[26] = TextDrawCreate(429.000, 135.000, "LD_SPAC:black");
	TextDrawTextSize(APPLOCK[26], 66.000, -11.000);
	TextDrawAlignment(APPLOCK[26], 1);
	TextDrawColour(APPLOCK[26], -1);
	TextDrawSetShadow(APPLOCK[26], 0);
	TextDrawSetOutline(APPLOCK[26], 0);
	TextDrawBackgroundColour(APPLOCK[26], 255);
	TextDrawFont(APPLOCK[26], 4);
	TextDrawSetProportional(APPLOCK[26], 1);

	APPLOCK[27] = TextDrawCreate(423.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[27], 16.000, 17.000);
	TextDrawAlignment(APPLOCK[27], 1);
	TextDrawColour(APPLOCK[27], 255);
	TextDrawSetShadow(APPLOCK[27], 0);
	TextDrawSetOutline(APPLOCK[27], 0);
	TextDrawBackgroundColour(APPLOCK[27], 255);
	TextDrawFont(APPLOCK[27], 4);
	TextDrawSetProportional(APPLOCK[27], 1);

	APPLOCK[28] = TextDrawCreate(485.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[28], 16.000, 17.000);
	TextDrawAlignment(APPLOCK[28], 1);
	TextDrawColour(APPLOCK[28], 255);
	TextDrawSetShadow(APPLOCK[28], 0);
	TextDrawSetOutline(APPLOCK[28], 0);
	TextDrawBackgroundColour(APPLOCK[28], 255);
	TextDrawFont(APPLOCK[28], 4);
	TextDrawSetProportional(APPLOCK[28], 1);

	APPLOCK[29] = TextDrawCreate(508.000, 122.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[29], 2.000, 12.000);
	TextDrawAlignment(APPLOCK[29], 1);
	TextDrawColour(APPLOCK[29], -1);
	TextDrawSetShadow(APPLOCK[29], 0);
	TextDrawSetOutline(APPLOCK[29], 0);
	TextDrawBackgroundColour(APPLOCK[29], 255);
	TextDrawFont(APPLOCK[29], 4);
	TextDrawSetProportional(APPLOCK[29], 1);

	APPLOCK[30] = TextDrawCreate(505.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[30], 2.000, -8.000);
	TextDrawAlignment(APPLOCK[30], 1);
	TextDrawColour(APPLOCK[30], -1);
	TextDrawSetShadow(APPLOCK[30], 0);
	TextDrawSetOutline(APPLOCK[30], 0);
	TextDrawBackgroundColour(APPLOCK[30], 255);
	TextDrawFont(APPLOCK[30], 4);
	TextDrawSetProportional(APPLOCK[30], 1);

	APPLOCK[31] = TextDrawCreate(502.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[31], 2.000, -5.000);
	TextDrawAlignment(APPLOCK[31], 1);
	TextDrawColour(APPLOCK[31], -1);
	TextDrawSetShadow(APPLOCK[31], 0);
	TextDrawSetOutline(APPLOCK[31], 0);
	TextDrawBackgroundColour(APPLOCK[31], 255);
	TextDrawFont(APPLOCK[31], 4);
	TextDrawSetProportional(APPLOCK[31], 1);

	APPLOCK[32] = TextDrawCreate(499.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[32], 2.000, -2.000);
	TextDrawAlignment(APPLOCK[32], 1);
	TextDrawColour(APPLOCK[32], -1);
	TextDrawSetShadow(APPLOCK[32], 0);
	TextDrawSetOutline(APPLOCK[32], 0);
	TextDrawBackgroundColour(APPLOCK[32], 255);
	TextDrawFont(APPLOCK[32], 4);
	TextDrawSetProportional(APPLOCK[32], 1);

	APPLOCK[33] = TextDrawCreate(514.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[33], 10.000, -8.000);
	TextDrawAlignment(APPLOCK[33], 1);
	TextDrawColour(APPLOCK[33], -1);
	TextDrawSetShadow(APPLOCK[33], 0);
	TextDrawSetOutline(APPLOCK[33], 0);
	TextDrawBackgroundColour(APPLOCK[33], 255);
	TextDrawFont(APPLOCK[33], 4);
	TextDrawSetProportional(APPLOCK[33], 1);

	APPLOCK[34] = TextDrawCreate(523.000, 132.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[34], 3.000, -4.000);
	TextDrawAlignment(APPLOCK[34], 1);
	TextDrawColour(APPLOCK[34], -1);
	TextDrawSetShadow(APPLOCK[34], 0);
	TextDrawSetOutline(APPLOCK[34], 0);
	TextDrawBackgroundColour(APPLOCK[34], 255);
	TextDrawFont(APPLOCK[34], 4);
	TextDrawSetProportional(APPLOCK[34], 1);

	APPLOCK[35] = TextDrawCreate(530.000, 142.000, "_");
	TextDrawLetterSize(APPLOCK[35], -1.029, 3.700);
	TextDrawTextSize(APPLOCK[35], 394.500, -4.000);
	TextDrawAlignment(APPLOCK[35], 1);
	TextDrawColour(APPLOCK[35], -1);
	TextDrawUseBox(APPLOCK[35], 1);
	TextDrawBoxColour(APPLOCK[35], 150);
	TextDrawSetShadow(APPLOCK[35], 1);
	TextDrawSetOutline(APPLOCK[35], 1);
	TextDrawBackgroundColour(APPLOCK[35], 150);
	TextDrawFont(APPLOCK[35], 1);
	TextDrawSetProportional(APPLOCK[35], 1);

	APPLOCK[36] = TextDrawCreate(530.000, 184.000, "_");
	TextDrawLetterSize(APPLOCK[36], -1.029, 3.700);
	TextDrawTextSize(APPLOCK[36], 394.500, -4.000);
	TextDrawAlignment(APPLOCK[36], 1);
	TextDrawColour(APPLOCK[36], -1);
	TextDrawUseBox(APPLOCK[36], 1);
	TextDrawBoxColour(APPLOCK[36], 150);
	TextDrawSetShadow(APPLOCK[36], 1);
	TextDrawSetOutline(APPLOCK[36], 1);
	TextDrawBackgroundColour(APPLOCK[36], 150);
	TextDrawFont(APPLOCK[36], 1);
	TextDrawSetProportional(APPLOCK[36], 1);

	APPLOCK[37] = TextDrawCreate(530.000, 228.000, "_");
	TextDrawLetterSize(APPLOCK[37], -1.029, 3.700);
	TextDrawTextSize(APPLOCK[37], 394.500, -4.000);
	TextDrawAlignment(APPLOCK[37], 1);
	TextDrawColour(APPLOCK[37], -1);
	TextDrawUseBox(APPLOCK[37], 1);
	TextDrawBoxColour(APPLOCK[37], 150);
	TextDrawSetShadow(APPLOCK[37], 1);
	TextDrawSetOutline(APPLOCK[37], 1);
	TextDrawBackgroundColour(APPLOCK[37], 150);
	TextDrawFont(APPLOCK[37], 1);
	TextDrawSetProportional(APPLOCK[37], 1);

	APPLOCK[38] = TextDrawCreate(530.000, 272.000, "_");
	TextDrawLetterSize(APPLOCK[38], -1.029, 3.700);
	TextDrawTextSize(APPLOCK[38], 394.500, -4.000);
	TextDrawAlignment(APPLOCK[38], 1);
	TextDrawColour(APPLOCK[38], -1);
	TextDrawUseBox(APPLOCK[38], 1);
	TextDrawBoxColour(APPLOCK[38], 150);
	TextDrawSetShadow(APPLOCK[38], 1);
	TextDrawSetOutline(APPLOCK[38], 1);
	TextDrawBackgroundColour(APPLOCK[38], 150);
	TextDrawFont(APPLOCK[38], 1);
	TextDrawSetProportional(APPLOCK[38], 1);

	APPLOCK[39] = TextDrawCreate(530.000, 315.000, "_");
	TextDrawLetterSize(APPLOCK[39], -1.029, 3.700);
	TextDrawTextSize(APPLOCK[39], 394.500, -4.000);
	TextDrawAlignment(APPLOCK[39], 1);
	TextDrawColour(APPLOCK[39], -1);
	TextDrawUseBox(APPLOCK[39], 1);
	TextDrawBoxColour(APPLOCK[39], 150);
	TextDrawSetShadow(APPLOCK[39], 1);
	TextDrawSetOutline(APPLOCK[39], 1);
	TextDrawBackgroundColour(APPLOCK[39], 150);
	TextDrawFont(APPLOCK[39], 1);
	TextDrawSetProportional(APPLOCK[39], 1);

	APPLOCK[40] = TextDrawCreate(400.000, 174.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[40], 125.000, -31.000);
	TextDrawAlignment(APPLOCK[40], 1);
	TextDrawColour(APPLOCK[40], -1);
	TextDrawSetShadow(APPLOCK[40], 0);
	TextDrawSetOutline(APPLOCK[40], 0);
	TextDrawBackgroundColour(APPLOCK[40], 255);
	TextDrawFont(APPLOCK[40], 4);
	TextDrawSetProportional(APPLOCK[40], 1);

	APPLOCK[41] = TextDrawCreate(402.000, 145.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[41], 24.000, 26.000);
	TextDrawAlignment(APPLOCK[41], 1);
	TextDrawColour(APPLOCK[41], 255);
	TextDrawSetShadow(APPLOCK[41], 0);
	TextDrawSetOutline(APPLOCK[41], 0);
	TextDrawBackgroundColour(APPLOCK[41], 255);
	TextDrawFont(APPLOCK[41], 4);
	TextDrawSetProportional(APPLOCK[41], 1);

	APPLOCK[42] = TextDrawCreate(402.000, 144.000, "HUD:radar_impound");
	TextDrawTextSize(APPLOCK[42], 24.000, 25.000);
	TextDrawAlignment(APPLOCK[42], 1);
	TextDrawColour(APPLOCK[42], -1);
	TextDrawSetShadow(APPLOCK[42], 0);
	TextDrawSetOutline(APPLOCK[42], 0);
	TextDrawBackgroundColour(APPLOCK[42], 255);
	TextDrawFont(APPLOCK[42], 4);
	TextDrawSetProportional(APPLOCK[42], 1);

	APPLOCK[43] = TextDrawCreate(428.000, 147.000, "VALLEY");
	TextDrawLetterSize(APPLOCK[43], 0.170, 0.799);
	TextDrawAlignment(APPLOCK[43], 1);
	TextDrawColour(APPLOCK[43], 255);
	TextDrawSetShadow(APPLOCK[43], 1);
	TextDrawSetOutline(APPLOCK[43], 1);
	TextDrawBackgroundColour(APPLOCK[43], 0);
	TextDrawFont(APPLOCK[43], 2);
	TextDrawSetProportional(APPLOCK[43], 1);

	APPLOCK[44] = TextDrawCreate(484.000, 147.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[44], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[44], 1);
	TextDrawColour(APPLOCK[44], 16711935);
	TextDrawSetShadow(APPLOCK[44], 0);
	TextDrawSetOutline(APPLOCK[44], 0);
	TextDrawBackgroundColour(APPLOCK[44], 255);
	TextDrawFont(APPLOCK[44], 4);
	TextDrawSetProportional(APPLOCK[44], 1);

	APPLOCK[45] = TextDrawCreate(507.000, 147.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[45], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[45], 1);
	TextDrawColour(APPLOCK[45], 16711935);
	TextDrawSetShadow(APPLOCK[45], 0);
	TextDrawSetOutline(APPLOCK[45], 0);
	TextDrawBackgroundColour(APPLOCK[45], 255);
	TextDrawFont(APPLOCK[45], 4);
	TextDrawSetProportional(APPLOCK[45], 1);

	APPLOCK[46] = TextDrawCreate(428.000, 156.000, "Author :Naju");
	TextDrawLetterSize(APPLOCK[46], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[46], 1);
	TextDrawColour(APPLOCK[46], 255);
	TextDrawSetShadow(APPLOCK[46], 1);
	TextDrawSetOutline(APPLOCK[46], 1);
	TextDrawBackgroundColour(APPLOCK[46], 0);
	TextDrawFont(APPLOCK[46], 2);
	TextDrawSetProportional(APPLOCK[46], 1);

	APPLOCK[47] = TextDrawCreate(428.000, 162.000, "Date : 1 / 2 / 2023");
	TextDrawLetterSize(APPLOCK[47], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[47], 1);
	TextDrawColour(APPLOCK[47], 255);
	TextDrawSetShadow(APPLOCK[47], 1);
	TextDrawSetOutline(APPLOCK[47], 1);
	TextDrawBackgroundColour(APPLOCK[47], 0);
	TextDrawFont(APPLOCK[47], 2);
	TextDrawSetProportional(APPLOCK[47], 1);

	APPLOCK[48] = TextDrawCreate(400.000, 216.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[48], 125.000, -31.000);
	TextDrawAlignment(APPLOCK[48], 1);
	TextDrawColour(APPLOCK[48], -1);
	TextDrawSetShadow(APPLOCK[48], 0);
	TextDrawSetOutline(APPLOCK[48], 0);
	TextDrawBackgroundColour(APPLOCK[48], 255);
	TextDrawFont(APPLOCK[48], 4);
	TextDrawSetProportional(APPLOCK[48], 1);

	APPLOCK[49] = TextDrawCreate(492.000, 150.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[49], 25.000, 15.000);
	TextDrawAlignment(APPLOCK[49], 1);
	TextDrawColour(APPLOCK[49], 16711935);
	TextDrawSetShadow(APPLOCK[49], 0);
	TextDrawSetOutline(APPLOCK[49], 0);
	TextDrawBackgroundColour(APPLOCK[49], 255);
	TextDrawFont(APPLOCK[49], 4);
	TextDrawSetProportional(APPLOCK[49], 1);
	TextDrawSetSelectable(APPLOCK[49], 1);

	APPLOCK[50] = TextDrawCreate(402.000, 187.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[50], 24.000, 26.000);
	TextDrawAlignment(APPLOCK[50], 1);
	TextDrawColour(APPLOCK[50], -2686721);
	TextDrawSetShadow(APPLOCK[50], 0);
	TextDrawSetOutline(APPLOCK[50], 0);
	TextDrawBackgroundColour(APPLOCK[50], 255);
	TextDrawFont(APPLOCK[50], 4);
	TextDrawSetProportional(APPLOCK[50], 1);

	APPLOCK[51] = TextDrawCreate(405.500, 197.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[51], 17.000, 13.000);
	TextDrawAlignment(APPLOCK[51], 1);
	TextDrawColour(APPLOCK[51], 255);
	TextDrawSetShadow(APPLOCK[51], 0);
	TextDrawSetOutline(APPLOCK[51], 0);
	TextDrawBackgroundColour(APPLOCK[51], 255);
	TextDrawFont(APPLOCK[51], 4);
	TextDrawSetProportional(APPLOCK[51], 1);

	APPLOCK[52] = TextDrawCreate(428.000, 189.000, "TAXI");
	TextDrawLetterSize(APPLOCK[52], 0.170, 0.799);
	TextDrawAlignment(APPLOCK[52], 1);
	TextDrawColour(APPLOCK[52], 255);
	TextDrawSetShadow(APPLOCK[52], 1);
	TextDrawSetOutline(APPLOCK[52], 1);
	TextDrawBackgroundColour(APPLOCK[52], 0);
	TextDrawFont(APPLOCK[52], 2);
	TextDrawSetProportional(APPLOCK[52], 1);

	APPLOCK[53] = TextDrawCreate(484.000, 189.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[53], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[53], 1);
	TextDrawColour(APPLOCK[53], 16711935);
	TextDrawSetShadow(APPLOCK[53], 0);
	TextDrawSetOutline(APPLOCK[53], 0);
	TextDrawBackgroundColour(APPLOCK[53], 255);
	TextDrawFont(APPLOCK[53], 4);
	TextDrawSetProportional(APPLOCK[53], 1);

	APPLOCK[54] = TextDrawCreate(507.000, 189.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[54], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[54], 1);
	TextDrawColour(APPLOCK[54], 16711935);
	TextDrawSetShadow(APPLOCK[54], 0);
	TextDrawSetOutline(APPLOCK[54], 0);
	TextDrawBackgroundColour(APPLOCK[54], 255);
	TextDrawFont(APPLOCK[54], 4);
	TextDrawSetProportional(APPLOCK[54], 1);

	APPLOCK[55] = TextDrawCreate(428.000, 198.000, "AUTHOR:CARLO");
	TextDrawLetterSize(APPLOCK[55], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[55], 1);
	TextDrawColour(APPLOCK[55], 255);
	TextDrawSetShadow(APPLOCK[55], 1);
	TextDrawSetOutline(APPLOCK[55], 1);
	TextDrawBackgroundColour(APPLOCK[55], 0);
	TextDrawFont(APPLOCK[55], 2);
	TextDrawSetProportional(APPLOCK[55], 1);

	APPLOCK[56] = TextDrawCreate(428.000, 204.000, "Date : 1 / 2 / 2023");
	TextDrawLetterSize(APPLOCK[56], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[56], 1);
	TextDrawColour(APPLOCK[56], 255);
	TextDrawSetShadow(APPLOCK[56], 1);
	TextDrawSetOutline(APPLOCK[56], 1);
	TextDrawBackgroundColour(APPLOCK[56], 0);
	TextDrawFont(APPLOCK[56], 2);
	TextDrawSetProportional(APPLOCK[56], 1);

	APPLOCK[57] = TextDrawCreate(404.000, 188.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[57], 20.000, 17.000);
	TextDrawAlignment(APPLOCK[57], 1);
	TextDrawColour(APPLOCK[57], 255);
	TextDrawSetShadow(APPLOCK[57], 0);
	TextDrawSetOutline(APPLOCK[57], 0);
	TextDrawBackgroundColour(APPLOCK[57], 255);
	TextDrawFont(APPLOCK[57], 4);
	TextDrawSetProportional(APPLOCK[57], 1);

	APPLOCK[58] = TextDrawCreate(407.000, 200.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[58], 6.000, 6.000);
	TextDrawAlignment(APPLOCK[58], 1);
	TextDrawColour(APPLOCK[58], -2686721);
	TextDrawSetShadow(APPLOCK[58], 0);
	TextDrawSetOutline(APPLOCK[58], 0);
	TextDrawBackgroundColour(APPLOCK[58], 255);
	TextDrawFont(APPLOCK[58], 4);
	TextDrawSetProportional(APPLOCK[58], 1);

	APPLOCK[59] = TextDrawCreate(415.000, 200.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[59], 6.000, 6.000);
	TextDrawAlignment(APPLOCK[59], 1);
	TextDrawColour(APPLOCK[59], -2686721);
	TextDrawSetShadow(APPLOCK[59], 0);
	TextDrawSetOutline(APPLOCK[59], 0);
	TextDrawBackgroundColour(APPLOCK[59], 255);
	TextDrawFont(APPLOCK[59], 4);
	TextDrawSetProportional(APPLOCK[59], 1);

	APPLOCK[60] = TextDrawCreate(400.000, 260.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[60], 125.000, -31.000);
	TextDrawAlignment(APPLOCK[60], 1);
	TextDrawColour(APPLOCK[60], -1);
	TextDrawSetShadow(APPLOCK[60], 0);
	TextDrawSetOutline(APPLOCK[60], 0);
	TextDrawBackgroundColour(APPLOCK[60], 255);
	TextDrawFont(APPLOCK[60], 4);
	TextDrawSetProportional(APPLOCK[60], 1);

	APPLOCK[61] = TextDrawCreate(492.000, 192.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[61], 25.000, 15.000);
	TextDrawAlignment(APPLOCK[61], 1);
	TextDrawColour(APPLOCK[61], 16711935);
	TextDrawSetShadow(APPLOCK[61], 0);
	TextDrawSetOutline(APPLOCK[61], 0);
	TextDrawBackgroundColour(APPLOCK[61], 255);
	TextDrawFont(APPLOCK[61], 4);
	TextDrawSetProportional(APPLOCK[61], 1);
	TextDrawSetSelectable(APPLOCK[61], 1);

	APPLOCK[62] = TextDrawCreate(402.000, 231.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[62], 24.000, 26.000);
	TextDrawAlignment(APPLOCK[62], 1);
	TextDrawColour(APPLOCK[62], 16777215);
	TextDrawSetShadow(APPLOCK[62], 0);
	TextDrawSetOutline(APPLOCK[62], 0);
	TextDrawBackgroundColour(APPLOCK[62], 255);
	TextDrawFont(APPLOCK[62], 4);
	TextDrawSetProportional(APPLOCK[62], 1);

	APPLOCK[63] = TextDrawCreate(484.000, 233.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[63], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[63], 1);
	TextDrawColour(APPLOCK[63], 16711935);
	TextDrawSetShadow(APPLOCK[63], 0);
	TextDrawSetOutline(APPLOCK[63], 0);
	TextDrawBackgroundColour(APPLOCK[63], 255);
	TextDrawFont(APPLOCK[63], 4);
	TextDrawSetProportional(APPLOCK[63], 1);

	APPLOCK[64] = TextDrawCreate(428.000, 233.000, "TWITTER");
	TextDrawLetterSize(APPLOCK[64], 0.170, 0.799);
	TextDrawAlignment(APPLOCK[64], 1);
	TextDrawColour(APPLOCK[64], 255);
	TextDrawSetShadow(APPLOCK[64], 1);
	TextDrawSetOutline(APPLOCK[64], 1);
	TextDrawBackgroundColour(APPLOCK[64], 0);
	TextDrawFont(APPLOCK[64], 2);
	TextDrawSetProportional(APPLOCK[64], 1);

	APPLOCK[65] = TextDrawCreate(507.000, 233.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[65], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[65], 1);
	TextDrawColour(APPLOCK[65], 16711935);
	TextDrawSetShadow(APPLOCK[65], 0);
	TextDrawSetOutline(APPLOCK[65], 0);
	TextDrawBackgroundColour(APPLOCK[65], 255);
	TextDrawFont(APPLOCK[65], 4);
	TextDrawSetProportional(APPLOCK[65], 1);

	APPLOCK[66] = TextDrawCreate(492.000, 236.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[66], 25.000, 15.000);
	TextDrawAlignment(APPLOCK[66], 1);
	TextDrawColour(APPLOCK[66], 16711935);
	TextDrawSetShadow(APPLOCK[66], 0);
	TextDrawSetOutline(APPLOCK[66], 0);
	TextDrawBackgroundColour(APPLOCK[66], 255);
	TextDrawFont(APPLOCK[66], 4);
	TextDrawSetProportional(APPLOCK[66], 1);
	TextDrawSetSelectable(APPLOCK[66], 1);

	APPLOCK[67] = TextDrawCreate(428.000, 242.000, "AUTHOR:VIKKI");
	TextDrawLetterSize(APPLOCK[67], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[67], 1);
	TextDrawColour(APPLOCK[67], 255);
	TextDrawSetShadow(APPLOCK[67], 1);
	TextDrawSetOutline(APPLOCK[67], 1);
	TextDrawBackgroundColour(APPLOCK[67], 0);
	TextDrawFont(APPLOCK[67], 2);
	TextDrawSetProportional(APPLOCK[67], 1);

	APPLOCK[68] = TextDrawCreate(428.000, 248.000, "Date : 1 / 2 / 2023");
	TextDrawLetterSize(APPLOCK[68], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[68], 1);
	TextDrawColour(APPLOCK[68], 255);
	TextDrawSetShadow(APPLOCK[68], 1);
	TextDrawSetOutline(APPLOCK[68], 1);
	TextDrawBackgroundColour(APPLOCK[68], 0);
	TextDrawFont(APPLOCK[68], 2);
	TextDrawSetProportional(APPLOCK[68], 1);

	APPLOCK[69] = TextDrawCreate(410.000, 233.000, "T");
	TextDrawLetterSize(APPLOCK[69], 0.349, 2.098);
	TextDrawAlignment(APPLOCK[69], 1);
	TextDrawColour(APPLOCK[69], -1);
	TextDrawSetShadow(APPLOCK[69], 1);
	TextDrawSetOutline(APPLOCK[69], 1);
	TextDrawBackgroundColour(APPLOCK[69], 0);
	TextDrawFont(APPLOCK[69], 3);
	TextDrawSetProportional(APPLOCK[69], 1);

	APPLOCK[70] = TextDrawCreate(400.000, 304.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[70], 125.000, -31.000);
	TextDrawAlignment(APPLOCK[70], 1);
	TextDrawColour(APPLOCK[70], -1);
	TextDrawSetShadow(APPLOCK[70], 0);
	TextDrawSetOutline(APPLOCK[70], 0);
	TextDrawBackgroundColour(APPLOCK[70], 255);
	TextDrawFont(APPLOCK[70], 4);
	TextDrawSetProportional(APPLOCK[70], 1);

	APPLOCK[71] = TextDrawCreate(402.000, 275.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[71], 24.000, 26.000);
	TextDrawAlignment(APPLOCK[71], 1);
	TextDrawColour(APPLOCK[71], -9849601);
	TextDrawSetShadow(APPLOCK[71], 0);
	TextDrawSetOutline(APPLOCK[71], 0);
	TextDrawBackgroundColour(APPLOCK[71], 255);
	TextDrawFont(APPLOCK[71], 4);
	TextDrawSetProportional(APPLOCK[71], 1);

	APPLOCK[72] = TextDrawCreate(484.000, 277.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[72], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[72], 1);
	TextDrawColour(APPLOCK[72], 16711935);
	TextDrawSetShadow(APPLOCK[72], 0);
	TextDrawSetOutline(APPLOCK[72], 0);
	TextDrawBackgroundColour(APPLOCK[72], 255);
	TextDrawFont(APPLOCK[72], 4);
	TextDrawSetProportional(APPLOCK[72], 1);

	APPLOCK[73] = TextDrawCreate(428.000, 277.000, "Instagram");
	TextDrawLetterSize(APPLOCK[73], 0.170, 0.799);
	TextDrawAlignment(APPLOCK[73], 1);
	TextDrawColour(APPLOCK[73], 255);
	TextDrawSetShadow(APPLOCK[73], 1);
	TextDrawSetOutline(APPLOCK[73], 1);
	TextDrawBackgroundColour(APPLOCK[73], 0);
	TextDrawFont(APPLOCK[73], 2);
	TextDrawSetProportional(APPLOCK[73], 1);

	APPLOCK[74] = TextDrawCreate(507.000, 277.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[74], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[74], 1);
	TextDrawColour(APPLOCK[74], 16711935);
	TextDrawSetShadow(APPLOCK[74], 0);
	TextDrawSetOutline(APPLOCK[74], 0);
	TextDrawBackgroundColour(APPLOCK[74], 255);
	TextDrawFont(APPLOCK[74], 4);
	TextDrawSetProportional(APPLOCK[74], 1);

	APPLOCK[75] = TextDrawCreate(492.000, 280.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[75], 25.000, 15.000);
	TextDrawAlignment(APPLOCK[75], 1);
	TextDrawColour(APPLOCK[75], 16711935);
	TextDrawSetShadow(APPLOCK[75], 0);
	TextDrawSetOutline(APPLOCK[75], 0);
	TextDrawBackgroundColour(APPLOCK[75], 255);
	TextDrawFont(APPLOCK[75], 4);
	TextDrawSetProportional(APPLOCK[75], 1);
	TextDrawSetSelectable(APPLOCK[75], 1);

	APPLOCK[76] = TextDrawCreate(428.000, 286.000, "AUTHOR:ROCKY");
	TextDrawLetterSize(APPLOCK[76], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[76], 1);
	TextDrawColour(APPLOCK[76], 255);
	TextDrawSetShadow(APPLOCK[76], 1);
	TextDrawSetOutline(APPLOCK[76], 1);
	TextDrawBackgroundColour(APPLOCK[76], 0);
	TextDrawFont(APPLOCK[76], 2);
	TextDrawSetProportional(APPLOCK[76], 1);

	APPLOCK[77] = TextDrawCreate(428.000, 292.000, "Date : 1 / 2 / 2023");
	TextDrawLetterSize(APPLOCK[77], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[77], 1);
	TextDrawColour(APPLOCK[77], 255);
	TextDrawSetShadow(APPLOCK[77], 1);
	TextDrawSetOutline(APPLOCK[77], 1);
	TextDrawBackgroundColour(APPLOCK[77], 0);
	TextDrawFont(APPLOCK[77], 2);
	TextDrawSetProportional(APPLOCK[77], 1);

	APPLOCK[78] = TextDrawCreate(403.000, 276.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[78], 22.000, 23.000);
	TextDrawAlignment(APPLOCK[78], 1);
	TextDrawColour(APPLOCK[78], -1);
	TextDrawSetShadow(APPLOCK[78], 0);
	TextDrawSetOutline(APPLOCK[78], 0);
	TextDrawBackgroundColour(APPLOCK[78], 255);
	TextDrawFont(APPLOCK[78], 4);
	TextDrawSetProportional(APPLOCK[78], 1);

	APPLOCK[79] = TextDrawCreate(400.000, 347.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[79], 125.000, -31.000);
	TextDrawAlignment(APPLOCK[79], 1);
	TextDrawColour(APPLOCK[79], -1);
	TextDrawSetShadow(APPLOCK[79], 0);
	TextDrawSetOutline(APPLOCK[79], 0);
	TextDrawBackgroundColour(APPLOCK[79], 255);
	TextDrawFont(APPLOCK[79], 4);
	TextDrawSetProportional(APPLOCK[79], 1);

	APPLOCK[80] = TextDrawCreate(402.000, 318.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[80], 24.000, 26.000);
	TextDrawAlignment(APPLOCK[80], 1);
	TextDrawColour(APPLOCK[80], 512819199);
	TextDrawSetShadow(APPLOCK[80], 0);
	TextDrawSetOutline(APPLOCK[80], 0);
	TextDrawBackgroundColour(APPLOCK[80], 255);
	TextDrawFont(APPLOCK[80], 4);
	TextDrawSetProportional(APPLOCK[80], 1);

	APPLOCK[81] = TextDrawCreate(484.000, 320.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[81], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[81], 1);
	TextDrawColour(APPLOCK[81], 16711935);
	TextDrawSetShadow(APPLOCK[81], 0);
	TextDrawSetOutline(APPLOCK[81], 0);
	TextDrawBackgroundColour(APPLOCK[81], 255);
	TextDrawFont(APPLOCK[81], 4);
	TextDrawSetProportional(APPLOCK[81], 1);

	APPLOCK[82] = TextDrawCreate(428.000, 320.000, "BANK");
	TextDrawLetterSize(APPLOCK[82], 0.170, 0.799);
	TextDrawAlignment(APPLOCK[82], 1);
	TextDrawColour(APPLOCK[82], 255);
	TextDrawSetShadow(APPLOCK[82], 1);
	TextDrawSetOutline(APPLOCK[82], 1);
	TextDrawBackgroundColour(APPLOCK[82], 0);
	TextDrawFont(APPLOCK[82], 2);
	TextDrawSetProportional(APPLOCK[82], 1);

	APPLOCK[83] = TextDrawCreate(507.000, 320.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[83], 18.000, 21.000);
	TextDrawAlignment(APPLOCK[83], 1);
	TextDrawColour(APPLOCK[83], 16711935);
	TextDrawSetShadow(APPLOCK[83], 0);
	TextDrawSetOutline(APPLOCK[83], 0);
	TextDrawBackgroundColour(APPLOCK[83], 255);
	TextDrawFont(APPLOCK[83], 4);
	TextDrawSetProportional(APPLOCK[83], 1);

	APPLOCK[84] = TextDrawCreate(492.000, 323.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[84], 25.000, 15.000);
	TextDrawAlignment(APPLOCK[84], 1);
	TextDrawColour(APPLOCK[84], 16711935);
	TextDrawSetShadow(APPLOCK[84], 0);
	TextDrawSetOutline(APPLOCK[84], 0);
	TextDrawBackgroundColour(APPLOCK[84], 255);
	TextDrawFont(APPLOCK[84], 4);
	TextDrawSetProportional(APPLOCK[84], 1);
	TextDrawSetSelectable(APPLOCK[84], 1);

	APPLOCK[85] = TextDrawCreate(428.000, 329.000, "AUTHOR:ZATHAN");
	TextDrawLetterSize(APPLOCK[85], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[85], 1);
	TextDrawColour(APPLOCK[85], 255);
	TextDrawSetShadow(APPLOCK[85], 1);
	TextDrawSetOutline(APPLOCK[85], 1);
	TextDrawBackgroundColour(APPLOCK[85], 0);
	TextDrawFont(APPLOCK[85], 2);
	TextDrawSetProportional(APPLOCK[85], 1);

	APPLOCK[86] = TextDrawCreate(428.000, 335.000, "Date : 1 / 2 / 2023");
	TextDrawLetterSize(APPLOCK[86], 0.100, 0.499);
	TextDrawAlignment(APPLOCK[86], 1);
	TextDrawColour(APPLOCK[86], 255);
	TextDrawSetShadow(APPLOCK[86], 1);
	TextDrawSetOutline(APPLOCK[86], 1);
	TextDrawBackgroundColour(APPLOCK[86], 0);
	TextDrawFont(APPLOCK[86], 2);
	TextDrawSetProportional(APPLOCK[86], 1);

	APPLOCK[87] = TextDrawCreate(411.000, 322.000, "$");
	TextDrawLetterSize(APPLOCK[87], 0.379, 1.799);
	TextDrawAlignment(APPLOCK[87], 1);
	TextDrawColour(APPLOCK[87], -1);
	TextDrawSetShadow(APPLOCK[87], 1);
	TextDrawSetOutline(APPLOCK[87], 1);
	TextDrawBackgroundColour(APPLOCK[87], 0);
	TextDrawFont(APPLOCK[87], 1);
	TextDrawSetProportional(APPLOCK[87], 1);

	APPLOCK[88] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(APPLOCK[88], 72.000, 3.000);
	TextDrawAlignment(APPLOCK[88], 1);
	TextDrawColour(APPLOCK[88], 255);
	TextDrawSetShadow(APPLOCK[88], 0);
	TextDrawSetOutline(APPLOCK[88], 0);
	TextDrawBackgroundColour(APPLOCK[88], 255);
	TextDrawFont(APPLOCK[88], 4);
	TextDrawSetProportional(APPLOCK[88], 1);
	TextDrawSetSelectable(APPLOCK[88], 1);

	APPLOCK[89] = TextDrawCreate(406.000, 278.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[89], 17.000, 19.000);
	TextDrawAlignment(APPLOCK[89], 1);
	TextDrawColour(APPLOCK[89], -15428609);
	TextDrawSetShadow(APPLOCK[89], 0);
	TextDrawSetOutline(APPLOCK[89], 0);
	TextDrawBackgroundColour(APPLOCK[89], 255);
	TextDrawFont(APPLOCK[89], 4);
	TextDrawSetProportional(APPLOCK[89], 1);

	APPLOCK[90] = TextDrawCreate(420.000, 277.000, "LD_BEAT:chit");
	TextDrawTextSize(APPLOCK[90], 4.000, 4.000);
	TextDrawAlignment(APPLOCK[90], 1);
	TextDrawColour(APPLOCK[90], -15428609);
	TextDrawSetShadow(APPLOCK[90], 0);
	TextDrawSetOutline(APPLOCK[90], 0);
	TextDrawBackgroundColour(APPLOCK[90], 255);
	TextDrawFont(APPLOCK[90], 4);
	TextDrawSetProportional(APPLOCK[90], 1);

		//phonemain
	APPLOADING[0] = TextDrawCreate(442.000, 202.000, "A");
	TextDrawLetterSize(APPLOADING[0], 1.498, 8.798);
	TextDrawAlignment(APPLOADING[0], 1);
	TextDrawColour(APPLOADING[0], 255);
	TextDrawSetShadow(APPLOADING[0], 1);
	TextDrawSetOutline(APPLOADING[0], 1);
	TextDrawBackgroundColour(APPLOADING[0], 255);
	TextDrawFont(APPLOADING[0], 2);
	TextDrawSetProportional(APPLOADING[0], 1);

	APPLOADING[1] = TextDrawCreate(440.000, 265.000, "Appstore");
	TextDrawLetterSize(APPLOADING[1], 0.209, 0.898);
	TextDrawAlignment(APPLOADING[1], 1);
	TextDrawColour(APPLOADING[1], 255);
	TextDrawSetShadow(APPLOADING[1], 1);
	TextDrawSetOutline(APPLOADING[1], 1);
	TextDrawBackgroundColour(APPLOADING[1], 0);
	TextDrawFont(APPLOADING[1], 2);
	TextDrawSetProportional(APPLOADING[1], 1);

	APPLOADING[2] = TextDrawCreate(453.000, 274.000, "Loadings..");
	TextDrawLetterSize(APPLOADING[2], 0.098, 0.499);
	TextDrawAlignment(APPLOADING[2], 1);
	TextDrawColour(APPLOADING[2], 255);
	TextDrawSetShadow(APPLOADING[2], 1);
	TextDrawSetOutline(APPLOADING[2], 1);
	TextDrawBackgroundColour(APPLOADING[2], 0);
	TextDrawFont(APPLOADING[2], 2);
	TextDrawSetProportional(APPLOADING[2], 1);

	INSTA[0] = TextDrawCreate(401.000, 114.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[0], 0.600, 2.000);
	TextDrawTextSize(INSTA[0], 122.500, 293.000);
	TextDrawAlignment(INSTA[0], 1);
	TextDrawColour(INSTA[0], -1094795521);
	TextDrawSetShadow(INSTA[0], 0);
	TextDrawSetOutline(INSTA[0], 1);
	TextDrawBackgroundColour(INSTA[0], 255);
	TextDrawFont(INSTA[0], 4);
	TextDrawSetProportional(INSTA[0], 1);

	INSTA[1] = TextDrawCreate(390.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[1], 0.600, 2.000);
	TextDrawTextSize(INSTA[1], 144.500, 269.000);
	TextDrawAlignment(INSTA[1], 1);
	TextDrawColour(INSTA[1], -1094795521);
	TextDrawSetShadow(INSTA[1], 0);
	TextDrawSetOutline(INSTA[1], 1);
	TextDrawBackgroundColour(INSTA[1], 255);
	TextDrawFont(INSTA[1], 4);
	TextDrawSetProportional(INSTA[1], 1);

	INSTA[2] = TextDrawCreate(385.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[2], 0.600, 2.000);
	TextDrawTextSize(INSTA[2], 33.000, 31.500);
	TextDrawAlignment(INSTA[2], 1);
	TextDrawColour(INSTA[2], -1094795521);
	TextDrawSetShadow(INSTA[2], 0);
	TextDrawSetOutline(INSTA[2], 1);
	TextDrawBackgroundColour(INSTA[2], 255);
	TextDrawFont(INSTA[2], 4);
	TextDrawSetProportional(INSTA[2], 1);

	INSTA[3] = TextDrawCreate(507.500, 109.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[3], 0.600, 2.000);
	TextDrawTextSize(INSTA[3], 32.000, 33.000);
	TextDrawAlignment(INSTA[3], 1);
	TextDrawColour(INSTA[3], -1094795521);
	TextDrawSetShadow(INSTA[3], 0);
	TextDrawSetOutline(INSTA[3], 1);
	TextDrawBackgroundColour(INSTA[3], 255);
	TextDrawFont(INSTA[3], 4);
	TextDrawSetProportional(INSTA[3], 1);

	INSTA[4] = TextDrawCreate(508.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[4], 0.600, 2.000);
	TextDrawTextSize(INSTA[4], 32.000, 32.000);
	TextDrawAlignment(INSTA[4], 1);
	TextDrawColour(INSTA[4], -1094795521);
	TextDrawSetShadow(INSTA[4], 0);
	TextDrawSetOutline(INSTA[4], 1);
	TextDrawBackgroundColour(INSTA[4], 255);
	TextDrawFont(INSTA[4], 4);
	TextDrawSetProportional(INSTA[4], 1);

	INSTA[5] = TextDrawCreate(385.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[5], 0.600, 2.000);
	TextDrawTextSize(INSTA[5], 32.000, 32.000);
	TextDrawAlignment(INSTA[5], 1);
	TextDrawColour(INSTA[5], -1094795521);
	TextDrawSetShadow(INSTA[5], 0);
	TextDrawSetOutline(INSTA[5], 1);
	TextDrawBackgroundColour(INSTA[5], 255);
	TextDrawFont(INSTA[5], 4);
	TextDrawSetProportional(INSTA[5], 1);

	INSTA[6] = TextDrawCreate(387.000, 110.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[6], 0.600, 2.000);
	TextDrawTextSize(INSTA[6], 27.000, 31.500);
	TextDrawAlignment(INSTA[6], 1);
	TextDrawColour(INSTA[6], 255);
	TextDrawSetShadow(INSTA[6], 0);
	TextDrawSetOutline(INSTA[6], 1);
	TextDrawBackgroundColour(INSTA[6], 255);
	TextDrawFont(INSTA[6], 4);
	TextDrawSetProportional(INSTA[6], 1);

	INSTA[7] = TextDrawCreate(389.000, 113.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[7], 0.600, 2.000);
	TextDrawTextSize(INSTA[7], 29.000, 29.500);
	TextDrawAlignment(INSTA[7], 1);
	TextDrawColour(INSTA[7], 255);
	TextDrawSetShadow(INSTA[7], 0);
	TextDrawSetOutline(INSTA[7], 1);
	TextDrawBackgroundColour(INSTA[7], 255);
	TextDrawFont(INSTA[7], 4);
	TextDrawSetProportional(INSTA[7], 1);

	INSTA[8] = TextDrawCreate(391.500, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[8], 0.600, 2.000);
	TextDrawTextSize(INSTA[8], 141.500, 269.000);
	TextDrawAlignment(INSTA[8], 1);
	TextDrawColour(INSTA[8], 255);
	TextDrawSetShadow(INSTA[8], 0);
	TextDrawSetOutline(INSTA[8], 1);
	TextDrawBackgroundColour(INSTA[8], 255);
	TextDrawFont(INSTA[8], 4);
	TextDrawSetProportional(INSTA[8], 1);

	INSTA[9] = TextDrawCreate(463.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[9], -2.000, -6.000);
	TextDrawAlignment(INSTA[9], 1);
	TextDrawColour(INSTA[9], 548580095);
	TextDrawSetShadow(INSTA[9], 0);
	TextDrawSetOutline(INSTA[9], 0);
	TextDrawBackgroundColour(INSTA[9], 255);
	TextDrawFont(INSTA[9], 4);
	TextDrawSetProportional(INSTA[9], 1);

	INSTA[10] = TextDrawCreate(504.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[10], 0.600, 2.000);
	TextDrawTextSize(INSTA[10], 34.700, 37.000);
	TextDrawAlignment(INSTA[10], 1);
	TextDrawColour(INSTA[10], 255);
	TextDrawSetShadow(INSTA[10], 0);
	TextDrawSetOutline(INSTA[10], 1);
	TextDrawBackgroundColour(INSTA[10], 255);
	TextDrawFont(INSTA[10], 4);
	TextDrawSetProportional(INSTA[10], 1);

	INSTA[11] = TextDrawCreate(506.000, 377.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[11], 0.600, 2.000);
	TextDrawTextSize(INSTA[11], 32.500, 34.500);
	TextDrawAlignment(INSTA[11], 1);
	TextDrawColour(INSTA[11], 255);
	TextDrawSetShadow(INSTA[11], 0);
	TextDrawSetOutline(INSTA[11], 1);
	TextDrawBackgroundColour(INSTA[11], 255);
	TextDrawFont(INSTA[11], 4);
	TextDrawSetProportional(INSTA[11], 1);

	INSTA[12] = TextDrawCreate(386.299, 377.299, "ld_beat:chit");
	TextDrawLetterSize(INSTA[12], 0.600, 2.000);
	TextDrawTextSize(INSTA[12], 33.000, 34.000);
	TextDrawAlignment(INSTA[12], 1);
	TextDrawColour(INSTA[12], 255);
	TextDrawSetShadow(INSTA[12], 0);
	TextDrawSetOutline(INSTA[12], 1);
	TextDrawBackgroundColour(INSTA[12], 255);
	TextDrawFont(INSTA[12], 4);
	TextDrawSetProportional(INSTA[12], 1);

	INSTA[13] = TextDrawCreate(395.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[13], 0.600, 2.000);
	TextDrawTextSize(INSTA[13], 62.000, 263.000);
	TextDrawAlignment(INSTA[13], 1);
	TextDrawColour(INSTA[13], -1168780289);
	TextDrawSetShadow(INSTA[13], 0);
	TextDrawSetOutline(INSTA[13], 1);
	TextDrawBackgroundColour(INSTA[13], 255);
	TextDrawFont(INSTA[13], 4);
	TextDrawSetProportional(INSTA[13], 1);

	INSTA[14] = TextDrawCreate(402.000, 115.097, "LD_SPAC:black");
	TextDrawTextSize(INSTA[14], 118.000, 15.000);
	TextDrawAlignment(INSTA[14], 1);
	TextDrawColour(INSTA[14], -1);
	TextDrawSetShadow(INSTA[14], 0);
	TextDrawSetOutline(INSTA[14], 0);
	TextDrawBackgroundColour(INSTA[14], 255);
	TextDrawFont(INSTA[14], 4);
	TextDrawSetProportional(INSTA[14], 1);

	INSTA[15] = TextDrawCreate(404.000, 395.100, "LD_SPAC:black");
	TextDrawTextSize(INSTA[15], 118.000, 10.500);
	TextDrawAlignment(INSTA[15], 1);
	TextDrawColour(INSTA[15], -1);
	TextDrawSetShadow(INSTA[15], 0);
	TextDrawSetOutline(INSTA[15], 0);
	TextDrawBackgroundColour(INSTA[15], 255);
	TextDrawFont(INSTA[15], 4);
	TextDrawSetProportional(INSTA[15], 1);

	INSTA[16] = TextDrawCreate(457.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[16], 0.600, 2.000);
	TextDrawTextSize(INSTA[16], 75.500, 264.000);
	TextDrawAlignment(INSTA[16], 1);
	TextDrawColour(INSTA[16], 255);
	TextDrawSetShadow(INSTA[16], 0);
	TextDrawSetOutline(INSTA[16], 1);
	TextDrawBackgroundColour(INSTA[16], 255);
	TextDrawFont(INSTA[16], 4);
	TextDrawSetProportional(INSTA[16], 1);

	INSTA[17] = TextDrawCreate(400.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[17], 0.600, 2.000);
	TextDrawTextSize(INSTA[17], 61.000, 280.000);
	TextDrawAlignment(INSTA[17], 1);
	TextDrawColour(INSTA[17], -1168780289);
	TextDrawSetShadow(INSTA[17], 0);
	TextDrawSetOutline(INSTA[17], 1);
	TextDrawBackgroundColour(INSTA[17], 255);
	TextDrawFont(INSTA[17], 4);
	TextDrawSetProportional(INSTA[17], 1);

	INSTA[18] = TextDrawCreate(389.000, 375.000, "ld_beat:chit");
	TextDrawLetterSize(INSTA[18], 0.600, 2.000);
	TextDrawTextSize(INSTA[18], 31.000, 31.500);
	TextDrawAlignment(INSTA[18], 1);
	TextDrawColour(INSTA[18], 0);
	TextDrawSetShadow(INSTA[18], 0);
	TextDrawSetOutline(INSTA[18], 1);
	TextDrawBackgroundColour(INSTA[18], 255);
	TextDrawFont(INSTA[18], 4);
	TextDrawSetProportional(INSTA[18], 1);

	INSTA[19] = TextDrawCreate(391.500, 378.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[19], 23.000, 26.500);
	TextDrawAlignment(INSTA[19], 1);
	TextDrawColour(INSTA[19], -1168780289);
	TextDrawSetShadow(INSTA[19], 0);
	TextDrawSetOutline(INSTA[19], 0);
	TextDrawBackgroundColour(INSTA[19], 255);
	TextDrawFont(INSTA[19], 4);
	TextDrawSetProportional(INSTA[19], 1);

	INSTA[20] = TextDrawCreate(467.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[20], 0.600, 2.000);
	TextDrawTextSize(INSTA[20], 62.000, 263.000);
	TextDrawAlignment(INSTA[20], 1);
	TextDrawColour(INSTA[20], -1168780289);
	TextDrawSetShadow(INSTA[20], 0);
	TextDrawSetOutline(INSTA[20], 1);
	TextDrawBackgroundColour(INSTA[20], 255);
	TextDrawFont(INSTA[20], 4);
	TextDrawSetProportional(INSTA[20], 1);

	INSTA[21] = TextDrawCreate(460.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(INSTA[21], 0.600, 2.000);
	TextDrawTextSize(INSTA[21], 63.000, 280.000);
	TextDrawAlignment(INSTA[21], 1);
	TextDrawColour(INSTA[21], -1168780289);
	TextDrawSetShadow(INSTA[21], 0);
	TextDrawSetOutline(INSTA[21], 1);
	TextDrawBackgroundColour(INSTA[21], 255);
	TextDrawFont(INSTA[21], 4);
	TextDrawSetProportional(INSTA[21], 1);

	INSTA[22] = TextDrawCreate(509.500, 377.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[22], 24.000, 28.500);
	TextDrawAlignment(INSTA[22], 1);
	TextDrawColour(INSTA[22], -1168780289);
	TextDrawSetShadow(INSTA[22], 0);
	TextDrawSetOutline(INSTA[22], 0);
	TextDrawBackgroundColour(INSTA[22], 255);
	TextDrawFont(INSTA[22], 4);
	TextDrawSetProportional(INSTA[22], 1);

	INSTA[23] = TextDrawCreate(392.000, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[23], 20.000, 24.000);
	TextDrawAlignment(INSTA[23], 1);
	TextDrawColour(INSTA[23], -1168780289);
	TextDrawSetShadow(INSTA[23], 0);
	TextDrawSetOutline(INSTA[23], 0);
	TextDrawBackgroundColour(INSTA[23], 255);
	TextDrawFont(INSTA[23], 4);
	TextDrawSetProportional(INSTA[23], 1);

	INSTA[24] = TextDrawCreate(509.500, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[24], 24.000, 24.500);
	TextDrawAlignment(INSTA[24], 1);
	TextDrawColour(INSTA[24], -1168780289);
	TextDrawSetShadow(INSTA[24], 0);
	TextDrawSetOutline(INSTA[24], 0);
	TextDrawBackgroundColour(INSTA[24], 255);
	TextDrawFont(INSTA[24], 4);
	TextDrawSetProportional(INSTA[24], 1);

	INSTA[25] = TextDrawCreate(400.000, 124.000, "AKRP");
	TextDrawLetterSize(INSTA[25], 0.200, 0.898);
	TextDrawAlignment(INSTA[25], 1);
	TextDrawColour(INSTA[25], -1);
	TextDrawSetShadow(INSTA[25], 1);
	TextDrawSetOutline(INSTA[25], 1);
	TextDrawBackgroundColour(INSTA[25], 0);
	TextDrawFont(INSTA[25], 2);
	TextDrawSetProportional(INSTA[25], 1);

	INSTA[26] = TextDrawCreate(429.000, 135.000, "LD_SPAC:black");
	TextDrawTextSize(INSTA[26], 66.000, -11.000);
	TextDrawAlignment(INSTA[26], 1);
	TextDrawColour(INSTA[26], -1);
	TextDrawSetShadow(INSTA[26], 0);
	TextDrawSetOutline(INSTA[26], 0);
	TextDrawBackgroundColour(INSTA[26], 255);
	TextDrawFont(INSTA[26], 4);
	TextDrawSetProportional(INSTA[26], 1);

	INSTA[27] = TextDrawCreate(423.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[27], 16.000, 17.000);
	TextDrawAlignment(INSTA[27], 1);
	TextDrawColour(INSTA[27], 255);
	TextDrawSetShadow(INSTA[27], 0);
	TextDrawSetOutline(INSTA[27], 0);
	TextDrawBackgroundColour(INSTA[27], 255);
	TextDrawFont(INSTA[27], 4);
	TextDrawSetProportional(INSTA[27], 1);

	INSTA[28] = TextDrawCreate(485.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[28], 16.000, 17.000);
	TextDrawAlignment(INSTA[28], 1);
	TextDrawColour(INSTA[28], 255);
	TextDrawSetShadow(INSTA[28], 0);
	TextDrawSetOutline(INSTA[28], 0);
	TextDrawBackgroundColour(INSTA[28], 255);
	TextDrawFont(INSTA[28], 4);
	TextDrawSetProportional(INSTA[28], 1);

	INSTA[29] = TextDrawCreate(508.000, 122.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[29], 2.000, 12.000);
	TextDrawAlignment(INSTA[29], 1);
	TextDrawColour(INSTA[29], -1);
	TextDrawSetShadow(INSTA[29], 0);
	TextDrawSetOutline(INSTA[29], 0);
	TextDrawBackgroundColour(INSTA[29], 255);
	TextDrawFont(INSTA[29], 4);
	TextDrawSetProportional(INSTA[29], 1);

	INSTA[30] = TextDrawCreate(505.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[30], 2.000, -8.000);
	TextDrawAlignment(INSTA[30], 1);
	TextDrawColour(INSTA[30], -1);
	TextDrawSetShadow(INSTA[30], 0);
	TextDrawSetOutline(INSTA[30], 0);
	TextDrawBackgroundColour(INSTA[30], 255);
	TextDrawFont(INSTA[30], 4);
	TextDrawSetProportional(INSTA[30], 1);

	INSTA[31] = TextDrawCreate(502.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[31], 2.000, -5.000);
	TextDrawAlignment(INSTA[31], 1);
	TextDrawColour(INSTA[31], -1);
	TextDrawSetShadow(INSTA[31], 0);
	TextDrawSetOutline(INSTA[31], 0);
	TextDrawBackgroundColour(INSTA[31], 255);
	TextDrawFont(INSTA[31], 4);
	TextDrawSetProportional(INSTA[31], 1);

	INSTA[32] = TextDrawCreate(499.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[32], 2.000, -2.000);
	TextDrawAlignment(INSTA[32], 1);
	TextDrawColour(INSTA[32], -1);
	TextDrawSetShadow(INSTA[32], 0);
	TextDrawSetOutline(INSTA[32], 0);
	TextDrawBackgroundColour(INSTA[32], 255);
	TextDrawFont(INSTA[32], 4);
	TextDrawSetProportional(INSTA[32], 1);

	INSTA[33] = TextDrawCreate(514.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[33], 10.000, -8.000);
	TextDrawAlignment(INSTA[33], 1);
	TextDrawColour(INSTA[33], -1);
	TextDrawSetShadow(INSTA[33], 0);
	TextDrawSetOutline(INSTA[33], 0);
	TextDrawBackgroundColour(INSTA[33], 255);
	TextDrawFont(INSTA[33], 4);
	TextDrawSetProportional(INSTA[33], 1);

	INSTA[34] = TextDrawCreate(523.000, 132.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[34], 3.000, -4.000);
	TextDrawAlignment(INSTA[34], 1);
	TextDrawColour(INSTA[34], -1);
	TextDrawSetShadow(INSTA[34], 0);
	TextDrawSetOutline(INSTA[34], 0);
	TextDrawBackgroundColour(INSTA[34], 255);
	TextDrawFont(INSTA[34], 4);
	TextDrawSetProportional(INSTA[34], 1);

	INSTA[35] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[35], 72.000, 3.000);
	TextDrawAlignment(INSTA[35], 1);
	TextDrawColour(INSTA[35], 255);
	TextDrawSetShadow(INSTA[35], 0);
	TextDrawSetOutline(INSTA[35], 0);
	TextDrawBackgroundColour(INSTA[35], 255);
	TextDrawFont(INSTA[35], 4);
	TextDrawSetProportional(INSTA[35], 1);
	TextDrawSetSelectable(INSTA[35], 1);

	INSTA[36] = TextDrawCreate(400.000, 139.000, "LD_SPAC:black");
	TextDrawTextSize(INSTA[36], 125.000, 232.000);
	TextDrawAlignment(INSTA[36], 1);
	TextDrawColour(INSTA[36], -1);
	TextDrawSetShadow(INSTA[36], 0);
	TextDrawSetOutline(INSTA[36], 0);
	TextDrawBackgroundColour(INSTA[36], 255);
	TextDrawFont(INSTA[36], 4);
	TextDrawSetProportional(INSTA[36], 1);

	INSTA[37] = TextDrawCreate(402.000, 142.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[37], 21.000, 24.000);
	TextDrawAlignment(INSTA[37], 1);
	TextDrawColour(INSTA[37], -1);
	TextDrawSetShadow(INSTA[37], 0);
	TextDrawSetOutline(INSTA[37], 0);
	TextDrawBackgroundColour(INSTA[37], 255);
	TextDrawFont(INSTA[37], 4);
	TextDrawSetProportional(INSTA[37], 1);

	INSTA[38] = TextDrawCreate(410.000, 146.000, "LD_SPAC:white");
	TextDrawTextSize(INSTA[38], 63.000, 16.000);
	TextDrawAlignment(INSTA[38], 1);
	TextDrawColour(INSTA[38], -1);
	TextDrawSetShadow(INSTA[38], 0);
	TextDrawSetOutline(INSTA[38], 0);
	TextDrawBackgroundColour(INSTA[38], 255);
	TextDrawFont(INSTA[38], 4);
	TextDrawSetProportional(INSTA[38], 1);

	INSTA[39] = TextDrawCreate(461.000, 142.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[39], 21.000, 24.000);
	TextDrawAlignment(INSTA[39], 1);
	TextDrawColour(INSTA[39], -1);
	TextDrawSetShadow(INSTA[39], 0);
	TextDrawSetOutline(INSTA[39], 0);
	TextDrawBackgroundColour(INSTA[39], 255);
	TextDrawFont(INSTA[39], 4);
	TextDrawSetProportional(INSTA[39], 1);

	INSTA[40] = TextDrawCreate(415.000, 146.000, "Instagram");
	TextDrawLetterSize(INSTA[40], 0.300, 1.500);
	TextDrawAlignment(INSTA[40], 1);
	TextDrawColour(INSTA[40], 255);
	TextDrawSetShadow(INSTA[40], 1);
	TextDrawSetOutline(INSTA[40], 1);
	TextDrawBackgroundColour(INSTA[40], 0);
	TextDrawFont(INSTA[40], 3);
	TextDrawSetProportional(INSTA[40], 1);

	INSTA[41] = TextDrawCreate(399.000, 163.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[41], 34.000, 39.000);
	TextDrawAlignment(INSTA[41], 1);
	TextDrawColour(INSTA[41], -1112052737);
	TextDrawSetShadow(INSTA[41], 0);
	TextDrawSetOutline(INSTA[41], 0);
	TextDrawBackgroundColour(INSTA[41], 255);
	TextDrawFont(INSTA[41], 4);
	TextDrawSetProportional(INSTA[41], 1);

	INSTA[42] = TextDrawCreate(412.000, 173.000, "LD_SPAC:dark");
	TextDrawTextSize(INSTA[42], 8.000, 9.000);
	TextDrawAlignment(INSTA[42], 1);
	TextDrawColour(INSTA[42], -1);
	TextDrawSetShadow(INSTA[42], 0);
	TextDrawSetOutline(INSTA[42], 0);
	TextDrawBackgroundColour(INSTA[42], 255);
	TextDrawFont(INSTA[42], 4);
	TextDrawSetProportional(INSTA[42], 1);

	INSTA[43] = TextDrawCreate(410.000, 193.000, "LD_SPAC:light");
	TextDrawTextSize(INSTA[43], 12.000, -10.000);
	TextDrawAlignment(INSTA[43], 1);
	TextDrawColour(INSTA[43], -1);
	TextDrawSetShadow(INSTA[43], 0);
	TextDrawSetOutline(INSTA[43], 0);
	TextDrawBackgroundColour(INSTA[43], 255);
	TextDrawFont(INSTA[43], 4);
	TextDrawSetProportional(INSTA[43], 1);

	INSTA[44] = TextDrawCreate(429.000, 178.000, "NAJUAIRCRACK");
	TextDrawLetterSize(INSTA[44], 0.140, 0.799);
	TextDrawAlignment(INSTA[44], 1);
	TextDrawColour(INSTA[44], -1);
	TextDrawSetShadow(INSTA[44], 1);
	TextDrawSetOutline(INSTA[44], 1);
	TextDrawBackgroundColour(INSTA[44], 0);
	TextDrawFont(INSTA[44], 2);
	TextDrawSetProportional(INSTA[44], 1);

	INSTA[45] = TextDrawCreate(418.000, 202.000, "_");
	TextDrawTextSize(INSTA[45], 90.000, 90.000);
	TextDrawAlignment(INSTA[45], 1);
	TextDrawColour(INSTA[45], -1);
	TextDrawSetShadow(INSTA[45], 0);
	TextDrawSetOutline(INSTA[45], 0);
	TextDrawBackgroundColour(INSTA[45], -1329275137);
	TextDrawFont(INSTA[45], 5);
	TextDrawSetProportional(INSTA[45], 0);
	TextDrawSetPreviewModel(INSTA[45], 496);
	TextDrawSetPreviewRot(INSTA[45], -5.000, -5.000, -38.000, 0.898);
	TextDrawSetPreviewVehCol(INSTA[45], 6, 0);

	INSTA[46] = TextDrawCreate(420.000, 278.000, "Let Him Cook!");
	TextDrawLetterSize(INSTA[46], 0.300, 1.299);
	TextDrawAlignment(INSTA[46], 1);
	TextDrawColour(INSTA[46], 255);
	TextDrawSetShadow(INSTA[46], 1);
	TextDrawSetOutline(INSTA[46], 1);
	TextDrawBackgroundColour(INSTA[46], 0);
	TextDrawFont(INSTA[46], 1);
	TextDrawSetProportional(INSTA[46], 1);
	

	INSTA[47] = TextDrawCreate(446.000, 342.000, "LD_BEAT:chit");
	TextDrawTextSize(INSTA[47], 33.000, 39.000);
	TextDrawAlignment(INSTA[47], 1);
	TextDrawColour(INSTA[47], -1);
	TextDrawSetShadow(INSTA[47], 0);
	TextDrawSetOutline(INSTA[47], 0);
	TextDrawBackgroundColour(INSTA[47], 255);
	TextDrawFont(INSTA[47], 4);
	TextDrawSetProportional(INSTA[47], 1);
	TextDrawSetSelectable(INSTA[47], 1);


	INSTA[48] = TextDrawCreate(457.000, 348.000, "+");
	TextDrawLetterSize(INSTA[48], 0.669, 2.197);
	TextDrawTextSize(INSTA[48], 471.000, -7.000);
	TextDrawAlignment(INSTA[48], 1);
	TextDrawColour(INSTA[48], 255);
	TextDrawSetShadow(INSTA[48], 1);
	TextDrawSetOutline(INSTA[48], 1);
	TextDrawBackgroundColour(INSTA[48], 0);
	TextDrawFont(INSTA[48], 1);
	TextDrawSetProportional(INSTA[48], 1);
	TextDrawSetSelectable(INSTA[48], 1);

	

	DEATHBUTTON[0] = TextDrawCreate(278.500, 275.000, "LD_SPAC:white");
	TextDrawTextSize(DEATHBUTTON[0], 82.000, 34.000);
	TextDrawAlignment(DEATHBUTTON[0], 1);
	TextDrawColour(DEATHBUTTON[0], -687865601);
	TextDrawSetShadow(DEATHBUTTON[0], 0);
	TextDrawSetOutline(DEATHBUTTON[0], 0);
	TextDrawBackgroundColour(DEATHBUTTON[0], 255);
	TextDrawFont(DEATHBUTTON[0], 4);
	TextDrawSetProportional(DEATHBUTTON[0], 1);

	DEATHBUTTON[1] = TextDrawCreate(276.500, 279.000, "LD_SPAC:white");
	TextDrawTextSize(DEATHBUTTON[1], 87.000, 26.000);
	TextDrawAlignment(DEATHBUTTON[1], 1);
	TextDrawColour(DEATHBUTTON[1], -687865601);
	TextDrawSetShadow(DEATHBUTTON[1], 0);
	TextDrawSetOutline(DEATHBUTTON[1], 0);
	TextDrawBackgroundColour(DEATHBUTTON[1], 255);
	TextDrawFont(DEATHBUTTON[1], 4);
	TextDrawSetProportional(DEATHBUTTON[1], 1);

	DEATHBUTTON[2] = TextDrawCreate(274.500, 300.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[2], 12.000, 11.000);
	TextDrawAlignment(DEATHBUTTON[2], 1);
	TextDrawColour(DEATHBUTTON[2], -654311169);
	TextDrawSetShadow(DEATHBUTTON[2], 0);
	TextDrawSetOutline(DEATHBUTTON[2], 0);
	TextDrawBackgroundColour(DEATHBUTTON[2], 255);
	TextDrawFont(DEATHBUTTON[2], 4);
	TextDrawSetProportional(DEATHBUTTON[2], 1);

	DEATHBUTTON[3] = TextDrawCreate(274.500, 273.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[3], 12.000, 11.000);
	TextDrawAlignment(DEATHBUTTON[3], 1);
	TextDrawColour(DEATHBUTTON[3], -654311169);
	TextDrawSetShadow(DEATHBUTTON[3], 0);
	TextDrawSetOutline(DEATHBUTTON[3], 0);
	TextDrawBackgroundColour(DEATHBUTTON[3], 255);
	TextDrawFont(DEATHBUTTON[3], 4);
	TextDrawSetProportional(DEATHBUTTON[3], 1);

	DEATHBUTTON[4] = TextDrawCreate(353.500, 273.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[4], 12.000, 11.000);
	TextDrawAlignment(DEATHBUTTON[4], 1);
	TextDrawColour(DEATHBUTTON[4], -654311169);
	TextDrawSetShadow(DEATHBUTTON[4], 0);
	TextDrawSetOutline(DEATHBUTTON[4], 0);
	TextDrawBackgroundColour(DEATHBUTTON[4], 255);
	TextDrawFont(DEATHBUTTON[4], 4);
	TextDrawSetProportional(DEATHBUTTON[4], 1);

	DEATHBUTTON[5] = TextDrawCreate(353.500, 300.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[5], 12.000, 11.000);
	TextDrawAlignment(DEATHBUTTON[5], 1);
	TextDrawColour(DEATHBUTTON[5], -654311169);
	TextDrawSetShadow(DEATHBUTTON[5], 0);
	TextDrawSetOutline(DEATHBUTTON[5], 0);
	TextDrawBackgroundColour(DEATHBUTTON[5], 255);
	TextDrawFont(DEATHBUTTON[5], 4);
	TextDrawSetProportional(DEATHBUTTON[5], 1);

	DEATHBUTTON[6] = TextDrawCreate(284.500, 284.000, "LD_SPAC:white");
	TextDrawTextSize(DEATHBUTTON[6], 9.000, 16.000);
	TextDrawAlignment(DEATHBUTTON[6], 1);
	TextDrawColour(DEATHBUTTON[6], -1);
	TextDrawSetShadow(DEATHBUTTON[6], 0);
	TextDrawSetOutline(DEATHBUTTON[6], 0);
	TextDrawBackgroundColour(DEATHBUTTON[6], 255);
	TextDrawFont(DEATHBUTTON[6], 4);
	TextDrawSetProportional(DEATHBUTTON[6], 1);

	DEATHBUTTON[7] = TextDrawCreate(283.000, 285.000, "LD_SPAC:white");
	TextDrawTextSize(DEATHBUTTON[7], 12.000, 14.000);
	TextDrawAlignment(DEATHBUTTON[7], 1);
	TextDrawColour(DEATHBUTTON[7], -1);
	TextDrawSetShadow(DEATHBUTTON[7], 0);
	TextDrawSetOutline(DEATHBUTTON[7], 0);
	TextDrawBackgroundColour(DEATHBUTTON[7], 255);
	TextDrawFont(DEATHBUTTON[7], 4);
	TextDrawSetProportional(DEATHBUTTON[7], 1);

	DEATHBUTTON[8] = TextDrawCreate(292.500, 283.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[8], 3.000, 4.000);
	TextDrawAlignment(DEATHBUTTON[8], 1);
	TextDrawColour(DEATHBUTTON[8], -1);
	TextDrawSetShadow(DEATHBUTTON[8], 0);
	TextDrawSetOutline(DEATHBUTTON[8], 0);
	TextDrawBackgroundColour(DEATHBUTTON[8], 255);
	TextDrawFont(DEATHBUTTON[8], 4);
	TextDrawSetProportional(DEATHBUTTON[8], 1);

	DEATHBUTTON[9] = TextDrawCreate(282.500, 283.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[9], 3.000, 4.000);
	TextDrawAlignment(DEATHBUTTON[9], 1);
	TextDrawColour(DEATHBUTTON[9], -1);
	TextDrawSetShadow(DEATHBUTTON[9], 0);
	TextDrawSetOutline(DEATHBUTTON[9], 0);
	TextDrawBackgroundColour(DEATHBUTTON[9], 255);
	TextDrawFont(DEATHBUTTON[9], 4);
	TextDrawSetProportional(DEATHBUTTON[9], 1);

	DEATHBUTTON[10] = TextDrawCreate(282.500, 297.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[10], 3.000, 4.000);
	TextDrawAlignment(DEATHBUTTON[10], 1);
	TextDrawColour(DEATHBUTTON[10], -1);
	TextDrawSetShadow(DEATHBUTTON[10], 0);
	TextDrawSetOutline(DEATHBUTTON[10], 0);
	TextDrawBackgroundColour(DEATHBUTTON[10], 255);
	TextDrawFont(DEATHBUTTON[10], 4);
	TextDrawSetProportional(DEATHBUTTON[10], 1);

	DEATHBUTTON[11] = TextDrawCreate(292.500, 297.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[11], 3.000, 4.000);
	TextDrawAlignment(DEATHBUTTON[11], 1);
	TextDrawColour(DEATHBUTTON[11], -1);
	TextDrawSetShadow(DEATHBUTTON[11], 0);
	TextDrawSetOutline(DEATHBUTTON[11], 0);
	TextDrawBackgroundColour(DEATHBUTTON[11], 255);
	TextDrawFont(DEATHBUTTON[11], 4);
	TextDrawSetProportional(DEATHBUTTON[11], 1);

	DEATHBUTTON[12] = TextDrawCreate(289.500, 282.000, "+");
	TextDrawLetterSize(DEATHBUTTON[12], 0.300, 1.598);
	TextDrawAlignment(DEATHBUTTON[12], 2);
	TextDrawColour(DEATHBUTTON[12], -16776961);
	TextDrawSetShadow(DEATHBUTTON[12], 1);
	TextDrawSetOutline(DEATHBUTTON[12], 1);
	TextDrawBackgroundColour(DEATHBUTTON[12], -654311424);
	TextDrawFont(DEATHBUTTON[12], 3);
	TextDrawSetProportional(DEATHBUTTON[12], 1);

	DEATHBUTTON[13] = TextDrawCreate(284.500, 296.000, "LD_SPAC:white");
	TextDrawTextSize(DEATHBUTTON[13], 7.000, 2.500);
	TextDrawAlignment(DEATHBUTTON[13], 1);
	TextDrawColour(DEATHBUTTON[13], -654311169);
	TextDrawSetShadow(DEATHBUTTON[13], 0);
	TextDrawSetOutline(DEATHBUTTON[13], 0);
	TextDrawBackgroundColour(DEATHBUTTON[13], 255);
	TextDrawFont(DEATHBUTTON[13], 4);
	TextDrawSetProportional(DEATHBUTTON[13], 1);

	DEATHBUTTON[14] = TextDrawCreate(292.500, 294.000, "LD_BEAT:chit");
	TextDrawTextSize(DEATHBUTTON[14], 5.000, 7.000);
	TextDrawAlignment(DEATHBUTTON[14], 1);
	TextDrawColour(DEATHBUTTON[14], -654311169);
	TextDrawSetShadow(DEATHBUTTON[14], 0);
	TextDrawSetOutline(DEATHBUTTON[14], 0);
	TextDrawBackgroundColour(DEATHBUTTON[14], 255);
	TextDrawFont(DEATHBUTTON[14], 4);
	TextDrawSetProportional(DEATHBUTTON[14], 1);
	 //phone
	DIALER[0] = TextDrawCreate(426.000, 325.000, "LD_SPAC:light");
	TextDrawTextSize(DIALER[0], 1.000, 1.000);
	TextDrawAlignment(DIALER[0], 1);
	TextDrawColour(DIALER[0], -1);
	TextDrawSetShadow(DIALER[0], 0);
	TextDrawSetOutline(DIALER[0], 0);
	TextDrawBackgroundColour(DIALER[0], 255);
	TextDrawFont(DIALER[0], 4);
	TextDrawSetProportional(DIALER[0], 1);

	DIALER[1] = TextDrawCreate(405.000, 168.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[1], 43.000, 52.000);
	TextDrawAlignment(DIALER[1], 1);
	TextDrawColour(DIALER[1], -1061109505);
	TextDrawSetShadow(DIALER[1], 0);
	TextDrawSetOutline(DIALER[1], 0);
	TextDrawBackgroundColour(DIALER[1], 255);
	TextDrawFont(DIALER[1], 4);
	TextDrawSetProportional(DIALER[1], 1);
	TextDrawSetSelectable(DIALER[1], 1);

	DIALER[2] = TextDrawCreate(440.000, 168.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[2], 43.000, 52.000);
	TextDrawAlignment(DIALER[2], 1);
	TextDrawColour(DIALER[2], -1061109505);
	TextDrawSetShadow(DIALER[2], 0);
	TextDrawSetOutline(DIALER[2], 0);
	TextDrawBackgroundColour(DIALER[2], 255);
	TextDrawFont(DIALER[2], 4);
	TextDrawSetProportional(DIALER[2], 1);
	TextDrawSetSelectable(DIALER[2], 1);

	DIALER[3] = TextDrawCreate(476.000, 168.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[3], 43.000, 52.000);
	TextDrawAlignment(DIALER[3], 1);
	TextDrawColour(DIALER[3], -1061109505);
	TextDrawSetShadow(DIALER[3], 0);
	TextDrawSetOutline(DIALER[3], 0);
	TextDrawBackgroundColour(DIALER[3], 255);
	TextDrawFont(DIALER[3], 4);
	TextDrawSetProportional(DIALER[3], 1);
	TextDrawSetSelectable(DIALER[3], 1);

	DIALER[4] = TextDrawCreate(405.000, 210.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[4], 43.000, 52.000);
	TextDrawAlignment(DIALER[4], 1);
	TextDrawColour(DIALER[4], -1061109505);
	TextDrawSetShadow(DIALER[4], 0);
	TextDrawSetOutline(DIALER[4], 0);
	TextDrawBackgroundColour(DIALER[4], 255);
	TextDrawFont(DIALER[4], 4);
	TextDrawSetProportional(DIALER[4], 1);
	TextDrawSetSelectable(DIALER[4], 1);

	DIALER[5] = TextDrawCreate(440.000, 210.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[5], 43.000, 52.000);
	TextDrawAlignment(DIALER[5], 1);
	TextDrawColour(DIALER[5], -1061109505);
	TextDrawSetShadow(DIALER[5], 0);
	TextDrawSetOutline(DIALER[5], 0);
	TextDrawBackgroundColour(DIALER[5], 255);
	TextDrawFont(DIALER[5], 4);
	TextDrawSetProportional(DIALER[5], 1);
	TextDrawSetSelectable(DIALER[5], 1);

	DIALER[6] = TextDrawCreate(476.000, 210.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[6], 43.000, 52.000);
	TextDrawAlignment(DIALER[6], 1);
	TextDrawColour(DIALER[6], -1061109505);
	TextDrawSetShadow(DIALER[6], 0);
	TextDrawSetOutline(DIALER[6], 0);
	TextDrawBackgroundColour(DIALER[6], 255);
	TextDrawFont(DIALER[6], 4);
	TextDrawSetProportional(DIALER[6], 1);
	TextDrawSetSelectable(DIALER[6], 1);

	DIALER[7] = TextDrawCreate(405.000, 251.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[7], 43.000, 52.000);
	TextDrawAlignment(DIALER[7], 1);
	TextDrawColour(DIALER[7], -1061109505);
	TextDrawSetShadow(DIALER[7], 0);
	TextDrawSetOutline(DIALER[7], 0);
	TextDrawBackgroundColour(DIALER[7], 255);
	TextDrawFont(DIALER[7], 4);
	TextDrawSetProportional(DIALER[7], 1);
	TextDrawSetSelectable(DIALER[7], 1);

	DIALER[8] = TextDrawCreate(440.000, 251.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[8], 43.000, 52.000);
	TextDrawAlignment(DIALER[8], 1);
	TextDrawColour(DIALER[8], -1061109505);
	TextDrawSetShadow(DIALER[8], 0);
	TextDrawSetOutline(DIALER[8], 0);
	TextDrawBackgroundColour(DIALER[8], 255);
	TextDrawFont(DIALER[8], 4);
	TextDrawSetProportional(DIALER[8], 1);
	TextDrawSetSelectable(DIALER[8], 1);

	DIALER[9] = TextDrawCreate(476.000, 251.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[9], 43.000, 52.000);
	TextDrawAlignment(DIALER[9], 1);
	TextDrawColour(DIALER[9], -1061109505);
	TextDrawSetShadow(DIALER[9], 0);
	TextDrawSetOutline(DIALER[9], 0);
	TextDrawBackgroundColour(DIALER[9], 255);
	TextDrawFont(DIALER[9], 4);
	TextDrawSetProportional(DIALER[9], 1);
	TextDrawSetSelectable(DIALER[9], 1);

	DIALER[10] = TextDrawCreate(440.000, 292.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[10], 43.000, 52.000);
	TextDrawAlignment(DIALER[10], 1);
	TextDrawColour(DIALER[10], -1061109505);
	TextDrawSetShadow(DIALER[10], 0);
	TextDrawSetOutline(DIALER[10], 0);
	TextDrawBackgroundColour(DIALER[10], 255);
	TextDrawFont(DIALER[10], 4);
	TextDrawSetProportional(DIALER[10], 1);
	TextDrawSetSelectable(DIALER[10], 1);

	DIALER[11] = TextDrawCreate(476.000, 292.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[11], 43.000, 52.000);
	TextDrawAlignment(DIALER[11], 1);
	TextDrawColour(DIALER[11], -1061109505);
	TextDrawSetShadow(DIALER[11], 0);
	TextDrawSetOutline(DIALER[11], 0);
	TextDrawBackgroundColour(DIALER[11], 255);
	TextDrawFont(DIALER[11], 4);
	TextDrawSetProportional(DIALER[11], 1);
	TextDrawSetSelectable(DIALER[11], 1);

	DIALER[12] = TextDrawCreate(405.000, 292.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[12], 43.000, 52.000);
	TextDrawAlignment(DIALER[12], 1);
	TextDrawColour(DIALER[12], -1061109505);
	TextDrawSetShadow(DIALER[12], 0);
	TextDrawSetOutline(DIALER[12], 0);
	TextDrawBackgroundColour(DIALER[12], 255);
	TextDrawFont(DIALER[12], 4);
	TextDrawSetProportional(DIALER[12], 1);
	TextDrawSetSelectable(DIALER[12], 1);

	DIALER[13] = TextDrawCreate(423.000, 187.000, "1");
	TextDrawLetterSize(DIALER[13], 0.300, 1.500);
	TextDrawAlignment(DIALER[13], 1);
	TextDrawColour(DIALER[13], -1);
	TextDrawSetShadow(DIALER[13], 1);
	TextDrawSetOutline(DIALER[13], 1);
	TextDrawBackgroundColour(DIALER[13], 150);
	TextDrawFont(DIALER[13], 2);
	TextDrawSetProportional(DIALER[13], 1);

	DIALER[14] = TextDrawCreate(457.000, 187.000, "2");
	TextDrawLetterSize(DIALER[14], 0.300, 1.500);
	TextDrawAlignment(DIALER[14], 1);
	TextDrawColour(DIALER[14], -1);
	TextDrawSetShadow(DIALER[14], 1);
	TextDrawSetOutline(DIALER[14], 1);
	TextDrawBackgroundColour(DIALER[14], 150);
	TextDrawFont(DIALER[14], 2);
	TextDrawSetProportional(DIALER[14], 1);

	DIALER[15] = TextDrawCreate(493.000, 187.000, "3");
	TextDrawLetterSize(DIALER[15], 0.300, 1.500);
	TextDrawAlignment(DIALER[15], 1);
	TextDrawColour(DIALER[15], -1);
	TextDrawSetShadow(DIALER[15], 1);
	TextDrawSetOutline(DIALER[15], 1);
	TextDrawBackgroundColour(DIALER[15], 150);
	TextDrawFont(DIALER[15], 2);
	TextDrawSetProportional(DIALER[15], 1);

	DIALER[16] = TextDrawCreate(422.000, 229.000, "4");
	TextDrawLetterSize(DIALER[16], 0.300, 1.500);
	TextDrawAlignment(DIALER[16], 1);
	TextDrawColour(DIALER[16], -1);
	TextDrawSetShadow(DIALER[16], 1);
	TextDrawSetOutline(DIALER[16], 1);
	TextDrawBackgroundColour(DIALER[16], 150);
	TextDrawFont(DIALER[16], 2);
	TextDrawSetProportional(DIALER[16], 1);

	DIALER[17] = TextDrawCreate(457.000, 229.000, "5");
	TextDrawLetterSize(DIALER[17], 0.300, 1.500);
	TextDrawAlignment(DIALER[17], 1);
	TextDrawColour(DIALER[17], -1);
	TextDrawSetShadow(DIALER[17], 1);
	TextDrawSetOutline(DIALER[17], 1);
	TextDrawBackgroundColour(DIALER[17], 150);
	TextDrawFont(DIALER[17], 2);
	TextDrawSetProportional(DIALER[17], 1);

	DIALER[18] = TextDrawCreate(493.000, 229.000, "6");
	TextDrawLetterSize(DIALER[18], 0.300, 1.500);
	TextDrawAlignment(DIALER[18], 1);
	TextDrawColour(DIALER[18], -1);
	TextDrawSetShadow(DIALER[18], 1);
	TextDrawSetOutline(DIALER[18], 1);
	TextDrawBackgroundColour(DIALER[18], 150);
	TextDrawFont(DIALER[18], 2);
	TextDrawSetProportional(DIALER[18], 1);

	DIALER[19] = TextDrawCreate(422.000, 270.000, "7");
	TextDrawLetterSize(DIALER[19], 0.300, 1.500);
	TextDrawAlignment(DIALER[19], 1);
	TextDrawColour(DIALER[19], -1);
	TextDrawSetShadow(DIALER[19], 1);
	TextDrawSetOutline(DIALER[19], 1);
	TextDrawBackgroundColour(DIALER[19], 150);
	TextDrawFont(DIALER[19], 2);
	TextDrawSetProportional(DIALER[19], 1);

	DIALER[20] = TextDrawCreate(457.000, 270.000, "8");
	TextDrawLetterSize(DIALER[20], 0.300, 1.500);
	TextDrawAlignment(DIALER[20], 1);
	TextDrawColour(DIALER[20], -1);
	TextDrawSetShadow(DIALER[20], 1);
	TextDrawSetOutline(DIALER[20], 1);
	TextDrawBackgroundColour(DIALER[20], 150);
	TextDrawFont(DIALER[20], 2);
	TextDrawSetProportional(DIALER[20], 1);

	DIALER[21] = TextDrawCreate(493.000, 270.000, "9");
	TextDrawLetterSize(DIALER[21], 0.300, 1.500);
	TextDrawAlignment(DIALER[21], 1);
	TextDrawColour(DIALER[21], -1);
	TextDrawSetShadow(DIALER[21], 1);
	TextDrawSetOutline(DIALER[21], 1);
	TextDrawBackgroundColour(DIALER[21], 150);
	TextDrawFont(DIALER[21], 2);
	TextDrawSetProportional(DIALER[21], 1);

	DIALER[22] = TextDrawCreate(457.000, 311.000, "0");
	TextDrawLetterSize(DIALER[22], 0.300, 1.500);
	TextDrawAlignment(DIALER[22], 1);
	TextDrawColour(DIALER[22], -1);
	TextDrawSetShadow(DIALER[22], 1);
	TextDrawSetOutline(DIALER[22], 1);
	TextDrawBackgroundColour(DIALER[22], 150);
	TextDrawFont(DIALER[22], 2);
	TextDrawSetProportional(DIALER[22], 1);

	DIALER[23] = TextDrawCreate(493.000, 311.000, "x");
	TextDrawLetterSize(DIALER[23], 0.300, 1.500);
	TextDrawAlignment(DIALER[23], 1);
	TextDrawColour(DIALER[23], -1);
	TextDrawSetShadow(DIALER[23], 1);
	TextDrawSetOutline(DIALER[23], 1);
	TextDrawBackgroundColour(DIALER[23], 150);
	TextDrawFont(DIALER[23], 2);
	TextDrawSetProportional(DIALER[23], 1);

	DIALER[24] = TextDrawCreate(422.000, 311.000, "x");
	TextDrawLetterSize(DIALER[24], 0.300, 1.500);
	TextDrawAlignment(DIALER[24], 1);
	TextDrawColour(DIALER[24], -1);
	TextDrawSetShadow(DIALER[24], 1);
	TextDrawSetOutline(DIALER[24], 1);
	TextDrawBackgroundColour(DIALER[24], 150);
	TextDrawFont(DIALER[24], 2);
	TextDrawSetProportional(DIALER[24], 1);

	DIALER[25] = TextDrawCreate(422.000, 311.000, "+");
	TextDrawLetterSize(DIALER[25], 0.319, 1.299);
	TextDrawAlignment(DIALER[25], 1);
	TextDrawColour(DIALER[25], -1);
	TextDrawSetShadow(DIALER[25], 1);
	TextDrawSetOutline(DIALER[25], 1);
	TextDrawBackgroundColour(DIALER[25], 150);
	TextDrawFont(DIALER[25], 2);
	TextDrawSetProportional(DIALER[25], 1);

	DIALER[26] = TextDrawCreate(456.000, 199.000, "ABC");
	TextDrawLetterSize(DIALER[26], 0.128, 0.597);
	TextDrawAlignment(DIALER[26], 1);
	TextDrawColour(DIALER[26], 255);
	TextDrawSetShadow(DIALER[26], 1);
	TextDrawSetOutline(DIALER[26], 1);
	TextDrawBackgroundColour(DIALER[26], 0);
	TextDrawFont(DIALER[26], 2);
	TextDrawSetProportional(DIALER[26], 1);

	DIALER[27] = TextDrawCreate(492.000, 199.000, "DEF");
	TextDrawLetterSize(DIALER[27], 0.128, 0.597);
	TextDrawAlignment(DIALER[27], 1);
	TextDrawColour(DIALER[27], 255);
	TextDrawSetShadow(DIALER[27], 1);
	TextDrawSetOutline(DIALER[27], 1);
	TextDrawBackgroundColour(DIALER[27], 0);
	TextDrawFont(DIALER[27], 2);
	TextDrawSetProportional(DIALER[27], 1);

	DIALER[28] = TextDrawCreate(421.000, 241.000, "GHI");
	TextDrawLetterSize(DIALER[28], 0.128, 0.597);
	TextDrawAlignment(DIALER[28], 1);
	TextDrawColour(DIALER[28], 255);
	TextDrawSetShadow(DIALER[28], 1);
	TextDrawSetOutline(DIALER[28], 1);
	TextDrawBackgroundColour(DIALER[28], 0);
	TextDrawFont(DIALER[28], 2);
	TextDrawSetProportional(DIALER[28], 1);

	DIALER[29] = TextDrawCreate(456.000, 241.000, "JKL");
	TextDrawLetterSize(DIALER[29], 0.128, 0.597);
	TextDrawAlignment(DIALER[29], 1);
	TextDrawColour(DIALER[29], 255);
	TextDrawSetShadow(DIALER[29], 1);
	TextDrawSetOutline(DIALER[29], 1);
	TextDrawBackgroundColour(DIALER[29], 0);
	TextDrawFont(DIALER[29], 2);
	TextDrawSetProportional(DIALER[29], 1);

	DIALER[30] = TextDrawCreate(492.000, 241.000, "MNO");
	TextDrawLetterSize(DIALER[30], 0.128, 0.597);
	TextDrawAlignment(DIALER[30], 1);
	TextDrawColour(DIALER[30], 255);
	TextDrawSetShadow(DIALER[30], 1);
	TextDrawSetOutline(DIALER[30], 1);
	TextDrawBackgroundColour(DIALER[30], 0);
	TextDrawFont(DIALER[30], 2);
	TextDrawSetProportional(DIALER[30], 1);

	DIALER[31] = TextDrawCreate(419.000, 282.000, "PQRS");
	TextDrawLetterSize(DIALER[31], 0.128, 0.597);
	TextDrawAlignment(DIALER[31], 1);
	TextDrawColour(DIALER[31], 255);
	TextDrawSetShadow(DIALER[31], 1);
	TextDrawSetOutline(DIALER[31], 1);
	TextDrawBackgroundColour(DIALER[31], 0);
	TextDrawFont(DIALER[31], 2);
	TextDrawSetProportional(DIALER[31], 1);

	DIALER[32] = TextDrawCreate(456.000, 282.000, "TUV");
	TextDrawLetterSize(DIALER[32], 0.128, 0.597);
	TextDrawAlignment(DIALER[32], 1);
	TextDrawColour(DIALER[32], 255);
	TextDrawSetShadow(DIALER[32], 1);
	TextDrawSetOutline(DIALER[32], 1);
	TextDrawBackgroundColour(DIALER[32], 0);
	TextDrawFont(DIALER[32], 2);
	TextDrawSetProportional(DIALER[32], 1);

	DIALER[33] = TextDrawCreate(490.000, 282.000, "WXYZ");
	TextDrawLetterSize(DIALER[33], 0.128, 0.597);
	TextDrawAlignment(DIALER[33], 1);
	TextDrawColour(DIALER[33], 255);
	TextDrawSetShadow(DIALER[33], 1);
	TextDrawSetOutline(DIALER[33], 1);
	TextDrawBackgroundColour(DIALER[33], 0);
	TextDrawFont(DIALER[33], 2);
	TextDrawSetProportional(DIALER[33], 1);

	DIALER[34] = TextDrawCreate(459.000, 324.000, "+");
	TextDrawLetterSize(DIALER[34], 0.128, 0.597);
	TextDrawAlignment(DIALER[34], 1);
	TextDrawColour(DIALER[34], 255);
	TextDrawSetShadow(DIALER[34], 1);
	TextDrawSetOutline(DIALER[34], 1);
	TextDrawBackgroundColour(DIALER[34], 0);
	TextDrawFont(DIALER[34], 2);
	TextDrawSetProportional(DIALER[34], 1);

	DIALER[35] = TextDrawCreate(440.000, 332.000, "LD_BEAT:chit");
	TextDrawTextSize(DIALER[35], 43.000, 52.000);
	TextDrawAlignment(DIALER[35], 1);
	TextDrawColour(DIALER[35], 16711935);
	TextDrawSetShadow(DIALER[35], 0);
	TextDrawSetOutline(DIALER[35], 0);
	TextDrawBackgroundColour(DIALER[35], 255);
	TextDrawFont(DIALER[35], 4);
	TextDrawSetProportional(DIALER[35], 1);
	TextDrawSetSelectable(DIALER[35], 1);

	DIALER[36] = TextDrawCreate(458.000, 346.000, "C");
	TextDrawLetterSize(DIALER[36], 0.238, 2.799);
	TextDrawAlignment(DIALER[36], 1);
	TextDrawColour(DIALER[36], -1);
	TextDrawSetShadow(DIALER[36], 1);
	TextDrawSetOutline(DIALER[36], 1);
	TextDrawBackgroundColour(DIALER[36], 0);
	TextDrawFont(DIALER[36], 2);
	TextDrawSetProportional(DIALER[36], 1);

	DIALER[37] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(DIALER[37], 72.000, 3.000);
	TextDrawAlignment(DIALER[37], 1);
	TextDrawColour(DIALER[37], 255);
	TextDrawSetShadow(DIALER[37], 0);
	TextDrawSetOutline(DIALER[37], 0);
	TextDrawBackgroundColour(DIALER[37], 255);
	TextDrawFont(DIALER[37], 4);
	TextDrawSetProportional(DIALER[37], 1);
	TextDrawSetSelectable(DIALER[37], 1);

	CAL[0] = TextDrawCreate(401.000, 114.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[0], 0.600, 2.000);
	TextDrawTextSize(CAL[0], 122.500, 293.000);
	TextDrawAlignment(CAL[0], 1);
	TextDrawColour(CAL[0], -1094795521);
	TextDrawSetShadow(CAL[0], 0);
	TextDrawSetOutline(CAL[0], 1);
	TextDrawBackgroundColour(CAL[0], 255);
	TextDrawFont(CAL[0], 4);
	TextDrawSetProportional(CAL[0], 1);

	CAL[1] = TextDrawCreate(390.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[1], 0.600, 2.000);
	TextDrawTextSize(CAL[1], 144.500, 269.000);
	TextDrawAlignment(CAL[1], 1);
	TextDrawColour(CAL[1], -1094795521);
	TextDrawSetShadow(CAL[1], 0);
	TextDrawSetOutline(CAL[1], 1);
	TextDrawBackgroundColour(CAL[1], 255);
	TextDrawFont(CAL[1], 4);
	TextDrawSetProportional(CAL[1], 1);

	CAL[2] = TextDrawCreate(385.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[2], 0.600, 2.000);
	TextDrawTextSize(CAL[2], 33.000, 31.500);
	TextDrawAlignment(CAL[2], 1);
	TextDrawColour(CAL[2], -1094795521);
	TextDrawSetShadow(CAL[2], 0);
	TextDrawSetOutline(CAL[2], 1);
	TextDrawBackgroundColour(CAL[2], 255);
	TextDrawFont(CAL[2], 4);
	TextDrawSetProportional(CAL[2], 1);

	CAL[3] = TextDrawCreate(507.500, 109.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[3], 0.600, 2.000);
	TextDrawTextSize(CAL[3], 32.000, 33.000);
	TextDrawAlignment(CAL[3], 1);
	TextDrawColour(CAL[3], -1094795521);
	TextDrawSetShadow(CAL[3], 0);
	TextDrawSetOutline(CAL[3], 1);
	TextDrawBackgroundColour(CAL[3], 255);
	TextDrawFont(CAL[3], 4);
	TextDrawSetProportional(CAL[3], 1);

	CAL[4] = TextDrawCreate(508.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[4], 0.600, 2.000);
	TextDrawTextSize(CAL[4], 32.000, 32.000);
	TextDrawAlignment(CAL[4], 1);
	TextDrawColour(CAL[4], -1094795521);
	TextDrawSetShadow(CAL[4], 0);
	TextDrawSetOutline(CAL[4], 1);
	TextDrawBackgroundColour(CAL[4], 255);
	TextDrawFont(CAL[4], 4);
	TextDrawSetProportional(CAL[4], 1);

	CAL[5] = TextDrawCreate(385.000, 380.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[5], 0.600, 2.000);
	TextDrawTextSize(CAL[5], 32.000, 32.000);
	TextDrawAlignment(CAL[5], 1);
	TextDrawColour(CAL[5], -1094795521);
	TextDrawSetShadow(CAL[5], 0);
	TextDrawSetOutline(CAL[5], 1);
	TextDrawBackgroundColour(CAL[5], 255);
	TextDrawFont(CAL[5], 4);
	TextDrawSetProportional(CAL[5], 1);

	CAL[6] = TextDrawCreate(387.000, 110.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[6], 0.600, 2.000);
	TextDrawTextSize(CAL[6], 27.000, 31.500);
	TextDrawAlignment(CAL[6], 1);
	TextDrawColour(CAL[6], 255);
	TextDrawSetShadow(CAL[6], 0);
	TextDrawSetOutline(CAL[6], 1);
	TextDrawBackgroundColour(CAL[6], 255);
	TextDrawFont(CAL[6], 4);
	TextDrawSetProportional(CAL[6], 1);

	CAL[7] = TextDrawCreate(389.000, 113.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[7], 0.600, 2.000);
	TextDrawTextSize(CAL[7], 29.000, 29.500);
	TextDrawAlignment(CAL[7], 1);
	TextDrawColour(CAL[7], 255);
	TextDrawSetShadow(CAL[7], 0);
	TextDrawSetOutline(CAL[7], 1);
	TextDrawBackgroundColour(CAL[7], 255);
	TextDrawFont(CAL[7], 4);
	TextDrawSetProportional(CAL[7], 1);

	CAL[8] = TextDrawCreate(391.500, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[8], 0.600, 2.000);
	TextDrawTextSize(CAL[8], 141.500, 269.000);
	TextDrawAlignment(CAL[8], 1);
	TextDrawColour(CAL[8], 255);
	TextDrawSetShadow(CAL[8], 0);
	TextDrawSetOutline(CAL[8], 1);
	TextDrawBackgroundColour(CAL[8], 255);
	TextDrawFont(CAL[8], 4);
	TextDrawSetProportional(CAL[8], 1);

	CAL[9] = TextDrawCreate(463.000, 212.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[9], -2.000, -6.000);
	TextDrawAlignment(CAL[9], 1);
	TextDrawColour(CAL[9], 548580095);
	TextDrawSetShadow(CAL[9], 0);
	TextDrawSetOutline(CAL[9], 0);
	TextDrawBackgroundColour(CAL[9], 255);
	TextDrawFont(CAL[9], 4);
	TextDrawSetProportional(CAL[9], 1);

	CAL[10] = TextDrawCreate(504.000, 109.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[10], 0.600, 2.000);
	TextDrawTextSize(CAL[10], 34.700, 37.000);
	TextDrawAlignment(CAL[10], 1);
	TextDrawColour(CAL[10], 255);
	TextDrawSetShadow(CAL[10], 0);
	TextDrawSetOutline(CAL[10], 1);
	TextDrawBackgroundColour(CAL[10], 255);
	TextDrawFont(CAL[10], 4);
	TextDrawSetProportional(CAL[10], 1);

	CAL[11] = TextDrawCreate(506.000, 377.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[11], 0.600, 2.000);
	TextDrawTextSize(CAL[11], 32.500, 34.500);
	TextDrawAlignment(CAL[11], 1);
	TextDrawColour(CAL[11], 255);
	TextDrawSetShadow(CAL[11], 0);
	TextDrawSetOutline(CAL[11], 1);
	TextDrawBackgroundColour(CAL[11], 255);
	TextDrawFont(CAL[11], 4);
	TextDrawSetProportional(CAL[11], 1);

	CAL[12] = TextDrawCreate(386.299, 377.299, "ld_beat:chit");
	TextDrawLetterSize(CAL[12], 0.600, 2.000);
	TextDrawTextSize(CAL[12], 33.000, 34.000);
	TextDrawAlignment(CAL[12], 1);
	TextDrawColour(CAL[12], 255);
	TextDrawSetShadow(CAL[12], 0);
	TextDrawSetOutline(CAL[12], 1);
	TextDrawBackgroundColour(CAL[12], 255);
	TextDrawFont(CAL[12], 4);
	TextDrawSetProportional(CAL[12], 1);

	CAL[13] = TextDrawCreate(395.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[13], 0.600, 2.000);
	TextDrawTextSize(CAL[13], 62.000, 263.000);
	TextDrawAlignment(CAL[13], 1);
	TextDrawColour(CAL[13], 255);
	TextDrawSetShadow(CAL[13], 0);
	TextDrawSetOutline(CAL[13], 1);
	TextDrawBackgroundColour(CAL[13], 255);
	TextDrawFont(CAL[13], 4);
	TextDrawSetProportional(CAL[13], 1);

	CAL[14] = TextDrawCreate(402.000, 115.097, "LD_SPAC:black");
	TextDrawTextSize(CAL[14], 118.000, 15.000);
	TextDrawAlignment(CAL[14], 1);
	TextDrawColour(CAL[14], -1);
	TextDrawSetShadow(CAL[14], 0);
	TextDrawSetOutline(CAL[14], 0);
	TextDrawBackgroundColour(CAL[14], 255);
	TextDrawFont(CAL[14], 4);
	TextDrawSetProportional(CAL[14], 1);

	CAL[15] = TextDrawCreate(404.000, 395.100, "LD_SPAC:black");
	TextDrawTextSize(CAL[15], 118.000, 10.500);
	TextDrawAlignment(CAL[15], 1);
	TextDrawColour(CAL[15], -1);
	TextDrawSetShadow(CAL[15], 0);
	TextDrawSetOutline(CAL[15], 0);
	TextDrawBackgroundColour(CAL[15], 255);
	TextDrawFont(CAL[15], 4);
	TextDrawSetProportional(CAL[15], 1);

	CAL[16] = TextDrawCreate(457.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[16], 0.600, 2.000);
	TextDrawTextSize(CAL[16], 75.500, 264.000);
	TextDrawAlignment(CAL[16], 1);
	TextDrawColour(CAL[16], 255);
	TextDrawSetShadow(CAL[16], 0);
	TextDrawSetOutline(CAL[16], 1);
	TextDrawBackgroundColour(CAL[16], 255);
	TextDrawFont(CAL[16], 4);
	TextDrawSetProportional(CAL[16], 1);

	CAL[17] = TextDrawCreate(400.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[17], 0.600, 2.000);
	TextDrawTextSize(CAL[17], 61.000, 280.000);
	TextDrawAlignment(CAL[17], 1);
	TextDrawColour(CAL[17], 255);
	TextDrawSetShadow(CAL[17], 0);
	TextDrawSetOutline(CAL[17], 1);
	TextDrawBackgroundColour(CAL[17], 255);
	TextDrawFont(CAL[17], 4);
	TextDrawSetProportional(CAL[17], 1);

	CAL[18] = TextDrawCreate(389.000, 375.000, "ld_beat:chit");
	TextDrawLetterSize(CAL[18], 0.600, 2.000);
	TextDrawTextSize(CAL[18], 31.000, 31.500);
	TextDrawAlignment(CAL[18], 1);
	TextDrawColour(CAL[18], 0);
	TextDrawSetShadow(CAL[18], 0);
	TextDrawSetOutline(CAL[18], 1);
	TextDrawBackgroundColour(CAL[18], 255);
	TextDrawFont(CAL[18], 4);
	TextDrawSetProportional(CAL[18], 1);

	CAL[19] = TextDrawCreate(391.500, 378.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[19], 23.000, 26.500);
	TextDrawAlignment(CAL[19], 1);
	TextDrawColour(CAL[19], 255);
	TextDrawSetShadow(CAL[19], 0);
	TextDrawSetOutline(CAL[19], 0);
	TextDrawBackgroundColour(CAL[19], 255);
	TextDrawFont(CAL[19], 4);
	TextDrawSetProportional(CAL[19], 1);

	CAL[20] = TextDrawCreate(467.000, 127.000, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[20], 0.600, 2.000);
	TextDrawTextSize(CAL[20], 62.000, 263.000);
	TextDrawAlignment(CAL[20], 1);
	TextDrawColour(CAL[20], 255);
	TextDrawSetShadow(CAL[20], 0);
	TextDrawSetOutline(CAL[20], 1);
	TextDrawBackgroundColour(CAL[20], 255);
	TextDrawFont(CAL[20], 4);
	TextDrawSetProportional(CAL[20], 1);

	CAL[21] = TextDrawCreate(460.000, 120.500, "ld_bum:blkdot");
	TextDrawLetterSize(CAL[21], 0.600, 2.000);
	TextDrawTextSize(CAL[21], 63.000, 280.000);
	TextDrawAlignment(CAL[21], 1);
	TextDrawColour(CAL[21], 255);
	TextDrawSetShadow(CAL[21], 0);
	TextDrawSetOutline(CAL[21], 1);
	TextDrawBackgroundColour(CAL[21], 255);
	TextDrawFont(CAL[21], 4);
	TextDrawSetProportional(CAL[21], 1);

	CAL[22] = TextDrawCreate(509.500, 377.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[22], 24.000, 28.500);
	TextDrawAlignment(CAL[22], 1);
	TextDrawColour(CAL[22], 255);
	TextDrawSetShadow(CAL[22], 0);
	TextDrawSetOutline(CAL[22], 0);
	TextDrawBackgroundColour(CAL[22], 255);
	TextDrawFont(CAL[22], 4);
	TextDrawSetProportional(CAL[22], 1);

	CAL[23] = TextDrawCreate(392.000, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[23], 20.000, 24.000);
	TextDrawAlignment(CAL[23], 1);
	TextDrawColour(CAL[23], 255);
	TextDrawSetShadow(CAL[23], 0);
	TextDrawSetOutline(CAL[23], 0);
	TextDrawBackgroundColour(CAL[23], 255);
	TextDrawFont(CAL[23], 4);
	TextDrawSetProportional(CAL[23], 1);

	CAL[24] = TextDrawCreate(509.500, 116.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[24], 24.000, 24.500);
	TextDrawAlignment(CAL[24], 1);
	TextDrawColour(CAL[24], 255);
	TextDrawSetShadow(CAL[24], 0);
	TextDrawSetOutline(CAL[24], 0);
	TextDrawBackgroundColour(CAL[24], 255);
	TextDrawFont(CAL[24], 4);
	TextDrawSetProportional(CAL[24], 1);

	CAL[25] = TextDrawCreate(400.000, 124.000, "AKRP");
	TextDrawLetterSize(CAL[25], 0.200, 0.898);
	TextDrawAlignment(CAL[25], 1);
	TextDrawColour(CAL[25], -1);
	TextDrawSetShadow(CAL[25], 1);
	TextDrawSetOutline(CAL[25], 1);
	TextDrawBackgroundColour(CAL[25], 0);
	TextDrawFont(CAL[25], 2);
	TextDrawSetProportional(CAL[25], 1);

	CAL[26] = TextDrawCreate(429.000, 135.000, "LD_SPAC:black");
	TextDrawTextSize(CAL[26], 66.000, -11.000);
	TextDrawAlignment(CAL[26], 1);
	TextDrawColour(CAL[26], -1);
	TextDrawSetShadow(CAL[26], 0);
	TextDrawSetOutline(CAL[26], 0);
	TextDrawBackgroundColour(CAL[26], 255);
	TextDrawFont(CAL[26], 4);
	TextDrawSetProportional(CAL[26], 1);

	CAL[27] = TextDrawCreate(423.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[27], 16.000, 17.000);
	TextDrawAlignment(CAL[27], 1);
	TextDrawColour(CAL[27], 255);
	TextDrawSetShadow(CAL[27], 0);
	TextDrawSetOutline(CAL[27], 0);
	TextDrawBackgroundColour(CAL[27], 255);
	TextDrawFont(CAL[27], 4);
	TextDrawSetProportional(CAL[27], 1);

	CAL[28] = TextDrawCreate(485.000, 121.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[28], 16.000, 17.000);
	TextDrawAlignment(CAL[28], 1);
	TextDrawColour(CAL[28], 255);
	TextDrawSetShadow(CAL[28], 0);
	TextDrawSetOutline(CAL[28], 0);
	TextDrawBackgroundColour(CAL[28], 255);
	TextDrawFont(CAL[28], 4);
	TextDrawSetProportional(CAL[28], 1);

	CAL[29] = TextDrawCreate(508.000, 122.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[29], 2.000, 12.000);
	TextDrawAlignment(CAL[29], 1);
	TextDrawColour(CAL[29], -1);
	TextDrawSetShadow(CAL[29], 0);
	TextDrawSetOutline(CAL[29], 0);
	TextDrawBackgroundColour(CAL[29], 255);
	TextDrawFont(CAL[29], 4);
	TextDrawSetProportional(CAL[29], 1);

	CAL[30] = TextDrawCreate(505.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[30], 2.000, -8.000);
	TextDrawAlignment(CAL[30], 1);
	TextDrawColour(CAL[30], -1);
	TextDrawSetShadow(CAL[30], 0);
	TextDrawSetOutline(CAL[30], 0);
	TextDrawBackgroundColour(CAL[30], 255);
	TextDrawFont(CAL[30], 4);
	TextDrawSetProportional(CAL[30], 1);

	CAL[31] = TextDrawCreate(502.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[31], 2.000, -5.000);
	TextDrawAlignment(CAL[31], 1);
	TextDrawColour(CAL[31], -1);
	TextDrawSetShadow(CAL[31], 0);
	TextDrawSetOutline(CAL[31], 0);
	TextDrawBackgroundColour(CAL[31], 255);
	TextDrawFont(CAL[31], 4);
	TextDrawSetProportional(CAL[31], 1);

	CAL[32] = TextDrawCreate(499.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[32], 2.000, -2.000);
	TextDrawAlignment(CAL[32], 1);
	TextDrawColour(CAL[32], -1);
	TextDrawSetShadow(CAL[32], 0);
	TextDrawSetOutline(CAL[32], 0);
	TextDrawBackgroundColour(CAL[32], 255);
	TextDrawFont(CAL[32], 4);
	TextDrawSetProportional(CAL[32], 1);

	CAL[33] = TextDrawCreate(514.000, 134.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[33], 10.000, -8.000);
	TextDrawAlignment(CAL[33], 1);
	TextDrawColour(CAL[33], -1);
	TextDrawSetShadow(CAL[33], 0);
	TextDrawSetOutline(CAL[33], 0);
	TextDrawBackgroundColour(CAL[33], 255);
	TextDrawFont(CAL[33], 4);
	TextDrawSetProportional(CAL[33], 1);

	CAL[34] = TextDrawCreate(523.000, 132.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[34], 3.000, -4.000);
	TextDrawAlignment(CAL[34], 1);
	TextDrawColour(CAL[34], -1);
	TextDrawSetShadow(CAL[34], 0);
	TextDrawSetOutline(CAL[34], 0);
	TextDrawBackgroundColour(CAL[34], 255);
	TextDrawFont(CAL[34], 4);
	TextDrawSetProportional(CAL[34], 1);

	CAL[35] = TextDrawCreate(426.000, 392.000, "LD_SPAC:white");
	TextDrawTextSize(CAL[35], 72.000, 3.000);
	TextDrawAlignment(CAL[35], 1);
	TextDrawColour(CAL[35], -1);
	TextDrawSetShadow(CAL[35], 0);
	TextDrawSetOutline(CAL[35], 0);
	TextDrawBackgroundColour(CAL[35], 255);
	TextDrawFont(CAL[35], 4);
	TextDrawSetProportional(CAL[35], 1);
	TextDrawSetSelectable(CAL[35], 1);

	CAL[36] = TextDrawCreate(426.000, 199.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[36], 41.000, 45.000);
	TextDrawAlignment(CAL[36], 1);
	TextDrawColour(CAL[36], -1448498689);
	TextDrawSetShadow(CAL[36], 0);
	TextDrawSetOutline(CAL[36], 0);
	TextDrawBackgroundColour(CAL[36], 255);
	TextDrawFont(CAL[36], 4);
	TextDrawSetProportional(CAL[36], 1);
	TextDrawSetSelectable(CAL[36], 1);

	CAL[37] = TextDrawCreate(457.000, 199.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[37], 41.000, 45.000);
	TextDrawAlignment(CAL[37], 1);
	TextDrawColour(CAL[37], -1448498689);
	TextDrawSetShadow(CAL[37], 0);
	TextDrawSetOutline(CAL[37], 0);
	TextDrawBackgroundColour(CAL[37], 255);
	TextDrawFont(CAL[37], 4);
	TextDrawSetProportional(CAL[37], 1);
	TextDrawSetSelectable(CAL[37], 1);

	CAL[38] = TextDrawCreate(488.000, 199.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[38], 41.000, 45.000);
	TextDrawAlignment(CAL[38], 1);
	TextDrawColour(CAL[38], -479723265);
	TextDrawSetShadow(CAL[38], 0);
	TextDrawSetOutline(CAL[38], 0);
	TextDrawBackgroundColour(CAL[38], 255);
	TextDrawFont(CAL[38], 4);
	TextDrawSetProportional(CAL[38], 1);
	TextDrawSetSelectable(CAL[38], 1);

	CAL[39] = TextDrawCreate(395.000, 234.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[39], 41.000, 45.000);
	TextDrawAlignment(CAL[39], 1);
	TextDrawColour(CAL[39], 1195853817);
	TextDrawSetShadow(CAL[39], 0);
	TextDrawSetOutline(CAL[39], 0);
	TextDrawBackgroundColour(CAL[39], 255);
	TextDrawFont(CAL[39], 4);
	TextDrawSetProportional(CAL[39], 1);
	TextDrawSetSelectable(CAL[39], 1);

	CAL[40] = TextDrawCreate(426.000, 234.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[40], 41.000, 45.000);
	TextDrawAlignment(CAL[40], 1);
	TextDrawColour(CAL[40], 1195853823);
	TextDrawSetShadow(CAL[40], 0);
	TextDrawSetOutline(CAL[40], 0);
	TextDrawBackgroundColour(CAL[40], 255);
	TextDrawFont(CAL[40], 4);
	TextDrawSetProportional(CAL[40], 1);
	TextDrawSetSelectable(CAL[40], 1);

	CAL[41] = TextDrawCreate(457.000, 234.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[41], 41.000, 45.000);
	TextDrawAlignment(CAL[41], 1);
	TextDrawColour(CAL[41], 1195853823);
	TextDrawSetShadow(CAL[41], 0);
	TextDrawSetOutline(CAL[41], 0);
	TextDrawBackgroundColour(CAL[41], 255);
	TextDrawFont(CAL[41], 4);
	TextDrawSetProportional(CAL[41], 1);
	TextDrawSetSelectable(CAL[41], 1);

	CAL[42] = TextDrawCreate(488.000, 234.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[42], 41.000, 45.000);
	TextDrawAlignment(CAL[42], 1);
	TextDrawColour(CAL[42], -479723265);
	TextDrawSetShadow(CAL[42], 0);
	TextDrawSetOutline(CAL[42], 0);
	TextDrawBackgroundColour(CAL[42], 255);
	TextDrawFont(CAL[42], 4);
	TextDrawSetProportional(CAL[42], 1);
	TextDrawSetSelectable(CAL[42], 1);

	CAL[43] = TextDrawCreate(395.000, 269.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[43], 41.000, 45.000);
	TextDrawAlignment(CAL[43], 1);
	TextDrawColour(CAL[43], 1195853823);
	TextDrawSetShadow(CAL[43], 0);
	TextDrawSetOutline(CAL[43], 0);
	TextDrawBackgroundColour(CAL[43], 255);
	TextDrawFont(CAL[43], 4);
	TextDrawSetProportional(CAL[43], 1);
	TextDrawSetSelectable(CAL[43], 1);

	CAL[44] = TextDrawCreate(426.000, 269.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[44], 41.000, 45.000);
	TextDrawAlignment(CAL[44], 1);
	TextDrawColour(CAL[44], 1195853823);
	TextDrawSetShadow(CAL[44], 0);
	TextDrawSetOutline(CAL[44], 0);
	TextDrawBackgroundColour(CAL[44], 255);
	TextDrawFont(CAL[44], 4);
	TextDrawSetProportional(CAL[44], 1);
	TextDrawSetSelectable(CAL[44], 1);

	CAL[45] = TextDrawCreate(457.000, 269.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[45], 41.000, 45.000);
	TextDrawAlignment(CAL[45], 1);
	TextDrawColour(CAL[45], 1195853823);
	TextDrawSetShadow(CAL[45], 0);
	TextDrawSetOutline(CAL[45], 0);
	TextDrawBackgroundColour(CAL[45], 255);
	TextDrawFont(CAL[45], 4);
	TextDrawSetProportional(CAL[45], 1);
	TextDrawSetSelectable(CAL[45], 1);

	CAL[46] = TextDrawCreate(488.000, 269.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[46], 41.000, 45.000);
	TextDrawAlignment(CAL[46], 1);
	TextDrawColour(CAL[46], -479723265);
	TextDrawSetShadow(CAL[46], 0);
	TextDrawSetOutline(CAL[46], 0);
	TextDrawBackgroundColour(CAL[46], 255);
	TextDrawFont(CAL[46], 4);
	TextDrawSetProportional(CAL[46], 1);
	TextDrawSetSelectable(CAL[46], 1);

	CAL[47] = TextDrawCreate(395.000, 303.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[47], 41.000, 45.000);
	TextDrawAlignment(CAL[47], 1);
	TextDrawColour(CAL[47], 1195853823);
	TextDrawSetShadow(CAL[47], 0);
	TextDrawSetOutline(CAL[47], 0);
	TextDrawBackgroundColour(CAL[47], 255);
	TextDrawFont(CAL[47], 4);
	TextDrawSetProportional(CAL[47], 1);
	TextDrawSetSelectable(CAL[47], 1);

	CAL[48] = TextDrawCreate(426.000, 303.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[48], 41.000, 45.000);
	TextDrawAlignment(CAL[48], 1);
	TextDrawColour(CAL[48], 1195853823);
	TextDrawSetShadow(CAL[48], 0);
	TextDrawSetOutline(CAL[48], 0);
	TextDrawBackgroundColour(CAL[48], 255);
	TextDrawFont(CAL[48], 4);
	TextDrawSetProportional(CAL[48], 1);
	TextDrawSetSelectable(CAL[48], 1);

	CAL[49] = TextDrawCreate(457.000, 303.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[49], 41.000, 45.000);
	TextDrawAlignment(CAL[49], 1);
	TextDrawColour(CAL[49], 1195853823);
	TextDrawSetShadow(CAL[49], 0);
	TextDrawSetOutline(CAL[49], 0);
	TextDrawBackgroundColour(CAL[49], 255);
	TextDrawFont(CAL[49], 4);
	TextDrawSetProportional(CAL[49], 1);
	TextDrawSetSelectable(CAL[49], 1);

	CAL[50] = TextDrawCreate(488.000, 303.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[50], 41.000, 45.000);
	TextDrawAlignment(CAL[50], 1);
	TextDrawColour(CAL[50], -479723265);
	TextDrawSetShadow(CAL[50], 0);
	TextDrawSetOutline(CAL[50], 0);
	TextDrawBackgroundColour(CAL[50], 255);
	TextDrawFont(CAL[50], 4);
	TextDrawSetProportional(CAL[50], 1);
	TextDrawSetSelectable(CAL[50], 1);

	CAL[51] = TextDrawCreate(457.000, 338.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[51], 41.000, 45.000);
	TextDrawAlignment(CAL[51], 1);
	TextDrawColour(CAL[51], 1195853823);
	TextDrawSetShadow(CAL[51], 0);
	TextDrawSetOutline(CAL[51], 0);
	TextDrawBackgroundColour(CAL[51], 255);
	TextDrawFont(CAL[51], 4);
	TextDrawSetProportional(CAL[51], 1);
	TextDrawSetSelectable(CAL[51], 1);

	CAL[52] = TextDrawCreate(488.000, 338.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[52], 41.000, 45.000);
	TextDrawAlignment(CAL[52], 1);
	TextDrawColour(CAL[52], -479723265);
	TextDrawSetShadow(CAL[52], 0);
	TextDrawSetOutline(CAL[52], 0);
	TextDrawBackgroundColour(CAL[52], 255);
	TextDrawFont(CAL[52], 4);
	TextDrawSetProportional(CAL[52], 1);
	TextDrawSetSelectable(CAL[52], 1);

	CAL[53] = TextDrawCreate(426.000, 338.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[53], 41.000, 45.000);
	TextDrawAlignment(CAL[53], 1);
	TextDrawColour(CAL[53], 1195853823);
	TextDrawSetShadow(CAL[53], 0);
	TextDrawSetOutline(CAL[53], 0);
	TextDrawBackgroundColour(CAL[53], 255);
	TextDrawFont(CAL[53], 4);
	TextDrawSetProportional(CAL[53], 1);

	CAL[54] = TextDrawCreate(396.000, 338.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[54], 41.000, 45.000);
	TextDrawAlignment(CAL[54], 1);
	TextDrawColour(CAL[54], 1195853823);
	TextDrawSetShadow(CAL[54], 0);
	TextDrawSetOutline(CAL[54], 0);
	TextDrawBackgroundColour(CAL[54], 255);
	TextDrawFont(CAL[54], 4);
	TextDrawSetProportional(CAL[54], 1);

	CAL[55] = TextDrawCreate(415.000, 345.500, "LD_SPAC:white");
	TextDrawTextSize(CAL[55], 31.000, 30.000);
	TextDrawAlignment(CAL[55], 1);
	TextDrawColour(CAL[55], 1195853823);
	TextDrawSetShadow(CAL[55], 0);
	TextDrawSetOutline(CAL[55], 0);
	TextDrawBackgroundColour(CAL[55], 255);
	TextDrawFont(CAL[55], 4);
	TextDrawSetProportional(CAL[55], 1);
	TextDrawSetSelectable(CAL[55], 1);

	CAL[56] = TextDrawCreate(409.000, 213.000, "AC");
	TextDrawLetterSize(CAL[56], 0.300, 1.500);
	TextDrawAlignment(CAL[56], 1);
	TextDrawColour(CAL[56], 255);
	TextDrawSetShadow(CAL[56], 1);
	TextDrawSetOutline(CAL[56], 1);
	TextDrawBackgroundColour(CAL[56], 0);
	TextDrawFont(CAL[56], 1);
	TextDrawSetProportional(CAL[56], 1);

	CAL[57] = TextDrawCreate(440.000, 210.000, "+");
	TextDrawLetterSize(CAL[57], 0.300, 1.500);
	TextDrawAlignment(CAL[57], 1);
	TextDrawColour(CAL[57], 255);
	TextDrawSetShadow(CAL[57], 1);
	TextDrawSetOutline(CAL[57], 1);
	TextDrawBackgroundColour(CAL[57], 0);
	TextDrawFont(CAL[57], 1);
	TextDrawSetProportional(CAL[57], 1);

	CAL[58] = TextDrawCreate(446.000, 214.000, "/-");
	TextDrawLetterSize(CAL[58], 0.300, 1.500);
	TextDrawAlignment(CAL[58], 1);
	TextDrawColour(CAL[58], 255);
	TextDrawSetShadow(CAL[58], 1);
	TextDrawSetOutline(CAL[58], 1);
	TextDrawBackgroundColour(CAL[58], 0);
	TextDrawFont(CAL[58], 1);
	TextDrawSetProportional(CAL[58], 1);

	CAL[59] = TextDrawCreate(469.000, 210.000, "o");
	TextDrawLetterSize(CAL[59], 0.300, 1.500);
	TextDrawAlignment(CAL[59], 1);
	TextDrawColour(CAL[59], 255);
	TextDrawSetShadow(CAL[59], 1);
	TextDrawSetOutline(CAL[59], 1);
	TextDrawBackgroundColour(CAL[59], 0);
	TextDrawFont(CAL[59], 1);
	TextDrawSetProportional(CAL[59], 1);

	CAL[60] = TextDrawCreate(476.000, 214.000, "/o");
	TextDrawLetterSize(CAL[60], 0.300, 1.500);
	TextDrawAlignment(CAL[60], 1);
	TextDrawColour(CAL[60], 255);
	TextDrawSetShadow(CAL[60], 1);
	TextDrawSetOutline(CAL[60], 1);
	TextDrawBackgroundColour(CAL[60], 0);
	TextDrawFont(CAL[60], 1);
	TextDrawSetProportional(CAL[60], 1);

	CAL[61] = TextDrawCreate(503.000, 213.000, "-");
	TextDrawLetterSize(CAL[61], 0.958, 1.500);
	TextDrawAlignment(CAL[61], 1);
	TextDrawColour(CAL[61], -1);
	TextDrawSetShadow(CAL[61], 1);
	TextDrawSetOutline(CAL[61], 1);
	TextDrawBackgroundColour(CAL[61], 0);
	TextDrawFont(CAL[61], 1);
	TextDrawSetProportional(CAL[61], 1);

	CAL[62] = TextDrawCreate(507.000, 218.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[62], 2.000, 2.000);
	TextDrawAlignment(CAL[62], 1);
	TextDrawColour(CAL[62], -1);
	TextDrawSetShadow(CAL[62], 0);
	TextDrawSetOutline(CAL[62], 0);
	TextDrawBackgroundColour(CAL[62], 255);
	TextDrawFont(CAL[62], 4);
	TextDrawSetProportional(CAL[62], 1);

	CAL[63] = TextDrawCreate(507.000, 225.000, "LD_BEAT:chit");
	TextDrawTextSize(CAL[63], 2.000, 2.000);
	TextDrawAlignment(CAL[63], 1);
	TextDrawColour(CAL[63], -1);
	TextDrawSetShadow(CAL[63], 0);
	TextDrawSetOutline(CAL[63], 0);
	TextDrawBackgroundColour(CAL[63], 255);
	TextDrawFont(CAL[63], 4);
	TextDrawSetProportional(CAL[63], 1);

	CAL[64] = TextDrawCreate(505.000, 245.000, "x");
	TextDrawLetterSize(CAL[64], 0.488, 1.799);
	TextDrawAlignment(CAL[64], 1);
	TextDrawColour(CAL[64], -1);
	TextDrawSetShadow(CAL[64], 1);
	TextDrawSetOutline(CAL[64], 1);
	TextDrawBackgroundColour(CAL[64], 0);
	TextDrawFont(CAL[64], 1);
	TextDrawSetProportional(CAL[64], 1);

	CAL[65] = TextDrawCreate(505.000, 281.000, "-");
	TextDrawLetterSize(CAL[65], 0.728, 1.799);
	TextDrawAlignment(CAL[65], 1);
	TextDrawColour(CAL[65], -1);
	TextDrawSetShadow(CAL[65], 1);
	TextDrawSetOutline(CAL[65], 1);
	TextDrawBackgroundColour(CAL[65], 0);
	TextDrawFont(CAL[65], 1);
	TextDrawSetProportional(CAL[65], 1);

	CAL[66] = TextDrawCreate(505.000, 315.000, "+");
	TextDrawLetterSize(CAL[66], 0.518, 1.799);
	TextDrawAlignment(CAL[66], 1);
	TextDrawColour(CAL[66], -1);
	TextDrawSetShadow(CAL[66], 1);
	TextDrawSetOutline(CAL[66], 1);
	TextDrawBackgroundColour(CAL[66], 0);
	TextDrawFont(CAL[66], 1);
	TextDrawSetProportional(CAL[66], 1);

	CAL[67] = TextDrawCreate(505.000, 347.000, "=");
	TextDrawLetterSize(CAL[67], 0.549, 2.198);
	TextDrawAlignment(CAL[67], 1);
	TextDrawColour(CAL[67], -1);
	TextDrawSetShadow(CAL[67], 1);
	TextDrawSetOutline(CAL[67], 1);
	TextDrawBackgroundColour(CAL[67], 0);
	TextDrawFont(CAL[67], 1);
	TextDrawSetProportional(CAL[67], 1);

	CAL[68] = TextDrawCreate(476.000, 347.000, ".");
	TextDrawLetterSize(CAL[68], 0.549, 2.198);
	TextDrawAlignment(CAL[68], 1);
	TextDrawColour(CAL[68], -1);
	TextDrawSetShadow(CAL[68], 1);
	TextDrawSetOutline(CAL[68], 1);
	TextDrawBackgroundColour(CAL[68], 0);
	TextDrawFont(CAL[68], 1);
	TextDrawSetProportional(CAL[68], 1);

	CAL[69] = TextDrawCreate(412.000, 349.000, "0");
	TextDrawLetterSize(CAL[69], 0.549, 2.198);
	TextDrawAlignment(CAL[69], 1);
	TextDrawColour(CAL[69], -1);
	TextDrawSetShadow(CAL[69], 1);
	TextDrawSetOutline(CAL[69], 1);
	TextDrawBackgroundColour(CAL[69], 0);
	TextDrawFont(CAL[69], 1);
	TextDrawSetProportional(CAL[69], 1);

	CAL[70] = TextDrawCreate(412.000, 314.000, "1");
	TextDrawLetterSize(CAL[70], 0.549, 2.198);
	TextDrawAlignment(CAL[70], 1);
	TextDrawColour(CAL[70], -1);
	TextDrawSetShadow(CAL[70], 1);
	TextDrawSetOutline(CAL[70], 1);
	TextDrawBackgroundColour(CAL[70], 0);
	TextDrawFont(CAL[70], 1);
	TextDrawSetProportional(CAL[70], 1);

	CAL[71] = TextDrawCreate(442.000, 314.000, "2");
	TextDrawLetterSize(CAL[71], 0.549, 2.198);
	TextDrawAlignment(CAL[71], 1);
	TextDrawColour(CAL[71], -1);
	TextDrawSetShadow(CAL[71], 1);
	TextDrawSetOutline(CAL[71], 1);
	TextDrawBackgroundColour(CAL[71], 0);
	TextDrawFont(CAL[71], 1);
	TextDrawSetProportional(CAL[71], 1);

	CAL[72] = TextDrawCreate(473.000, 314.000, "3");
	TextDrawLetterSize(CAL[72], 0.549, 2.198);
	TextDrawAlignment(CAL[72], 1);
	TextDrawColour(CAL[72], -1);
	TextDrawSetShadow(CAL[72], 1);
	TextDrawSetOutline(CAL[72], 1);
	TextDrawBackgroundColour(CAL[72], 0);
	TextDrawFont(CAL[72], 1);
	TextDrawSetProportional(CAL[72], 1);

	CAL[73] = TextDrawCreate(410.000, 279.000, "4");
	TextDrawLetterSize(CAL[73], 0.549, 2.198);
	TextDrawAlignment(CAL[73], 1);
	TextDrawColour(CAL[73], -1);
	TextDrawSetShadow(CAL[73], 1);
	TextDrawSetOutline(CAL[73], 1);
	TextDrawBackgroundColour(CAL[73], 0);
	TextDrawFont(CAL[73], 1);
	TextDrawSetProportional(CAL[73], 1);

	CAL[74] = TextDrawCreate(442.000, 279.000, "5");
	TextDrawLetterSize(CAL[74], 0.549, 2.198);
	TextDrawAlignment(CAL[74], 1);
	TextDrawColour(CAL[74], -1);
	TextDrawSetShadow(CAL[74], 1);
	TextDrawSetOutline(CAL[74], 1);
	TextDrawBackgroundColour(CAL[74], 0);
	TextDrawFont(CAL[74], 1);
	TextDrawSetProportional(CAL[74], 1);

	CAL[75] = TextDrawCreate(473.000, 279.000, "6");
	TextDrawLetterSize(CAL[75], 0.549, 2.198);
	TextDrawAlignment(CAL[75], 1);
	TextDrawColour(CAL[75], -1);
	TextDrawSetShadow(CAL[75], 1);
	TextDrawSetOutline(CAL[75], 1);
	TextDrawBackgroundColour(CAL[75], 0);
	TextDrawFont(CAL[75], 1);
	TextDrawSetProportional(CAL[75], 1);

	CAL[76] = TextDrawCreate(411.000, 245.000, "7");
	TextDrawLetterSize(CAL[76], 0.549, 2.198);
	TextDrawAlignment(CAL[76], 1);
	TextDrawColour(CAL[76], -1);
	TextDrawSetShadow(CAL[76], 1);
	TextDrawSetOutline(CAL[76], 1);
	TextDrawBackgroundColour(CAL[76], 0);
	TextDrawFont(CAL[76], 1);
	TextDrawSetProportional(CAL[76], 1);

	CAL[77] = TextDrawCreate(442.000, 245.000, "8");
	TextDrawLetterSize(CAL[77], 0.549, 2.198);
	TextDrawAlignment(CAL[77], 1);
	TextDrawColour(CAL[77], -1);
	TextDrawSetShadow(CAL[77], 1);
	TextDrawSetOutline(CAL[77], 1);
	TextDrawBackgroundColour(CAL[77], 0);
	TextDrawFont(CAL[77], 1);
	TextDrawSetProportional(CAL[77], 1);

	CAL[78] = TextDrawCreate(473.000, 245.000, "9");
	TextDrawLetterSize(CAL[78], 0.549, 2.198);
	TextDrawAlignment(CAL[78], 1);
	TextDrawColour(CAL[78], -1);
	TextDrawSetShadow(CAL[78], 1);
	TextDrawSetOutline(CAL[78], 1);
	TextDrawBackgroundColour(CAL[78], 0);
	TextDrawFont(CAL[78], 1);
	TextDrawSetProportional(CAL[78], 1);
	


	ANN[0] = TextDrawCreate(321.000000, 139.000000, "_");
	TextDrawFont(ANN[0], 1);
	TextDrawLetterSize(ANN[0], 0.600000, 8.949996);
	TextDrawTextSize(ANN[0], 298.500000, 748.500000);
	TextDrawSetOutline(ANN[0], 1);
	TextDrawSetShadow(ANN[0], 0);
	TextDrawAlignment(ANN[0], 2);
	TextDrawColour(ANN[0], -1);
	TextDrawBackgroundColour(ANN[0], 255);
	TextDrawBoxColour(ANN[0], 180);
	TextDrawUseBox(ANN[0], 1);
	TextDrawSetProportional(ANN[0], 1);
	TextDrawSetSelectable(ANN[0], 0);

	ANN[1] = TextDrawCreate(319.000000, 146.000000, "Announcement");
	TextDrawFont(ANN[1], 3);
	TextDrawLetterSize(ANN[1], 0.737499, 4.099997);
	TextDrawTextSize(ANN[1], 400.000000, 17.000000);
	TextDrawSetOutline(ANN[1], 0);
	TextDrawSetShadow(ANN[1], 0);
	TextDrawAlignment(ANN[1], 2);
	TextDrawColour(ANN[1], -2686721);
	TextDrawBackgroundColour(ANN[1], 255);
	TextDrawBoxColour(ANN[1], 50);
	TextDrawUseBox(ANN[1], 0);
	TextDrawSetProportional(ANN[1], 1);
	TextDrawSetSelectable(ANN[1], 0);

	ANN[2] = TextDrawCreate(319.000000, 187.000000, ""); // text
	TextDrawFont(ANN[2], 1);
	TextDrawLetterSize(ANN[2], 0.233332, 2.000000);
	TextDrawTextSize(ANN[2], 400.000000, 505.000000);
	TextDrawSetOutline(ANN[2], 0);
	TextDrawSetShadow(ANN[2], 0);
	TextDrawAlignment(ANN[2], 2);
	TextDrawColour(ANN[2], -1);
	TextDrawBackgroundColour(ANN[2], 255);
	TextDrawBoxColour(ANN[2], 50);
	TextDrawUseBox(ANN[2], 0);
	TextDrawSetProportional(ANN[2], 1);
	TextDrawSetSelectable(ANN[2], 0);

	TwtTD[0] = TextDrawCreate(499.500000, 186.000000, "_");
	TextDrawFont(TwtTD[0], 1);
	TextDrawLetterSize(TwtTD[0], 0.600000, 2.000000);
	TextDrawTextSize(TwtTD[0], 298.500000, 77.500000);
	TextDrawSetOutline(TwtTD[0], 1);
	TextDrawSetShadow(TwtTD[0], 0);
	TextDrawAlignment(TwtTD[0], 2);
	TextDrawColour(TwtTD[0], -1);
	TextDrawBackgroundColour(TwtTD[0], 255);
	TextDrawBoxColour(TwtTD[0], 135);
	TextDrawUseBox(TwtTD[0], 1);
	TextDrawSetProportional(TwtTD[0], 1);
	TextDrawSetSelectable(TwtTD[0], 0);

	TwtTD[1] = TextDrawCreate(462.000000, 186.000000, "Twitter");
	TextDrawFont(TwtTD[1], 1);
	TextDrawLetterSize(TwtTD[1], 0.205917, 1.306663);
	TextDrawTextSize(TwtTD[1], 400.000000, 17.000000);
	TextDrawSetOutline(TwtTD[1], 0);
	TextDrawSetShadow(TwtTD[1], 1);
	TextDrawAlignment(TwtTD[1], 1);
	TextDrawColour(TwtTD[1], 16777215);
	TextDrawBackgroundColour(TwtTD[1], 255);
	TextDrawBoxColour(TwtTD[1], 50);
	TextDrawUseBox(TwtTD[1], 0);
	TextDrawSetProportional(TwtTD[1], 1);
	TextDrawSetSelectable(TwtTD[1], 0);

	TwtTD[2] = TextDrawCreate(461.000000, 197.000000, "Jhon Pres");
	TextDrawFont(TwtTD[2], 1);
	TextDrawLetterSize(TwtTD[2], 0.222584, 1.356663);
	TextDrawTextSize(TwtTD[2], 537.000000, -214.500000);
	TextDrawSetOutline(TwtTD[2], 0);
	TextDrawSetShadow(TwtTD[2], 1);
	TextDrawAlignment(TwtTD[2], 1);
	TextDrawColour(TwtTD[2], -2686721);
	TextDrawBackgroundColour(TwtTD[2], 255);
	TextDrawBoxColour(TwtTD[2], 50);
	TextDrawUseBox(TwtTD[2], 0);
	TextDrawSetProportional(TwtTD[2], 1);
	TextDrawSetSelectable(TwtTD[2], 0);

	TwtTD[3] = TextDrawCreate(461.000000, 208.500000, "WASSUP!!! TEST 123 HAHAHA TEST");
	TextDrawFont(TwtTD[3], 1);
	TextDrawLetterSize(TwtTD[3], 0.164250, 1.156663);
	TextDrawTextSize(TwtTD[3], 538.000000, -232.500000);
	TextDrawSetOutline(TwtTD[3], 0);
	TextDrawSetShadow(TwtTD[3], 0);
	TextDrawAlignment(TwtTD[3], 1);
	TextDrawColour(TwtTD[3], -1);
	TextDrawBackgroundColour(TwtTD[3], 255);
	TextDrawBoxColour(TwtTD[3], 130);
	TextDrawUseBox(TwtTD[3], 1);
	TextDrawSetProportional(TwtTD[3], 1);
	TextDrawSetSelectable(TwtTD[3], 0);

	TwtTD[4] = TextDrawCreate(495.000000, 186.000000, "user123");
	TextDrawFont(TwtTD[4], 1);
	TextDrawLetterSize(TwtTD[4], 0.205917, 1.256663);
	TextDrawTextSize(TwtTD[4], 538.000000, 17.000000);
	TextDrawSetOutline(TwtTD[4], 0);
	TextDrawSetShadow(TwtTD[4], 1);
	TextDrawAlignment(TwtTD[4], 1);
	TextDrawColour(TwtTD[4], -1);
	TextDrawBackgroundColour(TwtTD[4], 255);
	TextDrawBoxColour(TwtTD[4], 50);
	TextDrawUseBox(TwtTD[4], 0);
	TextDrawSetProportional(TwtTD[4], 1);
	TextDrawSetSelectable(TwtTD[4], 0);

	TextdrawTD = TextDrawCreate(190.000000, 2.000000, "Priority_Status:");
	TextDrawFont(TextdrawTD, 2);
	TextDrawLetterSize(TextdrawTD, 0.150000, 1.100000);
	TextDrawTextSize(TextdrawTD, 400.000000, 17.000000);
	TextDrawSetOutline(TextdrawTD, 0);
	TextDrawSetShadow(TextdrawTD, 1);
	TextDrawAlignment(TextdrawTD, 1);
	TextDrawColour(TextdrawTD, -741092353);
	TextDrawBackgroundColour(TextdrawTD, 255);
	TextDrawBoxColour(TextdrawTD, 50);
	TextDrawUseBox(TextdrawTD, 0);
	TextDrawSetProportional(TextdrawTD, 1);
	TextDrawSetSelectable(TextdrawTD, 0);

	Textdraw2 = TextDrawCreate(248.000000, 3.000000, "Cooldown (15m remaining)");
	TextDrawFont(Textdraw2, 1);
	TextDrawLetterSize(Textdraw2, 0.179167, 1.000000);
	TextDrawTextSize(Textdraw2, 400.000000, 17.000000);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawSetShadow(Textdraw2, 1);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColour(Textdraw2, -1);
	TextDrawBackgroundColour(Textdraw2, 255);
	TextDrawBoxColour(Textdraw2, 50);
	TextDrawUseBox(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetSelectable(Textdraw2, 0);

	BanTD[0] = TextDrawCreate(319.000000, 129.000000, "_");
	TextDrawFont(BanTD[0], 3);
	TextDrawLetterSize(BanTD[0], 0.808332, 22.400003);
	TextDrawTextSize(BanTD[0], 564.000000, 360.000000);
	TextDrawSetOutline(BanTD[0], 1);
	TextDrawSetShadow(BanTD[0], 0);
	TextDrawAlignment(BanTD[0], 2);
	TextDrawColour(BanTD[0], 1296911871);
	TextDrawBackgroundColour(BanTD[0], 255);
	TextDrawBoxColour(BanTD[0], 1296911751);
	TextDrawUseBox(BanTD[0], 1);
	TextDrawSetProportional(BanTD[0], 1);
	TextDrawSetSelectable(BanTD[0], 0);

	BanTD[1] = TextDrawCreate(319.000000, 133.000000, "[]  All Kerala Roleplay[]");
	TextDrawFont(BanTD[1], 2);
	TextDrawLetterSize(BanTD[1], 0.320832, 2.000000);
	TextDrawTextSize(BanTD[1], 556.000000, 360.500000);
	TextDrawSetOutline(BanTD[1], 1);
	TextDrawSetShadow(BanTD[1], 0);
	TextDrawAlignment(BanTD[1], 2);
	TextDrawColour(BanTD[1], -1523963137);
	TextDrawBackgroundColour(BanTD[1], 255);
	TextDrawBoxColour(BanTD[1], 16711890);
	TextDrawUseBox(BanTD[1], 1);
	TextDrawSetProportional(BanTD[1], 1);
	TextDrawSetSelectable(BanTD[1], 0);

	BanTD[2] = TextDrawCreate(319.000000, 155.000000, "Ban System");
	TextDrawFont(BanTD[2], 0);
	TextDrawLetterSize(BanTD[2], 0.975000, 2.000000);
	TextDrawTextSize(BanTD[2], 400.000000, 207.500000);
	TextDrawSetOutline(BanTD[2], 1);
	TextDrawSetShadow(BanTD[2], 0);
	TextDrawAlignment(BanTD[2], 2);
	TextDrawColour(BanTD[2], 2094792959);
	TextDrawBackgroundColour(BanTD[2], 255);
	TextDrawBoxColour(BanTD[2], 50);
	TextDrawUseBox(BanTD[2], 0);
	TextDrawSetProportional(BanTD[2], 1);
	TextDrawSetSelectable(BanTD[2], 0);

	BanTD[3] = TextDrawCreate(144.000000, 179.000000, "Ban Information:");
	TextDrawFont(BanTD[3], 2);
	TextDrawLetterSize(BanTD[3], 0.266665, 1.500000);
	TextDrawTextSize(BanTD[3], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[3], 1);
	TextDrawSetShadow(BanTD[3], 0);
	TextDrawAlignment(BanTD[3], 1);
	TextDrawColour(BanTD[3], -16711681);
	TextDrawBackgroundColour(BanTD[3], 255);
	TextDrawBoxColour(BanTD[3], 50);
	TextDrawUseBox(BanTD[3], 0);
	TextDrawSetProportional(BanTD[3], 1);
	TextDrawSetSelectable(BanTD[3], 0);

	BanTD[4] = TextDrawCreate(145.000000, 197.000000, "Name:");
	TextDrawFont(BanTD[4], 2);
	TextDrawLetterSize(BanTD[4], 0.266665, 2.000000);
	TextDrawTextSize(BanTD[4], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[4], 1);
	TextDrawSetShadow(BanTD[4], 0);
	TextDrawAlignment(BanTD[4], 1);
	TextDrawColour(BanTD[4], 16777215);
	TextDrawBackgroundColour(BanTD[4], 255);
	TextDrawBoxColour(BanTD[4], 50);
	TextDrawUseBox(BanTD[4], 1);
	TextDrawSetProportional(BanTD[4], 1);
	TextDrawSetSelectable(BanTD[4], 0);

	BanTD[5] = TextDrawCreate(145.000000, 224.000000, "IP:");
	TextDrawFont(BanTD[5], 2);
	TextDrawLetterSize(BanTD[5], 0.266665, 2.000000);
	TextDrawTextSize(BanTD[5], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[5], 1);
	TextDrawSetShadow(BanTD[5], 0);
	TextDrawAlignment(BanTD[5], 1);
	TextDrawColour(BanTD[5], 16777215);
	TextDrawBackgroundColour(BanTD[5], 255);
	TextDrawBoxColour(BanTD[5], 50);
	TextDrawUseBox(BanTD[5], 1);
	TextDrawSetProportional(BanTD[5], 1);
	TextDrawSetSelectable(BanTD[5], 0);

	BanTD[6] = TextDrawCreate(145.000000, 251.000000, "WHO BANNED YOU?:");
	TextDrawFont(BanTD[6], 2);
	TextDrawLetterSize(BanTD[6], 0.266665, 2.000000);
	TextDrawTextSize(BanTD[6], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[6], 1);
	TextDrawSetShadow(BanTD[6], 0);
	TextDrawAlignment(BanTD[6], 1);
	TextDrawColour(BanTD[6], 16777215);
	TextDrawBackgroundColour(BanTD[6], 255);
	TextDrawBoxColour(BanTD[6], 50);
	TextDrawUseBox(BanTD[6], 1);
	TextDrawSetProportional(BanTD[6], 1);
	TextDrawSetSelectable(BanTD[6], 0);

	BanTD[7] = TextDrawCreate(145.000000, 277.000000, "BANNED SINCE:");
	TextDrawFont(BanTD[7], 2);
	TextDrawLetterSize(BanTD[7], 0.266665, 2.000000);
	TextDrawTextSize(BanTD[7], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[7], 1);
	TextDrawSetShadow(BanTD[7], 0);
	TextDrawAlignment(BanTD[7], 1);
	TextDrawColour(BanTD[7], 16777215);
	TextDrawBackgroundColour(BanTD[7], 255);
	TextDrawBoxColour(BanTD[7], 50);
	TextDrawUseBox(BanTD[7], 1);
	TextDrawSetProportional(BanTD[7], 1);
	TextDrawSetSelectable(BanTD[7], 0);

	BanTD[8] = TextDrawCreate(145.000000, 303.000000, "BAN REASON:");
	TextDrawFont(BanTD[8], 2);
	TextDrawLetterSize(BanTD[8], 0.266665, 2.000000);
	TextDrawTextSize(BanTD[8], 400.000000, 17.000000);
	TextDrawSetOutline(BanTD[8], 1);
	TextDrawSetShadow(BanTD[8], 0);
	TextDrawAlignment(BanTD[8], 1);
	TextDrawColour(BanTD[8], 16777215);
	TextDrawBackgroundColour(BanTD[8], 255);
	TextDrawBoxColour(BanTD[8], 50);
	TextDrawUseBox(BanTD[8], 1);
	TextDrawSetProportional(BanTD[8], 1);
	TextDrawSetSelectable(BanTD[8], 0);

	BanTD[9] = TextDrawCreate(413.000000, 168.000000, "ld_card:cd3s");
	TextDrawFont(BanTD[9], 4);
	TextDrawLetterSize(BanTD[9], 0.600000, 2.000000);
	TextDrawTextSize(BanTD[9], 78.000000, 151.000000);
	TextDrawSetOutline(BanTD[9], 1);
	TextDrawSetShadow(BanTD[9], 0);
	TextDrawAlignment(BanTD[9], 1);
	TextDrawColour(BanTD[9], -1);
	TextDrawBackgroundColour(BanTD[9], 255);
	TextDrawBoxColour(BanTD[9], 50);
	TextDrawUseBox(BanTD[9], 1);
	TextDrawSetProportional(BanTD[9], 1);
	TextDrawSetSelectable(BanTD[9], 0);

	BanTD[10] = TextDrawCreate(408.000000, 321.000000, "AK:RP COPYRIGHT 2021");
	TextDrawFont(BanTD[10], 2);
	TextDrawLetterSize(BanTD[10], 0.183333, 1.000000);
	TextDrawTextSize(BanTD[10], 581.000000, 198.000000);
	TextDrawSetOutline(BanTD[10], 1);
	TextDrawSetShadow(BanTD[10], 0);
	TextDrawAlignment(BanTD[10], 1);
	TextDrawColour(BanTD[10], -8433409);
	TextDrawBackgroundColour(BanTD[10], 255);
	TextDrawBoxColour(BanTD[10], 50);
	TextDrawUseBox(BanTD[10], 0);
	TextDrawSetProportional(BanTD[10], 1);
	TextDrawSetSelectable(BanTD[10], 0);

	// Animation textdraw
	AnimationTD = TextDrawCreate(435.000000, 426.000000, "Press ~r~~k~~PED_SPRINT~~w~ to stop animation");
	TextDrawBackgroundColour(AnimationTD, 255);
	TextDrawFont(AnimationTD, 1);
	TextDrawLetterSize(AnimationTD, 0.260000, 1.299999);
	TextDrawColour(AnimationTD, -1);
	TextDrawSetOutline(AnimationTD, 1);
	TextDrawSetProportional(AnimationTD, 1);

	// Unknwon Command Error textdraw
	UnknownTD[0] = TextDrawCreate(26.000000, 260.000000, "Error:");
	TextDrawBackgroundColour(UnknownTD[0], 255);
	TextDrawFont(UnknownTD[0], 2);
	TextDrawLetterSize(UnknownTD[0], 0.159999, 1.000000);
	TextDrawColour(UnknownTD[0], SERVER_COLOR);
	TextDrawSetOutline(UnknownTD[0], 0);
	TextDrawSetProportional(UnknownTD[0], 1);
	TextDrawSetShadow(UnknownTD[0], 1);
	TextDrawSetSelectable(UnknownTD[0], 0);

	UnknownTD[1] = TextDrawCreate(26.000000, 269.000000, "Unknown Command, please check /help");
	TextDrawBackgroundColour(UnknownTD[1], 255);
	TextDrawFont(UnknownTD[1], 2);
	TextDrawLetterSize(UnknownTD[1], 0.149999, 0.899999);
	TextDrawColour(UnknownTD[1], -1);
	TextDrawSetOutline(UnknownTD[1], 0);
	TextDrawSetProportional(UnknownTD[1], 1);
	TextDrawSetShadow(UnknownTD[1], 1);
	TextDrawSetSelectable(UnknownTD[1], 0);

	UnknownTD[2] = TextDrawCreate(167.000000, 261.000000, "New Textdraw");
	TextDrawBackgroundColour(UnknownTD[2], 255);
	TextDrawFont(UnknownTD[2], 1);
	TextDrawLetterSize(UnknownTD[2], 0.000000, 1.000000);
	TextDrawColour(UnknownTD[2], -1);
	TextDrawSetOutline(UnknownTD[2], 0);
	TextDrawSetProportional(UnknownTD[2], 1);
	TextDrawSetShadow(UnknownTD[2], 1);
	TextDrawUseBox(UnknownTD[2], 1);
	TextDrawBoxColour(UnknownTD[2], 96);
	TextDrawTextSize(UnknownTD[2], -3.000000, 0.000000);
	TextDrawSetSelectable(UnknownTD[2], 0);

	UnknownTD[3] = TextDrawCreate(7.000000, 258.000000, "?");
	TextDrawBackgroundColour(UnknownTD[3], 255);
	TextDrawFont(UnknownTD[3], 2);
	TextDrawLetterSize(UnknownTD[3], 0.620000, 2.499999);
	TextDrawColour(UnknownTD[3], -1);
	TextDrawSetOutline(UnknownTD[3], 0);
	TextDrawSetProportional(UnknownTD[3], 1);
	TextDrawSetShadow(UnknownTD[3], 1);
	TextDrawSetSelectable(UnknownTD[3], 0);

	// Blood Effects
    Blood[0] = TextDrawCreate(86.666648, 121.814811, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[0], 0.000000, 0.000000);
    TextDrawTextSize(Blood[0], 24.000000, 34.000000);
    TextDrawAlignment(Blood[0], 1);
    TextDrawColour(Blood[0], -1);
    TextDrawSetShadow(Blood[0], 0);
    TextDrawSetOutline(Blood[0], 0);
    TextDrawBackgroundColour(Blood[0], 255);
    TextDrawFont(Blood[0], 4);
    TextDrawSetProportional(Blood[0], 0);
    TextDrawSetShadow(Blood[0], 0);

    Blood[1] = TextDrawCreate(477.333312, 246.674102, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[1], 0.000000, 0.000000);
    TextDrawTextSize(Blood[1], 36.000000, 41.000000);
    TextDrawAlignment(Blood[1], 1);
    TextDrawColour(Blood[1], -1);
    TextDrawSetShadow(Blood[1], 0);
    TextDrawSetOutline(Blood[1], 0);
    TextDrawBackgroundColour(Blood[1], 255);
    TextDrawFont(Blood[1], 4);
    TextDrawSetProportional(Blood[1], 0);
    TextDrawSetShadow(Blood[1], 0);

    Blood[2] = TextDrawCreate(24.000041, 249.992660, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[2], 0.000000, 0.000000);
    TextDrawTextSize(Blood[2], 70.000000, 57.000000);
    TextDrawAlignment(Blood[2], 1);
    TextDrawColour(Blood[2], -1);
    TextDrawSetShadow(Blood[2], 0);
    TextDrawSetOutline(Blood[2], 0);
    TextDrawBackgroundColour(Blood[2], 255);
    TextDrawFont(Blood[2], 4);
    TextDrawSetProportional(Blood[2], 0);
    TextDrawSetShadow(Blood[2], 0);

    Blood[3] = TextDrawCreate(546.333374, 323.414916, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[3], 0.000000, 0.000000);
    TextDrawTextSize(Blood[3], 70.000000, 57.000000);
    TextDrawAlignment(Blood[3], 1);
    TextDrawColour(Blood[3], -1);
    TextDrawSetShadow(Blood[3], 0);
    TextDrawSetOutline(Blood[3], 0);
    TextDrawBackgroundColour(Blood[3], 255);
    TextDrawFont(Blood[3], 4);
    TextDrawSetProportional(Blood[3], 0);
    TextDrawSetShadow(Blood[3], 0);

    Blood[4] = TextDrawCreate(276.666717, 340.007568, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[4], 0.000000, 0.000000);
    TextDrawTextSize(Blood[4], 70.000000, 57.000000);
    TextDrawAlignment(Blood[4], 1);
    TextDrawColour(Blood[4], -1);
    TextDrawSetShadow(Blood[4], 0);
    TextDrawSetOutline(Blood[4], 0);
    TextDrawBackgroundColour(Blood[4], 255);
    TextDrawFont(Blood[4], 4);
    TextDrawSetProportional(Blood[4], 0);
    TextDrawSetShadow(Blood[4], 0);

    Blood[5] = TextDrawCreate(442.666748, 12.718672, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[5], 0.000000, 0.000000);
    TextDrawTextSize(Blood[5], 17.000000, 25.000000);
    TextDrawAlignment(Blood[5], 1);
    TextDrawColour(Blood[5], -1);
    TextDrawSetShadow(Blood[5], 0);
    TextDrawSetOutline(Blood[5], 0);
    TextDrawBackgroundColour(Blood[5], 255);
    TextDrawFont(Blood[5], 4);
    TextDrawSetProportional(Blood[5], 0);
    TextDrawSetShadow(Blood[5], 0);

    Blood[6] = TextDrawCreate(201.666732, 16.866807, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[6], 0.000000, 0.000000);
    TextDrawTextSize(Blood[6], 48.000000, 49.000000);
    TextDrawAlignment(Blood[6], 1);
    TextDrawColour(Blood[6], -1);
    TextDrawSetShadow(Blood[6], 0);
    TextDrawSetOutline(Blood[6], 0);
    TextDrawBackgroundColour(Blood[6], 255);
    TextDrawFont(Blood[6], 4);
    TextDrawSetProportional(Blood[6], 0);
    TextDrawSetShadow(Blood[6], 0);

    Blood[7] = TextDrawCreate(117.000106, 148.777893, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[7], 0.000000, 0.000000);
    TextDrawTextSize(Blood[7], 127.000000, 70.000000);
    TextDrawAlignment(Blood[7], 1);
    TextDrawColour(Blood[7], -1);
    TextDrawSetShadow(Blood[7], 0);
    TextDrawSetOutline(Blood[7], 0);
    TextDrawBackgroundColour(Blood[7], 255);
    TextDrawFont(Blood[7], 4);
    TextDrawSetProportional(Blood[7], 0);
    TextDrawSetShadow(Blood[7], 0);

    Blood[8] = TextDrawCreate(428.666717, 118.911254, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[8], 0.000000, 0.000000);
    TextDrawTextSize(Blood[8], 59.000000, 50.000000);
    TextDrawAlignment(Blood[8], 1);
    TextDrawColour(Blood[8], -1);
    TextDrawSetShadow(Blood[8], 0);
    TextDrawBackgroundColour(Blood[8], 255);
    TextDrawFont(Blood[8], 4);
    TextDrawSetProportional(Blood[8], 0);
    TextDrawSetShadow(Blood[8], 0);

	   

	CreateDynamic3DTextLabel("Self Repair\n"SVRCLR"(( Type '/selfrepair' to repair your vehicle. ))",COLOR_GREY, 829.3257,-2168.8684,2.6271,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Self Repair\n"SVRCLR"(( Type '/selfrepair' to repair your vehicle. ))",COLOR_GREY, 817.0483,-2168.1396,2.6409,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);

    CreateDynamic3DTextLabel("Pawnshop\n"SVRCLR"[Type '/exchange' to exchange your diamonds.]",COLOR_GREY, -309.5463, 1129.7507, 20.3066,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);

	CreateDynamic3DTextLabel("'/viplocker'\n"SVRCLR"[To open the donator's locker.]",COLOR_GREY,  1996.903808, 1003.976501, 994.468750,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);

	gPrisonCells[0] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[1] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[2] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[3] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[4] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[5] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[6] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[7] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[8] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[9] = CreateDynamicObject(19302,1215.29980469,-1337.69921875,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[10] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[11] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[12] = CreateDynamicObject(19302,1215.30004883,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[13] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[14] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[15] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[16] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[17] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[18] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[19] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[20] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[21] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[22] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
	gPrisonCells[23] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000);

	for(new i = 0; i < 24; i ++)
	{
		SetDynamicObjectMaterial(gPrisonCells[i], 0, 19302, "pd_jail_door02", "pd_jail_door02", 0xFF000000);
	}


    // Farmer
	FarmerVehicles[0] = AddStaticVehicleEx(478,-322.2967,-1350.3434,10.5241,270.7830,0,0, 3000); // pos 1
    FarmerVehicles[1] = AddStaticVehicleEx(478,-322.6843,-1340.8116,10.3685,272.3377,0,0, 3000); // pos 2
    FarmerVehicles[2] = AddStaticVehicleEx(478,-323.0977,-1331.4840,10.4024,271.4319,0,0, 3000); // pos 3
    FarmerVehicles[3] = AddStaticVehicleEx(478,-323.1684,-1322.5546,10.4159,270.6801,0,0, 3000); // pos 4
    FarmerVehicles[4] = AddStaticVehicleEx(478,-322.1127,-1358.8835,10.8958,269.5284,0,0, 3000); // pos 5
    FarmerVehicles[5] = AddStaticVehicleEx(478,-368.9034,-1360.9902,21.7564,93.9769,1,1, 3000); // car1
    FarmerVehicles[6] = AddStaticVehicleEx(478,-369.6640,-1364.9237,21.9200,82.5297,1,1, 3000); // car2
    FarmerVehicles[7] = AddStaticVehicleEx(478,-370.0378,-1368.0313,22.0123,79.5341,1,1, 3000); // car3
    FarmerVehicles[8] = AddStaticVehicleEx(478,-370.0262,-1371.3488,22.0194,84.8406,1,1, 3000); // 4
    FarmerVehicles[9] = AddStaticVehicleEx(478,-368.7458,-1359.5483,21.7232,86.1116,1,1, 3000); // car5

    Signal[0] = AddStaticVehicleEx(552, 1980.7, -1995.4, 13.2, 5.9, 2, 2, 3000);
	Signal[1] = AddStaticVehicleEx(552, 1973.8, -1995.4, 13.2, 5.9, 2, 2, 3000);
    Signal[2] = AddStaticVehicleEx(552, 1984.9, -1995.4, 13.2, 5.9, 2, 2, 3000);
    Signal[3] = AddStaticVehicleEx(552, 1988.9, -1995.4, 13.2, 5.9, 2, 2, 3000);
    
    Picker[0] = AddStaticVehicleEx(422, -2254.831298, -2305.609375, 28.916114, 256.26, 2, 2, 2000);
	Picker[1] = AddStaticVehicleEx(422, -2252.808105, -2303.044677, 29.099168 , 256.26, 2, 2, 2000);
    Picker[2] = AddStaticVehicleEx(422, -2250.780350, -2301.044677, 29.099168, 256.26, 2, 2, 2000);
    Picker[3] = AddStaticVehicleEx(422, -2248.780350, -2298.044677, 29.099168, 256.26, 2, 2, 2000);




	courierVehicles[0] = AddStaticVehicleEx(499, 2428.4609, -2079.6228, 13.6406, 180.0, 11,11, 300); // mule
	courierVehicles[1] = AddStaticVehicleEx(499, 2435.7002, -2079.4829, 13.6406, 180.0, 11,11, 300); // mule
	courierVehicles[2] = AddStaticVehicleEx(499, 2450.9763, -2079.6001, 13.6142, 180.0, 11,11, 300); // benson
	courierVehicles[3] = AddStaticVehicleEx(499, 2428.3293, -2102.2959, 13.6132, 270.0, 11,11, 300); // boxville
	courierVehicles[4] = AddStaticVehicleEx(499, 2428.3030, -2107.6719, 13.6155, 270.0, 11,11, 300); // boxville
    courierVehicles[5] = AddStaticVehicleEx(499, 2455.4595, -2079.3115, 13.6159, 180.0, 11,11, 300); // benson
    courierVehicles[6] = AddStaticVehicleEx(499, 2461.5056, -2079.6157, 13.6145, 180.0, 11,11, 300); // benson

	// Driving Test (Main)
    testVehicles[0] = AddStaticVehicleEx(400, 1830.584716, -1389.592163, 13.347613, 180.62, 1,1, 10); // test car 1
	testVehicles[1] = AddStaticVehicleEx(400, 1826.953125, -1389.583862, 13.346234, 180.62, 1, 1, 10); // test car 2
	testVehicles[2] = AddStaticVehicleEx(400, 1820.933105, -1388.404052, 13.343913, 180.62, 1, 1, 10); // test car 3
	
    sandalvehicle[0] = AddStaticVehicle(578,-537.717163, -177.915740, 79.028572, 159.27,26,26); //
	sandalvehicle[1] = AddStaticVehicle(578,-532.793762, -177.633087, 79.029846, 159.27,26,26); //
	sandalvehicle[2] = AddStaticVehicle(578,-562.389770, -199.278244, 79.161407, 3.86,26,26); //
	sandalvehicle[3] = AddStaticVehicle(578,-567.864868, -197.926361, 79.311157, 3.86,26,26); //
	
	atmvehicle[0] = AddStaticVehicle(499,1694.453247, -1097.079223, 24.078125, 86.57,26,26); //
	atmvehicle[1] = AddStaticVehicle(499,1696.557128, -1102.074829, 24.078125,101.42,26,26);

    OilExpoVehicle[0] = AddStaticVehicleEx(422,592.783508, 1226.879638, 12.342829,206.58,0,0, 1000); // OilExpo 1
	OilExpoVehicle[1] = AddStaticVehicleEx(422,588.465881, 1224.558471, 12.344742,203.57,0,0, 1000); // OilExpo 2
	OilExpoVehicle[2] = AddStaticVehicleEx(422,584.998657, 1222.556396, 12.336565,197.04,0,0, 1000); // OilExpo 3
	OilExpoVehicle[3] = AddStaticVehicleEx(422,581.121704, 1220.314086, 12.334438,197.22,0,0, 1000); // OilExpo 4
	OilExpoVehicle[4] = AddStaticVehicleEx(422,577.601806, 1218.290161, 12.392037,202.85,0,0, 1000); // OilExpo 5
	OilExpoVehicle[5] = AddStaticVehicleEx(422,574.017700, 1216.242309, 12.537953,198.83,0,0, 1000); // OilExpo 6
	OilExpoVehicle[6] = AddStaticVehicleEx(422,570.710083, 1214.348266, 12.575641,199.34,0,0, 1000); // OilExpo 7

	gettime(.hour = gHour);
 	gettime(.hour = gWorldTime);
	SetWorldTime(gWorldTime);

	for(new i = 0; i < MAX_LANDS; i ++)
	{
	    ReloadAllLandObjects(i);
	    ReloadLand(i);
	}
	// Timers
	SetTimer("MinuteTimer", 60000, true);
	SetTimer("SecondTimer", 1000, true);
	SetTimer("FuelTimer", 75000, true);
	SetTimer("InjuredTimer", 10000, true);
	SetTimer("LotteryUpdate", 2700000, true);
	SetTimerEx("RandomFire", 7200000, true, "i", 1);
	SetTimer("VehicleTimer", 700, true);
	SetTimer("SaveAccount", 5000, true);

	// Misc
    LoadServerInfo();
    RefreshTime();
    ResetEvent();
    ResetRobbery();
	gLastSave = 0;
	gLastFix = 0;

	SendRconCommand("weburl \t"SERVER_URL"");
	SetGameModeText(REVISION);
	print(SERVER_NAME);

	new count;
	for(new i = 0; i < MAX_OBJECTS; i ++)
	{
	    if(IsValidObject(i)) count++;
	}

	printf("%i objects loaded.", count);

	return 1;
}

