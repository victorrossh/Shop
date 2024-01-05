#define KNIFE_NUM 2
#define USP_NUM 1

//List of the new knife models
new knifeModels[KNIFE_NUM][128]={
	"",
	
	"models/vip/v_hide.mdl"
};
new knifeModelsNames[KNIFE_NUM][128]={
	"Default Knife",
	
	"Hide"
};

new uspModels[USP_NUM][128]={
	""
};

new uspModelsNames[USP_NUM][128]={
	"Default Usp"
};


//Precaching the skins from the list above
public plugin_precache(){
	for(new i=0;i<KNIFE_NUM;i++)
		precache_model(knifeModels[i]);
	for(new i=0;i<USP_NUM;i++)
		precache_model(uspModels[i]);

}

//Checking the weapon the player switched to and if he's a vip it'll set a skin on that weapon if it's on the weapons list above
public Changeweapon_Hook(id){
	if(!is_user_alive(id) )
		return PLUGIN_CONTINUE;

	new model[32];
	
	pev(id,pev_viewmodel2,model,31);

	if(equali(model,"models/v_usp.mdl") && !equali(inventory[id][usedUsp],""))
		set_pev(id,pev_viewmodel2, inventory[id][usedUsp]);
	if(equali(model,"models/v_knife.mdl") && !equali(inventory[id][usedKnife][0],""))
		set_pev(id,pev_viewmodel2,inventory[id][usedKnife][0]);
	if(equali(model,"models/knife-mod/v_butcher.mdl") && !equali(inventory[id][usedKnife][1],""))
		set_pev(id,pev_viewmodel2,inventory[id][usedKnife][1]);
	return PLUGIN_HANDLED;
}

//Menu to choose the menu you want
public skins_menu(id){
	new menu = menu_create( "\yChoose The Menu You Want!:", "skins_handler" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//menu handler for the vip menu /vmenu
public skins_handler( id, menu, item ){
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
//Menu to choose a custom player skin
public UspMenu(id){
	new txt[128];
	new menu = menu_create( "\yChoose The Skin You Want To Set!:", "usp_handler" );

	for(new i =0;i<USP_NUM;i++){
		if(inventory[id][UspSkins][i]){
			format(txt,charsmax(txt),"\w%s", uspModelsNames[i]);
		}
		else{
			format(txt,charsmax(txt),"\r%s -  \y%d puncte", uspModelsNames[i], PretUsp(i));
		}
		
		menu_additem( menu, txt, "", 0 );

	}

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the playerskin menu
public usp_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	if(inventory[id][UspSkins][item]){
		inventory[id][usedUsp] = uspModels[item];
	}
	else{
		new credits = get_user_credits(id);
		if(credits < PretUsp(item)){
			client_print(id, print_chat, "Nu ai suficente puncte!")
		}
		else{
			credits = credits - PretUsp(item);
			set_user_credits(id, credits);
			client_print(id, print_chat, "Ai cumparat %s!", uspModelsNames[item])
			client_print(id, print_chat, "Puncte curente %d.", credits);
			inventory[id][usedUsp] = uspModels[item];
			inventory[id][UspSkins][item] = 1;
		}
	}
	
	Save(id);
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}
//Menu to choose a custom knife skin
public KnifeMenu(id){
	new menu = menu_create( "\yChoose Knife To Set Skin To!:", "knife_handler" );

	menu_additem( menu, "\wDefault Knife", "", 0 );
	menu_additem( menu, "\wGravity Knife", "", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the knife skin menu
public knife_handler( id, menu, item ){
	switch( item )
	{
		case 0:
		{
			DefaultMenu(id);
		}
		case 1:
		{
			ButcherMenu(id);
		}
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Default Menu
public DefaultMenu(id){
	new txt[128];
	new menu = menu_create( "\yChoose Skin!:", "default_handler" );

	for(new i=0;i<KNIFE_NUM;i++){
		if(inventory[id][KnifeSkins][i]){
			format(txt,charsmax(txt),"\w%s", knifeModelsNames[i]);
		}
		else{
			format(txt,charsmax(txt),"\r%s -  \y%d puncte", knifeModelsNames[i], PretKnife(i));
		}
		menu_additem(menu, txt, "");
		
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );
}

//Default Menu Handler
public default_handler( id, menu, item){
	if ( item == MENU_EXIT )
	{
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	if(inventory[id][KnifeSkins][item]){
		inventory[id][usedKnife] = knifeModels[item];
	}
	else{
		new credits = get_user_credits(id);
		if(credits < PretKnife(item)){
			client_print(id, print_chat, "Nu ai suficente puncte!")
		}
		else{
			set_user_credits(id, credits - PretKnife(id));
			client_print(id, print_chat, "Ai cumparat %s!", knifeModelsNames[item])
			client_print(id, print_chat, "Puncte curente %d.", credits - PretKnife(id));
			inventory[id][usedKnife] = knifeModels[item];
			inventory[id][KnifeSkins][item] = 1;
		}
	}
	Save(id);
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Butcher Menu
public ButcherMenu(id){
	new txt[128];
	new menu = menu_create( "\yChoose Skin!:", "butcher_handler" );

	for(new i=0;i<KNIFE_NUM;i++){
		if(inventory[id][KnifeSkins][i]){
			format(txt,charsmax(txt),"\w%s", knifeModelsNames[i]);
		}
		else{
			format(txt,charsmax(txt),"\r%s -  \y%d puncte", knifeModelsNames[i], PretKnife(i));
		}
		menu_additem(menu, txt, "");
		
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );
}

//Butcher Menu Handler
public butcher_handler( id, menu, item){
	if ( item == MENU_EXIT )
	{
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	if(item == 0){
		format(inventory[id][usedButcher], 127, "models/knife-mod/v_butcher.mdl");
		Save(id);
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}

	if(inventory[id][KnifeSkins][item]){
		inventory[id][usedButcher] = knifeModels[item];
	}
	else{
		new credits = get_user_credits(id);
		if(credits < PretKnife(item)){
			client_print(id, print_chat, "Nu ai suficente puncte!")
		}
		else{
			set_user_credits(id, credits - PretKnife(id));
			client_print(id, print_chat, "Ai cumparat %s!", knifeModelsNames[item])
			client_print(id, print_chat, "Puncte curente %d.", credits - PretKnife(id));
			inventory[id][usedButcher] = knifeModels[item];
			inventory[id][KnifeSkins][item] = 1;
		}
	}
	Save(id);
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//save the skins and sounds for the vips
public Save(id){
	new szSteamID[32];
	new key[30];

	get_user_authid( id , szSteamID , charsmax( szSteamID ) );

	formatex(key, charsmax(key), "%s", szSteamID);

	nvault_set_array(g_hShop, key, inventory[id], sizeof(inventory[]));

}
//loads the skins and sounds for the vips
public Load(id){
	new szSteamID[32];
	new key[30];

	get_user_authid( id , szSteamID , charsmax( szSteamID ) );

	formatex(key, charsmax(key), "%s", szSteamID);

	nvault_get_array(g_hShop, key, inventory[id], sizeof(inventory[]));

	return PLUGIN_CONTINUE;
}

stock PretUsp(id){
	return id * 10;	
}

stock PretKnife(id){
	return id * 10;
}