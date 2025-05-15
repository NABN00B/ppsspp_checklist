/*
	PPSSPP 100% Checklist by NABN00B
	with contributions by Parik
	Original 100% Checklist by Lighnat0r with contributions by zoton2
	https://github.com/Lighnat0r-pers/100pc_checklist

	This derivative of the 100% Checklist has been modified to support 64 bit executables and bring several enhancements.
	Support for new games can be added by specifying the requirements in a new script file. Refer to 'Lib\Checklist_Tutorial.ahk'.

	Developed in version 1.1.31.01 of AutoHotkey.


	List of GUI windows in use:
		1: Output Window
		2: Welcome Screen
		3: Exit Confirmation
		4: Settings Window
		5: Semi-Transparent Background for Welcome Screen
		6: Semi-Transparent Background for Output Window
		7: Update Notifier
		FilenameError: Long Filename Error Message


	Table of Contents:
		Header Section
		Update Checker
		Welcome Window
		Settings Window
		Output Window
		File Output
		Update Output
		Restart/Exit Sequence
		Debug Stuff
		Supported Games List
*/


; ######################################################################################################
; ########################################### HEADER SECTION ###########################################
; ######################################################################################################

/*
Subheadings:

	#AUTO-EXECUTE
	ResetVersionControlVars
	FileList
	OpenReadme
	DefaultSettings
	SetVariablesDependentOnSettings
	WriteSettingsFile
	ReadSettingsFile
	IsColor(color)
	ErrorFilenameLength
	FilenameErrorButtonContinue/FilenameErrorGuiClose/FilenameErrorGuiEscape
	FilenameErrorButtonAbort
*/


/*
; Enable warnings to assist with detecting common errors.
#Warn All, MsgBox
*/
; Prevent empty variables from being looked up as potential environment variables.
#NoEnv
; Only one instance of the program can be running at a time.
#SingleInstance Force
; SetWinDelay, 0 is necessary to make the semi-transparent background window move without delay.
SetWinDelay, 0
; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%
; Load prerequisites.
#Include <classMemory>
#Include <ChooseColor>
#Include <ArrayToString>
#Include <GetLastErrorMessage>
; Tell the program what to do if it is closed.
OnExit, ExitSequence
; Install the readme.
SplitPath, A_ScriptName, , , , ScriptNameNoExt
FileInstall, FileInstall\Readme.txt, %ScriptNameNoExt% Readme.txt, 1
; Install and configure the application icons.
FileInstall, FileInstall\Checklist Icons.icl, %ScriptNameNoExt% Icons.icl, 1
ImageFilename := ScriptNameNoExt . " Icons.icl"
Menu, Tray, Icon, %ImageFilename%, 1, 1
; Change the name of the program in the tray menu, then remove the standard tray items
; and add the ones relevant to this program.
Menu, Tray, Tip, %ScriptNameNoExt%
Menu, Tray, NoStandard
Menu, Tray, Add, Restart Script, RestartSequence
Menu, Tray, Add, Open Readme, OpenReadme
Menu, Tray, Add, Exit, ExitSequence
ScriptNameNoExtLength := StrLen(ScriptNameNoExt)
if (ScriptNameNoExtLength >= 199)
	gosub ErrorFilenameLength
/*
; Enable debug functions if they exist and if the program is not compiled.
; This way normal users can't (accidentally) activate them.
if (IsLabel("DebugFunctions") AND A_IsCompiled != 1)
	gosub DebugFunctions
*/
; Initialise the settings. To make sure all settings exist, first load the default settings.
; Then check if the settings file exist and read it if it does. In case there are no saved settings,
; the program will look for the config of Lighnat0r's checklist and copy the settings, so the user
; does not have to reconfigure everything.
gosub DefaultSettings
SettingsFileNameOld := A_ScriptDir . "\100`% Checklist Config`.dll"
SettingsFileName := ScriptNameNoExt . " Config`.ini"
ifExist, %SettingsFileName%
	gosub ReadSettingsFile
