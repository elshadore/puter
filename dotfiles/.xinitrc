# export ADAM/EXMW-ENABLE=1
# exec dbus-launch --exit-with-session emacs -mm --debug-init

setxkbmap gb
xset r rate 200 80
xset s off -dpms
xrandr --output HDMI-1 --primary --output HDMI-2 --right-of HDMI-1
exec i3
