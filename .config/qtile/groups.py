from libqtile.config import Group, ScratchPad, DropDown
from layouts import web_layouts, terminal_layouts

terminal = "kitty"

web_theme = {
    'layout' : 'max',
    'layouts' : web_layouts,
}

terminal_theme = {
    'spawn' : [terminal for i in range(1)],
    'layout' : 'monadtall',
    'layouts' : terminal_layouts
}

groups = [
    Group("web", spawn='firefox', layout='max', label = '1'),
    Group("terminal", **terminal_theme, label='2'),
    Group("terminal2", **terminal_theme, label='3'),
    Group("youtube", layout='max', label = '4'),
    Group("mpv", label = '5'),
    Group("mpv", label = '6'),
    Group("mpv", label = '7'),
    Group("mpv", label = '8'),
    #ScratchPad("scratchpad", [
    #    # define a drop down terminal.
    #    # it is placed in the upper third of screen by default.
    #    DropDown("dropdown", 'kitty'),
    #]),
]