ifNotExist, %SettingsFileName%
{
	ifExist, %SettingsFileNameOld%
	{
		MsgBox, 0x2044, , The configuration file for PPSSPP 100`% Checklist could not be found, however, the configuration of Lighnat0r's 100`% Checklist is detected.`n`nDo you wish to load this configuration?`nSelect 'No' to use the default configuration.
		IfMsgBox, Yes
			gosub ReadOldSettingsFile
	}
	gosub WriteSettingsFile
}
gosub SetVariablesDependentOnSettings
; Configure the auto updater. The auto updater only triggers if the program is compiled, otherwise
; the program will go to the create arrays subroutine immediately, skipping the auto updater.
CurrentVersion := 20221217
VersionURL := "http://pastebin.com/raw/pc9QbQCK"
ProgramName := "PPSSPP 100% Checklist"
gosub FileList
/*
if (A_IsCompiled = 1)
{
	gosub UpdateCheck
	loop
	{
		if (UpdaterActive != 1)
			break
		sleep 100
	}
}
*/
; Initialization of variables.
; All of these variables' values are updated from the selected game's requirements file.
; Create the array with the icon indexes from the icons library. The icon names are used in the
; requirement lists and translated into the actual icons using this array.
IconArray := {"IconSolid":1, "Icon":2}
; Create the variables needed to find PPSSPP and to see if it's still running.
EmulatorWindowClass := "PPSSPPWnd"
EmulatorProcessName32bit := "PPSSPPWindows.exe"
EmulatorProcessName64bit := "PPSSPPWindows64.exe"
EmulatorPID := 0
EmulatorMemory := 0
gosub ResetVersionControlVars
; The requirements array is created later because it depends on settings chosen by the user.
goto WelcomeScreen


ResetVersionControlVars:
; Initialise some variables used by the script later for PPSSPP and game version control.
EmulatorVersion := "Unknown"
EmulatorBaseOffset := 0
GameDataAddress := 0
GameVersion := "unknown game"
GameScript := "unknown"
return


; List of names of the files the auto updater should download.
FileList:
File1 := "PPSSPP 100% Checklist newversion.exe"
File2 := "PPSSPP 100% Checklist Source.ahk"
File3 := "PPSSPP 100% Checklist Readme.txt"
ExecutableFile := File1
return


; First define which file from the file list is the readme, then test if it exists
; and open it if it does. Otherwise, show an error message with the most likely issue.
OpenReadme:
ReadmeFile := ScriptNameNoExt . " Readme.txt"
if (FileExist(ReadmeFile))
	Run, edit %ReadmeFile%
else
	MsgBox, 0x2030, , The readme could not be found.`n`nPlease make sure it is located in the same folder as the executable.
return


; These default settings will be used if they haven't been configured otherwise in the settings file.
DefaultSettings:
TextColour := DefaultTextColour := "000000"
BackColour := DefaultBackColour := "BDDCFD"
CustomColours := DefaultCustomColours := [0x000000, 0xFFFFFF, 0x000000, 0xFFFFFF, 0x000000, 0x000000, 0x000000, 0x000000, 0xF1F2F3, 0x313131, 0xFEFEFE, 0x010101, 0xBDDCFD, 0x94FF81, 0xFF8D81, 0xFFFF81]
FontSize := DefaultFontSize := 8
FontType := DefaultFontType := 1024
MaximumRowsText := DefaultMaximumRowsText := 33
MaximumRowsIcons := DefaultMaximumRowsIcons := 11
DecimalPlaces := DefaultDecimalPlaces := 2
RefreshRate := DefaultRefreshRate := 500
RefreshRateFileOutput := DefaultRefreshRateFileOutput := 5000
Transparency := DefaultTransparency := 255
TextSmoothing := DefaultTextSmoothing := 0
OutputWindowBoldText := DefaultOutputWindowBoldText := 1
ShowDoneIfDone := DefaultShowDoneIfDone := 1
ExitConfirmed := DefaultExitConfirmed := 0
AlwaysOnTop := DefaultAlwaysOnTop := 0
return


; Some of the settings have to be explicitly activated, or other variables depend on them.
SetVariablesDependentOnSettings:
if (OutputWindowBoldText = 1)
	CharacterWidth := 6
else
	CharacterWidth := 5.6
IconListViewWidth := 46 + 54 * FontSize / 8 ; Originally 85
TextListViewWidth := 225
IconListViewWidthWithFloat := IconListViewWidth + Round(CharacterWidth * DecimalPlaces)
; For text mode the list view width is determined more precisely while it is created
; so defining a width with float here is not necessary.
SetFormat, Float, 0.%DecimalPlaces%
return


; Save the settings to the settings file.
WriteSettingsFile:
IniWrite, %TextColour%, %SettingsFileName%, Options, Text colour
IniWrite, %BackColour%, %SettingsFileName%, Options, Background colour
CustomColours := ArrayToString(CustomColours, ",")
IniWrite, %CustomColours%, %SettingsFileName%, Options, Custom colours
CustomColours := StrSplit(CustomColours, ",", " `t")
IniWrite, %FontSize%, %SettingsFileName%, Options, Font size
/*
IniWrite, %FontType%, %SettingsFileName%, Options, Font type
*/
IniWrite, %MaximumRowsText%, %SettingsFileName%, Options, Text mode maximum rows
IniWrite, %MaximumRowsIcons%, %SettingsFileName%, Options, Icon mode maximum rows
IniWrite, %DecimalPlaces%, %SettingsFileName%, Options, Decimal places
IniWrite, %RefreshRate%, %SettingsFileName%, Options, Refresh rate (ms)
RefreshRateFileOutput := Round(RefreshRateFileOutput / 1000)
IniWrite, %RefreshRateFileOutput%, %SettingsFileName%, Options, Refresh rate file output (sec)
RefreshRateFileOutput := Round(RefreshRateFileOutput * 1000)
Transparency := 100 - Round(Transparency / 2.55)
IniWrite, %Transparency%, %SettingsFileName%, Options, Transparency
Transparency := 255 - Round(Transparency * 2.55)
IniWrite, %TextSmoothing%, %SettingsFileName%, Options, Text Smoothing
IniWrite, %OutputWindowBoldText%, %SettingsFileName%, Options, Bold Output Text
IniWrite, %ShowDoneIfDone%, %SettingsFileName%, Options, Show Done If Done
IniWrite, %ExitConfirmed%, %SettingsFileName%, Options, Disable Exit Confirmation
IniWrite, %AlwaysOnTop%, %SettingsFileName%, Options, Always On Top
return


; Read the settings from the settings file.
ReadSettingsFile:
IniRead, TextColour, %SettingsFileName%, Options, Text colour
IniRead, BackColour, %SettingsFileName%, Options, Background colour
IniRead, CustomColours, %SettingsFileName%, Options, Custom colours
CustomColours := StrSplit(CustomColours, ",", " `t")
IniRead, FontSize, %SettingsFileName%, Options, Font size
/*
IniRead, FontType, %SettingsFileName%, Options, Font type
*/
IniRead, MaximumRowsText, %SettingsFileName%, Options, Text mode maximum rows
IniRead, MaximumRowsIcons, %SettingsFileName%, Options, Icon mode maximum rows
IniRead, DecimalPlaces, %SettingsFileName%, Options, Decimal places
IniRead, RefreshRate, %SettingsFileName%, Options, Refresh rate (ms)
IniRead, RefreshRateFileOutput, %SettingsFileName%, Options, Refresh rate file output (sec)
RefreshRateFileOutput := Round(RefreshRateFileOutput * 1000)
IniRead, Transparency, %SettingsFileName%, Options, Transparency
Transparency := 255 - Round(Transparency * 2.55)
IniRead, TextSmoothing, %SettingsFileName%, Options, Text Smoothing
IniRead, OutputWindowBoldText, %SettingsFileName%, Options, Bold Output Text
IniRead, ShowDoneIfDone, %SettingsFileName%, Options, Show Done If Done
IniRead, ExitConfirmed, %SettingsFileName%, Options, Disable Exit Confirmation
IniRead, AlwaysOnTop, %SettingsFileName%, Options, Always On Top
gosub ValidateSettings
return


; Read the settings from the settings file of Lighnat0r's checklist.
ReadOldSettingsFile:
IniRead, TextColour, %SettingsFileNameOld%, Options, Text colour
IniRead, BackColour, %SettingsFileNameOld%, Options, Background colour
IniRead, MaximumRowsText, %SettingsFileNameOld%, Options, Text mode maximum rows
IniRead, MaximumRowsIcons, %SettingsFileNameOld%, Options, Icon mode maximum rows
IniRead, DecimalPlaces, %SettingsFileNameOld%, Options, Decimal places
IniRead, RefreshRateFileOutput, %SettingsFileNameOld%, Options, Refresh rate file output (sec)
RefreshRateFileOutput := Round(RefreshRateFileOutput * 1000)
IniRead, Transparency, %SettingsFileNameOld%, Options, Transparency
Transparency := 255 - Round(Transparency * 2.55)
IniRead, TextSmoothing, %SettingsFileNameOld%, Options, Text Smoothing
IniRead, OutputWindowBoldText, %SettingsFileNameOld%, Options, Bold Output Text
IniRead, ShowDoneIfDone, %SettingsFileNameOld%, Options, Show Done If Done
IniRead, ExitConfirmed, %SettingsFileNameOld%, Options, Disable Exit Confirmation
IniRead, AlwaysOnTop, %SettingsFileNameOld%, Options, Always On Top
gosub ValidateSettings
return


ValidateSettings:
if (!IsColor("0x" . TextColour))
	TextColour := DefaultTextColour
if (!IsColor("0x" . BackColour))
	BackColour := DefaultBackColour
if (!IsObject(CustomColours) OR CustomColours.Count() != 16 OR CustomColours.MinIndex() != 1 OR CustomColours.MaxIndex() != 16)
	CustomColours := DefaultCustomColours
if (CustomColours != DefaultCustomColours)
{
	for index, value in CustomColours
	{
		if (!IsColor(CustomColours[index]))
			CustomColours[index] := DefaultCustomColours[index]
	}
}
if (FontSize < 8 OR FontSize > 16)
	FontSize := DefaultFontSize
/*
if (FontType < 0)
	FontType := DefaultFontType
*/
if (MaximumRowsText < 4 OR MaximumRowsText > 65)
	MaximumRowsText := DefaultMaximumRowsText
if (MaximumRowsIcons < 3 OR MaximumRowsIcons > 30)
	MaximumRowsIcons := DefaultMaximumRowsIcons
if (DecimalPlaces < 0 OR DecimalPlaces > 5)
	DecimalPlaces := DefaultDecimalPlaces
if (RefreshRate < 100 OR RefreshRate > 10000)
	RefreshRate := DefaultRefreshRate
if (RefreshRateFileOutput < 0 OR RefreshRateFileOutput > 20000)
	RefreshRateFileOutput := DefaultRefreshRateFileOutput
if (Transparency < 0.0 OR Transparency > 255.0)
	Transparency := DefaultTransparency
if (!(TextSmoothing = 0 OR TextSmoothing = 1))
	TextSmoothing := DefaultTextSmoothing
if (!(OutputWindowBoldText = 0 OR OutputWindowBoldText = 1))
	OutputWindowBoldText := DefaultOutputWindowBoldText
if (!(ShowDoneIfDone = 0 OR ShowDoneIfDone = 1))
	ShowDoneIfDone := DefaultShowDoneIfDone
if (!(ExitConfirmed = 0 OR ExitConfirmed = 1))
	ExitConfirmed := DefaultExitConfirmed
if (!(AlwaysOnTop = 0 OR AlwaysOnTop = 1))
	AlwaysOnTop := DefaultAlwaysOnTop
return


IsColor(color)
{
	if color is NOT xdigit
		return 0
	if color is NOT integer
		return 0
	if (color < 0 OR color > 0xFFFFFF)
		return 0
	return 1
}


ErrorFilenameLength:
Gui, FilenameError:Add, Text, , The filename of the PPSSPP 100`% Checklist is too long: `n`nThe program can still function but settings cannot `nbe saved and file output is unavailable. `nDo you still want to continue`?
Gui, FilenameError:Add, Text, h0 w0 Y+4,
Gui, FilenameError:Add, Button, section default, Continue
Gui, FilenameError:Add, Button, ys, Abort
Gui, FilenameError:Show
Pause, On
return


FilenameErrorButtonContinue:
FilenameErrorGuiClose:
FilenameErrorGuiEscape:
Pause, Off
Gui, FilenameError:Destroy
return


FilenameErrorButtonAbort:
ExitConfirmed := 1
ExitApp


; ######################################################################################################
; ########################################### UPDATE CHECKER ###########################################
; ######################################################################################################

/*
Subheadings:

	UpdateCheck
	7ButtonYes
	7ButtonNo/7GuiClose/7GuiEscape
*/

/*
UpdateCheck:
; Avast stops the program from functioning correctly, presumably because it tries to connect to the internet for the
; update checker. So we will read the registry to see if Avast has been installed. The location of the registry key
; by which we determine if Avast is installed depends on whether the OS is 64 or 32 bit. If it is 64 bit, the key
; can be in one of two locations (one for the 32 bit version of Avast and one for the 64 bit version). The 32 bit
; OS only has one possible location.
if (A_Is64bitOS)
{
	SetRegView 64
	RegRead, AvastInstalled, HKLM, Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
	if (ErrorLevel = 1)
		RegRead, AvastInstalled, HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
}
else
	RegRead, AvastInstalled, HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\Avast, DisplayName
; If there was no problem reading the registry the registry key exists, so Avast is installed. In this case
; let the user know the update checker has been disabled and skip it.
if (ErrorLevel = 0)
{
	OutputDebug %AvastInstalled% detected
	MsgBox, 0x2030, , Avast has been detected on your computer.`n`nThe auto-updater has been disabled.
	return
}
; Delete Updater.cmd to make sure the most recent version is always used.
FileDelete, %ScriptNameNoExt% Updater.cmd
UrlDownloadToFile, %VersionURL%, %ScriptNameNoExt% Version.dll
if (ErrorLevel = 0) ; Check if the version file was downloaded successfully.
{
	; Check if a newer version is released. If this is the case, show the update screen with the current
	; version (stored internally), a description and the version it will update to (both read from the version file).
	IniRead, NewestVersion, %ScriptNameNoExt% Version.dll, Version, %ProgramName%
	if (NewestVersion != "Error" AND NewestVersion > CurrentVersion)
	{
		UpdaterActive := 1
		Gui, 7: -MinimizeBox -MaximizeBox +LastFound
		Gui, 7:Font, q3
		Gui, 7:Add, Text, , An update is available. Current version`: v%CurrentVersion%. `nNew version`: v%NewestVersion%. Would you like to update now`?
		IniRead, DescriptionText, %ScriptNameNoExt% Version.dll, %ProgramName% Files, Description
		if (DescriptionText != "Error" AND DescriptionText != "")
		{
			Gui, 7:Font, w700 q3 ; Bold
			Gui, 7:Add, Text, , Update description`:
			Gui, 7:Font, w400 q3 ; Normal
			Gui, 7:Add, Text, h0 w0 Y+4,
			StringSplit, DescriptionTextArray, DescriptionText, `|
			loop %DescriptionTextArray0%
				Gui, 7:Add, Text, Y+1, % DescriptionTextArray%A_Index%
		}
		Gui, 7:Add, Text, h0 w0 Y+4,
		Gui, 7:Add, Button, section default, Yes
		Gui, 7:Add, Button, ys, No
		Gui, 7:Show
		return
	}
}
; If the version file failed to download or there is no new version, delete the version file and continue running the program.
FileDelete, %ScriptNameNoExt% Version.dll
return


; If the user accepts, show a splash text that the new version is being downloaded.
7ButtonYes:
Gui, 7:Hide
SplashTextOn , 350 , , Downloading the new version. This might take some time...
; Download all the files from the file list defined earlier, from the locations specified in the version file.
loop
{
	if (!File%A_Index%)
		break
	File := File%A_Index%
	IniRead, FileLink, %ScriptNameNoExt% Version.dll, %ProgramName% Files, %File%
	UrlDownloadToFile, %FileLink%, %File%
}
; We don't need the version file anymore, so delete it.
FileDelete, %ScriptNameNoExt% Version.dll
; Once that's done, run the updater.cmd included in the executable of the running version. This is necessary because
; in order to update, the executable has to be replaced. Since that can't be done while the program is still running,
; it has to be done from a different process, in this case the updater.cmd, a Windows Command Script. From command-line,
; it will first close this program, then copy the new version of the executable over the old, then automatically start
; the new version. In all cases the version.dll file is deleted as to not clutter the computer. Since the updater.cmd
; is deleted every time the auto-updater checks for new updates, it will be deleted right after it has started the new version.
UpdateVar1 := """" . A_ScriptDir . "\" . ExecutableFile . """" ; Location of the newversion exe.
UpdateVar2 := """" . A_ScriptFullPath . """" ; Location of the old (currently running) exe which will be overwritten.
UpdateVar3 := DllCall("GetCurrentProcessId") ; Script PID so it can be closed.
FileInstall, FileInstall\Updater.cmd, %ScriptNameNoExt% Updater.cmd, 1
Run, %ScriptNameNoExt% Updater.cmd %UpdateVar1% %UpdateVar2% %UpdateVar3%, ,
sleep 5000 ; Give the updater some time to close this program.
ExitConfirmed := 1
exitapp


;If the user declines the update, delete the version file and continue running the program.
7ButtonNo:
7GuiClose:
7GuiEscape:
Gui, 7:Destroy
FileDelete, %ScriptNameNoExt% Version.dll
UpdaterActive := 0
return
*/

; ######################################################################################################
; ########################################### WELCOME WINDOW ###########################################
; ######################################################################################################

/*
Subheadings:

	WelcomeScreen
	ShowOutputFileLocation
	HideOutputFileLocation
	2ButtonClose/2GuiClose/2GuiEscape
	2GuiContextMenu
	WM_WELCOMEWINDOWPOSCHANGED()
	2ButtonConfirm
	SelectGameCode
	SetCurrentGameCode
	2ButtonSettings
	FillRequirementsArray
*/


; Create the welcome window. First the minimize and maximize buttons are removed, and LastFound is set so
; functions affecting the window later will automatically act on this one without having to specify.
; Next the background colour is set and then, dependent on the settings, the font options are set.
; If the window is even slightly transparent, the font gets maximum boldness, and if text smoothing
; is off or if the window is again even slightly transparent, text smoothing is turned off (having
; it turned on with a transparent background creates ugly borders). It proceeds to add the text and
; other controls to the window, some of which have somewhat specific placement settings, such as
; width or position relative to the previous control. Some empty text controls are also created to
; create some space between the controls above and below it. If any level of transparency is in play,
; the background window is made entirely transparent and some preparations are made for faking a
; semi-transparent background. After the gui is rendered, a second window is created which is locked
; to the first. It consists of just a background which is semi-transparent. (Within one window, it is
; possible to make either the background completely transparent, or the entire window, including controls,
; semi-transparent. This is the only decent solution I have found. It does have some issues (see readme)
; but nothing major.) The background window is set to be the owner of the real window, to avoid it being
; selectable which would push the background over the other window. Even if the background is completely
; transparent, the background window is still created, because otherwise clicks would fall through (this
; only happens if a specific colour is made transparent as is the case for the real window, it doesn't
; happen if the entire window is made completely transparent as is the case for the background window.)
WelcomeScreen:
Gui, 2: -MinimizeBox -MaximizeBox +LastFound
Gui, 2:Default
Gui, 2:Color, %BackColour%, %BackColour%
Gui, 2:Font, c%TextColour%
if (AlwaysOnTop = 1)
	Winset, AlwaysOnTop, On
if (Transparency < 255)
{
	Gui, 2:Font, w1000
	WelcomeWindowWidth := 350
}
else
	WelcomeWindowWidth := 300
if (Transparency < 255 OR TextSmoothing = 0)
	Gui, 2:Font, q3
Gui, 2:Add, Text, center w%WelcomeWindowWidth%, Welcome to the PPSSPP 100`% Checklist v%CurrentVersion%
Gui, 2:Add, Text, y+5 center w%WelcomeWindowWidth%, Original 100`% Checklist by Lighnat0r`nwith contributions by zoton2
Gui, 2:Add, Text, y+5 center w%WelcomeWindowWidth%, PPSSPP compatibility and improvements by NABN00B`nwith contributions by Parik
Gui, 2:Add, Text, w%WelcomeWindowWidth%, Load your game, then select the checklist to use.
if (Transparency < 255)
	Gui, 2:Add, Text, w100 section, Select the game:
else
	Gui, 2:Add, Text, w80 section, Select the game:
Gui, 2:Add, Text, ys h-6 w0,
CurrentLoopCode := "SelectGameCode"
gosub SupportedGamesList
Gui, 2:Add, Checkbox, vPercentageOnlyMode xs, Show percentage only
Gui, 2:Add, Text, ,
if (Transparency < 255)
	Gui, 2:Add, Text, w110 xs section, Select output type:
else
	Gui, 2:Add, Text, w90 xs section, Select output type:
Gui, 2:Add, Radio, ys vOutputTypeText gHideOutputFileLocation, Text
Gui, 2:Add, Radio, ys vOutputTypeIcons Checked gHideOutputFileLocation, Icons
Gui, 2:Add, Radio, ys vOutputTypeFile gShowOutputFileLocation, File
OutputFileString := "Output stored in """ . ScriptNameNoExt . " Output.txt"""
OutputFileStringLength := StrLen(OutputFileString)
OutputFileTextRows := Ceil(OutputFileStringLength * 6 / WelcomeWindowWidth) ; We need 6 pixels per character.
Gui, 2:Add, Text, w%WelcomeWindowWidth% r%OutputFileTextRows% xs vOutputFileText,
Gui, 2:Add, Button, xs section, Confirm
Gui, 2:Add, Button, ys, Close
Gui, 2:Add, Button, ys, Settings
if (Transparency < 255)
{
	WinSet, TransColor, %BackColour%
	WelcomeWindowID := WinExist()
	OnMessage(0x0047, "WM_WELCOMEWINDOWPOSCHANGED")
	Gui, 2: -Border
}
Gui, 2:Show,
if (Transparency < 255)
{
	WinGetPos, , , WelcomeWindowNoBorderWidth, WelcomeWindowNoBorderHeight
	Gui, 2: +Border
	Gui, 2:Show, Autosize
	WinGetPos, WelcomeWindowX, WelcomeWindowY, WelcomeWindowWidth, WelcomeWindowHeight
	BackgroundX := WelcomeWindowX + WelcomeWindowWidth - WelcomeWindowNoBorderWidth
	BackgroundY := WelcomeWindowY + WelcomeWindowHeight - WelcomeWindowNoBorderHeight
	Gui, 5: +LastFound
	Gui, 5:Color, %BackColour%, %BackColour%
	WinSet, Transparent, %Transparency%
	Gui, 5: -Caption
	Gui, 5:Show, x%BackgroundX% y%BackgroundY% w%WelcomeWindowNoBorderWidth% h%WelcomeWindowNoBorderHeight% NoActivate
	Gui, 2: +Owner5
}
return


ShowOutputFileLocation:
GuiControlGet, OutputFileTextContents, , OutputFileText
if (OutputFileTextContents != OutputFileString)
	GuiControl, , OutputFileText, %OutputFileString%
return


HideOutputFileLocation:
GuiControlGet, OutputFileTextContents, , OutputFileText
if (OutputFileTextContents != "")
	GuiControl, , OutputFileText,
return


; What happens if the user tries to close the window.
2ButtonClose:
2GuiClose:
2GuiEscape:
CurrentGUI := 2
exitapp
return


; Create a context menu if the user right clicks on the window.
2GuiContextMenu:
Menu, OutputRightClick, Add, Restart Script, RestartSequence
Menu, OutputRightClick, Add, Open Readme, OpenReadme
Menu, OutputRightClick, Add, Exit, 2GuiClose
Menu, OutputRightClick, Show
return


; This function is set to trigger as soon as the real window is moved and moves the
; background window with it.
WM_WELCOMEWINDOWPOSCHANGED()
{
	global
	Gui, 2: +LastFound
	WinGetPos, WelcomeWindowX, WelcomeWindowY,
	Gui, 5: +LastFound
	BackgroundX := WelcomeWindowX + (WelcomeWindowWidth - WelcomeWindowNoBorderWidth)
	BackgroundY := WelcomeWindowY + (WelcomeWindowHeight - WelcomeWindowNoBorderHeight)
	WinMove, BackgroundX, BackgroundY
}


; If the user presses the confirm button, first check if all the options have been
; selected correctly. If not, show an error message and restore the window. The
; program tries to restore the background window without checking if it exists, but
; this doesn't seem to cause any issues. If the options are selected correctly,
; configure the right options internally. Proceed to the output window after that.
2ButtonConfirm:
Gui, 5:Submit
Gui, 2:Submit
CurrentLoopCode := "SetCurrentGameCode"
gosub SupportedGamesList
if (!CurrentGame)
{
	MsgBox, 0x2040, , Please select a game.
	Gui, 5:Restore
	Gui, 2:Restore
	return
}
if (OutputTypeText = 1)
	OutputType := "Text"
else if (OutputTypeIcons = 1)
	OutputType := "Icons"
else if (OutputTypeFile = 1)
	OutputType := "File"
if (PercentageOnlyMode = 1)
	SpecialMode := "PercentageOnly"
else
	SpecialMode := ""
; Now that the options are selected, we can create the requirements array.
; Under the Initiliaze label we install the specified icons library, then build IconArray
; to associate a name to the icon indexes. The icon names are used in the requirement
; lists to identify each requirement in the list and each icon in the library.
gosub %CurrentGame%_Initialize
%CurrentGame%%SpecialMode%RequirementsArray := {}
CurrentLoopCode := "FillRequirementsArray"
gosub %CurrentGame%_%SpecialMode%Requirements
OutputStatus := "Starting"
if (OutputType = "File")
	goto FileOutput
else
	goto OutputWindow


; Code adding a control to the welcome screen for every game in the supported games list.
SelectGameCode:
gui, 2:Add, Radio, vSelectGame%GameNameNoSpace% Checked, %GameName%
return


; Code setting the current game name based on the option selected in the welcome window.
; For every game in the supported games list, it checks if the option was selected and
; sets the CurrentGame variable to it if so. If no option was selected, the CurrentGame
; variable will simply remain blank (which will generate an error in the code belonging
; to the confirm button.) If it would be possible to return to the welcome window from
; the output window it would be necessary to blank the CurrentGame variable to avoid
; missing this error.
SetCurrentGameCode:
if (SelectGame%GameNameNoSpace% = 1)
	CurrentGame := GameNameNoSpace
return


; If the settings button is pressed, hide the welcome window and start the subroutine
; which creates the settings window.
2ButtonSettings:
Gui, 2:Hide
Gui, 5:Hide
gosub CreateSettingsWindow
return


; Populate the requirements array.
FillRequirementsArray:
; Fill the array with all the requirements. Each name signifies an object created below
; which contains all the properties belonging to it. The name of the array
; is unique for each game/special mode even though currently only one of them
; can exist at a time. This way hotswitching can be added later without the
; the program breaking here. It might also avoid issues caused by multiple
; games using the same icon. The IconName is used instead of the Name because it does not
; contain any spaces which would can't be used in an object name.
%CurrentGame%%SpecialMode%RequirementsArray.Insert(IconName)
; Now create the object with its properties. Store the type and icon name,
; then loop to store all the addresses defined with the corresponding
; length and custom code flags. Again add the name of the game and the special
; mode to avoid issues.
%CurrentGame%%SpecialMode%%IconName% := {} ; Create the object
if (!Name)
	Name := "???" ; Default name
%CurrentGame%%SpecialMode%%IconName%.Insert("Name", Name)
if (!Type)
	Type := "Int" ; Default type
%CurrentGame%%SpecialMode%%IconName%.Insert("Type", Type)
%CurrentGame%%SpecialMode%%IconName%.Insert("TotalRequired", TotalRequired)
; Loop through all the defined addresses, adding them to the object if they are defined.
; Immediately after adding them, clear the address and its length and custom code flags
; in preparation of adding the next requirement once this subroutine is called again.
loop
{
	if (!Address%A_Index%)
		break
	%CurrentGame%%SpecialMode%%IconName%.Insert("Address"A_Index, Address%A_Index%)
	if (!Address%A_Index%Length)
		Address%A_Index%Length := 4 ; Default length
	%CurrentGame%%SpecialMode%%IconName%.Insert("AddressLength"A_Index, Address%A_Index%Length)
	if (Address%A_Index%CustomCode)
		%CurrentGame%%SpecialMode%%IconName%.Insert("AddressCustomCode"A_Index, Address%A_Index%CustomCode)
	Address%A_Index% := ""
	Address%A_Index%Length := ""
	Address%A_Index%CustomCode := ""
}
; Also reset all the other variables. Only the optional variables need to be reset,
; but resetting all variables makes sure they doesn't cause any issues.
Name := ""
Type := ""
IconName := ""
TotalRequired := ""
return


; ######################################################################################################
; ########################################## SETTINGS WINDOW ###########################################
; ######################################################################################################

/*
Subheadings:

	CreateSettingsWindow
	4ButtonSave
	4ButtonDiscard/4GuiClose/4GuiEscape
	4ButtonRestoreDefault
	4GuiContextMenu
	ChangeTextColour
	ChangeBackColour
	; ChangeFont
	; ChooseFont
	FontSize
	MaximumRowsText
	MaximumRowsIcons
	DecimalPlaces
	RefreshRate
	RefreshRateFileOutput
	Transparency
*/


CreateSettingsWindow:
SettingsTextWidth := 180
PreviewText := "Item 28/45"
Gui, 4: -MinimizeBox -MaximizeBox +LastFound
Gui, 4:Default
; Store the original values in case the settings window is discarded.
TextColourOriginal := TextColour
BackColourOriginal := BackColour
CustomColoursOriginal := CustomColours
FontSizeOriginal := FontSize
/*
FontTypeOriginal := FontType
*/
MaximumRowsTextOriginal := MaximumRowsText
MaximumRowsIconsOriginal := MaximumRowsIcons
DecimalPlacesOriginal := DecimalPlaces
RefreshRateOriginal := RefreshRate
RefreshRateFileOutputOriginal := RefreshRateFileOutput
TransparencyOriginal := Transparency
TextSmoothingOriginal := TextSmoothing
OutputWindowBoldTextOriginal := OutputWindowBoldText
ShowDoneIfDoneOriginal := ShowDoneIfDone
ExitConfirmedOriginal := ExitConfirmed
AlwaysOnTopOriginal := AlwaysOnTop
; Add the controls for changing text colour
Gui, 4:Add, Text, y+10 w%SettingsTextWidth% section, Text colour`:
Gui, 4:Add, Button, ys vTextColour gChangeTextColour w60, %TextColour%
Gui, 4:Add, Progress, ys w60 h23 c%TextColour% vTextColourBox, 100
; Add the controls for changing background colour
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Background colour`:
Gui, 4:Add, Button, ys vBackColour gChangeBackColour w60, %BackColour%
Gui, 4:Add, Progress, ys w60 h23 c%BackColour% vBackColourBox, 100
Gui, 4:Add, Text, ys w60 c%TextColour% vPreviewTextControl Center BackgroundTrans xp yp+5, %PreviewText%
/*
; Add the controls for changing font
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Font`:
Gui, 4:Add, Button, ys vFont gChangeFont w120, %FontSize% %FontType%
*/
; Add the controls for changing font size
Gui, 4:Add, Text, xs w%SettingsTextWidth% section vFontSizeDescription, Font size `(8`-16`)`:
Gui, 4:Add, Slider, ys vFontSize gFontSize Range8-16 w120 Tooltip Center Noticks , %FontSize%
Gui, 4:Add, Text, x+0 vFontSizeTextControl w12, %FontSize%
GuiControl, +Buddy2FontSizeTextControl, FontSize
; Add the controls for changing maximum rows text
Gui, 4:Add, Text, xs w%SettingsTextWidth% section vMaximumRowsTextDescription, Text mode maximum rows `(4`-65`)`:
Gui, 4:Add, Slider, ys vMaximumRowsText gMaximumRowsText Range4-65 w120 Tooltip Center Noticks , %MaximumRowsText%
Gui, 4:Add, Text, x+0 vMaximumRowsTextTextControl w12, %MaximumRowsText%
GuiControl, +Buddy2MaximumRowsTextTextControl, MaximumRowsText
; Add the controls for changing maximum rows icons
Gui, 4:Add, Text, xs w%SettingsTextWidth% section vMaximumRowsIconsDescription, Icon mode maximum rows `(3`-30`)`:
Gui, 4:Add, Slider, ys vMaximumRowsIcons gMaximumRowsIcons Range3-30 w120 Tooltip Center Noticks , %MaximumRowsIcons%
Gui, 4:Add, Text, x+0 vMaximumRowsIconsTextControl w12, %MaximumRowsIcons%
GuiControl, +Buddy2MaximumRowsIconsTextControl, MaximumRowsIcons
; Add the controls for changing decimal places
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Decimal places `(0`-5`)`:
Gui, 4:Add, Slider, ys vDecimalPlaces gDecimalPlaces Range0-5 w120 Tooltip Center Noticks , %DecimalPlaces%
Gui, 4:Add, Text, x+0 vDecimalPlacesTextControl w6, %DecimalPlaces%
GuiControl, +Buddy2DecimalPlacesTextControl, DecimalPlaces
; Add the controls for changing refresh rate.
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Refresh delay `(100`-10`,000 ms`)`:
Gui, 4:Add, Slider, ys vRefreshRate gRefreshRate Range100-10000 w120 Tooltip Center Noticks, %RefreshRate%
Gui, 4:Add, Text, x+0 vRefreshRateTextControl w30, %RefreshRate%
GuiControl, +Buddy2RefreshRateTextControl, RefreshRate
; Add the controls for changing refresh rate for file output.
RefreshRateFileOutput := Round(RefreshRateFileOutput / 1000)
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Additional file output refresh delay `(0`-20 sec`)`:
Gui, 4:Add, Slider, ys vRefreshRateFileOutput gRefreshRateFileOutput Range0-20 w120 Tooltip Center Noticks, %RefreshRateFileOutput%
Gui, 4:Add, Text, x+0 vRefreshRateFileOutputTextControl w30, %RefreshRateFileOutput%
GuiControl, +Buddy2RefreshRateFileOutputTextControl, RefreshRateFileOutput
; Add the controls for changing transparency
Transparency := 100-Round(Transparency / 2.55)
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Transparency `(0`-100`%`)`:
Gui, 4:Add, Slider, ys vTransparency gTransparency Range0-100 w120 Tooltip Center Noticks , %Transparency%
Gui, 4:Add, Text, x+0 vTransparencyTextControl w28, %Transparency%`%
GuiControl, +Buddy2TransparencyTextControl, Transparency
; Add the controls for changing text smoothing
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Smooth Text`:
Gui, 4:Add, Checkbox, vTextSmoothing ys Checked%TextSmoothing%,
; Add the controls for changing output window bold text
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Bold text`:
Gui, 4:Add, Checkbox, vOutputWindowBoldText ys Checked%OutputWindowBoldText%,
; Add the controls for changing show done if done
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Show "DONE" when an item is done`:
Gui, 4:Add, Checkbox, vShowDoneIfDone ys Checked%ShowDoneIfDone%,
; Add the controls for changing exit confirmed
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Skip exit confirmation`:
Gui, 4:Add, Checkbox, vExitConfirmed ys Checked%ExitConfirmed%,
; Add the controls for changing always on top
Gui, 4:Add, Text, xs w%SettingsTextWidth% section, Show checklist always on top`:
Gui, 4:Add, Checkbox, vAlwaysOnTop ys Checked%AlwaysOnTop%,
; Add the buttons for saving, discarding and restoring default settings.
; After all these controls are added, show the window.
Gui, 4:Add, Text, xs,
Gui, 4:Add, Button, xs section, Save
Gui, 4:Add, Button, ys, Discard
Gui, 4:Add, Button, ys, Restore Default
Gui, 4:Show
return


4ButtonSave:
Gui, 4:Submit
; Since everything with the same colour as the background is made transparent
; with transparency on, 'protect' some standard colours.
if (Backcolour = "000000" AND Transparency < 255)
	BackColour := "010101"
if (Backcolour = "FFFFFF" AND Transparency < 255)
	BackColour := "FEFEFE"
if (Backcolour = "F0F0F0" AND Transparency < 255)
	BackColour := "F1F1F1"
/*
if (BackColour = TextColour AND Transparency < 255)
{
	BackColour += 1
	BackColour2 := SubStr("00000" . BackColour, -5)
}
*/
; Translate transparency to something the program understands.
Transparency := 255 - Round(Transparency * 2.55)
; Translate refresh rate from sec to ms for the program.
RefreshRateFileOutput := Round(RefreshRateFileOutput * 1000)
; Destroy the settings screen and the welcome screen, save the new settings
; to a file and set the right variables. Then redraw the welcome screen.
Gui, 4:Destroy
Gui, 2:Destroy
Gui, 5:Destroy
gosub WriteSettingsFile
gosub SetVariablesDependentOnSettings
goto WelcomeScreen
return


; If the settings menu is canceled, undo all the changes made and restore the
; variables to what was saved at the start of initialising the settings window.
; Also destroy the settings window. Since no settings are changed, there is no
; need to destroy and redraw the welcome screen so we just restore it.
4ButtonDiscard:
4GuiClose:
4GuiEscape:
Gui, 4:Destroy
TextColour := TextColourOriginal
BackColour := BackColourOriginal
CustomColours := CustomColoursOriginal
FontSize := FontSizeOriginal
/*
FontType := FontTypeOriginal
*/
MaximumRowsText := MaximumRowsTextOriginal
MaximumRowsIcons := MaximumRowsIconsOriginal
DecimalPlaces := DecimalPlacesOriginal
RefreshRate := RefreshRateOriginal
RefreshRateFileOutput := RefreshRateFileOutputOriginal
Transparency := TransparencyOriginal
TextSmoothing := TextSmoothingOriginal
OutputWindowBoldText := OutputWindowBoldTextOriginal
ShowDoneIfDone := ShowDoneIfDoneOriginal
ExitConfirmed := ExitConfirmedOriginal
AlwaysOnTop := AlwaysOnTopOriginal
Gui, 5:Restore
Gui, 2:Restore
return


; Restore all the settings to default as defined in the DefaultSettings subroutine.
4ButtonRestoreDefault:
gosub DefaultSettings
GuiControl, , TextColour, %TextColour%
GuiControl, +c%TextColour%, TextColourBox
GuiControl, , BackColour, %BackColour%
GuiControl, +c%BackColour%, BackColourBox
GuiControl, 4: +c%TextColour%, PreviewTextControl
GuiControl, 4:, PreviewTextControl, %PreviewText%
/*
GuiControl, , Font, %FontSize% %FontType%
*/
GuiControl, , FontSize, %FontSize%
GuiControl, , FontSizeTextControl, %FontSize%
GuiControl, , MaximumRowsText, %MaximumRowsText%
GuiControl, , MaximumRowsTextTextControl, %MaximumRowsText%
GuiControl, , MaximumRowsIcons, %MaximumRowsIcons%
GuiControl, , MaximumRowsIconsTextControl, %MaximumRowsIcons%
GuiControl, , DecimalPlaces, %DecimalPlaces%
GuiControl, , DecimalPlacesTextControl, %DecimalPlaces%
GuiControl, , RefreshRate, %RefreshRate%
GuiControl, , RefreshRateTextControl, %RefreshRate%
RefreshRateFileOutput := Round(RefreshRateFileOutput / 1000)
GuiControl, , RefreshRateFileOutput, %RefreshRateFileOutput%
GuiControl, , RefreshRateFileOutputTextControl, %RefreshRateFileOutput%
Transparency := 100 - Round(Transparency / 2.55)
GuiControl, , Transparency, %Transparency%
GuiControl, , TransparencyTextControl, %Transparency%`%
GuiControl, , TextSmoothing, %TextSmoothing%
GuiControl, , OutputWindowBoldText, %OutputWindowBoldText%
GuiControl, , ShowDoneIfDone, %ShowDoneIfDone%
GuiControl, , ExitConfirmed, %ExitConfirmed%
GuiControl, , AlwaysOnTop, %AlwaysOnTop%
return


; Add a right click context menu.
4GuiContextMenu:
Menu, OutputRightClick, Add, Restart Script, RestartSequence
Menu, OutputRightClick, Add, Open Readme, OpenReadme
Menu, OutputRightClick, Add, Exit, 4GuiClose
Menu, OutputRightClick, Show
return


; Call the function which will initialise the colour dialog for text colour selection.
ChangeTextColour:
GuiHandle := WinExist()
TextColourNew := ChooseColor("0x" . TextColour, CustomColours, GuiHandle)
if (TextColourNew != "Error")
{
	TextColour := TextColourNew
	GuiControl, , TextColour, %TextColour%
	GuiControl, +c%TextColour%, TextColourBox
	GuiControl, 4: +c%TextColour%, PreviewTextControl
	GuiControl, 4:, PreviewTextControl, %PreviewText%
}
return


; Call the function which will initialise the colour dialog for background colour selection.
ChangeBackColour:
GuiHandle := WinExist()
BackColourNew := ChooseColor("0x" . BackColour, CustomColours, GuiHandle)
if (BackColourNew != "Error")
{
	BackColour := BackColourNew
	GuiControl, , BackColour, %BackColour%
	GuiControl, +c%BackColour%, BackColourBox
	GuiControl, 4:, PreviewTextControl, %PreviewText%
}
return


/*
; Call the subroutine which will initialise the font dialog.
ChangeFont:
gosub ChooseFont
return

; Initialise the font dialog, which requires a structure to be set up but
; is otherwise mostly a built-in function.
ChooseFont:
if (FontStructureExists != 1)
{
	VarSetCapacity(FontStructure, 0x60, 0)
	FontStructureExists := 1
}
GuiHandle := WinExist()
VarSetCapacity(FontDialogStructure, 0x3C, 0)
	NumPut(0x3C, FontDialogStructure, 0x0, "UInt")
	NumPut(GuiHandle, FontDialogStructure, 0x4) ; Will make the font dialog owned by the gui window
;	0x8 is unused
	NumPut(&FontStructure, FontDialogStructure, 0xC) ; Input/Output structure containing the font attributes
;	0x10 is the output for the font size
;	0x14 contains flags to set for creating the font dialog
;	0x18 contains a RGB macro if that flag is set in 0x14
;	0x1C is lCustData, not sure what this does
;	0x20 is a handle to some thing that handles messages if that flag is set in 0x14
;	0x24 is the name of the custom template for the font dialog in 0x28
; 	0x28 is the handle to the custom template if that flag is set in 0x14
;	0x2C is the input/output for a font style combo box if that flag is set in 0x14
;	0x30 is the output for the font type (e.g. bold, italic, etc)
;	0x34 is the minimum font size if that flag is set in 0x14
;	0x38 is the maximum font size if that flag is set in 0x14
ChooseFontErrorLevel := DllCall("Comdlg32\ChooseFont", "Ptr", &FontDialogStructure)
if (ChooseFontErrorLevel != 0)
{
	FontSize := Round(NumGet(FontDialogStructure, 0x10, "Int") / 10)
	FontType := NumGet(FontDialogStructure, 0x30, "Int")
	GuiControl, , Font, %FontSize% %FontType%
	GuiControl, , FontSize, %FontSize%
	GuiControl, , FontSizeTextControl, %FontSize%
}
return
*/


; Update the text next to the font size slider.
FontSize:
GuiControl, , FontSizeTextControl, %FontSize%
/*
GuiControl, , Font, %FontSize% %FontType%
*/
return


; Update the text next to the maximum text rows slider.
MaximumRowsText:
GuiControl, , MaximumRowsTextTextControl, %MaximumRowsText%
return


; Update the text next to the maximum icons rows slider.
MaximumRowsIcons:
GuiControl, , MaximumRowsIconsTextControl, %MaximumRowsIcons%
return


; Update the text next to the decimal places slider.
DecimalPlaces:
GuiControl, , DecimalPlacesTextControl, %DecimalPlaces%
return


; Update the text next to the refresh rate slider.
RefreshRate:
GuiControl, , RefreshRateTextControl, %RefreshRate%
return


; Update the text next to the refresh rate for file output slider.
RefreshRateFileOutput:
GuiControl, , RefreshRateFileOutputTextControl, %RefreshRateFileOutput%
return


; Update the text next to the transparency slider.
Transparency:
GuiControl, , TransparencyTextControl, %Transparency%`%
return


; ######################################################################################################
; ########################################### OUTPUT WINDOW ############################################
; ######################################################################################################

/*
Subheadings:

	OutputWindow
	GuiClose/GuiEscape
	GuiContextMenu
	WM_OUTPUTWINDOWPOSCHANGED()
	MoveWindow
	WM_LBUTTONDOWN(wParam, lParam)
	ButtonChangeOutputType
*/


OutputWindow:
Gui, 1: -MinimizeBox -MaximizeBox +LastFound
Gui, 1:Default
Gui, 1:Color, %BackColour%, %BackColour%
Gui, 1:Font, c%TextColour%
if (AlwaysOnTop = 1)
	WinSet, AlwaysOnTop, On
if (Transparency < 255 OR OutputWindowBoldText = 1)
	Gui, 1:Font, w1000
if (Transparency < 255 OR TextSmoothing = 0)
	Gui, 1:Font, q3
Gui, 1:Add, Button, , Change Output Type
Gui, 1:Add, Text, ys yp+5 w200 vOutputStatusTextControl, %OutputStatus%
Gui, 1:Font, s%FontSize%
; Changing the font after disabling text smoothing seems to enable it again. Since we don't want to scale the status text,
; text smoothing needs to be disabled again.
if (Transparency < 255 OR TextSmoothing = 0)
	Gui, 1:Font, q3
ListViewNumber := 1
RowAmount := 0
MaximumRows := MaximumRows%OutputType%
MaxValueLengthInPixels%ListViewNumber% := 0
if (OutputType = "Text")
	Gui, 1:Add, ListView, xs vRequirementsListView%ListViewNumber% gMoveWindow w%TextListViewWidth% Count20 -Multi -E0x200 section -Hdr, Name|Value|Required
else if (OutputType = "Icons")
{
	Gui, 1:Add, ListView, xs vRequirementsListView%ListViewNumber% gMoveWindow w%IconListViewWidth% Count15 -Multi -E0x200 section +Tile -LV0x20 +LV0x1 +0x2000 -0x8, Value
	ImageListID := IL_Create(20, 1, 1)
	LV_SetImageList(ImageListID, 0) ; 0 specifies large icons
}
else
{
	MsgBox, 0x2010, , Error`: Unknown output type.`n`nThe program will now restart.
	goto RestartSequence
}
; For each requirement in the requirements array, add it to the list view.
; At the start of every requirement, check if the list view exceeds the maximum
; length and create a new one in necessary.
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	Name := %CurrentGame%%SpecialMode%%IconName%.Name
	Type := %CurrentGame%%SpecialMode%%IconName%.Type
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	RowAmount += 1
	if (RowAmount > MaximumRows)
	{
		RowAmount := 1
		TotalRows := LV_GetCount()
		; For icons mode: each icon is 32x32 pixels with 4 pixels vertical padding between icons.
		; For text mode: each text has a height of 11 pixels with 4 pixels vertical padding at the top, 2 pixels at the bottom.
		ListViewHeight := TotalRows * ((OutputType = "Text") ? 17 * FontSize / 8 : 36 * FontSize / 8)
		GuiControl, Move, RequirementsListView%ListViewNumber%, h%ListViewHeight%
		; Update the column width and then update the list view width based on the column width.
		; The reason the column width needs to be updated is because of the variable length of
		; the requirement name, so this is only necessary in text mode (which is good because the
		; code wouldn't work for icons since it doesn't take the icon size into account).
		if (OutputType = "Text")
		{
			LV_ModifyCol() ; Set the width for the columns
			; We want 24 padding with the current layout of the listview. This padding is the area between the
			; list views but also the padding between the columns.
			ListViewTargetWidth := 24
			if (FloatInListView%ListViewNumber% = 1)
				ListViewTargetWidth += Round(CharacterWidth * DecimalPlaces + 1 * FontSize / 8)
			loop % LV_GetCount("Column")
			{
				SendMessage, 4125, A_Index - 1, 0, SysListView32%ListViewNumber% ; 4125 is LVM_GETCOLUMNWIDTH.
				ListViewTargetWidth += %ErrorLevel%
			}
			GuiControl, Move, RequirementsListView%ListViewNumber%, w%ListViewTargetWidth%
		}
		; We need to determine the X for the new list view manually, since we potentially changed
		; its size. The gui add function doesn't keep track of that by itself so it would put the
		; new listview based on the old width and the two list views would overlap or have too much padding.
		ControlGetPos, PreviousListViewX, , PreviousListViewWidth, , SysListView32%ListViewNumber%, , ,
		NewX := PreviousListViewX + PreviousListViewWidth
		ListViewNumber += 1
		MaxValueLengthInPixels%ListViewNumber% := 0
		if (OutputType = "Text")
		{
			Gui, 1:Add, ListView, vRequirementsListView%ListViewNumber% gMoveWindow w%TextListViewWidth% Count20 -Multi -E0x200 x%NewX% ys -Hdr, Name|Value|Required
		}
		else if (OutputType = "Icons")
		{
			Gui, 1:Add, ListView, vRequirementsListView%ListViewNumber% gMoveWindow w%IconListViewWidth% Count15 -Multi -E0x200 x%NewX% ys +Tile -LV0x20 +LV0x1 +0x2000 -0x8, Value
			LV_SetImageList(ImageListID, 0) ; 0 specifies large icons
		}
	}
	if (OutputType = "Text")
	{
		; Create the entry in the listview. Check if TotalRequired is defined, if not leave it out.
		LV_Add("", Name, 0, ((TotalRequired != "") ? ("`/"TotalRequired) : "" ))
		if (Type = "Float" OR Type = "UFloat" OR Type = "Double")
			FloatInListView%ListViewNumber% := 1
	}
	else if (OutputType = "Icons")
	{
		IconNumber := IconArray[IconName]
		IconIndex := IL_Add(ImageListID, ImageFilename, IconNumber)
		; Create the entry in the listview. Check if TotalRequired is defined, if not leave it out.
		LV_Add("Icon" . IconIndex, ((TotalRequired != "") ? ("0`/"TotalRequired) : 0 ))
		if (Type = "Float" OR Type = "UFloat" OR Type = "Double")
			GuiControl, Move, RequirementsListView%ListViewNumber%, w%IconListViewWidthWithFloat%
	}
}
TotalRows := LV_GetCount()
if (Transparency < 255)
{
	WinSet, TransColor, %BackColour%
	OutputWindowID := WinExist()
	OnMessage(0x0047, "WM_OUTPUTWINDOWPOSCHANGED")
}
else
{
	Gui, 1: -Caption
	OnMessage(0x201, "WM_LBUTTONDOWN")
}
if (OutputType = "Text")
{
	LV_ModifyCol() ; Set the width for the columns
	; We want 24 padding with the current layout of the listview. This padding is the area between the
	; list views but also the padding between the columns.
	ListViewTargetWidth := 24
	if (FloatInListView%ListViewNumber% = 1)
		ListViewTargetWidth += Round(CharacterWidth * DecimalPlaces + 1 * FontSize / 8)
	loop % LV_GetCount("Column")
	{
		SendMessage, 4125, A_Index - 1, 0, SysListView32%ListViewNumber% ; 4125 is LVM_GETCOLUMNWIDTH.
		ListViewTargetWidth += %ErrorLevel%
	}
	GuiControl, Move, RequirementsListView%ListViewNumber%, w%ListViewTargetWidth%
}
; For text mode: each text has a height of 11 pixels with 4 pixels vertical padding at the top, 2 pixels at the bottom, for a total of 17.
; For icons mode: each icon is 32x32 pixels with 4 pixels vertical padding between icons, for a total of 36.
ListViewHeight := TotalRows * ((OutputType = "Text") ? 17 * FontSize / 8 : 36 * FontSize / 8)
Guicontrol, Move, RequirementsListView%ListViewNumber%, h%ListViewHeight%
; Set the height of the window in pixels. We can describe the window in three parts:
; From the top of the window (so including the button) to the list view, which is 35 pixels.
; The height of the list view (the first list view is always the longest so use that one).
; Padding at the bottom, which can be chosen as whatever. We will use 5 here.
ControlGetPos, , , , RequirementsListViewHeight, SysListView321, , ,
GuiHeight := 35 + RequirementsListViewHeight + 5
; Set the width of the window in pixels.
ControlGetPos, RequirementsListViewX, , RequirementsListViewWidth, , SysListView32%ListViewNumber%, , ,
GuiWidth := RequirementsListViewX + RequirementsListViewWidth
; The calculated width is not enough for output with only one or two columns.
; In this case we base the gui width on the combined width of the button and text.
ControlGetPos, , , Button1Width, , Button1
ControlGetPos, , , OutputStatusTextControlWidth, , Static1
GuiTopRowWidth := Button1Width + OutputStatusTextControlWidth
if (GuiWidth < GuiTopRowWidth)
	GuiWidth := GuiTopRowWidth
; Check if this is the first time the window is shown or if it is redrawn after changing the output type.
; If it is being redrawn, use the saved position of the original window to draw it at the same position.
if (OutputChanged = 1)
	Gui, 1:Show, h%GuiHeight% x%OutputWindowX% y%OutputWindowY% w%GuiWidth%
else
	Gui, 1:Show, h%GuiHeight% w%GuiWidth%
; If any level of transparency is in play, the background window is made entirely transparent and some
; preparations are made for faking a semi-transparent background. After the gui is rendered, a second
; window is created which is locked to the first. It consists of just a background which is semi-
; transparent. (Within one window, it is possible to make either the background completely transparent,
; or the entire window, including controls, semi-transparent. This is the only decent solution I have
; found. It does have some issues (see readme) but nothing major.) The background window is set to be
; the owner of the real window, to avoid it being selectable which would push the background over the
; other window. Even if the background is completely transparent, the background window is still created,
; because otherwise clicks would fall through (this only happens if a specific colour is made transparent
; as is the case for the real window, it doesn't happen if the entire window is made completely transparent
; as is the case for the background window.)
if (Transparency < 255)
{
	WinGetPos, , , OutputWindowNoCaptionWidth, OutputWindowNoCaptionHeight
	Gui, 1:Show, Autosize
	WinGetPos, OutputWindowX, OutputWindowY, OutputWindowWidth, OutputWindowHeight
	BackgroundX := OutputWindowX + OutputWindowWidth - OutputWindowNoCaptionWidth
	BackgroundY := OutputWindowY + OutputWindowHeight - OutputWindowNoCaptionHeight
	Gui, 6: +LastFound
	Gui, 6:Color, %BackColour%, %BackColour%
	Winset, Transparent, %Transparency%
	Gui, 6: -Caption
	Gui, 6:Show, x%BackgroundX% y%BackgroundY% w%OutputWindowNoCaptionWidth% h%OutputWindowNoCaptionHeight% NoActivate
	Gui, 1: +Owner6
}
; Proceed to the MainScript, which is where the output is updated. Since we don't want to start the
; MainScript after changing the output (since it will be running already), we check for that. If the
; MainScript would be launched every time, we would quickly reach the maximum number of simultaneous
; threads causing the whole program to become unresponsive. Not to mention the memory leaking from having
; a lot of threads running.
if (OutputChanged != 1)
	goto MainScript
else
	exit


GuiClose:
GuiEscape:
CurrentGUI := 1
exitapp
return


; The following items are added to the right click menu.
GuiContextMenu:
Menu, OutputRightClick, Add, Restart Script, RestartSequence
Menu, OutputRightClick, Add, Open Readme, OpenReadme
Menu, OutputRightClick, Add, Exit, GuiClose
Menu, OutputRightClick, Show
return


; This function is triggered if the output window is moved, in order to move the 'fake' semi-transparent background with it.
WM_OUTPUTWINDOWPOSCHANGED()
{
	global
	Gui, 1: +LastFound
	WinGetPos, OutputWindowX, OutputWindowY,
	Gui, 6: +LastFound
	BackgroundX := OutputWindowX + (OutputWindowWidth - OutputWindowNoCaptionWidth)
	BackgroundY := OutputWindowY + (OutputWindowHeight - OutputWindowNoCaptionHeight)
	WinMove, BackgroundX, BackgroundY
}


; When the user clicks on any of the controls and moves the mouse, this will drag the window with it.
MoveWindow: ; For clicking on controls
if (Transparency = 255)
	PostMessage, 0xA1, 2, , , A ; Drag window on click
return


; When the user clicks in the window (but not on the controls) and moves the mouse, this will drag the window with it.
WM_LBUTTONDOWN(wParam, lParam) ; For clicking anywhere else in the window
{
	PostMessage, 0xA1, 2, , , A ; Drag window on click
}


; Pressing the "Change output type" button will alternate the output between text and icons.
; To accomplish this, it changes the OutputType and then destroys and recreates the output window.
; The position of the window is also saved to be able to draw the recreated output window at the
; same position. Since the image list is potentially shared between multiple list views, it won't
; be destroyed automatically so this is done explicitly.
ButtonChangeOutputType:
if (OutputType = "Text")
	OutputType := "Icons"
else if (OutputType = "Icons")
	OutputType := "Text"
WinGetPos, OutputWindowX, OutputWindowY,
Gui, 1:Destroy
Gui, 6:Destroy
IL_Destroy(ImageListID)
OutputChanged := 1
OutputChangedDup := 1
goto OutputWindow
return


; ######################################################################################################
; ############################################ FILE OUTPUT #############################################
; ######################################################################################################

/*
Subheadings:

	FileOutput
*/


FileOutput:
/*
MaximumRows := MaximumRows%OutputType% ; Not supported for now.
*/
FileOutputName := ScriptNameNoExt A_Space "Output.txt"
FileOutputNameTemp := FileOutputName ".temp" ; Used to reduce the downtime when updating the file as far as possible.
if (FileExist(FileOutputName))
	FileDelete, %FileOutputName%
FormatTime, CurrentTime, , HH:mm
FileAppend, %CurrentTime% %OutputStatus%`n, %FileOutputName%
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	Name := %CurrentGame%%SpecialMode%%IconName%.Name
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	; Create the entry in the listview. Check if TotalRequired is defined, if not leave it out.
	TextEntry := Name A_Space "0" ((TotalRequired != "") ? ("`/"TotalRequired) : "" ) "`n"
	FileAppend, %TextEntry%, %FileOutputName%
}
goto MainScript


; ######################################################################################################
; ########################################### UPDATE OUTPUT ############################################
; ######################################################################################################

/*
Subheadings:

	MainScript
	UpdateOutput
	ResetOutput
	UpdateOutputFile
	ResetOutputFile
	UpdateOutputStatus(newStatus)
*/


MainScript:
; Check if script is being run with 64 bit AHK
if (A_PtrSize != 8)
{
	MsgBox, 0x2010, , The PPSSPP 100`% Checklist must be run with the 64 bit AHK executable.`n`nThe program cannot continue operating.
	ExitConfirmed := 1
	ExitApp
}
; Wait until the game window is started.
UpdateOutputStatus("Waiting")
WinWait, ahk_class %EmulatorWindowClass%
; Initialise the process as a _ClassMemory object.
; In some cases _ClassMemory.setSeDebugPrivilege() may be required.
UpdateOutputStatus("Detecting")
_ClassMemory.setSeDebugPrivilege()
EmulatorMemory := new _ClassMemory("ahk_class" EmulatorWindowClass, "", EmulatorPID)
; Check if the parameter is an existing _ClassMemory object. Stop if it's not.
if (!IsObject(EmulatorMemory) OR EmulatorMemory.__class != "_ClassMemory")
{
	; Try to restart the program with admin privileges to see if that fixes the problem.
	if (!A_IsAdmin)
	{
		MsgBox, 0x2030, , Error accessing PPSSPP's process. `n`nThe program will now try to restart with admin privileges.
		Run, *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
		ExitConfirmed := 1
		ExitApp
	}
	; If the initialisation failed, the program cannot function properly so it will restart itself.
	else if (EmulatorPID = 0)
	{
		Error := GetLastErrorMessage()
		MsgBox, 0x2010, , Error accessing PPSSPP's process.`n`n%EmulatorWindowClass% is not found.`nThe program will now restart.`n%Error%
	}
	else if (EmulatorPID = "")
	{
		Error := GetLastErrorMessage()
		MsgBox, 0x2010, , Error accessing PPSSPP's process.`n`nOpenProcess failed.`nThe program will now restart.`n%Error%
	}
	goto RestartSequence
}
; Check which version of PPSSPP is used and which offsets to use for memory reading.
; Restart the script if the script can't detect the exe version.
while (EmulatorVersion = "Unknown")
{
	EmulatorBaseOffset := PPSSPP_VersionCheck(EmulatorMemory, EmulatorVersion, GameDataAddress)
	EmulatorVersionStatus := "PPSSPP v" . EmulatorVersion
	if (OutputStatus != EmulatorVersionStatus)
		UpdateOutputStatus(EmulatorVersionStatus)
	if (EmulatorVersion = "Unknown")
		sleep %RefreshRate%
}
/*
; This if-block is replaced by the while loop above.
if (EmulatorBaseOffset = "Error")
{
	Error := GetLastErrorMessage()
	MsgBox, 0x2010, , Error`: The script could not determine the version of PPSSPP's executable.`n`nThe program will now restart.`n%Error%
	goto RestartSequence
}
*/
; Reset all the values of the requirements to be sure to start with a clean slate.
; (Why is this necessary?)
ListViewNumber := 1
RowNumber := 0
gosub ResetOutput
; This While-loop will remain active as long as a detected PPSSPP version is running.
; The code in it handles game version control and updates the output.
; The loop checks if the output type is changed because it needs to realize that in order to keep updating the output.
while (EmulatorMemory.read(EmulatorMemory.BaseAddress))
{
	gosub %CurrentGame%_VersionCheck
	if (OutputStatus != GameVersion)
	{
		if (OutputStatus != EmulatorVersionStatus && GameVersion = "unknown game")
			UpdateOutputStatus(EmulatorVersionStatus)
		else if (GameVersion != "unknown game")
			UpdateOutputStatus(GameVersion)
	}
	gosub %CurrentGame%_UpdateVars
	if (OutputType = "File")
		gosub UpdateOutputFile
	else
	{
		ListViewNumber := 1
		Gui, 1:ListView, RequirementsListView%ListViewNumber%
		RowNumber := 0
		gosub UpdateOutput
	}
	if (OutputChangedDup = 1)
	{
		OutputChangedDup := 0
		break
	}
	sleep %RefreshRate%
}
; If the while-loop breaks (meaning the game is no longer running), reset the
; output for each requirement. After that return to the start of the 'main script'
; where the program will once again wait until the game is started.
UpdateOutputStatus("Restarting")
if (OutputType = "File")
	gosub ResetOutputFile
