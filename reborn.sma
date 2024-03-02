#include <amxmodx>
#include <cstrike>
#include <fakemeta>
#include <hamsandwich>
#include <fun>

#define FLAG_ACCESS ADMIN_LEVEL_G

#define PLUGIN_NAME "Reborn"
#define VERSION "1.0"
#define AUTHOR "jbengine"

#define linux_diff_player 5
#define m_pActiveItem 373

#define KNIFE_KEY 76543
#define AK_KEY 123419
#define AWP_KEY 42131
#define M4A1_KEY 87986

// 1.8.2
#define MAX_PLAYERS 32

enum _:MODEL {
	KNIFE_VIEW_MODEL[512],
	KNIFE_PLAYER_MODEL[512],
	KNIFE_WORLD_MODEL[512],
	AK_VIEW_MODEL[512],
	AK_PLAYER_MODEL[512],
	AK_WORLD_MODEL[512],
	AWP_VIEW_MODEL[512],
	AWP_PLAYER_MODEL[512],
	AWP_WORLD_MODEL[512],
	M4A1_VIEW_MODEL[512],
	M4A1_PLAYER_MODEL[512],
	M4A1_WORLD_MODEL[512],
	MAX_MODEL
}; new g_aModel[MAX_MODEL];

new g_sWeaponName[][] =  {
	"weapon_knife",
	"weapon_ak47",
	"weapon_awp",
	"weapon_m4a1"
};

new const GAME_MENU_ID[] = "Show_RebornMenu";
new g_iMenu_Game, g_bPluginEnablie = true;

new g_bKnifeEnable[MAX_PLAYERS] = false;
new g_iRoundCount = 0;

enum _:CVAR {
	DAMAGE_AK,
	DAMAGE_M4A1,
	DAMAGE_AWP,
	ROUND_TO_ACTIVATE,
	ROUND_FOR_AK,
	ROUND_FOR_M4A1,
	ROUND_FOR_AWP
}; new g_iCvar[CVAR];

public plugin_precache() {
	//g_aModel = ArrayCreate(64, 0);
	register_clcmd("test", "fn_test");
	CvarInit();
	GetModel();
	GetMap();
}

public fn_test(iPlayer) return Show_RebornMenu(iPlayer);

CvarInit() {
	g_iCvar[DAMAGE_AK] = register_cvar("rb_damage_ak", "2.0");
	g_iCvar[DAMAGE_AWP] = register_cvar("rb_damage_awp", "2.0");
	g_iCvar[DAMAGE_M4A1] = register_cvar("rb_damage_m4a1", "2.0");

	g_iCvar[ROUND_TO_ACTIVATE] = register_cvar("rb_round_active", "2");
	g_iCvar[ROUND_FOR_AK] = register_cvar("rb_round_ak", "3");
	g_iCvar[ROUND_FOR_M4A1] = register_cvar("rb_round_m4a1", "3");
	g_iCvar[ROUND_FOR_AWP] = register_cvar("rb_round_awp", "3");

	register_cvar("knife_view_model", "v_knife");
	register_cvar("knife_player_model", "p_knife");
	register_cvar("knife_world_model", "w_knife");

	register_cvar("ak_view_model", "v_ak47");
	register_cvar("ak_player_model", "p_ak47");
	register_cvar("ak_world_model", "w_ak47");

 	register_cvar("awp_view_model", "v_awp");
	register_cvar("awp_player_model", "p_awp");
	register_cvar("awp_world_model", "w_awp");

	register_cvar("m4a1_view_model", "v_m4a1");
	register_cvar("m4a1_player_model", "p_m4a1");
	register_cvar("m4a1_world_model", "w_m4a1");
}

