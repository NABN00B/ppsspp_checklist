/*
	PPSSPP 100% Checklist
	GTA Vice City Stories Requirement List by NABN00B
	This file is only to be used with '..\PPSSPP 100% Checklist.ahk'
*/

; ######################################################################################################
; ############################################### GTAVCS ###############################################
; ######################################################################################################

/*
Subheadings:

	GTAVCS_Initialize
	GTAVCS_VersionCheck
	GTAVCS_ReadMemory(offset, type, length)
	GTAVCS_PercentageOnlyRequirements
	GTAVCS_Requirements
	GTAVCS_UpdateVars

	Custom Codes:

		GTAVCS_PercentageCompleted_Address1CustomCode
		GTAVCS_CivilAssetForfeitureImpound_Address1-8CustomCode
		GTAVCS_EmpireSites_Address1-6CustomCode
		GTAVCS_EmpireHighRollers_Address1-6CustomCode/GTAVCS_EmpireAttacks_Address2-4CustomCode
		GTAVCS_Extortion_Address1CustomCode
		GTAVCS_LoanShark_Address1CustomCode
		GTAVCS_Pimping_Address1CustomCode
		GTAVCS_DrugRunning_Address1CustomCode
		GTAVCS_Smuggling_Address1CustomCode
		GTAVCS_Robbery_Address1CustomCode
		GTAVCS_BeachPatrol_Address1CustomCode
		GTAVCS_TaxiDriverCash_Address1CustomCode
		GTAVCS_TaxiDriverFares_Address1CustomCode
		GTAVCS_Vigilante_Address1CustomCode
		GTAVCS_Turismo_Address1-9CustomCode
		GTAVCS_SgtJerryMartinez_Address1CustomCode
		GTAVCS_PhilCassidy_Address1CustomCode
		GTAVCS_MartyJWilliams_Address1CustomCode
		GTAVCS_LouiseCassidyWilliams_Address1CustomCode
		GTAVCS_LanceVance_Address1CustomCode
		GTAVCS_UmbertoRobina_Address1CustomCode
		GTAVCS_BryanForbes_Address1CustomCode
		GTAVCS_ReniWassulmaier_Address1CustomCode
		GTAVCS_ArmandoAndDiegoMendez_Address1CustomCode
		GTAVCS_Gonzalez_Address1CustomCode
		GTAVCS_RicardoDiaz_Address1CustomCode
*/


; Prerequisites
#Include <classMemory>
#Include <PPSSPP_VersionCheck>
#Include <GetLastErrorMessage>


; Initialization
GTAVCS_Initialize:
FileInstall, FileInstall\GTAVCS Icons.icl, %ScriptNameNoExt% Icons.icl, 1
IconArray := {"PercentageCompleted":1, "RedBalloons":2, "Rampages":3, "UniqueStunts":4, "CivilAssetForfeitureImpound":5, "CAFIWatercrafts":6, "EmpireSites":7, "EmpireHighRollers":8, "EmpireAttacks":9, "Extortion":10, "LoanShark":11, "Pimping":12, "DrugRunning":13, "Smuggling":14, "Robbery":15, "AirRescue":16, "BeachPatrol":17, "FireCopter":18, "FireFighter":19, "Paramedic":20, "TaxiDriverCash":21, "TaxiDriverFares":22, "ViceSights":23, "Vigilante":24, "Crash":25, "CheckpointChallenges":26, "TimeTrials":27, "BMXTimeTrials":28, "QuadBikeTimeTrials":29, "SanchezTimeTrials":30, "Watersports":31, "Turismo":32, "PhilsShootingRange":33, "SwingersClub":34, "SgtJerryMartinez":35, "PhilCassidy":36, "MartyJWilliams":37, "LouiseCassidyWilliams":38, "LanceVance":39, "UmbertoRobina":40, "BryanForbes":41, "ReniWassulmaier":42, "ArmandoAndDiegoMendez":43, "Gonzalez":44, "RicardoDiaz":45}
return
; Initialization end


