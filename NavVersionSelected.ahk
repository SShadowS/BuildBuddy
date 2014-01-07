;------------ Config Section ------------
;Location of ini file.
;%A_MyDocuments%	The full path and name of the current user's "My Documents" folder.
;%A_Desktop%		The full path and name of the folder containing the current user's desktop files.
;%A_AppData%		The full path and name of the folder containing the current user's application-specific data. For example: C:\Documents and Settings\Username\Application Data
;%A_WinDir%			The Windows directory. For example: C:\Windows
inifile=%A_MyDocuments%\BuildBubby.ini

;######################################################################################
;Editing below this point at your own risk
;######################################################################################

;------------ Start of auto-execute section ------------
Menu, MainMenu, add, Dummy, ReloadMenu ;Dummy menu entry else DeleteAll fails.
GoSub, ReloadMenu

;------------ End of auto-execute section ------------
Return
;------------ End of auto-execute section ------------

AddStandardMenuItems:
;Stock menu entries
Menu, MainMenu, add, Add version to INI, AddVersion
Menu, MainMenu, add, ReloadMenu, ReloadMenu
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
	IniWrite,%SelectedFile%,%inifile%,%FileVersion%,Location
	GoSub, ReloadMenu
}
Return


ReloadMenu:
;Reloads all menu items. Upcomming features: Sorting by buildnumber
Menu, MainMenu, DeleteAll
GoSub, AddStandardMenuItems
Loop, read, %inifile%
{
	IfInString, A_LoopReadLine, [ ;Searches for sections to add
	{
		StringTrimLeft, MenuNameToAdd, A_LoopReadLine, 1
		StringTrimRight, MenuNameToAdd, MenuNameToAdd, 1
		Menu, MainMenu, add, %MenuNameToAdd%, RunClient
	}
}
Return

RunClient:
Menu, MainMenu, Check, %A_ThisMenuItem%
IniRead, RunThisFile, %inifile%, %A_ThisMenuItem%, Location
StringGetPos, PathPos, RunThisFile,\,1
StringMid, FilePath, RunThisFile,1,PathPos+1
StringMid, FileName, RunThisFile,PathPos+2
MsgBox, Will edit this key:`n%FileName%`nDefault:`n%RunThisFile%`nPath:`n%FilePath%
;RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Microsoft.Dynamics.Nav.Client.exe, Path, %RunThisFile%
;If ErrorLevel
;	MsgBox, Fejl.
Return

#n::
;Standard hotkey is Windows button (#) + n (n)
Menu, MainMenu, Show
Return