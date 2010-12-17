#!/bin/sh
dd if=/dev/zero of=/dev/ad0 bs=64k count=1024
gpart create -s gpt ad0
gpart add -s 64K -t freebsd-boot ad0
gpart add -t freebsd-zfs -l disk0 ad0 
gpart bootcode -b /mnt2/boot/pmbr -p /mnt2/boot/gptzfsboot -i 1 ad0
kldload /mnt2/boot/kernel/opensolaris.ko
kldload /mnt2/boot/kernel/zfs.ko 
mkdir /boot/zfs
zpool create zroot /dev/gpt/disk0
zpool set bootfs=zroot zroot 
zfs set checksum=fletcher4  zroot
zfs create -o compression=on -o exec=on -o setuid=off zroot/tmp
chmod 1777 /zroot/tmp
zfs create zroot/usr
zfs create zroot/usr/home
cd /zroot; ln -s /usr/home home
zfs create -o setuid=off zroot/usr/ports
zfs create -o exec=off -o setuid=off zroot/usr/ports/distfiles
zfs create -o exec=off -o setuid=off zroot/usr/ports/packages
zfs create -o exec=off -o setuid=off zroot/usr/src
zfs create zroot/var
zfs create -o exec=off -o setuid=off zroot/var/crash
zfs create -o exec=off -o=setuid=off zroot/var/db
zfs create -o exec=on -o=setuid=off zroot/var/db/pkg
zfs create -o exec=off -o=setuid=off zroot/empty
zfs create -o exec=off -o=setuid=off zroot/var/log
zfs create -o exec=off -o=setuid=off zroot/var/mail
zfs create -o exec=off -o=setuid=off zroot/var/run
zfs create -o exec=on -o=setuid=off zroot/var/tmp
chmod 1777 /zroot/var/tmp
cd /dist/8.1-*
export DESTDIR=/zroot
cd ./base;
./install.sh;
cd ../src;
./install.sh all;
cd ../kernels;
./install.sh generic
cd /zroot/boot ; cp -Rlp GENERIC/* /zroot/boot/kernel/;
zfs set readonly=on zroot/var/empty;
chroot /zroot;
echo 'zfs_enable="YES"' > /etc/rc.conf;
echo 'zfs_load="YES"' > /boot/loader.conf;
echo 'vfs.root.mountfrom="zfs:zroot"' >> /boot/loader.conf
echo "enter root password " ;
passwd;
cd /etc/mail;
make aliases;
umount /dev;
exit;
cp /boot/zfs/zpool.cache /zroot/boot/zfs/zpool.cache;
echo " /dev/gpt/swap0                 none                    swap    sw              0       0" > /zroot/etc/fstab
export LD_LIBRARY_PATH=/mnt2/lib;
zfs unmount -a 
zfs set mountpoint=legacy zroot
zfs set mountpoint=/tmp zroot/tmp
zfs set mountpoint=/usr zroot/usr
zfs set mountpoint=/var zroot/var
echo "base system installed " ;










