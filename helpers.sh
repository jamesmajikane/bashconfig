#!/bin/bash

spinner ()
{
    bar=" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;34m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}



# Show "Done."
function say_done() {
    echo " "
    echo -e "Done."
    say_continue
}


# Ask to Continue
function say_continue() {
    echo -n " To EXIT Press x Key, Press ENTER to Continue"
    read acc
    if [ "$acc" == "x" ]; then
        exit
    fi
    echo " "
}
# Obtain Server IP
function __get_ip() {
    serverip=$(ip route get 1 | awk '{print $NF;exit}')
    echo $serverip
}