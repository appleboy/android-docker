# android-docker

[![Build Status](https://travis-ci.org/appleboy/android-docker.svg?branch=master)](https://travis-ci.org/appleboy/android-docker)

Android Docker image

## Build image

```bash
docker build -t appleboy/android-docker .
```

If building fail you can debug via where `1b372b1f76f2` is partial build

```bash
docker run --tty --interactive --rm 1b372b1f76f2 /bin/bash
```

## Push build version to repository

```bash
docker push appleboy/android-docker
```

## Usage

```bash
docker run --tty --interactive --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm appleboy/android-docker  /bin/sh -c "./gradlew build"
```
