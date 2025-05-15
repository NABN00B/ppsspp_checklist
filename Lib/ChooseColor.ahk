; ChooseColor by iPhilip
; https://www.autohotkey.com/boards/viewtopic.php?t=59141#p249345
; Edited by NABN00B

; Function:                 ChooseColor( [startingRGB, ByRef customRGBs, hWnd, flags] )
;                           Initializes the standard color selection dialog window built into Windows and
;                           returns the selected color.
; Parameters:
;   [startingRGB]       -   The color initially selected when the dialog box is created. Can be given in either
;                           decimal or hexadecimal in the following format: 0x00RRGGBB. The "0x" prefix is
;                           required in case of hex format. Defaults to 0x0 (Black).
;   [customRGBs] (Out)  -   An array of up to 16 elements that contain RGB values for the custom color boxes in
;                           the dialog box when it's initialized. Elements after the 16th value are ignored.
;                           Elements can be given in either decimal or hexadecimal in the following format:
;                           0x00RRGGBB. The "0x" prefixes are required in case of hex format. Input value
;                           defaults to an empty list.
;   [hWnd]              -   A handle to the window that owns the dialog box. Specifying this prevents the
;                           user from interacting with the owning window while the dialog is active. Defaults
;                           to 0 (none).
;   [flags]             -   A set of bit flags that you can use to enable certain options for the dialog box.
;                           Defaults to CC_RGBINIT (0x1) and CC_FULLOPEN (0x2).
; Return values:
;   string              -   The color in RRGGBB format (without the "0x" prefix) the user selected from the
;                           dialog box.
;   "" (empty string)   -   Indicates invalid format of the startingRGB (or customRGBs) parameter(s).
;   "Error"             -   Indicates failure or user cancellation of the dialog box.
; Related documents:
;   https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms646912(v=vs.85)
;   https://docs.microsoft.com/en-us/windows/win32/api/commdlg/ns-commdlg-choosecolorw~r1
; Notes:
;   CHOOSECOLORW structure:
;       typedef struct tagCHOOSECOLORW {    Type  Offset  Length
;         DWORD        lStructSize;         UInt   0/ 0   4
;         HWND         hwndOwner;           Ptr    4/ 8   4/8
;         HWND         hInstance;           Ptr    8/16   4/8
;         COLORREF     rgbResult;           UInt  12/24   4
;         COLORREF     *lpCustColors;       Ptr   16/32   4/8
;         DWORD        Flags;               UInt  20/40   4
;         LPARAM       lCustData;           Ptr   24/48   4/8
;         LPCCHOOKPROC lpfnHook;            Ptr   28/56   4/8
;         LPCWSTR      lpTemplateName;      Ptr   32/64   4/8
;       } CHOOSECOLORW, *LPCHOOSECOLORW;          36/72

ChooseColor(startingRGB := 0x0, ByRef customRGBs := "", hWnd := 0x0, flags := 0x3)
{
	VarSetCapacity(CustomColors, 64, 0)
	NumPut(VarSetCapacity(CC, A_PtrSize = 8 ? 72 : 36, 0), CC, 0, "UInt")
	NumPut(hWnd ? hWnd : A_ScriptHwnd, CC, A_PtrSize = 8 ? 8 : 4, "Ptr")
	NumPut(ColorRefConvert(startingRGB), CC, A_PtrSize = 8 ? 24 : 12, "UInt")
	NumPut(&CustomColors, CC, A_PtrSize = 8 ? 32 : 16, "Ptr")
	NumPut(flags, CC, A_PtrSize = 8 ? 40 : 20, "UInt")
	if (IsObject(customRGBs))
	{
		for each, RGB in customRGBs
			NumPut(ColorRefConvert(RGB), CustomColors, (each-1)*4, "UInt")
		until each = 16
	}
	if (DllCall("comdlg32\ChooseColor", "Ptr", &CC, "Int"))
	{
		if (IsObject(customRGBs))
		{
			Loop, 16
				customRGBs[A_Index] := ColorRefConvert(NumGet(CustomColors, (A_Index-1)*4, "UInt"))
		}
		Offset := A_PtrSize = 8 ? 24 : 12
		return Format("{:02X}{:02X}{:02X}", NumGet(CC, Offset, "UChar"), NumGet(CC, Offset+1, "UChar"), NumGet(CC, Offset+2, "UChar"))
	}
	else
	{
		if (A_LastError)
			MsgBox, 0x2030, , Error calling "comdlg32\ChooseColor".`n`n%A_LastError%.
		return "Error"
	}
}

; Function:                 ColorRefConvert(rgb)
;                           Swaps the Red and Blue values of a color value. This is required because the
;                           colors are represented in 0x00BBGGRR format in the structure used by the dialog box.
; Parameters:
;	rgb                 -   The color whose R and B values are to be swapped. Must be in the 0x00RRGGBB or
;	                        0x00BBGGRR format for intended behaviour. The "0x" prefix is required in case of
;	                        hex format.
; Return values:
;	hex value           -   The color with swapped Red and Blue values. The format is 0x00BBGGRR in case of
;	                        0x00RRGGBB input and 0x00RRGGBB in case of 0x00BBGGRR input.
;	"" (empty string)   -   Indicates invalid format of the rgb parameter.
; Related documents:
;	https://docs.microsoft.com/en-us/windows/win32/gdi/colorref

ColorRefConvert(rgb)
{
	return ((rgb & 0xFF) << 16) + (rgb & 0xFF00) + ((rgb >> 16) & 0xFF)
}
