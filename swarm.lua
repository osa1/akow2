Swarm = {}

function Swarm:new()
    object = {}

    object.entities = {}

    setmetatable(object, self)
    self.__index = self
    return object
end

function Swarm:init()
    local i = 1
    for x = 0, 31 do
        for y = 0, 19 do
            red, green, blue, alpha = world.baseImg:getPixel(x, y)
            if red == 0 and green == 0 and blue == 255 then
                self.entities[i] = Actor:new(x*8*3+12, y*8*3+10)
                self.entities[i].type = "bug"
                self.entities[i].ai = true
                self.entities[i].maxSpeed = 15
                self.entities[i].sprite = love.graphics.newImage("gfx/enbug.png")
                self.entities[i].sprite:setFilter("nearest", "nearest")
                self.entities[i].fps = 6 + math.random(1, 3)
                i = i + 1
            end
        end
    end
    return i-1
end

function Swarm:add(x, y, xvel, yvel, objType)
    self.entities[#self.entities+1] = Actor:new(x, y)
    self.entities[#self.entities].xVel = xvel
    self.entities[#self.entities].yVel = yvel

    if objType == "bomb" then
        self.entities[#self.entities].type = "bomb"
        self.entities[#self.entities].hasLife = true
        self.entities[#self.entities].life = 3
        self.entities[#self.entities].inAir = true
        self.entities[#self.entities].fps = 8 + math.random(1, 3)
        self.entities[#self.entities].isBouncy = true
        self.entities[#self.entities].friction = 500
        self.entities[#self.entities].sprite = love.graphics.newImage("gfx/ball.png")
        self.entities[#self.entities].sprite:setFilter("nearest", "nearest")
    elseif objType == "smoke" then
        self.entities[#self.entities].collides = false
        self.entities[#self.entities].noWrap = true
        self.entities[#self.entities].hasLife = true
        self.entities[#self.entities].life = 0.1 + (math.random(1, 10)/50)
        if(math.random(1, 6) > 1) then
            self.entities[#self.entities].sprite = love.graphics.newImage("gfx/smoke.png")
        else
            self.entities[#self.entities].sprite = love.graphics.newImage("gfx/fire.png")
        end
        self.entities[#self.entities].sprite:setFilter("nearest", "nearest")
    elseif objType == "glitter" then
        self.entities[#self.entities].collides = true
        self.entities[#self.entities].noWrap = true
        self.entities[#self.entities].hasLife = true
        self.entities[#self.entities].life = 0.1 + (math.random(1, 10)/10)
        self.entities[#self.entities].friction = 100
        self.entities[#self.entities].sprite = love.graphics.newImage("gfx/glitter.png")
        self.entities[#self.entities].sprite:setFilter("nearest", "nearest")
    elseif objType == "blood" then
        self.entities[#self.entities].collides = false
        self.entities[#self.entities].noWrap = true
        self.entities[#self.entities].hasLife = true
        self.entities[#self.entities].life = 0.1 + (math.random(1, 10)/50)
        self.entities[#self.entities].sprite = love.graphics.newImage("gfx/blood.png")
        self.entities[#self.entities].sprite:setFilter("nearest", "nearest")
    end
end

function Swarm:draw()
    for i = 1, #self.entities do
        if not self.entities[i] == false then
            self.entities[i]:draw()
        end
    end
end

function Swarm:update(dt)
    for i = 1, #self.entities do
        if not self.entities[i] == false then
            self.entities[i]:update(dt)
            if self.entities[i].hasLife then
                if self.entities[i].life > 0 then
                    self.entities[i].life = self.entities[i].life - dt
                -- Kill actor
                else
                    if self.entities[i].type == "bomb" then
                        -- Kill near enemys
                        for j = 1, #self.entities do
                            if (not self.entities[j] == false) then
                                if not (j == i) then
                                    local radius = 30
                                    -- If object is in "radius"
                                    if self.entities[j].xPos > self.entities[i].xPos-radius and self.entities[j].xPos < self.entities[i].xPos+radius then
                                        if self.entities[j].yPos > self.entities[i].yPos-radius and self.entities[j].yPos < self.entities[i].yPos+radius then
                                            if self.entities[j].type == "bomb" and self.entities[j].life > .3 then
                                                self.entities[j].life = .3
                                            elseif self.entities[j].type == "bug" then
                                                self.entities[j].hasLife = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        sfx:play("boom")
                        gameScreenShake = 25
                        for z = 1, 40 do
                            self:add(self.entities[i].xPos, self.entities[i].yPos, math.random(-300, 300), math.random(-300, 300), "smoke")
                        end
                    end
                    if self.entities[i].type == "bug" then
                        sfx:play("splat")
                        mobsLeftOnMap = mobsLeftOnMap - 1
                        if mobsLeftOnMap == 0 and doorExists then
                            for z = 1, 30 do
                                self:add(world.doorXPos, world.doorYPos, math.random(-150, 150), math.random(-300, -150), "glitter")
                            end
                        end
                        for z = 1, 30 do
                            self:add(self.entities[i].xPos, self.entities[i].yPos, math.random(-150, 150), math.random(-150, 150), "blood")
                        end
                    end
                    self.entities[i] = false
                end
            end
        end
    end
end

function Swarm:collidesWithBug(actor)
    local retVal = false
    for i = 1, #self.entities do
        if not (self.entities[i] == false) then
            if self.entities[i].type == "bug" then
                if actor.xPos > self.entities[i].xPos-12 and actor.xPos < self.entities[i].xPos+12 and actor.yPos < self.entities[i].yPos+12 and actor.yPos > self.entities[i].yPos-6 then
                    retVal = true
                end
            end
        end
    end
    return retVal
end
