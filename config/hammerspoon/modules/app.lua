function open(appBundleID)
    return function()
        local app = hs.application.frontmostApplication()
        if app ~= nil and app:bundleID() == appBundleID then
            -- 不为空并且置顶，隐藏
            app:hide()
        else
            -- 启动或激活
            hs.application.launchOrFocusByBundleID(appBundleID)
        end
    end
end

-- osascript -e 'id of app "VimR"'
-- 获取包名
hs.hotkey.bind({ "alt", "shift" }, "W", open "com.tencent.WeWorkMac")
hs.hotkey.bind({ "cmd", "alt" }, ",", open "com.apple.systempreferences")
hs.hotkey.bind({ "alt" }, "E", open "com.apple.finder")
hs.hotkey.bind({ "cmd" }, "'", open "org.alacritty")
hs.hotkey.bind({ "alt" }, "W", open "com.tencent.xinWeChat")
hs.hotkey.bind({ "alt" }, "V", open "com.microsoft.VSCode")
hs.hotkey.bind({ "alt" }, "T", open "ru.keepcoder.Telegram")
hs.hotkey.bind({ "alt" }, "U", open "com.linnk.Linnk")
hs.hotkey.bind({ "alt" }, "G", open "com.openai.chat")

-- hs.hotkey.bind({ "cmd" }, "M", function ()
--   hs.window.frontmostWindow():application():hide()
-- end) -- cmd + m 隐藏窗口

function alacritty_with_tmux_main()
    local applescript = [[
    tell application "Finder"
      try
        if exists window 1 then
          set currentPath to (POSIX path of (target of window 1 as alias))
        else
          set currentPath to (POSIX path of (path to desktop folder as alias))
        end if
      on error
        set currentPath to (POSIX path of (path to desktop folder as alias))
      end try
    end tell
  ]]

    local success, result, error = hs.osascript.applescript(applescript)
    if success then
        local dirPath = result
        local _, status, _, rc = hs.execute("tmux has-session -t main 2>/dev/null", true)
        if not status then
            hs.execute("tmux new-session -d -s main -c ~", true)
            hs.execute("tmux send-keys -t main:1 'cd \"" .. dirPath .. "\" && clear' C-m", true)
        else
            hs.execute('tmux new-window -t main -c "' .. dirPath .. '"', true)
        end
        hs.application.launchOrFocus "Alacritty"
    else
        hs.alert.show("Failed to get path from Finder: " .. tostring(error))
    end
end

hs.hotkey.bind({ "cmd", "alt" }, ".", alacritty_with_tmux_main)
