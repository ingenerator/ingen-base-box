#!/bin/sh -eux

# Fill all empty disk space with zeros, so that it will be removed from the 
# virtual disk before imaging.
# https://github.com/opscode/bento/blob/master/packer/scripts/common/minimize.sh

dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync