; <!> Comments starting with <!> like this one are help messages, explaining you what the code should do.
; <!> You should remove these lines once your script is complete, but keep the rest of the comments to make your script easier to understand for others.

; <!> This header section contains a brief description of the file and the name of authors.
/*
	PPSSPP 100% Checklist
	Tutorial Example Requirement List by Your_Name
	This file is only to be used with '..\PPSSPP 100% Checklist.ahk'
*/

; <!> This header should contain the name the game must be refered to as everywhere in the code (GameNameNoSpace).
; ######################################################################################################
; ############################################## Tutorial ##############################################
; ######################################################################################################

; <!> This comment section lists the contents of the file: all labels, functions and a list of all custom code labels that you used. Make sure to keep it up to date as you develop your script.
; <!> Note that the "Initialize", "VersionCheck", "PercentageOnlyRequirements", "Requirements", "UpdateVars" labels and the "ReadMemory(address, type, length)" function must be implemented in order for the app to work!
; <!> Custom Codes are optional - their only use is to aid your implementation in some special cases.
/*
Subheadings:

	Tutorial_Initialize
	Tutorial_VersionCheck
	Tutorial_ReadMemory(address, type, length)
	Tutorial_PercentageOnlyRequirements
	Tutorial_Requirements
	Tutorial_UpdateVars

	Custom Codes:

		Tutorial_PercentageCompleted_Address1CustomCode
		Tutorial_Firefighter_Address1-3CustomCode/Tutorial_Vigilante_Address1-3CustomCode
		Tutorial_TaxiDriver_Address1CustomCode
*/


; <!> This is where you should include other autohotkey scripts that are used by your script. Eg memory reading script, utility functions.
; <!> Surround the script's filename with '< >' and omit the file extension. Make sure the script is in the 'Lib' folder, just like this file.
; <!> Include required scripts even if they are included by other scripts or the app itself - AutoHotkey will automatically ensure that each file is only included once at runtime.
; <!> Technically, prerequisites can be included anywhere in the code, but doing it before the actual script makes it easier for others to find them.
; <!> This tutorial will rely on RHCP's classMemory script, which provides the easiest way of accessing the memory of processes (and is also what the app's main code uses).
; Prerequisites
#Include <classMemory>


