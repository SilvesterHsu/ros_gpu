FROM silvesterhsu/base_ros

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    rm -rf /var/lib/apt/lists/*

#
# ============================== Base ==============================
#

ENV CUDA_VERSION 11.0.3

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-0=11.0.221-1 \
    cuda-compat-11-0 \
    && ln -s cuda-11.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451"

#
# ============================== Runtime ==============================
#

ENV NCCL_VERSION 2.7.8

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-0=11.0.3-1 \
    libnpp-11-0=11.1.0.245-1 \
    cuda-nvtx-11-0=11.0.167-1 \
    libcublas-11-0=11.2.0.252-1 \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install curl xz-utils -y --no-install-recommends && NCCL_DOWNLOAD_SUM=34000cbe6a0118bfd4ad898ebc5f59bf5d532bbf2453793891fa3f1621e25653 && \
    curl -fsSL https://developer.download.nvidia.com/compute/redist/nccl/v2.7/nccl_2.7.8-1+cuda11.0_x86_64.txz -O && \
    echo "$NCCL_DOWNLOAD_SUM  nccl_2.7.8-1+cuda11.0_x86_64.txz" | sha256sum -c - && \
    tar --no-same-owner --keep-old-files --lzma -xvf nccl_2.7.8-1+cuda11.0_x86_64.txz -C /usr/local/cuda/lib64/ --strip-components=2 --wildcards '*/lib/libnccl.so.*' && \
    tar --no-same-owner --keep-old-files --lzma -xvf  nccl_2.7.8-1+cuda11.0_x86_64.txz -C /usr/lib/pkgconfig/ --strip-components=3 --wildcards '*/lib/pkgconfig/*' && \
    rm nccl_2.7.8-1+cuda11.0_x86_64.txz && \
    ldconfig && rm -rf /var/lib/apt/lists/*

#
# ============================== Cudnn ==============================
#

ENV CUDNN_VERSION 8.0.4.30

RUN echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=$CUDNN_VERSION-1+cuda11.0 \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*

#
# ====================== Pytorch + Dependent =======================
#

RUN pip install torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

#
# ========================== Jupyter ==========================
#
RUN pip3 install tornado -U
RUN pip3 install jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
    && jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user \
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
    rm -rf /var/lib/apt/lists/*

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
    rm /usr/bin/pip /usr/local/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc

# =======================================================================
# Add user for jupyter notebook
RUN useradd -ms /bin/bash seel

# =======================================================================
# TensorBoard
EXPOSE 6006
# Jupyter
EXPOSE 8888
# VNC
EXPOSE 80

#USER seel
WORKDIR "/notebooks"
ENV HOME=/home/seel \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
