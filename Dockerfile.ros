FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python3-pip python3-dev build-essential \
        python-pip python-dev \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
        terminator \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# =================================
# install ros (source: https://github.com/osrf/docker_images/blob/5399f380af0a7735405a4b6a07c6c40b867563bd/ros/kinetic/ubuntu/xenial/ros-core/Dockerfile)
# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# =================================
# build geometry and geometry2 from source with python3.6
# (source: https://answers.ros.org/question/326226/importerror-dynamic-module-does-not-define-module-export-function-pyinit__tf2/)
RUN apt update \
    && apt install python3-catkin-pkg-modules python3-rospkg-modules python3-empy -y

RUN mkdir -p /root/catkin_ws/src; cd /root/catkin_ws \
    && apt update \
    && . /opt/ros/melodic/setup.sh \
    && catkin_make \
    && wstool init \
    && wstool set -y src/geometry2 --git https://github.com/ros/geometry2 -v 0.6.5 \
    && wstool set -y src/geometry --git https://github.com/ros/geometry -v 1.12.1 \
    && wstool up \
    && pip3 install rosdep numpy\
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -y -r \
    && catkin_make --cmake-args \
            -DCMAKE_BUILD_TYPE=Release \
            -DPYTHON_EXECUTABLE=/usr/bin/python3 \
            -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m \
            -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so

# =================================

# user tools
RUN apt-get update && apt-get install -y \
    terminator \
    gedit \
    okular \
    vim \
    && rm -rf /var/lib/apt/lists/*

# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

RUN cp /usr/share/applications/terminator.desktop /root/Desktop
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]