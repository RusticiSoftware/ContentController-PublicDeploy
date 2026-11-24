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
content requests to the Content Proxy service, which is hosted locally. The proxy can either rely on cookies or it can 
use Content-Vault.

The Content Proxy is built independently of Content Controller. Reach out to Team Delight for assistance getting this 
build.

There a few steps involved in configuring the Content Proxy. Firstly, you'll need to set up some Ansible variables in 
your playbooks:

```
# S3 settings
S3FileStorageEnabled: true
S3AWSAccountID: 1234567890
S3FileStorageIAMUsername: "s3-user-name"
S3FileStorageAwsId: "IAM access key ID here"
S3FileStorageAwsKey: "IAM secret access key here"
S3FileStorageBucket: "content-controller-bucket-name"
S3FileStorageRegion: "us-east-1"

# "CloudFront" settings (but not really)
use_cloudfront: true
cloudfront_access_key_id: ""
cloudfront_origin_access_identity: ""

# Content Proxy
content_proxy_enabled: true
enable_contentvault: false
```

Once deployed, you can verify that the Content Proxy is running as expected by SSHing onto the app server and checking 
the output of `sudo systemctl status content-proxy`.