else
{
	ListViewNumber := 1
	Gui, 1:ListView, RequirementsListView%ListViewNumber%
	RowNumber := 0
	gosub ResetOutput
}
gosub ResetVersionControlVars
goto MainScript


; Code which updates the output.
UpdateOutput:
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	Type := %CurrentGame%%SpecialMode%%IconName%.Type
	; The decimal places setting is enforced
	; (Why is this necessary?)
	SetFormat, Float, 0.%DecimalPlaces%
	/*
	sleep 100
	*/
	; The current value is reset to stop information from carrying over from the previous requirement.
	CurrentValue := 0
	; Then the row (and listview if required) which will be updated is selected.
	RowNumber += 1
	if (RowNumber > MaximumRows)
	{
		RowNumber := 1
		ListViewNumber += 1
		Gui, 1:ListView, RequirementsListView%ListViewNumber%
	}
	; Loop to read all the memory addresses belonging to the current requirement.
	; Get the address, length and customcode flags from the requirements array.
	; If type is set, the read value can be converted to a float and custom code
	; located in the requirement list can be executed. At the end of the loop,
	; The variable 'CurrentValue' contains the finalized value of the requirement.
	loop
	{
		ReadAddress := %CurrentGame%%SpecialMode%%IconName%["Address"A_Index]
		if (!ReadAddress)
			break
		ReadLength := %CurrentGame%%SpecialMode%%IconName%["AddressLength"A_Index]
		MemoryValue := %CurrentGame%_ReadMemory(ReadAddress, Type, ReadLength)
		if (%CurrentGame%%SpecialMode%%IconName%["AddressCustomCode"A_Index] = 1)
			gosub %CurrentGame%_%IconName%_Address%A_Index%CustomCode
		CurrentValue += %MemoryValue%
	}
	; Only update the output if the value found in this cycle is not the same as
	; the value found in the last cycle.
	if (CurrentValue != %IconName%ValueOld)
	{
		/*
		; Test to remove each item once it's done.
		; Issues atm:
		; No way to re-add items when reloading a save/starting a new game.
		; Items after a deleted entry are no longer updated.
		if (CurrentValue >= TotalRequired AND TotalRequired != "")
		{
			LV_Delete(RowNumber)
			RequirementsArrayClone := %CurrentGame%%SpecialMode%RequirementsArray.Clone()
			%CurrentGame%%SpecialMode%RequirementsArray.Remove(Index)
			ItemsRemoved := 1
			continue
		}
		*/
		; Store the value found this cycle to compare the next cycle against.
		%IconName%ValueOld := CurrentValue
		; When the requirement is done and the 'show DONE if done' option is selected,
		; write 'DONE' to the requirement and skip the rest of this cycle.
		if (CurrentValue >= TotalRequired AND TotalRequired != "" AND ShowDoneIfDone = 1)
		{
			if (OutputType = "Icons")
				LV_Modify(RowNumber, "Col1", "DONE")
			else if (OutputType = "Text")
			{
				LV_Modify(RowNumber, "Col2", "DONE")
				LV_Modify(RowNumber, "Col3", "")
				LV_ModifyCol()
			}
			continue
		}
		; If a total required is defined, check if the value is higher and
		; enforce it as a maximum in necessary.
		if (CurrentValue > TotalRequired AND TotalRequired != "")
			CurrentValue := TotalRequired
		; Update the output, with slightly different code depending on the
		; output type and if a total required has been defined.
		if (OutputType = "Icons")
		{
			UpdatedColumnContents := ((TotalRequired != "") ? (CurrentValue "`/" TotalRequired) : (CurrentValue) )
			LV_Modify(RowNumber, "Col1", UpdatedColumnContents)
			UpdatedValueLengthChar := StrLen(UpdatedColumnContents)
		}
		else if (OutputType = "Text")
		{
			LV_Modify(RowNumber, "Col2", CurrentValue)
			UpdatedValueLengthChar := StrLen(CurrentValue)
		}
		; Check the length of the new value and make the output wider if it's too small.
		UpdatedValueLengthInPixels := UpdatedValueLengthChar * 7 + 12
		if (UpdatedValueLengthInPixels > MaxValueLengthInPixels%ListViewNumber%)
		{
			if (OutputType = "Text")
				LV_ModifyCol(2, UpdatedValueLengthInPixels)
			/*
			else if (OutputType = "Icons")
			{
				UpdatedValueLengthInPixels := UpdatedValueLengthInPixels + 32
				GuiControlGet, RequirementsListView%ListViewNumber%Pos, Pos, RequirementsListView%ListViewNumber%
				GuiControl, Move, RequirementsListView%ListViewNumber%, w%UpdatedValueLengthInPixels%
				LV_ModifyCol(1, UpdatedValueLengthInPixels)
				UpdatedValueLengthInPixels := UpdatedValueLengthInPixels - 32
			}
			*/
			MaxValueLengthInPixels%ListViewNumber% := UpdatedValueLengthInPixels
		}
	}
}
return


