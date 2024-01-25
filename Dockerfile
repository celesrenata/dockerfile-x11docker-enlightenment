# x11docker/enlightenment
#
# Run enlightenment desktop in docker. 
#
# Use x11docker to run image. 
# Get x11docker script and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
#
# Run with hardware acceleration and init system runit:
#   x11docker --desktop --gpu --runit x11docker/enlightenment
#

# Options:
# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Sound support with option                    --alsa
# With pulseaudio in image, sound support with --pulseaudio
# Language locale setting with                 --lang=$LANG
#
# Look at x11docker --help for further options.

# Use the Arch Linux base image
FROM archlinux:latest

# Update the package database and install required dependencies
RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman-key --refresh-keys
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git enlightenment ecrire ephoto evisum rage terminology socat

# Update Go to ignore Amazon Proxy
# TODO: update to USE amazon proxy
ENV GOPROXY=direct

# Create a new user and make it a sudoer
RUN useradd -m -G wheel -s /bin/bash celes && \
    echo 'celes ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Switch to the new user
USER celes

# Install yay to make it easier to manage AUR packages
RUN git clone https://aur.archlinux.org/yay.git /home/celes/yay && \
    cd /home/celes/yay && \
    makepkg -si --noconfirm

# Install Userland dependencies
#RUN yay -S --noconfirm econnman edi enjoy-git eperiodique epour epymic-git eruler-git efbb-git elemines-git

# Cleanup
RUN rm -rf /home/celes/yay

# Switch back to root
USER root

# Specify the entry point
CMD /usr/bin/enlightenment_start
