#!/bin/bash
#
# Installs the libgecode30 and libgecode-dev packages on ubuntu, so that 
# they do not have to be compiled for use by dep-selector-gecode.
#
# On 12.04 this is easy, but 14.04 ships with a newer version which is not
# compatible with the current dep-selector-gecode per 
# https://github.com/berkshelf/berkshelf/issues/1138
# 
# Therefore on 14.04 the packages have to be installed manually
#
# Copyright: 2015 inGenerator Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -o nounset
set -o errexit

# locate ubuntu version
source /etc/lsb-release
if [ "$DISTRIB_RELEASE" = "14.04" ]; then
  echo "Installing libgecode30 and libgecode-dev manually from 12.04 repos"
  TMPDIR=`mktemp -d`
  pushd "$TMPDIR"
  # These dependencies are still valid in the 14.04 repos
  apt-get install -y -q  libqtcore4 libqtgui4 libqt4-dev libboost-dev
  # These are the 12.04 packages
  wget "http://us.archive.ubuntu.com/ubuntu/pool/universe/g/gecode/libgecode30_3.7.1-3_amd64.deb"
  wget "http://us.archive.ubuntu.com/ubuntu/pool/universe/g/gecode/libgecode-dev_3.7.1-3_amd64.deb"
  wget "http://us.archive.ubuntu.com/ubuntu/pool/universe/g/gecode/libgecodegist30_3.7.1-3_amd64.deb"
  wget "http://us.archive.ubuntu.com/ubuntu/pool/universe/g/gecode/libgecodeflatzinc30_3.7.1-3_amd64.deb"
  dpkg -i libgecode30_3.7.1-3_amd64.deb libgecodegist30_3.7.1-3_amd64.deb libgecodeflatzinc30_3.7.1-3_amd64.deb libgecode-dev_3.7.1-3_amd64.deb
  popd
  rm -rf "$TMPDIR"
else
  echo "Installing libgecode30 and libgecode-dev from apt"
  apt-get install -y -q libgecode30 libgecode-dev
fi