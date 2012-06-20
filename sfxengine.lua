SfxEngine = {}

function SfxEngine:new(x, y)
	object = {}

	object.music = love.audio.newSource("sfx/gamemusic.ogg", "stream")
	object.boom = love.audio.newSource("sfx/boom.ogg", "static")
	object.toss = love.audio.newSource("sfx/toss.ogg", "static")
	object.jump = love.audio.newSource("sfx/jump.ogg", "static")
	object.splat = love.audio.newSource("sfx/splat.ogg", "static")
	object.success = love.audio.newSource("sfx/success.ogg", "static")
	object.fail = love.audio.newSource("sfx/fail.ogg", "static")

	setmetatable(object, self)
	self.__index = self
	return object
end

function SfxEngine:play(sound)
	if sound == "music" then
		if self.music:isStopped() then
			self.music:play()
			self.music:setLooping(true)
		else
			self.music:setLooping(false)
			self.music:stop()
		end
	elseif sound == "boom" then
		if self.boom:isStopped() then
			self.boom:play()
		else
			self.boom:rewind()
		end
	elseif sound == "toss" then
		if self.toss:isStopped() then
			self.toss:play()
		else
			self.toss:rewind()
		end
	elseif sound == "jump" then
		if self.jump:isStopped() then
			self.jump:play()
		else
			self.jump:rewind()
		end
	elseif sound == "splat" then
		if self.splat:isStopped() then
			self.splat:play()
		else
			self.splat:rewind()
		end
	elseif sound == "success" then
		if self.success:isStopped() then
			self.success:play()
		else
			self.success:rewind()
		end
	elseif sound == "fail" then
		if self.fail:isStopped() then
			self.fail:play()
		else
			self.fail:rewind()
		end
	end
end