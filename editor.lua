require("gui/tilepanel")

Editor = {}

function Editor:new(lvl)
    local object = {}

    local level = lvl or 1

    object.world = World:new(level)
    -- FIXME
    world = object.world

    object.tilePanel = TilePanel:new(50, 50)

    object.drawEnabled = false

    setmetatable(object, self)
    self.__index = self
    return object
end

function Editor:saveBaseImgData(filePath)
    self.world.baseImg:encode(filePath, "png")
end

function Editor:update(dt)
    if self.drawEnabled then
        local x = love.mouse.getX()
        local y = love.mouse.getY()
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
    self.tilePanel:update(dt)
end

function Editor:draw()
    self.world:draw()

    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    local sx, sy = world:getTilePos(mouseX, mouseY)
    local r, g, b, c = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255, 40)
    love.graphics.rectangle("fill", sx, sy, 8*world.scale, 8*world.scale)
    love.graphics.setColor(r, g, b, a)

    self.tilePanel:draw()
end

function Editor:mousepressed(x, y, button)
    if not self.tilePanel:mousepressed(x, y, button) then
        if selectedTile then
            self.drawEnabled = true
        end
    end
end

function Editor:mousereleased(x, y, button)
    self.tilePanel:mousereleased(x, y, button)
    self.drawEnabled = false
end
