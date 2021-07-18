local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local icon_focus    = ""
local icon_urgent   = ""
local icon_occupied = ""
local icon_empty    = ""

local function colorize_text(text, foreground)
    return "<span foreground='" .. foreground .."'>" .. text .. "</span>"
end

local function update_taglist(item, tag, index)
  if tag.selected then
    item.markup = colorize_text(icon_focus, beautiful.taglist_fg_focus)
  elseif tag.urgent then
    item.markup = colorize_text(icon_urgent, beautiful.taglist_fg_urgent)
  elseif #tag:clients() > 0 then
    item.markup = colorize_text(icon_occupied, beautiful.taglist_fg_occupied)
  else
    item.markup = colorize_text(icon_empty, beautiful.taglist_fg_empty)
  end
end


local function get(s)
  -- Each screen has its own tag table.
  awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

  local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
  )

  local taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        widget_template = {
          widget = wibox.widget.textbox,
          create_callback = function(self, tag, index, _)
            self.align = "left"
            self.valign = "center"
            self.font = beautiful.taglist_text_font
            update_taglist(self, tag, index)
          end,
          update_callback = function(self, tag, index, _)
            update_taglist(self, tag, index)
          end,
        },
        buttons = taglist_buttons
  }

  local container = wibox.container.margin (taglist, beautiful.margin, 0, 0, 0)

  return container
end

return get
