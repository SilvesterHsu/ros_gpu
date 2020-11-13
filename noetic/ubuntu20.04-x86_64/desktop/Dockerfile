FROM silvesterhsu/ros_gpu:noetic-cuda11.0-runtime

#
# ========================== Jupyter ==========================
#
RUN pip3 install tornado -U
RUN pip3 install jupyter_contrib_nbextensions jupyter_nbextensions_configurator ipywidgets \
    && jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter nbextension enable splitcell/splitcell \
    && jupyter nbextension enable codefolding/main \
    && jupyter nbextension enable execute_time/ExecuteTime \
    && jupyter nbextension enable snippets_menu/main \
    && jupyter nbextension enable toggle_all_line_numbers/main

#
# ========================== Tool ==========================
#

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
        python3-dev build-essential \
        python-dev \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
        terminator \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# user tools
RUN apt-get update && apt-get install -y \
    terminator \
    gedit \
    okular \
    vim \
    nano \
    wget \
    && rm -rf /var/lib/apt/lists/*

# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN apt update && sudo apt install python2.7 -y && \
    curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    pip2 install setuptools wheel && pip2 install -r /usr/lib/web/requirements.txt && \
    rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/applications/terminator.desktop /root/Desktop

RUN rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    rm /usr/local/bin/pip && rm /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

# =======================================================================
# TensorBoard
EXPOSE 6006
# Jupyter
EXPOSE 8888
# VNC
EXPOSE 80

#USER seel
WORKDIR "/notebooks"
ENV HOME=/root \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
