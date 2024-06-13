#  Example build: docker build -t bpoole908/mlenv-gpu:bare --force-rm --no-cache .

# Do not change CUDA and CUDNN versions unless you confirm they are compatible
# with the TensorFlow version in use. 
ARG UBUNTU_VERSION=22.04
ARG CUDA=12.2.2
ARG CUDNN=8

# Nvidia refernce Dockerfiles (in template format ;_;): 
# https://gitlab.com/nvidia/container-images/cuda/-/tree/master/
FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-runtime-ubuntu${UBUNTU_VERSION}

ARG CUDA
ARG HOST_USER="dev"
ARG HOST_UID="1000"
ARG HOST_GID="100"

#  Conda relases: https://repo.anaconda.com/miniconda/
# py310_22.11.1-1 = conda 4.14
ENV HOME=/home/${HOST_USER} \
    MINICONDA_VERSION=py312_24.4.0-0 \ 
    CONDA_DIR=/home/$HOST_USER/miniconda \
    USER=$HOST_USER \
    UID=$HOST_UID \ 
    GID=$HOST_GID \
    CONDAENV=mlenv \
    TZ='America/New_York'

# PATH must have be on its own line or CONDA_DIR will not be recognized
ENV PATH=${CONDA_DIR}/bin:${HOME}/.local/bin:${PATH}

RUN groupadd -r ${HOST_USER} \
    && useradd -d /home/${HOST_USER} -g ${HOST_GID} -m -r -u ${HOST_UID} ${HOST_USER} \
    && mkdir ${HOME}/mnt/ 

# openmpi-bin/libopenmpi-dev are for mpi4py, i.e. parallel processing/logging
# locales is for syncing time in container with host computer
# libgtk2.0-0/xvfb/ is used for graphical interfaces if a $DISPLAY is passed to the container
# DEBIAN_FRONTEND=noninteractive prevents debconf from prompting for user input
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    vim \
    ssh \
    git \ 
    curl \
    ca-certificates \
    locales \
    fonts-liberation \
    libgtk2.0-0 \
    xvfb \
    locales \
    libgconf-2-4 \
    libxtst6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o $HOME/mnt/miniconda.sh \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen
    
# Avoid Python 3 errors regarding ASCII/UTF-8 
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en

COPY ./env.yaml $HOME/mnt/

RUN chown -R ${HOST_USER}:${HOST_GID} ${HOME}/mnt/ 

USER ${HOST_USER}

WORKDIR /home/${HOST_USER}/mnt

RUN /bin/bash ./miniconda.sh -bp ${CONDA_DIR} \
    && rm miniconda.sh

RUN conda update conda -y \
    && conda env create -f env.yaml \
    && conda clean --all -f -y \
    && rm env.yaml

RUN conda init bash \
    && /bin/bash -c "source ~/.bashrc" \
    && /bin/bash -c "source activate ${CONDAENV}" \
    && echo 'conda activate ${CONDAENV}' >> ~/.bashrc 

RUN echo 'export PS1="🐳 \[\033[1;36m\]\u@\[\033[1;32m\]\h:\[\033[1;34m\]\w\[\033[0m\]\$ "' >> ${HOME}/.bashrc

CMD /bin/bash
