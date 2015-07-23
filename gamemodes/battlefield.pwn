//----------------------------------------------------------
/*

Creat de catre: ReborN KillerZ Brigades Enterprises

	Ajutor:

	    - Whitetiger
		- StK Clan

Changelog: 03/07/2015 (last update)
- FPS & Ping 3d Text on player
- FPS Counter in TextDraw
- Changed kills/deaths/ratio textdraws position and font

*/
//----------------------------------------------------------
#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <dof2>
#include <dini>
#include <sscanf2>
#include <geoip>
#include <lookup>
//----------------------------------------------------------
//
//  Variabile
//
//----------------------------------------------------------

#define MYSQL_USER 				"root"
#define MYSQL_HOST 				"127.0.0.1"
#define MYSQL_DB 				"battlefield"
#define MYSQL_PAROLA 			"password"

#define Kick(%0) 				SetTimerEx("Kicka", 100, false, "i", %0)
#define Ban(%0) 				SetTimerEx("Bana", 100, false, "i", %0)
#define AdminLog 				"AdminLog.txt"
#define MAX_WEAPON_SLOT         13
#define MAX_ZONE_NAME           28
#define MAX_MAPS                18
#define MAX_VOTE_MAP            4
#define MAX_REPORTS    			10

#define FOLDER_ACCOUNTS 		"Accounts/%s.txt"

new mysql;

//----------------------------------------------------------
//
//  Variabile race
//
//----------------------------------------------------------

#pragma unused \
	ret_memcpy

#define ForEach(%0,%1) \
	for(new %0 = 0; %0 != %1; %0++) if(IsPlayerConnected(%0) && !IsPlayerNPC(%0))

#define Loop(%0,%1) \
	for(new %0 = 0; %0 != %1; %0++)

#define IsOdd(%1) \
	((%1) & 1)

#define ConvertTime(%0,%1,%2,%3,%4) \
	new \
	    Float: %0 = floatdiv(%1, 60000) \
	;\
	%2 = floatround(%0, floatround_tozero); \
	%3 = floatround(floatmul(%0 - %2, 60), floatround_tozero); \
	%4 = floatround(floatmul(floatmul(%0 - %2, 60) - %3, 1000), floatround_tozero)

#define function%0(%1) \
	forward%0(%1); public%0(%1)

#define MAX_RACE_CHECKPOINTS_EACH_RACE 	120
#define MAX_RACES 						100
#define COUNT_DOWN_TILL_RACE_START 		30 // seconds
#define MAX_RACE_TIME 					300 // seconds
#define RACE_CHECKPOINT_SIZE 			12.0
#define DEBUG_RACE 						1
//#define RACE_IN_OTHER_WORLD


new
	vNames[212][] =
	{
		{"Landstalker"},
		{"Bravura"},
		{"Buffalo"},
		{"Linerunner"},
		{"Perrenial"},
		{"Sentinel"},
		{"Dumper"},
		{"Firetruck"},
		{"Trashmaster"},
		{"Stretch"},
		{"Manana"},
		{"Infernus"},
		{"Voodoo"},
		{"Pony"},
		{"Mule"},
		{"Cheetah"},
		{"Ambulance"},
		{"Leviathan"},
		{"Moonbeam"},
		{"Esperanto"},
		{"Taxi"},
		{"Washington"},
		{"Bobcat"},
		{"Mr Whoopee"},
		{"BF Injection"},
		{"Hunter"},
		{"Premier"},
		{"Enforcer"},
		{"Securicar"},
		{"Banshee"},
		{"Predator"},
		{"Bus"},
		{"Rhino"},
		{"Barracks"},
		{"Hotknife"},
		{"Trailer 1"},
		{"Previon"},
		{"Coach"},
		{"Cabbie"},
		{"Stallion"},
		{"Rumpo"},
		{"RC Bandit"},
		{"Romero"},
		{"Packer"},
		{"Monster"},
		{"Admiral"},
		{"Squalo"},
		{"Seasparrow"},
		{"Pizzaboy"},
		{"Tram"},
		{"Trailer 2"},
		{"Turismo"},
		{"Speeder"},
		{"Reefer"},
		{"Tropic"},
		{"Flatbed"},
		{"Yankee"},
		{"Caddy"},
		{"Solair"},
		{"Berkley's RC Van"},
		{"Skimmer"},
		{"PCJ-600"},
		{"Faggio"},
		{"Freeway"},
		{"RC Baron"},
		{"RC Raider"},
		{"Glendale"},
		{"Oceanic"},
		{"Sanchez"},
		{"Sparrow"},
		{"Patriot"},
		{"Quad"},
		{"Coastguard"},
		{"Dinghy"},
		{"Hermes"},
		{"Sabre"},
		{"Rustler"},
		{"ZR-350"},
		{"Walton"},
		{"Regina"},
		{"Comet"},
		{"BMX"},
		{"Burrito"},
		{"Camper"},
		{"Marquis"},
		{"Baggage"},
		{"Dozer"},
		{"Maverick"},
		{"News Chopper"},
		{"Rancher"},
		{"FBI Rancher"},
		{"Virgo"},
		{"Greenwood"},
		{"Jetmax"},
		{"Hotring"},
		{"Sandking"},
		{"Blista Compact"},
		{"Police Maverick"},
		{"Boxville"},
		{"Benson"},
		{"Mesa"},
		{"RC Goblin"},
		{"Hotring Racer A"},
		{"Hotring Racer B"},
		{"Bloodring Banger"},
		{"Rancher"},
		{"Super GT"},
		{"Elegant"},
		{"Journey"},
		{"Bike"},
		{"Mountain Bike"},
		{"Beagle"},
		{"Cropdust"},
		{"Stunt"},
		{"Tanker"},
		{"Roadtrain"},
		{"Nebula"},
		{"Majestic"},
		{"Buccaneer"},
		{"Shamal"},
		{"Hydra"},
		{"FCR-900"},
		{"NRG-500"},
		{"HPV1000"},
		{"Cement Truck"},
		{"Tow Truck"},
		{"Fortune"},
		{"Cadrona"},
		{"FBI Truck"},
		{"Willard"},
		{"Forklift"},
		{"Tractor"},
		{"Combine"},
		{"Feltzer"},
		{"Remington"},
		{"Slamvan"},
		{"Blade"},
		{"Freight"},
		{"Streak"},
		{"Vortex"},
		{"Vincent"},
		{"Bullet"},
		{"Clover"},
		{"Sadler"},
		{"Firetruck LA"},
		{"Hustler"},
		{"Intruder"},
		{"Primo"},
		{"Cargobob"},
		{"Tampa"},
		{"Sunrise"},
		{"Merit"},
		{"Utility"},
		{"Nevada"},
		{"Yosemite"},
		{"Windsor"},
		{"Monster A"},
		{"Monster B"},
		{"Uranus"},
		{"Jester"},
		{"Sultan"},
		{"Stratum"},
		{"Elegy"},
		{"Raindance"},
		{"RC Tiger"},
		{"Flash"},
		{"Tahoma"},
		{"Savanna"},
		{"Bandito"},
		{"Freight Flat"},
		{"Streak Carriage"},
		{"Kart"},
		{"Mower"},
		{"Duneride"},
		{"Sweeper"},
		{"Broadway"},
		{"Tornado"},
		{"AT-400"},
		{"DFT-30"},
		{"Huntley"},
		{"Stafford"},
		{"BF-400"},
		{"Newsvan"},
		{"Tug"},
		{"Trailer 3"},
		{"Emperor"},
		{"Wayfarer"},
		{"Euros"},
		{"Hotdog"},
		{"Club"},
		{"Freight Carriage"},
		{"Trailer 3"},
		{"Andromada"},
		{"Dodo"},
		{"RC Cam"},
		{"Launch"},
		{"Police Car (LSPD)"},
		{"Police Car (SFPD)"},
		{"Police Car (LVPD)"},
		{"Police Ranger"},
		{"Picador"},
		{"S.W.A.T. Van"},
		{"Alpha"},
		{"Phoenix"},
		{"Glendale"},
		{"Sadler"},
		{"Luggage Trailer A"},
		{"Luggage Trailer B"},
		{"Stair Trailer"},
		{"Boxville"},
		{"Farm Plow"},
		{"Utility Trailer"}
	},
	BuildRace,
	BuildRaceType,
	BuildVehicle,
	BuildCreatedVehicle,
	BuildModeVID,
	BuildName[30],
	bool: BuildTakeVehPos,
	BuildVehPosCount,
	bool: BuildTakeCheckpoints,
	BuildCheckPointCount,
	RaceBusy = 0x00,
	RaceName[30],
	RaceVehicle,
	RaceType,
	TotalCP,
	Float: RaceVehCoords[2][4],
	Float: CPCoords[MAX_RACE_CHECKPOINTS_EACH_RACE][4],
	CreatedRaceVeh[MAX_PLAYERS],
	Index,
	PlayersCount[2],
	CountTimer,
	CountAmount,
	bool: Joined[MAX_PLAYERS],
	RaceTick,
	RaceStarted,
	CPProgess[MAX_PLAYERS],
	Position,
	FinishCount,
	JoinCount,
	rCounter,
	RaceTime,
	Text: RaceInfo[MAX_PLAYERS],
	InfoTimer[MAX_PLAYERS],
	RacePosition[MAX_PLAYERS],
	RaceNames[MAX_RACES][128],
 	TotalRaces,
 	bool: AutomaticRace,
 	TimeProgress
;
//----------------------------------------------------------
enum // Culori
{
	White       =   0xFFFFFFFF,
	Red         = 	0xE60000AA,
	Blue      	=	0x375FFFFF,
	Green       =	0x6FFF00AA,
	Gray     	=	0x9C9C9CFF,
	Yellow      =	0xFFFF00AA,
	Orange      =	0xFF9900AA,
	ColorChat   =   0x59C2ABFF,
	AdminColor  =   0x00C48DFF,
}

enum // Dialoguri
{
    D_Register,
	D_Login,
	D_WeaponSet,
	D_Rules,
	D_SvConfig,
	D_InfoAccount,
	D_RaceList
};

enum PLAYER_INFO
{
	Logged,
	Password[100],
	Admin,
	Level,
	Kills,
	Deaths,
	MutedTime,
	WeaponSet,
	Banned,
	PIP[16],
	RacePoints,

 	Float:P_ARMOUR,
	Float:P_HEALTH,
	P_SYNCALLOWED,
	P_INSYNC,
	P_SYNC_WEAP[MAX_WEAPON_SLOT],
	P_SYNC_AMMO[MAX_WEAPON_SLOT],
	
	M_1KILL,
	M_10KILLS,
	M_100KILLS,
	M_1000KILLS,
	
	M_1DEATH,
	M_10DEATHS,
	M_100DEATHS,
	M_1000DEATHS,
	
	M_HEADSHOT,
	M_DOUBLEKILL,
	M_TRIPEKILL
}

enum SERVER_INFO
{
	bool:ReadPMS,
	bool:ReadCMDS,
	SVWeather,
	SVTime,
	MaxPing,
	MinFps,
	MaxPL,
	bool:NetCheck,
	bool:ConnectMessages,
	bool:AntiCBug
}

enum SAZONE_MAIN
{
	SAZONE_NAME[28],
	Float:SAZONE_AREA[6]
};

enum Z_Info
{
    Float:zMinX,
    Float:zMinY,
    Float:zMaxX,
    Float:zMaxY
}

new
	PingWarns[MAX_PLAYERS],
	FpsWarns[MAX_PLAYERS],
	PLWarns[MAX_PLAYERS]
;

new Hours,Minutes,Segundos,Day,Month,Year;
new CheckLagPlayer[MAX_PLAYERS];
new bool:Autorizado[MAX_PLAYERS];
new bool:pAFK[MAX_PLAYERS];
new tAFK[MAX_PLAYERS];
new TimerAFK[MAX_PLAYERS];
new Reports[MAX_REPORTS][128];
new Flooder[MAX_PLAYERS];
new bool:AdminHide[MAX_PLAYERS];
new VotesNewMap = 0;
new bool:VoteON;
new bool:Voted[MAX_PLAYERS];
new Convidado[MAX_PLAYERS];
new EmDuelo[MAX_PLAYERS];
new Duel[MAX_PLAYERS];
new DuelWeapons[MAX_PLAYERS][2];
new PlayerInfo[MAX_PLAYERS][PLAYER_INFO];
new ServerInfo[SERVER_INFO];
new PasswordIncorret[MAX_PLAYERS];
new	Spree[MAX_PLAYERS];
new	CreatedVehicle[MAX_PLAYERS];
new bool:HitSound[MAX_PLAYERS];
new bool:AdminChangeArea = false;
new	pDrunkLevelLast[MAX_PLAYERS];
new	pFPS[MAX_PLAYERS];
new	area;
new inicio;
new	tbase;
new bool:Spawnado[MAX_PLAYERS];
new Float:pX;
new Float:pY;
new Float:pZ;
new Float:pF;
new DropLimit = 5; // above
new DeleteTime = 6; //above
new HealthPickup[MAX_PLAYERS];
new
	Text: textFPS[MAX_PLAYERS],
	Text: textFPSt[MAX_PLAYERS]
;
/*new NotMoving[MAX_PLAYERS];
new WeaponID[MAX_PLAYERS];*/
new CheckCrouch[MAX_PLAYERS];

new Text:Rampage[MAX_PLAYERS];
new	Text:Adrenaline[6];
new	Text:VoteMap[4];
new Text3D:pInfos[MAX_PLAYERS];
new	Text:Kill[MAX_PLAYERS];
new	Text:KillsSeguidos[MAX_PLAYERS];
new Text:Zone[MAX_PLAYERS];
new Text:Atingir[MAX_PLAYERS];
new Text:Atingido[MAX_PLAYERS];

new TempoMostrarLife[MAX_PLAYERS];
new MostrandoVida[MAX_PLAYERS];

new TempoMostrarLife2[MAX_PLAYERS];
new MostrandoVida2[MAX_PLAYERS];

stock const weaponObj[47] =
{
	325, 331, 333, 335, 336, 337, 338, 339, 341, 321,
	322, 323, 324, 325, 326, 342, 343, 344, 325, 325,
	325, 325, 346, 347, 348, 349, 350, 351, 352, 353,
	355, 356, 372, 357, 358, 359, 360, 361, 362, 363,
	364, 365, 366, 367, 368, 369, 371
};

enum e_PLAYER_DATA
{
	P_OBJ_TIMER[2],
	P_ARMAPLAYER
}
stock Player[MAX_PLAYERS][e_PLAYER_DATA];

