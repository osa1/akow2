FadingText = {}
FadingText.__index = FadingText

function FadingText:new(text, color, posx, posy, delay, speed)
    object = {}
    object.text = text
    object.posx = posx
    object.posy = posy
    object.color = color
    object.speed = speed or 100
    object.delay = delay
    object.currDelay = delay

    object.active = false

    setmetatable(object, self)
    --self.__index = self

    return object
end

function FadingText:update(dt)
    if self.active then
        if self.currDelay > 0 then
            self.currDelay = self.currDelay - dt
            print(self.currDelay)
        else
            self.color[4] = self.color[4] - self.speed*dt
            print("updating")
            print(self.color[4])
            if self.color[4] <= 0 then
                self.color[4] = 0
                self.active = false
            end
        end
    end
end

function FadingText:show()
    self.active = true
    self.color[4] = 255
    self.currDelay = self.delay
end

function FadingText:draw()
    if self.active then
        local r, g, b, a
        r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(self.color)
        love.graphics.setFont(font1)
        love.graphics.printf(self.text, self.posx, self.posy, 1000, "center")
        love.graphics.setColor(r, g, b, a)
    end
end
