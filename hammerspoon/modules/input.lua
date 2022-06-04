--local ITABC = "com.apple.inputmethod.SCIM.ITABC"
local ITABC = "im.rime.inputmethod.Squirrel.Rime"
local ABC = "com.apple.keylayout.ABC"

local function Chinese()
    --os.execute("/opt/homebrew/bin/im-select com.apple.inputmethod.SCIM.ITABC")
    os.execute("/opt/homebrew/bin/im-select im.rime.inputmethod.Squirrel.Rime")
    --hs.keycodes.currentSourceID(ITABC)
end

local function English()
    --os.execute("/opt/homebrew/bin/im-select im.rime.inputmethod.Squirrel.Rime")
    os.execute("/opt/homebrew/bin/im-select com.apple.keylayout.ABC")
    --hs.keycodes.currentSourceID(ITABC)
end


local app2input = {
    ["/Applications/iTerm.app"] = "English",
    ["/Applications/Sublime Text.app"] = "English",
    ["/Applications/Safari.app"] = "English",
    ["/Applications/Utilities/Terminal.app"] = "English",
    ["/Applications/MacVim.app"] = "English",
    ["/Applications/Dash.app"] = "English",
    ["/Applications/Typora.app"] = "Chinese",
    ["/Applications/wpsoffice.app"] = "English",
    ["/Applications/PyCharm.app"] = "English",
    ["/Applications/DataGrip.app"] = "English",
    ["/Applications/Alacritty.app"] = "English",
    ["/System/Applications/TextEdit.app"] = "English",
    ["/Applications/Visual Studio Code.app"] = "English",
    ["/Applications/Visual Studio Code - Insiders.app"] = "English",
    ["/Applications/Utilities/Terminal.app"] = "English",
    ["/System/Applications/Utilities/Terminal.app"] = "English",
    ["/Applications/Navicat Premium.app"] = "English",
    ["/Applications/Google Chrome.app"] = "English",
    ["/Applications/Microsoft Edge.app"] = "English",
    ["/Applications/网易有道词典.app"] = "English",
    ["/System/Library/CoreServices/Finder.app"] = "English",
    ["/Applications/System Preferences.app"] = "English",
    ["/Applications/Paw.app"] = "English",
    ["/Applications/GoLand.app"] = "English",

    ["/Applications/WeChat.app"] = "Chinese",
    ["/Applications/企业微信.app"] = "Chinese",
    ["/Applications/Telegram.app"] = "Chinese",
    ["/Applications/MindNode.app"] = "Chinese",
}


-- 指定 App 对应输入法
function inputMethod(appPath)
    input = app2input[appPath]
    if input ~= nil then
        
        currentSourceID = hs.keycodes.currentSourceID() -- 当前输入法
        if input == "English" and currentSourceID == ABC then
            return
        elseif input == "Chinese" and currentSourceID == ITABC then
            return
        end
        if input == "English" then
            English()
            --hs.keycodes.currentSourceID(ABC)
        else
            Chinese()
            --hs.keycodes.currentSourceID(ITABC)
        end
    end
end


function applicationWatcher(appName, eventType, appObject)
    --if eventType == 5 then  -- hs.application.watcher.activate 值为 5
    if (eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched) then   
        inputMethod(appObject:path())
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()


