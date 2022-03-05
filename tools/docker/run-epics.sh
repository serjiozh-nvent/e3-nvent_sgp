#!/bin/sh
BIND=${HOME}:${HOME}
docker run --network host -v $BIND -it epics /bin/bash -l
