---
layout: post
title:  "S3 Support"
date:   2016-06-08 17:55:06 -0500
categories: deployment ansible aws s3
---

* TOC
{:toc}

# S3 Support 

Content Controller can use S3 for file storage.  This is _The Right Way To Do It_ if you're running Content Controller on AWS, and is a requirement for using CloudFront as your frontend/CDN.

## Automagic Setup:

To run the automagic setup playbook, you'll need the following:

1. Your AWS Account Number.

1. Have your shell environment configured with powerful AWS credentials that will let you create a S3 bucket and create new IAM users and policies.  [The easiest way to do this is to configure the AWS CLI as per this article](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

1. A CloudFront origin access identity ID # (using S3 for content storage requires CloudFront.) To create an identity, [you can use the AWS console here.](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#oai:) This id will look something like:
	
	`E3NV0WR238LI90`



To run the automagic setup, do thusly:

	ansible-playbook aws-s3.yml --extra-vars="cloudfront_origin_access_identity=yourcforiginid"

...and answer the questions it asks.

This playbook will:

1. Create a new S3 bucket for you.  

1. set up an IAM user, group, and policy that assign sufficient rights to read/write from the new bucket.

1. Grant your CloudFront Origin Access Identity the rights it needs to access the bucket.

1. Create a valid `group_vars/s3.yml` file for ansible to use when it sets up Content Controller.

## Deleting it all and starting over.

Sometimes the first pass won't go right, and you need to blow it away and try again.  To undo all of your changes and delete the bucket and user you've created, do thusly:

NOTE THAT THIS IS DANGEROUS, AND WILL TOTALLY DELETE YOUR S3 BUCKET WITHOUT REMORSE.  ONLY USE IT IF YOU AREN'T USING STUFF YET AND ARE STILL SETTING THINGS UP.

	ansible-playbook aws-s3.yml --extra-vars="cloudfront_origin_access_identity=none, Slartibartfast=true"
	
