--  rc.lua
--  custom initialisation for awesome windowmanager 4.0.x
--
-- Copyright (C) 2012, 2013 by Togan Muftuoglu <toganm@opensuse.org>
-- Copyright (C) 2015, 2016 by Sorokin Alexei <sor.alexei@meowr.ru>
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2, or (at
-- your option) any later version.

-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with GNU Emacs; see the file COPYING.  If not, write to the
-- Free Software Foundation, Inc.,  51 Franklin Street, Fifth Floor,
-- Boston, MA 02110-1301 USA

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
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Introspection
local lgi = require("lgi")
local gtk = lgi.require("Gtk", "3.0")
-- Freedesktop integration
local freedesktop = require("freedesktop")
-- calendar functions
-- local calendar2 = require("calendar2")
-- Extra widgets
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Use personal theme if existing else goto default.
do
    local user_theme, ut
    user_theme = awful.util.getdir("config") .. "/themes/theme.lua"
    ut = io.open(user_theme)
    if ut then
        io.close(ut)
        beautiful.init(user_theme)
    else
        print("Personal theme doesn't exist, falling back to openSUSE")
        beautiful.init(awful.util.get_themes_dir() .. "openSUSE/theme.lua")
    end
end

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "vi"
editor_cmd = terminal .. " -e " .. editor

menubar.utils.terminal = terminal
theme.icon_theme = "Adwaita"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --    awful.layout.suit.tile.top,
    --    awful.layout.suit.fair,
    --    awful.layout.suit.fair.horizontal,
    --    awful.layout.suit.spiral,
    --    awful.layout.suit.spiral.dwindle,
    --    awful.layout.suit.max,
    --    awful.layout.suit.max.fullscreen,
    --    awful.layout.suit.magnifier,
    --    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local function lookup_icon(icon, size)
    local icon_theme = gtk.IconTheme.get_default()
    local icon_info = icon_theme:lookup_icon(icon, size, "USE_BUILTIN")
    return icon_info and icon_info:get_filename() or nil
end

mysystemmenu = {
    { "Lock Screen",     "light-locker-command --lock", lookup_icon("system-lock-screen", 16) },
    { "Logout",          function() awesome.quit() end, lookup_icon("system-log-out", 16) },
    { "Reboot System",   "systemctl reboot",            lookup_icon("system-restart", 16) },
    { "Shutdown System", "systemctl poweroff",          lookup_icon("system-shutdown", 16) }
}

myawesomemenu = {
    { "Restart Awesome", awesome.restart,               lookup_icon("view-refresh", 16) },
    { "Edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "rc.lua",
        lookup_icon(
            "package_settings", 16) },
    { "manual",          terminal .. " -e man awesome", lookup_icon("help-browser", 16) }
}

mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
    },
    after = {
        { "System",   mysystemmenu,           lookup_icon("preferences-system", 16) },
        { "Terminal", menubar.utils.terminal, lookup_icon("utilities-terminal", 16) }
    }
})

mygeeko = wibox.widget.imagebox(beautiful.opensuse_icon)

geeko_t = awful.tooltip({
    objects = { mygeeko },
})

local geeko_msg = {
    count = 0,
    to_write = "",
}


local geeko_timer = gears.timer {
    timeout = 0.02,
    callback = function(self)
        -- can't move this to spawn because it flashes the old message
        -- for one frame
        geeko_t.visible = true

        -- subtract 1 to remove extra new line
        if geeko_msg.count < geeko_msg.to_write:len() - 1 then
            geeko_t:set_text(geeko_msg.to_write:sub(1, geeko_msg.count + 1))
            geeko_msg.count = geeko_msg.count + 1
        else
            self:stop()
        end
    end
}

mygeeko:connect_signal('button::press', function()
    -- early completion
    if geeko_timer.started then
        geeko_timer:stop()
        geeko_t:set_text(geeko_msg.to_write:sub(1, geeko_msg.to_write:len() - 1))
    else
        awful.spawn.easy_async_with_shell("fortune", function(stdout)
            geeko_msg.count = 0
            geeko_msg.to_write = stdout

            geeko_timer:start()
        end)
    end
end)

