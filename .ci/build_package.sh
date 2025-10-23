#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

echo "$0: building the package"

ARTIFACTS_FOLDER=$1
BASE_IMAGE=$2

[ -z $ARTIFACTS_FOLDER ] && ARTIFACTS_FOLDER=/tmp/artifacts
[ -z $BASE_IMAGE ] && BASE_IMAGE=abcd

sudo apt-get -y install dpkg-dev

## | ------------ detect current CPU architecture ------------- |

CPU_ARCH=$(uname -m)
if [[ "$CPU_ARCH" == "x86_64" ]]; then
  echo "$0: detected amd64 architecture"
  ARCH="amd64"
else
  echo "$0: amd64 architecture not detected, assuming arm64"
  ARCH="arm64"
fi

echo "$0: building the package into '$ARTIFACTS_FOLDER'"

mkdir -p $ARTIFACTS_FOLDER

mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
make DESTDIR=../package install

cd ..

mkdir -p ./package/DEBIAN
cat <<EOF > ./package/DEBIAN/control
Package: livox-sdk2
Version: 2.0.0
Section: libs
Priority: optional
Architecture: $ARCH
Maintainer: Tomas Baca <tomas.baca@fel.cvut.cz>
Description: Livox SDK2 library for Livox LiDARs
EOF

dpkg-deb --build --root-owner-group package

dpkg-name package.deb

mv *.deb $ARTIFACTS_FOLDER
