#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <nvault_array>
#include <cromchat>

#include <credits>
#include <inventory>

native reg_is_user_logged(id);
native reg_is_user_registered(id);

#define PLUGIN "Dr Shop"
#define VERSION "0.1"
#define AUTHOR "MrShark45"

enum _: eShopItem
{
	szName[64],
	szCallBackFunction[64],
	szPlugin[64],
	iCost,
	iItemID
}

new Array: g_aItems;

new g_szLogFile[64];

public plugin_init(){
	register_clcmd("say /shop", "shop_menu");

	g_aItems = ArrayCreate( eShopItem );

	CC_SetPrefix("&x04[FWO]") 
}

public plugin_cfg(){
	static datestr[11], FilePath[64];
	get_localinfo("amxx_logs", FilePath, 63);
	get_time("%Y.%m.%d", datestr, 10);
	formatex(g_szLogFile, 63, "%s/shop/shop_%s.log", FilePath, datestr);
	if (!file_exists(g_szLogFile))
	{
		write_file(g_szLogFile, "Shop LogFile");
	}
}

public plugin_natives(){
	register_library("shop")

	register_native("register_item", "register_item_native");
	register_native("open_shop_menu", "open_shop_menu_native");
}

public register_item_native(numParams){
	new item_name[64], item_callbackFunction[64], item_plugin[64];
	get_string(1, item_name, sizeof(item_name));
	get_string(2, item_callbackFunction, sizeof(item_callbackFunction));
	get_string(3, item_plugin, sizeof(item_plugin));
	new item_cost = get_param(4);
	new itemID = get_param(5);

	new item[eShopItem];

	copy( item[ szName ], charsmax( item_name ), item_name );
	copy( item[ szCallBackFunction ], charsmax( item_callbackFunction ), item_callbackFunction );
	copy( item[ szPlugin ], charsmax( item_plugin ), item_plugin );
	item[iCost] = item_cost;
	item[iItemID] = itemID;

	ArrayPushArray(g_aItems, item);
}

public open_shop_menu_native(numParams){
	new id = get_param(1);
	shop_menu(id, 0);
}

public shop_menu(id, page){
	new title[128];
	new credits = get_user_credits(id);
	format(title, sizeof(title), "\r[FWO] \d- \wShop Menu^nCredits: \y%d", credits);
	new menu = menu_create( title, "menu_handler" );

	for(new i;i<ArraySize(g_aItems);i++)
	{
		new shopItem[eShopItem], item[128];
		ArrayGetArray(g_aItems, i, shopItem);

		if(credits >= shopItem[iCost])
			format(item, sizeof(item), "%s \y%d\wc", shopItem[szName], shopItem[iCost]);
		else
			format(item, sizeof(item), "%s \r%d\wc", shopItem[szName], shopItem[iCost]);
		if(!shopItem[iCost] || inventory_get_item(id, shopItem[iItemID]))
			format(item, sizeof(item), "\y%s", shopItem[szName]);

		menu_additem(menu, item, "");
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	
	menu_display( id, menu, page );

	return PLUGIN_HANDLED_MAIN;
}

public menu_handler(id, menu, item){
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;

	if(!reg_is_user_logged(id) || !reg_is_user_registered(id)){
		CC_SendMessage(id, "&x01Você deve estar registrado para comprar na loja.");
		return PLUGIN_CONTINUE;
	}

	if(item < 0){
		menu_destroy( menu );
		return PLUGIN_CONTINUE;
	}
		
	new shopItem[eShopItem];
	ArrayGetArray(g_aItems, item, shopItem);
	new credits = get_user_credits(id);

	if(inventory_get_item(id, shopItem[iItemID])){
		CC_SendMessage(id, "&x01Você já comprou este item!");
		return PLUGIN_HANDLED;
	}

	if(credits < shopItem[iCost]){
		CC_SendMessage(id, "&x01Você não tem créditos suficientes para comprar este item!");
		return PLUGIN_HANDLED;
	}

	new call = callfunc_begin(shopItem[szCallBackFunction], shopItem[szPlugin])
	if(call > 0) {
		callfunc_push_int(id);
		new ret = callfunc_end();
		if(!shopItem[iCost] || ret == -1){
			menu_destroy( menu );
			return PLUGIN_HANDLED;
		}
		CC_SendMessage(id, "&x01Você comprou &x03%s&x01.", shopItem[szName]);
		UTIL_LogBuy(id, "Comprou %s", shopItem[szName]);
		new newCredits = credits-shopItem[iCost];
		set_user_credits(id, newCredits);
	}
	/*switch(call){
		case -1: client_print(id, print_chat, "Function not found");
		case -2: client_print(id, print_chat, "Plugin not found");
		case 0: client_print(id, print_chat, "Runtime error");
		case 1: client_print(id, print_chat, "Success");
	}*/

	shop_menu(id, item/7);
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

public UTIL_LogBuy(const id, const szCvar[], any:...)
{
	new iFile;
	if( (iFile = fopen(g_szLogFile, "a")) )
	{
		new Name[32], Authid[32], Ip[32], Time[22];
		
		new message[128]; vformat(message, charsmax(message), szCvar, 3);

		get_user_name(id, Name, charsmax(Name));
		get_user_authid(id, Authid, charsmax(Authid));
		get_user_ip(id, Time, charsmax(Time), 1);
		get_time("%m/%d/%Y - %H:%M:%S", Time, charsmax(Time));

		fprintf(iFile, "L %s: <%s><%s><%s> %s^n", Time, Name, Authid, Ip, message);
		fclose(iFile);
	}
}
