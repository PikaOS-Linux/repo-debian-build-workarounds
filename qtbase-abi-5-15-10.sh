#! /bin/bash

# Remove old packages
rm -rf ./qtbase-abi-5-15-10*

# Update apt cache
apt update

# Get required packages
apt-get install -y reprepro dpkg-sig git gh

# setup package
mkdir -p qtbase-abi-5-15-10/DEBIAN
tee qtbase-abi-5-15-10/DEBIAN/control <<'EOF'
Package: qtbase-abi-5-15-10
Version: 5.15.10-100cosmo1
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtbase-abi-5-15-12
Description: make wrongly compiled shit shut the fuck up until we rebuild it against correct qt version
EOF

# Build the package
dpkg-deb --build qtbase-abi-5-15-10

# Sign the packages
dpkg-sig --sign builder ./*.deb

# Add the new package to the repo
reprepro -V includedeb sid ./qtbase-abi-5-15-10*.deb

# Commit all changes
git add .
git commit -m"Add $(ls ./qtbase-abi-5-15-10*.deb)"
git push
