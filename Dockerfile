FROM debian:buster-slim as build

# Essential tools
RUN apt update && \
    apt install wget -y

# cudnn file
RUN wget http://jupi.ink:83/cudnn-11.0-linux-x64-v8.0.4.30.tgz && \
    tar -xzvf cudnn-11.0-linux-x64-v8.0.4.30.tgz


FROM silvesterhsu/base_ros

#
# ========================== CUDA Setup ==========================
#

ENV CUDA_VERSION 11.0.3

ENV CUDA_PKG_VERSION $CUDA_VERSION-1

RUN apt-get update && apt-get install -y wget software-properties-common \
    gnupg2 curl ca-certificates && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
    apt-get update && apt-get -y install cuda=$CUDA_PKG_VERSION && \
rm -rf /var/lib/apt/lists/*

RUN echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc && \
    echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.zshrc

#
# ========================== cudnn Setup ==========================
#

COPY --from=build /cuda/ /cuda/

RUN cp cuda/include/cudnn*.h /usr/local/cuda/include && \
    cp cuda/lib64/libcudnn* /usr/local/cuda/lib64 && \
    chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn* && \
    rm -rf cuda

#
# ===================== Pytorch + Dependent ======================
#

RUN pip install torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html