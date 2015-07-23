#include <a_samp>
#include <sscanf2>
#include <DOF2>
#include <zcmd>

//Pastas
#define FOLDER_GANGS "Gangues/%i.txt" // Arquivos das gangues
#define FOLDER_ACCOUNTS "Gangues/Contas/%s.txt" //Arquivos do jogadores

//Controladores
#define MAX_GANGS 150

//Diálogos
#define CONVITE_GANG 500
#define D_Membros 501

//Enumeradores
enum gang
{
	gangname[25],
	Lider[26],
	Membro0[25],
	Membro1[25],
	Membro2[25],
	Membro3[25],
	Membro4[25],
	Membro5[25],
	Membro6[25],
	Membro7[25],
	Membro8[25],
	Membro9[25],
	Kills,
	Deaths

}
new Gang[MAX_GANGS][gang];

enum infoj
{
	idgang,
	bool:Lider
}

new Jogador[500][infoj];

main()
{
	print("\n--------------------------------------");
	print(" Sistema de Gangues por MultiKill");
	print("--------------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("Gangues");
	LoadGangs();
	return 1;
}

public OnGameModeExit()
{
	UnloadGangs();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(DOF2_FileExists(AccountFile(playerid)))
	{
	    LoadAccount(playerid);
	}
	else
	{
		CreateAccount(playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SaveAccount(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new gangkiller = Jogador[killerid][idgang];
	new gangdeath = Jogador[playerid][idgang];
	if(gangkiller != gangdeath)
	{
	    Gang[gangkiller][Kills] ++;
	    Gang[gangdeath][Deaths] ++;
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == CONVITE_GANG)
	{
		if(GetPVarInt(playerid, "ConviteGang") == 1)
		{
		    new id = GetPVarInt(playerid, "QuemConvidou");
			new gid = Jogador[id][idgang];
	    	if(response)
	    	{
				EnterGang(gid, playerid);
				SendClientMessage(id, -1, "O convite foi aceito.");
				Jogador[playerid][idgang] = Jogador[id][idgang];
				DeletePVar(playerid, "ConviteGang");
	    		DeletePVar(playerid, "QuemConvidou");
	    	}
	    	else
	    	{
	    	    SendClientMessage(id, -1, "O convite não foi aceito.");
                DeletePVar(playerid, "ConviteGang");
	    		DeletePVar(playerid, "QuemConvidou");
			}
		}
	}
	return 1;
}

CreateGang(nomegangue[], id)
{
	new i=0, filegang[80];
	while(i < MAX_GANGS)
	{
	    format(filegang, sizeof filegang, FOLDER_GANGS, i);
	    if(DOF2_FileExists(filegang))
	    {
	        if(i > MAX_GANGS)
	        {
	            SendClientMessage(id, -1, "O limte de gangues foi atingido.");
	            print("O limte de gangues criadas foi atingido.");
	            break;
	        }
			else
	        {
	        	i++;
	        	continue;
	        }
	    }
	    else
	    {
     		format(Gang[i][gangname], 25, nomegangue);
     		format(Gang[i][Lider], 26, Nome(id));
    		format(Gang[i][Membro0], 26,"Ninguem");
    		format(Gang[i][Membro1], 26,"Ninguem");
    		format(Gang[i][Membro2], 26,"Ninguem");
    		format(Gang[i][Membro3], 26,"Ninguem");
    		format(Gang[i][Membro4], 26,"Ninguem");
    		format(Gang[i][Membro5], 26,"Ninguem");
    		format(Gang[i][Membro6], 26,"Ninguem");
    		format(Gang[i][Membro7], 26,"Ninguem");
    		format(Gang[i][Membro8], 26,"Ninguem");
    		format(Gang[i][Membro9], 26,"Ninguem");
			Gang[i][Kills] = 0;
			Gang[i][Deaths] = 0;
			Jogador[id][idgang] = i;
			Jogador[id][idgang] = i;
			Jogador[id][Lider] = true;
		 	DOF2_CreateFile(GangFile(i));
		 	SaveGang(i);
	        break;
	    }
	}
	return 1;
}

SaveGang(id)
{
	new filegang[80];
    format(filegang, sizeof filegang, FOLDER_GANGS, id);
    DOF2_SetString(filegang, "Nome", Gang[id][gangname]);
    DOF2_SetString(filegang, "Lider", Gang[id][Lider]);
    DOF2_SetString(filegang, "Membro0", Gang[id][Membro0]);
    DOF2_SetString(filegang, "Membro1", Gang[id][Membro1]);
    DOF2_SetString(filegang, "Membro2", Gang[id][Membro2]);
    DOF2_SetString(filegang, "Membro3", Gang[id][Membro3]);
    DOF2_SetString(filegang, "Membro4", Gang[id][Membro4]);
    DOF2_SetString(filegang, "Membro5", Gang[id][Membro5]);
    DOF2_SetString(filegang, "Membro6", Gang[id][Membro6]);
    DOF2_SetString(filegang, "Membro7", Gang[id][Membro7]);
    DOF2_SetString(filegang, "Membro8", Gang[id][Membro8]);
    DOF2_SetString(filegang, "Membro9", Gang[id][Membro9]);
    DOF2_SetInt(filegang, "Kills", Gang[id][Kills]);
    DOF2_SetInt(filegang, "Deaths", Gang[id][Deaths]);
    DOF2_SaveFile();
	return 1;
}

GangFile(id)
{
	new gf[80];
	format(gf, sizeof gf, FOLDER_GANGS, id);
	return gf;
}

LoadGangs()
{
	for(new i=0; i<MAX_GANGS; i++)
	{
	    if(DOF2_FileExists(GangFile(i)))
	    {
			format(Gang[i][gangname], 25, DOF2_GetString(GangFile(i), "Nome"));
			format(Gang[i][Lider], 25, DOF2_GetString(GangFile(i), "Lider"));
			format(Gang[i][Membro0], 25, DOF2_GetString(GangFile(i), "Membro0"));
			format(Gang[i][Membro1], 25, DOF2_GetString(GangFile(i), "Membro1"));
			format(Gang[i][Membro2], 25, DOF2_GetString(GangFile(i), "Membro2"));
			format(Gang[i][Membro3], 25, DOF2_GetString(GangFile(i), "Membro3"));
			format(Gang[i][Membro4], 25, DOF2_GetString(GangFile(i), "Membro4"));
			format(Gang[i][Membro5], 25, DOF2_GetString(GangFile(i), "Membro5"));
			format(Gang[i][Membro6], 25, DOF2_GetString(GangFile(i), "Membro6"));
			format(Gang[i][Membro7], 25, DOF2_GetString(GangFile(i), "Membro7"));
			format(Gang[i][Membro8], 25, DOF2_GetString(GangFile(i), "Membro8"));
			format(Gang[i][Membro9], 25, DOF2_GetString(GangFile(i), "Membro9"));
			Gang[i][Kills] = DOF2_GetInt(GangFile(i), "Kills");
			Gang[i][Deaths] = DOF2_GetInt(GangFile(i), "Deaths");
	    }
	}
	return 1;
}

UnloadGangs()
{
    for(new i=0; i<MAX_GANGS; i++)
	{
		if(DOF2_FileExists(GangFile(i)))
	    {
	        SaveGang(i);
	    }
	}
	return 1;
}

Nome(id)
{
	new nome[25];
	GetPlayerName(id, nome, sizeof nome);
	return nome;
}

AccountFile(id)
{
	new folder_ac[80];
	format(folder_ac, sizeof folder_ac, FOLDER_ACCOUNTS, Nome(id));
	return folder_ac;
}

CreateAccount(id)
{
	if(!DOF2_FileExists(AccountFile(id)))
	{
	    Jogador[id][idgang] = -1;
	    DOF2_CreateFile(AccountFile(id));
		SaveAccount(id);
	}
	return 1;
}

SaveAccount(id)
{
    if(DOF2_FileExists(AccountFile(id)))
	{
	    DOF2_SetInt(AccountFile(id), "Gangue_Id", Jogador[id][idgang]);
	    DOF2_SetBool(AccountFile(id), "Lider", Jogador[id][Lider]);
	    DOF2_SaveFile();
	}
	return 1;
}

LoadAccount(id)
{
    if(DOF2_FileExists(AccountFile(id)))
	{
	    Jogador[id][idgang] = DOF2_GetInt(AccountFile(id), "Gangue_Id");
	    Jogador[id][Lider] = DOF2_GetBool(AccountFile(id), "Lider");
	}
	return 1;
}

LimparVaga(gid, vaganome[])
{
	new account[80];
	if(DOF2_FileExists(GangFile(gid)))
	{
	    if(strcmp(Gang[gid][Membro0], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro0], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
	    else if(strcmp(Gang[gid][Membro1], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro1], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro2], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro2], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro3], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro3], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro4], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro4], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro5], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro5], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro6], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro6], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro7], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro7], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro8], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro8], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
			}
		}
		else if(strcmp(Gang[gid][Membro9], vaganome, true) == 0)
		{
			format(account, sizeof account, FOLDER_ACCOUNTS, vaganome);
			if(DOF2_FileExists(account))
			{
				format(Gang[gid][Membro9], 26, "Ninguem");
				DOF2_SetInt(account, "Gangue_Id", -1);
				DOF2_SaveFile();
				print("Desbug 9");
			}
		}
	}
	return 1;
}

