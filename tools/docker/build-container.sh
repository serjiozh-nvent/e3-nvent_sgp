#!/bin/sh
echo
echo Configuration:
echo Using ${HOME} as a shared directory with the container
echo Using epics-ioc as a container name
echo
echo Building container image...
echo
docker pull centos || exit 1

BUILD_ARGS=""

if [ "${http_proxy}" != "" ]; then
    BUILD_ARGS="$BUILD_ARGS --build-arg HTTP_PROXY=${http_proxy}"
fi
if [ "${ftp_proxy}" != "" ]; then
    BUILD_ARGS="$BUILD_ARGS --build-arg FTP_PROXY=${ftp_proxy}"
fi

docker build -f Dockerfile -t epics $BUILD_ARGS . || exit 1

echo
echo "Remove old container (if present)..."
docker ps -a | grep epics-ioc && docker rm epics-ioc

echo
echo Create a new container...
BIND=${HOME}:${HOME}
docker create --name epics-ioc --network host -v $BIND -it epics || exit 1

echo
echo Success!
echo "docker start -ai epics-ioc - start the container."
echo "docker run -it epics <cmd> - run another instance with a <cmd>"
