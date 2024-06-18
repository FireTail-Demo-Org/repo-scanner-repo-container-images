#!/bin/sh

set -o errexit
set -o nounset

docker buildx build \
  --target runtime-image \
  --tag repo:v1.0 \
  --file build/Dockerfile \
  .

docker image tag repo:v1.0 example.com/repo:v1.0

echo "${PASSWORD}" |
  docker login \
    --username AWS \
    --password-stdin \
    example.com

# this is a comment about docker push
docker push example.com/repo:v1.0
