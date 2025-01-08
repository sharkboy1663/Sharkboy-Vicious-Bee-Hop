; this file has planter logic
plantersButton(*) {
    mainGui.Minimize()

    if !IsSet(plantersGuiExist)
        global plantersGuiExist := false

    if plantersGuiExist {
        MsgBox("Planters gui already exists!")
        return
    }

    plantersGuiExist := true
    global fieldList := ["Sunflower", "Dandelion", "Mushroom", "Blue Flower", "Clover", "Strawberry", "Spider", "Bamboo", "Pineapple", "Stump", "Cactus", "Pumpkin", "Pine", "Rose", "Mountain", "Pepper", "Coconut", "None"]
    global planterList := ["Plastic", "Candy", "Blue", "Red Clay", "Tacky", "Pesticide", "Heat-Treated", "Hydroponic", "Petal", "Plenty", "None"]

    plantersGui := Gui("-Theme", "Planters")
    plantersGui.SetFont("c" guiColor)
    plantersGui.BackColor := "0x1a1a1a" 

    global tab1Visible := true
    global tab2Visible := false
    global tab1Controls := []
    global tab2Controls := []

    loop 3 {
        i := A_Index
        tab1Controls.Push(plantersGui.Add("GroupBox", "x" 5 + (i-1) * 140 " y25 w145 h385 c" guiColor, "Cycle #" i))
        
        loop 3 {
            t := A_Index
            tab1Controls.Push(plantersGui.Add("GroupBox", "x" 12 + (i-1) * 140 " y" 50 + (t-1) * 120 " w130 h115 c" guiColor, "Planter Set #" t))
            planter := plantersGui.Add("ComboBox", "vPlanter" i "_slot" t " w100 x" 25 + (i-1) * 140 " y" 70 + (t-1) * 120 " Background1a1a1a", planterList)
            tab1Controls.Push(planter)
            planter.Text := planterList.Length
            
            fields := plantersGui.Add("ComboBox", "vfield" i "_slot" t " w100 x" 25 + (i-1) * 140 " y" 100 + (t-1) * 120 " Background1a1a1a", fieldList)
            tab1Controls.Push(fields)
            fields.Text := fieldList.Length
            
            time := plantersGui.Add("Edit", "vTime" i "_slot" t " w100 h25 x" 25 + (i-1) * 140 " y" 130 + (t-1) * 120 " Background1a1a1a", "Time (Minutes)")
            tab1Controls.Push(time)
        }
    }

    loop 3 {
        i := A_Index
        tab2Controls.Push(plantersGui.Add("GroupBox", "x" 5 + (i-1) * 140 " y25 w145 h385 c" guiColor, "Cycle #" i + 3))
        
        loop 3 {
            t := A_Index
            tab2Controls.Push(plantersGui.Add("GroupBox", "x" 12 + (i-1) * 140 " y" 50 + (t-1) * 120 " w130 h115 c" guiColor, "Planter Set #" t))
            planter := plantersGui.Add("ComboBox", "vPlanter" i + 3 "_slot" t " w100 x" 25 + (i-1) * 140 " y" 70 + (t-1) * 120 " Background1a1a1a", planterList)
            tab2Controls.Push(planter)
            planter.Value := planterList.Length
            
            fields := plantersGui.Add("ComboBox", "vfield" i + 3  "_slot" t " w100 x" 25 + (i-1) * 140 " y" 100 + (t-1) * 120 " Background1a1a1a", fieldList)
            tab2Controls.Push(fields)
            fields.Value := fieldList.Length
            
            time := plantersGui.Add("Edit", "vTime" (i + 3) "_slot" t " w100 h25 x" 25 + (i-1) * 140 " y" 130 + (t-1) * 120 " Background1a1a1a", "Time (Minutes)")
            tab2Controls.Push(time)
        }
    }

    for ctrl in tab2Controls
        ctrl.Visible := false

    plantersGui.Add("Button", "x330 y430", ">").OnEvent("Click", switchTab)
    plantersGui.Add("Button", "x310 y430", "<").OnEvent("Click", switchTab)
    plantersGui.Add("Button", "x100 y430", "Save Planter Settings").OnEvent("Click", savePlanterSettings)
    plantersGui.Show("w445 h465")
    plantersGui.OnEvent("Close", Exitfunc)

    loadPlanterSettings

    Exitfunc(*) {
        mainGui.Show()
        plantersGuiExist := false
    }

    switchTab(*) {
        static isTab1 := true
        
        for ctrl in tab1Controls
            ctrl.Visible := !isTab1
        for ctrl in tab2Controls
            ctrl.Visible := isTab1
            
        isTab1 := !isTab1
    }

    savePlanterSettings(*) {
        loop 6 {
            i := A_Index
            loop 3 {
                t := A_Index
                currentPlanter := plantersGui["Planter" i "_slot" t].Text
                currentField := plantersGui["field" i "_slot" t].Text
                currentTime := plantersGui["Time" i "_slot" t].Text
                
                IniWrite(currentPlanter, settingsPath, "Settings", "Planter" i "_slot" t)
                IniWrite(currentField, settingsPath, "Settings", "field" i "_slot" t)
                IniWrite(currentTime, settingsPath, "Settings", "Time" i "_slot" t)
            }
        }
    }

    loadPlanterSettings(*) {
        loop 6 {
            i := A_Index
            loop 3 {
                t := A_Index
                plantersGui["Planter" i "_slot" t].Text := IniRead(settingsPath, "Settings", "Planter" i "_slot" t, "None")
                plantersGui["field" i "_slot" t].Text := IniRead(settingsPath, "Settings", "field" i "_slot" t, "None")
                plantersGui["Time" i "_slot" t].Text := IniRead(settingsPath, "Settings", "Time" i "_slot" t, "Time (Minutes)")
            }
        }
    }
}