GetModel() {
	new szCfgDir[64];
	get_localinfo("amxx_configsdir", szCfgDir, charsmax(szCfgDir));
	server_cmd("exec %s/reborn/reborn.cfg", szCfgDir);

	new sBuff[512], szFile[512];
	get_cvar_string("knife_view_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[KNIFE_VIEW_MODEL], charsmax(g_aModel[KNIFE_VIEW_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("knife_player_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[KNIFE_PLAYER_MODEL], charsmax(g_aModel[KNIFE_PLAYER_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("knife_world_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[KNIFE_WORLD_MODEL], charsmax(g_aModel[KNIFE_WORLD_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);

	get_cvar_string("ak_view_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AK_VIEW_MODEL], charsmax(g_aModel[AK_VIEW_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("ak_player_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AK_PLAYER_MODEL], charsmax(g_aModel[AK_PLAYER_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("ak_world_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AK_WORLD_MODEL], charsmax(g_aModel[AK_WORLD_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);

	get_cvar_string("awp_view_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AWP_VIEW_MODEL], charsmax(g_aModel[AWP_VIEW_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("awp_player_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AWP_PLAYER_MODEL], charsmax(g_aModel[AWP_PLAYER_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("awp_world_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[AWP_WORLD_MODEL], charsmax(g_aModel[AWP_WORLD_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);

	get_cvar_string("m4a1_view_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[M4A1_VIEW_MODEL], charsmax(g_aModel[M4A1_VIEW_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("m4a1_player_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[M4A1_PLAYER_MODEL], charsmax(g_aModel[M4A1_PLAYER_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);
	get_cvar_string("m4a1_world_model", sBuff, charsmax(sBuff));
	if(sBuff[0]) {	
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(file_exists(szFile)) {
			engfunc(EngFunc_PrecacheModel, szFile);
			copy(g_aModel[M4A1_WORLD_MODEL], charsmax(g_aModel[M4A1_WORLD_MODEL]), szFile);
		}
	}
	//ArrayPushString(g_aModel, sBuff);

	/*for(new i = 0; i < ArraySize(g_aModel); i++) {
		ArrayGetString(g_aModel, i, sBuff, charsmax(sBuff))
		if(!sBuff[0]) continue;
		formatex(szFile, charsmax(szFile), "models/Reborn/%s.mdl", sBuff);
		if(!file_exists(szFile)) continue;
		engfunc(EngFunc_PrecacheModel, szFile);
		ArraySetString(g_aModel, i, szFile);
	}*/
}

GetMap() {
	new szBuffer[128], iLine, iLen,
	szMapName[32], szMapNameToFile[32];
	new szCfgDir[64], szCfgFile[128];

	get_localinfo("amxx_configsdir", szCfgDir, charsmax(szCfgDir));
	formatex(szCfgFile, charsmax(szCfgFile), "%s/reborn/reborn.ini", szCfgDir);
	while(read_file(szCfgFile, iLine++, szBuffer, charsmax(szBuffer), iLen))
	{
		if(!iLen || iLen > 16 || szBuffer[0] == ';') continue;
		copy(szMapNameToFile, charsmax(szMapNameToFile), szBuffer);
		get_mapname(szMapName, charsmax(szMapName));
		if(equal(szMapName, szMapNameToFile))
			g_bPluginEnablie = false;
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

public plugin_init() {
	register_plugin(PLUGIN_NAME, VERSION, AUTHOR);
	event_init();
	menu_init();
	hamsandwich_init();
}

event_init() {
	register_logevent("LogEvent_RoundStart", 2, "1=Round_Start");
	register_forward(FM_SetModel, "fw_SetModel_Post", 1);
	register_forward(FM_SetModel, "fw_SetModel_Pre", 0);
}

public LogEvent_RoundStart() {
	g_iRoundCount++;
}

public fw_SetModel_Post(entity, model[]) {
	if (!pev_valid(entity)) 
		return FMRES_IGNORED;

	new className[33]; 
	pev(entity, pev_classname, className, 32);
	
	if(equal(className, "weaponbox"))
	{
		static id; id = pev(entity, pev_owner)
		if(pev(id, pev_iuser2)) {
			switch(pev(id, pev_iuser2)) {
				case AK_KEY: {
					set_pev(entity, pev_impulse, AK_KEY);
					return FMRES_SUPERCEDE;
				}
				case AWP_KEY: {
					set_pev(entity, pev_impulse, AWP_KEY);
					return FMRES_SUPERCEDE;
				}
				case M4A1_KEY: {
					set_pev(entity, pev_impulse, M4A1_KEY);
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	return FMRES_IGNORED;
}

public fw_SetModel_Pre(entity, model[]) {
	if (!pev_valid(entity)) 
		return FMRES_IGNORED;

	new className[33], WeaponModel[64]; 
	pev(entity, pev_classname, className, 32);
	
	if(equal(className, "weaponbox"))
	{
		static id; id = pev(entity, pev_owner);
		if(pev(entity, pev_impulse)) {
			switch(pev(id, pev_iuser2)) {
				case AK_KEY: {
					copy(WeaponModel, charsmax(WeaponModel), g_aModel[AK_WORLD_MODEL]);
					//ArrayGetString(g_aModel, AK_WORLD_MODEL, WeaponModel, 63);
					if(!file_exists(WeaponModel)) return FMRES_IGNORED;
					engfunc(EngFunc_SetModel, entity, WeaponModel);
					set_pev(id, pev_iuser2, 0);
					return FMRES_SUPERCEDE;
				}
				case AWP_KEY: {
					copy(WeaponModel, charsmax(WeaponModel), g_aModel[AWP_WORLD_MODEL]);
					//ArrayGetString(g_aModel, AWP_WORLD_MODEL, WeaponModel, 63);
					if(!file_exists(WeaponModel)) return FMRES_IGNORED;
					engfunc(EngFunc_SetModel, entity, WeaponModel);
					set_pev(id, pev_iuser2, 0);
					return FMRES_SUPERCEDE;
				}
				case M4A1_KEY: {
					copy(WeaponModel, charsmax(WeaponModel), g_aModel[M4A1_WORLD_MODEL]);
					//ArrayGetString(g_aModel, M4A1_WORLD_MODEL, WeaponModel, 63);
					if(!file_exists(WeaponModel)) return FMRES_IGNORED;
					engfunc(EngFunc_SetModel, entity, WeaponModel);
					set_pev(id, pev_iuser2, 0);
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	return FMRES_IGNORED;
}

menu_init() {
	g_iMenu_Game = register_menuid(GAME_MENU_ID);
	register_menucmd(g_iMenu_Game, 1023, "Handle_RebornMenu");
}

Show_RebornMenu(iPlayer) {
  	new szMenu[512], iKeys = (1<<9),
	iLen = formatex(szMenu, charsmax(szMenu), "\wReborn Меню^n^n");
	if(g_iRoundCount >= get_pcvar_num(g_iCvar[ROUND_TO_ACTIVATE])) {
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y1. Нож [%s]^n", g_bKnifeEnable[iPlayer] ? "Вкл" : "Выкл");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y2. АК-47^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y3. AWP^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y4. M4A1^n");
		iKeys |= (1<<0|1<<1|1<<2|1<<3);
		if(g_iRoundCount >= get_pcvar_num(g_iCvar[ROUND_FOR_AK])) {
			iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y5. АК-47+^n");
			iKeys |= (1<<4);
		}
		else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d5. АК-47+^n");
		if(g_iRoundCount >= get_pcvar_num(g_iCvar[ROUND_FOR_AWP])) {
			iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y6. AWP+^n");
			iKeys |= (1<<5);
		}
		else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d6. АWP+^n");
		if(g_iRoundCount >= get_pcvar_num(g_iCvar[ROUND_FOR_M4A1])) {
			iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y7. M4A1+^n");
			iKeys |= (1<<6);
		}
		else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d7. M4A1+^n");
	}
	else {
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d1. Нож [%s]^n", g_bKnifeEnable[iPlayer] ? "Вкл" : "Выкл");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d2. AK-47^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d3. AWP^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d4. M4A1^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d5. АК-47+^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d6. АWP+^n");
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\d7. M4A1+^n");
	}

	formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n\r0. Выход");
	
	return show_menu(iPlayer, iKeys, szMenu, -1, GAME_MENU_ID);
}

public Handle_RebornMenu(iPlayer, iKey) {
	switch(iKey) {
		case 0: {
			g_bKnifeEnable[iPlayer] = !g_bKnifeEnable[iPlayer];
			client_cmd(iPlayer, "knife");
			if(get_user_weapon(iPlayer) == CSW_KNIFE) {
				new iActiveItem = get_pdata_cbase(iPlayer, m_pActiveItem, linux_diff_player);
				if(iActiveItem > 0) ExecuteHamB(Ham_Item_Deploy, iActiveItem);
			}
			return Show_RebornMenu(iPlayer);
		}
		case 1: {
			give_item(iPlayer, "weapon_ak47");
			give_item(iPlayer, "ammo_762nato");
			give_item(iPlayer, "ammo_762nato");
			give_item(iPlayer, "ammo_762nato");
			return Show_RebornMenu(iPlayer);
		}
		case 2: {
			give_item(iPlayer, "weapon_awp");
			give_item(iPlayer, "ammo_338magnum");
			give_item(iPlayer, "ammo_338magnum");
			give_item(iPlayer, "ammo_338magnum");
			return Show_RebornMenu(iPlayer);
		}
		case 3: {
			give_item(iPlayer, "weapon_m4a1");
			give_item(iPlayer, "ammo_556nato");
			give_item(iPlayer, "ammo_556nato");
			give_item(iPlayer, "ammo_556nato");
			return Show_RebornMenu(iPlayer);
		}
		case 4: {
			new iWeapon = give_item(iPlayer, "weapon_ak47");
			give_item(iPlayer, "ammo_762nato");
			give_item(iPlayer, "ammo_762nato");
			give_item(iPlayer, "ammo_762nato");
			if(pev_valid(iWeapon)) {
				set_pev(iWeapon, pev_impulse, AK_KEY);
				new iActiveItem = get_pdata_cbase(iPlayer, m_pActiveItem, linux_diff_player);
				if(iActiveItem > 0) ExecuteHamB(Ham_Item_Deploy, iActiveItem);
			}
			return Show_RebornMenu(iPlayer);
		}
		case 5: {
			new iWeapon = give_item(iPlayer, "weapon_awp");
			give_item(iPlayer, "ammo_338magnum");
			give_item(iPlayer, "ammo_338magnum");
			give_item(iPlayer, "ammo_338magnum");
			if(pev_valid(iWeapon)) {
				set_pev(iWeapon, pev_impulse, AWP_KEY);
				new iActiveItem = get_pdata_cbase(iPlayer, m_pActiveItem, linux_diff_player);
				if(iActiveItem > 0) ExecuteHamB(Ham_Item_Deploy, iActiveItem);
			}
			return Show_RebornMenu(iPlayer);
		}
		case 6: {
			new iWeapon = give_item(iPlayer, "weapon_m4a1");
			give_item(iPlayer, "ammo_556nato");
			give_item(iPlayer, "ammo_556nato");
			give_item(iPlayer, "ammo_556nato");
			
			if(pev_valid(iWeapon)) {
				set_pev(iWeapon, pev_impulse, M4A1_KEY);
				new iActiveItem = get_pdata_cbase(iPlayer, m_pActiveItem, linux_diff_player);
				if(iActiveItem > 0) ExecuteHamB(Ham_Item_Deploy, iActiveItem);
			}
			return Show_RebornMenu(iPlayer);
		}
	}
	return PLUGIN_HANDLED;
}

hamsandwich_init() {
	for(new i = 1; i < 4; i++) {
		RegisterHam(Ham_Item_Deploy, g_sWeaponName[i], "deploy_weapon", 1);
	}
	RegisterHam(Ham_TakeDamage, "player", "hook_TakeDamage")
	RegisterHam(Ham_Item_Deploy, g_sWeaponName[0], "deploy_knife", 1);
}

public hook_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type) {
	new Gun = get_user_weapon(attacker)
	if(Gun == CSW_AK47 && pev(attacker, pev_impulse) == AK_KEY)
	{
		SetHamParamFloat(4, damage*get_pcvar_num(g_iCvar[DAMAGE_AK]));
	}
	if(Gun == CSW_M4A1 && pev(attacker, pev_impulse) == M4A1_KEY)
	{
		SetHamParamFloat(4, damage*get_pcvar_num(g_iCvar[DAMAGE_M4A1]));
	}
	if(Gun == CSW_AWP && pev(attacker, pev_impulse) == AWP_KEY)
	{
		SetHamParamFloat(4, damage*get_pcvar_num(g_iCvar[DAMAGE_AWP]));
	}

	return HAM_IGNORED;
}

public deploy_weapon(wpn) {
	static id; id = get_pdata_cbase(wpn, 41, 4);
	
	switch(pev(wpn, pev_impulse)) {
		case AK_KEY: {
			//new sBuff[64];
			//ArrayGetString(g_aModel, AK_VIEW_MODEL, sBuff, 63)
			if(!file_exists(g_aModel[AK_VIEW_MODEL])) return;
			set_pev(id, pev_viewmodel2, g_aModel[AK_VIEW_MODEL]);

			//ArrayGetString(g_aModel, AK_PLAYER_MODEL, sBuff, 63)
			if(!file_exists(g_aModel[AK_PLAYER_MODEL])) return;
			set_pev(id, pev_weaponmodel2, g_aModel[AK_PLAYER_MODEL]);

			set_pev(id, pev_iuser2, AK_KEY);
		}
		case AWP_KEY: {
			//new sBuff[64]; 
			//ArrayGetString(g_aModel, AWP_VIEW_MODEL, sBuff, 63)
			if(!file_exists(g_aModel[AWP_VIEW_MODEL])) return;
			set_pev(id, pev_viewmodel2, g_aModel[AWP_VIEW_MODEL]);

			//ArrayGetString(g_aModel, AWP_PLAYER_MODEL, sBuff, 63)
			if(!file_exists(g_aModel[AWP_PLAYER_MODEL])) return;
			set_pev(id, pev_weaponmodel2, g_aModel[AWP_PLAYER_MODEL]);

			set_pev(id, pev_iuser2, AWP_KEY);
		}
		case M4A1_KEY: {
			//new sBuff[64]; 
			//ArrayGetString(g_aModel, M4A1_VIEW_MODEL, sBuff, 63)
			if(!file_exists(g_aModel[M4A1_VIEW_MODEL])) return;
			set_pev(id, pev_viewmodel2, g_aModel[M4A1_VIEW_MODEL]);

			//ArrayGetString(g_aModel, M4A1_PLAYER_MODEL, sBuff, 63);
			if(!file_exists(g_aModel[M4A1_PLAYER_MODEL])) return;
			set_pev(id, pev_weaponmodel2, g_aModel[M4A1_PLAYER_MODEL]);

			set_pev(id, pev_iuser2, M4A1_KEY);
		}
	}
}

public deploy_knife(wpn) {
	static id; id = get_pdata_cbase(wpn, 41, 4);

	if(g_bKnifeEnable[id]) {
		//new sBuff[64]; 
		//ArrayGetString(g_aModel, KNIFE_VIEW_MODEL, sBuff, 63)
		if(!file_exists(g_aModel[KNIFE_VIEW_MODEL])) return;
		set_pev(id, pev_viewmodel2, g_aModel[KNIFE_VIEW_MODEL]);

		//ArrayGetString(g_aModel, KNIFE_PLAYER_MODEL, sBuff, 63);
		if(!file_exists(g_aModel[KNIFE_PLAYER_MODEL])) return;
		set_pev(id, pev_weaponmodel2, g_aModel[KNIFE_PLAYER_MODEL]);
	}
}

public plugin_natives() {
	register_native("rb_menu", "@native_rb_menu");
}

@native_rb_menu(plugin, argc) {
	enum { arg_player = 1};

	new iPlayer = get_param(arg_player);
	new iFlags = get_user_flags(iPlayer);
	if(iFlags & FLAG_ACCESS && g_bPluginEnablie) return Show_RebornMenu(iPlayer);
	return 0;
}