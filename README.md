# Ingenerator base box builder

Simple builder for customised vagrant base box, bootstrapped
with Chef and Berkshelf and very little else.

Currently, our boxes are all based on Ubuntu 12.04.

This is a quick fix solution, we are planning to move to 
Packer in the near future.

### To build as a vagrant virtualbox

#### Install guest additions
Ensure you have the `vagrant-vbguest` plugin installed, this will bring your
Guest Additions up to date automatically when you build the box. This presumes
that end-users will also be using the same or later virtualbox release, or that
they also install vagrant-vbguest.

#### Rebuild the machine
Build the machine from scratch to be sure there's nothing hanging around from an
SSH session etc.

```shell
vagrant destroy
vagrant up
```

#### Get the virtualbox machine name
This will be something like `ingen-base-box_default_14051231231232_1232`. 
You can find this by looking in the virtualbox manager, or by running 
`vboxmanage listvms`.

#### Package the box

```shell
$VERSION=0.1.0 # or whatever the next number is
vagrant package --base $VIRTUALBOX_MACHINE_NAME --output .boxes/ingen-base-precise64.$VERSION.virtualbox.box
```

#### Upload the packaged box
Upload the box to boxes.ingenerator.com, placing it in /var/www/boxes.ingenerator.com/ingen-base/

#### Create the box version on Vagrant cloud
Go to vagrant cloud and create the new box version, entering the virtualbox provider URL

### To build as an Amazon AMI (NB - this is NOT a vagrant box for the vagrant-aws plugin)

Spin up a new instance from the appropriate Ubuntu 12.04 x64 cloud AMI - see the list at http://cloud-images.ubuntu.com/locator/ec2/
[ami-19d80d63 for eu-west currently](https://console.aws.amazon.com/ec2/home?region=eu-west-1#launchAmi=ami-19d80d6e])

```bash
cd /tmp
wget https://github.com/ingenerator/ingen-base-box/archive/master.tar.gz
tar -xvf master.tar.gz
cd ingen-base-box-master
sudo ./bootstrap-instance.sh
```

Build an AMI from the instance.