searchForPlanter(planter) {
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth//3 "|" windowHeight)
    outputList := ""
    result := Gdip_ImageSearch(pBMScreen, bitmaps[planter], &outputList, , , , , 1)
    if result {
        pos := StrSplit(outputList, ",")
        mousemove(pos[1], pos[2])
    }
    Gdip_DisposeImage(pBMScreen)
    return result
}

openInventory() {
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowwidth//3 "|" windowHeight)
    
    x := windowX + 15
    y := windowY + 120 
    
    result := Gdip_ImageSearch(pBMScreen, bitmaps["InventoryOpen"], &outputList, , , , , 1)
    if !result {
        mousemove(x, y)
        Hypersleep(50)
        click()
    } 
    
    mousemove(x + 25, y + 100)
    Hypersleep(50)
    
    loop 15 { 
        HyperSleep(25)  
        scroll("up", 300)  
    }
    
    Gdip_DisposeImage(pBMScreen)
}



clickYes() {
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth/1.5 "|" windowHeight/1.5)
    outputList := ""
    result := Gdip_ImageSearch(pBMScreen, bitmaps["yes"], &outputList, , , , , 1)
    if result {
        pos := StrSplit(outputList, ",")
        mousemove(pos[1], pos[2])
        HyperSleep(500)
        click()
    }
    Gdip_DisposeImage(pBMScreen)
}

placePlanter(planter, field) {
    ResetCharacter()
    HyperSleep(7500)
    goTo%field%()
    openInventory()
    HyperSleep(250)
    
    loop 40 {
        HyperSleep(100) 
        scroll("down", 25)  
        HyperSleep(150)       
        if searchForPlanter(planter) {
            getrobloxclientpos()
            MouseClickDrag("Left", , , windowWidth//2, windowHeight//2, 10)
            HyperSleep(250)
            clickYes()
            break
        }
    }
}

pickUpPlaner(planter, field) {
    ResetCharacter()
    HyperSleep(7500)
    goTo%field%()
    getrobloxclientpos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth/1.5 "|" windowHeight/1.5)
    if Gdip_ImageSearch(pBMScreen, bitmaps["harvest"], , , , , , 2) {
        send "e"
        sendwebhook("Picked up " planter " at " field)
        mousemove(500, 500)
        clickYes()
    }
    gdip_disposeimage(pBMScreen)
}

checkValidPlanter(cycle, slot) {
    planter := IniRead(settingsPath, "Settings", "Planter" cycle "_slot" slot, "None")
    field := IniRead(settingsPath, "Settings", "field" cycle "_slot" slot, "None")
    time := IniRead(settingsPath, "Settings", "time" cycle "_slot" slot, "Time (Minutes)")
    return (planter != "None" && field != "None" && IsNumber(time)) 
}

/**
checkAllValidPlanters() {
    validPlanters := []
    loop 6 {
        i := A_Index
        loop 3 {
            t := A_Index
            if checkValidPlanter(i, t)
                validPlanters.Push()
        }
    }
}
**/