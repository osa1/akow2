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


