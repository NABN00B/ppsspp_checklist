/*
	PPSSPP 100% Checklist
	GTA Liberty City Stories Requirement List by NABN00B
	This file is only to be used with '..\PPSSPP 100% Checklist.ahk'
*/

; ######################################################################################################
; ############################################### GTALCS ###############################################
; ######################################################################################################

/*
Subheadings:

	GTALCS_Initialize
	GTALCS_VersionCheck
	GTALCS_ReadMemory(offset, type, length)
	GTALCS_PercentageOnlyRequirements
	GTALCS_Requirements
	GTALCS_UpdateVars

	Custom Codes:

		GTALCS_TaxiDriver_Address1CustomCode
		GTALCS_BikeSalesman_Address1-4CustomCode
		GTALCS_CarSalesman_Address1CustomCode
		GTALCS_StreetRaces_Address1-6CustomCode
		GTALCS_SeeTheSightBeforeYourFlight_Address1CustomCode
		GTALCS_VincenzoCilli_Address1CustomCode/GTALCS_JDOToole_Address1CustomCode/GTALCS_MaCipriani_Address1CustomCode/GTALCS_SalvatoreLeone_Address1-3CustomCode/GTALCS_Maria_Address1CustomCode/GTALCS_DonaldLove_Address1CustomCode/GTALCS_ChurchConfessional_Address1CustomCode/GTALCS_LeonMcAffrey_Address1CustomCode/GTALCS_ToshikoKasen_Address1CustomCode
		GTALCS_DonaldLove_Address2CustomCode
		GTALCS_8Ball_Address1CustomCode
*/


; Prerequisites
#Include <classMemory>
#Include <PPSSPP_VersionCheck>


; Initialization
GTALCS_Initialize:
FileInstall, FileInstall\GTALCS Icons.icl, %ScriptNameNoExt% Icons.icl, 1
IconArray := {"PercentageCompleted":1, "HiddenPackages":2, "Rampages":3, "UniqueStunts":4, "CarRazyCarGiveAway":5, "AvengingAngels":6, "Firefighter":7, "Paramedic":8, "TaxiDriver":9, "TrashDash":10, "Vigilante":11, "BikeSalesman":12, "CarSalesman":13, "FoodDeliveries":14, "StreetRaces":15, "RCRaces":16, "RailShooters":17, "BumpsAndGrinds":18, "SeeTheSightBeforeYourFlight":19, "CheckpointChallenges":20, "Karmageddon":21, "RCTriadTakeDown":22, "SlashTV":23, "VincenzoCilli":24, "JDOToole":25, "MaCipriani":26, "SalvatoreLeone":27, "Maria":28, "DonaldLove":29, "ChurchConfessional":30, "LeonMcAffrey":31, "ToshikoKasen":32, "8Ball":33}
return
; Initialization end