new VehicleNames[212][] =
{
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
	{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
	{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
	{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
	{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
	{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
	{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
	{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
	{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
	{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
	{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
	{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
	{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
	{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
	{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
	{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
	{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
	{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
	{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
	{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
	{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
	{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
	{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
	{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
	{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
	{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
	{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
	{"Utility Trailer"}
};

new weaponNames[55][] =
{
	{"Punch"},{"Brass Knuckles"},{"Golf Club"},{"Nite Stick"},{"Knife"},{"Baseball Bat"},{"Shovel"},{"Pool Cue"},{"Katana"},{"Chainsaw"},{"Purple Dildo"},
	{"Smal White Vibrator"},{"Large White Vibrator"},{"Silver Vibrator"},{"Flowers"},{"Cane"},{"Grenade"},{"Tear Gas"},{"Molotov Cocktail"},
	{""},{""},{""}, // Empty spots for ID 19-20-21 (invalid weapon id's)
	{"Colt"},{"Silenced 9mm"},{"Deagle"},{"Shotgun"},{"Sawn-off"},{"Combat"},{"Micro SMG"},{"MP5"},{"AK-47"},{"M4"},{"Tec9"},
	{"Rifle"},{"Sniper"},{"Rocket"},{"HS Rocket"},{"Flamethrower"},{"Minigun"},{"Satchel Charge"},{"Detonator"},
	{"Spraycan"},{"Fire Extinguisher"},{"Camera"},{"Nightvision Goggles"},{"Thermal Goggles"},{"Parachute"}, {"Fake Pistol"},{""}, {"Vehicle"}, {"Helicopter Blades"},
	{"Explosion"}, {""}, {"Drowned"}, {"Collision"}
};


static const gSAZones[][SAZONE_MAIN] =
{
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};

// PalominioCreek
new Float:PalominioCreek[15][3] =
{
    {2156.5066,41.7807,26.3359},
	{2308.5085,114.6699,27.7341},
	{2428.8604,119.0436,26.4689},
	{2537.5042,58.0938,26.3365},
	{2397.9355,-22.4887,26.3307},
	{2240.2056,-69.9236,26.5077},
	{2256.7405,-74.7091,31.6016},
	{2323.4324,-43.5368,32.7277},
	{2322.1216,-123.7447,28.1536},
	{2439.1582,34.8691,26.4844},
	{2527.2646,34.2002,26.4844},
	{2550.3960,-7.7251,27.6756},
	{2324.2429,136.4271,28.4416},
	{2318.0542,23.8968,26.4766},
	{2253.9021,63.2286,29.4834}
};

//Arena Farm
new Float:ArenaFarm[14][3] =
{
    {-101.5579,-127.7706,3.1172},
	{-126.0069,-94.5780,6.4844},
	{-149.1780,-65.9923,3.1172},
    {-96.5858,-44.3701,3.1094},
	{-62.5416,-42.4035,3.1172},
	{-37.2023,-22.0126,3.1172},
    {-75.2416,7.8361,3.1172},
	{-93.4984,3.3210,6.4548},
	{-93.0743,57.5763,6.0763},
    {-53.7264,86.3917,3.1172},
	{-60.6580,142.6011,3.1172},
	{-14.9294,105.4311,3.1172},
    {-0.4140,63.1053,3.1172},
	{-41.0133,49.6987,5.9068}
};

//Area 51
new Float:Area51[15][3] =
{
    {249.4239,1800.3801,7.4141},
    {279.1605,1816.3639,1.0078},
    {289.1561,1815.3295,4.7266},
    {307.3394,1839.7416,7.7266},
    {277.3342,1836.4930,7.7266},
    {249.0877,1827.2548,7.5547},
    {241.6617,1812.9476,4.7109},
    {236.6451,1830.2229,7.4141},
    {219.3549,1822.8461,7.5725},
    {267.3355,1844.4585,7.3076},
    {249.5564,1866.9303,8.7578},
    {246.0587,1859.7797,14.0840},
    {241.4072,1879.5277,11.4609},
    {203.0457,1871.8285,13.1406},
    {215.8024,1853.8754,12.8366}
};

//LVPD
new Float:LVPD[17][3] =
{
    {297.5700,173.8816,1007.1719},
	{299.4489,191.2545,1007.1794},
	{267.8738,186.2940,1008.1719},
	{246.3554,186.1023,1008.1719},
	{257.9019,185.5921,1008.1719},
	{263.2933,171.4618,1003.0234},
	{252.7262,180.9050,1003.0234},
	{247.4364,143.9194,1003.0234},
	{230.1900,141.7465,1003.0234},
	{209.3498,142.2585,1003.0234},
	{219.7418,167.2396,1003.0234},
	{229.5028,182.6829,1003.0313},
	{223.5482,186.7878,1003.0313},
	{191.4252,179.0617,1003.0234},
	{190.5862,158.3047,1003.0234},
	{217.1430,158.1946,1003.0234},
	{231.5849,171.6475,1003.0234}
};

//Arena Depot
new Float:ArenaDepot[25][3] =
{
    {1753.6814,1119.1279,10.6755},
	{1696.1731,1119.7753,10.8203},
	{1650.7789,1118.3999,10.6868},
	{1664.1372,1087.6945,10.8203},
	{1595.4150,1117.3998,10.6714},
	{1588.7568,1074.1254,10.7363},
	{1629.3457,1055.8905,10.8203},
	{1687.2124,1036.9094,10.8203},
	{1749.8494,1046.5876,10.7092},
	{1751.8026,988.7004,10.6920},
	{1686.3513,986.8862,10.8203},
	{1636.7563,982.3732,10.8203},
	{1582.7733,996.6044,10.6823},
	{1584.4277,968.4046,10.6975},
	{1621.0507,949.1071,10.6793},
	{1662.9989,941.7299,10.6719},
	{1594.3246,919.4758,10.8203},
	{1582.6177,888.5183,10.6921},
	{1639.3669,888.0308,10.6881},
	{1687.1888,887.1895,10.6811},
	{1720.4691,889.2993,10.6986},
	{1752.6842,904.6794,10.6843},
	{1750.1646,952.3585,10.7064},
	{1729.5226,974.6152,10.8203},
	{1687.2157,997.1194,10.8203}
};

//LasPayasadas Arena
new Float:LasPayasadas[27][3] =
{
    {-217.6163,2591.1829,62.8582},
	{-257.3682,2589.1685,63.5703},
	{-280.4419,2599.2410,62.8582},
	{-312.7016,2635.6453,63.4051},
	{-312.3472,2660.2732,62.9231},
	{-317.9329,2705.6106,62.5351},
	{-297.4614,2704.6226,62.5391},
	{-274.7389,2676.0747,62.6313},
	{-251.5928,2675.5801,62.6875},
	{-227.7543,2692.8059,62.6875},
	{-202.9722,2684.4563,62.6835},
	{-173.5126,2683.3374,62.6836},
	{-135.1087,2697.0173,62.3488},
	{-133.2789,2721.1733,62.2097},
	{-132.7309,2746.7871,69.2639},
	{-160.0191,2765.6375,62.6797},
	{-175.2441,2764.3730,62.0148},
	{-201.4480,2750.6519,62.5391},
	{-215.9302,2734.3047,62.6875},
	{-237.7100,2731.4775,62.6875},
	{-261.1613,2772.1011,61.9662},
	{-279.8939,2766.2517,62.1014},
	{-297.2509,2761.1343,62.3236},
	{-288.4930,2732.5662,62.2108},
	{-297.5887,2716.1633,62.5090},
	{-295.2906,2677.9451,62.6280},
	{-288.1011,2662.8733,62.6653}
};

//AngelPine
new Float:AngelPine[47][3] =
{
	{-2141.7974,-2555.3098,30.6237},
	{-2104.0044,-2546.8069,30.6250},
	{-2152.7661,-2517.6201,30.4688},
	{-2202.0164,-2529.9836,30.5978},
	{-2240.9546,-2509.8547,30.9426},
	{-2255.7556,-2484.1790,29.7674},
	{-2258.9292,-2429.6194,31.9605},
	{-2252.2751,-2417.6729,31.9273},
	{-2215.3469,-2453.0593,31.3475},
	{-2198.1870,-2450.2612,30.7843},
	{-2172.4148,-2449.1277,30.4688},
	{-2152.7639,-2467.8806,30.6250},
	{-2142.3037,-2477.4175,30.4688},
	{-2119.7593,-2500.1477,30.6250},
	{-2100.1194,-2518.8862,30.5377},
	{-2079.0046,-2538.4104,30.4219},
	{-2067.6824,-2552.4150,30.6250},
	{-2047.6670,-2557.5850,30.6250},
	{-2027.1846,-2545.6545,30.6250},
	{-2022.4067,-2516.0422,32.9247},
	{-2047.7150,-2481.9077,30.4895},
	{-2064.6929,-2471.1965,30.4688},
	{-2063.8462,-2461.5347,30.6250},
	{-2067.5435,-2453.5610,30.6250},
	{-2093.2070,-2449.8027,30.4688},
	{-2151.1721,-2424.7104,30.4707},
	{-2181.4885,-2425.2153,30.6250},
	{-2201.1074,-2404.6365,30.4688},
	{-2204.5500,-2390.4705,30.8791},
	{-2228.4583,-2389.4819,31.7284},
	{-2200.1453,-2427.9817,30.7209},
	{-2202.3477,-2425.9421,30.6250},
	{-2146.3523,-2447.0583,30.6250},
	{-2113.4868,-2407.3572,31.3028},
	{-2076.5789,-2404.6626,30.6250},
	{-2087.2913,-2372.0122,30.6250},
	{-2021.7363,-2397.3267,30.6250},
	{-1989.8682,-2404.8750,35.6730},
	{-2057.7896,-2348.6960,40.8906},
	{-2098.0222,-2310.5522,30.4688},
	{-2126.0547,-2301.4102,30.6319},
	{-2095.9001,-2250.7771,30.6250},
	{-2135.3562,-2234.5737,30.4688},
	{-2164.9128,-2252.5837,30.4688},
	{-2202.1670,-2248.9797,33.3132},
	{-2208.4558,-2273.6169,30.4688},
	{-2256.7844,-2320.4756,29.1014}
};

//Doherty
new Float:Doherty[31][3] =
{
	{-2132.5071,-265.5921,35.3265},
	{-2151.0337,-276.4537,35.3203},
	{-2185.7134,-273.4570,35.3203},
	{-2193.4973,-254.4054,35.3203},
	{-2191.9080,-204.0591,35.3203},
	{-2185.2051,-209.8452,36.5156},
	{-2180.8733,-232.5103,36.5156},
	{-2157.2175,-232.3271,36.5156},
	{-2153.1257,-245.5145,36.5156},
	{-2177.7617,-241.7240,40.7195},
	{-2186.0273,-249.6289,40.7195},
	{-2169.0425,-254.1606,36.5156},
	{-2159.6563,-261.6309,36.5156},
	{-2185.0852,-260.3954,40.7195},
	{-2142.8801,-261.5756,40.7195},
	{-2140.8506,-242.3535,36.5156},
	{-2140.5564,-208.3757,35.3203},
	{-2099.1606,-196.1792,35.3203},
	{-2148.8174,-177.8822,35.3203},
	{-2154.2292,-159.1584,35.3203},
	{-2131.2336,-150.9294,35.3203},
	{-2104.6553,-146.7723,35.5114},
	{-2103.8489,-112.9033,35.3203},
	{-2099.1292,-94.4166,35.3273},
	{-2109.9348,-83.5231,35.3273},
	{-2133.0647,-95.9908,35.3203},
	{-2155.0381,-92.5815,35.3203},
	{-2154.9543,-119.2549,35.3273},
	{-2154.9468,-137.7552,35.3203},
	{-2152.4934,-162.0845,35.3203},
	{-2144.7295,-136.0682,36.5228}
};

//Willowfield
new Float:Willowfield[30][3] =
{
	{2501.8831,-2010.8625,13.2935},
	{2473.5107,-2039.5134,13.5500},
	{2454.3909,-2052.0630,11.2654},
	{2421.0505,-2032.9442,13.5469},
	{2387.1172,-2009.2441,13.5537},
	{2357.7744,-2026.9507,13.5949},
	{2424.0090,-2042.6464,22.2399},
	{2410.5762,-1978.8817,13.3657},
	{2357.4822,-1974.2474,13.3789},
	{2312.3989,-1960.8198,13.3910},
	{2284.5134,-1941.3436,13.5571},
	{2274.1296,-1916.6354,13.5469},
	{2273.7207,-1882.1818,14.2419},
	{2285.4546,-1871.0981,14.2344},
	{2321.8938,-1879.0858,13.5907},
	{2367.9802,-1881.2335,13.5537},
	{2375.5146,-1931.0891,13.5469},
	{2404.0632,-1925.1179,13.3828},
	{2402.3242,-1895.1412,13.3828},
	{2436.5188,-1934.9187,13.3265},
	{2456.9944,-1949.5049,13.6014},
	{2465.1836,-1953.5491,16.8357},
	{2509.6919,-1956.3439,16.8357},
	{2547.5471,-1906.1843,8.0654},
	{2495.9614,-1896.2511,25.5500},
	{2440.2605,-1891.9617,13.5534},
	{2410.3010,-1880.8093,13.3828},
	{2388.5713,-1875.3738,9.2734},
	{2402.0308,-1902.4116,14.4151},
	{2415.6641,-1858.0760,13.3828}
};

//Verdant Bluffs
new Float:VerdantBluffs[26][3] =
{
	{1027.2504,-2179.7688,40.4760},
	{1093.0579,-2199.7358,52.6042},
	{1120.7780,-2189.2117,62.1517},
	{1178.7931,-2223.0286,43.7623},
	{1160.9066,-2119.9187,69.6800},
	{1191.7966,-2091.2615,66.0088},
	{1124.5903,-2039.4802,69.8825},
	{1118.9214,-2065.1997,74.4297},
	{1115.4417,-2011.5352,74.4297},
	{1141.7914,-1990.5865,67.7085},
	{1190.0254,-1940.5928,35.7806},
	{1233.2972,-1953.4822,52.6403},
	{1252.1868,-2000.5870,59.3478},
	{1243.0537,-2022.9929,59.9117},
	{1260.8140,-2096.6812,57.0026},
	{1284.9994,-2139.0613,42.2297},
	{1351.9855,-2102.5610,46.9968},
	{1366.1947,-2082.7844,49.8037},
	{1452.7155,-2060.8538,38.3231},
	{1477.2782,-2021.4758,31.7932},
	{1454.3932,-1956.6770,26.8608},
	{1355.4678,-1952.7970,30.6060},
	{1266.5647,-1927.1620,29.8335},
	{1199.6010,-2021.7738,69.0078},
	{1210.7396,-2065.9119,69.0078},
	{1177.1073,-2084.0256,68.0485}
};

//Rodeo
new Float:Rodeo[24][3] =
{
	{619.2524,-1628.9204,16.7139},
	{647.9521,-1579.2069,15.6601},
	{588.3528,-1549.9379,15.4934},
	{611.8541,-1472.3025,14.5603},
	{589.3582,-1415.3354,13.7521},
	{612.1624,-1382.6434,13.7915},
	{651.9676,-1391.2457,13.5096},
	{692.2972,-1442.1981,14.8516},
	{692.3835,-1478.7183,12.2769},
	{723.0585,-1489.8057,1.9343},
	{750.1525,-1469.6381,7.7423},
	{727.7712,-1433.7964,13.5391},
	{724.8286,-1475.8207,17.6891},
	{792.8564,-1419.4203,13.3828},
	{723.8065,-1382.6541,25.7176},
	{777.5567,-1484.6040,13.6079},
	{809.0695,-1492.5266,13.5650},
	{798.3832,-1536.5557,13.5644},
	{772.3323,-1576.3947,13.3868},
	{758.0502,-1632.8477,7.8363},
	{788.1836,-1607.2971,13.3906},
	{822.8278,-1593.5508,13.5469},
	{813.7192,-1543.3459,13.5473},
	{804.0961,-1492.4131,13.5553}
};

//Industrial
new Float:Industrial[20][3] =
{
	{1580.6305,781.3664,10.8203},
	{1583.6993,739.7220,10.8203},
	{1582.7648,704.0415,10.7964},
	{1584.1304,669.1365,10.8203},
	{1624.1112,664.7440,10.8203},
	{1652.3425,664.8713,10.8203},
	{1678.1510,665.2595,10.8203},
	{1693.3228,684.3997,10.8203},
	{1713.1025,665.5720,10.8203},
	{1739.3066,665.0669,10.8203},
	{1743.1272,674.6530,10.8203},
	{1744.5902,692.2562,10.8203},
	{1750.7831,735.5437,10.8203},
	{1751.9342,773.9858,10.8203},
	{1733.5034,780.5518,10.8203},
	{1704.3507,778.6802,10.8203},
	{1654.5419,778.5571,10.8203},
	{1635.7433,760.9527,10.8203},
	{1622.0364,774.4764,10.8203},
	{1592.4254,777.9313,10.8203}
};

//Las Venturas
new Float:LasVenturas[33][3] =
{
	{1121.6366,2733.6035,10.8203},
	{1126.0249,2766.0508,10.7702},
	{1126.2072,2802.2717,10.8203},
	{1154.1272,2845.0596,10.8125},
	{1182.2855,2858.4155,10.8203},
	{1203.5355,2822.1204,10.5521},
	{1215.4503,2770.3252,10.8203},
	{1240.3636,2733.1843,10.8203},
	{1265.2155,2727.0200,10.8203},
	{1293.5785,2731.4927,10.8203},
	{1305.7566,2770.6748,10.8203},
	{1303.5984,2804.7444,10.8203},
	{1308.6024,2833.3032,10.8203},
	{1308.7871,2850.7542,10.7514},
	{1340.5894,2868.8088,10.5818},
	{1382.7501,2883.4739,9.8230},
	{1384.6340,2860.1487,10.8203},
	{1369.1691,2827.3643,10.8203},
	{1355.6997,2795.3613,10.5450},
	{1342.9967,2772.0227,10.8203},
	{1352.6621,2738.4136,10.8203},
	{1380.9612,2729.0444,10.8203},
	{1394.5975,2747.7881,10.8203},
	{1398.1393,2781.9580,10.8203},
	{1402.0657,2807.6421,10.8203},
	{1401.6003,2827.9189,10.8203},
	{1406.2603,2870.3860,10.7817},
	{1418.3235,2886.2524,10.2363},
	{1436.2161,2862.4338,10.8203},
	{1456.7190,2836.6523,10.8203},
	{1441.0887,2804.3721,21.2134},
	{1427.7505,2773.5281,14.8203},
	{1443.0308,2726.7126,10.8203}
};

//K.A.C.C
new Float:KACC[42][3] =
{
	{2508.7500,2708.1501,10.9844},
	{2537.6389,2711.4033,10.8203},
	{2578.9727,2735.6978,10.8203},
	{2562.5686,2769.1951,10.8203},
	{2567.4414,2799.2280,10.8203},
	{2535.0588,2807.0500,10.8203},
	{2504.4744,2822.7014,10.8203},
	{2507.5259,2844.1863,10.8203},
	{2535.6396,2854.4060,10.8203},
	{2544.6238,2806.5300,10.8203},
	{2579.6096,2806.0300,10.8203},
	{2603.1990,2814.4675,10.8203},
	{2587.2554,2836.7922,10.8203},
	{2603.8728,2841.3865,10.8203},
	{2615.7109,2831.2759,10.8203},
	{2623.2434,2841.2317,10.8203},
	{2611.0535,2801.4395,10.8203},
	{2649.8567,2780.5032,10.8203},
	{2665.7808,2750.0779,10.8203},
	{2667.8625,2713.3474,10.8203},
	{2657.6501,2691.3677,10.8203},
	{2651.7104,2776.2412,19.3222},
	{2642.5837,2766.0010,23.8222},
	{2594.2791,2757.7952,23.8222},
	{2611.7485,2723.0427,36.5386},
	{2642.4946,2731.4163,23.8222},
	{2598.0173,2849.1589,10.8203},
	{2560.7202,2853.8938,10.8203},
	{2618.2180,2846.0110,10.8203},
	{2641.6646,2847.3792,10.8203},
	{2696.3477,2846.7151,10.8203},
	{2720.6846,2852.8113,10.8203},
	{2738.4973,2827.4739,10.8203},
	{2711.9900,2797.4895,10.8203},
	{2697.3130,2767.3938,10.8203},
	{2676.8782,2722.9106,10.8203},
	{2676.4380,2680.8425,10.8203},
	{2689.8789,2667.3628,10.8203},
	{2682.2703,2631.4500,10.8203},
	{2637.3164,2642.9556,10.8203},
	{2550.2773,2665.1995,10.8203},
	{2516.2224,2699.4326,10.8130}
};

//Santa Floria
new Float:SantaFloria[36][3] =
{
	{-2519.9631,716.8359,27.9453},
	{-2527.6492,699.3946,28.5872},
	{-2527.6672,674.9827,28.1733},
	{-2529.2212,582.1650,15.0989},
	{-2529.9512,537.5163,14.4609},
	{-2542.2197,483.0375,14.6094},
	{-2585.1411,475.1626,14.6006},
	{-2629.9771,470.5179,14.4609},
	{-2686.2209,480.0679,5.9397},
	{-2716.8467,503.2776,7.4469},
	{-2723.8193,540.3210,12.5704},
	{-2747.8176,570.1629,14.3984},
	{-2749.1299,643.3036,28.0969},
	{-2748.0327,688.3871,41.1250},
	{-2717.3564,706.4645,40.9583},
	{-2678.1128,705.6959,28.7507},
	{-2657.3452,694.8886,27.9346},
	{-2616.9692,705.6172,27.8138},
	{-2576.9619,704.7220,27.8125},
	{-2555.6807,675.2952,27.8125},
	{-2551.0059,628.3259,27.8125},
	{-2583.1750,627.3350,27.8125},
	{-2607.2683,655.6686,21.3832},
	{-2627.6384,627.9734,14.4531},
	{-2662.1125,638.4531,14.4531},
	{-2682.1682,637.6761,14.4531},
	{-2701.4546,604.7379,14.4531},
	{-2704.1089,572.7441,14.5477},
	{-2657.8804,555.5624,14.6094},
	{-2623.4038,560.9962,14.4609},
	{-2610.3157,542.7294,14.4609},
	{-2570.4985,567.3666,14.4609},
	{-2547.3364,587.3425,14.4531},
	{-2582.1135,624.1359,14.4592},
	{-2568.5569,653.5236,14.4531},
	{-2592.8923,660.7014,14.4531}
};

//Dillimore
new Float:Dillimore[20][3] =
{
	{652.9257,-439.4167,16.3359},
	{676.4310,-447.3649,16.3359},
	{702.2845,-440.7105,16.3359},
	{723.4157,-441.3672,16.3359},
	{721.4241,-467.2227,16.3437},
	{728.1417,-499.0702,16.3359},
	{706.7456,-515.5920,19.8363},
	{693.4098,-507.8504,20.3363},
	{681.4891,-474.5877,16.5363},
	{680.7950,-464.2971,22.5705},
	{701.7301,-520.8088,16.3359},
	{674.9653,-522.3256,16.3281},
	{668.8997,-546.1472,16.3359},
	{628.0597,-571.8712,17.4067},
	{612.6452,-589.3669,17.2266},
	{612.1797,-608.5423,17.2266},
	{664.8586,-619.2724,16.3359},
	{666.2948,-581.3857,16.3359},
	{717.3547,-605.9651,16.3359},
	{738.3725,-588.8095,16.9908}
};

//Ocean Docks
new Float:OceanDocks[19][3] =
{
    {2734.4229,-2511.3472,13.6641},
	{2759.4927,-2535.8252,13.6348},
	{2732.1482,-2557.3262,13.6411},
	{2761.1133,-2569.1140,13.3322},
	{2808.4375,-2531.6729,13.6328},
	{2788.2637,-2484.5427,13.6497},
	{2787.7112,-2464.1499,13.6337},
	{2735.4822,-2465.7378,13.6484},
	{2744.2522,-2432.0471,13.6495},
	{2783.8015,-2440.0544,13.6346},
	{2797.9089,-2393.7151,13.9560},
	{2783.1726,-2385.8865,13.6276},
	{2797.7063,-2340.5352,13.6328},
	{2750.4683,-2350.5637,17.3403},
	{2694.9150,-2382.6682,17.3403},
	{2649.7869,-2431.2966,13.6328},
	{2628.3103,-2463.3069,13.3314},
	{2584.8787,-2504.0649,13.4922},
	{2669.7664,-2455.9565,13.6371}
};

//RockshoreEast
new Float:RockshoreEast[19][3] =
{
    {2671.9219,746.1770,10.8203},
	{2674.4431,729.0784,10.8203},
	{2656.0618,706.5021,10.8203},
	{2656.2939,715.3235,14.7396},
	{2635.1863,737.8536,10.8203},
	{2600.9875,748.2178,19.8303},
	{2592.0386,716.5038,11.0234},
	{2575.7175,705.5217,10.8203},
	{2555.9126,712.3346,11.0234},
	{2535.9607,710.9301,10.8203},
	{2532.9597,723.2748,12.6971},
	{2521.0916,728.7287,10.8203},
	{2524.2549,748.6713,10.8203},
	{2524.8101,761.6561,11.0234},
	{2556.7166,755.5114,11.0234},
	{2597.1606,743.5184,11.0234},
	{2626.6816,747.8964,10.8203},
	{2639.8010,748.5476,13.8722},
	{2614.3872,719.4459,10.8203}
};

//ElCorona
new Float:ElCorona[26][3] =
{
	{1814.4149,-1977.6150,13.5469},
	{1788.9468,-1977.8606,13.5351},
	{1790.6139,-2003.6256,13.4978},
	{1815.4932,-2045.8236,13.5469},
	{1849.3365,-2029.2345,13.5469},
	{1861.9583,-2030.8535,13.5469},
	{1856.9880,-2020.7670,13.5469},
	{1877.1062,-2007.7396,13.5469},
	{1882.9719,-1975.1620,13.5469},
	{1899.5348,-1978.6073,13.5469},
	{1924.5256,-1975.0347,13.5469},
	{1921.9769,-1992.8873,13.5469},
	{1916.4966,-2003.6945,13.5469},
	{1907.6512,-2044.2250,13.5469},
	{1894.9575,-2084.5134,15.0288},
	{1906.1335,-2072.6030,15.0331},
	{1859.1912,-2059.5447,13.5469},
	{1842.8762,-2068.9995,15.0312},
	{1830.9891,-2043.5923,13.5469},
	{1804.6658,-2058.6184,18.6873},
	{1872.8639,-1966.8430,18.6563},
	{1874.5138,-1953.2052,20.0703},
	{1903.2937,-1947.6837,13.5469},
	{1923.0852,-1955.9602,13.5547},
	{1940.7511,-1968.2543,16.1250},
	{1938.0826,-1985.1897,13.5469}
};

//----------------------------------------------------------
//
//  Callbacks e Main()
//
//----------------------------------------------------------

main()
{
    print("==================================================================");
    print(".");
	print("-      GAMEMODE     :       Battlefield");
	print("-      CREDITS      :       RBK BRIGADES ENTERPRISES");
	print("-      STATUS       :       Running");
	print(".");
	print("==================================================================");
}

AntiDeAMX()
{
    new a[][] =
	{
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

public OnGameModeInit()
{
	mysql = mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB,MYSQL_PAROLA);

	//if(mysql_errno() != 0)  print("Error database.");


	//Rcon protection
	SendRconCommand("rcon_password allahuahkbar1998");

    AdminChangeArea = false;
	area = random(19);
	ChangeArea();
	tbase = SetTimer("ChangeArea",600000,true);

    VotesNewMap = 0;
    VoteON = false;

	ServerInfo[ReadPMS] = true;
	ServerInfo[ReadCMDS] = true;
	ServerInfo[SVWeather] = 1;
	ServerInfo[SVTime] = 12;
	ServerInfo[MaxPing] = 320;
	ServerInfo[MinFps] = 35;
	ServerInfo[MaxPL] = 3;
	ServerInfo[NetCheck] = false;
	ServerInfo[ConnectMessages] = true;
	ServerInfo[AntiCBug] = false;

    
    if(!DOF2_FileExists("aka.txt")) DOF2_CreateFile("aka.txt");

	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	SetGameModeText("Battlefield: DeathMatch");
	
	for(new i; i != GetMaxPlayers(); ++i)
	{
		textFPS[i] = TextDrawCreate(575.0000, 51.0000, "~w~ ");
		TextDrawAlignment(textFPS[i], 3);
		TextDrawBackgroundColor(textFPS[i], 85);
		TextDrawFont(textFPS[i], 1);
		TextDrawLetterSize(textFPS[i], 0.1900, 0.8999);
		TextDrawColor(textFPS[i], -1);
		TextDrawSetOutline(textFPS[i], 1);
		TextDrawSetProportional(textFPS[i], 1);
		
		textFPSt[i] = TextDrawCreate(560.0000, 51.0000, "~r~FPS~w~:");
		TextDrawAlignment(textFPSt[i], 3);
		TextDrawBackgroundColor(textFPSt[i], 85);
		TextDrawFont(textFPSt[i], 1);
		TextDrawLetterSize(textFPSt[i], 0.190000, 0.899999);
		TextDrawColor(textFPSt[i], -1);
		TextDrawSetOutline(textFPSt[i], 1);
		TextDrawSetProportional(textFPSt[i], 1);
	}
	SetTimer("fpsCheck", 100, true);

	//Timers
	SetTimer("Update", 500, true);

	//Veh Palominio Creek
	AddStaticVehicleEx(411,2299.1072,-122.2888,27.1870,0.6695,64,1,120); // car 1
	AddStaticVehicleEx(468,2204.4519,-95.1147,27.1153,266.9292,46,46,120); // car 2
	AddStaticVehicleEx(421,2190.2966,-46.6692,27.3571,90.0452,13,1,120); // car 3
	AddStaticVehicleEx(560,2262.4136,61.0687,26.1892,269.6046,9,39,120); // car 4
	AddStaticVehicleEx(487,2265.0364,183.3166,27.6533,179.8492,29,42,120); // car 5
	AddStaticVehicleEx(413,2359.1804,124.3462,27.4238,90.0190,88,1,120); // car 6
	AddStaticVehicleEx(572,2447.3145,87.9202,27.1326,270.6007,101,1,120); // car 7
	AddStaticVehicleEx(481,2561.6643,5.6239,25.9935,90.1819,3,3,120); // car 8
	AddStaticVehicleEx(495,2444.0713,-52.4961,27.8172,0.3190,119,122,120); // car 9
	AddStaticVehicleEx(462,2433.6194,-1.2493,26.0828,183.1344,13,13,120); // car 10
	AddStaticVehicleEx(471,2312.8916,74.2925,29.1226,89.4264,103,111,120); // car 11

	//Veh Arena Farm
    AddStaticVehicleEx(422,-80.0079,91.7312,3.1077,336.8323,97,25,120); //
	AddStaticVehicleEx(422,-4.0894,155.1835,2.1889,238.7363,97,25,120); //
	AddStaticVehicleEx(421,-120.1923,-78.3088,3.0002,100.0204,25,1,120); //
	AddStaticVehicleEx(469,-28.3247,38.4472,3.1058,160.7275,1,3,120); //
	AddStaticVehicleEx(444,73.4317,-154.8546,1.7523,2.0763,32,42,120); //
	AddStaticVehicleEx(468,-62.3046,45.8695,6.1457,337.7945,46,46,120); //

	AddStaticVehicleEx(540,-2146.5198,-91.2262,41.4566,0.0513,53,53,120); // doherty
	AddStaticVehicleEx(462,-2191.2581,-115.2605,34.9206,268.6189,13,13,120); // doherty
	AddStaticVehicleEx(481,-2098.2202,-176.6363,34.8364,82.8348,3,3,120); // doherty
	AddStaticVehicleEx(443,-2023.0696,-94.6044,35.7978,270.7718,20,1,120); // doherty
	AddStaticVehicleEx(589,-2076.8545,-82.7518,34.8221,179.5013,31,31,120); // doherty


	AddStaticVehicleEx(487,1666.5114,1105.3989,18.9989,359.0067,29,42,120); // depot
	AddStaticVehicleEx(521,1633.3071,1072.0806,10.3886,183.5601,75,13,120); // depot
	AddStaticVehicleEx(560,1612.1028,928.5779,10.4485,270.0051,9,39,120); // depot
	AddStaticVehicleEx(404,1754.1422,897.3087,10.4785,181.0459,119,50,120); // depot


	AddStaticVehicleEx(568,-182.0000,2714.6062,62.4751,358.8790,9,39,120); // payasadas
	AddStaticVehicleEx(568,-333.3988,2683.9041,62.7487,182.9848,9,39,120); // payasadas
	AddStaticVehicleEx(471,-263.1293,2607.1531,62.3391,359.0808,120,114,120); // payasadas
	AddStaticVehicleEx(468,-229.5965,2722.6189,62.3566,1.2177,46,46,120); // payasadas
	AddStaticVehicleEx(412,-201.3300,2594.7458,62.5409,179.3117,10,8,120); // payasadas


	AddStaticVehicleEx(471,-2160.5151,-2459.2588,30.1084,51.1889,74,83,120); // angel pine
	AddStaticVehicleEx(555,-2154.7837,-2551.0044,30.3012,323.2134,58,1,120); // angel pine
	AddStaticVehicleEx(468,-2046.2590,-2524.8948,30.2926,49.1907,6,6,120); // angel pine
	AddStaticVehicleEx(408,-2206.1853,-2299.6011,31.1770,320.2086,26,26,120); // angel pine
	AddStaticVehicleEx(554,-2239.3237,-2476.6672,31.2625,142.4998,15,32,120); // angel pine
	AddStaticVehicleEx(543,-2118.0503,-2383.1074,30.3567,321.2944,32,8,120); // angel pine

	//Veh Willowfield
    AddStaticVehicleEx(522,2436.5039,-1798.8032,14.1379,183.7092,3,8,120);
	AddStaticVehicleEx(509,2380.5947,-1899.7489,13.0569,172.8883,74,1,120);
	AddStaticVehicleEx(560,2523.3721,-1888.8127,13.2513,358.7937,17,1,120);
	AddStaticVehicleEx(411,2496.8723,-2025.0712,13.2740,359.1042,123,1,120);
	AddStaticVehicleEx(468,2358.4531,-2021.0139,13.2229,7.2222,3,3,120);
	AddStaticVehicleEx(468,2298.3909,-1920.1804,13.2601,309.4111,3,3,120);
	AddStaticVehicleEx(468,2412.1116,-1828.0127,8.9419,264.2108,3,3,120);

	//Veh Verdant Bluffs
	AddStaticVehicleEx(451,1257.3136,-2010.6456,59.2029,177.8874,125,125,120);
	AddStaticVehicleEx(468,1318.9066,-2127.4927,42.6809,296.5912,53,53,120);
	AddStaticVehicleEx(481,1159.0930,-2139.6074,68.5690,23.6038,46,46,120);
	AddStaticVehicleEx(487,1117.6543,-2037.1469,78.4048,267.1473,3,29,120);
	AddStaticVehicleEx(506,1281.5486,-1916.4568,26.6288,82.5411,7,7,120);
	AddStaticVehicleEx(471,1483.8713,-1941.0471,24.5588,90.4709,120,112,120);

	//Veh Redeo
	AddStaticVehicleEx(522,858.9047,-1360.6973,13.3619,176.0242,6,25,120);
	AddStaticVehicleEx(482,755.8530,-1641.8860,6.0109,1.5711,48,48,120);
	AddStaticVehicleEx(493,726.0099,-1499.9084,-0.3198,95.4354,36,13,120);
	AddStaticVehicleEx(509,572.9722,-1388.2120,13.9222,269.8472,61,1,120);

	//Veh Industrial
    AddStaticVehicleEx(509,1621.8236,671.9279,10.3320,284.6404,16,1,120);
	AddStaticVehicleEx(471,1755.2578,752.8969,10.3018,86.9115,120,113,120);
	AddStaticVehicleEx(487,1634.1176,769.2473,18.9997,170.0227,26,57,120);
	AddStaticVehicleEx(481,1709.5967,668.5326,10.3388,179.2294,65,9,120);

	//Veh Santa Floria
	AddStaticVehicleEx(416,-2632.1914,627.2615,14.6022,179.5787,1,3,120); // santa floria
	AddStaticVehicleEx(416,-2707.2783,600.5861,14.6021,269.9418,1,3,120); // santa floria
	AddStaticVehicleEx(422,-2578.3716,473.2410,14.5137,88.4670,83,57,120); // santa floria
	AddStaticVehicleEx(506,-2645.2700,725.7231,27.6654,179.4655,6,6,120); // santa floria
	AddStaticVehicleEx(402,-2735.4543,721.0013,41.1050,359.6307,13,13,120); // santa floria
	AddStaticVehicleEx(481,-2552.8218,623.6324,27.3296,359.0045,3,3,120); // santa floria

	//Veh Dillimore
	AddStaticVehicleEx(589,755.6885,-581.8532,16.9921,88.8618,31,31,120); // dillimore
	AddStaticVehicleEx(521,752.5276,-494.3238,16.8868,0.1058,75,13,120); // dillimore
	AddStaticVehicleEx(412,666.8383,-464.5084,16.1737,89.2577,10,8,120); // dillimore
	AddStaticVehicleEx(523,626.4964,-584.0074,16.2838,263.7878,0,0,120); // dillimore

	//Veh Ocen Docks
	AddStaticVehicleEx(470,2788.5740,-2494.2234,13.6405,89.4233,43,0,120);
	AddStaticVehicleEx(433,2681.2146,-2532.8223,13.8222,359.3739,43,0,120);
	AddStaticVehicleEx(521,2770.7197,-2366.1621,13.1970,269.7591,87,118,120);

	//Arena 51
	CreateObject(980, 215.52490, 1875.79016, 12.83180,   0.00000, 0.00000, 0.00000);
	CreateObject(980, 226.37840, 1859.67725, 14.62040,   0.00000, 0.00000, 90.05990);

	//Rockshore
	AddStaticVehicleEx(521,2529.0310,706.7388,10.5927,266.8309,87,118,120); // rockshore
	AddStaticVehicleEx(510,2611.6353,755.3611,10.6318,358.6499,46,46,120); // rockshore

	//ElCorona
	AddStaticVehicleEx(405,1902.3575,-2057.4717,13.3345,269.3608,24,1,120); // elcorona
	AddStaticVehicleEx(458,1867.7563,-1966.7919,13.4255,270.8879,101,1,120); // elcorona
	AddStaticVehicleEx(402,1803.9091,-1911.3379,13.2283,269.5676,13,13,120); // elcorona
	AddStaticVehicleEx(515,1699.3175,-1972.8870,15.1408,358.1318,24,77,120); // elcorona

	//Server Skins
	for(new skins = 3; skins < 299; skins++)
	{
		AddPlayerClass(skins,0.0,0.0,0.0,0.0,0,0,0,0,0,0);
	}

	//TextDraws

	
	Adrenaline[1] = TextDrawCreate(142.000000, 392.000000, "_");
	TextDrawBackgroundColor(Adrenaline[1], 85);
	TextDrawFont(Adrenaline[1], 3);
	TextDrawLetterSize(Adrenaline[1], 0.500000, 1.400000);
	TextDrawColor(Adrenaline[1], -1);
	TextDrawSetOutline(Adrenaline[1], 1);
	TextDrawSetProportional(Adrenaline[1], 1);

	Adrenaline[2] = TextDrawCreate(156.000000, 406.000000, "~h~~r~~h~~h~Battlefield");
	TextDrawBackgroundColor(Adrenaline[2], 85);
	TextDrawFont(Adrenaline[2], 3);
	TextDrawLetterSize(Adrenaline[2], 0.509999, 1.600000);
	TextDrawColor(Adrenaline[2], -1);
	TextDrawSetOutline(Adrenaline[2], 1);
	TextDrawSetProportional(Adrenaline[2], 1);

	Adrenaline[3] = TextDrawCreate(135.000000, 421.000000, "~y~_________bf.rbkbrigades.com");
	TextDrawBackgroundColor(Adrenaline[3], 85);
	TextDrawFont(Adrenaline[3], 2);
	TextDrawLetterSize(Adrenaline[3], 0.210000, 1.000000);
	TextDrawColor(Adrenaline[3], -65281);
	TextDrawSetOutline(Adrenaline[3], 1);
	TextDrawSetProportional(Adrenaline[3], 1);

	Adrenaline[4] = TextDrawCreate(129.000000, 410.000000, "_");
	TextDrawBackgroundColor(Adrenaline[4], 85);
	TextDrawFont(Adrenaline[4], 2);
	TextDrawLetterSize(Adrenaline[4], 0.200000, 0.899999);
	TextDrawColor(Adrenaline[4], -1);
	TextDrawSetOutline(Adrenaline[4], 1);
	TextDrawSetProportional(Adrenaline[4], 1);

	Adrenaline[5] = TextDrawCreate(10.000000, 290.000000, "~r~Set your Spawn Weapons:~n~~w~/WeaponSet");
	TextDrawBackgroundColor(Adrenaline[5], 85);
	TextDrawFont(Adrenaline[5], 3);
	TextDrawLetterSize(Adrenaline[5], 0.429999, 1.799999);
	TextDrawColor(Adrenaline[5], -1);
	TextDrawSetOutline(Adrenaline[5], 1);
	TextDrawSetProportional(Adrenaline[5], 1);

	//Vote map Text Draws
	VoteMap[0] = TextDrawCreate(490.000000, 377.000000, ".");
	TextDrawBackgroundColor(VoteMap[0], 85);
	TextDrawFont(VoteMap[0], 1);
	TextDrawLetterSize(VoteMap[0], 0.000000, 5.999999);
	TextDrawColor(VoteMap[0], -1);
	TextDrawSetOutline(VoteMap[0], 1);
	TextDrawSetProportional(VoteMap[0], 1);
	TextDrawSetShadow(VoteMap[0], 1);
	TextDrawUseBox(VoteMap[0], 1);
	TextDrawBoxColor(VoteMap[0], 51);
	TextDrawTextSize(VoteMap[0], 624.000000, 0.000000);

	VoteMap[1] = TextDrawCreate(526.000000, 380.000000, "~r~Vote map");
	TextDrawBackgroundColor(VoteMap[1], 85);
	TextDrawFont(VoteMap[1], 2);
	TextDrawLetterSize(VoteMap[1], 0.280000, 1.100000);
	TextDrawColor(VoteMap[1], -1);
	TextDrawSetOutline(VoteMap[1], 1);
	TextDrawSetProportional(VoteMap[1], 1);
	TextDrawSetShadow(VoteMap[1], 1);

	VoteMap[2] = TextDrawCreate(491.000000, 396.000000, "~r~A Player ~w~started voting to change the map");
	TextDrawBackgroundColor(VoteMap[2], 85);
	TextDrawFont(VoteMap[2], 1);
	TextDrawLetterSize(VoteMap[2], 0.170000, 1.000000);
	TextDrawColor(VoteMap[2], -1);
	TextDrawSetOutline(VoteMap[2], 1);
	TextDrawSetProportional(VoteMap[2], 1);
	TextDrawSetShadow(VoteMap[2], 1);

	VoteMap[3] = TextDrawCreate(491.000000, 408.000000, "~w~Press (~r~Y~w~) to vote YES");
	TextDrawBackgroundColor(VoteMap[3], 85);
	TextDrawFont(VoteMap[3], 1);
	TextDrawLetterSize(VoteMap[3], 0.180000, 0.899999);
	TextDrawColor(VoteMap[3], -1);
	TextDrawSetOutline(VoteMap[3], 1);
	TextDrawSetProportional(VoteMap[3], 1);
	TextDrawSetShadow(VoteMap[3], 1);

	for(new m = 0; m < MAX_PLAYERS; m++)
	{

		//Races
		RaceInfo[m] = TextDrawCreate(630.000000, 345.000000, " ");
		TextDrawAlignment(RaceInfo[m], 3);
		TextDrawBackgroundColor(RaceInfo[m], 85);
		TextDrawFont(RaceInfo[m], 1);
		TextDrawLetterSize(RaceInfo[m], 0.240000, 1.100000);
		TextDrawColor(RaceInfo[m], -687931137);
		TextDrawSetOutline(RaceInfo[m], 1);
		TextDrawSetProportional(RaceInfo[m], 1);
		TextDrawSetShadow(RaceInfo[m], 1);

		Atingir[m] = TextDrawCreate(180.0,362.0, " ");
		TextDrawFont(Atingir[m], 1);
		TextDrawLetterSize(Atingir[m], 0.23000, 1.0);
		TextDrawBackgroundColor(Atingir[m], 85);
		TextDrawColor(Atingir[m], 16727295);
		TextDrawSetProportional(Atingir[m], 1);
		TextDrawSetOutline(Atingir[m],1);
		TextDrawSetShadow(Atingir[m],0);

		Atingido[m] = TextDrawCreate(400.0,362.0, " ");
		TextDrawFont(Atingido[m], 1);
		TextDrawLetterSize(Atingido[m], 0.23000, 1.0);
		TextDrawBackgroundColor(Atingido[m], 85);
		TextDrawColor(Atingido[m], 16727295);
		TextDrawSetProportional(Atingido[m], 1);
		TextDrawSetOutline(Atingido[m],1);
		TextDrawSetShadow(Atingido[m],0);

		Rampage[m] = TextDrawCreate(510.000000, 2.000000, "~w~Kills: ~y~~h~ ~w~Deaths: ~y~~h~ ~w~K/D: ~y~~h~");
		TextDrawBackgroundColor(Rampage[m], 85);
		TextDrawFont(Rampage[m], 1);
		TextDrawLetterSize(Rampage[m], 0.1900, 0.8999);
		TextDrawColor(Rampage[m], -1);
		TextDrawSetOutline(Rampage[m], 1);
		TextDrawSetProportional(Rampage[m], 1);

		Kill[m] = TextDrawCreate(300.000000, 130.000000, "~w~~h~+1");
		TextDrawBackgroundColor(Kill[m], 85);
		TextDrawFont(Kill[m], 2);
		TextDrawLetterSize(Kill[m], 0.559998, 1.799999);
		TextDrawColor(Kill[m], -1);
		TextDrawSetOutline(Kill[m], 1);
		TextDrawSetProportional(Kill[m], 1);

		KillsSeguidos[m] = TextDrawCreate(270.000000, 147.000000, "Double Kill!");
		TextDrawBackgroundColor(KillsSeguidos[m], 85);
		TextDrawFont(KillsSeguidos[m], 2);
		TextDrawLetterSize(KillsSeguidos[m], 0.319999, 1.899999);
		TextDrawColor(KillsSeguidos[m], -1);
		TextDrawSetOutline(KillsSeguidos[m], 1);
		TextDrawSetProportional(KillsSeguidos[m], 1);

		Zone[m] = TextDrawCreate(499.000000, 98.000000, "~w~Palominio Creek");
		TextDrawBackgroundColor(Zone[m], 85);
		TextDrawFont(Zone[m], 2);
		TextDrawLetterSize(Zone[m], 0.189999, 1.399999);
		TextDrawColor(Zone[m], -1);
		TextDrawSetOutline(Zone[m], 1);
		TextDrawSetProportional(Zone[m], 1);
	}
	return 1;
}

public OnGameModeExit()
{
	DOF2_Exit();
	BuildCreatedVehicle = (BuildCreatedVehicle == 0x01) ? (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00) : (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00);
	KillTimer(rCounter);
	KillTimer(CountTimer);
	Loop(i, MAX_PLAYERS)
	{
		DisablePlayerRaceCheckpoint(i);
		TextDrawDestroy(RaceInfo[i]);
		DestroyVehicle(CreatedRaceVeh[i]);
		Joined[i] = false;
		KillTimer(InfoTimer[i]);
	}
	JoinCount = 0;
	FinishCount = 0;
	TimeProgress = 0;
	AutomaticRace = false;
	for(new i; i != GetMaxPlayers(); ++i)
	{
	    TextDrawDestroy(textFPS[i]);
	    TextDrawDestroy(textFPSt[i]);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    static leban[90],lep[16],banSTR[64];
	GetPlayerIp(playerid,lep,sizeof(lep));

	format(leban,sizeof(leban),"SELECT * FROM bans WHERE nick = '%s' OR ip = '%s'",nome(playerid),lep);

	mysql_query(mysql, leban);
	mysql_store_result();

	if(mysql_num_rows() > 0)
	{
		static result[100],admin[25],reason[40],day,month,year,hour,minutes;

		if(mysql_fetch_row(result))
		{
			sscanf(result,"p<|>s[25]s[40]ddddd",admin,reason,day,month,year,hour,minutes);
		}

		static str[1024];

		format(str,sizeof(str),"{FF0000}Reason: {FFFFFF}%s\n",reason);
		format(str,sizeof(str),"{FF0000}Date: {FFFFFF}%02d/%02d/%d\n\n",day,month,year);
		format(str,sizeof(str),"{FF0000}Time: {FFFFFF}%02d:%02d\n",hour,minutes);
		ShowPlayerDialog(playerid,225,DIALOG_STYLE_MSGBOX,"Your ip is banned from this server!",str,"Leave","");

		format(banSTR,sizeof(banSTR),"%s leaved the server (IP BANNED)",nome(playerid));
		SendAdminMessage(Yellow,banSTR);

		Kick(playerid);
		writeLog(AdminLog,banSTR);
		return 0;
	}
	
	mysql_free_result();

    Spawnado[playerid] = false;

	SetPlayerPos(playerid, 1384.887084, 2185.860595, 11.023437);
	SetPlayerCameraPos(playerid, 1382.106933, 2182.984619, 11.023437);
	SetPlayerCameraLookAt(playerid, 1384.887084, 2185.860595, 11.023437);
	SetPlayerFacingAngle(playerid, 135.970474);
	TextDrawShowForPlayer(playerid, Text:Adrenaline[5]);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(PlayerInfo[playerid][Logged] == 0)
    {
       SendClientMessage(playerid,Red,"You need to login first!");
       return 0;
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
	
	pDrunkLevelLast[playerid] = 0;
    pFPS[playerid] = 0;
    Spawnado[playerid] = false;
    EmDuelo[playerid] = 0;
    Duel[playerid] = 998;
    HitSound[playerid] = false;
    PlayerInfo[playerid][P_SYNCALLOWED] = true;
    PlayerInfo[playerid][P_INSYNC] = false;
    Convidado[playerid] = 0;
    Voted[playerid] = false;
    pAFK[playerid] = false;
    AdminHide[playerid] = false;
    HitSound[playerid] = true;
    Autorizado[playerid] = false;
    PingWarns[playerid] = 0;
	FpsWarns[playerid] = 0;
	PLWarns[playerid] = 0;
    ResetVariables(playerid);

    InterpolateCameraPos(playerid, 1230.860473, 2189.489257, 45.712779, 1373.208496, 2174.499267, 14.125437, 10000);
	InterpolateCameraLookAt(playerid, 1225.864501, 2189.488037, 45.511535, 1376.762573, 2177.966552, 13.537010, 10000);

    for(new i = 0; i < 100; i++) { SendClientMessage(playerid,-1,""); }
	SendClientMessage(playerid, 0xACCD68FF, " » Battlefield © 2015 {FFFFFF}Powered by RBK");
	SendClientMessage(playerid, 0xACCD68FF, " » Site: {FFFFFF}bf.rbkbrigades.com - suggestions are welcome");
	SendClientMessage(playerid, 0xACCD68FF, " » /CMDS {FFFFFF}for all server commands");

	// Player registered or not
	
	if(PlayerInfo[playerid][Logged] == 0)
	{
		new lol[69];

		format(lol, sizeof(lol),"SELECT * FROM `accounts` WHERE `Username` = '%s'",nome(playerid));

		mysql_query(mysql, lol);
		mysql_store_result();

		if(mysql_num_rows() != 0)
		{
			ShowPlayerDialog(playerid,D_Login,DIALOG_STYLE_PASSWORD,"Login","Enter a password for Login","Login","Leave");
		}
		else
		{
	    	ShowPlayerDialog(playerid,D_Register,DIALOG_STYLE_PASSWORD,"Register","Enter a password to Register","Register","Leave");
		}
		mysql_free_result();
	}
	else
	{
		PlayerInfo[playerid][Logged] = 1;
	}
	
	//Not working yet
	/*if(fexist("aka.txt"))
	{
		new File:AkaList = fopen("aka.txt", io_readwrite);
		if(flength(AkaList) > 153600)
		{
			fclose(AkaList);
			fremove("aka.txt");
			AkaList = fopen("aka.txt", io_write);
			fwrite(AkaList," ");
			print("[MANUTENÇÃO]: AKA LIMPO AUTOMATICAMENTE POR PASSAR DE 150 KB");
		}
		fclose(AkaList);
	}*/
	
	new string[128], str[128], tmp3[50];
	GetPlayerIp(playerid,tmp3,50);

	if(ServerInfo[ConnectMessages] == true)
	{
	    new pAKA[256]; pAKA = DOF2_GetString("aka.txt",tmp3);

		if(strlen(pAKA) < 3) format(str,sizeof(str),"*** %s (%d) joined the server", nome(playerid), playerid);

		else if(!strcmp(pAKA,nome(playerid),true)) format(str,sizeof(str),"*** %s (%d) joined the server", nome(playerid), playerid);

		else format(str,sizeof(str),"*** %s (%d) joined the server (aka %s)", nome(playerid), playerid, pAKA );

		for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i)
		{
			if(PlayerInfo[i][Admin] > 1) SendClientMessage(i,Gray,str);
			else
			{
				format(string,sizeof(string),"*** %s (%d) joined the server", nome(playerid), playerid);
			 	SendClientMessage(i,Gray,string);
			}
		}
	}

	if(strlen(DOF2_GetString("aka.txt",tmp3)) == 0) DOF2_SetString("aka.txt", tmp3, nome(playerid));
 	else
	{
	    if(strfind(DOF2_GetString("aka.txt", tmp3), nome(playerid), true) == -1 )
		{
		    format(string,sizeof(string),"%s,%s", DOF2_GetString("aka.txt",tmp3), nome(playerid));
		    DOF2_SetString("aka.txt", tmp3, string);
		}
	}

	if(PlayerInfo[playerid][MutedTime] > 0)
	{
 		SendClientMessage(playerid,Red,"You are still muted!");
 		SetTimerEx("DesmutarPlayer",PlayerInfo[playerid][MutedTime]*1000*60,0,"d",playerid);
	}

	SetPlayerWeather(playerid, ServerInfo[SVWeather]);
 	SetPlayerTime(playerid, ServerInfo[SVTime], 0);
 	
 	CheckLagPlayer[playerid] = SetTimerEx("CheckLag", 950, true, "i", playerid);
 	GetPlayerPos(playerid,pX,pY,pZ);
	pInfos[playerid] = Create3DTextLabel("", -1, pX, pY, pZ, 15.0, 0, 0);
	Attach3DTextLabelToPlayer(pInfos[playerid], playerid, 0.0, 0.0, -1.0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerInfo[playerid][Logged] == 1)
	{
		SalvarPlayer(playerid);
	}

	TextDrawHideForPlayer(playerid, Adrenaline[1]);
	TextDrawHideForPlayer(playerid, Adrenaline[2]);
	TextDrawHideForPlayer(playerid, Adrenaline[3]);
	TextDrawHideForPlayer(playerid, Adrenaline[4]);
    Delete3DTextLabel(pInfos[playerid]);
	TextDrawHideForPlayer(playerid, Rampage[playerid]);
	TextDrawHideForPlayer(playerid, Kill[playerid]);
	TextDrawHideForPlayer(playerid, KillsSeguidos[playerid]);
	TextDrawHideForPlayer(playerid, Zone[playerid]);
	new str[130];
	switch (reason)
	{
        case 0: format(str, sizeof(str), "*** %s(%d) leaved the server (CRASH/TIMEOUT)", nome(playerid), playerid);
        case 1: format(str, sizeof(str), "*** %s(%d) leaved the server (LEAVE)", nome(playerid), playerid);
        case 2: format(str, sizeof(str), "*** %s(%d) leaved the server (KICK/BAN)", nome(playerid), playerid);
 	}
	SendAdminMessage(Gray,str);
	
    KillTimer(CheckLagPlayer[playerid]);
    
    //Races
    if(Joined[playerid] == true)
    {
		JoinCount--;
		Joined[playerid] = false;
		DestroyVehicle(CreatedRaceVeh[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		TextDrawHideForPlayer(playerid, RaceInfo[playerid]);
		CPProgess[playerid] = 0;
		KillTimer(InfoTimer[playerid]);
		#if defined RACE_IN_OTHER_WORLD
		SetPlayerVirtualWorld(playerid, 0);
		#endif
	}
	TextDrawDestroy(RaceInfo[playerid]);
	if(BuildRace == playerid+1) BuildRace = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerColor(playerid,0xFFFFFFFF);
	SetPVarInt(playerid, "spawned", true);
	AntiDeAMX();

	SetPlayerRandomPos(playerid);
	SetPlayerVirtualWorld(playerid,0);

	TextDrawHideForPlayer(playerid, Text:Adrenaline[5]);

	if(PlayerInfo[playerid][P_INSYNC] == 0) SetPlayerHealth(playerid,100.0);

	if(PlayerInfo[playerid][WeaponSet] != 0)
	{
		GivePlayerWeaponSet(playerid);
	}
	else
	{
		GivePlayerRandomWeapons(playerid);
	}

	EmDuelo[playerid] = 0;
	Duel[playerid] = 998;

	PlayerInfo[playerid][Logged] = 1;

 	SetPlayerChatBubble(playerid, "", 0xFF0000FF, 0.0, 0);
 	Spawnado[playerid] = true;
 	
 	TextDrawShowForPlayer(playerid, Adrenaline[1]);
	TextDrawShowForPlayer(playerid, Adrenaline[2]);
	TextDrawShowForPlayer(playerid, Adrenaline[3]);
	TextDrawShowForPlayer(playerid, Adrenaline[4]);
	TextDrawShowForPlayer(playerid, Rampage[playerid]);
	TextDrawShowForPlayer(playerid, Zone[playerid]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid,playerid,reason);
    SetPVarInt(playerid, "spawned", false);

	Spawnado[playerid] = false;

	PlayerInfo[killerid][Kills] ++;
	Spree[killerid] ++;

	PlayerInfo[playerid][Deaths] ++;
	Spree[playerid] = 0;


	new Float:x, Float:y, Float:z,Float:health;
	GetPlayerPos(playerid, x, y, z);
    GetPlayerHealth(killerid,health);

	HealthPickup[playerid] = CreatePickup(1240, 3, x-3, y, z, 0);
	SetTimerEx("HealthPickupDelete", 5000, false, "d", HealthPickup[playerid]);

	DropPlayerWeapons(playerid);

    if(EmDuelo[killerid] == 1 && EmDuelo[playerid] == 1)
    {
		new duelSTR[200];

		new Float:H,Float:A;
  		GetPlayerHealth(killerid,H);
  		GetPlayerArmour(killerid,A);

		EmDuelo[killerid] = 0;
		EmDuelo[playerid] = 0;
		Duel[killerid] = 998;
		Duel[playerid] = 998;

        SetPlayerArmour(playerid, 0.0);
        SetPlayerArmour(killerid, 0.0);

		SpawnPlayer(killerid);

		format(duelSTR,sizeof(duelSTR),"*** %s defeated %s in duel! (HP: %0.2f) ***",nome(killerid),nome(playerid),H+A);
		SendClientMessageToAll(0xD5D48FFF,duelSTR);
	}

    if(IsPlayerInAnyVehicle(killerid))
    {
        new string[256];

        SetPlayerHealth(killerid, 0);
        format(string, sizeof(string),"** %s leaved the server (CARKILL) **",nome(killerid));
        SendClientMessageToAll(Red, string);
        Kick(killerid);
    }

    new String[100];
    if(PlayerInfo[killerid][Kills] == 100 || PlayerInfo[killerid][Kills] == 200 || PlayerInfo[killerid][Kills] == 300 || PlayerInfo[killerid][Kills] == 400 || PlayerInfo[killerid][Kills] == 500 || PlayerInfo[killerid][Kills] == 600 || PlayerInfo[killerid][Kills] == 700 || PlayerInfo[killerid][Kills] == 800 || PlayerInfo[killerid][Kills] == 900 || PlayerInfo[killerid][Kills] == 1000 || PlayerInfo[killerid][Kills] == 1100 || PlayerInfo[killerid][Kills] == 1200 || PlayerInfo[killerid][Kills] == 1300
	|| PlayerInfo[killerid][Kills] == 1400 || PlayerInfo[killerid][Kills] == 1500 || PlayerInfo[killerid][Kills] == 1600 || PlayerInfo[killerid][Kills] == 1700 || PlayerInfo[killerid][Kills] == 1800 || PlayerInfo[killerid][Kills] == 1900 || PlayerInfo[killerid][Kills] == 2000
	|| PlayerInfo[killerid][Kills] == 2100 || PlayerInfo[killerid][Kills] == 2200 || PlayerInfo[killerid][Kills] == 2300 || PlayerInfo[killerid][Kills] == 2400 || PlayerInfo[killerid][Kills] == 2500 || PlayerInfo[killerid][Kills] == 2600 || PlayerInfo[killerid][Kills] == 2700 || PlayerInfo[killerid][Kills] == 2800 || PlayerInfo[killerid][Kills] == 2900 || PlayerInfo[killerid][Kills] == 3000)
	{
	   	SetPlayerScore(killerid,GetPlayerScore(killerid) +1);
	   	PlayerInfo[killerid][Level] = GetPlayerScore(killerid);
		format(String,sizeof(String),"LEVEL UP! {D5D48F}%s {FFFFFF}you just level up {D5D48F}%i.",nome(killerid),GetPlayerScore(killerid));
		SendClientMessageToAll(-1,String);
		GameTextForPlayer(killerid, "~r~] ~y~level up! ~r~]", 3000, 3);

		GetPlayerPos(killerid, x, y, z);
		SetPlayerPos(killerid, x, y, z+2);

		PlayerPlaySound(killerid,1054,0.0,0.0,0.0);
	}
	
	TextDrawShowForPlayer(killerid,Kill[killerid]);
	SetTimerEx("ApagaText1", 1000, false, "i", killerid);

	//===================================MISSOES================================
	/*
	//Kills
	if(PlayerInfo[killerid][M_1KILL] == 0)
	{
	    PlayerInfo[killerid][M_1KILL] = 1;
	    SendClientMessage(killerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}FRIST BLOOD.");
	}
	if(PlayerInfo[killerid][M_10KILLS] == 0)
	{
	    PlayerInfo[killerid][M_10KILLS] = 1;
	    SendClientMessage(killerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}TRYING TO BE A KILLER (10 Kills).");
	}
    if(PlayerInfo[killerid][M_100KILLS] == 0)
	{
	    PlayerInfo[killerid][M_100KILLS] = 1;
	    SendClientMessage(killerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}JUNIOR KILLER (100 Kills).");
	}
    if(PlayerInfo[killerid][M_1000KILLS] == 0)
	{
	    PlayerInfo[killerid][M_1000KILLS] = 1;
	    SendClientMessage(killerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}BLOOD KILLER (1000 Kills).");
	}
	
	//Deaths
	if(PlayerInfo[playerid][M_1DEATH] == 0)
	{
	    PlayerInfo[playerid][M_1DEATH] = 1;
	    SendClientMessage(playerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}FRIST DEATH.");
	}
	if(PlayerInfo[playerid][M_10DEATHS] == 0)
	{
	    PlayerInfo[playerid][M_10DEATHS] = 1;
	    SendClientMessage(playerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}BEING NOOB (10 Deaths).");
	}
    if(PlayerInfo[playerid][M_100DEATHS] == 0)
	{
	    PlayerInfo[playerid][M_100DEATHS] = 1;
	    SendClientMessage(playerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}PRO NOOB (100 Deaths).");
	}
    if(PlayerInfo[playerid][M_1000DEATHS] == 0)
	{
	    PlayerInfo[playerid][M_1000DEATHS] = 1;
	    SendClientMessage(playerid, -1, "{375FFF}[Missão]: {FFFFFF}Você acaba de completar a missão {FF0000}NEWBIE (1000 Deaths).");
	}
	*/
 	//===========================================================================

	if(Spree[killerid] == 2)
	{
		TextDrawSetString(KillsSeguidos[killerid],"Double Kill!");
		TextDrawShowForPlayer(killerid,KillsSeguidos[killerid]);
	}
	if(Spree[killerid] == 3)
	{
		TextDrawSetString(KillsSeguidos[killerid],"Triple Kill!");
   		TextDrawShowForPlayer(killerid,KillsSeguidos[killerid]);
 	}
	if(Spree[killerid] == 4)
	{
 		TextDrawSetString(KillsSeguidos[killerid],"Mega Kill!");
		TextDrawShowForPlayer(killerid,KillsSeguidos[killerid]);
	}
	if(Spree[killerid] == 5)
	{
 		TextDrawSetString(KillsSeguidos[killerid],"Ultra Kill!");
 		TextDrawShowForPlayer(killerid,KillsSeguidos[killerid]);
	}
	if(Spree[killerid] == 6)
	{
 		TextDrawSetString(KillsSeguidos[killerid],"Killing Spree!");
   		TextDrawShowForPlayer(killerid,KillsSeguidos[killerid]);
	}

	SetTimerEx("SpreeKilling", 7000, false, "i", killerid);
	SetTimerEx("ApagaTextSpree", 500, false, "i", killerid);
	
	TextDrawHideForPlayer(playerid, Adrenaline[1]);
	TextDrawHideForPlayer(playerid, Adrenaline[2]);
	TextDrawHideForPlayer(playerid, Adrenaline[3]);
	TextDrawHideForPlayer(playerid, Adrenaline[4]);
	TextDrawHideForPlayer(playerid, Rampage[playerid]);
	TextDrawHideForPlayer(playerid, Zone[playerid]);

	//Races
	if(Joined[playerid] == true)
    {
		JoinCount--;
		Joined[playerid] = false;
		DestroyVehicle(CreatedRaceVeh[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		TextDrawHideForPlayer(playerid, RaceInfo[playerid]);
		CPProgess[playerid] = 0;
		KillTimer(InfoTimer[playerid]);
		#if defined RACE_IN_OTHER_WORLD
		SetPlayerVirtualWorld(playerid, 0);
		#endif
	}
	if(BuildRace == playerid+1) BuildRace = 0;
	return 1;
}

forward ApagaText1(playerid);
public ApagaText1(playerid)
{
	TextDrawHideForPlayer(playerid,Kill[playerid]);
	return 1;
}

forward ApagaTextSpree(playerid);
public ApagaTextSpree(playerid)
{
	TextDrawHideForPlayer(playerid,KillsSeguidos[playerid]);
	return 1;
}

forward SpreeKilling(playerid);
public SpreeKilling(playerid)
{
    Spree[playerid] = 0;
    SetPlayerWantedLevel(playerid,0);
	return 1;
}

forward HideTextoLife(playerid);
public HideTextoLife(playerid)
{
	if(MostrandoVida[playerid] == 1)
	{
		TextDrawHideForPlayer(playerid, Atingir[playerid]);
		MostrandoVida[playerid] = 0;
	}
	return 1;
}

forward HideTextoLife2(playerid);
public HideTextoLife2(playerid)
{
	if(MostrandoVida2[playerid] == 1)
	{
  		TextDrawHideForPlayer(playerid, Atingido[playerid]);
		MostrandoVida2[playerid] = 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(pAFK[playerid] == true) return SendClientMessage(playerid, Red, "You cant use commands in AFK mode.\nType /afk for leave AFK mode.");

    //================ [ Read Comamands ] ===========================//
	if(ServerInfo[ReadCMDS] == true)
	{
	    new string[256];
		format(string, sizeof(string), "%s (ID: %d) typed: %s", nome(playerid),playerid,cmdtext);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if((PlayerInfo[i][Admin] > PlayerInfo[playerid][Admin]) && (PlayerInfo[i][Admin] > 1) && (i != playerid))
				{
					SendClientMessage(i, Gray, string);
				}
			}
		}
	}
	return 0;
}

public OnPlayerText(playerid, text[])
{
    if(pAFK[playerid] == true)
	{
 		SendClientMessage(playerid, Red, "You cant use chat in AFK mode.\nType /afk for leave AFK mode.");
		return 0;
	}

    if(Flooder[playerid] > gettime())
	{
		SendClientMessage(playerid,Gray,"Type slowly, don't flood!");
		return 0;
 	}
   	Flooder[playerid] = gettime()+3;

    if(PlayerInfo[playerid][MutedTime] >= 1)
	{
        SendClientMessage(playerid,Red,"You're muted bro.. :(");
        return 0;
    }

    if(text[0] == '#' && PlayerInfo[playerid][Admin] >= 1)
	{
        new string[140];
        format(string,sizeof(string),"{C4C4C4}(Admin Chat) {00C48D}%s: {C4C4C4}%s",nome(playerid),text[1]);
        SendAdminMessage(AdminColor,string);
    	return 0;
	}
	return 1;
}

Float:GetPlayerPacketloss( playerid )
{
    new pack[ 280 ], pa[ 12 ];

    GetPlayerNetworkStats( playerid, pack, 280 );
    new packet = strfind( pack, "Packetloss:");
	strmid( pa, pack, ( packet + 11 ), 280 );
	return floatstr( pa );
}

public OnPlayerUpdate(playerid)
{
    /*new Keys, ud, lr;
    GetPlayerKeys(playerid, Keys, ud, lr);
    if(CheckCrouch[playerid] == 1)
	{
 		switch(WeaponID[playerid])
		{
  			case 23..25, 27, 29..34, 41:
  			{
     			if(ServerInfo[AntiCBug] == true && (Keys & KEY_CROUCH) && !((Keys & KEY_FIRE) || (Keys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK )
				{
    				ApplyAnimation(playerid,"PED","handsup",4.1,0,0,0,0,0);
        		}
          		//else SendClientMessage(playerid, COLOR_RED, "Failed in onplayer update");
          	}
		}
  	}
  	*/
	//if(!ud && !lr)
	//{
		//NotMoving[playerid] = 1; /*OnPlayerKeyStateChange(playerid, Keys, 0);*/
	//}
	//else
	//{
		//NotMoving[playerid] = 0; /*OnPlayerKeyStateChange(playerid, Keys, 0);*/
	//}

    // handle fps counters.
    new drunknew;
    drunknew = GetPlayerDrunkLevel(playerid);

    if(drunknew < 100)
	{ // go back up, keep cycling.
        SetPlayerDrunkLevel(playerid, 2000);
    }
	else
	{
        if(pDrunkLevelLast[playerid] != drunknew)
		{
            new wfps = pDrunkLevelLast[playerid] - drunknew;

            if((wfps > 0) && (wfps < 200))
                pFPS[playerid] = wfps;

            pDrunkLevelLast[playerid] = drunknew;
        }
    }
    new pInfosStr[64];
	GetPlayerPos(playerid,pX,pY,pZ);
	format(pInfosStr, sizeof pInfosStr, "{00DE00}Ping: {FFFFFF}%d\n{00DE00}Fps: {FFFFFF}%d", GetPlayerPing(playerid), pFPS[playerid]);
	Update3DTextLabelText(pInfos[playerid], 0xFFFFFFFF, pInfosStr);
	new Float:phealth;
	GetPlayerHealth(playerid,phealth);
	if(phealth > 100.0) return SetPlayerHealth(playerid,99.9);
	
	new str[1024];
	new ip[16];
	GetPlayerIp(playerid,ip,sizeof(ip));

	format(str,sizeof(str),"UPDATE `accounts` SET Ip = '%s', Admin = %d, Level = %d, Kills = %d, Deaths = %d, MutedTime = %d, WeaponSet = %d, Banned = %d, RacePoints = '%d' WHERE `Username` = '%s'",

	ip,
	PlayerInfo[playerid][Admin],
	PlayerInfo[playerid][Level],
	PlayerInfo[playerid][Kills],
	PlayerInfo[playerid][Deaths],
	PlayerInfo[playerid][MutedTime],
	PlayerInfo[playerid][WeaponSet],
    PlayerInfo[playerid][Banned],
    PlayerInfo[playerid][RacePoints],
	nome(playerid)
	);
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(CPProgess[playerid] == TotalCP -1)
	{
		new
		    TimeStamp,
		    TotalRaceTime,
		    string[256],
		    rFile[256],
		    pName[MAX_PLAYER_NAME],
			rTime[3],
			Prize[2],
			TempTotalTime,
			TempTime[3]
		;
		Position++;
		GetPlayerName(playerid, pName, sizeof(pName));
		TimeStamp = GetTickCount();
		TotalRaceTime = TimeStamp - RaceTick;
		ConvertTime(var, TotalRaceTime, rTime[0], rTime[1], rTime[2]);
		switch(Position)
		{
		    case 1: /*Prize[0] = (random(random(5000)) + 10000),*/ Prize[1] = 10;
		    case 2: /*Prize[0] = (random(random(4500)) + 9000),*/ Prize[1] = 9;
		    case 3: /*Prize[0] = (random(random(4000)) + 8000),*/ Prize[1] = 8;
		    case 4: /*Prize[0] = (random(random(3500)) + 7000),*/ Prize[1] = 7;
		    case 5: /*Prize[0] = (random(random(3000)) + 6000),*/ Prize[1] = 6;
		    case 6: /*Prize[0] = (random(random(2500)) + 5000),*/ Prize[1] = 5;
		    case 7: /*Prize[0] = (random(random(2000)) + 4000),*/ Prize[1] = 4;
		    case 8: /*Prize[0] = (random(random(1500)) + 3000),*/ Prize[1] = 3;
		    case 9: /*Prize[0] = (random(random(1000)) + 2000),*/ Prize[1] = 2;
		    default: /*Prize[0] = random(random(1000)),*/ Prize[1] = 1;
		}
		format(string, sizeof(string), ">> \"%s\" Finished race, his place is \"%d\".", pName, Position);
		SendClientMessageToAll(White, string);
		format(string, sizeof(string), "    - Time: \"%d:%d.%d\".", rTime[0], rTime[1], rTime[2]);
		SendClientMessageToAll(White, string);
		format(string, sizeof(string), "    - Reward: \"+%d Race Points\".", /*Prize[0],*/ Prize[1]);
		SendClientMessageToAll(White, string);

		if(FinishCount <= 5)
		{
			format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", RaceName);
		    format(string, sizeof(string), "BestRacerTime_%d", TimeProgress);
		    TempTotalTime = dini_Int(rFile, string);
		    ConvertTime(var1, TempTotalTime, TempTime[0], TempTime[1], TempTime[2]);
		    if(TotalRaceTime <= dini_Int(rFile, string) || TempTotalTime == 0)
		    {
		        dini_IntSet(rFile, string, TotalRaceTime);
				format(string, sizeof(string), "BestRacer_%d", TimeProgress);
		        if(TempTotalTime != 0) format(string, sizeof(string), ">> \"%s\" broke the record in \"%s\" with \"%d\" seconds faster than \"%d\"'st/th place!", pName, dini_Get(rFile, string), -(rTime[1] - TempTime[1]), TimeProgress+1);
					else format(string, sizeof(string), ">> \"%s\" broke the record in \"%d\"'st/th place!", pName, TimeProgress+1);
                SendClientMessageToAll(Green, "  ");
				SendClientMessageToAll(Green, string);
				SendClientMessageToAll(Green, "  ");
				format(string, sizeof(string), "BestRacer_%d", TimeProgress);
				dini_Set(rFile, string, pName);
				TimeProgress++;
		    }
		}
		FinishCount++;
		PlayerInfo[playerid][RacePoints] += Prize[1];
		//SetPlayerScore(playerid, GetPlayerScore(playerid) + Prize[0]);
		DisablePlayerRaceCheckpoint(playerid);
		CPProgess[playerid]++;
		if(FinishCount >= JoinCount) return StopRace();
    }
	else
	{
		CPProgess[playerid]++;
		CPCoords[CPProgess[playerid]][3]++;
		RacePosition[playerid] = floatround(CPCoords[CPProgess[playerid]][3], floatround_floor);
	    SetCP(playerid, CPProgess[playerid], CPProgess[playerid]+1, TotalCP, RaceType);
	    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
	}
    return 1;
}

public OnPlayerClickPlayer( playerid, clickedplayerid, source )
{
	new info[ 128 ], Float:ratio = floatdiv(PlayerInfo[clickedplayerid][Kills],PlayerInfo[clickedplayerid][Deaths]);

	format( info, sizeof( info ), "%s's(%d):", nome( clickedplayerid ), clickedplayerid );
	SendClientMessage( playerid, Red, info );

	format( info, sizeof( info ), "{C3C3C3}Packetloss: %.1f\nPing: %i\nFps: %i\nKills: %i\nDeaths: %i\nK/D: %0.2f", GetPlayerPacketloss( clickedplayerid ), GetPlayerPing( clickedplayerid ), pFPS[ clickedplayerid ], PlayerInfo [ clickedplayerid ] [ Kills ], PlayerInfo [ clickedplayerid ] [ Deaths ], ratio );
	SendClientMessage( playerid, 0xFFFFFFFF, info );
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 599)
 	{
  		if(!response) return BuildRace = 0;
    	switch(listitem)
		{
  			case 0: BuildRaceType = 0;
 		  	case 1: BuildRaceType = 3;
		}
		ShowDialog(playerid, 600);
   	}
    if(dialogid == 600 || dialogid == 601)
    {
    	if(!response) return ShowDialog(playerid, 599);
     	if(!strlen(inputtext)) return ShowDialog(playerid, 601);
      	if(strlen(inputtext) < 1 || strlen(inputtext) > 20) return ShowDialog(playerid, 601);
       	strmid(BuildName, inputtext, 0, strlen(inputtext), sizeof(BuildName));
        ShowDialog(playerid, 602);
    }
    if(dialogid == 602 || dialogid == 603)
	{
		if(!response) return ShowDialog(playerid, 600);
		if(!strlen(inputtext)) return ShowDialog(playerid, 603);
		if(isNumeric(inputtext))
		{

			if(!IsValidVehicle(strval(inputtext))) return ShowDialog(playerid, 603);
			new
			Float: pPos[4];
			GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
			GetPlayerFacingAngle(playerid, pPos[3]);
			BuildModeVID = strval(inputtext);
			BuildCreatedVehicle = (BuildCreatedVehicle == 0x01) ? (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00) : (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00);
			BuildVehicle = CreateVehicle(strval(inputtext), pPos[0], pPos[1], pPos[2], pPos[3], random(126), random(126), (60 * 60));
			PutPlayerInVehicle(playerid, BuildVehicle, 0);
			BuildCreatedVehicle = 0x01;
			ShowDialog(playerid, 604);
		}
		else
		{
			if(!IsValidVehicle(ReturnVehicleID(inputtext))) return ShowDialog(playerid, 603);
			new
			Float: pPos[4];
			GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
			GetPlayerFacingAngle(playerid, pPos[3]);
			BuildModeVID = ReturnVehicleID(inputtext);
			BuildCreatedVehicle = (BuildCreatedVehicle == 0x01) ? (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00) : (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00);
			BuildVehicle = CreateVehicle(ReturnVehicleID(inputtext), pPos[0], pPos[1], pPos[2], pPos[3], random(126), random(126), (60 * 60));
			PutPlayerInVehicle(playerid, BuildVehicle, 0);
			BuildCreatedVehicle = 0x01;
			ShowDialog(playerid, 604);
		}
	}
	if(dialogid == 604)
	{
		if(!response) return ShowDialog(playerid, 602);
		SendClientMessage(playerid, Green, ">> Go to the start line on the left road and press 'KEY_FIRE' and do the same with the lock on the right road.");
		SendClientMessage(playerid, Green, "   - When this is done, you will see a dialog box to continue.");
		BuildVehPosCount = 0;
		BuildTakeVehPos = true;
	}
	if(dialogid == 605)
	{
		if(!response) return ShowDialog(playerid, 604);
		SendClientMessage(playerid, Green, ">> Start now creating checkpoints by pressing 'KEY_FIRE'.");
		SendClientMessage(playerid, Green, "   - ATTENTION: Press 'ENTER' when the checkpoints are ready, if this wont work press again and again.");
		BuildCheckPointCount = 0;
		BuildTakeCheckpoints = true;
	}
	if(dialogid == 606)
	{
		if(!response) return ShowDialog(playerid, 606);
		BuildRace = 0;
		BuildCheckPointCount = 0;
		BuildVehPosCount = 0;
		BuildTakeCheckpoints = false;
		BuildTakeVehPos = false;
		BuildCreatedVehicle = (BuildCreatedVehicle == 0x01) ? (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00) : (DestroyVehicle(BuildVehicle), BuildCreatedVehicle = 0x00);
	}

    if(dialogid == D_SvConfig)
	{
	    if(response)
		{
		    switch(listitem)
		    {
          		case 0:
				{
				    if(ServerInfo[ReadPMS] == false)
					{
						ServerInfo[ReadPMS] = true;
						ServerConfig(playerid);
					}
					else
					if(ServerInfo[ReadPMS] == true)
					{
						ServerInfo[ReadPMS] = false;
                        ServerConfig(playerid);
					}
				}
				case 1:
				{
				    if(ServerInfo[ReadCMDS] == false)
					{
						ServerInfo[ReadCMDS] = true;
						ServerConfig(playerid);
					}
					else
					if(ServerInfo[ReadCMDS] == true)
					{
						ServerInfo[ReadCMDS] = false;
                        ServerConfig(playerid);
					}
				}
				case 2:
				{
				    ShowPlayerDialog(playerid,100,DIALOG_STYLE_INPUT,"Server Weather","Change Server Weather","Accept","Cancel");
				}
				case 3:
				{
				    ShowPlayerDialog(playerid,101,DIALOG_STYLE_INPUT,"Server Time","Change Server Time,","Accept","Cancel");
				}
				case 4:
				{
				    ShowPlayerDialog(playerid,102,DIALOG_STYLE_INPUT,"Server Max.Ping","Change Server Max.Ping,","Accept","Cancel");
				}
				case 5:
				{
				    ShowPlayerDialog(playerid,103,DIALOG_STYLE_INPUT,"Server Min.Fps","Change Server Min.Fps,","Accept","Cancel");
				}
				case 6:
				{
				    ShowPlayerDialog(playerid,104,DIALOG_STYLE_INPUT,"Server Max.Packetloss","Change Server Max.Packetloss,","Accept","Cancel");
				}
				case 7:
				{
				    if(ServerInfo[NetCheck] == false)
					{
						ServerInfo[NetCheck] = true;
						ServerConfig(playerid);
						
						new String[128];

						format(String,sizeof(String),"Admin enabled server NetCheck");
						SendClientMessageToAll(Green,String);
					}
					else
					if(ServerInfo[NetCheck] == true)
					{
						new String[128];

						format(String,sizeof(String),"Admin disabled server NetCheck");
						SendClientMessageToAll(Red,String);
						
						ServerInfo[NetCheck] = false;
                        ServerConfig(playerid);
					}
				}
				case 8:
				{
				    if(ServerInfo[ConnectMessages] == false)
					{
						ServerInfo[ConnectMessages] = true;
						ServerConfig(playerid);

						new String[128];

						format(String,sizeof(String),"Admin enabled AKA Login");
						SendClientMessageToAll(Green,String);
					}
					else
					if(ServerInfo[ConnectMessages] == true)
					{
						new String[128];

						format(String,sizeof(String),"Admin disabled AKA Login");
						SendClientMessageToAll(Red,String);

						ServerInfo[ConnectMessages] = false;
                        ServerConfig(playerid);
					}
				}
				case 9:
				{
                    if(ServerInfo[AntiCBug] == false)
					{
						ServerInfo[AntiCBug] = true;
						ServerConfig(playerid);

						new String[128];

						format(String,sizeof(String),"Admin enabled Anti-CBug");
						SendClientMessageToAll(Green,String);
					}
					else
					if(ServerInfo[AntiCBug] == true)
					{
						new String[128];

						format(String,sizeof(String),"Admin disabled Anti-CBug");
						SendClientMessageToAll(Red,String);

						ServerInfo[AntiCBug] = false;
                        ServerConfig(playerid);
					}
				}
			}
		}
	}
	
	if(dialogid == 100)
	{
	    if(!response)
	    {
	        ServerConfig(playerid);
 		}
 		else
 		{
   			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, Red, "You can type only numbers here!");

            ServerInfo[SVWeather] = strval(inputtext);
			SetWeather(ServerInfo[SVWeather]);

			new String[128];

			format(String,sizeof(String),"Admin changed server weather to %d",ServerInfo[SVWeather]);
			SendClientMessageToAll(Green,String);

			ServerConfig(playerid);
 		}
	}
	
	if(dialogid == 101)
	{
	    if(!response)
	    {
	        ServerConfig(playerid);
 		}
 		else
 		{
   			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, Red, "You can type only numbers here!");

            ServerInfo[SVTime] = strval(inputtext);
			SetWorldTime(ServerInfo[SVTime]);

			new String[128];

			format(String,sizeof(String),"Admin changed server time to %d",ServerInfo[SVTime]);
			SendClientMessageToAll(Green,String);

			ServerConfig(playerid);
 		}
	}
	
	if(dialogid == 102)
	{
	    if(!response)
	    {
	        ServerConfig(playerid);
 		}
 		else
 		{
   			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, Red, "You can type only numbers here!");

			ServerInfo[MaxPing] = strval(inputtext);

            new String[128];

			format(String,sizeof(String),"Admin changed Max.Ping to %d",ServerInfo[MaxPing]);
			SendClientMessageToAll(Green,String);

			ServerConfig(playerid);
 		}
	}
	
	if(dialogid == 103)
	{
	    if(!response)
	    {
	        ServerConfig(playerid);
 		}
 		else
 		{
   			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, Red, "You can type only numbers here!");

            ServerInfo[MinFps] = strval(inputtext);

			new String[128];

			format(String,sizeof(String),"Admin changed Min.Fps to %d",ServerInfo[MinFps]);
			SendClientMessageToAll(Green,String);

			ServerConfig(playerid);
 		}
	}
	
	if(dialogid == 104)
	{
	    if(!response)
	    {
	        ServerConfig(playerid);
 		}
 		else
 		{
   			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, Red, "You can type only numbers here!");

            ServerInfo[MaxPL] = strval(inputtext);

			new String[128];

			format(String,sizeof(String),"Admin changed Max.Packetloss to %d",ServerInfo[MaxPL]);
			SendClientMessageToAll(Green,String);

			ServerConfig(playerid);
 		}
	}
	
	//Dialog weaponset
	if(dialogid == D_WeaponSet)
	{
	    if(!response)
	    {
	        return 0;
		}
		else
		{
		    switch(listitem)
		    {
		        case 0:
		        {
                    PlayerInfo[playerid][WeaponSet] = 1;

					SendClientMessage(playerid,Yellow,"Weapon set 1 selected, you will have this weapons all time you spawn.");
		        }
		        case 1:
		        {
                    PlayerInfo[playerid][WeaponSet] = 2;
                    SendClientMessage(playerid,Yellow,"Weapon set 2 selected, you will have this weapons all time you spawn.");
		        }
		        case 2:
		        {
                    PlayerInfo[playerid][WeaponSet] = 3;
                    SendClientMessage(playerid,Yellow,"Weapon set 3 selected, you will have this weapons all time you spawn.");
		        }
		        case 3:
		        {
		            PlayerInfo[playerid][WeaponSet] = 0;
                    SendClientMessage(playerid,Yellow,"Weapon set selected, you will have this weapons all time you spawn.");
		        }
		    }
		}
	}
	//Dialog register
	if(dialogid == D_Register)
	{
	    new str[500];
		if(response)
		{
			if(strlen(inputtext) < 4 || strlen(inputtext) > 16)
			{
				SendClientMessage(playerid, Red, "The password must be 4-16 characters.");
				return ShowPlayerDialog(playerid,D_Register,DIALOG_STYLE_PASSWORD,"Register","Enter a password to Register","Register","Leave");
			}
			
			new ip[16];
			GetPlayerIp(playerid,ip,sizeof(ip));
			
			format(str, sizeof(str),"INSERT INTO `accounts` (Username,Password,Ip,Admin,Level,Kills,Deaths,MutedTime,WeaponSet,Banned,RacePoints) VALUES ('%s','%s','%s','0','0','0','0','0','0','0','0')",nome(playerid),inputtext,ip);
  			mysql_query(mysql, str);
  			mysql_store_result();

			PlayerInfo[playerid][Logged] = 1;
		
   			ShowRules(playerid);
		}
		else
		{
			SendClientMessage(playerid,Red,"You were kicked from the server, register if you want to play.");
			Kick(playerid);
		}
	}
    //Dialog de login
    if(dialogid == D_Login)
	{
	    new str[150];
		if(response)
		{
			format(str, sizeof(str),"SELECT * FROM `accounts` WHERE `Username` = '%s' AND `Password` = '%s'",nome(playerid),inputtext);
	  		mysql_query(mysql, str);
			mysql_store_result();

			if(mysql_num_rows() == 0)
			{
				PasswordIncorret[playerid] ++;

				if(PasswordIncorret[playerid] == 5)
				{
					SendClientMessage(playerid,Red,"You wrong password 5/5 times, relog and type the right password.");
					Kick(playerid);
					return 0;
				}
				return ShowPlayerDialog(playerid,D_Login,DIALOG_STYLE_PASSWORD,"{FF0000}Wrong password","Type your password for login","Login","Leave");
			}
			else if(mysql_num_rows() > 0)
			{
				PlayerInfo[playerid][Logged] = 1;
   				CarregarPlayer(playerid);
   				
      			//ShowRules(playerid);

				new level[30];

				if(PlayerInfo[playerid][Admin] == 3) { level ="Owner"; }
				else if(PlayerInfo[playerid][Admin] == 2) { level = "Admin"; }
				else if(PlayerInfo[playerid][Admin] == 1) { level = "Mod"; }
				else if(PlayerInfo[playerid][Admin] == 0) { level = "Player"; }

				format(str,sizeof(str),"You logged in as %s",level);
				SendClientMessage(playerid,Green,str);
				
				new ip[16];
				GetPlayerIp(playerid,ip,sizeof(ip));
				
				format(str,sizeof(str),"UPDATE `accounts` SET Ip = '%s' WHERE `Username` = '%s'",ip,nome(playerid));
			 	mysql_query(mysql, str);
			 	mysql_store_result();
			}
			mysql_free_result();
		}
		else
		{
			SendClientMessage(playerid,Red,"You got kicked, login for play.");
			Kick(playerid);
		}
 	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    if(HitSound[issuerid] == true)
	{
	    PlayerPlaySound(issuerid, 17802, 0.0, 0.0, 0.0); // Ding Sound
	}

    if(issuerid != INVALID_PLAYER_ID)
	{
		new str[1500];
		
		KillTimer(TempoMostrarLife2[playerid]);
		TextDrawShowForPlayer(playerid, Atingido[playerid]);

		format(str,sizeof(str),"~r~~h~~h~%s	~w~~h~~h~/ -%.0f ~r~~h~~h~%s ~w~~h~~h~", nome(issuerid), amount, weaponNames[weaponid]);
		TextDrawSetString(Atingido[playerid], str);
		TempoMostrarLife2[playerid] = SetTimerEx("HideTextoLife2", 2000, 0, "i", playerid);
		MostrandoVida2[playerid] = 1;

		KillTimer(TempoMostrarLife[issuerid]);
		TextDrawShowForPlayer(issuerid, Atingir[issuerid]);
		
		format(str,sizeof(str),"~g~~h~~h~%s	~w~~h~~h~/ -%.0f ~g~~h~~h~%s ~w~~h~~h~", nome(playerid), amount, weaponNames[weaponid]);
  		TextDrawSetString(Atingir[issuerid], str);
		TempoMostrarLife[issuerid] = SetTimerEx("HideTextoLife", 2000, 0, "i", issuerid);
		MostrandoVida[issuerid] = 1;
	}

    KillTimer(Player[issuerid][P_OBJ_TIMER]);
	if(Player[issuerid][P_ARMAPLAYER] != 0) DestroyObject(Player[issuerid][P_ARMAPLAYER]);
    Player[issuerid][P_ARMAPLAYER] = CreateObject(weaponObj[weaponid], 0, 0, 0, 0, 0, 0);
	AttachObjectToPlayer(Player[issuerid][P_ARMAPLAYER], issuerid, 0, 0, 1.35, 0, 0, 0);
	Player[issuerid][P_OBJ_TIMER][0] = SetTimerEx("HideWeaponObject", 1000, false, "i", issuerid);
	Player[issuerid][P_OBJ_TIMER][1] = 1;
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    /*if(ServerInfo[AntiCBug] == true && (newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) || (oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) )
	{
        switch(GetPlayerWeapon(playerid))
		{
  			case 23..25, 27, 29..34, 41:
			{
  				ApplyAnimation(playerid,"PED","handsup",4.1,0,0,0,0,0);
      			return 1;
   			}
      	}
	}

	if(CheckCrouch[playerid] == 1)
	{
		switch(WeaponID[playerid])
		{
			case 23..25, 27, 29..34, 41:
			{
		 		if(ServerInfo[AntiCBug] == true && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK )
				{
		  			ApplyAnimation(playerid,"PED","handsup",4.1,0,0,0,0,0);
		     	}
			}
		}
  	}
	else if(ServerInfo[AntiCBug] == true && ((newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE) && !((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP))) ||
 	(newkeys & KEY_FIRE) && !((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP)) ||
 	(NotMoving[playerid] && (newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE)) ||
  	(NotMoving[playerid] && (newkeys & KEY_FIRE)) ||
  	(newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ||
  	(oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) )
	{
		SetTimerEx("CrouchCheck", 2000, 0, "d", playerid);
		CheckCrouch[playerid] = 1;
		WeaponID[playerid] = GetPlayerWeapon(playerid);
		return 1;
 	}
	*/
	
    new
 		string[256],
 		rNameFile[256],
   		rFile[256],
     	Float: vPos[4]
	;
	if(newkeys & KEY_FIRE)
	{
	    if(BuildRace == playerid+1)
	    {
		    if(BuildTakeVehPos == true)
		    {
		    	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, Red, ">> You need to be in a vehicle");
				format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", BuildName);
				GetVehiclePos(GetPlayerVehicleID(playerid), vPos[0], vPos[1], vPos[2]);
				GetVehicleZAngle(GetPlayerVehicleID(playerid), vPos[3]);
		        dini_Create(rFile);
				dini_IntSet(rFile, "vModel", BuildModeVID);
				dini_IntSet(rFile, "rType", BuildRaceType);
		        format(string, sizeof(string), "vPosX_%d", BuildVehPosCount), dini_FloatSet(rFile, string, vPos[0]);
		        format(string, sizeof(string), "vPosY_%d", BuildVehPosCount), dini_FloatSet(rFile, string, vPos[1]);
		        format(string, sizeof(string), "vPosZ_%d", BuildVehPosCount), dini_FloatSet(rFile, string, vPos[2]);
		        format(string, sizeof(string), "vAngle_%d", BuildVehPosCount), dini_FloatSet(rFile, string, vPos[3]);
		        format(string, sizeof(string), ">> Vehicle position '%d' was taken.", BuildVehPosCount+1);
		        SendClientMessage(playerid, Yellow, string);
				BuildVehPosCount++;
			}
   			if(BuildVehPosCount >= 2)
		    {
		        BuildVehPosCount = 0;
		        BuildTakeVehPos = false;
		        ShowDialog(playerid, 605);
		    }
			if(BuildTakeCheckpoints == true)
			{
			    if(BuildCheckPointCount > MAX_RACE_CHECKPOINTS_EACH_RACE) return SendClientMessage(playerid, Red, ">> You have reached the maximum checkpoints!");
			    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, Red, ">> You need to be in a vehicle");
				format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", BuildName);
				GetVehiclePos(GetPlayerVehicleID(playerid), vPos[0], vPos[1], vPos[2]);
				format(string, sizeof(string), "CP_%d_PosX", BuildCheckPointCount), dini_FloatSet(rFile, string, vPos[0]);
				format(string, sizeof(string), "CP_%d_PosY", BuildCheckPointCount), dini_FloatSet(rFile, string, vPos[1]);
				format(string, sizeof(string), "CP_%d_PosZ", BuildCheckPointCount), dini_FloatSet(rFile, string, vPos[2]);
    			format(string, sizeof(string), ">> Checkpoint '%d' has been set!", BuildCheckPointCount+1);
		        SendClientMessage(playerid, Yellow, string);
				BuildCheckPointCount++;
			}
		}
	}
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
	    if(BuildTakeCheckpoints == true)
	    {
	        ShowDialog(playerid, 606);
			format(rNameFile, sizeof(rNameFile), "/rRaceSystem/RaceNames/RaceNames.txt");
			TotalRaces = dini_Int(rNameFile, "TotalRaces");
			TotalRaces++;
			dini_IntSet(rNameFile, "TotalRaces", TotalRaces);
			format(string, sizeof(string), "Race_%d", TotalRaces-1);
			format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", BuildName);
			dini_Set(rNameFile, string, BuildName);
			dini_IntSet(rFile, "TotalCP", BuildCheckPointCount);
			Loop(x, 5)
			{
				format(string, sizeof(string), "BestRacerTime_%d", x);
				dini_Set(rFile, string, "0");
				format(string, sizeof(string), "BestRacer_%d", x);
				dini_Set(rFile, string, "noone");
			}
	    }
	}
	
	if(newkeys == 160 && (!GetPlayerWeapon(playerid) || GetPlayerWeapon(playerid) == 1) && !IsPlayerInAnyVehicle(playerid) && Spawnado[playerid] == true && PlayerInfo[playerid][P_SYNCALLOWED] == 1)
	{
		syncPlayer(playerid);
		return 1;
	}

	if(newkeys == KEY_YES && VoteON == true && Voted[playerid] == false)
	{
	    VotesNewMap ++;
		Voted[playerid] = true;

	    new str[200];
        format(str,sizeof(str),"{B5F056}(VOTE MAP): {FFFFFF}%s {B5F056}Agree to change the map. {FFFFFF}[Votes: %d/4]",nome(playerid),VotesNewMap);
		SendClientMessageToAll(-1,str);

		if(VotesNewMap == MAX_VOTE_MAP) return SendClientMessage(playerid,Red,"The vote already served the maximum votes! a new map starts!");
		return 1;
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(playerid, 0);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == HealthPickup[playerid])
	{
	    new Float:health;
	    GetPlayerHealth(playerid,health);
		SetPlayerHealth(playerid, health+20);
		DestroyPickup(HealthPickup[playerid]);
	}
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}

forward ResultVoteMap();
public ResultVoteMap()
{
    TextDrawHideForAll(VoteMap[0]);
	TextDrawHideForAll(VoteMap[1]);
	TextDrawHideForAll(VoteMap[2]);
	TextDrawHideForAll(VoteMap[3]);

	for(new i = 0; i < MAX_PLAYERS; i++) Voted[i] = false; VoteON = false;

	if(VotesNewMap >= 4) {
		ChangeArea();
		SendClientMessageToAll(White,"{B5F056}(VOTE MAP): {FFFFFF}Started another map randomly.");
	}
	else if(VotesNewMap < 4) {
		SendClientMessageToAll(White,"{B5F056}(VOTE MAP): {FFFFFF}There was not enough votes to change the map.");
	}
	return 1;
}

forward Cont(p1,p2,pos);
public Cont(p1,p2,pos)
{
	switch(pos)
	{
		case 2:
		{
			GameTextForPlayer(p1,"~n~~n~~n~~n~~n~~w~2",1000,3);
			GameTextForPlayer(p2,"~n~~n~~n~~n~~n~~w~2",1000,3);

			PlayerPlaySound(p2,1056,0,0,0);
			PlayerPlaySound(p1,1056,0,0,0);

			SetTimerEx("Cont",1000,false,"ddd",p1,p2,1);
			SetCameraBehindPlayer(p1);

			SetCameraBehindPlayer(p2);
		}
		case 1:
		{
			GameTextForPlayer(p1,"~n~~n~~n~~n~~n~~w~1",1000,3);
			GameTextForPlayer(p2,"~n~~n~~n~~n~~n~~w~1",1000,3);

			PlayerPlaySound(p2,1056,0,0,0);
			PlayerPlaySound(p1,1056,0,0,0);

			SetTimerEx("Cont",1000,false,"ddd",p1,p2,0);
		}
		case 0:
		{
			GameTextForPlayer(p1,"~n~~n~~n~~n~~n~~r~FIGTH!",1000,3);
			GameTextForPlayer(p2,"~n~~n~~n~~n~~n~~r~FIGTH!",1000,3);

			PlayerPlaySound(p2,1057,0,0,0);
			PlayerPlaySound(p1,1057,0,0,0);

			TogglePlayerControllable(p1,1);
			TogglePlayerControllable(p2,1);
		}
	}
	return 1;
}

forward HealthPickupDelete(id);
public HealthPickupDelete(id)
{
    DestroyPickup(id);
    return 1;
}

forward GiveSyncWeapons(playerid);
public GiveSyncWeapons(playerid)
{
	if(PlayerInfo[playerid][P_INSYNC] == 1)
	{
	    SetPlayerWeapons(playerid);
	}
	return 1;
}

forward TimeAFK(playerid);
public TimeAFK(playerid)
{
	tAFK[playerid] --;
	if(tAFK[playerid] == 0) return KillTimer(TimerAFK[playerid]);
	return 1;
}

forward ChangeArea();
public ChangeArea()
{
	if(AdminChangeArea == false) area = random(19); AdminChangeArea = false;

	switch(area)
	{
		case 0:
		{
		    area = 0;
		    SendRconCommand("mapname Palominio Creek");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Palominio Creek's (ID: 0) {FFFFFF}started.");
		}
        case 1:
		{
		    area = 1;
		    SendRconCommand("mapname Arena Farm");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Arena Farm's (ID: 1) {FFFFFF}started.");

		}
		case 2:
		{
		    area = 2;
		    SendRconCommand("mapname Area 51");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Area 51 (ID: 2) {FFFFFF}started.");

		}
		case 3:
		{
		    area = 3;
		    SendRconCommand("mapname LV Police HQ");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}LV Police HQ's (ID: 3) {FFFFFF}started.");
		}
		case 4:
		{
		    area = 4;
		    SendRconCommand("mapname Depot Arena's");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Depot Arena's (ID: 4) {FFFFFF}started.");
		}
		case 5:
		{
		    area = 5;
		    SendRconCommand("mapname Las Payasadas");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Las Payasadas's (ID: 5) {FFFFFF}started.");
		}
		case 6:
		{
		    area = 6;
		    SendRconCommand("mapname Angel Pine");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Angel Pine's (ID: 6) {FFFFFF}started.");
		}
		case 7:
		{
		    area = 7;
		    SendRconCommand("mapname Doherty");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Doherty's (ID: 7) {FFFFFF}started.");
		}
		case 8:
		{
		    area = 8;
		    SendRconCommand("mapname Willowfield");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Willowfield's (ID: 8) {FFFFFF}started.");
		}
		case 9:
		{
		    area = 9;
		    SendRconCommand("mapname VerdantBluffs");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}VerdantBluffs's (ID: 9) {FFFFFF}started.");
		}
		case 10:
		{
		    area = 10;
		    SendRconCommand("mapname Rodeo");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Rodeo's (ID: 10) {FFFFFF}started.");
		}
		case 11:
		{
		    area = 11;
		    SendRconCommand("mapname Industrial");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Industrial (ID: 11) {FFFFFF}started.");
		}
		case 12:
		{
		    area = 12;
		    SendRconCommand("mapname Las Venturas");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Las Ventura's (ID: 12) {FFFFFF}started.");
		}
		case 13:
		{
		    area = 13;
		    SendRconCommand("mapname K.A.C.C");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}K.A.C.C's (ID: 13) {FFFFFF}started.");
		}
		case 14:
		{
		    area = 14;
		    SendRconCommand("mapname Santa Floria");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Santa Floria's (ID: 14) {FFFFFF}started.");
		}
		case 15:
		{
		    area = 15;
		    SendRconCommand("mapname Dillimore");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Dillimore's (ID: 15) {FFFFFF}started.");
		}
		case 16:
		{
		    area = 16;
		    SendRconCommand("mapname Ocean Docks");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Ocean Dock's (ID: 16) {FFFFFF}started.");
		}
		case 17:
		{
		    area = 17;
		    SendRconCommand("mapname Rockshore East");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}Rockshore East's (ID: 17) {FFFFFF}started.");
		}
		case 18:
		{
		    area = 18;
		    SendRconCommand("mapname El Corona");
			SendClientMessageToAll(-1,"{FFFFFF}Map {FF0000}El Corona's (ID: 17) {FFFFFF}started.");
		}
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GameTextForPlayer(i,"~r~ROUND FINISHED",2000,1);
		}
	}
	inicio = SetTimer("Iniciar",1000,false);
	return 1;
}

forward Iniciar();
public Iniciar()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(Spawnado[i] == true && EmDuelo[i] == 0 && pAFK[i] == false)
		{
			SpawnPlayer(i);
		}
	}
	return 1;
}

forward Update(playerid);
public Update(playerid)
{
	//mysql = mysql_connect(mysql_HOST,mysql_USER,mysql_DB,mysql_SENHA);
	
    for(new u = 0, y = GetMaxPlayers(); u != y; u++)
	{
        new
			STR[200],
			Float:ratio =  floatdiv(PlayerInfo[u][Kills],PlayerInfo[u][Deaths])
		;

        format(STR, 100, "~w~Kills: ~r~~h~%d ~w~Deaths: ~r~~h~%d ~w~K/D: ~r~~h~%0.2f",PlayerInfo[u][Kills],PlayerInfo[u][Deaths],ratio);
        TextDrawSetString(Rampage[u],STR);

        format(STR, 100, "~h~~r~~h~%s",ReturnPlayerZone(u));
        TextDrawSetString(Zone[u],STR);
    }
    return 1;
}

forward CheckLag(playerid);
public CheckLag(playerid)
{
    if(ServerInfo[NetCheck] == true)
	{
	    if(Spawnado[playerid] == true && GetPlayerPing(playerid) > ServerInfo[MaxPing])
		{
			PingWarns[playerid] ++;
			if(PingWarns[playerid] >= 10)
			{
				new String[128];
				format(String,sizeof(String),"%s leaved the server (HIGH PING)",nome(playerid));
				SendClientMessageToAll(Gray,String);

				Kick(playerid);
			}
		}
		else
		{
			if(PingWarns[playerid] > 0)
			PingWarns[playerid] = 0;
		}

		if(Spawnado[playerid] == true && pFPS[playerid] < ServerInfo[MinFps])
	    {
			FpsWarns[playerid] ++;
			if(FpsWarns[playerid] >= 10)
			{
				new String[128];
				format(String,sizeof(String),"%s leaved the server (LOW FPS)",nome(playerid));
				SendClientMessageToAll(Gray,String);

				Kick(playerid);
			}
		}
		else
		{
			if(FpsWarns[playerid] > 0)
			FpsWarns[playerid] = 0;
		}

        if(Spawnado[playerid] == true && GetPlayerPacketloss(playerid) > ServerInfo[MaxPL])
	    {
			PLWarns[playerid] ++;
			if(PLWarns[playerid] >= 10)
			{
				new String[128];
				format(String,sizeof(String),"%s leaved the server (HIGH PL)",nome(playerid));
				SendClientMessageToAll(Gray,String);

				Kick(playerid);
			}
		}
		else
		{
			if(PLWarns[playerid] > 0)
			PLWarns[playerid] = 0;
		}
	}
	return 1;
}


forward HideWeaponObject(playerid);
public HideWeaponObject(playerid)
{
    DestroyObject(Player[playerid][P_ARMAPLAYER]);
    Player[playerid][P_OBJ_TIMER][1] = 0;
    Player[playerid][P_ARMAPLAYER] = 0;
}

forward Kicka(p);
public Kicka(p)
{
    #undef Kick
    Kick(p);
    #define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)
    return 1;
}

forward Bana(p);
public Bana(p)
{
    #undef Ban
    Ban(p);
    #define Ban(%0) SetTimerEx("Bana", 100, false, "i", %0)
    return 1;
}

forward allowSync(playerid);
public allowSync(playerid)
{
	if(!IsPlayerConnected(playerid))
		 return;

    PlayerInfo[playerid][P_SYNCALLOWED] = true;
    PlayerInfo[playerid][P_INSYNC] = false;
}

forward DropPlayerWeapons(playerid);
public DropPlayerWeapons(playerid)
{
    new playerweapons[13][2];
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid, x, y, z);//here gets your position..!

    for(new i=0; i<13; i++)
    {
        GetPlayerWeaponData(playerid, i, playerweapons[i][0], playerweapons[i][1]);
        new model = GetWeaponType(playerweapons[i][0]);// this to get, what weapons are you using in the moment !
        new times = floatround(playerweapons[i][1]/10.0001);
        new Float:X = x + (random(3) - random(3));
        new Float:Y = y + (random(3) - random(3));
        if(playerweapons[i][1] != 0 && model != -1)
        {
            if(times > DropLimit) times = DropLimit;
            for(new a=0; a<times; a++)
            {
                new pickupid = CreatePickup(model, 3, X, Y, z);//this is the place where you die, there you will drop your weapons !
				SetTimerEx("DeletePickup", DeleteTime*1000, false, "d", pickupid);//there you may change the time 1 *1000 to *19283718293712 whatever...!
            }
        }
    }
    return 1;
}

forward DeletePickup(pickupid);
public DeletePickup(pickupid)
{
    DestroyPickup(pickupid);
    return 1;
}

forward CrouchCheck(playerid);
public CrouchCheck(playerid)
{
	CheckCrouch[playerid] = 0;
 	return 1;
}
//----------------------------------------------------------
//
//         COMMANDS
//
//----------------------------------------------------------

//----------------------------------------------------------
//
//  Commands LVL3
//
//----------------------------------------------------------
CMD:setadmin(playerid,params[])
{
	new playerID,
	Nivel;

	if(strcmp(nome(playerid), "[RBK]shendlaw", true) == 0 || IsPlayerAdmin(playerid))
	{

		if(sscanf(params,"ii",playerID,Nivel)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /setadmin [ID] [Level]");
		if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");
		if(Nivel == PlayerInfo[playerID][Admin]) return SendClientMessage(playerid,Red,"This player already won this level");

		PlayerInfo[playerID][Admin] = Nivel;
		AdminHide[playerID] = true;
     	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	}
	else
	{

		SendClientMessage(playerid,Red,"You don't have permissions!");
	}
	return 1;
}

CMD:leaveadmin(playerid,params[])
{
	new string[128];

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(strlen(params) < 3) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /leaveadmin <NICK>");

	format(string,sizeof(string),"SELECT * FROM accounts WHERE Username = '%s'",params);

	mysql_query(mysql, string);
	mysql_store_result();

	if(mysql_num_rows() > 0)
	{

		format(string, sizeof(string),"UPDATE `accounts` SET Admin = '0' WHERE `Username` = '%s'",params);
		mysql_query(mysql,string);


		mysql_free_result();

		if(NametoId(params) != -1 && IsPlayerConnected(NametoId(params)))
		{

			PlayerInfo[NametoId(params)][Admin] = 0;
		}
	}
	else
	{

		mysql_free_result();
		SendClientMessage(playerid,Red,"Function not performed!");
	}
	return 1;
}

/*CMD:setlevel(playerid,params[])
{
	new playerID,
		Levelz,
		String[100],
		Log[150]
	;

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"ii",playerID,Levelz)) return SendClientMessage(playerid,Gray,"use: /setlevel <playerid> <level>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
	if(Levelz == PlayerInfo[playerID][Level]) return SendClientMessage(playerid,Red,"O player já possui esse level");

    SetPlayerScore(playerID,Levelz);
    PlayerInfo[playerID][Level] = Levelz;

    format(String,sizeof(String),"Admin %s alterou seu Level para %d",nome(playerid),Levelz);
	SendClientMessage(playerID,Orange,String);

	format(Log,sizeof(Log),"Admin %s alterou level de %s para %d",nome(playerid),nome(playerID),Levelz);

	writeLog(AdminLog,Log);

	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}

CMD:setskill(playerid,params[])
{
    new playerID,
        weaponID,
		Skillz,
		String[100],
		Log[150],
		weaponName[30]
	;

    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"iii",playerID,weaponID,Skillz)) return SendClientMessage(playerid,Gray,"use: /setskill <playerID> <weaponID> <level>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
	
	switch(weaponID)
	{
	    case 0:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_PISTOL, Skillz);
	        weaponName = "Pistol";
	    }
	    case 1:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_PISTOL_SILENCED, Skillz);
	        weaponName = "Silenced";
	    }
	    case 2:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_DESERT_EAGLE, Skillz);
	        weaponName = "Desert Eagle";
	    }
	    case 3:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_SHOTGUN, Skillz);
	        weaponName = "Shotgun";
	    }
	    case 4:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_SAWNOFF_SHOTGUN, Skillz);
	        weaponName = "Sawnoff Shotgun";
	    }
	    case 5:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_SPAS12_SHOTGUN, Skillz);
	        weaponName = "Combat Shotgun";
	    }
	    case 6:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_MICRO_UZI, Skillz);
	        weaponName = "Micro Uzi";
	    }
	    case 7:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_MP5, Skillz);
	        weaponName = "Mp5";
	    }
	    case 8:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_AK47, Skillz);
	        weaponName = "Ak47";
	    }
	    case 9:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_M4, Skillz);
	        weaponName = "Colt M4";
	    }
	    case 10:
	    {
	        SetPlayerSkillLevel(playerID, WEAPONSKILL_SNIPERRIFLE, Skillz);
	        weaponName = "Sniper Rifle";
	    }
    }
    
    format(String,sizeof(String),"Admin %s alterou seu Skill Level de %s para %d",nome(playerid),weaponName,Skillz);
	SendClientMessage(playerID,Orange,String);
    
    format(Log,sizeof(Log),"Admin %s alterou (%s) Skills Level de %s para %d",nome(playerid),weaponName,nome(playerID),Skillz);
	writeLog(AdminLog,Log);
	return 1;
}

CMD:setkills(playerid,params[])
{
	new playerID,
		Killz,
		String[100],
		Log[150]
	;

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"ii",playerID,Killz)) return SendClientMessage(playerid,Gray,"use: /setkills <playerid> <kills>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
	if(Killz == PlayerInfo[playerID][Kills]) return SendClientMessage(playerid,Red,"O player já possui esses kills");

    PlayerInfo[playerID][Kills] = Killz;

    format(String,sizeof(String),"Admin %s alterou seus Kills para %d",nome(playerid),Killz);
	SendClientMessage(playerID,Orange,String);

	format(Log,sizeof(Log),"Admin %s alterou kills de %s para %d",nome(playerid),nome(playerID),Killz);

	writeLog(AdminLog,Log);

	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}

CMD:setdeaths(playerid,params[])
{
	new playerID,
		Deathz,
		String[100],
		Log[150]
	;

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"ii",playerID,Deathz)) return SendClientMessage(playerid,Gray,"use: /setdeaths <playerid> <deaths>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
	if(Deathz == PlayerInfo[playerID][Deaths]) return SendClientMessage(playerid,Red,"O player já possui esses deaths");

    PlayerInfo[playerID][Deaths] = Deathz;

    format(String,sizeof(String),"Admin %s alterou suas Deaths para %d",nome(playerid),Deathz);
	SendClientMessage(playerID,Orange,String);

	format(Log,sizeof(Log),"Admin %s alterou deaths de %s para %d",nome(playerid),nome(playerID),Deathz);

	writeLog(AdminLog,Log);

	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}*/

CMD:svconfig(playerid)
{
	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"You don't have permissions!");

	ServerConfig(playerid);
	return 1;
}

CMD:authnick(playerid,params[])
{
	new playerID,String[128];

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"i",playerID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /authnick [ID]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");

	Autorizado[playerID] = true;

	format(String,sizeof(String),"Admin authorized you to change your nick!\nYou are able to change your nick after relog.",nome(playerid));
	SendClientMessage(playerID, White, String);
	return 1;
}

/*CMD:tdinfo(playerid,params[])
{
	new tdInfo[128],tdString[164];

	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"s[128]",tdInfo)) return SendClientMessage(playerid,Gray,"use: /tdinfo <texto>");

	format(tdString,sizeof(tdString),"%s",tdInfo);
	TextDrawSetString(Adrenaline[3],tdString);
	return 1;
}*/

CMD:startautorace(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(RaceBusy == 0x01 || RaceStarted == 1) return SendClientMessage(playerid, Red, "There is a race in progress, wait until it ends.");
	if(AutomaticRace == true) return SendClientMessage(playerid, Red, "Already enabled!");

	LoadRaceNames();
	LoadAutoRace(RaceNames[random(TotalRaces)]);

	AutomaticRace = true;

	SendClientMessage(playerid, Green, ">> Auto race enabled.");
	return 1;
}

CMD:stopautorace(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] < 3) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(AutomaticRace == false) return SendClientMessage(playerid, Red, "Already disabled!");

	AutomaticRace = false;

	SendClientMessage(playerid, Red, ">> Auto race disabled.");
	return 1;
}

//----------------------------------------------------------
//  CMDS LEVEL 2
//----------------------------------------------------------
CMD:randommap(playerid)
{
	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!");

	new string[150];
	format(string,sizeof(string),"Admin changed map (RANDOM).",nome(playerid));
	SendClientMessageToAll(Red,string);

	KillTimer(tbase);
	KillTimer(inicio);

	area = random(19);

	tbase = SetTimer("ChangeArea",600000,true);
	ChangeArea();

	return 1;
}

CMD:startmap(playerid,params[])
{
	new mapID;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"d",mapID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /startmap <map id>");
	if(mapID > MAX_MAPS) return SendClientMessage(playerid,Red,"This map doesen't exist!");

	new string[150];
	format(string,sizeof(string),"Admin started map with ID: %d.",nome(playerid),mapID);
	SendClientMessageToAll(Red,string);

	AdminChangeArea = true;
	area = mapID;

	KillTimer(tbase);
	KillTimer(inicio);

	tbase = SetTimer("ChangeArea",600000,true);
	ChangeArea();
	return 1;
}

CMD:pban(playerid,params[])
{
    if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(isnull(params)) return SendClientMessage(playerid,Gray,"use: /pban <nick/ip>");

	new query[1024],savingstring[256],string[1024];

 	format(query,sizeof(query),"SELECT * FROM `bans` WHERE `nick` LIKE '%%%s%%' or `ip` LIKE '%%%s%%'",params,params);

	mysql_query(mysql, query);
	mysql_store_result();

	new
		BannedBy[24],
		BannedName[24],
		BannedIP[24],
		BannedReason[24],
		BannedDay,
		BannedMonth,
		BannedYear,
		BannedHour,
		BannedMinute
	;

	if(mysql_num_rows() > 0)
	{
		mysql_fetch_field_row(BannedBy, "admin");
		mysql_fetch_field_row(BannedReason, "reason");
		mysql_fetch_field_row(savingstring, "day"); BannedDay = strval(savingstring);
		mysql_fetch_field_row(savingstring, "month"); BannedMonth = strval(savingstring);
		mysql_fetch_field_row(savingstring, "year"); BannedYear = strval(savingstring);
		mysql_fetch_field_row(savingstring, "hour"); BannedHour = strval(savingstring);
		mysql_fetch_field_row(savingstring, "minutes"); BannedMinute = strval(savingstring);
		mysql_fetch_field_row(BannedName, "nick");
		mysql_fetch_field_row(BannedIP, "ip");

		format(string,sizeof(string),"From %02d/%02d/%d to %02d:%02d %s(%s) banned for %s\n",
			BannedDay,
			BannedMonth,
			BannedYear,
			BannedHour,
			BannedMinute,
			BannedBy,
			BannedName,
			BannedIP,
			BannedReason
		);

		SendClientMessage(playerid,Yellow,string);
	}
	else
	{
	    SendClientMessage(playerid,Red,"No ban found!");
	}
	mysql_free_result();
	return 1;
}


CMD:ban(playerid,params[])
{
	new
	    playerID,
	    reason[124],
	    LogString[256],
	    string[256],
	    plrIP[16]
	;

    gettime(Hours,Minutes,Segundos); getdate(Year,Month,Day);
    GetPlayerIp(playerid,plrIP,sizeof(plrIP));

    if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!");
    if(sscanf(params,"ds",playerID,reason)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /ban [ID] [Reason]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");
    //if(PlayerInfo[playerID][Admin] >= 3 && IsPlayerAdmin(playerID)) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");

	PlayerInfo[playerID][Banned] = 1;

	new ip[16];
	GetPlayerIp(playerID,ip,sizeof(ip));

	format(string,sizeof(string),"INSERT INTO bans (admin,reason,day,month,year,hour,minutes,nick,ip) VALUES('%s','%s',%d,%d,%d,%d,%d,'%s','%s')",nome(playerid),reason,Day,Month,Year,Hours,Minutes,nome(playerID),ip);
	mysql_query(mysql, string);
	mysql_store_result();

    Kick(playerID);
	writeLog(AdminLog,LogString);
	return 1;
}

CMD:tempban(playerid,params[])
{
	/*new
	    playerID,
	    reason[100],
	    Days,
	    acstr[175]
	;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"usd",playerID,reason,Days)) return SendClientMessage(playerid,Gray,"use: /tempban <playerID> <rasao> <Days>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
	if(PlayerInfo[playerID][Admin] >= 3 && IsPlayerAdmin(playerID)) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");

	format(acstr,sizeof(acstr),"Admin %s baniu %s por %d day(s) por %s",nome(playerid),nome(playerID),Days,reason);
	SendClientMessageToAll(Red,acstr);

	TempBan(playerID, reason, Days);

	writeLog(AdminLog,acstr);*/
	return 1;
}

CMD:getip(playerid,params[])
{
	new pID;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"u",pID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /getip [ID]");
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Red,"Wrong ID!");

	new dest[22],string[256];

	new playaname[2][MAX_PLAYER_NAME];
	GetPlayerName(pID, playaname[1], MAX_PLAYER_NAME);

	NetStats_GetIpPort(pID, dest, sizeof(dest));
	format(string, sizeof(string),"====================| %s(%d) IP Infos: |====================", playaname[1], pID);
	SendClientMessage(playerid, Orange, string);
	format(string, sizeof(string),"Country: [%s] || City: [%s]", GetPlayerCountryName(pID), GetPlayerCountryRegion(pID));
	SendClientMessage(playerid, Yellow, string);
	format(string, sizeof(string), "ISP: [%s] || IP-PORT: [%s]", GetPlayerISP(pID), dest);
	SendClientMessage(playerid, Yellow, string);
	return 1;
}

/*CMD:unbanip(playerid,params[])
{
	new
	    unbanIP[16],
		String[128]
	;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!.");
	if(sscanf(params,"s[16]",unbanIP)) return SendClientMessage(playerid,Gray,"use: /unbanip <ip>");

	format(String,sizeof(String),"unbanip %s",unbanIP);
	SendRconCommand(String);

	writeLog(AdminLog,String);
	return 1;
}

CMD:unban(playerid,params[])
{
    if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso.");
    if(isnull(params)) return SendClientMessage(playerid,Gray,"use: /unbanip <nick>");

    new str[60],strz[126];

	format(str,sizeof(str),"SELECT * FROM bans WHERE nick = '%s'",params);

 	mysql_query(mysql, str);
	mysql_store_result();

	if(mysql_num_rows() > 0)
	{
		format(str, sizeof(str),"DELETE FROM bans WHERE nick = '%s'",params);
 		mysql_query(mysql, str);

		format(str,sizeof(str),"UPDATE accounts SET Banned=0 WHERE player = '%s'",params);
 		mysql_query(mysql, str);

 		format(strz,sizeof(strz),"Admin %s desbaniu a conta %s",nome(playerid),params);
 		SendAdminMessage(AdminColor,strz);
	}
	else
	{
		SendClientMessage(playerid,Red,"Esse nick não está banido.");
	}
	mysql_free_result();
    return 1;
}

CMD:goto(playerid, params[])
{
	new
	   	playerID,
	   	Float:Pos[3]
	;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"use: /goto <playerid>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");

	if(playerID != playerid)
	{
  		GetPlayerPos(playerID,Pos[0],Pos[1],Pos[2]);

	 	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
   			SetVehiclePos(GetPlayerVehicleID(playerid),Pos[0]+2,Pos[1],Pos[2]);
			LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerID));
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(playerID));
   		}
   		else
   		{
   			SetPlayerPos(playerid,Pos[0]+2,Pos[1],Pos[2]);
   			SetPlayerInterior(playerid,GetPlayerInterior(playerID));
	 		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(playerID));
		}
	}
	return 1;
}

CMD:get(playerid,params[])
{
    new
	    playerID,
		Float:Pos[3]
	;

    if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"use: /goto <playerid>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");
    if(PlayerInfo[playerID][Admin] >= 3 && IsPlayerAdmin(playerID)) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");

    if(playerID != playerid)
	{
		GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);

		if(GetPlayerState(playerID) == PLAYER_STATE_DRIVER)
		{
			new Veh = GetPlayerVehicleID(playerID);
			SetVehiclePos(Veh,Pos[0]+2,Pos[1],Pos[2]);
			LinkVehicleToInterior(Veh,GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(Veh,GetPlayerVirtualWorld(playerid));
		}
		else
		{
			SetPlayerPos(playerID,Pos[0]+2,Pos[1],Pos[2]);
			SetPlayerInterior(playerID,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(playerID,GetPlayerVirtualWorld(playerid));
		}
	}
	return 1;
}

CMD:freeze(playerid,params[])
{
	new
	    playerID,
	    acstr[100]
	;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"use: /freeze <playerid>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");

	TogglePlayerControllable(playerID,0);

	format(acstr,sizeof(acstr),"admin %s congelou %s",nome(playerid),nome(playerID));
	SendClientMessage(playerid,Red,acstr);
	return 1;
}

CMD:unfreeze(playerid,params[])
{
	new
	    playerID,
	    acstr[100]
	;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"use: /unfreeze <playerid>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");

	TogglePlayerControllable(playerID,1);

	format(acstr,sizeof(acstr),"admin %s descongelou %s",nome(playerid),nome(playerID));
	SendClientMessage(playerid,Red,acstr);
	return 1;
}*/

CMD:creports(playerid)
{
    if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!");

    for(new i,x = MAX_REPORTS; i !=x; i++)
	Reports[i] = "";

	SendClientMessage(playerid,White,"Reports cleaned.");
	return 1;
}

CMD:buildrace(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(BuildRace != 0) return SendClientMessage(playerid, Red, "Someone is already building a race!");
	if(RaceBusy == 0x01) return SendClientMessage(playerid, Red, "There is a race in progress, wait until it ends.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, Red, "Please leave your vehicle first.");

	BuildRace = playerid+1;
	ShowDialog(playerid, 599);
	return 1;
}

//----------------------------------------------------------
//  Comandos dos Admins: Level 1
//----------------------------------------------------------
CMD:kick(playerid,params[])
{
	new
	playerID,
	Motivo[100],
	acstr[175];

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"ds",playerID,Motivo)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /kick [ID] [Reason]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");
	if(PlayerInfo[playerID][Admin] >= 3 && IsPlayerAdmin(playerID)) return SendClientMessage(playerid,Red,"You don't have permissions!");

	format(acstr,sizeof(acstr),"you got kicked (Reason: %s)",Motivo);
	SendClientMessage(playerid,Red,acstr);
	Kick(playerID);

	writeLog(AdminLog,acstr);
	return 1;
}

/*CMD:slap(playerid,params[])
{
	new
	    playerID,
		String[100],
		Float:pos[3]
	;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"use: /slap <playerid>");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"PlayerID desconectado");

	GetPlayerPos(playerID,pos[0],pos[1],pos[2]);
	SetPlayerPos(playerID,pos[0],pos[1],pos[2]+15);

	format(String,sizeof(String),"Admin %s deu tapa em %s",nome(playerid),nome(playerID));
	//SendClientMessageToAll(Red,String);

	writeLog(AdminLog,String);

	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}*/

CMD:explode(playerid,params[])
{
	new
	playerID,
	Float:pos[3]
	;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"i",playerID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /explode [ID]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");

	GetPlayerPos(playerID,pos[0],pos[1],pos[2]);
	CreateExplosion(pos[0],pos[1],pos[2], 0, 8.0);



	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}

CMD:respawn(playerid,params[])
{
	new
	playerID,
	String[100]
	;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"i",playerID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /respawn [ID]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");

	SpawnPlayer(playerID);

	format(String,sizeof(String),"You got respawned by admin.",nome(playerid),nome(playerID));
	SendClientMessage(playerid,Red,String);


	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}

/*CMD:asay(playerid,params[])
{
	new
	    Mensagem[100],
		acstr[135]
	;

    if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"s[100]",Mensagem)) return SendClientMessage(playerid,Gray,"use: /asay <texto>");

	format(acstr,sizeof(acstr),"Admin %s: %s",nome(playerid),Mensagem);
	SendClientMessageToAll(Orange,acstr);
	return 1;
}*/

CMD:vehsadasdasddasdasdaada(playerid,params[])
{
    new
		veh[30],
		vehid
	;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"s[30]",veh)) return SendClientMessage(playerid,Gray,"use: /veh <nome/id>");

    if(IsNumeric(veh)) vehid = strval(veh);
        else vehid = ReturnVehicleModelID(veh);

    if(vehid < 400 || vehid > 611) return SendClientMessage(playerid,Red,"veículo invalido");

	GiveVehicle(playerid,vehid);
    return 1;
}

/*CMD:clearchat(playerid,params[])
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");

	for(new i = 0; i < 100; i++)
	{
		SendClientMessageToAll(-1,"");
	}
	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
}*/

CMD:mutedfasdad(playerid,params[])
{
	new acstr[175],Motivo[100];

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"uds[128]",params[0],params[1],params[2])) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /mute [ID] [Minutes] [Reason]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid,Red,"Wrong ID!");

	format(acstr,sizeof(acstr),"You got muted (Reason %s)",Motivo);
	SendClientMessageToAll(Red, acstr);

	SetTimerEx("DesmutarPlayer",60*1000*params[1],false,"i", params[0]);

	PlayerInfo[params[0]][MutedTime] = params[1];
	return 1;
}

CMD:unmutesadasd(playerid,params[])
{
	new acstr[128] ;

	if(PlayerInfo[playerid][Admin] < 2) return SendClientMessage(playerid,Red,"You don't have permissions!.");
	if(sscanf(params,"u", params[0])) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /unmute [ID]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid,Red,"Wrong ID!");

	format(acstr,sizeof(acstr),"You got unmuted.");
	SendClientMessageToAll(Red,acstr);

	DesmutarPlayer(params[0]);
	return 1;
}

CMD:spec(playerid,params[])
{
	new playerID;

	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(sscanf(params,"u",playerID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /spec [ID]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");
	if(playerid == playerID) return SendClientMessage(playerid,Red,"You cant spec yourself!");

	if(!IsPlayerInAnyVehicle(playerID))
	{

		TogglePlayerSpectating(playerid,1);
		PlayerSpectatePlayer(playerid,playerID);
		SetPlayerInterior(playerid,GetPlayerInterior(playerID));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(playerID));
	}
	else
	{

		TogglePlayerSpectating(playerid,1);
		PlayerSpectateVehicle(playerid,GetPlayerVehicleID(playerID));
		SetPlayerInterior(playerid,GetPlayerInterior(playerID));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(playerID));
	}
	return 1;
}

CMD:specoff(playerid)
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	TogglePlayerSpectating(playerid,0);
	return 1;
}


/*CMD:esconderijo(playerid)
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	SetPlayerPos(playerid,1412.639892,-1.787510,1000.924377);
	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, 1894);
	return 1;
}

CMD:hide(playerid)
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");

	if(AdminHide[playerid] == false)
	{
	    SendClientMessage(playerid,ColorChat,"Agora você está no modo Admin invisível.");
	    AdminHide[playerid] = true;
	}
	else if(AdminHide[playerid] == true)
	{
	    SendClientMessage(playerid,ColorChat,"Agora você está no modo Admin visível.");
	    AdminHide[playerid] = false;
	}
	return 1;
}*/

CMD:reports(playerid)
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");

	new bool:ton;

	for(new i = 1; i < MAX_REPORTS; i++)
	{

		if(strcmp( Reports[i], "<none>", true) != 0)
		{

			ton = true;
			SendClientMessage(playerid,White,Reports[i]);
		}
	}

	if(!ton)return SendClientMessage(playerid,Gray,"No reports.");
	return 1;
}

CMD:infoacc(playerid,params[])
{
	//SendClientMessage(playerid,Red,"COMANDO DESABILITADO!");
	/*new nick[24],Arquivo[64],Lucas[600],Henrique[600];

    format(Arquivo,sizeof(Arquivo),"Accounts/%s.txt",params);

    if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
	if(sscanf(params,"s[24]",nick)) return SendClientMessage(playerid,Gray,"use: /infoacc <NICK>");
	if(!DOF2_FileExists(Arquivo)) return SendClientMessage(playerid,Red,"Essa conta não existe!");

	format(Lucas, sizeof(Lucas),"{2E93FF}NICK: {FFFFFF}%s\n",nick); strcat(Henrique, Lucas);
    format(Lucas, sizeof(Lucas),"{2E93FF}Admin Level: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"Admin")); strcat(Henrique, Lucas);
    format(Lucas, sizeof(Lucas),"{2E93FF}Level: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"Level")); strcat(Henrique, Lucas);
	format(Lucas, sizeof(Lucas),"{2E93FF}Kills: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"Kills")); strcat(Henrique, Lucas);
	format(Lucas, sizeof(Lucas),"{2E93FF}Deaths: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"Deaths")); strcat(Henrique, Lucas);
    format(Lucas, sizeof(Lucas),"{2E93FF}Tempo Mutado: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"MutedTime")); strcat(Henrique, Lucas);
    format(Lucas, sizeof(Lucas),"{2E93FF}Weapon Set: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"WeaponSet")); strcat(Henrique, Lucas);
    format(Lucas, sizeof(Lucas),"{2E93FF}Banido: {FFFFFF}%d\n", DOF2_GetInt(Arquivo,"Banned")); strcat(Henrique, Lucas);
	format(Lucas, sizeof(Lucas),"{2E93FF}Gang ID: {FFFFFF}%i\n", DOF2_GetInt(Arquivo,"Gang_Id")); strcat(Henrique, Lucas);

	ShowPlayerDialog(playerid,D_InfoAccount,DIALOG_STYLE_MSGBOX,"Informações da Conta:",Henrique,"Fechar","");*/
	return 1;
}

CMD:aka(playerid,params[])
{
	new playerID;

	if(PlayerInfo[playerid][Admin] >= 1 || IsPlayerAdmin(playerid))
	{

		if(sscanf(params,"i",playerID)) return SendClientMessage(playerid, Gray, "{FF0000}[USE]: /aka [ID]");

		new str[128], tmp3[50];
		playerID = strval(params);

		if(IsPlayerConnected(playerID) && playerID != INVALID_PLAYER_ID)
		{

			GetPlayerIp(playerID,tmp3,50);

			format(str,sizeof(str),"AKA: [%s ID:%d] [%s] %s", nome(playerID), playerID, tmp3, DOF2_GetString("aka.txt",tmp3));
			return SendClientMessage(playerid,Blue,str);
		}
		else return SendClientMessage(playerid, Red, "Wrong ID!");
	}
	else return SendClientMessage(playerid, Red, "You don't have permissions!");
}

CMD:races(playerid)
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");

	new
	rNameFile[64],
	string[64],
	str[512]
	;

	format(rNameFile, sizeof(rNameFile), "/rRaceSystem/RaceNames/RaceNames.txt");
	TotalRaces = dini_Int(rNameFile, "TotalRaces");

	Loop(x, TotalRaces)
	{

		format(string, sizeof(string), "Race_%d", x), strmid(RaceNames[x], dini_Get(rNameFile, string), 0, 20, sizeof(RaceNames));
		format(str,sizeof(str),"%s\n",RaceNames[x]);
		SendClientMessage(playerid,White,str);
	}
	return 1;
}

CMD:startrace(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"You don't have permissions!");
	if(AutomaticRace == true) return SendClientMessage(playerid, Red, "Auto race mode is on!");
	if(BuildRace != 0) return SendClientMessage(playerid, Red, "Someone is building a race.");
	if(RaceBusy == 0x01 || RaceStarted == 1) return SendClientMessage(playerid, Red, "There is a race in progress, wait until it ends.");
	if(isnull(params)) return SendClientMessage(playerid, Red, "/startrace [RACE]");

	LoadRace(playerid, params);
	return 1;
}

CMD:stoprace(playerid, params[])
{
   	if(PlayerInfo[playerid][Admin] < 1) return SendClientMessage(playerid,Red,"Você não tem permissão para isso");
    if(RaceBusy == 0x00 || RaceStarted == 0) return SendClientMessage(playerid, Red, "Não há nenhuma corrida em andamento.");

	new str[124];

	format(str,sizeof(str),">> Admin %s terminou a corrida.",nome(playerid));
	SendClientMessageToAll(Red, str);
	
	writeLog(AdminLog,str);
	return StopRace();
}

CMD:acmds(playerid)
{
    if(PlayerInfo[playerid][Admin] == 0) return
        SendClientMessage(playerid,Red,"You don't have permissions!");

    if(PlayerInfo[playerid][Admin] >= 1)
	{
        SendClientMessage(playerid,-1,"{EAFF00}Level 1 Commands");
        SendClientMessage(playerid,-1,"{FFFFFF}/explode, /respawn, /kick, /spec, /specoff");
        SendClientMessage(playerid,-1,"{FFFFFF}/reports, /aka, /pban, /races, /startrace, /stoprace");
	}
	if(PlayerInfo[playerid][Admin] >= 2)
	{
        SendClientMessage(playerid,-1,"{EAFF00}Level 2 Commands");
        SendClientMessage(playerid,-1,"{FFFFFF}/randommap, /startmap, /ban, /getip, /unbanip, /creports, /buildrace");
	}
    if(PlayerInfo[playerid][Admin] >= 3)
	{
        SendClientMessage(playerid,-1,"{EAFF00}Level 3 Commands");
        SendClientMessage(playerid,-1,"{FFFFFF}/setadmin, /leaveadmin, /svconfig, /authnick, /startautorace, /stopautorace");
 	}
	return 1;
}
//----------------------------------------------------------
//  Players commands
//----------------------------------------------------------
CMD:skin(playerid,params[])
{
	new SkinID,
		String[40]
	;

	if(sscanf(params,"d",SkinID)) return SendClientMessage(playerid,Gray,"use: /skin <id>");
	if(SkinID < 9 || SkinID > 299)
	{
		SendClientMessage(playerid, Red, "You cant use this skin!");
  	}
  	else
  	{
  	    SetPlayerSkin(playerid, SkinID);
  	    format(String, sizeof(String), "skin %d", SkinID);
       	SendClientMessage(playerid, -1, String);
  	}
	return 1;
}

CMD:weather(playerid,params[])
{
	new WeatherID,
	String[40]
	;

	if(sscanf(params,"d",WeatherID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /weather [ID]");
	if(WeatherID < 0 || WeatherID > 50)
	{

		SendClientMessage(playerid, Red, "You cant use this weather.");
	}
	else
	{

		SetPlayerWeather(playerid, WeatherID);
		format(String, sizeof(String), "Weather %d", WeatherID);
		SendClientMessage(playerid, White, String);
	}
	return 1;
}

CMD:time(playerid,params[])
{
	new TimeID,
	String[40]
	;

	if(sscanf(params,"d",TimeID)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /time [ID]");
	if(TimeID < 0 || TimeID > 24)
	{

		SendClientMessage(playerid, Red, "You cant use this time.");
	}
	else
	{

		SetPlayerTime(playerid, TimeID, 0);
		format(String, sizeof(String), "Time %d", TimeID);
		SendClientMessage(playerid, White, String);
	}
	return 1;
}

CMD:pm(playerid,params[])
{
	new playerID,
	String[200],
	Msg[150]
	;

	if(sscanf(params,"us[150]",playerID, Msg)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /pm [ID] [Text]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");

	format(String,sizeof(String),"*** PM sent to %s (ID:%i): %s",nome(playerID),playerID,Msg);
	SendClientMessage(playerid, 0xFFD700FF, String);

	format(String,sizeof(String),"*** PM recived from %s (ID:%i): %s",nome(playerid),playerid,Msg);
	SendClientMessage(playerID, 0xFFD700FF, String);
	return 1;
}


CMD:sync(playerid)
{
	if(Spawnado[playerid] == false) return SendClientMessage(playerid,Red,"You need to be spawned for use this command.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red,"You cant use this command in vehicle.");
	if(PlayerInfo[playerid][P_SYNCALLOWED] == 0) return SendClientMessage(playerid,Red,"Wait some seconds for use this command again.");

	syncPlayer(playerid);
	return 1;
}

CMD:s(playerid)
{
	return cmd_sync(playerid);
}

/*CMD:admins(playerid,params[])
{
 	new acstr[200],acstr2[200];
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
  		if(PlayerInfo[i][Admin] >= 1 && AdminHide[i] == false)
   		{
			format(acstr,sizeof(acstr),"%s(ID: %d) - Level: %d\n", nome(i), i, PlayerInfo[i][Admin]);
			strcat(acstr2, acstr);
		}
	}

    ShowPlayerDialog(playerid,4498,DIALOG_STYLE_MSGBOX,"Admins Online",acstr2,"Fechar","");
	return 1;
}

CMD:offadmins(playerid)
{
    format(query,sizeof(query),"SELECT * FROM `accounts` WHERE Admin > 0");
	mysql_query(mysql, query);
	mysql_store_result();

	new aNome[MAX_PLAYER_NAME], aLevel[5], num;

	while(mysql_retrieve_row())
	{
	    mysql_fetch_field_row(aNome, "Username");
        mysql_fetch_field_row(aLevel, "Admin");
        num++;
	}
	
	format(string,sizeof(string),"{FF0000}Nick: {FFFFFF}%s {FF0000}Level: {FFFFFF}%d");

	ShowPlayerDialog(playerid,9559,DIALOG_STYLE_MSGBOX,"Admins Offline",string,"Fechar","");
	mysql_free_result();
	return 1;
}*/

CMD:weaponset(playerid)
{
	if(Spawnado[playerid] == true) return SendClientMessage(playerid,Red,"Command cant be used while youre spawned!");
	ShowPlayerDialog(playerid,D_WeaponSet,DIALOG_STYLE_LIST,"Weapon Set","Deagle/Pump/M4/Rifle\nDeagle/Pump/Ak-47/Sniper\nDeagle/Spas/MP5/M4\nRandom Set","Select","Cancel");
	return 1;
}

/*CMD:hitsound(playerid)
{
	if(HitSound[playerid] == true)
	{
	    HitSound[playerid] = false;
	    SendClientMessage(playerid,Orange,"hitsound off");
	}
	else if(HitSound[playerid] == false)
	{
	    HitSound[playerid] = true;
	    SendClientMessage(playerid,Orange,"hitsound on");
	}
	return 1;
}*/

CMD:duel(playerid,params[])
{
	new weapon1,weapon2,string[200],Float:pHealth;
	GetPlayerHealth(playerid,pHealth);

	if(sscanf(params,"ii",weapon1,weapon2)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /duel [WEP 1] [WEP 2]");
	if(Spawnado[playerid] == false) return SendClientMessage(playerid,Red,"You are not spawned");
	if(Duel[playerid] == 999) return SendClientMessage(playerid,Red,"Youre already in a duel");
	if(EmDuelo[playerid] == 1) return SendClientMessage(playerid,Red,"Youre already in a duel");
	if(pHealth < 70.0) return SendClientMessage(playerid,Red,"You need at least 70 HP for request a duel");

	Duel[playerid] = 999;
	EmDuelo[playerid] = 1;

    SetPlayerPos(playerid, 1415.6921,-21.1801,1000.9258);
	SetPlayerFacingAngle(playerid, 87.5832);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid,0);

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, weapon1, 999);
	GivePlayerWeapon(playerid, weapon2, 999);

	DuelWeapons[playerid][0] = weapon1;
	DuelWeapons[playerid][1] = weapon2;

	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);

	SetPlayerVirtualWorld(playerid, playerid);
	SetPlayerInterior(playerid, 1);

	format(string,sizeof(string),"*** %s requested a duel (%s+%s) /goduel %d ***",nome(playerid),weaponNames[weapon1],weaponNames[weapon2],playerid);
	SendClientMessageToAll(0xD5D48FFF,string);
	return 1;
}

CMD:goduel(playerid,params[])
{
	new id,string[200];

	if(sscanf(params,"d",id)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /duel [ID]");
	if(Duel[playerid] == 999) return SendClientMessage(playerid,Red,"Youre already in a duel");
	if(Duel[id] != 999) return SendClientMessage(playerid,Red,"This duel doesen't exist, or someone already playing it!");
	if(id == playerid) return SendClientMessage(playerid,Red,"You cant duel with yourself!");

	Duel[id] = playerid;
	Duel[playerid] = id;
	EmDuelo[playerid] = 1;

    SetPlayerPos(playerid, 1362.2002,-20.9850,1000.9219);
	SetPlayerFacingAngle(playerid, 271.2359);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid,0);

	ResetPlayerWeapons(playerid);
 	GivePlayerWeapon(playerid, DuelWeapons[id][0], 999);
	GivePlayerWeapon(playerid, DuelWeapons[id][1], 999);

	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);

	SetPlayerVirtualWorld(playerid, id);
	SetPlayerInterior(playerid, 1);

	Contagem(playerid,id);

	format(string,sizeof(string),"*** %s accepted duel request by %s ***",nome(playerid),nome(id));
	SendClientMessageToAll(0xD5D48FFF,string);
	return 1;
}

CMD:rq(playerid)
{
	if(Duel[playerid] == 999)
	{
		SpawnPlayer(playerid);
		Duel[playerid] = 998;
		return 1;
	}

	if(Duel[playerid] == 998) return SendClientMessage(playerid,Red,"You are not in a duel!");

    SetPlayerArmour(Duel[playerid], 0.0);
	SetPlayerArmour(playerid, 0.0);

	SpawnPlayer(Duel[playerid]);
	SpawnPlayer(playerid);

	new sring[100];
	format(sring,sizeof sring,"*** %s RAGE-QUIT against %s ***",nome(playerid),nome(Duel[playerid]));
	SendClientMessageToAll(0xE6E465FF,sring);
	return 1;
}

CMD:votemap(playerid,params[])
{
	if(VoteON == true) return SendClientMessage(playerid,Red,"There is already a vote in progress!");

	new str[124];

	VotesNewMap = 0;
	VoteON = true;
	SendClientMessage(playerid,Green,"Votemap started!");

	TextDrawShowForAll(Text:VoteMap[0]);
	TextDrawShowForAll(Text:VoteMap[1]);

	format(str,sizeof(str),"~r~%s ~w~voting to change the map",nome(playerid));
	TextDrawSetString(Text:VoteMap[2],str);
	TextDrawShowForAll(Text:VoteMap[2]);

	TextDrawShowForAll(Text:VoteMap[3]);

	SetTimer("ResultVoteMap",10000,false);
	return 1;
}

CMD:credits(playerid)
{
	SendClientMessage(playerid, Red, "• BATTLEFIELD •");
	SendClientMessage(playerid, White, "Scripted by RBK Brigades Enterprises");
	SendClientMessage(playerid, White, "Helped by StK Clan");
	return 1;
}

CMD:report(playerid,params[])
{
	new
	playerID,
	Motivo[75],
	String[125]
	;

	if(sscanf(params,"ds[75]",playerID,Motivo)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /report [ID] [Reason]");
	if(!IsPlayerConnected(playerID)) return SendClientMessage(playerid,Red,"Wrong ID!");
	if(playerID == playerid) return SendClientMessage(playerid,Red,"You cant report yourself!");

	format(String,sizeof(String),"{FF0000}REPORT: {00C48D}%s(%d) reported %s(%d) (Reason: {FF0000}%s)",nome(playerid),playerid,nome(playerID),playerID,Motivo);
	SendAdminMessage(AdminColor,String);

	for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
	Reports[MAX_REPORTS-1] = String;

	for(new m = 0; m < MAX_PLAYERS; m++)
	{

		if(PlayerInfo[m][Admin] > 0)
		{

			GameTextForPlayer(m,"~r~] ~y~NEW REPORT! ~r~]",3000,3);
			PlayerPlaySound(m,1056,0.0,0.0,0.0);
		}
	}

	SendClientMessage(playerid,White,"Your report was sent to admins.");
	return 1;
}

CMD:afk(playerid)
{
	new afkString[128];

	if(pAFK[playerid] == false)
	{

		pAFK[playerid] = true;

		new Float:pHealth;

		GetPlayerHealth(playerid,pHealth);
		if(pHealth < 80) return SendClientMessage(playerid,Red,"You need to have 80HP to use this command!");


		tAFK[playerid] = 30;
		TimerAFK[playerid] = SetTimerEx("TimeAFK", 1000, true, "d", playerid);

		ResetPlayerWeapons(playerid);
		SetPlayerHealth(playerid, 99999.0);
		SetPlayerInterior(playerid,15);
		SetPlayerPos(playerid,2215.454833,-1147.475585,1025.796875);
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));

		SetPlayerChatBubble(playerid, "Player AFK..", 0xFFFFFFAA, 20.0, 30000);

		format(afkString,sizeof(afkString),"%s(ID: %i) is now AFK.",nome(playerid),playerid);
		SendClientMessageToAll(0xFF333FFF,afkString);
	}

	if(pAFK[playerid] == true && tAFK[playerid] < 30)
	{

		pAFK[playerid] = false;
		tAFK[playerid] = 0;

		SpawnPlayer(playerid);

		format(afkString,sizeof(afkString),"%s(ID: %i) is now back from AFK.",nome(playerid),playerid);
		SendClientMessageToAll(0xFF333FFF,afkString);
	}
	else
	{

		SendClientMessage(playerid, Red, "You need to stay at least 30 seconds AFK in order to return to the game!");
	}
	return 1;
}

CMD:changepass(playerid,params[])
{
	new newPass[16],String[128];

	if(PlayerInfo[playerid][Logged] == 0) return SendClientMessage(playerid,Red,"You must be logged in to use this command!");
	if(sscanf(params,"s[16]",newPass)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /changepass [PASSWORD]");
	if(Spawnado[playerid] == false) return SendClientMessage(playerid,Red,"You must be spawned to use this command!");

	if(strlen(newPass) < 4 || strlen(newPass) > 16) return SendClientMessage(playerid, Red, "The password must be 4-16 characters.");

	format(String, sizeof(String),"UPDATE `accounts` SET Password = sha1('%s') WHERE `Username` = '%s'",newPass,nome(playerid));
	mysql_query(mysql, String);
	mysql_store_result();

	format(String,sizeof(String),"Your password has been changed");
	SendClientMessage(playerid, White, String);
	return 1;
}

CMD:changename(playerid,params[])
{
	new String[128],newNick[26],Folder[60];

	if(PlayerInfo[playerid][Logged] == 0) return SendClientMessage(playerid,Red,"You must be logged in to use this command!");
	if(sscanf(params,"s[26]",newNick)) return SendClientMessage(playerid,Gray,"{FF0000}[USE]: /changename [NICK]");

	format(Folder,sizeof(Folder),"Accounts/%s.txt",newNick);

	if(Spawnado[playerid] == false) return SendClientMessage(playerid,Red,"You must be spawned to use this command!");
	if(PlayerInfo[playerid][Admin] >= 1 && Autorizado[playerid] == false) return SendClientMessage(playerid, Red, "Administrators can not change your nickname without authorization!");
	if(strlen(newNick) < 4 || strlen(newNick) > 20) return SendClientMessage(playerid, Red, "The nickname must contain 4-20 characters.");

	format(String,sizeof(String),"%s changed his nick to %s");

	new str[140];

	format(str,sizeof(str),"UPDATE `accounts` SET Username = '%s' WHERE `Username` = '%s'",newNick,nome(playerid));
	mysql_query(mysql, str);
	mysql_store_result();

	SetPlayerName(playerid, params[0]);

	format(String,sizeof(String),"Your nick has been changed to: %s",newNick);
	SendClientMessage(playerid, White, String);
	return 1;
}

CMD:rules(playerid)
{
	ShowRules(playerid);
	return 1;
}

CMD:race(playerid, params[])
{
	if(RaceStarted == 1) return SendClientMessage(playerid, Red, "There is a race in progress, wait until it ends.");
	if(RaceBusy == 0x00) return SendClientMessage(playerid, Red, "There is no races aviable!");
	if(Joined[playerid] == true) return SendClientMessage(playerid, Red, "You are already in a race!");
	if(IsPlayerInAnyVehicle(playerid)) return SetTimerEx("SetupRaceForPlayer", 1500, 0, "e", playerid), RemovePlayerFromVehicle(playerid), Joined[playerid] = true;
	if(pAFK[playerid] == true) return SendClientMessage(playerid, Red, "You cant use this command while begin in AFK mode.\nIf you want to quit afk mode please digit /afk.");

	SetupRaceForPlayer(playerid);
	Joined[playerid] = true;

	new str[124];
	format(str,sizeof(str),"%s entered the race! (/race).",nome(playerid));
	SendClientMessageToAll(Green,str);
	return 1;
}

CMD:leaverace(playerid, params[])
{
	if(pAFK[playerid] == true) return SendClientMessage(playerid, Red, "You cant use this command while begin in AFK mode.\nIf you want to quit afk mode please digit /afk.");
	if(Joined[playerid] == true)
	{

		JoinCount--;
		Joined[playerid] = false;
		DestroyVehicle(CreatedRaceVeh[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		TextDrawHideForPlayer(playerid, RaceInfo[playerid]);
		CPProgess[playerid] = 0;
		KillTimer(InfoTimer[playerid]);
		TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
		SpawnPlayer(playerid);

		new str[124];
		format(str,sizeof(str),"%s quit the race (/leaverace).",nome(playerid));
		SendClientMessageToAll(Orange,str);

		#if defined RACE_IN_OTHER_WORLD
		SetPlayerVirtualWorld(playerid, 0);
		#endif
	} else return SendClientMessage(playerid, Red, "You are not in race!");
	return 1;
}

CMD:cmds(playerid)
{
	SendClientMessage(playerid,White,"{0062FF}*** Server Commands");
	SendClientMessage(playerid,White,"{0062FF}*** {9C9C9C}/credits, /report, /skin, /weather, /time, /pm, /sync, /changepass. /acmds");
	SendClientMessage(playerid,White,"{0062FF}*** {9C9C9C}/duel, /goduel, /rq, /weaponset, /votemap, /changename, /rules, /afk");
	SendClientMessage(playerid,White,"{0062FF}*** {FF0000}Events Commands: {9C9C9C}/race, /leaverace");
	return 1;
}

//----------------------------------------------------------
//
//  Functii in plus
//
//----------------------------------------------------------

function LoadRaceNames()
{
	new
	    rNameFile[64],
	    string[64]
	;
	format(rNameFile, sizeof(rNameFile), "/rRaceSystem/RaceNames/RaceNames.txt");
	TotalRaces = dini_Int(rNameFile, "TotalRaces");
	Loop(x, TotalRaces)
	{
	    format(string, sizeof(string), "Race_%d", x), strmid(RaceNames[x], dini_Get(rNameFile, string), 0, 20, sizeof(RaceNames));
	    printf(">> Loaded Races: %s", RaceNames[x]);
	}
	return 1;
}

function LoadAutoRace(rName[])
{
	new
		rFile[256],
		string[256]
	;
	format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", rName);
	if(!dini_Exists(rFile)) return printf("Race \"%s\" doesn't exist!", rName);
	strmid(RaceName, rName, 0, strlen(rName), sizeof(RaceName));
	RaceVehicle = dini_Int(rFile, "vModel");
	RaceType = dini_Int(rFile, "rType");
	TotalCP = dini_Int(rFile, "TotalCP");

	#if DEBUG_RACE == 1
	printf("Veiculo: %d", RaceVehicle);
	printf("Tipo: %d", RaceType);
	printf("Total de CPS: %d", TotalCP);
	#endif

	Loop(x, 2)
	{
		format(string, sizeof(string), "vPosX_%d", x), RaceVehCoords[x][0] = dini_Float(rFile, string);
		format(string, sizeof(string), "vPosY_%d", x), RaceVehCoords[x][1] = dini_Float(rFile, string);
		format(string, sizeof(string), "vPosZ_%d", x), RaceVehCoords[x][2] = dini_Float(rFile, string);
		format(string, sizeof(string), "vAngle_%d", x), RaceVehCoords[x][3] = dini_Float(rFile, string);
		#if DEBUG_RACE == 1
		printf("Veiculos Pos %d: %f, %f, %f, %f", x, RaceVehCoords[x][0], RaceVehCoords[x][1], RaceVehCoords[x][2], RaceVehCoords[x][3]);
		#endif
	}
	Loop(x, TotalCP)
	{
 		format(string, sizeof(string), "CP_%d_PosX", x), CPCoords[x][0] = dini_Float(rFile, string);
 		format(string, sizeof(string), "CP_%d_PosY", x), CPCoords[x][1] = dini_Float(rFile, string);
 		format(string, sizeof(string), "CP_%d_PosZ", x), CPCoords[x][2] = dini_Float(rFile, string);
 		#if DEBUG_RACE == 1
 		printf("CP %d: %f, %f, %f", x, CPCoords[x][0], CPCoords[x][1], CPCoords[x][2]);
 		#endif
	}
	Position = 0;
	FinishCount = 0;
	JoinCount = 0;
	Loop(x, 2) PlayersCount[x] = 0;
	CountAmount = COUNT_DOWN_TILL_RACE_START;
	RaceTime = MAX_RACE_TIME;
	RaceBusy = 0x01;
	CountTimer = SetTimer("CountTillRace", 999, 1);
	TimeProgress = 0;
	return 1;
}

function LoadRace(playerid, rName[])
{
	new
		rFile[256],
		string[256]
	;
	format(rFile, sizeof(rFile), "/rRaceSystem/%s.RRACE", rName);
	if(!dini_Exists(rFile)) return SendClientMessage(playerid, Red, "Race não existe"), printf("Race \"%s\" não existe!", rName);
	strmid(RaceName, rName, 0, strlen(rName), sizeof(RaceName));
	RaceVehicle = dini_Int(rFile, "vModel");
	RaceType = dini_Int(rFile, "rType");
	TotalCP = dini_Int(rFile, "TotalCP");

	#if DEBUG_RACE == 1
	printf("VehicleModel: %d", RaceVehicle);
	printf("RaceType: %d", RaceType);
	printf("TotalCheckpoints: %d", TotalCP);
	#endif

	Loop(x, 2)
	{
		format(string, sizeof(string), "vPosX_%d", x), RaceVehCoords[x][0] = dini_Float(rFile, string);
		format(string, sizeof(string), "vPosY_%d", x), RaceVehCoords[x][1] = dini_Float(rFile, string);
		format(string, sizeof(string), "vPosZ_%d", x), RaceVehCoords[x][2] = dini_Float(rFile, string);
		format(string, sizeof(string), "vAngle_%d", x), RaceVehCoords[x][3] = dini_Float(rFile, string);
		#if DEBUG_RACE == 1
		printf("VehiclePos %d: %f, %f, %f, %f", x, RaceVehCoords[x][0], RaceVehCoords[x][1], RaceVehCoords[x][2], RaceVehCoords[x][3]);
		#endif
	}
	Loop(x, TotalCP)
	{
 		format(string, sizeof(string), "CP_%d_PosX", x), CPCoords[x][0] = dini_Float(rFile, string);
 		format(string, sizeof(string), "CP_%d_PosY", x), CPCoords[x][1] = dini_Float(rFile, string);
 		format(string, sizeof(string), "CP_%d_PosZ", x), CPCoords[x][2] = dini_Float(rFile, string);
 		#if DEBUG_RACE == 1
 		printf("RaceCheckPoint %d: %f, %f, %f", x, CPCoords[x][0], CPCoords[x][1], CPCoords[x][2]);
 		#endif
	}
	Position = 0;
	FinishCount = 0;
	JoinCount = 0;
	Loop(x, 2) PlayersCount[x] = 0;
	Joined[playerid] = true;
	CountAmount = COUNT_DOWN_TILL_RACE_START;
	RaceTime = MAX_RACE_TIME;
	RaceBusy = 0x01;
	TimeProgress = 0;
	SetupRaceForPlayer(playerid);
	CountTimer = SetTimer("CountTillRace", 999, 1);
	return 1;
}

function SetCP(playerid, PrevCP, NextCP, MaxCP, Type)
{
	if(Type == 0)
	{
		if(NextCP == MaxCP) SetPlayerRaceCheckpoint(playerid, 1, CPCoords[PrevCP][0], CPCoords[PrevCP][1], CPCoords[PrevCP][2], CPCoords[NextCP][0], CPCoords[NextCP][1], CPCoords[NextCP][2], RACE_CHECKPOINT_SIZE);
			else SetPlayerRaceCheckpoint(playerid, 0, CPCoords[PrevCP][0], CPCoords[PrevCP][1], CPCoords[PrevCP][2], CPCoords[NextCP][0], CPCoords[NextCP][1], CPCoords[NextCP][2], RACE_CHECKPOINT_SIZE);
	}
	else if(Type == 3)
	{
		if(NextCP == MaxCP) SetPlayerRaceCheckpoint(playerid, 4, CPCoords[PrevCP][0], CPCoords[PrevCP][1], CPCoords[PrevCP][2], CPCoords[NextCP][0], CPCoords[NextCP][1], CPCoords[NextCP][2], RACE_CHECKPOINT_SIZE);
			else SetPlayerRaceCheckpoint(playerid, 3, CPCoords[PrevCP][0], CPCoords[PrevCP][1], CPCoords[PrevCP][2], CPCoords[NextCP][0], CPCoords[NextCP][1], CPCoords[NextCP][2], RACE_CHECKPOINT_SIZE);
	}
	return 1;
}

function SetupRaceForPlayer(playerid)
{
	ResetPlayerWeapons(playerid);
	CPProgess[playerid] = 0;
	TogglePlayerControllable(playerid, false);
	CPCoords[playerid][3] = 0;
	SetCP(playerid, CPProgess[playerid], CPProgess[playerid]+1, TotalCP, RaceType);
	if(IsOdd(playerid)) Index = 1;
	    else Index = 0;

	switch(Index)
	{
		case 0:
		{
		    if(PlayersCount[0] == 1)
		    {
				RaceVehCoords[0][0] -= (6 * floatsin(-RaceVehCoords[0][3], degrees));
		 		RaceVehCoords[0][1] -= (6 * floatcos(-RaceVehCoords[0][3], degrees));
		   		CreatedRaceVeh[playerid] = CreateVehicle(RaceVehicle, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2]+2, RaceVehCoords[0][3], random(126), random(126), (60 * 60));
				SetPlayerPos(playerid, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2]+2);
				SetPlayerFacingAngle(playerid, RaceVehCoords[0][3]);
				PutPlayerInVehicle(playerid, CreatedRaceVeh[playerid], 0);
				Camera(playerid, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2], RaceVehCoords[0][3], 20);
			}
		}
		case 1:
 		{
 		    if(PlayersCount[1] == 1)
 		    {
				RaceVehCoords[1][0] -= (6 * floatsin(-RaceVehCoords[1][3], degrees));
		 		RaceVehCoords[1][1] -= (6 * floatcos(-RaceVehCoords[1][3], degrees));
		   		CreatedRaceVeh[playerid] = CreateVehicle(RaceVehicle, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2]+2, RaceVehCoords[1][3], random(126), random(126), (60 * 60));
				SetPlayerPos(playerid, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2]+2);
				SetPlayerFacingAngle(playerid, RaceVehCoords[1][3]);
				PutPlayerInVehicle(playerid, CreatedRaceVeh[playerid], 0);
				Camera(playerid, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2], RaceVehCoords[1][3], 20);
    		}
 		}
	}
	switch(Index)
	{
	    case 0:
		{
			if(PlayersCount[0] != 1)
			{
		   		CreatedRaceVeh[playerid] = CreateVehicle(RaceVehicle, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2]+2, RaceVehCoords[0][3], random(126), random(126), (60 * 60));
				SetPlayerPos(playerid, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2]+2);
				SetPlayerFacingAngle(playerid, RaceVehCoords[0][3]);
				PutPlayerInVehicle(playerid, CreatedRaceVeh[playerid], 0);
				Camera(playerid, RaceVehCoords[0][0], RaceVehCoords[0][1], RaceVehCoords[0][2], RaceVehCoords[0][3], 20);
			    PlayersCount[0] = 1;
		    }
	    }
	    case 1:
	    {
			if(PlayersCount[1] != 1)
			{
		   		CreatedRaceVeh[playerid] = CreateVehicle(RaceVehicle, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2]+2, RaceVehCoords[1][3], random(126), random(126), (60 * 60));
				SetPlayerPos(playerid, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2]+2);
				SetPlayerFacingAngle(playerid, RaceVehCoords[1][3]);
				PutPlayerInVehicle(playerid, CreatedRaceVeh[playerid], 0);
				Camera(playerid, RaceVehCoords[1][0], RaceVehCoords[1][1], RaceVehCoords[1][2], RaceVehCoords[1][3], 20);
				PlayersCount[1] = 1;
		    }
   		}
	}
	new
	    string[256]
	;
	#if defined RACE_IN_OTHER_WORLD
	SetPlayerVirtualWorld(playerid, 10);
	#endif
	InfoTimer[playerid] = SetTimerEx("TextInfo", 500, 1, "e", playerid);
	if(JoinCount == 1) format(string, sizeof(string), "Race: ~w~%s~n~~p~~h~Checkpoint: ~w~%d/%d~n~~b~~h~Time: ~w~%s~n~~y~Place: ~w~1/1~n~ ", RaceName, CPProgess[playerid], TotalCP, TimeConvert(RaceTime));
	else format(string, sizeof(string), "Race: ~w~%s~n~~p~~h~Checkpoint: ~w~%d/%d~n~~b~~h~Time: ~w~%s~n~~y~Place: ~w~%d/%d~n~ ", RaceName, CPProgess[playerid], TotalCP, TimeConvert(RaceTime), RacePosition[playerid], JoinCount);

	TextDrawSetString(RaceInfo[playerid], string);
	TextDrawShowForPlayer(playerid, RaceInfo[playerid]);
	JoinCount++;
	return 1;
}

