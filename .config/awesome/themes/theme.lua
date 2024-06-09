theme = {}

theme.font_no_size          = "SauceCodePro NFM Semibold"
theme.font          = theme.font_no_size .. " 12"
theme.font_icon          = theme.font_no_size .. " 36"
theme.font_sep          = theme.font_no_size .. " 24"
theme.font_space          = theme.font_no_size .. " 12"

local bg_alpha = "55"
theme.bg_normal     = "#222222" .. bg_alpha
theme.bg_focus      = "#62a541" .. bg_alpha
theme.bg_urgent     = "#ff0000" .. bg_alpha
theme.bg_minimize   = "#444444" .. bg_alpha
theme.bg_systray    = theme.bg_normal .. bg_alpha

local fg_alpha = "DD"

theme.fg_normal     = "#e2e2e3" .. fg_alpha
theme.fg_focus      = "#e2e2e3" .. fg_alpha
theme.fg_urgent     = "#e2e2e3" .. fg_alpha
theme.fg_minimize   = "#e2e2e3" .. fg_alpha

theme.border_width  = 1
theme.border_normal = "#605d68" .. fg_alpha -- the next shade from mycolor.space
theme.border_focus  = "#e2e2e3" .. fg_alpha
theme.border_marked = "#91231c" .. fg_alpha
theme.useless_gap = 15.0/2

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/openSUSE/submenu.png"
theme.menu_height = 25
theme.menu_width  = 200

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

--theme.wallpaper = "~/Pictures/Wallpapers/Transmission_75.png"

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/openSUSE/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/openSUSE/layouts/fairvw.png"
theme.layout_floating  = "/usr/share/awesome/themes/openSUSE/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/openSUSE/layouts/magnifierw.png"
theme.layout_max = "/usr/share/awesome/themes/openSUSE/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/openSUSE/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/openSUSE/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/openSUSE/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/openSUSE/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/openSUSE/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/openSUSE/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/openSUSE/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
theme.opensuse_icon = "~/.config/awesome/themes/button-unfilled-color.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
