#!/bin/bash

set -C -f

image() {
	if [ -n "$FIFO_UEBERZUG" ]; then
		path="$(printf '%s' "$1" | sed 's/\\/\\\\/g;s/"/\\"/g')"
		printf '{"action": "add", "identifier": "PREVIEW", "x": %d, "y": %d, "width": %d, "height": %d, "scaler": "contain", "scaling_position_x": 0.5, "scaling_position_y": 0.5, "path": "%s"}\n' "$4" "$5" "$2" "$3" "$1" >"$FIFO_UEBERZUG"
        # Exits with code 1 to signal lf not to cache the result of the previewer script
        # so that the next time the user selects the same file the previewer script will be executed again
        exit 1
	else
		mediainfo "$1"
	fi
}

video() {
    file="$1"
    shift

    cache="$(hash "$file").jpg"
    if [ -n "$FIFO_UEBERZUG" ]; then
        ffmpegthumbnailer -i "$file" -o "$cache" -s 0
        image "$cache" "$@"
    else
        mediainfo "$file"
    fi
}

hash() {
  printf '%s/.cache/lf/%s' "$HOME" "$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}')"
}

file="$1"
shift

case "$(file -Lb --mime-type -- "$file")" in
    image/*) image "$file" "$@" ;;
    video/*) video "$file" "$@" ;;
    *) bat "$file" ;;
esac