-- default is to have tooltip visible on entry
mygeeko:connect_signal('mouse::enter', function()
    geeko_t.visible = false
end)

mygeeko:connect_signal('mouse::leave', function()
    geeko_t.visible = false
    geeko_timer:stop()
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- We need spacer and separator between the widgets
spacer = wibox.widget.textbox(" ")
spacer.font = beautiful.font_space

left_separator = wibox.widget.textbox()
right_separator = wibox.widget.textbox()

right_separator:set_text("")
left_separator:set_text("")

right_separator.font = beautiful.font_sep
left_separator.font = beautiful.font_sep

left_separator = wibox.container.background(left_separator)
right_separator = wibox.container.background(right_separator)

right_separator.fg = beautiful.fg_accent
left_separator.fg = beautiful.fg_accent

-- Create a textclock widget (date)
local date_format_def = "%a %b %-d"

mydate = wibox.widget.textclock(date_format_def, 60)
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach(mydate, "tr")

local clock_format_def = "%-I:%M %p"
local clock_format_alt = "%-I:%M:%S %p"

mytextclock = wibox.widget.textclock(clock_format_def)

local function clock_switch(format)
    if format == clock_format_def then
        return { clock_format_alt, 1 }
    else
        return { clock_format_def, 60 }
    end
end

mytextclock:connect_signal('mouse::enter', function()
    local switched = clock_switch(mytextclock.format)
    mytextclock.format = switched[1]
    mytextclock.refresh = switched[2]
    mytextclock.hold = false
end)
mytextclock:connect_signal('mouse::leave', function()
    if not mytextclock.hold then
        local switched = clock_switch(mytextclock.format)
        mytextclock.format = switched[1]
        mytextclock.refresh = switched[2]
    end
end)
mytextclock:connect_signal('button::press', function()
    mytextclock.hold = true
end)
-- calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

mythermalwidget = wibox.widget.textbox()
vicious.register(mythermalwidget, vicious.widgets.hwmontemp,
    function(widget, args)
        return string.format("%.0f°C", args[1])
    end, 61, { "coretemp", 1 })


mybattery = wibox.widget.textbox()
battery_t = awful.tooltip({ objects = { mybattery }, })
vicious.register(mybattery, function(format, warg)
    local args = vicious.widgets.bat(format, warg)
    if args[2] < 10 then
        args['{color}'] = 'red'
    else
        args['{color}'] = beautiful.fg_normal
    end
    if args[1] == "+" or args[1] == "↯" then
        if args[2] == 100 then
            args["{icon}"] = "󰂅"
        elseif args[2] >= 90 then
            args["{icon}"] = "󰂋"
        elseif args[2] >= 80 then
            args["{icon}"] = "󰂊"
        elseif args[2] >= 70 then
            args["{icon}"] = "󰢞"
        elseif args[2] >= 60 then
            args["{icon}"] = "󰂉"
        elseif args[2] >= 50 then
            args["{icon}"] = "󰢝"
        elseif args[2] >= 40 then
            args["{icon}"] = "󰂈"
        elseif args[2] >= 30 then
            args["{icon}"] = "󰂇"
        elseif args[2] >= 20 then
            args["{icon}"] = "󰂆"
        elseif args[2] >= 10 then
            args["{icon}"] = "󰢜"
        elseif args[2] >= 0 then
            args["{icon}"] = "󱈐"
        end
    elseif args[1] == "-" then
        if args[2] == 100 then
            args["{icon}"] = "󰁹"
        elseif args[2] >= 90 then
            args["{icon}"] = "󰂂"
        elseif args[2] >= 80 then
            args["{icon}"] = "󰂁"
        elseif args[2] >= 70 then
            args["{icon}"] = "󰂀"
        elseif args[2] >= 60 then
            args["{icon}"] = "󰁿"
        elseif args[2] >= 50 then
            args["{icon}"] = "󰁾"
        elseif args[2] >= 40 then
            args["{icon}"] = "󰁽"
        elseif args[2] >= 30 then
            args["{icon}"] = "󰁼"
        elseif args[2] >= 20 then
            args["{icon}"] = "󰁻"
        elseif args[2] >= 10 then
            args["{icon}"] = "󰁺"
        elseif args[2] >= 0 then
            args["{icon}"] = "󱃍"
        end
    else
        args["{icon}"] = "?"
    end

    battery_t:set_text(args[2] .. "%\n" .. args[3])

    return args
    -- avoid harmonics with prime number interval
end, '<span foreground="${color}">${icon}</span>', 11, 'BAT0')
mybattery.font = beautiful.font_icon

-- for some reason, crashes if this is implemented like the battery
local wifi_interface = "wlp0s20f3"
mywifi = wibox.widget.textbox()
wifi_t = awful.tooltip({ objects = { mywifi }, })
vicious.register(mywifi, vicious.widgets.wifi,
    function(widget, args)
        args["{icon}"] = "󰤫"
        if args["{sign}"] == 0 then
            args["{icon}"] = "󰤮"
        elseif args["{sign}"] >= -70 then
            args["{icon}"] = "󰤨"
        elseif args["{sign}"] >= -80 then
            args["{icon}"] = "󰤥"
        elseif args["{sign}"] >= -90 then
            args["{icon}"] = "󰤢"
        elseif args["{sign}"] >= -100 then
            args["{icon}"] = "󰤟"
        end
        wifi_t:set_text(args["{ssid}"] .. "\n" .. args["{sign}"] .. " dBm")
        return args["{icon}"]
    end, 13, wifi_interface)
mywifi.font = beautiful.font_icon

--mynet = wibox.widget.textbox()
--vicious.register(mynet, vicious.widgets.net,
--        function (widget, args)
--            local down = args[string.format("{%s down_mb}", wifi_interface)] .. " MB/s"
--            local up = args[string.format("{%s up_mb}", wifi_interface)] .. " MB/s"
--            wifi_t:set_text(string.format("up: %s MB/s\ndown: %s MB/s", up, down))
--            return ""
--    end, 3, wifi_interface)

mybrightness = wibox.widget.textbox()

function mybrightness.get_icon()
    local icon = "?"

    if mybrightness.percent == 1 then
        icon = "󰃠"
    elseif mybrightness.percent >= 5 / 6 then
        icon = "󰃟"
    elseif mybrightness.percent >= 4 / 6 then
        icon = "󰃞"
    elseif mybrightness.percent >= 3 / 6 then
        icon = "󰃝"
    elseif mybrightness.percent >= 2 / 6 then
        icon = "󰃜"
    elseif mybrightness.percent >= 1 / 6 then
        icon = "󰃛"
    elseif mybrightness.percent >= 0 then
        icon = "󰃚"
    end

    return icon
end

local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

brightness_t = awful.tooltip({ objects = { mybrightness }, })
mybrightness.font = beautiful.font_icon

function mybrightness.set(percent)
    mybrightness.percent = clamp(percent, 0, 1)
    mybrightness.text = mybrightness.get_icon()
    brightness_t:set_text(string.format("%.0f%%", mybrightness.percent * 100))
end

-- initialize brightness
awesome.connect_signal("startup", function(c)
    -- this should work on the first try (call_now), but just in case use timer
    gears.timer {
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = function(self)
            awful.spawn.easy_async_with_shell("brightnessctl m", function(max)
                awful.spawn.easy_async_with_shell("brightnessctl g", function(cur)
                    -- naughty.notify { text = "brightness " .. cur .. " / " .. max }
                    if cur ~= "" and max ~= "" then
                        mybrightness.set(cur / max)
                        self:stop()
                    end
                end)
            end)
        end
    }
end)

myvolume = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
        font = beautiful.font_no_size .. " 48"
    },
    {
        id = "vol",
        widget = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal
}

