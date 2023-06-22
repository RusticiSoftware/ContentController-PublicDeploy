---
title: "Content Controller"
type: docs
menu:
    main:
        name: 4. IAM
        identifier: iam
        parent: aws
        weight: 5
---

# IAM

IAM manages credentials for you AWS account.  It can create users, API credentials, etc.  We'll need to provision an IAM role for the next few steps.  It's easiest to create this role and attach it to your Ansible EC2 instance, however you can also create API credentials and configure boto on your Ansible box manually.  We'll create a role here, and then we'll attach it to the Ansible box in the next section.

Go to **Services** -> **IAM**

## Create IAM role

1. Click on **Roles** on the left sidebar and click the blue **Create role** button.
2. Choose **AWS service** and **EC2**, then click **Next: Permissions**.
3. Attach the following policies by checking the boxes beside them:
	1. AmazonS3FullAccess
	2. AmazonEC2FullAccess
	3. IAMFullAccess
4. Click **Next: Review**
5. Enter `RusticiCCAnsibleRole` for the Name and `Allows the Rustici Content Controller Ansible instance to provision users, servers, and S3 buckets.` for the Description, and click **Create role**.

## Resources

[What Is IAM?](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

[IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
