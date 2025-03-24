#!/bin/bash

# set -C（或 set -o noclobber）
# 作用: 防止 > 覆盖已有文件，避免意外删除数据。
# 如果确实要覆盖，可以使用 >| 强制写入
# set -f（或 set -o noglob）
# 作用: 禁用路径通配符（globbing），防止 *、?、[] 被展开。
set -C -f

# 计算文件缓存路径
hash() {
    printf '%s/lf/thumb.%s' "${XDG_CACHE_HOME:-$HOME/.cache}" "$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$1" | sha256sum | cut -d' ' -f1)"
    # stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$1"
    # %n：文件名
    # %i：inode 号
    # %F：文件类型
    # %s：文件大小
    # %W：文件创建时间（如果支持）
    # %Y：最后修改时间
    # \0 作为分隔符，确保字符串唯一性
    # cut -d' ' -f1 只取哈希值部分，去掉 sha256sum 可能附加的 -（表示标准输入）
}

# 预览图片
image() {
	if [ -n "$FIFO_UEBERZUG" ]; then
		local path="$(printf '%s' "$1" | sed 's/\\/\\\\/g;s/"/\\"/g')"
        printf '{"action": "add", "identifier": "PREVIEW", "x": %d, "y": %d, "width": %d, "height": %d, "scaler": "contain", "scaling_position_x": 0.5, "scaling_position_y": 0.5, "path": "%s"}\n' "$4" "$5" "$(($2-1))" "$(($3-1))" "$1" >"$FIFO_UEBERZUG"
        # Exits with code 1 to signal lf not to cache the result of the previewer script
        # so that the next time the user selects the same file the previewer script will be executed again
        exit 1
	else
		mediainfo "$6"
	fi
}

# 预览视频
video() {
    local cache
    cache="$(hash "$1").jpg"
    if [ -z "$FFTHUMB" ]; then
        FFTHUMB="$(command -v ffmpegthumbnailer)"
    fi

    if [ -n "$FFTHUMB" ]; then
        [ ! -f "$cache" ] && "$FFTHUMB" -i "$1" -o "$cache" -s 0
        image "$cache" "$2" "$3" "$4" "$5" "$1"
    else
        mediainfo "$1"
    fi
}

# 预览 PDF
pdf() {
    local cache
    cache="$(hash "$1")"
    if [ -z "$PDFTOPPM" ]; then
        PDFTOPPM="$(command -v pdftoppm)"
    fi

    if [ -n "$PDFTOPPM" ]; then
        [ ! -f "$cache.jpg" ] && "$PDFTOPPM" -jpeg -f 1 -singlefile "$1" "$cache"
        image "$cache.jpg" "$2" "$3" "$4" "$5" "$1"
    else
        mediainfo "$1"
    fi
}

# 预览文本
batorcat() {
    if [ -z "$BAT" ]; then
        BAT="$(command -v bat)"
    fi

    if [ -n "$BAT" ]; then
        "$BAT" --color=always --style=plain --pager=never "$1"
    else
        cat "$1"
    fi
}

# 获取文件的绝对路径
file="$(readlink -f "$1")"
shift

case "$(file -Lb --mime-type -- "$file")" in
    image/*) image "$file" "$@" "$file" ;;
    video/*) video "$file" "$@" ;;
    */pdf) pdf "$file" "$@" ;;
    text/* | */xml | application/json | application/x-ndjson) batorcat "$file" ;;
    application/*zip) command -v atool >/dev/null 2>&1 && atool --list -- "$file" || mediainfo "$file" ;;
    *opendocument*) command -v odt2txt >/dev/null 2>&1 && odt2txt "$file" || mediainfo "$file" ;;
    application/pgp-encrypted) gpg -d -- "$file" ;;
    *) file -Lb "$file" ;;
esac
