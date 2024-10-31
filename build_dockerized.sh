#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE[0]})

docker buildx build . -t llamafile-builder:latest --load
docker run --rm -it --entrypoint bash -w /src -v $PWD:/src -v $HOME/models:/models llamafile-builder:latest