VerificarVagas(id)
{
	new vagalivre[20];
	if(DOF2_FileExists(GangFile(id)))
	{
	    new ii=0;
		if(strcmp(Gang[id][Membro0], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro1], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro2], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro3], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro4], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro5], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro6], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro7], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro8], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(strcmp(Gang[id][Membro9], "Ninguem", true) == 0) vagalivre = "Livre", ii++;
		else if(ii == 0) vagalivre = "Nenhuma";
	}
	return vagalivre;
}

EnterGang(idg, id)
{
	if(strcmp(VerificarVagas(idg), "Livre", true) == 0)
	{
	    if(strcmp(Gang[idg][Membro0], "Ninguem", true) == 0) format(Gang[idg][Membro0], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro1], "Ninguem", true) == 0) format(Gang[idg][Membro1], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro2], "Ninguem", true) == 0) format(Gang[idg][Membro2], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro3], "Ninguem", true) == 0) format(Gang[idg][Membro3], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro5], "Ninguem", true) == 0) format(Gang[idg][Membro4], 26, Nome(id));
		else if(strcmp(Gang[idg][Membro6], "Ninguem", true) == 0) format(Gang[idg][Membro5], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro7], "Ninguem", true) == 0) format(Gang[idg][Membro6], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro8], "Ninguem", true) == 0) format(Gang[idg][Membro7], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro9], "Ninguem", true) == 0) format(Gang[idg][Membro8], 26, Nome(id));
	    else if(strcmp(Gang[idg][Membro9], "Ninguem", true) == 0) format(Gang[idg][Membro9], 26, Nome(id));
	}
	return 1;
}