function myvolume.set(percent)
    myvolume.percent = clamp(percent, 0, 100)
    myvolume:get_children_by_id("vol")[1].text = string.format("%d%%", myvolume.percent)
end

function myvolume.set_mute(muted)
    if muted or myvolume.percent == 0 then
        myvolume:get_children_by_id("icon")[1].text = "󰸈"
    else
        myvolume:get_children_by_id("icon")[1].text = "󱄠"
    end
end

function myvolume.toggle_mute()
    if myvolume:get_children_by_id("icon")[1].text == "󰸈"
        and myvolume.percent ~= 0 then
        myvolume:get_children_by_id("icon")[1].text = "󱄠"
    else
        myvolume:get_children_by_id("icon")[1].text = "󰸈"
    end
end

-- initialize volume
awesome.connect_signal("startup", function(c)
    -- getting values from pactl is fairly inconsistent for some reason
    -- so poll until initialized
    -- this always runs at least twice because the self:stop() doesn't work
    -- on the initial call_now iteration, presumably because the timer hasn't
    -- started yet
    gears.timer {
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = function(self)
            awful.spawn.easy_async_with_shell(
                "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -n 1",
                function(stdout)
                    -- naughty.notify({ text = "vol " .. stdout })
                    if stdout ~= "" then
                        myvolume.set(tonumber(stdout))
                        self:stop()
                    end
                end
            )
        end
    }

    gears.timer {
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = function(self)
            awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: )\\w+'",
                function(stdout)
                    -- naughty.notify({ text = "mute " .. stdout })
                    if stdout ~= "" then
                        myvolume.set_mute(stdout == "yes")
                        self:stop()
                    end
                end
            )
        end
    }
