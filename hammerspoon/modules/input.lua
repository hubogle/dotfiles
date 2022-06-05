k = require("hs.keycodes")

-- 设置App对应的输入法
local App2Ime = {
	{'/System/Library/CoreServices/Finder.app', 'Chinese'},
	{'/Applications/WeChat.app', 'Chinese'},
	{'/Applications/QQ.app', 'Chinese'},
	{'/Applications/企业微信.app', 'Chinese'},
	{'/Applications/Telegram.app', 'Chinese'},
	{'/Applications/Preview.app', 'Chinese'},
	{'/Applications/Microsoft Word.app', 'Chinese'},
	{'/Applications/Microsoft Excel.app', 'Chinese'},
	{'/Applications/Microsoft PowerPoint.app', 'Chinese'},
	{'/System/Applications/Music.app', 'Chinese'},
	{'/Applications/Safari.app', 'English'},
	{'/Applications/Google Chrome.app', 'English'},
    {"/Applications/Alacritty.app", 'English'},
    {"/Applications/PyCharm.app", 'English'},
    {"/Applications/DataGrip.app", 'English'},
    {"/Applications/GoLand.app", 'English'},
    {"/Applications/VimR.app", 'English'},
    {"/Applications/Paw.app", 'English'},
    {"/Applications/Visual Studio Code.app", 'English'},
	{'/Applications/Utilities/Terminal.app', 'English'},
	{'/System/Library/CoreServices/Spotlight.app', 'English'},
	{'/Applications/Hammerspoon.app', 'English'},
	{'/Applications/Visual Studio Code.app', 'English'},
	{'/Applications/System Preferences.app', 'English'},
}

-- 记录App输入法状态
function imeStash()
	local imehistory = {}
	currentapp = hs.window.frontmostWindow():application():path()
	local currentime = k.currentSourceID()
	if #imehistory > 50 then
		table.remove(App2Ime)
	end
	local imetable = {currentapp, currentime}
	local exist = false
	for idx,val in ipairs(App2Ime) do
		if val[1] == currentapp then
			exist = true
		end
	end
	if exist == false then
		table.insert(App2Ime, imetable)
	end
	return App2Ime
end
-- 自动切换输入法
function updateFocusAppInputMethod()
	if hs.window.frontmostWindow() ~= nil then
		if hs.window.frontmostWindow():application() ~= nil then
			focusAppPath = hs.window.frontmostWindow():application():path()
		end
	end
	for index, app in pairs(imeStash()) do
		local appPath = app[1]
		local expectedIme = app[2]
		if focusAppPath == appPath then
			ime = expectedIme
			break
		end
	end
	if ime == 'English' then
		k.currentSourceID("com.apple.keylayout.ABC")
	elseif ime == 'Chinese' then
		k.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
	end
end
-- 监视App启动或终止并切换输入法成对应方式
function applicationWatcher(appName, eventType, appObject)
	if (eventType == hs.application.watcher.activated) then
		updateFocusAppInputMethod()
	end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