; For each requirement in the requirements array, set the value in the listview(s) back to
; 0 or 0/TotalRequired, whichever applies. At the start of every requirement, check if the
; current row exceeds the maximum length and jump to the next list view in necessary.
ResetOutput:
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	RowNumber += 1
	%IconName%ValueOld := 0
	if (RowNumber > MaximumRows)
	{
		RowNumber := 1
		ListViewNumber += 1
		Gui, 1:ListView, RequirementsListView%ListViewNumber%
	}
	If (OutputType = "Icons")
		LV_Modify(RowNumber, "Col1", ((TotalRequired != "") ? ("0`/"TotalRequired) : 0 ))
	else if (OutputType = "Text")
		LV_Modify(RowNumber, "Col2", 0)
}
return


UpdateOutputFile:
if (FileExist(FileOutputNameTemp))
	FileDelete, %FileOutputNameTemp%
FormatTime, CurrentTime, , HH:mm
FileAppend, %CurrentTime% %OutputStatus%`n, %FileOutputNameTemp%
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	Name := %CurrentGame%%SpecialMode%%IconName%.Name
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	Type := %CurrentGame%%SpecialMode%%IconName%.Type
	; The current value is reset to stop information from carrying over from the previous requirement.
	CurrentValue := 0
	; Loop to read all the memory addresses belonging to the current requirement.
	; Get the address, length and customcode flags from the requirements array.
	; If type is set, the read value can be converted to a float and custom code
	; located in the requirement list can be executed. At the end of the loop,
	; The variable 'CurrentValue' contains the finalized value of the requirement.
	loop
	{
		ReadAddress := %CurrentGame%%SpecialMode%%IconName%["Address"A_Index]
		if (!ReadAddress)
			break
		ReadLength := %CurrentGame%%SpecialMode%%IconName%["AddressLength"A_Index]
		MemoryValue := %CurrentGame%_ReadMemory(ReadAddress, Type, ReadLength)
		if (%CurrentGame%%SpecialMode%%IconName%["AddressCustomCode"A_Index] = 1)
			gosub %CurrentGame%_%IconName%_Address%A_Index%CustomCode
		CurrentValue += %MemoryValue%
	}
	; When the requirement is done and the 'show DONE if done' option is selected,
	; write 'DONE' to the requirement. Else, enforce the TotalRequired as a maximum for CurrentValue
	if (CurrentValue >= TotalRequired AND TotalRequired != "")
	{
		if (ShowDoneIfDone = 1)
			TextEntry := Name A_Space "DONE" "`n"
		else
			TextEntry := Name A_Space TotalRequired "`/" TotalRequired "`n"
	}
	else
		TextEntry := Name A_Space CurrentValue  ((TotalRequired != "") ? ("`/"TotalRequired) : "" ) "`n"
	FileAppend, %TextEntry%, %FileOutputNameTemp%
}
; Move the temp file to the original file output, overwriting the old file.
if (FileExist(FileOutputNameTemp))
	FileMove, %FileOutputNameTemp%, %FileOutputName%, 1
