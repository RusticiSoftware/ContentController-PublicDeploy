# Quick Start Guide

This Quick Start Guide is for someone who has a working knowledge of AWS and wants to jump right in or someone who is planning to host Content Controller on a different platform (such as Azure, Google Cloud, bare metal, etc).  If you want detailed deployment steps for AWS, take a look at the [Deploying in AWS](aws/AWS.md) section.

Before you start, read through the [Requirements](Requirements.md), [Hosting at Scale](Infrastructure.md), and [Deploy Scripts and Tools](DeployTools.md) sections, and make sure you have a good understanding of how the Ansible playbooks are structured.

## Prepare Your Infrastructure

1. Setup your hosting environment
  * Public and private subnets
  * Shared storage for content (such as an NFS or S3 compatible object storage)
  * Load balancer
  * Content delivery network
2. Create your control server
  * Running Ubuntu 14.04 or greater
  * Accessible via SSH
  * Has privileged access to your application servers

## Prepare Your Control Server

1. SSH to your control server.
2. Install `git`.
3. Run `git clone https://github.com/RusticiSoftware/ContentController-PublicDeploy.git`.
4. Change to the `ContentController-PublicDeploy` folder.
5. Run `./bootstrap.sh` to install Ansible, python, boto, and other dependencies.
6. Copy the `keypair.yml` file provided by Rustici into `group_vars/keypair.yml`.
7. Run `./setup.sh cc.example.com`, but replace `cc.example.com` with your FQDN for Content Controller.
8. Take note of the DB `mysql_root` user and password from `group_vars/env.yml`.

## Prepare Your Database

1. Setup your MySQL using the root username and password copied from the last steps.
1. Apply the following settings:

### Binary Logging of Stored Programs

If you're using Amazon RDS, or are running on a server that is doing binary logging (which is most modern MySQL servers) and upon which your user lacks the SUPER privilege, you'll need to set the global variable `log_bin_trust_function_creators` to `1` in the parameter group associated with your Content Controller databases.

If you don't do this, Content Controller database migrations that use triggers will fail, which will cause problems during deployment.

For more information, please see:

https://aws.amazon.com/premiumsupport/knowledge-center/rds-mysql-functions/

https://dev.mysql.com/doc/refman/5.6/en/stored-programs-logging.html

### SQL Mode

Due to some changes made to the way `JOIN`s work in MySQL 5.7 (`ONLY_FULL_GROUP_BY`), you will need to disable that SQL mode.  To minimize the differences between your system and our QA systems, we recommend that you use the AWS RDS default `sql_mode` of `NO_ENGINE_SUBSTITUTION`.

For more information, please see:

https://dev.mysql.com/doc/refman/5.7/en/sql-mode.html

## Configure Shared Storage

If you want to use S3 and CloudFront, follow the detailed documentation in [Deploying to AWS](aws/AWS.md).  You can use these even if you are hosting your application with a different provider (although the CloudFront bits will be more complicated).

If you're using a non-AWS S3 compatible object store, those settings will go in `group_vars/s3.yml`.  Note that you will need to provide a way to serve these files manually on the same domain that Content Controller is hosted from at the `/courses/*` path.  We use CloudFront for this.  If you're using a NFS, mount it on your application servers at `/mnt` or `/mnt/content` (or mount it where you want and update the `data_root` settings in your Ansible config).  Apache will handle serving your content from the NFS automagically.

If you're only using one application server, you can host the content on the server itself.  This is the default config.

## Prepare your environment config

1. Go to the `ContentController-PublicDeploy` folder on your control server.
2. Edit the files in `group_vars` to set your DB endpoint and to ensure the other settings are correct.  See [Deploy Scripts and Tools](DeployTools.md) for more details about things that will need to be configured.

## Deploy

If you're using AWS, refer to the details about [Building and Deploying an AMI](aws/AMI.md).  If you're using fixed machines and want to deploy straight to them:

1. Setup your application servers.  These should be a base Ubuntu 14.04 or later install.  Take note of their IPs, the SSH user name, and the SSH key.
2. Go to the `ContentController-PublicDeploy` folder on your control server.
3. Copy `inventory` to `inventory.prod`.
4. Edit the inventory and delete the dummy IP addresses replacing them with the IP addresses to your application servers.
5. Run the Ansible playbooks against your production servers:
```
ansible-playbook --user=YOUR_SSH_USER --connection=ssh --inventory-file=inventory.prod env.yml
```

**Note:** you may need to add `--ask-sudo-pass` or `--private-key="~/.ssh/my_private_key.pem"` to get SSH to work.

## Upgrading

1. Take a look at the [Release Notes](https://support.scorm.com/hc/en-us/sections/115000419513-Release-Notes) to see if there are any important messages about self-hosting for any of the versions between the one you're starting on and the one you're moving to.
2. Go to the `ContentController-PublicDeploy` folder on your control server.
3. Create an image of your DB, control server, and an application server in case something goes sideways during the upgrade.
4. Run `git pull`, then run `git checkout vx.x.xxx` replacing `x.x.xxx` with the version number you are moving to.
5. Run the ansible-playbook command you used above.
