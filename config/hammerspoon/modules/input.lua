-- 设置App对应的输入法
local App2Ime = {
    ['/System/Library/CoreServices/Finder.app'] = 'Chinese',
    ['/Applications/WeChat.app'] = 'Chinese',
    ['/Applications/Hammerspoon.app'] = 'English',
    ['/Applications/Visual Studio Code.app'] = 'English',
    ['/Applications/企业微信.app'] = 'Chinese',
    ['/Applications/Telegram.app'] = 'Chinese',
    ['/Applications/Preview.app'] = 'Chinese',
    ['/Applications/Microsoft Word.app'] = 'Chinese',
    ['/Applications/Microsoft Excel.app'] = 'Chinese',
    ['/Applications/Microsoft PowerPoint.app'] = 'Chinese',
    ['/System/Applications/Music.app'] = 'Chinese',
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
}

local function Chinese()
	hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
  end

local function English()
	hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

function updateFocusAppInputMethod()
    local appPath = hs.window.frontmostWindow():application():path()
    if App2Ime[appPath] == 'Chinese' then
        Chinese()
    else
        English()
    end
end

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
