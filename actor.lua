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

    object.maxSpeed = 500
    object.maxFall = 900
    object.inAir = true

    object.height = 8
    object.width = 8

    -- required for wall-jump
    object.wallPos = nil
    object.maxWallFall = 50

    object.quads = {}
    for i=0,5 do
        table.insert(object.quads, love.graphics.newQuad(8*i, 0, 8, 8, 48, 8))
    end

    object.sprite = love.graphics.newImage("gfx/player.png")
    object.sprite:setFilter("nearest", "nearest")
    object.spriteSize = object.sprite:getHeight()

    object.leftWallSprite = love.graphics.newImage("gfx/playerleftwall.png")
    object.leftWallSprite:setFilter("nearest", "nearest")
    object.rightWallSprite = love.graphics.newImage("gfx/playerrightwall.png")
    object.rightWallSprite:setFilter("nearest", "nearest")

    setmetatable(object, self)
    self.__index = self
    return object
end

function Actor:draw()
    love.graphics.push()
    love.graphics.translate(-math.floor(cam.x), -math.floor(cam.y))

    local r, g, b, a = love.graphics.getColor()

    if not self.wallPos then
        if self.dir == "l" then
            love.graphics.drawq(self.sprite,
                self.quads[math.floor(self.fps*love.timer.getTime()%#self.quads)+1],
                self.xPos+(self.width/2)*world.scale,
                self.yPos-(self.height/2)*world.scale,
                0,
                -world.scale,
                world.scale)
        elseif self.dir == "r" then
            love.graphics.drawq(self.sprite,
                self.quads[math.floor(self.fps*love.timer.getTime()%#self.quads)+1],
                self.xPos-(self.width/2)*world.scale,
                self.yPos-(self.height/2)*world.scale,
                0,
                world.scale,
                world.scale)
        end
    else
        local sprite
        if self.wallPos == "l" then
            sprite = self.leftWallSprite
        else
            sprite = self.rightWallSprite
        end
        love.graphics.draw(sprite,
            self.xPos-(self.width/2)*world.scale,
            self.yPos-(self.height/2)*world.scale,
            0,
            world.scale,
            world.scale)
    end
    love.graphics.pop()
end

function Actor:update(dt)
    -- print("wall pos", self.wallPos)
    if dt >= 0.008 then
        self:update(0.007)
        self:update(dt-0.007)
        return
    end
    -- if dt >= 0.01 then
    --     self:update(0.009)
    --     self:update(dt-0.009)
    --     return
    -- end

    -- AI movement
    if self.ai then
        if self.dir == "r" then
            self.xVel = self.maxSpeed
            if world:checkCollide(self.xPos+self.width, self.yPos+self.height*world.scale+self.height)
                    and not world:checkCollide(self.xPos+self.width, self.yPos) then
                self.xPos = self.xPos + self.xVel*dt
            else
                self.dir = "l"
            end
        else
            self.xVel = -self.maxSpeed
            if world:checkCollide(self.xPos-self.width, self.yPos+self.height*world.scale+self.height)
                    and not world:checkCollide(self.xPos-self.width, self.yPos) then
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

    if self.wallPos then
        if self.yVel > self.maxWallFall then self.yVel = self.maxWallFall end
    else
        if self.yVel > self.maxFall then self.yVel = self.maxFall end
    end


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
    -- if not self.noWrap then
    --     if self.xPos > love.graphics.getWidth()-12 then self.xPos = self.xPos - love.graphics.getWidth()+24 end
    --     if self.xPos < 13 then self.xPos = self.xPos + love.graphics.getWidth()-24 end
    --     if self.yPos > love.graphics.getHeight()-12 then self.yPos = self.yPos - love.graphics.getHeight()+24 end
    --     if self.yPos < 13 then self.yPos = self.yPos + love.graphics.getHeight()-24 end
    -- end

    -- Collision

    -- if self.collides then
    --     for i = -8, 8 do
    --         if world:checkCollide(xPos+i, self.yPos+12) then
    --             self.yPos = yPos
    --             self.inAir = false
    --             if self.isBouncy then
    --                 self.yVel = (self.yVel * -1) * 0.5
    --             else
    --                 self.yVel = 0
    --             end
    --         end
    --     end

    --     for i = -8, 8 do
    --         if world:checkCollide(xPos+i, self.yPos-8) then
    --             self.yPos = yPos
    --             if self.isBouncy then
    --                 self.yVel = (self.yVel * -1) * 0.5
    --             else
    --                 self.yVel = 0
    --             end
    --         end
    --     end

    --     for i = -8, 12 do
    --         if world:checkCollide(self.xPos+8, yPos+i) or world:checkCollide(self.xPos-8, yPos+i) then
    --             self.xPos = xPos
    --             if self.isBouncy then
    --                 self.xVel = self.xVel * -1
    --             else
    --                 self.xVel = 0
    --             end
    --         end
    --     end
    -- end


    if self.collides then
        for i = -self.width, self.width do
            if world:checkCollide(xPos+i, self.yPos+(1.5*self.height)) then
                self.yPos = yPos
                self.inAir = false
                if self.isBouncy then
                    self.yVel = (self.yVel * -1) * 0.5
                else
                    self.yVel = 0
                end
            end
        end

        for i = -self.width, self.width do
            if world:checkCollide(xPos+i, self.yPos-self.height) then
                self.yPos = yPos
                if self.isBouncy then
                    self.yVel = (self.yVel * -1) * 0.5
                else
                    self.yVel = 0
                end
            end
        end

        self.wallPos = nil
        for i = -self.height, 1.5*self.height do
            -- if world:checkCollide(self.xPos+self.width, yPos+i) or
            --         world:checkCollide(self.xPos-self.width, yPos+i) then
            local collided = false
            if world:checkCollide(self.xPos+self.width, yPos+i) then
                collided = true
                self.wallPos = "r"
            elseif world:checkCollide(self.xPos-self.width, yPos+i) then
                collided = true
                self.wallPos = "l"
            end

            if collided then
                self.xPos = xPos
                if self.isBouncy then
                    self.xVel = self.xVel * -1
                else
                    self.xVel = 0
                end
            end
        end

        if self.wallPos and love.keyboard.isDown("up") then
            -- lol, I liked this setting, shuold record a vid while this is on
            -- self.yVel = -self.maxFall
            self.yVel = -self.maxFall/2
            sfx:play("jump")
            if self.wallPos == "l" then
                print("right")
                self.xVel = self.maxSpeed
            else
                print("left")
                self.xVel = -self.maxSpeed
            end
        end
    end
end

function Actor:jump()
    if not self.inAir then
        sfx:play("jump")
        self.yVel = -375
        self.inAir = true
    else
        if self.wallPos then
            -- print("accelerating")
            if self.wallPos == "l" then
                self.xVel = -self.maxSpeed
            else
                self.xVel = self.maxSpeed
            end
        end
    end
end
