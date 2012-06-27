require("editor")
require("cam")
require("world")

function love.load()
    love.graphics.setMode(768, 480, false, false, 0)
    mapEndX = 768
    mapEndY = 480


    -- gamestate = [editor, game, main, menu]
    gameState = "editor"
    editor = Editor:new()

    font1 = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 12)
    fontSmall = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 9)

    --char = { x=0, y=0 }

    --cam = Cam:new(300, 200, 768, 480)
    cam = Cam:new(768, 480, 1440, 480)
    --cam:lock(char)

    Tile:new("normal", Tile.gfxNormal, { r=255, g=0, b=0 })
    Tile:new("top",    Tile.gfxTop,    { r=0, g=255, b=0 })
    Tile:new("under",  Tile.gfxUnder,  { r=255, g=0, b=0 })
    Tile:new("strand", Tile.gfxStrand, { r=0, g=255, b=255 })
    Tile:new("pillar", Tile.gfxPillar, { r=125, g=0, b=125 })
    Tile:new("door",   Tile.gfxDoor,   { r=255, g=255, b=255 })
    Tile:new("back",   Tile.gfxBack,   { r=0, g=0, b=0 })

    -- TODO: I couldn't find any better way
    table.insert(tiles, tiles.normal)
    table.insert(tiles, tiles.top)
    table.insert(tiles, tiles.under)
    table.insert(tiles, tiles.strand)
    table.insert(tiles, tiles.pillar)
    table.insert(tiles, tiles.door)
    table.insert(tiles, tiles.back) -- 7
end

function love.draw()
    editor:draw()
end

function love.update(dt)
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
end

function between(a, min, max)
    return a >= min and a <= max
end

function love.mousepressed(x, y, button)
    editor:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    editor:mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
    print("key pressed: ", unicode)
    if unicode == 20 then -- ctrl + t
        editor.world.overImgToggle = not editor.world.overImgToggle
    elseif unicode == 18 then -- ctrl + r
        -- text:show()
    end
end
