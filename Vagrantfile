# This is the Vagrant config file for building a bootstrapped inGenerator vagrant box.
#
# Only the most basic common tools and configuration should be installed with this 
# project, just those things that would otherwise be copied almost verbatim for all
# server roles across all our projects.
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  Vagrant.require_version ">= 1.5.0"
  
  # Configure the base box - will be sourced from vagrant cloud
  config.vm.box = "ubuntu/trusty64"
  
  # Common configuration for virtualbox
  # Based on the performance enhancements for ubuntu in http://blog.jdpfu.com/2012/09/14/solution-for-slow-ubuntu-in-virtualbox
  # Also by default don't show a GUI unless an environment variable is set
  config.vm.provider "virtualbox" do |v|
    v.gui    = ENV['VAGRANT_GUI']
    v.memory = 512

    # Performance enhancements from http://blog.jdpfu.com/2012/09/14/solution-for-slow-ubuntu-in-virtualbox
    v.customize ["modifyvm", :id, "--chipset", "ich9"]     # Chipset ICH9
    v.customize ["modifyvm", :id, "--ioapic", "on"]        # IO APIC On
    v.customize ["modifyvm", :id, "--accelerate3d", "off"] # 3D acceleration off
  end
  
  # Configure synced folders - the project path is always required in /vagrant
  config.vm.synced_folder ".", "/vagrant"
  
  # And run our bootstrapping shell scripts
  config.vm.provision :shell, :path => 'provisioning/bootstrap-instance.sh'
  config.vm.provision :shell, :path => 'provisioning/cleanup-ubuntu.sh'
  config.vm.provision :shell, :path => 'provisioning/minimize.sh'
  
end
