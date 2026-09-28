---
title: "Content Proxy"
type: docs
menu:
    main:
        name: Content Proxy
        identifier: content_proxy
        parent: cc_content
        weight: 5
---

# Content Proxy

Some self-hosted customers need to authenticate their content that is hosted in S3, but can't use CloudFront. 
For those customers, we offer a CloudFront replacement that we call Content Proxy.

It acts like a CDN, but it just lives on the CC app server(s). Content Controller has Apache configured to forward 
content requests to the Content Proxy service, which is hosted locally. The proxy can authorize learners using cookies
or Content Vault — see [Content Authorization](/integration/cc_content/content-authorization/).

Content Proxy needs very little to be configured:

```
content_proxy_enabled: true
```

This will automatically install and deploy Content Proxy configured to serve files using your content root, file storage location, and Content Authorization method.

Once deployed, you can verify that the Content Proxy is running as expected by SSHing onto the app server and checking 
the output of `sudo systemctl status content-proxy`.
