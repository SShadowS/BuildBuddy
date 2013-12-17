;------------ Start of auto-execute section ------------

;Main Menu
Menu, MainMenu, add, Classic, RunClassic
Menu, MainMenu, add, Role, RunRole

;Classic
Menu, SubMenuClassic, add, Classic Build 1, RunClassic
Menu, SubMenuClassic, add, Classic Build 2, RunClassic

;Role
Menu, SubMenuRole, add, Role Build 1, RunRole
Menu, SubMenuRole, add, Role Build 2, RunRole

;SubMenuLinks
Menu, MainMenu, add, Classic, :SubMenuClassic
Menu, MainMenu, add, Role, :SubMenuRole

;------------ End of auto-execute section ------------
Return
;------------ End of auto-execute section ------------

RunClassic:
MsgBox You selected %A_ThisMenuItem%
Return

RunRole:
MsgBox You selected %A_ThisMenuItem%
Return

#n::
FileSelectFile, SelectedFile,3,, Select the fin.exe or finsql.exe to add, (*.exe)
FileGetVersion, FileVersion, %SelectedFile%
if SelectedFile =
	MsgBox, You didn't select a file.
Else
	MsgBox, You selected:`n%SelectedFile%`nBuild version:`n%FileVersion%

Menu, MainMenu, Show

Return