Actor = {}

function Actor:new(x, y)
    object = {}

    object.xPos = x or 0
    object.yPos = y or 0
    object.xVel = 0
    object.yVel = 0
    object.dir = "r"

    object.type = "unset"
    object.collides = true
    object.ai = false
    object.isBouncy = false
    object.friction = 1100
    object.noWrap = false
    object.fps = 12
    object.hasLife = false
    object.life = 0

    object.maxSpeed = 250
    object.maxFall = 900
    object.inAir = true

    object.sprite = love.graphics.newImage("gfx/player.png")
    object.sprite:setFilter("nearest", "nearest")

    setmetatable(object, self)
    self.__index = self
    return object
end

function Actor:draw()
    r, g, b, a = love.graphics.getColor()

    local spriteSize = self.sprite:getHeight()
    local spriteNum = math.floor(self.sprite:getWidth()/spriteSize)
    love.graphics.setColor(255, 255 ,255, 255)
    love.graphics.setScissor(self.xPos-12, self.yPos-12, spriteSize*3, spriteSize*3)
    if self.dir == "l" then
        love.graphics.draw(self.sprite, math.floor(self.xPos)+12+(math.floor(self.fps*love.timer.getTime()%spriteNum)*24), math.floor(self.yPos)-12, 0, -3, 3)
    elseif self.dir == "r" then
        love.graphics.draw(self.sprite, math.floor(self.xPos)-12-(math.floor(self.fps*love.timer.getTime()%spriteNum)*24), math.floor(self.yPos)-12, 0, 3, 3)
    end

    love.graphics.setColor(r, g, b, a)
    love.graphics.setScissor()
end

function Actor:update(dt)
    -- AI movement
    if self.ai then
        if self.dir == "r" then
            self.xVel = self.maxSpeed
            if world:checkCollide(self.xPos+8, self.yPos+24+8) and not world:checkCollide(self.xPos+8, self.yPos) then
                self.xPos = self.xPos + self.xVel*dt
            else
                self.dir = "l"
            end
        else
            self.xVel = -self.maxSpeed
            if world:checkCollide(self.xPos-8, self.yPos+24+8) and not world:checkCollide(self.xPos-8, self.yPos) then
                self.xPos = self.xPos + self.xVel*dt
            else
                self.dir = "r"
            end
        end
    end

    -- Collision detection and movement
    local xPos = self.xPos
    local yPos = self.yPos

    self.yPos = self.yPos + (self.yVel * dt)
    self.yVel = self.yVel + (1150 * dt)
    if self.yVel > self.maxFall then self.yVel = self.maxFall end
    if math.abs(self.yVel) < 2 then
        self.yVel = 0
    end

    self.xPos = self.xPos + (self.xVel * dt)

    if math.abs(self.xVel) < 2 then
        self.xVel = 0
    end
    if self.xVel > 0 then
        if self.inAir then
            self.xVel = self.xVel - (self.friction * 0.65 * dt)
        else
            self.xVel = self.xVel - (self.friction * dt)
        end
    elseif self.xVel < 0 then
        if self.inAir then
            self.xVel = self.xVel + (self.friction * 0.65 * dt)
        else
            self.xVel = self.xVel + (self.friction * dt)
        end
    end

    -- Wrapping
    if not self.noWrap then
        if self.xPos > love.graphics.getWidth()-12 then self.xPos = self.xPos - love.graphics.getWidth()+24 end
        if self.xPos < 13 then self.xPos = self.xPos + love.graphics.getWidth()-24 end
        if self.yPos > love.graphics.getHeight()-12 then self.yPos = self.yPos - love.graphics.getHeight()+24 end
        if self.yPos < 13 then self.yPos = self.yPos + love.graphics.getHeight()-24 end
    end

    -- Collision
    if self.collides then
        for i = -8, 8 do
            if world:checkCollide(xPos+i, self.yPos+12) then
                self.yPos = yPos
                self.inAir = false
                if self.isBouncy then
                    self.yVel = (self.yVel * -1) * 0.5
                else
                    self.yVel = 0
                end
            end
        end

        for i = -8, 8 do
            if world:checkCollide(xPos+i, self.yPos-8) then
                self.yPos = yPos
                if self.isBouncy then
                    self.yVel = (self.yVel * -1) * 0.5
                else
                    self.yVel = 0
                end
            end
        end

        for i = -8, 12 do
            if world:checkCollide(self.xPos+8, yPos+i) or world:checkCollide(self.xPos-8, yPos+i) then
                self.xPos = xPos
                if self.isBouncy then
                    self.xVel = self.xVel * -1
                else
                    self.xVel = 0
                end
            end
        end
    end
end
