; GameVersionCheck by NABN00B

; Load prerequisites.
#Include <classMemory>

; Function:                 GameVersionCheck(emulator, gameName [, ByRef gameVersion] )
;                           Returns the value to offset the game's pointers depending on the game's version.
; Requirements:
;   classMemory.ahk     -   _ClassMemory class by RHCP
; Parameters:
;   emulator            -   The _ClassMemory object of a running emulator process.
;   gameName            -   The selected game's name without space.
;   [gameVersion] (Out) -   The selected game's detected version. Input value defaults to an empty string.
; Return values:
;   integer             -   The value to offset the game's pointers, corresponding to the selected game's
;                           detected version.
;   "Error"             -   Indicates failure.

GameVersionCheck(emulator, gameName, ByRef gameVersion := "")
{
	; Check if the parameter is an existing _ClassMemory object. Stop if it's not.
	if (!IsObject(emulator) || emulator.__class != "_ClassMemory")
	{
		gameVersion := ""
		return "Error"
	}
	
	; AHK only supports up to 20 switch case values so I decided to stick with if statements.
	if (gameName = "GTALCS")
	{
		; No version checking yet.
		if (True)
		{
			gameVersion := "ULUS10041_1.05_ARTiSAN"
			return 0x0
		}
		
		; If version is unrecognised, warn the user about unintended behaviour.
		gameVersion := "ULUS10041_1.05_ARTiSAN"
		MsgBox, Error`: The script could not determine the version of %gameName%.`nThe version is defaulted to %gameVersion%.`nIf this is not the correct version, try restarting the script once the game is fully loaded.`nOtherwise the checklist might not work as intended.
		return 0x0
	}
	
	if (gameName = "GTAVCS")
	{
		; No version checking yet.
		if (True)
		{
			gameVersion := "ULUS10160_1.03_Start2"
			return 0x0
		}
		
		; If version is unrecognised, warn the user about unintended behaviour.
		gameVersion := "ULUS10160_1.03_Start2"
		MsgBox, Error`: The script could not determine the version of %gameName%.`nThe version is defaulted to %gameVersion%.`nIf this is not the correct version, try restarting the script once the game is fully loaded.`nOtherwise the checklist might not work as intended.
		return 0x0
	}
	
	/*
	else if (gameName = "YourGame")
	{
		; Detect version.
		; Update the value of gameVersion to a non-empty string.
		; Return corresponding offset.
		
		; If version is unrecognised, warn the user about unintended behaviour.
		MsgBox Error`: The script could not determine the version of Your Game.`nThe checklist might not work as intended.
		; Update the value of gameVersion to a non-empty string.
		; Return 0x0 if you wish the program to be able to continue operating
		; or return "Error" to make it stop.
	}
	*/
	
	; If the game is invalid (eg. not in SupportedGamesList), return "Error" to indicate failure.
	gameVersion := ""
	return "Error"
}
