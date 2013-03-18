# Add the HipChat source to APT
ATLASSIAN_SOURCE_LIST="/etc/apt/sources.list.d/atlassian-hipchat.list"
if [ ! -f $ATLASSIAN_SOURCE_LIST ]; then
    echo "Installing Atlassian source list file to APT..."

    echo "deb http://downloads.hipchat.com/linux/apt stable main" > $ATLASSIAN_SOURCE_LIST
    wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
    apt-get update

    echo "Installing hipchat..."
    apt-get install hipchat 
else
    echo "Atlassian source list file already exists, not installing."
fi