function CountTillRace()
{
	switch(CountAmount)
	{
 		case 0:
	    {
			ForEach(i, MAX_PLAYERS)
			{
			    if(Joined[i] == false)
			    {
			        new
			            string[128]
					;
					format(string, sizeof(string), ">> You cant join anymore the race \"%s\". Time to join expired!", RaceName);
					SendClientMessage(i, Red, string);
				}
			}
			StartRace();
	    }
	    case 1..5:
	    {
	        new
	            string[10]
			;
			format(string, sizeof(string), "~b~%d", CountAmount);
			ForEach(i, MAX_PLAYERS)
			{
			    if(Joined[i] == true)
			    {
			    	GameTextForPlayer(i, string, 999, 5);
			    	PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
			    }
			}
	    }
	    case 60, 50, 40, 30, 20, 10:
	    {
	        new
	            string[128]
			;
			format(string, sizeof(string), ">> In \"%d\" seconds race will \"%s\" start! Type \"/race\" to join the queue.", CountAmount, RaceName);
			SendClientMessageToAll(Green, string);
		}
	}
	return CountAmount--;
}

function StartRace()
{
	ForEach(i, MAX_PLAYERS)
	{
	    if(Joined[i] == true)
	    {
	        TogglePlayerControllable(i, true);
	        PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
  			GameTextForPlayer(i, "~g~GO GO GO", 3000, 5);
			SetCameraBehindPlayer(i);
	    }
	}
	rCounter = SetTimer("RaceCounter", 900, 1);
	RaceTick = GetTickCount();
	RaceStarted = 1;
	KillTimer(CountTimer);
	return 1;
}

