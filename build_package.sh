#/bin/sh 
export PACKAGES=/usr/ports/packages/All/
make config-recursive;
make package-recursive;
echo "Packages created and are located in $PACKAGES";
