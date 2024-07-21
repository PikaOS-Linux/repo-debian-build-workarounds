#! /bin/bash

# Remove old packages
rm -rf ./qtbase-abi-5-15-10.deb || true
rm -rf ./qtbase-abi-5-15-10 || true
rm -rf ./qtbase-abi-5-15-10_x32.deb || true
rm -rf ./qtbase-abi-5-15-10_x32 || true
rm -rf ./qtwayland-client-abi-5-15-10.deb || true
rm -rf ./qtwayland-client-abi-5-15-10 || true
rm -rf ./qtwayland-client-abi-5-15-10_x32.deb || true
rm -rf ./qtwayland-client-abi-5-15-10_x32 || true

# Update apt cache
apt update

# Get required packages
apt-get install -y wget git openssh-client reprepro gh apt-utils gpg build-essential devscripts
wget http://ftp.us.debian.org/debian/pool/main/d/dpkg-sig/dpkg-sig_0.13.1+nmu4_all.deb -O ./dpkg-sig.deb
apt-get install -y ./dpkg-sig.deb

# setup qtbase-abi amd64 package
mkdir -p qtbase-abi-5-15-10/DEBIAN
tee qtbase-abi-5-15-10/DEBIAN/control <<'EOF'
Package: qtbase-abi-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtbase-abi-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtbase-abi amd64 package
dpkg-deb --build qtbase-abi-5-15-10

# setup qtbase-abi i386 package
mkdir -p qtbase-abi-5-15-10_x32/DEBIAN
tee qtbase-abi-5-15-10_x32/DEBIAN/control <<'EOF'
Package: qtbase-abi-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: i386
Depends: qtbase-abi-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtbase-abi i386 package
dpkg-deb --build qtbase-abi-5-15-10_x32

# setup qtwayland-client-abi amd64 package
mkdir -p qtwayland-client-abi-5-15-10/DEBIAN
tee qtwayland-client-abi-5-15-10/DEBIAN/control <<'EOF'
Package: qtwayland-client-abi-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtwayland-client-abi-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtwayland-client-abi amd64 package
dpkg-deb --build qtwayland-client-abi-5-15-10

# setup qtwayland-client-abi i386 package
mkdir -p qtwayland-client-abi-5-15-10_x32/DEBIAN
tee qtwayland-client-abi-5-15-10_x32/DEBIAN/control <<'EOF'
Package: qtwayland-client-abi-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: i386
Depends: qtwayland-client-abi-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtwayland-client-abi i386 package
dpkg-deb --build qtwayland-client-abi-5-15-10_x32

# setup qtdeclarative-abi-5-15-10 amd64 package
mkdir -p qtdeclarative-abi-5-15-10-5-15-10/DEBIAN
tee qtdeclarative-abi-5-15-10-5-15-10/DEBIAN/control <<'EOF'
Package: qtdeclarative-abi-5-15-10-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtdeclarative-abi-5-15-10-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtdeclarative-abi amd64 package
dpkg-deb --build qtdeclarative-abi-5-15-10

# setup qtdeclarative-abi i386 package
mkdir -p qtdeclarative-abi-5-15-10_x32/DEBIAN
tee qtdeclarative-abi-5-15-10_x32/DEBIAN/control <<'EOF'
Package: qtdeclarative-abi-5-15-10
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: i386
Depends: qtdeclarative-abi-5-15-14
Description: Bridge Package for PikaOS Builder
EOF

# Build the qtdeclarative-abi i386 package
dpkg-deb --build qtdeclarative-abi-5-15-10_x32

# Sign the packages
dpkg-sig --sign builder ./*.deb

# Add the new qtbase-abi package to the repo
reprepro -V \
    --section utils \
    --component main \
    --priority 0 \
    includedeb sid ./qtbase-abi-5-15-10*.deb

# Add the new qtwayland-client-abi package to the repo
reprepro -V \
    --section utils \
    --component main \
    --priority 0 \
    includedeb sid ./qtwayland-client-abi-5-15-10*.deb

# Add the new qtdeclarative-abi package to the repo
reprepro -V \
    --section utils \
    --component main \
    --priority 0 \
    includedeb sid ./qtdeclarative-abi-5-15-10*.deb

rm -rf ./qtbase-abi-5-15-10.deb || true
rm -rf ./qtbase-abi-5-15-10 || true
rm -rf ./qtbase-abi-5-15-10_x32.deb || true
rm -rf ./qtbase-abi-5-15-10_x32 || true
rm -rf ./qtwayland-client-abi-5-15-10.deb || true
rm -rf ./qtwayland-client-abi-5-15-10 || true
rm -rf ./qtwayland-client-abi-5-15-10_x32.deb || true
rm -rf ./qtwayland-client-abi-5-15-10_x32 || true

qtdeclarative-abi-5-15-10
# Commit changes to git
git config --global user.name 'Github Workflow Action'
git config --global user.email 'hotrod.master@hotmail.com'
git config --global --add safe.directory /__w/repo-debian-build-workarounds/repo-debian-build-workarounds
git add .
git commit -am"Include Debfile file for QT 5-15-10 Bridging"
git push
