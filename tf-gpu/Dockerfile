# Do not change CUDA and CUDNN versions unless you confirm they are compatible
# with the TensorFlow version in use. 
ARG UBUNTU_VERSION=20.04
ARG CUDA=11.8
# ARG CUDNN=8

# Nvidia refernce Dockerfiles (in template format ;_;): https://gitlab.com/nvidia/container-images/cuda/-/tree/master/
FROM nvidia/cuda:${CUDA}.0-base-ubuntu${UBUNTU_VERSION}

ARG CUDA
ARG CUDNN=8.6.0.163-1
ARG CUDNN_MAJOR_VERSION=8
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=8.4.3-1
ARG LIBNVINFER_MAJOR_VERSION=8
ARG HOST_USER="dev"
ARG HOST_UID="1000"
ARG HOST_GID="100"

#  Conda relases: https://repo.anaconda.com/miniconda/
ENV HOME=/home/${HOST_USER} \
    MINICONDA_VERSION=py38_4.9.2 \
    CONDA_DIR=/home/${HOST_USER}/miniconda \
    CONDA_ENV_DIR=/home/${HOST_USER}/miniconda/envs/mlenv \
    USER=$HOST_USER \
    UID=$HOST_UID \ 
    GID=$HOST_GID \
    DEBIAN_FRONTEND=noninteractive \
    TZ='America/New_York' 

# Pre-append excepted conda path variables 
# CONDA_DIR needed to run conda command
# CONDA_ENV_DIR needed for GPU detection
ENV PATH=${CONDA_DIR}/bin:${HOME}/.local/bin:${PATH} 
    # LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CONDA_ENV_DIR}/lib/ \
    # XLA_FLAGS=–xla_gpu_cuda_data_dir=${CONDA_ENV_DIR}/lib/

RUN groupadd -r ${HOST_USER} \
    && useradd -d /home/${HOST_USER} -g ${HOST_GID} -m -r -u ${HOST_UID} ${HOST_USER} \
    && mkdir ${HOME}/mnt/ 

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
# openmpi-bin/libopenmpi-dev are for mpi4py, i.e. parallel processing/logging
# locales is for syncing time in container with host computer
# libgtk2.0-0/xvfb/ is used for graphical interfaces if a $DISPLAY is passed to the container
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-11-8 \
        cuda-command-line-tools-${CUDA/./-} \
        libcublas-${CUDA/./-} \
        cuda-nvrtc-${CUDA/./-} \
        libcufft-${CUDA/./-} \
        libcurand-${CUDA/./-} \
        libcusolver-${CUDA/./-} \
        libcusparse-${CUDA/./-} \
        curl \
        libcudnn8=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        ca-certificates \
        locales \
        fonts-liberation \
        libopenmpi-dev \
        openmpi-bin \
        libgtk2.0-0 \
        xvfb \
        vim \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o $HOME/mnt/miniconda.sh \
        && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
        && locale-gen

# RUN apt-get update && \
#         apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub && \
#         echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /"  > /etc/apt/sources.list.d/tensorRT.list && \
#         apt-get update && \
#         apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.6 \
#         libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.6 \
#         && apt-get clean \
#         && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# Avoid Python 3 errors regarding ASCII/UTF-8 
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en

COPY ./environment.yml $HOME/mnt/

RUN chown -R ${HOST_USER}:${HOST_GID} ${HOME}/mnt/ 

USER ${HOST_USER}

WORKDIR /home/${HOST_USER}/mnt

RUN /bin/bash ./miniconda.sh -bp ${CONDA_DIR} \
    && rm miniconda.sh

RUN conda update conda -y \
    && conda env create --file environment.yml \
    && conda clean --all -f -y \
    && rm environment.yml

# Adding conda activate mlenv doesn't work!
RUN conda init bash \
    && /bin/bash -c "source ~/.bashrc" \
    && /bin/bash -c "source activate mlenv" \
    && echo 'conda activate mlenv' >> ~/.bashrc 

RUN echo 'export PS1="🐳 \[\033[1;36m\]\u@\[\033[1;32m\]\h:\[\033[1;34m\]\w\[\033[0m\]\$ "' >> ${HOME}/.bashrc

CMD /bin/bash
