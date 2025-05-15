; PPSSPP_VersionCheck by NABN00B
; Signature scanning method by Parik

; Load prerequisites.
#Include <classMemory>
#Include <RevArr>

; Function:                       PPSSPP_VersionCheck(ppssppMemory [, ByRef ppssppVersion] )
;                                 Returns the base offset of a PPSSPP process depending on its version.
; Requirements:
;   classMemory.ahk           -   _ClassMemory class by RHCP
;                                 https://github.com/Kalamity/classMemory/blob/master/classMemory.ahk
;   RevArr.ahk                -   RevArrByRef function by jNizM
;                                 https://github.com/jNizM/AHK_Scripts/blob/master/src/arrays/RevArr.ahk
; Parameters:
;   ppssppMemory              -   The _ClassMemory object of a running PPSSPP process.
;   ppssppVersion (Out)       -   The variable to store the detected version of PPSSPP (string).
;   [ppssppGameAddress] (Out) -   The variable to store the start memory address of game data (integer).
; Return values:
;   positive integer          -   The base offset corresponding to the version of PPSSPP.
;   "Error"                   -   Indicates failure.
;
; Basic Usage:
;   EmulatorWindowClass := "PPSSPPWnd"
;   EmulatorPID := 0
;   EmulatorMemory := 0
;   EmulatorVersion := "Unknown"
;   EmulatorBaseOffset := 0
;   GameDataAddress := 0
;
;   WinWait, ahk_class %EmulatorWindowClass%
;   _ClassMemory.setSeDebugPrivilege()
;   EmulatorMemory := new _ClassMemory("ahk_class" EmulatorWindowClass, "", EmulatorPID)
;
;   if (IsObject(EmulatorMemory) && EmulatorMemory.__class = "_ClassMemory" && A_IsAdmin && EmulatorPID)
;   {
;     while (EmulatorVersion = "Unknown")
;     {
;       EmulatorBaseOffset := PPSSPP_VersionCheck(EmulatorMemory, EmulatorVersion, GameDataAddress)
;       sleep 1000
;     }
;     while (EmulatorMemory.read(EmulatorMemory.BaseAddress))
;     {
;       ; Pointer read (recommended):
;       MyValue1 := EmulatorMemory.read(EmulatorMemory.BaseAddress + EmulatorBaseOffset, "Int", MyOffset1)
;       MsgBox, MyValue1: %MyValue1%
;       ; Direct address read (NOT recommended):
;       MyValue2 := EmulatorMemory.read(GameDataAddress + MyOffset2, "Int")
;       MsgBox, MyValue2: %MyValue2%
;     }
;   }
;
; Notes:
; - PPSSPP must allocate game memory (by having a game loaded) before this function can operate.
; - This function ensures to return "Error" if either of ppssppVersion, ppssppGameAddress or the base
;   offset could not be determined.
; - Whenever "Error" is returned, ppssppVersion is set to "Unknown", and ppssppGameAddress is set to 0.
; - PPSSPP doesn't guarantee that the allocated game memory starts at the same address after reloading
;   the same game in the same process session. This means that the value of ppssppGameAddress should not
;   be used for memory operations, unless you call this function before every such operation.

