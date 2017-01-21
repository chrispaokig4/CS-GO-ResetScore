#include <sourcemod>
#include <cstrike>
#include <colors>

#pragma semicolon 1

Handle ResetScoreEnable;

public Plugin:myinfo =
{
	name        = "Resetscore Plugin",
	author      = "ChrisPaokiG4",
	description = "Type !rs to set your frags and deaths to 0",
	version     = "1.0",
	url         = "<- URL ->"
}

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("resetscore.phrases");
	
	RegConsoleCmd("sm_rs", ResetScoreCommand);
	RegConsoleCmd("sm_resetscore", ResetScoreCommand);
	
	ResetScoreEnable = CreateConVar("sm_resetscore", "1", "Enable and Disable the Plugin.");
}

public Action ResetScoreCommand(int client, int args)
{
	if(GetConVarInt(ResetScoreEnable) == 0)
	{
		CPrintToChat(client, "{green}[{purple}SM{green}] \x01%t", "Plugin Disabled");
		return Plugin_Continue;
	}
	
	if(GetClientDeaths(client) == 0 && GetClientFrags(client) == 0)
	{
		CPrintToChat(client, "{green}[{purple}SM{green}] \x01%t", "Already 0 Score");
		return Plugin_Continue;
	}
	
	ResetScoreCommand2(client);
	CPrintToChat(client, "{green}[{purple}SM{green}] \x01%t", "Score Reseted");
	CPrintToChat(client, "{green}[{purple}SM{green}] \x01%t", "Score Reseted2");
	
	return Plugin_Continue;
}

void ResetScoreCommand2(int client)
{
	if(IsValidClient(client))
	{
		SetEntProp(client, Prop_Data, "m_iFrags", 0);
		SetEntProp(client, Prop_Data, "m_iDeaths", 0);
		CS_SetClientAssists(client, 0);
		CS_SetClientContributionScore(client, 0);
	}
}

stock bool IsValidClient(int client)
{
	if(client <= 0)
	{
		return false;
	}
	
	if(client > MaxClients)
	{
		return false;
	}
	
	if(!IsClientConnected(client))
	{
		return false;
	}
	
	return IsClientInGame(client);
}