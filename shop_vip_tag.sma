#include <amxmodx>
#include <amxmisc>
#include <cromchat>

#include <shop>
#include <vip>

new g_iTagType[33];

public plugin_init(){

	register_clcmd("TAG", "inputTAG");

	register_item("Tag 1 Day", "handleTag1", "shop_vip_tag.amxx", 1000);
	register_item("Tag 30 Day", "handleTag30", "shop_vip_tag.amxx", 15000);
	//register_item("Vip 1 Day", "handleVip1", "shop_vip_tag.amxx", 2500);
	//register_item("Vip 30 Day", "handleVip30", "shop_vip_tag.amxx", 25000);

}

public handleTag1(id){
	/*
	if(!isPlayerVip(id)){
		CC_SendMessage(id, "&x01Trebuie sa fii &x04VIP pentru a cumpara acest item!");
		return PLUGIN_HANDLED;
	}
	*/
	
	g_iTagType[id] = 1;
	client_cmd(id, "messagemode TAG");

	return PLUGIN_CONTINUE;
}

public handleTag30(id){
	/*
	if(!isPlayerVip(id)){
		CC_SendMessage(id, "&x01Trebuie sa fii &x04VIP pentru a cumpara acest item!");
		return PLUGIN_HANDLED;
	}
	*/

	g_iTagType[id] = 30;
	client_cmd(id, "messagemode TAG");
	
	return PLUGIN_CONTINUE;
}

public handleVip1(id){
	AddVip(id, 1);
}

public handleVip30(id){
	AddVip(id, 30);
}

public inputTAG(id){
	if(!g_iTagType[id])
		return PLUGIN_HANDLED;

	new input[64];
	read_args(input, charsmax(input))
	remove_quotes(input);
	
	AddTag(id, input, g_iTagType[id]);
	
	return PLUGIN_HANDLED;
}

public AddTag(id, szTag[], period){
	new line[128], szName[64];
	new expirationDate[20] 
	get_time("%d.%b.%Y", expirationDate, 19) 
	AddToDate(expirationDate, period, expirationDate, 19);
	get_user_name(id, szName, sizeof(szName));
	formatex(line, sizeof(line), "^n^"name^" ^"%s^" ^"%s^" ^"%s^"",szName, szTag, expirationDate);
	AddTextAtLine("ChatManager.ini", "## PLAYER TAGS ##", line, szName);
	server_cmd("cm_reload");
	g_iTagType[id] = 0;
	return PLUGIN_CONTINUE;
}

public AddVip(id, period){
	new line[128], szName[64];
	new expirationDate[20] 
	get_time("%d.%b.%Y", expirationDate, 19) 
	AddToDate(expirationDate, period, expirationDate, 19);
	get_user_name(id, szName, sizeof(szName));
	formatex(line, sizeof(line), "^"%s^" [%s]",szName, expirationDate);
	AddLine("vip.ini", line);
	server_cmd("amx_reloadvips");

	return PLUGIN_CONTINUE;
}


AddToDate(const OriginalDate[], const DaysToAdd, FinalDate[], const Size)
{
	new const FormatRule[] = "%d.%m.%Y"
	new const SecondsInDay = 86400
	
	new CurrentTimeStamp = parse_time(OriginalDate, FormatRule)
	CurrentTimeStamp = CurrentTimeStamp + DaysToAdd * SecondsInDay
	format_time(FinalDate, Size, FormatRule, CurrentTimeStamp)
} 


stock AddLine(const FileName[], const Line[])
{
	new ConfigDirPath[128]; get_configsdir(ConfigDirPath, charsmax(ConfigDirPath))
	new FullPath[256]; formatex(FullPath, charsmax(FullPath), "%s/%s", ConfigDirPath, FileName)

	new FilePointer = fopen(FullPath, "at")
	if(FilePointer)
	{
		fprintf(FilePointer, "^n%s", Line)
	}

	fclose(FilePointer)
}

stock AddTextAtLine(const FileName[], const BeforeLine[], const Line[], const DeleteLine[])
{
	new const TempFileName[] = "tempfile.ini"

	new ConfigDirPath[128]; get_configsdir(ConfigDirPath, charsmax(ConfigDirPath))
	new FullPath[256]; formatex(FullPath, charsmax(FullPath), "%s/%s", ConfigDirPath, FileName)

	new FilePointer = fopen(FullPath, "rt")
	if(FilePointer)
	{
		new TempFilePath[256]; formatex(TempFilePath, charsmax(TempFilePath), "%s/%s", ConfigDirPath, TempFileName)
		
		new InputFilePointer = fopen(TempFilePath, "wt")
		if(InputFilePointer)
		{
			new FileData[128]
			while(!feof(FilePointer))
			{
				fgets(FilePointer, FileData, charsmax(FileData))
				trim(FileData)

				//DELETE LINE IF CONTAINS "DeleteLine"
				if(containi(FileData, DeleteLine) != -1)
				{
					continue;
				}

				//PRINT FILE NORMALLY
				fprintf(InputFilePointer, "%s^n", FileData)

				//ADD "Line" AFTER "BeforeLine"
				if(equal(FileData, BeforeLine))
				{
					server_print(FileData);
					server_print(Line);
					server_print("%d", fprintf(InputFilePointer, "%s^n", Line));
				}
				
			}
			
			fclose(InputFilePointer)
			fclose(FilePointer)

			delete_file(FullPath)
			rename_file(TempFilePath, FullPath, 1)
			
			return 1
		}
	}
	return 0
}
