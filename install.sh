#!/bin/sh
version=1.0.5
platform=linux
base="$(dirname "$(realpath "$0")")"
libdir=/usr/local/lib

_arch=$(arch)
_set=true
if [ -z "${TARGETPLATFORM}" ]; then _unset=false; fi

if [ "$_set" = true ] && [ "$TARGETPLATFORM" = "aarch64" ] || [ "$_arch" = "aarch64" ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/arm-linux-gnueabihf/lib/
  dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y \
      libc6-dev:armhf \
      gcc-arm-linux-gnueabihf
  arch=armv7

elif [ "$_set" = true ] && [ "$TARGETPLATFORM" = "linux/amd64" ] || [ "$_arch" = "x86_64" ]; then
  dpkg --add-architecture i386 && apt-get update
  arch=x86

elif [ "$_set" = true ] && [ "$TARGETPLATFORM" = "linux/arm/v7" ] || [ "$_arch" = "armhf" ] || [ "$_arch" = "armv7l" ]; then
  arch=armv7

else
  arch=x86

fi

cp "$base/libfwlib32-$platform-$arch.so.$version" "$libdir/libfwlib32.so.$version"
ln -sf "$libdir/libfwlib32.so.$version" "$libdir/libfwlib32.so"
cp "$base/fwlib32.h" /usr/include/
ldconfig