; Version Control
GTAVCS_VersionCheck:
if (EmulatorBaseOffset != "Error" && EmulatorBaseOffset != "")
{
	GameDetectionString := GTAVCS_ReadMemory(0x8BAD4EC, "Int64", 8)
	;GameDetectionStringLowerBits := GTAVCS_ReadMemory(0x8BAD4EC)
	;GameDetectionStringUpperBits := GTAVCS_ReadMemory(0x8BAD4F0)
	;GameDetectionString := (GameDetectionStringUpperBits << 32) + GameDetectionStringLowerBits
	;err := GetLastErrorMessage()
	;MsgBox, %GameDetectionString% " " %err%
	if (GameDetectionString = 0x474E494B434F4C42) ; "BLOCKING"
	{
		GameVersion := "ULUS10160_1.03_Start2"
		GameScript := "international"
		return
	}
	else if (GameDetectionString = 0x00474E4944414F4C) ; "LOADING\0"
	{
		GameVersion := "ULES00502_1.02_pSyPSP"
		GameScript := "international"
		return
	}
	else if (GameDetectionString = 0x000000797473616E) ; "nasty\0\0\0"
	{
		GameVersion := "ULES00503_1.02_Googlecus"
		GameScript := "international"
		return
	}
	else if (GameDetectionString = 0x0000005445535341) ; "ASSET\0\0\0"
	{
		GameVersion := "ULJM05297_1.01_Caravan"
		GameScript := "Japanese"
		return
	}	
}
GameVersion := "unknown game"
GameScript := "international"
; If version is unrecognised, warn the user about unintended behaviour.
;MsgBox, 0x2030, , Error`: The script could not determine the version of %CurrentGame%.`n`nThe version is defaulted to %GameVersion%.`nIf this is not the correct version, try restarting the script once the game is fully loaded.`nOtherwise the checklist might not work as intended.
return
; Version Control end


; Memory Reading Function
GTAVCS_ReadMemory(offset, type := "Int", length := 4)
{
	global
	; We only need to read 4-byte numeric values from this game, so the "read" method is fine.
	return EmulatorMemory.read(EmulatorMemory.BaseAddress + EmulatorBaseOffset, type, offset)
}
; Memory Reading Function end


; Requirements
GTAVCS_PercentageOnlyRequirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := -1
Address1CustomCode := True
gosub %CurrentLoopCode%
return


GTAVCS_Requirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := -1
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Red Balloons"
IconName := "RedBalloons"
TotalRequired := 99
Address1 := 0x9F6A1AC ; $1899[i] Red Balloon i Popped
Address2 := 0x9F6A1B0
Address3 := 0x9F6A1B4
Address4 := 0x9F6A1B8
Address5 := 0x9F6A1BC
Address6 := 0x9F6A1C0
Address7 := 0x9F6A1C4
Address8 := 0x9F6A1C8
Address9 := 0x9F6A1CC
Address10 := 0x9F6A1D0
Address11 := 0x9F6A1D4
Address12 := 0x9F6A1D8
Address13 := 0x9F6A1DC
Address14 := 0x9F6A1E0
Address15 := 0x9F6A1E4
Address16 := 0x9F6A1E8
Address17 := 0x9F6A1EC
Address18 := 0x9F6A1F0
Address19 := 0x9F6A1F4
Address20 := 0x9F6A1F8
Address21 := 0x9F6A1FC
Address22 := 0x9F6A200
Address23 := 0x9F6A204
Address24 := 0x9F6A208
Address25 := 0x9F6A20C
Address26 := 0x9F6A210
Address27 := 0x9F6A214
Address28 := 0x9F6A218
Address29 := 0x9F6A21C
Address30 := 0x9F6A220
Address31 := 0x9F6A224
Address32 := 0x9F6A228
Address33 := 0x9F6A22C
Address34 := 0x9F6A230
Address35 := 0x9F6A234
Address36 := 0x9F6A238
Address37 := 0x9F6A23C
Address38 := 0x9F6A240
Address39 := 0x9F6A244
Address40 := 0x9F6A248
Address41 := 0x9F6A24C
Address42 := 0x9F6A250
Address43 := 0x9F6A254
Address44 := 0x9F6A258
Address45 := 0x9F6A25C
Address46 := 0x9F6A260
Address47 := 0x9F6A264
Address48 := 0x9F6A268
Address49 := 0x9F6A26C
Address50 := 0x9F6A270
Address51 := 0x9F6A274
Address52 := 0x9F6A278
Address53 := 0x9F6A27C
Address54 := 0x9F6A280
Address55 := 0x9F6A284
Address56 := 0x9F6A288
Address57 := 0x9F6A28C
Address58 := 0x9F6A290
Address59 := 0x9F6A294
Address60 := 0x9F6A298
Address61 := 0x9F6A29C
Address62 := 0x9F6A2A0
Address63 := 0x9F6A2A4
Address64 := 0x9F6A2A8
Address65 := 0x9F6A2AC
Address66 := 0x9F6A2B0
Address67 := 0x9F6A2B4
Address68 := 0x9F6A2B8
Address69 := 0x9F6A2BC
Address70 := 0x9F6A2C0
Address71 := 0x9F6A2C4
Address72 := 0x9F6A2C8
Address73 := 0x9F6A2CC
Address74 := 0x9F6A2D0
Address75 := 0x9F6A2D4
Address76 := 0x9F6A2D8
Address77 := 0x9F6A2DC
Address78 := 0x9F6A2E0
Address79 := 0x9F6A2E4
Address80 := 0x9F6A2E8
Address81 := 0x9F6A2EC
Address82 := 0x9F6A2F0
Address83 := 0x9F6A2F4
Address84 := 0x9F6A2F8
Address85 := 0x9F6A2FC
Address86 := 0x9F6A300
Address87 := 0x9F6A304
Address88 := 0x9F6A308
Address89 := 0x9F6A30C
Address90 := 0x9F6A310
Address91 := 0x9F6A314
Address92 := 0x9F6A318
Address93 := 0x9F6A31C
Address94 := 0x9F6A320
Address95 := 0x9F6A324
Address96 := 0x9F6A328
Address97 := 0x9F6A32C
Address98 := 0x9F6A330
Address99 := 0x9F6A334
gosub %CurrentLoopCode%
Name := "Rampages"
IconName := "Rampages"
TotalRequired := 30
Address1 := 0x9F69DA4 ; $1641[i] Rampage i Completed
Address2 := 0x9F69DA8
Address3 := 0x9F69DAC
Address4 := 0x9F69DB0
Address5 := 0x9F69DB4
Address6 := 0x9F69DB8
Address7 := 0x9F69DBC
Address8 := 0x9F69DC0
Address9 := 0x9F69DC4
Address10 := 0x9F69DC8
Address11 := 0x9F69DCC
Address12 := 0x9F69DD0
Address13 := 0x9F69DD4
Address14 := 0x9F69DD8
Address15 := 0x9F69DDC
Address16 := 0x9F69DE0
Address17 := 0x9F69DE4
Address18 := 0x9F69DE8
Address19 := 0x9F69DEC
Address20 := 0x9F69DF0
Address21 := 0x9F69DF4
Address22 := 0x9F69DF8
Address23 := 0x9F69DFC
Address24 := 0x9F69E00
Address25 := 0x9F69E04
Address26 := 0x9F69E08
Address27 := 0x9F69E0C
Address28 := 0x9F69E10
Address29 := 0x9F69E14
Address30 := 0x9F69E18
gosub %CurrentLoopCode%
Name := "Unique Stunts"
IconName := "UniqueStunts"
TotalRequired := 30
Address1 := 0x9F69E1C ; $1671[i] Unique Stunt i Completed
Address2 := 0x9F69E20
Address3 := 0x9F69E24
Address4 := 0x9F69E28
Address5 := 0x9F69E2C
Address6 := 0x9F69E30
Address7 := 0x9F69E34
Address8 := 0x9F69E38
Address9 := 0x9F69E3C
Address10 := 0x9F69E40
Address11 := 0x9F69E44
Address12 := 0x9F69E48
Address13 := 0x9F69E4C
Address14 := 0x9F69E50
Address15 := 0x9F69E54
Address16 := 0x9F69E58
Address17 := 0x9F69E5C
Address18 := 0x9F69E60
Address19 := 0x9F69E64
Address20 := 0x9F69E68
Address21 := 0x9F69E6C
Address22 := 0x9F69E70
Address23 := 0x9F69E74
Address24 := 0x9F69E78
Address25 := 0x9F69E7C
Address26 := 0x9F69E80
Address27 := 0x9F69E84
Address28 := 0x9F69E88
Address29 := 0x9F69E8C
Address30 := 0x9F69E90
gosub %CurrentLoopCode%
Name := "Civil Asset Forfeiture Impound"
IconName := "CivilAssetForfeitureImpound"
TotalRequired := 24
Address1 := 0x9F69ED8 ; $1718[0] Import/Export: Streetfighter / WinterGreen / PCJ-600 Delivered
Address1CustomCode := True
Address2 := 0x9F69EDC ; $1718[1] Import/Export: Sanchez / Freeway / Deluxo Delivered
Address2CustomCode := True
Address3 := 0x9F69EE0 ; $1718[2] Import/Export: Oceanic / Banshee / Infernus Delivered
Address3CustomCode := True
Address4 := 0x9F69EE4 ; $1718[3] Import/Export: Cuban Hermes / Cheetah / Sabre Delivered
Address4CustomCode := True
Address5 := 0x9F69EE8 ; $1718[4] Import/Export: Polaris V8 / Comet / Stretch Delivered
Address5CustomCode := True
Address6 := 0x9F69EEC ; $1718[5] Import/Export: Stallion / Phoenix / Stinger Delivered
Address6CustomCode := True
Address7 := 0x9F69EF0 ; $1718[6] Import/Export: Pony / Sentinel XS / Maverick Delivered
Address7CustomCode := True
Address8 := 0x9F69EF4 ; $1718[7] Import/Export: Boxville / Mule / Sparrow Delivered
Address8CustomCode := True
gosub %CurrentLoopCode%
Name := "CAFI Watercrafts"
IconName := "CAFIWatercrafts"
TotalRequired := 8
Address1 := 0x9F69EF8 ; $1726[0] Import/Export: Dinghy Delivered
Address2 := 0x9F69EFC ; $1726[1] Import/Export: JetSki Delivered
Address3 := 0x9F69F00 ; $1726[2] Import/Export: Marquis Delivered
Address4 := 0x9F69F04 ; $1726[3] Import/Export: Rio Delivered
Address5 := 0x9F69F08 ; $1726[4] Import/Export: Reefer Delivered
Address6 := 0x9F69F0C ; $1726[5] Import/Export: Violator Delivered
Address7 := 0x9F69F10 ; $1726[6] Import/Export: Squallo Delivered
Address8 := 0x9F69F14 ; $1726[7] Import/Export: Tropic Delivered
gosub %CurrentLoopCode%
Name := "Empire Sites"
IconName := "EmpireSites"
TotalRequired := 30
Address1 := 0x9F68944 ; $337 Empire Sites Owned: 30
Address1CustomCode := True
Address2 := 0x9F6894C ; $339 Empire Sites Owned: 5+
Address2CustomCode := True
Address3 := 0x9F68950 ; $340 Empire Sites Owned: 10+
Address3CustomCode := True
Address4 := 0x9F68954 ; $341 Empire Sites Owned: 15+
Address4CustomCode := True
Address5 := 0x9F68958 ; $342 Empire Sites Owned: 20+
Address5CustomCode := True
Address6 := 0x9F6895C ; $343 Empire Sites Owned: 25+
Address6CustomCode := True
gosub %CurrentLoopCode%
Name := "Empire High Rollers"
IconName := "EmpireHighRollers"
TotalRequired := 6
Address1 := 0x9F68968 ; $344[2] Clothes Locked: 'Leisure'
Address1CustomCode := True
Address2 := 0x9F68978 ; $344[6] Clothes Locked: 'Tracksuit'
Address2CustomCode := True
Address3 := 0x9F6897C ; $344[7] Clothes Locked: 'Hood'
Address3CustomCode := True
Address4 := 0x9F68980 ; $344[8] Clothes Locked: 'Hired Muscle'
Address4CustomCode := True
Address5 := 0x9F68984 ; $344[9] Clothes Locked: 'Repo-Man'
Address5CustomCode := True
Address6 := 0x9F68988 ; $344[10] Clothes Locked: 'Smuggler'
Address6CustomCode := True
gosub %CurrentLoopCode%
Name := "Empire Attacks"
IconName := "EmpireAttacks"
TotalRequired := 4
Address1 := 0x9F68E10 ; $644 First Empire Attack Completed
Address2 := 0x9F68E28 ; $646[4] Empire Type Locked: Drugs
Address2CustomCode := True
Address3 := 0x9F68E2C ; $646[5] Empire Type Locked: Smuggling
Address3CustomCode := True
Address4 := 0x9F68E30 ; $646[6] Empire Type Locked: Robbery
Address4CustomCode := True
gosub %CurrentLoopCode%
Name := "Extortion"
IconName := "Extortion"
TotalRequired := 15
Address1 := 0x9F68E54 ; $660[1] Empire Mission Jobs Completed: Extortion
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Loan Shark"
IconName := "LoanShark"
TotalRequired := 15
Address1 := 0x9F68E58 ; $660[2] Empire Mission Jobs Completed: Loan Shark
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Pimping"
IconName := "Pimping"
TotalRequired := 15
Address1 := 0x9F68E5C ; $660[3] Empire Mission Jobs Completed: Pimping
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Drug Running"
IconName := "DrugRunning"
TotalRequired := 6
Address1 := 0x9F68E60 ; $660[4] Empire Mission Jobs Completed: Drug Running
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Smuggling"
IconName := "Smuggling"
TotalRequired := 6
Address1 := 0x9F68E64 ; $660[5] Empire Mission Jobs Completed: Smuggling
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Robbery"
IconName := "Robbery"
TotalRequired := 6
Address1 := 0x9F68E68 ; $660[6] Empire Mission Jobs Completed: Robbery
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Air Rescue"
IconName := "AirRescue"
TotalRequired := 15
Address1 := 0x9F69EA0 ; $1704 Air Rescue: Current Checkpoint Level
gosub %CurrentLoopCode%
Name := "Beach Patrol"
IconName := "BeachPatrol"
TotalRequired := 15
Address1 := 0x9F6A3A0 ; $2024 Beach Patrol: Current Checkpoint Level
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Fire Copter"
IconName := "FireCopter"
TotalRequired := 1
Address1 := 0x9F6A3C0 ; $2032 Fire Copter Completed
gosub %CurrentLoopCode%
Name := "Fire Fighter"
IconName := "FireFighter"
TotalRequired := 15
Address1 := 0x9F69E94 ; $1701 Fire Fighter: Current Checkpoint Level
gosub %CurrentLoopCode%
Name := "Paramedic"
IconName := "Paramedic"
TotalRequired := 15
Address1 := 0x9F69E98 ; $1702 Paramedic: Current Checkpoint Level
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Taxi Driver Cash"
IconName := "TaxiDriverCash"
TotalRequired := 5000
Address1 := 0x9F69EB8 ; $1710 Taxi Driver: Cash Made
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Taxi Driver Fares"
IconName := "TaxiDriverFares"
TotalRequired := 50
Address1 := 0x9F69EBC ; $1711 Taxi Driver: Fares Completed
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Vice Sights"
IconName := "ViceSights"
TotalRequired := 1
Address1 := 0x9F6A3C8 ; $2034 Vice Sights Completed
gosub %CurrentLoopCode%
Name := "Vigilante"
IconName := "Vigilante"
TotalRequired := 15
Address1 := 0x9F69E9C ; $1703 Vigilante: Current Checkpoint Level
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Crash!"
IconName := "Crash"
TotalRequired := 1
Address1 := 0x9F69EC4 ; $1713 Crash! Completed
gosub %CurrentLoopCode%
Name := "Checkpoint Challenges"
IconName := "CheckpointChallenges"
TotalRequired := 2
Address1 := 0x9F6A38C ; $2019 Playground On The Town Completed
Address2 := 0x9F6A390 ; $2020 Playground On The Point Completed
gosub %CurrentLoopCode%
Name := "Time Trials"
IconName := "TimeTrials"
TotalRequired := 6
Address1 := 0x9F6A364 ; $2009 Haiti Hover Race Completed
Address2 := 0x9F6A368 ; $2010 Harbor Hover Race Completed
Address3 := 0x9F6A374 ; $2013 Mashin' up the Mall Completed
Address4 := 0x9F6A3A8 ; $2026 Crims On Wings Completed
Address5 := 0x9F6A3B0 ; $2028 Land, Sea And Air Ace Completed
Address6 := 0x9F6A3B8 ; $2030 Skywolf Completed
gosub %CurrentLoopCode%
Name := "BMX Time Trials"
IconName := "BMXTimeTrials"
TotalRequired := 8
Address1 := 0x9F69FD4 ; $1781[0] BMX Time Trials: Track 1 Completed
Address2 := 0x9F69FD8 ; $1781[1] BMX Time Trials: Track 2 Completed
Address3 := 0x9F69FDC ; $1781[2] BMX Time Trials: Track 3 Completed
Address4 := 0x9F69FE0 ; $1781[3] BMX Time Trials: Track 4 Completed
Address5 := 0x9F69FE4 ; $1781[4] BMX Time Trials: Track 5 Completed
Address6 := 0x9F69FE8 ; $1781[5] BMX Time Trials: Track 6 Completed
Address7 := 0x9F69FEC ; $1781[6] BMX Time Trials: Track 7 Completed
Address8 := 0x9F69FF0 ; $1781[7] BMX Time Trials: Track 8 Completed
gosub %CurrentLoopCode%
Name := "Quad Bike Time Trials"
IconName := "QuadBikeTimeTrials"
TotalRequired := 4
Address1 := 0x9F69F5C ; $1751[1] Quad Bike Time Trials: Track 1 Completed
Address2 := 0x9F69F60 ; $1751[2] Quad Bike Time Trials: Track 2 Completed
Address3 := 0x9F69F64 ; $1751[3] Quad Bike Time Trials: Track 3 Completed
Address4 := 0x9F69F68 ; $1751[4] Quad Bike Time Trials: Track 4 Completed
gosub %CurrentLoopCode%
Name := "Sanchez Time Trials"
IconName := "SanchezTimeTrials"
TotalRequired := 12
Address1 := 0x9F6A08C ; $1827[0] Sanchez Time Trials: Track 1 Completed
Address2 := 0x9F6A090 ; $1827[1] Sanchez Time Trials: Track 2 Completed
Address3 := 0x9F6A094 ; $1827[2] Sanchez Time Trials: Track 3 Completed
Address4 := 0x9F6A098 ; $1827[3] Sanchez Time Trials: Track 4 Completed
Address5 := 0x9F6A09C ; $1827[4] Sanchez Time Trials: Track 5 Completed
Address6 := 0x9F6A0A0 ; $1827[5] Sanchez Time Trials: Track 6 Completed
Address7 := 0x9F6A0A4 ; $1827[6] Sanchez Time Trials: Track 7 Completed
Address8 := 0x9F6A0A8 ; $1827[7] Sanchez Time Trials: Track 8 Completed
Address9 := 0x9F6A0AC ; $1827[8] Sanchez Time Trials: Track 9 Completed
Address10 := 0x9F6A0B0 ; $1827[9] Sanchez Time Trials: Track 10 Completed
Address11 := 0x9F6A0B4 ; $1827[10] Sanchez Time Trials: Track 11 Completed
Address12 := 0x9F6A0B8 ; $1827[11] Sanchez Time Trials: Track 12 Completed
gosub %CurrentLoopCode%
Name := "Watersports"
IconName := "Watersports"
TotalRequired := 8
Address1 := 0x9F6A124 ; $1865[0] Watersports: Track 1 Completed
Address2 := 0x9F6A128 ; $1865[1] Watersports: Track 2 Completed
Address3 := 0x9F6A12C ; $1865[2] Watersports: Track 3 Completed
Address4 := 0x9F6A130 ; $1865[3] Watersports: Track 4 Completed
Address5 := 0x9F6A134 ; $1865[4] Watersports: Track 5 Completed
Address6 := 0x9F6A138 ; $1865[5] Watersports: Track 6 Completed
Address7 := 0x9F6A13C ; $1865[6] Watersports: Track 7 Completed
Address8 := 0x9F6A140 ; $1865[7] Watersports: Track 8 Completed
gosub %CurrentLoopCode%
Name := "Turismo"
IconName := "Turismo"
TotalRequired := 9
Address1 := 0x9F6A148 ; $1874[0] Turismo Best Position: Escobar Runway
Address1CustomCode := True
Address2 := 0x9F6A14C ; $1874[1] Turismo Best Position: Downtown Showdown
Address2CustomCode := True
Address3 := 0x9F6A150 ; $1874[2] Turismo Best Position: Port Sports
Address3CustomCode := True
Address4 := 0x9F6A154 ; $1874[3] Turismo Best Position: Rum & Salsa Sting
Address4CustomCode := True
Address5 := 0x9F6A158 ; $1874[4] Turismo Best Position: Cuban Wheels
Address5CustomCode := True
Address6 := 0x9F6A15C ; $1874[5] Turismo Best Position: Fools Rush
Address6CustomCode := True
Address7 := 0x9F6A160 ; $1874[6] Turismo Best Position: High Stakes Highway
Address7CustomCode := True
Address8 := 0x9F6A164 ; $1874[7] Turismo Best Position: Asphalt Assault
Address8CustomCode := True
Address9 := 0x9F6A168 ; $1874[8] Turismo Best Position: Supercharged Circuit
Address9CustomCode := True
gosub %CurrentLoopCode%
Name := "Phil's Shooting Range"
IconName := "PhilsShootingRange"
TotalRequired := 1
Address1 := 0x9F69EC8 ; $1714 Phil's Shooting Range Completed
gosub %CurrentLoopCode%
Name := "Swinger's Club"
IconName := "SwingersClub"
TotalRequired := 1
Address1 := 0x9F69EA4 ; $1705 Swinger's Club Completed
gosub %CurrentLoopCode%
Name := "Sgt. Jerry Martinez"
IconName := "SgtJerryMartinez"
TotalRequired := 3
Address1 := 0x9F68418 ; $6[0] Mission Chain Counter: Sgt. Jerry Martinez
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Phil Cassidy"
IconName := "PhilCassidy"
TotalRequired := 4
Address1 := 0x9F6841C ; $6[1] Mission Chain Counter: Phil Cassidy
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Marty J Williams"
IconName := "MartyJWilliams"
TotalRequired := 5
Address1 := 0x9F68420 ; $6[2] Mission Chain Counter: Marty J Williams
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Louise Cassidy-Williams"
IconName := "LouiseCassidyWilliams"
TotalRequired := 6
Address1 := 0x9F68424 ; $6[3] Mission Chain Counter: Louise Cassidy-Williams
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Lance Vance"
IconName := "LanceVance"
TotalRequired := 14
Address1 := 0x9F68428 ; $6[4] Mission Chain Counter: Lance Vance
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Umberto Robina"
IconName := "UmbertoRobina"
TotalRequired := 4
Address1 := 0x9F6842C ; $6[5] Mission Chain Counter: Umberto Robina
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Bryan Forbes"
IconName := "BryanForbes"
TotalRequired := 3
Address1 := 0x9F68430 ; $6[6] Mission Chain Counter: Bryan Forbes
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Reni Wassulmaier"
IconName := "ReniWassulmaier"
TotalRequired := 7
Address1 := 0x9F68438 ; $6[8] Mission Chain Counter: Reni Wassulmaier
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Armando and Diego Mendez"
IconName := "ArmandoAndDiegoMendez"
TotalRequired := 5
Address1 := 0x9F68434 ; $6[7] Mission Chain Counter: Armando and Diego Mendez
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Gonzalez"
IconName := "Gonzalez"
TotalRequired := 3
Address1 := 0x9F6843C ; $6[9] Mission Chain Counter: Gonzalez
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Ricardo Diaz"
IconName := "RicardoDiaz"
TotalRequired := 5
Address1 := 0x9F68444 ; $6[11] Mission Chain Counter: Ricardo Diaz
Address1CustomCode := True
gosub %CurrentLoopCode%
; Requirements end


; Custom Code Variables
GTAVCS_UpdateVars:
; The offsets of these variables depends on the game's exe.
if (GameVersion = "ULUS10160_1.03_Start2")
{
	GTAVCS_Addr_ProgressMade := 0x8BB3CF0 ; CStats::ProgressMade
	GTAVCS_Addr_InfiniteSprint := 0x8BDE5FD ; CPlayerInfo::m_bInfiniteSprint (m_nMoney + 0xA1)
}
else if (GameVersion = "ULES00502_1.02_pSyPSP")
{
	GTAVCS_Addr_ProgressMade := 0x8BB40D0
	GTAVCS_Addr_InfiniteSprint := 0x8BDE9BD
}
else if (GameVersion = "ULES00503_1.02_Googlecus")
{
	GTAVCS_Addr_ProgressMade := 0x8BB3F50
	GTAVCS_Addr_InfiniteSprint := 0x8BDE83D
}
else if (GameVersion = "ULJM05297_1.01_Caravan")
{
	GTAVCS_Addr_ProgressMade := 0x8BB3F4C
	GTAVCS_Addr_InfiniteSprint := 0x8BC757D
}
else
{
	GTAVCS_Addr_ProgressMade := 0
	GTAVCS_Addr_InfiniteSprint := 0
}
; Read CStats::ProgressMade used in custom code.
if (GTAVCS_Addr_ProgressMade)
	GTAVCS_Var_ProgressMade := GTAVCS_ReadMemory(GTAVCS_Addr_ProgressMade, "Float")
else
	GTAVCS_Var_ProgressMade := 0
; Only proceed reading the rest of the variables if Percentage Only mode is not enabled.
if (SpecialMode != "PercentageOnly")
{
	; Read CPlayerInfo::m_bInfiniteSprint used in custom code.
	if (GTAVCS_Addr_InfiniteSprint)
		GTAVCS_Var_InfiniteSprint := GTAVCS_ReadMemory(GTAVCS_Addr_InfiniteSprint, "Char", 1)
	else
		GTAVCS_Var_InfiniteSprint := 0
	; Read MAIN.SCM global variables used in custom codes.
	GTAVCS_Var_ImportExportGroundListsCompleted := GTAVCS_ReadMemory(0x9F69F18) ; $1734 Import/Export: Ground Lists Completed
	GTAVCS_Var_CurrentChapter := GTAVCS_ReadMemory(0x9F68608) ; $130 Current Chapter
	GTAVCS_Var_EmpireMissionRespectLevelExtortion := GTAVCS_ReadMemory(0x9F68E70) ; $667[1] Empire Mission Respect Level: Extortion
	GTAVCS_Var_EmpireMissionRespectLevelLoanShark := GTAVCS_ReadMemory(0x9F68E74) ; $667[2] Empire Mission Respect Level: Loan Shark
	GTAVCS_Var_EmpireMissionRespectLevelPimping := GTAVCS_ReadMemory(0x9F68E78) ; $667[3] Empire Mission Respect Level: Pimping
	GTAVCS_Var_EmpireMissionRespectLevelDrugRunning := GTAVCS_ReadMemory(0x9F68E7C) ; $667[4] Empire Mission Respect Level: Drug Running
	GTAVCS_Var_EmpireMissionRespectLevelSmuggling := GTAVCS_ReadMemory(0x9F68E80) ; $667[5] Empire Mission Respect Level: Smuggling
	GTAVCS_Var_EmpireMissionRespectLevelRobbery := GTAVCS_ReadMemory(0x9F68E84) ; $667[6] Empire Mission Respect Level: Robbery
	GTAVCS_Var_BeachPatrolCompleted := GTAVCS_ReadMemory(0x9F6A39C) ; 2023 Beach Patrol Completed
	GTAVCS_Var_TaxiDriverCompleted := GTAVCS_ReadMemory(0x9F69EB4) ; $1709 Taxi Driver Completed
	GTAVCS_Var_VigilanteCompleted := GTAVCS_ReadMemory(0x9F69EC0) ; 1712 Vigilante Completed
}
return
; Custom Code Variables end


; Custom Codes
GTAVCS_PercentageCompleted_Address1CustomCode:
MemoryValue := GTAVCS_Var_ProgressMade / 2.23 ; CStats::TotalProgressInGame is 223 (CStats::ProgressMade + 0x4)
return


GTAVCS_CivilAssetForfeitureImpound_Address1CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address2CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address3CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address4CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address5CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address6CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address7CustomCode:
GTAVCS_CivilAssetForfeitureImpound_Address8CustomCode:
if (GTAVCS_Var_ImportExportGroundListsCompleted >= 2)
{
	MemoryValue += 2
	return
}
if (GTAVCS_Var_ImportExportGroundListsCompleted = 1)
	MemoryValue += 1
return


GTAVCS_EmpireSites_Address1CustomCode:
GTAVCS_EmpireSites_Address2CustomCode:
GTAVCS_EmpireSites_Address3CustomCode:
GTAVCS_EmpireSites_Address4CustomCode:
GTAVCS_EmpireSites_Address5CustomCode:
GTAVCS_EmpireSites_Address6CustomCode:
GTAVCS_EmpireSites_Address7CustomCode:
GTAVCS_EmpireSites_Address8CustomCode:
if (MemoryValue = 1)
	MemoryValue := 5
return


GTAVCS_EmpireHighRollers_Address1CustomCode:
GTAVCS_EmpireHighRollers_Address2CustomCode:
GTAVCS_EmpireHighRollers_Address3CustomCode:
GTAVCS_EmpireHighRollers_Address4CustomCode:
GTAVCS_EmpireHighRollers_Address5CustomCode:
GTAVCS_EmpireHighRollers_Address6CustomCode:
GTAVCS_EmpireAttacks_Address2CustomCode:
GTAVCS_EmpireAttacks_Address3CustomCode:
GTAVCS_EmpireAttacks_Address4CustomCode:
; This code is a bit unfortunate, but the only variables I could found used the value 0 for True.
if (GTAVCS_Var_CurrentChapter >= 1 && MemoryValue = 0)
{
	MemoryValue := 1
	return
}
MemoryValue := 0
return


GTAVCS_Extortion_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelExtortion >= 2)
	MemoryValue := 15
return


GTAVCS_LoanShark_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelLoanShark >= 2)
	MemoryValue := 15
return


GTAVCS_Pimping_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelPimping >= 2)
	MemoryValue := 15
return


GTAVCS_DrugRunning_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelDrugRunning >= 2)
	MemoryValue := 6
return


GTAVCS_Smuggling_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelSmuggling >= 2)
	MemoryValue := 6
return


GTAVCS_Robbery_Address1CustomCode:
if (GTAVCS_Var_EmpireMissionRespectLevelRobbery >= 2)
	MemoryValue := 6
return


GTAVCS_BeachPatrol_Address1CustomCode:
if (GTAVCS_Var_BeachPatrolCompleted = 1)
	MemoryValue := 15
return


GTAVCS_Paramedic_Address1CustomCode:
if (GTAVCS_Var_InfiniteSprint = 1)
	MemoryValue := 15
return


GTAVCS_TaxiDriverCash_Address1CustomCode:
if (GTAVCS_Var_TaxiDriverCompleted = 1)
	MemoryValue := 5000
return


GTAVCS_TaxiDriverFares_Address1CustomCode:
if (GTAVCS_Var_TaxiDriverCompleted = 1)
	MemoryValue := 50
return


GTAVCS_Vigilante_Address1CustomCode:
if (GTAVCS_Var_VigilanteCompleted = 1)
	MemoryValue := 15
return


GTAVCS_Turismo_Address1CustomCode:
GTAVCS_Turismo_Address2CustomCode:
GTAVCS_Turismo_Address3CustomCode:
GTAVCS_Turismo_Address4CustomCode:
GTAVCS_Turismo_Address5CustomCode:
GTAVCS_Turismo_Address6CustomCode:
GTAVCS_Turismo_Address7CustomCode:
GTAVCS_Turismo_Address8CustomCode:
GTAVCS_Turismo_Address9CustomCode:
if (MemoryValue = 1)
	return
MemoryValue := 0
return


GTAVCS_SgtJerryMartinez_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter >= 1)
{
	MemoryValue := 3
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_PhilCassidy_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter >= 1)
{
	MemoryValue := 4
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_MartyJWilliams_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter >= 1)
{
	MemoryValue := 5
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_LouiseCassidyWilliams_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	MemoryValue := 6
	return
}
if (GTAVCS_Var_CurrentChapter = 1)
{
	if (MemoryValue >= 4)
	{
		MemoryValue += 2
		return
	}
	MemoryValue += 3
	return
}
if (MemoryValue)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_LanceVance_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	if (MemoryValue >= 3)
	{
		MemoryValue += 3
		return
	}
	MemoryValue += 4
	return
}
if (GTAVCS_Var_CurrentChapter = 1)
{
	if (MemoryValue >= 4)
	{
		MemoryValue -= 2
		return
	}
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_UmbertoRobina_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	MemoryValue := 4
	return
}
if (GTAVCS_Var_CurrentChapter = 1)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_BryanForbes_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	MemoryValue := 3
	return
}
if (GTAVCS_Var_CurrentChapter = 1)
{
	if (MemoryValue >= 3)
	{
		MemoryValue -= 2
		return
	}
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_ReniWassulmaier_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	if (MemoryValue >= 9)
	{
		MemoryValue -= 2
		return
	}
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_ArmandoAndDiegoMendez_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	if (MemoryValue >= 5)
	{
		MemoryValue -= 2
		return
	}
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_Gonzalez_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	if (MemoryValue >= 6)
	{
		MemoryValue -= 3
		return
	}
	if (MemoryValue >= 2)
	{
		MemoryValue -= 2
		return
	}
	MemoryValue -= 1
	return
}
MemoryValue := 0
return


GTAVCS_RicardoDiaz_Address1CustomCode:
GTAVCS_Var_CurrentChapter := GTAVCS_Var_CurrentChapter
if (GTAVCS_Var_CurrentChapter = 2)
{
	MemoryValue -= 1
	return
}
MemoryValue := 0
return
; Custom Codes end

