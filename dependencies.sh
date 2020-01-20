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
export RUST_G_VERSION=0.4.2

#bsql git tag
export BSQL_VERSION=v1.4.0.0

#node version
export NODE_VERSION=12

# PHP version
export PHP_VERSION=5.6

# SpacemanDMM git tag
export SPACEMAN_DMM_VERSION=suite-1.2

# Quickwrite git tag
export QUICKWRITE_TAG=98b5183e3da5d14e59c38030a9b6824a615c8260

# Extools git tag
export EXTOOLS_TAG=bb4299ed543704bdc09af801296c0c3adefbba6d

# byondcrypt git tag
export BYONDCRYPT_TAG=b558b8fa35407791173b19811c52c3a7ecb5e3a8
