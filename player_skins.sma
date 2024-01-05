#include <amxmodx>
#include <cstrike>
#include <nvault>
#include <fakemeta_util>

new g_szKnife[MAX_PLAYERS][64];
new g_szButcher[MAX_PLAYERS][64];
new g_szUsp[MAX_PLAYERS][64];
new g_szSkin[MAX_PLAYERS][64];

new bool:g_bHideKnife[MAX_PLAYERS];
new bool:g_bHideUsp[MAX_PLAYERS];

new g_iVault;

public plugin_init()
{
	register_event("CurWeapon","Changeweapon_Hook","be","1=1");
	register_event("ResetHUD", "ResetModel_Hook", "b");

	g_iVault = nvault_open("player_skins2");
}

public plugin_natives()
{
	register_native("set_user_knife", "set_user_knife_native");
	register_native("set_user_butcher", "set_user_butcher_native");
	register_native("set_user_usp", "set_user_usp_native");
	register_native("set_user_skin", "set_user_skin_native");

	register_native("toggle_user_knife", "toggle_user_knife_native");
	register_native("toggle_user_usp", "toggle_user_usp_native");
}

public set_user_knife_native(numParams)
{
	new id = get_param(1);
	new skin[64];
	get_string(2, skin, charsmax(skin));

	format(g_szKnife[id], charsmax(g_szKnife[]), skin);

	SaveSkins(id);
}

public set_user_butcher_native(numParams)
{
	new id = get_param(1);
	new skin[64];
	get_string(2, skin, charsmax(skin));

	format(g_szButcher[id], charsmax(g_szButcher[]), skin);
	SaveSkins(id);
}

public set_user_usp_native(numParams)
{
	new id = get_param(1);
	new skin[64];
	get_string(2, skin, charsmax(skin));

	format(g_szUsp[id], charsmax(g_szUsp[]), skin);
	SaveSkins(id);
}

public set_user_skin_native(numParams)
{
	new id = get_param(1);
	new skin[64];
	get_string(2, skin, charsmax(skin));

	format(g_szSkin[id], charsmax(g_szSkin[]), skin);
	SaveSkins(id);
	cs_set_user_model(id, g_szSkin[id]);
}

public toggle_user_knife_native(numParams)
{
	new id = get_param(1);
	g_bHideKnife[id] = !g_bHideKnife[id];
}

public toggle_user_usp_native(numParams)
{
	new id = get_param(1);
	g_bHideUsp[id] = !g_bHideUsp[id];
}



//Checking the weapon the player switched to and if he's a vip it'll set a skin on that weapon if it's on the weapons list above
public Changeweapon_Hook(id){
	new model[32];

	pev(id,pev_viewmodel2, model, 31);
	new wpn_id = get_user_weapon(id);

	if(wpn_id == CSW_USP && g_bHideUsp[id])
	{
		set_pev(id,pev_viewmodel2, "");
		return PLUGIN_HANDLED;
	}
	if(wpn_id == CSW_KNIFE && g_bHideKnife[id])
	{
		set_pev(id,pev_viewmodel2, "");
		return PLUGIN_HANDLED;
	}

	if(wpn_id == CSW_USP && strlen(g_szUsp[id]))
		set_pev(id,pev_viewmodel2, g_szUsp[id]);
	if(equali(model,"models/fwo/v_knife.mdl") && strlen(g_szKnife[id]))
		set_pev(id,pev_viewmodel2, g_szKnife[id]);
	if(equali(model,"models/fwo/v_butcher.mdl") && strlen(g_szButcher[id]))
		set_pev(id,pev_viewmodel2, g_szButcher[id]);
	
	return PLUGIN_HANDLED;
}

public ResetModel_Hook(id, level, cid){
	if(strlen(g_szSkin[id]) && is_user_connected(id)){
		cs_set_user_model(id, g_szSkin[id]);
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}

public client_putinserver(id){
	LoadSkins(id);
	g_bHideKnife[id] = false;
	g_bHideUsp[id] = false;
}

public SaveSkins(id){
	new name[30];
	new key1[30];
	new key2[30];
	new key3[30];
	new key4[30];


	get_user_name( id , name , charsmax( name ) );

	formatex(key1, charsmax(key1), "%s", name);
	formatex(key2, charsmax(key2), "%s+1", name);
	formatex(key3, charsmax(key2), "%s+2", name);
	formatex(key4, charsmax(key2), "%s+3", name);
	
	nvault_set( g_iVault , key1 , g_szKnife[id]);
	nvault_set( g_iVault , key2 , g_szButcher[id]);
	nvault_set( g_iVault , key3 , g_szUsp[id]);
	nvault_set( g_iVault , key4 , g_szSkin[id]);
}
//loads the skins
public LoadSkins(id){

	new name[30];
	new key1[30];
	new key2[30];
	new key3[30];
	new key4[30];

	get_user_name( id , name , charsmax( name ) );

	formatex(key1, charsmax(key1), "%s", name);
	formatex(key2, charsmax(key2), "%s+1", name);
	formatex(key3, charsmax(key2), "%s+2", name);
	formatex(key4, charsmax(key2), "%s+3", name);

	nvault_get( g_iVault , key1 , g_szKnife[id] , 127 );  
	nvault_get( g_iVault , key2 , g_szButcher[id] , 127 );
	nvault_get( g_iVault , key3 , g_szUsp[id] , 127 );
	nvault_get( g_iVault , key4 , g_szSkin[id] , 127 );

}