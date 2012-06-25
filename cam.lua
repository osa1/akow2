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
        elseif self.lock.x - self.width/2 < 0 then
            self.x = 0
        else
            self.x = self.lock.x - self.width/2
        end

        if self.lock.y + self.height/2 > self.mapHeight then
            self.y = self.mapHeight - self.height
        elseif self.lock.y - self.height/2 < 0 then
            self.y = 0
        else
            self.y = self.lock.y - self.height/2
        end
    end
    --print("cam.x", self.x, "cam.y", self.y)
end

function Cam:draw()
    -- for testing purposes
    -- draw a rect around the cam
    love.graphics.line(self.x, self.y, self.x+self.width, self.y)
    love.graphics.line(self.x, self.y, self.x, self.y+self.height)
    love.graphics.line(self.x+self.width, self.y+self.height, self.x+self.width, self.y)
    love.graphics.line(self.x+self.width, self.y+self.height, self.x, self.y+self.height)
end
