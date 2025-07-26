#!/bin/bash
for GOOS in linux; do
  for GOARCH in arm arm64 amd64; do
    export GOOS GOARCH
    ./docker_build_specific_platform.sh $GOOS $GOARCH
  done
done
./docker_build_specific_platform.sh windows amd64
