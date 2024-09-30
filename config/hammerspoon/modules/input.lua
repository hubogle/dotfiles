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
	["ru.keepcoder.Telegram"] = "Chinese",
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
		if input == "Chinese" then
			Chinese()
		elseif input == "English" then
			English()
		end
	end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()


-- shift 单击轻按切换输入法
send_space = false
last_mods = {}

shift_key_timer = hs.timer.delayed.new(0.3, function()
	send_space = false
end)

shift_handler = function(evt)
	local new_mods = evt:getFlags()
	if last_mods["shift"] == new_mods["shift"] then
		return false
	end
	if not last_mods["shift"] then
		last_mods = new_mods
		send_space = true
		shift_key_timer:start()
	else
		if send_space then
			hs.eventtap.keyStroke({ "ctrl", "alt" }, "space")
		end
		last_mods = new_mods
		shift_key_timer:stop()
	end
	return false
end

shift_tap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, shift_handler)
shift_tap:start()