function StopRace()
{
	KillTimer(rCounter);
	RaceStarted = 0;
	RaceTick = 0;
	RaceBusy = 0x00;
	JoinCount = 0;
	FinishCount = 0;
    TimeProgress = 0;

	ForEach(i, MAX_PLAYERS)
	{
	    if(Joined[i] == true)
	    {
	    	DisablePlayerRaceCheckpoint(i);
	    	DestroyVehicle(CreatedRaceVeh[i]);
	    	Joined[i] = false;
			TextDrawHideForPlayer(i, RaceInfo[i]);
			CPProgess[i] = 0;
			KillTimer(InfoTimer[i]);
		}
	}
	SendClientMessageToAll(Yellow, ">> The race is over!");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(Spawnado[i] == true && EmDuelo[i] == 0 && pAFK[i] == false)
		{
			SpawnPlayer(i);
		}
	}
	if(AutomaticRace == true) LoadRaceNames(), LoadAutoRace(RaceNames[random(TotalRaces)]);
	return 1;
}

function RaceCounter()
{
	if(RaceStarted == 1)
	{
		RaceTime--;
		if(JoinCount <= 0)
		{
			StopRace();
			SendClientMessageToAll(Red, ">> Race is over, noone joinet the race!");
		}
	}
	if(RaceTime <= 0)
	{
	    StopRace();
	}
	return 1;
}

