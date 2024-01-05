#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat>

#include <player_skins>
#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 19
#define USP_NUM 13

enum _: eSkin
{
	iSkinId,
	szName[64],
	szModel[128],
	iCost
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{400, "Default", "", 0},
	{401, "Knife Abstract", 			"models/fwo/shop/knife/v_def_abstract.mdl", 	2500},
	{402, "Butcher Black-Wolf", 		"models/fwo/shop/knife/v_but_black_wolf.mdl", 	2500},
	{403, "Knife Blue-Ghost", 			"models/fwo/shop/knife/v_def_ghost_blue.mdl", 	2500},
	{404, "Butcher Carbon", 			"models/fwo/shop/knife/v_but_carbon.mdl", 		2500},
	{405, "Knife Color", 				"models/fwo/shop/knife/v_def_color.mdl", 		2500},
	{406, "Knife Frozen", 				"models/fwo/shop/knife/v_def_frozen.mdl", 		2500},
	{407, "Knife Lightning", 			"models/fwo/shop/knife/v_def_lightning.mdl", 	2500},
	{408, "Knife Linkin-Park", 			"models/fwo/shop/knife/v_def_linkin_park.mdl", 	2500},
	{409, "Butcher Lion", 				"models/fwo/shop/knife/v_but_lion.mdl", 		2500},
	{410, "Knife Nexus", 				"models/fwo/shop/knife/v_def_nexus.mdl", 		2500},
	{411, "Knife Night", 				"models/fwo/shop/knife/v_def_night.mdl", 		2500},
	{412, "Knife Nightraid", 			"models/fwo/shop/knife/v_def_nightraid.mdl", 	2500},
	{413, "Butcher Rainbow", 			"models/fwo/shop/knife/v_but_rainbow.mdl", 		2500},
	{414, "Butcher Red-Ghost ", 		"models/fwo/shop/knife/v_but_red_ghost.mdl", 	2500},
	{415, "Knife Red-Ghost", 			"models/fwo/shop/knife/v_def_ghost_red.mdl", 	2500},
	{416, "Butcher Rias", 				"models/fwo/shop/knife/v_but_rias.mdl", 		2500},
	{417, "Knife Steel", 				"models/fwo/shop/knife/v_def_steel.mdl", 		2500},
	{418, "Knife Thug-Cat", 			"models/fwo/shop/knife/v_def_thug_cat.mdl", 	2500}
	
}


new g_Usps[USP_NUM][eSkin]={
	{500, "Default", "", 0},
	{501, "Abstract", 				"models/fwo/shop/usp/v_usp_abstract.mdl", 			2500},
	{502, "Carbon", 				"models/fwo/shop/usp/v_usp_carbon.mdl", 			2500},
	{503, "Dark-Flower", 			"models/fwo/shop/usp/v_usp_dark_flower.mdl", 		2500},
	{504, "Dark-Red", 				"models/fwo/shop/usp/v_usp_dark_red.mdl", 			2500},
	{505, "Fire", 					"models/fwo/shop/usp/v_usp_fire.mdl", 				2500},
	{506, "Green-Night", 			"models/fwo/shop/usp/v_usp_night_wolf_green.mdl", 	2500},
	{507, "Nightfire", 				"models/fwo/shop/usp/v_usp_nightfire.mdl", 			2500},
	{508, "Nightraid", 				"models/fwo/shop/usp/v_usp_nightraid.mdl", 			2500},
	{509, "Orion", 					"models/fwo/shop/usp/v_usp_orion.mdl", 				2500},
	{510, "Shadow-Knight", 			"models/fwo/shop/usp/v_usp_shadow_knight.mdl", 		2500},
	{511, "Strong-Blue", 			"models/fwo/shop/usp/v_usp_strong_blue.mdl", 		2500},
	{512, "Water", 					"models/fwo/shop/usp/v_usp_water.mdl", 				2500}
};

new knifeId[33];


//Main
public plugin_init(){
	
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins", "SkinsMenu", "shop_skins.amxx", 0);

	CC_SetPrefix("&x04[FWO]") 

}
//Precaching the skins from the list above
public plugin_precache(){
	for(new i=1;i<KNIFE_NUM;i++)
		precache_model(g_Knives[i][szModel]);
	for(new i=1;i<USP_NUM;i++)
		precache_model(g_Usps[i][szModel]);
	
}


//Menu to choose the menu you want
public SkinsMenu(id){

	new menu = menu_create( "\r[FWO] \d- \wChoose your item:", "menu_handler1" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//menu handler
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
		KnifeMenu(id);
		menu_destroy( menu );
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
