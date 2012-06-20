Cam = {}

function Cam:new(width, height, mapWidth, mapHeight)
    object = {}
    object.width = width
    object.height = height
    object.mapWidth = mapWidth
    object.mapHeight = mapHeight
    object.lock = nil
    -- top left corner
    object.x = 0
    object.y = 0

    setmetatable(object, self)
    self.__index = self

    return object
end


function Cam:lock(entity)
    self.lock = entity
end

function Cam:update(dt)
    if self.lock then
        if self.lock.x + self.width/2 > self.mapWidth then
            self.x = self.mapWidth - self.width
        else
            self.x = self.lock.x - self.width/2
        end
        if self.lock.y + self.height/2 > self.mapHeight then
            self.y = self.mapHeight - self.height
        else
            self.y = self.lock.y - self.height/2
        end
    end
end

function Cam:draw()
    -- for testing purposes
    -- draw a rect around the cam
    love.graphics.line(self.x, self.y, self.x+self.width, self.y)
    love.graphics.line(self.x, self.y, self.x, self.y+self.height)
    love.graphics.line(self.x+self.width, self.y+self.height, self.x+self.width, self.y)
    love.graphics.line(self.x+self.width, self.y+self.height, self.x, self.y+self.height)
end