; <!> This is the label where we initialise some variables that are important for creating the requirement list and finding the game process at runtime.
; Initialization
Tutorial_Initialize:
; <!> The FileInstall command will pack your icon library into the script (which will be compiled into the application's executable) and extract it during runtime for the app to read.
; <!> Make sure your icon library is placed inside the 'FileInstall' folder.
; <!> The filename of the icon library must not contain variables, so it has to be hardcoded. Replace "GTALCS" with your GameNameNoSpace value. Don't change the 2nd and 3rd parameters.
FileInstall, FileInstall\GTALCS Icons.icl, %ScriptNameNoExt% Icons.icl, 1
; <!> Build the IconArray associative array that is used to identify the icons in your icons library, and also to identify each requirement in the application.
IconArray := {"PercentageCompleted":1, "HiddenPackages":2, "Rampages":3, "UniqueStunts":4, "CarRazyCarGiveAway":5, "AvengingAngels":6, "Firefighter":7, "Paramedic":8, "TaxiDriver":9, "TrashDash":10, "Vigilante":11, "BikeSalesman":12, "CarSalesman":13, "FoodDeliveries":14, "StreetRaces":15, "RCRaces":16, "RailShooters":17, "BumpsAndGrinds":18, "SeeTheSightBeforeYourFlight":19, "CheckpointChallenges":20, "Karmageddon":21, "RCTriadTakeDown":22, "SlashTV":23, "VincenzoCilli":24, "JDOToole":25, "MaCipriani":26, "SalvatoreLeone":27, "Maria":28, "DonaldLove":29, "ChurchConfessional":30, "LeonMcAffrey":31, "ToshikoKasen":32, "8Ball":33}
; <!> The name of the AutoHotkey class specific to the target game. Can be determined by the 'WindowSpy.ahk' script (that comes with AHK by default).
; <!> Move the cursor over the game while Window Spy is running and look for the 'ahk_class' value.
GameWindowClass := "Grand theft auto 3"
; <!> The name of the target game's process. Look for the 'ahk_exe' value in Window Spy.
GameProcessName := "gta3.exe"
; <!> The app will look for the executable and class specified above to detect wether your game is running.
return
; Initialization end


; <!> This label is responsible for handling version control for your game. This mainly consists of version detection and setting the memory offset corresponding to the detected version.
; <!> Please note that version control may work differently for each and every game! The example below is for GTA III specifically.
; Version Control
Tutorial_VersionCheck:
; <!> Read the value from the game memory which will be used to decide the game's version.
; <!> At this point in the script you can already read the contents of your game's memory as you please. Refer to the function descriptions inside 'classMemory.ahk'.
Value := GameMemory.read(0x00608578)
; <!> Note that switch in AHK will exit after executing any of branches.
switch Value
{
	case 0x5D:
		GameExeVersion := "v1.0"
		GameExeVersionOffset := 0
	case 0x81:
		GameExeVersion := "v1.1"
		GameExeVersionOffset := 8
	case 0x5B:
		GameExeVersion := "Steam"
		GameExeVersionOffset := -0xFF8
	case 0x44:
		GameExeVersion := "Japanese"
		GameExeVersionOffset := -0x2FF8
	default:
		; If version is unrecognised, warn the user about unintended behaviour.
		GameExeVersion := "v1.0"
		GameExeVersionOffset := 0x0
		MsgBox, 0x2030, , Error`: The script could not determine the version of %CurrentGame%.`n`nThe version is defaulted to %GameExeVersion%.`nIf this is not the correct version, try restarting the script once the game is fully loaded.`nOtherwise the checklist might not work as intended.
}
return
; <!> Programs such as emulators will require multiple offsets for version control - one for the emulator's version and another for loaded ROM's version. For this purpose, the GameVersion and GameVersionOffset variables may also be set in this label in addition to GameExeVersion and GameExeVersionOffset.
; <!> You must implement this label, even if you don't do anything in it (because you don't know how to deal with version control). In this case, make sure you use the most widely accepted version of your game while developing this script.
; Version Control end


; <!> The implementation of this function will define how the app will read memory addresses from your game. This is required because different games can use pointers differently.
; <!> The parameters represent the memory address, type and length. The app's main code will expect a function with these parameters in this order.
; <!> See the notes for "Tutorial_Requirements" for a list of possible types.
; Memory Reading Function
Tutorial_ReadMemory(address, type := "Int", length := 4)
{
	; <!> The global keyword is required to be able to access the game's memory and version control variables.
	global
	; <!> Use the "read" method to read numerical values, "readString" to read strings and "readRaw" to read an array of bytes. Refer to the function descriptions inside 'classMemory.ahk'.
	return GameMemory.read(address+GameExeVersionOffset, type)
	; <!> Depending on how your game uses pointers, and how complex your game's version control is, you may need to use a different approach when reading the game's memory. Below is another example.
	return GameMemory.read(GameMemory.BaseAddress + GameExeVersionOffset, type, address + GameVersionOffset)
	; <!> If you need to list non-numeric values you need to check for the value of type and then call the corresponding function.
	if (type = "UTF-8" || type = "UTF-8-RAW")
		return GameMemory.readString(address+GameExeVersionOffset, length, type)
	if (type = "Bytes")
	{
		MemoryValue := ""
		GameMemory.readRaw(address+GameExeVersionOffset, MemoryValue, length)
		return MemoryValue
	}
}
; Memory Reading Function end


; Requirements
; <!> This label contains every requirement that will be shown in the app when using "percentage only mode". See the notes under the "Tutorial_Requirements" label for syntax.
; <!> This can literally be a copy-paste of the "Percentage Completed" requirement from the "Tutorial_Requirements" label.
Tutorial_PercentageOnlyRequirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := 0x0090651C ; Completion Points
Address1CustomCode := True
gosub %CurrentLoopCode%
return


; <!> This label contains every requirement that will be shown in the app.
; <!> The requirements will appear in the checklist in the same order they are listed here.
; <!>    Syntax for adding new requirements:
; <!>        Name := "Percentage Completed"     ; (str) Displayed name of the requirement. Defaults to "???".
; <!>        [Type := "Float"]                  ; (str) Type of the requirement. See below for a list of possible types. Defaults to "Int".
; <!>        IconName := "PercentageCompleted"  ; (str) Internal name and displayed icon of the requirement. Must be unique per game. These are the same icon names you defined in IconArray.
; <!>        [TotalRequired := 100]             ; (int) Minimal value required to consider the requirement as completed. Defaults to "" (total value will be omitted from checklist).
; <!>        Address{Index} := 0x8B5E158        ; (int) Full memory address, memory address offset or pointer offset depending on the implementation of "Tutorial_ReadMemory" function above.
; <!>                                                   In case of hex format, the "0x" prefix is required.
; <!>        [Address{Index}Length := 2]        ; (int) Size of value at the address in bytes. Defaults to 4.
; <!>        [Address{Index}CustomCode := True] ; (int) Execite custom code or not after reading value from the address. Defaults to 0. Use "True" for better readability and searchability.
; <!>        gosub %CurrentLoopCode%            ;       Continue the cycle in code. NOTE: This is required at the end of every requirement for intended behavior.
; <!>    List of possible requirement types: (Note that they must not contain whitespace)
; <!>        Numeric types with fixed lengths:
; <!>            "UChar":    1,  "Char":     1,
; <!>            "UShort":   2,  "Short":    2,
; <!>            "UInt":     4,  "Int":      4,
; <!>            "UFloat":   4,  "Float":    4,
; <!>            "Int64":    8,  "Double":   8
; <!>        String types (encoding), use Address{Index}Length to set their length:
; <!>            "UTF-8" ,  "UTF-8-RAW" ,
; <!>            "UTF-16",  "UTF-16-RAW",
; <!>            "CPnnnnn"   where "nnnnn" is a Code Page Identifier
; <!>        Array of bytes, use Address{Index}Length to set its length:
; <!>            "Bytes"
; <!> Variables surrounded in brackets '[ ]' above are optional.
; <!> Substitute "{Index}" with an integer starting from 1. Eg. Address1, Address1CustomCode, Address2, Address2CustomCode ...
; <!> You have to figure out the addresses yourself with the use of programs like Cheat Engine, debuggers or in some cases reverse engineering tools.
; <!> Custom Codes are a powerful method of modifying the value displayed in the checklist after it's been read from the address via special case-by-case codes.
; <!> If an Address{Index}CustomCode variable is set to 1, the custom code must be implemented as a label with the name of "Tutorial_IconName_Address{Index}CustomCode", otherwise the app will throw an error.
Tutorial_Requirements:
Name := "Percentage Completed"
Type := "Float"
IconName := "PercentageCompleted"
Address1 := 0x0090651C ; Completion Points
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Firefighter"
IconName := "Firefighter"
TotalRequired := 60
Address1 := 0x0075C474 ; Firefighter: Portland Fires
Address1CustomCode := True
Address2 := 0x0075C478 ; Firefighter: Staunton Island Fires
Address2CustomCode := True
Address3 := 0x0075C47C ; Firefighter: Shoreside Vale Fires
Address3CustomCode := True
gosub %CurrentLoopCode%
Name := "Taxi Driver"
IconName := "TaxiDriver"
TotalRequired := 100
Address1 := 0x0075B9B4 ; Taxi Driver: Fares Completed
Address1CustomCode := True
gosub %CurrentLoopCode%
Name := "Vigilante"
IconName := "Vigilante"
TotalRequired := 60
Address1 := 0x0075C454 ; Vigilante: Portland Kills
Address1CustomCode := True
Address2 := 0x0075C458 ; Vigilante: Staunton Island Kills
Address2CustomCode := True
Address3 := 0x0075C45C ; Vigilante: Shoreside Vale Kills
Address3CustomCode := True
gosub %CurrentLoopCode%
return
; Requirements end



; Custom Code Variables
Tutorial_UpdateVars:
if (Memory(3, 0x005C1E70, 4) = 0x53E58955) ; Game is version 1.0
	Tutorial_Var_CompletionPoints := Tutorial_ReadMemory(0x008F6224, "Float") ;Memory(3, 0x008F6224, 4)
else if (Memory(3, 0x009F3C17, 4) = 0x6AEC8B55) ; Game is Japanese version
	Tutorial_Var_CompletionPoints := Tutorial_ReadMemory(0x0090436C, "Float") ;Memory(3, 0x0090436C, 4)
; <!> When the app is running in "percentage only mode", variables that are not needed for PrecentageOnlyRequirements, don't need to be updated.
if (SpecialMode != "PercentageOnly")
{
	Tutorial_Var_TaxiDriverCompleted := Tutorial_ReadMemory(0x0075B9C4) ;Memory(3, 0x0075B9C4+VersionOffset, 4)
}
return
; Custom Code Variables end



; Custom Codes
Tutorial_PercentageCompleted_Address1CustomCode:
if (Memory(3, 0x005C1E70, 4) = 0x53E58955 || Memory(3, 0x009F3C17, 4) = 0x6AEC8B55) ; Game is v1.0 or Japanese
	MemoryValue := Tutorial_Var_CompletionPoints
MemoryValue /= 1.54 ; Total: 154
return


; <!> Custom Codes that contain the same code can have the same body.
Tutorial_Firefighter_Address1CustomCode:
Tutorial_Firefighter_Address2CustomCode:
Tutorial_Firefighter_Address3CustomCode:
Tutorial_Vigilante_Address1CustomCode:
Tutorial_Vigilante_Address2CustomCode:
Tutorial_Vigilante_Address3CustomCode:
if (MemoryValue >= 21)
	MemoryValue := 20
return


Tutorial_TaxiDriver_Address1CustomCode:
if (Tutorial_Var_TaxiDriverCompleted = 1)
	MemoryValue := 100
return
; Custom Codes end

