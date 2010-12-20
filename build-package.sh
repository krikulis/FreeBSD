#/bin/sh 
# builds package from port with depencies,
# packages are located at /usr/ports/packages/All
export PACKAGES=/usr/ports/packages/All/
make config-recursive;
make package-recursive;
echo "Packages created and are located in $PACKAGES";
