local quitModal = hs.hotkey.modal.new('cmd', 'q', "Press Cmd+Q again to quit")

function quitModal:entered()
    hs.timer.doAfter(1, function() quitModal:exit() end)
end

local function doQuit()
    local app = hs.application.frontmostApplication()
    app:kill()
    quitModal:exit()
end

quitModal:bind('cmd', 'q', doQuit)
quitModal:bind('', 'escape', function() quitModal:exit() end)
