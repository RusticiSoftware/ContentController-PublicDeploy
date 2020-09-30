#!/bin/bash

# Copy templates into position and set good random passwords for things

DATE=`date +%s`
SERVERNAME=$1

if [[ $# -eq 0 ]];
  then
    echo "Usage: setup.sh cc.example.com"
    echo "The only argument should be the Fully Qualified DNS Name you wish to assign to Content Controller"
    echo "This value is added to the ServerName variable in env.yml"
    exit 1
fi



random()
{
    PASSWORD=`cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9!@#$^&_=+()[]{}<>' | fold -w ${1:-32} | head -n 1`
}


while [[ ! $PROCEED =~ "YES" ]]; do
	echo "WARNING!!!"
	echo "This script sets up the files in group_vars/ with good default values for passwords and keys"
	echo "and copies the templates into place."
	echo "This script will overwrite all of the .yml files in the group_vars/ folder."
	echo "Unless you're configuring Content Controller for the 1st time, this is probably not what you want."
	echo "Please type YES to proceed, or Ctrl-c to quit"
	read PROCEED
done

if [ ! -e group_vars/keypair.yml ]
then
	echo "Your friends at Rustici should have provided you with a license keypair that you'll need in order to install Content Controller."
	echo "Please enter them here: (or leave these blank and just drop in your license file later.)"
	read -p "Please enter your download key id (AKIAxxxxxxxxxxxx): " DKEY
	read -p "Please enter your download secret: " SKEY
	KEYPAIR="overwrite"
fi

echo $KEYPAIR

cd group_vars

if [ -e env.yml ]
then
 cp env.yml env.yml.$DATE
fi

if [ -e content_controller.yml ]
then
 cp content_controller.yml content_controller.yml.$DATE
fi

if [ -e engine_java.yml ]
then
 cp engine_java.yml engine_java.yml.$DATE
fi

if [ -e cloudfront.yml ]
then
 cp cloudfront.yml cloudfront.yml.$DATE
fi

if [ -e s3.yml ]
then
 cp s3.yml s3.yml.$DATE
fi

cp env.yml.template env.yml
cp content_controller.yml.template content_controller.yml
cp engine_java.yml.template engine_java.yml
cp s3.yml.template s3.yml
cp cloudfront.yml.template cloudfront.yml
cp aws.yml.template aws.yml


# Setup env.yml
sed -i.bak  "s/\(^ServerName\:\).*/\1 $SERVERNAME/" env.yml
random 16; sed -i.bak "s/\(^tomcat_password\:\).*/\1 $PASSWORD/" env.yml
random 16; sed -i.bak "s/\(^mysql_root_password\:\).*/\1 $PASSWORD/" env.yml

# Setup Content Controller.yml
random 16; sed -i.bak "s/\(^cc_db_password\:\).*/\1 $PASSWORD/" content_controller.yml
random 16; sed -i.bak "s/\(^engine_password\:\).*/\1 $PASSWORD/" content_controller.yml
random 64; sed -i.bak "s/\(^secret_key\:\).*/\1 $PASSWORD/" content_controller.yml

# Setup engine-java.yml
random 16; sed -i.bak "s/\(^engine_db_password\:\).*/\1 $PASSWORD/" engine_java.yml

# Setup keypair.yml
if [[ "$KEYPAIR" == "overwrite" ]]; then
	cp keypair.yml.template keypair.yml
	sed -i.bak "s/\(^s3_download_key\:\).*/\1 $DKEY/" keypair.yml
	sed -i.bak "s/\(^s3_download_secret\:\).*/\1 $SKEY/" keypair.yml
fi

# Remove the extra .bak files that we had to generate since we're in compatibility mode with sed for OSX + Linux
rm engine_java.yml.bak
rm content_controller.yml.bak
rm env.yml.bak

echo "Done - I have copied over the templates and set new random passwords in the config files in group_vars/"

# Prevent further execution unless it's intentional
ME=`basename $0`
chmod 0600 ../$ME
