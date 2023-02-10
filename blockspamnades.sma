#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>

#define PLUGIN "Blokada Naduzywania Granatow"
#define VERSION "1.7"
#define AUTHOR "PANDA"

new gracz[33][4];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	RegisterHam(Ham_Spawn, "player", "SpawnedEventPre", 1);
	register_event("DeathMsg","EDeathMsg","a");
}
	
public SpawnedEventPre(id){
	gracz[id][3]=1;
	for(new i = 0; i < 3; i++) gracz[id][i]=0;
}

public EDeathMsg() gracz[read_data(2)][3]=0;
	
public grenade_throw(id, greindex, wId){
	switch(wId){
		case CSW_HEGRENADE: gracz[id][0]++;
		case CSW_FLASHBANG: gracz[id][1]++;
		case CSW_SMOKEGRENADE: gracz[id][2]++;
	}	
}

public client_command(id){
	if(gracz[id][3]!=1) return PLUGIN_CONTINUE;
	new szCommand[13];
	if(read_argv(0, szCommand, charsmax(szCommand))<12 && GetAliasId(szCommand)!=0) return CanBuyItem(id, GetAliasId(szCommand));
	return PLUGIN_CONTINUE;
}

public CS_InternalCommand(id, const szCommand[]){
	if(gracz[id][3]!=1) return PLUGIN_CONTINUE;
	new szCmd[13];
	if(copy(szCmd, charsmax(szCmd), szCommand)<12 && GetAliasId(szCmd)!=0) return CanBuyItem(id, GetAliasId(szCmd));
	return PLUGIN_CONTINUE;
}

public CanBuyItem(id, iItem){
	switch(iItem){
		case CSW_FLASHBANG: {
			if((user_has_weapon(id, CSW_FLASHBANG) && gracz[id][1]==1) || gracz[id][1]==2){
				client_print(id, print_center, "2 FB na runde! Nie Spamuj granatami!")
				return PLUGIN_HANDLED;
			}
		}
		case CSW_HEGRENADE: {
			if(gracz[id][0]==1){
				client_print(id, print_center, "1 HE na runde! Nie Spamuj granatami!")
				return PLUGIN_HANDLED;
			}
		}
		case CSW_SMOKEGRENADE: {
			if(gracz[id][2]==1){
				client_print(id, print_center, "1 SG na runde! Nie Spamuj granatami!")
				return PLUGIN_HANDLED;
			}
		}
	}
	return PLUGIN_CONTINUE;
}

public GetAliasId(szAlias[]){
	static Trie:tAliasesIds = Invalid_Trie;
	if(tAliasesIds == Invalid_Trie){
		tAliasesIds = TrieCreate();
		TrieSetCell(tAliasesIds, "flash", CSW_FLASHBANG);
		TrieSetCell(tAliasesIds, "hegren", CSW_HEGRENADE);
		TrieSetCell(tAliasesIds, "sgren", CSW_SMOKEGRENADE);
	}
	strtolower(szAlias);
	new iId;
	if(TrieGetCell(tAliasesIds, szAlias, iId)){
		return iId;
	}
	return 0;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
