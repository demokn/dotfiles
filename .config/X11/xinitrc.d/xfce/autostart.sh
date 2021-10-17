# lightweight and minimal dock
plank &
# continuous file synchronization program
syncthing -no-browser &
# grabbing keys program for X
# default is $HOME/.xbindkeysrc
xbindkeys -f ${XDG_CONFIG_HOME:-$HOME/.config}/xbindkeys/config &
# notification service for the Xfce Desktop
# try to kill dunst first (used in dwm)
killall dunst ; /usr/lib/xfce4/notifyd/xfce4-notifyd &
