local mnu = {}
mnu.__index = mnu

mnu.item = {name = "Item", action = function() end}
mnu.item.__index = mnu.item

--[[ ===================
     LOCAL FUNCTIONS
     =================== ]]

-- COLOR MODE
local function draw_color(menu, i, item)
    local h = love.graphics.getFont():getHeight()
    local r, g, b = love.graphics.getColor()

    if i == menu.selected then
        love.graphics.setColor(menu.border_color.r, menu.border_color.g, menu.border_color.b)
        love.graphics.print(item.name, menu.x, menu.y + h * i)
    else
        love.graphics.setColor(r, g, b)
        love.graphics.print(item.name, menu.x, menu.y + h * i)
    end

    love.graphics.setColor(r, g, b)
end

-- BORDER MODE
local function draw_border(menu, i, item)
    local h = love.graphics.getFont():getHeight()
    local r, g, b = love.graphics.getColor()

    if i == menu.selected then
        love.graphics.setColor(menu.border_color.r, menu.border_color.g, menu.border_color.b)

        for dx = -menu.border_size, menu.border_size, menu.border_size do
            for dy = -menu.border_size, menu.border_size, menu.border_size do
                if dx ~= 0 or dy ~= 0 then
                    love.graphics.print(item.name, menu.x + dx, menu.y + h * i + dy)
                end
            end
        end
    end

    love.graphics.setColor(r, g, b)
    love.graphics.print(item.name, menu.x, menu.y + h * i)
end

-- BLINK MODE
local function draw_blink(menu, i, item)
    local h = love.graphics.getFont():getHeight()
    local r, g, b = love.graphics.getColor()

    love.graphics.setColor(r, g, b)
    love.graphics.print(item.name, menu.x, menu.y + h * i)

    if i == menu.selected then
        menu.blink_timer = menu.blink_timer + love.timer.getDelta()

        if menu.blink_timer >= menu.blink_interval then
            menu.blink_timer = 0
            menu.blink_status = not menu.blink_status
        end

        if menu.blink_status == true then
            love.graphics.setColor(r, g, b)
        else
            love.graphics.setColor(menu.blink_color.r, menu.blink_color.g, menu.blink_color.b)
        end
    end

    love.graphics.print(item.name, menu.x, menu.y + h * i)

    love.graphics.setColor(r, g, b)
end

-- ZOOM MODE
local function draw_zoom(menu, i, item)
    local h = love.graphics.getFont():getHeight()

    local scale = (i == menu.selected) and menu.zoom_scale or 1

    love.graphics.push()
    love.graphics.translate(menu.x, menu.y + h * i - (h * scale) / 2 )
    love.graphics.scale(scale, scale)
    love.graphics.print(item.name, 0, 0)
    love.graphics.pop()
end

-- SHAKE MODE
local function draw_shake(menu, i, item)
    local h = love.graphics.getFont():getHeight()
    local bounce = 0

    if i == menu.selected then
        bounce = math.sin(love.timer.getTime() * menu.shake_period) * menu.shake_interval
    end
    love.graphics.print(item.name, menu.x, menu.y + h * i + bounce)
end


--[[ ====================
     INTERFACES
     ==================== ]]
function mnu:new(name, x, y)
    local instance = setmetatable({}, mnu)

    instance.name = name or nil
    instance.x, instance.y = x, y
    instance.selected_mode = "color"

    instance.color_color = {r = 1, g = 0, b = 0}

    instance.border_color = {r = 1, g = 0, b = 0}
    instance.border_size = 2

    instance.blink_color = {r = 1, g = 0, b = 0}
    instance.blink_period = .5
    instance.blink_status = true
    instance.blink_timer = 0

    instance.zoom_scale = 1.2
    
    instance.shake_period = 5
    instance.shake_interval = 10

    instance.items = {}
    instance.selected = 1

    return instance
end

function mnu:set_mode(mode)
    if mode == "color" or mode == "border" or mode == "blink" or mode == "zoom" or mode == "shake" then
        self.selected_mode = mode
    else
        error(mode .. " mode doesn't exist.")
    end
end

function mnu:set_color_color(r, g, b)
    self.border_color = {r = r, g = g, b = b}
end

function mnu:set_border_color(r, g, b)
    self.border_color = {r = r, g = g, b = b}
end

function mnu:set_border_size(size)
    self.border_size = size
end

function mnu:set_blink_color(r, g, b)
    self.blink_color = {r = r, g = g, b = b}
end

function mnu:set_blink_period(t)
    self.blink_interval = t
end

function mnu:set_zoom_scale(scale)
    self.zoom_scale = scale
end

function mnu:set_shake_period(t)
    self.shake_period = t
end

function mnu:set_shake_interval(distance)
    self.shake_interval = distance
end

function mnu:new_item(name, action)
    local instance = setmetatable({}, mnu.item)

    instance.name = name
    instance.action = function() action(instance) end

    return instance
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
        if self.selected_mode == "color" then
            draw_color(self, i, item)
        elseif self.selected_mode == "border" then
            draw_border(self, i, item)
        elseif self.selected_mode == "blink" then
            draw_blink(self, i, item)
        elseif self.selected_mode == "zoom" then
            draw_zoom(self, i, item)
        elseif self.selected_mode == "shake" then
            draw_shake(self, i, item)
        end
    end
end

return mnu