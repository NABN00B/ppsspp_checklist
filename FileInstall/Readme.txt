PPSSPP 100% Checklist by NABN00B
with contributions by Parik

This derivative of Lighnat0r's 100% Checklist has been modified to work with the 64 bit version of
PPSSPP in order to implement support for Grand Theft Auto: Liberty City Stories and Vice City Stories.

########################################### COMPATIBILITY ############################################

PPSSPP:
- 64 bit executable ONLY (PPSSPPWindows64.exe)
- v1.4 or newer stable releases
- standard or Gold edition

Grand Theft Auto: Liberty City Stories:
- ULUS10041_1.05_ARTiSAN only

Grand Theft Auto: Vice City Stories:
- ULUS10160_1.03_Start2
- ULES00502_1.02_pSyPSP
- ULES00503_1.02_Googlecus
- (% only) ULJM05297_1.01_Caravan / ULJM05884_1.00_Pussycat

When using an unsupported game or version, the values displayed will be "junk". If using an unsuppor-
ted game version where the script is still the same, only the percentage value will be junk.

############################################ KNOWN ISSUES ############################################

- Increasing the font size will introduce empty spaces on the bottom of the checklist window. For now
  you will have to trim it off in your recording software or stick with the default size.
- Increasing the font size will cause the columns to be sized incorrectly in Text output mode. Requi-
  res further investigation.
- If the checklist fails to hook into PPSSPPWindows64.exe, then the check for admin rights might fail?
  Requires further investigation.
- Auto update feature is not yet updated to work with PPSSPP 100% Checklist, so it has been disabled.

Issues carried over from Lighnat0r's 100% Checklist:
- 100% transparency will make clicks fall through the welcome screen. For navigation click on the win-
  dow's header, and press Tab and the Cursor Keys to toggle between elements and Spacebar to confirm/
  toggle selection.
- Changing the size of GUI elements in Windows Accessibility Settings breaks the layout of the check-
  list window.
- OBS window capture will show a black box instead of the application's current window after the tool
  is restarted. The window capture needs to be refreshed after every restart.

Quoted from Lighnat0r's "100% Checklist Readme.txt":
- 100% transparency will make everything that has the same colour as the background transparent. (For
  this reason, when using transparency don't set the background colour to the same as the text co-
  lour.) This could also make (parts of) icons transparent.
- If you resize the window in OBS, there will be a one pixel border around the text, in a colour very
  similar to the background colour. To counter this, change the background colour to something more to
  your liking (not the same as text colour, see the issue above). Using the right background colour
  might even make the text even more readable. This issue seems to be specific to OBS, not sure if I
  can do anything to solve it.
- When using transparency the preview icon in Windows Peek and the alt-tab menu shows a box in the
  background colour instead of what the program actually looks like.
- The semi-transparent background might glitch out if you're restarting the program while it is inac-
  tive. The only solution I know of is to make the window always on top and I don't want to do that.

############################################# CHANGELOG ##############################################

20221217:
- ENGINE: The tool now tries to detect PPSSPP version on every update cycle instead of throwing an er-
  ror message and restarting.
- ENGINE: Game version control is now run on every update cycle.
- GUI: The output status text now displays the detected game version, or the detected PPSSPP version,
  if no game version was recognized.
- GUI: Fixed an issue where the "Change Output Type" button and output status text were cut off the
  output window.
- CONFIG: The settings read from the file are now validated. Any setting with an unintended value will
  be reset to the default.
- CONFIG: The output window font is now bold but not smooth by default.
- PPSSPP: Completely redone the way version control works. Implemented support to retrieving the add-
  ress of a PPSSPP v1.14+ process via window messages. https://github.com/hrydgard/ppsspp/pull/15748
  The previous methods have been updated as well, including bugfixes and possibly more reliability.
- PPSSPP: Added base offsets for v1.13.2 and v1.14 when checking the emulator version manually.
- GTAVCS: Implemented version control. The tool now recognizes the following disc versions: 
  ULUS10160_1.03_Start2, ULES00502_1.02_pSyPSP, ULES00503_1.02_Googlecus, ULJM05297_1.01_Caravan /
  ULJM05884_1.00_Pussycat. Support for the Japanese versions are currently limited to percentage only.
- GTAVCS: Paramedic is now recognized as done if the player has infinite sprint.
- README: The content of the previous "Enhancements" section of is now listed under the changelog for
  v2021.0406 instead.
- README: Unified the formatting of the "Changelog" section

2022.0729:
- PPSSPP: Added base offsets for v1.13 and v1.13.1 when checking the emulator version manually.

2022.0307:
- GUI: Fixed an issue that caused the font of the list view in the output window to be always smooth,
  regardless of the configuration setting.
- PPSSPP: Added base offsets for v1.12.x when checking the emulator version manually.
- GTALCS: Updated the RC races icon.
- GTAVCS: Updated the empire mission icons.

2021.0406:
(First build to be released on GTA Speedrunning Discord.)
- ENGINE: The tool has been modified to work in 64 bit AutoHotkey environment and with 64 bit apps.
- GUI: The last supported game in the list is now selected by default on the welcome screen.
- GUI: Icons output mode is now selected by default on the welcome screen.
- GUI: Added a small showcase in the settings window for both the selected text and background colors.
- GUI: Implemented a small status label in the output window/file to help with troubleshooting.
- GUI: The elements now properly scale with decimals and font size in Icons output mode. Text output
  mode is still buggy.
- GUI/CONFIG: Implemented changing font size on a scale of 8-16. The GUI is still buggy when changing
  this.
- CONFIG: Slightly adjusted the limits of a few settings.
- CONFIG: Custom colors saved in the color selector dialogue window are now saved into the file. By
  default 8 basic text-background color pairs are saved.
- CONFIG: Support for reading the configuration file of Lighnat0r's 100% Checklist.
- CONFIG: The the most commonly used settings are now applied by default.
- DEV: Game specific codes (such as memory reading, version management, etc.) and requirements have
  been isolated from the main script into separate files for each game.
- DEV: Icon libraries are now separate files for each game.

############################################## CREDITS ###############################################

PPSSPP 100% Checklist by NABN00B
with contributions by Parik

Original 100% Checklist by Lighnat0r with contributions by zoton2
https://github.com/Lighnat0r-pers/100pc_checklist

ArrayToString.ahk by just me
https://www.autohotkey.com/boards/viewtopic.php?p=228529#p228529
Edited by NABN00B

ChooseColor.ahk by iPhilip
https://www.autohotkey.com/boards/viewtopic.php?t=59141#p249345
Edited by NABN00B

RevArr.ahk by jNizM
https://github.com/jNizM/AHK_Scripts/blob/master/src/arrays/RevArr.ahk

classMemory.ahk by RHCP
https://github.com/Kalamity/classMemory/blob/master/classMemory.ahk
PPSSPP 100% Checklist wouldn't have been possible without such an amazing wrapper class!

PPSSPP 100% Checklist icon by NABN00B
Based on the original work "joystick" by Igé Maulana
https://thenounproject.com/term/joystick/2522039/
Licensed under a Creative Commons Attribution 3.0 United States License.
https://creativecommons.org/licenses/by/3.0/us/legalcode
The original work has been recolored.
