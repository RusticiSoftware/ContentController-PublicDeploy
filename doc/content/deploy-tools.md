---
title: "Deploy Tools Reference"
type: docs
menu: "main"
weight: 3
---
# Deploy Tools Reference

Content Controller is a fairly complex application, so we've created a set of Ansible playbooks and Bash scripts to help you deploy it.

[Ansible playbooks](http://docs.ansible.com/ansible/2.4/playbooks.html) are a collection of tasks that describe how application componets are deployed.  These playbooks are further broken down in to [Roles](http://docs.ansible.com/ansible/2.4/playbooks_reuse_roles.html).  There is usually one role per application component.  You'll want to pay special attention to the section labeled **Group Vars** below, as that is how you will configure your installation.

To make it easier to understand, let's dive in to the Content Controller playbooks. [You can find those here on GitHub](https://github.com/RusticiSoftware/ContentController-PublicDeploy).

Note that you don't *have* to understand every detail of these playbooks, but if you are hosting the application yourself, it certainly helps when things go sideways to have an idea of what is running on your servers and how it gets there.

## Bash Scripts

There are a few bash scripts that are useful for getting started.

### `bootstrap.sh`

Run this on your Ansible control server.  It will install all of the necessary dependencies for running the playbooks.

### `setup.sh`

Only run this once!  It sets up the initial group vars for you, sets sane defaults, and generates passwords and secrets. After adding your `keypair.yml` file, run this script.

## Roles

Inside the `roles` folder, you'll find several folders.  Each folder is a role which contains default variables, tasks, files, and templates and is responsibile for installing and configuring an application component.

* `tasks` describe exactly what the role will do and when.
* `defaults` are variables that can be configured by you if needed.  If you want to change one of these variables, place those changes somewhere in your `group_vars` or `host_vars` - don't modify the actual files in `defaults`.
* `vars` are variables that are used by the role.  They typically shouldn't be changed (overwriting them in the `group_vars` or `host_vars` won't work).
* `handlers` are executed by the `tasks` when things are changed.  We typically use them to restart services after the role has finished executing.

### `apache`

Installs the Apache web server, which acts as a reverse proxy to Content Controller and SCORM Engine.

### `aws-s3`

Provisions S3 buckets, IAM users, and creates an S3 group var when initial provisioning Content Controller inside of Amazon Web Services.  This role is covered in more detail in the AWS setup.  It will only be used one time.

### `cc-scorm-engine`

Installs Rustici Engine, which carries the bulk of the load when serving courses to learners.

### `cloudfront`

Copies cookie signing keys for AWS CloudFront to the proper locations on the server.

### `common`

Performs some important tasks such as installing operating system dependencies and setting the server timezone to UTC.

### `content-controller`

Installs the Content Controller application and writes configuration templates.

### `java`

Installs and updates the Oracle Java JDK to the latest supported version.

### `mnt`

Sets up folders and permissions for temp files or mounted folders when using a storage solution other than AWS S3.

### `mysql-config`

Installs local dependencies for connecting to MySQL, creates application DB users with appropriate permissions, sets up tables, and performs some hardening.

### `mysql-local`

Installs a local copy of MySQL for QA and staging environments.

### `ssl`

Installs SSL certs when terminating SSL at Apache.  Also generates self-signed SSL certs for QA and staging environments.

### `tomcat`

Installs and configures Apache Tomcat for use by Rustici Engine.

## Group Vars

### `aws.yml`

Contains settings for the `build_ami.yml` playbook.  If you are not using AWS or you don't want to deploy releases using the AMI builder, then you can ignore this file.

### `cloudfront.yml`

Enables AWS CloudFront and provides settings for allowing Content Controller to sign CloudFront cookies.  You can ignore this if you aren't using CloudFront and S3.

### `content_controller.yml`

Contains important settings for the Content Controller application such as database credentials, auth token secret key, initial application user credentials, and email credentials.

### `engine_java.yml`

Contains settings for Rustici Engine.  You can probably ignore most of these.

### `env.yml`

This one is where the majority of the configuration happens, and you should review it carefully.  Some important things to check on in this file include:
* `ServerName` - the domain name used by Content Controller
* `S3FileStorageEnabled` - you'll want to set this to true if you're using AWS S3
* SSL settings - we recommend terminating SSL at the load balancer if you're using AWS.  If not, you'll want to follow the instructions for adding SSL certificates and set `use_ssl` to true.
* Heap size - if your application servers have more than 4 GB RAM, you'll want to adjust these values.

### `keypair.yml`

This file contains credentials for downloading the latest release of Content Controller.  It will be provided by Rustici during the project kickoff.

### `s3.yml`

Contains settings for AWS S3.  If you run the `aws-s3.yml` playbook to setup S3, then this file will be created for you.

## Host Vars

If you have a staging and production installation of CC and want specific settings to vary between them, using `host_vars` will be how you accomplish that. You will need to add a separate `host_vars` file for each environment that contains the different settings. These files will overwrite settings from the shared `group_vars` config files.  An example setup might look like:

* `host_vars/demo.contentcontroller.net.yml`
* `host_vars/demo-staging.contentcontroller.net.yml`

All of your `group_vars` files will stay the same, and the values that the settings should have for production will be specified in your `host_vars` entry. There may be other settings you want to differ between environments, but we expect the following to be set:

* `ServerName`: the domain name used by Content Controller
* `cc_db_host`: used to ensure that your deployment doesn't affect the test environment's database
* `mysql_root_password`: the root password of the target database

We also recommend changing the following between environments for the sake of security, but it isn't necessary. The exact values don't matter, as long as they are unique and secure passwords:

* `cc_db_password`
* `engine_db_password`
* `engine_password`
* `tomcat_password`
* `secret_key`
* `cc_user_password`

When you want to reference a `host_vars` file during deployment, just add the argument `--extra-vars="@host_vars/name.of.file.yml"` somewhere before the `env.yml`. Ansible will read the file you've provided, and the settings specified in that file will overwrite the values you've configured in the `group_vars` directory.

Again, these files are for environment-specific settings. Anything that applies to both staging and production environments (like SMTP settings, file paths, etc) will go in the `group_vars` directory, and anything environment-specific goes in the `host_vars` directory for that environment. If you have any questions about the best way to setup a separate staging and production environment, give us a call.

## Playbooks

We provide several playbooks to assist you with deploying Content Controller.

### `aws-s3.yml`

This playbook sets up the majority of the necessary bits in AWS for using S3 with Content Controller.

### `build-ami.yml`

If you're using AWS, this is the best way to deploy Content Controller.  It creates a new EC2 instance, deploys Content Controller to it, creates an AMI (Amazon Machine Image), and then destroys the EC2 instance.  You can then add the AMI to an autoscaling group or use the image to spin up a few servers and add them to your load balancer target.  Refer to the deploying on AWS section for more information.

### `env.yml`

Deploys Content Controller.  It will automatically load the group vars.

### `env-novars.yml`

Also deploys Content Controller, but skips loading group vars.  You must include the group vars from the command line or provide a fully-loaded host vars file.  You probably won't need this one.

## Helpful Resources

* [Ansible Documentation](http://docs.ansible.com/ansible/2.4/index.html)
* [Ansible Playbooks](http://docs.ansible.com/ansible/2.4/playbooks.html)
* [Ansible Roles](http://docs.ansible.com/ansible/2.4/playbooks_reuse_roles.html)
* [Where Should I Put A Variable?](http://docs.ansible.com/ansible/2.4/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
