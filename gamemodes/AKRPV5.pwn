/*
 ****************************************************************
 *  ___________________________________________________________ *
 * |                         INFORMATION                       |*
 * |___________________________________________________________|*
 * |                                                           |*
 * |   [Server]: "All Kerala Roleplay"                         |*
 * |   [Founder]: "SHAZ"                                       |*
 * |   [Developer]: "NAJU & ROCKY" (@najuaircrack)             |*
 * |   [Scripts Date]: "20/5/2025"                             |*                                                         
 * |   [Owner]: "GULAN & MANU"                                 |*
 * |   [Version]: "V5-OMP - Public Release"                    |*
 * |___________________________________________________________|*
 *                                                              *
 *   COPYRIGHT © 2024 NAJU - All Kerala Roleplay.               *
 *   This script is publicly released by the original author.   *
 *                                                              *
 *   Redistribution and use with credit are allowed.            *
 *   Commercial use or resale is strictly prohibited.           *
 *                                                              *
 *   For contributions, issues, or forks, visit:                *
 *   https://github.com/najuaircrack/AKRPV5                     *
 *                                                              *
 *   Contact: Kcnajwan7@gmail.com                               *
 ****************************************************************
*/


//-----------------------------[ PRAGMA'S ]----------------------------

#pragma warning disable 213  // tag warnings  you can use #define NO_TAGS
#pragma unused KICK_MSG
#pragma unused MAX_CONNECTS_MSG
#pragma unused UNKNOWN_CLIENT_MSG


#pragma option -d3

#define MIXED_SPELLINGS
#define NO_SUSPICION_LOGS
#include <open.mp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 303

//-----------------------------[ INCLUDES AND DEFINESTAG]-----------------------------

#include <omp_http> //latest
#include <a_mysql> //R41-4
#include "modules/core/mysql_r41.pwn"
#include <sscanf2> //latest
#include <logger> //latest
#include <Pawn.CMD> //latest
#include <mSelection> //latest
#include <BustAim> //latest
#include <streamer> //latest
#include <nex-ac> //latest
#include <PawnPlus> //latest
#include <weapon-config> //latest
#include <discord-connector2> //just name changed new verison pre 
#include <discord-cmd> //latest
#include <profiler> //latest
#include <textdraw-streamer> //latest
#include <sampvoice> // integrated voice

//-----------------------------[ EXTERNAL INCLUDES ]-----------------------------
#include <mapfix>
#include <selection> 
#include <tp> 
#include <td-string-width>
#include <progress2>
#include <pawn-easing-functions>
#include <air-gps>


//---------------------------[ END EXTERNAL INCLUDES ]--------------------------- 

//core
#include "modules/core/enum.pwn"
#include "modules/core/definition.pwn"
#include "modules/core/modules.pwn"
#include "modules/core/db_async.pwn"
#include "modules/core/dialog_async.pwn"
#include "modules/core/notification/header.pwn"

//server
#include "modules/server/anticheat.pwn"
#include "modules/server/discordconnector.pwn"
#include "modules/server/safezone.pwn"
#include "modules/server/mappings.pwn"

//client
#include "modules/client/inventory.pwn"
#include "modules/client/backgun.pwn"
#include "modules/client/utils.pwn"

//integrations
#include "modules/integrations/sampvoice.pwn"

//preload  and utils
#include "modules/core/utils/preload.pwn"
#include "modules/core/utils/color.pwn"

// Notification
#include "modules/core/notification/callbacks.pwn"
#include "modules/core/notification/functions.pwn"


// Thin gamemode entry: all AKRP systems are loaded from domain modules.
#include "modules/akrp/loader.pwn"
