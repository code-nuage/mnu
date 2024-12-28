local mnu = {}
mnu.__index = mnu

function mnu:new(name, x, y)
    local instance = setmetatable({}, mnu)

    instance.name = name or nil
    instance.x, instance.y = x, y
    instance.color = {r = 1, g = 1, b = 1}
    instance.border_size = 2

    instance.items = {}
    instance.selected = 1

    return instance
end

function mnu:set_color(r, g, b)
    self.color = {r = r, g = g, b = b}
end

function mnu:set_border_size(size)
    self.border_size = size
end

function mnu:add_item(item)
    self.items[#self.items + 1] = item
end

function mnu:clear()
    self.items = {}
end

function mnu:up()
    self.selected = self.selected - 1
    if self.selected < 1 then self.selected = #self.items end
end

function mnu:down()
    self.selected = self.selected + 1
    if self.selected > #self.items then self.selected = 1 end
end

function mnu:execute()
    self.items[self.selected].action()
end

function mnu:draw()
    for i, item in ipairs(self.items) do
        
        local h = love.graphics.getFont():getHeight()

        if i == self.selected then

            local r, g, b = love.graphics.getColor()
            love.graphics.setColor(self.color.r, self.color.g, self.color.b)
            for dx = -self.border_size, self.border_size, self.border_size do
                for dy = -self.border_size, self.border_size, self.border_size do
                    if dx ~= 0 or dy ~= 0 then
                        love.graphics.print(item.name, self.x + dx, self.y + h * i + dy)
                    end
                end
            end
        
            love.graphics.setColor(r, g, b)
        end

        love.graphics.print(item.name, self.x, self.y + h * i)
    end

    
end

return mnu