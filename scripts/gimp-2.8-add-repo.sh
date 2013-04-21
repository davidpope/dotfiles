# For Ubuntu 12.04, add the gimp 2.8 repo.

# The Gimp 2.8 has a single-window mode that fits very nicely with the
# Awesome window manager; stock Ubuntu 12.04 only includes version 2.6.

if [ "$USER" != "root" ]; then
    echo "You must be root to run this tool."  # sudo counts too
    exit 1
fi

[ -f /etc/os-release ] && . /etc/os-release
if [ "x$VERSION_ID" != "x12.04" ]; then
    echo "This does not appear to be an Ubuntu 12.04 system, not adding Gimp 2.8 repo."
    exit 1
fi

# there seems to be no direct way to query whether a repo has already been added
GIMP_PRECISE_SOURCE_LIST="/etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list"
if [ ! -f $GIMP_PRECISE_SOURCE_LIST ]; then
    echo "Installing Otto Kesselgulasch's Gimp 2.8 repository to APT..."
    apt-add-repository ppa:otto-kesselgulasch/gimp
    cat <<EOF

    Added the Gimp 2.8 PPA to this Ubuntu 12.04 system, thanks Otto Kesselgulasch!

    Now 'apt-get update' and 'apt-get install gimp'.

    Note: For some reason, The Gimp 2.8's single-window mode is accessed via
    the Windows menu, not Preferences.

EOF
else
    echo "Gimp 2.8 source list file already exists, not installing."
    exit 1
fi
