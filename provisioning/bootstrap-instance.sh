#!/bin/bash

# Ensures that the instance has the correct chef, ruby, berkshelf and related dependencies
#
# Copyright: 2013 inGenerator Ltd
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

require_chef_version="13.12.3"

# ------------------------------------------------------------------------------
# Error handlers
# ------------------------------------------------------------------------------
set -o nounset
set -o errexit
function error_handler()
{
    echo "********************************************************"
    echo "* PROVISIONING FAILED - SEE COMMAND OUTPUTS ABOVE      *"
    echo "********************************************************"
}
trap 'error_handler' ERR

# ------------------------------------------------------------------------------
# Setup
# ------------------------------------------------------------------------------
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Rubydoc really slows down gem install, and throws lots of warnings, and we don't need it
echo "Disabling all rubydoc by default"
echo "gem: --no-document --no-ri --no-rdoc" > /tmp/gemrc
sudo mv /tmp/gemrc /etc/gemrc

echo "Updating apt cache"
sudo apt-get update

echo "Updating base distribution packages"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew";
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

echo "Installing basic native packages"
# includes native libraries required by gems to save compiling them locally
# libxslt-dev and libxml2-dev are for nokogiri
sudo apt-get install -y -q build-essential curl git libxslt-dev libxml2-dev software-properties-common

echo "Installing ruby"
sudo apt-add-repository ppa:brightbox/ruby-ng -y
sudo apt-get update
sudo apt-get install -y -q ruby2.4 ruby2.4-dev

# ------------------------------------------------------------------------------
# Chef
# ------------------------------------------------------------------------------
echo "Installing Chef version '$require_chef_version'"
sudo curl -L https://www.opscode.com/chef/install.sh > /tmp/chef-install.sh
sudo chmod +x /tmp/chef-install.sh
sudo /tmp/chef-install.sh -v $require_chef_version

# ------------------------------------------------------------------------------
# Chef and knife plugins
# ------------------------------------------------------------------------------
echo "Installing Chef and knife plugins"
sudo /opt/chef/embedded/bin/gem install --no-rdoc --no-ri knife-solo_data_bag

# ------------------------------------------------------------------------------
# Bundler and then gems
# ------------------------------------------------------------------------------
echo "Installing bundler"
sudo gem install bundler

echo "Installing libarchive for berkshelf"
sudo apt-get install -y libarchive-dev

echo "Installing berkshelf from $DIR to /usr/lib/berkshelf"
if [ ! -d /usr/lib/berkshelf ]; then
  mkdir /usr/lib/berkshelf
fi
cp $DIR/berkshelf/* /usr/lib/berkshelf
bundle install --gemfile=/usr/lib/berkshelf/Gemfile --deployment --binstubs
ln -s /usr/lib/berkshelf/bin/berks /usr/bin/berks

INSTALLED_BERKS_VER=`berks --version`
echo "Berkshelf installed : version $INSTALLED_BERKS_VER"
