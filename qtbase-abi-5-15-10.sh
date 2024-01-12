#! /bin/bash

# Remove old packages
rm -rf ./qtbase-abi-5-15-10*.deb

# Update apt cache
apt update

# Get required packages
apt-get install -y reprepro dpkg-sig


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