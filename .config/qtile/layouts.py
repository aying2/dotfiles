from libqtile import layout
from libqtile.config import Match

from colorschemes import colors

theme = {
    'border_focus' : colors[1], 
    'border_focus_stack' : [colors[8], colors[1]],
    'border_normal' : colors[6],
    'border_normal_stack' : [colors[8], colors[6]],
    'border_width' : 3,
    'margin' : 15,
}

layouts = [
        layout.Max(),
        layout.Columns(**theme),
        # Try more layouts by unleashing below layouts.
        #layout.Stack(num_stacks=2),
        #layout.Bsp(**theme),
        #layout.Matrix(),
        layout.MonadTall(**theme, ratio = 0.50),
        layout.MonadWide(**theme, ratio = 0.50),
        #layout.RatioTile(),
        #layout.Tile(),
        #layout.TreeTab(),
        #layout.VerticalTile(),
        #layout.Zoomy(),
    ]

web_layouts = [layouts[i] for i in [0, 1]]
terminal_layouts = [layouts[i] for i in [2, 3]]

floating_layout = layout.Floating(
    **theme,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="fortune"),  # for the lizard
    ]
)

