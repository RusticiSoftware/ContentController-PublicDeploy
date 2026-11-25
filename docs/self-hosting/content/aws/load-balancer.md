---
title: "Load Balancer and Target Group"
type: docs
menu:
    main:
        name: 8. Load Balancer and Target Group
        identifier: load_balancer
        parent: aws
        weight: 9
---

# Load Balancer and Target Group

We'll need to create a load balancer to distribute traffic to your application server(s).  If you use CloudFront and S3, you should use a load balancer - even if you only use 1 application server.  We'll also create a target group, which tells the load balancer which servers to distribute traffic to.

Go to **Services** -> **EC2**.

1. Click **Load Balancers** on the left sidebar, and click **Create Load Balancer**.
2. Click **Create** under **Application Load Balancer**.
3. Under **Basic configuration** enter the following values:
    * Load balancer name: `cc-load-balancer`
    * Scheme: **Internet-facing**
    * IP address type: **IPv4** or **Dualstack** (if you want to support IPv6)
3. Under **Network Mappings** enter the following values:
    * VPC: `Rustici CC VPC`
    * Mappings: `us-east-1a` with the Subnet `CC Public 1` and `us-east-1b` with Subnet `CC Public 2`
4. For the **Security groups** select the `CC Load Balancer`.
5. For **Listeners and routing** configure the following listeners:
    * **HTTPS:443**
    * **HTTP:80**
6. For these listeners, you will need to select **Create target group** located under **Default action** and configure the following values:.
    * Target type: **Instances**
    * Target group name: `cc-prod-target-group`
    * Protocol and Port: **HTTP:80**
    * VPC: `Rustici CC VPC`
    * Protocol version: **HTTP1**
    8 Health check path: `/healthcheck`
7. Under **Secure listener settings** you will need to configure the following:
    * Choose a **Security policy**. See these [AWS SSL Security Policies](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html) docs for more details about which one to pick, or take a look at the [FAQ Security docs](/self-hosting/faq/security).
    * For **Default SSL/TLS certificate**, choose **From ACM** and select the certificate that you [requested or uploaded earlier](/self-hosting/aws/certificate-manager).
16. Click **Create Load Balancer**.

**Note:** You may want to enable deletion protection and access logs for your load balancer.  For more information see [Access Logs for Elastic Load Balancers](https://aws.amazon.com/blogs/aws/access-logs-for-elastic-load-balancers/).
