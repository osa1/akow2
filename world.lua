require("swarm")

World = {}

function World:new(lvl)
    object = {}

    local level = lvl or 1

    object.width = 32
    object.height = 20
    object.scale = 3
    object.baseImg = love.image.newImageData("levels/lvl"..level.."col.png")
    object.overImg = love.graphics.newImage("levels/lvl"..level.."over.png")
    object.overImg:setFilter("nearest", "nearest")

    object.doorXPos = love.graphics.getWidth()/2
    object.doorYPos = love.graphics.getHeight()/2

    object.gfxNormal = love.graphics.newImage("levels/nullbox.png")
    object.gfxNormal:setFilter("nearest", "nearest")
    object.gfxTop = love.graphics.newImage("levels/grassbox.png")
    object.gfxTop:setFilter("nearest", "nearest")
    object.gfxUnder = love.graphics.newImage("levels/underbox.png")
    object.gfxUnder:setFilter("nearest", "nearest")
    object.gfxStrand = love.graphics.newImage("levels/strandbox.png")
    object.gfxStrand:setFilter("nearest", "nearest")
    object.gfxPillar = love.graphics.newImage("levels/pillarbox.png")
    object.gfxPillar:setFilter("nearest", "nearest")
    object.gfxBack = love.graphics.newImage("levels/backbox.png")
    object.gfxBack:setFilter("nearest", "nearest")
    object.gfxDoor = love.graphics.newImage("levels/doorbox.png")
    object.gfxDoor:setFilter("nearest", "nearest")

    setmetatable(object, self)
    self.__index = self
    return object
end

function World:draw()
    r, g, b, a = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255, 255)
    for x = 0, self.width-1 do
        for y = 0, self.height-1 do
            red, green, blue, alpha = self.baseImg:getPixel(x, y)
            if red == 255 and green == 0 and blue == 0 then
                love.graphics.draw(self.gfxNormal, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            elseif red == 0 and green == 255 and blue == 0 then
                love.graphics.draw(self.gfxTop, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            elseif red == 255 and green == 255 and blue == 0 then
                love.graphics.draw(self.gfxUnder, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            elseif red == 0 and green == 255 and blue == 255 then
                love.graphics.draw(self.gfxStrand, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            elseif red > 120 and red < 135 and green == 0 and blue > 120 and blue < 135 then
                love.graphics.draw(self.gfxPillar, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            elseif red == 255 and green == 255 and blue == 255 then
                self.doorXPos = x*8*self.scale
                self.doorYPos = y*8*self.scale
                doorExists = true
                if mobsLeftOnMap == 0 then
                    love.graphics.draw(self.gfxDoor, x*8*self.scale, y*8*self.scale, 0, 3, 3)
                else
                    love.graphics.draw(self.gfxBack, x*8*self.scale, y*8*self.scale, 0, 3, 3)
                end
            else
                love.graphics.draw(self.gfxBack, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            end
        end
    end

    swarm:draw()
    if self.overImg == false then
        -- nothing
    else
        love.graphics.draw(self.overImg, 1, 1, 0, 3, 3)
    end

    love.graphics.setColor(r, g, b, a)
end

function World:update(dt)

end

function World:positionPlayer()
    for x = 0, self.width-1 do
        for y = 0, self.height-1 do
            red, green, blue, alpha = self.baseImg:getPixel(x, y)
            if red == 255 and green == 0 and blue == 255 then
                player.xPos = x*8*self.scale+12
                player.yPos = y*8*self.scale
            end
        end
    end
end

function World:checkCollide(xVal, yVal)
    local x = math.floor(xVal/3/8)
    local y = math.floor(yVal/3/8)

    if x < self.baseImg:getWidth() and y < self.baseImg:getHeight() and x >= 0 and y >= 0 then
        red, green, blue, alpha = self.baseImg:getPixel(x, y)
        if red+green > 0 and blue == 0 then
            return true
        else
            return false
        end
    else
        return false
    end
end
