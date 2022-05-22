#!/bin/bash

#Check if script is executed with root permissions

# if [[ "${UID}" -ne 0 ]]
# then
#     echo "Please execute this script with sudo / root permissions"
#     exit 1
# fi

# Create a file for logs
touch logfile.txt

# Distro information

DISTRO=$(. /etc/os-release && echo "$ID")

#Install zsh

## Install zsh in debian
debian_install()
{
    echo "Updates going on !!!"
    sudo apt-get update &>>logfile.txt
    echo "Installing zsh"
    sudo apt install zsh -y &>>logfile.txt

    if [[ "${?}" -ne 0 ]]
    then
        echo "Script could not proceed hereafter !!!"
        echo "Please check logfile.txt in current directory for logs"
        exit 1
    fi
}

centos_install()
{
    echo "Updates going on !!!"
    sudo yum -y update &>>logfile.txt
    echo "Installing zsh"
    sudo yum install -y zsh &>>logfile.txt

    if [[ "${?}" -ne 0 ]]
    then
        echo "Script could not proceed hereafter !!!"
        echo "Please check logfile.txt in current directory for logs"
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
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
else
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended"
fi

if [[ "${?}" -ne 0 ]]
then
    echo "Error in installing oh-my-zsh"
    exit 1
fi

# Setup oh-my-zsh

git -C ~/.oh-my-zsh/custom/plugins clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git
git -C ~/.oh-my-zsh/custom/plugins clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
git -C ~/.oh-my-zsh/custom/themes clone --depth=1 https://github.com/romkatv/powerlevel10k.git

cp .p10k.zsh ~/

cat >~/.zshrc <<\END
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH=~/.oh-my-zsh
DISABLE_AUTO_UPDATE=true
DISABLE_MAGIC_FUNCTIONS=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/.p10k.zsh
END

echo "Please exit of out of the shell and reload the session to see the effects"
exit 0