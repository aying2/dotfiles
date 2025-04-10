from libqtile.config import Key, Drag, Click, Group
from libqtile.command import lazy
from groups import groups

#from key_functions import focus_right

mod = "mod4"
terminal = "kitty"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], 
        "l", 
        lazy.layout.right().when(layout='columns'), 
        lazy.layout.right().when(layout='monadwide'), 
        lazy.layout.right().when(layout='max'), 
        lazy.group.focus_back().when(layout='monadtall'), 
        desc="Move focus to right"
    ),
    Key([mod], 
        "j", 
        lazy.layout.down().when(layout='columns'), 
        lazy.layout.down().when(layout='monadtall'), 
        lazy.layout.down().when(layout='max'), 
        lazy.group.focus_back().when(layout='monadwide'), 
        desc="Move focus down"
    ),
    Key([mod],
        "k",
        lazy.layout.up(),
        #lazy.layout.up().when(layout='columns'),
        #lazy.layout.up().when(layout='monadtall'),
        #lazy.group.focus_by_index(0).when(layout='monadwide'),
        desc="Move focus up"
    ),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.shrink_main(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_main(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),  

    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "control"], "n", lazy.layout.reset(), desc="Reset all window sizes"),

    Key([mod], "t",
        lazy.window.toggle_floating(),
        desc='toggle floating'
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control"], "e", lazy.spawn("systemctl suspend"), desc="Suspend"),
    Key([mod, "control"], "x", lazy.spawn("systemctl hibernate"), desc="Hibernate"),
    Key([mod], "r", lazy.spawn('rofi -show drun'), desc="Spawn a command using a prompt widget"),

    # Change the volume if our keyboard has keys
    Key([], "XF86AudioRaiseVolume", 
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ false"), 
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
        ),
    Key([], "XF86AudioLowerVolume", 
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ false"), 
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
        ),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
]
group_keys = "asdfguiop1234567890"

for i, group in enumerate(groups):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                group_keys[i],
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group_keys[i],
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
