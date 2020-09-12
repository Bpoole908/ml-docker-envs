# Do not change CUDA and CUDNN versions unless you confirm they are compatible
# with the TensorFlow version in use. 
ARG UBUNTU_VERSION=18.04
ARG CUDA=10.1
ARG CUDNN=7

# Nvidia refernce Dockerfiles (in template format ;_;): https://gitlab.com/nvidia/container-images/cuda/-/tree/master/
FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu${UBUNTU_VERSION}

ARG CUDA
ARG HOST_USER="dev"
ARG HOST_UID="1000"
ARG HOST_GID="100"

ENV HOME=/home/${HOST_USER} \
    MINICONDA_VERSION=4.6.14 \
    CONDA_VERSION=4.6.14 \
    CONDA_DIR=/home/$HOST_USER/miniconda

# PATH must have be on its own line or CONDA_DIR will not be recognized
ENV PATH=${CONDA_DIR}/bin:${HOME}/.local/bin:${PATH}

RUN groupadd -r ${HOST_USER} \
    && useradd -d /home/${HOST_USER} -g $HOST_GID -m -r -u ${HOST_UID} ${HOST_USER} \
    && mkdir ${HOME}/mnt/ \
    && chown ${HOST_USER}:${HOST_GID} ${HOME}/mnt/

# Designated mount point inside the contianer for mounting volumes from host PC
WORKDIR /home/${HOST_USER}/mnt

# openmpi-bin/libopenmpi-dev are for mpi4py, i.e. parallel processing/logging
# locales is for syncing time in container with host computer
# libgtk2.0-0/xvfb/ is used for graphical interfaces if a $DISPLAY is passed to the container
# gcc is for compiling C/C++
# libnvinfer is for installing TensorRT, which requires libcudnn7.
RUN apt-get update && apt-get install -yq --no-install-recommends \
    vim \
    ssh \
    git \ 
    curl \
    ca-certificates \
    locales \
    fonts-liberation \
    libopenmpi-dev \
    openmpi-bin \
    libgtk2.0-0 \
    xvfb \
    libgconf-2-4 \
    libxtst6 \
    gcc \
    libnvinfer6=6.0.1-1+cuda${CUDA} \
    libnvinfer-dev=6.0.1-1+cuda${CUDA} \
    libnvinfer-plugin6=6.0.1-1+cuda${CUDA} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o miniconda.sh \
    && chown $HOST_USER:$HOST_GID ./miniconda.sh  

USER $HOST_USER

RUN /bin/bash ./miniconda.sh -bp ${CONDA_DIR} \
    && rm miniconda.sh

COPY --chown=$HOST_USER ./conda_requirements.txt ./conda_requirements.txt

RUN conda config --system --prepend channels conda-forge \
    && conda config --system --prepend channels anaconda \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true  \
    && conda install --quiet --yes conda="${CONDA_VERSION%.*}.*" \
    && conda install --yes --file conda_requirements.txt \
    && conda update --all --quiet --yes \
    && conda clean --all -f -y 

COPY --chown=$HOST_USER ./pip_requirements.txt ./pip_requirements.txt

RUN pip install --upgrade pip \
    && pip install --user -r pip_requirements.txt --no-cache-dir \
    && rm pip_requirements.txt

RUN echo 'export PS1="🐳 \[\033[1;36m\]\u@\[\033[1;32m\]\h:\[\033[1;34m\]\w\[\033[0m\]\$ "' >> ${HOME}/.bashrc

CMD /bin/bash
