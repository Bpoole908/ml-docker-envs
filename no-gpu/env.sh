user="1000:10"
version="latest"
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

alias mlenv-make="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --name mlenv \
    --user $user \
    -dit \
    -p 8888:8888 \
    -p 6006:6006 \
    -e DISPLAY=unix$DISPLAY \
    bpoole908/mlenv:$version"

alias mlenv-attach="docker run \
    --volume=$path:/home/dev/mnt \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume=/etc/localtime:/etc/localtime:ro \
    --rm \
    --name mlenv-tmp \
    --user $user \
    -dit \
    -e DISPLAY=unix$DISPLAY \
    -p 8888:8888 \
    -p 6006:6006 \
    bpoole908/mlenv:$version \
    && docker attach mlenv-tmp "

alias  mlenv-stop="docker stop mlenv"