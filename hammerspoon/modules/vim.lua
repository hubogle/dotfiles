-- 按键

hs.hotkey.bind({"ctrl"}, "H", function()
  hs.eventtap.keyStroke({},'left',0);
end,nil,function()
  hs.eventtap.keyStroke({},'left',0);
end);

hs.hotkey.bind({"ctrl"}, "K", function()
  hs.eventtap.keyStroke({},'down',0);
end,nil,function()
  hs.eventtap.keyStroke({},'down',0);
end);

hs.hotkey.bind({"ctrl"}, "J", function()
  hs.eventtap.keyStroke({},'up',0);
end,nil,function()
  hs.eventtap.keyStroke({},'up',0);
end);

hs.hotkey.bind({"ctrl"}, "L", function()
  hs.eventtap.keyStroke({},'right',0);
end,nil,function()
  hs.eventtap.keyStroke({},'right',0);
end);
