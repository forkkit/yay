#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}")"


wget https://github.com/multiarch/qemu-user-static/releases/download/v4.1.0-1/qemu-aarch64-static 
wget https://github.com/multiarch/qemu-user-static/releases/download/v4.1.0-1/qemu-arm-static

docker run --rm --privileged multiarch/qemu-user-static:register --reset