else
	MsgBox, 0x2030, , Error`: Updated output file unavailable.
; Updating the file is quite a resource hog, so we don't want to do it too often.
sleep %RefreshRateFileOutput%
return


ResetOutputFile:
if (FileExist(FileOutputName))
	FileDelete, %FileOutputName%
if (FileExist(FileOutputNameTemp))
	FileDelete, %FileOutputNameTemp%
FormatTime, CurrentTime, , HH:mm
FileAppend, %CurrentTime% %OutputStatus%`n, %FileOutputName%
for Index, IconName in %CurrentGame%%SpecialMode%RequirementsArray
{
	Name := %CurrentGame%%SpecialMode%%IconName%.Name
	TotalRequired := %CurrentGame%%SpecialMode%%IconName%.TotalRequired
	; Create the entry in the listview. Check if TotalRequired is defined, if not leave it out.
	TextEntry := Name A_Space "0" ((TotalRequired != "") ? ("`/"TotalRequired) : "" ) "`n"
	FileAppend, %TextEntry%, %FileOutputName%
}
return


; Update the status text next to the Change Output Type button or in the first line of the output file.
UpdateOutputStatus(newStatus)
{
	global
	OutputStatus := newStatus
	if (OutputType = "Text" OR OutputType = "Icons")
		GuiControl, 1:, OutputStatusTextControl, %OutputStatus%
	return
}