VagasLimpas(gangid)
{
	new retornar;
    if(DOF2_FileExists(GangFile(gangid)))
	{
	    new ii=0;
		if(strcmp(Gang[gangid][Membro0], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro1], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro2], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro3], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro4], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro5], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro6], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro7], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro8], "Ninguem", true) == 0) ii++;
		else if(strcmp(Gang[gangid][Membro9], "Ninguem", true) == 0) ii++;
		else if(ii == 0) retornar = 0;
		else if(ii == 10) retornar = 1;
	}
	return retornar;
}

CMD:criargangue(playerid, params[])
{
	new gangtag[80];
	if(Jogador[playerid][idgang] != -1) return SendClientMessage(playerid, -1, "Você já tem ou está em uma gangue.");
	if(sscanf(params, "s[80]", gangtag)) return SendClientMessage(playerid, -1, "Use: /criargangue <tag>"),
    SendClientMessage(playerid, -1, "OBS: Tag 5 digitos sem []");
    new maximo = strlen(gangtag);
	if(maximo <= 5)
	{
	    printf("%d é menor ou igual que 5", maximo);
		for(new i=0; i <= strlen(gangtag); i++)
		if(gangtag[i] == ' ') return SendClientMessage(playerid, -1, "Não use espaço.");

		CreateGang(gangtag, playerid);
	}
	else
	{
		SendClientMessage(playerid, -1, "Máximo de 5 digitos.");
		printf("%d é maior que 5", maximo);
	}
	return 1;
}

