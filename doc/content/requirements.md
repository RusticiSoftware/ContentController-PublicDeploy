---
title: "Infrastructure Requirements"
type: docs
menu: "main"
weight: 1
---

# Infrastructure Requirements

Content Controller has four required components: a database to store application data, file storage for courses and other application data, an application server, and a control server.

## Minimum Requirements

### Database

Content Controller requires MySQL 5.7.  We recommend a MySQL 5.7 installation dedicated to Content Controller.  For details about specific settings that will be required in your MySQL instance, see [Installation Guide](/self-hosting/quick-start) or [RDS Setup](/self-hosting/aws/rds).

### File Storage

If you're running more than one Content Controller application server (which we highly recommend for production), you will need some kind of shared storage mechanism for your SCORM content. SCORM content has to live on a filesystem somewhere (it does not get persisted in the database).

If you're using AWS, we recommend using S3 for content storage and CloudFront for distribution. We designed Content Controller to use these technologies, and we test against them with every build. For a high-performance setup that doesn't cost a fortune, this is the way to go.

If you prefer not to use S3 and CloudFront, here are some alternative options:

- An iSCSI target
- A direct attached SAN of some sort
- An NFS share
- We don't recommend using SMB shares. You might be able to make it work fine, but please don't ask us to support it.

Storage is the most difficult aspect of sizing to predict - it all depends upon your content.  If you're unsure, talk to us about your content and we'll help you find a way to spec an environment to suit.

### Application Server

Content Controller requires _at least_ one server used only for running the Content Controller application.  We support Ubuntu 18.04 LTS and 20.04 LTS, and Red Hat/CentOS 7 and 8. We recommend using Ubuntu, as we have the most experience with that OS, but we can support Red Hat deployments if that is preferred by your team.

This server will contain Apache, Tomcat, Content Controller, SCORM Engine, Java, temporary files, logs, etc.  But don't worry about the long list - we've created some [Ansible playbooks](/self-hosting/deploy-tools) to help you deploy and configure these dependencies in a way that's tested and reliable. These playbooks require Ansible version 2.5 or newer.

**Note**: Content Controller's deployment process involves downloading dependencies onto the application server. Due to this, we strongly recommend allowing your app servers to connect to the internet during deployment. If that is not possible, then you will need to pull the list of dependencies from the Ansible playbooks, download the necessary packages, and deploy them onto the server.

### Control Server

You will need a place to store your Ansible tools, configuration secrets, etc.  You need to use a separate box from your application servers for this purpose, but you can share the Ansible box for deploying to production and staging.  If you already have a Jenkins setup or other infrastructure orchestration box, feel free to use it.  The only requirements are that it runs Linux (Ubuntu 18.04 is recommended), can run Ansible, has SSH access to your application servers, and is kept secure and backed up.

## Server Sizing

### QA / Staging Environments

If you're customizing the playbooks or the base server for your own needs, you'll probably want to run a small staging environment to test things out before moving to production.  We run our QA environment on a t2.medium EC2 instance which has the following specs:

- 4 GB RAM
- 2 vCPU (2.4 GHz Xeon)

This box is running the entire stack, database and all, and works fine for test purposes.  We also run it successfully in a Parallels VM of similar specs for dev stuff.

### Production Environments

Every environment is unique, but we've found that the following guidelines are a great starting point.

#### Entry Level

In our hosted environments, we have successfully served loads of 100 course launches per hour with two AWS EC2 t2.medium application servers and a single RDS t2.small database server. In bare-metal terms, that translates into:

Application Servers:

- 2 servers running behind a load balancer
- 4 GB RAM each
- 2 vCPU (2.4 GHz Xeon) each
- 80 GB of local storage (not content storage)

Database Server:

- 2 GB RAM
- 1 vCPU (2.4 GHz Xeon)

Control Server:

- 1 GB RAM
- 1 vCPU

#### Really Big

In our hosted environments, we are able to serve loads of up to 2500 course launches per hour with 5 AWS EC2 t2.medium app servers and a single RDS r5.2xlarge database backend. In bare-metal terms, that translates into:

Application Servers:

- 5 servers running behind a load balancer
- 4 GB RAM each
- 2 vCPUs (2.4 GHz Xeon) each
- 80 GB of local storage (not content storage)

Database Server:

- 61 GB RAM
- 8 vCPUs (2.4 GHz Xeon)

Control Server:

- 1 GB RAM
- 1 vCPU

#### Your Environment

If you have questions, give us a call, and tell us about your environment.  We can help you spec something appropriate and cost-effective.

## Hosting Providers

We highly recommend using Amazon Web Services, but it is not required.  We've provided detailed instructions for running the application in AWS, and we've provided playbooks to automate several of the deploy steps.
