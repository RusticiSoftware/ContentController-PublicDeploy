---
layout: post
title:  "AWS CloudFront Support"
date:   2016-06-09 17:55:06 -0500
categories: cloudfront s3 ansible deployment
---

![RusticiContentControllerLogo]({{site.url}}{{site.baseurl}}/assets/Rustici_ContentController.png)

* TOC
{:toc}

## Overview

Cloudfront acts like a proxy in front of your Content Controller Server and the S3 bucket that you use for storing course content.  For most connections, it just passes the request right through to your web tier.  For requests for course content, CloudFront authenticates the user via a signed cookie that the application generates, and if the user is allowed, it reaches into your S3 bucket and serves up the content.

CloudFront does all this while still appearing to have a DNS origin that is the same whether the content is coming from the web tier or the application layer, which allows us to deliver SCORM content without violating cross-domain rules.

If you're interested in some futher light reading on the subject, give these a go:

[Serving Private Content In CloudFront](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html)

[Cookie Signing Information](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-signed-cookies.html)

## Getting Started

### Elastic Load Balancer

If you don't already have your Content Controller server(s) behind an Elastic Load Balancer, go ahead and get that sorted out before you move on - CloudFront has to use an ELB as the Default Origin for this to all work.  Nope, you can't just use an EC2 instance - we've tried, and no workee :-(

### SSL
You'll need to have valid SSL certificates sorted out before you go any further, and they'll need to be available from the IAM Certificate Store or the ACM service.  Note that for CloudFront certificates, you have to upload the certs to the IAM Certificate Store with a CloudFront specific path, and that they must be 2048 bit certs - 4096 bit certs dont work!

Here's what a AWS CLI command to upload a CloudFront-compatible certificate to the IAM store looks like - note the `path` variable:

	aws iam upload-server-certificate --server-certificate-name cloudfront_star_example_com --certificate-body file://star_example_com.crt --private-key file://star_example_com.key --certificate-chain file://gd_bundle-g2-g1.crt --path /cloudfront/wildcard/

### Signing Keys

We use signed cookies to authenticate requests for content that lives in S3.  In order to make this work, you'll need to generate a pair of signing keys and make them available to the application thusly:

- [Generate your signing keys per this AWS doc](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-trusted-signers.html) and note the Access Key ID for the keypair.

-  Convert the private key to DER format so that Java can grok it:

		openssl pkcs8 -topk8 -nocrypt -in privatekey.pem  -inform PEM -out privatekey.der  -outform DER

-  Place your private and public key files in `roles/cloudfront/files`

### Ansible Config

- [Configure your ContentController installation to use S3 for content storage as per the README]({{site.baseurl}}{% post_url 2016-06-11-AWS-S3-Support %}#s3-support)

- Copy the `group_vars/cloudfront.yml.template` file to a working file:

		cp group_vars/cloudfront.yml.template group_vars/cloudfront.yml


- Set the `use_cloudfront` variable in `group_vars/cloudfront.yml` to `true`

- Add the Access Key ID for your Signing Keys to the `cloudfront_access_key_id` variable

- Add the filename (without path) of your private and public key files to the `group_vars/cloudfront.yml` file in these variables, similar to the following:

		cloudfront_private_key: private.der
		cloudfront_public_key: public.pem

### Create your Distribution

Create a new CloudFront Web distribution, and configure it thusly:

#### Default Origin Settings:

![DefaultOriginSettings]({{site.url}}{{site.baseurl}}/assets/CloudFront-ELB-OriginSettings.png)

#### Default Cache Behavior Settings:

![DefaultBehaviorSettings]({{site.url}}{{site.baseurl}}/assets/CloudFront-ELB-BehaviorSettings.png)

#### Distribution Seetings:

![DistroSettings]({{site.url}}{{site.baseurl}}/assets/CloudFrontDistributionSettings.png)


#### S3 Bucket Origin:

Create a new Origin that points at the S3 bucket you've provisioned for your content thusly.  It's a good idea to use the "Create A New Identity" feature to set up the Origin Access Identity for your bucket unless you've got something clever up your sleeve.

![S3OriginSettings]({{site.url}}{{site.baseurl}}/assets/CloudFront-S3-OriginSettings.png)

#### S3 Origin Behavior Settings

Create a new Cache Behaviour that uses your S3 bucket Origin.  Note the `Path Pattern` setting in particular!

![S3BehaviorSettings]({{site.url}}{{site.baseurl}}/assets/CloudFront-S3-BehaviorSettings.png)

### Reconfiguring Content Controller

Now that you've configured everything, you'll need to reconfigure Content Controller to use the new settings:

Run the `cloudfront.yml` playbook against your servers to update stuff (YMMV here, change this to suit your environement and inventory file):
		
		ansible-playbook -i inventoryfile cloudfront.yml

### Testing

The best smoke test for your CloudFront setup is to launch a course and verify that it works properly.  Under _Content > Courses_, select a course and choose "Test" under _Course Details_.

![TestLaunch]({{site.url}}{{site.baseurl}}/assets/CC-TestLaunch.png)

If the Course Launches, you're ready to roll.  If it fails, well, Team Delight is here to help:  hit us up at support@scorm.com or our [Support Site](support.scorm.com) and we'll help you get it all working.



