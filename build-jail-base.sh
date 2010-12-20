#!/bin/sh 
# Script to build jail base (from where to clone all other jails)
# Presumes that make buildworld already is done 

zfs create zroot/jails
zfs create zroot/jails/base
zfs set mountpoint=/jails/base zroot/jails/base
setenv DEST=/jails/base
cd /usr/src
make installworld=DESTDIR=$DEST
make distribution DESTDIR=$D

