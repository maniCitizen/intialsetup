#!/bin/bash

#Check if script is executed with root permissions

if [[ "${UID}" -eq 0 ]]
then
    echo "Please do not execute this script with sudo / root permissions"
    exit 1
fi

#Create a file for logs
LOGFILE="logfile.txt"

# Create a file for logs
touch ${LOGFILE}

# Distro information

DISTRO=$(. /etc/os-release && echo "$ID")

#Install zsh

## Install zsh in debian
debian_install()
{
    echo "Updates going on !!!"
    sudo apt-get update &>>${LOGFILE}
    echo "Installing zsh"
    sudo apt install zsh -y &>>${LOGFILE}

    if [[ "${?}" -ne 0 ]]
    then
        echo "Script could not proceed hereafter !!!"
        echo "Please check ${LOGFILE} in current directory for logs"
        exit 1
    fi
}

centos_install()
{
    echo "Updates going on !!!"
    sudo yum -y update &>>${LOGFILE}
    echo "Installing zsh"
    sudo yum install -y zsh &>>${LOGFILE}

    if [[ "${?}" -ne 0 ]]
    then
        echo "Script could not proceed hereafter !!!"
        echo "Please check ${LOGFILE} in current directory for logs"
        exit 1
    fi
}

case $DISTRO in
    ubuntu|debian)
        debian_install
        ;;
    centos|rhel|almalinux|rockylinux)
        centos_install
        ;;
esac

# Change defalt shell to ZSH

ZSH_PRESENT=$(cat /etc/shells | grep zsh)

if [[ "${?}" -ne 0 ]]
then
    echo "ZSH is not present !!!"
    exit 1
fi

sudo chsh -s $(which zsh) $(whoami)

if [[ "${?}" -ne 0 ]]
then
    echo "Shell not changed due to an error !!!"
    exit 1
fi

# Oh-my-zsh script
LINK="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Check if wget or curl exists
if  ! command -v wget &>/dev/null
then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" &>>${LOGFILE}
else
    echo "Installing oh-my-zsh"
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended" &>>${LOGFILE}
fi

if [[ "${?}" -ne 0 ]]
then
    echo "Error in installing oh-my-zsh"
    exit 1
fi

# Setup oh-my-zsh

# Clone zsh-syntax-highlighting
echo "Cloning zsh-syntax-highlighting"
git -C ~/.oh-my-zsh/custom/plugins clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git &>>${LOGFILE}

# Clone zsh-autosugestions
echo "Cloning zsh-autosuggestions"
git -C ~/.oh-my-zsh/custom/plugins clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git &>>${LOGFILE}

# Clone powerlevel10k theme
echo "Cloning powerlevel10k"
git -C ~/.oh-my-zsh/custom/themes clone --depth=1 https://github.com/romkatv/powerlevel10k.git &>>${LOGFILE}

# Copy the .p10.zsh file for customization
cp .p10k.zsh ~/

# Copy the .zshrc configuration file
cp .zshrc ~/

echo "Please exit of out of the shell and reload the session to see the effects"
exit 0