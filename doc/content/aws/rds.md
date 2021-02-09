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

Content Controller works on MySQL 5.6 & 5.7 and the Aurora counterparts for those versions.  We recommend MySQL 5.7, and that is the version we test against daily.  Content Controller does not support read replicas (you can create one for your own usage, but the application won't take advantage of it).

Go to **Services** -> **Relational Database Service**.

## Subnet Groups

Before launching your database, we'll need to create a Subnet Group to launch it in.

1. Click on **Subnet groups** on the left sidebar and click the orange **Create DB Subnet Group** button.
2. Enter `Rustici CC RDS Subnet Group` for the name, enter a description, and choose `Rustici CC VPC` for the VPC.
3. Under Add Subnets, add both of your private subnets (no public subnets).  Note: AWS doesn't show the subnet names here, so you may need to refer to the VPC Subnet list and take note of the IDs.

## Parameter Groups

A parameter group allows you to set certain DB parameters that will be applied when an instance is launched.  We'll need a custom one.

1. Click on **Parameter groups** on the left sidebar and click the orange **Create parameter group** button.
2. Choose **mysql5.7** for the parameter group family, enter `Rustici-CC RDS-Paramter-Group` for the name, and enter a description, then click **Create**.
3. Select the newly created parameter group from the list.
4. Search for `log_bin_trust_function_creators`, check the box beside it, and click **Edit parameters**.  Set it to `1`, and click **Save changes**.

## Instances

1. Click on **Instances** on the left sidebar and click the orange **Launch DB Instance** button.
2. Select **MySQL** and click **Next**.
3. Choose **Production - MySQL** and click **Next**.
4. Enter the following values and click **Next**
	1. DB engine version: choose the latest 5.7 version (>= 5.7.21)
	2. DB instance class: choose your preferred size (at least t2.medium) (contact us if you have questions about which size would be best here)
	3. Multi-AZ deployment: choose **Create replica in a different zone**
	4. Storage type: Choose **General Purpose (SSD)**
	5. Allocated storage: Enter at least 100 GB [Read here for more information about IOPS vs storage size](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html) Note that IOPS are the first limit people usually hit when scaling up with Content Controller
	6. DB instance identifier: `cc-prod`
	7. Master username: `ccroot` or the value you chose when editing `group_vars/env.yml` earlier
	8. Master password: the value generated in `group_vars/env.yml` earlier
5. Enter the following values and click **Launch DB instance**
	1. Virtual Private Cloud: `Rustici CC VPC`
	2. Subnet group: `rustici cc rds subnet group`
	3. Public accessibility: **No**
	4. Availability zone: **No preference**
	5. VPC security groups: **Choose existing VPC security groups**, then remove **default**, and add `CC Database`
	6. Database name: leave blank
	7. Database port: 3306
	8. DB parameter group: `rustici-cc-rds-parameter-group`
	9. Option group: `default:mysql-5-7`
	10. IAM DB authentication: **Disable**
	11. Encryption: Your preference
	12. Backup: Your preference - at least 1 day
	13. Monitoring: Your preference
	14. Log exports: Your preference
	15. Maintenance: Your preference (but we recommend **Enable auto minor version upgrade** so that security patches are applied quickly)

## Configuration

Now that your database instance is up and running, you will need to setup the playbooks to point Content Controller at it.

1. Select your new database from the **Instances** list in the **Relational Database Service** console.
2. Scroll down to the **Details** panel, and copy the **Endpoint**.  (It should look something like `cc-prod.************.us-east-1.rds.amazonaws.com`).
3. SSH to your Ansible instance and navigate to your `ContentController-PublicDeploy` folder.
4. Edit `group_vars/content_controller.yml`.
5. Find the line `cc_db_host: localhost` and replace `localhost` with the endpoint you copied from the RDS console.
6. Save and exit.
