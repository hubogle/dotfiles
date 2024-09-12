-- 设置App对应的输入法
local App2Ime = {
	["org.hammerspoon.Hammerspoon"] = "English",
	["org.alacritty"] = "English",
	["com.apple.Terminal"] = "English",
	["com.microsoft.VSCode"] = "English",
	["com.apple.Safari"] = "English",
	["com.microsoft.edgemac"] = "English",
	["com.google.Chrome"] = "English",
	["com.apple.systempreferences"] = "English",
	["com.apple.finder"] = "English",
	["com.tencent.xinWeChat"] = "Chinese",
	["com.tencent.WeWorkMac"] = "Chinese",
}

local function Chinese() -- 中文
	local flag = hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
	if not flag then
		hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
	end
end

local function English() -- 英文
	hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local function applicationWatcher(appName, eventType, appObject)
	if eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched then -- 切换窗口或首次启动时
		local input = App2Ime[appObject:bundleID()]
		if input then
			if input == "Chinese" then
				Chinese()
			else
				English()
			end
		end
	end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
