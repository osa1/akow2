Panel = {}
Panel.__index = Panel

function Panel:new(title, posx, posy, width, height)
    object = {}
    object.title = title
    object.posx = posx
    object.posy = posy
    object.width = width
    object.height = height

    object.drag = false
    object.xoffset = 0
    object.yoffset = 0

    setmetatable(object, self)
    --self.__index = self

    return object
end

function Panel:update(dt)
    if self.drag then
        self.posx = love.mouse.getX() - self.xoffset
        self.posy = love.mouse.getY() - self.yoffset
    end
end

function Panel:draw()
    love.graphics.setLine(1, "smooth")
    love.graphics.line(self.posx, self.posy, self.posx+self.width, self.posy)
    love.graphics.line(self.posx, self.posy, self.posx, self.posy+self.height)
    love.graphics.line(self.posx+self.width, self.posy, self.posx+self.width, self.posy+self.height)
    love.graphics.line(self.posx, self.posy+self.height, self.posx+self.width, self.posy+self.height)
end

function Panel:mousepressed(x, y, button)
    if button == "l" and x >= self.posx and x <= self.posx+self.width and
            y >= self.posy and y <= self.posy+self.height then
        self.drag = true
        self.xoffset = x-self.posx
        self.yoffset = y-self.posy
    end
end

function Panel:mousereleased(x, y, button)
    self.drag = false
end
