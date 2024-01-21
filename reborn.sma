#include <amxmodx>
#include <reapi>

#define FLAG_ACCESS ADMIN_LEVEL_G

#define PLUGIN_NAME "[ReAPI] Reborn"
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
new g_iMenu_Game;

enum _:CVAR {
	DAMAGE_AK,
	DAMAGE_M4A1,
	DAMAGE_AWP
}; new g_iCvar[CVAR];

public plugin_precache() {
	g_aModel = ArrayCreate(1, 0);

	CvarInit();
	GetModel();
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
	ArraySetString(g_aModel, KNIFE_VIEW_MODEL, sBuff);
}