; ######################################################################################################
; ####################################### RESTART/EXIT SEQUENCE ########################################
; ######################################################################################################

/*
Subheadings:

	RestartSequence
	ExitSequence
	3ButtonYes
	3ButtonNo/3GuiClose/3GuiEscape
*/


; Restart the program.
RestartSequence:
ReloadingScript := 1
reload
sleep 100
return


; If the exit is already confirmed or the script is being reloaded, do that immediately.
; If not, disable the currently active window (which prevents it from being activated)
; and instead create a window asking the user to confirm the exit. This window does not
; follow the settings to make sure it is always readable, even if the user screwed up the
; settings. The only setting which is used here is the text smoothing, since it can't
; mess up the window so far that it is no longer readable.
ExitSequence:
if (ExitConfirmed = 1 OR ReloadingScript = 1)
{
	; Delete the icons library if the program is compiled to keep things neat.
	if (A_IsCompiled = 1)
	{
		FileDelete, %ScriptNameNoExt% Readme.txt
		FileDelete, %ScriptNameNoExt% Icons.icl
	}
	; If the program is exited mid update loop in file mode, we need to remove the temp file here.
	if (FileExist(FileOutputNameTemp))
		FileDelete, %FileOutputNameTemp%
	exitApp
}
else
{
	if (CurrentGUI)
		Gui, %CurrentGUI%: +Disabled
	Gui, 3: -MinimizeBox -MaximizeBox +owner%CurrentGUI% +LastFound
	WinSet, AlwaysOnTop, On
	if (TextSmoothing = 0)
		Gui, 3:Font, q3
	Gui, 3:Add, Text, , Are you sure you want to exit the program?
	Gui, 3:Add, Button, Default section, Yes
	Gui, 3:Add, Button, ys, No
	Gui, 3:Show, ,
	return
}


; If the user confirms the exit, exit.
3ButtonYes:
ExitConfirmed := 1
exitApp


; If the user cancels the exit, restore the previous window and destroy the exit confirmation window.
3ButtonNo:
3GuiClose:
3GuiEscape:
if (CurrentGUI)
	Gui, %CurrentGUI%: -Disabled
Gui, 3:Destroy
return


; ######################################################################################################
; ############################################ DEBUG STUFF #############################################
; ######################################################################################################

/*
Subheadings:

	DebugFunctions
	DebugListvars
*/


DebugFunctions:
Hotkey, F7, DebugListvars, On
return


DebugListvars:
ListVars
return


; ######################################################################################################
; ######################################## SUPPORTED GAMES LIST ########################################
; ######################################################################################################
; This label has been isolated from the rest of the script in order to make implementation of support
; for games easier.
#Include <SupportedGamesList>

