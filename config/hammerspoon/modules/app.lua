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
hs.hotkey.bind({ "cmd", "shift" }, "W", open("com.tencent.WeWorkMac"))
hs.hotkey.bind({ "cmd", "alt" }, ",", open("com.apple.systempreferences"))
hs.hotkey.bind({ "alt" }, "E", open("com.apple.finder"))
hs.hotkey.bind({ "cmd" }, ".", open("io.alacritty"))
hs.hotkey.bind({ "alt" }, "C", open("com.google.Chrome"))
hs.hotkey.bind({ "alt" }, ".", open("com.apple.Terminal"))
hs.hotkey.bind({ "alt" }, "M", open("com.qvacua.VimR"))
hs.hotkey.bind({ "alt" }, "V", open("com.microsoft.VSCode"))
hs.hotkey.bind({ "alt" }, "T", open("ru.keepcoder.Telegram"))
hs.hotkey.bind({ "alt" }, "P", open("com.luckymarmot.Paw"))
hs.hotkey.bind({ "alt" }, "S", open("com.sublimetext.4"))
hs.hotkey.bind({ "alt" }, "U", open("com.lukilabs.lukiapp"))
hs.hotkey.bind({ "alt" }, "W", open("com.tencent.xinWeChat"))

-- hs.hotkey.bind({ "cmd" }, "M", function ()
--   hs.window.frontmostWindow():application():hide()
-- end) -- cmd + m 隐藏窗口


-- 当前目录打开终端
function iterm()
  hs.osascript.applescript(
    [[
        tell application "Finder"
          set dir_path to quoted form of (POSIX path of (folder of the front window as alias))
        end tell
        -- 待执行命令
        set cd_cmd to "cd " & dir_path
        -- 打开 iterm
        tell application "iTerm"
          activate
          try
            tell current session of first window
              write text cd_cmd
            end tell
          on error
            create window with profile "Default" command cd_cmd
          end try
        end tell
    ]]
  )
  hs.application.launchOrFocus("iTerm")
end

function terminal()
  hs.osascript.applescript(
    [[
        tell application "Finder"
          set dir_path to quoted form of (POSIX path of (folder of the front window as alias))
        end tell
        -- 待执行命令
        -- 打开 iterm
        tell application "Terminal"
          activate
          set cd_cmd to "cd " & dir_path
          try
            set sesh to current session of current terminal
          on error
            set currentWindow to (create window with default profile)
          end try
          -- try
          --   set sesh to current session of current terminal
          -- on error
          --   set term to (make new terminal)
          --   tell term
          --     launch session "Default"
          --     set sesh to current session
          --   end tell
          -- end try
          -- tell sesh
          --   write text "cd " & dir_path & ";clear;"
          -- end tell
        end tell
    ]]
  )
  hs.application.launchOrFocus("Terminal")
end

hs.hotkey.bind({ "cmd", "alt" }, ".", terminal)
