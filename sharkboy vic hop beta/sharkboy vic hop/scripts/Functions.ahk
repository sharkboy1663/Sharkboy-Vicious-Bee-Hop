GetServer(amount:=1, cursor?) {
    static lastServers := [], serverListLength := 20
    server := []
    Whr := ComObject("WinHTTP.WinHTTPRequest.5.1")
    Whr.open("GET", "https://games.roblox.com/v1/games/1537690962/servers/0?sortOrder=1&excludeFullGames=true&limit=100" (IsSet(cursor) ? "&cursor=" cursor : ""), true)
    Whr.send()
    try 
        Whr.WaitForResponse()
    catch
        return [0]
    obj := JSON.parse(Whr.responsetext, true, false)
    if !IsObject(obj) || !obj.HasProp('data')
        return [0]
    for i in obj.data {
        for j in lastServers
            if j = i.id
                continue 2
        lastServers.InsertAt(1, i.id)
        server.Push(i.id)
        if server.Length = amount
            return server
    }
    return [0,obj.nextpagecursor]
}
Run(A_ScriptDir "\scripts\Background.ahk")
global serversJoined := 0
global nightservers := 0
joinRoblox() {
        leaveGame()
        Hypersleep(1000)
        Servers := GetServer(1)
     return Servers[1] ? Run("roblox://placeId=1537690962&gameInstanceId=" Servers[1]) : 0
}


loadRoblox() {
    joinRoblox()
    loop 25 {
        if BSSActive() {
            return true
        }
        else if A_index = 20 
           return false 
        Hypersleep(1000)
    }
}

joinAndCheckNight() {
    global serversJoined
    global nightservers
    if !roblox := loadRoblox()
        return false

    sendWebhook("Joined " serversJoined "x servers")
    serversJoined++
    sendKey("i", 5)
    if CheckNight() { 
        nightservers++
        sendwebhook("Joined " nightservers "x night servers")
        sendWebhook("Night found!", true)
        return true ; its night time
    }
    sendWebhook("No night found, leaving game", true)
}

joinUntilNight() {
    actions := [claimHive, rampToCannon, cannonToPepper, searchPepper, pepperToMountain, searchMountain, mountainToCactus, searchCactus, cactusToRose, searchRose]
    if joinAndCheckNight() { 
        startTime := A_tickcount
        for a in actions {
            if a() {
                global currentField := "none"
                global currentProcess := "none"
                return       
            }   
        }
    }
        return false
}



CheckNight(hwnd?){
    if !IsSet(hwnd)
        Hwnd := GetRobloxHWND()
    if !WinExist(Hwnd)
        return 0
    WinActivate("ahk_id " Hwnd)
    GetRobloxClientPos(Hwnd)
    Night := ["0x17481F","0x18481F","0x56646B"]
    for v in Night 
        if result := PixelSearch(&outx, &outy, windowX+windowWidth//2, windowY+windowHeight//2, windowX+windowWidth, windowY+windowHeight,v)
            return result
    return 0
}



leaveGame() {
    hwnd := GetRobloxHWND()
    if WinExist(hwnd) && BSSActive() {
        send "{" "Esc" "}"
        Hypersleep(50)
        send "{" "L" "}"
        Hypersleep(50)
        send "{" "Enter" "}"
        Hypersleep(50)
    }
}


ResetCharacter() {
    hwnd := GetRobloxHWND()
    if WinExist(hwnd) && BSSActive() {
        send "{" "Esc" "}"
        sleep 50
        send "{" "R" "}"
        sleep 50
        send "{" "Enter" "}"
        sleep 100
    }
}

Move(tiles, key1, key2?) {
    GetRobloxClientPos()
    send("{" key1 " down}" (IsSet(key2) ? "{" key2 " down}" : ""))
    walk(tiles)
    send("{" key1 " up}" (IsSet(key2) ? "{" key2 " up}" : ""))
}


BSSActive() {
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth//3 "|" windowHeight//3)
    if Gdip_ImageSearch(pBMScreen, bitmaps["science"], , , , , 100, 2) {
        Gdip_DisposeImage(pBMScreen)
        return true
    }
    else {
        Gdip_DisposeImage(pBMScreen)
        return false
    }
}

checkHive() {
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(WindowX "|" windowY+offsetY "|" WindowWidth "|" 125)
    if Gdip_ImageSearch(pBMScreen, bitmaps["claimhive"], , , , , , 2) {
        Gdip_DisposeImage(pBMScreen)
        return true
    }
    else {
        Gdip_DisposeImage(pBMScreen)
        return false
    }
} 

checkVicDead() {
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2 "|" windowY "|" windowX+windowWidth//2 "|" windowY+windowHeight//2)
    Send "/{Enter}"
    Hypersleep(100)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["VicDefeated"], , , , , , 5)) {
        Gdip_DisposeImage(pBMScreen)
        return 1
    }
    else {
        Gdip_DisposeImage(pBMScreen)
        return 0
    }
}

