movement = {"alt", "ctrl"}


function moveFrame(frame, offsetX, offsetY) 
    frame.x = frame.x + offsetX
    frame.y = frame.y + offsetY
end

function moveCurrentWindow(offsetX, offsetY)
    local window = hs.window.focusedWindow()
    if window ~= nil then
        local frame = window:frame()
        moveFrame(frame, offsetX, offsetY)
        window:setFrame(frame)
    end
end

-- 左移动
hs.hotkey.bind(movement, "h", function()
    moveCurrentWindow(-100, 0)
end)

-- 右移动
hs.hotkey.bind(movement, "l", function()
    moveCurrentWindow(100, 0)
end)

-- 上移动
hs.hotkey.bind(movement, "k", function()
    moveCurrentWindow(0, -100)
end)

-- 下移动
hs.hotkey.bind(movement, "j", function()
    moveCurrentWindow(0, 100)
end)


