Swarm = {}

function Swarm:new()
	object = {}

	object.enteties = {}

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
				self.enteties[i] = Actor:new(x*8*3+12, y*8*3+10)
				self.enteties[i].type = "bug"
				self.enteties[i].ai = true
				self.enteties[i].maxSpeed = 15
				self.enteties[i].sprite = love.graphics.newImage("gfx/enbug.png")
				self.enteties[i].sprite:setFilter("nearest", "nearest")
				self.enteties[i].fps = 6 + math.random(1, 3)
				i = i + 1
			end
		end
	end
	return i-1
end

function Swarm:add(x, y, xvel, yvel, objType)
	self.enteties[#self.enteties+1] = Actor:new(x, y)
	self.enteties[#self.enteties].xVel = xvel
	self.enteties[#self.enteties].yVel = yvel

	if objType == "bomb" then
		self.enteties[#self.enteties].type = "bomb"
		self.enteties[#self.enteties].hasLife = true
		self.enteties[#self.enteties].life = 3
		self.enteties[#self.enteties].inAir = true
		self.enteties[#self.enteties].fps = 8 + math.random(1, 3)
		self.enteties[#self.enteties].isBouncy = true
		self.enteties[#self.enteties].friction = 500
		self.enteties[#self.enteties].sprite = love.graphics.newImage("gfx/ball.png")
		self.enteties[#self.enteties].sprite:setFilter("nearest", "nearest")
	elseif objType == "smoke" then
		self.enteties[#self.enteties].collides = false
		self.enteties[#self.enteties].noWrap = true
		self.enteties[#self.enteties].hasLife = true
		self.enteties[#self.enteties].life = 0.1 + (math.random(1, 10)/50)
		if(math.random(1, 6) > 1) then
			self.enteties[#self.enteties].sprite = love.graphics.newImage("gfx/smoke.png")
		else
			self.enteties[#self.enteties].sprite = love.graphics.newImage("gfx/fire.png")
		end
		self.enteties[#self.enteties].sprite:setFilter("nearest", "nearest")
	elseif objType == "glitter" then
		self.enteties[#self.enteties].collides = true
		self.enteties[#self.enteties].noWrap = true
		self.enteties[#self.enteties].hasLife = true
		self.enteties[#self.enteties].life = 0.1 + (math.random(1, 10)/10)
		self.enteties[#self.enteties].friction = 100
		self.enteties[#self.enteties].sprite = love.graphics.newImage("gfx/glitter.png")
		self.enteties[#self.enteties].sprite:setFilter("nearest", "nearest")
	elseif objType == "blood" then
		self.enteties[#self.enteties].collides = false
		self.enteties[#self.enteties].noWrap = true
		self.enteties[#self.enteties].hasLife = true
		self.enteties[#self.enteties].life = 0.1 + (math.random(1, 10)/50)
		self.enteties[#self.enteties].sprite = love.graphics.newImage("gfx/blood.png")
		self.enteties[#self.enteties].sprite:setFilter("nearest", "nearest")
	end
end

function Swarm:draw()
	for i = 1, #self.enteties do
		if not self.enteties[i] == false then
			self.enteties[i]:draw()
		end
	end
end

function Swarm:update(dt)
	for i = 1, #self.enteties do
		if not self.enteties[i] == false then
			self.enteties[i]:update(dt)
			if self.enteties[i].hasLife then
				if self.enteties[i].life > 0 then
					self.enteties[i].life = self.enteties[i].life - dt	
				-- Kill actor
				else
					if self.enteties[i].type == "bomb" then
						-- Kill near enemys
						for j = 1, #self.enteties do
							if (not self.enteties[j] == false) then
								if not (j == i) then
									local radius = 30
									-- If object is in "radius"
									if self.enteties[j].xPos > self.enteties[i].xPos-radius and self.enteties[j].xPos < self.enteties[i].xPos+radius then
										if self.enteties[j].yPos > self.enteties[i].yPos-radius and self.enteties[j].yPos < self.enteties[i].yPos+radius then
											if self.enteties[j].type == "bomb" and self.enteties[j].life > .3 then
												self.enteties[j].life = .3
											elseif self.enteties[j].type == "bug" then
												self.enteties[j].hasLife = true
											end
										end
									end
								end
							end
						end
						sfx:play("boom")
						gameScreenShake = 25
						for z = 1, 40 do
							self:add(self.enteties[i].xPos, self.enteties[i].yPos, math.random(-300, 300), math.random(-300, 300), "smoke")
						end
					end
					if self.enteties[i].type == "bug" then
						sfx:play("splat")
						mobsLeftOnMap = mobsLeftOnMap - 1
						if mobsLeftOnMap == 0 and doorExists then
							for z = 1, 30 do
								self:add(world.doorXPos, world.doorYPos, math.random(-150, 150), math.random(-300, -150), "glitter")
							end
						end
						for z = 1, 30 do
							self:add(self.enteties[i].xPos, self.enteties[i].yPos, math.random(-150, 150), math.random(-150, 150), "blood")
						end
					end
					self.enteties[i] = false
				end
			end
		end
	end
end

function Swarm:collidesWithBug(actor)
	local retVal = false
	for i = 1, #self.enteties do
		if not (self.enteties[i] == false) then
			if self.enteties[i].type == "bug" then
				if actor.xPos > self.enteties[i].xPos-12 and actor.xPos < self.enteties[i].xPos+12 and actor.yPos < self.enteties[i].yPos+12 and actor.yPos > self.enteties[i].yPos-6 then
					retVal = true
				end
			end
		end
	end
	return retVal
end