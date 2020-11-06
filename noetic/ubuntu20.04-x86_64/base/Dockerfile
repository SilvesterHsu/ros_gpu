FROM ubuntu:20.04

ARG shell=/bin/bash
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt install lsb-release gnupg2 zsh -y && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt update && \
    apt install ros-noetic-desktop-full -y && \
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && \
    apt install python3-pip -y && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    rm -rf /var/lib/apt/lists/*
