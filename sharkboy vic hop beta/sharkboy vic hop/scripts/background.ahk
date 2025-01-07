#Requires AutoHotkey v2.0
#SingleInstance Force

global settingsPath := A_ScriptDir "\..\config.ini"
#Include "..\scripts\webhook.ahk"
#Include "..\lib\Gdip_all.ahk"
#Include "..\lib\Gdip_ImageSearch.ahk"
#Include "..\lib\Roblox.ahk"
#Include "..\img\bitmaps.ahk"

global lastState := false

DetectDeath() {
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2 "|" windowY+windowHeight//2 "|" windowWidth//2 "|" windowHeight//2)
    result := Gdip_ImageSearch(pBMScreen, bitmaps["playerDied"],,,,,, 3)
    Gdip_DisposeImage(pBMScreen)
    return result
}

loop {
    currentState := DetectDeath()
    
    if (currentState && !lastState) {
        sendwebhook("You died", true)
        PostMessage(0x1003, 0, 0,, "Sharkboy Vic Hop")
        Sleep(2500)
    }
    
    lastState := currentState
    
    if !WinExist("Sharkboy Vic Hop")
        ExitApp()
        
    Sleep(500)
}