; Version Control
GTALCS_VersionCheck:
if (EmulatorBaseOffset != "Error" && EmulatorBaseOffset != "")
{
	; No game version control yet.
	if (true)
	{
		GameVersion := "ULUS10041_1.05_ARTiSAN"
		GameScript := "v1"
		return
	}
}
GameVersion := "unknown game"
GameScript := "v1"
; If version is unrecognised, warn the user about unintended behaviour.
;MsgBox, 0x2030, , Error`: The script could not determine the version of %CurrentGame%.`n`nThe version is defaulted to %GameVersion%.`nIf this is not the correct version, try restarting the script once the game is fully loaded.`nOtherwise the checklist might not work as intended.
return
; Version Control end


; Memory Reading Function
GTALCS_ReadMemory(offset, type := "Int", length := 4)
{
	global
	; We only need to read 4-byte numeric values from this game, so the "read" method is fine.
	return EmulatorMemory.read(EmulatorMemory.BaseAddress + EmulatorBaseOffset, type, offset)
}
; Memory Reading Function end


; Requirements
GTALCS_PercentageOnlyRequirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := 0x8B5E158 ; Completion Points
Address1CustomCode := True
gosub %CurrentLoopCode%
return


GTALCS_Requirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := 0x8B5E158 ; Completion Points
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Hidden Packages"
IconName := "HiddenPackages"
TotalRequired := 100
Address1 := 0x9F6BC2C ; $11[i] Hidden Package i Collected
Address2 := 0x9F6BC30
Address3 := 0x9F6BC34
Address4 := 0x9F6BC38
Address5 := 0x9F6BC3C
Address6 := 0x9F6BC40
Address7 := 0x9F6BC44
Address8 := 0x9F6BC48
Address9 := 0x9F6BC4C
Address10 := 0x9F6BC50
Address11 := 0x9F6BC54
Address12 := 0x9F6BC58
Address13 := 0x9F6BC5C
Address14 := 0x9F6BC60
Address15 := 0x9F6BC64
Address16 := 0x9F6BC68
Address17 := 0x9F6BC6C
Address18 := 0x9F6BC70
Address19 := 0x9F6BC74
Address20 := 0x9F6BC78
Address21 := 0x9F6BC7C
Address22 := 0x9F6BC80
Address23 := 0x9F6BC84
Address24 := 0x9F6BC88
Address25 := 0x9F6BC8C
Address26 := 0x9F6BC90
Address27 := 0x9F6BC94
Address28 := 0x9F6BC98
Address29 := 0x9F6BC9C
Address30 := 0x9F6BCA0
Address31 := 0x9F6BCA4
Address32 := 0x9F6BCA8
Address33 := 0x9F6BCAC
Address34 := 0x9F6BCB0
Address35 := 0x9F6BCB4
Address36 := 0x9F6BCB8
Address37 := 0x9F6BCBC
Address38 := 0x9F6BCC0
Address39 := 0x9F6BCC4
Address40 := 0x9F6BCC8
Address41 := 0x9F6BCCC
Address42 := 0x9F6BCD0
Address43 := 0x9F6BCD4
Address44 := 0x9F6BCD8
Address45 := 0x9F6BCDC
Address46 := 0x9F6BCE0
Address47 := 0x9F6BCE4
Address48 := 0x9F6BCE8
Address49 := 0x9F6BCEC
Address50 := 0x9F6BCF0
Address51 := 0x9F6BCF4
Address52 := 0x9F6BCF8
Address53 := 0x9F6BCFC
Address54 := 0x9F6BD00
Address55 := 0x9F6BD04
Address56 := 0x9F6BD08
Address57 := 0x9F6BD0C
Address58 := 0x9F6BD10
Address59 := 0x9F6BD14
Address60 := 0x9F6BD18
Address61 := 0x9F6BD1C
Address62 := 0x9F6BD20
Address63 := 0x9F6BD24
Address64 := 0x9F6BD28
Address65 := 0x9F6BD2C
Address66 := 0x9F6BD30
Address67 := 0x9F6BD34
Address68 := 0x9F6BD38
Address69 := 0x9F6BD3C
Address70 := 0x9F6BD40
Address71 := 0x9F6BD44
Address72 := 0x9F6BD48
Address73 := 0x9F6BD4C
Address74 := 0x9F6BD50
Address75 := 0x9F6BD54
Address76 := 0x9F6BD58
Address77 := 0x9F6BD5C
Address78 := 0x9F6BD60
Address79 := 0x9F6BD64
Address80 := 0x9F6BD68
Address81 := 0x9F6BD6C
Address82 := 0x9F6BD70
Address83 := 0x9F6BD74
Address84 := 0x9F6BD78
Address85 := 0x9F6BD7C
Address86 := 0x9F6BD80
Address87 := 0x9F6BD84
Address88 := 0x9F6BD88
Address89 := 0x9F6BD8C
Address90 := 0x9F6BD90
Address91 := 0x9F6BD94
Address92 := 0x9F6BD98
Address93 := 0x9F6BD9C
Address94 := 0x9F6BDA0
Address95 := 0x9F6BDA4
Address96 := 0x9F6BDA8
Address97 := 0x9F6BDAC
Address98 := 0x9F6BDB0
Address99 := 0x9F6BDB4
Address100 := 0x9F6BDB8
gosub %CurrentLoopCode%
Name := "Rampages"
IconName := "Rampages"
TotalRequired := 20
Address1 := 0x9F6BE8C ; $163[i] Rampage i Completed
Address2 := 0x9F6BE90
Address3 := 0x9F6BE94
Address4 := 0x9F6BE98
Address5 := 0x9F6BE9C
Address6 := 0x9F6BEA0
Address7 := 0x9F6BEA4
Address8 := 0x9F6BEA8
Address9 := 0x9F6BEAC
Address10 := 0x9F6BEB0
Address11 := 0x9F6BEB4
Address12 := 0x9F6BEB8
Address13 := 0x9F6BEBC
Address14 := 0x9F6BEC0
Address15 := 0x9F6BEC4
Address16 := 0x9F6BEC8
Address17 := 0x9F6BECC
Address18 := 0x9F6BED0
Address19 := 0x9F6BED4
Address20 := 0x9F6BED8
gosub %CurrentLoopCode%
Name := "Unique Stunts"
IconName := "UniqueStunts"
TotalRequired := 26
Address1 := 0x9F6BEDC ; $183[i] Unique Stunt i Completed
Address2 := 0x9F6BEE0
Address3 := 0x9F6BEE4
Address4 := 0x9F6BEE8
Address5 := 0x9F6BEEC
Address6 := 0x9F6BEF0
Address7 := 0x9F6BEF4
Address8 := 0x9F6BEF8
Address9 := 0x9F6BEFC
Address10 := 0x9F6BF00
Address11 := 0x9F6BF04
Address12 := 0x9F6BF08
Address13 := 0x9F6BF0C
Address14 := 0x9F6BF10
Address15 := 0x9F6BF14
Address16 := 0x9F6BF18
Address17 := 0x9F6BF1C
Address18 := 0x9F6BF20
Address19 := 0x9F6BF24
Address20 := 0x9F6BF28
Address21 := 0x9F6BF2C
Address22 := 0x9F6BF30
Address23 := 0x9F6BF34
Address24 := 0x9F6BF38
Address25 := 0x9F6BF3C
Address26 := 0x9F6BF40
gosub %CurrentLoopCode%
Name := "Car-razy Car Give Away"
IconName := "CarRazyCarGiveAway"
TotalRequired := 16
Address1 := 0x9F6C294 ; $421[0] Import/Export: Hearse Delivered
Address2 := 0x9F6C298 ; $421[1] Import/Export: Faggio Delivered
Address3 := 0x9F6C29C ; $421[2] Import/Export: Freeway Delivered
Address4 := 0x9F6C2A0 ; $421[3] Import/Export: Deimos SP Delivered
Address5 := 0x9F6C2A4 ; $421[4] Import/Export: Manana Delivered
Address6 := 0x9F6C2A8 ; $421[5] Import/Export: Hellenbach GT Delivered
Address7 := 0x9F6C2AC ; $421[6] Import/Export: Phobos VT Delivered
Address8 := 0x9F6C2B0 ; $421[7] Import/Export: V8 Ghost Delivered
Address9 := 0x9F6C2B4 ; $421[8] Import/Export: Thunder-Rodd Delivered
Address10 := 0x9F6C2B8 ; $421[9] Import/Export: PCJ-600 Delivered
Address11 := 0x9F6C2BC ; $421[10] Import/Export: Sentinel Delivered
Address12 := 0x9F6C2C0 ; $421[11] Import/Export: Infernus Delivered
Address13 := 0x9F6C2C4 ; $421[12] Import/Export: Banshee Delivered
Address14 := 0x9F6C2C8 ; $421[13] Import/Export: Patriot Delivered
Address15 := 0x9F6C2CC ; $421[14] Import/Export: BF Injection Delivered
Address16 := 0x9F6C2D0 ; $421[15] Import/Export: Landstalker Delivered
gosub %CurrentLoopCode%
Name := "Avenging Angels"
IconName := "AvengingAngels"
TotalRequired := 3
Address1 := 0x9F6C014 ; $261 Avenging Angels: Portland Completed
Address2 := 0x9F6C018 ; $262 Avenging Angels: Staunton Completed
Address3 := 0x9F6C01C ; $263 Avenging Angels: Shoreside Completed
gosub %CurrentLoopCode%
Name := "Firefighter"
IconName := "Firefighter"
TotalRequired := 1
Address1 := 0x9F6BF60 ; $216 Firefighter Completed
gosub %CurrentLoopCode%
Name := "Paramedic"
IconName := "Paramedic"
TotalRequired := 1
Address1 := 0x9F6BF5C ; $215 Paramedic Completed
gosub %CurrentLoopCode%
Name := "Taxi Driver"
IconName := "TaxiDriver"
TotalRequired := 100
Address1 := 0x9F6BF68 ; $218 Taxi Driver: Fares Completed
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Trash Dash"
IconName := "TrashDash"
TotalRequired := 3
Address1 := 0x9F6BF6C ; $219[0] Trash Dash: Portland Completed
Address2 := 0x9F6BF70 ; $219[1] Trash Dash: Staunton Completed
Address3 := 0x9F6BF74 ; $219[2] Trash Dash: Shoreside Completed
gosub %CurrentLoopCode%
Name := "Vigilante"
IconName := "Vigilante"
TotalRequired := 1
Address1 := 0x9F6BF58 ; $214 Vigilante Completed
gosub %CurrentLoopCode%
Name := "Bike Salesman"
IconName := "BikeSalesman"
TotalRequired := 40
Address1 := 0x9F6C2DC ; $439[0] Bike Salesman: Bike Freeways Sold
Address1CustomCode := True
Address2 := 0x9F6C2E0 ; $439[1] Bike Salesman: Bike PCJ-600's Sold
Address2CustomCode := True
Address3 := 0x9F6C2E4 ; $439[2] Bike Salesman: Bike Faggios Sold
Address3CustomCode := True
Address4 := 0x9F6C2E8 ; $439[3] Bike Salesman: Bike Sanchezes Sold
Address4CustomCode := True
gosub %CurrentLoopCode%
Name := "Car Salesman"
IconName := "CarSalesman"
TotalRequired := 6
Address1 := 0x9F6C040 ; $272 Car Salesman: Highest Level Reached
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Food Deliveries"
IconName := "FoodDeliveries"
TotalRequired := 2
Address1 := 0x9F6C050 ; $276 Noodle Punk Completed
Address2 := 0x9F6C2EC ; $443 Well Snacked Pizza Completed
gosub %CurrentLoopCode%
Name := "Street Races"
IconName := "StreetRaces"
TotalRequired := 6
Address1 := 0x9F6C170 ; $348[0] Street Races Best Position: Low-Rider Rumble
Address1CustomCode := True
Address2 := 0x9F6C174 ; $348[1] Street Races Best Position: Deimos Dash
Address2CustomCode := True
Address3 := 0x9F6C178 ; $348[2] Street Races Best Position: Wi-Cheetah Run
Address3CustomCode := True
Address4 := 0x9F6C17C ; $348[3] Street Races Best Position: Red Light Racing
Address4CustomCode := True
Address5 := 0x9F6C180 ; $348[4] Street Races Best Position: Torrington TT
Address5CustomCode := True
Address6 := 0x9F6C184 ; $348[5] Street Races Best Position: Gangsta GP
Address6CustomCode := True
gosub %CurrentLoopCode%
Name := "RC Races"
IconName := "RCRaces"
TotalRequired := 3
Address1 := 0x9F6BF78 ; $222 Thrashin' RC Completed
Address2 := 0x9F6BF7C ; $223 Ragin' RC Completed
Address3 := 0x9F6BF80 ; $224 Chasin' RC Completed
gosub %CurrentLoopCode%
Name := "Rail Shooters"
IconName := "RailShooters"
TotalRequired := 3
Address1 := 0x9F6C064 ; $281 9mm Mayhem Completed
Address2 := 0x9F6C06C ; $283 Scooter Shooter Completed
Address3 := 0x9F6C078 ; $286 AWOL Angel Completed
gosub %CurrentLoopCode%
Name := "Bumps & Grinds"
IconName := "BumpsAndGrinds"
TotalRequired := 10
Address1 := 0x9F6C240 ; $400 Bumps & Grinds: Course 1 Completed
Address2 := 0x9F6C244 ; $401 Bumps & Grinds: Course 2 Completed
Address3 := 0x9F6C248 ; $402 Bumps & Grinds: Course 3 Completed
Address4 := 0x9F6C24C ; $403 Bumps & Grinds: Course 4 Completed
Address5 := 0x9F6C250 ; $404 Bumps & Grinds: Course 5 Completed
Address6 := 0x9F6C254 ; $405 Bumps & Grinds: Course 6 Completed
Address7 := 0x9F6C258 ; $406 Bumps & Grinds: Course 7 Completed
Address8 := 0x9F6C25C ; $407 Bumps & Grinds: Course 8 Completed
Address9 := 0x9F6C260 ; $408 Bumps & Grinds: Course 9 Completed
Address10 := 0x9F6C264 ; $409 Bumps & Grinds: Course 10 Completed
gosub %CurrentLoopCode%
Name := "See the Sight Before your Flight"
IconName := "SeeTheSightBeforeYourFlight"
TotalRequired := 12
Address1 := 0x9F6C330 ; $460 See the Sight Before your Flight: Sights Completed
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Checkpoint Challenges"
IconName := "CheckpointChallenges"
TotalRequired := 3
Address1 := 0x9F6C024 ; $265 Wong Side Of The Tracks Completed
Address2 := 0x9F6C058 ; $278 Scrapyard Challenge Completed: Score 21+
Address3 := 0x9F6C0F0 ; $316 GO GO Faggio Completed
gosub %CurrentLoopCode%
Name := "Karmageddon"
IconName := "Karmageddon"
TotalRequired := 1
Address1 := 0x9F6C0F4 ; $317 Karmageddon (Side Mission) Completed
gosub %CurrentLoopCode%
Name := "RC Triad Take-Down"
IconName := "RCTriadTakeDown"
TotalRequired := 1
Address1 := 0x9F6C044 ; $273 RC Triad Take-Down Completed
gosub %CurrentLoopCode%
Name := "Slash TV"
IconName := "SlashTV"
TotalRequired := 1
Address1 := 0x9F6C04C ; $275 Slash TV: 1st Time Completed
gosub %CurrentLoopCode%
Name := "Vincenzo Cilli"
IconName := "VincenzoCilli"
TotalRequired := 7
Address1 := 0x9F6BFC4 ; $241 Vincenzo Cilli Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "JD O'Toole"
IconName := "JDOToole"
TotalRequired := 8
Address1 := 0x9F6BFDC ; $247 JD O'Toole Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Ma Cipriani"
IconName := "MaCipriani"
TotalRequired := 5
Address1 := 0x9F6BFE8 ; $250 Ma Cipriani Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Salvatore Leone"
IconName := "SalvatoreLeone"
TotalRequired := 19
Address1 := 0x9F6BFD0 ; $244 Salvatore Leone Mission Chain Counter
Address1CustomCode := True
Address2 := 0x9F6C0A0 ; $296 Salvatore Leone Staunton Mission Chain Counter
Address2CustomCode := True
Address3 := 0x9F6C2F8 ; $446 Salvatore Leone Shoreside Mission Chain Counter
Address3CustomCode := True
gosub %CurrentLoopCode%
Name := "Maria"
IconName := "Maria"
TotalRequired := 5
Address1 := 0x9F6BFF4 ; $253 Maria Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Donald Love"
IconName := "DonaldLove"
TotalRequired := 11
Address1 := 0x9F6C0B8 ; $302 Donald Love Staunton Mission Chain Counter
Address1CustomCode := True
Address2 := 0x9F6C304 ; $449 Donald Love Shoreside Mission Chain Counter
Address2CustomCode := True
gosub %CurrentLoopCode%
Name := "Church Confessional"
IconName := "ChurchConfessional"
TotalRequired := 4
Address1 := 0x9F6C0C4 ; $305 Church Confessional Staunton Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Leon McAffrey"
IconName := "LeonMcAffrey"
TotalRequired := 5
Address1 := 0x9F6C0AC ; $299 Leon McAffrey Staunton Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Toshiko Kasen"
IconName := "ToshikoKasen"
TotalRequired := 4
Address1 := 0x9F6C310 ; $452 Toshiko Kasen Shoreside Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "8-Ball"
IconName := "8Ball"
TotalRequired := 2
Address1 := 0x9F6C304 ; $449 Donald Love Shoreside Mission Chain Counter
Address1CustomCode := True
gosub %CurrentLoopCode%
return
; Requirements end


; Custom Code Variables
GTALCS_UpdateVars:
if (SpecialMode != "PercentageOnly")
{
	GTALCS_Var_TaxiDriverCompleted := GTALCS_ReadMemory(0x9F6BF64) ; $217 Taxi Driver Completed
	GTALCS_Var_CarSalesmanCompleted := GTALCS_ReadMemory(0x9F6C02C) ; $267 Car Salesman Completed
	GTALCS_Var_SeeTheSightBeforeYourFlightAllLevelsCompleted := GTALCS_ReadMemory(0x9F6C32C) ; $459 See the Sight Before your Flight: All Sights Completed
	GTALCS_Var_HogsNCogsIncomeUnlocked := GTALCS_ReadMemory(0x9F6CD34) ; $1101 Hogs & Cogs Income Unlocked

}
return
; Custom Code Variables end


; Custom Codes
GTALCS_PercentageCompleted_Address1CustomCode:
MemoryValue /= 1.71 ; Total: 171
return


GTALCS_TaxiDriver_Address1CustomCode:
if (GTALCS_Var_TaxiDriverCompleted = 1)
	MemoryValue := 100
return


GTALCS_BikeSalesman_Address1CustomCode:
GTALCS_BikeSalesman_Address2CustomCode:
GTALCS_BikeSalesman_Address3CustomCode:
GTALCS_BikeSalesman_Address4CustomCode:
if (GTALCS_Var_HogsNCogsIncomeUnlocked = 1)
	MemoryValue := 10
return


GTALCS_CarSalesman_Address1CustomCode:
if (GTALCS_Var_CarSalesmanCompleted = 1)
{
	MemoryValue := 6
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTALCS_StreetRaces_Address1CustomCode:
GTALCS_StreetRaces_Address2CustomCode:
GTALCS_StreetRaces_Address3CustomCode:
GTALCS_StreetRaces_Address4CustomCode:
GTALCS_StreetRaces_Address5CustomCode:
GTALCS_StreetRaces_Address6CustomCode:
if (MemoryValue = 1)
	return
MemoryValue := 0
return


GTALCS_SeeTheSightBeforeYourFlight_Address1CustomCode:
if (GTALCS_Var_SeeTheSightBeforeYourFlightAllLevelsCompleted = 1)
	MemoryValue := 12
return

GTALCS_VincenzoCilli_Address1CustomCode:
GTALCS_JDOToole_Address1CustomCode:
GTALCS_MaCipriani_Address1CustomCode:
GTALCS_SalvatoreLeone_Address1CustomCode:
GTALCS_Maria_Address1CustomCode:
GTALCS_SalvatoreLeone_Address2CustomCode:
GTALCS_DonaldLove_Address1CustomCode:
GTALCS_ChurchConfessional_Address1CustomCode:
GTALCS_LeonMcAffrey_Address1CustomCode:
GTALCS_SalvatoreLeone_Address3CustomCode:
GTALCS_ToshikoKasen_Address1CustomCode:
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTALCS_DonaldLove_Address2CustomCode:
if (MemoryValue >= 6)
{
	MemoryValue -= 3
	return
}
if (MemoryValue = 5)
{
	MemoryValue -= 2
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTALCS_8Ball_Address1CustomCode:
if (MemoryValue >= 6)
{
	MemoryValue := 2
	return
}
if (MemoryValue = 5)
{
	MemoryValue := 1
	return
}
MemoryValue := 0
return
; Custom Codes end

