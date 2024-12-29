# mnu

## What is mnu?
`mnu` is a LÖVE2D library that handles simple interactives menus.

When to use `mnu`?
`mnu` helps you to create menus objects with a few amount of code.
It's useful when you have to create simple menus, like a Main Menu for a videogame.

It contains many features like executing functions, navigating, set selected colors or set selected border size

## How to install `mnu`?
To install `mnu`, just grab the `mnu.lua` file from the repo, place it in your project and require it in your main lua file.

```lua
_G.mnu = require("mnu.lua")
```

## How tu use `mnu`?
`mnu` is very easy to use, you just have to know the very basics.

### General presentation
First, create a menu with `mnu:new(name, x, y)`
```lua
local MENU = menu:new("Main menu", 100, 100)
```

You can create an item with `mnu:new_item(name, action)`
```lua
local item = mnu:new_item("Item", function() print("You trggered an item") end)
```

You can even modify the item itself when its action is triggered, you just have to pass itself in the anonymous function
```lua
local item = mnu:new_item("Item", function(self) self.name = "Item triggered" end)
```

Then add some items to it with `mnu:add_item(item)`
```lua
MENU:add_item(mnu:new_item("Play", function() print("play") end))
MENU:add_item(mnu:new_item("Fullscreen: off", function(self)
    fullscreen = not fullscreen
    if fullscreen == true then self.name = "Fullscreen: on" else self.name = "Fullscreen: off" end
    love.window.setFullscreen(fullscreen)
end))
MENU:add_item(mnu:new_item("Quit", function() love.event.quit() end))
```

You can also clear a menu with `mnu:clear()`
```lua
MENU:clear()
```
`mnu` contains a bunch of selected modes, that modify the appearence of the current selected item, by default it is `color` but we will change it for `border` here with `mnu:set_mode(mode)`
```lua
MNEU:set_mode("border")
```

You can modify the border color and the border size of the selected item with `mnu:set_border_color(r, g, b)` and `mnu:set_border_size(size)`
```lua
MENU:set_border_color(1, 1, 0)
MENU:set_border_size(3)
```

Then, we assume that we have a rising edge function, you can navigate in this menu with `mnu:up()`, `mnu:down()` and `mnu:execute()`
```lua
rising_edge("s", function() MENU:down() end)
rising_edge("w", function() MENU:up() end)
rising_edge("space", function() MENU:execute() end)
```

And finally you can draw your menu in `love.draw()` with `mnu:draw()`
```lua
function love.draw()
  MENU:draw()
end
```

### Selected modes
There are a bunch of pre-written selected mode: `color`, `border`, `blink`, `zoom` and `shake`.
It's your job to hack the lib to add some.

As said previously in **General presentation**, you can set the mode of the current selected item with `mnu:set_mode(mode)`. 
They all are tweakable with methods, named like: `mnu:set_<mode>_<setting>`

#### `color`
The basic (and default) selected mode, it just renders a different color as a selected indicator

```lua
MENU:set_color_color(r, g, b)
```

#### `border`
A basic text outline, looks weird when the difference between font size and border size is big

```lua
MENU:set_border_color(r, g, b)
MENU:set_border_size(size)
```

#### `blink`
A generic blinking selected mode, switch the selected item between menu color and blinking color

```lua
MENU:set_blink_color(r, g, b)
MENU:set_blink_period(t)
```

#### `zoom`
Zooms the current selected item

```lua
MENU:set_zoom_scale(scale)
```

#### `shake`
Shakes the current selected item

```lua
MENU:set_shake_period(t)
MENU:set_shake_interval(distance)
```
