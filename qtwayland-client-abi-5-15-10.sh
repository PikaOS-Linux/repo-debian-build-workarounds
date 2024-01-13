#! /bin/bash

# Remove old packages
rm -rf ./qtwayland-client-abi-5-15-10.deb || true
rm -rf ./qtwayland-client-abi-5-15-10 || true

# Update apt cache
apt update

# Get required packages
apt-get install -y reprepro dpkg-sig git gh

# setup package
mkdir -p qtwayland-client-abi-5-15-10/DEBIAN
tee qtwayland-client-abi-5-15-10/DEBIAN/control <<'EOF'
Package: qtwayland-client-abi-5-15-10
Version: 5.15.10-100cosmo2
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtbase-abi-5-15-12
Description: make wrongly compiled shit shut the fuck up until we rebuild it against correct qt version
EOF

# Build the package
dpkg-deb --build qtwayland-client-abi-5-15-10

# Sign the packages
dpkg-sig --sign builder ./*.deb

# Add the new package to the repo
reprepro -V \
    --section utils \
    --component main \
    --priority 0 \
    includedeb sid ./qtwayland-client-abi-5-15-10*.deb

rm -rf ./qtwayland-client-abi-5-15-10.deb || true
rm -rf ./qtwayland-client-abi-5-15-10 || true

# Commit changes to git
git config --global user.name 'Github Workflow Action'
git config --global user.email 'hotrod.master@hotmail.com'
git config --global --add safe.directory /__w/debian-workaround-packages-repo/debian-workaround-packages-repo
git add .
git commit -am"Add $(ls ./qtwayland-client-abi-5-15-10*.deb)"
git push
