-- 设置App对应的输入法
local App2Ime = {
    ['/Applications/WeChat.app'] = 'Chinese',
    ['/Applications/企业微信.app'] = 'Chinese',
    ['/Applications/Telegram.app'] = 'Chinese',
    ['/Applications/Preview.app'] = 'Chinese',
    ['/Applications/Microsoft Word.app'] = 'Chinese',
    ['/Applications/Microsoft Excel.app'] = 'Chinese',
    ['/Applications/Microsoft PowerPoint.app'] = 'Chinese',
    ['/System/Applications/Music.app'] = 'English',
    ['/System/Library/CoreServices/Finder.app'] = 'English',
    ['/Applications/Safari.app'] = 'English',
    ['/Applications/Google Chrome.app'] = 'English',
    ['/Applications/PyCharm.app'] = 'English',
    ['/Applications/DataGrip.app'] = 'English',
    ['/Applications/GoLand.app'] = 'English',
    ['/Applications/VimR.app'] = 'English',
    ['/Applications/Paw.app'] = 'English',
    ['/Applications/Utilities/Terminal.app'] = 'English',
    ['/System/Library/CoreServices/Spotlight.app'] = 'English',
    ['/Applications/Hammerspoon.app'] = 'English',
    ['/Applications/Visual Studio Code.app'] = 'English',
    ['/Applications/System Preferences.app'] = 'English',
    ['/Applications/Alacritty.app'] = 'English',
}
local app = nil

local AppNotHide = {
    ['/Applications/Visual Studio Code.app'] = true,
    ['/Applications/Alacritty.app'] = true,
    ['/Applications/GoLand.app'] = true,
    ['/Applications/PyCharm.app'] = true,
}
-- 将 esc 映射为隐藏 App，当处于 vim 模式则隐藏，只能判断 App 是否支持 VIM
local escKey = hs.hotkey.bind({}, "escape", function() app:hide() end)

local function Chinese()
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local function updateFocusAppInputMethod()
    local app_path = app:path()
    if App2Ime[app_path] == 'Chinese' then
        Chinese()
    else
        English()
    end
    if AppNotHide[app_path] == true then
        escKey:disable()
    else
        escKey:enable()
    end
end

local function applicationWatcher(appName, eventType, appObject)
    app = appObject
    if (eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
