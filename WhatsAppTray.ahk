
#SingleInstance Force
DetectHiddenWindows, On
SetTitleMatchMode, 3
SetTitleMatchMode, Fast
WinTitle := "WhatsApp Tray"
TrayTitle := "WhatsApp"
if (!GetWhatsAppWindowPID()){
    StartWhatsApp()
}
WhatsAppPID := GetWhatsAppWindowPID()
Gosub, ShowWhatsApp
InitTray()
Loop
{
    if (!WhatsAppWinHide){
        ExitWhenWhatsAppExit()
        Sleep 500
        WhatsAppMinimizedDetector()
        Sleep 500
        if (WhatsAppPID != GetActiveWinPID())
            Sleep, 1000 ; for performance
    }Else{
        Sleep 3000 ; also for performance
    }
}

ShowWhatsApp:
    WhatsAppWinShow(True)
Return

Exit:
    Process, Close, %WhatsAppPID%
ExitApp

ExitWhenWhatsAppExit(){
    global
    Process, Exist, %WhatsAppPID%
    if (!ErrorLevel){
        Gosub, Exit
    }
}

WhatsAppMinimizedDetector(){
    global
    local WinState
    WinGet, WinState, MinMax, WhatsApp ahk_pid %WhatsAppPID% ahk_exe WhatsApp.exe ahk_class Chrome_WidgetWin_1
    if (WinState == -1){
        WhatsAppWinShow(False)
    }
}

WhatsAppWinShow(show){
    global
    if (show){
        WinShow, WhatsApp ahk_pid %WhatsAppPID% ahk_exe WhatsApp.exe ahk_class Chrome_WidgetWin_1
        WhatsAppWinHide := False
        WinActivate, WhatsApp ahk_pid %WhatsAppPID% ahk_exe WhatsApp.exe ahk_class Chrome_WidgetWin_1
        Menu, Tray, NoIcon
    }Else{
        Menu, Tray, Icon
        WinHide, WhatsApp ahk_pid %WhatsAppPID% ahk_exe WhatsApp.exe ahk_class Chrome_WidgetWin_1
        WhatsAppWinHide := True
    }
}

InitTray(){
    global
    Menu, Tray, Tip, % TrayTitle
    Menu, Tray, NoStandard
    Menu, Tray, Add, WhatsApp Desktop, ShowWhatsApp
    Menu, Tray, Add, Exit, Exit
    Menu, Tray, Default, WhatsApp Desktop
}

StartWhatsApp(){
    local InstallLocation, PackageFamilyName, runOutputPID
    GetWhatsApp_AppxPackageData(InstallLocation, PackageFamilyName)
    Run, % "explorer.exe shell:appsFolder\" . PackageFamilyName . "!" . GetWhatsApp_ApplicationID(InstallLocation),,,runOutputPID
    WinWait, ahk_pid %runOutputPID%, , 3
    if (WinExist("ahk_pid " . runOutputPID)){
        WinKill, ahk_pid %runOutputPID%
        Debug(0, 1, "Error while launching WhatsApp", "WhatsApp can't run through this program. Please run WhatsApp and rerun this program`n`nCurrent process will be terminated.", 0x000301)
        ExitApp
    }
}

GetWhatsApp_AppxPackageData(ByRef InstallLocation, ByRef PackageFamilyName){
    local TempFile := A_ScriptDir . "\appxpackage.temp", debugOut, Quotation
    Quotation = "
    Loop
    {
        RunWait, % A_ComSpec . " /c powershell get-appxpackage > " . Quotation . TempFile . Quotation,,Hide
        IfNotExist, % TempFile
        {
            debugOut := Debug(2, 2, "Run PowerShell error", "PowerShell doesn't return Get-AppxPackage or create " TempFile, 0x000101)
            if (debugOut == "Abort") OR (debugOut == "")
                ExitApp
            if (debugOut == "Ignore")
                Break
        }Else{
            Break
        }
    }
    Loop, Read, % TempFile
    {
        if (IsStrContainsStr(A_LoopReadLine, ["InstallLocation","\WindowsApps\","WhatsAppDesktop"])){
            InstallLocation := SubStr(A_LoopReadLine, 21)
        }
        if (IsStrContainsStr(A_LoopReadLine, ["PackageFamilyName","WhatsAppDesktop"])){
            PackageFamilyName := SubStr(A_LoopReadLine, 21)
        }
        if (InstallLocation) && (PackageFamilyName){
            Break
        }
    }
    FileDelete, % TempFile
}

GetWhatsApp_ApplicationID(InstallLocation){
    local Quotation, debugOut
    Quotation = "
    IfNotExist, % InstallLocation
    {
        debugOut := Debug(4, 2, "Folder Not Exist", InstallLocation . " is not exist or maybe WhatsApp Desktop isn't installed yet.`n`nDo you wish to continue?", 0x000201)
        if (debugOut == "No") OR (debugOut == "")
            ExitApp
    }Else{
        IfNotExist, % InstallLocation . "\AppxManifest.xml"
        {
            debugOut := Debug(4, 2, "File Not Exist", InstallLocation . "\AppxManifest.xml is not exist. `n`nDo you wish to continue?", 0x000202)
            if (debugOut == "No") OR (debugOut == "")
                ExitApp
        }
    }
    Loop, Read, % InstallLocation . "\AppxManifest.xml"
    {
        if (IsStrContainsStr(A_LoopReadLine, ["<Application ", "Id="])){
            Return GetStrBetweenStr(A_LoopReadLine, "Id=" . Quotation, Quotation)
        }
    }
}

GetWhatsAppWindowPID(){
    local out
    WinGet, out, PID, ahk_exe WhatsApp.exe ahk_class Chrome_WidgetWin_1, Chrome Legacy Window
    Return % out
}

GetStrBetweenStr(Str, Str1, Str2){
    local pos1, pos2
    pos1 := InStr(Str, Str1, True) + StrLen(Str1)
    pos2 := InStr(Str, Str2, True, pos1)
    Return % (pos2 > pos1)? SubStr(Str, pos1, pos2 - pos1) : ""
}

IsStrContainsStr(Str, NeedleStrArray){
    local out
    for i,c in NeedleStrArray
    {
        if (InStr(Str, c, True) != 0){
            out ++
        }
    }
    Return % (out == NeedleStrArray.Length())? True : False
}

GetActiveWinPID(){
    local out
    WinGet, out, PID, A
    Return % out
}

Debug(Button, Level, ErrorType, Str, ErrorCode){
    global
    if (Level == 1)
        Level := 64
    if (Level == 2)
        Level := 48
    if (Level == 3)
        Level := 16
    MsgBox, % Button + Level, % WinTitle, % ErrorType ": " Str "`n`nCode: (" ErrorCode ")"
    IfMsgBox, Yes
        Return % "Yes"
    IfMsgBox, No
        Return % "No"
    IfMsgBox, OK
        Return % "OK"
    IfMsgBox, Cancel
        Return % "Cancel"
    IfMsgBox, Abort
        Return % "Abort"
    IfMsgBox, Ignore
        Return % "Ignore"
    IfMsgBox, Retry
        Return % "Retry"
    IfMsgBox, Continue
        Return % "Continue"
    IfMsgBox, TryAgain
        Return % "TryAgain"
    Return % ""
}
