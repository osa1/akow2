Tile = {}
tiles = {}

function Tile:new(name, image, imageDataColor)
    object = {}
    object.name = name
    object.image = image
    object.imageDataColor = imageDataColor

    setmetatable(object, self)
    self.__index = self

    --table.insert(tiles, object)
    tiles.name = object
    return object
end

function Tile:drawToImageData(imageData, x, y)
    imageData:setPixel(x, y, self.imageDataColor.r, self.imageDataColor.g, self.imageDataColor.b, 0)
end

function Tile:draw(x, y, scale)
    love.graphics.draw(self.image, x*8*scale, y*8*scale, 0, 3, 3)
end


Editor = {}

function Editor:saveBaseImgData(filePath)

end

function Editor:new(lvl)
    object = {}

    local level = lvl or 1

    object.width = 32
    object.height = 20
    object.scale = 3
    object.baseImg = love.image.newImageData("levels/lvl"..level.."col.png")
    object.overImg = love.graphics.newImage("levels/lvl"..level.."over.png")
    object.overImg:setFilter("nearest", "nearest")
    object.overImgToggle = false

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

function Editor:draw(cam)
    r, g, b, a = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255, 255)
    
    startX = math.floor(cam.x/8/self.scale)
    endX = math.floor((cam.x+cam.width)/8/self.scale)
    startY = math.floor(cam.y/8/self.scale)
    endY = math.floor((cam.y+cam.height)/8/self.scale)

    for x=startX, endX do
        for y=startY, endY do
            if x < 0 or x >= self.width or y < 0 or y >= self.height then
                    love.graphics.draw(self.gfxBack, x*8*self.scale, y*8*self.scale, 0, self.scale, self.scale)
            else
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
                    love.graphics.draw(self.gfxDoor, x*8*self.scale, y*8*self.scale, 0, 3, 3)
                else
                    love.graphics.draw(self.gfxBack, x*8*self.scale, y*8*self.scale, 0, 3, 3)
                end
            end
        end
    end



    --[[for x = 0, self.width-1 do
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
                love.graphics.draw(self.gfxDoor, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            else
                love.graphics.draw(self.gfxBack, x*8*self.scale, y*8*self.scale, 0, 3, 3)
            end
        end
    end]]

    if self.overImg ~= false and self.overImgToggle == true then
        love.graphics.draw(self.overImg, 1, 1, 0, 3, 3)
    end

    love.graphics.setColor(r, g, b, a)
end
