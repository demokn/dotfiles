# lightweight and minimal dock
plank &
# continuous file synchronization program
syncthing -no-browser &
# grabbing keys program for X
xbindkeys &
# notification service for the Xfce Desktop
# try to kill dunst first (used in dwm)
killall dunst ; /usr/lib/xfce4/notifyd/xfce4-notifyd &
