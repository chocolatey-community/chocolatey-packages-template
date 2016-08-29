Opt('WinDetectHiddenText', 1)
;Path and filename of the installer executable
$APPTOINSTALL="""" & $CmdLine[1] & """"
Run($APPTOINSTALL)
If @error <> 0  Then 
	Exit 1
EndIf

$WINDOWNAME="Stickies Installer"
WinWaitActive($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:&Install]")

$WINDOWNAME="Stickies 9.0a help"
WinWait($WINDOWNAME)
WinClose("Stickies 9.0a help")

$WINDOWNAME="Stickies Installer"
WinWait($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:&Finish]")

Exit