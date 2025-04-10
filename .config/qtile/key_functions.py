from libqtile.command import lazy
from libqtile import qtile

@lazy.function
def focus_left(qtile):
    layout = qtile.current_layout

def focus_right():
    if qtile.current_layout.name == 'monadtall':
        return lazy.group.focus_back()
    else:
        return lazy.layout.right()

@lazy.function
def focus_up(qtile):
    layout = qtile.current_layout

@lazy.function
def focus_down(qtile):
    layout = qtile.current_layout


'''
# BSP resizing taken from https://github.com/qtile/qtile/issues/1402
def resize(qtile, direction):
    layout = qtile.current_layout
    child = layout.current
    parent = child.parent

    while parent:
        if child in parent.children:
            layout_all = False

            if (direction == "left" and parent.split_horizontal) or (direction == "up" and not parent.split_horizontal):
                parent.split_ratio = max(5, parent.split_ratio - layout.grow_amount)
                layout_all = True
            elif (direction == "right" and parent.split_horizontal) or (direction == "down" and not parent.split_horizontal):
                parent.split_ratio = min(95, parent.split_ratio + layout.grow_amount)
                layout_all = True

            if layout_all:
                layout.group.layout_all()
                break

        child = parent
        parent = child.parent

@lazy.function
def resize_left(qtile):
    resize(qtile, "left")

@lazy.function
def resize_right(qtile):
    resize(qtile, "right")

@lazy.function
def resize_up(qtile):
    resize(qtile, "up")

@lazy.function
def resize_down(qtile):
    resize(qtile, "down")
'''
