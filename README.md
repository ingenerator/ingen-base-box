# Ingenerator base box builder

Simple builder for customised vagrant base box, bootstrapped
with Chef and Berkshelf and very little else.

The boxes are built with [packer](https://www.packer.io/) to simplify provisioning of 
near-identical images from a common provisioning script.

### To build boxes

First, install packer (and virtualbox if you want to build vagrant boxes) following the 
instructions.

You will need some secret credentials, including an AWS access key and secret key. Drop a
secret_vars.json in the working directory, that looks like this:

```json
{
  "aws_access_key": "YOUR ACCESS KEY HERE",
  "aws_secret_key": "YOUR SECRET KEY HERE",
  "vagrant_cloud_token": "YOUR VAGRANT CLOUD TOKEN HERE"
}
```

The virtualbox base boxes are built on top of the `hashicorp/precise64` and `ubuntu/trusty64`
vagrant images. You will therefore need to install these locally before you can build on them.

```shell
vagrant box add hashicorp/precise64
vagrant box add ubuntu/trusty64
```

Then to build all the boxes:

```shell
packer build --var "version=$VERSION" --var-file=secret_vars.json packer.json"
```

To build a specific image, specify the name(s) in the --only parameter:

```shell
packer build --var "version=$VERSION" --var-file=secret_vars.json --only=ingen-jenkins-trusty64 packer.json"
```

### Uploading packaged vagrant boxes

The vagrant-cloud post-processor is broken at the moment so uploading the packaged box to
vagrant cloud is a manual step. Log in to https://atlas.hashicorp.com and use the web interface
to locate the appropriate ingenerator box, create a new version and upload the box file that 
packer will have created in your working directory.
