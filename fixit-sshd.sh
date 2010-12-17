#!/bin/sh
echo "Enter network device"
read $device
mkdir /var/db
ifconfig $device up
sleep 5
dhclient $device


mkdir /etc/ssh
cp /dist/etc/ssh/sshd_config /etc/ssh
echo ‘PermitRootLogin yes’ >> /etc/ssh/sshd_config

mkdir /usr/bin/
ln -s /dist/usr/bin/ssh /usr/bin/ssh

ssh-keygen -t rsa1 -b 1024 -f /etc/ssh/ssh_host_key -N ”
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ”
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ”


mkdir /root
echo “setenv PATH ‘/bin:/sbin:/usr/bin:/usr/sbin:/stand:/mnt2/stand:/mnt2/bin:/mnt2/sbin:/mnt2/usr/bin:/mnt2/usr/sbin’” > /root/.cshrc
echo “setenv EDITOR ‘/mnt2/usr/bin/ee’” >> /root/.cshrc
echo “set prompt=’Fixit# ‘” >> /root/.cshrc
ln -s /mnt2/bin/csh /bin/csh

/mnt2/usr/sbin/sshd

