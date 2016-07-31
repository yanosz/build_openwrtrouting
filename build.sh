#!/bin/bash



if [ -z $SDK ];then 
  SDK="OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64"
fi

if [ -z $SDK_URL ]; then
  SDK_URL="http://ftp.stw-bonn.de/pub/openwrt/chaos_calmer/15.05.1/ar71xx/generic/$SDK.tar.bz2"
fi

if [ -z $PKGS ]; then
  PKGS="batman-adv batctl"
fi

BUILD_KEY=''
if ! [ -z $CONFIG_BUILD_KEY ]; then
  BUILD_KEY="BUILD_KEY=$CONFIG_BUILD_KEY"
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

# For Building gluon libucc from OpenWRT must be present
# Since it's not part of the SDK - it has to be built in addition

#ln -fs $pwd/openwrt-packages/libs/libuecc ./$SDK/package/libuecc


#Link gluon packages
ln -fs $pwd/gluon-packages ./$SDK/package/gluon

#Remove ecdsautils: br0ken buld
rm -Rf $pwd/gluon-packages/utils/ecdsautils

make -C $SDK V=99 $BUILD_KEY world
