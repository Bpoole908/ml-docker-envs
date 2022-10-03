ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION}

ARG HOST_USER="dev"
ARG HOST_UID="1000"
ARG HOST_GID="100"

ENV HOME=/home/${HOST_USER} \
    MINICONDA_VERSION=py38_4.9.2 \
    CONDA_VERSION=4.6.14 \
    CONDA_DIR=/home/$HOST_USER/miniconda \
    USER=$HOST_USER \
    UID=$HOST_UID \ 
    GID=$HOST_GID

# PATH must have be on its own line or CONDA_DIR will not be recognized
ENV PATH=${CONDA_DIR}/bin:${HOME}/.local/bin:${PATH}

RUN groupadd -r ${HOST_USER} \
    && useradd -d /home/${HOST_USER} -g ${HOST_GID} -m -r -u ${HOST_UID} ${HOST_USER} \
    && mkdir ${HOME}/mnt/ 

# openmpi-bin/libopenmpi-dev are for mpi4py, i.e. parallel processing/logging
# locales is for syncing time in container with host computer
# libgtk2.0-0/xvfb/ is used for graphical interfaces if a $DISPLAY is passed to the container
# libnvinfer is for installing TensorRT, which requires libcudnn7.
# g++ and cmake for wider package compatibility 
RUN apt-get update && apt-get install -yq --no-install-recommends \
    g++ \
    cmake\ 
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o $HOME/mnt/miniconda.sh \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen
    
# Avoid Python 3 errors regarding ASCII/UTF-8 
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

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
