#!/bin/bash

LOGFILE="logfile.txt"

# Function for exit status

exit_status()
{
    if [[ "${?}" -ne 0 ]]
    then
        echo $1
    fi
}

# Dialog box for installation of tools

SELECTED=($(whiptail --title "SELECT PACKAGES TO INSTALL" --checklist \
"List of tools" 20 100 10 \
"tmux" "Terminal multiplexer" OFF \
"trash-cli" "Safe Alternative for rm command" OFF \
"ranger" "Terminal file manager" OFF \
"asciinema" "Terminal session recording tool" OFF \
"filebrowser" "Locally hosted Google Drive" OFF 3>&1 1>&2 2>&3))

# Install tmux

tmux_install()
{
    echo "Installing tmux"
    sudo apt-get install -y tmux &>>${LOGFILE}
    exit_status "Tmux not installed properly !!!"
}

#Install trash-cli

trash_cli_install()
{
    echo "Installing trash-cli"
    sudo apt-get install -y trash-cli &>>${LOGFILE}
    exit_status "trash_cli not installed properly !!!"
}

# Install ranger

ranger_install()
{
    echo "Installing ranger"
    sudo apt-get install -y ranger &>>${LOGFILE}
    exit_status "ranger not installed properly !!!"
}

# Install asciinema

asciinema_install()
{
    echo "Installing asciinema"
    sudo apt-get install -y asciinema &>>${LOGFILE}
    exit_status "asciinema not installed properly !!!"
}

# Install filebrowser

filebrowser_install()
{
    echo "Coming soon !!!"
    sudo apt-get install -y filebrowser &>>${LOGFILE}
    exit_status "filebrowser not installed properly !!!"
}


for i in ${SELECTED[@]}
do
    tool=$(echo $i | sed -e 's/"//g')
    case $tool in
        "tmux")
            tmux_install
        ;;
        "trash-cli")
            trash_cli_install
        ;;
        "ranger")
            ranger_install
        ;;
        "asciinema")
            asciinema_install
        ;;
        "filebrowser")
            filebrowser_install
        ;;
    esac
done