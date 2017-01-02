#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
NAME="zesty"

VERSIONS=( 3.8 3.9 snapshot)
for v in "${VERSIONS[@]}"
do
        echo $v
        v_without_dot=$(echo $v|sed -e "s|\.||g")
        sh create-new-job.sh $NAME $v release_$v_without_dot $v
        chown -R jenkins. llvm-toolchain-*
done

cd /usr/share/debootstrap/scripts
ln -s trusty $NAME

mkdir  -p /srv/repository/$NAME
chown jenkins. /srv/repository/$NAME

emacs ~/.pbuilderrc
echo "On every slave, git pull + create the symlink from trusty for deboostrap"
