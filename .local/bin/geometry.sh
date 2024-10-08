#! /bin/bash
# 用于获取st的准确geometry座标 且支持多屏幕

parse_params() {
    position=$1      # 1: 位置 top_left or top_right
    c=$2             # 2: 列数
    l=$3             # 3: 行数
    diffc=${4:-0}    # 4: 列差
    diffl=${5:-0}    # 5: 行差
    diffxgap=${6:-0} # 6: x方向偏移(以gap为单位)
    diffygap=${7:-0} # 7: y方向偏移(以gap为单位)
}

parse_default() {
    uw=8; uh=17;  # 单位宽高
    gap=12;       # 边距
    barh=31;      # 状态栏高度
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    if [ "$mx" -lt 1920 ]; then
        wx=0; wy=0; ww=1920; wh=1080
        if [ $(xrandr --listmonitors | sed 1d | wc -l) -eq 1 ]; then # 如果是单屏
            ww=1440; wh=900
        fi
    else
        wx=1920; wy=325; ww=1440; wh=900
    fi
}

parse_default
parse_params $*
case $position in
    top_left)
        x=$(( $wx + $gap))
        x=$(( $x + $diffc * $uw + $diffxgap * $gap ))
        y=$(( $wy + $gap + $barh ))
        y=$(( $y + $diffl * $uh + $diffygap * $gap ))
        ;;
    top_right)
        x=$(( $wx + $ww - $gap - $c * $uw ))
        x=$(( $x + $diffc * $uw + $diffxgap * $gap ))
        y=$(( $wy + $gap + $barh ))
        y=$(( $y + $diffl * $uh + $diffygap * $gap ))
        ;;
esac
echo $c\x$l+$x+$y
