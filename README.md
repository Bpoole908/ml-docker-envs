# Getting Started
The GPU Docker environment has two requirements: 1) you will need to use a version of Linux where [docker-gpu](https://github.com/NVIDIA/nvidia-docker) is supported 2) you need to have a GPU and the latest Nvidia drivers installed on your host PC. If you meet these requirements then you can use the Docker environment within `gpu/`. Otherwise, you should stick to using the `no-gpu/` Docker environment. Additionally, if you are not using Linux you might not be able to use to `env.sh` scripts which contain the commands for running the Docker images.

The GPU environment image `bpoole908/mlenv-gpu:latest` can be pulled directly via Docker command-line or can be found [here](https://hub.docker.com/repository/docker/bpoole908/mlenv-gpu). Likewise, the non-GPU environment image `bpoole908/mlenv:latest` can be pulled directly via Docker command-line or can be found [here](https://hub.docker.com/repository/docker/bpoole908/mlenv).

# Building Images

To manually build an image you will need to run the below command from within the respective directory, i.e. `../gpu` or `../no-gpu`. If you are on Linux and want to avoid mounting permission errors please be sure that the ARG `HOST_UID` in the Dockerfile match your host UID (if you do not do this there is a potential runtime workaround).

```
docker build -t <tag-name> .
```

Note, that the `env.sh` aliases will fail to work as they are hard coded for my `bpoole908` DockerHub images. If you wish to use the `env.sh` aliases for your own built iamges then you'll need to replace the original Docker image name with the name you gave your built image, i.e. the \<tag-name\>.

## Adding packages
To see the default installed packages please see the `pip_requirements.txt` and `conda_requirements.txt` files. If you wish to add your own packages you can do so by appending these aforementioned files and then manually re-building the image. Additionally, you can instal packages directly inside the container once you are attached to said container. (Note, installing directly inside the container means that if the container is deleted it will not remember packages you installed!)

# Running Images on Linux
There are pre-defined commands for running each respective Docker image on Linux. To access these commands simply source the `env.sh` script within  `../gpu` or `../no-gpu`.  

```
source env.sh
```

The `env.sh` has three possible parameters you can pass to it when sourcing: `-v` for `version`, `-u` for `user`, and `-p` for `path`. The `version` parameter allows you to use an alternate Dockerfile version other than `:latest`, which is the default. The `user` parameter lets you pass your UID:GID for overriding the original images UID and GID, which defaults to 1000:10. Lastly, the `path` variable specifies the directory path that will be mounted to the container (by default this is your current working directory). 

Additionally, there are three aliases that are created when you source the `env.sh` script. The
`-attach` aliases creates a Docker container and attaches you to said Docker container. Further, it will delete the container upon exiting. The `-make` creates a persistent container that will not be destroyed upon exiting. You will also have to manually attach to this contain by using the `docker attach <container-name>` command. Lastly, `-stop` stops the container created by `-make`.

# Running Images on Windows/Mac
For users other than Linux you can simply refer to the to the `no-gpu/env.sh` script for the commands you'll need in order to run the image. 

However, there are some Linux specific commands that you might have to drop such as, `--volume=/tmp/.X11-unix:/tmp/.X11-unix`, `--volume=/etc/localtime:/etc/localtime:ro`, `-e DISPLAY=unix$DISPLAY` and `--user $user`. The first three commands allow the container to display any GUI elements that are ran within the container on the host PC. The forth command is used to sync the container and host PC times. The last command is used to pass user related permission information, i.e. UID:GID.
