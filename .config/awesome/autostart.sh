#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run ~/.fehbg
run picom --backend glx &
run xinput set-prop "DELL0A68:00 0488:1024 Touchpad" "libinput Natural Scrolling Enabled" 1
run xinput set-prop "DELL0A68:00 0488:1024 Touchpad" "libinput Accel Speed" 0.45
run xset s 900
export XSECURELOCK_SAVER=saver_mpv 
export XSECURELOCK_IMAGE_DURATION_SECONDS=9223372036854775807
export XSECURELOCK_LIST_VIDEOS_COMMAND=$'grep -oP "(?<=\').+(?=\')" ~/.fehbg'
export XSECURELOCK_PASSWORD_PROMPT=time_hex 
export XSECURELOCK_AUTH_FOREGROUND_COLOR="#918d36" # middle yellow
export XSECURELOCK_AUTH_BACKGROUND_COLOR="#222222"
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