CMD:convidargangue(playerid, params[])
{
	new id, gid, strgang[200];
	gid = Jogador[playerid][idgang];
	if(Jogador[playerid][Lider] == false) return SendClientMessage(playerid, -1, "Você não é lider de nenhuma gangue.");
	if(strcmp(VerificarVagas(Jogador[playerid][idgang]), "Nenhuma", true) == 0) return SendClientMessage(playerid, -1, "Não há vagas na sua gangue.\nLimpe alguma vaga.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "Use: /convidargangue [id]");
	if(id == playerid) return SendClientMessage(playerid, -1, "Você não pode convidar você mesmo para sua gangue.");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "Jogador(a) não conectado(a)");
	if(Jogador[id][idgang] != -1) return SendClientMessage(playerid, -1, "O(A) jogador(a) já está em uma gangue.");
	format(strgang, sizeof strgang, "%s está lhe convidando para a gangue %s.\nDesejá entrar para está gangue?", Nome(playerid), Gang[gid][gangname]);
	ShowPlayerDialog(id, CONVITE_GANG, DIALOG_STYLE_MSGBOX, "Convite para Gangue", strgang, "Sim", "Nao");
	SetPVarInt(id, "ConviteGang", 1);
	SetPVarInt(id, "QuemConvidou", playerid);
	return 1;
}

CMD:limparvaga(playerid, params[])
{
	new membrovaga[80];
    if(Jogador[playerid][Lider] == false) return SendClientMessage(playerid, -1, "Você não é lider de nenhuma gangue.");
    if(sscanf(params, "s[80]", membrovaga)) return SendClientMessage(playerid, -1, "Use: /limparvaga [nome]"),
	SendClientMessage(playerid, -1, "O nome deve ser o nick do jogador que está na vaga.");
	LimparVaga(Jogador[playerid][idgang], membrovaga);
	SendClientMessage(playerid, -1, "Vaga limpa.");
	return 1;
}

CMD:deletargangue(playerid, params[])
{
	if(Jogador[playerid][Lider] == false) return SendClientMessage(playerid, -1, "Você não tem nenhuma gangue");
	if(!VagasLimpas(Jogador[playerid][idgang])) return SendClientMessage(playerid, -1, "Limpe todas as vagas da gangue.");
	DOF2_RemoveFile(GangFile(Jogador[playerid][idgang]));
	return 1;
}

CMD:membros(playerid)
{
	new form[500], forgangn[100];
	new gid = Jogador[playerid][idgang];
	if(Jogador[playerid][idgang] == -1) return SendClientMessage(playerid, -1, "Voê não participa de nenhuma gangue.");
	format(form, sizeof form, "Lider: %s\nMembro 0: %s\nMembro 1: %s\nMembro 2: %s\nMembro 3: %s\nMembro 4: %s\nMembro 5: %s\nMembro 6: %s\nMembro 7: %s\nMembro 8: %s\nMembro 9: %s",
	Gang[gid][Lider], Gang[gid][Membro0], Gang[gid][Membro1], Gang[gid][Membro2], Gang[gid][Membro3], Gang[gid][Membro4], Gang[gid][Membro5], Gang[gid][Membro6], Gang[gid][Membro7], Gang[gid][Membro8],
	Gang[gid][Membro9]);
	format(forgangn, sizeof forgangn, "Membros da Gangue %s", Gang[gid][gangname]);
	ShowPlayerDialog(playerid, D_Membros, DIALOG_STYLE_MSGBOX, forgangn, form, "OK", "");
	return 1;
}
