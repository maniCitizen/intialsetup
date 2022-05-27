#!/bin/bash

#Check if script is executed with root permissions

if [[ "${UID}" -eq 0 ]]
then
    echo "Please do not execute this script with sudo / root permissions"
    exit 1
fi

# Function for exit status condition

exit_status()
{
    if [[ "${?}" -ne 0 ]]
    then
        echo $1
        exit 1
    fi
}

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

    exit_status "Script could not proceed hereafter !!! . Please check the ${LOGFILE} in current directory for logs."
}

centos_install()
{
    echo "Updates going on !!!"
    sudo yum -y update &>>${LOGFILE}
    echo "Installing zsh"
    sudo yum install -y zsh &>>${LOGFILE}

    exit_status "Script could not proceed hereafter !!! . Please check the ${LOGFILE} in current directory for logs."
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

exit_status "ZSH is not present !!!"

sudo chsh -s $(which zsh) $(whoami)

exit_status "Shell not changed due to an error !!!"

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

exit_status "Error in installing oh-my-zsh"

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

exit_status "Powerlevel theme was not cloned succesfully !!!"

# Copy the .p10.zsh file for customization
cp .p10k.zsh ~/

exit_status ".p10k.zsh was not copied usccessfully !!!"

# Copy the .zshrc configuration file
cp .zshrc ~/

exit_status ".zshrc was not copied successfully !!!"

echo "Please exit of out of the shell and reload the session to see the effects"
exit 0