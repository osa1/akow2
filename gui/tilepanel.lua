require("tile")

TilePanel = {}
TilePanel.__index = TilePanel

function TilePanel:new(posx, posy)
    local object = {}
    object.panelTitle = "Blocks"
    object.title = object.panelTitle
    object.posx = posx
    object.posy = posy
    object.width = 100
    object.height = 150

    object.drag = false
    object.xoffset = 0
    object.yoffset = 0

    object.cols = 3
    object.rows = 3

    setmetatable(object, self)
    return object
end

function TilePanel:update(dt)
    if self.drag then
        self.posx = love.mouse.getX() - self.xoffset
        self.posy = love.mouse.getY() - self.yoffset
    end
end

function TilePanel:draw()
    love.graphics.setLine(1, "smooth")
    love.graphics.line(self.posx, self.posy, self.posx+self.width, self.posy)
    love.graphics.line(self.posx, self.posy, self.posx, self.posy+self.height)
    love.graphics.line(self.posx+self.width, self.posy, self.posx+self.width, self.posy+self.height)
    love.graphics.line(self.posx, self.posy+self.height, self.posx+self.width, self.posy+self.height)

    local colWidth = self.width/self.cols
    local rowHeight = self.height/self.rows
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    --self.title = if selectedTile then selectedTile.name else self.panelTitle end
    if selectedTile then
        self.title = selectedTile.name
    else
        self.title = self.panelTitle
    end
    for x=1,self.cols do
        for y=1,self.rows do
            if between(mouseX, self.posx+colWidth*(x-1), self.posx+colWidth*x) and
                    between(mouseY, self.posy+rowHeight*(y-1), self.posy+rowHeight*y) then
                local r, g, b, a = love.graphics.getColor()
                if tiles[self.cols*(y-1)+x] then
                    self.title = tiles[self.cols*(y-1)+x].name
                end
                love.graphics.setColor(255, 255, 255, 100)
                love.graphics.rectangle("fill", self.posx+colWidth*(x-1), self.posy+rowHeight*(y-1), colWidth, rowHeight)
                love.graphics.setColor(r, g, b, a)
            else
                local r, g, b, a = love.graphics.getColor()
                love.graphics.setColor(0, 0, 0, 100)
                love.graphics.rectangle("fill", self.posx+colWidth*(x-1), self.posy+rowHeight*(y-1), colWidth, rowHeight)
                love.graphics.setColor(r, g, b, a)
            end
            if tiles[self.cols*(y-1)+x] then
                love.graphics.draw(tiles[self.cols*(y-1)+x].image,
                    self.posx+colWidth*(x-1)+((colWidth-24)/2),
                    self.posy+rowHeight*(y-1)+((rowHeight-24)/2),
                    0, 3, 3)
            end
        end
    end
            love.graphics.setFont(font1)
            love.graphics.printf(self.title, self.posx+5, self.posy-18, 1000, "left")
end

function TilePanel:mousepressed(x, y, button)
    if button == "l" and x >= self.posx and x <= self.posx+self.width and
            y >= self.posy and y <= self.posy+self.height then
        local xoffset = x - self.posx
        local yoffset = y - self.posy
        self.drag = true
        self.xoffset = xoffset
        self.yoffset = yoffset

        local col = math.floor(xoffset / (self.width / self.cols)) + 1
        local row = math.floor(yoffset / (self.height / self.rows)) + 1
        -- print("col", col, "row", row)
        if tiles[self.cols*(row-1)+col] then
            -- print("tile selected", tiles[self.cols*(row-1)+col].name)
            selectedTile = tiles[self.cols*(row-1)+col]
        end
        return true -- this means that user clicked on the panel
    end
    return false -- user didn't click on panel
end

function TilePanel:mousereleased(x, y, button)
    self.drag = false
end
