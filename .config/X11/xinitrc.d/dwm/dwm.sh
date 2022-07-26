killall statusbar ; statusbar -d &
picom &
setbg &
# 解决首次进入 dwm 壁纸显示不完全, 有黑块的问题
(sleep 10 ; setbg) &
dunst &
# default is $HOME/.xbindkeysrc
xbindkeys -f ${XDG_CONFIG_HOME:-$HOME/.config}/xbindkeys/config &
fcitx5 &
unclutter &
