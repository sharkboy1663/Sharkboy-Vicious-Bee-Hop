global currentField := "none"
global currentProcess := "none"
; === VIC PATHS ===

searchPepper() {
    global currentProcess := "Searching"
    sendWebhook("Searching Pepper", true)
    Move(3, "s")
    Move(19, "d")
    Move(6, "w")
    Move(17, "a")
    Move(6, "w")
    Move(17, "d")
    Move(6, "w")
    Move(17, "a")

    if checkVicDetected() {
        global currentProcess := "attacking"
        global startTime := A_TickCount
        sendWebhook("Detected vicious bee, attacking", true)
        while (A_TickCount - startTime < 90000) {
            if attackPepper()
                return true
        }
        sendWebhook("Took too long to kill vicious bee, leaving game", true)
        return true
    }
}

attackPepper() {
    Move(15, "s")
    Hypersleep(25)
    Move(15, "d")
    Hypersleep(25)
    Move(15, "w")
    Hypersleep(25)
    Move(15, "a")

    if checkVicDead() {
        sendwebhook("Successfully killed vicious bee at pepper", true, true)
        return true
    }
    if checkvicLeft() {
        sendWebhook("Vicious bee left, leaving game", true)
        return true
    }     
    return false
}

searchMountain() {
    global currentProcess := "searching"
    global startTime := A_TickCount
    sendWebhook("Searching mountain", true)
    Move(5, "w")
    Move(8, "a")
    Move(20, "s")
    Move(6, "d")
    Move(12, "w")
    Move(6, "d")
    Move(12, "s")
    Move(5, "d")
    Move(19, "w")
    Move(25, "a")

    if checkVicDetected() {
        global currentProcess := "attacking"
        sendWebhook("Detected vicious bee, attacking", true)
        while (A_TickCount - startTime < 90000) {
            if attackMountain()
                return true
        }
        sendWebhook("Took too long to kill vicious bee, leaving game", true)
        return true
    }
}

attackMountain() {
    Move(15, "s")
    Hypersleep(25)
    Move(15, "d")
    Hypersleep(25)
    Move(15, "w")
    Hypersleep(25)
    Move(15, "a")

    if checkVicDead() {
        sendwebhook("Successfully killed vicious bee at mountain", true, true)
        return true
    }
    if checkvicLeft() {
        sendWebhook("Vicious bee left, leaving game", true)
        return true
    }     
    return false
}

searchCactus() {
    global currentProcess := "searching"
    global startTime := A_TickCount
    sendWebhook("Searching cactus", true)
    Hypersleep(500)
    Move(1.5, "w")
    Move(30, "a")
    Move(5, "w")
    Move(27, "d")
    Move(5, "w")
    Move(30, "a")

    if checkVicDetected()  {
        global currentProcess := "attacking"
        sendWebhook("Detected vicious bee, attacking", true)
        while (A_TickCount - startTime < 90000) {
            Move(5, "d")
            Move(5, "s")
            if attackCactus()
                return true
        }
        sendWebhook("Took too long to kill vicious bee, leaving game", true)
        return true
    }
}

attackCactus() {
    Move(15, "s")
    Hypersleep(25)
    Move(15, "d")
    Hypersleep(25)
    Move(15, "w")
    Hypersleep(25)
    Move(15, "a")

    if checkVicDead() {
        sendwebhook("Successfully killed vicious bee at cactus", true, true)
        return true
    }
    if checkvicLeft() {
        sendWebhook("Vicious bee left, leaving game", true)
        return true
    }     
    return false
}

searchRose() {
    global currentProcess := "searching"
    global startTime := A_TickCount
    sendWebhook("Searching rose", true)
    Move(15, "d")
    Move(4, "s")
    Move(25, "a")
    Move(4, "s")
    Move(25, "d")
    Move(4, "s")
    Move(25, "a")

    if checkVicDetected() {   
        global currentProcess := "attacking"
        sendWebhook("Detected vicious bee, attacking", true)
        while (A_TickCount - startTime < 90000) {
            if attackRose()
                return true
        }
        sendWebhook("Took too long to kill vicious bee, leaving game", true)
        return true
    }
}

attackRose() {
    Move(15, "s")
    Hypersleep(25)
    Move(15, "d")
    Hypersleep(25)
    Move(15, "w")
    Hypersleep(25)
    Move(15, "a")

    if checkVicDead() {
        sendwebhook("Successfully killed vicious bee at rose", true, true)
        return true
    }
    if checkvicLeft() {
        sendWebhook("Vicious bee left, leaving game", true)
        return true
    }     
    return false
}



checkForHive() {
    global hiveslot
    Hypersleep(150)
    Move(21, "w", "d")
    Hypersleep(15)
    Move(3, "d")
    Hypersleep(200)

    if checkHive() {
        Send "e"
        global hiveSlot := 1
        sendWebhook("Claimed hiveslot " hiveslot, true)
        Move(6, "d")
        return true
    }

    Hypersleep(700)
    loop 5 {
        Move(9, "a")
        Hypersleep(500)
        if checkHive() {
            global hiveSlot := A_Index + 1
            Send "e"
            break
        }
    }

    if !IsSet(hiveSlot) {
        sendWebhook("No hive slot found, retrying", true)
        return false
    }
    else if IsSet(hiveSlot) {
        Move(hiveSlot * 10, "d")
        return true
    }
}

