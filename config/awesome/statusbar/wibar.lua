-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

local set_wallpaper = require("misc.wallpaper")
local taglist = require("statusbar.workspaces")

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    
    -- Create the taglist
    s.mytaglist = taglist(s)

    -- Create the systray 
    local systray = wibox.widget.systray()
    systray:set_base_size(28)
    s.mysystray = systray

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = beautiful.wibar_height, bg = beautiful.bg_wibar })

    s.mywibox:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.margin,
                s.mytaglist,
                s.mypromptbox
            },
            nil,
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                s.mysystray,
                mytextclock
            }
        },
        {
            mytextclock,
            valign = "center",
            halign = "center",
            layout = wibox.container.place
        }
    }
end)
