#if defined _akrp_mysql_r41_inc
	#endinput
#endif
#define _akrp_mysql_r41_inc

stock SQL_GetRows()
{
	new rows;
	cache_get_row_count(rows);
	return rows;
}

stock SQL_GetFields()
{
	new fields;
	cache_get_field_count(fields);
	return fields;
}

stock SQL_GetCacheData(&rows, &fields)
{
	cache_get_row_count(rows);
	cache_get_field_count(fields);
	return 1;
}

stock SQL_GetInt(row, const field[])
{
	new value;
	cache_get_value_name_int(row, field, value);
	return value;
}

stock Float:SQL_GetFloat(row, const field[])
{
	new Float:value;
	cache_get_value_name_float(row, field, value);
	return value;
}

stock SQL_GetString(row, const field[], destination[], max_len = sizeof(destination))
{
	return cache_get_value_name(row, field, destination, max_len);
}

stock SQL_GetIntByIndex(row, column)
{
	new value;
	cache_get_value_index_int(row, column, value);
	return value;
}

stock Float:SQL_GetFloatByIndex(row, column)
{
	new Float:value;
	cache_get_value_index_float(row, column, value);
	return value;
}

stock SQL_GetStringByIndex(row, column, destination[], max_len = sizeof(destination))
{
	return cache_get_value_index(row, column, destination, max_len);
}
