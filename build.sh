#!/bin/bash



if [ -z $SDK ];then 
  SDK="OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64"
fi

if [ -z $SDK_URL ]; then
  SDK_URL="http://ftp.stw-bonn.de/pub/openwrt/chaos_calmer/15.05.1/ar71xx/generic/$SDK_FOLDER.tar.bz2"
fi

if [ -u $PKGS ]; then
  PKGS="batman-adv batctl"
fi

IFS=' '



## Setting up the build environment
if ! [ -f "$SDK.tar.bz2" ]
then 
  wget  "$SDK_URL" 
fi

if ! [ -d "$SDK" ]
then
 tar -xf $SDK.tar.bz2 
fi

pwd=$(pwd)
#Linking packages
for pkg in $PKGS; do
  echo "Including Packet $pkg"
  ln -fs $pwd/packages/$pkg ./$SDK/package/$file/$pkg  
done
make -C $SDK V=99 world
