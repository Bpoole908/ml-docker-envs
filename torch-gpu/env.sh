user="1000:10"
version="torch"
path=$PWD

while getopts u:v:p: option
do
case "${option}"
in
u) user=${OPTARG};;
v) version=${OPTARG};;
p) path=${OPTARG};;

esac
done

alias mlenv-gpu-make="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --name mlenv-gpu-$version \
    --user $user \
    --gpus 1 \
    -dit \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 4000:4000 \
    -e DISPLAY=unix$DISPLAY \
    bpoole908/mlenv-gpu:$version"

alias mlenv-gpu-attach="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --rm \
    --name mlenv-gpu-$version-tmp \
    --user $user \
    --gpus 1 \
    -dit \
    -e DISPLAY=unix$DISPLAY \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 4000:4000 \
    bpoole908/mlenv-gpu:$version \
    && docker attach mlenv-gpu-tmp "

alias wsl-mlenv-gpu-make="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/etc/localtime:/etc/localtime:ro \
    --name mlenv-gpu-$version \
    --user $user \
    --gpus 1 \
    -dit \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 4000:4000 \
    bpoole908/mlenv-gpu:$version"