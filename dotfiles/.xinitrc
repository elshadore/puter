## Xinit Script

puter-xsettings
puter-pape

## XDG Config Stuff to Prevent Firefox from not being able to open the Save File Menu
systemctl --user import-environment DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP

exec i3

## EXWM
# export ADAM_EXWM_ENABLE=1
# exec dbus-launch --exit-with-session emacs -mm --debug-init
