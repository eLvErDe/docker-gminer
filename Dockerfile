FROM debian:stretch

MAINTAINER Adam Cecile <acecile@le-vert.net>

ENV TERM xterm
ENV HOSTNAME bminer-cuda.local
ENV DEBIAN_FRONTEND noninteractive
ENV URL https://github.com/develsoftware/GMinerRelease/releases/download/1.36/gminer_1_36_minimal_linux64.tar.xz

WORKDIR /root

# Upgrade base system
RUN apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends dist-upgrade \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt update && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends install wget ca-certificates bsdtar && rm -rf /var/lib/apt/lists/*

# Install binary
RUN wget ${URL} -O- | bsdtar -xvf- --include='miner' -O > /root/miner \
    && chmod 0755 /root/ && chmod 0755 /root/miner

# Workaround GMiner not finding libnvml
# Do not attempt to link in /usr/local/nvidia/lib64, it is dynamic mount by nvidia-docker
# but /root is also in LD_LIBRARY_PATH
RUN ln -sf /usr/local/nvidia/lib64/libnvidia-ml.so.1 /root/libnvidia-ml.so

# nvidia-container-runtime @ https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Workaround nvml not found
ENV LD_LIBRARY_PATH /root:${LD_LIBRARY_PATH}
