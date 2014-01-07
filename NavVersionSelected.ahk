;------------ Config Section ------------
;Location of ini file.
;%A_MyDocuments%	The full path and name of the current user's "My Documents" folder.
;%A_Desktop%		The full path and name of the folder containing the current user's desktop files.
;%A_AppData%		The full path and name of the folder containing the current user's application-specific data. For example: C:\Documents and Settings\Username\Application Data
;%A_WinDir%			The Windows directory. For example: C:\Windows
inifile=%A_MyDocuments%\BuildBubby.ini
;Mode
;0=Normal mode
;1=No registry editing(Debug)
Mode=0

;######################################################################################
;Editing below this point at your own risk
;######################################################################################

;------------ Start of auto-execute section ------------
GoSub, FindCurrentVersion
Menu, MainMenu, add, Dummy, ReloadMenu ;Dummy menu entry else DeleteAll fails.
GoSub, ReloadMenu

;------------ End of auto-execute section ------------
Return
;------------ End of auto-execute section ------------

AddStandardMenuItems:
;Stock menu entries
Menu, MainMenu, add, Add version to INI, AddVersion
;Menu, MainMenu, add, ReloadMenu, ReloadMenu
Return

AddVersion:
;Add and updates build entries in ini file.
FileSelectFile, SelectedFile,3,, Select the *.exe to add to menu, (*.exe)
FileGetVersion, FileVersion, %SelectedFile%
if SelectedFile =
	MsgBox, You didn't select a file.
Else
{
	MsgBox, You selected:`n%SelectedFile%`nBuild version:`n%FileVersion%
	IniRead,IsActive,%inifile%,%FileVersion%,Active
	If IsActive = ERROR
	{
		IniWrite,%SelectedFile%,%inifile%,%FileVersion%,Location
		IniWrite,False,%inifile%,%FileVersion%,Active
	}
	Else
	{
		IniWrite,%SelectedFile%,%inifile%,%FileVersion%,Location
	}
	GoSub, ReloadMenu
}
Return


ReloadMenu:
;Reloads all menu items. Upcoming features: Sorting by build number
Menu, MainMenu, DeleteAll
GoSub, AddStandardMenuItems
Loop, read, %inifile%
{
	IfInString, A_LoopReadLine, [ ;Searches for sections to add
	{
		StringTrimLeft, MenuNameToAdd, A_LoopReadLine, 1
		StringTrimRight, MenuNameToAdd, MenuNameToAdd, 1
		If MenuNameToAdd != Settings
		{
			Menu, MainMenu, add, %MenuNameToAdd%, ModifyRegDB
			IniRead,FileLocation,%inifile%,%MenuNameToAdd%,Location
			StringGetPos, PathPos, FileLocation,\,1
			StringMid, FileName, FileLocation,PathPos+2
			IniRead,SetActive,%inifile%,Settings,%FileName%
			If SetActive = %MenuNameToAdd%
			{
				Menu, MainMenu, Check, %MenuNameToAdd%
			}
		}
	}
}
Return

ModifyRegDB:
;Modifies the RegDB
Menu, MainMenu, Check, %A_ThisMenuItem%
IniRead, RunThisFile, %inifile%, %A_ThisMenuItem%, Location
StringGetPos, PathPos, RunThisFile,\,1
StringMid, FilePath, RunThisFile,1,PathPos+1
StringMid, FileName, RunThisFile,PathPos+2
IniWrite,%A_ThisMenuItem%,%inifile%,Settings,%FileName%
If Mode = 1
	MsgBox, Will edit this key:`n%FileName%`nDefault:`n%RunThisFile%`nPath:`n%FilePath%
Else
{	
	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%FileName%,, %RunThisFile%
	If ErrorLevel
		MsgBox, Error changing Default key at SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%FileName%.
	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%FileName%, Path, %FilePath%
	If ErrorLevel
		MsgBox, Error changing Path key at SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%FileName%.
}
GoSub, ReloadMenu
Return

FindCurrentVersion:
;Find current versions from RegDB
RegRead, CurrentDynNav, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Microsoft.Dynamics.Nav.Client.exe
RegRead, CurrentFin, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fin.exe
RegRead, CurrentFinSQL, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\finsql.exe
;Find version from Files
FileGetVersion, CurrentDynNavVersion, %CurrentDynNav%
FileGetVersion, CurrentFinVersion, %CurrentFin%
FileGetVersion, CurrentFinSQLVersion, %CurrentFinSQL%
;Create/Modify entries in ini file
IniWrite,%CurrentDynNav%,%inifile%,%CurrentDynNavVersion%,Location
IniWrite,True,%inifile%,%CurrentDynNavVersion%,Active
IniWrite,%CurrentFin%,%inifile%,%CurrentFinVersion%,Location
IniWrite,True,%inifile%,%CurrentFinVersion%,Active
IniWrite,%CurrentFinSQL%,%inifile%,%CurrentFinSQLVersion%,Location
IniWrite,True,%inifile%,%CurrentFinSQLVersion%,Active
IniWrite,%CurrentDynNavVersion%,%inifile%,Settings,Microsoft.Dynamics.Nav.Client.exe
IniWrite,%CurrentFinVersion%,%inifile%,Settings,fin.exe
IniWrite,%CurrentFinSQLVersion%,%inifile%,Settings,finsql.exe
Return

#n::
;Standard hot-key is Windows button (#) + n (n)
Menu, MainMenu, Show
Return