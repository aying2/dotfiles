#!/bin/sh
~/.fehbg &
picom &
xinput set-prop "DELL0A68:00 0488:1024 Touchpad" "libinput Natural Scrolling Enabled" 1 &
xinput set-prop "DELL0A68:00 0488:1024 Touchpad" "libinput Accel Speed" 0.45 &
