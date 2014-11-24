fix_resolution() {
    # laptop resolution is (toodamnhigh)

    # My Dell laptop display is ~254 DPI; when set to 1920x1080 (about 150 DPI),
    # it's usable in Linux.

        #sed -r -e 's/^(\w+) connected \w* ?([0-9]+)x([0-9]+)\+[0-9]+\+[0-9]+ \(.*\) ([0-9]+)mm x ([0-9]+)mm$/\1 \2 \3 \4 \5/g')
    CONNECTED_OUTPUTS=$(xrandr --current | \
        grep " connected" | \
        sed -r -e 's/^(\w+) connected( | primary) ?([0-9]+)x([0-9]+)\+[0-9]+\+[0-9]+ \(.*\) ([0-9]+)mm x ([0-9]+)mm$/\1|\2|\3|\4|\5|\6/g')
    CURRENT_PRIMARY=""
    TARGET_PRIMARY=""

    # CONNECTED_OUTPUTS looks like:
    #
    #     eDP1| primary|1920|1080|346|194
    #     DP2| |2560|1600|123|456

    while read CONNECTED_OUTPUT
    do
        IFS="|" read OUTPUT PRIMARY X_PX Y_PX X_MM Y_MM <<<"$CONNECTED_OUTPUT"
        if [[ "$PRIMARY" == " primary" ]]; then
            CURRENT_PRIMARY=$OUTPUT
        fi
        # X_DPI=$(echo "$X_PX / ($X_MM / 25.4)" | bc)
        # Y_DPI=$(echo "$Y_PX / ($Y_MM / 25.4)" | bc)
        if [[ $X_PX == 3200 && $Y_PX == 1800 ]]; then
            xrandr --output $OUTPUT --mode 1920x1080
            echo "Laptop resolution corrected at $(date)" >> /tmp/display_fix.log
        elif [[ $X_MM -ge 640 && $Y_MM -ge 400 && $TARGET_PRIMARY == "" ]]; then
            TARGET_PRIMARY=$OUTPUT
        fi
    done <<<"$CONNECTED_OUTPUTS"
}

fix_resolution

if [[ -n $TARGET_PRIMARY && $CURRENT_PRIMARY != $TARGET_PRIMARY ]]; then
    xrandr --output $TARGET_PRIMARY --primary
fi