function TextInfo(playerid)
{
	new
	    string[256]
	;
	if(JoinCount == 1) format(string, sizeof(string), "Race: ~w~%s~n~~p~~h~Checkpoint: ~w~%d/%d~n~~b~~h~Time: ~w~%s~n~~y~Place: ~w~1/1~n~", RaceName, CPProgess[playerid], TotalCP, TimeConvert(RaceTime));
	else format(string, sizeof(string), "Race: ~w~%s~n~~p~~h~Checkpoint: ~w~%d/%d~n~~b~~h~Time: ~w~%s~n~~y~Place: ~w~%d/%d~n~", RaceName, CPProgess[playerid], TotalCP, TimeConvert(RaceTime), RacePosition[playerid], JoinCount);

	TextDrawSetString(RaceInfo[playerid], string);
	TextDrawShowForPlayer(playerid, RaceInfo[playerid]);
	return 1;
}

function Camera(playerid, Float:X, Float:Y, Float:Z, Float:A, Mul)
{
	SetPlayerCameraLookAt(playerid, X, Y, Z);
	SetPlayerCameraPos(playerid, X + (Mul * floatsin(-A, degrees)), Y + (Mul * floatcos(-A, degrees)), Z+6);
}

function IsPlayerInRace(playerid)
{
	if(Joined[playerid] == true) return true;
	    else return false;
}