checkVicDetected() {
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2 "|" windowY "|" windowX+windowWidth//2 "|" windowY+windowHeight//2)
        Send "/{Enter}"
        Hypersleep(100)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["VicDetected"], , , , , , 3)) {
        Gdip_DisposeImage(pBMScreen)
        return 1
    }
    else {
        Gdip_DisposeImage(pBMScreen)
        return 0
    }
}

/*
*@returns 1 if it detects vicious bee left, else, returns 0
*/
checkVicLeft() {
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2 "|" windowY "|" windowX+windowWidth//2 "|" windowY+windowHeight//2)
    Send "/{Enter}"
    Hypersleep(100)
    result := (Gdip_ImageSearch(pBMScreen, bitmaps["ViciousLeft"], , , , , , 3))
    Gdip_DisposeImage(pBMScreen)
    return result
}

rotate(direction := "right", amount := 4) {
    loop amount {
        Send((direction = "right") ? "." : ",")
        Hypersleep(15)
    }
}

shiftLock() {
    Send "{Shift down}"
    Hypersleep(25)
    Send "{Shift up}"
}

glider(seconds := 0) {
    loop 2 {
        send "{" 'space' " down}"
        Hypersleep(25)
        send "{" 'space' " up}"
        Hypersleep(350)
    }
    if seconds {
        Hypersleep(seconds * 1000)
        send "{" 'space' " down}"
        Hypersleep(25)
        send "{" 'space' " up}"
    }
}

claimhive() {
     loop 5 {
        if checkForHive() {
            break
        }
        
        else if (A_Index = 5) {
            return true
        }
        
        ResetCharacter()
        Hypersleep(7500)
    }
}

sendKey(key, amount, delay := 25) {
    loop amount {
        Send "{" key "}"
        Hypersleep(delay)
    }
}


checkSpawnPos() {
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(WindowX "|" windowY+offsetY "|" WindowWidth "|" 125)
    result1 := Gdip_ImageSearch(pBMScreen, bitmaps["collectPollen"],,,,,, 2) 
    result2 := Gdip_ImageSearch(pBMScreen, bitmaps["Ebutton"],,,,,, 2)
    Gdip_DisposeImage(pBMScreen)
    return (result1 || result2)
}




scroll(upOrDown := "up", times := 10) {
    direction := upOrDown = "up" ? "WheelUp" : "WheelDown"
    loop times {
        Send("{" direction "}")
    }
}


mainAccountLoop() {
    server := joinUntilNight()
    if !server 
        joinUntilNight()
}

deathDetected(*) {
    global currentField, currentProcess
    StopWalk()
    HyperSleep(7000)
    
    if (currentProcess = "attacking") {
        attackVic(currentField)
    } else {
        searchVic(currentField)
        if(currentField = "pepper")
            pepperToMountain()
        else if(currentField = "mountain")
            mountainToCactus()
        else if(currentField = "cactus")
            cactusToRose()
    }
}



attackVic(field) {
    if field != "none"
        returnTo%field%()
    while (A_TickCount - startTime < 90000) {
        if attack%field%()
            return true
    }
    sendWebhook("Could not kill vicious bee in time, leaving game", true)
    return true
}


searchVic(field) {
    if field != "none" {
        returnTo%field%()
        search%field%()
    }
}


StopWalk() {
    Send "{" "a" " up}"
    Send "{" "d" " up}"
    Send "{" "w" " up}"
    Send "{" "s" " up}" 
}


class client extends Socket.Client {
    onRead(*) {
        this.lastMessage := this.RecvText()
    }

    sendMessage(text) {
        this.SendText(text)
    }

    checkMessage(expectedMsg, callbackFn) {
        if(this.lastMessage = expectedMsg) {
            callbackFn.Call()
            this.lastMessage := ""
            return true
        }
        return false
    }
}

class server extends Socket.Server {
    onAccept(*) {
        this.client := this.AcceptAsClient()
        this.client.onRead := this.onread
        this.client.SendText("Hello world!")
    }

    onread(client, *) {
        this.lastMessage := this.RecvText()
    }

    sendMessage(text) {
        if HasProp(this, "client")
            this.client.SendText(text)
    }
    

    checkMessage(expectedMsg, callbackFn) {
        if(this.lastMessage = expectedMsg) {
            callbackFn()
            this.lastMessage := ""
            return true
        }
        return false
    }
}


if AccountType := "Main" {
    main := server(8080, "localhost")
    main.sendMessage("Hey, this is a test")
}


onMessage(0x1003, deathDetected)