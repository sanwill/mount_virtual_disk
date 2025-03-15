# Mount Virtual Disk
Users have few option to move files from VM's disk to local PC, they can do scp or use "Shared folder" option (in case of VirtualBox), however there is a 3rd option which to mount the virtual disk directly to local PC.
This definately useful if users want to copy the files without boot up the VM (e.g. in case of the boot disk failure).

We will use qemu-nbd to mount the virtual disk. qemu-ndb supports a variety of virtual disk formats such as:
* QCOW2: QEMU's own format, which supports features like snapshots and compression.
* RAW: A simple uncompressed format.
* VMDK: VMware's format.
* VHD: Microsoft's format for Hyper-V.
* VHDX: An updated version of VHD with additional features.
* VDI: VirtualBox's format2.

Users can opt to mount remote virtualdisk using qemu-nbd, as long as the virtual disk can be read by qemu-nbd, for example with combination of sshfs or nfs to mount the virtual disks.

## Steps to Mount Virtual Disk
Add nbd module to the kernel:

`sudo modprobe nbd max_part=8`

Mount the virtual disk to nbd0 and set to read only.

`sudo qemu-nbd -r -c /dev/nbd0 "/path/vdisk.vdi"`

Verify if the vdisk is mounted

`sudo fdisk -l /dev/nbd0`

For example
```
$ sudo fdisk -l /dev/nbd0

Disk /dev/nbd0: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

Create the mounting point

```
sudo mkdir /mnt/virtualdisk

sudo mount /dev/nbd0 /mnt/virtualdisk`
```

For example
```
$ ls -ld /mnt/virtualdisk/
drwx------ 5 user user 4096 Feb 15 00:33 /mnt/virtualdisk/
```

To unmount the virtual disk and remove ndb module from kernel

```
sudo umount /mnt/virtualdisk

sudo qemu-nbd -d /dev/nbd0

sudo modprobe -r nbd
```
`
