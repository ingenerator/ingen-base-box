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

The virtualbox base boxes are built on top of the `bento/ubuntu-18.04`
vagrant image. You will therefore need to install these locally before you can build on them.

```shell
vagrant box add bento/ubuntu-18.04
```

Then to build all the boxes:

```shell
packer build --var "version=0.5.0" --var-file=secret_vars.json packer.json"
```

To build a specific image, specify the name(s) in the --only parameter:

```shell
packer build --var "version=0.5.0" --var-file=secret_vars.json --only=ingen-jenkins-bionic64 packer.json"
```

### Uploading packaged vagrant boxes

The vagrant-cloud post-processor is broken at the moment so uploading the packaged box to
vagrant cloud is a manual step. Log in to https://atlas.hashicorp.com and use the web interface
to locate the appropriate ingenerator box, create a new version and upload the box file that 
packer will have created in your working directory.

## Provisioning a brand-new instance

If we have a base image for the hosting provider, launch that. If not, launch a bare Ubuntu 14.04 instance, SSH in, and run:

```bash
cd /tmp
wget https://github.com/ingenerator/ingen-base-box/archive/master.tar.gz
tar -xvf master.tar.gz
ingen-base-box-master/provisioning/bootstrap-instance.sh
```

Once you have an instance running our base box packages, you need to provision and deploy the project.

First:

* Login to github as the bot user for the project and create a new personal access token
* Get the project encrypted configuration key 

Then:
```bash
mkdir -p /var/www/www-source
cd /var/www/www-source
git clone https://$BOT_USER_TOKEN:x-oauth-basic@github.com/$GITHUB_ORG/$GITHUB_PROJECT_REPO .
mkdir -p /var/chef-solo/secrets
touch /var/chef-solo/secrets/$PROJECT_NAME.secret.key
chmod 0600 /var/chef-solo/secrets/$PROJECT_NAME.secret.key
nano /var/chef-solo/secrets/$PROJECT_NAME.secret.key
# paste in the secret key and save the file
git checkout $INITIAL_REVISION_TO_DEPLOY
architecture/provision $SERVER_ROLE
architecture/provision $SERVER_ROLE
# Run provisioning twice, because the first run will create new users/directories/etc that may affect
# the configs etc provisioned on the second run
```

And then you should be good to go.