end)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following :isvisible()
            -- makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimise the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 36 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mygeeko,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacer,
            wibox.widget.systray(),
            spacer,

            right_separator,
            spacer,
            mythermalwidget,
            spacer,
            left_separator,

            spacer,
            mybrightness,
            spacer,

            right_separator,
            spacer,
            mywifi,
            spacer,
            left_separator,

            spacer,
            myvolume,
            spacer,

            right_separator,
            spacer,
            mybattery,
            spacer,
            left_separator,

            spacer,
            mydate,
            spacer,

            right_separator,
            spacer,
            mytextclock,
            spacer,
            left_separator,
            --s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings (change tag)
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

local function focus_for_layout(key)
    if mouse.screen.selected_tag.layout.name == "tilebottom" then
        if key == "j" then
            awful.client.focus.history.previous()
        elseif key == "k" then
            client.focus = awful.client.getmaster()
        elseif key == "h" then
            awful.client.focus.byidx(-1)
        elseif key == "l" then
            awful.client.focus.byidx(1)
        end
    else
        if key == "j" then
            awful.client.focus.byidx(1)
        elseif key == "k" then
            awful.client.focus.byidx(-1)
        elseif key == "h" then
            client.focus = awful.client.getmaster()
        elseif key == "l" then
            awful.client.focus.history.previous()
        end
    end
end

local function swap_for_layout(key)
    if mouse.screen.selected_tag.layout.name == "tilebottom" then
        if key == "j" then
            client.focus:swap(awful.client.focus.history.get(awful.screen.focused(), 1))
        elseif key == "k" then
            if client.focus ~= awful.client.getmaster() then
                client.focus = awful.client.getmaster()
                awful.client.focus.history.previous()
            end
            client.focus:swap(awful.client.getmaster())
        elseif key == "h" then
            awful.client.swap.byidx(-1)
        elseif key == "l" then
            awful.client.swap.byidx(1)
        end
    else
        if key == "j" then
            awful.client.swap.byidx(1)
        elseif key == "k" then
            awful.client.swap.byidx(-1)
        elseif key == "h" then
            -- put the master client in history before swap
            -- so a swap previous later will use old master
            -- but don't react to repeated master focus
            if client.focus ~= awful.client.getmaster() then
                client.focus = awful.client.getmaster()
                awful.client.focus.history.previous()
            end
            client.focus:swap(awful.client.getmaster())
        elseif key == "l" then
            client.focus:swap(awful.client.focus.history.get(awful.screen.focused(), 1))
        end
    end
