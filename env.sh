user="1000:10"
version="tf"
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
echo $version $user $path
alias mlenv-gpu-make="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --name mlenv-gpu-$version \
    --user $user \
    --gpus all \
    --shm-size 16G \
    -dit \
    -e DISPLAY \
    -e XAUTHORITY \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 6886:6886 \
    -p 8000:8000 \
    bpoole908/mlenv-gpu:$version"

alias mlenv-gpu-attach="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --rm \
    --name mlenv-gpu-${version}-tmp \
    --user $user \
    --gpus all \
    --shm-size 16G \
    -dit \
    -e DISPLAY \
    -e XAUTHORITY \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 6886:6886 \
    -p 8000:8000 \
    bpoole908/mlenv-gpu:$version \
    && docker attach mlenv-gpu-${version}-tmp"

alias wsl-mlenv-gpu-make="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/etc/localtime:/etc/localtime:ro \
    --name mlenv-gpu-$version \
    --user $user \
    --gpus all \
    --shm-size 16G \
    -dit \
    -p 8888:8888 \docker 
    -p 6006:6006 \
    -p 6886:6886 \
    -p 8000:8000 \
    bpoole908/mlenv-gpu:$version"