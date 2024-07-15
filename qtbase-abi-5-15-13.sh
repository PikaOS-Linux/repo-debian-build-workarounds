#! /bin/bash

# Remove old packages
rm -rf ./qtbase-abi-5-15-13.deb || true
rm -rf ./qtbase-abi-5-15-13 || true
rm -rf ./qtbase-abi-5-15-13_x32.deb || true
rm -rf ./qtbase-abi-5-15-13_x32 || true

# Update apt cache
apt update

# Get required packages
apt-get install -y wget git openssh-client reprepro gh apt-utils gpg build-essential devscripts
wget http://ftp.us.debian.org/debian/pool/main/d/dpkg-sig/dpkg-sig_0.13.1+nmu4_all.deb -O ./dpkg-sig.deb
apt-get install -y ./dpkg-sig.deb

# setup amd64 package
mkdir -p qtbase-abi-5-15-13/DEBIAN
tee qtbase-abi-5-15-13/DEBIAN/control <<'EOF'
Package: qtbase-abi-5-15-13
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtbase-abi-5-15-14
Description: make wrongly compiled shit shut the fuck up until we rebuild it against correct qt version
EOF

# Build the amd64 package
dpkg-deb --build qtbase-abi-5-15-13

# setup package
mkdir -p qtbase-abi-5-15-13_x32/DEBIAN
tee qtbase-abi-5-15-13_x32/DEBIAN/control <<'EOF'
Package: qtbase-abi-5-15-13
Version: 5.15.13-100cosmo4
Maintainer: Cosmic Fusion
Architecture: i386
Depends: qtbase-abi-5-15-14
Description: make wrongly compiled shit shut the fuck up until we rebuild it against correct qt version
EOF

# Build the i386 package
dpkg-deb --build qtbase-abi-5-15-13_x32

# Sign the packages
dpkg-sig --sign builder ./*.deb

# Add the new package to the repo
reprepro -V \
    --section utils \
    --component main \
    --priority 0 \
    includedeb sid ./qtbase-abi-5-15-13*.deb

rm -rf ./qtbase-abi-5-15-13.deb || true
rm -rf ./qtbase-abi-5-15-13 || true
rm -rf ./qtbase-abi-5-15-13_x32.deb || true
rm -rf ./qtbase-abi-5-15-13_x32 || true

# Commit changes to git
git config --global user.name 'Github Workflow Action'
git config --global user.email 'hotrod.master@hotmail.com'
git config --global --add safe.directory /__w/debian-workaround-packages-repo/debian-workaround-packages-repo
git add .
git commit -am"Include Debfile file for qtbase-abi-5-15-13"
git push
