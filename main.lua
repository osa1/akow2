require("editor")
require("cam")
require("gui/toolkit")
require("gui/fadingtext")

function love.load()
    --love.graphics.setMode(768, 480, false, false, 0)
    love.graphics.setMode(868, 480, false, false, 0)
    mapEndX = 768
    mapEndY = 480

    selectedTile = nil
    editor = Editor:new()
    
    char = { x=0, y=0 }

    cam = Cam:new(300, 200, 768, 480)
    cam:lock(char)

    tiles.normal = Tile:new("normal", editor.gfxNormal, { r=255, g=0, b=0 })
    tiles.top = Tile:new("top",    editor.gfxTop,    { r=0, g=255, b=0 })
    tiles.under = Tile:new("under",  editor.gfxUnder,  { r=255, g=0, b=0 })
    tiles.strand = Tile:new("strand", editor.gfxStrand, { r=0, g=255, b=255 })
    tiles.pillar = Tile:new("pillar", editor.gfxPillar, { r=125, g=0, b=125 })
    tiles.door = Tile:new("door",   editor.gfxDoor,   { r=255, g=255, b=255 })
    tiles.back = Tile:new("back",   editor.bfxBack,   { r=0, g=0, b=0 })

    panel = Panel:new("test", 10, 10, 100, 80)
    text = FadingText:new("ilk text denemesi", {255, 255, 255, 255}, 300, 300, 1, 400)
    text:show()
end

function love.draw()
    editor:draw(cam)
    cam:draw()
    
    -- we have 7 different tiles
    -- and I need one more slot for eraser
    
    -- 100 x 480
    -- 24 x 24
    love.graphics.setLine(2, "smooth")
    love.graphics.line(mapEndX+1, 0, mapEndX+1, 200)
    love.graphics.line(mapEndX+50, 0, mapEndX+50, 200)
    for i=1,4 do
        love.graphics.line(mapEndX, 50*i, mapEndX+100, 50*i)
    end

    love.graphics.draw(editor.gfxNormal, mapEndX+9, 9, 0, 3, 3)
    love.graphics.draw(editor.gfxTop, mapEndX+59, 9, 0, 3, 3)
    love.graphics.draw(editor.gfxUnder, mapEndX+9, 59, 0, 3, 3)
    love.graphics.draw(editor.gfxStrand, mapEndX+50, 59, 0, 3, 3)
    love.graphics.draw(editor.gfxPillar, mapEndX+9, 109, 0, 3, 3)
    love.graphics.draw(editor.gfxBack, mapEndX+59, 109, 0, 3, 3)
    love.graphics.draw(editor.gfxDoor, mapEndX+9, 159, 0, 3, 3)

    panel:draw()
    text:draw()
end

function love.update(dt)
    cam:update(dt)
    panel:update(dt)
    text:update(dt)

    if love.keyboard.isDown("left") then
        char.x = char.x - 100*dt
    elseif love.keyboard.isDown("right") then
        char.x = char.x + 100*dt
    end

    if love.keyboard.isDown("up") then
        char.y = char.y - 100*dt
    elseif love.keyboard.isDown("down") then
        char.y = char.y + 100*dt
    end
end

function between(a, min, max)
    return a >= min and a <= max
end

function love.mousepressed(x, y, button)
    panel:mousepressed(x, y, button)
    if button == "l" then
        if between(x, mapEndX, mapEndX+50) then
            if between(y, 0, 50) then
                selectedTile = tiles.normal
            elseif between(y, 50, 100) then
                selectedTile = tiles.under
            elseif between(y, 100, 150) then
                selectedTile = tiles.pillar
            elseif between(y, 150, 200) then
                selectedTile = tiles.door
            end
        elseif between(x, mapEndX+50, mapEndX+100) then
            if between(y, 0, 50) then
                selectedTile = tiles.top
            elseif between(y, 50, 100) then
                selectedTile = tiles.strand
            elseif between(y, 100, 150) then
                selectedTile = tiles.back
            end
        elseif selectedTile then
            -- place selected tile
            posX = math.floor(x/(8*editor.scale))
            posY = math.floor(y/(8*editor.scale))
            selectedTile:drawToImageData(editor.baseImg, posX, posY)
        end
    else
        selectedTile = nil
    end
    print(selectedTile)
end

function love.mousereleased(x, y, button)
    panel:mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
    print("key pressed: ", unicode)
    if unicode == 20 then -- ctrl + t
        editor.overImgToggle = not editor.overImgToggle
    elseif unicode == 18 then
        text:show()
    end
end

--[[require("actor")
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
end]]
