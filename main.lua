require("editor")
require("cam")
require("world")
require("actor")
require("sfxengine")

function love.load()
    love.graphics.setMode(768, 480, false, false, 0)
    mapEndX = 768
    mapEndY = 480

    -- gamestate = [editor, game, main, menu]
    gameState = "editor"
    editor = Editor:new()

    sfx = SfxEngine:new()
    sfx:play("music")

    clickCooldown = 0

    font1 = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 12)
    fontSmall = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 9)
    player = Actor:new(0, 0)
    editor.world:positionPlayer()

    cam = Cam:new(768, 480)

    Tile:new("normal", Tile.gfxNormal, { r=255, g=0, b=0 })
    Tile:new("top",    Tile.gfxTop,    { r=0, g=255, b=0 })
    Tile:new("under",  Tile.gfxUnder,  { r=255, g=0, b=0 })
    Tile:new("strand", Tile.gfxStrand, { r=0, g=255, b=255 })
    Tile:new("pillar", Tile.gfxPillar, { r=125, g=0, b=125 })
    Tile:new("door",   Tile.gfxDoor,   { r=255, g=255, b=255 })
    Tile:new("back",   Tile.gfxBack,   { r=0, g=0, b=0 })
    Tile:new("player", Tile.player,    { r=255, g = 0, b=255 })

    -- TODO: I couldn't find any better way
    table.insert(tiles, tiles.normal)
    table.insert(tiles, tiles.top)
    table.insert(tiles, tiles.under)
    table.insert(tiles, tiles.strand)
    table.insert(tiles, tiles.pillar)
    table.insert(tiles, tiles.door)
    table.insert(tiles, tiles.back) -- 7
    table.insert(tiles, tiles.player)
end

function love.draw()
    if gameState == "editor" then
        editor:draw()
    elseif gameState == "game" then
        editor.world:draw()
        player:draw()
    end
end

function love.update(dt)
    if gameState == "editor" then
        cam:update(dt)

        if love.keyboard.isDown("left") then
            --char.x = char.x - 500*dt
            cam.x = cam.x - 500*dt
        elseif love.keyboard.isDown("right") then
            --char.x = char.x + 500*dt
            cam.x = cam.x + 500*dt
        end

        if love.keyboard.isDown("up") then
            --char.y = char.y - 500*dt
            cam.y = cam.y - 500*dt
        elseif love.keyboard.isDown("down") then
            --char.y = char.y + 500*dt
            cam.y = cam.y + 500*dt
        end

        editor:update(dt)
    elseif gameState == "game" then
        cam:update(dt)

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
        -- swarm:update(dt)
        clickCooldown = clickCooldown - dt

        if mobsLeftOnMap == 0 then
            if player.xPos > world.doorXPos and player.xPos < world.doorXPos+24 and player.yPos > world.doorYPos and player.yPos < world.doorYPos+24 and doorExists then
                gameLevel = gameLevel + 1
                gameInit = true
                sfx:play("success")
            end
        end

    end
end

function between(a, min, max)
    return a >= min and a <= max
end

function love.mousepressed(x, y, button)
    if gameState == "editor" then
        editor:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if gameState == "editor" then
        editor:mousereleased(x, y, button)
    end
end

function love.keypressed(key, unicode)
    -- print("key pressed: ", unicode)
    if unicode == 20 then -- ctrl + t
        editor.world.overImgToggle = not editor.world.overImgToggle
    -- elseif unicode == 18 then -- ctrl + r
        -- text:show()

    elseif unicode == 5 then -- ctrl + e
        if gameState == "editor" then
            gameState = "game"
            cam:lock(player)
        elseif gameState == "game" then
            gameState = "editor"
            cam:lock(nil)
        end
    end

    if gameState == "game" and not player.inAir then
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
