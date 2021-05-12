#!/usr/bin/env bash
#
# emoji.gen.sh

fmt_emoji_file=$HOME/.local/share/emoji
# TODO: 从官网 https://unicode.org/Public/emoji/ 下载最新的 emoji-test.txt 文件
emoji_data_file=/usr/share/unicode/emoji/emoji-test.txt
# 该脚本是生成 https://github.com/LukeSmithxyz/voidrice 库中提供的 emoji 文件格式
# 思路参考自 https://github.com/LukeSmithxyz/voidrice/pull/753
sed '/; fully-qualified/!d ; s/^\(.*\); fully-qualified\s*# \(.*\) E[0-9]\+\.[0-9]\+ \(.*\)$/\2 \3; \1/ ; s/\s*$/;/' $emoji_data_file | sed "/$(echo -ne '\u200d')/d ; /$(echo -ne '\U1F3FB')/d ; /$(echo -ne '\U1F3FC')/d ; /$(echo -ne '\U1F3FD')/d ; /$(echo -ne '\U1F3FE')/d ; /$(echo -ne '\U1F3FF')/d ;" > $fmt_emoji_file
