#!/bin/bash

# Adds the dependencies for using the instance as a Jenkins slave
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

add-apt-repository -y ppa:openjdk-r/ppa
apt-get update 
apt-get install -y openjdk-8-jre openjdk-8-jdk
mkdir -p /var/jenkins/workspace
chown -R ubuntu:ubuntu /var/jenkins
