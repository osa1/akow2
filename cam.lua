Cam = {}

function Cam:new(width, height, mapWidth, mapHeight)
    object = {}
    object.width = width
    object.height = height
    object.mapWidth = mapWidth
    object.mapHeight = mapHeight
    object.lockedId = nil
    -- top left corner
    object.x = 0
    object.y = 0

    setmetatable(object, self)
    self.__index = self

    return object
end


function Cam:lock(entity)
    self.lockedId = entity
end

function Cam:update(dt)
    if self.lockedId then
        if self.lockedId.xPos + self.width/2 > self.mapWidth then
            self.x = self.mapWidth - self.width
        elseif self.lockedId.xPos - self.width/2 < 0 then
            self.x = 0
        else
            self.x = self.lockedId.xPos - self.width/2
        end

        if self.lockedId.yPos + self.height/2 > self.mapHeight then
            self.y = self.mapHeight - self.height
        elseif self.lockedId.yPos - self.height/2 < 0 then
            self.y = 0
        else
            self.y = self.lockedId.yPos - self.height/2
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
