---
title: "Content Vault"
type: docs
menu:
    main:
        name: Content Vault
        identifier: content_vault
        parent: cc_content
        weight: 5
---

# Content Vault

Recently, browsers have been getting stricter about the cookies that websites can set for users. Since CC is generally 
loaded inside of an iframe, browsers think that we are trying to monitor users with our cookies, so our cookies get 
blocked. Previously, we were using these cookies to authenticate access to our content, but once the cookies started to
be blocked, we had to come up with an alternate solution. "Content Vault" is the term we use to refer to this layer of 
cookieless content authentication.

When a user launches the course, we will generate a unique URL path prefix with which they can access that course. This 
unique URL is only valid for a few hours (this time limit is configurable). In addition to that path, we can also record
the IP address and/or browser User-Agent when the content is launched (this validation is also configurable). Then, on 
subsequent launches using the generated path, we will check that the requester's IP address and/or User-Agent is the 
same as the one that was used to launch the course.

Here is an example content-vaulted path:

```
https://my-example.contentcontroller.com/vault/87a24c13-dc0b-450a-940c-f3efb2133ec7/courses/7e480c43-45fd-48a0-8aba-d77a965ab052/0/shared/launchpage.html
```

Everything after `/courses/` points to the actual file in S3, while the `/vault/87a24c13-dc0b-450a-940c-f3efb2133ec7` is
the unique URL path prefix. This GUID is randomly generated on launch, and a new GUID is for every launch after that. We
store this guid in a database table named `content_vault`.

This table records the User-Agent and IP address from the launch request and saves them to this table, alongside the 
access GUID. For every request that includes this `/vault/` prefix, we verify that the details of the request for 
content match the details of the original launch request.

We perform this verification using CloudFront and Lambda@Edge, which are two AWS technologies. CloudFront receives the 
request, sees the `/vault/` prefix, and then calls our Lambda@Edge function. This function analyzes the incoming content
request and asks Content Controller to verify that the details look right.

Content Controller checks the provided details, compares them to the values in `content_vault`. If everything matches 
up, Content Controller returns a successful response. To avoid overloading CC with these requests, successful 
verification results are cached for a short time. That way, the next time Lambda tries to verify a request, it just 
reads the cached value. This cache only lasts as long as the access GUID remains valid.