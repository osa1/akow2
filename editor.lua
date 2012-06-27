require("gui/tilepanel")

Editor = {}

function Editor:new(lvl)
    local object = {}

    local level = lvl or 1

    object.world = World:new(level)
    -- FIXME
    world = object.world

    object.tilePanel = TilePanel:new(50, 50)

    setmetatable(object, self)
    self.__index = self
    return object
end

function Editor:saveBaseImgData(filePath)
    self.world.baseImg:encode(filePath, "png")
end

function Editor:update(dt)
    self.tilePanel:update(dt)
end

function Editor:draw()
    love.graphics.push()
    love.graphics.translate(-cam.x, -cam.y)
    self.world:draw()
    -- cam:draw()
    love.graphics.pop()
    self.tilePanel:draw()
end

function Editor:mousepressed(x, y, button)
    if not self.tilePanel:mousepressed(x, y, button) then
        if selectedTile then
            local imgx = math.floor((cam.x+x)/(self.world.scale*8))
            local imgy = math.floor((cam.y+y)/(self.world.scale*8))
            local color = selectedTile.imageDataColor
            if selectedTile.name == "player" then
                local r, g, b, a = self.world.baseImg:getPixel(imgx, imgy)
                if (r == 0 and g == 0 and b == 0) then
                    self.world.baseImg:setPixel(imgx, imgy, color.r, color.g, color.b, 0)
                end
            else
                self.world.baseImg:setPixel(imgx, imgy, color.r, color.g, color.b, 0)
            end
        end
    end
    print("selected tile", selectedTile)
end

function Editor:mousereleased(x, y, button)
    self.tilePanel:mousereleased(x, y, button)
end
