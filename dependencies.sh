#!/bin/bash

#Project dependencies file
#Final authority on what's required to fully build the project

# byond version
# Extracted from the Dockerfile. Change by editing Dockerfile's FROM command.
LIST=($(sed -n 's/.*byond:\([0-9]\+\)\.\([0-9]\+\).*/\1 \2/p' Dockerfile))
export BYOND_MAJOR=${LIST[0]}
export BYOND_MINOR=${LIST[1]}
unset LIST

#rust_g git tag
export RUST_G_VERSION=0.4.5

#bsql git tag
export BSQL_VERSION=v1.4.0.0

#node version
export NODE_VERSION=12

# PHP version
export PHP_VERSION=7.2

# SpacemanDMM git tag
export SPACEMAN_DMM_VERSION=suite-1.6

export QUICKWRITE_TAG=98b5183e3da5d14e59c38030a9b6824a615c8260
