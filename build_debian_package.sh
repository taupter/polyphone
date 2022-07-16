#!/bin/bash
set -e

# For building a DEB package, first copy this file and the directory "debian" next to the sources:
# root directory
# |- debian
# |  |- changelog
# |  |- ...
# |- sources
# |  |- ... (lot of things)
# |- build-debian-package
#
# Then, please take care of the following points:
#  * adapt debian/changelog so that the version and date are correct
#  * make sure "devscripts" package is installed (sudo apt-get install devscripts)
#  * the filesystem allow the execution flags to be removed (no NTFS)
#
# Finally, run this script by opening a terminal in the root directory
# For version 2.1 write "build-debian-package 2.1"

if [ -z "$1" ]
then
  echo "Usage: build-debian-package VERSION"
  exit $E_NOARGS
fi

# Remove the execution flags
chmod -R -x+X debian
chmod -R -x+X sources

# Rename folder sources
mv sources polyphone-$1

# Create archive
tar -zcvf polyphone_$1.orig.tar.gz polyphone-$1

# Copy debian directory in sources
cp -r debian polyphone-$1

# Build package
cd polyphone-$1
dpkg-buildpackage || true
cd ..

# Revert rename
mv polyphone-$1 sources

# Delete files
rm -f polyphone_$1-1.debian.tar.xz
rm -f polyphone_$1-1.dsc
rm -f *.changes
rm -f *.buildinfo
rm -f polyphone_$1.orig.tar.gz
rm -f polyphone-dbg*

# Clean the source directory
rm -rf sources/debian
rm -rf sources/generated_files
rm -rf sources/bin
rm -rf sources/.qm
rm -f sources/*.o
rm -f sources/ui_*
rm -f sources/moc_*
rm -f sources/qrc_*
rm -f sources/qmake_qmake_qm_files.qrc
rm -f sources/Makefile
rm -f sources/.qmake.stash
