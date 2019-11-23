#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

mkdir -p quickwrite
cd quickwrite
git init
git remote add origin https://github.com/MCHSL/byond-quickwrite
git fetch --depth 1 origin $QUICKWRITE_TAG
git checkout FETCH_HEAD

g++-7 -std=c++17 -m32 -shared -o libquickwrite.so -fPIC dllmain.cpp

mkdir -p ~/.byond/bin
cp $PWD/libquickwrite.so ~/.byond/bin
