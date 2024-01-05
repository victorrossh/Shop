#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat>

#include <vip>
#include <player_skins>
#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 18
#define USP_NUM 12
#define CHARS_NUM 5

enum _: eSkin
{
	iSkinId,
	szName[64],
	szModel[128],
	iCost
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Default", "", 0},
	{101, "Knife Ahegao", 				"models/fwo/shop/vip/knife/v_def_ahegao.mdl", 			1500},
	{102, "Knife Black", 				"models/fwo/shop/vip/knife/v_def_black.mdl", 			1500},
	{103, "Knife Fire", 				"models/fwo/shop/vip/knife/v_def_fire.mdl", 			1500},
	{104, "Knife Fire-Flower", 			"models/fwo/shop/vip/knife/v_def_fire_flower.mdl",	 	1500},
	{105, "Knife Grizzly", 				"models/fwo/shop/vip/knife/v_def_grizzly.mdl", 			1500},
	{106, "Butcher Hyperbeast", 		"models/fwo/shop/vip/knife/v_but_hyperbeast.mdl", 		1500},
	{107, "Butcher Ice-Phoenix", 		"models/fwo/shop/vip/knife/v_def_icephoenix.mdl", 		1500},
	{108, "Butcher Iridescent", 		"models/fwo/shop/vip/knife/v_but_iridescent.mdl", 		1500},
	{109, "Knife Iridescent", 			"models/fwo/shop/vip/knife/v_def_iridescent.mdl", 		1500},
	{110, "Knife King", 				"models/fwo/shop/vip/knife/v_def_king.mdl", 			1500},
	{111, "Butcher King-Lion", 			"models/fwo/shop/vip/knife/v_but_lion_blade.mdl", 		1500},
	{112, "Knife Moon", 				"models/fwo/shop/vip/knife/v_def_moon.mdl", 			1500},
	{113, "Butcher Neo-Noir", 			"models/fwo/shop/vip/knife/v_but_neo-noir.mdl", 		1500},
	{114, "Knife Neo-Noir", 			"models/fwo/shop/vip/knife/v_def_neo-noir.mdl", 		1500},
	{115, "Knife Purple", 				"models/fwo/shop/vip/knife/v_def_plr.mdl", 				1500},
	{116, "Knife Sakura", 				"models/fwo/shop/vip/knife/v_def_sakura.mdl", 			1500},
	{117, "Butcher Xiao", 				"models/fwo/shop/vip/knife/v_but_xiao.mdl", 			1500}
}


new g_Usps[USP_NUM][eSkin]={
	{200, "Default", "", 0},
	{201, "Abstract-Blue", 				"models/fwo/shop/vip/usp/v_usp_abstract_blue.mdl", 		1500},
	{202, "Black", 						"models/fwo/shop/vip/usp/v_usp_black.mdl", 				1500},
	{203, "Bright", 					"models/fwo/shop/vip/usp/v_usp_bright.mdl", 			1500},
	{204, "Cortex", 					"models/fwo/shop/vip/usp/v_usp_cortex.mdl", 			1500},
	{205, "Fire-Flower", 				"models/fwo/shop/vip/usp/v_usp_fire_flower.mdl", 		1500},
	{206, "Ice-Phoenix", 				"models/fwo/shop/vip/usp/v_usp_lightning_monster.mdl",	1500},
	{207, "Iridescent", 				"models/fwo/shop/vip/usp/v_usp_iridescent.mdl", 		1500},
	{208, "Neo-Noir", 					"models/fwo/shop/vip/usp/v_usp_neo-noir.mdl", 			1500},
	{209, "Night-Wolf", 				"models/fwo/shop/vip/usp/v_usp_night_wolf.mdl", 		1500},
	{210, "Sakura", 					"models/fwo/shop/vip/usp/v_usp_sakura.mdl", 			1500},
	{211, "Xiao", 						"models/fwo/shop/vip/usp/v_usp_xiao.mdl", 				1500}
};

new g_Chars[CHARS_NUM][eSkin]={
	{300, "Default", "", 0},
	{301, "Arctic", "arctic2", 2000},
	{302, "Hitman", "hitman", 5000},
	{303, "Ema", "ema", 10000},
	{304, "Agent Ritsuka", "ritsuka", 15000},
}

new knifeId[33];

