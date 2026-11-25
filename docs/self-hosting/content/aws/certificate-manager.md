---
title: "Certificate Manager"
type: docs
menu:
    main:
        name: 3. Certificate Manager
        identifier: certificate_manager
        parent: aws
        weight: 4
---

# Certificate Manager

Certificate Manager will keep track of your SSL certificates and make them available to AWS services (such as the load balancer).  You may either request a free certificate from AWS or import an existing certificate.

Go to **Services** -> **Certificate Manager**

## Request a certificate

1. Click on **Request a certificate**.
2. Under domain name, enter your subdomain for Content Controller.  If you are dedicating an entire domain to your CC install (such as `example.com`), make sure you enter both `www.example.com` and `example.com` OR `*.example.com` and `example.com`.  Click **Next**. <br><br>{{< img src="/self-hosting/aws/img/cm-domain-name.png" >}}<br><br>
3. Choose **DNS validation** and click **Review**, then click **Confirm and request**.
4. Expand the section(s) with your domain name and click **Create record in Route 53**, then in the dialog that appears, click **Create**. <br><br>{{< img src="/self-hosting/aws/img/cm-validation.png" >}}<br><br>
5. Click **Continue**.
6. It may take a few minutes for your certificate to be validated.

## Resources

[What Is AWS Certificate Manager?](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)
