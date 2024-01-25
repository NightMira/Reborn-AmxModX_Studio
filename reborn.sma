#include <amxmodx>
#include <fakemeta>

#define FLAG_ACCESS ADMIN_LEVEL_G

#define PLUGIN_NAME "Reborn"
#define VERSION "0.1"
#define AUTHOR "jbengine"

enum _:MODEL {
	KNIFE_VIEW_MODEL,
	KNIFE_PLAYER_MODEL,
	KNIFE_WORLD_MODEL,
	AK_VIEW_MODEL,
	AK_PLAYER_MODEL,
	AK_WORLD_MODEL,
	AWP_VIEW_MODEL,
	AWP_PLAYER_MODEL,
	AWP_WORLD_MODEL,
	M4A1_VIEW_MODEL,
	M4A1_PLAYER_MODEL,
	M4A1_WORLD_MODEL,
	MAX_MODEL
}; new Array:g_aModel;

new const GAME_MENU_ID[] = "Show_RebornMenu";
new g_iMenu_Game, g_bPluginEnablie = false;

new g_bKnifeEnable[MAX_PLAYERS] = false;

enum _:CVAR {
	DAMAGE_AK,
	DAMAGE_M4A1,
	DAMAGE_AWP
}; new g_iCvar[CVAR];

public plugin_precache() {
	g_aModel = ArrayCreate(1, 0);

	CvarInit();
	GetModel();
	GetMap();
}

CvarInit() {
	g_iCvar[DAMAGE_AK] = register_cvar("rb_damage_ak", "2.0");
	g_iCvar[DAMAGE_AWP] = register_cvar("rb_damage_awp", "2.0");
	g_iCvar[DAMAGE_M4A1] = register_cvar("rb_damage_m4a1", "2.0");

	register_cvar("knife_view_model", "model/v_knife.mdl");
	register_cvar("knife_player_model", "model/p_knife.mdl");
	register_cvar("knife_world_model", "model/w_knife.mdl");

	register_cvar("ak_view_model", "model/v_ak47.mdl");
	register_cvar("ak_player_model", "model/p_ak47.mdl");
	register_cvar("ak_world_model", "model/w_ak47.mdl");

 	register_cvar("awp_view_model", "model/v_awp.mdl");
	register_cvar("awp_player_model", "model/p_awp.mdl");
	register_cvar("awp_world_model", "model/w_awp.mdl");

	register_cvar("m4a1_view_model", "model/v_m4a1.mdl");
	register_cvar("m4a1_player_model", "model/p_m4a1.mdl");
	register_cvar("m4a1_world_model", "model/w_m4a1.mdl");
}

GetModel() {
	new sBuff[512];
	get_cvar_string("knife_view_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("knife_player_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("knife_world_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);

	get_cvar_string("ak_view_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("ak_player_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("ak_world_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);

	get_cvar_string("awp_view_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("awp_player_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("awp_world_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);

	get_cvar_string("m4a1_view_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("m4a1_player_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);
	get_cvar_string("m4a1_world_model", sBuff, charsmax(sBuff));
	ArrayPushString(g_aModel, sBuff);

	for(new i = 0; i <= ArraySize(g_aModel); i++) {
		formatex(sBuff, charsmax(sBuff), "models/Reborn/%s.mdl", ArrayGetString(g_aModel, i, sBuff, charsmax(sBuff)));
		engfunc(EngFunc_PrecacheModel, sBuff);
	}
}

public plugin_cfg() {
	new szCfgDir[64];
	get_localinfo("amxx_configsdir", szCfgDir, charsmax(szCfgDir));
	server_cmd("exec %s/reborn/reborn.cfg", szCfgDir);
}

GetMap() {
	new szBuffer[128], iLine, iLen,
	szMapName[32], szMapNameToFile[32];
	new szCfgDir[64], szCfgFile[128];

	get_localinfo("amxx_configsdir", szCfgDir, charsmax(szCfgDir));
	formatex(szCfgFile, charsmax(szCfgFile), "%s/reborn/renorn.ini", szCfgDir);
	while(read_file(szCfgFile, iLine++, szBuffer, charsmax(szBuffer), iLen))
	{
		if(!iLen || iLen > 16 || szBuffer[0] == ';') continue;
		copy(szMapNameToFile, charsmax(szMapNameToFile), szBuffer);
		get_mapname(szMapName, charsmax(szMapName));
		if(equal(szMapName, szMapNameToFile))
			g_bPluginEnablie = true;
	}/*

	new szCfgDir[64], szCfgFile[128];
	get_localinfo("amxx_configsdir", szCfgDir, charsmax(szCfgDir));
	formatex(szCfgFile, charsmax(szCfgFile), "%s/reborn/renorn.ini", szCfgDir);
	switch(file_exists(szCfgFile))
	{
		case 0: log_to_file("%s/reborn/log_error.log", "File ^"%s^" not found!", szCfgDir, szCfgFile);
		case 1: BlockMapList(szCfgFile);
	}*/
}

/*
BlockMapList(szCfgFile) {

	new szBuffer[128], iLine, iLen,
	szMapName[32], szMapNameToFile[32];
	while(read_file(szCfgFile, iLine++, szBuffer, charsmax(szBuffer), iLen))
	{
		if(!iLen || iLen > 16 || szBuffer[0] == ';') continue;
		copy(szMapNameToFile, charsmax(szMapNameToFile), szBuffer);
		get_mapname(szMapName, charsmax(szMapName));
		if(equal(szMapName, szMapNameToFile))
			g_bPluginEnablie = true;
	}
}
*/

public plugin_init() {
	register_plugin(PLUGIN_NAME, VERSION, AUTHOR);

	event_init();
	menu_init();
	hamsandwich_init();
}

event_init() {
	return;
}

menu_init() {
	g_iMenu_Game = register_menuid(GAME_MENU_ID);
	register_menucmd(g_iMenu_Game, 1024, "Handle_RebornMenu");
}

Show_RebornMenu(iPlayer) {
	new szMenu[512], iKeys = (1<<0|1<<2|1<<3|1<<4|1<<5|1<<6|1<<9),
	iLen = formatex(szMenu, charsmax(szMenu), "\wReborn Меню^n^n");

	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "1. Нож [%s]^n", g_bKnifeEnable[iPlayer] ? "вкл" : "выкл");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "2. АК-47");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "3. AWP^n");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "4. M4A1^n");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "5. АК-47+^n");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "6. AWP+^n");
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "7. M4A1+^n");

	formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n0. Выход");
	
	return show_menu(iPlayer, iKeys, szMenu, -1, GAME_MENU_ID);
}

hamsandwich_init() {
	return;//RegisterHam(Ham_Player_ResetMaxSpeed, "player", "Ham_PlayerResetMaxSpeed_Post", true);
}