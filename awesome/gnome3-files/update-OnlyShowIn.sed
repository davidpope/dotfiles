/^OnlyShowIn=/ {
    # copy pattern space to hold space
    h
    # comment out the original and add a note
    i # Modified by davidp to run under Awesome
    s/^\(.*\)$/# \1/p
    # copy hold space back to pattern space
    g
    # output modified line
    s/^\(.*\)$/\1Awesome;/
}
