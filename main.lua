require("editor")
require("cam")
--require("gui/toolkit")
--require("gui/fadingtext")
require("gui/package")

function love.load()
    --love.graphics.setMode(768, 480, false, false, 0)
    love.graphics.setMode(868, 480, false, false, 0)
    mapEndX = 768
    mapEndY = 480

    selectedTile = nil
    editor = Editor:new()

    font1 = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 12)
    fontSmall = love.graphics.newFont("fonts/pf_tempesta_seven_extended.ttf", 9)
    
    char = { x=0, y=0 }

    cam = Cam:new(300, 200, 768, 480)
    cam:lock(char)

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

    panel = gui.newPanel("test", 10, 10, 100, 80)
    tilePanel = gui.newTilePanel(50, 50)
    text = gui.newFadingText("ilk text denemesi", {255, 255, 255, 255}, 300, 300, 1, 400)
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


    for i,v in ipairs(activeGUIs) do
        v:draw()
    end

    if editor.overImg ~= false and editor.overImgToggle == true then
        love.graphics.draw(editor.overImg, 1, 1, 0, 3, 3)
    end

    --panel:draw()
    --text:draw()
end

function love.update(dt)
    cam:update(dt)

    for i,v in ipairs(activeGUIs) do
        v:update(dt)
    end

    --panel:update(dt)
    --text:update(dt)
    if love.keyboard.isDown("left") then
        char.x = char.x - 500*dt
    elseif love.keyboard.isDown("right") then
        char.x = char.x + 500*dt
    end

    if love.keyboard.isDown("up") then
        char.y = char.y - 500*dt
    elseif love.keyboard.isDown("down") then
        char.y = char.y + 500*dt
    end
end

function between(a, min, max)
    return a >= min and a <= max
end

function love.mousepressed(x, y, button)
    panel:mousepressed(x, y, button)
    tilePanel:mousepressed(x, y, button)
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