end
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey, "Shift" }, "/", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Tab", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "j",
        function()
            focus_for_layout("j")
        end,
        { description = "focus next by index/focus previous by history", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            focus_for_layout("k")
        end,
        { description = "focus previous by index/focus master", group = "client" }
    ),
    awful.key({ modkey, }, "h",
        function()
            focus_for_layout("h")
        end,
        { description = "focus master/focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "l",
        function()
            focus_for_layout("l")
        end,
        { description = "focus previous by history/focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "v", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() swap_for_layout("j") end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() swap_for_layout("k") end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function() swap_for_layout("h") end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function() swap_for_layout("l") end,
        { description = "swap with previous client by index", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit,

        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "e", function() awful.spawn("systemctl suspend") end,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "x", function() awful.spawn("systemctl poweroff") end,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "j", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Control" }, "k", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Shift" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey, "Shift" }, "Return", function() awful.spawn("rofi -show drun") end,
        { description = "rofi drun", group = "launcher" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- System
    awful.key({}, "XF86AudioRaiseVolume", function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ false")
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
            myvolume.set(myvolume.percent + 2)
            myvolume.set_mute(false)
        end,
        { description = "raise volume", group = "system" }),
    awful.key({}, "XF86AudioLowerVolume", function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ false")
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
            myvolume.set(myvolume.percent - 2)
            myvolume.set_mute(false)
        end,
        { description = "lower volume", group = "system" }),

    awful.key({}, "XF86AudioMute", function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
            myvolume.toggle_mute()
        end,
        { description = "toggle mute", group = "system" }),

    awful.key({}, "XF86AudioMicMute", function()
            awful.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
        end,
        { description = "toggle mic mute", group = "system" }),
    awful.key({}, "XF86MonBrightnessUp", function()
            awful.spawn("brightnessctl set +10%")
            mybrightness.set(mybrightness.percent + 0.1)
        end,
        { description = "raise brightness", group = "system" }),
    awful.key({}, "XF86MonBrightnessDown", function()
            awful.spawn("brightnessctl set 10%-")
            mybrightness.set(mybrightness.percent - 0.1)
        end,
        { description = "lower brightness", group = "system" })
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, }, "Escape", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "b", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            if c.maximized then c.border_width = 0 else c.border_width = beautiful.border_width end
            c:raise()
        end,
        { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tabkeys = { "a", "s", "d", "f", "g", "q", "w", "e", "r" }
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, tabkeys[i],
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, tabkeys[i],
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, tabkeys[i],
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        tag:view_only()
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, tabkeys[i],
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        client.focus = c; c:raise()
    end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

local max_class = { "firefox", "discord", "RStudio", "QtCreator" }
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                -- To fix Flash fullscreen issues if still seeing bottom bar
                -- For chromium change "plugin-container" to "exe"
                "plugin-container",
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer" },

            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "pop-up",      -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- disable titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = false }
    },

    -- except maximized programs
    {
        rule = {},
        except_any = { class = max_class },
        properties = {
            border_width = beautiful.border_width,
        }
    },

    {
        rule_any = { class = max_class },
        properties = {
            maximized = true,
            border_width = 0,
        }
    },

    -- qt prevent stealing focus
    {
        rule_any = {
            class = {
                "xwordyzApp"
            }
        },
        properties = { focus = false }
    },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({}, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {     -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostarts and spawns
local function is_in_tag(cmd, tagname)
    local tag = awful.tag.find_by_name(awful.screen.focused(), tagname)

    for _, c in ipairs(tag:clients()) do
        if c.class == cmd then return true end
    end
    --return false
end

local function spawn_not_in_tag(cmd, tagname)
    if not is_in_tag(cmd, tagname) then
        awful.spawn(cmd, { tag = tagname })
    end
end
-- need this signal otherwise the client list doesn't update fast enough
-- to iterate through
awesome.connect_signal("startup", function(c)
    -- multistart protection in the bash script
    awful.spawn.with_shell("~/.config/awesome/autostart.sh")
    spawn_not_in_tag("firefox", "1")
    spawn_not_in_tag(terminal, "2")
end)

-- }}}
