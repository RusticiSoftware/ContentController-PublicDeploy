---
title: "Enabling Support for HTTP Learners"
type: docs
menu:
    main:
        name: Enabling HTTP Learners
        identifier: http
        parent: faq
        weight: 3
---

# Enabling Support for HTTP Learners

Some LMSs do not support launching courses via HTTPS.  When possible, we recommend always using HTTPS (which is why HTTP support is disabled by default).  If you find that you need to enable support for launching courses via HTTP, follow these instructions.

## AWS

If you are not using AWS, you'll need to update your load balancer and firewall to allow HTTP traffic (TCP/80) to your application servers. If you are using AWS, you'll need to make sure you allow HTTP access on your load balancer and in CloudFront.

**Note:** By default, we will still redirect users of the management UI to HTTPS (based on the `X-Forwarded-Proto` from your load balancer), even if HTTP is enabled.

### Enabling HTTP Access on the Application Load Balancer

1. Go to **Services** -> **EC2**.
2. Click on **Load Balancers** on the left side bar.
3. Select your CC load balancer and click on the **Listeners** tab.
4. Click **Add listener**.  Choose **HTTP** for the protocol, `80` for the port, and your app server's target group.
5. Click **Create**.

{{< img src="/self-hosting/faq/img/ec2-elb-listeners.png" >}}

### Enabling HTTP Access on the Load Balancer Security Group

1. Go to **Services** -> **EC2**.
2. Click on **Security Groups** on the left side bar.
3. Select your CC Load Balancer security group and click on the **Inbound** tab.
4. Click **Edit** and add a rule for **HTTP** from `0.0.0.0/0`.
5. Click **Save**.

{{< img src="/self-hosting/faq/img/ec2-sg-elb-inbound-rules.png" >}}

### Enabling HTTP Access on the CloudFront Distribution

1. Go to **Services** > **CloudFront.
2. Choose your CC CloudFront distribution, and then click on the **Origins** tab.
3. Select the origin for your load balancer, and click **Edit**.
4. Change Origin Protocol Policy to **Match Viewer**, and click **Yes, Edit**.
5. Click on the **Behaviors** tab, select your S3 behavior, and click **Edit**.
6. Change the Viewer Protocol Policy to **HTTP and HTTPS**, and click **Yes, Edit**.
7. Click on the **Behaviors** tab, select your load balancer behavior, and click **Edit**.
8. Change the Viewer Protocol Policy to **HTTP and HTTPS**, and click **Yes, Edit**.

It may take a few minutes for these CloudFront changes to propagate.

## Application Config

1. Connect to your Ansible control server and navigate to the `ContentController-PublicDeploy` folder.
2. Edit `group_vars/env.yml` and change `allow_80: false` to `allow_80: true`.  If it is already true, then you're good to go (no need to re-deploy).
3. Deploy Content Controller (see the [Installation Guide](/self-hosting/quick-start)).
