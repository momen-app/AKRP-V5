#if defined _akrp_async_db_included
	#endinput
#endif
#define _akrp_async_db_included

stock DB_AsyncQuery(moduleid, requestid, const query[])
{
	return mysql_tquery(connectionID, query, "DB_OnModuleQuery", "ii", moduleid, requestid);
}

stock DB_AsyncExec(const query[])
{
	return mysql_tquery(connectionID, query);
}

forward DB_OnModuleQuery(moduleid, requestid);
public DB_OnModuleQuery(moduleid, requestid)
{
	return Module_OnQueryResult(moduleid, requestid);
}