//Main
public plugin_init(){
	
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins(VIP)", "SkinsMenu", "shop_vip_skins.amxx", 0);

	CC_SetPrefix("&x04[FWO]") 

}
//Precaching the skins from the list above
public plugin_precache(){
	for(new i=1;i<KNIFE_NUM;i++)
		precache_model(g_Knives[i][szModel]);
	for(new i=1;i<USP_NUM;i++)
		precache_model(g_Usps[i][szModel]);
	
	new mdl[128];
	for(new i=1;i<CHARS_NUM;i++){
		format(mdl, charsmax(mdl), "models/player/%s/%s.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		precache_generic(mdl);
		format(mdl, charsmax(mdl), "models/player/%s/%sT.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		if(file_exists(mdl))
			precache_generic(mdl);
	}
		

}

//Menu to choose the menu you want
public SkinsMenu(id){
	
	if(!isPlayerVip(id)){
		CC_SendMessage(id, "&x01Você precisa ser &x04VIP &x01para comprar este item.");
		return PLUGIN_HANDLED;
	}
	
	new menu = menu_create( "\r[FWO] \d- \wChoose your item:", "menu_handler1" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );
	menu_additem( menu, "\wPlayer Skins", "", 0);

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//menu handler for the vip menu /vmenu
public menu_handler1( id, menu, item ){
	
	switch( item )
	{
		case 0:
		{
			KnifeMenu(id);
		}
		case 1:
		{
			UspMenu(id);
		}
		case 2:
		{
			CharSkinMenu(id);
		}
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Menu to choose a custom knife skin
public KnifeMenu(id){
	new menu = menu_create( "\r[FWO] \d- \wChoose the type of knife:", "menu_handler" );

	menu_additem( menu, "\wDefault Knife", "", 0 );
	menu_additem( menu, "\wButcher Knife", "", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the knife skin menu
public menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}

	switch( item )
	{
		case 0:
		{
			KnifeSkinMenu(id);
			knifeId[id] = 0;
		}
		case 1:
		{
			KnifeSkinMenu(id);
			knifeId[id] = 1;
		}
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}
//Menu to choose a custom knife skin
public UspMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[FWO] \d- \wUsp Skins^n\wCredits: \y%d\d", credits);

	new menu = menu_create( title, "usp_menu_handler" );

	for(new i = 0;i<USP_NUM;i++){
		if(inventory_get_item(id, g_Usps[i][iSkinId]) || !g_Usps[i][iCost])
			formatex(itemText, 127, "\y%s", g_Usps[i][szName])
		else{
			if(credits>=g_Usps[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Usps[i][szName], g_Usps[i][iCost])
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Usps[i][szName], g_Usps[i][iCost])
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the knife skin menu
public usp_menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Usps[item][iSkinId])){
		set_user_usp(id, g_Usps[item][szModel]);
		menu_destroy( menu );
		UspMenu(id);
		return PLUGIN_HANDLED;
	}

	menu_destroy( menu );
	BuyUspSkin(id, item);
	UspMenu(id);
	return PLUGIN_HANDLED;
}
//Second Menu
public KnifeSkinMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[FWO] \d- \wKnife Skins^n\wCredits: \y%d\d", credits);
	new menu = menu_create( title, "knife_skin_handler" );
	
	for(new i = 0;i<KNIFE_NUM;i++){
		if(inventory_get_item(id, g_Knives[i][iSkinId]) || !g_Knives[i][iCost])
			formatex(itemText, 127, "\y%s", g_Knives[i][szName]);
		else{
			if(credits>=g_Knives[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Knives[i][szName], g_Knives[i][iCost]);
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Knives[i][szName], g_Knives[i][iCost]);
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public knife_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		KnifeMenu(id);
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Knives[item][iSkinId])){

		if(knifeId[id] == 0)
			set_user_knife(id, g_Knives[item][szModel]);
		else
			set_user_butcher(id, g_Knives[item][szModel]);

		menu_destroy( menu );
		KnifeSkinMenu(id);
		return PLUGIN_HANDLED;

	}

	menu_destroy( menu );
	BuyKnifeSkin(id, item);
	KnifeSkinMenu(id);
	return PLUGIN_HANDLED;
}

public CharSkinMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[FWO] \d- \wPlayer Skins^n\wCredits: \y%d", credits);
	new menu = menu_create( title, "player_skin_handler" );
	
	for(new i = 0;i<CHARS_NUM;i++){
		if(inventory_get_item(id, g_Chars[i][iSkinId]) || !g_Chars[i][iCost])
			formatex(itemText, 127, "\y%s", g_Chars[i][szName]);
		else{
			if(credits>=g_Chars[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Chars[i][szName], g_Chars[i][iCost]);
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Chars[i][szName], g_Chars[i][iCost]);
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public player_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Chars[item][iSkinId])){
		set_user_skin(id, g_Chars[item][szModel]);
		
		menu_destroy( menu );
		CharSkinMenu(id);
		return PLUGIN_HANDLED;

	}
	menu_destroy( menu );
	BuyPlayerSkin(id, item);
	CharSkinMenu(id);
	return PLUGIN_HANDLED;
}

public BuyKnifeSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Knives[item][iCost]){
		set_user_credits(id, credits - g_Knives[item][iCost])
		inventory_add(id, g_Knives[item][iSkinId]);
		CC_SendMessage(id, "&x01Você comprou &x04%s&x01.", g_Knives[item][szName]);

		if(knifeId[id] == 0)
			set_user_knife(id, g_Knives[item][szModel]);
		else
			set_user_butcher(id, g_Knives[item][szModel]);
	}		
	else{
		CC_SendMessage(id, "&x01Você não tem créditos suficiente para comprar esta skin.");
	}
	
}

public BuyUspSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Usps[item][iCost]){
		set_user_credits(id, credits - g_Usps[item][iCost])
		inventory_add(id, g_Usps[item][iSkinId]);
		set_user_usp(id, g_Usps[item][szModel]);
		CC_SendMessage(id, "&x01Você comprou &x04%s&x01.", g_Usps[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Você não tem créditos suficiente para comprar esta skin.");
	}
}

public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iCost]){
		set_user_credits(id, credits - g_Chars[item][iCost])
		inventory_add(id, g_Chars[item][iSkinId]);
		set_user_skin(id, g_Chars[item][szModel]);
		CC_SendMessage(id, "&x01Você comprou &x04%s&x01.", g_Chars[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Você não tem créditos suficiente para comprar esta skin.");
	}
}
