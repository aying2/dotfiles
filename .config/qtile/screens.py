from libqtile.config import Screen
from libqtile import bar, widget
from libqtile.lazy import lazy
from colorschemes import colors

widget_defaults = dict(
    font = 'SauceCodePro NFM',
    fontsize=16,
    padding=5,
)
extension_defaults = widget_defaults.copy()
# Inspiration
# https://github.com/IV4NTMR/Qtile-Chainsawman/blob/main/qtile/config.py
bar_widgets = [
    widget.Sep(
        linewidth=0,
        padding=10,
        foreground=colors[0],
        background=colors[4]
    ),
    widget.TextBox(
        font = 'Inconsolata NFM',
        fontsize=72,
        text=u'\uf314',
        foreground=colors[0],
        background=colors[4],
        padding=2,
        mouse_callbacks={'Button1': lazy.spawn("kitty --hold fortune")},
        #mouse_callbacks={'Button1': lazy.group["scratchpad"].dropdown_toggle("dropdown")},
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b0',
        foreground=colors[4],
        background=colors[0],
        padding=0,
    ),
    widget.GroupBox(
        **widget_defaults,
        highlight_color=colors[10],
        highlight_method='line',
        this_current_screen_border=colors[4],
        foreground=colors[1],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b0',
        foreground=colors[0],
        background=colors[8],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[8]
    ),
    widget.CurrentLayout(
        **widget_defaults,
        foreground=colors[0],
        background=colors[8],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b0',
        foreground=colors[8],
        background=colors[0],
        padding=0,
    ),
    widget.WindowName(
        **widget_defaults,
        foreground=colors[1],
        background=colors[0],
    ),
    widget.Pomodoro(
        **widget_defaults,
        foreground=colors[1],
        background=colors[0],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[3],
        background=colors[0],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[3],
    ),
    widget.TextBox(
        font = 'DroidSansMono NFM',
        fontsize=24,
        text='󱩅 ',
        foreground=colors[0],
        background=colors[3],
        padding=0,
    ),
    widget.ThermalSensor(
        **widget_defaults,
        fmt = '{}',
        foreground=colors[0],
        background=colors[3],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[3],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[0],
        background=colors[3],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'DroidSansMono NFM',
        fontsize=32,
        text='',
        foreground=colors[1],
        background=colors[0],
        padding=0,
    ),
    widget.Memory(
        **widget_defaults,
        fmt = "{}",
        format = '{MemUsed: .1f} GB',
        measure_mem = 'G',
        foreground=colors[1],
        background=colors[0],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[8],
        background=colors[0],
        padding=0,
    ),
#    widget.Backlight(
#        **widget_defaults,
#        fmt = "LIT: {}",
#        backlight_name='intel_backlight',
#        foreground=colors[0],
#        background=colors[8]
#    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[8],
    ),
    widget.TextBox(
        font = 'VictorMono NFM',
        fontsize=42,
        text='󰖩',
        foreground=colors[0],
        background=colors[8],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[8],
    ),
    widget.Net(
        **widget_defaults,
        #format = '{down} ' + '' + '' + ' {up}',
        format = '{down}',
        foreground=colors[0],
        background=colors[8],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[8],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[0],
        background=colors[8],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'DroidSansMono NFM',
        fontsize=32,
        text='墳',
        foreground=colors[1],
        background=colors[0],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=6,
        background=colors[0],
    ),
    widget.PulseVolume(
        **widget_defaults,
        fmt = "{}",
        update_interval=0,
        foreground=colors[1],
        background=colors[0],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[5],
        background=colors[0],
        padding=0,
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[5],
    ),
    widget.Battery(
        font = 'DroidSansMono NFM',
        fontsize=22,
        #fmt = "BAT: {}",
        charge_char = '',
        discharge_char = '',
        empty_char = '',
        full_char = '',
        format = '{char}',
        update_interval=0,
        foreground=colors[0],
        background=colors[5],
    ),
    widget.Sep(
        linewidth=0,
        padding=4,
        background=colors[5],
    ),
    widget.Battery(
        **widget_defaults,
        #fmt = "BAT: {}",
        format = '{percent:2.0%}',
        update_interval=0,
        foreground=colors[0],
        background=colors[5],
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[5],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[0],
        background=colors[5],
        padding=0,
    ),
    widget.Clock(
        **widget_defaults,
        format="%a, %d %b %Y",
        foreground=colors[1],
        background=colors[0]
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        background=colors[0],
    ),
    widget.TextBox(
        font = 'Hack',
        fontsize=32,
        text=u'\ue0b2',
        foreground=colors[4],
        background=colors[0],
        padding=0,
    ),
    widget.Clock(
        **widget_defaults,
        format="%I:%M %p",
        foreground=colors[0],
        background=colors[4]
    ),
    widget.Sep(
        linewidth=0,
        padding=5,
        foreground=colors[1],
        background=colors[4]
    ),
]


screens = [
    Screen(
        top=bar.Bar(
            bar_widgets,
            size = 36,
            background=colors[0],
            #margin = [15, 15, 0, 15],
            #border_width=[0, 0, 3, 0],
            border_width=0,
            border_color=colors[0],
        ),
    ),
]