function ShowDialog(playerid, dialogid)
{
	switch(dialogid)
	{

		case 599: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, CreateCaption("Create a new race"), "\
		Normal Race\n\
		Airplanes Race", "Next", "Quit");

		case 600: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, CreateCaption("New race step 1/4"), "\
		Step 1:\n\
		********\n\
		Welcome to create a new race.\n\
		First to start give your race a name EX: SFRace (Don't use spacebar).\n\n\
		>> Press 'Next' to make things up. 'Back' to change something.", "Next", "Back");

		case 601: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, CreateCaption("New race step 1/4"), "\
		ERROR: Wrong name! (min. 1 - max. 20 characters)\n\n\n\
		Step 1:\n\
		********\n\
		First to start give your race a name EX: SFRace (Don't use spacebar).\n\n\
		>> Press 'Next' to make things up. 'Back' to change something.", "Next", "Back");

		case 602: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, CreateCaption("New race step 2/4"), "\
		Step 2:\n\
		********\n\
		Please type the vehicle name/id that you want to use in this race.\n\n\
		>> Press 'Next' to make things up. 'Back' to change something.", "Next", "Back");

		case 603: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, CreateCaption("New race step 2/4"), "\
		ERROR: Invalid Vehilce ID/Name\n\n\n\
		Step 2:\n\
		********\n\
		Please type the vehicle name/id that you want to use in this race.\n\n\
		>> Press 'Next' to make things up. 'Back' to change something.", "Next", "Back");

		case 604: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, CreateCaption("New race step 3/4"),
		"\
		Step 3:\n\
		********\n\
		Were almost done! Now go to the starting line, where the first and second car should be.\n\
		Note: When you click 'OK' you will be free. Use 'KEY_FIRE' to set the first position and the second position.\n\
		Nota: Once you have these positions, you'll automatically see a dialog box to continue the wizard.\n\n\
		>> Press 'Next' to make things up. 'Back' to change something.", "Next", "Back");

		case 605: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, CreateCaption("New race step 4/4"),
		"\
		Step 4:\n\
		********\n\
		Welcome to the last step. In this step you have to set the checkpoints, so if you click 'OK', you can set the checkpoints.\n\
		You can set the checkpoints with 'KEY_FIRE'. Each checkpoint you set will be saved.\n\
		You have to press 'ENTER' when you're done with everything. And your race'll be available!\n\n\
		>> Press 'OK' to make things up. 'Back' to change something.", "OK", "Back");

		case 606: ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, CreateCaption("New race done!"),
		"\
		Your race is now aviable!\n\n\
		>> Press 'Finish' to complete. 'Exit' to delete everything you done.", "Finish", "Exit");
	}
	return 1;
}

