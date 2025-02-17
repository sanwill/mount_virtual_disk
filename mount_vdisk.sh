#!/bin/bash

cmd=$1
path=$2

mountvmdisk()
{
sudo modprobe nbd max_part=8
sudo qemu-nbd -r -c /dev/nbd0 "$1"

sudo fdisk -l /dev/nbd0
sudo mkdir /mnt/virtualdisk
sudo mount /dev/nbd0 /mnt/virtualdisk
}

umountvmdisk()
{
sudo umount /mnt/virtualdisk
sudo qemu-nbd -d /dev/nbd0
sudo modprobe -r nbd
}

if [ "$cmd" = "mt" ] && [ -n "$path" ]
then
  mountvmdisk "$path"
elif [ "$cmd" = "umt" ]
then
  umountvmdisk
else
  echo "Supported cmd: mt <path>, umt"
fi
