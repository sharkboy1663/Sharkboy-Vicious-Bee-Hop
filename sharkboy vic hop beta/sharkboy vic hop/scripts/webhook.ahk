isValidWebhook(webhookUrl) {
    return RegExmatch(webhookUrl, "https://discord.com/api/webhooks/\d{17,19}")
}

sendWebhook(message, ss := false, ping := false) {
    static http := ComObject("WinHttp.WinHttpRequest.5.1")  
    static webhookUrl := IniRead(settingsPath, "Settings", "Webhook", "")
    static userID := IniRead(settingsPath, "Settings", "User ID", "")
    
    if !isValidWebhook(webhookUrl)
        return
    
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    pingContent := ping ? '"content":"<@' userID '>", ' : ""
    
    if ss {
        pBitmap := Gdip_BitmapFromScreen()
        Gdip_SaveBitmapToFile(pBitmap, A_Temp "\s.png")
        Gdip_DisposeImage(pBitmap)
        
        data := CreateFormData(Map(
            "payload_json", '{' pingContent '"embeds":[{"description":"' message '","color":16750848,"author":{"name":"Sharkboy Vic Hop","icon_url":"https://cdn.discordapp.com/attachments/1168276165119709198/1322630664125677639/sharkboyvichop.png"},"thumbnail":{"url":"https://cdn.discordapp.com/attachments/1168276165119709198/1322630664125677639/sharkboyvichop.png"},"image":{"url":"attachment://s.png"},"footer":{"text":"' timestamp '"}}]}',
            "file", "@" A_Temp "\s.png"
        ))
        
        http.Open("POST", webhookUrl, 1), http.SetRequestHeader("Content-Type", data.contentType), http.Send(data.body)
        FileDelete(A_Temp "\s.png")
    } else {
        http.Open("POST", webhookUrl, 1), http.SetRequestHeader("Content-Type", "application/json")
        http.Send('{' pingContent '"embeds":[{"description":"' message '","color":16750848,"author":{"name":"Sharkboy Vic Hop","icon_url":"https://cdn.discordapp.com/attachments/1168276165119709198/1322630664125677639/sharkboyvichop.png"},"thumbnail":{"url":"https://cdn.discordapp.com/attachments/1168276165119709198/1322630664125677639/sharkboyvichop.png"},"footer":{"text":"' timestamp '"}}]}')
    }
}

CreateFormData(formData) {
    boundary := "boundary" Random(1000000, 9999999), buf := Buffer()
    
    for k, v in formData {
        if v ~= "^@" {
            file := FileOpen(LTrim(v, "@"), "r")
            AddStr "--" boundary '`r`nContent-Disposition: form-data; name="' k '"; filename="s.png"`r`nContent-Type: image/png`r`n`r`n'
            AddFile(file), AddStr("`r`n")
        } else AddStr "--" boundary '`r`nContent-Disposition: form-data; name="' k '"`r`n`r`n' v "`r`n"
    }
    AddStr "--" boundary "--"
    
    return {body: SafeArrayFromBuffer(buf), contentType: "multipart/form-data; boundary=" boundary}
    
    AddStr(str) => (oldSize:=buf.Size, buf.Size+=strSize:=StrPut(str,"UTF-8")-1, StrPut(str,buf.Ptr+oldSize,strSize,"UTF-8"))
    AddFile(file) => (oldSize:=buf.Size, buf.Size+=file.Length, file.Pos:=0, file.RawRead(buf.ptr+oldSize,file.Length))
    SafeArrayFromBuffer(buf) => (arr:=ComObjArray(0x11,buf.Size), DllCall("RtlMoveMemory","Ptr",NumGet(ComObjValue(arr),8+A_PtrSize,"Ptr"),"Ptr",buf,"Ptr",buf.Size), arr)
}
