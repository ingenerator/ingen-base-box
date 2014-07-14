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

require_chef_version="11.8.2"

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

# Rubydoc really slows down gem install, and throws lots of warnings, and we don't need it
echo "Disabling all rubydoc by default"
echo "gem: --no-document --no-ri --no-rdoc" > /tmp/gemrc
sudo mv /tmp/gemrc /etc/gemrc

echo "Updating apt cache"
sudo apt-get update

echo "Installing basic native packages"
# includes native libraries required by gems to save compiling them locally
# libxslt-dev and libxml2-dev are for nokogiri
# libgecode30 is for dep-selector-gecode
sudo apt-get install -y -q build-essential curl git ruby1.9.3 libxslt-dev libxml2-dev libgecode30 libgecode-dev

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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing gems from gemfile in $DIR"
cd $DIR
USE_SYSTEM_GECODE=1 bundle install
