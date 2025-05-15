/*
	PPSSPP 100% Checklist
	Supported Games List
	This file is only to be used with '..\PPSSPP 100% Checklist.ahk'


	This label has been isolated from the rest of the script in order to make implementation of support for games easier.


	Requirements for adding a new game:
	* Add the requirements list (for both percentage only and normal objectives) into a new file, including custom code if applicable.
	* Add the icons to 'Icons.icl', and define them in the IconArray associative array in your file.
	* Include the requirements file at the bottom of this file.
	* Add the game to the SupportedGamesList label in this fule.
	* Implement the game's version control in 'Lib\GameVersionCheck.ahk'.
	Try and follow coding conventions!


	Syntax for adding new requirements:
		Name := "Percentage Completed"     ; (str) Displayed name of the requirement. Defaults to "???".
		[Type := "Float"]                  ; (str) Type of the requirement. Specify "Float" or omit it. Defaults to "Int".
		IconName := "PercentageCompleted"  ; (str) Internal name and displayed icon of the requirement. Must be unique per game.
		[TotalRequired := 100]             ; (int) Minimal value required to consider the requirement as completed. Defaults to "" (empty string).
		Address{Index} := 0x8B5E158        ; (int) Pointer offset. Don't include the base offset because that's handled in 'Lib\EmuVersionCheck.ahk'.
		                                   ;       NOTE: This is not the entire addres! The "0x" prefix is required in case of hex format!
		[Address{Index}Length := 2]        ; (int) Size of value in bytes. Defaults to 4.
		[Address{Index}CustomCode := True] ; (int) Use custom code or not when reading value from memory. Defaults to 0. Use "True" for searchability.
		gosub %CurrentLoopCode%            ;       Continue the cycle in code. NOTE: This is required at the end of every requirement for intended behavior.
*/

; ######################################################################################################
; ######################################## SUPPORTED GAMES LIST ########################################
; ######################################################################################################

/*
Subheadings:

	SupportedGamesList

Supported games list:

	GTALCS
	GTAVCS
	; Tutorial
*/


; These are the games that will show up in the welcome window and can be selected there.
; Also included is the name used internally by this program for the game.
SupportedGamesList:
GameName := "GTA Liberty City Stories"
GameNameNoSpace := "GTALCS"
gosub %CurrentLoopCode%
GameName := "GTA Vice City Stories"
GameNameNoSpace := "GTAVCS"
gosub %CurrentLoopCode%
/*
GameName := "Tutorial Example"
GameNameNoSpace := ""
gosub %CurrentLoopCode%
*/
return


; These are the files that contain the requirements for each game. They are included at
; an isolated part of the script so that the labels inside them don't get executed
; automatically.
#Include <Checklist_GTALCS>
#Include <Checklist_GTAVCS>
/*
#Include <Checklist_Tutorial>
*/

