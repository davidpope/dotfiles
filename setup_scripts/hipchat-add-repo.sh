# Add the HipChat source to APT

if [ "$USER" != "root" ]; then
    echo "You must be root to run this tool."  # sudo counts too
    exit 1
fi

ATLASSIAN_SOURCE_LIST="/etc/apt/sources.list.d/atlassian-hipchat.list"
if [ ! -f $ATLASSIAN_SOURCE_LIST ]; then
    echo "Installing Atlassian source list file to APT..."

    echo "deb http://downloads.hipchat.com/linux/apt stable main" > $ATLASSIAN_SOURCE_LIST
    wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -

    cat <<EOF
    Atlassian source list added, now 'apt-get update' and 'apt-get install hipchat'.
EOF
else
    echo "Atlassian source list file already exists, not installing."
fi
