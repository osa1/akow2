require("editor")
require("cam")
--require("gui/toolkit")
--require("gui/fadingtext")
require("gui/package")

function love.load()
    --love.graphics.setMode(768, 480, false, false, 0)
    love.graphics.setMode(768, 480, false, false, 0)
    mapEndX = 768
    mapEndY = 480

    editor = Editor:new()

    font1 = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 12)
    fontSmall = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 9)
    
    --char = { x=0, y=0 }

    --cam = Cam:new(300, 200, 768, 480)
    cam = Cam:new(768, 480, 1440, 480)
    --cam:lock(char)

    tiles.normal = Tile:new("normal", editor.gfxNormal, { r=255, g=0, b=0 })
    tiles.top = Tile:new("top",    editor.gfxTop,    { r=0, g=255, b=0 })
    tiles.under = Tile:new("under",  editor.gfxUnder,  { r=255, g=0, b=0 })
    tiles.strand = Tile:new("strand", editor.gfxStrand, { r=0, g=255, b=255 })
    tiles.pillar = Tile:new("pillar", editor.gfxPillar, { r=125, g=0, b=125 })
    tiles.door = Tile:new("door",   editor.gfxDoor,   { r=255, g=255, b=255 })
    tiles.back = Tile:new("back",   editor.gfxBack,   { r=0, g=0, b=0 })

    -- TODO: I couldn't find any better way
    table.insert(tiles, tiles.normal)
    table.insert(tiles, tiles.top)
    table.insert(tiles, tiles.under)
    table.insert(tiles, tiles.strand)
    table.insert(tiles, tiles.pillar)
    table.insert(tiles, tiles.door)
    table.insert(tiles, tiles.back) -- 7

    --panel = gui.newPanel("test", 10, 10, 100, 80)
    tilePanel = gui.newTilePanel(50, 50)
    text = gui.newFadingText("ilk text denemesi", {255, 255, 255, 255}, 300, 300, 1, 400)
    text:show()
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-cam.x, -cam.y)
    editor:draw(cam)
    cam:draw()
    love.graphics.pop()
    -- we have 7 different tiles
    -- and I need one more slot for eraser
    
    -- 100 x 480
    -- 24 x 24

    for i,v in ipairs(activeGUIs) do
        v:draw()
    end

    if editor.overImg ~= false and editor.overImgToggle == true then
        love.graphics.draw(editor.overImg, 1, 1, 0, 3, 3)
    end
end

function love.update(dt)
    cam:update(dt)

    for i,v in ipairs(activeGUIs) do
        v:update(dt)
    end
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
end

function between(a, min, max)
    return a >= min and a <= max
end

function love.mousepressed(x, y, button)
    --panel:mousepressed(x, y, button)
    tilePanel:mousepressed(x, y, button)
    print("selected tile", selectedTile)
end

function love.mousereleased(x, y, button)
    --panel:mousereleased(x, y, button)
    tilePanel:mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
    print("key pressed: ", unicode)
    if unicode == 20 then -- ctrl + t
        editor.overImgToggle = not editor.overImgToggle
    elseif unicode == 18 then -- ctrl + r
        text:show()
    end
end