moveToCannonAfterDeath() {
    global hiveslot
    position := checkSpawnPos()
    if position {
        Move(hiveslot * 10, "d")
        rampToCannon()
    }
    else if !position 
        spawnToCannon()
}

returnToPepper() {
    moveToCannonAfterDeath()
    cannonToPepper()
    Move(10, "w", "d")
}

returnToMountain() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(2500)
}

returnToCactus() {
    moveToCannonAfterDeath()
    send "e"
    HyperSleep(500)
    glider()
    Move(10, "d")
    Move(10, "s")
    HyperSleep(300)
    Move(1, "space")
    rotate("left", 4)
    Move(3, "d")
}

returnToRose() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(100)
    glider()
    Move(5, "d")
    HyperSleep(1500)
    Move(1, "space")
    Move(10, "s", "d")
}


spawnToCannon() {
    Move(21, "w", "d")
    Move(10, "d")
    rampToCannon()
}

rampToCannon() {
    global currentField := "pepper"
    Move(1, "space", "d")
    Move(2, "d")
    Move(6, "w")
    Move(6, "d")
    Move(1.5, "s")
    if checkVicDead() || checkVicDetected() || checkvicLeft() {
        sendWebhook("Leaving game, vicious bee detected or defeated", true)
        return true
    }
    Hypersleep(100)
}

cannonToPepper() {
    sendWebhook("Going to pepper", true)
    Move(25, "d")
    Move(1.5, "space", "d")
    Move(7, "d")
    Move(5, "w")
    Move(1.5, "w", "space")
    Move(20, "w")
    Move(10, "w", "space")
    Move(9, "w")
    Move(3, "w", "space")
    Move(2, "w")
    Move(30, "d")
    Move(5, "w")
    Move(2, "w", "space")
    Move(3, "w")
    Move(3, "d", "space")
}

pepperToMountain() {
    global currentField := "mountain"
    sendWebhook("Going to mountain", true)
    Move(19, "s")
    Hypersleep(25)
    rotate("left", 3)
    Hypersleep(50)
    shiftLock()
    Hypersleep(25)
    glider()
    Hypersleep(2600)
    Rotate("right", 1)
    Hypersleep(250)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
    Hypersleep(500)
    Move(10, "w")
    shiftLock()
    Hypersleep(25)
    if checkVicDetected() || checkVicDead() || checkvicLeft() {
        sendWebhook("Vicious bee detected or dead, leaving game", true)
        return true
    }
    send "e"
    Hypersleep(3000)
    rotate("left", 2)
}

mountainToCactus() {
    global currentField := "cactus"
    sendWebhook("Going to cactus", true)
    Move(3, "d")
    Move(25, "s")
    Move(6, "a")
    Move(6, "s")
    Move(37, "a")
    Move(2, "a", "space")
    HyperSleep(500)
}

cactusToRose() {
    global currentField := "rose"
    sendWebhook("Going to rose", true)
    Move(20, "a")
    Move(59, "s")
}


; === PLANTER PATHS ===

goToPinapple() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(2300)
    Move(40, "a")
}

goToMountain() {
    moveToCannonAfterDeath()
    send "e"
}

goToStump() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(2300)
    Move(90, "a")
    Move(5, "w")
}

goToPepper() {
    moveToCannonAfterDeath()
    Hypersleep(200)
    cannonToPepper()
    move(10, "d")
}

goToCoconut() {
    moveToCannonAfterDeath()
    Move(25, "d")
    Move(1.5, "space", "d")
    Move(7, "d")
    Move(5, "w")
    Move(1.5, "w", "space")
    Move(20, "w")
    Move(10, "w", "space")
    Move(9, "w")
    Move(3, "w", "space")
    Move(8, "a")
}

goToRose() {
    returnToRose()
}

goToSunflower() {
    moveToCannonAfterDeath()
    send "e"
    HyperSleep(200)
    glider()
    Move(5, "d")
    Hypersleep(600)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
    Move(10, "w")
}

goToDandelion() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(200)
    glider()
    Move(5, "a", "w")
    Hypersleep(1000)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
    Move(5, "w", "d")
}

goToMushroom() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(200)
    glider()
    Hypersleep(500)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
    Move(5, "w")
}

goToClover() {
    moveToCannonAfterDeath()
    send "e"
    HyperSleep(85)
    glider()
    Move(5, "a")
    HyperSleep(1000)
    Move(7, "w")
}

goToBlueFlower() {
    moveToCannonAfterDeath()
    send "e"
    HyperSleep(300)
    glider()
    Move(5, "a")
    HyperSleep(2500)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}


goToSpider() {
    moveToCannonAfterDeath()
    send "e"
    HyperSleep(150)
    glider()
    HyperSleep(2200)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}

goToStrawberry() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(600)
    glider()
    Move(10, "d")
    Hypersleep(300)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}

goToBamboo() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(800)
    glider()
    Move(10, "a")
    Hypersleep(300)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}

goToPumpkin() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(500)
    glider()
    Move(5, "d")
    HyperSleep(1000)
    Move(10, "s")
    Hypersleep(1600)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}

goToPine() {
    moveToCannonAfterDeath()
    send "e"
    Hypersleep(800)
    glider()
    Move(15, "d")
    Hypersleep(2500)
    Move(5, "s")
    Hypersleep(1000)
    send "{" 'space' " down}"
    Hypersleep(25)
    send "{" 'space' " up}"
}