CreateCaption(arguments[])
{
	new
	    string[128 char]
	;
	format(string, sizeof(string), "Races - %s", arguments);
	return string;
}

stock IsValidVehicle(vehicleid)
{
	if(vehicleid < 400 || vehicleid > 611) return false;
	    else return true;
}

ReturnVehicleID(vName[])
{
	Loop(x, 211)
	{
	    if(strfind(vNames[x], vName, true) != -1)
		return x + 400;
	}
	return -1;
}

TimeConvert(seconds)
{
	new tmp[16];
 	new minutes = floatround(seconds/60);
  	seconds -= minutes*60;
   	format(tmp, sizeof(tmp), "%d:%02d", minutes, seconds);
   	return tmp;
}

ServerConfig(playerid)
{
    new cfg[512], cfg2[512];

    if(ServerInfo[ReadPMS] == true) {
		format(cfg,sizeof(cfg),"{FFFFFF}Read PMS {13E000}[ON]\n"); strcat(cfg2, cfg);
	}
	else {
 	   format(cfg,sizeof(cfg),"{FFFFFF}Read PMS {FF0000}[OFF]\n"); strcat(cfg2, cfg);
	}

    if(ServerInfo[ReadCMDS] == true) {
		format(cfg,sizeof(cfg),"{FFFFFF}Read Commands {13E000}[ON]\n"); strcat(cfg2, cfg);
	}
	else {
 	   format(cfg,sizeof(cfg),"{FFFFFF}Read Commands {FF0000}[OFF]\n"); strcat(cfg2, cfg);
	}

	format(cfg,sizeof(cfg),"{FFFFFF}Weather {FF0000}[%d]\n",ServerInfo[SVWeather]); strcat(cfg2, cfg);
	format(cfg,sizeof(cfg),"{FFFFFF}Time {FF0000}[%d]\n",ServerInfo[SVTime]); strcat(cfg2, cfg);
	
	format(cfg,sizeof(cfg),"{FFFFFF}Max Ping {FF0000}[%d]\n",ServerInfo[MaxPing]); strcat(cfg2, cfg);
	format(cfg,sizeof(cfg),"{FFFFFF}Min Fps {FF0000}[%d]\n",ServerInfo[MinFps]); strcat(cfg2, cfg);
	format(cfg,sizeof(cfg),"{FFFFFF}Max PL {FF0000}[%d]\n",ServerInfo[MaxPL]); strcat(cfg2, cfg);

    if(ServerInfo[NetCheck] == true) {
		format(cfg,sizeof(cfg),"{FFFFFF}NetCheck {13E000}[ON]\n"); strcat(cfg2, cfg);
	}
	else {
 	   format(cfg,sizeof(cfg),"{FFFFFF}NetCheck {FF0000}[OFF]\n"); strcat(cfg2, cfg);
	}

    if(ServerInfo[ConnectMessages] == true) {
		format(cfg,sizeof(cfg),"{FFFFFF}Aka Login {13E000}[ON]\n"); strcat(cfg2, cfg);
	}
	else {
 	   format(cfg,sizeof(cfg),"{FFFFFF}Aka Login {FF0000}[OFF]\n"); strcat(cfg2, cfg);
	}

    if(ServerInfo[AntiCBug] == true) {
		format(cfg,sizeof(cfg),"{FFFFFF}Anti C-Bug {13E000}[ON]\n"); strcat(cfg2, cfg);
	}
	else {
 	   format(cfg,sizeof(cfg),"{FFFFFF}Anti C-Bug {FF0000}[OFF]\n"); strcat(cfg2, cfg);
	}

	ShowPlayerDialog(playerid,D_SvConfig,DIALOG_STYLE_LIST,"Server Config",cfg2,"Change","Close");
	return 1;
}

