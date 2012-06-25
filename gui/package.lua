require("gui/fadingtext")
require("gui/toolkit")
require("gui/tilepanel")

gui = {}
activeGUIs = {}

gui.FadingText = FadingText
gui.Panel = Panel

gui.newPanel = function (...)
    local p = Panel:new(...)
    table.insert(activeGUIs, p)
    return p
end

gui.newFadingText = function (...)
    local t = FadingText:new(...)
    table.insert(activeGUIs, t)
    return t
end

gui.newTilePanel = function (...)
    local t = TilePanel:new(...)
    table.insert(activeGUIs, t)
    return t
end
