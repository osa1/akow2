Tile = {}
tiles = {}
selectedTile = nil

Tile.gfxNormal = love.graphics.newImage("levels/nullbox.png")
Tile.gfxNormal:setFilter("nearest", "nearest")
Tile.gfxTop = love.graphics.newImage("levels/grassbox.png")
Tile.gfxTop:setFilter("nearest", "nearest")
Tile.gfxUnder = love.graphics.newImage("levels/underbox.png")
Tile.gfxUnder:setFilter("nearest", "nearest")
Tile.gfxStrand = love.graphics.newImage("levels/strandbox.png")
Tile.gfxStrand:setFilter("nearest", "nearest")
Tile.gfxPillar = love.graphics.newImage("levels/pillarbox.png")
Tile.gfxPillar:setFilter("nearest", "nearest")
Tile.gfxBack = love.graphics.newImage("levels/backbox.png")
Tile.gfxBack:setFilter("nearest", "nearest")
Tile.gfxDoor = love.graphics.newImage("levels/doorbox.png")
Tile.gfxDoor:setFilter("nearest", "nearest")

function Tile:new(name, image, imageDataColor)
    local object = {}
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


