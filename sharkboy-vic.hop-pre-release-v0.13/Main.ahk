#Requires AutoHotkey v2.0
checkUpdate()

TraySetIcon(A_scriptdir "\img\sharkboyvichop.png")
setworkingdir(A_scriptdir)
global settingsPath := A_scriptdir "\config.ini"

#Include %A_scriptdir%\scripts
#Include paths.ahk
#Include functions.ahk
#Include webhook.ahk
#Include planters.ahk

#Include %A_scriptdir%\lib
#Include roblox.ahk
#Include JSON.ahk
#Include walk.ahk
#Include socket.ahk


#Include Hypersleep.ahk
#Include %A_scriptdir%\img
#Include "bitmaps.ahk"

sendmode("Event")

if !FileExist(settingsPath) {
    FileAppend("", settingsPath)
}

sendWebhook("Connected to Discord")

guiColor := IniRead(settingsPath, "Settings", "GuiColor", "0x00FF00")


mainGui := Gui(, "Sharkboy Vic Hop")
mainGui.BackColor := "0x1a1a1a"  
mainGui.SetFont("s12 bold", "Segoe UI")
mainGui.Add("Text", "c" guiColor " x20 y28 w400", "SHARKBOY VIC HOP (Main)")

mainGui.SetFont("s10", "Segoe UI")
mainGui.Add("Text", "c" guiColor " x20 y70", "Movespeed:")
MovespeedEdit := mainGui.Add("Edit", "x140 y67 w200 h25")
MovespeedEdit.Text := IniRead(settingsPath, "Settings", "Movespeed", "33.35")

mainGui.Add("Text", "c" guiColor " x20 y105", "Discord User ID:")
userIDEdit := mainGui.Add("Edit", "x140 y102 w200 h25")
userIDEdit.Text := IniRead(settingsPath, "Settings", "User ID", "")

mainGui.Add("Text", "c" guiColor " x20 y140", "Discord Webhook:")
discordWebhookEdit := mainGui.Add("Edit", "x140 y137 w200 h25")
discordWebhookEdit.Text := IniRead(settingsPath, "Settings", "Webhook", "")

mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x20 y180 w100 h35", "Start (F1)").onEvent("click", start)
mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x130 y180 w100 h35", "Pause (F2)").onEvent("click", (*) => Pause(-1))
mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x240 y180 w100 h35", "Stop (F3)").onEvent("click", (*) => reload())
mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x240 y25 w100 h30", "Save Settings").onEvent("click", saveSettings)

mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x20 y222 w100 h25", "Planters").onEvent("click", plantersButton)

mainGui.Add("Text", "c" guiColor " x130 y225", "GUI Color:")
colorEdit := mainGui.Add("Edit", "x200 y222 w100 h25")
colorEdit.Text := guiColor
mainGui.Add("Button", "c0xFFFFFF Background" guiColor " x310 y222 w30 h25", "✓").OnEvent("Click", updateColor)

mainGui.Show("w360 h265")
mainGui.OnEvent("Close", (*) => ExitApp())


updateColor(*) {
    if (RegExMatch(colorEdit.Text, "^0x[0-9A-Fa-f]{6}$")) {
        IniWrite(colorEdit.Text, settingsPath, "Settings", "GuiColor")
        Reload
    } else {
        MsgBox("Invalid color format! Use 0xRRGGBB format (e.g., 0x00FF00)")
    }
}

saveSettings(*) {
    settings := [
        [MovespeedEdit.Text, isNumber, "Movespeed", "Not a valid movespeed!"],
        [discordWebhookEdit.Text, isValidWebhook, "Webhook", "Not a valid webhook!"],
        [userIDEdit.Text, (val) => RegExMatch(val, "\d{17,19}"), "User ID", "Not a valid user ID!"]
    ]

    for setting in settings {
        if !setting[2](setting[1]) {
            MsgBox(setting[4])
            return
        }
    }

    for setting in settings {
        IniWrite(setting[1], settingsPath, "Settings", setting[3])
    }

    MsgBox("Successfully saved all settings!")
}


start(*) {
    sendWebhook("Starting Main loop")
    mainGui.Minimize()
    loop
        mainAccountLoop()
}


f1:: start
f2:: Pause(-1)
f3:: reload()