PPSSPP_VersionCheck(ByRef ppssppMemory, ByRef ppssppVersion, ByRef ppssppGameAddress := 0)
{
	; Check if the parameter is an existing _ClassMemory object. Stop if it's not.
	if (!IsObject(ppssppMemory) || ppssppMemory.__class != "_ClassMemory")
	{
		ppssppGameAddress := 0
		ppssppVersion := "Unknown"
		return "Error"
	}

	; Get the file path to the exe of PPSSPP and then the file's version.
	ppssppFilePath := ppssppMemory.GetModuleFileNameEx()
	FileGetVersion, ppssppVersion, % ppssppFilePath
	fileVersionError := ErrorLevel

	if (!fileVersionError && ppssppMemory.isTarget64bit)
	{
		ppssppIs64bit := ppssppMemory.isTarget64bit
		ppssppBaseAddress := ppssppMemory.BaseAddress
		ppssppEndAddress := ppssppMemory.getEndAddressOfLastModule()

		; Method A: manual detection (fastest)
		; Return the base offset corresponding to the executable's version.
		gosub PPSSPP_InitializeBaseOffsets
		if (PPSSPP_BaseOffsets.HasKey(ppssppVersion))
		{
			offset := PPSSPP_BaseOffsets[ppssppVersion]
			gameAddress := ppssppMemory.read(ppssppBaseAddress + offset, "Int64")
			if (gameAddress > 0)
			{
				ppssppGameAddress := gameAddress
				return offset
			}
		}

		; Method B: window message (from v1.14) https://github.com/hrydgard/ppsspp/pull/15748
		ppssppPID := ppssppMemory.PID
		SendMessage, 0xB118, 0, 0, , ahk_pid %ppssppPID%
		replyLowerBits := ErrorLevel
		if (replyLowerBits != "FAIL")
		{
			SendMessage, 0xB118, 0, 1, , ahk_pid %ppssppPID%
			replyUpperBits := ErrorLevel
			if (replyUpperBits != "FAIL")
			{
				reply := (replyUpperBits << 32) + replyLowerBits
				if (reply > 0)
				{
					; Format the retrieved memory address.
					replyString := Format("{:016X}", reply)
					pattern := ppssppMemory.hexStringToPattern(replyString)
					; Reverse byte order.
					RevArrByRef(pattern)
					; Scan for the formatted memory address.
					address := ppssppMemory.processPatternScan(ppssppBaseAddress, ppssppEndAddress, pattern*)
					if (address > 0 && !Mod(address, 8))
					{
						offset := address - ppssppBaseAddress
						if (offset >= 0x100000)
						{
							ppssppGameAddress := reply
							return offset
						}
					}
				}
			}
		}

		; Method C: signature scanning (from v1.4 up to v1.12.3)
		; Scan for the signature of `static int sceMpegRingbufferAvailableSize(u32 ringbufferAddr)` to get the
		; address that's 22 bytes off the instruction that accesses the memory pointer.
		pattern := ppssppMemory.hexStringToPattern("41 B9 ?? 05 00 00 48 89 44 24 20 8D 4A FC E8 ?? ?? ?? FF 48 8B 0D ?? ?? ?? 00 48 03 CB")
		address := ppssppMemory.processPatternScan(ppssppBaseAddress, ppssppEndAddress, pattern*)
		; If the signature scanning was successful, calculate and return the base offset.
		if (address > 0)
		{
			; The next two lines must remain exactly as they are, otherwise this entire read fails.
			address += 22
			address += ppssppMemory.read(address) + 0x4
			gameAddress := ppssppMemory.read(address, "Int64")
			if (gameAddress > 0 && !Mod(gameAddress, 8))
			{
				offset := address - ppssppBaseAddress
				if (offset >= 0x100000)
				{
					ppssppGameAddress := gameAddress
					return offset
				}
			}
		}
	}

	; If neither method was successful, return "Error" to indicate failure. Memory access won't work if the
	; base offset can't be determined.
	ppssppGameAddress := 0
	ppssppVersion := "Unknown"
	return "Error"
}

PPSSPP_InitializeBaseOffsets:
if (!PPSSPP_BaseOffsets)
{
	global PPSSPP_BaseOffsets
	PPSSPP_BaseOffsets := { "1.3.0.0": 0xF34488
		, "1.7.0.0": 0xD90250
		, "1.7.1.0": 0xD91250, "1.7.4.0": 0xD91250
		, "1.8.0.0": 0xDC8FB0
		, "1.9.0.0": 0xD8AF70
		, "1.9.3.0": 0xD8C010
		, "1.10.0.0": 0xC53AC0
		, "1.10.1.0": 0xC53B00
		, "1.10.2.0": 0xC53CB0
		, "1.10.3.0": 0xC54CB0
		, "1.11.0.0": 0xC68320
		, "1.11.1.0": 0xC6A440, "1.11.2.0": 0xC6A440, "1.11.3.0": 0xC6A440
		, "1.12.0.0": 0xD960F8
		, "1.12.1.0": 0xD97108
		, "1.12.2.0": 0xD96108, "1.12.3.0": 0xD96108
		, "1.13.0.0": 0xDE90F0
		, "1.13.1.0": 0xDEA130
		, "1.13.2.0": 0xDF10F0
		, "1.14.0.0": 0xDF5C68 }
}
return
