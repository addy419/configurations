-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Global variables
require("globals")
-- Error handling
require("misc.error-handling")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/dracula/config.lua")
-- }}}

-- Imports
local layouts = require("misc.layouts")
local globalkeys = require("bindings.globalkeys")
local rules = require("rules")

-- Layouts
layouts()

-- Set keys
root.keys(globalkeys())

-- WiBar
require("statusbar.wibar")

-- Rules
awful.rules.rules = rules()

-- Signals
require("misc.signals")
