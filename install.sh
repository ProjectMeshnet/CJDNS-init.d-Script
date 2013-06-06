#!/bin/bash

# Used to install and uninstall cjdns

# Make sure these values align with those in the init script
GIT_PATH=/opt/cjdns
CJDNS_CONFIG=/etc/cjdroute.conf

Usage() {
    echo "Usage: $0 [OPTIONS]"
    echo 
    echo "-I, --install         Install cjdns to your system"
    echo "-D, --uninstall       Remove cjdns from your system"
}

RootCheck() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

Setup() {
    echo "Create cjdns installation folder if it does not exist: $GIT_PATH."
    mkdir -p $GIT_PATH
    echo "Ensuring you have the required software: cmake make git build-essential"
    # Hopefully you are on ubuntu/debian
    apt-get install -y cmake make git build-essential
    echo "Cloning from github..."
    cd $GIT_PATH/../
    git clone https://github.com/cjdelisle/cjdns.git cjdns
    echo "Compiling software..."
    cd $GIT_PATH
    ./do

    if [ -f $CJDNS_CONFIG ]; then #check if config file already exist.
        echo
        echo "A config file is already here ($CJDNS_CONFIG),"
        echo "So we're not going to generate a new one"
        echo
    else
        echo
        echo "There is not a config file ($CJDNS_CONFIG) detected. "
        echo "**Generating a config file ($CJDNS_CONFIG)..."
        echo
        $GIT_PATH/cjdroute --genconf > $CJDNS_CONFIG
        echo
        echo "Please add some peers (optional)..."
    fi

    echo "Installing init script"
    cp hyperboria.sh /etc/init.d/cjdns
    echo "Autostarting cjdns"
    update-rc.d cjdns defaults

    echo
    echo "Cjdns has successfully been installed!"
    echo "Now go find some peers online (IRC, Node Map, etc.)"
    echo
}


Delete() {
    echo 
    echo "[**WARNING**]"
    read -p "Are you SURE your want to DELETE cjdns from this system? NOTE: this will not delete the config file($CJDNS_CONFIG): (Y/n). " choice
    case "$choice" in 
        y|Y ) 
            echo "**Stopping cjdns..."
            killall cjdroute
            sleep 3
            echo
            echo "**Deleting cjdns files from your system ($GIT_PATH)"
            sleep 2
            rm -rf $GIT_PATH 
            echo
            echo "Your configuration file ($CJDNS_CONFIG) still exists."
            echo "You many want to keep this for later use.  You can also"
            echo "delete the init script (/etc/init.d/cjdns.sh)"
            echo
        ;;
        **) 
            echo "**Exiting uninstall of cjdns. You have done nothing :)..."
        ;;
    esac

if [ $# -eq 0 ]; then  
    Usage
    exit 1
else if [ $# -gt 1 ]; then
    echo "Too Many Arguments"
    Usage
    exit 1
fi

case $1 in
    -I|-i|--install|setup)
        RootCheck
        Setup
        exit 0
    ;;
    -D|-d|--uninstall)
        RootCheck
        Delete
        exit 0
    ;;
    **)
        Usage
        exit 1
    ;;
esac
