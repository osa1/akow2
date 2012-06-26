require("actor")
require("world")
require("sfxengine")

function love.load()
	-- Screen settings
	love.graphics.setMode(768, 480, false, false, 0)

	-- Startup gamesettings
	gameScreen = "game"
	gameInit = true
	gameUpdate = true
	gameLevel = 0
	gameBlackout = 255
	gameScreenShake = 0

	-- Setup game
	sfx = SfxEngine:new()
	world = World:new(gameLevel)
	player = Actor:new()
	swarm = Swarm:new()
	mobsLeftOnMap = 0
	doorExists = false

	-- Other
	clickCooldown = 0
	dirtCover = love.graphics.newImage("gfx/dirtcover.png")
	sfx:play("music")
end

function love.draw()
	-- While in game menu
	if gameScreen == "menu" then

	-- While in game state
	elseif gameScreen == "game" then
		-- Reset the game
		if gameInit then
			gameBlackout = 255
			gameScreenShake = 0
			player = Actor:new()
			world = World:new(gameLevel)
			world:positionPlayer()
			swarm = Swarm:new()
			mobsLeftOnMap = swarm:init()
			doorExists = false
			gameInit = false
		end

		-- Move screen from shake
		if gameScreenShake > 0 then
			local shakeX = math.random(gameScreenShake/2-gameScreenShake, gameScreenShake/2)
			local shakeY = math.random(gameScreenShake/2-gameScreenShake, gameScreenShake/2)
			love.graphics.translate(shakeX, shakeY)
		end

		world:draw()
		swarm:draw()
		player:draw()

		-- Return screen to normal
		love.graphics.translate(0, 0)
	end

	if gameBlackout > 0 then
		love.graphics.setColor(0, 0, 0, gameBlackout)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.draw(dirtCover)
end

function love.update(dt)
	if gameScreen == "game" then
		if gameUpdate then
			world:update(dt)

			local speedAdd = 3000
			if player.inAir then speedAdd = speedAdd / 1.7 end
			if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and player.xVel > -player.maxSpeed then
				player.xVel = player.xVel - (speedAdd * dt)
				player.dir = "l"
			elseif (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and player.xVel < player.maxSpeed then
				player.xVel = player.xVel + (speedAdd * dt)
				player.dir = "r"
			end
			if player.xVel < -player.maxSpeed then player.xVel = -player.maxSpeed end
			if player.xVel > player.maxSpeed then player.xVel = player.maxSpeed end

			player:update(dt)
			swarm:update(dt)
		end
		clickCooldown = clickCooldown - dt

		if mobsLeftOnMap == 0 then
			if player.xPos > world.doorXPos and player.xPos < world.doorXPos+24 and player.yPos > world.doorYPos and player.yPos < world.doorYPos+24 and doorExists then
				gameLevel = gameLevel + 1
				gameInit = true
				sfx:play("success")
			end
		end

		if swarm:collidesWithBug(player) == true then
			gameInit = true
			sfx:play("fail")
		end
	end

	if gameBlackout > 2 then
		gameBlackout = gameBlackout - 125 * dt
	else
		gameBlackout = 0
	end

	if gameScreenShake > 2 then
		gameScreenShake = gameScreenShake - 75 * dt
	else
		gameScreenShake = 0
	end
end

function love.keypressed(key, unicode)
	if gameScreen == "game" and not player.inAir then
		if key == " " or key == "up" then
			sfx:play("jump")
			player.yVel = -375
			player.inAir = true
		end
	end
	if key == "r" and gameLevel > 0 then
		gameInit = true
		sfx:play("fail")
	end
	if key == "escape" and gameLevel > 0 then
		gameLevel = 0
		gameInit = true
		sfx:play("fail")
	end
end

function love.mousepressed(x, y, button)
	if gameScreen == "game" then
		if button == "l" and clickCooldown < 0 then
			local px, py = player.xPos, player.yPos
			local mx, my = x, y

			local dx = mx - px
			local dy = my - py

			local magnitude = math.sqrt(dx*dx+dy*dy)
			dx = (dx / magnitude) * 600
			dy = (dy / magnitude) * 600

			player.xVel = player.xVel + ((dx * -1) / 3)
			player.yVel = player.yVel + ((dy * -1) / 7)
			swarm:add(px, py, dx, dy, "bomb")

			sfx:play("toss")
			clickCooldown = .5
		end
	end
end