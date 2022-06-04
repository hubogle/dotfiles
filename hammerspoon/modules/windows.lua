
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local layout = require "hs.layout"
hyper = {"ctrl", "alt"}
hyperShift = {"alt", "shift", "ctrl"}
--hyperCtrl = {"alt", "ctrl"}
hyperAlt = {"ctrl", "shift"}


window.animationDuration = 0

-- 左半
hotkey.bind(hyper, "Left", function()
  if window.focusedWindow() then
    window.focusedWindow():moveToUnit(layout.left50)
  else
    alert.show("No active window")
  end
end)

-- 右半
hotkey.bind(hyper, "Right", function()
  window.focusedWindow():moveToUnit(layout.right50)
end)

-- 上半
hotkey.bind(hyper, "Up", function()
  window.focusedWindow():moveToUnit'[0,0,100,50]'
end)

-- 下半
hotkey.bind(hyper, "Down", function()
  window.focusedWindow():moveToUnit'[0,50,100,100]'
end)

-- 左上
hotkey.bind(hyperAlt, "Left", function()
  window.focusedWindow():moveToUnit'[0,0,50,50]'
end)

-- 右下
hotkey.bind(hyperAlt, "Right", function()
  window.focusedWindow():moveToUnit'[50,50,100,100]'
end)

-- 右上
hotkey.bind(hyperAlt, "Up", function()
  window.focusedWindow():moveToUnit'[50,0,100,50]'
end)

-- 左下
hotkey.bind(hyperAlt, "Down", function()
  window.focusedWindow():moveToUnit'[0,50,50,100]'
end)

-- 全屏
hotkey.bind(hyper, 'return', function() 
  window.focusedWindow():toggleFullScreen()
end)

-- 窗口中心
hotkey.bind(hyper, 'C', function() 
  window.focusedWindow():centerOnScreen()
end)

-- 最大化窗口
hotkey.bind(hyper, 'M', function() toggle_maximize() end)


-- defines for window maximize toggler
local frameCache = {}
-- toggle a window between its normal size, and being maximized
function toggle_maximize()
    local win = window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end


-- 显示用于将焦点切换到每个窗口的键盘提示
hotkey.bind(hyperShift, '/', function()
    hints.windowHints()
    -- Display current application window
    -- hints.windowHints(hs.window.focusedWindow():application():allWindows())
end)

-- 切换活动窗口
hotkey.bind(hyperShift, "H", function()
  window.switcher.nextWindow()
end)

-- 移动活动窗口到上个显示器
hotkey.bind(hyperShift, "Left", function()
  window.focusedWindow():moveOneScreenWest()
end)

hotkey.bind(hyperShift, "Right", function()
  window.focusedWindow():moveOneScreenEast()
end)

-- 移动光标到上个显示器
--hotkey.bind(hyperCtrl, "Left", function ()
--  focusScreen(window.focusedWindow():screen():previous())
--end)

--hotkey.bind(hyperCtrl, "Right", function ()
--  focusScreen(window.focusedWindow():screen():next())
--end)


--Predicate that checks if a window belongs to a screen
function isInScreen(screen, win)
  return win:screen() == screen
end

function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = fnutils.filter(
      window.orderedWindows(),
      fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()

  -- 将光标移到屏幕中心
  local pt = geometry.rectMidPoint(screen:fullFrame())
  mouse.setAbsolutePosition(pt)
end

-- maximized active window and move to selected monitor
moveto = function(win, n)
  local screens = screen.allScreens()
  if n > #screens then
    alert.show("Only " .. #screens .. " monitors ")
  else
    local toWin = screen.allScreens()[n]:name()
    alert.show("Move " .. win:application():name() .. " to " .. toWin)

    layout.apply({{nil, win:title(), toWin, layout.maximized, nil, nil}})
    
  end
end

-- 将光标移动到监视器1并最大化窗口
hotkey.bind(hyperShift, "1", function()
  local win = window.focusedWindow()
  moveto(win, 1)
end)

hotkey.bind(hyperShift, "2", function()
  local win = window.focusedWindow()
  moveto(win, 2)
end)
