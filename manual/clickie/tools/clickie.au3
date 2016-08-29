Opt('WinDetectHiddenText', 1)
;Path and filename of the installer executable
$APPTOINSTALL="""" & $CmdLine[1] & """"
Run($APPTOINSTALL)
If @error <> 0  Then 
	Exit @error
EndIf

$WINDOWNAME="Clickie Installation (1/3)"
WinWaitActive($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:&Next >]")
WinSetState($WINDOWNAME,"",@SW_HIDE)

$WINDOWNAME="Clickie Installation (2/3)"
WinWaitActive($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:&Yes]")
WinSetState($WINDOWNAME,"",@SW_HIDE)

$WINDOWNAME="Clickie Installation (3/3)"
WinWaitActive($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:Finish]")
WinSetState($WINDOWNAME,"",@SW_HIDE)

$WINDOWNAME="Clickie Installation"
WinWaitActive($WINDOWNAME)
ControlClick($WINDOWNAME,"","[TEXT:OK]")
WinSetState($WINDOWNAME,"",@SW_HIDE)

;Installation complete
Exit