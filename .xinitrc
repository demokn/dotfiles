#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.config/X11/xresources
usermodmap=$HOME/.config/X11/xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

userscripts=$HOME/.config/X11/xinitrc.d
sysscripts=/etc/X11/xinit/xinitrc.d

SESSION=${1:-xfce}

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d "$sysscripts" ] ; then
    for f in $sysscripts/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -d "$userscripts" ] ; then
    for f in $userscripts/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f

    if [ -d "$userscripts/$SESSION" ] ; then
        for f in $userscripts/$SESSION/?*.sh ; do
            [ -x "$f" ] && . "$f"
        done
        unset f
    fi
fi

get_prog(){
	local prog=""
	case "$SESSION" in
		awesome) prog+=(awesome) ;;
		bspwm) prog+=(bspwm-session) ;;
		budgie) prog+=(budgie-desktop) ;;
		cinnamon) prog+=(cinnamon-session) ;;
		deepin) prog+=(startdde) ;;
		dwm) prog+=(dwm) ;;
		enlightenment) prog+=(enlightenment_start) ;;
		fluxbox) prog+=(startfluxbox) ;;
		gnome) prog+=(gnome-session) ;;
		i3|i3wm) prog+=(i3 --shmlog-size 0) ;;
		jwm) prog+=(jwm) ;;
		kde) prog+=(startkde) ;;
		lxde) prog+=(startlxde) ;;
		lxqt) prog+=(lxqt-session) ;;
		mate) prog+=(mate-session) ;;
		xfce) prog+=(xfce4-session) ;;
		openbox) prog+=(openbox-session) ;;
		*) prog+=("$SESSION") ;;
	esac

	echo "${prog[*]}"
}

exec $(get_prog)

# 使用下面的 dbus-launch 方式启动, 会导致 dunst 启动失败, "Cannot connect to DBUS" 
# get_session(){
# 	local dbus_args=(--sh-syntax --exit-with-session)
# 	case "$SESSION" in
# 		awesome) dbus_args+=(awesome) ;;
# 		bspwm) dbus_args+=(bspwm-session) ;;
# 		budgie) dbus_args+=(budgie-desktop) ;;
# 		cinnamon) dbus_args+=(cinnamon-session) ;;
# 		deepin) dbus_args+=(startdde) ;;
# 		dwm) dbus_args+=(dwm) ;;
# 		enlightenment) dbus_args+=(enlightenment_start) ;;
# 		fluxbox) dbus_args+=(startfluxbox) ;;
# 		gnome) dbus_args+=(gnome-session) ;;
# 		i3|i3wm) dbus_args+=(i3 --shmlog-size 0) ;;
# 		jwm) dbus_args+=(jwm) ;;
# 		kde) dbus_args+=(startkde) ;;
# 		lxde) dbus_args+=(startlxde) ;;
# 		lxqt) dbus_args+=(lxqt-session) ;;
# 		mate) dbus_args+=(mate-session) ;;
# 		xfce) dbus_args+=(xfce4-session) ;;
# 		openbox) dbus_args+=(openbox-session) ;;
# 		*) dbus_args+=("$SESSION") ;;
# 	esac
# 
# 	echo "dbus-launch ${dbus_args[*]}"
# }
# 
# exec $(get_session)
