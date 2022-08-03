#!/bin/bash

DOCKER_BASEIMAGE=docker.io/python:3.9-alpine

docker buildx build --platform linux/amd64,linux/arm64 --push -t hub.realmanual.ru/pub/clamav-mirror \
	--build-arg DOCKER_BASEIMAGE=${DOCKER_BASEIMAGE} .
