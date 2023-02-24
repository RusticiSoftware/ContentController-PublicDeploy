---
title: "Content Controller"
type: docs
menu:
    main:
        name: 7. RDS
        identifier: rds
        parent: aws
        weight: 8
---

# RDS

RDS (Relation Database Service) provides pre-configured and easy-to-use databases.  Updates, backups, and fail-overs are managed by AWS.  While you could setup your own EC2 instances running MySQL, we highly recommend using RDS.

Content Controller works on MySQL 5.7 & 8.0 and the Aurora counterparts for those versions.  We recommend MySQL 8.0, and that is the version we test against daily. Content Controller does not support read replicas (you can create one for your own usage, but the application won't take advantage of it).

Go to **Services** -> **Relational Database Service**.

## Subnet Groups

Before launching your database, we'll need to create a Subnet Group to launch it in.

1. Click on **Subnet groups** on the left sidebar and click the orange **Create DB Subnet Group** button.
2. Enter `Rustici CC RDS Subnet Group` for the name, enter a description, and choose `Rustici CC VPC` for the VPC.
3. Under Add Subnets, add both of your private subnets (no public subnets).  Note: AWS doesn't show the subnet names here, so you may need to refer to the VPC Subnet list and take note of the IDs.

## Parameter Groups

A parameter group allows you to set certain DB parameters that will be applied when an instance is launched.  We'll need a custom one.

1. Click on **Parameter groups** on the left sidebar and click the orange **Create parameter group** button.
2. Choose **mysql8.0** for the parameter group family, enter `Rustici-CC RDS-Paramter-Group` for the name, and enter a description, then click **Create**.
3. Select the newly created parameter group from the list.
4. Search for `log_bin_trust_function_creators`, check the box beside it, and click **Edit parameters**.  Set it to `1`, and click **Save changes**.

## Instances

1. Click on **Databases** on the left sidebar and click the orange **Create database** button.
2. Select **Standard create** and **MySQL**.
3. Select the latest 8.0 version for **Engine Version**.
4. Select **Production - MySQL**.
5. Select **Multi-AZ DB instance**.
6. Set the DB instance identifier to `cc-prod`.
7. Set master username to `ccroot` or the value you chose for `mysql_root_user` in `group_vars/env.yml` earlier.
8. Set master password to the value specified for `mysql_root_password` in `group_vars/env.yml`.
9. For the DB instance class select at least a t4g.medium. Check out our recommendations in [Infrastructure Requirements](https://docs.contentcontroller.com/self-hosting/requirements/) or reach out to us if you have questions about size for your instance.
10. For storage type choose `General Purpose (SSD)`.
11. For allocated storage enter at least 100 GB [Read here for more information about IOPS vs storage size](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html) **Note that IOPS are the first limit people usually hit when scaling up with Content Controller
12. Enter the following values under **Connectivity**.
	* Virtual Private Cloud: `Rustici CC VPC`
	* Subnet group: `rustici cc rds subnet group`
	* Public accessibility: **No**
	* Availability zone: **No preference**
	* VPC security group: **Choose existing**, then remove **default**, and add `CC Database`
	* Database port: 3306
13. For database authentication select **Password authentication**.
14. Configure the monitoring section to your preference.
15. Enter the following values under **Additional Configuration** and click **Create database**.
	* Database name: leave blank
	* DB parameter group: `rustici-cc-rds-parameter-group`
	* Option group: `default:mysql-8-0`
	* Backup: Your preference - at least 1 day
	* Encryption: Your preference
	* Log exports: Your preference
	* Maintenance: Your preference (but we recommend **Enable auto minor version upgrade** so that security patches are applied quickly)

## Configuration

Now that your database instance is up and running, you will need to setup the playbooks to point Content Controller at it.

1. Select your new database from the **Instances** list in the **Relational Database Service** console.
2. Scroll down to the **Connectivity & security** panel, and copy the **Endpoint**.  (It should look something like `cc-prod.************.us-east-1.rds.amazonaws.com`).
3. SSH to your Ansible instance and navigate to your `ContentController-PublicDeploy` folder.
4. Edit `group_vars/content_controller.yml`.
5. Find the line `cc_db_host: localhost` and replace `localhost` with the endpoint you copied from the RDS console.
6. Save and exit.
