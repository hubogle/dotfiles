
function airpods(deviceId)
    cmd = "/usr/local/bin/blueutil --connect "..(deviceId)
    os.execute(cmd) -- 直接执行 shell
    --result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))   -- 调用 applescript 执行命令
    builtDevice = hs.audiodevice.findOutputByName("Mac mini扬声器")    -- 获取系统内置输出
    builtDevice:setOutputMuted(true)    -- 设置静音
    builtDevice:setOutputVolume(0)  -- 设置输出音量

    infoList = hs.battery.privateBluetoothBatteryInfo()     -- 获取所有外接蓝牙
    for __, info in pairs(infoList) do
        if info["address"] == deviceId then -- 获取蓝牙耳机
            airPodsDevice = hs.audiodevice.findDeviceByName(info["name"]) -- 获取设备
            flag = flase
            if airPodsDevice ~= nil then
                airPodsDevice:setDefaultOutputDevice()  -- 设置输出音量为 airPro
                outPutName = hs.audiodevice.defaultOutputDevice():name()    -- 目前输出设备名称
                if outPutName == "Airc Pro" then
                    flag = true
                end
            end

            message = "L:"..tostring(info["batteryPercentLeft"]).." R:"..tostring(info["batteryPercentRight"])
            caseInfo = info["batteryPercentCase"]   -- 盒子🔋

            hs.alert.closeSpecific(showUUID)    -- 关闭重复提示
            if caseInfo ~= "0" then
                message = message.." Case:"..caseInfo
            end

            if flag == nil then
                message = message .. " outPut: No"
            end

            showUUID = hs.alert.show(message, 0.6)
            return true
        end
    end
end

-- 链接 AirPods 并显示电量
-- 内置输出名称 Built-in Output
-- 当连接 AirPods 时设置系统输出音量为静音
hs.hotkey.bind({"alt"}, 'A', nil, function()
    local ok = airpods("e4-90-fd-1d-d9-41")     -- blueutil --recent 耳机 UID 查询
    hs.alert.closeSpecific(showUUID1)
    if ok ~= true then
        showUUID1 = hs.alert.show("Couldn't connect to AirPods!")
    end
end)