ShowRules(playerid)
{
	new StringRules[1000],StringRules2[1100];

	format(StringRules,sizeof(StringRules),"                         {FF4545}Battlefield\n\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FFFFFF}Here is forbidden:\n\n\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}1 - {D4D4D4}Kill someone using vehicles (Carkill).\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}2 - {D4D4D4}Using any kind of cheat.\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}3 - {D4D4D4}Messages repeating (Flood/Spam).\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}4 - {D4D4D4}Racism and prejudice.\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}5 - {D4D4D4}Mods that give advantage.\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}6 - {D4D4D4}Disrespect to players.\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}7 - {D4D4D4}Admins/Mods exposing.\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FF4545}8 - {D4D4D4}Blame players of cheats (use /report or fraps them).\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"\n\n\n"); strcat(StringRules2, StringRules);
	format(StringRules,sizeof(StringRules),"{FFFFFF}Welcome to our server, have fun.\n"); strcat(StringRules2, StringRules);

	ShowPlayerDialog(playerid,D_Rules,DIALOG_STYLE_MSGBOX,"Server Rules",StringRules2,"I Agree","");
	return 1;
}

ResetVariables(playerid)
{
    PlayerInfo[playerid][Logged] = 0;
	PlayerInfo[playerid][Admin] = 0;
	PlayerInfo[playerid][Level] = 0;
	PlayerInfo[playerid][Kills] = 0;
	PlayerInfo[playerid][Deaths] = 0;
	PlayerInfo[playerid][MutedTime] = 0;
	PlayerInfo[playerid][WeaponSet] = 0;
	PlayerInfo[playerid][Banned] = 0;
	PlayerInfo[playerid][RacePoints] = 0;
}

Contagem(p1,p2)
{
	TogglePlayerControllable(p1,0);
	TogglePlayerControllable(p2,0);

	GameTextForPlayer(p1,"~n~~n~~n~~n~~n~~w~3",1000,3);
	GameTextForPlayer(p2,"~n~~n~~n~~n~~n~~w~3",1000,3);

	PlayerPlaySound(p1,1056,0,0,0);
	PlayerPlaySound(p2,1056,0,0,0);

	SetTimerEx("Cont",1000,false,"iii",p1,p2,2);
}

GivePlayerRandomWeapons(playerid)
{
    switch(random(3))
	{
		case 0:
		{
			GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,25,500); GivePlayerWeapon(playerid,31,500); GivePlayerWeapon(playerid,33,500);
		}
		case 1:
		{
			GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,25,500); GivePlayerWeapon(playerid,30,500); GivePlayerWeapon(playerid,34,500);
		}
		case 2:
		{
			GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,27,500); GivePlayerWeapon(playerid,29,500); GivePlayerWeapon(playerid,31,500);
		}
	}
}

GivePlayerWeaponSet(playerid)
{
	if(PlayerInfo[playerid][WeaponSet] == 1)
	{
        GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,25,500); GivePlayerWeapon(playerid,31,500); GivePlayerWeapon(playerid,33,500);
	}
    if(PlayerInfo[playerid][WeaponSet] == 2)
	{
        GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,25,500); GivePlayerWeapon(playerid,30,500); GivePlayerWeapon(playerid,34,500);
	}
	if(PlayerInfo[playerid][WeaponSet] == 3)
	{
        GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,27,500); GivePlayerWeapon(playerid,29,500); GivePlayerWeapon(playerid,31,500);
	}
}

GetWeaponType(weaponid) //explainin'
{
    switch(weaponid)
    {
        case 1: return 331; case 2: return 333; case 3: return 334; // this is to define the weapons
        case 4: return 335; case 5: return 336; case 6: return 337;
        case 7: return 338; case 8: return 339; case 9: return 341;
        case 10: return 321; case 11: return 322; case 12: return 323;
        case 13: return 324; case 14: return 325; case 15: return 326;
        case 16: return 342; case 17: return 343; case 18: return 344;
        case 22: return 346; case 23: return 347; case 24: return 348;
        case 25: return 349; case 26: return 350; case 27: return 351;
        case 28: return 352; case 29: return 353; case 30: return 355;
        case 31: return 356; case 32: return 372; case 33: return 357;
        case 34: return 358; case 35: return 359; case 36: return 360;
        case 37: return 361; case 38: return 362; case 39: return 363;
        case 41: return 365; case 42: return 366; case 46: return 371; //example, this case is the id 46 is the parachute, we will drop the parachute, that's if  you got one
    }
    return -1;
}

ReturnPlayerZone(playerid)
{
	new location[MAX_ZONE_NAME]; GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
    return location;
}

GetPlayer2DZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ ) if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4]) return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
	return 0;
}

syncPlayer(playerid)
{
	if(EmDuelo[playerid] == 1 && Duel[playerid] == 999) return SendClientMessage(playerid,Red,"You cant sync during duel!");
    if(pAFK[playerid] == true) return SendClientMessage(playerid,Red,"You cant sync during AKF mode!");

	GetPlayerArmour(playerid, PlayerInfo[playerid][P_ARMOUR]);
	GetPlayerHealth(playerid, PlayerInfo[playerid][P_HEALTH]);
	GetPlayerPos(playerid, pX, pY, pZ);
	GetPlayerFacingAngle(playerid, pF);

    StoreWeaponsData(playerid);

	SpawnPlayer(playerid);
	PlayerInfo[playerid][P_SYNCALLOWED] = false;
	PlayerInfo[playerid][P_INSYNC] = true;

	SetTimerEx("allowSync", 3500, false, "i", playerid);
	SetTimerEx("GiveSyncWeapons", 100, false, "i", playerid);
	return 1;
}

StoreWeaponsData(playerid)
{
    new slot, weap, ammo;
    for (slot = 0; slot < 13; slot++)
	{
        GetPlayerWeaponData(playerid, slot, weap, ammo);
        if(weap != 0)
        {
            switch(slot)
			{
               case 0:
               {
                   SetPVarInt(playerid, "slot0weap",weap);
                   SetPVarInt(playerid, "slot0ammo",ammo);
               }
               case 1:
               {
                   SetPVarInt(playerid, "slot1weap",weap);
                   SetPVarInt(playerid, "slot1ammo",ammo);
               }
               case 2:
               {
                   SetPVarInt(playerid, "slot2weap",weap);
                   SetPVarInt(playerid, "slot2ammo",ammo);
               }
               case 3:
               {
                   SetPVarInt(playerid, "slot3weap",weap);
                   SetPVarInt(playerid, "slot3ammo",ammo);
               }
               case 4:
               {
                   SetPVarInt(playerid, "slot4weap",weap);
                   SetPVarInt(playerid, "slot4ammo",ammo);
               }
               case 5:
               {
                   SetPVarInt(playerid, "slot5weap",weap);
                   SetPVarInt(playerid, "slot5ammo",ammo);
               }
               case 6:
               {
                   SetPVarInt(playerid, "slot6weap",weap);
                   SetPVarInt(playerid, "slot6ammo",ammo);
               }
               case 7:
               {
                   SetPVarInt(playerid, "slot7weap",weap);
                   SetPVarInt(playerid, "slot7ammo",ammo);
               }
               case 8:
               {
                   SetPVarInt(playerid, "slot8weap",weap);
                   SetPVarInt(playerid, "slot8ammo",ammo);
               }
               case 9:
               {
                   SetPVarInt(playerid, "slot9weap",weap);
                   SetPVarInt(playerid, "slot9ammo",ammo);
               }
               case 10:
               {
                   SetPVarInt(playerid, "slot10weap",weap);
                   SetPVarInt(playerid, "slot10ammo",ammo);
               }
               case 11:
               {
                   SetPVarInt(playerid, "slot11weap",weap);
                   SetPVarInt(playerid, "slot11ammo",ammo);
               }
               case 12:
               {
                   SetPVarInt(playerid, "slot12weap",weap);
                   SetPVarInt(playerid, "slot12ammo",ammo);
               }
			}
        }
    }
}

SetPlayerWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    if(GetPVarInt(playerid, "slot0weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot0weap"),GetPVarInt(playerid, "slot0ammo"));
    }
    if(GetPVarInt(playerid, "slot1weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot1weap"),GetPVarInt(playerid, "slot1ammo"));
    }
    if(GetPVarInt(playerid, "slot2weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot2weap"),GetPVarInt(playerid, "slot2ammo"));
    }
    if(GetPVarInt(playerid, "slot3weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot3weap"),GetPVarInt(playerid, "slot3ammo"));
    }
    if(GetPVarInt(playerid, "slot4weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot4weap"),GetPVarInt(playerid, "slot4ammo"));
    }
    if(GetPVarInt(playerid, "slot5weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot5weap"),GetPVarInt(playerid, "slot5ammo"));
    }
    if(GetPVarInt(playerid, "slot6weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot6weap"),GetPVarInt(playerid, "slot6ammo"));
    }
    if(GetPVarInt(playerid, "slot7weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot7weap"),GetPVarInt(playerid, "slot7ammo"));
    }
    if(GetPVarInt(playerid, "slot8weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot8weap"),GetPVarInt(playerid, "slot8ammo"));
    }
    if(GetPVarInt(playerid, "slot9weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot9weap"),GetPVarInt(playerid, "slot9ammo"));
    }
    if(GetPVarInt(playerid, "slot10weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot10weap"),GetPVarInt(playerid, "slot10ammo"));
    }
    if(GetPVarInt(playerid, "slot11weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot11weap"),GetPVarInt(playerid, "slot11ammo"));
    }
    if(GetPVarInt(playerid, "slot12weap") != 0)
    {
		GivePlayerWeapon(playerid,GetPVarInt(playerid, "slot12weap"),GetPVarInt(playerid, "slot12ammo"));
    }
}

newLog ( filename [ ] )
{
    if( fexist ( filename ) )
        return printf ( "[ERRO]: O arquivo %s já existe." , filename );
    return fclose ( fopen ( filename , io_write ) );
}

writeLog ( filename [ ] , text [ ] )
{
	new
 		str [ 128 ],
   		day,
     	month,
      	year,
       	hour,
       	minute,
        second,
        File: fileLog
	;

	if( !fexist ( filename ) )
	{
 		newLog ( filename );
 	}

	gettime ( hour , minute , second );
 	getdate ( year , month , day );

	fileLog = fopen ( filename , io_append );
 	format ( str , sizeof ( str ) , "[%02i/%02i/%04i - %02i:%02i:%02i]: %s\r\n" , day , month , year , hour , minute , second , text );
  	fwrite ( fileLog , str );
   	fclose ( fileLog );
    return 1;
}

DesmutarPlayer(playerid)
{
    PlayerInfo[playerid][MutedTime] = 0;
    SendClientMessage(playerid,Orange,"You are now unmuted by server!");
    return 1;
}

GiveVehicle(playerid,vehicleid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new Float:x,
			Float:y,
			Float:z,
			Float:angle,
			string2[85]
		;

	    if(CreatedVehicle[playerid]) DestroyVehicle(CreatedVehicle[playerid]);

		GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);

	    new veh = CreateVehicle(vehicleid, x, y, z, angle, -1, -1, -1);

		SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
		PutPlayerInVehicle(playerid, veh, 0);
		CreatedVehicle[playerid] = veh;

		format(string2,sizeof(string2),"%s(%d) created", VehicleNames[vehicleid-400],vehicleid);
		return SendClientMessage(playerid, Orange, string2);
	}
	return 1;
}

IsNumeric(string[])
{
	for (new i = 0, j = strlen(string);
	i < j; i++)
	{
		if(string[i] > '9' || string[i] < '0')
		return 0;
	}
	return 1;
}

ReturnVehicleModelID(Name[])
{
    for(new i; i != 211; i++) if(strfind(VehicleNames[i], Name, true) != -1) return i + 400;
    return INVALID_VEHICLE_ID;
}

SendAdminMessage(color,const strdoadm[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
  		if(IsPlayerConnected(i) == 1) if(PlayerInfo[i][Admin] >= 1) SendClientMessage(i, color, strdoadm);
    }
    return 0;
}

SetPlayerRandomPos(playerid)
{
    if(PlayerInfo[playerid][P_INSYNC] == 1)
	{
	    SetPlayerPos(playerid,pX,pY,pZ);
	    SetPlayerFacingAngle(playerid, pF);
	}
	else if(PlayerInfo[playerid][P_INSYNC] == 0)
	{
		switch(area)
		{
			case 0:
			{
				new rand = random(sizeof PalominioCreek);
				SetPlayerPos(playerid,PalominioCreek[rand][0],PalominioCreek[rand][1],PalominioCreek[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 1:
			{
				new rand = random(sizeof ArenaFarm);
				SetPlayerPos(playerid,ArenaFarm[rand][0],ArenaFarm[rand][1],ArenaFarm[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 2:
			{
				new rand = random(sizeof Area51);
				SetPlayerPos(playerid,Area51[rand][0],Area51[rand][1],Area51[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 3:
			{
				new rand = random(sizeof LVPD);
				SetPlayerPos(playerid,LVPD[rand][0],LVPD[rand][1],LVPD[rand][2]);
				SetPlayerInterior(playerid, 3);
			}
			case 4:
			{
				new rand = random(sizeof ArenaDepot);
				SetPlayerPos(playerid,ArenaDepot[rand][0],ArenaDepot[rand][1],ArenaDepot[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 5:
			{
				new rand = random(sizeof LasPayasadas);
				SetPlayerPos(playerid,LasPayasadas[rand][0],LasPayasadas[rand][1],LasPayasadas[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 6:
			{
				new rand = random(sizeof AngelPine);
				SetPlayerPos(playerid,AngelPine[rand][0],AngelPine[rand][1],AngelPine[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 7:
			{
				new rand = random(sizeof Doherty);
				SetPlayerPos(playerid,Doherty[rand][0],Doherty[rand][1],Doherty[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 8:
			{
				new rand = random(sizeof Willowfield);
				SetPlayerPos(playerid,Willowfield[rand][0],Willowfield[rand][1],Willowfield[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 9:
			{
				new rand = random(sizeof VerdantBluffs);
				SetPlayerPos(playerid,VerdantBluffs[rand][0],VerdantBluffs[rand][1],VerdantBluffs[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 10:
			{
				new rand = random(sizeof Rodeo);
				SetPlayerPos(playerid,Rodeo[rand][0],Rodeo[rand][1],Rodeo[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 11:
			{
				new rand = random(sizeof Industrial);
				SetPlayerPos(playerid,Industrial[rand][0],Industrial[rand][1],Industrial[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 12:
			{
				new rand = random(sizeof LasVenturas);
				SetPlayerPos(playerid,LasVenturas[rand][0],LasVenturas[rand][1],LasVenturas[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 13:
			{
				new rand = random(sizeof KACC);
				SetPlayerPos(playerid,KACC[rand][0],KACC[rand][1],KACC[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 14:
			{
				new rand = random(sizeof SantaFloria);
				SetPlayerPos(playerid,SantaFloria[rand][0],SantaFloria[rand][1],SantaFloria[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 15:
			{
				new rand = random(sizeof Dillimore);
				SetPlayerPos(playerid,Dillimore[rand][0],Dillimore[rand][1],Dillimore[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 16:
			{
				new rand = random(sizeof OceanDocks);
				SetPlayerPos(playerid,OceanDocks[rand][0],OceanDocks[rand][1],OceanDocks[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 17:
			{
				new rand = random(sizeof RockshoreEast);
				SetPlayerPos(playerid,RockshoreEast[rand][0],RockshoreEast[rand][1],RockshoreEast[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
			case 18:
			{
				new rand = random(sizeof ElCorona);
				SetPlayerPos(playerid,ElCorona[rand][0],ElCorona[rand][1],ElCorona[rand][2]);
				SetPlayerInterior(playerid, 0);
			}
		}
	}
}

nome(playerid)
{
	new NOME[24];
	GetPlayerName(playerid,NOME,sizeof(NOME));
	return NOME;
}

SalvarPlayer(playerid)
{
	new arquivo[256];

    format(arquivo,sizeof(arquivo),"UPDATE `accounts` SET Admin = %d, Level = %d, Kills = %d, Deaths = %d, MutedTime = %d, WeaponSet = %d, Banned = %d, RacePoints = '%d' WHERE Username = '%s'",

    PlayerInfo[playerid][Admin],
    GetPlayerScore(playerid),
    PlayerInfo[playerid][Kills],
    PlayerInfo[playerid][Deaths],
    PlayerInfo[playerid][MutedTime],
    PlayerInfo[playerid][WeaponSet],
    PlayerInfo[playerid][Banned],
	PlayerInfo[playerid][RacePoints],
	nome(playerid));
	
	mysql_query(mysql, arquivo);
    return 1;
}

CarregarPlayer(playerid)
{
	new arquivo[256],savingstring[256];

	format(arquivo,sizeof(arquivo),"SELECT * FROM `accounts` WHERE `Username` = '%s'",nome(playerid));

 	mysql_query(mysql, arquivo);
	mysql_store_result();
	
    while(mysql_fetch_row_format(arquivo,"|"))
    {
        mysql_fetch_field_row(savingstring, "Username"); nome(playerid);
        mysql_fetch_field_row(savingstring, "Password"); PlayerInfo[playerid][Password] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "Ip"); PlayerInfo[playerid][PIP] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "Admin"); PlayerInfo[playerid][Admin] = strval(savingstring);
		mysql_fetch_field_row(savingstring, "Level"); PlayerInfo[playerid][Level] = strval(savingstring);
		mysql_fetch_field_row(savingstring, "Kills"); PlayerInfo[playerid][Kills] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "Deaths"); PlayerInfo[playerid][Deaths] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "MutedTime"); PlayerInfo[playerid][MutedTime] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "WeaponSet"); PlayerInfo[playerid][WeaponSet] = strval(savingstring);
        mysql_fetch_field_row(savingstring, "Banned"); PlayerInfo[playerid][Banned] = strval(savingstring);
		mysql_fetch_field_row(savingstring, "RacePoints"); PlayerInfo[playerid][RacePoints] = strval(savingstring);
		
		SetPlayerScore(playerid,PlayerInfo[playerid][Level]);
    }
	mysql_free_result();
	return 1;
}
/*HexToInt(string[])
{
	new i = 0;
	new cur = 1;
	new res = 0;
	for (i = strlen(string); i > 0; i--)
	{
		if (string[i-1] < 58) res = res + cur*(string[i-1] - 48); else res = res + cur*(string[i-1] - 65 + 10);
	    cur = cur*16;
	}
	return res;
}*/

NametoId(nameid[])
{
	new i, nometoid;
	while(i < MAX_PLAYERS)
	{
		if(IsPlayerConnected(i))
		{
			if(strcmp(nome(i), nameid, true) == 0)
			{
				nometoid = i;
				break;
			}
			else
			{
				nometoid = INVALID_PLAYER_ID;
				i++;
				continue;
			}
		}
	}
	return nometoid;
}
forward fpsCheck();
public fpsCheck()
{
	for(new i; i != GetMaxPlayers(); ++i)
	{
	    if(IsPlayerConnected(i) && !IsPlayerNPC(i))
	    {
			if(GetPVarInt(i, "spawned"))
			{
			    SetPVarInt(i, "drunkLevel", GetPlayerDrunkLevel(i));

			    if(GetPVarInt(i, "drunkLevel") < 100)
			    {
			        SetPlayerDrunkLevel(i, 2000);
			    }
			    else
			    {
			        if(GetPVarInt(i, "lastDrunkLevel") != GetPVarInt(i, "drunkLevel"))
			        {
						SetPVarInt(i, "fps", (GetPVarInt(i, "lastDrunkLevel") - GetPVarInt(i, "drunkLevel")));
                        SetPVarInt(i, "lastDrunkLevel", GetPVarInt(i, "drunkLevel"));

						if((GetPVarInt(i, "fps") > 0) && (GetPVarInt(i, "fps") < 256))
						{
						    new
						        string[6]
							;
						    format(string, sizeof(string), "%d", GetPVarInt(i, "fps") - 1);
						    TextDrawSetString(textFPS[i], string);
						    TextDrawShowForPlayer(i, textFPS[i]);
						    TextDrawShowForPlayer(i, textFPSt[i]);
						}
					}
			    }
			}
			else
			{
			    TextDrawHideForPlayer(i, textFPS[i]);
			    TextDrawHideForPlayer(i, textFPSt[i]);
			}
		}
	}
	return 1;
}

//----------------------------------------------------------
//
//  Finish of games
//
//----------------------------------------------------------
