function _tide_pwd_multiline
    set_color -o $tide_pwd_color_anchors | read -l color_anchors
    set_color $tide_pwd_color_truncated_dirs | read -l color_truncated
    set -l reset_to_color_dirs (set_color normal -b $tide_pwd_bg_color; set_color $tide_pwd_color_dirs)

    set -l unwritable_icon $tide_pwd_icon_unwritable' '
    set -l home_icon $tide_pwd_icon_home' '
    set -l pwd_icon $tide_pwd_icon' '

    if set -l split_pwd (string replace -r '^$HOME' '~' -- $PWD | string split /)
        test -w . && set -f split_output "$pwd_icon$split_pwd[1]" $split_pwd[2..] ||
            set -f split_output "$unwritable_icon$split_pwd[1]" $split_pwd[2..]
        set split_output[-1] "$color_anchors$split_output[-1]$reset_to_color_dirs"
    else
        set -f split_output "$home_icon$color_anchors~"
    end

    string join / -- $split_output | string length -V | read -g _tide_pwd_len
    
    # If path is longer than available space and we're in a narrow terminal
    if test \( $_tide_pwd_len -gt $dist_btwn_sides \) -a \( $COLUMNS -lt 82 \)
        # Create multi-line output with path segments on separate lines
        set -l output "$reset_to_color_dirs$split_output[1]"
        for segment in $split_output[2..]
            set output "$output/\n$reset_to_color_dirs$segment"
        end
        printf $output
    else
        # Use the standard pwd function for normal display
        _tide_pwd
    end
end