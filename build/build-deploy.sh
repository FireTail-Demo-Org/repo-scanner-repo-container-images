#!/bin/sh

set -o errexit
set -o nounset

docker buildx build --load \
  --target test-image \
  --file build/dockerfile \
  --tag app:test-image \
  .

docker container run --rm \
  --tag app:test-image

docker buildx build --load \
  --target runtime-image \
  --file build/dockerfile \
  --tag app:latest \
  .

aws ecr get-login-password |
  docker login \
  --username AWS \
  --password-stdin \
  01234567890.dkr.ecr.eu-west-1.amazonaws.com

docker image tag \
  app:latest \
  01234567890.dkr.ecr.eu-west-1.amazonaws.com/app:v1.2.3

docker tag \
  app:latest \
  01234567890.dkr.ecr.eu-west-1.amazonaws.com/app:latest

docker image push \
  01234567890.dkr.ecr.eu-west-1.amazonaws.com/app:latest

docker push \
  01234567890.dkr.ecr.eu-west-1.amazonaws.com/app:v1.2.3

docker tag app:latest example.com/app:latest

docker push example.com/app:latest

docker tag app:latest example.com/app:v1.2.3
